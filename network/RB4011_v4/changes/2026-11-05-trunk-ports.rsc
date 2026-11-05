# Apply to the running router (built from v4 before 5 Nov 2026) to match
# lablan/30-bridge.rsc: the ens4f0 ports become tagged-only trunks, VLAN 88
# stays only on the eno1 (access) ports, and the provider VLANs appear for
# OpenStack provider networks and SR-IOV VFs.
#
# Use Safe Mode (Ctrl+X in the terminal) and work from HomeLAN or ether4's
# host; nothing here touches HomeLAN. /import file-name=2026-11-05-trunk-ports.rsc

/interface ethernet
set [find default-name=ether2] comment="LabLAN - mz640 ens4f0 (trunk: VLANs 10-19)"
set [find default-name=ether3] comment="LabLAN - spare (management access)"
set [find default-name=ether5] comment="LabLAN - mz640test ens4f0 (trunk: VLANs 20-29)"

# Trunks: pvid 1, so the bridge doesn't add them to VLAN 88 untagged on its
# own (it does that for a port's pvid), and untagged frames are dropped.
/interface bridge port
set [find interface=ether2] pvid=1 frame-types=admit-only-vlan-tagged comment="mz640 ens4f0: trunk"
set [find interface=ether5] pvid=1 frame-types=admit-only-vlan-tagged comment="mz640test ens4f0: trunk"
set [find interface=ether1] frame-types=admit-only-untagged-and-priority-tagged
set [find interface=ether3] frame-types=admit-only-untagged-and-priority-tagged comment="spare: management access"
set [find interface=ether4] frame-types=admit-only-untagged-and-priority-tagged

/interface bridge vlan
set [find vlan-ids=88] untagged=ether1,ether3,ether4 comment="Management: untagged on the access ports only"
set [find vlan-ids=10] tagged=LabLAN,ether2 comment="mz640 external (routed)"
add bridge=LabLAN vlan-ids=11-19 tagged=ether2 comment="mz640 provider VLANs (L2 only)"
add bridge=LabLAN vlan-ids=21-29 tagged=ether5 comment="mz640test provider VLANs (L2 only)"
