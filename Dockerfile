FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /flutter && \
     cd flutter && \
     git checkout 3.24.3 && \
    /flutter/bin/flutter doctor
   
# Add Flutter to PATH
ENV PATH="/flutter/bin:${PATH}"

WORKDIR /app

