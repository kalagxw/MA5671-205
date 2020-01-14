
function stLanPublicIPClass(domain, Enable, IPAddress, SubnetMask)
{
    this.domain = domain;
	this.Enable =  Enable;
    this.IPAddress = IPAddress;
    this.SubnetMask = SubnetMask;	
}

var LanPublicIPItms = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.X_HW_PublicIPInterface.{i},Enable|IPAddress|SubnetMask,stLanPublicIPClass);%>;

//var LanPublicIPItms = new Array(new stLanPublicIPClass("InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.X_HW_PublicIPInterface.1","0","192.168.100.99","255.255.255.0"),null);

function GetLanPublicIP()
{
    return LanPublicIPItms;
}