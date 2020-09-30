#!/bin/bash

# Copyright (c) 2019. Master Sucipto
JS_VERSION=7.5.0

echo "Downloading from GCS"
gsutil cp gs://gke-shared/jasperreport/${JS_VERSION}/jasperreports-server_${JS_VERSION}_bin.zip	 resources/
echo "Downloading from Web"
gsutil cp gs://gke-shared/jasperreport/${JS_VERSION}/WEB-INF/applicationContext-externalAuth-oAuth.xml	 resources/WEB-INF/

echo "Downloading from Lib"
gsutil cp gs://gke-shared/jasperreport/${JS_VERSION}/WEB-INF/lib/google-oauth-1.0-SNAPSHOT.jar	 resources/WEB-INF/lib/
gsutil cp gs://gke-shared/jasperreport/${JS_VERSION}/WEB-INF/lib/jettison-1.1.jar	 resources/WEB-INF/lib/
gsutil cp gs://gke-shared/jasperreport/${JS_VERSION}/WEB-INF/lib/org.apache.oltu.oauth2.client-1.0.2.jar	 resources/WEB-INF/lib/
gsutil cp gs://gke-shared/jasperreport/${JS_VERSION}/WEB-INF/lib/org.apache.oltu.oauth2.common-1.0.2.jar	 resources/WEB-INF/lib/

echo "Downloading from JSP"
gsutil cp gs://gke-shared/jasperreport/${JS_VERSION}/WEB-INF/jsp/modules/commonJSTLScripts.jsp		 resources/WEB-INF/jsp/modules/commonJSTLScripts.jsp	


echo "Downloading from License"
gsutil cp gs://gke-shared/jasperreport/license/jasperserver.license resources/

echo "Download keystore"
gsutil cp gs://gke-shared/jasperreport/${JS_VERSION}/keystore/keystore.init.properties   resources/
gsutil cp gs://gke-shared/jasperreport/${JS_VERSION}/keystore/.jrsks   resources/
gsutil cp gs://gke-shared/jasperreport/${JS_VERSION}/keystore/.jrsksp   resources/

echo "Running Docker Build"

docker-compose build
