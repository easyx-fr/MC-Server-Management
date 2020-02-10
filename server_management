#!/bin/bash

#-------####-------#
# Server Management
# By EasYx_ 
# Version : 1.0
#------------------#

#La variable info permet de terminer le script si elle vaut "yes" :
info="no"

#La tableau serveur contient la liste des serveurs minecraft :
serveur=("bungee" "hub1")

#La variabe chemin_serveur contient le chemin ou se trouve les serveurs minecraft :
chemin_serveur="/home/minecraft/"
 
#Cette fonction permet de vérifier si un serveur existe ou non (liée au tableau 'serveur')
inArrayServeur(){
    for i in "${serveur[@]}" 
    do
        if [ "$i" = "$1" ]; then
            echo $i
        elif [ -z "$1" ]; then
            echo "no"
        fi 
    done
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
msgBv()
{
    echo -e "\033[1;33m  ____                             __  __                                                   _   "
    echo " / ___|  ___ _ ____   _____ _ __  |  \/  | __ _ _ __   __ _  __ _  ___ _ __ ___   ___ _ __ | |_ "
    echo " \___ \ / _ \ '__\ \ / / _ \ '__| | |\/| |/ _\` | '_ \ / _\` |/ _\` |/ _ \ '_ \` _ \ / _ \ '_ \| __|"
    echo "  ___) |  __/ |   \ V /  __/ |    | |  | | (_| | | | | (_| | (_| |  __/ | | | | |  __/ | | | |_ "
    echo " |____/ \___|_|    \_/ \___|_|    |_|  |_|\__,_|_| |_|\__,_|\__, |\___|_| |_| |_|\___|_| |_|\__|"
    echo -e "                                                            |___/                               "
}

listeCmd(){
    retour
    echo -e "\n\033[1;33m------------------- [Liste des actions à effectuer] -------------------\033[0m"
    echo -e "\033[1;32mconsole, csl : \033[1;33mPermet de se connecter a la console d'un serveur\033[0m"
    echo -e "\033[1;32mstart, on, launch : \033[1;33mPermet de démarrer un serveur\033[0m"
    echo -e "\033[1;32mstop, off, boot : \033[1;33mPermet d'éteindre un serveur\033[0m"
    echo -e "\033[1;32mrestart, reboot : \033[1;33mPermet de redémarrer un serveur\033[0m"
    echo -e "\033[1;32mstatut, status, sta : \033[1;33mPermet d'afficher le statut des serveurs\033[0m"
    echo -e "\033[1;32mhelp, aide, ? : \033[1;33mPermet d'afficher la liste des commandes\033[0m"
    echo -e "\033[1;32mexit, quit : \033[1;33mPermet de quitter Server Management\033[0m"
    echo -e "\033[1;33m-----------------------------------------------------------------------\033[0m"
}

consoleServer(){
    echo -n -e "\033[1;33mSur quel serveur voulez vous connecter : \033[1;36m"
    read nameserver
    case $nameserver in
        $(inArrayServeur "$nameserver") )
            clear
            echo -e "\033[1;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
            echo -e "\n! N'oubliez surtout pas de faire CTRL + A + D pour sortir de la console !"
            echo -e "\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
            echo -e "\n\033[1;32mConnexion\033[5;32m...\033[0m"
            sleep 5
            screen -r $nameserver
            clear
            msgBv
            echo -e "\n\033[1;32mVous vous êtes bien déconnecté de la console du serveur \033[4;33m$nameserver\033[0m \033[1;32m!\033[0m\n" 
        ;;
        "exit" )
            quit
        ;;
        "return" )
            retour
        ;;
        * ) 
            listServer
            consoleServer $1  
        ;;
    esac
}


startServer(){
    PID=$(ps ax | grep "$1" | grep -v grep | awk '{ print $1 }')
    if [ -z "$PID" ]; then
        screen -dmS $1
        screen -S $1 -p 0 -U -X stuff "cd $chemin_serveur$1/^M"
        screen -S $1 -p 0 -U -X stuff "./$1.sh^M"
    else
        screen -S $1 -p 0 -U -X stuff "./$1.sh^M"
    fi
}


stopServer(){
    if [ "$1" = "bungee" ] || [ "$1" = "bungeecord" ] || [ "$1" = "Bungee" ] || [ "$1" = "BungeeCord" ]; then
        screen -S $1 -p 0 -U -X stuff "end^M"
    else
        screen -S $1 -p 0 -U -X stuff "stop^M"
    fi
}

