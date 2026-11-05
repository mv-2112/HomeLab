# LabLAN: addresses.
#
# Management, 192.168.88.0/24 (IPv4 only):
#   .1         router          .200-.219  mz640 API_RANGE
#   .10-.159   DHCP            .220-.239  mz640test API_RANGE
#   .160-.199  static, spare   .240-.249  spare service addresses
#                              .250-.254  hardware: .252 mz640test, .253 mz640
#
# External networks (OpenStack owns them; no DHCP from the router):
#   VLAN 10  mz640      192.168.10.0/24  fd18:aaa8:47c3:10::/64  floating IPs .10-.249
#   VLAN 20  mz640test  192.168.20.0/24  fd18:aaa8:47c3:20::/64  floating IPs .10-.249
#
# Lab IPv6 is ULA fd18:aaa8:47c3::/48 (randomly generated, RFC 4193):
#   :10::/64, :20::/64     external networks
#   :1x::/64, :2x::/64     provider networks (if routed)
#   :1000::/52             mz640 tenant networks
#   :2000::/52             mz640test tenant networks
#   :88::/64               reserved for IPv6 management, unused

/ip address
add address=192.168.88.1/24 interface=vlan88_mgmt comment="Management gateway"
add address=192.168.10.1/24 interface=vlan10_mz640 comment="mz640 external gateway"
add address=192.168.20.1/24 interface=vlan20_mz640test comment="mz640test external gateway"

# No IPv6 on vlan88_mgmt: management is single-stack (dual-stack trips Juju).
/ipv6 address
add address=fd18:aaa8:47c3:10::1/64 interface=vlan10_mz640 advertise=yes comment="mz640 external IPv6"
add address=fd18:aaa8:47c3:20::1/64 interface=vlan20_mz640test advertise=yes comment="mz640test external IPv6"

/ipv6 nd
add interface=vlan10_mz640 advertise-dns=yes comment="mz640 external RA"
add interface=vlan20_mz640test advertise-dns=yes comment="mz640test external RA"

# Tenant /64s are routed to their tenant routers by static routes, generated
# from OpenStack by cib-undercloud/tools/ipv6-routes.py (one run per cloud).
# This catches the rest of the /48, so an unrouted lab prefix is dropped here
# instead of following the default route out to EE.
/ipv6 route
add blackhole dst-address=fd18:aaa8:47c3::/48 comment="Lab ULA /48 (more-specific routes override)"
