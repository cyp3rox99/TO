#!/bin/bash

# Run as root check
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

# =============================================
# 1. SYSTEM CONFIGURATION
# =============================================

# Add new user
echo "Adding new user lveuia..."
useradd -m -G wheel -s /bin/bash lveuia
echo "lveuia:2zs" | chpasswd

# Change hostname
echo "Changing hostname to lveunix..."
echo "lveunix" > /etc/hostname
sed -i 's/^127.0.1.1.*/127.0.1.1\tlveunix/g' /etc/hosts

# Add user to sudoers
echo "Adding lveuia to sudoers..."
echo 'lveuia ALL=(ALL:ALL) ALL' >> /etc/sudoers

# Delete old user
echo "Deleting old user..."
userdel -r arch 2>/dev/null || echo "Original user not found or already removed"

# =============================================
# 2. TERMINAL CUSTOMIZATION
# =============================================

# Customize prompt
echo "Customizing prompt..."
echo 'PS1="\$ "' >> /etc/bash.bashrc
echo 'PS1="\$ "' >> /home/lveuia/.bashrc

# Terminal colors
echo "Setting terminal colors..."
echo 'alias ls="ls --color=auto"' >> /etc/bash.bashrc
echo 'alias grep="grep --color=auto"' >> /etc/bash.bashrc
echo 'PS1="\[\e[34m\]\$ \[\e[0m\]"' >> /etc/bash.bashrc
echo 'PS1="\[\e[31m\]\$ \[\e[0m\]"' >> /root/.bashrc

# =============================================
# 3. FIRE LOGIN INTERFACE
# =============================================

echo "Creating ultimate login interface..."
cat > /etc/profile.d/lveunix-login.sh << 'EOL'
#!/bin/bash

if [ "$(tty)" = "/dev/tty1" ]; then
    # Set full screen and clear
    clear
    printf '\033[8;50;150t'
    
    # FIRE ASCII ART
    echo -e "\e[1;31m"
    echo '          (  .      )'
    echo '       )           (              )'
    echo '             .  .   .    .       )'
    echo '    (    )   .            .      ('
    echo '     )   (   )     .             )'
    echo '      .    )  . (   (   )   (   ('
    echo '   .  .  (    ) )  )  (   )  )  )'
    echo '  . )    )    ( (  (  (   (  (  ('
    echo '   ( (  (      ) )  )  )   ) ) ) )'
    echo '    ) ) ) )    ( (  (  (   ( ( ( ('
    echo '   ( ( ( ( (    ) )  )  )   ) ) ) )'
    echo '    ) ) ) ) )__(_(__(__(___( ( ( ('
    echo '   ( ( ( ( (__|__|__|__|__|__)_ ) )'
    echo '    )_)_)_)__|__|__|__|__|__|__)_)'
    echo -e "\e[0m"
    
    # SKULL ASCII ART
    echo -e "\e[1;30m"
    echo '    _____     ____'
    echo '   /     \   |  o |'
    echo '  | () () |  / ___\'
    echo '   \  ^  /  | |   |'
    echo '    |||||   | |   |'
    echo '    |||||   | |___|'
    echo '    |||||    \____/'
    echo '   /|||||\'
    echo '  /_______\' 
    echo -e "\e[0m"
    
    # SYSTEM NAME
    echo -e "\e[1;33m"
    echo ' ██▓     ▒█████   ██▒   █▓▓█████  ██▓  ██████ '
    echo '▓██▒    ▒██▒  ██▒▓██░   █▒▓█   ▀ ▓██▒▒██    ▒ '
    echo '▒██░    ▒██░  ██▒ ▓██  █▒░▒███   ▒██▒░ ▓██▄   '
    echo '▒██░    ▒██   ██░  ▒██ █░░▒▓█  ▄ ░██░  ▒   ██▒'
    echo '░██████▒░ ████▓▒░   ▒▀█░  ░▒████▒░██░▒██████▒▒'
    echo '░ ▒░▓  ░░ ▒░▒░▒░    ░ ▐░  ░░ ▒░ ░░▓  ▒ ▒▓▒ ▒ ░'
    echo '░ ░ ▒  ░  ░ ▒ ▒░    ░ ░░   ░ ░  ░ ▒ ░░ ░▒  ░ ░'
    echo '  ░ ░   ░ ░ ░ ▒       ░░     ░    ▒ ░░  ░  ░  '
    echo '    ░  ░    ░ ░        ░     ░  ░ ░        ░  '
    echo '                         ░                     '
    echo -e "\e[0m"
    
    echo -e "\e[1;35m           T E R M I N A L   W A R R I O R\e[0m"
    echo -e "\e[1;32m------------------------------------------------\e[0m"
    echo -e "\e[1;36m        Developed by lveuia & cyp3rox99\e[0m"
    echo -e "\e[1;31m               W A R N I N G\e[0m"
    echo -e "\e[1;33m  Unauthorized access will be punished by code\e[0m"
    echo -e "\e[1;32m------------------------------------------------\e[0m"
    echo
    
    # CSL BOXES
    while true; do
        # Username box
        echo -e "\e[1;34m"
        echo '╔═══════════════════════════════╗'
        echo '║                               ║'
        echo -n '║  '
        read -p "Username: " username
        echo '║                               ║'
        echo '╚═══════════════════════════════╝'
        echo -e "\e[0m"
        
        # Password box
        echo -e "\e[1;34m"
        echo '╔═══════════════════════════════╗'
        echo '║                               ║'
        echo -n '║  '
        read -s -p "Password: " password
        echo '║                               ║'
        echo '╚═══════════════════════════════╝'
        echo -e "\e[0m"
        
        # Authentication
        if [ "$username" == "lveuia" ] && [ "$password" == "2zs" ]; then
            echo -e "\e[1;32m\n[+] ACCESS GRANTED! Welcome to the dark side...\e[0m"
            sleep 1
            break
        else
            echo -e "\e[1;31m\n[-] ACCESS DENIED! The system is watching...\e[0m"
            sleep 1
            clear
            continue
        fi
    done
fi
EOL

chmod +x /etc/profile.d/lveunix-login.sh

# =============================================
# 4. SYSTEMD SERVICE
# =============================================

echo "Creating ultimate login service..."
cat > /etc/systemd/system/lveunix-login.service << 'EOL'
[Unit]
Description=LVEUNIX Ultimate Login
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

systemctl daemon-reload
systemctl enable lveunix-login.service
systemctl disable getty@tty1.service

# =============================================
# 5. FINAL TOUCHES
# =============================================

echo -e "\e[1;32m"
echo "╔════════════════════════════════════╗"
echo "║                                    ║"
echo "║   LVEUNIX ULTIMATE SETUP COMPLETE  ║"
echo "║                                    ║"
echo "╚════════════════════════════════════╝"
echo -e "\e[0m"

echo "System will reboot in 5 seconds..."
sleep 5
reboot