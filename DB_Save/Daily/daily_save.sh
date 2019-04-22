#!/bin/sh

apk add zip
DATE=$(date +%d-%m-%y)
gcloud auth activate-service-account education-sa-savemaker@mathrix-education.iam.gserviceaccount.com --key-file=sa-key/key.json
gcloud config set project mathrix-education
gcloud sql export sql mysql gs://backups-education/daily_saves/$DATE/db_save.gz --database=master_mathrix_education
cd ~
mkdir cdn_save
gsutil -m cp -r gs://cdn.mathrix.fr cdn_save
zip -r cdn_save.zip cdn_save
gsutil cp cdn_save.zip gs://backups-education/daily_saves/$DATE

