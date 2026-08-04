# RB4011 Migration

Modular RouterOS 7 configuration for the RB4011 migration from the existing hEX export.

Source:
https://raw.githubusercontent.com/mv-2112/HomeLab/refs/heads/main/mikrotik_export.conf

## Fixed architecture

- ether1-5 = LabLAN switch group
- ether6-9 = HomeLAN switch group
- ether10 = EE ONT / PPPoE WAN / future PoE-out
- sfp-sfpplus1 = future 10GbE

Ethernet interface names are deliberately NOT renamed. Descriptions are applied to the physical interfaces instead.

The RB4011 has two RTL8367 switch chips: ether1-5 and ether6-10. The two bridges are deliberately kept within those physical groups.

## HomeLAN invariants

These must remain unchanged:

- Network: 192.168.1.0/24
- Gateway: 192.168.1.254
- DNS: 192.168.1.254
- NTP: 192.168.1.254

The three Deco X55 units connect to ether6-8 in AP mode. ether9 is spare.

## LabLAN

Migrated from the hEX:

- VLAN 10: 192.168.10.0/24, gateway 192.168.10.1
- VLAN 20: 192.168.20.0/24, gateway 192.168.20.1
- VLAN 30: 192.168.30.0/24, gateway 192.168.30.1
- VLAN 40: L2 only in the source export; no IPv4 gateway/DHCP is invented
- VLAN 88: 192.168.88.0/24, gateway 192.168.88.1

VLAN 88 is native/untagged on ether1-5. VLANs 10/20/30/40 are tagged.

## Routing policy

- HomeLAN -> Internet: allow
- HomeLAN -> LabLAN: allow
- LabLAN -> HomeLAN: allow
- LabLAN -> Internet: allow
- Internet -> internal: deny by default

There is intentionally no LabLAN -> HomeLAN firewall deny. The RB4011
does not provide L3 hardware routing/offload; inter-LAN routing is CPU-based
and FastTrack is used for eligible flows. The design therefore prioritises
simple, fast routed connectivity over a firewall policy that is not currently
a stated requirement.

## IPv6

- PPPoE carries IPv6.
- DHCPv6-PD obtains the EE delegated prefix dynamically.
- One /64 is allocated to each routed LAN.
- ULA is retained for stable internal addressing.
- IPv6 is routed natively; ULA is not used as Internet connectivity.

## Hardware offload

The LabLAN and HomeLAN bridges are kept on separate RB4011 switch chips.
The RB4011 provides L2 hardware offload/VLAN switching but does not provide
L3 hardware routing/offload. Routed traffic therefore uses the CPU, with
FastTrack enabled for eligible IPv4/IPv6 flows.

## Applying

This is intended for the new RB4011, not the live hEX.

Recommended sequence:

1. Connect locally/console.
2. Verify RouterOS and hardware.
3. Reset to no-defaults if appropriate.
4. Import the numbered modules in order.
5. Verify after WAN, HomeLAN, LabLAN and IPv6 stages.
6. Only then move the Decos to AP mode and cut over.
7. Keep the hEX available for rollback.
8. Leave ether10 PoE-out disabled until the ONT electrical requirements are verified.

PPPoE credentials are placeholders in `10-interfaces.rsc`.

Useful verification commands are in `90-verify.rsc`.
