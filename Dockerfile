# Copyright (c) 2016. TIBCO Software Inc.
# This file is subject to the license terms contained
# in the license file that is distributed with this file.
# version: 6.3.0-v1.0.4



#FROM tomcat:8.0-jre8
FROM tomcat:8.5.54-jdk8-openjdk
ARG JRS_VERSION=7.5.0

ENV BUILDOMATIC_MODE=' '
#ENV BUILDOMATIC_ENV=dev
#ENV env.BUILDOMATIC_ENV=dev
# Copy jasperreports-server-<ver> zip file from resources dir.
# Build will fail if file not present.


COPY resources/jasperreports-server*zip /tmp/jasperserver.zip


RUN apt-get update && apt-get install -y postgresql-client unzip xmlstarlet && \
#    apt-get install -y git && \  
#    apt-get install -y ant && \
    rm -rf /var/lib/apt/lists/* && \
    unzip /tmp/jasperserver.zip -d /usr/src/ && \
    mv /usr/src/jasperreports-server-* /usr/src/jasperreports-server && \
    mkdir -p /usr/local/share/jasperreports-pro/license && \
    rm -rf /tmp/* && apt-get clean 

# This is in accordance to : https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04
#RUN apt-get update && \
#	apt-get install -y openjdk-11-jdk && \
#	apt-get install -y ant && \
#	apt-get clean && \
#	rm -rf /var/lib/apt/lists/* && \
#	rm -rf /var/cache/oracle-jdk8-installer;
	
# Fix certificate issues, found as of 
# https://bugs.launchpad.net/ubuntu/+source/ca-certificates-java/+bug/983302
#RUN apt-get update && \
#	apt-get install -y ca-certificates-java && \
#	apt-get clean && \
#	update-ca-certificates -f && \
#	rm -rf /var/lib/apt/lists/* && \
#	rm -rf /var/cache/oracle-jdk8-installer;

# Setup JAVA_HOME, this is useful for docker commandline
#ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/
#RUN export JAVA_HOME
#RUN unset JAVA_TOOL_OPTIONS
#ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
#RUN export JAVA_HOME	
COPY resources/WEB-INF/lib/*.jar /usr/src/jasperreports-server/WEB-INF/lib/
COPY resources/WEB-INF/applicationContext-externalAuth-oAuth.xml /usr/src/jasperreports-server/WEB-INF/
COPY resources/WEB-INF/jsp/modules/commonJSTLScripts.jsp	 /usr/src/jasperreports-server/WEB-INF/jsp/modules/
COPY resources/jasperserver.license /usr/local/share/jasperreports-pro/license/jasperserver.license 
COPY resources/keystore.init.properties /usr/src/jasperreports-server/buildomatic/
copy resources/.jrsks /root/
copy resources/.jrsksp /root/
# Extract phantomjs, move to /usr/local/share/phantomjs, link to /usr/local/bin.
# Comment out if phantomjs not required.
RUN wget \
    "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2" \
    -O /tmp/phantomjs.tar.bz2 --no-verbose && \
    tar -xjf /tmp/phantomjs.tar.bz2 -C /tmp && \
    rm -f /tmp/phantomjs.tar.bz2 && \
    mv /tmp/phantomjs*linux-x86_64 /usr/local/share/phantomjs && \
    ln -sf /usr/local/share/phantomjs/bin/phantomjs /usr/local/bin && \
    rm -rf /tmp/*
# In case you wish to download from a different location you can manually
# download the archive and copy from resources/ at build time. Note that you
# also # need to comment out the preceding RUN command
#COPY resources/phantomjs*bz2 /tmp/phantomjs.tar.bz2
#RUN tar -xjf /tmp/phantomjs.tar.bz2 -C /tmp && \
#    rm -f /tmp/phantomjs.tar.bz2 && \
#    mv /tmp/phantomjs*linux-x86_64 /usr/local/share/phantomjs && \
#    ln -sf /usr/local/share/phantomjs/bin/phantomjs /usr/local/bin && \
#    rm -rf /tmp/*

# Set default environment options.
ENV CATALINA_OPTS="${JAVA_OPTIONS:--Xmx2g -XX:+UseParNewGC \
    -XX:+UseConcMarkSweepGC} \
    -Djs.license.directory=${JRS_LICENSE:-/usr/local/share/jasperreports-pro/license}"

# Configure tomcat for SSL (optional). Uncomment ENV and RUN to enable generation of
# self-signed certificate and to set up JasperReports Server to use HTTPS only.
#
#ENV DN_HOSTNAME=${DN_HOSTNAME:-localhost.localdomain} \
#    KS_PASSWORD=${KS_PASSWORD:-changeit} \
#    JRS_HTTPS_ONLY=${JRS_HTTPS_ONLY:-true} \
#    HTTPS_PORT=${HTTPS_PORT:-8443}
#
#RUN keytool -genkey -alias self_signed -dname "CN=${DN_HOSTNAME}" \
#        -keyalg RSA -storepass "${KS_PASSWORD}" \
#        -keypass "${KS_PASSWORD}" \
#        -keystore /root/.keystore && \
#    xmlstarlet ed --inplace --subnode "/Server/Service" --type elem \
#        -n Connector -v "" --var connector-ssl '$prev' \
#    --insert '$connector-ssl' --type attr -n port -v "${HTTPS_PORT:-8443}" \
#    --insert '$connector-ssl' --type attr -n protocol -v \
#        "org.apache.coyote.http11.Http11NioProtocol" \
#    --insert '$connector-ssl' --type attr -n maxThreads -v "150" \
#    --insert '$connector-ssl' --type attr -n SSLEnabled -v "true" \
#    --insert '$connector-ssl' --type attr -n scheme -v "https" \
#    --insert '$connector-ssl' --type attr -n secure -v "true" \
#    --insert '$connector-ssl' --type attr -n clientAuth -v "false" \
#    --insert '$connector-ssl' --type attr -n sslProtocol -v "TLS" \
#    --insert '$connector-ssl' --type attr -n keystorePass \
#        -v "${KS_PASSWORD}"\
#    --insert '$connector-ssl' --type attr -n keystoreFile \
#        -v "/root/.keystore" \
#    ${CATALINA_HOME}/conf/server.xml

# Expose ports. Note that you must do one of the following:
# map them to local ports at container runtime via "-p 8080:8080 -p 8443:8443"
# or use dynamic ports.
EXPOSE ${HTTP_PORT:-8080} ${HTTPS_PORT:-8443}

COPY scripts/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

# Default action executed by entrypoint script.
CMD ["run"]
