#!/bin/bash

set -e

# File: setup-android-env.sh
# Check for required system packages
echo "📦 Checking system packages..."
MISSING_PKGS=""
for pkg in git g++ wget curl zip pkg-config tar cmake unzip python3 autoconf automake libtool; do
    if ! command -v $pkg &> /dev/null; then
        MISSING_PKGS="$MISSING_PKGS $pkg"
    fi
done

if [ -n "$MISSING_PKGS" ]; then
    echo "⚠️  Missing packages:$MISSING_PKGS"
    echo "Install with: sudo pacman -S base-devel git curl wget zip unzip tar cmake pkg-config python3 autoconf automake libtool"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# NDK setup - download if missing
NDK_VERSION="r29"
NDK_PATH="$(pwd)/android-ndk-$NDK_VERSION"
[ -d "$NDK_PATH" ] || (rm -f android-ndk-$NDK_VERSION-linux.zip && wget https://dl.google.com/android/repository/android-ndk-$NDK_VERSION-linux.zip && unzip android-ndk-$NDK_VERSION-linux.zip && rm android-ndk-$NDK_VERSION-linux.zip)

# Set environment variables
export ANDROID_NDK_HOME="$NDK_PATH"
export ANDROID_NDK="$NDK_PATH"
export NDK_HOME="$NDK_PATH"
export PATH="$NDK_PATH:$PATH"

# Android build settings
export ANDROID_API=28
export ANDROID_ABI=arm64-v8a

if [ ! -d "vcpkg" ]; then
    git clone https://github.com/microsoft/vcpkg.git
fi

cd vcpkg
export VCPKG_ROOT=$(pwd)
export PATH=$VCPKG_ROOT:$PATH

echo "📁 Copying custom ports and triplets..."
cp -r $VCPKG_ROOT/ports . 2>/dev/null || echo "  No ports directory to copy"
cp -r $VCPKG_ROOT/triplets . 2>/dev/null || echo "  No triplets directory to copy"
cp -r $VCPKG_ROOT/vcpkg.json . 2>/dev/null || echo "  No vcpkg.json to copy"

if [ ! -f "./vcpkg" ]; then
    ./bootstrap-vcpkg.sh
fi

cd ..

echo "🎯 Current environment:"
echo "ANDROID_NDK_HOME=$ANDROID_NDK_HOME"
echo "ANDROID_API=$ANDROID_API"
echo "ANDROID_ABI=$ANDROID_ABI"

vcpkg install --overlay-ports=ports --overlay-triplets=triplets --triplet arm64-android

mkdir -p project

vcpkg export --x-all-installed --7zip --output-dir ./project --output android-deps
