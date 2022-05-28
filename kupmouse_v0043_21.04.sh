#! /bin/bash
#
# Script en bash que intenta hacer la vida más fácil al usuario de ubuntu,
# instalando programas sencillos y útiles para su trabajo diario.
# Bash script to install useful programs for your daily work in a fresh Ubuntu.
# More info in http://kacharreando.com Copyright (C) 
#
# Last Update: 2021-09-01
# +--------------------------------------------------------------------------------+
# |                                                                                |
# | Este programa es Software Libre; Puedes distribuirlo y/o                       |
# | modificarlo bajo los términos de la GNU General Public License                 |
# | como está publicada por la Free Software Foundation; cualquier                 |
# | versión 3 de la Licencia, o (opcionalmente) cualquier versión                  |
# | posterior. http://www.gnu.org/licenses/lgpl.html                               |
# |                                                                                |
# | Este programa es distribuido con la esperanza de que sea útil,                 |
# | pero SIN NINGUNA GARANTÍA. Vea la GNU General Public License                   |
# | para más detalles.                                                             |
# +--------------------------------------------------------------------------------+

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
    echo "$1"
    sleep 1s
    (
    echo "10" ; sleep 1
    sudo apt-get update
    echo "20" ; sleep 1
    sudo apt-get -y install "${@:2}"
    echo "99" ; sleep 1
    sudo apt-get install -f
    echo "100" ; sleep 1
    ) |
    zenity --auto-close --progress \
    --title="$1" --width=300 --height=100\
    --percentage=0
    clear 
    echo "$1", completed installation
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
    #sudo apt install application.deb
    echo "80" ; sleep 1
    sudo apt-get -f install
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

# Para aceptar los terminos de la licencia.
#    zenity --text-info \
#    --title="License" \
#    --filename=$FILE \
#    --checkbox="I read and accept the terms."

#sudo apt install apt-transport-https curl
#pkgs='yad certbot'
pkgs='yad apt-transport-https curl'
for pkg in $pkgs; do
    status="$(dpkg-query -W --showformat='${db:Status-Status}' "$pkg" 2>&1)"
    if [ ! $? = 0 ] || [ ! "$status" = installed ]; then
        read -p "Es necesario instalar $pkg sino saldrás del programa, ¿estas seguro? [y/n]" -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo apt-get install $pkg -y
        else
            exit 0
        fi
    fi
done
###################################
# Update and Upgrade
###################################
#echo
echo "Updating and upgrading system ..."
sleep 1
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
#while true; do #Iniciamos el menú en un bucle infinito
    #check if the user $nameversion and $processor
