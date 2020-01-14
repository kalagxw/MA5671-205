function WanAccessItemClass(domain, Enable, Protocol, WanName,SrcIPPrefix)
{
    this.domain = domain;
    this.Enable = Enable;
    this.Protocol = Protocol;
    this.WanName =  WanName;
    this.SrcIPPrefix =  SrcIPPrefix;     
}

var WanAccessListTemp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.AclServices.WanAccess.{i},Enable|Protocol|WanName|SrcIPPrefix,WanAccessItemClass);%>;  

var WanAccessList = new Array();

var Count = 0;

for (var i = 0; i < WanAccessListTemp.length-1; i++)
{
    WanAccessList[Count++] = WanAccessListTemp[i];
}
    
function GetWanAccessList()
{
    return WanAccessList;
}
