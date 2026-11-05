# General: clean start. Comments only; nothing here runs.
#
# The full build (dist/rb4011-full.rsc) is written for an RB4011 reset to
# no defaults. Before resetting the live router:
#
#   /export file=rb4011-before-v4
#   /system backup save name=rb4011-before-v4
#   ...and copy both files off the router.
#
# Upload dist/rb4011-full.rsc to the router (Files), then reset. You lose
# access over IP until the import finishes, so do this from a laptop on
# ether6-9 using Winbox over MAC, or a serial console:
#
#   /system reset-configuration no-defaults=yes skip-backup=yes \
#       run-after-reset=rb4011-full.rsc
#
# Or reset without run-after-reset and import by hand after the reboot:
#
#   /import file-name=rb4011-full.rsc verbose=yes
#
# Rollback: /system backup load name=rb4011-before-v4
