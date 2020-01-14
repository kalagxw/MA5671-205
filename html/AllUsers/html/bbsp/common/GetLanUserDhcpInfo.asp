function DHCPInfo(domain,name,ip,mac,remaintime,devtype, interfacetype)
{
	this.domain		= domain;
	this.name 		= name;
	this.ip 		= ip;
	this.mac		= mac;
	this.remaintime		= remaintime;
	this.devtype        = devtype;
	this.interfacetype = interfacetype;
}

var UserDhcpinfo = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecialGetUserDevInfo,InternetGatewayDevice.LANDevice.1.Hosts.Host.{i},HostName|IPAddress|MACAddress|LeaseTimeRemaining|VendorClassID|InterfaceType, DHCPInfo);%>;

function GetUserDhcpInfoList()
{
	return UserDhcpinfo;
}

GetUserDhcpInfoList();