#!/bin/bash

-------------- معلومات النظام ---------------

USERNAME="lveuia" PASSWORD="2zs" SYSTEM_NAME="EREBUX"

-------------- تحديث النظام ---------------

echo -e "\e[91m[+] Updating system...\e[0m" pacman -Sy --noconfirm

-------------- إنشاء المستخدم ---------------

echo -e "\e[91m[+] Creating user: $USERNAME\e[0m" useradd -m -G wheel -s /bin/bash "$USERNAME" echo "$USERNAME:$PASSWORD" | chpasswd echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

-------------- تثبيت أدوات أساسية ---------------

echo -e "\e[91m[+] Installing basic tools...\e[0m" pacman -S --noconfirm neofetch figlet lolcat bash-completion

-------------- إعداد التيرمنال للمستخدم الجديد ---------------

echo -e "\e[91m[+] Customizing terminal...\e[0m" cat << 'EOF' >> /home/$USERNAME/.bashrc

شعار النظام عند كل تشغيل

clear figlet -f bloody "$SYSTEM_NAME" | lolcat

واجهة تسجيل دخول

while true; do clear echo -e "\e[31m" echo "      ██████████████████████████████████" echo "      █─▄─▄─█▄─▀█▄─▄█▄─▄▄─█─▄─▄─█▄─▄▄─█" echo "      ███─████─█▄▀─███─▄█▀███─████─▄█▀█" echo "      ▀▀▄▄▄▀▀▄▄▄▀▀▄▄▀▄▄▄▄▄▀▀▄▄▄▀▀▄▄▄▄▄▀" echo "      █     E R E B U X   S Y S T E M   █" echo "      ██████████████████████████████████" echo -e "\e[0m"

read -p $'\e[91m[LOGIN]\e[0m Username: ' u read -sp $'\e[91m[LOGIN]\e[0m Password: ' p echo

if [[ "$u" == "$USERNAME" && "$p" == "$PASSWORD" ]]; then for i in {1..5}; do echo -e "\e[91m[+] Access Granted - Loading █${i}█\e[0m" sleep 0.3 done break else echo -e "\e[91m[-] Access Denied\e[0m" sleep 1 fi done

تغيير موجه التيرمنال ليكون فقط $

export PS1='$ '

EOF

-------------- تعديل الأذونات ---------------

chown -R $USERNAME:$USERNAME /home/$USERNAME

-------------- إنهاء ---------------

echo -e "\e[92m[✓] System is ready. Login as $USERNAME and enjoy EREBUX.\e[0m"

