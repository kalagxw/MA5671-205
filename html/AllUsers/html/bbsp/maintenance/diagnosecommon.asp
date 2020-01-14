<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="javascript" src="../common/userinfo.asp"></script>
<script language="javascript" src="../common/topoinfo.asp"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<script language="javascript" src="../common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/EquipTestResult.asp"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" type="text/javascript">
var DATA_BLOCK_DEFAULT=56;
var REPEATE_TIME_DEFAULT=4;
var DSCP_DEFAULT=0;
var MaxTimeout_DEFAULT = 10;
var TraceRoute_DATA_BLOCK_DEFAULT = 38;

var PING_FLAG="Ping";
var TRACEROUTE_FLAG="Traceroute";
var EQUIPTEST_FLAG="EquipTest";
var NSLOOKUP_FLAG="Nslookup";

var CLICK_INIT_FLAG="None";
var CLICK_START_FLAG="START";
var CLICK_TERMINAL_FLAG="TERMIANL";

var STATE_INIT_FLAG="None";
var STATE_DOING_FLAG="Doing";
var STATE_DONE_FLAG="Done";

var TimerHandle ;
var TimerHandlePing;
var TimerHandlePingDns;
var TimerHandleEquip;
var TimerHandleNslookup;

var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var CfgModeWord ='<%HW_WEB_GetCfgMode();%>';
var curWebFrame = '<%HW_WEB_GetWEBFramePath();%>';
var CurBinMode = '<%HW_WEB_GetBinMode();%>';

function loadlanguage()
{
	var all = document.getElementsByTagName("td");
	for (var i = 0; i <all.length ; i++) 
	{
		var b = all[i];
		if(b.getAttribute("BindText") == null)
		{
			continue;
		}
		b.innerHTML = diagnose_language[b.getAttribute("BindText")];
	}
}

function Br0IPAddressItem(domain, IPAddress, SubnetMask)
{
    this.domain = domain;
    this.IPAddress = IPAddress;
    this.SubnetMask = SubnetMask;
}
function PingResultClass(domain, DiagnosticsState,Interface,Host,NumberOfRepetitions,Timeout,DataBlockSize,DSCP,FailureCount, SuccessCount,MinimumResponseTime,MaximumResponseTime,AverageResponseTime)
{
    this.domain = domain;
    this.DiagnosticsState = DiagnosticsState;
    this.Interface = Interface;
    this.Host = Host;
    this.NumberOfRepetitions = NumberOfRepetitions;
    this.Timeout = Timeout;
    this.DataBlockSize = DataBlockSize;
    this.DSCP = DSCP;
    this.FailureCount = FailureCount;
    this.SuccessCount = SuccessCount;
    this.MinimumResponseTime = MinimumResponseTime;
    this.MaximumResponseTime = MaximumResponseTime;
    this.AverageResponseTime = AverageResponseTime;
}
function TracertResultClass(domain,DiagnosticsState,Interface,Host,NumberOfTries,Timeout,DataBlockSize,DSCP,MaxHopCount,ResponseTime,RouteHopsNumberOfEntries)
{
	this.domain = domain;
	this.DiagnosticsState = DiagnosticsState;
	this.Interface = Interface;
	this.Host = Host;
	this.NumberOfTries = NumberOfTries;
	this.Timeout = Timeout;
	this.DataBlockSize = DataBlockSize;
	this.DSCP = DSCP;
	this.MaxHopCount = MaxHopCount;
	this.ResponseTime = ResponseTime;
	this.RouteHopsNumberOfEntries = RouteHopsNumberOfEntries;
}

var LanHostInfos = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_FilterSlaveLanHostIp, InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},IPInterfaceIPAddress|IPInterfaceSubnetMask,Br0IPAddressItem);%>;
var LanHostInfo = LanHostInfos[0];
var PingResultList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetPingResult, InternetGatewayDevice.IPPingDiagnostics,DiagnosticsState|Interface|Host|NumberOfRepetitions|Timeout|DataBlockSize|DSCP|FailureCount|SuccessCount|MinimumResponseTime|MaximumResponseTime|AverageResponseTime, PingResultClass);%>;
var PingResult = PingResultList[0];
var TracertResultList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.TraceRouteDiagnostics,DiagnosticsState|Interface|Host|NumberOfTries|Timeout|DataBlockSize|DSCP|MaxHopCount|ResponseTime|RouteHopsNumberOfEntries, TracertResultClass);%>;
var TracerResult = TracertResultList[0];
var splitobj = "[@#@]";
var dnsString = "";
var NslookupOpInfo;

var PingClickFlag= "<%HW_WEB_GetRunState("Ping");%>";
var TracerouteClickFlag= "<%HW_WEB_GetRunState("Traceroute");%>";
var EquipTestClickFlag= "<%HW_WEB_GetRunState("EquipTest");%>";
var NslookupClickFlag= "<%HW_WEB_GetRunState("Nslookup");%>";

var PingState=STATE_INIT_FLAG;
var TraceRouteState=STATE_INIT_FLAG;
var EquipCheckState=STATE_INIT_FLAG;
var NslookupState=STATE_INIT_FLAG;

function OnApply()
{
    var IPAddress = getValue("IPAddress");
    var WanName = getSelectVal("WanNameList");

    IPAddress = removeSpaceTrim(IPAddress);
    if (IPAddress.length == 0)
    {
		AlertEx(diagnose_language['bbsp_taraddrisreq']);
        return false;
    }
	if(IPAddress.indexOf("\"") >= 0)
	{
		AlertEx(diagnose_language['bbsp_targetaddrinvalid']);
        return false;
	}
 
	var DataBlockSize = getValue("DataBlockSize");
	DataBlockSize = removeSpaceTrim(DataBlockSize);
	if(DataBlockSize!="")
	{
       if ( false == CheckNumber(DataBlockSize,32, 65500) )
       {
         AlertEx(diagnose_language['bbsp_pingdatablocksizeinvalid']);
         return false;
       }
    }
    else
    {
  	   DataBlockSize=DATA_BLOCK_DEFAULT;
    }
	
	var NumberOfRepetitions = getValue("NumOfRepetitions");
	NumberOfRepetitions = removeSpaceTrim(NumberOfRepetitions);
	if(NumberOfRepetitions!="")
	{
	   var maxRepetitions = ("TELMEX" == CfgModeWord.toUpperCase()) ? 300000 : 3600;
       if ( false == CheckNumber(NumberOfRepetitions,1, maxRepetitions) )
       {
			if("TELMEX" == CfgModeWord.toUpperCase())
			{
				AlertEx(diagnose_language['bbsp_numofrepetitionsinvalid_telmex']);
				return false;
			}
			else
			{
				AlertEx(diagnose_language['bbsp_numofrepetitionsinvalid']);
				return false;
			}
       }
	}
	else
	{
	   NumberOfRepetitions=REPEATE_TIME_DEFAULT;
	}

	var DSCP = getValue("DscpValue");
	DSCP = removeSpaceTrim(DSCP);
    if(DSCP!="")
	{
       if ( false == CheckNumber(DSCP,0, 63) )
       {
         AlertEx(diagnose_language['bbsp_dscpvalueinvalid']);
         return false;
       }
  }else
  {
  	   DSCP=DSCP_DEFAULT;
  }

	var MaxTimeout = getValue("MaxTimeout");
	MaxTimeout = removeSpaceTrim(MaxTimeout);
	if(MaxTimeout != "")
	{
       if ( false == CheckNumber(MaxTimeout,1, 4294967) )
       {
         AlertEx(diagnose_language['bbsp_maxtimeoutinvalid']);
         return false;
       }
  }else
  {
  	   MaxTimeout = MaxTimeout_DEFAULT;
  }
	MaxTimeout = MaxTimeout*1000;
	
	setDisable("ButtonApply", "1");	
	setDisable("ButtonStopPing", "1");
	getElement('PingTestTitle').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_testing']+ '</FONT><B>';
	getElement('DnsTitle').innerHTML ="";
	getElement('DnsText').innerHTML ="";
	getElement('PingTitle').innerHTML ="";
	getElement('PingText').innerHTML ="";
	
    var Form = new webSubmitForm();

    Form.addParameter('x.Host', IPAddress);
    Form.addParameter('x.DiagnosticsState','Requested');
    Form.addParameter('x.NumberOfRepetitions',NumberOfRepetitions);
    if(DSCP != "" && false == IsSonetUser())
	{
       Form.addParameter('x.DSCP',DSCP);
    }
    Form.addParameter('x.DataBlockSize',DataBlockSize);
    Form.addParameter('x.Timeout',MaxTimeout);

    if (WanName != "")
    {
       Form.addParameter('x.Interface',WanName); 
    }
	
	Form.addParameter('RUNSTATE_FLAG.value',CLICK_START_FLAG);
	Form.addParameter('x.X_HW_Token', getValue('onttoken')); 
    Form.setAction('complex.cgi?x=InternetGatewayDevice.IPPingDiagnostics&RUNSTATE_FLAG='+PING_FLAG+'&RequestFile=html/bbsp/maintenance/diagnosecommon.asp');   
 
    Form.submit(); 
}

