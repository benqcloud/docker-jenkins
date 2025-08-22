FROM jenkins/jenkins:lts-jdk21

USER root

RUN apt-get update \
    # Install rsync
    && apt-get install -y --no-install-recommends rsync \
    # Install jq
    && apt-get install -y --no-install-recommends jq \
    # Install awscli & amazon-ecr-credential-helper
    && apt-get install -y --no-install-recommends awscli less curl amazon-ecr-credential-helper \
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
    # Install zip unzip
    && apt-get install -y --no-install-recommends zip unzip \
    # Install docker-ce-cli
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends docker-ce-cli \
    # Install docker-compose-plugin
    && apt-get install -y --no-install-recommends docker-compose-plugin \
    # Clean
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER jenkins
