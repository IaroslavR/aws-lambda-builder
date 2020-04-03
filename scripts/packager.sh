#!/bin/bash

# cleanup
rm -rf /.package/* /.build/*
touch /.package/.gitkeep /.build/.gitkeep
# build
cp -r /src/* /.build
pip download -r requirements.txt
pip wheel -r requirements.txt
pip install --no-index -r requirements.txt -t .
zip -r /.package/lambda.zip *
# fix
chmod -R 777 /.build /.package /.wheelhouse