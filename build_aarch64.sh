#!/usr/bin/env bash

ROOT_DIR=$PWD
echo $ROOT_DIR

function build_gflags() {
  cd gflags
  mkdir -p build-$ARCH && cd build-$ARCH
  cmake \-std=c++11 
    -DARCH="$ARCH" \
    -DCMAKE_TOOLCHAIN_FILE="$ROOT_DIR/linux.cmake" \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_PATH" \
    -DBUILD_SHARED_LIBS=ON \
    ..
  if ! make -j $(nproc); then
    error "Failed to build gflags!"
    exit 1
  fi
  make install
  cd $ROOT_DIR
}

function build_gtest() {
  # git clone https://github.com/google/googletest.git
  cd gtest  
  mkdir -p build-$ARCH && cd build-$ARCH
  cmake \
    -DARCH="$ARCH" \
    -DCMAKE_TOOLCHAIN_FILE="$ROOT_DIR/linux.cmake" \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_PATH" \
    -DBUILD_SHARED_LIBS=ON \
    ..
  make -j $(nproc)
  make install
  cd $ROOT_DIR
}

function build_glog() {
  # git clone https://github.com/google/glog.git
  cd glog
  mkdir -p build-$ARCH && cd build-$ARCH
  cmake \
    -DARCH="$ARCH" \
    -DCMAKE_TOOLCHAIN_FILE="$ROOT_DIR/linux.cmake" \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_PATH" \
    -DBUILD_SHARED_LIBS=ON \
    ..
  if ! make -j "$(nproc)"; then
    error "Failed to build glog!"
    exit 1
  fi
  make install
  cd $ROOT_DIR
}

ARCH="aarch64"
INSTALL_PATH="$ROOT_DIR/aarch64-sdrv-linux/"
build_gflags
build_gtest
build_glog
