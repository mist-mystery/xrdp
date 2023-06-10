FROM ubuntu:22.04
ARG RDPUSER=user
ARG RDPPASS=pass
EXPOSE 3389

# repository locale: Japan
RUN sed -i -e 's/archive/jp.archive/g' /etc/apt/sources.list

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    dbus-x11 \
    fonts-noto-cjk \
    ibus-mozc \
    language-pack-ja \
    lxde \
    mozc-utils-gui \
    xrdp \
    wget \
  && apt-get purge -y firefox \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /etc/apt/keyrings \
  && wget -O /etc/apt/keyrings/firefox-esr.asc \
    "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x0ab215679c571d1c8325275b9bdb3d89ce49ec21" \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/firefox-esr.asc] " \
    "https://ppa.launchpadcontent.net/mozillateam/ppa/ubuntu $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/firefox-esr.list \
  && apt-get update \
  && apt-get install -y \
    $(check-language-support -l ja) \
    firefox-esr \
  && apt-get install -y --no-install-recommends \
    init \
    sudo \
    vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && echo 'Asia/Tokyo' > /etc/timezone \
  && locale-gen ja_JP.UTF-8 \
  && update-locale LANG=ja_JP.UTF-8 LANGUAGE=ja_JP:ja

RUN useradd -m $RDPUSER \
  && echo "${RDPUSER} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${RDPUSER}" \
  && chsh -s /bin/bash $RDPUSER \
  && echo "${RDPUSER}:${RDPPASS}" | chpasswd

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

USER $RDPUSER
RUN echo "startlxde" > ~/.xsession