function OnStopPing()
{
    var IPAddress = getValue("IPAddress");
    var WanName = getSelectVal("WanNameList");

    if (IPAddress.length == 0)
    {
        return false;
    }
    
    setDisable("ButtonApply", "1");	
	setDisable("ButtonStopPing", "1");
	
	var Form = new webSubmitForm();

    Form.addParameter('x.Host', IPAddress);	
	
    Form.addParameter('x.NumberOfRepetitions',PingResult.NumberOfRepetitions);
	if(true != IsSonetUser())
    {
    	Form.addParameter('x.DSCP',PingResult.DSCP);
  	}
    Form.addParameter('x.DataBlockSize',PingResult.DataBlockSize);
    Form.addParameter('x.Timeout',PingResult.Timeout);
    if (WanName != "")
    {
       Form.addParameter('x.Interface',WanName); 
    }

    Form.addParameter('RUNSTATE_FLAG.value',CLICK_TERMINAL_FLAG);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));	
    Form.setAction('complex.cgi?x=InternetGatewayDevice.IPPingDiagnostics&RUNSTATE_FLAG='+PING_FLAG+'&RequestFile=html/bbsp/maintenance/diagnosecommon.asp&1');   
    Form.submit(); 
}

function showPingDnsInfo(dnsTitle, dnsText)
{
	if (dnsString.indexOf("NONE") == -1)
	{
		getElement('DnsTitle').innerHTML = dnsTitle;
		getElement('DnsText').innerHTML = dnsText;
	}
}

function ParsePingResult(pingString)
{   
	 var subString = pingString.split(splitobj);
	 var result = "";
	 var status = "";
	 if (subString.length >= 2)
	 {

	 	if ("\n" == subString[1])
		{
			status = subString[0];
			getElement('PingTestTitle').innerHTML ='';
			showPingDnsInfo('', '');
			getElement('PingTitle').innerHTML = '';
			getElement('PingText').innerHTML = '';
			substring=null;
			return;
		}
		else
		{
			status = subString[1];
			result = subString[0];
		}
	 }
	 else
	 {
	 	 substring=null;
	 	 return ;
	 }
	 if ((status.indexOf("None") >= 0)
	     ||( status.indexOf("Requested") >= 0) )
	 {
		 if (CLICK_START_FLAG == PingClickFlag)
		 {
			if("TELMEX" == CfgModeWord.toUpperCase())
			{
				var requestResult = "";
				if(dnsString.indexOf("NONE") == -1)
				{
					requestResult = diagnose_language['bbsp_dnstitle'] + '\n' + dnsString + '\n';
				}
				requestResult += diagnose_language['bbsp_pingtitle'] + '\n';
				if(result.indexOf("NONE") == -1)
				{
					requestResult += result;
				}
				getElement("PingResultArea").value = requestResult;	
			}
			else
			{
				result = ChangeRetsult(result);
				getElement('PingTestTitle').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_testing']+ '</FONT><B>';
			}
			PingState=STATE_DOING_FLAG;
		 }
		 else if(CLICK_INIT_FLAG == PingClickFlag)
		 {
		    PingState=STATE_INIT_FLAG;
		 }		
		  
		 showPingDnsInfo('', '');
		 getElement('PingTitle').innerHTML = '';
		 getElement('PingText').innerHTML = '';
	 }
	 else if( status.indexOf("Complete_Err") >= 0)
	 {
		PingState=STATE_DONE_FLAG;		
		setDisable('ButtonApply',0);		
		setDisable("ButtonStopPing", 1);	
		getElement('PingTestTitle').innerHTML ='<B><FONT color=red>'+diagnose_language['bbsp_fail']+ '</FONT><B>';
		showPingDnsInfo(diagnose_language['bbsp_dnstitle'], dnsString);
		getElement('PingTitle').innerHTML = diagnose_language['bbsp_pingtitle'];
		getElement('PingText').innerHTML = diagnose_language['bbsp_pingfail1'];
		
		var errResult = "";
		if(dnsString.indexOf("NONE") == -1)
		{
			errResult = diagnose_language['bbsp_dnstitle'] + '\n' + dnsString + '\n';
		}
		errResult += diagnose_language['bbsp_pingtitle'] + '\n' + result;
		getElement("PingResultArea").value = errResult;
	 }
	 else if( status.indexOf("Complete") >= 0)
	 {
		PingState=STATE_DONE_FLAG;		
		setDisable('ButtonApply',0);		
		setDisable("ButtonStopPing", 1);	
		var tmpResult = ChangeRetsult(result);
		var SubStatisticResult = tmpResult.split("ping statistics ---<br/>");
		var StatisticResult = SubStatisticResult[1];
		var Result = StatisticResult.split("<br/>");
		
		getElement('PingTestTitle').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_result']+ '</FONT><B>';
		showPingDnsInfo(diagnose_language['bbsp_dnstitle'], dnsString);
		getElement('PingTitle').innerHTML = diagnose_language['bbsp_pingtitle'];
		getElement('PingText').innerHTML = Result[0] + '<br/>' + Result[1];
		
		var completeResult = "";
		if(dnsString.indexOf("NONE") == -1)
		{
			completeResult = diagnose_language['bbsp_dnstitle'] + '\n' + dnsString + '\n';
		}
		completeResult += diagnose_language['bbsp_pingtitle'] + '\n' + result;
		getElement("PingResultArea").value = completeResult;		
	 }
	 else 
	 {
		PingState=STATE_DONE_FLAG;		
		var otherResult = "";
		setDisable('ButtonApply',0);
		setDisable("ButtonStopPing", 1);	
		getElement('PingTestTitle').innerHTML ='<B><FONT color=red>'+diagnose_language['bbsp_fail']+ '</FONT><B>';
		if( false == CheckIsIpOrNot(removeSpaceTrim(getValue("IPAddress"))) )
		{
			if (dnsString.indexOf("NONE") == -1)
			{
				getElement('DnsTitle').innerHTML = diagnose_language['bbsp_dnstitle'];
				getElement('DnsText').innerHTML = dnsString;
				otherResult = diagnose_language['bbsp_dnstitle'] + '\n' + dnsString + '\n';
			}
			else
			{
				getElement('DnsTitle').innerHTML = diagnose_language['bbsp_dnstitle'];
				getElement('DnsText').innerHTML = diagnose_language['bbsp_pingfail1'];
				otherResult = diagnose_language['bbsp_dnstitle'] + '\n' + diagnose_language['bbsp_pingfail1'] + '\n';
			}
		}
		getElement('PingTitle').innerHTML = diagnose_language['bbsp_pingtitle'];
		getElement('PingText').innerHTML = diagnose_language['bbsp_pingfail1'];
		
		otherResult += diagnose_language['bbsp_pingtitle'] + '\n' + diagnose_language['bbsp_pingfail1'];
		getElement("PingResultArea").value = otherResult;
	 }
	 otherResult = null;
	 completeResult = null;
	 errResult = null;
	 tmpResult=null;
	 SubStatisticResult=null;
	 Result=null;
	 return ;
}

