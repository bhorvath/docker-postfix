# docker-postfix

A container running Postfix with secure default settings. By default, unauthenticate delivery is only available on port 25 and authenticated delivery is only available on port 587.

## Build instructions

Build the docker image locally:
```
cd docker-postfix
docker build -t postfix .
```

## Running the container

Create and run the container with the following command:
```
docker run --name postfix -d -v /etc/postfix:/etc/postfix -v /var/spool/postfix:/var/spool/postfix -v /path/to/tls/files:/tls -e MAIL_DOMAIN=foo.com -e TLS_CERT_FILE=/tls/cert.pem -e TLS_KEY_FILE=/tls/key.pem -p 25:25/tcp -p 587:587/tcp postfix
```
The configuration and spool directories are persisted as volumes. The TLS key and certificate should also be made available to the container.

The container requires several environment variables to be set to initialisation. These are described further in the next section.

## Environment variables

The configuration files cannot be built unless the following environment variables have been set.

Variable      | Description
--------      | -----------
MAIL_DOMAIN   | The domain for which Postfix will be handling mail
TLS_CERT_FILE | The path to the TLS certificate (this path must be accessible within the container)
TLS_KEY_FILE  | The path to the TLS key (this path must be accessible within the container)
RELAY_HOST    | The relay host through which to send outgoing mail

## Notes

This image uses Dovecot for SASL authentication and final delivery. The default locations are `private/auth` for the authentication and `private/dovecot-lmtp` for devivery. Make sure this has been configured in your instance of Dovecot.
