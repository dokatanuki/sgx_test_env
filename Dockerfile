FROM ubuntu:18.04
MAINTAINER Keita Aihara <dokatanuki@gmail.com>

ARG MAIN_DIR=/sgx/

ARG SGX_FILE=sgx_linux_x64_sdk_2.5.100.49891.bin
ARG SGX_URL=https://download.01.org/intel-sgx/linux-2.5/ubuntu18.04-server/${SGX_FILE}

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		gcc \
		avr-libc \
		build-essential \
		libpcre3-dev \
		zlib1g-dev \
		git \
		bison \
		flex \
		libtool \
		git \
		openssh-client \
		wget \
		ca-certificates \
		make \
		patch \
		libapr1-dev \
		libaprutil1-dev \
        gdb \
	&& apt-get clean \
	&& apt-get autoclean \
	&& rm -rf /var/lib/apt/lists/*

# Create main directory
RUN mkdir -p ${MAIN_DIR}

WORKDIR ${MAIN_DIR}

# Install Intel SGX SDK
RUN wget ${SGX_URL} \
	&& chmod +x ${SGX_FILE} \
	&& echo "yes" | ./${SGX_FILE} \
	&& rm ${SGX_FILE}

WORKDIR /root
