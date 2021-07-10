FROM rabbitmq:3.8-management
RUN rabbitmq-plugins enable --offline rabbitmq_mqtt rabbitmq_management rabbitmq_web_mqtt rabbitmq_federation_management

# Define environment variables.
ENV RABBITMQ_USER user
ENV RABBITMQ_PASSWORD password
ENV RABBITMQ_DEFAULT_USER guest
ENV RABBITMQ_DEFAULT_PASS guest
ENV RABBITMQ_PID_FILE /var/lib/rabbitmq/mnesia/rabbitmq

COPY init.sh .
RUN chmod +x init.sh

EXPOSE 5672
EXPOSE 15672

ENTRYPOINT ["/bin/sh", "./init.sh"]