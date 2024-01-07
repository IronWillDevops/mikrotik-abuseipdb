#!/bin/bash

# Set the path for the application
PATHAPP=/etc/ITkha/mikrotik-abuseipdb

# Source the configuration file
source $PATHAPP/config.cfg.local
source $PATHAPP/config.cfg

SEND_TO_ABUSEIPDB=""
IPList=$(bash $PATHAPP/scripts/get_block_lish.sh)
old_list=""


# Проверка существования предыдущего списка
if [ -e "$PREVIOUS_BLOCKLIST_PATH" ]; then
old_list=$(<"$PREVIOUS_BLOCKLIST_PATH")

# Цикл для проверки каждого адреса в IPList
while IFS= read -r ip_address; do
    # Проверка, есть ли адрес в файле
    if ! grep -q "$ip_address" <<< "$old_list"; then
        # Добавление адреса в List1, если его нет в файле
        SEND_TO_ABUSEIPDB="$SEND_TO_ABUSEIPDB$ip_address"$'\n'
    fi
done <<< "$IPList"



else
SEND_TO_ABUSEIPDB=$IPList

fi
echo "$IPList" > $PREVIOUS_BLOCKLIST_PATH


echo -n "$SEND_TO_ABUSEIPDB" | while IFS= read -r ip; do
   sudo bash $PATHAPP/scripts/register_ip.sh $ip
done
