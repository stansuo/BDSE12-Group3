# Copyright (c) IIIedu BDSE.
ARG BASE_CONTAINER=jupyter/pyspark-notebook
FROM $BASE_CONTAINER

LABEL maintainer="BDSE12 Project <contactus@iii.org.tw>"

COPY module module 
COPY jar jar 
COPY sample sample 

USER root
RUN cp -r ~/module/sparkxgb /opt/conda/lib/python3.7/site-packages
RUN cp ~/jar/*.jar /usr/local/spark/jars
RUN rm -r ~/module
RUN rm -r ~/jar
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
USER jovyan


