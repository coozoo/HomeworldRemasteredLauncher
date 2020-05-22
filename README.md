# Homeworld Remastered Launcher

## Summary

It's just a Homeworld remastered game launcher.

This windows only Space strategy game with launcher written in .NET which actually doesn't works in wine. Remastered game collection contains original old games and new remastered version.
All of this games has a lot of parameters. And needs wineprefix with some tricks to run smothly.

So this script attempt to make game launcher for linux using game installed by Steam or GOG (it's not hard to add more options to detect game) inside lutris or playonlinux wineprefixes.


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

Maybe somehing more... but that's how it works in my case.

## Preparations to use script

You should install Lutris or Playonlinux in the way available for your distribution. winetricks shold be installed as well

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

## Using launcher

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

Next UI languages are available fo all homeworld games:

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

### Command line launcher mode

Cli mode is default you need to launch it by

```
./homeworldlauncher.sh
```

type the number of option and hit Enter.

<img src="https://user-images.githubusercontent.com/25594311/82635249-75e78500-9c08-11ea-9773-7fecd0cd06b4.png" width="60%"></img>

### GUI launcher mode

It is required zenity to start GUI. In my distro it was installed by default.

GUI selector:

```
./homeworldlauncher.sh gui
```

or create symlink to it `$ ln -s ./homeworldlauncher.sh "./hwlauncher-gui"` and launch `./hwlauncher-gui`

<img src="https://user-images.githubusercontent.com/25594311/82635555-18a00380-9c09-11ea-97b1-33d422e0040d.png" width="60%"></img>

### Termminal launcher mode

It is required whiptail to start TUI. In my distro it was installed by default.

```
./homeworldlauncher.sh tui
```

or create symlink to it `$ ln -s ./homeworldlauncher.sh "./hwlauncher-tui"` and launch `./hwlauncher-tui`

<img src="https://user-images.githubusercontent.com/25594311/82635926-125e5700-9c0a-11ea-946a-681343f27964.png" width="60%"></img>

### Script cutomizations

Sure you can modify it any way what you want but here few inputs.

#### Setting custom wineprefix

Script search installs inside lutris Wine Steam prefix and all 64bit playonlinux prefixes.

To force script using your winprefix find `wineprefix=""` and set it to yours value.

#### Disable using optimus

If optirun or primusrun are not available script will work with intel card.

Maybe in some reason you want to use intel GPU instead of optimus.  
Then find `useoptirun=1` and change it to `useoptirun=0`

#### Ingame screen resolution

Old games Homeworld and Homeworld2 has limited set of screen resolutions so script will determine your current screen width and height and set ingame resolution accordingly.

Homeworld screen resolution pretty strict so script will use first resolution that will fit to your screen.

Homeworld2 looks like can support any resolution. They simply are not available inside game options. So this script will set width accordingly to your screen and height a bit less to left space for bars.

Homeworld remastered games will resize wine window accordingly to ingame settings (didn't try if command line screens are supported)

To disable this behavior find `useautoresolution=1` and change it to `useautoresolution=0`. In this case don't forget to check default screen size values inside starthomeworld function. Check screenWidth and screenHeight variables for first and second if and change it apropriatly. 



