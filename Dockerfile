FROM ghost:1.25.4

ADD ./storage.js /tmp/storage.js

RUN npm install ghost-google-cloud-storage \
	&& mkdir -p /var/lib/ghost/versions/$(ls /var/lib/ghost/versions/)/core/server/adapters/storage/gcloud \
	&& mv /tmp/storage.js /var/lib/ghost/versions/$(ls /var/lib/ghost/versions/)/core/server/adapters/storage/gcloud/index.js