function GetPingResult()
{
	var PingContent="";
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : "./GetPingResult.asp",
		success : function(data) {

			if ((data.length > 8) && ('\\n" + ' == data.substr(2,6)))
			{
				data = data.substr(8);
			}
			PingContent = eval(data);
			ParsePingResult(PingContent);
		},
		complete: function (XHR, TS) { 
            PingContent=null;			
			XHR = null;
		}
	});
}

function GetPingDnsResult()
{
	var PingDnsContent="";
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : "./GetPingDnsResult.asp",
		success : function(data) {

			if ((data.length > 8) && ('\\n" + ' == data.substr(2,6)))
			{
				data = data.substr(8);
			}
			PingDnsContent = eval(data);
			dnsString = PingDnsContent;
		},
		complete: function (XHR, TS) { 
            PingDnsContent = null;			
			XHR = null;
		}
	});
}

function GetPingAllResult()
{
    GetPingDnsResult();
    GetPingResult();
    
	if (CLICK_START_FLAG  ==  PingClickFlag && STATE_DOING_FLAG == PingState)
    { 	
        if(TimerHandlePing == undefined)
        {            
            TimerHandlePing = setInterval("GetPingAllResult()", 10000);
        }
    }
    
    if ((CLICK_START_FLAG  ==  PingClickFlag && STATE_DONE_FLAG == PingState)
        || (CLICK_TERMINAL_FLAG  ==  PingClickFlag) )
    { 	
        if(TimerHandlePing != undefined)
        {
            clearInterval(TimerHandlePing);
        }
    }   
}

function setAllDisable()
{
	setDisable('IPAddress',1);
	setDisable('WanNameList',1);
	setDisable('DataBlockSize',1);
	setDisable('NumOfRepetitions',1);
	setDisable('ButtonApply',1);
	setDisable('ButtonStopPing',1);
	setDisable('wanname',1);
	setDisable('urladdress',1);
	setDisable('btnTraceroute',1);
	setDisable('btnStopTraceroute',1);
	setDisable('Timeout',1);
	setDisable('DSCP',1);
	setDisable('nslookup_target',1);
	setDisable('nslookup_wanname',1);
	setDisable('nslookup_srv',1);
	setDisable('btnNsLookupStart',1);
}

function LoadFrame()
{
	if (curUserType == sysUserType)
	{
	    setDisplay("space",0);
		if( "CMCC" == CurBinMode.toUpperCase() )
		{
			setDisplay("mainend",1);
		}
		else
		{
			setDisplay("mainend",0);
		}
	}
	else
	{
	    setDisplay("mainend",0);
	    setDisplay("space",1);
	}
	setDisplay("TraceRoute",1);
	setDisplay('btnStopTraceroute', 0);
    if ('DT_HUNGARY' == CfgModeWord.toUpperCase())
    {
        setDisplay('btnStopTraceroute', 1);
    }
	if (CLICK_START_FLAG == TracerouteClickFlag)
	{
		getElement('traceRouteresult').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_testing']+ '</FONT><B>';
		setDisable('btnTraceroute',1);
		setDisable('btnStopTraceroute',0);
		GetRouteResult();		
	}
	else if  (CLICK_TERMINAL_FLAG == TracerouteClickFlag)
	{
		var href = window.location.href.split('&');
		if( (href.length == 3) && (href[2] == 1) )
		{
			getElement('traceRouteresult').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_testing']+ '</FONT><B>';
		}
		setDisable('btnTraceroute',0);
		setDisable("btnStopTraceroute", 1);	 
	 }
	 else if(CLICK_INIT_FLAG == TracerouteClickFlag)//no ping oper after reboot
	 {
	    setDisable('btnTraceroute',0);
		setDisable("btnStopTraceroute", 1);
     }
     else
     {
        //not impossible
	 }

	if (CLICK_START_FLAG == EquipTestClickFlag)
	{
		getElement('equipTestResult').innerHTML = '<B><FONT color=red>'+diagnose_language['selftestwait']+ '</FONT><B>';
		setDisable('EquipCheck',1);
	}
	else
	{
		getElement('equipTestResult').innerHTML ="";
		getElement('EquipTestText').innerHTML = "";
	}
   
	var Tr069Enable = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_TR069);%>';
	if(Tr069Enable != 1)
	{
		setDisplay("mainend",0);
	}
	
	if("TELMEX" != CfgModeWord.toUpperCase())
	{
		setDisplay("PingTestTitle",1);
		setDisplay("DnsTitle",1);
		setDisplay("DnsText",1);
		setDisplay("PingTitle",1);
		setDisplay("PingText",1);
	}
   	 if(CLICK_START_FLAG == PingClickFlag)
	 {
		getElement('PingTestTitle').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_testing']+ '</FONT><B>';
		setDisable('ButtonApply',1);
		setDisable("ButtonStopPing", 0);
		GetPingAllResult();
		if("TELMEX" == CfgModeWord.toUpperCase())
		{
			setDisplay("PingResultDiv",1);
		}
	 }
	 else if(CLICK_TERMINAL_FLAG == PingClickFlag)
	 {
		var href = window.location.href.split('&');
		if( (href.length == 4) && (href[3] == 1) )
		{
			getElement('PingTestTitle').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_stopping']+ '</FONT><B>';
			
			if("TELMEX" == CfgModeWord.toUpperCase())
			{
				GetPingAllResult();
				setDisplay("PingResultDiv",1);
			}
		}
		else
		{

		}
		setDisable('ButtonApply',0);
		setDisable("ButtonStopPing", 1);	 
	 }
	 else if(CLICK_INIT_FLAG == PingClickFlag)
	 {
	    setDisable('ButtonApply',0);
		setDisable("ButtonStopPing", 1);
     }
	 
	 
	if('PTVDF' == CfgModeWord.toUpperCase())
	{
		setDisplay('NsLookupForm',1);
		GetNslookupOpResult();
	}
	else
	{
		setDisplay('NsLookupForm',0);
	}
	 
	 

	loadlanguage();
	
	if((curWebFrame == 'frame_argentina') &&(curUserType != sysUserType))
	{
		setAllDisable();
	}
	
	var FeatureInfo = GetFeatureInfo();
	if (FeatureInfo.Wan != 1)
	{	
		setDisplay('ThirdPlayerPanel',0);
	}
	
	if(IsSonetUser())
	{
		setDisplay('tr_dscpvalue',0);
	}
	if(('TELECOM' == CfgModeWord.toUpperCase()) &&(curUserType != sysUserType))
	{
		setAllDisable();
	    setDisable('MaxTimeout',1);
		setDisable('DscpValue',1);
	    setDisable('TraceRouteDataBlockSize',1);
	}
}

function WriteOptionFortraceRoute()
{
   	InitWanNameListControl2("wanname", function(item){
		if((curUserType != sysUserType) && (CfgModeWord.toUpperCase() == "RDSGATEWAY"))
		{
			if ((item.Mode == 'IP_Routed') && (item.Enable == 1) && (item.Tr069Flag == '0') && (item.ServiceList.toString().toUpperCase().indexOf("INTERNET") >=0)){
				return true;
			}
		}
		else if ((curUserType != sysUserType) && (CfgModeWord.toUpperCase() == "DT_HUNGARY"))
        {
            if ((item.Mode == 'IP_Routed') && (item.Enable == 1) && (item.Tr069Flag == '0')
                && (item.Name.toUpperCase().indexOf("INTERNET") >= 0))
            {
                return true;
            }           
        }
		else
		{
			if ((item.Mode == 'IP_Routed') && (item.Enable == 1) && (item.Tr069Flag == '0'))
			{
				return true;
			}
		}
		return false;
   	});
}

function isHostName(name) 
{
    var reg = new RegExp("^[a-z|A-Z]\.");
    return reg.test(name);
}


