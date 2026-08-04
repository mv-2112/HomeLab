# Physical interface descriptions. Names remain ether1..ether10.
#
# ether1-5: LabLAN
# ether6-9: HomeLAN
# ether10: EE ONT / PPPoE / future PoE-out

/interface ethernet
set [find default-name=ether1] comment="LabLAN - port 1"
set [find default-name=ether2] comment="LabLAN - port 2"
set [find default-name=ether3] comment="LabLAN - port 3"
set [find default-name=ether4] comment="LabLAN - port 4"
set [find default-name=ether5] comment="LabLAN - port 5 / spare"
set [find default-name=ether6] comment="HomeLAN - Deco X55 #1"
set [find default-name=ether7] comment="HomeLAN - Deco X55 #2"
set [find default-name=ether8] comment="HomeLAN - Deco X55 #3"
set [find default-name=ether9] comment="HomeLAN - spare"
set [find default-name=ether10] comment="WAN - EE ONT / PPPoE / future PoE-out"
set [find default-name=sfp-sfpplus1] comment="Future 10GbE uplink"

# Keep PoE-out disabled during migration.
/interface ethernet
set [find default-name=ether10] poe-out=off

# Replace the credentials before importing.
/interface pppoe-client
add name=pppoe-ee interface=ether10 user="YOUR_PPPOE_USERNAME" password="YOUR_PPPOE_PASSWORD" add-default-route=yes use-peer-dns=no disabled=no max-mtu=1492 max-mru=1492 comment="EE FTTP PPPoE"
