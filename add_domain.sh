#! /bin/bash

## todo: 增加 restart dnsmasq
## todo: 增加对 IP 和域名的判断，IP 直接写入 ipset
## todo: 增加对 CUSTOM_FILE 的删除操作

DNSMASQ_FILE="dnsmasq_list.conf"
CUSTOM_FILE="custom_list.conf"
DNS_SERVER="127.0.0.1#5353"
IPSET_NAME="gfwlist"

domain=$1

if [ -z "$domain" ]; then
    echo "ERROR: domain is empty"
    exit 1
fi

isExist=`grep "/.$domain/" "$DNSMASQ_FILE" "$CUSTOM_FILE"`

if [ -n "$isExist" ]; then
    echo "WARN: domain is exist"
    exit 0
fi

echo "server=/.$domain/$DNS_SERVER" >> $CUSTOM_FILE
echo "ipset=/.$domain/$IPSET_NAME" >> $CUSTOM_FILE

echo "restart dnsmasq"

/etc/init.d/dnsmasq restart

if [ $? -eq 0  ]; then
    echo "INFO: success"
else
    echo "ERROR: failed"
    exit 1
fi
