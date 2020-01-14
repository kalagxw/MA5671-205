function stLayer3Enable(domain, lay3enable)
{
	this.domain = domain;
	this.L3Enable = lay3enable;
}

var LanModeList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.{i}, X_HW_L3Enable,stLayer3Enable);%>; 

function GetLanModeList()
{
    return LanModeList;
}

function IsL3Mode(LanId)
{
    if (parseInt(LanId) >= LanModeList.length){
    	return "null";
    }
    return LanModeList[parseInt(LanId)-1].L3Enable;
}