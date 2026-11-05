# HomeLAN: ether6-9, one bridge, on the second switch chip.
# The bridge settings keep Sonos and the Decos happy: IGMP snooping with a
# multicast querier (Sonos discovery/streams across the mesh) and STP with a
# low priority so the RB4011 stays root bridge over the Decos.

/interface ethernet
set [find default-name=ether6] comment="HomeLAN - Deco X55 #1"
set [find default-name=ether7] comment="HomeLAN - Deco X55 #2"
set [find default-name=ether8] comment="HomeLAN - Deco X55 #3"
set [find default-name=ether9] comment="HomeLAN - spare"

/interface bridge
add name=HomeLAN protocol-mode=stp priority=0x4000 igmp-snooping=yes multicast-querier=yes \
    comment="HomeLAN - ether6-9"

/interface bridge port
add bridge=HomeLAN interface=ether6 comment="HomeLAN - Deco X55 #1"
add bridge=HomeLAN interface=ether7 comment="HomeLAN - Deco X55 #2"
add bridge=HomeLAN interface=ether8 comment="HomeLAN - Deco X55 #3"
add bridge=HomeLAN interface=ether9 comment="HomeLAN - spare"
