# LabLAN bridge: entirely ether1-5 / switch chip A.
# VLAN 88 is native/untagged; VLAN 10/20/30/40 are tagged.

/interface bridge
add name=LabLAN protocol-mode=rstp vlan-filtering=no comment="LabLAN - ether1-5"

/interface bridge port
add bridge=LabLAN interface=ether1 pvid=88 comment="LabLAN port 1"
add bridge=LabLAN interface=ether2 pvid=88 comment="LabLAN port 2"
add bridge=LabLAN interface=ether3 pvid=88 comment="LabLAN port 3"
add bridge=LabLAN interface=ether4 pvid=88 comment="LabLAN port 4"
add bridge=LabLAN interface=ether5 pvid=88 comment="LabLAN port 5 / spare"

/interface bridge vlan
add bridge=LabLAN tagged=LabLAN,ether1,ether2,ether3,ether4,ether5 vlan-ids=10
add bridge=LabLAN tagged=LabLAN,ether1,ether2,ether3,ether4,ether5 vlan-ids=20
add bridge=LabLAN tagged=LabLAN,ether1,ether2,ether3,ether4,ether5 vlan-ids=30
add bridge=LabLAN tagged=LabLAN,ether1,ether2,ether3,ether4,ether5 vlan-ids=40
add bridge=LabLAN tagged=LabLAN untagged=ether1,ether2,ether3,ether4,ether5 vlan-ids=88

/interface bridge
set [find name=LabLAN] vlan-filtering=yes
