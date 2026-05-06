# jssl - Java SSL certificate tool

![shellcheck](https://github.com/pmamico/java-ssl-tools/actions/workflows/shellcheck.yml/badge.svg)

## NAME
**jssl** \- Resolve Java SSL issues like `PKIX path building failed` instantly.  
Diagnose, retrieve, and install certificates into Java keystores with ease.

## SYNOPSIS
```bash
jssl <operation> [host|file] [options]
```

## DESCRIPTION
**jssl** is a command-line tool to interact with Java keystores and SSL endpoints. It allows users to diagnose SSL handshake issues, retrieve remote certificates, and install them into local Java keystores. It also parses Maven logs for missing certificate errors and handles them automatically.

## OPERATIONS

**ping**
:   Check the SSL handshake against a host without modifying the keystore.

**install**
:   Connect to a host, retrieve its SSL certificate, and install it into the Java keystore. If the target alias already exists, it is replaced.

**file**
:   Process a file containing a list of hosts (one per line) to install certificates.

**list**
:   List trusted certificates installed with jssl in a table, including creation and expiration dates. Certificates expiring within 30 days are highlighted in yellow; expired certificates are highlighted in red.

**uninstall**
:   Remove a certificate from the Java keystore, identified by its hostname or alias.

**doctor**
:   Read Maven build logs (from stdin) and automatically detect and install missing certificates based on connection errors.

## OPTIONS
* `-p, --port`: SSL port to connect to. Defaults to `443`.
* `-a, --alias`: Alias to use in the Java keystore. Defaults to `jssl_<host>`.
* `-v, --verbose`: Print debug output.
* `--version`: Print jssl and Java version information.
* `-h, --help`: Print help.

## KEYSTORE OVERRIDES
By default, **jssl** uses the active Java truststore. For tests or custom workflows, the target keystore can be overridden with environment variables:

```bash
JSSL_KEYSTORE_PATH=/path/to/cacerts JSSL_STOREPASS=changeit jssl list
```

`JSSL_STOREPASS` defaults to `changeit` when unset.

## INSTALLATION
### Via script
```bash
curl -sL https://raw.githubusercontent.com/pmamico/java-ssl-tools/main/install.sh | bash
```
Run in any terminal. On Windows, use **Git Bash** with administrative privileges.

### Via Homebrew
```bash
brew install pmamico/keg/jssl
```

## DEMO

![demo](https://raw.githubusercontent.com/pmamico/java-ssl-tools/main/.doc/jssl.gif)

## COMPATIBILITY
![OpenJDK](https://github.com/pmamico/jssl/actions/workflows/openjdk.yml/badge.svg)
![GraalVM](https://github.com/pmamico/jssl/actions/workflows/graalvm.yml/badge.svg)

## REQUIREMENTS
* `JAVA_HOME` environment variable must be set
* `openssl` must be available on the system

## SEE ALSO
keytool(1), openssl(1), mvn(1)
