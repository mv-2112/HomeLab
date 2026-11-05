# HomeLAN: work laptop isolation. These are the FIRST forward rules, above
# established/related and every zone rule: HomeLAN may reach the lab, and
# without these the work laptop could too.
#
# Matched by MAC only (the live rule also required 192.168.1.17, so the
# laptop slipped past it on any other address). IPv6 is new: the laptop has
# HomeLAN IPv6 addresses, and the lab is reachable over ULA.

/ip firewall address-list
add list=Private_CIDRs address=10.0.0.0/8 comment="RFC1918 Class A"
add list=Private_CIDRs address=172.16.0.0/12 comment="RFC1918 Class B"
add list=Private_CIDRs address=192.168.0.0/16 comment="RFC1918 Class C"

/ip firewall filter
add chain=forward action=drop src-mac-address=BC:D0:74:11:07:2D dst-address-list=Private_CIDRs \
    comment="CRITICAL: Drop work device traffic to any private subnets"
add chain=input action=drop src-mac-address=BC:D0:74:11:07:2D disabled=yes \
    comment="CRITICAL: Prevent work device from probing MikroTik router ports"

/ipv6 firewall address-list
add list=Private_v6 address=fc00::/7 comment="ULA: HomeLAN and the whole lab"

/ipv6 firewall filter
add chain=forward action=drop src-mac-address=BC:D0:74:11:07:2D dst-address-list=Private_v6 \
    comment="CRITICAL: Drop work device IPv6 traffic to ULA (HomeLAN and lab)"
add chain=input action=drop src-mac-address=BC:D0:74:11:07:2D disabled=yes \
    comment="CRITICAL: Prevent work device from probing MikroTik router ports (IPv6)"