if [ $lsbrelease = `lsb_release -cs` ]; then
    choices=`zenity --title="$NameProg $vkup" --width=740 --height=550 \
        --text="Bienvenido al instalador <b>$NameProg</b> de aplicaciones extras imprescindibles para ubuntu. \nEstás usando Ubuntu $version $codenamelinux de $processor.\n\n Si te gusta visita <a href='https://kacharreando.com'>Kacharreando.com</a>\n\nSelecciona los paquetes a instalar:" \
        --list --column="Selección" --column="Paquete" --column="Descripción"\
        --checklist TRUE "Importante" "Herramientas importantes para Ubuntu Pc"\
        TRUE "Utilidades" "Utilidades del sistema: curl, wget, exFAT, ntfs, usbmount, python3-pip, ..."\
        FALSE "Preload" "Utilidad para optimizar memoria RAM."\
        FALSE "Gparted" "Utilidad para particionar discos duros."\
        FALSE "Screenkey" "A screencast tool to display your keys, inspired by Screenflick."\
        FALSE "Plugins Gedit" "Plugins para añadir funcionalidades a Gedit."\
        FALSE "Tools PDF" "Herramientas para gestionar PDF."\
        FALSE "Okular" "Okular is a universal document viewer with support for advanced document features, such as annotations, forms, and embedded files."\
        FALSE "Zotero" "Zotero is a free, easy-to-use tool to help you collect, organize, cite, and share research."\
        FALSE "Scripts Nautilus" "Scripts para añadir funcionalidades a Nautilus."\
        FALSE "Pandoc" "Herramienta para convertir diferentes formatos entre docx, pdf, markdown, ..."\
        FALSE "Ubuntu Extra" "Codecs propietarios para ubuntu"\
        FALSE "Compresión" "Utilidades de compresión y de diferentes formatos rar, unace, 7zip, arj ..."\
        FALSE "Gcalcli" "gcalcli is a Python application that allows you to access your Google Calendar from a command line."\
        FALSE "Deborphan" "Deborphan encuentra paquetes «huérfanos» en el sistema."\
        FALSE "Git" "Git es un sistema de control de versiones para manejar proyectos de programación."\
        FALSE "Latex" "Utilidades para trabajar con LaTEX."\
        FALSE "Latex Full" "Todo el paquete para trabajar con LaTEX."\
        FALSE "Chromium" "Navegador opensource basado en Chrome de google"\
        FALSE "Chrome" "Navegador web de Google"\
        FALSE "Firefox ESR" "Navegador Firefox Extended Support Release, versión de soporte extendido."\
        FALSE "Brave Browser" "Navegador privado centrado en la seguridad que se conecta con wallets de criptomonedas."\
        FALSE "Discord" "Discord es una plataforma social destinada a permitir crear grupos de chat para diferentes juegos y finalidades."\
        FALSE "VideoLAN" "Reproductor de video en su última versión en desarrollo"\
        FALSE "Kdenlive" "Kdenlive is a non-linear video editing suite, which supports DV, HDV and many more formats."\
        FALSE "LibreOffice" "LibreOffice es un paquete de productividad de ofimática."\
        FALSE "Typora" "Typora es un editor de Markdown que añade características muy interesantes."\
        FALSE "Slimbook" "Programas pensados para los ordenadores portátiles Slimbook"\
        FALSE "Telegram" "Telegram es la alternativa a Whatsapp"\
        FALSE "Flameshot" "Flameshot es una herramienta de captura de pantalla con utilidades interesantes."\
        FALSE "Gimp" "Editor de imágenes que no tiene nada que envidiar a Photoshop."\
        FALSE "Gimp Extras" "Filtros, pinceles, formatos, ... extras para Gimp."\
        FALSE "Drawing" "Aplicación para dibujar en entornos Linux, centrándose en la sencillez, y con soporte de webp."\
        FALSE "Folder Color" "Añadir colores a las carpetas."\
        FALSE "Wine" "Librerías para emular aplicaciones Windows."\
        FALSE "Wine Extras" "Playonlinux y Winetricks para instalar aplicaciones windows y librerías de microsoft."\
        FALSE "Node.js" "As an asynchronous event-driven JavaScript runtime, Node.js is designed to build scalable network applications."\
        FALSE "Gastby-CLI" "Gatsby enables developers to build fast, secure, and powerful websites using a React-based framework."\
        FALSE "Youtube-dl" "Youtube-dl is a command-line program to download videos from YouTube.com and a few more sites."\
        FALSE "Youtube-dlp" "yt-dlp is a youtube-dl fork based on the now inactive youtube-dlc. The main focus of this project is adding new features and patches while also keeping up to date with the original project."\
        FALSE "mpv" "MPV is a media player for the command line."\
        FALSE "Localwp" "The #1 local WordPress development tool."\
        FALSE "TWS" "Trader Workstation es la aplicación de Interactive Brokers para operar con la plataforma."`
    
