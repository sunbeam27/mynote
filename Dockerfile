FROM alpine:3.15.0

ARG GIT_REPO=https://github.com/1241577140/mynote.git
ARG USER=1241577140%40qq.com
ARG PASSWORD=password
RUN crond
RUN apk add git 
RUN git clone  ${GIT_REPO:0:8}${USER}:${PASSWORD}@${GIT_REPO:8} /usr/src/mynote  
RUN chmod +x /usr/src/mynote/sync.sh \
    && echo "0 * * * * ./usr/src/mynote/sync.sh" >> /var/spool/cron/crontabs/root \ 
WORKDIR /usr/src/mynote
CMD [ "crond " ]
ENTRYPOINT [ "init" ]
