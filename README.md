![shellcheck](https://github.com/pmamico/java-ssl-tools/actions/workflows/shellcheck.yml/badge.svg)  

# `jssl` 🔐
Fix Java SSL issues in seconds – no more `PKIX path building failed`.  
`jssl` lets you **ping** and **install** SSL certs directly in your Java keystore.

![demo](.doc/jssl.gif)

or you can pipe a failing `mvn` command with `jssl doctor` 

![demo](.doc/doctor.gif)

## 🚀 Install
any terminal:
```
curl -sL https://raw.githubusercontent.com/pmamico/java-ssl-tools/main/install.sh | bash
```
on Windows, use `Git Bash` as system administrator.  
  
🍺  or via homebrew:
```
brew install pmamico/java/jssl
```

## Manual
```
jssl <operation> [host|file] [options]
```
**Operations**  
- **ping**  
Check the SSL handshake against a host without modifying the keystore.  
- **install**  
Connect to a host, retrieve its SSL certificate, and install it into the Java keystore.  
- **file**  
Process a file containing a list of hosts (one per line) to ping or install certificates.  
- **list**  
List trusted certificates currently present in the Java keystore installed with jssl.  
- **uninstall**  
Remove a certificate from the Java keystore, identified by its alias.  
- **doctor**  
Read Maven or Gradle build logs (from stdin) and automatically detect and install missing certificates based on connection errors.

## Compatibility

![OpenJDK](https://github.com/pmamico/jssl/actions/workflows/openjdk.yml/badge.svg)
![GraalVM](https://github.com/pmamico/jssl/actions/workflows/graalvm.yml/badge.svg)

## Requirements

* `JAVA_HOME` environment
* `openssl`
