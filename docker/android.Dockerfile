ARG JDK_VERSION

FROM bellsoft/liberica-openjdk-alpine:${JDK_VERSION}
LABEL maintainer="Mateusz Kaźmierczak <kazik117@gmail.com>"

ARG CMDLINE_VERSION
ARG SDK_TOOLS_VERSION
ARG BUILD_TOOLS
ARG TARGET_SDK

ENV ANDROID_SDK_ROOT "/opt/sdk"
ENV ANDROID_HOME ${ANDROID_SDK_ROOT}
ENV PATH $PATH:${ANDROID_SDK_ROOT}/cmdline-tools/${CMDLINE_VERSION}/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/extras/google/instantapps

RUN apk upgrade && \ 
    apk add --no-cache bash curl git unzip wget openssh-client coreutils python3 && \
    rm -rf /tmp/* && \ 
    rm -rf /var/cache/apk/* && \ 
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-${SDK_TOOLS_VERSION}_latest.zip -O /tmp/tools.zip && \ 
    mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \ 
    unzip -qq /tmp/tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \ 
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/* ${ANDROID_SDK_ROOT}/cmdline-tools/${CMDLINE_VERSION} && \ 
    rm -v /tmp/tools.zip && \ 
    mkdir -p ~/.android/ && touch ~/.android/repositories.cfg && \ 
    yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses && \ 
    sdkmanager --sdk_root="${ANDROID_SDK_ROOT}" --install "platform-tools" "extras;google;instantapps" && \
    sdkmanager --sdk_root="${ANDROID_SDK_ROOT}" --install "build-tools;${BUILD_TOOLS}" "platforms;android-${TARGET_SDK}" && \
    sdkmanager --sdk_root="${ANDROID_SDK_ROOT}" --uninstall emulator

ENV PATH $PATH:${ANDROID_SDK_ROOT}/build-tools/${BUILD_TOOLS}
COPY ./extras /bin

WORKDIR /home/android
CMD ["/bin/bash"]

