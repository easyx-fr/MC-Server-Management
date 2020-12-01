#!/bin/bash

#--------#####--------#
#  Server Management  #
#     By EasYx_       #
#   Version : 1.2     #
#---------------------#

##############################################################################
##                     ~ Script Gestion des Serveurs ~                      ##
##############################################################################
#La variable info permet de terminer le script si elle vaut "yes" :
info="no"

#La tableau serveur contient la liste des serveurs :
server=()

#launchCMD=["bungee"]=""

#La variabe path_server contient le chemin ou se trouve les serveurs minecraft :
path_server="/home/minecraft/"
 
#Cette fonction permet de vérifier si un serveur existe ou non (liée au tableau 'server')
inArrayServer(){
    servexist=$(grep ^"$1"$ $(dirname $(readlink -f $0))/server_list.txt)
    if [ -z "$servexist" ] || [ -z "$1" ]; then
        echo "no"
    else
        echo $1
    fi 
}

onRunning(){
    PID=$(ps ax | grep "$1".sh | grep -v grep | awk '{ print $1 }')
    if [ -z "$PID" ]; then
        echo "no"
    else
        echo "yes"
    fi 
}

#Cette fonction permet d'afficher un header
msgWlc()
{
    echo -e "\033[1;33m  ____                             __  __                                                   _   "
    echo " / ___|  ___ _ ____   _____ _ __  |  \/  | __ _ _ __   __ _  __ _  ___ _ __ ___   ___ _ __ | |_ "
    echo " \___ \ / _ \ '__\ \ / / _ \ '__| | |\/| |/ _\` | '_ \ / _\` |/ _\` |/ _ \ '_ \` _ \ / _ \ '_ \| __|"
    echo "  ___) |  __/ |   \ V /  __/ |    | |  | | (_| | | | | (_| | (_| |  __/ | | | | |  __/ | | | |_ "
    echo " |____/ \___|_|    \_/ \___|_|    |_|  |_|\__,_|_| |_|\__,_|\__, |\___|_| |_| |_|\___|_| |_|\__|"
    echo -e "                                                            |___/                               \033[0m"
}

listCmd(){
    returnMenu
    echo -e "\n\033[1;33m------------------- [Liste des actions à effectuer] -------------------\033[0m"
    echo -e "\033[1;32mconsole, csl : \033[1;33mPermet de se connecter a la console d'un serveur\033[0m"
    echo -e "\033[1;32mstart, on, launch : \033[1;33mPermet de démarrer un serveur\033[0m"
    echo -e "\033[1;32mstop, off, boot : \033[1;33mPermet d'éteindre un serveur\033[0m"
    echo -e "\033[1;32mrestart, reboot : \033[1;33mPermet de redémarrer un serveur\033[0m"
    echo -e "\033[1;32mstatut, status, sta : \033[1;33mPermet d'afficher le statut des serveurs\033[0m"
    echo -e "\033[1;32mhelp, aide, ? : \033[1;33mPermet d'afficher la liste des commandes\033[0m"
        echo -e "\033[1;32mreturn, back : \033[1;33mPermet de revenir au menu principal\033[0m"
    echo -e "\033[1;32mexit, quit, bye : \033[1;33mPermet de quitter Server Management\033[0m"
    echo -e "\033[1;33m-----------------------------------------------------------------------\033[0m"
}

consoleServer(){
    echo -n -e "\033[1;33mSur quel serveur voulez vous connecter : \033[1;36m"
    read nameserver
    echo
    case $nameserver in
        $(inArrayServer "$nameserver") )
            clear
            echo -e "\033[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
            echo -e "\n! N'oubliez surtout pas de faire CTRL + A + D pour sortir de la console !"
            echo -e "\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
            echo -e "\n\033[1;32mConnexion en cours\033[1;32m..."
            sleep 5
            screen -r $nameserver
            returnMenu
            echo -e "\n\033[1;32mVous vous êtes bien déconnecté de la console du serveur \033[4;33m$nameserver\033[0m \033[1;32m!\033[0m\n" 
        ;;
        "exit" )
            quit
        ;;
        "return" | "back" )
            returnMenu
        ;;
        * ) 
            listServer
            consoleServer $1  
        ;;
    esac
}

