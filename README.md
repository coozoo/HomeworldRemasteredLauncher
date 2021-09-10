# Homeworld Remastered Launcher

## Summary

It's just a Homeworld remastered game launcher.

This MS Windows only Space strategy game with launcher written in .NET which actually doesn't work in wine. Remastered game collection contains original old games and new remastered version.
All of this games has a lot of parameters. And needs wineprefix with some tricks to run smothly.

So this script attempt to make game launcher for linux using game installed by Steam or GOG (it's not hard to add more options to detect game) inside lutris or playonlinux wineprefixes.

<img src="https://user-images.githubusercontent.com/25594311/82635249-75e78500-9c08-11ea-9773-7fecd0cd06b4.png" width="60%"></img>

## Contents

* [Features](#features)
* [Preparations to use script](#preparations-to-use-script)
   * [Setup Games inside Lutris or POL](#setup-games-inside-lutris-or-pol)
      * [lutris](#lutris)
      * [Playonlinux](#Playonlinux)
* [Launcher usage](#launcher-usage)
   * [Download launcher script](#download-launcher)
   * [Supported arguments](#supported-arguments)
      * [In game UI Language](#in-game-ui-language)
      * [Quick start symlinks](#quick-start-symlinks)
      * [Command line examples](#command-line-examples)
   * [Setup wineprefix](#setup-wineprefix)   
   * [Script modes](#script-modes)
      * [Command line launcher mode](#command-line-launcher-mode)
      * [GUI launcher mode](#gui-launcher-mode)
      * [Terminal launcher mode](#terminal-launcher-mode)
   * [Script cutomizations](#script-cutomizations)
      * [Customize wineprefix](#customize-wineprefix)
      * [Disable using optimus](#disable-using-optimus)
      * [Disable/Enable osd FPS](#disableenable-osd-fps)
      * [Ingame screen resolution](#ingame-screen-resolution)
 * [Problems of Homeworld Games under Wine](#problems-of-homeworld-games-under-wine)

## Features

This launcher contains next features:

    - as mentioned before launcher has been designed to work with Steam and GOG games;
    - automatically detect wineprefix and installation dir that contains game it can be Lutris or Playonlinux;
    - use optimus (optirun or primusrun) if they're available;
    - show FPS counter for games based on wine stat;
    - find wine to run (proiority: Pol 4.21; Lutris 4.21; System wine);
    - install required tricks into wineprefix to run the game;
    - adjust screen resolution for old Homeworld;
    - some sort of cli, tui and gui switchers;
    - and actually set different parameters to run these games;

All of this allows me do not think about:

    - oh where my game? wineprefix here and game here ok;
    - what wine do I need? oh yes previous wine one (see problems section);
    - oh not again I've played homeworld before... now need to change wine version back.
    - oh yes I need to launch steam first;
    - Damn I forgot to start it with NVIDIA card;
    - what again full screen? this crap resolution for old game, full screen and how I supposed to use chats and browser;
    - oh not again, steam FPS counter again not visible under wine?
    - what a crap message from steam?...

Maybe something more... but that's how it works in my case.

## Preparations to use script

You should install Lutris or Playonlinux in the way available for your distribution. winetricks should be installed as well

### Setup Games inside Lutris or POL

First you need to setup 64bit wineprefix.  
This script still allows to use the same wineprefix for other games and you don't need to change settings everytime for each game like wine version.  

So if you have Steam under wine (playonlinux or lutris) you can install game by steam and skip this step.  
In caseof GOG game only playonlinux supported (but you can override wineprefix with custom one).

We need to install Homeworld game in our steam (suppose GOG will work without problem).  

####  Lutris

In case of steam it's my choice. Because Lutris provides steam ready runner for steam just install and use (with some UI flickering but anyway it works).

To setup Lutris steam game perform next steps:

    - launch lutris;
    - press button on the left top corner beside "Runners";
    - in the appeared "Manage Runners" window scroll down and find "Wine Steam", click install button;
    - in the same window "Wine" and click "Manage Vesrions" button;
    - in "Manage wine versions" find lutris-4.21 and click on checkbox beside.

After downloading wine version you need to go to main Lutris window and launch "Wine Steam" by Run button.  
Setup steam to autologin. And install game inside steam (it can be black inside just move mouse over steam windows and images will flicker and appear for you). Wait till the game will be downloaded.

#### Playonlinux

It's possible to use playonlinux with steam but it appears to be more problematic than Lutris. But GOG users should be fine with that.

Don't use default Pol (automatic steam install) it will install 32bit prefix where games have problem with FPS at least for me (see problems section)

To setup playonlinux steam game perform next steps:

    - download steam for windows on their website;
    - launch playonlinux;
    - hit "Install" button;
    - in appearead "PlayOnLinux menu" window click "Install a non-listed program" at the bottom left corner;
    - "install a program in a new virtual drive", next
    - enter some name for your prefix, next
    - no need cusomizations at this stage, next
    - "64bit windows installation", next
    - click "browse" button and select previously downloaded steam
    - next few more times and you create Steam shortcut at the end

Launch steam login and suppose you will see black screen.  
So select steam shortcut click and add ```-no-cef-sandbox -console``` to arguments to use simplified version of steam.
Launch steam again and install Homeworld remastered.

## Launcher Usage

### Download launcher

Sure you can download it in any other way

Using git:
```
$ git clone https://github.com/coozoo/HomeworldRemasteredLauncher
$ cd HomeworldRemasteredLauncher
$ chmod 777 homeworldlauncher.sh
```

Get script by wget:
```
$ wget https://github.com/coozoo/HomeworldRemasteredLauncher/raw/master/homeworldlauncher.sh
$ chmod 777 homeworldlauncher.sh
```

### Supported arguments

Launcher supports next arguments:

    - ID of action:
	* [1] Homeworld - original classic Homeworld game;
	* [2] Homeworld 2 - original classic Homeworld2 game;
	* [3] Homeworld Remastered (HomeworldClassic) - remastered Homeworld;
	* [4] Homeworld 2 Remastered (Ascension) - remastered Homeworld2;
	* [5] Homeworld Remastered Multiplayer - multiplayer I've didn't tried to play it (some people wrote that it should be activated in original windows launcher);
	* [6] Setup prefix (Run First) - setup directx vcrun and other stuff.
    - Launcher modes:
	* [gui] - GTK selector it requires zenity to be installed;
	* [tui] - terminal selector it requires whiptail to be installed.

#### In game UI Language

By default game will be launched using environment language.  
You can force another language by setting up LANG variable.  

Next UI languages are available for all homeworld games:

    - English;
    - German;
    - Spanish;
    - French;
    - Italian;
    
Just examples:

    - `LANG=en_US.UTF-8 ./homeworldlauncher.sh 3` to force English;
    - `LANG=de_DE.UTF-8 ./homeworldlauncher.sh 3` to force German;
    - `LANG=es_ES.UTF-8 ./homeworldlauncher.sh 3` to force Spanish;
    - `LANG=fr_FR.UTF-8 ./homeworldlauncher.sh 3` to force French;
    - `LANG=it_IT.UTF-8 ./homeworldlauncher.sh 3` to force Italian;

#### Quick start symlinks

Symlinking support by launcher I mean that you can create symlink with the name of game and it will launch appropriate game.

You can create them by following commands (sure you can change paths):

```
$ ln -s ./homeworldlauncher.sh "./Homeworld";
$ ln -s ./homeworldlauncher.sh "./Homeworld 2";
$ ln -s ./homeworldlauncher.sh "./Homeworld Remastered (HomeworldClassic)";
$ ln -s ./homeworldlauncher.sh "./Homeworld 2 Remastered (Ascension)";
$ ln -s ./homeworldlauncher.sh "./Homeworld Remastered Multiplayer";
$ ln -s ./homeworldlauncher.sh "./hwlauncher-gui";
$ ln -s ./homeworldlauncher.sh "./hwlauncher-tui";
```

Now when you click "Homeworld" symlink it will launch classic game.  
Or if you click "hwlauncher-gui" you will see UI selector;

#### Command line examples

Show Help:  
```
./homeworldlauncher.sh -h
```

Start launcher in cli mode:  
```
./homeworldlauncher.sh
```

Start Homeworld2 remastered:  
```
./homeworldlauncher.sh 4
```

Start GUI selector:  
```
./homeworldlauncher.sh gui
```

### Setup wineprefix

In script there is an option to setup wineprefix and load it up with directx, vcrun. And everything that is required to run this game properly.

It is required winetricks installed to your system. For example for Fedora it is `# dnf install winetricks`.

Launch script `./homeworldlauncher.sh` and select "Setup prefix (Run First)" by entering number (6) and hitting Enter.

Wait till installers will finish all of the jobs.

At the end you will see Wine Config window.  
If you want to play game and navigate in space without problems you need to select 'Graphics' tab -> mark checkbox 'Automatically capture the mouse in full-screen windows'.

That's all now you will be able to run games

### Script modes 

#### Command line launcher mode

Cli mode is default you need to launch it by

```
./homeworldlauncher.sh
```

type the number of option and hit Enter.

<img src="https://user-images.githubusercontent.com/25594311/82635249-75e78500-9c08-11ea-9773-7fecd0cd06b4.png" width="60%"></img>

#### GUI launcher mode

It is required zenity to start GUI. In my distro it was installed by default.

GUI selector:

```
./homeworldlauncher.sh gui
```

or create symlink to it `$ ln -s ./homeworldlauncher.sh "./hwlauncher-gui"` and launch `./hwlauncher-gui`

<img src="https://user-images.githubusercontent.com/25594311/82635555-18a00380-9c09-11ea-97b1-33d422e0040d.png" width="60%"></img>

#### Terminal launcher mode

It is required whiptail to start TUI. In my distro it was installed by default.

```
./homeworldlauncher.sh tui
```

or create symlink to it `$ ln -s ./homeworldlauncher.sh "./hwlauncher-tui"` and launch `./hwlauncher-tui`

<img src="https://user-images.githubusercontent.com/25594311/82635926-125e5700-9c0a-11ea-946a-681343f27964.png" width="60%"></img>

### Script cutomizations

Sure you can modify it any way what you want but here few inputs.

#### Customize wineprefix

Script search installs inside lutris Wine Steam prefix and all 64bit playonlinux prefixes.

To force script using your winprefix find `wineprefix=""` and set it to yours value.

#### Disable using optimus

If optirun or primusrun are not available script will work with intel card.

Maybe in some reason you want to use intel GPU instead of optimus.  
Then find `useoptirun=1` and change it to `useoptirun=0`

#### Disable/Enable osd FPS

Actually to Enable it you should have `osd_cat` tool in Fedora it is provided by xosd package `# dnf install xosd`.  
If `osd_cat` available it will show FPS automatically

To disable osd FPS you need to find `useosd=""` and comment threelined if below with `#`.

#### Ingame screen resolution

Old games Homeworld and Homeworld2 has limited set of screen resolutions so script will determine your current screen width and height and it will set ingame resolution accordingly.

To disable this behavior find `useautoresolution=1` and change it to `useautoresolution=0`. In this case don't forget to check default screen size values inside starthomeworld function. Check screenWidth and screenHeight variables for first and second if and change it apropriatly. 

##### Homeworld Classic game

Homeworld screen resolution pretty strict so script will use first resolution that will fit to your screen.

##### Homeworld2 Classic game

Homeworld2 looks like can support any resolution. They simply are not available inside game options. So this script will set width accordingly to your screen and height a bit less in order to left space for toolbars.

##### Homeworld Remastered games

Homeworld remastered games will resize wine window accordingly to ingame settings

## Problems of Homeworld Games under Wine

Games run smoothly almost without problems using all of tweaks but without them only homeworld2 will be able to launch by default.  
So this script actually a set of tweaks.

Games work under Wine>5 (tested with up to 5.7) but there is some problems with it and to eliminate them it's better to use Wine4(tested with 4.21 latest available in lutris and playonlinux).

Don't try to use 32bit wine FPS in remastered version will be significatly lower than 64bit.

Wineprefix should contain:

    - all of directx
    - dxdiag
    - vcrun(2003-2015)
    - tahoma
    - corefonts
    - smooth rgb

Inside script there is option to do that for you (6). You can view it closely inside "function setupprefix".

### Original Homeworld .NET launcher

It is simply doesn't work. Even with 32bit prefix (cause .NET support in wine for 32 better than 64) it doesn't work.  
As reported in internet you need to use this launcher to activate multiplayer game. I didn't try it. But suppose you need virtualbox for that.

### Homeworld

Homeworld classic game doesn't work by default under wine. You need to pass some parameters to force it in OpenGL mode.  
Example of arguments to run it under wine `-waveout -1024 -safeGL -waveout -noglddraw -noswddraw -nofastfe -triple`  
This one works with wine 5 and wine 4.21 but actually I didn't test it a lot.  
Resolution pretty strict so it's better to use windowed mode and prevent mouse from leaving wine window.

### Homeworld2

Homeworld2 classic game it works by default you can start it and play but.  

If you want to set LOD to maximum it will crash under wine5 you can eliminate crashes caused by some of LOD settings by installing winetricks something like glsl enabled, rendered opengl, renderer lock readdraw but anyway with all high settings it will crash.  

To eliminate high settings crash completly you need to run game under Wine4.21.

In-game resolutions list pretty limited but looks like Homeworld2 supports any resolution you just need to set it in arguments.  
As for homeworld I prefer to use windowed mode and sure again it is requiered to mark option in wine that prevent mouse to leave game window.

Example of command line `-w 1024 -h 768 -hardwarecursor`.

Language support from .big files and can be set by `-locale German`. But looks like it's only for UI, I'm not sure that game contains sounds for other languages but if it's true then maybe it's possible to handle by file renaming(I've tried with German and didn't sight the differnce looks like all sounds left in English).

### Homeworld Remastered

Homeworld Remastered hm it can't be launched by default.  
You need to force report availaable version of opengl by setting.  
`export MESA_GL_VERSION_OVERRIDE=3.3COMPAT`
But even after that this game will be almost empty just tutorial available.  
Game requires command line to use remastered versions. You can find those commands inside script.  

With wine5 intro video will be in creep some kind of flickering loop of attempts to play it. But any other videos looks like played fine I've didn't played game to the end yet(and I won't under wine5). To eliminate this you can install winetricks directpplay and directmusic, but I'm not sure looks like it has more crashes with them on high settings.

Wine 4.21 intro video runs nice looks like high settings more stable with it but still there is some problem with few of them:

    - TEXTURE QUALITY: 6-MEDIUM - works stable, higher values sometimes causing troubles on load level
    - TEXTURE SIZE LIMIT: 2048 - works stable, any higher value failed to load level
    - DEPTH OF FIELD: OFF - works stable, ON value works stable but significantly lower FPS

Game resolution can be set inside game settings and wine window will be resized automatically to fit game. Again "winecfg" -> "Graphics" tab -> mark checkbox "Automatically capture the mouse in full-screen windows" to navigate in game without problem of leaving window.

Language support the same as in case of homeworld2 and available from .big files it can be set by `-locale German`. But looks like it's only for UI, I'm not sure that game contains sounds for other languages but if it's true then maybe it's possible to handle by file renaming(I've tried with German and didn't sight the differnce looks like all sounds left in English).

### Steam start

When you launching game from command line without steam launched inside wine. You will get some stupid message that someone trying to launch game with custom parameters do you want to allow and proceed and even in case yes it does nothing.  
So this script will launch steam for you and only when it is started it will continue with game loading.  
There is annoying thing it's not related to wine or game itself it's simply steam very buggy when you launch steam under wine you can be disconnected from steam launched natively. Maybe it's related to the same strange thing like sometimes I have weird statuses sync if steam in one PC chat offline sometimes it can be synced and set offline on another PC and the same can be with online...

# Bottomline

This script made for myself but maybe it will be usefull for you :)

