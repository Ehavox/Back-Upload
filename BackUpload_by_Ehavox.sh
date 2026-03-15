#!/bin/bash

# Définition des couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
# Couleurs en gras
REDG='\033[1;31m'
YELLOWG='\033[1;33m'
CYANG='\033[1;36m'
WHITEG='\033[1;37m'
# Reset de couleur
NC='\033[0m'

#------------------
#ROOT ONLY
if [[ $EUID -ne 0 ]]; then
	echo -e "${RED}Ce script doit être exécuté en tant que root.${NC}"
	sleep 1.5
	exec sudo "$0" "$@"
fi
#------------------
#Nettoyage, MAJ et check paquets
clear && apt update >/dev/null 2<&1
if ! command -v figlet >/dev/null 2<&1; then
    echo -e "${WHITEG}• Installation des éléments de démarrage en cours. ${NC}"
    echo -n -e "${WHITEG}▷ État : ${NC}"
	apt install -y figlet lolcat >/dev/null 2<&1
    echo -e "[${GREEN}OK${NC}]"
    sleep 0.5
    mv /usr/games/lolcat /bin
fi
clear
sleep 1
#----------------------------
#----------------------------
clear
keylocate=$(find /etc -name ".B@ckupl0ad")
key="/etc/.B@ckupl0ad/keyfile.srv"
if [ "$keylocate" == "$1" ]
then
    echo -e "${PURPLE}+-----------------------------------+${NC}"
    echo -e "${PURPLE}|    ${RED}Protection de configuration    ${PURPLE}|${NC}"
    echo -e "${PURPLE}+-----------------------------------+${NC}"
    echo -e "${RED}• La clé de chiffrement n'est pas définie, merci d'en créer une :${NC}"
    echo ""
    read -s -p "Clé : " sslkey
    echo "*"
    read -s -p "Saisir à nouveau : " sslkeychk
    echo "*"
    if [ "$sslkey" == "$sslkeychk" ]
    then
        mkdir /etc/.B@ckupl0ad
        echo "$sslkey" > /etc/.B@ckupl0ad/keyfile.srv
        chmod 600 /etc/.B@ckupl0ad/keyfile.srv
        chattr +i /etc/.B@ckupl0ad/keyfile.srv
        echo "# ============================================================" > /etc/.B@ckupl0ad/credits
        echo "# Nom du script : BackUpload" >> /etc/.B@ckupl0ad/credits
        echo "# Description   : Sauvegarde de fichiers/dossiers/base de données sur un serveur distant." >> /etc/.B@ckupl0ad/credits
        echo "# Auteur        : EHAVOX" >> /etc/.B@ckupl0ad/credits
        echo "# Version       : 0.0" >> /etc/.B@ckupl0ad/credits
        echo "# Date création : 28/02/2026" >> /etc/.B@ckupl0ad/credits
        echo "# Dernière modif: 05/03/2026" >> /etc/.B@ckupl0ad/credits
        echo "# Dépendances   : bash, mysql, rsync, openssh-client, openssl, cron" >> /etc/.B@ckupl0ad/credits
        echo "# ============================================================" >> /etc/.B@ckupl0ad/credits
        echo "Licence : Personal Backup License (PBL) v1.0" >> /etc/.B@ckupl0ad/credits
        echo "" >> /etc/.B@ckupl0ad/credits
        echo "Ce logiciel est fourni gratuitement pour un usage personnel" >> /etc/.B@ckupl0ad/credits
        echo "strictement limité aux opérations de sauvegarde (backup)." >> /etc/.B@ckupl0ad/credits
        echo "" >> /etc/.B@ckupl0ad/credits
        echo "Toute utilisation commerciale est interdite." >> /etc/.B@ckupl0ad/credits
        echo "Toute modification ou redistribution doit conserver cette licence." >> /etc/.B@ckupl0ad/credits
        echo "Toute utilisation pour un autre objectif que la sauvegarde est interdite." >> /etc/.B@ckupl0ad/credits
        echo "" >> /etc/.B@ckupl0ad/credits
        echo "© 2026 EHAVOX - Tous droits réservés" >> /etc/.B@ckupl0ad/credits
        echo "# ============================================================" >> /etc/.B@ckupl0ad/credits
    else
        echo ""
        echo -e "${RED}• Erreur lors de la saisie, veuillez recommencer.${NC}"
        echo ""
        exit
    fi
fi
##########################
##########################
version=$(grep "Version" /etc/.B@ckupl0ad/credits |cut -d " " -f 10)
if [ "$version" != "1.0" ]
then
    clear
    echo -e "${PURPLE}+---------------------------------+${NC}"
    echo -e "${PURPLE}|           ${GREEN}Mise à jour           ${PURPLE}|${NC}"
    echo -e "${PURPLE}+---------------------------------+${NC}"
    echo ""
    echo -e "${GREEN}▷ Vous utilisez la première version de Back Upload, merci de lire le README.md.${NC}"
    echo ""
    echo -e "${WHITEG}Note de la version $version ${NC}:"
    echo -e "• Transfert des fichiers avec 'RSYNC'.            ${CYAN}#La version bêta faisait appel à 'SCP'.${NC}"
    echo -e "• Vérifications des saisies (IP, port, cron).     ${CYAN}#La version bêta ne le faisait pas.${NC}"
    echo "• Variable d'environnement remplacée pour la sécurité"
    echo "• Ajustement de openssl"
    sed -i 's/^# Version\s*:\s*0\.0/# Version       : 1.0/' /etc/.B@ckupl0ad/credits
    echo ""
    read -p "Appuyez sur [Entrer] pour continuer" enterscript
