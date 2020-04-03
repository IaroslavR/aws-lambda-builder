### Docker image for build AWS Lambdas with native dependencies right way

Base helper image for build and test AWS lambda packages without EC2 instances

Inspired by authors of [An easier way to build AWS Lambda deployment packages — with Docker instead of EC2](https://blog.quiltdata.com/an-easier-way-to-build-lambda-deployment-packages-with-docker-instead-of-ec2-9050cd486ba8?gi=c983640fef87) and  [How to build an AWS Lambda function with Python 3.7 (the right way)](https://medium.com/@niklongstone/how-to-build-an-aws-lambda-function-with-python-3-7-the-right-way-21888e2edbe8) articles 

Main problem described in the [The Black Magic of Python Wheels](https://hashman.ca/pycon-2019/ehashman-pycon2019-slides.pdf). Due to the [bug](https://github.com/pypa/auditwheel/issues/159) in the `patcheif` we need to use [this](https://github.com/nvictus/patchelf.git) repo with patched for [auditwheel](https://github.com/pypa/auditwheel) version

##### Why? If...
- **Q** We are already have [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/what-is-sam.html)
- **A:** https://github.com/awslabs/aws-sam-cli/issues/973


- **Q** We are use [chalice](https://chalice.readthedocs.io/en/latest/index.html) 
- **A** This tool cover [example of a library with C extensions and no wheel files](https://chalice.readthedocs.io/en/latest/topics/packaging.html#cryptography-example) case with local building runtime

##### Requirements
- Docker
- docker-compose

#### Usage
- Create [Dockerfile](./example) with installed native requirements for python lib build
- Copy your code and `requirements.txt` to the `./src` dir
- Execute `make build-package`
```
make build-package 
docker build \
        ./example
lambda-builder_1  | + pip wheel -r requirements.txt
lambda-builder_1  | Looking in links: /.wheelhouse
lambda-builder_1  | Processing /.wheelhouse/mysqlclient-1.4.6-cp37-cp37m-manylinux2014_x86_64.whl
lambda-builder_1  |   File was already downloaded /.wheelhouse/mysqlclient-1.4.6-cp37-cp37m-manylinux2014_x86_64.whl
lambda-builder_1  | Skipping mysqlclient, due to already being wheel.
lambda-builder_1  | + auditwheel repair --plat manylinux2014_x86_64 -w /.wheelhouse /.wheelhouse/mysqlclient-1.4.6-cp37-cp37m-linux_x86_64.whl
lambda-builder_1  | INFO:auditwheel.main_repair:Repairing mysqlclient-1.4.6-cp37-cp37m-linux_x86_64.whl
lambda-builder_1  | INFO:auditwheel.wheeltools:Previous filename tags: linux_x86_64
lambda-builder_1  | INFO:auditwheel.wheeltools:New filename tags: manylinux2014_x86_64
lambda-builder_1  | INFO:auditwheel.wheeltools:Previous WHEEL info tags: cp37-cp37m-linux_x86_64
lambda-builder_1  | INFO:auditwheel.wheeltools:New WHEEL info tags: cp37-cp37m-manylinux2014_x86_64
lambda-builder_1  | INFO:auditwheel.main_repair:
lambda-builder_1  | Fixed-up wheel written to /.wheelhouse/mysqlclient-1.4.6-cp37-cp37m-manylinux2014_x86_64.whl
lambda-builder_1  | + auditwheel show /.wheelhouse/mysqlclient-1.4.6-cp37-cp37m-manylinux2014_x86_64.whl
lambda-builder_1  | 
lambda-builder_1  | mysqlclient-1.4.6-cp37-cp37m-manylinux2014_x86_64.whl is consistent
lambda-builder_1  | with the following platform tag: "manylinux2014_x86_64".
lambda-builder_1  | 
lambda-builder_1  | The wheel references external versioned symbols in these system-
lambda-builder_1  | provided shared libraries: libc.so.6 with versions {'GLIBC_2.3',
lambda-builder_1  | 'GLIBC_2.14', 'GLIBC_2.17', 'GLIBC_2.7', 'GLIBC_2.4', 'GLIBC_2.3.4',
lambda-builder_1  | 'GLIBC_2.16', 'GLIBC_2.8', 'GLIBC_2.2.5'},
lambda-builder_1  | libkrb5support-1e00ebb8.so.0.1 with versions {'krb5support_0_MIT'},
lambda-builder_1  | libk5crypto-83914fc5.so.3.1 with versions {'k5crypto_3_MIT'},
lambda-builder_1  | libkrb5-5171cf0b.so.3.3 with versions {'krb5_3_MIT'},
lambda-builder_1  | libcrypto-1763ce4d.so.1.0.2k with versions {'libcrypto.so.10',
lambda-builder_1  | 'OPENSSL_1.0.1_EC'}, libkeyutils-caf8c69c.so.1.5 with versions
lambda-builder_1  | {'KEYUTILS_0.3', 'KEYUTILS_1.0', 'KEYUTILS_1.5'}, libresolv.so.2 with
lambda-builder_1  | versions {'GLIBC_2.2.5'}, libpthread.so.0 with versions
lambda-builder_1  | {'GLIBC_2.3.2', 'GLIBC_2.2.5'}, libdl.so.2 with versions
lambda-builder_1  | {'GLIBC_2.2.5'}, libm.so.6 with versions {'GLIBC_2.2.5'},
lambda-builder_1  | libssl-54f048ca.so.1.0.2k with versions {'libssl.so.10'},
lambda-builder_1  | libmysqlclient-70ab951e.so.18.0.0 with versions {'libmysqlclient_16'}
lambda-builder_1  | 
lambda-builder_1  |   adding: MySQLdb/_mysql.cpython-37m-x86_64-linux-gnu.so (deflated 69%)
lambda-builder_1  |   adding: MySQLdb/cursors.py (deflated 71%)
lambda-builder_1  |   adding: MySQLdb/_exceptions.py (deflated 63%)
lambda-builder_1  |   adding: MySQLdb/release.py (deflated 7%)
lambda-builder_1  |   adding: MySQLdb/converters.py (deflated 62%)
lambda-builder_1  |   adding: MySQLdb/__pycache__/ (stored 0%)
lambda-builder_1  |   adding: MySQLdb/__pycache__/__init__.cpython-37.pyc (deflated 45%)
lambda-builder_1  |   adding: MySQLdb/__pycache__/release.cpython-37.pyc (deflated 13%)
lambda-builder_1  |   adding: MySQLdb/__pycache__/converters.cpython-37.pyc (deflated 48%)
lambda-builder_1  |   adding: MySQLdb/__pycache__/_exceptions.cpython-37.pyc (deflated 62%)
lambda-builder_1  |   adding: MySQLdb/__pycache__/times.cpython-37.pyc (deflated 52%)
lambda-builder_1  |   adding: MySQLdb/__pycache__/cursors.cpython-37.pyc (deflated 58%)
lambda-builder_1  |   adding: MySQLdb/__pycache__/compat.cpython-37.pyc (deflated 18%)
lambda-builder_1  |   adding: MySQLdb/__pycache__/connections.cpython-37.pyc (deflated 54%)
lambda-builder_1  |   adding: MySQLdb/times.py (deflated 70%)
lambda-builder_1  |   adding: MySQLdb/constants/ (stored 0%)
lambda-builder_1  |   adding: MySQLdb/constants/ER.py (deflated 65%)
lambda-builder_1  |   adding: MySQLdb/constants/CR.py (deflated 57%)
lambda-builder_1  |   adding: MySQLdb/constants/CLIENT.py (deflated 32%)
lambda-builder_1  |   adding: MySQLdb/constants/FLAG.py (deflated 26%)
lambda-builder_1  |   adding: MySQLdb/constants/__pycache__/ (stored 0%)
lambda-builder_1  |   adding: MySQLdb/constants/__pycache__/__init__.cpython-37.pyc (deflated 10%)
lambda-builder_1  |   adding: MySQLdb/constants/__pycache__/CR.cpython-37.pyc (deflated 42%)
lambda-builder_1  |   adding: MySQLdb/constants/__pycache__/FLAG.cpython-37.pyc (deflated 25%)
lambda-builder_1  |   adding: MySQLdb/constants/__pycache__/ER.cpython-37.pyc (deflated 58%)
lambda-builder_1  |   adding: MySQLdb/constants/__pycache__/FIELD_TYPE.cpython-37.pyc (deflated 32%)
lambda-builder_1  |   adding: MySQLdb/constants/__pycache__/CLIENT.cpython-37.pyc (deflated 31%)
lambda-builder_1  |   adding: MySQLdb/constants/FIELD_TYPE.py (deflated 40%)
lambda-builder_1  |   adding: MySQLdb/constants/__init__.py (deflated 2%)
lambda-builder_1  |   adding: MySQLdb/__init__.py (deflated 62%)
lambda-builder_1  |   adding: lambda.py (deflated 29%)
lambda-builder_1  |   adding: mysqlclient-1.4.6.dist-info/ (stored 0%)
lambda-builder_1  |   adding: mysqlclient-1.4.6.dist-info/METADATA (deflated 59%)
lambda-builder_1  |   adding: mysqlclient-1.4.6.dist-info/INSTALLER (stored 0%)
lambda-builder_1  |   adding: mysqlclient-1.4.6.dist-info/top_level.txt (stored 0%)
lambda-builder_1  |   adding: mysqlclient-1.4.6.dist-info/WHEEL (deflated 3%)
lambda-builder_1  |   adding: mysqlclient-1.4.6.dist-info/LICENSE (deflated 62%)
lambda-builder_1  |   adding: mysqlclient-1.4.6.dist-info/RECORD (deflated 52%)
lambda-builder_1  |   adding: mysqlclient.libs/ (stored 0%)
lambda-builder_1  |   adding: mysqlclient.libs/libgssapi_krb5-594507f6.so.2.2 (deflated 67%)
lambda-builder_1  |   adding: mysqlclient.libs/libssl-54f048ca.so.1.0.2k (deflated 70%)
lambda-builder_1  |   adding: mysqlclient.libs/libk5crypto-83914fc5.so.3.1 (deflated 66%)
lambda-builder_1  |   adding: mysqlclient.libs/libkrb5-5171cf0b.so.3.3 (deflated 66%)
lambda-builder_1  |   adding: mysqlclient.libs/libcom_err-7d8345a5.so.2.1 (deflated 68%)
lambda-builder_1  |   adding: mysqlclient.libs/libkeyutils-caf8c69c.so.1.5 (deflated 69%)
lambda-builder_1  |   adding: mysqlclient.libs/libz-5de0a349.so.1.2.8 (deflated 49%)
lambda-builder_1  |   adding: mysqlclient.libs/libcrypto-1763ce4d.so.1.0.2k (deflated 60%)
lambda-builder_1  |   adding: mysqlclient.libs/libkrb5support-1e00ebb8.so.0.1 (deflated 69%)
lambda-builder_1  |   adding: mysqlclient.libs/libmysqlclient-70ab951e.so.18.0.0 (deflated 75%)
lambda-builder_1  |   adding: mysqlclient.libs/libselinux-e812e8aa.so.1 (deflated 57%)
lambda-builder_1  |   adding: requirements.txt (stored 0%)
lambda-builder_1  | + chmod -R 777 /.build /.package /.wheelhouse
aws-lambda-builder_lambda-builder_1 exited with code 0
```
Results can be found in `./.build`(sources + libs) and in `./.package`(ready to use zipped lambda) dirs. Python version and other globals can be modified in `.env` file
##### Testing
Testing stack example based on [lambci/lambda](https://github.com/lambci/lambci) can be found [here](docker-compose.lambci.yml)
```
$ make test-package
docker-compose -f docker-compose.lambci.yml up
Starting aws-lambda-builder_mysql_1  ... done
Starting aws-lambda-builder_lambda_1 ... done
Attaching to aws-lambda-builder_mysql_1, aws-lambda-builder_lambda_1
----------------skipped-----------------
mysql_1   | 2020-04-03T20:27:09.994163Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Socket: '/var/run/mysqld/mysqlx.sock' bind-address: '::' port: 33060
lambda_1  | connected
lambda_1  | START RequestId: c8aa1d91-3c2f-12b1-3e54-fbbd31477dd0 Version: $LATEST
lambda_1  | END RequestId: c8aa1d91-3c2f-12b1-3e54-fbbd31477dd0
lambda_1  | REPORT RequestId: c8aa1d91-3c2f-12b1-3e54-fbbd31477dd0      Init Duration: 5336.32 ms       Duration: 10.30 ms      Billed Duration: 100 ms Memory Size: 1536 MB    Max Memory Used: 28 MB   
lambda_1  | 
lambda_1  | {}
aws-lambda-builder_lambda_1 exited with code 0
^CGracefully stopping... (press Ctrl+C again to force)
```

#### Available commands
 ```
$ make

Usage:
  make <target>

Targets:
  help        Display this help
  build-image  Build base builder Docker image
  build-image-custom  Build custom runtime from ./examples/Doskerfile
  push-image  Push base builder image to the regestry
  clean       Clean dirs
  build-package  Build lambda package with ./examples/Doskerfile as runtime
  test-package  Test lambda with the help of lambci/lambda
```

#### References
- [amazonlinux DockerHub](https://hub.docker.com/_/amazonlinux/?tab=tags)
- [Lambda runtimes](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html)
