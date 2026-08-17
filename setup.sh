#!/bin/bash
# سكريبت VPN متكامل (v3.4 - مُعدل لضمان التوافق)

GREEN='\033[1;32m'
CYAN='\033[1;36m'
NC='\033[0m'

function setup_sslh() {
    echo -e "${CYAN}جاري إعداد sslh...${NC}"
    apt-get update && apt-get install -y sslh
    echo 'RUN=yes' > /etc/default/sslh
    echo 'DAEMON_OPTS="--user sslh --listen 0.0.0.0:443 --listen 0.0.0.0:80 --ssh 127.0.0.1:143 --openvpn 127.0.0.1:1194 --anyvpn 127.0.0.1:8443"' >> /etc/default/sslh
    systemctl restart sslh
    systemctl enable sslh
    echo -e "${GREEN}تم إعداد sslh.${NC}"
}

function setup_openvpn() {
    echo -e "${CYAN}جاري إعداد OpenVPN...${NC}"
    apt-get install -y openvpn
    echo "port 1194" > /etc/openvpn/server.conf
    echo "proto tcp" >> /etc/openvpn/server.conf
    echo "dev tun" >> /etc/openvpn/server.conf
    systemctl enable openvpn@server
    systemctl start openvpn@server
}

function create_xray_user() {
    clear
    read -p "أدخل اسم العميل: " client_name
    new_uuid=$(cat /proc/sys/kernel/random/uuid)
    mkdir -p /usr/local/etc/xray/
    echo '{' > /usr/local/etc/xray/config.json
    echo '  "inbounds": [' >> /usr/local/etc/xray/config.json
    echo '    { "port": 8443, "protocol": "vless", "settings": { "clients": [ { "id": "'"$new_uuid"'" } ], "decryption": "none" }, "streamSettings": { "network": "ws", "wsSettings": { "path": "/vless" } } }' >> /usr/local/etc/xray/config.json
    echo '  ],' >> /usr/local/etc/xray/config.json
    echo '  "outbounds": [ { "protocol": "freedom" } ]' >> /usr/local/etc/xray/config.json
    echo '}' >> /usr/local/etc/xray/config.json
    systemctl restart xray
    echo -e "${GREEN}تم إنشاء المستخدم: $new_uuid${NC}"
    sleep 3
}

function install_all_services() {
    apt-get update -y && apt-get install -y python3 openvpn dropbear curl sslh
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
    setup_openvpn
    setup_sslh
    echo -e "${GREEN}تم التثبيت بنجاح!${NC}"
}

while true; do
    clear
    echo "مدير VPN المتكامل (V3.4)"
    echo "1. تثبيت الكل"
    echo "2. إنشاء حساب Xray"
    echo "0. خروج"
    read -p "اختر: " choice
    case $choice in
        1) install_all_services ;;
        2) create_xray_user ;;
        0) exit 0 ;;
    esac
done
