#!/bin/bash
# Script de mise à jour de la version d'Omeka S
# Répertoire d'omekaupgrade à localiser au même niveau que les sites Omeka S à mettre à jour (sous "www" ou "data")
# installation : git clone https://github.com/pcouchet/omekaupgrade.git 
#
# Paramètre 1. nom du répertoire du site Omeka S à mettre à jour 
# Paramètre 2. version d'Omeka S souhaitée
#
# Deux répertoires sont créés : /omeka-2.7.1 (nouvelle version) et /omekabackup/aian (sauvegarde des fichiers modifiés) 
#
# ex : ./upgrade-omeka-s.sh
#

echo "Bienvenue dans l'interface de mise à jour d'Omeka S"

# 1. Site du répertoire courant à upgrader, ex : batadata, répertoire des sauvegardes
echo "1. Nom de répertoire du site à mettre à jour ?"
read SITE
if [ -d "../$SITE" ];
 then
  echo "1. Le répertoire du site Omeka S $SITE existe bien";
 else
  echo "1. Le répertoire du site Omeka S $SITE n'existe pas"
  exit 1
fi
echo -e "\n"
mkdir ./omekabackup/$SITE

# 1.5 Sauvegarde de la base MySql
echo -e "Voulez-vous sauvegarder la base (fortement recommandé pour revenir en arrière) ? [O/N]\n"
read DB_BACKUP
if [ "$DB_BACKUP" = "O" ]
then
	echo "Sauvegardez via phpMyAdmin avant de poursuivre"
fi

# 2. Version d'omeka S à mettre en place, ex : 3.0.1
echo "2. Version d'Omeka S souhaitée ?"
read OMEKA_V
# Configuration URL téléchargement
URL_OMEKA=https://github.com/omeka/omeka-s/releases/download/v$OMEKA_V/omeka-s-$OMEKA_V.zip
# Récupération du fichier
if [ -e ./omekadownload/omeka-s-$OMEKA_V.zip ]
then
  echo "2.1 Le fichier omeka-s-$OMEKA_V.zip a déjà été téléchargé"
else
  echo "2.1 Fichier en cours de téléchargement"
	wget -P ./omekadownload $URL_OMEKA
fi

# 2.2 Dezip dans répertoire du nom de la version, ex : ./omekadownload/omeka-s-3.0.1/omeka-s
if [ -d ./omekadownload/omeka-s-$OMEKA_V ]; then
  echo "2.2 Le fichier est décompressé dans ./omekadownload/omeka-s-$OMEKA_V"
else
  echo "2.2 Fichier en cours de décompression"
  mkdir ./omekadownload/omeka-s-$OMEKA_V
  unzip ./omekadownload/omeka-s-$OMEKA_V.zip -d ./omekadownload/omeka-s-$OMEKA_V
fi
echo -e "\n"

# 3. Sauvegarde des fichiers de configuration et personnalisés
echo "3.2 Sauvegarde des fichiers personnalisés dans ./omekabackup/$SITE"
cp ../$SITE/.htaccess ./omekabackup/$SITE/
cp ../$SITE/favicon.ico ./omekabackup/$SITE/
cp ../$SITE/config/database.ini ./omekabackup/$SITE/    
cp ../$SITE/config/local.config.php ./omekabackup/$SITE/    
echo -e "\n"

# 4. Suprression des répertoires /application, /vendor et des fichiers à la racine
# les répertoires /config, /files, /logs, /modules, /themes et leurs contenus sont préservés
echo -e "4. Suppression des répertoires de l'ancienne version et des fichiers à la racine\n"
rm -rf ../$SITE/application
rm -rf ../$SITE/vendor
find ../$SITE/ -maxdepth 1 -type f -delete

# 5. Copie des répertoires /application, /vendor et des fichiers à la racine
# de la nouvelle version
echo -e "5. Copie des répertoires /application, /vendor et des fichiers à la racine de $SITE\n"
cp -R ./omekadownload/omeka-s-$OMEKA_V/omeka-s/application ../$SITE/
cp -R ./omekadownload/omeka-s-$OMEKA_V/omeka-s/vendor ../$SITE/
cp ./omekadownload/omeka-s-$OMEKA_V/omeka-s/*.* ../$SITE/
cp ./omekadownload/omeka-s-$OMEKA_V/omeka-s/.htaccess ../$SITE/
cp ./omekadownload/omeka-s-$OMEKA_V/omeka-s/LICENSE ../$SITE/

# 6. Copie des fichiers sauvegardés de la racine
echo -e "6. Copie des fichiers de configuration sauvegardés du site $SITE\n"
cp ./omekabackup/$SITE/.htaccess ../$SITE/
cp ./omekabackup/$SITE/favicon.ico ../$SITE/

echo -e "7. End\n"

