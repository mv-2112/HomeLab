# Changelog

## 5 Nov 2026: Backstage DNS name

- `backstage.mz640test.lab.home.arpa` -> 192.168.20.250, mz640test's fixed
  platform ingress address (cib-undercloud `PLATFORM_INGRESS_IP`), in
  `src/lablan/34-dns.rsc`. Live router: `changes/2026-11-05-backstage-dns.rsc`.

## v4 (4 Nov 2026)

Compared with the live router's export of 4 Nov 2026 (RouterOS 7.25.1).

### Kept as it is

- WAN: PPPoE on ether10, PoE-out off, DHCPv6-PD /56 into `ee-pd`.
- HomeLAN: bridge settings (STP priority 0x4000, IGMP snooping, multicast
  querier), 192.168.1.254 as gateway/DNS/NTP, DHCP pool, `fd00:50::/64` ULA,
  EE /64, DNS servers, NTP.
- Sonos and Hue fixed leases and DNS names (they were only on the router,
  not in the repo; now in `homelan/22-dhcp.rsc` and `23-dns.rsc`).
- The work laptop's fixed lease and isolation rules, still the first forward
  rules.
- Host reservations .252 (mz640test) and .253 (mz640).

### Changed

- **Firewall is default-drop between zones.** "LAN to LAN: allow all" is
  replaced by interface-list zones and one rule per allowed flow (README).
  The lab can no longer start connections into HomeLAN; the two clouds can't
  reach each other.
- **Work laptop isolation matches by MAC only and covers IPv6.** The live
  rule also required 192.168.1.17, and there was no IPv6 rule although the
  laptop has IPv6 addresses.
- **FastTrack works again.** The rule was last in forward, after the
  accepts, so it never matched (IPv4 and IPv6). It's first now.
- **Management is IPv4 only.** VLAN 88 loses `fd00:88::/64` and its EE /64;
  the default `/ipv6 nd` entry (advertising on every interface) is disabled.
- **Management DHCP pool** is .10–.159 (was .10–.254, overlapping API ranges
  and hardware). Domain `lab.home.arpa` (was `mgmt.lan`/`lab.lan`); the
  `router.lab.lan` name is kept.
- **Host reservations match by MAC**, not client-id (a rebuilt host gets a
  new DUID).
- **VLAN 10 and 20 belong to the clouds:** renamed `vlan10_mz640` and
  `vlan20_mz640test`, no DHCP, new ULA prefixes, EE /64s removed, each tagged
  only on its own host's port.
- **Access and trunk ports (5 Nov 2026):** VLAN 88 is untagged only on the
  eno1 ports (ether1, ether4) and the spare ether3. The ens4f0 ports (ether2
  for mz640, ether5 for mz640test) are tagged-only trunks with their cloud's
  external and provider VLANs (11–19, 21–29) for OpenStack provider networks
  and SR-IOV VFs. A running v4 router gets this from
  `changes/2026-11-05-trunk-ports.rsc`.
- **Lab IPv6** moves from `fd00:*` to the random ULA `fd18:aaa8:47c3::/48`,
  with NAT66 for internet access, a blackhole route for the /48, and a filter
  stopping ULA crossing the WAN.
- **Interface lists** WAN/LAN/LAB become WAN, HOME, MGMT, LAB_MZ640,
  LAB_MZ640TEST, LAB_CLOUDS, ROUTER_ADMIN. Neighbour discovery and MAC-Winbox
  use ROUTER_ADMIN (HomeLAN and management).
- **Router input** also accepts DNS and NTP from the clouds' networks.
- **NAT66 source address:** a /64 from `ee-pd` on `pppoe-ee`.
- **PPPoE password** comes from a git-ignored secrets file.

### Removed

- VLANs 30, 40, 90 and 100 with their addresses, pools, DHCP servers, RA
  and EE /64s (planned, never used). VLAN 90 was misconfigured, untagged on
  the same ports as 88; VLAN 100's address had no prefix length and the VLAN
  wasn't in the bridge table.
- `cib-undercloud/bootstrap/router/rb4011-openstack.rsc` in cloud-in-a-box:
  everything it did is in here now.
