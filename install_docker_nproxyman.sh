#!/bin/bash
# install_docker_nproxyman.sh
# Installs Docker CE, Docker Compose plugin, and optional Docker applications.
# Supports: CentOS/Fedora, Debian 10/11/12, Ubuntu 18.04/20.04/22.04/24.04/26.04 LTS,
#           Arch Linux, OpenSUSE, Raspbian/Arm64
# Ubuntu 26.04 LTS (Resolute Raccoon) released April 23, 2026.
# Docker CE 29.x installs cleanly on 26.04 via get.docker.com (containerd 2.x, cgroup v2).

set -euo pipefail

GITLAB_RAW="https://gitlab.com/bmcgonag/docker_installs/-/raw/main"
LOG="$HOME/docker-script-install.log"

spinner() {
    local pid=$1
    local spin='-\|/'
    local i=0
    while kill -0 "$pid" 2>/dev/null; do
        i=$(( (i+1) % 4 ))
        printf "\r${spin:$i:1}"
        sleep .1
    done
    printf "\r"
}

installApps() {
    clear
    OS="$REPLY"
    echo "We can install Docker CE, Docker Compose, Nginx Proxy Manager, and more."
    echo "Please select 'y' for each item you would like to install."
    echo "NOTE: Docker CE must be installed before any other packages."
    echo ""

    ISACT=$(sudo systemctl is-active docker 2>&1 || true)
    ISCOMP=$(docker compose version 2>&1 || true)

    if [[ "$ISACT" != "active" ]]; then
        read -rp "Docker CE (y/n): " DOCK
    else
        echo "Docker CE is already installed and running."
        DOCK="n"
    fi

    if [[ "$ISCOMP" == *"command not found"* ]] || [[ "$ISCOMP" == *"unknown command"* ]]; then
        read -rp "Docker Compose plugin (y/n): " DCOMP
    else
        echo "Docker Compose plugin is already installed."
        DCOMP="n"
    fi

    echo ""
    read -rp "Do you want to install any Docker-based applications? (y/n): " INSTALLAPPS
    echo ""

    NPM="n"; NAVID="n"; PTAIN="n"; PORT="0"
    REMOTELY="n"; GUAC="n"; KUMA="n"; RUST="n"; BESZEL="n"

    if [[ "$INSTALLAPPS" == [yY] ]]; then
        read -rp "Nginx Proxy Manager (y/n): " NPM
        read -rp "Navidrome - self-hosted music streaming (y/n): " NAVID
        read -rp "Portainer CE (y/n): " PTAIN
        read -rp "Remotely - web-based remote desktop support (y/n): " REMOTELY
        read -rp "Guacamole - browser-based remote desktop gateway (y/n): " GUAC
        read -rp "Uptime Kuma - uptime monitor with notifications (y/n): " KUMA
        read -rp "RustDesk Server - self-hosted remote desktop relay (y/n): " RUST
        read -rp "Beszel - lightweight system monitoring hub (y/n): " BESZEL
    fi

    if [[ "$PTAIN" == [yY] ]]; then
        echo ""
        PS3="Please choose Portainer-CE or just the Agent: "
        select _ in \
            "Full Portainer CE (web UI for Docker, Swarm, and Kubernetes)" \
            "Portainer Agent only (connect to a remote Portainer CE instance)" \
            "Skip Portainer"
        do
            PORT="$REPLY"
            case $REPLY in
                1) startInstall; break ;;
                2) startInstall; break ;;
                3) startInstall; break ;;
                *) echo "Invalid selection, please try again..." ;;
            esac
        done
    else
        startInstall
    fi
}

