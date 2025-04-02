#!/bin/bash
now=$(date +"%Y-%m-%d-%H-%M")
docker run --rm --entrypoint "" \
  -v /opt/backup:/backup \
  --network="shvirtd-example-python_backend" \
  my-mysqldump \
  mysqldump --opt -hmysql -uroot -p${1} --result-file=/backup/${now}_virtd.sql virtd