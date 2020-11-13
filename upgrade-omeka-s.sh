#!/bin/bash
# install : unzip omekaupgrade
# launch : from inside /omekaupgrade, first parameter is site to upgrade, second is Omeka S version
# syntax : "./upgrade-omeka-s.sh omekaSiteName version" eg : "./upgrade-omeka-s.sh omeka-s 2.1.2"
# two directories are created in /omekaupgrade :
# 1/ /omekadownload with the zip and unzipped files
# 2/ /omekabackup/omekaSiteName with saving of config, favicon and .htacces

# Omeka S code URL
URL_OMEKA=https://github.com/omeka/omeka-s/releases/download/v$2/omeka-s-$2.zip

echo
echo 1. Creating backup dir at /omekabackup/$1
mkdir omekabackup
mkdir omekabackup/$1
mkdir omekadownload
mkdir omekadownload/omeka-s-$2

# Download if necessary
if [ -f ./omekadownload/omeka-s-$2/omeka-s-$2.zip ]; then
	echo omeka-s-$2.zip already downloaded
else
	wget $URL_OMEKA -P ./omekadownload/omeka-s-$2/
fi

# Unzip if necessary
if [ -f ./omekadownload/omeka-s-$2/omeka-s ]; then
	echo zip file already unzipped
else
	unzip -o ./omekadownload/omeka-s-$2/omeka-s-$2.zip -d ./omekadownload/omeka-s-$2/
fi

echo
echo 2. Backing up 4 files from $1 in /omekabackup/$1
cp ../$1/.htaccess ./omekabackup/$1
cp ../$1/favicon.ico ./omekabackup/$1
cp ../$1/config/database.ini ./omekabackup/$1

# Uncomment for testing, stop the script before deleting production site
#exit 1

echo
echo 3. Removing some directories and files from $1
rm -rf ../$1/application
rm -rf ../$1/vendor
rm ../$1/*

echo
echo 4. Copying new Omeka ./omekadownload/omeka-s-$2/* in $1
cp -R ./omekadownload/omeka-s-$2/omeka-s/* ../$1/

echo
echo 5. Restoring config files from old version to $1
echo
cp -R ./omekabackup/$1/.htaccess ../$1/
cp -R ./omekabackup/$1/favicon.ico ../$1/
cp -R ./omekabackup/$1/database.ini ../$1/config/

echo
echo 6. Connect to the admin of your site to complete the database upgrade
echo
echo End
echo
