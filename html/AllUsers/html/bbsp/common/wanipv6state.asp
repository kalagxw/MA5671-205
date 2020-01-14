function IPv6AddressInfo(domain, IPAddressStatus, Origin,IPAddress,PreferredTime,
                        ValidTime,ValidTimeRemaining)
{
    this.WanInstanceId = domain.split(".")[4];
    this.IPAddressStatus = IPAddressStatus;
    this.Origin = Origin;
    this.IPAddress = IPAddress;
	this.PreferredTime = PreferredTime;
	this.ValidTime = ValidTime;
	this.ValidTimeRemaining = ValidTimeRemaining;
}
function IPv6PrefixInfo(domain, Origin, Prefix,PreferredTime,ValidTime,ValidTimeRemaining)
{
    this.WanInstanceId = domain.split(".")[4];
    this.Prefix = Prefix;
    this.Origin = Origin;
	this.PreferredTime = PreferredTime;
	this.ValidTime = ValidTime;
	this.ValidTimeRemaining = ValidTimeRemaining;
}


function IPv6WanInfo(domain, Type, ConnectionStatus, L2EncapType, MACAddress, Vlan, Pri,
                     DNSServers, AFTRName, AFTRPeerAddr,DefaultRouterAddress,V6UpTime)
{
    this.WanInstanceId = domain.split(".")[4];
    this.Type = Type;
    this.ConnectionStatus = ConnectionStatus;
    this.L2EncapType = L2EncapType;
    this.MACAddress = MACAddress;
    this.Vlan = Vlan;
    this.Pri = Pri;
	this.DNSServers = DNSServers;
	this.AFTRName = AFTRName;
	this.AFTRPeerAddr = (AFTRPeerAddr=="::")?"":AFTRPeerAddr;
	this.DefaultRouterAddress = DefaultRouterAddress;
    this.V6UpTime = V6UpTime;
}


var IPv6AddressList =  <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetIPv6Address, InternetGatewayDevice.WANDevice.1.X_HW_ShowInterface.{i}.IPv6Address.{i},IPAddressStatus|Origin|IPAddress|PreferredTime|ValidTime|ValidTimeRemaining,IPv6AddressInfo);%>;
var IPv6PrefixList  =  <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetIPv6WanPrefix, InternetGatewayDevice.WANDevice.1.X_HW_ShowInterface.{i}.IPv6Prefix.{i},Origin|Prefix|PreferredTime|ValidTime|ValidTimeRemaining,IPv6PrefixInfo);%>;
var IPv6WanInfoList =  <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetIPv6WanInfo, InternetGatewayDevice.WANDevice.1.X_HW_ShowInterface.{i},Type|ConnectionStatus|L2EncapType|MACAddress|Vlan|Pri|IPv6DNS|AFTRName|PeerAddress|DefaultRouterAddress|V6UpTime,IPv6WanInfo);%>;


function GetIPv6AddressList(WanInstanceId)
{
    var List = new Array();
    var Count = 0;
    
    for (var i = 0; i < IPv6AddressList.length; i++)
    {
        if(IPv6AddressList[i] == null)
        continue;
        
        if (IPv6AddressList[i].WanInstanceId != WanInstanceId)
        continue;
        
        List[Count++] = IPv6AddressList[i];
    } 
    
    return List;
}

function GetIPv6PrefixList(WanInstanceId)
{
    var List = new Array();
    var Count = 0;
    
    for (var i = 0; i < IPv6PrefixList.length; i++)
    {
        if(IPv6PrefixList[i] == null)
        continue;
        
        if (IPv6PrefixList[i].WanInstanceId != WanInstanceId)
        continue;
        
        List[Count++] = IPv6PrefixList[i];
    } 
    
    return List;
}

function GetIPv6WanInfo(WanInstanceId)
{
    for (var i = 0; i < IPv6WanInfoList.length; i++)
    {
        if (IPv6WanInfoList[i] != null)
        {
            if (IPv6WanInfoList[i].WanInstanceId == WanInstanceId)
            {
                return IPv6WanInfoList[i];
            }
        }
    }    
}
