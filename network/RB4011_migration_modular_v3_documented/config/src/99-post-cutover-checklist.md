# Post-cutover checklist

## WAN
- [ ] ether10 links to EE ONT at 1GbE
- [ ] PPPoE connected
- [ ] IPv4 default route installed
- [ ] IPv4 Internet works
- [ ] DHCPv6-PD bound
- [ ] IPv6 default route exists
- [ ] delegated IPv6 pool exists

## HomeLAN
- [ ] ether6/7/8 connect to Deco X55s in AP mode
- [ ] ether9 is spare
- [ ] clients remain on 192.168.1.0/24
- [ ] gateway remains 192.168.1.254
- [ ] DNS remains 192.168.1.254
- [ ] NTP remains 192.168.1.254
- [ ] existing statically configured devices work
- [ ] IPv4 Internet works
- [ ] IPv6 Internet works

## LabLAN
- [ ] ether1-5 are LabLAN
- [ ] VLAN 10/20/30/40 tagged
- [ ] VLAN 88 native/untagged
- [ ] VLAN 10/20/30/88 DHCP works
- [ ] VLAN 40 remains L2-only as in source

## Routing/security
- [ ] HomeLAN -> LabLAN works
- [ ] LabLAN -> HomeLAN works
- [ ] LabLAN -> Internet works
- [ ] LabLAN -> HomeLAN works
- [ ] Internet -> internal is blocked
- [ ] FastTrack counters increase for eligible flows

## Hardware
- [ ] HomeLAN bridge ports show H hardware offload
- [ ] LabLAN bridge ports show H hardware offload
- [ ] Confirm RB4011 is using CPU routing for inter-VLAN traffic
- [ ] Confirm FastTrack counters increase for eligible routed flows
- [ ] CPU remains healthy under normal load

## PoE
- [ ] ether10 PoE-out remains OFF initially
- [ ] verify EE ONT voltage/current/PoE requirements before enabling
- [ ] test WAN stability under PoE load