function startTraceroute()
{
    getElement('TraceRouteText').innerHTML ="";
	with (getElement('TraceRouteForm'))
	{
		var url = getValue('urladdress');
		var wanVal;

		if (url.length == 0)
		{
			AlertEx(diagnose_language['bbsp_taraddrisreq']);
			return false;
		}

		if ((IsIPv6AddressValid(url) == true) && (IsIPv6LinkLocalAddress(url) == true))
		{
			AlertEx(diagnose_language['bbsp_linkLocalnotsup']);
			return false;
		}

		var DataBlockSize = getValue('TraceRouteDataBlockSize');
		DataBlockSize = removeSpaceTrim(DataBlockSize);
		if(DataBlockSize!="")
		{
       		if ( false == CheckNumber(DataBlockSize,38, 32768) )
       		{
         		AlertEx(diagnose_language['bbsp_tracertdatablocksizeinvalid']);
         		return false;
       		}
  		}else
  		{
  	   		DataBlockSize = TraceRoute_DATA_BLOCK_DEFAULT;
  		}

		setDisable('urladdress',1);
		setDisable('TraceRouteDataBlockSize',1);
		setDisable('btnTraceroute',1);
		setDisable('btnStopTraceroute',0);
		getElement('traceRouteresult').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_testing']+ '</FONT><B>';

		var Form = new webSubmitForm();
		wanVal = getSelectVal('wanname');
		if (wanVal != "")
    		{
			Form.addParameter('x.Interface',wanVal); 
    		}
		Form.addParameter('x.DiagnosticsState',"Requested"); 
		Form.addParameter('x.Host',url);  
		Form.addParameter('x.DataBlockSize',DataBlockSize);
		Form.addParameter('RUNSTATE_FLAG.value',CLICK_START_FLAG);
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.setAction('complex.cgi?x=InternetGatewayDevice.TraceRouteDiagnostics&RUNSTATE_FLAG='+TRACEROUTE_FLAG+'&RequestFile=html/bbsp/maintenance/diagnosecommon.asp');               		
        Form.submit();
	}
	return true;
}

function stopTraceroute()
{
    getElement('TraceRouteText').innerHTML ="";
    var url = getValue('urladdress');
    var wanVal;
    if (url.length == 0)
    {
        return false;
    }
    setDisable('urladdress',1);
    setDisable('TraceRouteDataBlockSize',1);
    setDisable('btnTraceroute',1);
    setDisable('btnStopTraceroute',0);
    getElement('traceRouteresult').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_testing']+ '</FONT><B>';
    var Form = new webSubmitForm();
    wanVal = getSelectVal('wanname');
    if (wanVal != "")
    {
        Form.addParameter('x.Interface',wanVal); 
    }
    Form.addParameter('x.Host',url); 
    Form.addParameter('x.DataBlockSize',TracerResult.DataBlockSize);
    Form.addParameter('RUNSTATE_FLAG.value',CLICK_TERMINAL_FLAG);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('complex.cgi?x=InternetGatewayDevice.TraceRouteDiagnostics&RUNSTATE_FLAG='+TRACEROUTE_FLAG+'&RequestFile=html/bbsp/maintenance/diagnosecommon.asp');                      
    Form.submit();
	return true;
}

function ChangeRetsult(text)
{
    var result = "";
    if (text.toLowerCase() != 'none')
	{
	   var str=text.replace("!H"," ");
	   res = str.split("\n");
	   
	   for(i=0;i<res.length;i++)
	   {
		  result+=res[i]+'<br/>';
	   }
	}
	return result;
}

function FindResultEnd(string)
{   
	 var newString = string.split(splitobj);
	 var status =  newString[1];
	 var result =  newString[0];

	 if (  (status.indexOf("None") >= 0)
	     ||( status.indexOf("Requested") >= 0) )
	 {
	 	var result;
	    if(TimerHandle != undefined)
		{
			result = ChangeRetsult(result);
			getElement('traceRouteresult').innerHTML ='<B><FONT color=red>'+diagnose_language['bbsp_testing']+ '</FONT><B>';
			getElement('TraceRouteText').innerHTML =result;						
		}
		TraceRouteState=STATE_DOING_FLAG;
	 }
	 else if( status.indexOf("Complete") >= 0)
	 {
		TraceRouteState=STATE_DONE_FLAG;
		setDisable('btnTraceroute',0);
		setDisable('btnStopTraceroute',1);
		var tmpResult = ChangeRetsult(newString[0]);
		getElement('traceRouteresult').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_result']+ '</FONT><B>';
		if(tmpResult == "" || tmpResult == "<br/>")
		{
			getElement('TraceRouteText').innerHTML = diagnose_language['bbsp_pingfail1'];
		}
		else
		{
			getElement('TraceRouteText').innerHTML = tmpResult;
		}
		tmpResult=null;
	 }
     else 
	 {
		TraceRouteState=STATE_DONE_FLAG;
		setDisable('btnTraceroute',0);
		setDisable('btnStopTraceroute',1);
		getElement('traceRouteresult').innerHTML ='<B><FONT color=red>'+diagnose_language['bbsp_fail']+ '</FONT><B>';
		getElement('TraceRouteText').innerHTML = "";
	 }
	newString=null;
	result=null;
	return ;
}

function SetFlag(flag,value)
{    
    $.ajax({
     type : "POST",
     async : false,
     cache : false,
     data : "RUNSTATE_FLAG.value="+value +"&x.X_HW_Token="+getValue('onttoken'),
     url : "complex.cgi?RUNSTATE_FLAG="+flag,
     success : function(data) {
     },
     complete: function (XHR, TS) {
        XHR=null;
     }
    });
}

function GetRouteResult()
{
	var traceRouteTxt="";
    $.ajax({
     type : "POST",
     async : true,
     cache : false,
     url : "./GetRouteResult.asp",
     success : function(data) {
        traceRouteTxt = eval(data);
        FindResultEnd(traceRouteTxt);
     },
     complete: function (XHR, TS) {
        if (CLICK_START_FLAG  ==  TracerouteClickFlag && TraceRouteState == STATE_DOING_FLAG)
        {
            if(TimerHandle == undefined)
            {
                TimerHandle=setInterval("GetRouteResult()", 10000);
            }
        }
        
        if( CLICK_START_FLAG  ==  TracerouteClickFlag && TraceRouteState == STATE_DONE_FLAG )
        {
            if(TimerHandle != undefined)
            {
	            clearInterval(TimerHandle);
	        }else
	        {
	        }
        }      
        

        traceRouteTxt=null;

     	XHR = null;
     }
    });
}



function WriteOptionForNslookup()
{
	InitWanNameListControl2("nslookup_wanname", function(item){
		if ((curUserType != sysUserType) 
			&& ((CfgModeWord.toUpperCase() == "RDSGATEWAY") || (CfgModeWord.toUpperCase() == "DT_HUNGARY")))
		{
			if ((item.ServiceList.toString().toUpperCase().indexOf("INTERNET") >=0) && (item.Mode == "IP_Routed")){
				return true;
			}
		}else{
			if (item.Mode == "IP_Routed"){
				return true;
			}
		}
		return false;
   	});
}

function startNSlookup()
{
	with (getElement('NsLookupForm'))
	{
		var url = getValue('nslookup_target');
		var DNSServer = getValue('nslookup_srv');
		var wanVal = getSelectVal('nslookup_wanname');
	
		if (url.length == 0)
		{
			AlertEx(diagnose_language['bbsp_taraddrisreq']);
			return false;
		}
		
		if(DNSServer != "")
		{
			if(false == CheckIsIpOrNot(DNSServer) || false == CheckIpAddressValid(DNSServer))
			{
				AlertEx(diagnose_language['bbsp_invaliddns']);
				return false;
			}
		}
		
		setDisable('nslookup_target',1);
		setDisable('nslookup_srv',1);
		setDisable('nslookup_wanname',1);
		setDisable('btnNsLookupStart',1);
		getElement('nslookup_process').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_testing']+ '</FONT><B>';
		getElement('nslookup_result').innerHTML ="";		
		var Form = new webSubmitForm();
		
		Form.addParameter('x.Interface',wanVal);
		Form.addParameter('x.DiagnosticsState',"Requested"); 
		Form.addParameter('x.HostName',url);  
		Form.addParameter('x.DNSServer',DNSServer);
		Form.addParameter('RUNSTATE_FLAG.value',CLICK_START_FLAG);
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.setAction('complex.cgi?x=InternetGatewayDevice.DNS.Diagnostics.NSLookupDiagnostics&RUNSTATE_FLAG='+NSLOOKUP_FLAG+'&RequestFile=html/bbsp/maintenance/diagnosecommon.asp');              		
        Form.submit();
	}
	return true;
}

