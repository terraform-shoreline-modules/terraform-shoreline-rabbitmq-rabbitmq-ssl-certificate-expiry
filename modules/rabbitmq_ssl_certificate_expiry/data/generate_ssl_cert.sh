bash

#!/bin/bash



# Set variables

CERT_NAME=${NEW_CERTIFICATE_NAME}

CERT_EXPIRY=${NEW_CERTIFICATE_EXPIRY}

RABBITMQ_CONFIG=${RABBITMQ_CONFIG_FILE}



# Generate new SSL certificate

openssl req -newkey rsa:2048 -nodes -keyout $CERT_NAME.key \

    -x509 -days $CERT_EXPIRY -out $CERT_NAME.crt



# Update RabbitMQ configuration

sudo sed -i "s/ssl_certfile.*/ssl_certfile = \/path\/to\/$CERT_NAME.crt/" $RABBITMQ_CONFIG

sudo sed -i "s/ssl_keyfile.*/ssl_keyfile = \/path\/to\/$CERT_NAME.key/" $RABBITMQ_CONFIG



# Restart RabbitMQ service

sudo systemctl restart rabbitmq-server