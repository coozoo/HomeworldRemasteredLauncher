#!/usr/bin/bash
#####################################
# Homeworld bash launcher
# Author: Yuriy Kuzin
####################################
version="1.0"
######## WINEPREFIX REQUIREMENTS ##########
# lutris provides runner for steam (just a bit flickering UI inside but it works)
# so we can use lutris steam to install homeworld
# .local/share/lutris/runners/winesteam/prefix64
# if you prefer playonlinux you can try and change this script (but steam in playonlinux just blask inside for me)
#
# you need to setup win environment with next components installed
# vcrun2005-2015
# tahoma
# core fonts
# font smooth
# directx (all)
#
# .NET you can omit it as it is required by launcher only
# and even when it is installed in 32 bit space it doesn't work either
# that's actually why I need this script
# don't use 32bit prefix it has significantly lower FPS
####### Mouse ############
# To prevent mouse of leaving window during ingame navigation
# launch "winecfg" -> "Graphics" tab -> mark checkbox "Automatically capture the mouse in full-screen windows"
####### Find prefix ###########
wineprefix=""
# uncomment and modify string below if you want to use your own wineprefix with homeworld inside
# override wineprefix
#wineprefix="$HOME/.PlayOnLinux/wineprefix/hw64"

# determine resolutions for homeworld and homeworld2 automatically
# 0- disable; 1 - enable
useautoresolution=1

# try to use optirun or primusrun
useoptirun=1

function findinstalldir
{
    local directory=$1
    # find location of games in wine registery steam or GOG versions
    installdir=$(cat $directory/system.reg |grep -i -A20  'Steam App 244160\|2114871440'|grep -i 'InstallLocation'|head -1|cut -d "=" -f2|sed 's|"C:|drive_c|g'|sed 's|\\\\"||'|sed 's|\\\\|/|g'|sed 's|"||g')
    echo "$installdir"
}

function findsteaminstallpath
{
    local wineprefix=$1
    steaminstallpath=$(cat $wineprefix/system.reg|grep -i -A5 valve|grep -i steam|grep -i installpath|head -1|cut -d "=" -f2|sed 's|"C:|drive_c|g'|sed 's|\\\\"||'|sed 's|\\\\|/|g'|sed 's|"||g')
    echo "$steaminstallpath"
}


polprefixes="$HOME/.PlayOnLinux/wineprefix/"
lutrissteamprefix="$HOME/.local/share/lutris/runners/winesteam/prefix64"
installdir=""
usesteam=0

if [[ ! -z "$wineprefix" ]];then
    if [[ -d $wineprefix ]]; then
	installdir="$(findinstalldir $wineprefix)"
	if [[ -z "$installdir" ]];then
	    echo "Error!!! Unable to find Homeworld in specified wineprefix: $wineprefix"
	fi
    else
	echo "Error!!! Forced wineprefix: $wineprefix"
	echo "Doesn't exist!"
	exit 1
    fi
fi


if [[ -z "$wineprefix" ]] && [[ -d $lutrissteamprefix ]]; then
    echo "Lutris prefix"
    wineprefix=$lutrissteamprefix
    installdir="$(findinstalldir $lutrissteamprefix)"
fi

if [[ -z "$wineprefix" ]];then
    echo "Search playonlinux prefixes"
    if [[ -d $polprefixes ]];then
	for directory in `find "$polprefixes" -maxdepth 1 -mindepth 1 -type d`; do
	    polconfig="$directory/playonlinux.cfg"
	    if [[ -f "$polconfig" ]];then
		polplatform=$(cat "$directory/playonlinux.cfg"|grep "amd64"|cut -d "=" -f2)
		if [[ "$polplatform" == "amd64" ]];then
		    echo "Searching homeworlld inside prefix: $directory"
		    # find location of games in wine registery steam or GOG versions
		    #installdir=$(cat $directory/system.reg |grep -i -A20  'Steam App 244160\|2114871440'|grep -i 'InstallLocation'|head -1|cut -d "=" -f2|sed 's|"C:|drive_c|g'|sed 's|\\\\"||'|sed 's|\\\\|/|g'|sed 's|"||g')
		    installdir="$(findinstalldir $directory)"
		    if [[ ! -z "$installdir" ]];then
			wineprefix="$directory"
			break
		    fi
		fi
	    fi
	done
    else
	echo "Can't find wineprefix with installed homeworld inside"
    fi
