#!/bin/bash
yum install mysql-devel
rm -rf /.package/* /.build/*
touch /.package/.gitkeep /.build/.gitkeep
cp -r /src/* /.build
cd /.build
python3.7 -m pip install -r requirements.txt -t .
zip -r /.package/lambda.zip *
chmod -R 777 /.build /.package