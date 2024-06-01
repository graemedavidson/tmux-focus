FROM ubuntu:jammy-20240427

# https://packages.ubuntu.com/
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential=12.9ubuntu3 \
  ca-certificates=20230311ubuntu0.22.04.1 \
  fzf=0.29.0-1 \
  git=1:2.34.1-1ubuntu1.9 \
  libevent-dev=2.1.12-stable-1build3 \
  libncurses-dev=6.3-2ubuntu0.1 \
  wget=1.21.2-2ubuntu1 \
  bison=2:3.8.2+dfsg-1build1 \
  byacc=1:2.0.20220114-1 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates

# https://github.com/tmux/tmux/releases
ARG TMUX_VERSION=3.4
RUN mkdir /opt/tmux
WORKDIR /opt/tmux
RUN wget --progress=dot:giga https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz && \
  tar xzf tmux-${TMUX_VERSION}.tar.gz
WORKDIR /opt/tmux/tmux-${TMUX_VERSION}

RUN ./configure && \
  make && \
  make install && \
  ln -s /opt/tmux/tmux-${TMUX_VERSION}/tmux /usr/bin/tmux
RUN useradd -ms /bin/bash developer && \
  usermod -aG sudo developer
USER developer
WORKDIR /home/developer

COPY .tmux.conf /home/developer/
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins

ENTRYPOINT ["tmux"]
