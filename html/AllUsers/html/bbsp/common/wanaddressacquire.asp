function IPAddressAcquireIPItem(_domain, _Alias, _Origin, _IPAddress, _ChildPrefixBits, _UnnumberredWanReserveAddress, _AddrMaskLen, _DefaultGateway)
{
    this.domain = _domain;
    this.Alias = _Alias;
	
	switch(_Origin.toString().toUpperCase())
	{
		case "AUTOCONFIGURED": 
			_Origin = "AutoConfigured"; break;
		case "DHCPV6": 
			_Origin = "DHCPv6"; break;
		case "STATIC": 
			_Origin = "Static"; break;
		case "NONE": 
			_Origin = "None"; break;
		default: 
			break;
	}
    this.Origin = _Origin;
    this.IPAddress = _IPAddress;
    this.ChildPrefixBits = _ChildPrefixBits;
    this.WanInstanceId = _domain.split(".")[4];
    this.InstanceId = _domain.split(".")[9];
	this.IPv6ReserveAddress = _UnnumberredWanReserveAddress;
    this.AddrMaskLen = _AddrMaskLen;
    this.DefaultGateway = _DefaultGateway;
}

function IPAddressAcquirePPPItem(_domain, _Alias, _Origin, _IPAddress, _ChildPrefixBits,_AddrMaskLen, _DefaultGateway)
{
    this.domain = _domain;
    this.Alias = _Alias;
	
	switch(_Origin.toString().toUpperCase())
	{
		case "AUTOCONFIGURED": 
			_Origin = "AutoConfigured"; break;
		case "DHCPV6": 
			_Origin = "DHCPv6"; break;
		case "STATIC": 
			_Origin = "Static"; break;
		case "NONE": 
			_Origin = "None"; break;
		default: 
			break;
	}
    this.Origin = _Origin;
    this.IPAddress = _IPAddress;
    this.ChildPrefixBits = _ChildPrefixBits;
    this.WanInstanceId = _domain.split(".")[4];
    this.InstanceId = _domain.split(".")[9];
    this.AddrMaskLen = _AddrMaskLen;
    this.DefaultGateway = _DefaultGateway;
}

var IPAddressAcquireIP  = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetIPv6IPAddressIP, InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i}.X_HW_IPv6.IPv6Address.{i},Alias|Origin|IPAddress|ChildPrefixBits|UnnumberredWanReserveAddress|AddrMaskLen|DefaultGateway,IPAddressAcquireIPItem);%>;
var IPAddressAcquirePPP = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetIPv6IPAddressPPPoE, InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i}.X_HW_IPv6.IPv6Address.{i},Alias|Origin|IPAddress|ChildPrefixBits|AddrMaskLen|DefaultGateway,IPAddressAcquirePPPItem);%>;
var IPAddressAcquireList = new Array();
var Count = 0;
for (var i = 0; i < IPAddressAcquireIP.length; i++)
{
    if (IPAddressAcquireIP[i] != null)
    {
        IPAddressAcquireList[Count++] = IPAddressAcquireIP[i];
    }    
}
for (var i = 0; i < IPAddressAcquirePPP.length; i++)
{
    if (IPAddressAcquirePPP[i] != null)
    {
        IPAddressAcquireList[Count++] = IPAddressAcquirePPP[i];
    }    
}

function GetIPv6AddressAcquireInfo(domain)
{
    for (var i = 0; i < IPAddressAcquireList.length; i++)
    {
        if (IPAddressAcquireList[i].domain.indexOf(domain) >= 0)
        {
            return IPAddressAcquireList[i];
        }
    }    
    return null;
}

function PrefixAcquireItem(_domain, _Alias, _Origin, _Prefix)
{
    this.domain = _domain;
    this.Alias = _Alias;
    
	switch(_Origin.toString().toUpperCase())
	{
		case "AUTOCONFIGURED": 
			_Origin = "AutoConfigured"; break;
		case "ROUTERADVERTISEMENT": 
			_Origin = "RouterAdvertisement"; break;
		case "PREFIXDELEGATION": 
			_Origin = "PrefixDelegation"; break;
		case "DHCPV6-PD": 
			_Origin = "DHCPv6-PD"; break;
		case "STATIC": 
			_Origin = "Static"; break;
		case "NONE": 
			_Origin = "None"; break;
		default: 
			break;
	}
	
    if ( ("AutoConfigured" == _Origin) || ("RouterAdvertisement" == _Origin))
    {
        this.Origin = "PrefixDelegation";
    }
    else
    {
        this.Origin = _Origin;
    }
    
    this.Prefix = _Prefix;
    this.WanInstanceId = _domain.split(".")[4];
    this.InstanceId = _domain.split(".")[9]
}

var PrefixAcquireIP  = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i}.X_HW_IPv6.IPv6Prefix.{i},Alias|Origin|Prefix,PrefixAcquireItem);%>;
var PrefixAcquirePPP = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i}.X_HW_IPv6.IPv6Prefix.{i},Alias|Origin|Prefix,PrefixAcquireItem);%>;
var PrefixAcquireList = new Array();
var Count = 0;
for (var i = 0; i < PrefixAcquireIP.length; i++)
{
    if (PrefixAcquireIP[i] != null)
    {
        PrefixAcquireList[Count++] = PrefixAcquireIP[i];
    }    
}
for (var i = 0; i < PrefixAcquirePPP.length; i++)
{
    if (PrefixAcquirePPP[i] != null)
    {
        PrefixAcquireList[Count++] = PrefixAcquirePPP[i];
    }    
}

function GetIPv6PrefixAcquireInfo(domain)
{
    for (var i = 0; i < PrefixAcquireList.length; i++)
    {
        if (PrefixAcquireList[i].domain.indexOf(domain) >= 0)
        {
            return PrefixAcquireList[i];
        }
    }    
    return null;
}