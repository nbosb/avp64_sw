FROM ubuntu:22.04
WORKDIR /app
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y
RUN apt install -y --no-install-recommends \
    git \
    cmake \
    ninja-build \
    gperf \
    ccache \
    dfu-util \
    device-tree-compiler \
    wget \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-tk \
    python3-wheel \
    xz-utils \
    file \
    make \
    gcc \
    gcc-multilib \
    g++-multilib \
    libsdl2-dev \
    libmagic1


# install west
RUN pip3 install --user -U west
ENV PATH="/root/.local/bin:$PATH"

# get zephyr source code
RUN west init -m https://github.com/zephyrproject-rtos/zephyr --mr v3.7.0 zephyrproject
WORKDIR /app/zephyrproject
RUN west update

# export zephyr cmake package
RUN west zephyr-export

# install additional python dependencies
RUN pip3 install --user -r ./zephyr/scripts/requirements.txt

WORKDIR /app

# download the sdk
RUN wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.8/zephyr-sdk-0.16.8_linux-x86_64.tar.xz
RUN wget -O - https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.8/sha256.sum | shasum --check --ignore-missing
RUN tar -xf zephyr-sdk-0.16.8_linux-x86_64.tar.xz -C /app/ && rm zephyr-sdk-0.16.8_linux-x86_64.tar.xz

WORKDIR /app/zephyr-sdk-0.16.8
RUN ./setup.sh -c -t aarch64-zephyr-elf

WORKDIR /app/zephyr

ENTRYPOINT ["/app/docker_entrypoint.sh"]

