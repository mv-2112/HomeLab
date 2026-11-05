# 2026-11-05: DNS name for Backstage on mz640test's admin cluster.
# Already in src/lablan/34-dns.rsc; this applies just that change to the
# running router:  /import file-name=2026-11-05-backstage-dns.rsc
# Safe to re-run: removes any earlier copy first.

/ip dns static
remove [find name=backstage.mz640test.lab.home.arpa]
add name=backstage.mz640test.lab.home.arpa address=192.168.20.250 type=A comment="mz640test platform ingress (Traefik): Backstage"
