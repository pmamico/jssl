#!/usr/bin/env bats

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

@test "jssl" {
    run ./src/jssl
    [ "$status" -eq 1 ]
    assert_output --partial "Missing required arguments"
}

@test "jssl install example.com" {
    ./src/jssl uninstall example.com || true
    run ./src/jssl install example.com
    assert_success
    assert_output --partial "Certificate installed"
}

@test "jssl ping example.com" {
    run ./src/jssl ping example.com
    assert_success
    assert_output --partial "SSL handshake successful"
}

@test "jssl list (example.com)" {
    run ./src/jssl list
    assert_success
    assert_output --partial "Entry type: trustedCertEntry"
}

@test "jssl uninstall example.com" {
    run ./src/jssl uninstall example.com
    assert_success
    assert_output --partial "Certificate removed"
}

@test "jssl list (empty)" {
    run ./src/jssl list
    assert_success
    refute_output --partial "example.com"
}

@test "jssl file missing_file" {
    run ./src/jssl file list.txt
    assert_failure
    assert_output --partial "File not found"
}

@test "jssl file hosts.txt" {
    echo -e "example.com\nhowsmyssl.com" > hosts.txt
    run ./src/jssl file hosts.txt
    rm hosts.txt
    assert_success
    assert_output --partial "SSL handshake successful with howsmyssl.com:443"
}

@test "warns when JAVA_HOME is not set" {
    unset JAVA_HOME
    run ./src/jssl --help
    assert_output --partial "JAVA_HOME is not set"
}

@test "detects version mismatch between javac and JAVA_HOME/bin/javac" {
    export JAVA_HOME="/some/fake/path"
    run ./src/jssl --help
    assert_output --partial "differs from JAVA_HOME/bin/javac version"
}