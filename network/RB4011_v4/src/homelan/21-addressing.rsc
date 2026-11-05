# HomeLAN: addresses. Unchanged from the live router: 192.168.1.254 stays
# gateway, DNS and NTP for every existing client.

/ip address
add address=192.168.1.254/24 interface=HomeLAN comment="HomeLAN gateway/DNS/NTP - preserve existing client configuration"

# Native IPv6 from EE, plus a ULA for stable internal addressing. HomeLAN
# devices use the ULA when talking to the lab (also ULA), so those replies
# never depend on the EE prefix.
/ipv6 address
add address=fd00:50::1/64 interface=HomeLAN advertise=yes comment="HomeLAN ULA"
add from-pool=ee-pd interface=HomeLAN advertise=yes comment="HomeLAN EE delegated /64"
# Optional, later: move HomeLAN's ULA into the lab /48 so one prefix means
# "the whole site". Add this, let devices pick it up, then remove fd00:50::1.
# add address=fd18:aaa8:47c3:50::1/64 interface=HomeLAN advertise=yes comment="HomeLAN ULA (site /48)"

/ipv6 nd
add interface=HomeLAN advertise-dns=yes comment="HomeLAN RA"
