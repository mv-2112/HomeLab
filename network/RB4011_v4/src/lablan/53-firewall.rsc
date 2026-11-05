# LabLAN: what management and the clouds may reach. Not accepted here, so
# dropped by the default rule at the end:
#   - one cloud's networks to the other's
#   - anything in the lab starting a connection into HomeLAN
#   - the clouds to management, except their own API range on 80/443
#
# The hosts reach each other on 192.168.88.x (same VLAN, switched) and
# 192.168.200.x (direct cable); neither goes through these rules.

/ip firewall filter
add chain=forward action=accept in-interface-list=MGMT out-interface-list=WAN \
    comment="MGMT to the internet (snaps, images, Juju)"
add chain=forward action=accept in-interface-list=MGMT out-interface-list=LAB_CLOUDS \
    comment="MGMT to the clouds' networks (hosts reaching floating IPs, cluster APIs)"
add chain=forward action=accept in-interface-list=LAB_MZ640 out-interface-list=MGMT protocol=tcp \
    dst-address=192.168.88.200-192.168.88.219 dst-port=80,443 comment="mz640 cloud to its own APIs"
add chain=forward action=accept in-interface-list=LAB_MZ640TEST out-interface-list=MGMT protocol=tcp \
    dst-address=192.168.88.220-192.168.88.239 dst-port=80,443 comment="mz640test cloud to its own APIs"
add chain=forward action=accept in-interface-list=LAB_CLOUDS out-interface-list=WAN \
    comment="Clouds to the internet (NAT)"

/ipv6 firewall filter
add chain=forward action=accept in-interface-list=LAB_CLOUDS out-interface-list=WAN \
    comment="IPv6 clouds to the internet (NAT66)"
# Management has no IPv6. If a cloud moves to IPv6 management later
# (fd18:aaa8:47c3:88::/64), add its API rule here, e.g.:
# add chain=forward action=accept in-interface-list=LAB_MZ640TEST out-interface-list=MGMT protocol=tcp \
#     dst-address=fd18:aaa8:47c3:88::220-fd18:aaa8:47c3:88::239 dst-port=80,443 comment="mz640test cloud to its own APIs (IPv6)"