startInstall() {
    clear
    echo "#######################################################"
    echo "###           Preparing for Installation            ###"
    echo "#######################################################"
    echo ""
    sleep 2s

    # Raspbian / Arm64
    if [[ "$OS" == "8" ]]; then
        echo "    1. Installing system updates..."
        (sudo apt update && sudo apt upgrade -y) > "$LOG" 2>&1 &
        spinner $!
        echo "    2. Installing prerequisite packages..."
        sudo apt install -y curl wget git >> "$LOG" 2>&1
        if [[ "$ISACT" != "active" ]]; then
            echo "    3. Installing Docker CE..."
            curl -fsSL https://get.docker.com | sh >> "$LOG" 2>&1
            DOCKERV=$(docker -v)
            echo "       Docker version: ${DOCKERV}"
            sleep 2s
            sudo systemctl enable docker >> "$LOG" 2>&1
            sudo systemctl start docker >> "$LOG" 2>&1
        fi
    fi

    # Debian / Ubuntu (all versions including 26.04 LTS)
    # OS 2=Debian, OS 3=Ubuntu 18.04, OS 4=Ubuntu 20-24, OS 5=Ubuntu 26.04
    if [[ "$OS" == [2345] ]]; then
        echo "    1. Installing system updates..."
        (sudo apt update && sudo apt upgrade -y) > "$LOG" 2>&1 &
        spinner $!
        echo "    2. Installing prerequisite packages..."
        sudo apt install -y curl wget git apt-transport-https ca-certificates gnupg lsb-release >> "$LOG" 2>&1
        if [[ "$ISACT" != "active" ]]; then
            echo "    3. Installing Docker CE..."
            curl -fsSL https://get.docker.com | sh >> "$LOG" 2>&1
            DOCKERV=$(docker -v)
            echo "       Docker version: ${DOCKERV}"
            sleep 2s
            sudo systemctl enable docker >> "$LOG" 2>&1
            sudo systemctl start docker >> "$LOG" 2>&1
        fi
    fi

    # CentOS / Fedora
    if [[ "$OS" == "1" ]]; then
        if [[ "$DOCK" == [yY] ]]; then
            echo "    1. Updating system packages..."
            sudo dnf check-update > "$LOG" 2>&1 || true
            echo "    2. Installing prerequisite packages..."
            sudo dnf install -y git curl wget >> "$LOG" 2>&1
            if [[ "$ISACT" != "active" ]]; then
                echo "    3. Installing Docker CE..."
                curl -fsSL https://get.docker.com | sh >> "$LOG" 2>&1
                sudo systemctl enable docker >> "$LOG" 2>&1
                sudo systemctl start docker >> "$LOG" 2>&1
                DOCKERV=$(docker -v)
                echo "       Docker version: ${DOCKERV}"
                sleep 2s
            fi
        fi
    fi

    # Arch Linux
    if [[ "$OS" == "6" ]]; then
        read -rp "Do you want to install system updates before Docker CE? (y/n): " UPDARCH
        if [[ "$UPDARCH" == [yY] ]]; then
            echo "    1. Installing system updates..."
            (sudo pacman -Syu --noconfirm) > "$LOG" 2>&1 &
            spinner $!
        else
            echo "    1. Skipping system update..."
        fi
        echo "    2. Installing prerequisite packages..."
        sudo pacman -Sy --noconfirm git curl wget >> "$LOG" 2>&1
        if [[ "$ISACT" != "active" ]]; then
            echo "    3. Installing Docker CE..."
            sudo pacman -Sy --noconfirm docker >> "$LOG" 2>&1
            sudo systemctl enable docker >> "$LOG" 2>&1
            sudo systemctl start docker >> "$LOG" 2>&1
            DOCKERV=$(docker -v)
            echo "       Docker version: ${DOCKERV}"
            sleep 2s
        fi
    fi

    # OpenSUSE
    if [[ "$OS" == "7" ]]; then
        read -rp "Do you want to install system updates before Docker CE? (y/n): " UPDSUSE
        if [[ "$UPDSUSE" == [yY] ]]; then
            echo "    1. Installing system updates..."
            (sudo zypper -n update) > "$LOG" 2>&1 &
            spinner $!
        else
            echo "    1. Skipping system update..."
        fi
        echo "    2. Installing prerequisite packages..."
        sudo zypper -n install git curl wget >> "$LOG" 2>&1
        if [[ "$ISACT" != "active" ]]; then
            echo "    3. Installing Docker CE..."
            curl -fsSL https://get.docker.com | sh >> "$LOG" 2>&1
            sudo systemctl enable docker >> "$LOG" 2>&1
            sudo systemctl start docker >> "$LOG" 2>&1
            DOCKERV=$(docker -v)
            echo "       Docker version: ${DOCKERV}"
            sleep 2s
        fi
    fi

    if [[ "$DOCK" == [yY] ]]; then
        echo ""
        echo "    Adding the current user to the docker group..."
        sudo usermod -aG docker "${USER}" >> "$LOG" 2>&1
        echo "    You will need to log out and back in for this change to take effect."
        echo ""
        sleep 2s
    fi

    if [[ "$DCOMP" == [yY] ]]; then
        echo "    Installing Docker Compose plugin..."
        if [[ "$OS" == "8" ]]; then
            sudo apt-get install -y libffi-dev libssl-dev python3-dev python3 python3-pip >> "$LOG" 2>&1
            sudo pip3 install docker-compose >> "$LOG" 2>&1
        fi
        if [[ "$OS" == "6" ]]; then
            sudo pacman -Sy --noconfirm docker-compose >> "$LOG" 2>&1
        fi
        echo "    Docker Compose version: $(docker compose version)"
        echo ""
        sleep 2s
    fi

    ISACT=$(sudo systemctl is-active docker 2>&1 || true)
    X=0
    while [[ "$ISACT" != "active" ]] && [[ $X -le 10 ]]; do
        echo "    Waiting for Docker daemon to start..."
        sudo systemctl start docker >> "$LOG" 2>&1
        sleep 5s &
        spinner $!
        ISACT=$(sudo systemctl is-active docker 2>&1 || true)
        X=$(( X + 1 ))
    done

    if [[ "$ISACT" != "active" ]]; then
        echo "ERROR: Docker daemon did not start after 10 attempts. Check $LOG for details."
        exit 1
    fi

    echo "################################################"
    echo "######      Creating Docker Network      #######"
    echo "################################################"
    echo ""

    if ! docker network inspect my-main-net > /dev/null 2>&1; then
        docker network create my-main-net >> "$LOG" 2>&1
        echo "    Created network: my-main-net"
    else
        echo "    Network my-main-net already exists. Skipping."
    fi
    echo ""
    sleep 2s
    cd "$HOME"

    if [[ "$NPM" == [yY] ]]; then
        echo "###    Install Nginx Proxy Manager     ###"
        mkdir -p "$HOME/docker/nginx-proxy-manager"
        cd "$HOME/docker/nginx-proxy-manager"
        curl -fsSL "${GITLAB_RAW}/docker_compose_nginx_proxy_manager.yml" -o docker-compose.yml >> "$LOG" 2>&1
        sudo docker compose up -d >> "$LOG" 2>&1
        echo "    Nginx Proxy Manager running at http://<your-server-ip>:81"
        echo "    Default: admin@example.com / changeme - CHANGE IMMEDIATELY"
        sleep 3s
        cd "$HOME"
    fi

    if [[ "$PORT" == "1" ]]; then
        echo "###      Installing Portainer CE     ###"
        mkdir -p "$HOME/docker/portainer/portainer_data"
        cd "$HOME/docker/portainer"
        curl -fsSL "${GITLAB_RAW}/docker_compose_portainer_ce.yml" -o docker-compose.yml >> "$LOG" 2>&1
        sudo docker compose up -d >> "$LOG" 2>&1
        echo "    Portainer CE: http://<your-server-ip>:9000 or https://<your-server-ip>:9443"
        sleep 3s
        cd "$HOME"
    fi

    if [[ "$PORT" == "2" ]]; then
        echo "###      Installing Portainer Agent     ###"
        mkdir -p "$HOME/docker/portainer"
        cd "$HOME/docker/portainer"
        curl -fsSL "${GITLAB_RAW}/docker_compose_portainer_ce_agent.yml" -o docker-compose.yml >> "$LOG" 2>&1
        sudo docker compose up -d >> "$LOG" 2>&1
        echo "    Portainer Agent running. Add this host in Portainer CE at Environments > port 9001"
        sleep 3s
        cd "$HOME"
    fi

    if [[ "$NAVID" == [yY] ]]; then
        echo "###        Installing Navidrome         ###"
        mkdir -p "$HOME/docker/navidrome/data/music"
        cd "$HOME/docker/navidrome"
        curl -fsSL "${GITLAB_RAW}/docker_compose_navidrome.yml" -o docker-compose.yml >> "$LOG" 2>&1
        sudo docker compose up -d >> "$LOG" 2>&1
        echo "    Navidrome: http://<your-server-ip>:4533"
        echo "    Add music to: $HOME/docker/navidrome/data/music"
        sleep 3s
        cd "$HOME"
    fi

    if [[ "$REMOTELY" == [yY] ]]; then
        echo "###          Install Remotely          ###"
        echo "    Generating a random PostgreSQL password..."
        postgrespw=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32)
        mkdir -p "$HOME/docker/remotely"
        cd "$HOME/docker/remotely"
        curl -fsSL "${GITLAB_RAW}/docker_compose_remotely.yml" -o docker-compose.yml >> "$LOG" 2>&1
        curl -fsSL "${GITLAB_RAW}/remotely_env" -o .env >> "$LOG" 2>&1
        sed -i "s|^POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=${postgrespw}|" .env
        sudo docker compose up -d >> "$LOG" 2>&1
        echo "    Remotely: http://<your-server-ip>:5000"
        echo "    Put behind Nginx Proxy Manager with SSL + WebSocket support."
        sleep 3s
        cd "$HOME"
    fi

    if [[ "$GUAC" == [yY] ]]; then
        echo "###         Installing Guacamole       ###"
        mkdir -p "$HOME/docker/guacamole"
        cd "$HOME/docker/guacamole"
        curl -fsSL "${GITLAB_RAW}/docker_compose_guacamole.yml" -o docker-compose.yml >> "$LOG" 2>&1
        sudo docker compose up -d >> "$LOG" 2>&1
        echo "    Guacamole: http://<your-server-ip>:8080/guacamole"
        echo "    Default: guacadmin / guacadmin - CREATE NEW ADMIN AND DELETE THIS ACCOUNT"
        sleep 3s
        cd "$HOME"
    fi

    if [[ "$RUST" == [yY] ]]; then
        echo "###         Installing RustDesk        ###"
        read -rp "    Enter the FQDN or public IP address for your RustDesk server: " RUSTFQDN
        mkdir -p "$HOME/docker/rustdesk/hbbs" "$HOME/docker/rustdesk/hbbr"
        cd "$HOME/docker/rustdesk"
        curl -fsSL "${GITLAB_RAW}/docker_compose_rustdesk-server.yml" -o docker-compose.yml >> "$LOG" 2>&1
        curl -fsSL "${GITLAB_RAW}/rustdesk_env" -o .env >> "$LOG" 2>&1
        cd hbbs
        ssh-keygen -t ed25519 -f ./id_ed25519 -N "" -q
        yoursecretkey=$(<id_ed25519.pub)
        secondpartsecretkey=$(echo "$yoursecretkey" | awk '{print $2}')
        echo "$secondpartsecretkey" > id_ed25519.pub
        cd ..
        sed -i "s|^RUSTDESK_FQDN=.*|RUSTDESK_FQDN=${RUSTFQDN}|" .env
        sed -i "s|^RUSTDESK_SECRET_KEY=.*|RUSTDESK_SECRET_KEY=${secondpartsecretkey}|" .env
        sudo docker compose up -d >> "$LOG" 2>&1
        echo "    RustDesk Server: ${RUSTFQDN} | Key: ${secondpartsecretkey}"
        echo "    Firewall: 21115/tcp 21116/tcp 21116/udp 21117/tcp 21118/tcp 21119/tcp"
        sleep 3s
        cd "$HOME"
    fi

    if [[ "$KUMA" == [yY] ]]; then
        echo "###         Installing Uptime Kuma     ###"
        mkdir -p "$HOME/docker/uptime-kuma"
        cd "$HOME/docker/uptime-kuma"
        curl -fsSL "${GITLAB_RAW}/docker_compose_uptime_kuma.yml" -o docker-compose.yml >> "$LOG" 2>&1
        sudo docker compose up -d >> "$LOG" 2>&1
        echo "    Uptime Kuma: http://<your-server-ip>:3001"
        echo "    Enable WebSocket support in Nginx Proxy Manager for the live dashboard."
        sleep 3s
        cd "$HOME"
    fi

    if [[ "$BESZEL" == [yY] ]]; then
        echo "###      Installing Beszel             ###"
        mkdir -p "$HOME/docker/beszel/beszel_data"
        cd "$HOME/docker/beszel"
        curl -fsSL "${GITLAB_RAW}/docker_compose_beszel.yml" -o docker-compose.yml >> "$LOG" 2>&1
        sudo docker compose up -d >> "$LOG" 2>&1
        echo "    Beszel: http://<your-server-ip>:8090"
        echo "    Deploy Beszel agents on remote hosts from within the Beszel UI."
        sleep 3s
        cd "$HOME"
    fi

    echo ""
    echo "##########################################################"
    echo "###           Installation Complete                    ###"
    echo "##########################################################"
    echo ""
    echo "    All selected applications are on the my-main-net Docker network."
    echo "    Installation log saved to: $LOG"
    echo ""
    exit 0
}

