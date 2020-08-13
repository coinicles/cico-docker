FROM ubuntu
MAINTAINER pandazwb

RUN set -ex \
    && apt-get update \
    && apt-get install -y -qq --no-install-recommends ca-certificates curl wget apt-utils jq

# install cico binaries
RUN set -ex \
    && echo `curl -s https://api.github.com/repos/coinicles/cico/releases/latest | jq -r ".assets[] | select(.name | test(\"x86_64-linux-gnu.tar.gz\")) | .browser_download_url"` > /tmp/cico_url \
    && CICO_URL=`cat /tmp/cico_url` \
    && CICO_DIST=$(basename $CICO_URL) \
    && wget -O $CICO_DIST $CICO_URL \
	&& tar -xzvf $CICO_DIST -C /usr/local --strip-components=1 \
	&& rm /tmp/cico*

# create data directory
ENV CICO_DATA /data
RUN mkdir $CICO_DATA \
	&& ln -sfn $CICO_DATA /root/.cico \
VOLUME /data

EXPOSE 38880 38890 23888 23889
CMD ["cicod"]
