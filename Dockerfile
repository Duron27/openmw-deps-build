FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Set Android API level
ENV ANDROID_API 28

# Set target ABI
ENV ANDROID_ABI arm64-v8a

RUN apt-get update && apt-get -y upgrade && \
    apt-get -y install git g++ wget curl zip vim pkg-config tar cmake unzip ca-certificates python3 autoconf autoconf-archive automake libtool

# Download Android NDK
RUN \
  wget https://dl.google.com/android/repository/android-ndk-r29-linux.zip && \
  unzip android-ndk-r29-linux.zip && \
  rm -rf android-ndk-r29-linux.zip

ENV ANDROID_NDK_HOME=/android-ndk-r29

WORKDIR /vcpkg
RUN git clone https://github.com/microsoft/vcpkg .
RUN ./bootstrap-vcpkg.sh

ENV PATH="/vcpkg:$PATH"
ENV VCPKG_ROOT="/vcpkg"

WORKDIR /project

COPY vcpkg.json ./
COPY ports ./ports
COPY triplets ./triplets

#RUN git clone --recurse-submodules https://github.com/sisah2/Ng-gl4es -b Openmw3 NG-GL4ES

RUN vcpkg install --overlay-ports=ports --overlay-triplets=triplets --triplet arm64-android \
  || (echo "=== VCPKG BUILD FAILED ===" \
      && find /vcpkg/buildtrees -maxdepth 3 -type f -name '*.log' -print -exec cat {} \; \
      && exit 1)

RUN vcpkg export \
    --x-all-installed \
    --7zip \
    --output-dir /project \
    --output android-deps
