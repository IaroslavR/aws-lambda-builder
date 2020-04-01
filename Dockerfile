FROM amazonlinux:2018.03
# Need to set "ulimit -n" to a small value to stop yum from hanging:
# https://bugzilla.redhat.com/show_bug.cgi?id=1715254#c1
RUN ulimit -n 1024 && \
    yum -y update && \
    yum -y install \
    gcc \
    openssl-devel \
    zip \
    zlib-devel \
    libffi-devel && \
    yum -y clean all && \
    rm -rf /var/cache/yum

# Install Python
ADD ./.cache /cache
WORKDIR /cache
RUN mkdir Python && \
    tar xzf Python.tgz -C Python --strip-components 1 && \
    cd Python ; ./configure --enable-optimizations; make altinstall && \
    ln -s /usr/local/bin/python3.7 /usr/local/bin/python3 && \
    python3 -V

RUN rm -rf /cache

# Install pip and boto
# boto3 is available to lambda processes by default,
# but it's not in the amazonlinux image
# https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
RUN python3 get-pip.py  && \
    pip -V  && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install botocore==1.13.34 boto3==1.10.34

ADD ./scripts /scripts

WORKDIR /src

# Make it possible to build numpy:
# https://github.com/numpy/numpy/issues/14147
ENV CFLAGS="-std=c99"