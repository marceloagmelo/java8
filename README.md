# Docker image for SpringBoot Microservice

This image is based on CentOS 7 Image, contains the OpenJDK 1.8 and Prometheus. This image was designed initially for Spring Boot but it can be used for any java daemon process.
The image exposes the port 8080 and the java process is executed by the "java" user.
All the componentes (Java process and Prometheus Agent) write logs entries to the standard output and standard error.

### How to download the image

docker pull marceloagmelo/java8:latest

### How to use image

The image contains a control.sh script, this script has several operations.

#### Help

docker run --rm -ti marceloagmelo/java8:latest help
```
========================================
USAGE: /control.sh COMMAND [args]
  Command list:
    - info      : execute info scripts
    - shell     : execute shell scripts
    - start     : execute start scripts
    - status    : execute status scripts
    - test      : execute test scripts
    - threaddump  : Thread dump is created in system out
    - heapdump    : Heap dump file is created in /tmp/jvm.hprof
========================================
```

#### Info

The info operation shows only image's metadafa information.

docker run --rm -ti marceloagmelo/java8:latest info
```
com.produban.components=java8, prometheus
com.produban.description=Java 8 runtime for Spring boot microservices
com.produban.imageowner=Products and Services
```

#### Status

The status operation shows information about the running proccess

docker run --rm -ti marceloagmelo/java8:latest status
```
top - 07:56:33 up 10 days,  5:29,  0 users,  load average: 0.43, 0.42, 0.41
Tasks:   2 total,   1 running,   1 sleeping,   0 stopped,   0 zombie
%Cpu(s): 25.7 us,  3.3 sy,  0.0 ni, 70.8 id,  0.1 wa,  0.0 hi,  0.1 si,  0.0 st
KiB Mem :  8055068 total,   195620 free,  5451296 used,  2408152 buff/cache
KiB Swap:  8265724 total,  4965660 free,  3300064 used.  1416092 avail Mem
  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
    1 java      20   0   11608   1364   1160 S   0.0  0.0   0:00.02 control.sh
    8 java      20   0   24080   1368   1088 R   0.0  0.0   0:00.00 top
```

#### Start

The start operation initialize the java process, by default the start script looks for JAR files inside /opt/app directory, the first JAR file found will be used as the application, if no JAR files are found the start operation will use the default Spring Boot application /application.jar, this application can be used for testing.
```
docker run -d -p 0.0.0.0:8080:8080 marceloagmelo/java8:latest start
```

In this example the default application is executed.

> NOTE: In the Environment Variables section we will see all the environment variables available. In order to change the process behaviour we have to configure some environment variable when the container/pod is started.

#### shell

This operation starts the /bin/bash shell
```
docker run --rm -ti marceloagmelo/java8:latest shell
```

#### Environment Variables

JAVA_OPTS_EXT

Use this variable to add new parameters o properties to the java runtime process.
```
docker run -e JAVA_OPTS_EXT="-Dapp.title=Test -Xms256M" -d -p 8080:8080 marceloagmelo/java8:latest start
```

In this example we configure the initial heap size to 256MB also we add a java property called "app.title".

APP_HOME=/opt/app

This is where we have to deploy our SpringBoot application and dependant files such as X509v3 certificates, private keys etc.

JAR_PATH

By default the start script get the first JAR file found in /opt/app, with this variable we can specify the application JAR file.

ARTIFACT_URL

This docker image is able to download an artifact from any https/http web server, the articaft can be jar/zip/tgz.

It is possible to package differents kind of files using tgz/zip artifact, at least one of them must be a jar file, tgz/zip
packaging is useful to package certificates, configuration files, java security policies etc.
The package tgz/zip is deplyecin the /opt/app directory.

PBD_URL

This docker image is able to download an pbd file from any https/http web server, the articaft can be zip/tgz.

```
docker run -e JAR_PATH="/opt/app/vivaFluminense.jar" -d -p 8080:8080 marceloagmelo/java8:latest start
```

```
docker run -it -p 8080:8080 -m 512m marceloagmelo/java8:latest
```

APP_NAME

Using this variable we can configure agent/process name.
> NOTE: We recommend to inject OpenShift's metadada inside the container and use the application name, using this information will be very easy to group or indentify the container in the Prometheus console.

PROJECT_NAME

It is just a label used for grouping prometheus agents, in OpenShift this label could be the project name.

## How to create new images from Java imagen

In this example we will create new SpringBoot application using marceloagmelo/java8:latest as the base image.

Dockerfile

```
FROM marceloagmelo/java8:latest
ADD configuration.jar /opt/app
ADD mykey.key /opt/app
ADD mycert.crt /opt/app
```

```
docker build .
```

## Time Zone
By default this image uses the time zone "Ameruca/Sao_Paulo", if you want to change the default time zone, you should specify the environment variable TZ.