#    if [[ $? -eq 1 ]]; then #Cancel selected
#        exit 0
#        break
    if [ $? -eq 0 ]; then #Selected OK
        IFS="|"
        for choice in $choices
        do
            if [  "$choice" = "Importante" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            cd ./kupmouse
                            chmod +x important
                            ./important
                      fi
            elif [  "$choice" = "Utilidades" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice curl wget exfat-fuse exfat-utils ntfs-3g usbmount python3-pip
                      fi
            elif [  "$choice" = "Ubuntu Extra" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice ubuntu-restricted-extras
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
            elif [  "$choice" = "Brave Browser" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
                            echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
                            instapack $choice brave-browser
                      fi
            elif [  "$choice" = "Discord" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            wget -O ~/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
                            sudo dpkg -i discord.deb
                            sudo apt-get -f install
                      fi
                      Discord
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
                            instapack $choice typora
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
            elif [  "$choice" = "Flameshot" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice flameshot 
                            xdg-open https://kacharreando.com
                            #Shortkey for flameshot in ubuntu
                            #https://askubuntu.com/questions/1036473/how-to-change-screenshot-application-to-flameshot-on-ubuntu-18-04#:~:text=Go%20to%20Settings%20%2D%3E%20Devices%20%2D,shortcut%20to%20PrtScr%20(print).
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
            elif [  "$choice" = "Latex" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice texlive-full texlive-latex-extra texlive-font-utils texlive-fonts-recommended texlive-extra-utils texlive-lang-spanish texlive-lang-english texlive-pictures texlive-science gedit-latex-plugin
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
            elif [  "$choice" = "Zotero" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            wget -qO - https://github.com/retorquere/zotero-deb/releases/download/apt-get/install.sh | sudo bash
                            instapack $choice zotero
                      fi
                      Zotero
            elif [  "$choice" = "Pandoc" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice pandoc
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
            elif [  "$choice" = "Drawing" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instarepo "ppa:cartes/drawing" $choice drawing
                            wget -q -O - "https://github.com/aruiz/webp-pixbuf-loader/archive/refs/heads/master.tar.gz" | tar -xz
                            cd webp-pixbuf-loader-master/
                            apt install libgdk-pixbuf2.0-dev webp libwebp-dev
                            meson builddir -Dgdk_pixbuf_query_loaders_path="/usr/lib/x86_64-linux-gnu/gdk-pixbuf-2.0/gdk-pixbuf-query-loaders"
                            ninja -C builddir/
                            sudo ninja -C builddir/ install
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
            elif [  "$choice" = "Node.js" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
                            instapack $choice nodejs build-essential gcc g++ make
                      fi
            elif [  "$choice" = "Gastby-CLI" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            npm install -g gatsby-cli
                      fi
            elif [  "$choice" = "Localwp" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            #wget -q https://cdn.localwp.com/stable/latest/deb #-q modo silencioso
                            instadeb $choice https://cdn.localwp.com/stable/latest/ deb
                      fi
            elif [  "$choice" = "Youtube-dl" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            sudo pip install --upgrade youtube-dl
                      fi
            elif [  "$choice" = "Youtube-dlp" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            python3 -m pip install --upgrade yt-dlp
                      fi
            elif [  "$choice" = "mpv" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            instapack $choice mpv
                      fi
            elif [  "$choice" = "TWS" ];
                   then
                       if [  $? -eq 0  ]
                       then
                            sudo apt-get install libcanberra-gtk-module libcanberra-gtk0 -y
                            wget -q https://download2.interactivebrokers.com/installers/tws/latest/tws-latest-linux-x64.sh #-q modo silencioso
                            bash tws-latest-linux-x64.sh
                            rm tws-latest-linux-x64.sh
                      fi
            else #instarepo()
                   echo Siguiente
                   #sudo apt-get -y --force-yes install '$choice'
             fi
        done
        IFS=""
fi

else
    zenity --error \
       --title="$NameProg $vkup" \
       --width=350 \
       --text "Error: en esta versión de Ubuntu no se puede ejecutar el instalador <b>$NameProg</b> de aplicaciones extras imprescindibles para ubuntu. \nEstás usando Ubuntu $version $codenamelinux de $processor.\n\n Si te gusta visita <a href='https://kacharreando.com'>Kacharreando.com</a>\n\n Tu versión es $Distributorlinux"
	exit 0
fi
#done

#yad --height=300 --list --checklist --column="Selección" --column="Paquetes" --column="Descripción" < ./paquetes.list

#echo "[some repository]" | sudo tee -a /etc/apt/sources.list
#sudo sh -c 'echo "[some repository]" >> /etc/apt/sources.list.d/tsbarnes-ubuntu-indicator-keylock-focal.list'
#deb http://ppa.launchpad.net/tsbarnes/indicator-keylock/ubuntu/ focal main
## deb-src http://ppa.launchpad.net/tsbarnes/indicator-keylock/ubuntu/ focal main
##Elininar repositorio: sudo add-apt-repository --remove ppa:kdenlive/kdenlive-stable


###################################
# Installations
###################################
### important

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
sudo apt autoremove
clear

###################################
# Finish!
###################################
echo
echo "Finish! All done!"
echo
