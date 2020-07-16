FROM debian

ARG GH_RUNNER_VERSION="2.267.1"

# docker
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt-get update && apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io

# docker-compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# gh-runner
WORKDIR /runner
RUN curl -L https://github.com/actions/runner/releases/download/v${GH_RUNNER_VERSION}/actions-runner-linux-x64-${GH_RUNNER_VERSION}.tar.gz > runner.tar.gz
RUN tar xzf runner.tar.gz
RUN rm -f runner.tar.gz

COPY ./bin/start ./start
CMD ["./start"]
