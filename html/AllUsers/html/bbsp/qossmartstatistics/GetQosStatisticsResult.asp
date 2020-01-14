function QosSmartItem(_Domain, _ClassInterface, _DomainName, _DestIP, _DestMask, _SourceIP, _SourceMask, _Protocol, _DestPort, _DestPortRangeMax, _SourcePort, _SourcePortRangeMax, _DSCPMark, _VLANIDCheck, _TRAFFIC, _PRIMARK, _TRAFFICMARK, _CountEnable, _TotalCountedPackets, _TotalCountedBytesLo, _TotalCountedBytesHi, _ClassPolicer)
{
	this.domain = _Domain;
	this.ClassInterface = _ClassInterface;
    this.QosSmartDomain = (_DomainName == '-1')?'':_DomainName;
    this.DestIP = _DestIP;
    this.DestMask = _DestMask;
    this.SourceIP = _SourceIP;
    this.SourceMask = _SourceMask;
    this.Protocol = (_Protocol == '-1')?'':_Protocol;
    this.DestPort = (_DestPort == '-1')?'':_DestPort;
    this.DestPortRangeMax = (_DestPortRangeMax == '-1')?'':_DestPortRangeMax;
    this.SourcePort = (_SourcePort == '-1')?'':_SourcePort;
    this.SourcePortRangeMax = (_SourcePortRangeMax == '-1')?'':_SourcePortRangeMax;    
    this.DSCPMark = _DSCPMark;
    this.VLANIDCheck = (_VLANIDCheck == '-1')?'':_VLANIDCheck;
    this.TRAFFIC = (_TRAFFIC == '-1')?'':_TRAFFIC;
    this.TRAFFICMARK = (_TRAFFICMARK == '-1')?'':_TRAFFICMARK;
    this.PRIMARK = (_PRIMARK == '-1')?'':_PRIMARK;
	this.CountEnable = _CountEnable;
	this.TotalCountedPackets = _TotalCountedPackets;
	this.TotalCountedBytesLo = _TotalCountedBytesLo;
	this.TotalCountedBytesHi = _TotalCountedBytesHi;
	this.ClassPolicer = _ClassPolicer;
}

var QosSmartListArray = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetParaQosSmart,InternetGatewayDevice.QueueManagement.X_HW_Classification.{i},ClassInterface|DomainName|DestIP|DestMask|SourceIP|SourceMask|Protocol|DestPort|DestPortRangeMax|SourcePort|SourcePortRangeMax|DSCPMark|VLANIDCheck|TRAFFIC|PRIMARK|TRAFFICMARK|CountEnable|TotalCountedPackets|TotalCountedBytesLo|TotalCountedBytesHi|ClassPolicer, QosSmartItem);%>; 

function GetQosSmartData()
{
	return QosSmartListArray;
}

GetQosSmartData();