function ParseNslookupInfo( NslookupInfo )
{
	var result = NslookupInfo;
	var text = "";
	var ip_addr = "";
	var ipv4_str = "";
	var ipv6_str = "";
		
	for(var i = 0 ; i < result.length - 1 ; i++ )
	{
		if(result[i].Status.indexOf("NotAvailable") >= 0)
		{
			text +="&nbsp;&nbsp;&nbsp;&nbsp;***Can't find " + NslookupOpInfo.DNSServer + "for" + NslookupOpInfo.HostName + ": No response from server." + '<br/>';
			if( "" == result[i].DNSServerIP)
			{
				text +="&nbsp;&nbsp;&nbsp;&nbsp;Server Address: --"
			}
			else
			{
				text +="&nbsp;&nbsp;&nbsp;&nbsp;Server Address: "+result[i].DNSServerIP + '<br/>' + '<br/>';
			}
			continue;
		}
		if(result[i].Status.indexOf("NotResolved") >= 0)
		{
			text +="&nbsp;&nbsp;&nbsp;&nbsp;***Dns server can't find " + NslookupOpInfo.HostName + ": Non-existent domain." + '<br/>';
			if( "" == result[i].DNSServerIP)
			{
				text +="&nbsp;&nbsp;&nbsp;&nbsp;Server Address: --"
			}
			else
			{
				text +="&nbsp;&nbsp;&nbsp;&nbsp;Server Address: "+result[i].DNSServerIP + '<br/>' + '<br/>';
			}
			continue;
		}
		if(result[i].Status.indexOf("Timeout") >= 0)
		{
			text +="&nbsp;&nbsp;&nbsp;&nbsp;***Dns requset timed out ." + '<br/>';
			if( "" == result[i].DNSServerIP)
			{
				text +="&nbsp;&nbsp;&nbsp;&nbsp;Server Address: --"
			}
			else
			{
				text +="&nbsp;&nbsp;&nbsp;&nbsp;Server Address: "+result[i].DNSServerIP + '<br/>' + '<br/>';
			}
			continue;
		}
		if(result[i].Status.indexOf("Other") >= 0)
		{
			text +="&nbsp;&nbsp;&nbsp;&nbsp;***Dns requset error: error other ." + '<br/>' ;
			if( "" == result[i].DNSServerIP)
			{
				text +="&nbsp;&nbsp;&nbsp;&nbsp;Server Address: --"
			}
			else
			{
				text +="&nbsp;&nbsp;&nbsp;&nbsp;Server Address: "+result[i].DNSServerIP + '<br/>' + '<br/>';
			}
			continue;
		}
		
		text +="&nbsp;&nbsp;&nbsp;&nbsp;***Dns request success" + '<br/>' ;
		text +="&nbsp;&nbsp;&nbsp;&nbsp;Server Address: "+result[i].DNSServerIP + '<br/>' + '<br/>';
		
		if(result[i].AnswerType.indexOf("NonAuthoritative") >= 0)
		{
			text +="&nbsp;&nbsp;&nbsp;&nbsp;Non-authoritative answer: " + '<br/>' ;
		}
		else if(result[i].AnswerType.indexOf("Authoritative") >= 0)
		{
			text +="&nbsp;&nbsp;&nbsp;&nbsp;Authoritative answer: " + '<br/>' ;
		}
		else
		{
			
		}		
		text +="&nbsp;&nbsp;&nbsp;&nbsp;Name: "+NslookupOpInfo.HostName + '<br/>';
		
		text +="&nbsp;&nbsp;&nbsp;&nbsp;Addresses: " ;
		
		ip_addr = result[i].IPAddresses.split(",");

		for(var j = 0 ; j < ip_addr.length ; j++)
		{	
			if( 0 == j)
			{
				text += ip_addr[j]+ '<br/>';
			}
			else
			{
				text +=  "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"+ip_addr[j]+ '<br/>';
			}
		}	
		text += '<br/>' ;	
	}
	getElement('nslookup_result').innerHTML = text;
}


function ParseNslookupError( )
{
	var result = NslookupOpInfo;
	var text = "";
	if(result.DiagnosticsState.indexOf("Internal") >= 0 )
	{
		text += "&nbsp;&nbsp;&nbsp;&nbsp;Error: Internal "+ '<br/>';
	}
	if(result.DiagnosticsState.indexOf("Other") >= 0 )
	{
		text += "&nbsp;&nbsp;&nbsp;&nbsp;Error: Other "+ '<br/>';
	}
	getElement('nslookup_result').innerHTML = text;
}

function GetNslookupResult(func)
{
	var NslookupInfoList;
	$.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "./GetNslookupResult.asp",
            success : function(data) {
			
				NslookupInfoList = eval(data);
				
				func(NslookupInfoList);				
            }
	});
			
}	

function GetNslookupOpResult()
{
	var NslookupOpInfoList;
	$.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "./GetNslookupOpResult.asp",
            success : function(data) {
			
				NslookupOpInfoList = eval(data);
				setDisable('btnNsLookupStart',1);
				if(NslookupOpInfoList != null) 
				{
					NslookupOpInfo = NslookupOpInfoList[0];
					if(NslookupOpInfo != "" )
					{	
						setText("nslookup_target",NslookupOpInfo.HostName);
						setSelect("nslookup_wanname",NslookupOpInfo.Interface);
						setText("nslookup_srv",NslookupOpInfo.DNSServer);
						
						for (var i=0; i < document.getElementById("nslookup_wanname").length; i++)
						{
							if (document.getElementById("nslookup_wanname")[i].value == NslookupOpInfo.Interface)
							{
								try
								{
									document.getElementById("nslookup_wanname")[i].selected = true;
								}
								catch(Exception)
								{
								}
							}
						}
					}
					if(  NslookupOpInfo.DiagnosticsState.indexOf("Complete") >= 0 || NslookupOpInfo.DiagnosticsState.indexOf("NotResolved") >= 0)
					{	
						NslookupState = STATE_DONE_FLAG;
						setDisable('btnNsLookupStart',0);
						getElement('nslookup_process').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_result']+ '</FONT><B>';
						GetNslookupResult(function(para2)
						{
							var NslookupInfo = para2;
							ParseNslookupInfo( NslookupInfo );
						});
						
					}
					else if( NslookupOpInfo.DiagnosticsState.indexOf("None") >= 0 )
					{
						NslookupState = STATE_INIT_FLAG;
						setDisable('btnNsLookupStart',0);
					}	
					else if( NslookupOpInfo.DiagnosticsState.indexOf("Internal") >= 0 || NslookupOpInfo.DiagnosticsState.indexOf("Other") >= 0 )
					{
						NslookupState = STATE_DONE_FLAG;
						setDisable('btnNsLookupStart',0);
						getElement('nslookup_process').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_result']+ '</FONT><B>';
						ParseNslookupError( NslookupOpInfo);
					}	
					else
					{
						NslookupState = STATE_DOING_FLAG;
						getElement('nslookup_process').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_testing']+ '</FONT><B>';
					}
				}
            },
			complete: function (XHR, TS) { 
                NslookupOpInfoList = null;
             	XHR = null;
				if(STATE_DOING_FLAG == NslookupState)
				{
					if(TimerHandleNslookup == undefined)
					{
						TimerHandleNslookup = setInterval("GetNslookupOpResult()", 10000);
					}
				}
				if(STATE_DONE_FLAG == NslookupState)
				{
					if(TimerHandleNslookup != undefined)
					{
						clearInterval(TimerHandleNslookup);
					}
				}
			}
        });
}

