#!/bin/sh

apk add zip
DATE=$(date +%s_%m-%d_%X)
gcloud auth activate-service-account education-sa-savemaker@mathrix-education.iam.gserviceaccount.com --key-file=sa-key/key.json
gcloud config set project mathrix-education
gcloud sql export sql mysql gs://backups-education/hourly_saves/$DATE/db_save.gz --database=master_mathrix_education
cd ~
mkdir cdn_save
gsutil -m cp -r gs://cdn.mathrix.fr cdn_save
zip -r cdn_save.zip cdn_save
gsutil cp cdn_save.zip gs://backups-education/hourly_saves/$DATE
#if [ "$(gsutil ls gs://backups-education/hourly_saves | wc -l)" -gt "169" ]; then 
# TODELETE=($( gsutil ls gs://backups-education/hourly_saves ))
# gsutil -m rm -r ${TODELETE[1]}
#fi
