ARG IMAGE="quay.io/cloudnativetoolkit/cli-tools-core:fedora"
FROM ${IMAGE}

USER root

# Adapted from https://github.com/bbrowning/github-runner/blob/master/Dockerfile
RUN dnf -y upgrade --security && \
    dnf -y install \
        curl \
        git \
        jq \
        hostname \
        procps \
        findutils \
        which \
        openssl && \
    dnf clean all

# The UID env var should be used in child Containerfile.
ENV UID=1000
ENV GID=0
ENV USERNAME="runner"

# Create our user and their home directory
RUN useradd -m $USERNAME -u $UID && \
    usermod -G 0 $USERNAME

ENV HOME=/home/${USERNAME}

WORKDIR /home/${USERNAME}

# Override these when creating the container.
ENV GITHUB_PAT ""
ENV GITHUB_APP_ID ""
ENV GITHUB_APP_INSTALL_ID ""
ENV GITHUB_APP_PEM ""
ENV GITHUB_OWNER ""
ENV GITHUB_REPOSITORY ""
ENV RUNNER_WORKDIR /home/${USERNAME}/_work
ENV RUNNER_GROUP ""
ENV RUNNER_LABELS ""
ENV EPHEMERAL ""

# Allow group 0 to modify these /etc/ files since on openshift, the dynamically-assigned user is always part of group 0.
# Also see ./uid.sh for the usage of these permissions.
COPY --chown=${USERNAME}:0 get-runner-release.sh ./

RUN chmod g+w /etc/passwd && \
    touch /etc/sub{g,u}id && \
    chmod -v ug+rw /etc/sub{g,u}id && \
    ./get-runner-release.sh && \
    ./bin/installdependencies.sh && \
    chown -R ${USERNAME}:0 /home/${USERNAME}/ && \
    chgrp -R 0 /home/${USERNAME}/ && \
    chmod -R g=u /home/${USERNAME}/

COPY --chown=${USERNAME}:0 entrypoint.sh uid.sh register.sh get_github_app_token.sh ./

USER $USERNAME

ENTRYPOINT ["./entrypoint.sh"]