fi
echo "Homeworld detected in wineprefix: $wineprefix"

echo -e "Homeworld install dir: $installdir \n"

if [[ ! -z "$wineprefix" ]];then
    steaminstallpath="$(findsteaminstallpath $wineprefix)"
    if [[ ! -z "$steaminstallpath" ]];then
	usesteam=1
	echo "Steam found in: $steaminstallpath"
    fi
fi

echo "Use wineprefix: $wineprefix"
echo -e "Use Homeworld Install Dir: $installdir \n"

######## OpenGL ##########################
# this OpenGL version needed for remastered version
# Games tested with:
#          Intel: UHD Graphics 620
#          NVIDIA: GP108M [GeForce MX150]
export MESA_GL_VERSION_OVERRIDE=3.3COMPAT

######## WINE Version ####################
# All games somehow works with WINE 5 but there is some problems
#### WINE 5.5-5.7 (staging) #####
#	Homeworld.exe - works fine
#	Homeworld2.exe - works with low level video settings
#			 Hangs on load level with max settings
#			    Playonlinux settings allow to increase some of LOD to higher values:
#						GLSL support: enabled;
#						Direct Draw Renderer: opengl
#						Render target mode lock: readdraw
#					But still it will hange if all settings on max
#	HomeworldRM.exe - works in low level (see below)
#				glitchering intro video: can be solved by installing directmusic and directplay
#							 but don't do that because looks like after this game hangs more on load level
#							 High level settings problem (see below wine 4.21 comments)
##################################
#### WINE 4.21 #####
#	Homeworld.exe - works fine
#	Homeworld2.exe - works fine (even on high settings)
#	HomeworldRM.exe - works fine on high settings excluding few of them
#			  TEXTURE QUALITY: 6-MEDIUM (works stable, higher values causing troubles on load level)
#			  TEXTURE SIZE LIMIT: 2048  (works stable, any higher value failed to load level)
#			  DEPTH OF FIELD: OFF (works stable, ON value significantly lower FPS)
##################################
###### install using playonlinux:
#				"Tools" menu -> "Manage wine versions" menu item -> "Wine versions (amd64)" tab
#				Find and select 4.21 from the left side
#				And click ">" button to install it
# you can try your version but read comments above
winebin="$HOME/.PlayOnLinux/wine/linux-amd64/4.21/bin/wine"
lutriswinebin="$HOME/.local/share/lutris/runners/wine/lutris-4.21-x86_64/bin/wine"
if [[ -f $winebin ]]; then
    echo "Playonlinux wine has been found"
elif [[ -f $lutriswinebin ]]; then
    echo "Lutris wine has been found"
    winebin=$lutriswinebin
elif hash wine 2>/dev/null; then
    echo "Warnning!!! System wine will be use, keep in mind of possible problems"
else
    echo "Error!!! Please install wine recomended playonlinux"
    echo '"Tools" menu -> "Manage wine versions" menu item -> "Wine versions (amd64)" tab"'
    echo 'Find and select 4.21 from the left side'
    echo 'And click ">" button to install it'
    echo 'You can use Lutris as well. Find wine in runners and push Manage Versions button, find and mark lutris-4.21 item in list'
    exit 1
fi


optimus=""
if [[ useoptirun -eq 1 ]]; then
    if hash optirun 2>/dev/null; then
	optimus="optirun";
    elif  hash primusrun 2>/dev/null; then
	optimus="primusrun";
    elif [[ $(__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only glxinfo -B|grep "OpenGL vendor"|grep NVIDIA) != "" ]]; then
	optimus="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only";
    fi
fi

echo "Optimus:  $optimus";

useosd="";
if hash osd_cat 2>/dev/null; then
    useosd="2>&1 | tee /dev/stderr | sed -u -n -e '/trace/ s/.*approx //p' | osd_cat --lines=1 --color=yellow --outline=1 --pos=top --align=center"
fi

# in some reason it doesn't work
# eval $(echo WINEDEBUG=fps WINEPREFIX="\"$wineprefix\"" "\"$winebin\"" reg.exe ADD "\"HKEY_CURRENT_USER\Software\Wine\DirectInput\"" "/v" "MouseWarpOverride" "/t" "REG_SZ" "/d" "enable")

