#!/bin/bash

auditwheel --version
# cleanup
rm -rf /.package/* /.build/*
touch /.package/.gitkeep /.build/.gitkeep
# build
cp -r /src/* /.build
pip download -r requirements.txt
pip wheel -r requirements.txt
auditwheel repair --plat manylinux2014_x86_64 -w /.wheelhouse /.wheelhouse/mysqlclient-1.4.6-cp37-cp37m-linux_x86_64.whl
auditwheel show /.wheelhouse/mysqlclient-1.4.6-cp37-cp37m-manylinux2014_x86_64.whl
pip install --no-index -r requirements.txt -t .
zip -r /.package/lambda.zip *

chmod -R 777 /.build /.package /.wheelhouse
