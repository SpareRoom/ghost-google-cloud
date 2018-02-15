FROM ghost:1.21.1

RUN npm install ghost-google-cloud-storage \
	&& mkdir -p /var/lib/ghost/versions/$(ls /var/lib/ghost/versions/)/core/server/adapters/storage/gcloud

ADD ./storage.js /var/lib/ghost/versions/$(ls /var/lib/ghost/versions/)/core/server/adapters/storage/gcloud/index.js
