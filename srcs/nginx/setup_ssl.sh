#!/bin/bash

CERT_DIR = "/etc/ssl/certs"
KEY_DIR = "/etc/ssl/private"

CERT_FILE = "$CERT_DIR/server.crt"
KEY_FILE = "$KEY_DIR/server.key" 

if [! -f "$CERT_FILE" ] || [! -f "$KEY_FILE" ]; then

    mkdir -p "$CERT_DIR" "$KEY_DIR"

    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048
        -keyout "$KEY_FILE"
        -out "$CERT_FILE"
        -subj "/CN=localhost" 

fi
