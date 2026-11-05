# General: read-only checks after an import. Not part of the build; paste
# these into the terminal (or /import this file: every line only prints).

/system resource print
/interface ethernet print where running
/interface bridge port print detail
/interface bridge vlan print detail
/interface list print
/interface list member print
/interface pppoe-client print detail
/ip address print
/ip route print where dst-address=0.0.0.0/0
/ip dhcp-server print
/ip dhcp-server lease print
/ip dns static print
/ip firewall filter print stats
/ip firewall nat print stats
/ipv6 dhcp-client print detail
/ipv6 pool print
/ipv6 address print
/ipv6 route print
/ipv6 nd print
/ipv6 firewall filter print stats
/ipv6 firewall nat print stats
/interface bridge host print where !local
