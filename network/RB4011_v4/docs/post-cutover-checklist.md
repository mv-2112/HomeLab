# Post-cutover checklist

Commands are in `src/general/90-verify.rsc`.

## WAN
- [ ] `pppoe-ee` connected; IPv4 default route present
- [ ] DHCPv6-PD bound; `ee-pd` pool exists
- [ ] `pppoe-ee` has an address from `ee-pd` (NAT66 needs it)

## HomeLAN (should look exactly as before)
- [ ] Decos up on ether6–8; clients on 192.168.1.0/24, gateway/DNS/NTP .254
- [ ] Sonos speakers get their fixed addresses and can be found in the Sonos app
- [ ] Hue bridge at .104
- [ ] IPv4 and IPv6 internet from a HomeLAN device
- [ ] Work laptop: internet works, pinging a host (192.168.88.252) or any lab ULA fails

## LabLAN
- [ ] `/interface bridge vlan print`: 88 untagged on ether1, 3, 4 only; 10 and 11–19 on ether2; 20 and 21–29 on ether5
- [ ] ether2 and ether5 show `admit-only-vlan-tagged`, pvid 1 (`/interface bridge port print detail`)
- [ ] no management (192.168.88.x or IPv6) addresses on either host's ens4f0
- [ ] hosts get .252/.253 (static in netplan, or the reservation)
- [ ] hosts have no IPv6 on eno1 apart from link-local (`ip -6 addr show eno1`)
- [ ] `hostname -f` on each host resolves to its .25x address
- [ ] `ping 192.168.200.253` from mz640test (10GbE link, router not involved)

## Policy
- [ ] HomeLAN → SSH to both hosts
- [ ] HomeLAN → Horizon on a cloud's API address (once a cloud is up)
- [ ] HomeLAN → a floating IP; → a tenant IPv6 address (once routes are imported)
- [ ] a VM → the internet over IPv4 and IPv6 (`curl -6 https://ipv6.google.com`)
- [ ] a VM → its own cloud's API on 443 works; → the host's SSH fails
- [ ] a VM on one cloud → the other cloud's floating IP fails
- [ ] FastTrack counters rising (`/ip firewall filter print stats`)
- [ ] nothing unexpected counting on the default-drop rules
