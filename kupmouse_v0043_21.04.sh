#! /bin/bash
#
# Script en bash que intenta hacer la vida más fácil al usuario de ubuntu,
# instalando programas sencillos y útiles para su trabajo diario.
# Bash script to install useful programs for your daily work in a fresh Ubuntu.
# More info in http://kacharreando.com
#
# Last Update: 2021-09-01

instarepo() {
    sudo apt-get install -f 
    sudo dpkg --configure -a
    clear                    
    echo $2
    sleep 1s
    (
    echo "10" ; sleep 1
    sudo add-apt-repository $1 -y
    echo "20" ; sleep 1
    sudo apt-get -y install "${@:3}" 
    echo "99" ; sleep 1
    sudo apt-get install -f
    echo "100" ; sleep 1
    ) |
    zenity --auto-close --progress \
    --title="$2" --width=300 --height=100\
    --percentage=0
    clear 
    echo $2, completed installation
    sleep 2s
}

instapack() {
    sudo apt-get install -f 
    sudo dpkg --configure -a
    clear                    
    echo $1
    sleep 1s
    (
    echo "10" ; sleep 1
    sudo apt-get -y install "${@:2}"
    echo "99" ; sleep 1
    sudo apt-get install -f
    echo "100" ; sleep 1
    ) |
    zenity --auto-close --progress \
    --title="$1" --width=300 --height=100\
    --percentage=0
    clear 
    echo $1, completed installation
    sleep 2s
}

instadeb() { 
    sudo apt-get install -f 
    sudo dpkg --configure -a
    clear                    
    echo $1
    sleep 1s
    (
    echo "10" ; sleep 1
    wget -c $2$3
    echo "50" ; sleep 1
    sudo dpkg -i $3
    echo "80" ; sleep 1
    sudo apt-get install -f
    echo "99" ; sleep 1
    sudo rm $3
    echo "100" ; sleep 1
    ) |
    zenity --auto-close --progress \
    --title="$1" --width=300 --height=100\
    --percentage=0
    clear 
    echo $1, completed installation
    sleep 2s
}

#pkgs='yad certbot'
pkgs='yad'
for pkg in $pkgs; do
    status="$(dpkg-query -W --showformat='${db:Status-Status}' "$pkg" 2>&1)"
    if [ ! $? = 0 ] || [ ! "$status" = installed ]; then
        read -p "Es necesario instalar $pkg sino saldrás del programa, ¿estas seguro? [y/n]" -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo apt install $pkg -y
        else
            exit 0
        fi
    fi
done
###################################
# Update and Upgrade
###################################
#echo
echo "Updating and upgrading..."
#echo
sudo apt-get update && sudo apt-get upgrade -y
clear

# Información de inicio
#zenity --text-info --filename=./inicio.txt

NameProg="Kupmouse"
vkup="v0.4.3"
# Versión Ubuntu
version=21.04 #lsb_release -rs
lsbrelease=hirsute
#codenamelinux=$(echo `lsb_release -cs`) # Display a description of the currently installed distribution
Distributorlinux=$(echo `lsb_release -is`)
releaselinux=$(echo `lsb_release -rs`) # Display de release number of the currently installed distribution
processor=$(echo `uname -m`) # Nos dice el tipo de procesador
#check if the user $nameversion and $processor
if [ $lsbrelease = `lsb_release -cs` ]; then
    zenity --info \
       --title="$NameProg $vkup" \
       --width=350 \
       --text "Bienvenido al instalador <b>$NameProg</b> de aplicaciones extras imprescindibles para ubuntu. \nEstás usando Ubuntu $version $codenamelinux de $processor.\n\n Si te gusta visita <a href='https://kacharreando.com'>Kacharreando.com</a>"
else
    zenity --error \
       --title="$NameProg $vkup" \
       --width=350 \
       --text "Error: en esta versión de Ubuntu no se puede ejecutar el instalador <b>Cupmouse</b> de aplicaciones extras imprescindibles para ubuntu. \nEstás usando Ubuntu $version $codenamelinux de $processor.\n\n Si te gusta visita <a href='https://kacharreando.com'>Kacharreando.com</a>\n\n Tu versión es $Distributorlinux"
	exit 0
fi