restartServer(){
    if [ "$(onRunning "$1")" = "no" ]; then
        startServer "$1"
    else
        stopServer "$1"
        echo -e "\n\033[1;32mRedémarrage en cours\033[5;32m...\033[0m"
        sleep 4
        startServer "$1"
    fi
}

actionServer(){
    echo -n -e "\033[1;33mQuel serveur voulez vous $1 : \033[1;36m"
    read nameserver
    echo
    case $nameserver in
        "all" )
            stopfunction="no"
            if [ "$3" = "start" ]; then
                for i in "${serveur[@]}" 
                do
                    if [ "$(onRunning "$i")" = "no" ]; then
                        startServer "$i"
                        echo -e "\033[1;32mLe serveur \033[1;36m$i \033[1;32ma été allumé !\033[0m"
                    else
                        echo -e "\033[1;31mLe serveur \033[1;36m$i \033[1;31mest déjà allumé !\033[0m"
                        stopfunction="yes"
                    fi
                done
            elif [ "$3" = "restart" ]; then
                echo -e "\n\033[1;32mRedémarrage des serveurs en cours\033[5;32m...\033[0m"
                for i in "${serveur[@]}" 
                do
                    if [ "$(onRunning "$i")" = "no" ]; then
                        startServer "$i"
                    else
                        stopServer "$i"
                        sleep 3
                        startServer "$i"
                    fi
                done
                sleep 4
            elif [ "$3" = "stop" ]; then
                for i in "${serveur[@]}" 
                do
                    if [ "$(onRunning "$i")" = "yes" ]; then
                        stopServer "$i"
                        echo -e "\033[1;32mLe serveur \033[1;36m$i \033[1;32ma été éteint !\033[0m"
                    else
                        echo -e "\033[1;31mLe serveur \033[1;36m$i \033[1;31mest déjà éteint !\033[0m"
                        stopfunction="yes"
                    fi
                done
            fi
            if [ "$stopfunction" = "yes" ]; then
                return
            else
                retour
                echo -e "\n\033[1;32mTous les serveurs ont été "$2"s !\033[0m"
            fi 
        ;;
        $(inArrayServeur "$nameserver" ) )
            if [ "$3" = "start" ]; then 
                if [ "$(onRunning "$nameserver")" = "no" ]; then
                    startServer "$nameserver"
                else 
                    echo -e "\033[1;31mLe serveur \033[1;36m$nameserver \033[1;31mest déjà allumé !\033[0m"
                    stopfunction="yes"  
                fi 
            elif [ "$3" = "restart" ]; then
                restartServer "$nameserver"
            elif [ "$3" = "stop" ]; then
                if [ "$(onRunning "$nameserver")" = "yes" ]; then
                    stopServer "$nameserver"
                else
                    echo -e "\033[1;31mLe serveur \033[1;36m$nameserver \033[1;31mn'est pas allumé !\033[0m"
                    stopfunction="yes"
                fi
            fi
            if [ "$stopfunction" = "yes" ]; then
                return
            else
                retour
                echo -e "\n\033[1;32mLe serveur $nameserver a été $2 !\033[0m"
            fi 
        ;;
        "exit" )
            quit
        ;;
        "return" )
            retour
        ;;
        * )
            listServer
            actionServer $1
        ;;
    esac
}

statusServer(){
    clear
    msgBv
    echo -e "\n\033[1;33m----------------------- [Statuts des serveurs] -----------------------\033[0m"
    echo -e "\033[1;33mInformation de tout les serveurs :\033[0m" 
    for i in "${serveur[@]}" 
    do
        PID=$(ps ax | grep "$i".sh | grep -v grep | awk '{ print $1 }')
        if [ -z "$PID" ]; then
            echo -e "\033[1;33m - Le serveur \033[1;36m$i \033[1;33mest \033[1;31méteint \033[1;33m!"
        else
            echo -e "\033[1;33m - Le serveur \033[1;36m$i \033[1;33mest \033[1;32mallumé \033[1;33m!"
        fi
    done
    echo -e "\033[1;33m----------------------------------------------------------------------\033[0m"
}


listServer(){
    for (( i=0; i<${#serveur[@]}; i++ )) 
    do  
        if [ "${#displayserv[@]}" != "${#serveur[@]}" ]; then
            displayserv+=( "${serveur[$i]}," )
        fi
    done
    echo -e "\033[1;33mListe des serveurs disponible : \033[1;32m${displayserv[@]} all \033[0m"
}

retour(){
    clear
    msgBv
}

quit(){
    clear
    info="yes"
}


######################################################################
                    # Corp Principal du Script #
######################################################################

clear
msgBv
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
            listeCmd
        ;;
        * )
            listeCmd
        ;;
    esac
done
