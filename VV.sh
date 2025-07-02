#!/bin/bash

set -e

# 1. إعدادات أساسية
username="lveuia"
password="2zs"
hostname="lveunix"

echo "[*] إضافة المستخدم $username بكلمة مرور $password ..."
useradd -m -G wheel -s /bin/bash "$username"
echo "$username:$password" | chpasswd

# 2. تفعيل sudo للمجموعة wheel
echo "[*] تفعيل صلاحيات sudo ..."
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# 3. تغيير اسم النظام
echo "[*] تغيير اسم النظام إلى $hostname ..."
echo "$hostname" > /etc/hostname
sed -i "s/127.0.1.1.*/127.0.1.1\t$hostname.localdomain\t$hostname/" /etc/hosts
echo "Welcome to $hostname OS" > /etc/issue

cat > /etc/os-release <<EOF
NAME="$hostname Linux"
PRETTY_NAME="$hostname OS"
ID=$hostname
EOF

# 4. تخصيص الطرفية (bash prompt)
echo "[*] تخصيص الطرفية للمستخدم root و $username ..."

# root prompt (أحمر)
echo 'PS1="\e[1;31m\u@\h \w \$\e[0m "' >> /root/.bashrc

# user prompt (أزرق)
mkdir -p /home/$username
echo 'PS1="\e[1;34m\u@\h \w \$\e[0m "' >> /home/$username/.bashrc
chown $username:$username /home/$username/.bashrc

# 5. تثبيت الواجهة الرسومية (XFCE شبيهة كالي)
echo "[*] تثبيت XFCE والبرامج الأساسية ..."
pacman -Sy --noconfirm xorg xorg-xinit xfce4 xfce4-goodies lightdm lightdm-gtk-greeter network-manager-applet

# 6. تفعيل مدير العرض lightdm
systemctl enable lightdm

# 7. تحسين الأداء والتجربة
echo "[*] تثبيت أدوات دعم الأداء وتجربة المستخدم ..."
pacman -S --noconfirm gvfs gvfs-smb thunar-archive-plugin file-roller firefox ttf-dejavu ttf-liberation

# 8. خلفية مخصصة + اسم النظام يظهر عند الإقلاع
echo "[*] تخصيص اسم النظام في motd وملف الإقلاع ..."
echo "WELCOME TO $hostname OS" > /etc/motd

# لتغيير اسم GRUB (لو مثبت grub)
if [ -f /etc/default/grub ]; then
    sed -i "s/GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR=\"$hostname\"/" /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg
fi

# 9. تثبيت الخط المشابه لكالي
pacman -S --noconfirm ttf-ubuntu-font-family

echo "[✓] تم الإنتهاء من بناء نظام $hostname بنجاح!"
echo "⚠️ أعد التشغيل الآن لتجربة النظام الرسومي الجديد."