choices=`zenity --title="$NameProg $vkup" --width=740 --height=550 \
        --text="Bienvenido al instalador <b>$NameProg</b> de aplicaciones extras imprescindibles para ubuntu. \nEstás usando Ubuntu $version $codenamelinux de $processor.\n\n Si te gusta visita <a href='https://kacharreando.com'>Kacharreando.com</a>\n\nSelecciona los paquetes a instalar:" \
        --list --column="Selección" --column="Paquete" --column="Descripción"\
        --checklist FALSE "Utilidades" "Utilidades del sistema: curl, wget, exFAT, ntfs, usbmount."\
        FALSE "Preload" "Utilidad para optimizar memoria RAM."\
        FALSE "Gparted" "Utilidad para particionar discos duros."\
        FALSE "Screenkey" "A screencast tool to display your keys, inspired by Screenflick."\
        FALSE "Plugins Gedit" "Plugins para añadir funcionalidades a Gedit."\
        FALSE "Tools PDF" "Herramientas para gestionar PDF."\
        FALSE "Okular" "Okular is a universal document viewer with support for advanced document features, such as annotations, forms, and embedded files."\
        FALSE "Scripts Nautilus" "Scripts para añadir funcionalidades a Nautilus."\
        FALSE "Ubuntu Extra" "Codecs propietarios para ubuntu"\
        FALSE "Compresión" "Utilidades de compresión y de diferentes formatos rar, unace, 7zip, arj ..."\
        FALSE "Gcalcli" "gcalcli is a Python application that allows you to access your Google Calendar from a command line."\
        FALSE "Deborphan" "Deborphan encuentra paquetes «huérfanos» en el sistema."\
        FALSE "Git" "Git es un sistema de control de versiones para manejar proyectos de programación."\
        FALSE "Latex" "Utilidades para trabajar con LaTEX."\
        FALSE "Chromium" "Navegador opensource basado en Chrome de google"\
        FALSE "Chrome" "Navegador web de Google"\
        FALSE "Firefox ESR" "Navegador Firefox Extended Support Release, versión de soporte extendido."\
        FALSE "VideoLAN" "Reproductor de video en su última versión en desarrollo"\
        FALSE "Kdenlive" "Kdenlive is a non-linear video editing suite, which supports DV, HDV and many more formats."\
        FALSE "LibreOffice" "LibreOffice es un paquete de productividad de ofimática."\
        FALSE "Typora" "Typora es un editor de Markdown que añade características muy interesantes."\
        FALSE "Slimbook" "Programas pensados para los ordenadores portátiles Slimbook"\
        FALSE "Telegram" "Telegram es la alternativa a Whatsapp"\
        FALSE "Gimp" "Editor de imágenes que no tiene nada que envidiar a Photoshop."\
        FALSE "Gimp Extras" "Filtros, pinceles, formatos, ... extras para Gimp."\
        FALSE "Folder Color" "Añadir colores a las carpetas."\
        FALSE "Wine" "Librerías para emular aplicaciones Windows."\
        FALSE "Wine Extras" "Playonlinux y Winetricks para instalar aplicaciones windows y librerías de microsoft."`

