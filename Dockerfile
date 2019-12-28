FROM mikefarah/yq as yq


# TODO build/have hub pinned 
FROM debian:buster-slim as hub
ARG HUB_VERSION=2.13.0 

RUN apt-get update && apt-get install -y  curl git

RUN curl -L -o hub.tgz https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-amd64-${HUB_VERSION}.tgz
RUN tar  xf hub.tgz && mv hub-linux-amd64-${HUB_VERSION}/bin/hub /usr/local/bin/

FROM debian:buster-slim as base

RUN apt-get update && apt-get install -y  git bash
RUN mkdir =p /root/.ssh && chmod 700 /root/.ssh
RUN ssh-keyscan -H github.com >> ~/.ssh/known_hosts
RUN  git config --global hub.protocol https

COPY --from=hub /usr/local/bin/hub /usr/local/bin/
COPY --from=yq /usr/bin/yq /usr/local/bin/



# RUN apk add --no-cache curl bash git

COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]

