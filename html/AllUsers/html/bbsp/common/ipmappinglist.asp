function IpMappingItemClass(domain, Enable, Priority, Interface,StartIP,EndIP,SnatSrcIP)
{
    this.domain = domain;
    this.Enable = Enable;
    this.Priority = Priority;
    this.Interface =  Interface;
    this.StartIP =  StartIP; 
    this.EndIP =  EndIP;
    this.SnatSrcIP =  SnatSrcIP;    
}

var IpMappingList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_NAT.IPMapping.{i},Enable|Priority|Interface|StartIP|EndIP|SnatSrcIP,IpMappingItemClass);%>;  
    
function GetIpMappingList()
{
    return IpMappingList;
}