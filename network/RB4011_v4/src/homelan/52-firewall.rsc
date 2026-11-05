# HomeLAN: what HOME may reach. To the clouds, HomeLAN is "the internet":
# floating IPs, provider networks and tenant IPv6 are open, and security
# groups protect the VMs. Unlike the real internet, it also gets operator
# access to the hosts and the OpenStack APIs.

/ip firewall filter
add chain=forward action=accept in-interface-list=HOME out-interface-list=WAN comment="HOME to the internet"
add chain=forward action=accept in-interface-list=HOME out-interface-list=MGMT dst-address=192.168.88.250-192.168.88.254 \
    comment="HOME to the hosts and hardware (all ports)"
add chain=forward action=accept in-interface-list=HOME out-interface-list=MGMT protocol=tcp \
    dst-address=192.168.88.200-192.168.88.239 dst-port=80,443 comment="HOME to both clouds' Horizon and APIs"
add chain=forward action=accept in-interface-list=HOME out-interface-list=LAB_CLOUDS \
    comment="HOME to the clouds: floating IPs, provider networks (security groups protect VMs)"

/ipv6 firewall filter
add chain=forward action=accept in-interface-list=HOME out-interface-list=WAN comment="IPv6 HOME to the internet"
add chain=forward action=accept in-interface-list=HOME out-interface-list=LAB_CLOUDS \
    comment="IPv6 HOME to the clouds: external networks and tenant /64s"
