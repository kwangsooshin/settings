FROM ubuntu:18.04

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
