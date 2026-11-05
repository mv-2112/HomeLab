# HomeLAN: local DNS names (served by the router at 192.168.1.254).

/ip dns static
add name=router.lan address=192.168.1.254 type=A comment="HomeLAN router name"
add name=hue.lan address=192.168.1.104 type=A comment="Philips Hue Bridge v2"
add name=sonos-kitchen-l address=192.168.1.201 type=A comment="Sonos Symfonisk Kitchen (Left)"
add name=sonos-kitchen-r address=192.168.1.202 type=A comment="Sonos Symfonisk Kitchen (Right)"
add name=sonos-bedroom-l address=192.168.1.203 type=A comment="Sonos Symfonisk Lamp Main bedroom (Left)"
add name=sonos-bedroom-r address=192.168.1.204 type=A comment="Sonos Symfonisk Lamp Main bedroom (Right)"
add name=sonos-office-l address=192.168.1.211 type=A comment="Sonos One SL Office (Left)"
add name=sonos-office-r address=192.168.1.212 type=A comment="Sonos One SL Office (Right)"
add name=sonos-roam-2 address=192.168.1.240 type=A comment="Sonos Roam2"
add name=sonos-ursula address=192.168.1.241 type=A comment="Sonos Symfonisk Lamp (gen2) Ursula Bedroom"
