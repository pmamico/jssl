# jssl - Java SSL certificate tool

![shellcheck](https://github.com/pmamico/java-ssl-tools/actions/workflows/shellcheck.yml/badge.svg)

## NAME
**jssl** \- Resolve Java SSL issues instantly. No more `PKIX path building failed`.  
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
:   Connect to a host, retrieve its SSL certificate, and install it into the Java keystore.

**file**
:   Process a file containing a list of hosts (one per line) to ping or install certificates.

**list**
:   List trusted certificates currently present in the Java keystore installed with jssl.

**uninstall**
:   Remove a certificate from the Java keystore, identified by its alias.

**doctor**
:   Read Maven build logs (from stdin) and automatically detect and install missing certificates based on connection errors.

## INSTALLATION
### Via script
```bash
curl -sL https://raw.githubusercontent.com/pmamico/java-ssl-tools/main/install.sh | bash
```
Run in any terminal. On Windows, use **Git Bash** with administrative privileges.

### Via Homebrew
```bash
brew install pmamico/java/jssl
```

## DEMO
**Standard usage:**  
![demo](https://raw.githubusercontent.com/pmamico/java-ssl-tools/main/.doc/jssl.gif)  

**Automatic fix with `doctor`:**  
![doctor](https://raw.githubusercontent.com/pmamico/java-ssl-tools/main/.doc/doctor.gif)  

## COMPATIBILITY
![OpenJDK](https://github.com/pmamico/jssl/actions/workflows/openjdk.yml/badge.svg)
![GraalVM](https://github.com/pmamico/jssl/actions/workflows/graalvm.yml/badge.svg)

## REQUIREMENTS
* `JAVA_HOME` environment variable must be set
* `openssl` must be available on the system

## SEE ALSO
keytool(1), openssl(1), mvn(1)

