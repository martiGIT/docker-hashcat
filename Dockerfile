FROM nvidia/cuda:11.2.0-devel-ubuntu20.04 AS build-stage

ENV DEBIAN_FRONTEND=noninteractive

ENV HASHCAT_VERSION        v6.2.3
ENV HASHCAT_UTILS_VERSION  v1.9
ENV HCXTOOLS_VERSION       6.2.0
ENV HCXDUMPTOOL_VERSION    6.2.0
ENV HCXKEYS_VERSION        master

# Update & install packages for building hashcat
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git libcurl4-openssl-dev libssl-dev zlib1g-dev libcurl4-openssl-dev libssl-dev

WORKDIR /root

RUN git clone https://github.com/hashcat/hashcat.git \
    && cd hashcat \
    && git checkout ${HASHCAT_VERSION} \
    && make install -j4

RUN git clone https://github.com/hashcat/hashcat-utils.git \
    && cd hashcat-utils/src \
    && git checkout ${HASHCAT_UTILS_VERSION} \
    && make

RUN git clone https://github.com/ZerBea/hcxtools.git \
    && cd hcxtools \
    && git checkout ${HCXTOOLS_VERSION} \
    && make install

RUN git clone https://github.com/ZerBea/hcxdumptool.git \
    && cd hcxdumptool \
    && git checkout ${HCXDUMPTOOL_VERSION} \
    && make install

RUN git clone https://github.com/hashcat/kwprocessor.git \
    && cd kwprocessor \
    && git checkout ${HCXKEYS_VERSION} \
    && make


################# runtime stage ################

FROM nvidia/cuda:11.2.0-devel-ubuntu20.04

WORKDIR /root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git wget clinfo p7zip-full nano \
    && rm -rf /var/lib/apt/lists/*

# For OpenCL support
RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

COPY --from=build-stage /usr/local/bin/* /root/kwprocessor/kwp /usr/local/bin/
COPY --from=build-stage /root/hashcat-utils/src/cap2hccapx.bin /usr/local/bin/cap2hccapx
COPY --from=build-stage /usr/local/share/hashcat /usr/local/share/hashcat
COPY --from=build-stage /usr/local/share/doc/hashcat /usr/local/share/doc/hashcat
COPY --from=build-stage /root/hashcat-utils/src/*.bin /root/hashcat-utils/src/*.pl /root/hashcat-utils/bin/

LABEL maintainer="Sergey Cheperis"
