FROM jenkins/jenkins:lts

USER root

RUN apt-get update \
    # Install rsync
    && apt-get install -y --no-install-recommends rsync \
    # Install jq
    && apt-get install -y --no-install-recommends jq \
    # Install awscli
    && apt-get install -y --no-install-recommends awscli less curl \
    && ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ]; then \
        curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb"; \
    elif [ "$ARCH" = "arm64" ]; then \
        curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_arm64/session-manager-plugin.deb" -o "/tmp/session-manager-plugin.deb"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi \
    && dpkg -i /tmp/session-manager-plugin.deb \
    && rm /tmp/session-manager-plugin.deb \
    # Install ansible
    && apt-get install -y --no-install-recommends ansible \
    # Install expect (unbuffer)
    && apt-get install -y --no-install-recommends expect \
    # Install mysql client
    && apt-get install -y --no-install-recommends mariadb-client \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER jenkins
