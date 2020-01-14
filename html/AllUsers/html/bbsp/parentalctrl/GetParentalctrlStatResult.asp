function StatsListClass(domain, PacketsBlockedByTime_High,PacketsBlockedByTime_Low,PacketsBlockedByUrl_High,PacketsBlockedByUrl_Low)
{
	this.domain     = domain;
	this.TemplateId = "";
	this.PacketsBlockedByTime_High	= PacketsBlockedByTime_High;
	this.PacketsBlockedByTime_Low	= PacketsBlockedByTime_Low;
	this.PacketsBlockedByUrl_High	= PacketsBlockedByUrl_High;
	this.PacketsBlockedByUrl_Low    = PacketsBlockedByUrl_Low;
}

var StatsListArray = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.ParentalCtrl.Templates.{i}.Stats,PacketsBlockedByTime_High|PacketsBlockedByTime_Low|PacketsBlockedByUrl_High|PacketsBlockedByUrl_Low,StatsListClass);%>;

for (var i = 0; i < StatsListArray.length -1; i++)
{
	var id = StatsListArray[i].domain.split("."); 
	StatsListArray[i].TemplateId = id[id.length -2];
}

function GetStatsList()
{
	return StatsListArray;
}

GetStatsList();