cat << 'EOF' > README.md
# VPN Manager Pro (v3.3)

أداة متكاملة لإدارة خوادم VPN بنظام احترافي. 

## المميزات:
- **دمج ذكي للمنافذ:** تشغيل (SSH, OpenVPN, Xray) جميعاً خلف المنفذين 80 و 443 باستخدام `sslh`.
- **دعم البروتوكولات:** SSH, OpenVPN (TCP), VLESS (WS).
- **تثبيت سريع:** واجهة تحكم بسيطة لإدارة الخادم.

## طريقة التثبيت:
```bash
wget https://raw.githubusercontent.com/th3fre/MNR-VPS/main/setup.sh && chmod +x setup.sh && ./setup.sh
