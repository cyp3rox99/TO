#!/bin/bash

# تأكد من التشغيل كـ root
if [ "$EUID" -ne 0 ]; then
  echo "🚨 شغل السكربت باستخدام sudo أو root!"
  exit 1
fi

echo "🔧 تحديث النظام..."
pacman -Syu --noconfirm

echo "🔥 إزالة واجهات XFCE والبرامج الرسومية..."
pacman -Rns xfce4 xfce4-goodies xorg xorg-server lightdm lightdm-gtk-greeter gdm sddm plasma kde-applications gnome gnome-extra --noconfirm

echo "🧼 تنظيف الحزم اليتيمة..."
pacman -Rns $(pacman -Qdtq) --noconfirm

echo "📦 تثبيت ly من AUR (يتطلب yay)..."
if ! command -v yay &> /dev/null; then
    echo "🚫 لم يتم العثور على yay! يرجى تثبيته أولاً (sudo pacman -S yay)"
    exit 1
fi
yay -S ly --noconfirm

echo "⚙️ إعداد ly للإقلاع التلقائي..."
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat <<EOF > /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/usr/bin/ly
EOF

echo "🛑 تعطيل مديري العرض الآخرين..."
systemctl disable lightdm.service 2>/dev/null
systemctl disable gdm.service 2>/dev/null
systemctl disable sddm.service 2>/dev/null

echo "🔁 إعادة تهيئة systemd..."
systemctl daemon-reexec
systemctl restart getty@tty1

echo "🎨 تغيير موجه التيرمنال PS1 إلى \$ لجميع المستخدمين..."
for user in $(ls /home); do
    echo "export PS1='\$ '" >> /home/$user/.bashrc
done
echo "export PS1='\$ '" >> /root/.bashrc

echo "✅ تم الانتهاء! أعد تشغيل النظام الآن بـ reboot."