# HomeLAN bridge: entirely ether6-9 / switch chip B.
# ether10 is NOT a bridge member; it is the PPPoE WAN.

/interface bridge
add name=HomeLAN protocol-mode=rstp vlan-filtering=no comment="HomeLAN - ether6-9"

/interface bridge port
add bridge=HomeLAN interface=ether6 comment="HomeLAN - Deco X55 #1"
add bridge=HomeLAN interface=ether7 comment="HomeLAN - Deco X55 #2"
add bridge=HomeLAN interface=ether8 comment="HomeLAN - Deco X55 #3"
add bridge=HomeLAN interface=ether9 comment="HomeLAN - spare"
