FROM tpill90/steam-lancache-prefill:latest

RUN set -x &&\
    apt update &&\
    apt install -qq -y cron

ARG FILE=/etc/cron.d/prefill-cron
RUN touch ${FILE} &&\
    chmod 0644 ${FILE}

RUN echo "0 4 * * * /SteamPrefill prefill > /proc/1/fd/1 2>/proc/1/fd/2" >> ${FILE} &&\
    echo "@reboot /SteamPrefill prefill > /proc/1/fd/1 2>/proc/1/fd/2" >> ${FILE} &&\
    echo "# last line required for value cron file" >> ${FILE}

RUN crontab ${FILE}

ENTRYPOINT [ "cron", "-f", "-l", "1" ]