var EquipTestResultInfo = new EquipTestResultClass("0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0");
var PhyResult = new Array();
function GetEquipInfo()
{
	PhyResult[0] = EquipTestResultInfo.Port1Result;
	PhyResult[1] = EquipTestResultInfo.Port2Result;
	PhyResult[2] = EquipTestResultInfo.Port3Result;
	PhyResult[3] = EquipTestResultInfo.Port4Result;
	PhyResult[4] = EquipTestResultInfo.Port5Result;
	PhyResult[5] = EquipTestResultInfo.Port6Result;
}


function GetEquipTestResult()
{
	if (CLICK_START_FLAG  ==  EquipTestClickFlag)
	{
		$.ajax({
			type : "POST",
			async : true,
			cache : false,
			url : "./getEquipTestResult.asp",
			success : function(data) {
			EquipTestResultInfo = eval(data);
			GetEquipInfo();
			EquipTestResult();
			},
            complete: function (XHR, TS) { 

                traceRouteTxt=null;

             	XHR = null;
          }			
		});		
	}
	else
	{
	    if(TimerHandleEquip != undefined)
	    {
	        clearInterval(TimerHandleEquip);
	    }		
	}
}

function ParseSelfTestResult(SelfTestResult, PhyResult)
{
	var result = "";
	var resulttemp = "";
	if (SelfTestResult.SD5113Result.indexOf("Failed") >= 0)
	{
		result += diagnose_language['bbsp_sd5113fail'];
	}

	if (SelfTestResult.WifiResult.indexOf("Failed") >= 0)
	{
		result += diagnose_language['bbsp_wififail'];
	}

	if (SelfTestResult.LswResult.indexOf("Failed") >= 0)
	{
		result += diagnose_language['bbsp_lswfailk'];
	}

	if (SelfTestResult.CodecResult.indexOf("Failed") >= 0)
	{
		result += diagnose_language['bbsp_codecfail'];
	}

	if (SelfTestResult.OpticResult.indexOf("Failed") >= 0)
	{
		result += diagnose_language['bbsp_lightfail'];
	}

	for (i = 0; i < 6; i++)
	{
		if (PhyResult[i].indexOf("Failed") >= 0)
		{
			resulttemp = "ETH" + (i+1) + diagnose_language['bbsp_phyfail'] ;
			result += resulttemp;
		}
	}
	return result;
}

function ParseLinkTestResult(rawresult)
{
	var result = "";
	var resulttemp = "";
	var nochecknum = 0;
	portres = rawresult.split(";");

	for (i =0; i < 12; i++)
	{
		innerres = portres[i].split(":");
		finalres = innerres[1];

		if (finalres.indexOf("NoCheck") >= 0)
		{
			nochecknum++;
			continue;
		}

		if (!(i % 2))
		{
			if (finalres.indexOf("Failed") >= 0)
			{
				resulttemp = "511X ETH" + (i + 2)/2 + diagnose_language['bbsp_machwabnormal'];
				result += resulttemp;
			}			
		}
		else
		{
			if (finalres.indexOf("Failed") >= 0)
			{
				resulttemp = "ETH" + (i + 1)/2 + diagnose_language['bbsp_phyhwabnmormal'];
				result += resulttemp;
			}
		}
	}

	if (nochecknum == 12)
	{
		result = "NoCheck";
	}	
	return result;
}

function EquipTestResult()
{
	var ShowStr = "";
	var PrifixStr = diagnose_language['bbsp_test'];
	LinkResult = ParseLinkTestResult(EquipTestResultInfo.LinkTestResult);
	EquipFinalStr = ParseSelfTestResult(EquipTestResultInfo, PhyResult) + LinkResult;

	if (EquipFinalStr == "")
	{
		ShowStr = PrifixStr + diagnose_language['bbsp_ok'];
	}
	else
	{
		ShowStr = PrifixStr + EquipFinalStr + "!";
		ShowStr = ShowStr.replace("；!", "");
	}

	if (LinkResult.indexOf("NoCheck") >= 0)
	{
		ShowStr = "";
	}
	
	getElement('equipTestResult').innerHTML ='<B><FONT color=red>'+diagnose_language['bbsp_result']+ '</FONT><B>';
	getElement('EquipTestText').innerHTML = ShowStr;
	EquipTestClickFlag = CLICK_TERMINAL_FLAG;
	SetFlag(EQUIPTEST_FLAG,CLICK_TERMINAL_FLAG);
	setDisable('EquipCheck',0);
	return ShowStr;
}

function OnEquipCheck()
{
	var lanid = "";
    setDisable('EquipCheck', 1);
	getElement('EquipTestText').innerHTML ="";
	getElement('equipTestResult').innerHTML = '<B><FONT color=red>'+diagnose_language['selftestwait']+ '</FONT><B>';	
	EquipTestClickFlag = CLICK_START_FLAG;		
	EquipTestResultInfo = GetCommonEquipTestResultInfo();
	GetEquipInfo();

    var Form = new webSubmitForm();

	if (EquipTestResultInfo.SD5113Result.indexOf("OK") >= 0)
	{
		for (i = 0; i < 6; i++)
		{
			if (PhyResult[i].indexOf("OK") >= 0)
			{
				lanid += "" + (i +1);
			}
		}
	}

	Form.addParameter('x.portid', lanid);
	Form.addParameter('RUNSTATE_FLAG.value',CLICK_START_FLAG);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));	
	Form.setAction('complex.cgi?x=InternetGatewayDevice.X_HW_DEBUG.BBSP.ExtendPortTransCheck&RUNSTATE_FLAG='+EQUIPTEST_FLAG+'&RequestFile=html/bbsp/maintenance/diagnosecommon.asp');	
	Form.submit();
	
}

function OnEndClick() 
{
	setDisable('MaintenanceEnd', 1);
	var Form = new webSubmitForm();
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('maintenancend.cgi?FileType=log&RequestFile=html/bbsp/maintenance/diagnosecommon.asp');
	Form.submit();
}
</script>
<title>Diagnose Ping Configuration</title>
</head>
<body  class="mainbody" onLoad="LoadFrame();"> 
<form> 
<form> </form> 
<div id="ThirdPlayerPanel">
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("DCpingtitle", GetDescFormArrayById(diagnose_language, ""), GetDescFormArrayById(diagnose_language, ""), false);
	if (IsAdminUser() == true)
	{
		document.getElementById("DCpingtitle_content").innerHTML = diagnose_language["bbsp_diagnose_titleadmin"];
	}
	else
	{
		document.getElementById("DCpingtitle_content").innerHTML = diagnose_language["bbsp_diagnose_titleuser"];
	}
</script>
<div class="title_spread"></div>

<table width="100%" border="0" cellpadding="0" id="table_ping_title" cellspacing="0" class="tabal_head"> 
  <tr> 
    <td  class="width_per100 align_left" BindText='bbsp_pingtest'>
	</td> 
	<td>
		<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
	</td>
  </tr> 
