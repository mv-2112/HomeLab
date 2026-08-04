# v2 change summary

## Changed

- Removed `l3-hw-offloading=no` from all LabLAN VLAN interfaces.
- Removed the LabLAN -> HomeLAN IPv4 firewall deny.
- Removed the LabLAN -> HomeLAN IPv6 firewall deny.
- Added explicit LAN -> LAN routed acceptance for IPv4 and IPv6.
- Kept WAN ingress protection intact.
- Moved IPv4 and IPv6 FastTrack rules before the established/related accept rules
  so eligible established/related flows can actually be FastTracked.
- Updated documentation and cutover checklist.

## Architectural intent

The RB4011 provides L2 hardware switching/offload on its switch chips but does
not provide L3 hardware routing/offload. Inter-LAN routing therefore remains a
CPU function. The configuration now prioritises straightforward routed
connectivity and FastTrack over an inter-LAN firewall isolation policy that is
not currently required.