function infoscreen
{
echo -e "\
\e[44m\e[1m\e[36m  ╔══════════════════════════════════════════ INFO ═══════════════════════════════════════════════════╗  \e[0m\n\
\e[44m\e[1m\e[36m  ║  Before using Games you need to Run 'Setup prefix'(6).                                            ║  \e[0m\n\
\e[44m\e[1m\e[36m  ║  Game should be installed into lutris or playonlinux 64bit (steam and GOG are supported).         ║  \e[0m\n\
\e[44m\e[1m\e[36m  ║  winecfg will be launched automatically.                                                          ║  \e[0m\n\
\e[44m\e[1m\e[36m  ║  To prevent mouse of leaving window during ingame navigation                                      ║  \e[0m\n\
\e[44m\e[1m\e[36m  ║  Select 'Graphics' tab -> mark checkbox 'Automatically capture the mouse in full-screen windows'  ║  \e[0m\n\
\e[44m\e[1m\e[36m  ║  You need to do that only once                                                                    ║  \e[0m\n\
\e[44m\e[1m\e[36m  ╚═══════════════════════════════════════════════════════════════════════════════════════════════════╝  \e[0m\n\
"
}

function titlescreen
{
echo -e "\
\e[43m\e[31m\e[1m  ╔═══════════════════════════════════════════════════════════════════════════════════════════════════╗  \e[0m\n\
\e[43m\e[31m\e[1m  ║                                Homeworld bash Launcher                                            ║  \e[0m\n\
\e[43m\e[31m\e[1m  ╚═══════════════════════════════════════════════════════════════════════════════════════════════════╝  \e[0m\n\
"
}

declare -a optionslist=("Homeworld" "Homeworld 2" "Homeworld Remastered (HomeworldClassic)" "Homeworld 2 Remastered (Ascension)" "Homeworld Remastered Multiplayer" "Setup prefix (Run First)");

function helpscreen
{
echo -e "   Version: $version  (-h - show this info)\n\
\e[44m\e[1m\e[36m  ╔══════════════════════════════════════════ HELP ═══╦═══════════════════════════════════════════════╗  \e[0m\n\
\e[44m\e[1m\e[36m  ║ \e[4mSupported arguments:\e[24m                              ║  \e[4mSupported UI Lang:\e[24m                           ║  \e[0m\n\
\e[44m\e[1m\e[36m  ║        [1]"${optionslist[0]}"                               ║    En|Fr|De|It|Sp - selected based on LANG    ║  \e[0m\n\
\e[44m\e[1m\e[36m  ║        [2]"${optionslist[1]}"                             ║           you can force by LANG=en_US.UTF-8   ║  \e[0m\n\
\e[44m\e[1m\e[36m  ║        [3]"${optionslist[2]}" ║                                               ║  \e[0m\n\
\e[44m\e[1m\e[36m  ║        [4]"${optionslist[3]}"      ║  \e[4mLauncher modes:\e[24m                              ║  \e[0m\n\
\e[44m\e[1m\e[36m  ║        [5]"${optionslist[4]}"        ║     Default command line, but you can force   ║  \e[0m\n\
\e[44m\e[1m\e[36m  ║        [6]"${optionslist[5]}"                ║      [gui] - GTK selector (zenity)            ║  \e[0m\n\
\e[44m\e[1m\e[36m  ║                                                   ║      [tui] - terminal selector (whiptail)     ║  \e[0m\n\
\e[44m\e[1m\e[36m  ║   \e[4mExamples:\e[24m                                       ╚═══════════════════════════════════════════════╣  \e[0m\n\
\e[44m\e[1m\e[36m  ║        $ ./homeworldlauncher.sh 6                  -> setup directx,vcrun and other stuff         ║  \e[0m\n\
\e[44m\e[1m\e[36m  ║        $ ./homeworldlauncher.sh 1                  -> launch classic homeworld game               ║  \e[0m\n\
\e[44m\e[1m\e[36m  ║        $ LANG=en_US.UTF-8 ./homeworldlauncher.sh 2 -> launch homeworld2 force English language*   ║  \e[0m\n\
\e[44m\e[1m\e[36m  ║        $ ./homeworldlauncher.sh gui                -> GTK window selector will be started         ║  \e[0m\n\
\e[44m\e[1m\e[36m  ║                                                                                                   ║  \e[0m\n\
\e[44m\e[1m\e[36m  ║           * LANG=en_US.UTF-8 LANG=de_DE.UTF-8 LANG=es_ES.UTF-8 LANG=fr_FR.UTF-8 LANG=it_IT.UTF-8  ║  \e[0m\n\
\e[44m\e[1m\e[36m  ╚═══════════════════════════════════════════════════════════════════════════════════════════════════╝  \e[0m\n\
"
}

chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}

function starthomeworld
{
    local itemid=$1;
    yourlanguage="$(locale -ck LC_IDENTIFICATION|grep language|cut -d "=" -f2|sed 's|\"||'|awk '{print $NF}'|sed 's|\"||')"
    echo "System language detected: $yourlanguage"
    if [[ $itemid -eq 1 ]];then
	    # 640 - 640x480
	    # 800 - 800x600
	    # 1024 - 1024x768
	    # 1280 - 1280x1024
	    # 1600 - 1600x1200
	    screenWidth=1280
            screenHeight=1024
            declare -a widthlist=( 640 800 1024 1280 1600 )
	    declare -a heightlist=( 480 600 768 1024 1200 )
	    if [[ $useautoresolution -eq 1 ]];then
		currentscreenWidth=$(xrandr | grep '*'|awk '{print $1;}'|awk -Fx '{print $1;}')
		widthid=0
		for width in "${widthlist[@]}";do
		    if [[ $width -ge $currentscreenWidth ]];then
			break;
		    fi
		    ((++widthid))
		done
		((widthid--))
		currentscreenHeight=$(xrandr | grep '*'|awk '{print $1;}'|awk -Fx '{print $2;}')
		heightid=0
		for height in "${heightlist[@]}";do
		    if [[ $height -ge $currentscreenHeight ]];then
			break;
		    fi
		    ((++heightid))
		done
		((heightid--))
		if [[ $widthid -lt $heightid ]];then
		    heightid=$widthid
		else
		    widthid=$heightid
		fi
		screenWidth="${widthlist[$widthid]}"
		screenHeight="${heightlist[$heightid]}"
		echo "hw screen width : $screenWidth"
		echo "hw screen height: $screenHeight"
	    fi
            # -locale[english|french|german|italian|spanish]
            declare -a hwsuplang=( "french" "german" "italian" "spanish" )
            islang=$(printf -- '%s\n' "${hwsuplang[@]}"|grep -i "$yourlanguage")
            localehw=""
            if [[ "$islang" ]];then
        	echo "Custom Language Supported: $islang"
        	localehw="-locale $islang"
            fi
            homeworldparams=$(echo -waveout -"$screenWidth" -safeGL -waveout -noglddraw -noswddraw -nofastfe -triple "$localehw")
            exename=Homeworld.exe
            exelocation="$wineprefix/$installdir/Homeworld1Classic/exe";
	
    elif [[ $itemid -eq 2 ]];then
	    screenWidth=1680
            screenHeight=1024
            if [[ $useautoresolution -eq 1 ]];then
        	# homeworld2 looks like supports any resolution
        	# so lets set width to maximum not sure maybe will be some problems with side panels
        	screenWidth=$(xrandr | grep '*'|awk '{print $1;}'|awk -Fx '{print $1;}')
        	echo "hw2 screen width : $screenWidth"
        	# set height a bit less to left space for window header and topbottom panels
        	screenHeight=$((($(xrandr | grep '*'|awk '{print $1;}'|awk -Fx '{print $2;}')-56)))
        	echo "hw2 screen height: $screenHeight"
            fi
            exelocation="$wineprefix/$installdir/Homeworld2Classic/Bin/Release";
            datalocation="$wineprefix/$installdir/Homeworld2Classic/Data";
            localehw2=""
            if [[ "$yourlanguage" ]]; then
        	
        	bigfilelang=$(ls "$datalocation"|grep -i "$yourlanguage"|grep -iv "$(chr 69)$(chr 110)$(chr 103)$(chr 108)$(chr 105)$(chr 115)$(chr 104)"|grep -iv "$(chr 82)$(chr 117)$(chr 115)$(chr 115)$(chr 105)$(chr 97)$(chr 110)"|grep -iv speech|cut -d "." -f1)
		if [[ "$bigfilelang" ]];then
		    echo "language switch"
		    echo "Custom Language Supported: $bigfilelang"
		    localehw2="-locale $bigfilelang"
		fi
            fi
            homeworldparams=$(echo -w "$screenWidth" -h "$screenHeight" -hardwarecursor "$localehw2")
            exename=Homeworld2.exe
            
    elif [[ $itemid -eq 3 ]];then
	    # screensize will be adjusted automatically to game size so don't worry about this values
	    screenWidth=800
            screenHeight=600
            exename=HomeworldRM.exe
            exelocation="$wineprefix/$installdir/HomeworldRM/Bin/Release";
            datalocation="$wineprefix/$installdir/HomeworldRM/Data";
            localehwrm=""
            if [[ "$yourlanguage" ]]; then
        	
        	bigfilelang=$(ls "$datalocation"|grep -i "$yourlanguage"|grep -iv "$(chr 69)$(chr 110)$(chr 103)$(chr 108)$(chr 105)$(chr 115)$(chr 104)"|grep -iv "$(chr 82)$(chr 117)$(chr 115)$(chr 115)$(chr 105)$(chr 97)$(chr 110)"|grep -iv campaign|grep -iv speech|cut -d "." -f1)
		if [[ "$bigfilelang" ]];then
		    echo "language switch"
		    echo "Custom Language Supported: $bigfilelang"
		    localehwrm="-locale $bigfilelang"
		fi
            fi

            homeworldparams=$(echo -dlccampaign HW1Campaign.big -campaign HomeworldClassic -moviepath DataHW1Campaign -mod compatibility.big "$localehwrm")
            

    elif [[ $itemid -eq 4 ]];then
	    # screensize will be adjusted automatically to game size so don't worry about this values
	    screenWidth=800
            screenHeight=600
	    exename=HomeworldRM.exe
	    exelocation="$wineprefix/$installdir/HomeworldRM/Bin/Release";
	    datalocation="$wineprefix/$installdir/HomeworldRM/Data";
            localehwrm=""
            if [[ "$yourlanguage" ]]; then
        	
        	bigfilelang=$(ls "$datalocation"|grep -i "$yourlanguage"|grep -iv "$(chr 69)$(chr 110)$(chr 103)$(chr 108)$(chr 105)$(chr 115)$(chr 104)"|grep -iv "$(chr 82)$(chr 117)$(chr 115)$(chr 115)$(chr 105)$(chr 97)$(chr 110)"|grep -iv campaign|grep -iv speech|cut -d "." -f1)
		if [[ "$bigfilelang" ]];then
		    echo "language switch"
		    echo "Custom Language Supported: $bigfilelang"
		    localehwrm="-locale $bigfilelang"
		fi
            fi

	    homeworldparams=$(echo -dlccampaign HW2Campaign.big -campaign Ascension -moviepath DataHW2Campaign -mod compatibility.big "$localehwrm")
            

    elif [[ $itemid -eq 5 ]];then
	    # screensize will be adjusted automatically to game size so don't worry about this values
	    screenWidth=800
            screenHeight=600
            exename=HomeworldRM.exe
            exelocation="$wineprefix/$installdir/HomeworldRM/Bin/Release";
            datalocation="$wineprefix/$installdir/HomeworldRM/Data";
            localehwrm=""
            if [[ "$yourlanguage" ]]; then
        	
        	bigfilelang=$(ls "$datalocation"|grep -i "$yourlanguage"|grep -iv "$(chr 69)$(chr 110)$(chr 103)$(chr 108)$(chr 105)$(chr 115)$(chr 104)"|grep -iv "$(chr 82)$(chr 117)$(chr 115)$(chr 115)$(chr 105)$(chr 97)$(chr 110)"|grep -iv campaign|grep -iv speech|cut -d "." -f1)
		if [[ "$bigfilelang" ]];then
		    echo "language switch"
		    echo "Custom Language Supported: $bigfilelang"
		    localehwrm="-locale $bigfilelang"
		fi
            fi

            homeworldparams=$(echo -mpbeta -mod compatibility.big "$localehwrm")

    fi

    if [[ $usesteam -eq 1 ]]; then
	# do not start steam if it's already running
	pid=$(WINEPREFIX="$wineprefix" "$winebin" winedbg --command "info proc"|grep -i steam.exe|awk '{print $1;}');
	if ! [[ "$pid" ]]; then
	    cd "$wineprefix/$steaminstallpath";
	    #launch simplified steam before game it allows to suppress message about "someone started this app with parameters do you want to allow" and when you agree it does nothing
	    #eval $(echo WINEPREFIX="\"$wineprefix\"" "\"$winebin\"" start explorer /desktop=HomeworldRM,"$screenWidth"x"$screenHeight" "steam.exe" -silent -no-cef-sandbox -console)
	    eval $(echo WINEPREFIX="\"$wineprefix\"" "\"$winebin\"" start "steam.exe" -silent -no-cef-sandbox -console)
	    #wait for steam start actually a bit supid way if more than 5 steamwebhelper processes that suppose steam started fine and make sure that steam.exe still there
	    while [[ $(ps aux|grep exe|grep -i steamwebhelper|wc -l) -le 5 ]] && [[ "$(WINEPREFIX="$wineprefix" "$winebin" winedbg --command "info proc"|grep -i steam.exe|awk '{print $1;}')" ]]; do echo "wait 5 seconds for steam launch"; sleep 5; done
	fi
    fi
    cd "$exelocation"
    # start application
    eval $(echo WINEDEBUG=fps WINEPREFIX="\"$wineprefix\"" "$optimus" "\"$winebin\"" explorer /desktop=HomeworldRM,"$screenWidth"x"$screenHeight" \""$exename"\" "$homeworldparams" "$useosd")
    # if you don't want to close steam on exit comment row below
    eval $(echo WINEPREFIX="\"$wineprefix\"" wineserver -k)
}

function setupprefix
{
	eval $(echo WINEPREFIX="\"$wineprefix\"" WINE="\"$winebin\"" winetricks -q  vcrun6 vcrun6sp6 vcrun2003 vcrun2005 vcrun2008 vcrun2010 vcrun2012 vcrun2013 vcrun2015)
	eval $(echo WINEPREFIX="\"$wineprefix\"" WINE="\"$winebin\"" winetricks -q  dxdiag dxdiagn dx8vb directx9 d3dx9 d3dx9_24 d3dx9_25 d3dx9_26 d3dx9_27 d3dx9_28 d3dx9_29 d3dx9_30 d3dx9_31 d3dx9_32 d3dx9_33 d3dx9_34 d3dx9_35 d3dx9_36 d3dx9_37 d3dx9_38 d3dx9_39 d3dx9_40 d3dx9_41 d3dx9_42 d3dx9_43)
	eval $(echo WINEPREFIX="\"$wineprefix\"" WINE="\"$winebin\"" winetricks -q  tahoma corefonts fontsmooth=rgb)
	# actually this one below doesn't work insome reason
	eval $(echo WINEPREFIX="\"$wineprefix\"" WINE="\"$winebin\"" winetricks -q  mwo=force)
	eval $(echo WINEPREFIX="\"$wineprefix\"" WINE="\"$winebin\"" winetricks -q  vb6run)
	eval $(echo WINEPREFIX="\"$wineprefix\"" "\"$winebin\"" start winecfg)
	# some kind of way to show description in wine what you need to do
	#eval $(echo WINEPREFIX="\"$wineprefix\"" "\"$winebin\"" start CMD /C "\"ECHO To prevent mouse of leaving window during ingame navigation Select Graphics tab and mark checkbox Automatically capture the mouse in full-screen windows && PAUSE\"")
echo -e "\
\e[40m\e[44m\e[1m  To prevent mouse of leaving window during ingame navigation                                                 \e[0m\n\
\e[40m\e[44m\e[1m  Go to \"winecfg\" -> \"Graphics\" tab -> mark checkbox \"Automatically capture the mouse in full-screen windows\" \e[0m\n\
\e[40m\e[44m\e[1m  Everything done. Please tune winecfg and relaunch script                                                    \e[0m\n"
}


function zenitymenu
{
    i=0
    zenity_options=""
    for option in "${optionslist[@]}"; do
	zenity_options="$zenity_options $( if [[ $i -eq 2 ]];then echo TRUE; else echo FALSE;fi) $((++i)) "\"$option\"" "
    done
    #echo zenity --list --column Selection --column ID --column Game $zenity_options --radiolist
    zenityresult="$(eval $(echo zenity --width=500 --height=400 --title \"Homeworld Launcher\"  --text \"Setup wineprefix before launch games 6.\\nGame should be installed under lutris or playonlinux 64bit.\\nYou need to do that only once.\\n\\nSelect game:\" --list --column Selection --column ID --column Game $zenity_options --radiolist))"
    echo "$zenityresult"
    return "$zenityresult"
}

function whiptailmenu
{
    i=0
    whiptail_options=""
    for option in "${optionslist[@]}"; do
	whiptail_options="$whiptail_options \""$((++i))"\" \""$option"\" $(if [[ $i -eq 3 ]];then echo ON; else echo OFF;fi) \n "
    done
    innertext='"
    \\nGame should be installed into lutris or playonlinux 64bit.
    \\nBefore launch game you should Setup prefix (6). Do that just once.
    \\n
    \\n Select Game:
    \\n  ⇵ - move cursor by options; SPACE - select option; ENTER - confirm;
    \\n  TAB - switch to buttons;"'
    whiptailresult="$(eval $(echo -e TERM=ansi whiptail --title "\"Homeworld Launcher\"" --radiolist "\n" "$innertext" 20 78 "$((($i+1)))" "\n" "$whiptail_options" "\"$(((${#optionslist[@]})+1))\" \"Exit\" OFF"  "3>&1 1>&2 2>&3"))"
    echo "$whiptailresult"
    return "$whiptailresult"
}

