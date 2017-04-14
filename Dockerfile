FROM marceloagmelo/centos7:latest

MAINTAINER Marcelo Melo <mmelo@produban.com.br>

ADD application.jar /

ENV JAVA_VERSION 1.8.0
ENV JAVA_HOME=/usr/lib/jvm/java-openjdk
ENV GID 20000
ENV UID 20000

ENV PROMETHEUS_HOME $IMAGE_SCRIPTS_HOME/prometheus

COPY Dockerfile $IMAGE_SCRIPTS_HOME/Dockerfile

RUN yum clean all && yum -y install \
    java-$JAVA_VERSION-openjdk-devel && \
    yum clean all && \
    rm -Rf /tmp/* && rm -Rf /var/tmp/*

RUN groupadd --gid $GID java && useradd --uid $UID -m -g java java

ADD scripts $IMAGE_SCRIPTS_HOME
ADD prometheus/* ${PROMETHEUS_HOME}/

RUN chown -R java:java $APP_HOME && \
    chown -R java:java $IMAGE_SCRIPTS_HOME && \
    chown java:java /application.jar

EXPOSE 8080 1055

# To modify a hosts
RUN cp /etc/hosts /tmp/hosts && \
    mkdir -p -- /lib-override && cp /lib64/libnss_files.so.2 /lib-override && \
    sed -i 's:/etc/hosts:/tmp/hosts:g' /lib-override/libnss_files.so.2 && \
    chmod 755 /tmp/hosts && \
    chown java:java /tmp/hosts
ENV LD_LIBRARY_PATH /lib-override

#######################################################################
##### We have to expose image metada as label and ENV
#######################################################################
LABEL com.produban.imageowner="Products and Services" \
      com.produban.description="Java 8 runtime for Spring boot microservices" \
      com.produban.components="java8" \
      com.prpoduban.image="marceloagmelo/java8:1.0.0"
ENV com.produban.imageowner="Products and Services" \
    com.produban.description="Java 8 runtime for Spring boot microservices" \
    com.produban.components="java8" \
    com.prpoduban.image="marceloagmelo/java8:1.0.0"

USER 20000
WORKDIR $IMAGE_SCRIPTS_HOME

ENTRYPOINT [ "./control.sh" ]
CMD [ "start" ]