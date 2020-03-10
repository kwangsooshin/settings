FROM ubuntu:18.04

ENV PYTHON_VERSION 3.7

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common apt-utils wget curl build-essential \
        python$PYTHON_VERSION python$PYTHON_VERSION-dev python$PYTHON_VERSION-venv python$PYTHON_MAJOR_VERISON-pip
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python$PYTHON_VERSION get-pip.py && rm get-pip.py
RUN ln -s /usr/bin/python$PYTHON_VERSION /usr/bin/python && \
    ln -s /usr/bin/pip$PYTHON_VERSION /usr/bin/pip

##################################################
RUN sed -i "s/archive.ubuntu.com/mirror.kakao.com/g" /etc/apt/sources.list && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends apt-utils openssh-server vim

RUN mkdir ~/.pip && \
    echo '[global]\n\
          index-url=http://mirror.kakao.com/pypi/simple/\n\
          trusted-host=mirror.kakao.com' > ~/.pip/pip.conf && \
    pip install --upgrade pip
#RUN pip install -r /requirements.txt --no-cache-dir

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "root:password" | chpasswd

RUN printenv > ~/.pam_environment

EXPOSE 22 8000

ADD dev.entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
##################################################
