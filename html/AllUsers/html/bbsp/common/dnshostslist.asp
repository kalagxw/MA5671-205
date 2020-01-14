function DnsHostsItemClass(domain, IPAddress, DomainName)
{
    this.domain     = domain;
    this.IPAddress  = IPAddress;
    this.DomainName = DomainName;
}

var DnsHostsListTemp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DNS.HOSTS.{i},IPAddress|DomainName,DnsHostsItemClass);%>;  

var DnsHostsList = new Array();

var Count = 0;

for (var i = 0; i < DnsHostsListTemp.length-1; i++)
{
     DnsHostsList[Count++] = DnsHostsListTemp[i];
}
    
function GetDnsHostsList()
{
    return DnsHostsList;
}
