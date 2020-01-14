function NSLOOKUPOP(Domain,DiagnosticsState,Interface,HostName,DNSServer,Timeout,NumberOfRepetitions,SuccessCount,ResultNumberOfEntries)
{
	this.Domain 	      		= Domain;
	this.DiagnosticsState       = DiagnosticsState;
	this.Interface	      		= Interface;
	this.HostName		 		= HostName;
	this.DNSServer              = DNSServer;
	this.Timeout	     		= Timeout;
	this.NumberOfRepetitions    = NumberOfRepetitions;
	this.SuccessCount 	 		= SuccessCount;
	this.ResultNumberOfEntries  = ResultNumberOfEntries;
}


var NslookupOpResult = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DNS.Diagnostics.NSLookupDiagnostics,DiagnosticsState|Interface|HostName|DNSServer|Timeout|NumberOfRepetitions|SuccessCount|ResultNumberOfEntries,NSLOOKUPOP);%>;

function GetNslookupOpResult()
{
	return NslookupOpResult;
}

GetNslookupOpResult();