FROM alpine:3.15.0

ARG GIT_REPO=https://github.com/1241577140/mynote.git
ARG USER=1241577140%40qq.com
ARG PASSWORD=sunmeng0727
RUN crond
RUN apk add git 
RUN git clone  ${GIT_REPO:0:8}${USER}:${PASSWORD}@${GIT_REPO:8} /usr/src/mynote  
RUN chmod +x /usr/src/mynote/sync.sh \
    && echo "* * * * * ./usr/src/mynote/sync.sh" >> /var/spool/cron/crontabs/root \
    && crond 
WORKDIR /usr/src/mynote
ENTRYPOINT [ "init" ]

