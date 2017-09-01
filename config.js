var path = require('path'),
    config;

config = {
    // ### Production
    // When running Ghost in the wild, use the production environment.
    // Configure your URL and mail settings here
    production: {
        url: 'http://blog.example.com',
        server: {
            host: '0.0.0.0',
            port: '2368'
        },
        paths: {
            contentPath: path.join(__dirname, '/content/')
        },
        database: {
            client: 'sqlite3',
            connection: {
                filename: '/usr/src/ghost/content/data/ghost-dev.db'
            },
            debug: false
        }
    }
};

module.exports = config;
