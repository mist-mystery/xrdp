FROM ubuntu:22.04
ARG RDPUSER=user
ARG RDPPASS=pass
EXPOSE 3389

# repository locale: Japan
RUN sed -i -e 's/archive/jp.archive/g' /etc/apt/sources.list

# DEBIAN_FRONTEND=noninteractive が必要ならつける
RUN apt-get update \
  && apt-get install -y --no-install-recommends init gosu sudo \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -m $RDPUSER \
  && echo "${RDPUSER} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${RDPUSER}" \
  && chsh -s /bin/bash $RDPUSER \
  && echo "${RDPUSER}:${RDPPASS}" | chpasswd

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod u+x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

