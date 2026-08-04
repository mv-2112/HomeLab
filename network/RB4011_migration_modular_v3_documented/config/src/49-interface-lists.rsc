# Interface lists.

/interface list
add name=WAN comment="Internet/WAN"
add name=LAN comment="Trusted internal interfaces"
add name=LAB comment="Routed LabLAN interfaces"

/interface list member
add interface=pppoe-ee list=WAN
add interface=HomeLAN list=LAN
add interface=LabLAN list=LAN
add interface=vlan10_tenant list=LAN
add interface=vlan20_tenant list=LAN
add interface=vlan30_tenant list=LAN
add interface=vlan40_tenant list=LAN
add interface=vlan88_mgmt list=LAN

add interface=vlan10_tenant list=LAB
add interface=vlan20_tenant list=LAB
add interface=vlan30_tenant list=LAB
add interface=vlan40_tenant list=LAB
add interface=vlan88_mgmt list=LAB
