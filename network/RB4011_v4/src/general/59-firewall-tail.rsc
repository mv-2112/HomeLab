# General: the end of the forward chains. Everything not accepted above
# stops here.

/ip firewall filter
add chain=forward action=drop in-interface-list=WAN connection-nat-state=!dstnat comment="FORWARD drop unsolicited WAN"
add chain=forward action=drop comment="FORWARD default drop (zone rules above say what is allowed)"

/ipv6 firewall filter
add chain=forward action=drop in-interface-list=WAN comment="IPv6 FORWARD drop unsolicited WAN"
add chain=forward action=drop comment="IPv6 FORWARD default drop (zone rules above say what is allowed)"
