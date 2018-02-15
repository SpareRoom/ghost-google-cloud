FROM ghost:1.21.1

ADD ./storage.js /tmp/storage.js

RUN npm install ghost-google-cloud-storage \
	&& mkdir -p /var/lib/ghost/versions/$(ls /var/lib/ghost/versions/)/core/server/adapters/storage/gcloud \
	&& mv /tmp/storage.js /var/lib/ghost/versions/$(ls /var/lib/ghost/versions/)/core/server/adapters/storage/gcloud/index.js
