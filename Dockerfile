FROM ghost:1.25.5

ADD ./storage.js /tmp/storage.js

RUN npm install ghost-google-cloud-storage \
	&& mkdir -p /var/lib/ghost/versions/$(ls /var/lib/ghost/versions/)/core/server/adapters/storage/gcloud \
	&& mv /tmp/storage.js /var/lib/ghost/versions/$(ls /var/lib/ghost/versions/)/core/server/adapters/storage/gcloud/index.js

ADD ./storage-patch.js /var/lib/ghost/node_modules/ghost-google-cloud-storage/index.js
ADD ./slack.js /var/lib/ghost/current/core/server/services/slack.js
