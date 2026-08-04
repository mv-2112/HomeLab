# IPv6 firewall. IPv6 is routed, not NATed.
#
# LabLAN <-> HomeLAN routing is intentionally permitted.
# WAN ingress remains protected.

/ipv6 firewall address-list
add list=bad_ipv6 address=::/128 comment="unspecified"
add list=bad_ipv6 address=::1/128 comment="loopback"
add list=bad_ipv6 address=fec0::/10 comment="site-local"
add list=bad_ipv6 address=::ffff:0.0.0.0/96 comment="IPv4-mapped"
add list=bad_ipv6 address=::/96 comment="IPv4-compatible"
add list=bad_ipv6 address=100::/64 comment="discard-only"
add list=bad_ipv6 address=2001:db8::/32 comment="documentation"
add list=bad_ipv6 address=2001:10::/28 comment="ORCHID"
add list=bad_ipv6 address=3ffe::/16 comment="6bone"

/ipv6 firewall filter
add chain=input action=accept connection-state=established,related,untracked comment="IPv6 INPUT accept established/related"
add chain=input action=drop connection-state=invalid comment="IPv6 INPUT drop invalid"
add chain=input action=accept protocol=icmpv6 comment="IPv6 INPUT allow ICMPv6"
add chain=input action=accept protocol=udp src-address=fe80::/10 dst-port=546 comment="IPv6 INPUT allow DHCPv6-PD"
add chain=input action=accept in-interface=HomeLAN comment="IPv6 INPUT allow HomeLAN to router"
add chain=input action=accept in-interface=vlan88_mgmt comment="IPv6 INPUT allow management VLAN to router"
add chain=input action=drop in-interface-list=WAN comment="IPv6 INPUT drop unsolicited WAN"
add chain=input action=drop comment="IPv6 INPUT drop everything else"

add chain=forward action=fasttrack-connection connection-state=established,related hw-offload=yes comment="IPv6 FORWARD FastTrack established/related"
add chain=forward action=accept connection-state=established,related,untracked comment="IPv6 FORWARD accept established/related"
add chain=forward action=drop connection-state=invalid comment="IPv6 FORWARD drop invalid"
add chain=forward action=drop src-address-list=bad_ipv6 comment="IPv6 FORWARD drop bad source"
add chain=forward action=drop dst-address-list=bad_ipv6 comment="IPv6 FORWARD drop bad destination"
add chain=forward action=drop hop-limit=equal:1 protocol=icmpv6 comment="IPv6 FORWARD drop hop-limit 1"
add chain=forward action=accept protocol=icmpv6 comment="IPv6 FORWARD allow ICMPv6"
add chain=forward action=accept ipsec-policy=in,ipsec comment="IPv6 FORWARD accept IPsec in"
add chain=forward action=accept ipsec-policy=out,ipsec comment="IPv6 FORWARD accept IPsec out"
add chain=forward action=accept in-interface-list=LAN out-interface-list=LAN comment="IPv6 FORWARD allow internal routed traffic"
add chain=forward action=accept in-interface-list=LAN out-interface-list=WAN comment="IPv6 FORWARD allow LAN to Internet"
add chain=forward action=drop in-interface-list=WAN comment="IPv6 FORWARD drop unsolicited WAN"
