var path = require('path'),
    config;

config = {
    // ### Production
    // When running Ghost in the wild, use the production environment.
    // Configure your URL and mail settings here
    production: {
        url: 'GHOST_URL',
        mail: {
            from: 'GHOST_EMAIL_FROM',
            transport: 'SES',
            options: {
                region: "GHOST_EMAIL_REGION",
                AWSAccessKeyID: "GHOST_EMAIL_KEY",
                AWSSecretKey: "GHOST_EMAIL_SECRET"
            }
        },
        database: {
            client: 'mysql',
            connection: {
                host: 'GHOST_DB_HOST',
                user: 'GHOST_USER',
                password: 'GHOST_PASSWORD',
                database: 'GHOST_DB',
                charset: 'utf8'
            }
        },
        storage: {
            active: 'gcloud',
            'gcloud': {
                projectId: 'GHOST_ASSETS_PROJECT',
                key: '/secrets/cloudstorage/credentials.json',
                bucket: 'GHOST_ASSETS_BUCKET'
            }
        },
        server: {
            host: '0.0.0.0',
            port: '2368'
        },
        paths: {
            contentPath: path.join(__dirname, '/content/')
        }
    }
};

module.exports = config;
