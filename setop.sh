#!/bin/bash

# Run as root check
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

# Step 1: Add new user
echo "Adding new user lveuia..."
useradd -m -G wheel -s /bin/bash lveuia
echo "lveuia:2zs" | chpasswd

# Step 2: Change hostname
echo "Changing hostname to lveunix..."
echo "lveunix" > /etc/hostname
sed -i 's/^127.0.1.1.*/127.0.1.1\tlveunix/g' /etc/hosts

# Step 3: Add user to sudoers
echo "Adding lveuia to sudoers..."
echo 'lveuia ALL=(ALL:ALL) ALL' >> /etc/sudoers

# Step 4: Delete old user (assuming the original user is 'arch')
echo "Deleting old user..."
userdel -r arch 2>/dev/null || echo "Original user not found or already removed"

# Step 5: Customize PS1 (prompt)
echo "Customizing prompt..."
echo 'PS1="\$ "' >> /etc/bash.bashrc
echo 'PS1="\$ "' >> /home/lveuia/.bashrc

# Step 6: Terminal colors
echo "Setting terminal colors..."
echo 'alias ls="ls --color=auto"' >> /etc/bash.bashrc
echo 'alias grep="grep --color=auto"' >> /etc/bash.bashrc
echo 'PS1="\[\e[34m\]\$ \[\e[0m\]"' >> /etc/bash.bashrc  # Blue for normal user
echo 'PS1="\[\e[31m\]\$ \[\e[0m\]"' >> /root/.bashrc    # Red for root

# Step 7: Create login script
echo "Creating login script..."
cat > /etc/profile.d/lveunix-login.sh << 'EOL'
#!/bin/bash

if [ "$(tty)" = "/dev/tty1" ]; then
    # Clear screen
    clear

    # ASCII Art
    echo -e "\e[1;34m"
    echo '   __      _____  __  __ _   _ _  __ '
    echo '   \ \    / / _ \|  \/  | | | | |/ / '
    echo '    \ \/\/ / | | | |\/| | | | |   /  '
    echo '     \  /  | |_| | |  | | |_| | |\ \ '
    echo '      \/    \___/|_|  |_|\___/|_| \_\'
    echo -e "\e[0m"
    echo -e "\e[1;35m        L V E U N I X   T E R M I N A L\e[0m"
    echo -e "\e[1;33m       Ethical Hacking Environment\e[0m"
    echo -e "\e[1;32m--------------------------------------------\e[0m"
    echo
    
    # Login prompt
    read -p "Username: " username
    read -s -p "Password: " password
    echo
    
    # CSL style interface
    echo -e "\e[1;36m"
    echo '[1] System Status'
    echo '[2] Network Tools'
    echo '[3] Security Scanner'
    echo '[4] Exit to Shell'
    echo -e "\e[0m"
    
    read -p "Select option: " choice
    
    case $choice in
        1)
            echo -e "\e[1;33mSystem Status:\e[0m"
            neofetch --ascii_distro arch
            ;;
        2)
            echo -e "\e[1;33mNetwork Tools Menu\e[0m"
            ;;
        3)
            echo -e "\e[1;33mSecurity Scanner Menu\e[0m"
            ;;
        4)
            echo -e "\e[1;32mLaunching shell...\e[0m"
            ;;
        *)
            echo -e "\e[1;31mInvalid option\e[0m"
            ;;
    esac
fi
EOL

chmod +x /etc/profile.d/lveunix-login.sh

# Step 8: Make script run on boot
echo "Adding script to startup..."
echo "[Unit]
Description=LVEUNIX Setup Script
After=network.target

[Service]
ExecStart=/bin/bash /etc/profile.d/lveunix-login.sh
Type=oneshot
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/lveunix-startup.service

systemctl enable lveunix-startup.service

# Step 9: Install neofetch for system info display
pacman -Sy --noconfirm neofetch

echo -e "\e[1;32m"
echo "LVEUNIX Setup Complete!"
echo "System will now reboot to apply changes..."
echo -e "\e[0m"

reboot