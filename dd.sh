#!/bin/bash

EREBUX SYSTEM CUSTOMIZATION SCRIPT ⚠️🔥

By: lveuia / 2zs

CLI Mode | Dark Red Demon Theme

set -e  # Exit on any error

STEP 1: Create New User

USERNAME="lveuia" PASSWORD="2zs"

if ! id "$USERNAME" &>/dev/null; then useradd -m -s /bin/bash "$USERNAME" echo "$USERNAME:$PASSWORD" | chpasswd usermod -aG wheel "$USERNAME" echo "[+] Created user $USERNAME and added to wheel group." else echo "[!] User $USERNAME already exists." fi

STEP 2: Remove Default User (Optional, dangerous)

DEFAULT_USER="arch" if id "$DEFAULT_USER" &>/dev/null; then userdel -r "$DEFAULT_USER" && echo "[+] Removed user $DEFAULT_USER." fi

STEP 3: Rename Hostname

NEW_HOSTNAME="Erebux" echo "$NEW_HOSTNAME" > /etc/hostname echo "127.0.1.1   $NEW_HOSTNAME" >> /etc/hosts

STEP 4: Custom Bash Prompt + Colors

BASHRC_PATH="/home/$USERNAME/.bashrc" cat << 'EOF' > "$BASHRC_PATH"

ASCII Logo 🔥

function erebux_logo() { clear echo -e "\e[31m" echo "     ███████╗██████╗ ███████╗██████╗ ██╗   ██╗██╗  ██╗" echo "     ██╔════╝██╔══██╗██╔════╝██╔══██╗██║   ██║╚██╗██╔╝" echo "     █████╗  ██████╔╝█████╗  ██████╔╝██║   ██║ ╚███╔╝ " echo "     ██╔══╝  ██╔═══╝ ██╔══╝  ██╔═══╝ ██║   ██║ ██╔██╗ " echo "     ███████╗██║     ███████╗██║     ╚██████╔╝██╔╝ ██╗" echo "     ╚══════╝╚═╝     ╚══════╝╚═╝      ╚═════╝ ╚═╝  ╚═╝" echo -e "\e[0m" }

erebux_logo

Color Prompt

if [[ $EUID -eq 0 ]]; then PS1='\u@\h \W # ' else PS1='\u@\h \W $ ' fi

alias ls='ls --color=auto' alias grep='grep --color=auto' alias cat='batcat' EOF

chown $USERNAME:$USERNAME "$BASHRC_PATH"

STEP 5: Install Needed Tools

pacman -Sy --noconfirm bat figlet lolcat neofetch

STEP 6: Create Demon Login Banner

cat << 'BANNER' > /etc/issue

\e[1;31m  ██▓███   ▄▄▄       ██▀███   ▒█████   ██ ▄█▀ ▓██░  ██▒▒████▄    ▓██ ▒ ██▒▒██▒  ██▒ ██▄█▒ ▓██░ ██▓▒▒██  ▀█▄  ▓██ ░▄█ ▒▒██░  ██▒▓███▄░ ▒██▄█▓▒ ▒░██▄▄▄▄██ ▒██▀▀█▄  ▒██   ██░▓██ █▄ ▒██▒ ░  ░ ▓█   ▓██▒░██▓ ▒██▒░ ████▓▒░▒██▒ █▄ ▒▓▒░ ░  ░ ▒▒   ▓▒█░░ ▒▓ ░▒▓░░ ▒░▒░▒░ ▒ ▒▒ ▓▒ ░▒ ░       ▒   ▒▒ ░  ░▒ ░ ▒░  ░ ▒ ▒░ ░ ░▒ ▒░ ░░         ░   ▒     ░░   ░ ░ ░ ░ ▒  ░ ░░ ░ ░  ░   ░         ░ ░  ░  ░

\e[0mEnter the Abyss of Erebux...

BANNER

Done

echo -e "\n[✓] System customized for Erebux! Reboot then login as: \e[32m$USERNAME\e[0m / \e[33m$PASSWORD\e[0m"

