#!/bin/bash

#------------#####------------#
#  Install Server Management  #
#         By EasYx_           #
#       Version : 1.1         #
#-----------------------------#
INSTALL_VERSION="v1.1"
before="*"

dep_list=("apache2" "php" "default-jdk")
dep_ins=()
dep_unins=()

time_zone=""

checkPaquet(){
    dep=$(dpkg -l | grep $1)
    if [ -z "$dep" ]; then
        echo "no"
    else
        echo "yes"
    fi 
}

updatePaquet(){
    echo -e "\033[1;33m[CONFIGURATION] Mise à jour de ${1^}...\033[0m"
    apt-get update &>/dev/null
    apt-get -y install $1 &>/dev/null
}

updateTimeZone(){
    echo -n -e "\033[1;33m[CONFIGURATION] Quel est votre fuseau horaire (Ex: Europe/Paris) : \033[0m"
    read up_timezone
    if [ -n "$up_timezone" ]; then
        if [ -e "/usr/share/zoneinfo/$up_timezone" ]; then
            timedatectl set-timezone $up_timezone
            send_tz=$(echo $up_timezone | sed 's/\//\\\//g')
            time_zone=$send_tz
        else
            echo -e "\033[1;31m[ERREUR] Le fuseau horaire \033[1;36m\"$up_timezone\"\033[1;31m n'existe pas, veuillez réessayer !\033[0m"
            updateTimeZone
        fi
    else
        updateTimeZone
    fi
}

checkDependency(){
    for i in "${dep_list[@]}" 
    do
        if [ "$(checkPaquet "$i")" = "yes" ]; then
            dep_ins=("${dep_ins[@]}" "$i")
        else
            dep_unins=("${dep_unins[@]}" "$i")
        fi 
    done
}

downloadScript(){
    wget -N -P $1 https://cdn.easyx.fr/mcsvmn/server_management.sh &>/dev/null
    chmod -R 777 $1
}

clear
echo -e "\033[1;33m$before"
echo -e "$before MC Server Management installation script @ $INSTALL_VERSION"
echo -e "$before"
echo -e "$before Copyright © 2021 - All rights reserved"
echo -e "$before https://github.com/EasYx-Developper/MC-Server-Management"
echo -e "$before"
echo -e "$before Developed by EasYx_ (EasYx_#3121, <contact@easyx.fr>)"
echo -e "$before\033[0m"
echo