clear
echo ""
echo "Let's figure out which OS / distro you are running."
echo ""
echo "    OS Name:       $(lsb_release -i 2>/dev/null | awk -F: '{print $2}' | xargs || echo 'Unknown')"
echo "    Description:   $(lsb_release -d 2>/dev/null | awk -F: '{print $2}' | xargs || echo 'Unknown')"
echo "    Version:       $(lsb_release -r 2>/dev/null | awk -F: '{print $2}' | xargs || echo 'Unknown')"
echo "    Codename:      $(lsb_release -c 2>/dev/null | awk -F: '{print $2}' | xargs || echo 'Unknown')"
echo ""
echo "------------------------------------------------------"
echo ""

PS3="Please select the number for your OS / distro: "
select _ in \
    "CentOS 7 / 8 / Fedora" \
    "Debian 10 / 11 / 12" \
    "Ubuntu 18.04" \
    "Ubuntu 20.04 / 21.04 / 22.04 / 24.04" \
    "Ubuntu 26.04 LTS (Resolute Raccoon)" \
    "Arch Linux" \
    "OpenSUSE" \
    "Arm64 / Raspbian" \
    "Exit"
do
    case $REPLY in
        1) installApps ;;
        2) installApps ;;
        3) installApps ;;
        4) installApps ;;
        5) installApps ;;
        6) installApps ;;
        7) installApps ;;
        8) installApps ;;
        9) exit 0 ;;
        *) echo "Invalid selection, please try again..." ;;
    esac
done
