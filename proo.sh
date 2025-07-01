#!/bin/bash

# التحقق من تشغيل السكربت كـ root
if [ "$(id -u)" -ne 0 ]; then
    echo "يجب تشغيل هذا السكربت كـ root" >&2
    exit 1
fi

# =============================================
# 1. إعدادات النظام الأساسية
# =============================================

# إعداد موجه الأوامر الذكي
cat > /etc/profile.d/lveunix-prompt.sh << 'EOL'
#!/bin/bash

# دالة لتغيير الألوان العشوائية
random_color() {
    colors=("31" "32" "33" "34" "35" "36" "91" "92" "93" "94" "95" "96")
    echo "${colors[$RANDOM % ${#colors[@]}]}"
}

# موجه الأوامر الذكي
PS1='\[\e[$(random_color)m\]\w\[\e[0m\] \[\e[1;31m\]\$\[\e[0m\] '
EOL

chmod +x /etc/profile.d/lveunix-prompt.sh

# =============================================
# 2. واجهة الدخول الأسطورية
# =============================================

cat > /etc/profile.d/lveunix-login.sh << 'EOL'
#!/bin/bash

if [ "$(tty)" = "/dev/tty1" ]; then
    # دالة لعرض ASCII Art عشوائي
    show_random_art() {
        arts=(
            # Art 1: جمجمة نارية
            '
            \e[31m
              _____
             /     \
            | () () |
             \  ^  /
              |||||
              |||||
            \/|||||\/
            \e[0m
            '
            
            # Art 2: كائن فضائي
            '
            \e[32m
               ___ 
              /   \
             |  O  |
              \_∆_/
               / \
              /   \
            \e[0m
            '
            
            # Art 3: عين سحرية
            '
            \e[36m
              _____
             /     \
            | () () |
             \  ~  /
              |||||
              |||||
              |||||
            \e[0m
            '
            
            # Art 4: تحذير
            '
            \e[33m
              !!!
             !   !
            !     !
             !   !
              !!!
            \e[0m
            '
        )
        echo -e "${arts[$RANDOM % ${#arts[@]}]}"
    }

    # دالة للشعار الذائب
    melted_logo() {
        echo -e "\e[1;31m"
        echo '    ██╗     ███████╗██╗   ██╗██╗   ██╗███╗   ██╗██╗██╗  ██╗'
        echo '    ██║     ██╔════╝██║   ██║╚██╗ ██╔╝████╗  ██║██║╚██╗██╔╝'
        echo '    ██║     █████╗  ██║   ██║ ╚████╔╝ ██╔██╗ ██║██║ ╚███╔╝ '
        echo '    ██║     ██╔══╝  ██║   ██║  ╚██╔╝  ██║╚██╗██║██║ ██╔██╗ '
        echo '    ███████╗███████╗╚██████╔╝   ██║   ██║ ╚████║██║██╔╝ ██╗'
        echo '    ╚══════╝╚══════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝'
        echo -e "\e[0m"
    }

    # مسح الشاشة مع الاحتفاظ بالرسمة عند استخدام clear
    clear() {
        command clear
        show_random_art
        melted_logo
    }

    # عرض واجهة الدخول
    while true; do
        command clear
        
        # عرض الرسمة العشوائية
        show_random_art
        
        # عرض الشعار الذائب
        melted_logo
        
        # معلومات النظام
        echo -e "\e[1;36m"
        echo "System: LVEUNIX-PRO"
        echo "Version: 0.2"
        echo "Developed by: lveuia & cyp3rox99"
        echo -e "\e[0m"
        
        # واجهة الدخول البسيطة
        echo -e "\e[1;33m"
        echo "------------------------------------------------"
        read -p "Username: " username
        read -s -p "Password: " password
        echo -e "\n------------------------------------------------"
        echo -e "\e[0m"
        
        # التحقق من البيانات
        if [ "$username" == "lveuia" ] && [ "$password" == "2zs" ]; then
            echo -e "\e[1;32m\n[+] تم التحقق بنجاح! جاري الدخول إلى النظام...\e[0m"
            
            # العد التنازلي
            for i in {5..1}; do
                echo -ne "\e[1;35m$i \e[0m"
                sleep 1
            done
            echo -e "\e[1;32m\nتم!\e[0m"
            sleep 1
            break
        else
            echo -e "\e[1;31m\n[-] بيانات الدخول غير صحيحة! حاول مرة أخرى\e[0m"
            sleep 2
        fi
    done
    
    # تعيين دالة clear المخصصة
    export -f clear
fi
EOL

chmod +x /etc/profile.d/lveunix-login.sh

# =============================================
# 3. إعدادات systemd النهائية
# =============================================

cat > /etc/systemd/system/lveunix-login.service << 'EOL'
[Unit]
Description=LVEUNIX-PRO Login Interface
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
systemctl stop getty@tty1.service
systemctl disable getty@tty1.service
systemctl mask getty@tty1.service

# تفعيل الخدمة الجديدة
systemctl daemon-reload
systemctl enable lveunix-login.service
systemctl start lveunix-login.service

# =============================================
# 4. اللمسات النهائية
# =============================================

echo -e "\e[1;32m"
echo '╔════════════════════════════════════╗'
echo '║                                    ║'
echo '║   تم إعداد LVEUNIX-PRO بنجاح!       ║'
echo '║                                    ║'
echo '╚════════════════════════════════════╝'
echo -e "\e[0m"

echo "جاري إعادة تشغيل النظام خلال 5 ثوان..."
sleep 5
reboot