fi
##########################
##########################
clear
echo "Back Upload" |figlet|lolcat
echo ""
echo -e "${PURPLE} ____________________________________________________________________${NC}"
echo -e "${PURPLE}|                                                                    |${NC}"
echo -e "${PURPLE}|                ${WHITE}Panneau de configuration Back Upload${NC}                ${PURPLE}|${NC}"
echo -e "${PURPLE}|                             ${BLUES}By \e[1mEhavox\e[0m${NC}                              ${PURPLE}|${NC}"
echo -e "${PURPLE}|____________________________________________________________________|${NC}"
echo -e "${PURPLE}|                                                                    |${NC}"
echo -e "${PURPLE}|        ${WHITE}1 - Installation / Configuration.${NC}                           ${PURPLE}|${NC}"
echo -e "${PURPLE}|        ${WHITE}2 - Gestion des backups${NC}                                     ${PURPLE}|${NC}"
echo -e "${PURPLE}|        ${WHITE}3 - Quitter.${NC}                                                ${PURPLE}|${NC}"
echo -e "${PURPLE}|____________________________________________________________________|${NC}"
read -p "▷ Votre choix : " chxlst
case $chxlst in
    1)
        clear
        chkconf=$(find / -iname "config.srv")
        if [ "$chkconf" == "$1" ]
        then
            sleep 1
            echo -e "${PURPLE}+----------------------------------+${NC}"
            echo -e "${PURPLE}|      ${WHITEG}Vérifications en cours      ${PURPLE}|${NC}"
            echo -e "${PURPLE}+----------------------------------+${NC}"
            echo ""
            sleep 0.5
            echo -n -e "${WHITEG}• Internet : ${NC}"
            if ping -w 1 -c 1 9.9.9.9 &> /dev/null; then
                ip=$(hostname -I)
                host=$(hostname)
                echo -e "[${GREEN}OK${NC}]"
                echo ""
                echo -n -e "${WHITEG}• Mise à jour des dêpots : ${NC}"
                apt update >/dev/null 2<&1
                echo -e "[${GREEN}OK${NC}]"
                echo ""
                sleep 1
                echo -n -e "${WHITEG}• Installation des prérequis : ${NC}"
                apt install -y openssh-client cron rsync >/dev/null 2<&1
                echo -e "[${GREEN}OK${NC}]"
                sleep 2
                clear
                echo -e "${PURPLE}+---------------------------------+${NC}"
                echo -e "${PURPLE}|          ${WHITEG}Configuration          ${PURPLE}|${NC}"
                echo -e "${PURPLE}+---------------------------------+${NC}"
                echo -e "${WHITEG}IPv4 : ${NC}$ip"
                echo -e "${WHITEG}Hostname : ${NC}$host"
                echo ""
                echo ""
                echo -e "${YELLOWG}[ INFORMATIONS SUR LE SERVEUR DISTANT ]${NC}"
                echo ""
                echo -e "${WHITEG}Veuillez saisir l'adresse IP du serveur de sauvegarde :${NC}"
                read -p "IPv4 : " ip_srv
                REG='^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])$'
                if [[ "$ip_srv" =~ $REG  ]]
                then
                    if ping -w 1 -c 1 $ip_srv &> /dev/null; then
                        echo -e "[${GREEN}Fait${NC}] --> ${YELLOW}$ip_srv${NC}"
                    else
                        echo ""
                        echo -e "${RED}L'adresse IP ${NC}$ip_srv ${RED}ne répond pas, vérifiez son état.${NC}"
                        echo ""
                        exit
                    fi
                else
                    echo -e "${RED}Veuillez saisir un format valide.${NC} (ex : 192.168.1.1)"
                    echo ""
                    exit
                fi
                echo ""
                echo -e "${WHITEG}Veuillez saisir le hostname du serveur de sauvegarde :${NC}"
                read -p "Host : " host_srv
                echo -e "[${GREEN}Fait${NC}] --> ${YELLOW}$host_srv${NC}"
                echo ""
                echo -e "${WHITEG}Veuillez saisir le nom d'utilisateur du serveur de sauvegarde :${NC}"
                read -p "Nom d'utilisateur : " user_srv
                echo -e "[${GREEN}Fait${NC}] --> ${YELLOW}$user_srv${NC}"
                echo ""
                echo -e "${WHITEG}Veuillez saisir le port d'écoute SSH du serveur de sauvegarde :${NC}"
                read -p "Port : " port_srv
                if [[ "$port_srv" =~ ^[0-9]+$ ]] && (( port_srv == 22 | (port_srv >= 1024 && port_srv <=65535) ))
                then
                    echo -e "[${GREEN}Fait${NC}] --> ${YELLOW}$port_srv${NC}"
                else
                    echo -e "${RED}Veuillez saisir un port valide.${NC} (22 ou 1024/..../65535)"
                    echo ""
                    exit
                fi
                sleep 2
                clear
                echo -e "${PURPLE}+----------------------------------+${NC}"
                echo -e "${PURPLE}|          ${WHITEG}Initialisation          ${PURPLE}|${NC}"
                echo -e "${PURPLE}+----------------------------------+${NC}"
                echo ""
                echo -n -e "${WHITEG}• Transcription et chiffrement des données : ${NC}"
                tempfile=(mktemp)
                configfile="config.srv"
                echo "Informations du serveur des backups :" > $tempfile
                echo "IP : $ip_srv" >> $tempfile
                echo "Hostname : $host_srv" >> $tempfile
                echo "Username : $user_srv" >> $tempfile
                echo "Port : $port_srv" >> $tempfile
                sleep 1
                openssl enc -aes-256-cbc -salt -pbkdf2 -iter 100000 -in "$tempfile" -out "$configfile" -pass file:"$key"
                sleep 1
                rm "$tempfile"
                sleep 1
                chattr +i $configfile
                echo -e "[${GREEN}OK${NC}]"
                sleep 0.5
                echo -n -e "${WHITEG}• Ajout du nouvel host (${NC}$host_srv${WHITEG}) : ${NC}"
                sleep 1
                echo "" >> /etc/hosts
                echo "######--Serveur_BACKUP--######" >> /etc/hosts
                echo "" >> /etc/hosts
                echo -e "$ip_srv\t$host_srv" >> /etc/hosts
                echo "" >> /etc/hosts
                echo "##############################" >> /etc/hosts
                echo "" >> /etc/hosts
                echo -e "[${GREEN}OK${NC}]"
                sleep 1
                echo ""
                echo ""
                clear
                echo -e "${PURPLE}+---------------------------------+${NC}"
                echo -e "${PURPLE}|          ${WHITEG}Identification         ${PURPLE}|${NC}"
                echo -e "${PURPLE}+---------------------------------+${NC}"
                echo ""
                echo -e "${CYANG}NB : choisissez 'n' si une backup par crontab est prévue.${NC}"
                echo -e "${WHITEG}Souhaitez-vous une passphrase pour la clé SSH ? : ${NC}"
                read -p "(o/n) : " chx_pass
                case $chx_pass in
                    o|O|OUI|oui|y|Y|YES|yes)
                        echo ""
                        echo -e "${WHITEG}Tapez votre passphrase : ${NC}"
                        read pass
                        echo ""
                        echo -n -e "${WHITEG}• Création de la clé SSH : ${NC}"
                        sleep 2
                        ssh-keygen -t ed25519 -a 100 -f "/root/.ssh/id_serveurBACKUP" -N "$pass" >/dev/null 2<&1
                        sleep 1
                        echo -e "[${GREEN}OK${NC}]"
                        echo ""
                        echo -e "${GREEN}1.${NC} Établissez une première connexion avec : '${YELLOWG}ssh-copy-id -i ~/.ssh/id_serveurBACKUP.pub -p $port_srv $user_srv@$host_srv${NC}'."
                        echo -e "${GREEN}2.${NC} Puis, connectez vous une première fois : '${YELLOWG}ssh -i /root/.ssh/id_serveurBACKUP -p $port_srv $user_srv@$host_srv${NC}'"
                        ;;

                    n|N|NON|non|NO|no)
                        echo ""
                        echo -n -e "${WHITEG}• Création de la clé SSH : ${NC}"
                        sleep 2
                        ssh-keygen -t ed25519 -a 100 -f "/root/.ssh/id_serveurBACKUP" -N "" >/dev/null 2<&1
                        sleep 1
                        echo -e "[${GREEN}OK${NC}]"
                        echo ""
                        echo -e "${GREEN}1.${NC} Établissez une première connexion avec : '${YELLOWG}ssh-copy-id -i ~/.ssh/id_serveurBACKUP.pub -p $port_srv $user_srv@$host_srv${NC}'."
                        echo -e "${GREEN}2.${NC} Puis, connectez vous une première fois : '${YELLOWG}ssh -i /root/.ssh/id_serveurBACKUP -p $port_srv $user_srv@$host_srv${NC}'"
                        ;;
                    *)
		                echo -e "${RED}Aucune option ne correspond à votre requête, veuillez recommencer.${NC}"
                        echo -n -e "${WHITEG}• Annulation en cours : ${NC}"
                        chattr -i $configfile
                        rm $configfile
                        sed -i '/######--Serveur_BACKUP--######$/,/^##############################$/d' /etc/hosts
                        echo -e "[${GREEN}OK${NC}]"
		                exit
		                ;;
                esac
                echo ""
                echo ""
                echo -e "${WHITEG}• L'installation terminée. Vous pouvez maintenant effectuer vos sauvegardes${NC}"
                echo "Merci d'avoir choisi Back Upload."
                echo ""
            else
                echo -e "[${RED}Échec${NC}]"
                echo ""
                echo -e "${WHITEG}Impossible d'accéder à internet, verifiez votre connexion.${NC}"
                exit
            fi
        else
            echo -e "${PURPLE}+------------------------------------+${NC}"
            echo -e "${PURPLE}|          ${WHITEG}Reinitialisation          ${PURPLE}|${NC}"
            echo -e "${PURPLE}+------------------------------------+${NC}"
            echo ""
            echo -e "${WHITEG}Vous avez déjà une configuration, voulez-vous la supprimer ?${NC}"
            read -p "(o/n) : " chx_pass
            case $chx_pass in
                o|O|OUI|oui|y|Y|YES|yes)
			        echo -e "\e[5mCTRL+C\e[0m pour annulé"
			        echo ""
			        i=10
			        while [[ "$i" -ne "-1" ]]; do
			        	echo -ne "${RED}\rLa suppression de Back Upload commence dans exactement${NC} $i ${RED}secondes${NC}"
			        	((i--))
			        	sleep 1
			        done
			        echo ""
			        ascii=(
			        	" _____.,-#%&$@%#&#~,._____"
			        	"          | ;  :|    "
			        	"       '-=#$%&%$#=-'   "
			        	"       .-=||  | |=-.   "
			        	"         | |   |            "
			        	"    '''--. . , ; .--'''     "
			        	" \\._                   _./   "
			        	"|                         |   "
			        	"<                        >)   "
			        	" _--                  —-_   "
			        	"    _.-^^---....,,--  "
			        )
			        for ((i = ${#ascii[@]} - 1; i >= 0; i--)); do
			        	echo -e "${ascii[$i]}"
			        	sleep 0.2
			        done
                    echo -n -e "${RED}• Suppression en cours : ${NC}"
                    chattr -i $chkconf
                    rm $chkconf
                    sleep 0.5
                    sed -i '/######--Serveur_BACKUP--######$/,/^##############################$/d' /etc/hosts
                    sleep 0.5
                    rm ~/.ssh/id_serveurBACKUP* >/dev/null 2<&1
                    chattr -R -i ~/.crontabSRV/* >/dev/null 2<&1
                    rm -d -R ~/.crontabSRV/ >/dev/null 2<&1
                    sed -i '/#####BACKUP-CRON#####$/,/^#####################$/d' /etc/crontab
                    chattr -i /etc/.B@ckupl0ad/keyfile.srv
                    rm -R -d /etc/.B@ckupl0ad
                    sleep 0.5
                    echo -e "[${GREEN}OK${NC}]"
                    echo ""
                    echo -e "${RED}▼ ${NC}${WHITEG}Configuration supprimée. Lancez à nouveau le programme pour une nouvelle installation.${NC}"
                    echo ""
                    exit
                    ;;

                n|N|NON|non|NO|no)
                    exit
                    ;;
                *)
		            echo -e "${RED}Aucune option ne correspond à votre requête, veuillez recommencer.${NC}"
                    echo -n -e "${WHITEG}• Annulation en cours : ${NC}"
                    echo -e "[${GREEN}OK${NC}]"
		            exit
		            ;;
            esac
        fi
        ;;
    2)
        clear
        chkconf=$(find / -iname "config.srv")
        if [ "$chkconf" == "$1" ]
        then
            echo ""
            echo -e "${RED}Il est nécessaire d'installer le programme avant de procéder à cette opération.${NC}"
            echo ""
            exit
        fi
        if ping -w 1 -c 1 9.9.9.9 &> /dev/null; then
            echo -e "${PURPLE} ____________________________________________________________________${NC}"
            echo -e "${PURPLE}|                                                                    |${NC}"
            echo -e "${PURPLE}|                         ${WHITE}Gestion des backups${NC}                        ${PURPLE}|${NC}"
            echo -e "${PURPLE}|                              ${BLUES}By \e[1mEhavox\e[0m${NC}                             ${PURPLE}|${NC}"
            echo -e "${PURPLE}|____________________________________________________________________|${NC}"
            echo -e "${PURPLE}|                                                                    |${NC}"
            echo -e "${PURPLE}|        ${WHITE}▷ Que voulez-vous faire :${NC}                                   ${PURPLE}|${NC}"
            echo -e "${PURPLE}|                                                                    ${PURPLE}|${NC}"
            echo -e "${PURPLE}|        ${WHITE}1 - Créer une sauvegarde.${NC}                                   ${PURPLE}|${NC}"
            echo -e "${PURPLE}|        ${WHITE}2 - Créer une sauvegarde avec crontab.${NC}                      ${PURPLE}|${NC}"
            echo -e "${PURPLE}|        ${WHITE}3 - Quitter.${NC}                                                ${PURPLE}|${NC}"
            echo -e "${PURPLE}|____________________________________________________________________|${NC}"
            read -p "▷ Votre choix : " chx_bck
            case $chx_bck in
                1)
                    clear
                    echo -e "${PURPLE}+----------------------------------+${NC}"
                    echo -e "${PURPLE}|      ${WHITEG}Création d'une  backup      ${PURPLE}|${NC}"
                    echo -e "${PURPLE}+----------------------------------+${NC}"
                    echo ""
                    echo -e "${WHITEG}▷ Quel type de sauvegarde :${NC}"
                    echo ""
                    echo -e "${GREEN}1. ${YELLOWG}Fichier/Dossier${NC}"
                    echo -e "${GREEN}2. ${YELLOWG}Base de données.${NC} (MariaDB)"
                    echo ""
                    read -p "Votre choix : " chx_elem
                    case $chx_elem in
                        1)
                            #######################################-Fonction-début
                            function compildoc() {
                                echo ""
                                bcktempfile="backupSRV"
                                DATE=$(date +%F)
                                FILENAME="backup_files_serveur_du_${DATE}.tar.gz"
                                mkdir -p ./$bcktempfile
                                while true; do
                                    echo ""
                                    echo -e "${WHITEG}▶ Tapez le chemin absolu du fichier à sauvegarder :${NC}"
                                    read -p "Chemin : " filename
                                    echo ""
                                    cp -R $filename $bcktempfile
                                    echo -e "${YELLOW}$filename${NC} ajouté."
                                    echo ""
                                    echo -e "${WHITEG}▶ Souhaitez-vous ajouter un autre fichier/dossier ?${NC}"
                                    read -p "(o/n) : " conf2
                                    case $conf2 in
                                        o|O|oui|OUI|y|Y|yes|YES)
                                            continue
                                            ;;
                                        n|N|non|NON|no|NO)
                                            break
                                            ;;
                                        *)
                                            echo -e "${RED}Aucune option ne correspond à votre requête, veuillez recommencer.${NC}"
                                            echo -n -e "${WHITEG}• Annulation en cours : ${NC}"
                                            echo -e "[${GREEN}OK${NC}]"
                                            exit
                                            ;;
                                    esac
                                done
                            }
                            #######################################-Fonction-fin
                            compildoc
                            clear
                            echo -e "${PURPLE}+-------------------------------+${NC}"
                            echo -e "${PURPLE}|      ${WHITEG}Sauvegarde en cours      ${PURPLE}|${NC}"
                            echo -e "${PURPLE}+-------------------------------+${NC}"
                            echo ""
                            echo -n -e "${WHITEG}• Compression de $bcktempfile : ${NC}"
                            sleep 1
                            tar -czf "$FILENAME" $bcktempfile
                            sleep 1
                            rm -R $bcktempfile
                            sleep 0.5
                            echo -e "[${GREEN}OK${NC}]"
                            echo -n -e "${WHITEG}• Lecture de 'config.srv' : ${NC}"
                            sleep 1
                            chattr -i $chkconf
                            openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 -in "$chkconf" -out "config.txt" -pass file:$key
                            sleep 1
                            ipcom=$(cat config.txt | grep "IP" | cut -d " " -f 3)
                            hostcom=$(cat config.txt | grep "Host" | cut -d " " -f 3)
                            usercom=$(cat config.txt | grep "User" | cut -d " " -f 3)
                            portcom=$(cat config.txt | grep "Port" | cut -d " " -f 3)
                            sleep 1
                            echo -e "[${GREEN}OK${NC}]"
                            echo ""
                            echo -e "${WHITEG}• Téléversement de $FILENAME vers $hostcom : ${NC}"
                            sleep 1
                            echo ""
                            rsync -avz -e "ssh -p $portcom -i ~/.ssh/id_serveurBACKUP" "$FILENAME" $usercom@$hostcom:/home/$usercom/
                            sleep 1
                            rm config.txt
                            rm $FILENAME
                            chattr +i $chkconf
                            echo ""
                            echo -n -e "${WHITEG}▷ Téléversement : [${NC}${GREEN}OK${NC}${WHITEG}]${NC}"
                            echo ""
                            ;;
                        2)
                            #######################################-Fonction-début
                            function compilbdd() {
                                echo ""
                                bcktempfile="backupSQL"
                                DATE=$(date +%F)
                                FILENAME="backup_SQL_serveur_du_${DATE}.tar.gz"
                                mkdir -p ./$bcktempfile
                                while true; do
                                    echo ""
                                    mysql -e "show databases;"
                                    echo -e "${WHITEG}▶ Quelle base de données souhaitez-vous sauvegarder :${NC}"
                                    read -p "Base de données : " bdd
                                    echo ""
                                    mysqldump $bdd > $bcktempfile/$bdd.sql
                                    echo -e "${YELLOW}$bdd${NC} ajouté."
                                    echo ""
                                    echo -e "${WHITEG}▶ Souhaitez-vous ajouter une nouvelle base de données ?${NC}"
                                    read -p "(o/n) : " conf2
                                    case $conf2 in
                                        o|O|oui|OUI|y|Y|yes|YES)
                                            continue
                                            ;;
                                        n|N|non|NON|no|NO)
                                            break
                                            ;;
                                        *)
                                            echo -e "${RED}Aucune option ne correspond à votre requête, veuillez recommencer.${NC}"
                                            echo -n -e "${WHITEG}• Annulation en cours : ${NC}"
                                            echo -e "[${GREEN}OK${NC}]"
                                            exit
                                            ;;
                                    esac
                                done
                            }
                            #######################################-Fonction-fin
                            if systemctl list-unit-files --type=service | grep -o mariadb.service; then
                                compilbdd
                                clear
                                echo -e "${PURPLE}+-------------------------------+${NC}"
                                echo -e "${PURPLE}|      ${WHITEG}Sauvegarde en cours      ${PURPLE}|${NC}"
                                echo -e "${PURPLE}+-------------------------------+${NC}"
                                echo ""
                                echo -n -e "${WHITEG}• Compression de $bcktempfile : ${NC}"
                                sleep 1
                                tar -czf "$FILENAME" $bcktempfile
                                sleep 1
                                rm -R $bcktempfile
                                sleep 0.5
                                echo -e "[${GREEN}OK${NC}]"
                                echo -n -e "${WHITEG}• Lecture de 'config.srv' : ${NC}"
                                sleep 1
                                chattr -i $chkconf
                                openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 -in "$chkconf" -out "config.txt" -pass file:$key
                                sleep 1
                                ipcom=$(grep "IP" config.txt |cut -d " " -f 3)
                                hostcom=$(grep "Host" config.txt |cut -d " " -f 3)
                                usercom=$(grep "User" config.txt |cut -d " " -f 3)
                                portcom=$(grep "Port" config.txt |cut -d " " -f 3)
                                sleep 1
                                echo -e "[${GREEN}OK${NC}]"
                                echo ""
                                echo -e "${WHITEG}• Téléversement de $FILENAME vers $hostcom : ${NC}"
                                sleep 1
                                echo ""
                                rsync -avz -e "ssh -p $portcom -i ~/.ssh/id_serveurBACKUP" "$FILENAME" $usercom@$hostcom:/home/$usercom/
                                sleep 1
                                rm config.txt
                                rm $FILENAME
                                chattr +i $chkconf
                                echo ""
                                echo -n -e "${WHITEG}▷ Téléversement : [${NC}${GREEN}OK${NC}${WHITEG}]${NC}"
                                echo ""
                            else
                                echo -e "${RED}Le service de base de données MariaDB n'est pas installé.${NC}"
                                exit
                            fi
                            ;;
                        *)
                            echo -e "${RED}Aucune option ne correspond à votre requête, veuillez recommencer.${NC}"
                            echo -n -e "${WHITEG}• Annulation en cours : ${NC}"
                            echo -e "[${GREEN}OK${NC}]"
                            exit
                            ;;
                    esac
                    ;;
                2)
                    clear
                    echo -e "${PURPLE}+---------------------------------------+${NC}"
                    echo -e "${PURPLE}|      ${WHITEG}Sauvegarde automatique cron      ${PURPLE}|${NC}"
                    echo -e "${PURPLE}+---------------------------------------+${NC}"
                    echo ""
			        echo -e "${CYAN}▷ Tapez ci-dessous la fréquence de sauvagarde au format cron :${NC} (voir : ${CYANG}https://crontab.guru${NC})"
                    echo "Veuillez séparer les caractères par des '.', le programme ajustera les espacements par la suite. (ex : *.*.*.*.*)"
                    echo ""
			        read -p "▷ cron schedule  : " cron_time
                    REGcron='^([0-9a-z*/,@-]+\.){4}[0-9a-z*/,@-]+$'
                    if [[ "$cron_time" =~ $REGcron ]]
                    then
                        format=$(echo "$cron_time" | tr "." " ")
                    else
                        echo -e "${RED}Veuillez respecter le format cron.${NC} (voir la doc ci-dessus si nécessaire)"
                        echo ""
                        exit
                    fi
                    echo ""
                    echo -e "${PURPLE}+------------------------------------------------+${NC}"
                    echo -e "${PURPLE}|      ${WHITEG}Initialisation de la sauvagarde cron      ${PURPLE}|${NC}"
                    echo -e "${PURPLE}+------------------------------------------------+${NC}"
                    echo ""
                    echo -e "${WHITEG}▷ Quel type de sauvegarde :${NC}"
                    echo ""
                    echo -e "${GREEN}1. ${YELLOWG}Fichier/Dossier${NC}"
                    echo -e "${GREEN}2. ${YELLOWG}Base de données.${NC} (MariaDB)"
                    echo ""
                    read -p "Votre choix : " chx_elem
                    case $chx_elem in
                        1)
                            #######################################-Fonction-début
                            function crondoc() {
                                configfile=$(echo "$chkconf")
                                mkdir -p /root/.crontabSRV/docBackup
                                cp $configfile /root/.crontabSRV/docBackup
                                echo ""
                                echo -e "${WHITEG}Tapez un nom de fichier (il servira uniquement au service cron) :${NC}"
                                read -p "Nom (sans extension) : " cron_name
                                echo ""
                                echo -e "${YELLOW}$cron_name${NC} a été défini."
                                echo ""
                                touch /root/.crontabSRV/docBackup/$cron_name.sh
                                bckfile="/root/.crontabSRV/docBackup/bck.file"
                                echo '#!/bin/bash' >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                while true; do
                                    echo -e "${WHITEG}▶ Tapez le chemin absolu du fichier à sauvegarder :${NC}"
                                    read -p "Chemin : " cron_file_abs
                                    echo ""
                                    echo "$cron_file_abs" >> $bckfile
                                    echo -e "${YELLOW}$cron_file_abs${NC} ajouté."
                                    echo ""
                                    echo -e "${WHITEG}▶ Souhaitez-vous ajouter un autre fichier/dossier ?${NC}"
                                    read -p "(o/n) : " conf2
                                    case $conf2 in
                                        o|O|oui|OUI|y|Y|yes|YES)
                                            continue
                                            ;;
                                        n|N|non|NON|no|NO)
                                            break
                                            ;;
                                        *)
                                            echo -e "${RED}Aucune option ne correspond à votre requête, veuillez recommencer.${NC}"
                                            echo -n -e "${WHITEG}• Annulation en cours : ${NC}"
                                            echo -e "[${GREEN}OK${NC}]"
                                            exit
                                            ;;
                                    esac
                                done
                                clear
                                echo -e "${WHITEG}▷ Configuration de la tâche cron en cours${NC}"
                                echo ""
                                echo -n -e "• Définiton des variables : "
                                echo "cd ~/.crontabSRV/docBackup/" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "files=\"bck.file\"" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "bcktempfile=\"backup_SRV_docs\"" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "DATE=\$(date +%F)" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "FILENAME=\"backup_files_serveur_du_\${DATE}.tar.gz\"" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "mkdir -p \$bcktempfile" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo -e "[${GREEN}OK${NC}]"
                                sleep 1

                                echo -n -e "• Création du fichier de service : "
                                echo "sleep 0.5" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "while read -r fichiers" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "do" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "cp -R \"\$fichiers\" \$bcktempfile" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "done < \$files" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo -e "[${GREEN}OK${NC}]"
                                sleep 1

                                echo -n -e "• Application de la compression : "
                                echo "sleep 1" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "tar -czf \"\$FILENAME\" \$bcktempfile" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "rm -R \$bcktempfile" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo -e "[${GREEN}OK${NC}]"
                                sleep 1

                                echo -n -e "• Déchiffrage du fichier de configuration du serveur : "
                                echo "sleep 1" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "chattr -i config.srv" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "sleep 1" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 -in \"config.srv\" -out \"config.txt\" -pass file:$key" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "sleep 1" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo -e "[${GREEN}OK${NC}]"
                                sleep 1

                                echo -n -e "• Définition de nouvelles variables : "
                                echo "ipcom=\$(grep \"IP\" config.txt |cut -d \" \" -f 3)" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "hostcom=\$(grep \"Host\" config.txt |cut -d \" \" -f 3)" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "usercom=\$(grep \"User\" config.txt |cut -d \" \" -f 3)" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "portcom=\$(grep \"Port\" config.txt |cut -d \" \" -f 3)" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "sleep 1" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo -e "[${GREEN}OK${NC}]"
                                sleep 1

                                echo -n -e "• Ajout de la communication distante : "
                                echo "rsync -az -e \"ssh -p \$portcom -i ~/.ssh/id_serveurBACKUP\" \"\$FILENAME\" \$usercom@\$hostcom:/home/\$usercom/" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "sleep 3" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "rm config.txt" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "rm \$FILENAME" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "chattr +i config.srv" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "cd ~" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo "exit" >> /root/.crontabSRV/docBackup/$cron_name.sh
                                echo -e "[${GREEN}OK${NC}]"
                                sleep 1

                                echo -n -e "• Chiffrement du fichier cron : "
                                sleep 0.5
                                echo -e "[${GREEN}OK${NC}]"
                                sleep 0.5
                                chattr +i $bckfile
                                echo "#####BACKUP-CRON#####" >> /etc/crontab
                                echo "$format root /root/.crontabSRV/docBackup/$cron_name.sh" >> /etc/crontab
                                chmod 700 -R ~/.crontabSRV/ >/dev/null 2<&1
                                echo "#####################" >> /etc/crontab
                                sleep 1

                                systemctl restart cron
                                sleep 3
                                clear
                                echo ""
                                echo -e "${PURPLE}+----------------------------------+${NC}"
                                echo -e "${PURPLE}|      ${GREEN}Initialisation terminée     ${PURPLE}|${NC}"
                                echo -e "${PURPLE}+----------------------------------+${NC}"
                                echo ""
                                echo -e "${WHITEG}La configuration du service de sauvegarde via cron est terminée.${NC}"
                                echo ""
                                echo -e "${WHITEG}• Fichiers qui seront sauvegardés :${NC}"
                                cat $bckfile
                                echo ""
                                echo -e "${WHITEG}• Fréquence :${NC} $format"
                                echo ""
                                echo "-----------------"
                                echo ""
                                exit
                            }
                            #######################################-Fonction-fin
                            crondoc
                            ;;
                        2)
                            function cronbdd() {
                                if systemctl list-unit-files --type=service | grep -o mariadb.service >/dev/null 2<&1; then
                                    configfile=$(echo "$chkconf")
                                    mkdir -p /root/.crontabSRV/BddBackup
                                    cp $configfile /root/.crontabSRV/BddBackup >/dev/null 2<&1
                                    echo ""
                                    echo -e "${WHITEG}Tapez un nom de fichier (il servira uniquement au service cron) :${NC}"
                                    read -p "Nom (sans extension) : " cron_name
                                    echo ""
                                    echo -e "${YELLOW}$cron_name${NC} a été défini."
                                    echo ""
                                    touch /root/.crontabSRV/BddBackup/$cron_name.sh
                                    bckfile="/root/.crontabSRV/BddBackup/bck.bdd"
                                    echo '#!/bin/bash' >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    while true; do
                                        mysql -e "show databases;"
                                        echo -e "${WHITEG}▶ Quelle base de données souhaitez-vous sauvegarder :${NC}"
                                        read -p "Base de données : " cron_bdd
                                        echo ""
                                        echo "$cron_bdd"  >> $bckfile
                                        echo -e "${YELLOW}$cron_bdd${NC} ajoutée."
                                        echo ""
                                        echo -e "${WHITEG}▶ Souhaitez-vous ajouter une nouvelle base de données ?${NC}"
                                        read -p "(o/n) : " conf2
                                        case $conf2 in
                                            o|O|oui|OUI|y|Y|yes|YES)
                                                continue
                                                ;;
                                            n|N|non|NON|no|NO)
                                                break
                                                ;;
                                            *)
                                                echo -e "${RED}Aucune option ne correspond à votre requête, veuillez recommencer.${NC}"
                                                echo -n -e "${WHITEG}• Annulation en cours : ${NC}"
                                                echo -e "[${GREEN}OK${NC}]"
                                                exit
                                                ;;
                                        esac
                                    done
                                    clear
                                    echo -e "${WHITEG}▷ Configuration de la tâche cron en cours${NC}"
                                    echo ""
                                    echo -n -e "• Définiton des variables : "
                                    echo "cd ~/.crontabSRV/BddBackup/" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "files=\"bck.bdd\"" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "bcktempfile=\"backup_SRV_SQL\"" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "DATE=\$(date +%F)" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "FILENAME=\"backup_SQL_serveur_du_\${DATE}.tar.gz\"" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "mkdir -p \$bcktempfile" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo -e "[${GREEN}OK${NC}]"
                                    sleep 1

                                    echo -n -e "• Création du fichier de service : "
                                    echo "sleep 0.5" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "while read -r databases" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "do" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "mysqldump \"\$databases\" > \$bcktempfile/\$databases.sql" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "done < \$files" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo -e "[${GREEN}OK${NC}]"
                                    sleep 1

                                    echo -n -e "• Application de la compression : "
                                    echo "sleep 1" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "tar -czf \"\$FILENAME\" \$bcktempfile" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "rm -R \$bcktempfile" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo -e "[${GREEN}OK${NC}]"
                                    sleep 1

                                    echo -n -e "• Déchiffrage du fichier de configuration du serveur : "
                                    echo "sleep 1" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "chattr -i config.srv" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "sleep 1" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "openssl enc -d -aes-256-cbc -pbkdf2 -iter 100000 -in \"config.srv\" -out \"config.txt\" -pass file:$key" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "sleep 1" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo -e "[${GREEN}OK${NC}]"
                                    sleep 1

                                    echo -n -e "• Définition de nouvelles variables : "
                                    echo "ipcom=\$(grep \"IP\" config.txt |cut -d \" \" -f 3)" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "hostcom=\$(grep \"Host\" config.txt |cut -d \" \" -f 3)" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "usercom=\$(grep \"User\" config.txt |cut -d \" \" -f 3)" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "portcom=\$(grep \"Port\" config.txt |cut -d \" \" -f 3)" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "sleep 1" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo -e "[${GREEN}OK${NC}]"
                                    sleep 1

                                    echo -n -e "• Ajout de la communication distante : "
                                    echo "rsync -az -e \"ssh -p \$portcom -i ~/.ssh/id_serveurBACKUP\" \"\$FILENAME\" \$usercom@\$hostcom:/home/\$usercom/" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "sleep 1" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "rm config.txt" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "rm \$FILENAME" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "chattr +i config.srv" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "cd ~" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo "exit" >> /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo -e "[${GREEN}OK${NC}]"
                                    sleep 1

                                    echo -n -e "• Chiffrement du fichier cron : "
                                    sleep 0.5
                                    chmod +x /root/.crontabSRV/BddBackup/$cron_name.sh
                                    echo -e "[${GREEN}OK${NC}]"
                                    sleep 0.5
                                    chattr +i $bckfile
                                    echo "#####BACKUP-CRON#####" >> /etc/crontab
                                    echo "$format root /root/.crontabSRV/BddBackup/$cron_name.sh" >> /etc/crontab
                                    chmod 700 -R ~/.crontabSRV/ >/dev/null 2<&1
                                    echo "#####################" >> /etc/crontab
                                    sleep 1

                                    systemctl restart cron
                                    sleep 3
                                    clear
                                    echo ""
                                    echo -e "${PURPLE}+----------------------------------+${NC}"
                                    echo -e "${PURPLE}|      ${GREEN}Initialisation terminée     ${PURPLE}|${NC}"
                                    echo -e "${PURPLE}+----------------------------------+${NC}"
                                    echo ""
                                    echo -e "${WHITEG}La configuration du service de sauvegarde via cron est terminée.${NC}"
                                    echo ""
                                    echo -e "${WHITEG}• Fichiers qui seront sauvegardés :${NC}"
                                    cat $bckfile
                                    echo ""
                                    echo -e "${WHITEG}• Fréquence :${NC} $format"
                                    echo ""
                                    echo "-----------------"
                                    echo ""
                                    exit
                                else
                                    echo -e "${RED}Le service de base de données MariaDB n'est pas installé.${NC}"
                                    exit
                                fi
                            }
                            cronbdd
                            ;;
                    esac

                    ;;
                3)
                    echo ""
                	echo "Au revoir !" | figlet
			        sleep 2
			        clear
			        exit
                    ;;
                *)
		            echo -e "${RED}Aucune option ne correspond à votre requête, veuillez recommencer.${NC}"
                    echo -n -e "${WHITEG}• Annulation en cours : ${NC}"
                    echo -e "[${GREEN}OK${NC}]"
		            exit
		            ;;
            esac
        else
            echo -e "[${RED}Échec${NC}]"
            echo ""
            echo -e "${WHITEG}Impossible d'accéder à internet, verifiez votre connexion.${NC}"
            exit
        fi
        ;;
    3)
        echo ""
        echo "Au revoir !" | figlet
		sleep 2
		clear
		exit
        ;;
    *)
        echo -e "${RED}Aucune option ne correspond à votre requête, veuillez recommencer.${NC}"
        echo -n -e "${WHITEG}• Annulation en cours : ${NC}"
        echo -e "[${GREEN}OK${NC}]"
        ;;
esac