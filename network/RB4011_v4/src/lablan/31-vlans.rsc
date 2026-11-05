# LabLAN: the router's own VLAN interfaces. VLANs 30, 40, 90 and 100 are
# retired (planned, never used); tenants get overlay networks inside
# OpenStack instead of VLANs.

/interface vlan
add name=vlan88_mgmt interface=LabLAN vlan-id=88 comment="Management LAN (IPv4 only)"
add name=vlan10_mz640 interface=LabLAN vlan-id=10 comment="mz640 external network"
add name=vlan20_mz640test interface=LabLAN vlan-id=20 comment="mz640test external network"