</table> 
<table border="0" cellpadding="0" cellspacing="1" id="table_ping" width="100%"> 
  <tr> 
    <td class="table_title width_per25">
	<script language="JavaScript" type="text/javascript">
		  if ('PTVDF' == CfgModeWord.toUpperCase())
		  {
			  document.write(diagnose_language['bbsp_targetmh1']);
		  }
		  else
		  {
		      document.write(diagnose_language['bbsp_targetmh']);
		  }
	</script>
	</td> 
    <td class="table_right align_left width_per75"><input name="IPAddress" type="text" id="IPAddress" class="width_254px"/>
      <font color="red">*</font><span id="PingResult" class='width_per20x'></span> </td> 
  </tr> 
  <tr> 
    <td  class="table_title width_per25" BindText='bbsp_wannamemh'></td> 
    <td  class="table_right" title=""><select id="WanNameList"  class="width_260px" name="WanNameList"> </select></td> 
  </tr> 
  
    <tr> 
    <td class="table_title width_per25" BindText='bbsp_datablocksize'></td> 
    <td class="table_right align_left width_per75"><input name="DataBlockSize" type="text" value="56" id="DataBlockSize" class="width_254px"/>
	<span class="gray"><script>document.write(diagnose_language['bbsp_pingdatablocksizerange']);</script></span> 
       </td> 
  </tr> 
    <tr> 
    <td class="table_title width_per25" BindText='bbsp_numofrepetitions'></td> 
    <td class="table_right align_left width_per75"><input name="NumOfRepetitions" type="text" value="4" id="NumOfRepetitions" class="width_254px"/>
	<span class="gray">
	<script>
	if("TELMEX" == CfgModeWord.toUpperCase())
	{
		document.write(diagnose_language['bbsp_repetitionsPromptTelmex']);
	}
	else
	{
		document.write(diagnose_language['bbsp_repetitionsPrompt']);
	}
	</script>
	</span> 
       </td> 
  </tr> 
  <tr> 
    <td class="table_title width_per25" BindText='bbsp_maxtimeout'></td> 
    <td class="table_right align_left width_per75"><input name="MaxTimeout" type="text" value="10" id="MaxTimeout" class="width_254px"/>
	<span class="gray"><script>document.write(diagnose_language['bbsp_pingmaxtimeoutrange']);</script></span> 
       </td> 
  </tr> 
  <tr id="tr_dscpvalue"> 
    <td class="table_title width_per25" BindText='bbsp_dscpvalue'></td> 
    <td class="table_right align_left width_75p"><input name="DscpValue" type="text" id="DscpValue" value="0" class="width_254px"/>
    <span class="gray"><script>document.write(diagnose_language['bbsp_dscpPrompt']);</script></span> 
    </td> 
  </tr> 

</table> 
<table id="OperatorPanel" class="table_button" style="width: 100%;"> 
  <tr> 
    <td class="table_submit width_per25" ></td> 
    <td class="table_submit width_per10 align_left"><button id="ButtonApply"  type="button" onclick="javascript: OnApply();" class="submit" ><script>document.write(diagnose_language['bbsp_start']);</script></button></td> 
    <td class="table_submit align_left"><button id="ButtonStopPing"  type="button" onclick="javascript: OnStopPing();" class="submit" ><script>document.write(diagnose_language['bbsp_stop']);</script></button></td> 
  </tr> 
</table> 
	<div name="PingTestTitle" id="PingTestTitle" style="display:none;"></div> 
	<div name="DnsTitle" id="DnsTitle" style="display:none;"></div> 
	 <div name="DnsText" id="DnsText" style="display:none;word-break:break-all"></div> 
	 <div name="PingTitle" id="PingTitle" style="display:none;"></div> 
	 <div name="PingText" id="PingText" style="display:none;"></div> 
	 <div id="PingResultDiv" style="display:none;"> 
	  <textarea name="PingResultArea" id="PingResultArea"  wrap="off" readonly="readonly" style="width: 100%;height: 150px;margin-top: 10px;">
	  </textarea> 
     </div> 	 
<div class="func_spread"></div>	 

<form id="TraceRouteForm"> 
  <div id ="TraceRoute"> 
    <table width="100%" border="0" id="TraceRoute_title" cellpadding="0" cellspacing="0" class="tabal_head"> 
      <tr> 
        <td  class="width_per100 align_left" BindText='bbsp_tracertest'> </td> 
      </tr> 
    </table> 
	<script language="JavaScript" type="text/javascript">
		HWCreatePageHeadInfo("DCtraceroutetitle", GetDescFormArrayById(diagnose_language, ""), GetDescFormArrayById(diagnose_language, "bbsp_diagnose_title2"), false);
	</script>
	<div class="title_spread"></div>
  
    <table border="0" cellpadding="0" cellspacing="1" id="table_trace" width="100%"> 
      <tr> 
        <td class="table_title width_per25">
		<script language="JavaScript" type="text/javascript">
		  if ('PTVDF' == CfgModeWord.toUpperCase())
		  {
			  document.write(diagnose_language['bbsp_targetmh1']);
		  }
		  else
		  {
		      document.write(diagnose_language['bbsp_targetmh']);
		  }
	   </script>
	   </td> 
        <td class="table_right align_left"> <table border="0"> 
            <tr> 
              <td class="align_left"><input name="urladdress" type="text" id="urladdress" class="width_254px"/> <font color="red">*</font> </td> 
            </tr> 
			<tr>
				<td  style="display:none"> <input type='text'> </td> 
			</tr> 

          </table></td> 
      </tr> 
      <tr> 
        <td   class="table_title width_per25" BindText='bbsp_wannamemh'></td> 
        <td class="table_right width_per75" title=""> <table> 
            <tr> 
              <td> <select id="wanname" name="wanname" class="width_260px"> 
                  <option value=""></option> 
                  <script language="JavaScript" type="text/javascript">
				   if(!((curUserType != sysUserType) && ((CfgModeWord.toUpperCase() == "RDSGATEWAY")||(CfgModeWord.toUpperCase() == "DT_HUNGARY"))))
				   {
						document.write('<option value="br0">br0</option> ');
				   }
		           WriteOptionFortraceRoute();
		         </script> 
                </select></td> 
            </tr> 
          </table></td> 
      </tr>
	  <tr> 
        <td class="table_title width_per25" BindText='bbsp_datablocksize'></td> 
        <td class="table_right align_left"> <table border="0"> 
            <tr> 
              <td class="align_left"><input name="TraceRouteDataBlockSize" type="text" value="38" id="TraceRouteDataBlockSize" class="width_254px"/> 
			  <span class="gray"><script>document.write(diagnose_language['bbsp_tracertdatablocksizerange']);</script> </span> </td> 
            </tr> 
          </table></td> 
      </tr> 
    </table> 
    <table width="100%" border="0" cellspacing="1" cellpadding="0" id="table_trace_button" class="table_button">  
        <td class="table_submit width_per25" ></td> 
        <td class="table_submit align_left width_per10"> <button  class="submit" name="btnTraceroute" id= "btnTraceroute" type="button" onClick="startTraceroute();"><script>document.write(diagnose_language['bbsp_start']);</script> </button></td> 
        <td class="table_submit align_left"><button  class="submit" name="btnStopTraceroute" id= "btnStopTraceroute" type="button" onClick="stopTraceroute();"><script>document.write(diagnose_language['bbsp_stop']);</script> </button></td> 
	  </tr> </table> 
    <div name="traceRouteresult" id="traceRouteresult"></div> 
    <div name="TraceRouteText" id="TraceRouteText"></div> 
    <div id="space"> 
     <div class="func_spread"></div>
    </div> 
  </div> 
</form>

