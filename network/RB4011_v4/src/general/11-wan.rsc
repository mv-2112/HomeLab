# General: WAN (EE FTTP over PPPoE on ether10) and the EE IPv6 prefix.

/interface ethernet
set [find default-name=ether10] comment="WAN - EE ONT / PPPoE / future PoE-out" poe-out=off
set [find default-name=sfp-sfpplus1] comment="Future 10GbE uplink"

:global pppoePassword
/interface pppoe-client
add name=pppoe-ee interface=ether10 user="bthomehub@btbroadband.com" password=$pppoePassword \
    add-default-route=yes use-peer-dns=no max-mtu=1492 max-mru=1492 disabled=no comment="EE FTTP PPPoE"

# EE delegates a /56 into pool ee-pd. Only HomeLAN and the WAN take /64s from
# it; the lab uses its own ULA and reaches the internet through NAT66.
/ipv6 dhcp-client
add interface=pppoe-ee request=prefix prefix-hint=::/56 pool-name=ee-pd pool-prefix-length=64 \
    add-default-route=yes use-peer-dns=no comment="EE IPv6 DHCPv6-PD"

# NAT66 masquerade needs a global address on the out-interface, and EE gives
# the PPPoE link none of its own. One /64 from the delegation, not advertised.
/ipv6 address
add from-pool=ee-pd interface=pppoe-ee advertise=no comment="EE /64 on the WAN: source address for NAT66"
