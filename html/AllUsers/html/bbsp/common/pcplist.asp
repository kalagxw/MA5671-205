function stPcpMapping(domain, Enable, Interface, PlainMode, ServerAddress, UsedServerAddress)
{
    this.domain = domain;
    this.Enable = Enable;
    this.Interface = Interface;
    this.PlainMode =  PlainMode;
    this.ServerAddress = ServerAddress;
    this.UsedServerAddress = UsedServerAddress;	
}

function stPcpMappingList(domain, InternalAddress, InternalPort, Protocol, RequiredExternalAddress, RequiredExternalPort, AllowProposal, Origin, ExternalAddress, ExternalPort, Status)
{
    this.domain = domain;
    this.InternalAddress = InternalAddress;
    this.InternalPort = InternalPort;
    this.Protocol =  Protocol;
    this.RequiredExternalAddress = RequiredExternalAddress;
    this.RequiredExternalPort = RequiredExternalPort;
    this.AllowProposal =  AllowProposal; 
    this.Origin = Origin;
    this.ExternalAddress = ExternalAddress;
    this.ExternalPort =  ExternalPort;
    this.Status =  Status; 	
}

var PcpMapping = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaPcp,InternetGatewayDevice.X_HW_PCP.{i},Enable|Interface|ServerAddress|UsedServerAddress,stPcpMapping);%>;
var PcpMappingList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_PCP.{i}.PCPMapping.{i},InternalAddress|InternalPort|Protocol|RequiredExternalAddress|RequiredExternalPort|AllowProposal|Origin|ExternalAddress|ExternalPort|Status,stPcpMappingList);%>;

var PcpMappingArray = new Array();
var PcpMappingListArray = new Array();

var Countmapping = 0;
var Countmappinglist = 0;

for (var i = 0; i < PcpMappingList.length-1; i++)
{
     PcpMappingListArray[Countmapping++] = PcpMappingList[i];
}
    
function GetPcpmapping()
{
    return PcpMapping;
}
function GetPcpMappingList()
{
    return PcpMappingListArray;
}

