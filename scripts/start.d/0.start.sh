#!/bin/bash

if [ -z "$JAR_PATH" ]
then
   JAR_PATH=`find $APP_HOME -name "*.jar" -o -name "*.war" | head -1`
fi

if [ -z "$JAR_PATH" ]
then
   JAR_PATH="/application.jar"
fi

export JAVA_PROMETHEUS="-javaagent:$PROMETHEUS_HOME/jmx_prometheus_javaagent.jar=1055:$PROMETHEUS_HOME/java.yml"

export JAVA_OPTS_EXT="$JAVA_PROMETHEUS $JAVA_OPTS_EXT"

#### if you want to add extra JVM options,, you have to use the env variable JAVA_EXT_OPTS

###echo java $JAVA_PROMETHEUS $JAVA_OPTS_EXT -jar "$JAR_PATH" $JAVA_PARAMETERS
echo "========================================="
echo "Starting application"
echo "========================================="
exec java $JAVA_OPTS_EXT -jar "$JAR_PATH" $JAVA_PARAMETERS