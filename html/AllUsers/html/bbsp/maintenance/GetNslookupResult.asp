function NSLOOKUPRESULT(Domain,Status,AnswerType,HostNameReturned,IPAddresses,DNSServerIP,ResponseTime)
{
	this.Domain 	      	= Domain;
	this.Status       		= Status;
	this.AnswerType	      	= AnswerType;
	this.HostNameReturned	= HostNameReturned;
	this.IPAddresses        = IPAddresses;
	this.DNSServerIP	    = DNSServerIP;
	this.ResponseTime    	= ResponseTime;
}


var NslookupResult = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DNS.Diagnostics.NSLookupDiagnostics.Result.{i},Status|AnswerType|HostNameReturned|IPAddresses|DNSServerIP|ResponseTime,NSLOOKUPRESULT);%>;

function GetNslookupResult()
{
	return NslookupResult;
}

GetNslookupResult();