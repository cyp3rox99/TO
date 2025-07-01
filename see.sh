#!/bin/bash

# التحقق من تشغيل السكربت كـ root
if [ "$(id -u)" -ne 0 ]; then
    echo "يجب تشغيل هذا السكربت كـ root" >&2
    exit 1
fi

# =============================================
# 1. إعدادات النظام الأساسية
# =============================================

# إضافة المستخدم الجديد
echo "جاري إضافة المستخدم lveuia..."
useradd -m -G wheel -s /bin/bash lveuia
echo "lveuia:2zs" | chpasswd

# تغيير اسم النظام
echo "جاري تغيير اسم النظام إلى lveunix..."
echo "lveunix" > /etc/hostname
sed -i 's/^127.0.1.1.*/127.0.1.1\tlveunix/g' /etc/hosts

# إضافة صلاحيات sudo للمستخدم
echo "جاري منح صلاحيات sudo للمستخدم lveuia..."
echo 'lveuia ALL=(ALL:ALL) ALL' >> /etc/sudoers

# حذف المستخدم القديم
echo "جاري حذف المستخدم القديم..."
userdel -r arch 2>/dev/null || echo "المستخدم القديم غير موجود أو تم حذفه بالفعل"

# =============================================
# 2. تخصيص الطرفية
# =============================================

# تخصيص موجه الأوامر
echo "جاري تخصيص موجه الأوامر..."
echo 'PS1="\$ "' >> /etc/bash.bashrc
echo 'PS1="\$ "' >> /home/lveuia/.bashrc

# ألوان الطرفية
echo "جاري ضبط ألوان الطرفية..."
echo 'alias ls="ls --color=auto"' >> /etc/bash.bashrc
echo 'alias grep="grep --color=auto"' >> /etc/bash.bashrc
echo 'PS1="\[\e[34m\]\$ \[\e[0m\]"' >> /etc/bash.bashrc
echo 'PS1="\[\e[31m\]\$ \[\e[0m\]"' >> /root/.bashrc

# =============================================
# 3. واجهة الدخول النهائية
# =============================================

echo "جاري إنشاء واجهة الدخول النهائية..."
cat > /etc/profile.d/lveunix-login.sh << 'EOL'
#!/bin/bash

if [ "$(tty)" = "/dev/tty1" ]; then
    # مسح الشاشة وتحديد الحجم
    clear
    printf '\033[8;50;150t'
    
    # شعار النظام الناري
    echo -e "\e[1;31m"
    echo '    ██╗     ███████╗██╗   ██╗██╗   ██╗███╗   ██╗██╗██╗  ██╗'
    echo '    ██║     ██╔════╝██║   ██║██║   ██║████╗  ██║██║╚██╗██╔╝'
    echo '    ██║     █████╗  ██║   ██║██║   ██║██╔██╗ ██║██║ ╚███╔╝ '
    echo '    ██║     ██╔══╝  ██║   ██║██║   ██║██║╚██╗██║██║ ██╔██╗ '
    echo '    ███████╗███████╗╚██████╔╝╚██████╔╝██║ ╚████║██║██╔╝ ██╗'
    echo '    ╚══════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝'
    echo -e "\e[0m"
    
    # جمجمة CSL
    echo -e "\e[1;30m"
    echo '       ______'
    echo '      /      \'
    echo '     |  () () |'
    echo '      \   ^   /'
    echo '       |||||||'
    echo '       |||||||'
    echo '      /|||||||\'
    echo '     /_________\'
    echo -e "\e[0m"
    
    # رسالة تحذير
    echo -e "\e[1;33m"
    echo '╔════════════════════════════════════════════╗'
    echo '║                                            ║'
    echo '║  WARNING: THIS SYSTEM IS UNDER SURVEILLANCE ║'
    echo '║                                            ║'
    echo '╚════════════════════════════════════════════╝'
    echo -e "\e[0m"
    
    # معلومات النظام
    echo -e "\e[1;36m"
    echo "System: LVEUNIX Ultimate"
    echo "Version: 0.1"
    echo "Developed by: lveuia & cyp3rox99"
    echo -e "\e[0m"
    
    # واجهة الدخول
    while true; do
        # اسم المستخدم
        echo -e "\e[1;34m"
        echo '┌───────────────────────────────┐'
        echo '│                               │'
        echo -n '│  '
        read -p "Username: " username
        echo '│                               │'
        echo '└───────────────────────────────┘'
        echo -e "\e[0m"
        
        # كلمة المرور
        echo -e "\e[1;34m"
        echo '┌───────────────────────────────┐'
        echo '│                               │'
        echo -n '│  '
        read -s -p "Password: " password
        echo '│                               │'
        echo '└───────────────────────────────┘'
        echo -e "\e[0m"
        
        # التحقق من البيانات
        if [ "$username" == "lveuia" ] && [ "$password" == "2zs" ]; then
            echo -e "\e[1;32m\n[+] تم التحقق بنجاح! جاري الدخول إلى النظام...\e[0m"
            sleep 1
            break
        else
            echo -e "\e[1;31m\n[-] بيانات الدخول غير صحيحة! حاول مرة أخرى\e[0m"
            sleep 1
            clear
            continue
        fi
    done
fi
EOL

chmod +x /etc/profile.d/lveunix-login.sh

# =============================================
# 4. إعدادات systemd النهائية
# =============================================

echo "جاري إنشاء خدمة systemd النهائية..."
cat > /etc/systemd/system/lveunix-login.service << 'EOL'
[Unit]
Description=LVEUNIX Ultimate Login Interface
After=systemd-user-sessions.service

[Service]
ExecStart=/bin/bash /etc/profile.d/lveunix-login.sh
Restart=always
RestartSec=3
StandardInput=tty
StandardOutput=tty
TTYPath=/dev/tty1

[Install]
WantedBy=multi-user.target
EOL

# تعطيل الخدمات القديمة
echo "جاري تعطيل خدمات الدخول القديمة..."
systemctl stop getty@tty1.service
systemctl disable getty@tty1.service
systemctl mask getty@tty1.service

# تفعيل الخدمة الجديدة
echo "جاري تفعيل خدمة الدخول الجديدة..."
systemctl daemon-reload
systemctl enable lveunix-login.service
systemctl start lveunix-login.service

# =============================================
# 5. اللمسات النهائية
# =============================================

echo -e "\e[1;32m"
echo '╔════════════════════════════════════╗'
echo '║                                    ║'
echo '║   تم إعداد النظام بنجاح!           ║'
echo '║                                    ║'
echo '╚════════════════════════════════════╝'
echo -e "\e[0m"

echo "جاري إعادة تشغيل النظام خلال 5 ثوان..."
sleep 5
reboot