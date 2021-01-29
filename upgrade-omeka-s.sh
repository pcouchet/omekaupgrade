#!/bin/bash
# Premier paramètre le répertoire du site à migrer, deuxième la version d'Omeka Classic
# ex : ./upgrade-omeka.sh aian 2.7.1
#
# Deux répertoires sont créés : /omeka-2.7.1 (nouvelle version) et /omekabackup/aian (sauvegarde des fichiers modifiés) 
#
# ex : ./upgrade-omeka-s.sh
#

# SITE : nom du site, nom du répertoire à mettre à jour, exemple "aian"
echo "Bienvenue dans l'interface de mise à jour d'Omeka S"

# 1. Site du répertoire courant à upgrader, ex : batadata
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

# 3. Sauvegarde des fichiers de configuration
if [ -d ./omekabackup/$SITE ]; then
  echo "3.1 Répertoire de sauvegarde de la configuration de $SITE déjà existant"
  echo "3.1 Voulez vous écraser écraser cette sauvegarde (y/n)?"
  read answer
  # 3. Suppression sauvegarde précédente
  if [ "$answer" != "${answer#[Yy]}" ] ;then
    rm -f ./omekabackup/$SITE/*.*
    echo "3. Sauvegarde précédente supprimée"
    cp ../$SITE/.htaccess ./omekabackup/$SITE/
    cp ../$SITE/favicon.ico ./omekabackup/$SITE/
    cp ../$SITE/config/database.ini ./omekabackup/$SITE/    
  fi
else
  echo "3.2 Répertoire de sauvegarde ./omekabackup/$SITE inexistant"
  mkdir ./omekabackup/$SITE
  cp ../$SITE/.htaccess ./omekabackup/$SITE/
  cp ../$SITE/favicon.ico ./omekabackup/$SITE/
  cp ../$SITE/config/database.ini ./omekabackup/$SITE/    
fi
echo -e "\n"

# 4. Suprression des répertoires /application, /config, /vendor et des fichiers à la racine
# les répertoires /files, /logs, /modules,/themes sont conservés
echo -e "4. Suppression des répertoires de l'ancienne version\n"
rm -rf ../$SITE/application
rm -rf ../$SITE/config
rm -rf ../$SITE/vendor
rm -f ../$SITE/*
rm -f ../$SITE/.htaccess

# 5. Suprression des répertoires /application, /config, /vendor et des fichiers à la racine
# les répertoires /files, /logs, /modules,/themes sont conservés
echo -e "5. Copie des répertoires de la nouvelle version dans $SITE\n"
cp -R ./omekadownload/omeka-s-$OMEKA_V/omeka-s/* ../$SITE/

# 6. Copie des fichiers de configuration
echo -e "6. Copie des fichiers de configuration sauvegardés du site $SITE\n"
rm ../$SITE/.htaccess
rm ../$SITE/config/database.ini    
cp ./omekabackup/$SITE/.htaccess ../$SITE/
cp ./omekabackup/$SITE/favicon.ico ../$SITE/
cp ./omekabackup/$SITE/database.ini ../$SITE/config/database.ini

echo "7. End\n"

