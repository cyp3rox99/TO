#!/bin/bash

# Run as root check
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

# Step 1: Disable original getty service
systemctl disable getty@tty1.service

# Step 2: Add new user
echo "Adding new user lveuia..."
useradd -m -G wheel -s /bin/bash lveuia
echo "lveuia:2zs" | chpasswd

# Step 3: Change hostname
echo "Changing hostname to lveunix..."
echo "lveunix" > /etc/hostname
sed -i 's/^127.0.1.1.*/127.0.1.1\tlveunix/g' /etc/hosts

# Step 4: Add user to sudoers
echo "Adding lveuia to sudoers..."
echo 'lveuia ALL=(ALL:ALL) ALL' >> /etc/sudoers

# Step 5: Delete old user (assuming the original user is 'arch')
echo "Deleting old user..."
userdel -r arch 2>/dev/null || echo "Original user not found or already removed"

# Step 6: Customize PS1 (prompt)
echo "Customizing prompt..."
echo 'PS1="\$ "' >> /etc/bash.bashrc
echo 'PS1="\$ "' >> /home/lveuia/.bashrc

# Step 7: Terminal colors
echo "Setting terminal colors..."
echo 'alias ls="ls --color=auto"' >> /etc/bash.bashrc
echo 'alias grep="grep --color=auto"' >> /etc/bash.bashrc
echo 'PS1="\[\e[34m\]\$ \[\e[0m\]"' >> /etc/bash.bashrc  # Blue for normal user
echo 'PS1="\[\e[31m\]\$ \[\e[0m\]"' >> /root/.bashrc    # Red for root

# Step 8: Create full-screen login interface
echo "Creating full-screen login interface..."
cat > /etc/profile.d/lveunix-login.sh << 'EOL'
#!/bin/bash

if [ "$(tty)" = "/dev/tty1" ]; then
    # Clear screen and set full-screen
    clear
    printf '\033[8;50;150t'  # Set terminal size
    
    # Display massive skull ASCII art
    echo -e "\e[1;31m"
    echo '          _____          '
    echo '         /     \         '
    echo '        | () () |        '
    echo '         \  ^  /         '
    echo '          |||||          '
    echo '          |||||          '
    echo '        \/|||||\/        '
    echo '  _______|||||_______    '
    echo ' /       \___/       \   '
    echo '/ |     |     |     | \  '
    echo '  |     |     |     |    '
    echo '  |     |     |     |    '
    echo '  |_____|     |_____|    '
    echo -e "\e[0m"
    
    # System name with hacker style
    echo -e "\e[1;35m"
    echo '  _      _____ _____ _   _ _   _ ___  '
    echo ' | |    |  _  |  _  | | | | \ | |__ \ '
    echo ' | |    | | | | | | | | | |  \| | / / '
    echo ' | |____| | | | | | | | | | . ` ||_|  '
    echo ' |_____ \ \_/ / \_/ \ \_/ / |\  | (_) '
    echo '       \_\___/\___/ \___/\_| \_/\___/ '
    echo -e "\e[0m"
    
    echo -e "\e[1;33m           T E R M I N A L   S Y S T E M\e[0m"
    echo -e "\e[1;32m------------------------------------------------\e[0m"
    echo -e "\e[1;36m        Developed by lveuia & cyp3rox99\e[0m"
    echo -e "\e[1;31m               W A R N I N G\e[0m"
    echo -e "\e[1;33m  Unauthorized access is strictly prohibited\e[0m"
    echo -e "\e[1;32m------------------------------------------------\e[0m"
    echo
    
    # CSL style login boxes
    while true; do
        # Username box
        echo -e "\e[1;34m"
        echo '+-------------------------------+'
        echo '|                               |'
        echo -n '|  '
        read -p "Username: " username
        echo '|                               |'
        echo '+-------------------------------+'
        echo -e "\e[0m"
        
        # Password box
        echo -e "\e[1;34m"
        echo '+-------------------------------+'
        echo '|                               |'
        echo -n '|  '
        read -s -p "Password: " password
        echo '|                               |'
        echo '+-------------------------------+'
        echo -e "\e[0m"
        
        # Authentication check
        if [ "$username" == "lveuia" ] && [ "$password" == "2zs" ]; then
            echo -e "\e[1;32m\nAuthentication successful! Launching shell...\e[0m"
            sleep 1
            break
        else
            echo -e "\e[1;31m\nInvalid credentials! Try again.\e[0m"
            sleep 1
            clear
            continue
        fi
    done
fi
EOL

chmod +x /etc/profile.d/lveunix-login.sh

# Step 9: Create startup service
echo "Creating startup service..."
cat > /etc/systemd/system/lveunix-login.service << 'EOL'
[Unit]
Description=LVEUNIX Custom Login
After=systemd-user-sessions.service

[Service]
ExecStart=/bin/bash /etc/profile.d/lveunix-login.sh
Type=idle
Restart=always
RestartSec=1
StandardInput=tty
StandardOutput=tty
TTYPath=/dev/tty1

[Install]
WantedBy=multi-user.target
EOL

systemctl enable lveunix-login.service

echo -e "\e[1;32m"
echo "LVEUNIX Final Setup Complete!"
echo "System will now reboot to apply changes..."
echo -e "\e[0m"

reboot