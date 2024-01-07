#!/bin/bash
# Set the path for the application
PATHAPP=/etc/ITkha/mikrotik-abuseipdb

# Source the configuration file
source $PATHAPP/config.cfg.local
source $PATHAPP/config.cfg

IPList=$(sshpass -p "$MIKROTIK_PASS" ssh -o StrictHostKeyChecking=no $MIKROTIK_USER@$MIKROTIK_HOST "/ip firewall address-list print where list=\"$MIKROTIK_BLOCKLIST\"" | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b')

# Вывод списка IP-адресов
echo "$IPList"
