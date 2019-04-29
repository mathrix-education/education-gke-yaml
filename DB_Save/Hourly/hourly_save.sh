#!/bin/sh

apk add zip
DATE=$(date +%s_%m-%d_%X)
gcloud auth activate-service-account education-sa-savemaker@mathrix-education.iam.gserviceaccount.com --key-file=sa-key/key.json
gcloud config set project mathrix-education
gcloud sql export sql mysql gs://backups-education/hourly_saves/$DATE/db_save.gz --database=master_mathrix_education
cd ~
mkdir source
mkdir dest
gcsfuse cdn.mathrix.fr source
gcsfuse backups-education dest
zip -r dest/hourly_saves/$DATE/cdn.zip source
#if [ "$(gsutil ls gs://backups-education/hourly_saves | wc -l)" -gt "169" ]; then 
# TODELETE=($( gsutil ls gs://backups-education/hourly_saves ))
# gsutil -m rm -r ${TODELETE[1]}
#fi
exit 0
