#!/bin/bash

set -m

if [ ! -f /.rabbitmq_config_initialized ]; then
    /set_rabbitmq_password.sh
    touch /.rabbitmq_config_initialized

    mkdir -p /etc/rabbitmq/certs
    echo "$RABBITMQ_SSL_CERT" > /etc/rabbitmq/certs/cert.pem
    echo "$RABBITMQ_SSL_KEY" > /etc/rabbitmq/certs/key.pem
    echo "$RABBITMQ_SSL_CACERT" > /etc/rabbitmq/certs/cacert.pem
fi

# register current IP address into config-service
config-service-set "${SERVER_NAME}_host" "$HOST_IPV4_ADDRESS"
config-service-set "${SERVER_NAME}_hostPublic" "$HOST_PUBLIC_IPV4_ADDRESS"
config-service-set "${SERVER_NAME}_hostPrivate" "$CONTAINER_IPV4_ADDRESS"
config-service-set "${SERVER_NAME}_port" "5672"
config-service-set "${SERVER_NAME}_portManagement" "15672"
config-service-set "${SERVER_NAME}_portWebStomp" "15674"
config-service-set "${SERVER_NAME}_portWebStompSsl" "15671"

# make rabbit own its own files
chown -R rabbitmq:rabbitmq /var/lib/rabbitmq

if [ -z "$CLUSTER_WITH" ] ; then
    /usr/sbin/rabbitmq-server
else
    if [ -f /.CLUSTERED ] ; then
    /usr/sbin/rabbitmq-server
    else
        touch /.CLUSTERED
        /usr/sbin/rabbitmq-server &
        sleep 10
        rabbitmqctl stop_app
        rabbitmqctl join_cluster rabbit@$CLUSTER_WITH
        rabbitmqctl start_app
        fg
    fi
fi
