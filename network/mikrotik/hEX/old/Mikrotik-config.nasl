# =========================================================================
# STEP 1: DEFINE PERSISTENT SCRIPT WITH DIRECT IPv6 ULA ADVERTISEMENTS
# =========================================================================
/system script remove [find where name="deploy_vlan_matrix"]
/system script add name="deploy_vlan_matrix" policy=read,write,policy,test source={
    :local domesticGw      "192.168.1.254"
    :local hexWanIp        "192.168.1.253/30"
    :local localDomain     "lan"

    # Hex values are explicitly defined clean IPv6 Gateways - no dynamic pools required
    :local networks {
        {id="none"; gw4="192.168.88.1"; net4="192.168.88.0/24"; dhcp4="Y"; sub6="fd00:88::1/64"; ra6="Y"; desc="Management LAN"};
        {id="10";   gw4="192.168.10.1"; net4="192.168.10.0/24"; dhcp4="Y"; sub6="fd00:10::1/64"; ra6="Y"; desc="Openstack tenant #1"};
        {id="20";   gw4="192.168.20.1"; net4="192.168.20.0/24"; dhcp4="Y"; sub6="fd00:20::1/64"; ra6="Y"; desc="Openstack tenant #2"};
        {id="30";   gw4="192.168.30.1"; net4="192.168.30.0/24"; dhcp4="Y"; sub6="fd00:30::1/64"; ra6="N"; desc="Openstack tenant #3"};
        {id="40";   gw4="none";         net4="none";            dhcp4="N"; sub6="fd00:40::1/64"; ra6="Y"; desc="Openstack tenant #4"};
    }

    # =========================================================================
    # COMPLETE TEARDOWN AND WORKSPACE CLEAR
    # =========================================================================
    /ip firewall filter remove [/ip firewall filter find where comment~"Isolate:"]
    /ipv6 firewall filter remove [/ipv6 firewall filter find where comment~"Isolate:"]
    /ip firewall mangle remove [/ip firewall mangle find where comment~"Isolate:"]
    /ip firewall nat remove [/ip firewall nat find where comment~"Isolate:"]
    /interface list member remove [/interface list member find where list="Isolated-LANs"]
    /interface list remove [/interface list find where name="Isolated-LANs"]
    
    /ip dhcp-server network remove [/ip dhcp-server network find]
    /ip dhcp-server remove [/ip dhcp-server find where name~"dhcp-"]
    /ip pool remove [/ip pool find where name~"pool-"]
    
    /ip address remove [/ip address find where comment~"Gateway"]
    /ip address remove [/ip address find comment~"WAN to"]
    /ip route remove [/ip route find comment="Default Route to Domestic Gateway"]

    /ipv6 address remove [/ipv6 address find where comment~"Gateway"]
    /ipv6 route remove [/ipv6 route find comment="Default Route IPv6"]
    /ipv6 nd remove [/ipv6 nd find where comment~"ND-"]
    /ipv6 dhcp-client remove [/ipv6 dhcp-client find interface=ether1]

    /interface bridge vlan remove [/interface bridge vlan find where bridge="bridge-trunk"]
    /interface vlan remove [/interface vlan find where name~"vlan-"]
    /interface bridge port remove [/interface bridge port find where bridge="bridge-trunk"]
    /interface bridge remove [/interface bridge find name="bridge-trunk"]

    # =========================================================================
    # REBUILD MASTER BRIDGE WITH VLAN FILTERING (HYBRID PORTS enabled)
    # =========================================================================
    /interface bridge add name=bridge-trunk vlan-filtering=yes fast-forward=yes comment="Master Trunk Bridge"
    
    /interface bridge port
    add bridge=bridge-trunk interface=ether2 pvid=1 frame-types=admit-all
    add bridge=bridge-trunk interface=ether3 pvid=1 frame-types=admit-all
    add bridge=bridge-trunk interface=ether4 pvid=1 frame-types=admit-all
    add bridge=bridge-trunk interface=ether5 pvid=1 frame-types=admit-all

    # Core IPv4 Layout
    /ip address add address=$hexWanIp interface=ether1 comment="WAN to Domestic Network"
    /ip route add gateway=$domesticGw comment="Default Route to Domestic Gateway"
    /ip dns set allow-remote-requests=yes servers=1.1.1.1,8.8.8.8
    /interface ethernet set [find name=ether1] arp=enabled

    # Core IPv6 Layout
    /ipv6 dhcp-client add interface=ether1 request=address add-default-route=yes comment="WAN IPv6 Client Link"
    /interface list add name=Isolated-LANs comment="Contains all subnets behind the hEX"

    # =========================================================================
    # CORE LOOP NETWORK ENGINE
    # =========================================================================
    :foreach net in=$networks do={
        :local vlanId     ($net->"id")
        :local gatewayIp  ($net->"gw4")
        :local subnetCidr ($net->"net4")
        :local runDhcp    ($net->"dhcp4")
        :local subId6     ($net->"sub6")
        :local runRa6     ($net->"ra6")
        :local description ($net->"desc")
        
        :local targetInterface ""
        :local suffixTag ""
        
        :if ($vlanId = "none") do={
            :set targetInterface "bridge-trunk"
            :set suffixTag "native"
            
            # Map untagged (PVID 1) traffic to the hardware table
            /interface bridge vlan add bridge=bridge-trunk vlan-ids=1 untagged=bridge-trunk,ether2,ether3,ether4,ether5
        } else={
            :set targetInterface ("vlan-" . $vlanId)
            :set suffixTag ("vlan" . $vlanId)
            /interface vlan add interface=bridge-trunk name=$targetInterface vlan-id=$vlanId comment=$description
            
            # Map tagged trunk traffic to the hardware table
            /interface bridge vlan add bridge=bridge-trunk vlan-ids=$vlanId tagged=bridge-trunk,ether2,ether3,ether4,ether5
        }
        
        :local poolName      ("pool-" . $suffixTag)
        :local serverName    ("dhcp-" . $suffixTag)

        # Build IPv4 Subsystem Routing
        :if ($gatewayIp != "none") do={
            :local slashIdx [:find $subnetCidr "/"]
            :local maskv4 [:pick $subnetCidr $slashIdx [:len $subnetCidr]]
            :local combinedIp ($gatewayIp . $maskv4)
            /ip address add address=$combinedIp interface=$targetInterface comment=($description . " Gateway")
            
            :if ($runDhcp = "Y") do={
                :local dot1 [:find $gatewayIp "."]
                :local dot2 [:find $gatewayIp "." ($dot1 + 1)]
                :local dot3 [:find $gatewayIp "." ($dot2 + 1)]
                :local baseIp [:pick $gatewayIp 0 ($dot3 + 1)]
                :local dhcpPoolRange ($baseIp . "2-" . $baseIp . "254")
                
                /ip pool add name=$poolName ranges=$dhcpPoolRange
                /ip dhcp-server add add-dns-entries=yes address-pool=$poolName interface=$targetInterface name=$serverName disabled=no
                /ip dhcp-server network add address=$subnetCidr dns-server=$gatewayIp gateway=$gatewayIp domain=$localDomain
            }
        }

        # Build Clean Static IPv6 Subsystem Routing
        :if ($subId6 != "none") do={
            :local advertiseFlag "no"
            :if ($runRa6 = "Y") do={ :set advertiseFlag "yes" }
            
            /ipv6 address add address=$subId6 interface=$targetInterface advertise=$advertiseFlag comment=($description . " IPv6 Gateway")
            
            :if ($runRa6 = "Y") do={
                :local ndComment ("ND-" . $suffixTag)
                /ipv6 nd add interface=$targetInterface ra-interval=10s-30s ra-lifetime=30m hop-limit=64 managed-address-configuration=no other-configuration=yes comment=$ndComment
            }
        }

        /interface list member add interface=$targetInterface list=Isolated-LANs
    }

    # =========================================================================
    # ENFORCE FILTER FIREWALL CONFIGURATIONS (With CPU Protection FastTrack)
    # =========================================================================
    /ip firewall filter
    add chain=input src-address=192.168.1.0/24 action=accept comment="Isolate: Allow Home Access" place-before=*0
    
    # FastTrack Engine: Routes established WAN and cross-network traffic away from the CPU 
    add chain=forward action=fasttrack-connection connection-state=established,related comment="Isolate: FastTrack established traffic" place-before=*0
    add chain=forward connection-state=established,related action=accept comment="Isolate: Allow established/related packets" place-before=*0
    
    # Inter-VLAN Isolation Rule
    add chain=forward in-interface-list=Isolated-LANs out-interface-list=Isolated-LANs action=drop comment="Isolate: Block cross-VLAN traffic between subnets"

    /ipv6 firewall filter
    add chain=forward connection-state=established,related action=accept comment="Isolate: Allow established/related IPv6 packets" place-before=*0
    add chain=forward in-interface-list=Isolated-LANs out-interface-list=Isolated-LANs action=drop comment="Isolate: Block cross-VLAN traffic between IPv6 subnets"
}
