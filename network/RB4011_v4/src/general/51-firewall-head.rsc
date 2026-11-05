# General: the start of every chain. The order across files is the rule
# order on the router:
#
#   homelan/50  work laptop isolation        (first, above everything)
#   general/51  input chain; forward: FastTrack, established, invalid, ICMP, IPsec, IPv6 sanity
#   homelan/52  what HOME may reach
#   lablan/53   what MGMT and the clouds may reach
#   general/59  default drop                 (last)
#
# Anything not accepted between 51 and 59 is dropped: clouds can't reach each
# other, the lab can't start connections into HomeLAN, the internet can't
# start connections in.

# ---------------------------------------------------------------- IPv4 ----
/ip firewall filter
add chain=input action=accept connection-state=established,related,untracked comment="INPUT accept established/related"
add chain=input action=drop connection-state=invalid comment="INPUT drop invalid"
add chain=input action=accept protocol=icmp comment="INPUT allow ICMP"
add chain=input action=accept in-interface-list=ROUTER_ADMIN comment="INPUT allow HomeLAN and management to the router"
add chain=input action=accept in-interface-list=LAB_CLOUDS protocol=udp dst-port=53,123 comment="INPUT clouds: DNS and NTP"
add chain=input action=accept in-interface-list=LAB_CLOUDS protocol=tcp dst-port=53 comment="INPUT clouds: DNS over TCP"
add chain=input action=drop in-interface-list=WAN comment="INPUT drop unsolicited WAN"
add chain=input action=drop comment="INPUT drop everything else"

# FastTrack first: in the live config it sat last, after the accepts, so it
# never matched and all routed traffic took the slow path.
add chain=forward action=fasttrack-connection connection-state=established,related comment="FORWARD FastTrack established/related"
add chain=forward action=accept connection-state=established,related,untracked comment="FORWARD accept established/related"
add chain=forward action=drop connection-state=invalid comment="FORWARD drop invalid"
add chain=forward action=accept protocol=icmp comment="FORWARD allow ICMP"
add chain=forward action=accept ipsec-policy=in,ipsec comment="FORWARD accept IPsec in"
add chain=forward action=accept ipsec-policy=out,ipsec comment="FORWARD accept IPsec out"

# ---------------------------------------------------------------- IPv6 ----
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
add chain=input action=accept in-interface-list=ROUTER_ADMIN comment="IPv6 INPUT allow HomeLAN and management to the router"
add chain=input action=accept in-interface-list=LAB_CLOUDS protocol=udp dst-port=53,123 comment="IPv6 INPUT clouds: DNS and NTP"
add chain=input action=accept in-interface-list=LAB_CLOUDS protocol=tcp dst-port=53 comment="IPv6 INPUT clouds: DNS over TCP"
add chain=input action=drop in-interface-list=WAN comment="IPv6 INPUT drop unsolicited WAN"
add chain=input action=drop comment="IPv6 INPUT drop everything else"

add chain=forward action=fasttrack-connection connection-state=established,related comment="IPv6 FORWARD FastTrack established/related"
add chain=forward action=accept connection-state=established,related,untracked comment="IPv6 FORWARD accept established/related"
add chain=forward action=drop connection-state=invalid comment="IPv6 FORWARD drop invalid"
add chain=forward action=drop src-address-list=bad_ipv6 comment="IPv6 FORWARD drop bad source"
add chain=forward action=drop dst-address-list=bad_ipv6 comment="IPv6 FORWARD drop bad destination"
# ULA belongs inside the site (RFC 4193). Lab traffic to the internet leaves
# as EE addresses via NAT66 (60-nat.rsc): srcnat happens after this chain, so
# these match the original addresses.
add chain=forward action=drop out-interface-list=WAN dst-address=fc00::/7 comment="IPv6 FORWARD no ULA destinations out to the internet"
add chain=forward action=drop in-interface-list=WAN src-address=fc00::/7 comment="IPv6 FORWARD no ULA sources in from the internet"
add chain=forward action=drop hop-limit=equal:1 protocol=icmpv6 comment="IPv6 FORWARD drop hop-limit 1"
add chain=forward action=accept protocol=icmpv6 comment="IPv6 FORWARD allow ICMPv6"
add chain=forward action=accept ipsec-policy=in,ipsec comment="IPv6 FORWARD accept IPsec in"
add chain=forward action=accept ipsec-policy=out,ipsec comment="IPv6 FORWARD accept IPsec out"
