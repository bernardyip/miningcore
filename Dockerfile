FROM mcr.microsoft.com/dotnet/sdk:5.0-focal
MAINTAINER bernardyip@outlook.com

# Install dependencies and build miningcore
COPY . /miningcore/
RUN echo "deb https://mirror.0x.sg/ubuntu focal main restricted" > /etc/apt/sources.list && \
    echo "deb https://mirror.0x.sg/ubuntu focal-updates main restricted" >> /etc/apt/sources.list && \
    echo "deb https://mirror.0x.sg/ubuntu focal universe" >> /etc/apt/sources.list && \
    echo "deb https://mirror.0x.sg/ubuntu focal-updates universe" >> /etc/apt/sources.list && \
    echo "deb https://mirror.0x.sg/ubuntu focal multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirror.0x.sg/ubuntu focal-updates multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirror.0x.sg/ubuntu focal-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirror.0x.sg/ubuntu focal-security main restricted" >> /etc/apt/sources.list && \
    echo "deb https://mirror.0x.sg/ubuntu focal-security universe" >> /etc/apt/sources.list && \
    echo "deb https://mirror.0x.sg/ubuntu focal-security multiverse" >> /etc/apt/sources.list && \
    apt-get update -y && \
    apt-get -y install apt-transport-https && \
    apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install cmake build-essential libssl-dev pkg-config libboost-all-dev libsodium-dev libzmq3-dev && \
    cd /miningcore/src/Miningcore && \
    sh linux-build.sh && \
    mkdir -p /miningcoreapp && \
    cp -r ../../build/* /miningcoreapp/

FROM mcr.microsoft.com/dotnet/aspnet:5.0-focal

# Copy files over and install dependencies
COPY --from=0 /miningcoreapp/ /miningcoreapp/
RUN echo "deb https://mirror.0x.sg/ubuntu focal main restricted" > /etc/apt/sources.list && \
    echo "deb https://mirror.0x.sg/ubuntu focal-updates main restricted" >> /etc/apt/sources.list && \
    echo "deb https://mirror.0x.sg/ubuntu focal universe" >> /etc/apt/sources.list && \
    echo "deb https://mirror.0x.sg/ubuntu focal-updates universe" >> /etc/apt/sources.list && \
    echo "deb https://mirror.0x.sg/ubuntu focal multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirror.0x.sg/ubuntu focal-updates multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirror.0x.sg/ubuntu focal-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirror.0x.sg/ubuntu focal-security main restricted" >> /etc/apt/sources.list && \
    echo "deb https://mirror.0x.sg/ubuntu focal-security universe" >> /etc/apt/sources.list && \
    echo "deb https://mirror.0x.sg/ubuntu focal-security multiverse" >> /etc/apt/sources.list && \
    apt-get update -y && \
    apt-get -y install libzmq3-dev

WORKDIR /miningcoreapp

# API
EXPOSE 4000
# Stratum Ports
EXPOSE 3032-3199

ENTRYPOINT /miningcoreapp/Miningcore -c /config.json
