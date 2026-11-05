# General: clock, NTP, IPv6 behaviour.

/system clock
set time-zone-name=Europe/London

/system ntp client
set enabled=yes
/system ntp client servers
add address=time.cloudflare.com comment="Cloudflare NTP"
add address=time.google.com comment="Google NTP"

# The router is the NTP server for HomeLAN and the lab (input chain decides who may ask).
/system ntp server
set enabled=yes

/ipv6 settings
set disable-ipv6=no forward=yes accept-redirects=no accept-router-advertisements=no

# Router advertisements only where an explicit /ipv6 nd entry says so. The
# default entry advertises on every interface, which would hand the
# management VLAN an IPv6 default route and make it dual-stack again.
/ipv6 nd
set [find default=yes] disabled=yes

/interface detect-internet
set detect-interface-list=all
