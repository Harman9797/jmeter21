# inspired by https://github.com/hauptmedia/docker-jmeter  and
# https://github.com/hhcordero/docker-jmeter-server/blob/master/Dockerfile
FROM alpine:3.18.4

MAINTAINER Just van den Broecke<just@justobjects.nl>

ARG JMETER_VERSION="5.6.2"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_CUSTOM_PLUGINS_FOLDER /plugins
ENV     JMETER_BIN      ${JMETER_HOME}/bin
ENV     JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz


# Install extra packages
# Set TimeZone, See: https://github.com/gliderlabs/docker-alpine/issues/136#issuecomment-612751142
ARG TZ="Europe/Amsterdam"
ENV TZ ${TZ}
RUN    apk update 
RUN  apk upgrade 
RUN apk add ca-certificates 
# RUN update-ca-certificates 
RUN     apk add --update openjdk21-jre --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing tzdata curl unzip bash \
        && apk add --no-cache nss \
        && rm -rf /var/cache/apk/* \
        && mkdir -p /tmp/dependencies  \
        && curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
        && mkdir -p /opt  \
        && tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
        && rm -rf /tmp/dependencies

# TODO: plugins (later)
# && unzip -oq "/tmp/dependencies/JMeterPlugins-*.zip" -d $JMETER_HOME

# Set global PATH such that "jmeter" command is found
ENV PATH $PATH:$JMETER_BIN

# Entrypoint has same signature as "jmeter" command
COPY entrypoint.sh /

WORKDIR ${JMETER_HOME}

ENTRYPOINT ["/entrypoint.sh"]
