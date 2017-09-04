FROM node:6

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user

ENV GOSU_VERSION 1.7
RUN set -x \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true

ENV GHOST_SOURCE /usr/src/ghost
WORKDIR $GHOST_SOURCE

ENV GHOST_VERSION 0.11.10

RUN set -ex; \
	\
	buildDeps=' \
		gcc \
		make \
		python \
		unzip \
	'; \
	apt-get update; \
	apt-get install -y $buildDeps --no-install-recommends; \
	rm -rf /var/lib/apt/lists/*; \
	\
	wget -O ghost.zip "https://github.com/TryGhost/Ghost/releases/download/${GHOST_VERSION}/Ghost-${GHOST_VERSION}.zip"; \
	unzip ghost.zip; \
	\
	npm install --production; \
	\
	rm ghost.zip;

ENV GHOST_CONTENT /var/lib/ghost

COPY config.js /config.js

RUN mkdir -p "$GHOST_CONTENT" \
        && chown -R user:user "$GHOST_CONTENT"
VOLUME $GHOST_CONTENT

EXPOSE 2368

WORKDIR /usr/src/ghost/

COPY docker-entrypoint.sh /tmp/entrypoint.sh
RUN mv /tmp/entrypoint.sh /entrypoint.sh \
  && chown user /entrypoint.sh \
  && chmod u+x /entrypoint.sh \
  && mkdir -p /usr/src/ghost/content/storage \
  && npm i ghost-google-cloud-storage

WORKDIR /usr/src/ghost/content/storage/gcloud

RUN  cp -r /usr/src/ghost/node_modules/ghost-google-cloud-storage/* /usr/src/ghost/content/storage/gcloud \
    && npm install gcloud util bluebird \
	&& chmod a+x /usr/src/ghost/core/server/storage \
    && chmod a+rwx /usr/src/ghost/core/server/data \
    && chmod a+x /usr/src/ghost/core/server/storage/base.js \
    && chown -R root:root /usr/src/ghost/

COPY storage.js /usr/src/ghost/content/storage/gcloud/index.js

WORKDIR /usr/src/ghost/

ENTRYPOINT ["/entrypoint.sh"]

CMD ["npm", "start", "--production"]
