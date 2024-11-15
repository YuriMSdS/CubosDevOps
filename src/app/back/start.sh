#!/bin/bash
systemctl enable nginx

chmod +x /usr/src/app/wait-for-db.sh

/usr/src/app/wait-for-db.sh db 5432 ${POSTGRESQL_USERNAME} ${POSTGRESQL_PASSWORD} ${DATABASE_NAME}

node /usr/src/app/script.js

