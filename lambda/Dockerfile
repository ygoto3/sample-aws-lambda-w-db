FROM --platform=linux/amd64 amazonlinux:latest
RUN yum install python3.9 -y zip
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py --user
RUN mkdir /home/layers
RUN mkdir /home/python
