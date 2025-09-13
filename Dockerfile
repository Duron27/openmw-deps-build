FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y upgrade && \
    apt-get -y install git g++ wget curl zip vim pkg-config tar cmake unzip ca-certificates

# Download Android NDK
RUN \
  wget https://dl.google.com/android/repository/android-ndk-r26d-linux.zip && \
  unzip android-ndk-r26d-linux.zip && \
  rm -rf android-ndk-r26d-linux.zip

ENV ANDROID_NDK_HOME=/android-ndk-r26d

WORKDIR /vcpkg
RUN git clone https://github.com/microsoft/vcpkg .
RUN ./bootstrap-vcpkg.sh

ENV PATH="/vcpkg:$PATH"
ENV VCPKG_ROOT="/vcpkg"

WORKDIR /project

COPY vcpkg.json ./
COPY ports ./ports
COPY triplets ./triplets

RUN vcpkg install --overlay-ports=ports --overlay-triplets=triplets --triplet arm64-android
RUN vcpkg export \
    --x-all-installed \
    --7zip \
    --output-dir /project \
    --output android-deps
