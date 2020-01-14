function RadioWanStatsClass(domain, BytesSentL, BytesSentH, BytesReceivedL, BytesReceivedH, ServiceStatus, SignalStrength)
{
	this.domain = domain;
	this.BytesSentL = BytesSentL;
	this.BytesSentH = BytesSentH;
	this.BytesReceivedL = BytesReceivedL;
	this.BytesReceivedH = BytesReceivedH;
	this.ServiceStatus = ServiceStatus;
	this.SignalStrength = SignalStrength;
}

var RadioWanStatsList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Radio_WAN_Stats, BytesSentL|BytesSentH|BytesReceivedL|BytesReceivedH|ServiceStatus|SignalStrength,RadioWanStatsClass);%>;

function GetRadioWanStatsList()
{
	return RadioWanStatsList;
}
GetRadioWanStatsList();