displayLaunch(){
    if [ "$3" = "yes" ]; then
        echo -e "\n\033[1;32mLe serveur \033[4;33m$1\033[0m \033[1;32ma été $2 avec succès !\033[0m"
    elif [ "$3" = "all" ]; then
        echo -e "\n\033[1;32mTous les serveurs ont été "$2"s !\033[0m"
    elif [ "$3" = "rb" ]; then
        echo -e "\n\033[1;32mRedémarrage du serveur \033[4;33m$1\033[0m \033[1;32men cours...\033[0m"
    else
        echo -e "\n\033[1;31mLe serveur \033[1;36m$1 \033[1;31mest déjà $2 !\033[0m"
    fi
}

startServer(){
    PID=$(ps ax | grep "$1" | grep -v grep | awk '{ print $1 }')
    if [ -z "$PID" ]; then
        screen -dmS $1
        sleep 1
        screen -S $1 -X stuff "cd $path_server$1/^M"
        screen -S $1 -X stuff "./$1.sh^M"
    else
        screen -S $1 -X stuff "./$1.sh^M"
    fi
}


stopServer(){
    if [ "$1" = "bungee" ] || [ "$1" = "bungeecord" ] || [ "$1" = "Bungee" ] || [ "$1" = "proxy" ] || [ "$1" = "BungeeCord" ]; then
        screen -S $1 -X stuff "end^M"
    else
        screen -S $1 -X stuff "stop^M"
    fi
}

restartServer(){
    returnMenu
    if [ "$(onRunning "$1")" = "no" ]; then
        startServer "$1"
        echo -e "\n\033[1;32mLe serveur \033[4;33m$1\033[0m \033[1;32métait éteint et a était démarrer avec succès !\033[0m"
    else
        displayLaunch "$i" "" "rb"
        stopServer "$1"
        sleep 6
        startServer "$1"
    fi
}

actionServer(){
    echo -n -e "\033[1;33mQuel serveur voulez vous $1 : \033[1;36m"
    read nameserver
    echo
    case $nameserver in
        "all" )
            returnMenu
            stopfunction="no"
            if [ "$3" = "start" ]; then
                for i in "${server[@]}" 
                do
                    if [ "$(onRunning "$i")" = "no" ]; then
                        startServer "$i"
                        displayLaunch "$i" "$2" "yes"
                    else
                        displayLaunch "$i" "$2" "no"
                        stopfunction="yes"
                    fi
                    sleep 1
                done
            elif [ "$3" = "restart" ]; then
                for i in "${server[@]}" 
                do
                    restartServer "$i"
                done
                sleep 5
            elif [ "$3" = "stop" ]; then
                for i in "${server[@]}" 
                do
                    if [ "$(onRunning "$i")" = "yes" ]; then
                        stopServer "$i"
                        displayLaunch "$i" "$2" "yes"
                    else
                        displayLaunch "$i" "$2" "no"
                        stopfunction="yes"
                    fi
                done
                sleep 3
            fi
            if [ "$stopfunction" = "yes" ]; then
                return
            else
                displayLaunch "$i" "$2" "all"
            fi 
        ;;
        "$(inArrayServer "$nameserver")" )
            returnMenu
            if [ "$3" = "start" ]; then
                if [ "$(onRunning "$nameserver")" = "no" ]; then
                    startServer "$nameserver"
                    displayLaunch "$nameserver" "$2" "yes"
                else 
                    displayLaunch "$i" "$2" "no"
                fi 
            elif [ "$3" = "restart" ]; then
                restartServer "$nameserver"
            elif [ "$3" = "stop" ]; then
                if [ "$(onRunning "$nameserver")" = "yes" ]; then
                    stopServer "$nameserver"
                    displayLaunch "$nameserver" "$2" "yes"
                else
                    displayLaunch "$i" "$2" "no"
                fi
            fi
        ;;
        "exit" )
            quit
        ;;
        "return" | "back" )
            returnMenu
        ;;
        * )
            listServer
            actionServer $1
        ;;
    esac
}

statusServer(){
    returnMenu
    if [ "${#server[@]}" -le 1 ]; then
        echo -e "\n\033[1;33m----------------------- [Statut du serveur] -----------------------\033[0m"
        echo -e "\033[1;33mInformation du serveur :\033[0m" 
    else
        echo -e "\n\033[1;33m----------------------- [Statuts des serveurs] -----------------------\033[0m"
        echo -e "\033[1;33mInformation de tout les serveurs :\033[0m" 
    fi
    for i in "${server[@]}" 
    do
        if [ "$(onRunning "$i")" = "no" ]; then
            echo -e "\033[1;33m - Le serveur \033[1;36m$i \033[1;33mest \033[1;31méteint \033[1;33m!"
        else
            echo -e "\033[1;33m - Le serveur \033[1;36m$i \033[1;33mest \033[1;32mallumé \033[1;33m!"
        fi
    done
    echo -e "\033[1;33m----------------------------------------------------------------------\033[0m"
}


