#!/bin/bash

# تأكد أنك تعمل كـ root
if [[ $EUID -ne 0 ]]; then
  echo "🔴 يجب تشغيل هذا السكربت بصلاحيات root."
  exit 1
fi

# بيانات المستخدم الجديد
NEW_USER="lveuia"
NEW_PASS="2zs"

# إنشاء المستخدم الجديد وإضافة كلمة السر
useradd -m -s /bin/bash "$NEW_USER"
echo "$NEW_USER:$NEW_PASS" | chpasswd

# إضافة sudo إن وجد
if command -v sudo &>/dev/null; then
  usermod -aG wheel "$NEW_USER"
fi

# حذف المستخدم القديم (ما عدا root)
OLD_USER=$(logname)
if [[ "$OLD_USER" != "root" && "$OLD_USER" != "$NEW_USER" ]]; then
  userdel -r "$OLD_USER"
fi

# تغيير اسم النظام
hostnamectl set-hostname "Erebux"

# تخصيص التيرمنال
BASHRC="/home/$NEW_USER/.bashrc"

cat << 'EOF' > "$BASHRC"
# شعار دموي
echo -e "\e[31m
███████╗███████╗██████╗ ███████╗██████╗ ██╗   ██╗
██╔════╝██╔════╝██╔══██╗██╔════╝██╔══██╗╚██╗ ██╔╝
█████╗  █████╗  ██████╔╝█████╗  ██████╔╝ ╚████╔╝ 
██╔══╝  ██╔══╝  ██╔══██╗██╔══╝  ██╔══██╗  ╚██╔╝  
██║     ███████╗██║  ██║███████╗██║  ██║   ██║   
╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   
       💀 Welcome to Erebux Terminal 💀
\e[0m"

# تلوين سطر الأوامر (عادي - أزرق / root - أحمر)
if [[ $EUID -eq 0 ]]; then
  PS1='\e[1;31ml 2zs@lveu > \e[0m'
else
  PS1='\e[1;34ml 2zs@lveu > \e[0m'
fi

# تلوين أوامر مشهورة
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias cat='batcat'
alias ..='cd ..'
alias update='sudo pacman -Syu'
alias py='python3'
EOF

chown "$NEW_USER":"$NEW_USER" "$BASHRC"

echo "✅ تم إنشاء المستخدم الجديد وتخصيص النظام بنجاح."
echo "ℹ️ أعد التشغيل وسجل الدخول باسم: $NEW_USER وكلمة السر: $NEW_PASS"