# General: router services. Who may reach them is decided by the input chain
# (51-firewall-head.rsc), not here.

/ip dns
set allow-remote-requests=yes servers=1.1.1.1,1.0.0.1 cache-size=4096KiB

# Neighbour discovery (MNDP/LLDP/CDP) and MAC-Winbox on HomeLAN and
# management only. LLDP from the hosts arrives untagged, so on VLAN 88: run
# lldpd on a host and /ip neighbor print shows which port it's on.
/ip neighbor discovery-settings
set discover-interface-list=ROUTER_ADMIN

/tool mac-server
set allowed-interface-list=ROUTER_ADMIN
/tool mac-server mac-winbox
set allowed-interface-list=ROUTER_ADMIN
