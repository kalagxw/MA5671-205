function UserDevice(domain, MacAddr,HostName)
{
	this.domain     = domain;
	this.MacAddr    = MacAddr;
	this.HostName   = HostName;
}

function ChildListClass(domain, MACAddress,Description,TemplateInst)
{
	this.domain = domain;
	this.MACAddress = MACAddress;
	this.Description = Description;
	this.TemplateInst = TemplateInst;
}


function TemplatesListClass(domain,Name,UrlFilterPolicy,UrlFilterRight,StartDate,EndDate)
{
	this.domain = domain;
	this.TemplateId = "";
	this.Name = Name;
	this.UrlFilterPolicy = UrlFilterPolicy;
	this.UrlFilterRight = UrlFilterRight;
	this.StartDate = StartDate;
	this.EndDate = EndDate;
}

function DurationListClass(domain, StartTime,EndTime,RepeatDay)
{
	this.domain     = domain;
	this.TemplateId = "";
	this.StartTime  = StartTime;
	this.EndTime    = EndTime;
	this.RepeatDay  = RepeatDay;
}

function UrlValueClass(_Domain, _Url)
{
	this.Domain = _Domain;
	this.Url = _Url;
}

function TimeShowClass(TemplateTime, TemplateRepeatDay)
{
	this.TemplateTime = TemplateTime;
	this.TemplateRepeatDay = TemplateRepeatDay;
}

function BindShowClass(MACAddress, Description)
{
	this.MACAddress = MACAddress;
	this.Description = Description;
}

function UrlShowClass(seq, UrlAddress)
{
	this.seq = seq;
	this.UrlAddress = UrlAddress;
}



function StatsListClass(domain, PacketsBlockedByTime_High,PacketsBlockedByTime_Low,PacketsBlockedByUrl_High,PacketsBlockedByUrl_Low)
{
	this.domain     = domain;
	this.TemplateId = "";
	this.PacketsBlockedByTime_High  = PacketsBlockedByTime_High;
	this.PacketsBlockedByTime_Low   = PacketsBlockedByTime_Low;
	this.PacketsBlockedByUrl_High   = PacketsBlockedByUrl_High;
	this.PacketsBlockedByUrl_Low    = PacketsBlockedByUrl_Low;
}

var UserDevicesListArray = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecialGetUserDevInfo,InternetGatewayDevice.LANDevice.1.X_HW_UserDev.{i},MacAddr|HostName,UserDevice);%>;
var UserDevicesListArrayNr = UserDevicesListArray.length - 1;

var ChildListArray = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.ParentalCtrl.MAC.{i}.,MACAddress|Description|TemplateInst,ChildListClass);%>;
var ChildListArrayNr = ChildListArray.length-1;

var TemplatesListArray = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.ParentalCtrl.Templates.{i}.,Name|UrlFilterPolicy|UrlFilterRight|StartDate|EndDate,TemplatesListClass);%>;
var TemplatesListArrayNr = TemplatesListArray.length-1;
for (var i = 0; i < TemplatesListArrayNr; i++)
{
	var id = TemplatesListArray[i].domain.split(".");
	TemplatesListArray[i].TemplateId = id[id.length -2];
}


var DurationListArray = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.ParentalCtrl.Templates.{i}.Duration.{i}.,StartTime|EndTime|RepeatDay,DurationListClass);%>;
var DurationListArrayNr = DurationListArray.length-1;
for (var i = 0; i < DurationListArrayNr; i++)
{
	var id = DurationListArray[i].domain.split(".");
	DurationListArray[i].TemplateId = id[id.length -4];
}

var StatsListArray = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.ParentalCtrl.Templates.{i}.Stats,PacketsBlockedByTime_High|PacketsBlockedByTime_Low|PacketsBlockedByUrl_High|PacketsBlockedByUrl_Low,StatsListClass);%>;
for (var i = 0; i < StatsListArray.length -1; i++)
{
	var id = StatsListArray[i].domain.split(".");
	StatsListArray[i].TemplateId = id[id.length -2];
}

function UrlFilterUrlAddress(_Domain, _UrlAddress)
{
	this.Domain = _Domain;
	this.UrlAddress = _UrlAddress;
}
var UrlValueArrayAll = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.ParentalCtrl.Templates.{i}.UrlFilter.{i},UrlAddress,UrlFilterUrlAddress);%>;

var FltsecLevel = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Security.X_HW_FirewallLevel);%>';

function GetUserDevicesList()
{
	return UserDevicesListArray;
}

function GetChildList()
{
	return ChildListArray;
}

function GetFilterApplyRange()
{
	var FilterApplyRange = "";
	if (ChildListArrayNr == 0)
	{
		FilterApplyRange = "SpecifiedDevice";
		return FilterApplyRange.toUpperCase();
	}
	else
	{
		for (var i = 0; i < ChildListArrayNr; i++)
		{
			if (ChildListArray[i].MACAddress.toUpperCase() == "FF:FF:FF:FF:FF:FF")
			{
				FilterApplyRange = "AllDevice";
				return FilterApplyRange.toUpperCase();
			}
		}
		FilterApplyRange = "SpecifiedDevice";
		return FilterApplyRange.toUpperCase();
	}
}

function GetTemplatesList()
{
	return TemplatesListArray;
}

function GetDurationList()
{
	return DurationListArray;
}

function GetStatsList()
{
	return StatsListArray;
}


function GetUrlValueArray(templateId)
{
	var selectDomain = "InternetGatewayDevice.X_HW_Security.ParentalCtrl.Templates." + templateId + '.';
	var UrlValueArray = new Array();
	for(var i = 0; i < UrlValueArrayAll.length - 1; i++){
		if( UrlValueArrayAll[i].Domain.indexOf(selectDomain) >= 0 ){
			UrlValueArray.push(UrlValueArrayAll[i]);
		}
	}
	return UrlValueArray;
}

function GetTemplateUrlEnable(templateId)
{
	for (var i = 0; i < TemplatesListArrayNr; i++){
		if(templateId == TemplatesListArray[i].TemplateId){
			return (TemplatesListArray[i].UrlFilterRight == '0')?false:true;
		}
	}
	return false;
}
function GetFltsecLevel()
{
	return FltsecLevel;
}

function SetDivValue(Id, Value)
{
	try
	{
		var Div = document.getElementById(Id);
		Div.innerHTML = Value;
	}
	catch(ex)
	{

	}
}

function getHeight(id)
{
	var item = id;
	var height;
	if (item != null)
	{
		if (item.style.display == 'none')
		{
			//item invisible
			return 0;
		}
		if (navigator.appName.indexOf("Internet Explorer") == -1)
		{
			height = item.offsetHeight;
		}
		else
		{
			height = item.scrollHeight;
		}
		if (typeof height == 'number')
		{
			return height;
		}
		return null;
	}

	return null;
}



