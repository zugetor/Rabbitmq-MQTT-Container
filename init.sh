#!/bin/sh
# Create Rabbitmq user
( rabbitmqctl wait --quiet --timeout 30 $RABBITMQ_PID_FILE > /dev/null ; \
rabbitmqctl add_user $RABBITMQ_USER $RABBITMQ_PASSWORD > /dev/null ; \
rabbitmqctl set_permissions -p / $RABBITMQ_USER  ".*" ".*" ".*" > /dev/null ; \
# Create Rabbitmq admin
rabbitmqctl add_user $RABBITMQ_DEFAULT_USER $RABBITMQ_DEFAULT_PASS >/dev/null ; \
rabbitmqctl set_user_tags $RABBITMQ_DEFAULT_USER administrator > /dev/null ; \
rabbitmqctl set_permissions -p / $RABBITMQ_DEFAULT_USER  ".*" ".*" ".*" > /dev/null ; \
rabbitmqadmin declare queue --vhost="/" name="mqtt_data" durable=true auto_delete=false arguments={\"x-queue-type\":\"classic\"} --username=$RABBITMQ_DEFAULT_USER --password=$RABBITMQ_DEFAULT_PASS > /dev/null ; \
rabbitmqadmin --vhost="/" declare binding source="amq.topic" destination_type="queue" destination="mqtt_data" routing_key="#" --username=$RABBITMQ_DEFAULT_USER --password=$RABBITMQ_DEFAULT_PASS > /dev/null ; \
echo "*** User '$RABBITMQ_USER' with password '$RABBITMQ_PASSWORD' completed. ***" ; \
echo "*** Log in the WebUI at port 15672 (example: http:/localhost:15672) ***") &

# $@ is used to pass arguments to the rabbitmq-server command.
# For example if you use it like this: docker run -d rabbitmq arg1 arg2,
# it will be as you run in the container rabbitmq-server arg1 arg2
rabbitmq-server $@