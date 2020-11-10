#!/bin/bash
# install : in the omekaupgrade directory
# launch : first parameter is site to upgrade, second is Omeka Classic version
# syntax : "./upgrade-omeka.sh sitename version" eg : "./upgrade-omeka.sh aian 2.7.1"
# results : two directories are created 
# 1/ the downloaded unzipped files, eg : /omekaupgrade/omeka-2.7.1
# 2/ the security saving under omekabackup/sitename, eg : /omekaupgrade/omekabackup/aian

# download Omeka Classic
URL_OMEKA=https://github.com/omeka/Omeka/releases/download/v$2/omeka-$2.zip
# directory of unzipped files
OMEKA_NEWDIR=./omeka-$2
# Backup site directory
BCKDIR_SITE=./omekabackup/$1
# directory of site to upgrade
DEST_DIR=../$1

echo
echo 1. Creating backup dir $BCKDIR_SITE
mkdir ./omekabackup
mkdir $BCKDIR_SITE

# Téléchargement si nécessaire
if [ -f omeka-$2.zip -a -d $OMEKA_NEWDIR ]; then
	echo zip file already downloaded, $OMEKA_NEWDIR exists
else
	wget $URL_OMEKA
	unzip omeka-$2.zip
fi

echo
echo 2. Backing up directories and files from $1 to $BCKDIR_SITE
mv $DEST_DIR/admin $BCKDIR_SITE
mv $DEST_DIR/application $BCKDIR_SITE
mv $DEST_DIR/install $BCKDIR_SITE
mv $DEST_DIR/db.ini $BCKDIR_SITE
mv $DEST_DIR/.htaccess $BCKDIR_SITE
mv $DEST_DIR/favicon.ico $BCKDIR_SITE

# Uncomment for testing, stop the script before deleting production site
#exit 1

echo
echo 3. Removing some directories and files from $DEST_DIR files, plugins and themes not remove
rm -rf $DEST_DIR/admin
rm -rf $DEST_DIR/application
rm -rf $DEST_DIR/install
rm $DEST_DIR/*

echo
echo 4. Copying new Omeka $OMEKA_NEWDIR/* in $DEST_DIR
cp -R $OMEKA_NEWDIR/* $DEST_DIR/

echo
echo 5. Restoring 3 files from old version to $DEST_DIR
echo
cp -R $BCKDIR_SITE/db.ini $DEST_DIR/
cp -R $BCKDIR_SITE/.htaccess $DEST_DIR/
cp -R $BCKDIR_SITE/favicon.ico $DEST_DIR/
cp -R $BCKDIR_SITE/application/config/config.ini $DEST_DIR/application/config/

echo
echo 6. Connect to the admin of your site to complete the database upgrade
echo
echo End
echo
