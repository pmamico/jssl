![shellcheck](https://github.com/pmamico/java-ssl-tools/actions/workflows/shellcheck.yml/badge.svg)  

# `jssl` 🔐
Fix Java SSL issues in seconds – no more `PKIX path building failed`.  
`jssl` lets you **ping** and **install** SSL certs directly in your Java keystore – _in one line_.

✅ No more manual `keytool` troubles   
✅ Works with any Java (8–24)  
✅ Docker & CI friendly

![demo](https://raw.githubusercontent.com/pmamico/java-ssl-tools/main/.doc/jssl.gif)

## 🚀 install
any terminal:
```
curl -sL https://raw.githubusercontent.com/pmamico/java-ssl-tools/main/install.sh | bash
```
on Windows, use `Git Bash` as system administrator.  
  
🍺  via homebrew:
```
brew install pmamico/java/jssl
```


## Manual
```
jssl v2.0
Install trusted certificate and check SSL handshake against java keystore.

Usage: jssl <operation> [host|file] ...
	[host]: without https:// and port, eg. google.com
	<operation>: ping, install, uninstall, list, file
	-p, --port: port (default: '443')
	-a, --alias: alias in keystore (default: '<host>')
	-h, --help: Prints help
	-v, --version: Prints version
```

## 🐳 Using jssl in docker

Here’s how you can use jssl inside a Dockerfile to import a certificate into the Java keystore during image build:

### 📦 Dockerfile
```dockerfile
FROM eclipse-temurin:17-jdk

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl openssl && \
    rm -rf /var/lib/apt/lists/*

# Install jssl
RUN curl -sL https://raw.githubusercontent.com/pmamico/java-ssl-tools/main/install.sh | bash

# Set JAVA_HOME if not already set by base image
ENV JAVA_HOME=/opt/java/openjdk

#  Add your cert at build time
RUN jssl example.com install

# Your application setup
COPY ./app.jar /app.jar
CMD ["java", "-jar", "/app.jar"]
```

### 📦 Docker Compose example (runtime install) 
If you have `jssl` in your base image, but you want to install the certificate at runtime, you can use the following Docker Compose setup:
```yaml
services:
  app:
    build: .
    environment:
      - JAVA_HOME=/opt/java/openjdk
    entrypoint: >
      sh -c "jssl example.xom install &&
             java -jar /app.jar"
```

## Why not just use `keytool`?
Java has a built-in `keytool` to handle certificates on the java keystore.  
However it has a few drawbacks:
### In `keytool` there is no way to check that the certifiacate works 
With `jssl` just type
```
$ jssl <URL> ping
```
### With `keytool` you have to type a lot!
 Especially annoying if you are in flow.  
First you need to get the certificate somehow,   
then to import it with keytool, thinking about alias names and the default password.  
Eg.:
```
$ echo | openssl s_client -connect "<URL>:443"  2>/dev/null | openssl x509 > certificate.pem
$ /opt/homebrew/opt/openjdk@11/bin/keytool -importcert -cacerts -noprompt -alias <myalias> -file certificate.pem -keypass changeit -storepass changeit
```
is equivalent to 
```
$ jssl <URL> install
```

## Compatibility

![OpenJDK](https://github.com/pmamico/jssl/actions/workflows/openjdk.yml/badge.svg)
![GraalVM](https://github.com/pmamico/jssl/actions/workflows/graalvm.yml/badge.svg)

## Requirements

* `JAVA_HOME` environment
* `openssl`
