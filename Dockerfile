FROM debian:12.1-slim

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y && apt-get install build-essential -y \
    wget unzip openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

COPY . /app

# Set environment variables
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}"

# Download and install the Android SDK command-line tools
RUN mkdir -p $ANDROID_HOME/cmdline-tools && cd $ANDROID_HOME/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip && rm cmdline-tools.zip && \
    mv cmdline-tools latest

# Accept licenses and install required SDK packages
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0" "ndk;25.2.9519653"

# Set environment variables for NDK
ENV ANDROID_NDK_HOME=$ANDROID_HOME/ndk/25.2.9519653
ENV PATH="${ANDROID_NDK_HOME}:${PATH}"

# Verify installation
RUN sdkmanager --list

ENV ANDROID_JAR=$ANDROID_HOME/platforms/android-34/android.jar
ENV ANDROID_LLVM=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64
ENV ANDROID_LIBS=$ANDROID_LLVM/sysroot/usr/lib/aarch64-linux-android
ENV ANDROID_LIBS_LINK=$ANDROID_LLVM/sysroot/usr/lib/aarch64-linux-android/29

ENV AAPT=$ANDROID_HOME/build-tools/34.0.0/aapt
ENV ADB=$ANDROID_HOME/platform-tools/adb
ENV CLANG=$ANDROID_LLVM/bin/clang
ENV ZIPALIGN=$ANDROID_HOME/build-tools/34.0.0/zipalign

