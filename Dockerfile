FROM ubuntu:latest

ENV PORT=4200 \
    SIAB_USERCSS="Normal:+/etc/shellinabox/options-enabled/00+Black-on-White.css,Reverse:-/etc/shellinabox/options-enabled/00_White-On-Black.css;Colors:+/etc/shellinabox/options-enabled/01+Color-Terminal.css,Monochrome:-/etc/shellinabox/options-enabled/01_Monochrome.css" \
    SIAB_USER=guest \
    SIAB_USERID=1000 \
    SIAB_GROUP=guest \
    SIAB_GROUPID=1000 \
    SIAB_PASSWORD=password123 \
    SIAB_SHELL=/bin/bash \
    SIAB_HOME=/home/guest

RUN /usr/sbin/groupadd -r shellinabox && /usr/sbin/useradd -r -g shellinabox shellinabox

RUN apt-get update && apt-get install -y openssl curl openssh-client sudo shellinabox && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    ln -sf '/etc/shellinabox/options-enabled/00+Black on White.css' \
      /etc/shellinabox/options-enabled/00+Black-on-White.css && \
    ln -sf '/etc/shellinabox/options-enabled/00_White On Black.css' \
      /etc/shellinabox/options-enabled/00_White-On-Black.css && \
    ln -sf '/etc/shellinabox/options-enabled/01+Color Terminal.css' \
      /etc/shellinabox/options-enabled/01+Color-Terminal.css

RUN /usr/sbin/groupadd -g $SIAB_GROUPID $SIAB_GROUP && \
    /usr/sbin/useradd -u $SIAB_USERID -g $SIAB_GROUPID -s $SIAB_SHELL -d $SIAB_HOME -m -G sudo $SIAB_USER && \
    echo "$SIAB_USER:$SIAB_PASSWORD" | /usr/sbin/chpasswd && \
    unset SIAB_PASSWORD

EXPOSE $PORT

VOLUME /etc/shellinabox /var/log/supervisor /home

ADD assets/entrypoint.sh /usr/local/sbin/

ENTRYPOINT ["entrypoint.sh"]
CMD ["shellinabox"]