listServer(){
    for (( i=0; i<${#server[@]}; i++ )) 
    do  
        if [ "${#displayserv[@]}" != "${#server[@]}" ]; then
            displayserv+=( "${server[$i]}," )
        fi
    done
    echo -e "\033[1;33mListe des serveurs disponible : \033[1;32m${displayserv[@]} all \033[0m"
}

returnMenu(){
    clear
    msgWlc
}

quit(){
    echo -e "\033[0m"
    clear
    info="yes"
}

##############################################################################
##                    ~ Installation des Dépendences ~                      ##
##############################################################################
gmc=$(grep 'mc' /root/.bashrc)
if [ -z "$gmc" ]; then
    echo -e "\nalias mc='bash $(dirname $(readlink -f $0))/$(basename "$0")'" >> /root/.bashrc
fi 
if [ ! -e "/etc/init.d/launch_server" ]; then
    echo -e "#!/bin/sh" >> /etc/init.d/launch_server
    echo -e "### BEGIN INIT INFO" >> /etc/init.d/launch_server
    echo -e "# Provides:          launch_server" >> /etc/init.d/launch_server
    echo -e "# Required-Start:    \$local_fs \$network" >> /etc/init.d/launch_server
    echo -e "# Required-Stop:     \$local_fs" >> /etc/init.d/launch_server
    echo -e "# Default-Start:     2 3 4 5" >> /etc/init.d/launch_server
    echo -e "# Default-Stop:      0 1 6" >> /etc/init.d/launch_server
    echo -e "# Short-Description: Permet de lancer" >> /etc/init.d/launch_server
    echo -e "# Description:       Les serveurs minecraft au démarrage de la machine" >> /etc/init.d/launch_server
    echo -e "### END INIT INFO" >> /etc/init.d/launch_server
    echo -e "\npath_server=\"$path_server\"\nserver=()" >> /etc/init.d/launch_server
    echo -e "\nif [ -e $(dirname $(readlink -f $0))/server_list.txt ]; then\n    while read aLine ;\n    do server[\$i]=\"\$aLine\";\n        ((i++));\n    done <$(dirname $(readlink -f $0))/server_list.txt\nfi" >> /etc/init.d/launch_server
    echo -e "\nfor i in \"\${server[@]}\"\ndo\n    screen -dmS \$i\n    sleep 1\n    screen -S \$i -X stuff \"cd \$path_server\$i/^M\"\n    screen -S \$i -X stuff \"./\$i.sh^M\"\ndone" >> /etc/init.d/launch_server
    chmod 700 /etc/init.d/launch_server
    update-rc.d launch_server defaults
fi 
if [ -e $(dirname $(readlink -f $0))/server_list.txt ]; then
    while read aLine ;
    do server[$i]="$aLine";
        ((i++)); 
    done <$(dirname $(readlink -f $0))/server_list.txt
    returnMenu
else
    info="yes"
    echo -e "\033[1;31m[ERREUR] Vous devez créer un fichier \033[1;36m\"server_list.txt\"\033[1;31m dans le répertoire suivant \033[1;36m$(dirname $(readlink -f $0))\033[0m"
fi

##############################################################################
##                     ~ Script Gestion des Serveurs ~                      ##
##############################################################################


while [ "$info" = "no" ]
do
    echo -n -e "\n\033[1;33mQue voulez vous faire : \033[1;36m"
    read action

    case $action in
        "start" | "on" | "launch" )
            actionServer "lancer" "lancé" "start"
        ;;
        "stop" | "off" | "boot" )
            actionServer "stopper" "stoppé" "stop"
        ;;
        "restart" | "reboot" )
            actionServer "redémarrer" "redémarré" "restart"
        ;;
        "screen" | "console" | "csl" )
            consoleServer
        ;;
        "status" | "sta" | "statut" )
            statusServer
        ;;
        "exit" | "quit" | "bye" )
            quit
        ;;
        "help" | "aide" | "?" )
            listCmd
        ;;
        * )
            listCmd
        ;;
    esac
done
