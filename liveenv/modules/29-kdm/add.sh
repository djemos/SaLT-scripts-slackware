#!/bin/sh
startdir="$1"
[ -n "$startdir" ] && [ -d "$startdir" ] || exit 1
cd "$(dirname "$0")"
HDIR="$startdir/liveenv"
PKGSDIR="$startdir/PKGS"
RDIR="$HDIR"/root
doinst="$HDIR"/doinst
modtxt="$HDIR"/MODIFICATIONS

cat <<EOF >> "$modtxt"
kdm
---
- kdm autologin for user 'one'


EOF

mkdir -p "$RDIR"/etc/kde/kdm
cat <<EOF > "$RDIR"/etc/kde/kdm/kdmrc
[General]
ConfigVersion=2.4
ConsoleTTYs=tty1,tty2,tty3
PidFile=/var/run/kdm.pid
ReserveServers=:1,:2,:3
ServerVTs=-4
StaticServers=:0

[Shutdown]
BootManager=None
HaltCmd=/sbin/halt
RebootCmd=/sbin/reboot

[X-*-Core]
AllowNullPasswd=false
AllowRootLogin=false
AllowShutdown=Root
AutoReLogin=false
ClientLogFile=.xsession-errors-%d
Reset=/usr/share/config/kdm/Xreset
Session=/usr/share/config/kdm/Xsession
SessionsDirs=/usr/share/config/kdm/sessions,/usr/share/apps/kdm/sessions
Setup=/usr/share/config/kdm/Xsetup
Startup=/usr/share/config/kdm/Xstartup

[X-*-Greeter]
AntiAliasing=false
BackgroundCfg=/usr/share/config/kdm/backgroundrc
ColorScheme=
FaceSource=AdminOnly
FailFont=Sans Serif,10,-1,5,75,0,0,0,0,0
ForgingSeed=1285845789
GUIStyle=
GreetFont=Serif,20,-1,5,50,0,0,0,0,0
GreetString=welcome to %n
GreeterPos=50,50
HiddenUsers=
Language=en_US
LogoArea=Logo
LogoPixmap=/usr/share/icons/hicolor/128x128/apps/slackel.png
MaxShowUID=65000
MinShowUID=500
Preloader=/usr/bin/preloadkde
SelectedUsers=
ShowUsers=NotHidden
SortUsers=true
StdFont=Sans Serif,10,-1,5,50,0,0,0,0,0
Theme=/usr/share/apps/kdm/themes/slackel
UseBackground=true
UseTheme=true
UserCompletion=false
UserList=true

[X-:*-Core]
AllowNullPasswd=true
AllowShutdown=All
NoPassEnable=true
NoPassUsers=one
ServerArgsLocal=-nolisten tcp
ServerCmd=/usr/bin/X -br -novtswitch -quiet
ServerTimeout=45

[X-:*-Greeter]
AllowClose=false
DefaultUser=one
FocusPasswd=true
LoginMode=DefaultLocal
PreselectUser=Previous

[X-:0-Core]
AutoLoginEnable=true
AutoLoginLocked=false
AutoLoginUser=one
ClientLogFile=.xsession-errors

[Xdmcp]
Enable=false
Willing=/usr/share/config/kdm/Xwilling
Xaccess=/usr/share/config/kdm/Xaccess

EOF
