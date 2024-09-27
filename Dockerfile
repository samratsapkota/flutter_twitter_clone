FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisites
RUN apt update && apt install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-17-jdk \
    wget \
    maven # Install maven for JAXB dependencies

# Set up user as root
RUN mkdir /home/flutterdev
WORKDIR /home/flutterdev
USER root

# Prepare Android directories and system variables
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /home/flutterdev/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg

# Set up Android SDK
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/sdk/tools

# Install JAXB dependencies
RUN mvn dependency:get -Dartifact=javax.xml.bind:jaxb-api:2.3.1
RUN mvn dependency:get -Dartifact=org.glassfish.jaxb:jaxb-runtime:2.3.1
# Accept licenses for the SDK
RUN cd Android/sdk/tools/bin && \
    echo "y" | ./sdkmanager --licenses || true
RUN cd Android/sdk/tools/bin && \
    ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"


# Accept licenses for the SDK
#RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
#RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /flutter && \
    cd /flutter && \
    git checkout 3.24.3 && \
    flutter doctor

# Run basic check to download Dart SDK
RUN flutter doctor
RUN flutter config --no-analytics

