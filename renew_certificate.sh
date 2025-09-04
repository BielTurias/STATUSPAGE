#!/bin/bash
systemctl stop nginx
# Ruta de los certificados
CERT="/etc/letsencrypt/live/statuspage.d01.cloud/fullchain.pem"
PRIV_KEY="/etc/letsencrypt/live/statuspage.d01.cloud/privkey.pem"

# Backup de la fecha de modificación original
ORIGINAL_CERT_DATE=$(stat -c %Y "$CERT")

# Renovar el certificado (sin interacción y aceptando los términos)
sudo certbot certonly --dns-route53 -d statuspage.d01.cloud --non-interactive --agree-tos

# Verificar si el certificado se ha renovado (compara las fechas)
NEW_CERT_DATE=$(stat -c %Y "$CERT")

if [ "$ORIGINAL_CERT_DATE" != "$NEW_CERT_DATE" ]; then
    # Si la fecha del certificado ha cambiado, significa que se renovó  DEST="/etc/letsencrypt/live/statuspage.d01.cloud/"

    echo "Recreating the certificates in /etc/letsencrypt/live/statuspage.d01.cloud/ ..."
    cp "$CERT" "$DEST/tls-certificate.pem"
    cp "$PRIV_KEY" "$DEST/tls-key.pem"

    sleep 5

    echo "Restarting docker web-server ..."
    docker restart  statuspage_statuspage_1

    sleep 5
    echo "Done, SSL certificates renewed ..."
else
    echo "No renewal needed. Certificate is still valid."
fi
systemctl start nginx