function selector
{
optionslist+=( "exit" )
COLUMNS=20
export PS3=$'\e[22m\e[1m\e[48;5;18mType number to play selected game and  hit Enter:\e[0m '
options=("${optionslist[@]}")
select opt in "${options[@]}"
do
    case $opt in
        "Homeworld")
            echo "Starting $REPLY $opt"
            starthomeworld $REPLY
	    break
            ;;
        "Homeworld 2")
            echo "Starting $REPLY $opt"
            starthomeworld $REPLY
            break
            ;;
        "Homeworld Remastered (HomeworldClassic)")
            echo "Starting $REPLY $opt"
            starthomeworld $REPLY
            break
            ;;
        "Homeworld 2 Remastered (Ascension)")
            echo "Starting $REPLY $opt"
            starthomeworld $REPLY
            break
            ;;
        "Homeworld Remastered Multiplayer")
            echo "Starting $REPLY $opt"
            starthomeworld $REPLY
            break
            ;;
	"Setup prefix (Run First)")
	    echo "Installing required libs:"
	    setupprefix
	    break
	    ;;
        "exit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
}

helpscreen
infoscreen
titlescreen
argument=$1
nameoflauncher=$(basename "$0")
re='^[0-9]+$'
if ! [[ $argument =~ $re ]];then
    if [[ "$argument" == "tui" ]] || [[ "$nameoflauncher" == "hwlauncher-tui" ]];then
	if hash whiptail 2>/dev/null; then
	    argument=$(whiptailmenu)
	    if [[ -z "$argument" ]] || [[ $argument -eq $(((${#optionslist[@]}+1))) ]];then
		echo "action canceled"
		exit 0
	    fi
	else
	    echo "No whiptail found. If you want to use gui then install whiptail"
	    argument=""; 
	fi
    elif [[ "$argument" == "gui" ]] || [[ "$nameoflauncher" == "hwlauncher-gui" ]];then
	if hash zenity 2>/dev/null; then
	    argument=$(zenitymenu)
	    if [[ -z "$argument" ]];then
		echo "action canceled"
		exit 0
	    fi
	else
	    echo "No zenity found. If you want to use gui then install zenity"
	    argument=""; 
	fi
    elif [[ "$argument" == "help" ]] || [[ "$argument" == "h" ]] || [[ "$argument" == "--help" ]] || [[ "$argument" == "-h" ]];then
	exit 0
    elif [[ " ${optionslist[@]} " =~ " ${nameoflauncher} " ]];then
	echo "exists in array"
	for i in "${!optionslist[@]}"; do
	    if [[ "${optionslist[$i]}" = "${nameoflauncher}" ]]; then
    		argument="$((${i}+1))";
    		echo "$argument"
	    fi
	done
    fi
fi

if [[ $argument =~ $re ]];then
    if [[ $argument -ge 1 ]] && [[ $argument -le $(((${#optionslist[@]}-1))) ]];then
	starthomeworld $argument
    elif [[ $argument -eq ${#optionslist[@]} ]];then
	setupprefix
    else
	selector
    fi
else
    selector
fi
