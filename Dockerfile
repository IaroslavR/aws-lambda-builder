FROM amazonlinux:2018.03
# Need to set "ulimit -n" to a small value to stop yum from hanging:
# https://bugzilla.redhat.com/show_bug.cgi?id=1715254#c1
RUN ulimit -n 1024 && \
    yum -y update && \
    yum -y install \
    autoconf \
    automake \
    bzip2 \
    findutils \
    gcc \
    gcc-c++ \
    git \
    libffi-devel \
    openssl-devel \
    unzip \
    unzip \
    wget \
    zip \
    zlib-devel && \
    yum -y clean all && \
    rm -rf /var/cache/yum

# Install Python, pip and boto
# boto3 is available to lambda processes by default
# Runtimes - https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
COPY ./.cache /cache
WORKDIR /cache
RUN mkdir Python && \
    tar xzf Python.tgz -C Python --strip-components 1 && \
    cd Python && \
    ./configure --enable-optimizations && \
    make altinstall && \
    ln -s /usr/local/bin/python3.7 /usr/local/bin/python3 && \
    cd .. && \
    python3 get-pip.py  && \
    python3 -m pip install --upgrade pip && \
    python3 -V && \
    pip -V  && \
    python3 -m pip install botocore==1.13.34 boto3==1.10.34 auditwheel && \
    git clone https://github.com/nvictus/patchelf.git && \
    cd patchelf && \
    ./bootstrap.sh && \
    ./configure && \
    make && \
    make install && \
    rm -rf /cache

COPY ./scripts/packager.sh /scripts/packager.sh
WORKDIR /.build

ENV PIP_WHEEL_DIR=/.wheelhouse
ENV PIP_FIND_LINKS=/.wheelhouse
ENV PIP_DESTINATION_DIRECTORY=/.wheelhouse
# https://github.com/numpy/numpy/issues/14147
ENV CFLAGS="-std=c99"
ENTRYPOINT ["/bin/bash", "-ex"]
CMD ["/scripts/packager.sh"]
