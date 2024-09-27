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
    wget

# Create a user and set the home directory
RUN useradd -ms /bin/bash flutterdev

# Switch to the new user
USER flutterdev
WORKDIR /home/flutterdev

# Set up Android SDK
RUN mkdir -p Android/sdk && \
    mkdir -p .android && touch .android/repositories.cfg

# Download and install Android SDK tools
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
    unzip sdk-tools.zip -d Android/sdk && \
    rm sdk-tools.zip && \
    yes | Android/sdk/tools/bin/sdkmanager --licenses && \
    Android/sdk/tools/bin/sdkmanager "platform-tools" "platforms;android-29"

# Set up Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /flutter && \
    cd /flutter && \
    git checkout 3.24.3

# Add Flutter to PATH
ENV PATH="/flutter/bin:${PATH}"

# Run Flutter doctor to finalize setup
RUN flutter doctor

# Default command to keep the container running
CMD ["bash"]


