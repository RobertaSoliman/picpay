#!/bin/bash

MONGODB_ADMIN_USER=${MONGODB_ADMIN_USER:-"admin"}
MONGODB_ADMIN_PASS=${MONGODB_ADMIN_PASS:-"admin"}

MONGODB_APPLICATION_DATABASE=${MONGODB_APPLICATION_DATABASE:-"picpay_db"}
MONGODB_APPLICATION_USER=${MONGODB_APPLICATION_USER:-"picpay"}
MONGODB_APPLICATION_PASS=${MONGODB_APPLICATION_PASS:-"admin"}

while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup..."
    sleep 5
    mongo admin --eval "help" >/dev/null 2>&1
    RET=$?
done

echo "=> Creating admin user with a password in MongoDB"
mongo admin --eval "db.createUser({user: '$MONGODB_ADMIN_USER', pwd: '$MONGODB_ADMIN_PASS', roles:[{role:'root',db:'admin'}]});"

sleep 3

if [ "$MONGODB_APPLICATION_DATABASE" != "admin" ]; then
    echo "=> Creating a ${MONGODB_APPLICATION_DATABASE} database user with a password in MongoDB"
    mongo admin -u $MONGODB_ADMIN_USER -p $MONGODB_ADMIN_PASS << EOF
echo "Using $MONGODB_APPLICATION_DATABASE database"
use $MONGODB_APPLICATION_DATABASE
db.createUser({user: '$MONGODB_APPLICATION_USER', pwd: '$MONGODB_APPLICATION_PASS', roles:[{role:'dbOwner', db:'$MONGODB_APPLICATION_DATABASE'}]})
EOF
fi

sleep 1

touch /data/db/.mongodb_password_set

echo "MongoDB configured successfully. You may now connect to the DB."
