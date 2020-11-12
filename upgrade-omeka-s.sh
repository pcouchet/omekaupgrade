#!/bin/bash
# Premier paramètre le répertoire du site à migrer, deuxième la version d'Omeka Classic
# ex : ./upgrade-omeka.sh aian 2.7.1
#
# Deux répertoires sont créés : /omeka-2.7.1 (nouvelle version) et /omekabackup/aian (sauvegarde des fichiers modifiés) 
#

# SITE : nom du site, nom du répertoire à mettre à jour, exemple "aian"
SITE=$1
# OMEKA_V : version d'Omeka Classic, exemple "2.7.1"
OMEKA_V=$2
# Omeka url pour download
URL_OMEKA=https://github.com/omeka/omeka-s/releases/download/v$OMEKA_V/omeka-s-$OMEKA_V.zip
# ROOTDIR : Racine serveur web
ROOTDIR=.
# OMEKA_NEWDIR : Répertoire nouvelle version
OMEKA_NEWDIR=$ROOTDIR/omeka-s-$OMEKA_V
# BCKDIR : répertoire des sauvegardes
BCKDIR=$ROOTDIR/omekabackup
# BCKDIR_SITE : répertoire des quelques fichiers sauvegardés
BCKDIR_SITE=$BCKDIR/$SITE
# DEST_DIR : Site omeka à mettre à jour
DEST_DIR=$ROOTDIR/$SITE

echo
echo 1. Creating backup dir $BCKDIR_SITE
mkdir $ROOTDIR/omekabackup
mkdir $BCKDIR_SITE
mkdir $OMEKA_NEWDIR

# Téléchargement si nécessaire
if [ -f omeka-s-$OMEKA_V.zip -a -d $OMEKA_NEWDIR/omeka-s ]; then
	echo zip file already downloaded, $OMEKA_NEWDIR exists
else
	wget $URL_OMEKA
	unzip omeka-s-$OMEKA_V.zip -d $OMEKA_NEWDIR
fi

echo
echo 2. Backing up 4 files from $SITE in $BCKDIR_SITE
cp $DEST_DIR/.htaccess $BCKDIR_SITE
cp $DEST_DIR/favicon.ico $BCKDIR_SITE
cp $DEST_DIR/config/database.ini $BCKDIR_SITE

# Uncomment for testing, stop the script before deleting production site
#exit 1

echo
echo 3. Removing some directories and files from $DEST_DIR
rm -rf $DEST_DIR/admin
rm -rf $DEST_DIR/application
rm -rf $DEST_DIR/install
rm $DEST_DIR/*

echo
echo 4. Copying new Omeka $OMEKA_NEWDIR/* in $DEST_DIR
cp -R $OMEKA_NEWDIR/omeka-s/* $DEST_DIR/

echo
echo 5. Restoring 3 files from old version to $DEST_DIR
echo
cp -R $BCKDIR_SITE/.htaccess $DEST_DIR/
cp -R $BCKDIR_SITE/favicon.ico $DEST_DIR/
cp -R $BCKDIR_SITE/database.ini $DEST_DIR/config/

echo
echo 6. Connect to the admin of your site to complete the database upgrade
echo
echo End
echo
