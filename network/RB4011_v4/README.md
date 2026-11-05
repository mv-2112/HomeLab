# RB4011 configuration, v4

The whole RB4011 configuration as source: one folder per area, joined by
`build.sh` into a single file to import. It's built from the live router's
export of 4 Nov 2026 and the LabLAN redesign, and replaces
`RB4011_migration_modular_v3_documented` (kept for history).

```
src/general/   WAN, system, interface lists (zones), services, firewall start/end, NAT
src/homelan/   HomeLAN bridge, addresses, DHCP (Sonos/Hue leases), DNS, its firewall rules
src/lablan/    LabLAN bridge and VLANs, addresses, DHCP, DNS, its firewall rules
build.sh       joins them in NN order -> dist/rb4011-full.rsc
```

The two-digit prefix sets the order across all three folders, and the order
matters: it's the firewall rule order on the router. Each prefix is used once
(`build.sh` checks).

| NN | Area | File |
|---|---|---|
| 00 | general | secrets (git-ignored; from `00-secrets.rsc.example`) |
| 05 | general | clean-start notes (comments) |
| 10–11 | general | system, WAN and EE IPv6 prefix |
| 20–23 | homelan | bridge, addresses, DHCP, DNS |
| 30–34 | lablan | bridge and ports, VLANs, addresses, DHCP, DNS |
| 40–41 | general | interface lists (zones), services |
| 50 | homelan | work laptop isolation: the first forward rules |
| 51 | general | input chain; start of forward |
| 52 | homelan | what HomeLAN may reach |
| 53 | lablan | what management and the clouds may reach |
| 59 | general | default drop |
| 60 | general | NAT and NAT66 |
| 90 | general | verification commands (not built in) |

## Building

```bash
cp src/general/00-secrets.rsc.example src/general/00-secrets.rsc   # PPPoE password
./build.sh                     # -> dist/rb4011-full.rsc (mode 600: it holds the password)
./build.sh --placeholder       # a copy with CHANGEME, safe to read or share
```

This repo is public: the secrets file and `dist/` are git-ignored. The
sources do contain MAC addresses (Sonos, Hue, the hosts, the work laptop),
which are low-risk but visible.

## Applying

The build is a complete configuration for a router reset with no defaults;
`src/general/05-clean-start-notes.rsc` has the steps (export and backup
first, reset with `run-after-reset`, rollback by restoring the backup).
Do it from a laptop on HomeLAN using Winbox over MAC, or a console: IP access
goes away during the reset.

Then work through `docs/post-cutover-checklist.md`.

**Not tested on RouterOS.** Nothing here has been run on a router: it was
written against RouterOS 7.25.1's export format and checked by reading. Expect
to fix the odd line on the first import (run it with `verbose=yes` and it
stops at the first error).

## Design

### Zones and policy

| From ↓ / to → | MGMT | LAB_MZ640 | LAB_MZ640TEST | HOME | WAN |
|---|---|---|---|---|---|
| HOME | all to .250–.254; 80/443 to .200–.239 | all | all | – | all |
| MGMT | – | all | all | drop | all (NAT) |
| LAB_MZ640 | 80/443 to .200–.219 | – | drop | drop | all (NAT, NAT66) |
| LAB_MZ640TEST | 80/443 to .220–.239 | drop | – | drop | all (NAT, NAT66) |
| WAN | drop | drop | drop | drop | – |

HomeLAN is the clouds' "internet", plus operator access to the hosts and
APIs. Forward chains end in a default drop. The work laptop (by MAC) is
dropped to every private range, IPv4 and IPv6, before any of this.

### Addresses

| Network | VLAN | IPv4 | IPv6 | Notes |
|---|---|---|---|---|
| HomeLAN | – (ether6–9) | 192.168.1.0/24, .254 | EE /64 + `fd00:50::/64` | unchanged |
| Management | 88, untagged on ether1–5 | 192.168.88.0/24 | none | IPv4 only: dual-stack trips Juju |
| mz640 external | 10 | 192.168.10.0/24 | `fd18:aaa8:47c3:10::/64` | floating IPs .10–.249, no DHCP |
| mz640test external | 20 | 192.168.20.0/24 | `fd18:aaa8:47c3:20::/64` | floating IPs .10–.249, no DHCP |
| mz640 tenants | – | (NAT inside OpenStack) | `fd18:aaa8:47c3:1000::/52` | routed per /64 |
| mz640test tenants | – | (NAT inside OpenStack) | `fd18:aaa8:47c3:2000::/52` | routed per /64 |
| 10GbE host link | – | 192.168.200.0/24 | – | host to host; never on the router |

Management: .10–.159 DHCP, .160–.199 static, .200–.219 mz640 APIs,
.220–.239 mz640test APIs, .240–.249 spare, .250–.254 hardware
(.252 mz640test, .253 mz640).

The lab's IPv6 is a random ULA /48 with NAT66 to EE's prefix on the way out:
stable addresses inside, outbound IPv6 internet, and nothing breaks if EE
changes the prefix. A blackhole route covers the /48; tenant /64 routes come
from `cib-undercloud/tools/ipv6-routes.py` in cloud-in-a-box.

### Ports

| Port | Connected to | VLANs |
|---|---|---|
| ether1 | mz640 eno1 | access: 88 untagged |
| ether2 | mz640 ens4f0 (cable it here) | trunk: 10, 11–19 tagged only |
| ether3 | spare | access: 88 untagged |
| ether4 | mz640test eno1 | access: 88 untagged |
| ether5 | mz640test ens4f0 | trunk: 20, 21–29 tagged only |
| ether6–9 | Decos, spare | HomeLAN |

Management (VLAN 88) is only ever on access ports; trunks drop untagged
frames. Each host's `ens4f0` (X540) carries its cloud's external VLAN for OVS,
and its SR-IOV VFs go on that cloud's provider VLANs, each VF tagged by the
NIC. Provider VLANs are layer 2 only unless given a router interface.
`eno1` (I218-LM) has no SR-IOV.
| ether10 | EE ONT | PPPoE |

## Changes from the live router

See `CHANGELOG.md`.
