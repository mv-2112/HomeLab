# 2026-11-08: HomeLAN spanning tree STP -> RSTP, Deco/switch ports as edge.
# Already in src/homelan/20-bridge.rsc; this applies just that change to the
# running router:  /import file-name=2026-11-08-homelan-rstp.rsc
#
# Why: classic STP held each port ~30 s after link-up, so rebooting Decos
# found the wire dead and chose wireless backhaul (the T topology was lost).
# Safe to re-run. HomeLAN re-converges for a second or two.
#
# Undo:
#   /interface bridge port set [find bridge=HomeLAN] edge=auto
#   /interface bridge set [find name=HomeLAN] protocol-mode=stp

/interface bridge set [find name=HomeLAN] protocol-mode=rstp
/interface bridge port set [find bridge=HomeLAN] edge=yes
