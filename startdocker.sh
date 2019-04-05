#!/bin/bash

# Copyright (c) 2019. Master Sucipto
JS_VERSION=7.1.1

echo "Downloading from GCS"
gsutil cp gs://gke-shared/jasperreport/${JS_VERSION}/jasperreports-server_${JS_VERSION}_bin.zip	 resources/

gsutil cp gs://gke-shared/jasperreport/${JS_VERSION}/WEB-INF/applicationContext-externalAuth-Keycloak.xml	 resources/WEB-INF/
gsutil cp gs://gke-shared/jasperreport/${JS_VERSION}/WEB-INF/slave.json	 resources/WEB-INF/

gsutil cp gs://gke-shared/jasperreport/${JS_VERSION}/WEB-INF/lib/jasperserver-keycloak-adapter-0.0.3-SNAPSHOT.jar	 resources/WEB-INF/lib/
gsutil cp gs://gke-shared/jasperreport/${JS_VERSION}/WEB-INF/lib/keycloak-adapter-core-2.5.5.Final.jar	 resources/WEB-INF/lib/
gsutil cp gs://gke-shared/jasperreport/${JS_VERSION}/WEB-INF/lib/keycloak-adapter-spi-2.5.5.Final.jar	 resources/WEB-INF/lib/
gsutil cp gs://gke-shared/jasperreport/${JS_VERSION}/WEB-INF/lib/keycloak-common-2.5.5.Final.jar	 resources/WEB-INF/lib/
gsutil cp gs://gke-shared/jasperreport/${JS_VERSION}/WEB-INF/lib/keycloak-core-2.5.5.Final.jar	 resources/WEB-INF/lib/
gsutil cp gs://gke-shared/jasperreport/${JS_VERSION}/WEB-INF/lib/keycloak-spring-security-adapter-2.5.5.Final.jar	 resources/WEB-INF/lib/

echo "Running Docker Build"



docker-compose build