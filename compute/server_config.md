Setup SRIOV on ethernet

https://oneuptime.com/blog/post/2026-03-02-configure-sr-iov-vm-network-performance-ubuntu/view





/tool/netwatch
add host=8.8.8.8 interval=10s timeout=3s down-script="/log warning \"Target 8.8.8.8 is DOWN!\"; /interface disable ether2" up-script="/log info \"Target 8.8.8.8 is UP.\"; /interface enable ether2"
