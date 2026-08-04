# IPv4 firewall.
#
# HomeLAN -> Internet: allow
# HomeLAN -> LabLAN: allow
# LabLAN -> HomeLAN: allow
# LabLAN -> Internet: allow
# WAN -> internal: deny unless established/related or dst-nat.
#
# There is deliberately NO LabLAN -> HomeLAN deny. The RB4011 has no L3
# hardware offload; normal routing plus FastTrack is preferred over adding
# an inter-zone firewall policy that is not a stated requirement.

/ip firewall filter
add chain=input action=accept connection-state=established,related,untracked comment="INPUT accept established/related"
add chain=input action=drop connection-state=invalid comment="INPUT drop invalid"
add chain=input action=accept protocol=icmp comment="INPUT allow ICMP"
add chain=input action=accept in-interface=HomeLAN comment="INPUT allow HomeLAN to router"
add chain=input action=accept in-interface=vlan88_mgmt comment="INPUT allow management VLAN to router"
add chain=input action=drop in-interface-list=WAN comment="INPUT drop unsolicited WAN"
add chain=input action=drop comment="INPUT drop everything else"

add chain=forward action=fasttrack-connection connection-state=established,related hw-offload=yes comment="FORWARD FastTrack established/related"
add chain=forward action=accept connection-state=established,related,untracked comment="FORWARD accept established/related"
add chain=forward action=drop connection-state=invalid comment="FORWARD drop invalid"
add chain=forward action=accept protocol=icmp comment="FORWARD allow ICMP"
add chain=forward action=accept ipsec-policy=in,ipsec comment="FORWARD accept IPsec in"
add chain=forward action=accept ipsec-policy=out,ipsec comment="FORWARD accept IPsec out"
add chain=forward action=accept in-interface-list=LAN out-interface-list=LAN comment="FORWARD allow internal routed traffic"
add chain=forward action=accept in-interface-list=LAN out-interface-list=WAN comment="FORWARD allow LAN to Internet"
add chain=forward action=drop connection-nat-state=!dstnat in-interface-list=WAN comment="FORWARD drop unsolicited WAN"

/ip firewall nat
add chain=srcnat action=masquerade out-interface-list=WAN ipsec-policy=out,none comment="NAT internal IPv4 to EE PPPoE"
