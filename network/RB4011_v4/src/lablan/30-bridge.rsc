# LabLAN: ether1-5, one VLAN-filtering bridge, on the first switch chip.
#
# Two kinds of port, never mixed:
#   access  VLAN 88 untagged only: the hosts' eno1 (onboard I218-LM, no
#           SR-IOV) and anything else that just needs management.
#   trunk   one cloud's VLANs, tagged only; no VLAN 88, untagged frames
#           dropped. The hosts' ens4f0 (X540): OVS carries the external VLAN,
#           and SR-IOV VFs are each tagged onto one of that cloud's provider
#           VLANs. Nothing on ens4f0 can reach management.
#
#   ether1  access  mz640 eno1
#   ether2  trunk   mz640 ens4f0 (cable it here)    VLAN 10, provider 11-19
#   ether3  access  spare (laptop on management)
#   ether4  access  mz640test eno1
#   ether5  trunk   mz640test ens4f0                VLAN 20, provider 21-29
#
# The hosts' ens4f1 ports are a direct 10GbE link (192.168.200.0/24) and never
# touch the router. Each cloud's VLANs exist only on its own host's trunk, so
# the two clouds can't meet at layer 2.

/interface ethernet
set [find default-name=ether1] comment="LabLAN - mz640 eno1 (management)"
set [find default-name=ether2] comment="LabLAN - mz640 ens4f0 (trunk: VLANs 10-19)"
set [find default-name=ether3] comment="LabLAN - spare (management access)"
set [find default-name=ether4] comment="LabLAN - mz640test eno1 (management)"
set [find default-name=ether5] comment="LabLAN - mz640test ens4f0 (trunk: VLANs 20-29)"

/interface bridge
add name=LabLAN protocol-mode=rstp vlan-filtering=no comment="LabLAN - ether1-5"

/interface bridge port
add bridge=LabLAN interface=ether1 pvid=88 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged comment="mz640 eno1: management access"
add bridge=LabLAN interface=ether2 ingress-filtering=yes frame-types=admit-only-vlan-tagged comment="mz640 ens4f0: trunk"
add bridge=LabLAN interface=ether3 pvid=88 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged comment="spare: management access"
add bridge=LabLAN interface=ether4 pvid=88 ingress-filtering=yes frame-types=admit-only-untagged-and-priority-tagged comment="mz640test eno1: management access"
add bridge=LabLAN interface=ether5 ingress-filtering=yes frame-types=admit-only-vlan-tagged comment="mz640test ens4f0: trunk"

/interface bridge vlan
add bridge=LabLAN vlan-ids=88 tagged=LabLAN untagged=ether1,ether3,ether4 \
    comment="Management: untagged on the access ports only"
add bridge=LabLAN vlan-ids=10 tagged=LabLAN,ether2 comment="mz640 external (routed)"
add bridge=LabLAN vlan-ids=20 tagged=LabLAN,ether5 comment="mz640test external (routed)"
# Provider VLANs, for OpenStack provider networks and SR-IOV VFs: layer 2
# only (the router isn't a member). To route one, add LabLAN to its tagged
# list, a VLAN interface, an address and its cloud's interface list.
add bridge=LabLAN vlan-ids=11-19 tagged=ether2 comment="mz640 provider VLANs (L2 only)"
add bridge=LabLAN vlan-ids=21-29 tagged=ether5 comment="mz640test provider VLANs (L2 only)"

/interface bridge
set [find name=LabLAN] vlan-filtering=yes
