#!/bin/bash

if [ -f /.rabbitmq_config_initialized ]; then
    echo "RabbitMQ password already set!"
    exit 0
fi

PASS=${RABBITMQ_PASS:-$(pwgen -s 12 1)}
USER=${RABBITMQ_USER:-"admin"}
_word=$( [ ${RABBITMQ_PASS} ] && echo "preset" || echo "random" )
echo "=> Securing RabbitMQ with a ${_word} password"

sed -i 's~{default_user}~'"$USER"'~' /etc/rabbitmq/rabbitmq.config
sed -i 's~{default_pass}~'"$PASS"'~' /etc/rabbitmq/rabbitmq.config

echo "=> Done!"

echo "========================================================================"
echo "You can now connect to this RabbitMQ server using, for example:"
echo ""
echo "    curl --user $USER:$PASS http://<host>:<port>/api/vhosts"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "========================================================================"

config-service-set "${SERVER_NAME}_adminUser"     "$USER"
config-service-set "${SERVER_NAME}_adminPassword" "$PASS"