<form id="NsLookupForm">
	<table width="100%" height="20" cellpadding="0" cellspacing="0"> 
	  <tr><td></td></tr>
	</table> 
  <div id ="NsLookup"> 
    <table width="100%" border="0" id="NsLookup_title" cellpadding="0" cellspacing="0" class="tabal_head"> 
      <tr> 
        <td  class="width_per100 align_left" BindText='bbsp_nl_fullname'> </td> 
      </tr> 
    </table> 
	<script language="JavaScript" type="text/javascript">
		HWCreatePageHeadInfo("DCNsLookuptitle", GetDescFormArrayById(diagnose_language, ""), GetDescFormArrayById(diagnose_language, "bbsp_nl_title"), false);
	</script>
	<div class="title_spread"></div>
   
    <table border="0" cellpadding="0" id="table_nslookup" cellspacing="1" width="100%"> 
      <tr> 
        <td class="table_title width_per25">
		<script language="JavaScript" type="text/javascript">
			  document.write(diagnose_language['bbsp_URL']);		 
	   </script>
	   </td> 
        <td class="table_right align_left"> <table border="0"> 
            <tr> 
              <td class="align_left"><input name="nslookup_target" type="text" id="nslookup_target" class="width_254px"/> <font color="red">*</font> </td> 
            </tr> 
			<tr>
				<td  style="display:none"> <input type='text'> </td> 
			</tr> 

          </table></td> 
      </tr> 
      <tr> 
        <td   class="table_title width_per25" BindText='bbsp_wannamemh'></td> 
        <td class="table_right width_per75" title=""> <table> 
            <tr> 
              <td> <select id="nslookup_wanname" name="nslookup_wanname" class="width_260px"> 
                  <option value=""></option> 
                  <script language="JavaScript" type="text/javascript">
		           WriteOptionForNslookup();
		         </script> 
                </select></td> 
            </tr> 
          </table></td> 
      </tr>
	  <tr> 
        <td class="table_title width_per25" BindText='bbsp_nl_dns_srv'></td> 
        <td class="table_right align_left"> <table border="0"> 
            <tr> 
              <td class="align_left"><input name="nslookup_srv" type="text" id="nslookup_srv" class="width_254px"/> 
			  </td> 
            </tr> 
          </table></td> 
      </tr> 
    </table> 
    <table width="100%" border="0" cellspacing="1" cellpadding="0" id="table_nslookup_button" class="table_button">  
        <td class="table_submit width_per25" ></td> 
        <td class="table_submit align_left width_per10"> <button  class="submit" name="btnNsLookupStart" id= "btnNsLookupStart" type="button" onClick="startNSlookup();"><script>document.write(diagnose_language['bbsp_start']);</script> </button></td> 
        <td class="table_submit align_left"></td> 
	  </tr> </table> 
	<div name="nslookup_process" id="nslookup_process"></div>
    <div name="nslookup_result" id="nslookup_result"></div> 
  </div> 
  <div class="func_spread"></div>
</form>
</div>

<form id="EquipForm"> 
<div id ="EquipDiv"> 
  <table width="100%" height="20" cellpadding="0" cellspacing="0"> 
	<tr> 
		<td></td> 
	</tr> 
  </table> 
  <table id="EquipTitle" width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_head"> 
    <tr> 
      <td  class="align_left width_per100" BindText='bbsp_hwtest'></td> 
    </tr> 
  </table> 
  
	<script language="JavaScript" type="text/javascript">
		HWCreatePageHeadInfo("DCequiptitle", GetDescFormArrayById(diagnose_language, ""), GetDescFormArrayById(diagnose_language, ""), false);
		document.getElementById("DCequiptitle_content").innerHTML = diagnose_language["bbsp_diagnose_title3"] + '<br>' + diagnose_language["bbsp_diagnose_title4"] + '<br>' + diagnose_language["bbsp_diagnose_title6"] + '<br>' + diagnose_language["bbsp_diagnose_title7"];
	</script>
	<div class="title_spread"></div>
  
  <table id= "EquipButton"  width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button"> 
    <tr > 
      <td class="table_submit width_1p" > </td> 
	  <td class="table_submit width_99p"> <button id="EquipCheck" name="EquipCheck" type="button" class="submit"  onclick="OnEquipCheck();"><script>document.write(diagnose_language['bbsp_starthwtest']);</script> </button></td> 
		 </tr> 
	   </table> 
		<div name="equipTestResult" id="equipTestResult"></div> 
			<div name="EquipTestText" id="EquipTestText"></div> 
			<div id="equipTestSpace"> 
			  <div class="func_spread"></div>
			</div>
</div>
</form> 
<div id="mainend"> 
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_head"> 
    <tr> 
      <td  class="align_left width_per100" BindText='bbsp_maint'></td> 
    </tr> 
  </table> 
  <div id="MaintenancePrompt">
	<script language="JavaScript" type="text/javascript">
		HWCreatePageHeadInfo("DCmainendtitle", GetDescFormArrayById(diagnose_language, ""), GetDescFormArrayById(diagnose_language, "bbsp_diagnose_title5"), false);
	</script>
	<div class="title_spread"></div>
  </div>
  
  <table  id="MaintenanceButton" class="table_button" style="width: 100%;"> 
    <tr> 
      <td class="table_submit width_per1" ></td> 
      <td class="table_submit width_per99 align_left"><button id="MaintenanceEnd"  type="button"  onclick="javascript:OnEndClick();" class="submit" ><script>document.write(diagnose_language['bbsp_maintend']);</script></button></td> 
    </tr> 
  </table> 
  
  <script>
    function IsValidWan(Wan)
    {
		if ((curUserType != sysUserType) 
			&& ((CfgModeWord.toUpperCase() == "RDSGATEWAY") || (CfgModeWord.toUpperCase() == "DT_HUNGARY")))
		{
			if ((Wan.ServiceList.toString().toUpperCase().indexOf("INTERNET") >=0) && (Wan.Enable == 1) && (Wan.Mode == "IP_Routed")){
				return true;
			}
		}else{
				if ((Wan.Mode == "IP_Routed") && (Wan.Enable == 1)){
				return true;
			}
		}
		return false;
    }
    function InitWanList()
    {
        var Option = document.createElement("Option");
        Option.value = "";
        Option.innerText = "";
        Option.text = "";
        getElById("WanNameList").appendChild(Option);
		if(!((curUserType != sysUserType) && ((CfgModeWord.toUpperCase() == "DT_HUNGARY") || (CfgModeWord.toUpperCase() == "RDSGATEWAY"))))
		{
			if (LanHostInfo != null)
			{
				var OptionBr0 = document.createElement("Option");
				OptionBr0.value = LanHostInfo.domain;
				OptionBr0.innerText = "br0";
				OptionBr0.text = "br0";
				getElById("WanNameList").appendChild(OptionBr0);            
			}
		}
        
        InitWanNameListControl2("WanNameList", IsValidWan);
    }
    function ShowPingResult()
    {
        var Text = GetPageParameter("queryFlag");
        var Success;

        if (Text == null)
        {
            return;
        }

        if (PingResult == null)
        {
            return;
        }

        getElById('PingResult').innerHTML = ((parseInt(PingResult.SuccessCount,10) > 0) ? ("<B><FONT class='color_red'>" + diagnose_language['bbsp_pingpass'] + "</FONT><B>") : ("<B><FONT class='color_red'>" + diagnose_language['bbsp_pingfail'] + "</FONT><B>"));
    }
    function ControlPage()
    {
        if (IsAdminUser() == false)
        {
            setDisplay("MaintenanceButton", "0");
            setDisplay("MaintenancePrompt", "0");
			setDisplay("EquipForm", "0");
        }
    }
    InitWanList();
    ControlPage();
	
	setText("TraceRouteDataBlockSize",TracerResult.DataBlockSize);
	setText("urladdress",TracerResult.Host);
	setSelect("wanname",TracerResult.Interface);
	
	for (var i=0; i < document.getElementById("wanname").length; i++)
	{
		if (document.getElementById("wanname")[i].value == TracerResult.Interface)
		{
			try
			{
				document.getElementById("wanname")[i].selected = true;
			}
			catch(Exception)
			{
			}
		}
	}

  if(PingResult.Host!="")
  {	
      setText("IPAddress",PingResult.Host);
      setText("DataBlockSize", PingResult.DataBlockSize);
      setText("NumOfRepetitions",PingResult.NumberOfRepetitions);
      setText("DscpValue",PingResult.DSCP); 
	  setText("MaxTimeout",parseInt(PingResult.Timeout/1000,10)); 	
	  setSelect("WanNameList",PingResult.Interface);
  }

	
	for (var i=0; i < document.getElementById("WanNameList").length; i++)
	{
		if (document.getElementById("WanNameList")[i].value == PingResult.Interface)
		{
			try
			{
				document.getElementById("WanNameList")[i].selected = true;
			}
			catch(Exception)
			{
			}
		}
	}
    
  </script> 
  </form> 
  <table width="100%" height="20" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td></td> 
    </tr> 
  </table> 
</div> 
<table width="100%" height="20" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td></td> 
    </tr> 
  </table> 
<script language="JavaScript" type="text/javascript">
TimerHandleEquip = setInterval("GetEquipTestResult()", 30000);
</script> 
</body>
</html>
