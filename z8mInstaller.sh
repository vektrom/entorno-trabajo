#!/bin/bash

ARCHITECTURE=$(file /bin/bash | cut -d' ' -f3)
PACKAGE_CONTROL_USER_FILE=~/.config/sublime-text-3/Packages/User/Package\ Control.sublime-settings

LIST_OF_APPS="git nodejs npm ruby jq"
NPM_PACKAGES="bower browser-sync browserify csslint gulp jscs jshint jsxhint"
GEM_PACKAGES="sass scss-lint"
SUBLIME_PACKAGES='["BracketHighlighter", "CSScomb", "EditorConfig", "GitGutter", "Package Control", "Sass", "SublimeCodeIntel", "SublimeLinter", "SublimeLinter-contrib-scss-lint", "SublimeLinter-csslint", "SublimeLinter-sjcss", "SublimeLinter-jshint", "SublimeLinter-jsxhint", "SublimeOnSaveBuild"]'

IS_SUBLIME_INSTALLED=$(dpkg -l | grep "sublime-text" | awk '{print $3}')
SUBLIMETEXT64="http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_amd64.deb"
SUBLIMETEXT32="http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_i386.deb"

# Instalación de paquetes apt-get
apt-get update
echo ""
echo 'Instalando paquetes.'
apt-get install $LIST_OF_APPS

if [ -z "$IS_SUBLIME_INSTALLED" ] || (( $IS_SUBLIME_INSTALLED < 3083 ))
then
	# Instalación de Sublime Text 3
	echo ""
	echo 'Instalando Sublime Text 3'
	SUBLIMEDEB=""
	if [ $ARCHITECTURE == "64-bit" ]
	then
		SUBLIMEDEB="sublime-text_64.deb"
		wget $SUBLIMETEXT64 -O $HOME/$SUBLIMEDEB
	else
		SUBLIMEDEB="sublime-text_32.deb"
		wget $SUBLIMETEXT32 -O $HOME/$SUBLIMEDEB
	fi

	dpkg -i $HOME/$SUBLIMEDEB
else 
	echo ""
	echo 'Sublime Text 3 ya está instalado.'
fi

# Instalación de paquetes NPM
echo ""
echo 'Instalando paquetes NPM'
npm install -g $NPM_PACKAGES

# Instalación de paquetes GEM
echo ""
echo 'Instalando paquetes GEM'
gem install $GEM_PACKAGES

# Instalación manual de Package Control
while [ ! -f "$PACKAGE_CONTROL_USER_FILE" ] 
do
	echo ""
	echo 'Para continuar tienes que instalar Package Control en Sublime Text.'
	echo 'Para instalarlo dirigete a la siguiente página y sigue las instrucciones: '
	echo 'https://packagecontrol.io/installation#st3'
	read -p 'Presiona la tecla [Enter] cuando hayas instalado Package Control...'
done

# Instalación de paquetes Package Control de Sublime Text
echo ""
echo 'Continuando la instalación.'
echo 'Se modificará la configuración de usuario de Package Control para instalar los nuevos packetes.'
echo 'Si quieres conservar tu actual configuración haz una copia del archivo antes de continuar.'
read -p 'Presiona la tecla [Enter] para continuar...'

JQ_FILTER_ADD=".installed_packages = .installed_packages + ${SUBLIME_PACKAGES}"
jq "$JQ_FILTER_ADD" "$PACKAGE_CONTROL_USER_FILE" > tmp.$$.json && mv tmp.$$.json "$PACKAGE_CONTROL_USER_FILE"

echo ""
echo 'Intalación completada.'
