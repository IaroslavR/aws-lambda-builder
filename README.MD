### Docker image for build AWS Lambdas

Base helper image for build and test AWS lambda packages without EC2 instances

Inspired by authors of [An easier way to build AWS Lambda deployment packages — with Docker instead of EC2](https://blog.quiltdata.com/an-easier-way-to-build-lambda-deployment-packages-with-docker-instead-of-ec2-9050cd486ba8?gi=c983640fef87) and  [How to build an AWS Lambda function with Python 3.7 (the right way)](https://medium.com/@niklongstone/how-to-build-an-aws-lambda-function-with-python-3-7-the-right-way-21888e2edbe8) articles 

##### Why? We are already have [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/what-is-sam.html)

Answer: https://github.com/awslabs/aws-sam-cli/issues/973

##### Requirements
- Docker
- docker-compose

#### Usage
- Copy your code and `requirements.txt` to the `./src` dir
- Execute `make build-package`
```.env
$ make build-package
docker-compose up
Recreating aws-lambda-builder_cognito-lambda-builder_1 ... done
Attaching to aws-lambda-builder_cognito-lambda-builder_1
cognito-lambda-builder_1  | + rm -rf /.package/lambda.zip /.build/MySQLdb /.build/lambda.py /.build/libmysqlclient.so.1020 /.build/mysqlclient-1.4.6.dist-info /.build/requirements.txt
cognito-lambda-builder_1  | + touch /.package/.gitkeep /.build/.gitkeep
cognito-lambda-builder_1  | + cp -r /src/lambda.py /src/requirements.txt /.build
cognito-lambda-builder_1  | + cd /.build
cognito-lambda-builder_1  | + python3.7 -m pip install -r requirements.txt -t .
cognito-lambda-builder_1  | Collecting mysqlclient
cognito-lambda-builder_1  |   Downloading mysqlclient-1.4.6.tar.gz (85 kB)
cognito-lambda-builder_1  |     ERROR: Command errored out with exit status 1:
cognito-lambda-builder_1  |      command: /usr/local/bin/python3.7 -c 'import sys, setuptools, tokenize; sys.argv[0] = '"'"'/tmp/pip-install-mu6r6vy7/mysqlclient/setup.py'"'"'; __file__='"'"'/tmp/pip-install-mu6r6vy7/mysqlclient/setup.py'"'"';f=getattr(tokenize, '"'"'open'"'"', open)(__file__);code=f.read().replace('"'"'\r\n'"'"', '"'"'\n'"'"');f.close();exec(compile(code, __file__, '"'"'exec'"'"'))' egg_info --egg-base /tmp/pip-install-mu6r6vy7/mysqlclient/pip-egg-info
cognito-lambda-builder_1  |          cwd: /tmp/pip-install-mu6r6vy7/mysqlclient/
cognito-lambda-builder_1  |     Complete output (12 lines):
cognito-lambda-builder_1  |     /bin/sh: mysql_config: command not found
cognito-lambda-builder_1  |     /bin/sh: mariadb_config: command not found
cognito-lambda-builder_1  |     /bin/sh: mysql_config: command not found
cognito-lambda-builder_1  |     Traceback (most recent call last):
cognito-lambda-builder_1  |       File "<string>", line 1, in <module>
cognito-lambda-builder_1  |       File "/tmp/pip-install-mu6r6vy7/mysqlclient/setup.py", line 16, in <module>
cognito-lambda-builder_1  |         metadata, options = get_config()
cognito-lambda-builder_1  |       File "/tmp/pip-install-mu6r6vy7/mysqlclient/setup_posix.py", line 61, in get_config
cognito-lambda-builder_1  |         libs = mysql_config("libs")
cognito-lambda-builder_1  |       File "/tmp/pip-install-mu6r6vy7/mysqlclient/setup_posix.py", line 29, in mysql_config
cognito-lambda-builder_1  |         raise EnvironmentError("%s not found" % (_mysql_config_path,))
cognito-lambda-builder_1  |     OSError: mysql_config not found
cognito-lambda-builder_1  |     ----------------------------------------
cognito-lambda-builder_1  | ERROR: Command errored out with exit status 1: python setup.py egg_info Check the logs for full command output.
aws-lambda-builder_cognito-lambda-builder_1 exited with code 1

```
As we can see we can't build our [lambda](./src/lambda.py) with `mysqlclient` in [reqs](./src/requirements.txt) without `mysql-devel` installed. Lets use modified for our needs [./scripts/custom_packager.sh](./scripts/custom_packager.sh) instead of base one. **Pay attention** Step where I search for `so` file which I need to copy was skipped in this README :) But you can use for it testing stack [described](#testing) below
```
$ make build-package-custom 
docker-compose -f docker-compose.custom.yml up
-------------skipped------------
cognito-lambda-builder_1  |   adding: mysqlclient-1.4.6.dist-info/LICENSE (deflated 62%)
cognito-lambda-builder_1  |   adding: mysqlclient-1.4.6.dist-info/RECORD (deflated 55%)
cognito-lambda-builder_1  |   adding: requirements.txt (stored 0%)
cognito-lambda-builder_1  | + chmod -R 777 /.build /.package
aws-lambda-builder_cognito-lambda-builder_1 exited with code 0
```
Results can be found in `./.build`(sources + libs) and in `./.package`(ready to use zipped lambda) dirs. Python version and other globals can be modified in `.env` file
##### Testing
Testing stack example based on [lambci/lambda](https://github.com/lambci/lambci) can be found [here](docker-compose.lambci.yml)
```
$ make test-package 
docker-compose -f docker-compose.lambci.yml up
Starting aws-lambda-builder_lambda_1 ... done
Starting aws-lambda-builder_mysql_1  ... done
Attaching to aws-lambda-builder_lambda_1, aws-lambda-builder_mysql_1
mysql_1   | 2020-04-02 04:59:49+00:00 [Note] [Entrypoint]: Entrypoint script for MySQL Server 8.0.19-1debian10 started.
-------------skipped------------
mysql_1   | 2020-04-02T04:59:51.271168Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Socket: '/var/run/mysqld/mysqlx.sock' bind-address: '::' port: 33060
lambda_1  | connected
lambda_1  | START RequestId: 0d531a34-5c6f-1752-2ad9-f45b10044235 Version: $LATEST
lambda_1  | END RequestId: 0d531a34-5c6f-1752-2ad9-f45b10044235
lambda_1  | REPORT RequestId: 0d531a34-5c6f-1752-2ad9-f45b10044235      Init Duration: 5963.99 ms       Duration: 6.09 ms       Billed Duration: 100 ms      Memory Size: 1536 MB    Max Memory Used: 27 MB
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
  build-image  Build builder Docker image
  delete-image  Remove docker image
  push-image  Push image to the regestry
  clean       Clean dirs
  build-package  Build lambda package with container /scripts/builder.sh
  build-package-custom  Build lambda package with local ./scripts/custom_builder.sh
  test-package  Test lambda with the help of lambci/lambda
```

#### References
- [amazonlinux DockerHub](https://hub.docker.com/_/amazonlinux/?tab=tags)
- [Lambda runtimes](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html)