if [ $? -eq 0 ]
then
        IFS="|"
        for choice in $choices
        do
            if [  "$choice" = "Utilidades" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice curl wget exfat-fuse exfat-utils ntfs-3g usbmount
                      fi
            elif [  "$choice" = "Ubuntu Extra" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            sudo apt-get install -f
                            sudo dpkg --configure -a
                            clear
                            echo $choice
                            sleep 1s
                            echo "10" ; sleep 1
                            sudo apt-get -y install ubuntu-restricted-extras
                            echo "99" ; sleep 1
                            sudo apt-get install -f
                            echo "100" ; sleep 1
                            clear
                            echo $choice, completed installation
                            sleep 2s
                      fi
            elif [  "$choice" = "Preload" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice preload
                      fi
            elif [  "$choice" = "Gparted" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice gparted
                      fi
            elif [  "$choice" = "Screenkey" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice screenkey
                      fi
            elif [  "$choice" = "Chromium" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg
                      fi
            elif [  "$choice" = "Chrome" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instadeb $choice https://dl.google.com/linux/direct/ google-chrome-stable_current_amd64.deb
                      fi
            elif [  "$choice" = "Firefox ESR" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instarepo "ppa:mozillateam/ppa" $choice firefox-esr
                      fi
            elif [  "$choice" = "VideoLAN" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice vlc
                      fi
            elif [  "$choice" = "Kdenlive" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instarepo "ppa:kdenlive/kdenlive-stable" $choice kdenlive
                      fi
            elif [  "$choice" = "LibreOffice" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice libreoffice libreoffice-pdfimport libreoffice-help-es libreoffice-java-common libreoffice-math libreoffice-mysql-connector
                      fi
            elif [  "$choice" = "Typora" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
                            sudo add-apt-repository 'deb https://typora.io/linux ./' -y
                            sudo apt-get update
                            sudo apt-get install typora
                      fi
            elif [  "$choice" = "Slimbook" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instarepo "ppa:slimbook/slimbook" $choice slimbookbattery slimbooksensortouchpad
                      fi
            elif [  "$choice" = "Telegram" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instarepo "ppa:atareao/telegram" $choice telegram 
                      fi
            elif [  "$choice" = "Compresión" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice rar unace p7zip-full p7zip-rar sharutils mpack
                      fi
            elif [  "$choice" = "Gcalcli" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice gcalcli
                      fi
            elif [  "$choice" = "Deborphan" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice deborphan
                      fi
            elif [  "$choice" = "Git" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice git
                      fi
            elif [  "$choice" = "Latex" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice texlive-latex-base texlive-base texlive-latex-extra texlive-font-utils texlive-fonts-recommended texlive-extra-utils texlive-lang-spanish texlive-lang-english texlive-pictures texlive-science gedit-latex-plugin
                      fi
            elif [  "$choice" = "Plugins Gedit" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice gedit-plugins 
                      fi
            elif [  "$choice" = "Tools PDF" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice printer-driver-cups-pdf
                      fi
            elif [  "$choice" = "Okular" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice okular
                      fi
            elif [  "$choice" = "Gimp" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice gimp
                      fi
            elif [  "$choice" = "Gimp Extras" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice gimp-plugin-registry gimp-cbmplugs gimp-dcraw gimp-dds gimp-gap gimp-gluas gimp-gmic gimp-gutenprint gimp-texturize
                      fi
            elif [  "$choice" = "Folder Color" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instarepo "ppa:costales/folder-color" $choice folder-color
                      fi
            elif [  "$choice" = "Wine" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            sudo dpkg --add-architecture i386
                            wget -nc https://dl.winehq.org/wine-builds/winehq.key
                            sudo apt-key add winehq.key
                            sudo rm winehq.key
                            sudo add-apt-repository "deb https://dl.winehq.org/wine-builds/ubuntu/ $lsbrelease main" -y
                            sudo apt update
                            sudo apt install --install-recommends winehq-devel -y
                      fi
            elif [  "$choice" = "Wine Extras" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice playonlinux winetricks
                      fi
            else #instarepo()
                   echo Siguiente
                   #sudo apt-get -y --force-yes install '$choice'
             fi
        done
        IFS=""
else
        echo cancel selected
fi



#yad --height=300 --list --checklist --column="Selección" --column="Paquetes" --column="Descripción" < ./paquetes.list

#echo "[some repository]" | sudo tee -a /etc/apt/sources.list
#sudo sh -c 'echo "[some repository]" >> /etc/apt/sources.list.d/tsbarnes-ubuntu-indicator-keylock-focal.list'
#deb http://ppa.launchpad.net/tsbarnes/indicator-keylock/ubuntu/ focal main
## deb-src http://ppa.launchpad.net/tsbarnes/indicator-keylock/ubuntu/ focal main

# Installation of many packages in a fresh Ubuntu

###################################
# Add repositories
###################################
#echo
#echo "Installing repositories..."
#echo
#sudo apt-add-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
#sudo add-apt-repository ppa:webupd8team/java
#sudo add-apt-repository ppa:ubuntu-x-swat/x-updates # nvidia
#sudo add-apt-repository ppa:transmissionbt/ppa
#sudo add-apt-repository ppa:jd-team/jdownloader
##Elininar repositorio: sudo add-apt-repository --remove ppa:kdenlive/kdenlive-stable

###################################
# Remove programs not used
###################################
#echo
#echo "Removing programs not used..."
#echo
#sudo apt-get remove hexchat hexchat-common thunderbird thunderbird-gnome-support thunderbird-locale-en  thunderbird-locale-en-us  banshee tomboy pidgin pidgin-libnotify -y

###################################
# Installations
###################################
### important
#sudo apt-get install gparted ntfs-config usbmount -y
### desktop
#sudo apt-get remove xscreensaver xscreensaver-data xscreensaver-gl  indicator-multiload -y
#sudo apt-get install xdotool gnome-screensaver -y
### nautilus complements
#sudo apt-get install nautilus nautilus-dropbox nautilus-open-terminal -y
#sudo apt install nautilus-scripts-manager -y
### java and pdf tools
#sudo apt-get install oracle-java7-installer
### pdf tools
#sudo apt-get install printer-driver-cups-pdf -y
## audio, image and video
#sudo apt-get install inkscape
### tools
#sudo apt-get install mencoder vlc audacious skype brasero -y
### torrent and direct download
#sudo apt-get install jdownloader -y

## developing
### compilers and IDEs
#sudo apt-get install build-essential gcc-avr avr-libc doxygen doxygen-latex cmake cmake-curses-gui gfortran libgtk2.0-dev pkg-config -y
#sudo apt-get install qtcreator qtcreator-plugin-cmake -y
### libraries
#sudo apt-get install libboost-all-dev libeigen3-dev libblas-dev liblapack-dev ant -y
#### python
#sudo apt-get install python-tk python-matplotlib python-pip  -y
#sudo easy_install ipython jinja2 tornado pyzmq scipy scikit-image
#### repositories
#sudo apt-get install git ssh openssh-server filezilla filezilla-common -y
#### tools
#sudo apt-get install kdiff3-qt vim source-highlight -y
#### latex
#sudo apt-get install texlive-latex-base texlive-base texlive-latex-extra texlive-font-utils texlive-fonts-recommended texlive-extra-utils texlive-lang-spanish texlive-lang-english texlive-pictures texlive-science -y
#sudo apt-get install gedit-plugins gedit-latex-plugin -y
### web tools
#echo "To install LAMP:"
##echo "Launch Synaptic. Edit Menu, Package by task, LAMP Server"
#sudo apt-get install php5 -yy
#sudo apt-get install mysql-client mysql-server mysql-workbench -y
#sudo apt-get install phpmyadmin phpsysinfo -y
###################################
# Cleaning
###################################
echo
echo "Cleaning..."
sudo apt-get autoclean
clear
###################################
# Configuring
###################################
#echo
#echo "Configuring..."
### java
#sudo update-alternatives --config java



###################################
# Finish!
###################################
echo
echo "Finish! All done!"
echo
