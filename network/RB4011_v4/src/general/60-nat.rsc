# General: NAT, only on the way out to EE. Traffic between HomeLAN and the
# lab is routed, never NATed.

/ip firewall nat
add chain=srcnat action=masquerade out-interface-list=WAN ipsec-policy=out,none comment="NAT internal IPv4 to EE PPPoE"

# NAT66 for the lab's ULA: outbound IPv6 internet with addresses inside the
# lab that never change, whatever EE does to the delegated prefix. HomeLAN
# has its own EE addresses and isn't NATed.
/ipv6 firewall nat
add chain=srcnat action=masquerade out-interface-list=WAN src-address=fd18:aaa8:47c3::/48 \
    comment="NAT66 lab ULA to the EE prefix (outbound only)"
