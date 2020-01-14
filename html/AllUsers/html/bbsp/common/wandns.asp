function IPv6WanDnsInfoClass(domain, DNSServer, Interface)
{
    this.domain = domain;
    this.DNSServer = DNSServer;
    this.Interface = Interface;
    this.WanInstanceId = Interface;
}


var RecordList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DNS.Client.Server.{i},DNSServer|Interface,IPv6WanDnsInfoClass);%>;

function GetIPv6WanDnsServerInfo(WanInstanceId)
{
    for (var i = 0; i < RecordList.length - 1; i++)
    {
        if (RecordList[i].WanInstanceId == WanInstanceId)
        {
            return RecordList[i];
        }
    }
    
    return null;
}

function GetWanDnsServerString(PrimaryDnsServer, SecondaryDnsServer)
{
	var DnsServerString = "";
	if ("" != PrimaryDnsServer && "" != SecondaryDnsServer)
	{
		DnsServerString = PrimaryDnsServer + "," + SecondaryDnsServer;
	}
	else
	{
		DnsServerString = PrimaryDnsServer  + SecondaryDnsServer;
	}
	return DnsServerString;
}
