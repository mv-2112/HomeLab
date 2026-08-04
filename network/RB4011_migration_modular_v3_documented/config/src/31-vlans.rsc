# VLAN interfaces sit on the LabLAN bridge.

/interface vlan
add name=vlan10_tenant interface=LabLAN vlan-id=10 comment="OpenStack tenant #1"
add name=vlan20_tenant interface=LabLAN vlan-id=20 comment="OpenStack tenant #2"
add name=vlan30_tenant interface=LabLAN vlan-id=30 comment="OpenStack tenant #3"
add name=vlan40_tenant interface=LabLAN vlan-id=40 comment="OpenStack tenant #4 - L2 only in source"
add name=vlan88_mgmt interface=LabLAN vlan-id=88 comment="Management LAN"

# RB4011 does not provide L3 hardware offload.
# VLAN switching remains hardware-offloaded where supported; routed traffic
# is handled by the RB4011 CPU, with FastTrack used for eligible flows.
