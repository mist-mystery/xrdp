FROM ubuntu:22.04
ARG RDPUSER=user
ARG RDPPASS=pass
EXPOSE 3389

# repository locale: Japan
RUN sed -i -e 's/archive/jp.archive/g' /etc/apt/sources.list

# dconf-editor        : dconf設定編集/確認用(option)
# init                : systemdで起動
# fonts-ricty-diminished : 日本語フォント
# ibus-mozc           : 日本語入力用
# ibus-gtk            : 日本語入力用
# ibus-gtk3           : 日本語入力用
# mozc-utils-gui      : mozcをGUIで設定
# language-pack-ja    : 日本語化
# lxde                : デスクトップ環境
# accountsservice     : LightDM で必要（なくても動くけどエラーでる）
# lightdm-gtk-greeter : ディスプレイマネージャ Greeter
# tzdata              : タイムゾーン設定。DEBIAN_FRONTEND=noninteractive が必要
# xrdp                : リモートデスクトップ
# dbus-x11            : xrdpに必要
# xorgxrdp            : xrdpに必要
# vim                 : エディタ
# wget                : firefox-esrのリポジトリ追加に使用
# ca-certificates     : wgetに必要
# pulseaudio          : 音
# pavucontrol         : 音
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    accountsservice \
    ca-certificates \
    dbus-x11 \
    fonts-ricty-diminished \
    ibus-gtk \
    ibus-gtk3 \
    ibus-mozc \
    init \
    language-pack-ja \
    lightdm-gtk-greeter \
    lxde \
    lxtask \
    mozc-utils-gui \
    pavucontrol \
    pulseaudio \
    sudo \
    tzdata \
    xorgxrdp \
    xrdp \
    vim \
    wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

#RUN apt-get update \
#  && apt-get install -y --no-install-recommends $(check-language-support -l ja) \
#  && apt-get clean \
#  && rm -rf /var/lib/apt/lists/*

# firefox-esrのinstall
RUN mkdir -p /etc/apt/keyrings \
  && wget -O /etc/apt/keyrings/firefox-esr.asc \
    'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x0ab215679c571d1c8325275b9bdb3d89ce49ec21' \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/firefox-esr.asc] " \
    "https://ppa.launchpadcontent.net/mozillateam/ppa/ubuntu $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/firefox-esr.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends firefox-esr \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# ロケール設定
RUN ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && echo 'Asia/Tokyo' > /etc/timezone \
  && locale-gen ja_JP.UTF-8 \
  && update-locale LANG=ja_JP.UTF-8 LANGUAGE=ja_JP:ja

# RDPUSER追加
RUN useradd -m $RDPUSER \
  && echo "${RDPUSER} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${RDPUSER}" \
  && chsh -s /bin/bash $RDPUSER \
  && echo "${RDPUSER}:${RDPPASS}" | chpasswd

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod u+x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

USER $RDPUSER
RUN { \
	# ibus起動時にmozcを使用
#	echo "dconf write /desktop/ibus/general/preload-engines \"['mozc-jp']\""; \
	# ibus用の環境変数
	echo "export GTK_IM_MODULE=ibus XMODIFIERS=@im=ibus QT_IM_MODULE=ibus"; \
	# ibus起動
 	echo "ibus-daemon -d"; \
	echo "startlxde"; \
} > /home/${RDPUSER}/.xsession

# root でないと /sbin/init init でsystemd起動出来ないみたいなのでrootに戻す
USER root