if [ "$USER" = "root" ]; then
    echo -n -e "\033[1;33m[CONFIGURATION] Voulez vous lancer l'installation ? (O/N) \033[0m"
    read start_install

    if [ "$start_install" = "O" ] | [ "$start_install" = "o" ]; then
        updateTimeZone
        echo -n -e "\033[1;33m[CONFIGURATION] Où voulez-vous installer le script (Ex: /home/script) : \033[0m"
        read path_script
        if [ -n "$path_script" ]; then
            if [ ! -d "$path_script" ]; then
                mkdir $path_script
                mkdir $path_script/backup_basket
                downloadScript "$path_script"
            else
                downloadScript "$path_script"
            fi
            gmc=$(grep 'mc' /root/.bashrc)
            if [ -z "$gmc" ]; then
                echo -e "\nalias mc='bash $path_script/server_management.sh'" >> /root/.bashrc
            fi 
            send_psc=$(echo $path_script | sed 's/\//\\\//g')
            echo -n -e "\033[1;33m[CONFIGURATION] Où sont stocker votre/vos serveur(s) minecraft (Ex: /home/minecraft) : \033[0m"
            read path_svmc
            if [ -n "$path_svmc" ]; then
                if [ -d "$path_svmc" ]; then
                    send_ptsv=$(echo $path_svmc | sed 's/\//\\\//g')
                    sed -i "s/\(path_server=\"\"\)/\path_server=\"$send_ptsv\/\"/" "$path_script/server_management.sh"
                    chmod -R 777 $path_svmc
                    if [ -e "$path_script/server_management.sh" ]; then
                        echo -n -e "\033[1;33m[CONFIGURATION] Listé votre/vos serveur(s) minecraft (Ex: bungee,hub,faction) : \033[0m"
                        read svl
                        tbl_svr=( ${svl//,/ } )
                        for i in "${tbl_svr[@]}" 
                        do
                            echo -e "$i" >> "$path_script/server_list.txt"
                        done
                    fi
                else
                    echo -e "\033[1;31m[ERREUR] Le dossier \033[1;36m\"$path_svmc\"\033[1;31m n'existe pas !\033[0m"
                fi
            fi
            echo -n -e "\033[1;33m[CONFIGURATION] Où voulez-vous installer le module web (Ex: /home/web) : \033[0m"
            read path_web
            echo
            if [ -n "$path_web" ]; then
                checkDependency
                if [ ${#dep_unins[@]} -ge 1 ]; then
                    echo -e "\033[1;33m[CONFIGURATION] Lancement de l'installation des dépendances ...\033[0m"
                    sleep 3
                    for i in "${dep_unins[@]}" 
                    do
                        echo -e "\033[1;33m[CONFIGURATION] Installation de ${i^}... \033[0m"
                        apt-get update &>/dev/null
                        apt-get -y install $i &>/dev/null
                        echo -e "\033[1;33m[CONFIGURATION] Installation de ${i^} réussi !\033[0m"
                        if [ "$i" = "apache2" ]; then
                            echo -e "\033[1;33m[CONFIGURATION] Configuration de ${i^}... \033[0m"
                            mkdir $path_web
                            sleep 1
                            send_web=$(echo $path_web | sed 's/\//\\\//g')
                            sed -i "s/\(<Directory \/var\/www\/>\)/\<Directory $send_web\/>/" "/etc/apache2/apache2.conf"
                            nbl_ao=$(grep -no "AllowOverride None" /etc/apache2/apache2.conf | sed -n "3 p" | cut -c1-3)
                            sed -i "$nbl_ao s/AllowOverride None/AllowOverride All/" /etc/apache2/apache2.conf
                            sed -i "s/\(DocumentRoot \/var\/www\/html\)/\DocumentRoot $send_web/" "/etc/apache2/sites-available/000-default.conf"
                            echo -e "\033[1;33m[CONFIGURATION] Configuration de ${i^} réussi !\033[0m"
                        fi
                    done
                fi
                a2enmod rewrite &>/dev/null
                chmod 777 /var/lib/php/sessions
                /etc/init.d/apache2 restart &>/dev/null
                updatePaquet "zip"
                updatePaquet "screen"
                echo -e "\n\033[1;33m[CONFIGURATION] Toutes les dépendances sont installés !\033[0m"
                sleep 1
                echo -e "\n\033[1;33m[CONFIGURATION] Mise en place du module Mc Server Management Web...\033[0m"
                wget -N -P $path_web https://cdn.easyx.fr/mcsvmn/mcsvmn_web.zip &>/dev/null
                unzip "$path_web/mcsvmn_web.zip" -d "$path_web/" &>/dev/null
                sleep 2
                rm -r "$path_web/mcsvmn_web.zip"
                sed -i "s/\date_default_timezone_set('');/\date_default_timezone_set('$time_zone');/" "$path_web/data.php"
                sed -i "s/\$chemin_bscript = \"\";/\$chemin_bscript = \"$send_psc\/\";/" "$path_web/data.php"
                sed -i "s/\$chemin_mc = \"\";/\$chemin_mc = \"$send_ptsv\/\";/" "$path_web/data.php"
                chmod -R 777 $path_web
                echo -e "\033[1;33m[CONFIGURATION] Module Mc Server Management Web mis en place avec succès !\033[0m"
            fi
        fi
        echo -e "\n\033[1;32m[INSTALLATION] L'installation de Mc Server Management c'est terminé avec succès !\033[0m"
    fi
else
    echo -e "\033[1;31m[ERREUR] Vous devez être connecté a l'utilisateur \033[1;36m\"root\"\033[1;31m !\033[0m"
fi