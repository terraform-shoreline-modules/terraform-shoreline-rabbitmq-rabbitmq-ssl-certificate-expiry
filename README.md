
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# RabbitMQ SSL Certificate Expiry
---

This incident type refers to situations where the SSL (Secure Sockets Layer) certificate used by RabbitMQ, a popular open-source message broker software, has expired. This can lead to issues with secure communications and potentially cause disruptions in the messaging system's functionality. It is important to promptly renew the SSL certificate to avoid any negative impact on system performance and security.

### Parameters
```shell
export PATH_TO_CERTIFICATE_FILE="PLACEHOLDER"

export PATH_TO_CA_CERTIFICATES="PLACEHOLDER"

export RABBITMQ_HOST="PLACEHOLDER"

export NEW_CERTIFICATE_EXPIRY="PLACEHOLDER"

export NEW_CERTIFICATE_NAME="PLACEHOLDER"

export RABBITMQ_CONFIG_FILE="PLACEHOLDER"
```

## Debug

### Check for RabbitMQ SSL certificate expiration date
```shell
openssl x509 -enddate -noout -in ${PATH_TO_CERTIFICATE_FILE}
```

### Check RabbitMQ logs for SSL related issues
```shell
journalctl -u rabbitmq-server | grep SSL
```

### Verify RabbitMQ SSL configuration
```shell
rabbitmqctl eval 'ssl:versions().'

rabbitmqctl eval 'ssl:ciphers().'

rabbitmqctl eval 'ssl:versions_fallback().'

rabbitmqctl eval 'ssl:versions_disabled().'
```

### Check RabbitMQ SSL port status
```shell
ss -tulwn | grep 5671
```

### Verify SSL certificate chain
```shell
openssl verify -verbose -CAfile ${PATH_TO_CA_CERTIFICATES} ${PATH_TO_CERTIFICATE_FILE}
```

### Verify SSL connection to RabbitMQ server
```shell
openssl s_client -connect ${RABBITMQ_HOST}:5671
```

## Repair

### Generate a new SSL certificate with a valid expiration date and update it in the RabbitMQ configuration.
```shell
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


```