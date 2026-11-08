# HomeLAN: ether6-9, one bridge, on the second switch chip.
# The bridge settings keep Sonos and the Decos happy: IGMP snooping with a
# multicast querier (Sonos discovery/streams across the mesh) and spanning
# tree with a low priority so the RB4011 stays root bridge over the Decos.
#
# RSTP with edge ports, not classic STP (changed 8 Nov 2026): classic STP
# holds a port for ~30 s (listening + learning) every time its link comes up.
# A rebooting Deco sees its cable up but nothing passing, picks wireless
# backhaul, and stays on it. Edge ports forward as soon as the link is up;
# a port that receives a BPDU (a real switch, or a loop) drops edge status
# and RSTP handles it normally. Sonos/Deco classic STP still interoperates:
# RSTP falls back to STP on just those ports.

/interface ethernet
set [find default-name=ether6] comment="HomeLAN - Deco X55 #1"
set [find default-name=ether7] comment="HomeLAN - Deco X55 #2"
set [find default-name=ether8] comment="HomeLAN - Deco X55 #3"
set [find default-name=ether9] comment="HomeLAN - spare"

/interface bridge
add name=HomeLAN protocol-mode=rstp priority=0x4000 igmp-snooping=yes multicast-querier=yes \
    comment="HomeLAN - ether6-9"

/interface bridge port
add bridge=HomeLAN interface=ether6 edge=yes comment="HomeLAN - Deco X55 #1"
add bridge=HomeLAN interface=ether7 edge=yes comment="HomeLAN - Deco X55 #2"
add bridge=HomeLAN interface=ether8 edge=yes comment="HomeLAN - Deco X55 #3"
add bridge=HomeLAN interface=ether9 edge=yes comment="HomeLAN - spare"
