function QosBasicInfo(Domain, Enable, DefaultEthernetPriorityMark, X_HW_Mode, X_HW_ClassificationEnable, X_HW_Bandwidth, X_HW_Plan, X_HW_EnableForceWeight, X_HW_EnableDSCPMark, X_HW_Enable8021p)
{
    this.Domain = Domain;
    this.Enable = Enable;
    this.DefaultEthernetPriorityMark = DefaultEthernetPriorityMark;
	this.X_HW_Mode = X_HW_Mode;
	this.X_HW_ClassificationEnable = X_HW_ClassificationEnable;
	this.X_HW_Bandwidth = X_HW_Bandwidth;
	this.X_HW_Plan = X_HW_Plan;
	this.X_HW_EnableForceWeight = X_HW_EnableForceWeight;
	this.X_HW_EnableDSCPMark = X_HW_EnableDSCPMark;
	this.X_HW_Enable8021p = X_HW_Enable8021p;
}

function PriorityQueueInfo(Domain, Enable, Priority, Weight)
{
    this.Domain = Domain;
    this.Enable = Enable;
    this.Priority = Priority;
    this.Weight = Weight;
}

function AppInfo(Domain, AppName, ClassQueue)
{
    this.Domain = Domain;
    this.AppName = AppName;
    this.ClassQueue = ClassQueue;
}

function ClassificationInfo(Domain, ClassQueue, DSCPMarkValue, PriorityValue)
{
    this.Domain = Domain;
	this.ClassificationId = "";
    this.ClassQueue = ClassQueue;
	this.DSCPMarkValue = DSCPMarkValue;
	this.PriorityValue = PriorityValue;
}

function ClassificationTypeInfo(Domain, Type, Max, Min, ProtocolList)
{
	this.Domain = Domain;
	this.ClassificationId = "";
	this.ClassificationTypeId = "";
	this.Type = Type;
	this.Max = Max;
	this.Min = Min;
	this.ProtocolList = ProtocolList;
	this.MaxShow = "";
	this.MinShow = "";
}


var QosBasicInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.QueueManagement, Enable|DefaultEthernetPriorityMark|X_HW_Mode|X_HW_ClassificationEnable|X_HW_Bandwidth|X_HW_Plan|X_HW_EnableForceWeight|X_HW_EnableDSCPMark|X_HW_Enable8021p, QosBasicInfo);%>; 

var PQInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_UplinkQos.PriorityQueue.{i}, Enable|Priority|Weight, PriorityQueueInfo);%>; 
var DefaultPQList = new Array(new PriorityQueueInfo("","0","1","0"),new PriorityQueueInfo("","0","2","0"),new PriorityQueueInfo("","0","3","0"),new PriorityQueueInfo("","0","4","0"),null);
var PriorityQueueInfoList = new Array();

var AppInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_UplinkQos.App.{i}, AppName|ClassQueue, AppInfo);%>; 
var ClassificationInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_UplinkQos.Classification.{i}, ClassQueue|DSCPMarkValue|PriorityValue, ClassificationInfo);%>;
var ClsTypeList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_UplinkQos.Classification.{i}.type.{i}, Type|Max|Min|ProtocolList, ClassificationTypeInfo);%>;
var SortClassId = new Array();

if (ClassificationInfoList.length - 1 > 0)
{
	for (var i = 0; i < ClassificationInfoList.length - 1; i++)
	{
		var id = ClassificationInfoList[i].Domain.split("."); 
		ClassificationInfoList[i].ClassificationId = id[id.length -1];
		SortClassId[i] = ClassificationInfoList[i].ClassificationId;
	}
}

function ClassIdSort(array)
{ return array.sort(function(a, b)
{ return a - b; }); 
}

var ClsTypeInfoList = new Array();
if (ClsTypeList.length - 1 > 0)
{
	var ClassTypeItemNr = new Array();		
	
	for (var i = 0; i < ClsTypeList.length - 1; i++)
	{
		var id = ClsTypeList[i].Domain.split("."); 
		ClsTypeList[i].ClassificationId = id[id.length -3];
		ClsTypeList[i].ClassificationTypeId = id[id.length -1];
		if (ClsTypeList[i].Type == "LANInterface")
		{
			var lanminstr = ClsTypeList[i].Min.split("."); 
			var lanmaxstr = ClsTypeList[i].Max.split("."); 
			if (lanminstr[lanminstr.length-2] == "LANEthernetInterfaceConfig")
			{
				ClsTypeList[i].MinShow = "LAN" + lanminstr[lanminstr.length-1];
			}
			else if (lanminstr[lanminstr.length-2] == "WLANConfiguration")
			{
				ClsTypeList[i].MinShow = "SSID" + lanminstr[lanminstr.length-1];
			}
			
			if (lanmaxstr[lanmaxstr.length-2] == "LANEthernetInterfaceConfig")
			{
				ClsTypeList[i].MaxShow = "LAN" + lanmaxstr[lanmaxstr.length-1];
			}
			else if (lanmaxstr[lanmaxstr.length-2] == "WLANConfiguration")
			{
				ClsTypeList[i].MaxShow = "SSID" + lanmaxstr[lanmaxstr.length-1];
			}
		}
		
		var InstId = ClsTypeList[i].ClassificationId;
		if(typeof(ClassTypeItemNr[InstId]) == 'undefined')
			ClassTypeItemNr[InstId] = 1;
		else
			ClassTypeItemNr[InstId] ++;	
		
		
		if(ClassTypeItemNr[InstId] > 4)
		{
			continue;
		}
		
		ClsTypeInfoList.push(ClsTypeList[i]);
	}
}
ClsTypeInfoList.push(null);


if (PQInfoList.length == 1)
{
	for (var i = 0; i < DefaultPQList.length - 1; i++)
	{
		PriorityQueueInfoList[i] = DefaultPQList[i];
	}
}
else if (PQInfoList.length > 1)
{
	var i = 0;	
	var j = 0;
	var PQId = "";
	for (i = 0; i < PQInfoList.length - 1; i++)
	{
	    PQId = PQInfoList[i].Domain.charAt(PQInfoList[i].Domain.length-1);
		PriorityQueueInfoList[PQId-1] = PQInfoList[i];
	}
	for (j = 0; j < DefaultPQList.length - 1; j++)
	{
		if (PriorityQueueInfoList[j] == null)
		{
			PriorityQueueInfoList[j] = DefaultPQList[j];
		}
	}
}

function GetQosBasicInfoList()
{
	return QosBasicInfoList;
}

function GetAppInfoList()
{
	return AppInfoList;
}

function GetClassificationInfoList()
{
	return ClassificationInfoList;
}

function GetClassificationTypeInfoList()
{
	return ClsTypeInfoList;
}

function GetPriorityQueueInfoList()
{
	return PriorityQueueInfoList;
}

function GetSortClassInfoList()
{
	return ClassIdSort(SortClassId);
}