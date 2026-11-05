# General: firewall zones. Every firewall rule names zones, never single
# interfaces, so adding a provider VLAN to a cloud is one list membership.
#
#   WAN            the internet (EE)
#   HOME           HomeLAN: plays "the internet" for the clouds, plus operator access
#   MGMT           LabLAN management, VLAN 88
#   LAB_MZ640      mz640's cloud networks (VLAN 10, provider VLANs 11-19)
#   LAB_MZ640TEST  mz640test's cloud networks (VLAN 20, provider VLANs 21-29)

/interface list
add name=WAN comment="Internet/WAN"
add name=HOME comment="HomeLAN"
add name=MGMT comment="LabLAN management (VLAN 88)"
add name=LAB_MZ640 comment="mz640 cloud networks (VLANs 10-19)"
add name=LAB_MZ640TEST comment="mz640test cloud networks (VLANs 20-29)"
add name=LAB_CLOUDS include=LAB_MZ640,LAB_MZ640TEST comment="Both clouds' networks"
add name=ROUTER_ADMIN include=HOME,MGMT comment="May manage the router (Winbox, SSH, discovery)"

/interface list member
add list=WAN interface=pppoe-ee
add list=HOME interface=HomeLAN
add list=MGMT interface=vlan88_mgmt
add list=LAB_MZ640 interface=vlan10_mz640
add list=LAB_MZ640TEST interface=vlan20_mz640test
