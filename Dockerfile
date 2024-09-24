FROM jenkins/jenkins:lts

USER root

RUN apt-get update \
    # Install rsync
    && apt-get install -y --no-install-recommends rsync \
    # Install jq
    && apt-get install -y --no-install-recommends jq \
    # Install awscli
    && apt-get install -y --no-install-recommends awscli \
    # Install unbuffer
    && apt-get install -y --no-install-recommends expect \
    # Install mysql client
    && apt-get install -y --no-install-recommends mariadb-client \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER jenkins
