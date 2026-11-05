# LabLAN: names. Sunbeam/Juju identify a node by its FQDN, so each host's
# `hostname -f` must be exactly its name here and resolve to its eno1 address.

/ip dns static
add name=router.lab.home.arpa address=192.168.88.1 type=A comment="Lab router"
add name=router.lab.lan address=192.168.88.1 type=A comment="Lab router (old name, kept for existing bookmarks)"
add name=mz640.lab.home.arpa address=192.168.88.253 type=A comment="mz640 management (eno1)"
add name=mz640test.lab.home.arpa address=192.168.88.252 type=A comment="mz640test management (eno1)"

# Platform services on each cloud's admin cluster: <service>.<cloud>.lab.home.arpa
# -> that cloud's fixed ingress address (PLATFORM_INGRESS_IP in cib-undercloud's
# bootstrap/site.env: outside the floating IP pool, so it never moves).
# `terraform output dns_records` in cib-undercloud/platform lists the names.
add name=backstage.mz640test.lab.home.arpa address=192.168.20.250 type=A comment="mz640test platform ingress (Traefik): Backstage"
# add name=backstage.mz640.lab.home.arpa address=192.168.10.250 type=A comment="mz640 platform ingress (Traefik): Backstage"
