# MC-Server-Management
bash <(curl -s https://cdn.easyx.fr/mcsvmn/install.sh)
# Prérequis : 
- Avoir installer screen (apt-get install screen)
- Avoir installer java (apt-get install default-jdk)

# Installation :
- Télécharger le fichier server_management.sh
- Envoyé le sur votre serveur et placé le ou vous voulez
- Ensuite exécuté le avec la commande suivante : bash chemin_du_fichier/server_management.sh

Si vous le souhaiter vous pouvez vous faire un racourcci pour exécuter le script :
- Connectez vous en root à votre machine
- Ensuite aller dans le dossier /root/
- Exécuter la commande : nano .bashrc 
- Maintenant vous allez ajouté la ligne suivante : alias mc='chemin_du_fichier/server_management.sh'
- Faites Ctrl + X, taper yes ou oui et enter

Maintenant si vous tapez mc sur votre ligne de commande cela vous ouvrira directement le script !

# Compatibilitées :
Ce script est écrit en bash et il a été tester uniquement sur Debian.

Je vous recommande donc de configurer votre machine sous Debian 9 ou Debian 10 pour éviter tout risque de non-compatibilité.
