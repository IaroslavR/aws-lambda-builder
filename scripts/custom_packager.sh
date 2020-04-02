#!/bin/bash
yum install mysql-devel findutils -y
find / -name "libmysqlclient.*"
rm -rf /.package/* /.build/*
touch /.package/.gitkeep /.build/.gitkeep
cp -r /src/* /.build
cd /.build
python3 -m pip install -r requirements.txt -t .
cp /usr/lib64/mysql57/libmysqlclient.so.1020 ./
zip -r /.package/lambda.zip *
chmod -R 777 /.build /.package
