### Docker image for build AWS Lambdas

This image can help to build and test AWS lambda packages without EC2 instances

##### Requirements
- Docker
- docker-compose

#### Usage
- Copy your code and `requirements.txt` to the `./src` dir
- Execute `make build-package`

Results can be found in `./.build`(sources + libs) and in `./.package`(ready to use zipped lambda) dirs. Python version and other globals can be modified in `.env` file

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
  build-package  Build lambda package
```

#### References
- [An easier way to build AWS Lambda deployment packages — with Docker instead of EC2](https://blog.quiltdata.com/an-easier-way-to-build-lambda-deployment-packages-with-docker-instead-of-ec2-9050cd486ba8?gi=c983640fef87)
- [How to build an AWS Lambda function with Python 3.7 (the right way)](https://medium.com/@niklongstone/how-to-build-an-aws-lambda-function-with-python-3-7-the-right-way-21888e2edbe8)
- [amazonlinux DockerHub](https://hub.docker.com/_/amazonlinux/?tab=tags)