# DNS, NTP and local management.

/ip dns
set allow-remote-requests=yes servers=1.1.1.1,1.0.0.1 cache-size=4096KiB

/ip dns static
add address=192.168.88.1 name=router.lan type=A comment="Lab management router name"
add address=192.168.1.254 name=router.home.lan type=A comment="HomeLAN router name"

/system ntp client
set enabled=yes mode=unicast

/system ntp client servers
add address=time.cloudflare.com iburst=yes comment="Cloudflare NTP"
add address=time.google.com iburst=yes comment="Google NTP"

/system ntp server
set enabled=yes

/system clock
set time-zone-name=Europe/London

/ip neighbor discovery-settings
set discover-interface-list=LAN

/tool mac-server
set allowed-interface-list=LAN

/tool mac-server mac-winbox
set allowed-interface-list=LAN
