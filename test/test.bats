#!/usr/bin/env bats

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

setup() {
    export JSSL_STOREPASS="changeit"
    export JSSL_KEYSTORE_PATH="$BATS_TEST_TMPDIR/cacerts"

    if [[ -n "$JAVA_HOME" && -f "$JAVA_HOME/jre/lib/security/cacerts" ]]; then
        cp "$JAVA_HOME/jre/lib/security/cacerts" "$JSSL_KEYSTORE_PATH"
    elif [[ -n "$JAVA_HOME" && -f "$JAVA_HOME/lib/security/cacerts" ]]; then
        cp "$JAVA_HOME/lib/security/cacerts" "$JSSL_KEYSTORE_PATH"
    else
        unset JSSL_KEYSTORE_PATH
    fi

    if [[ -n "${JSSL_KEYSTORE_PATH:-}" ]]; then
        while IFS= read -r line; do
            alias_name="${line%%,*}"
            "$JAVA_HOME/bin/keytool" -delete -noprompt \
                -keystore "$JSSL_KEYSTORE_PATH" \
                -storepass "$JSSL_STOREPASS" \
                -alias "$alias_name" >/dev/null 2>&1 || true
        done < <("$JAVA_HOME/bin/keytool" -list -keystore "$JSSL_KEYSTORE_PATH" -storepass "$JSSL_STOREPASS" 2>/dev/null | grep '^jssl_')
    fi
}

@test "jssl" {
    run ./src/jssl
    [ "$status" -eq 1 ]
    assert_output --partial "Missing required arguments"
}

@test "jssl install, list and uninstall example.com in isolated keystore" {
    run ./src/jssl install example.com
    assert_success
    assert_output --partial "Certificate installed"

    run ./src/jssl install example.com
    assert_success
    assert_output --partial "Certificate installed"

    run ./src/jssl list
    assert_success
    assert_output --partial "Alias"
    assert_output --partial "Expires"
    assert_output --partial "jssl_example.com"
    assert_output --partial "trustedCertEntry"

    run "$JAVA_HOME/bin/keytool" -list -keystore "$JSSL_KEYSTORE_PATH" -storepass "$JSSL_STOREPASS"
    assert_success
    assert_output --partial "jssl_example.com"

    run ./src/jssl uninstall example.com
    assert_success
    assert_output --partial "Certificate removed"

    run ./src/jssl list
    assert_output --partial "No jssl certificates installed."
}

@test "jssl ping example.com" {
    run ./src/jssl ping example.com
    assert_success
    assert_output --partial "SSL handshake successful"
}

@test "jssl ping supports explicit port" {
    run ./src/jssl ping example.com --port 443
    assert_success
    assert_output --partial "SSL handshake successful with example.com:443"
}

@test "jssl get prints pem certificate" {
    run ./src/jssl get example.com
    assert_success
    assert_output --partial "-----BEGIN CERTIFICATE-----"
    assert_output --partial "-----END CERTIFICATE-----"
}

@test "jssl supports custom jssl alias" {
    run ./src/jssl install example.com --alias jssl_custom_example
    assert_success
    assert_output --partial "Certificate installed"

    run ./src/jssl list
    assert_success
    assert_output --partial "jssl_custom_example"

    run ./src/jssl uninstall example.com --alias jssl_custom_example
    assert_success
    assert_output --partial "Certificate removed"

    run ./src/jssl list
    refute_output --partial "jssl_custom_example"
}

@test "jssl rejects unknown operation" {
    run ./src/jssl unknown example.com
    assert_failure
    assert_output --partial "Unknown operation"
}

@test "jssl file missing_file" {
    run ./src/jssl file list.txt
    assert_failure
    assert_output --partial "File not found"
}

@test "jssl file hosts.txt" {
    hosts_file="$BATS_TEST_TMPDIR/hosts.txt"
    printf "  example.com  \n\n  howsmyssl.com  \n" > "$hosts_file"
    run ./src/jssl file "$hosts_file"
    assert_success
    assert_output --partial "SSL handshake successful with howsmyssl.com:443"
}

@test "success | jssl doctor" {
    run bash -c "echo 'SUCCESS' | ./src/jssl doctor"
    assert_success
    assert_output --partial "No PKIX issues found"
}

@test "failing command | jssl doctor" {
    run bash -c "echo '(https://secured.com/repository/internal/): PKIX path building failed' | ./src/jssl doctor"
    assert_success
    assert_output --partial "jssl install secured.com"
}

@test "help is printed without JAVA_HOME diagnostics" {
    unset JAVA_HOME
    unset JSSL_KEYSTORE_PATH
    run ./src/jssl --help
    assert_success
    assert_output --partial "Usage: jssl <operation> [host|file] [options]"
    assert_output --partial "-v, --verbose: print debug output"
    assert_output --partial "mvn package | jssl doctor"
    refute_output --partial "JAVA_HOME is not set"
}

@test "version prints java information" {
    run ./src/jssl --version
    assert_success
    assert_output --partial "jssl v2.3"
}
