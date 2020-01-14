<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../../bbsp/common/userinfo.asp"></script>
<script language="javascript" src="../../bbsp/common/topoinfo.asp"></script>
<script language="javascript" src="../../bbsp/common/managemode.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list.asp"></script>
<script language="javascript" src="../../bbsp/common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>
<script language="javascript" src="../../bbsp/common/wan_check.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<style type="text/css">
.tabal_tr {
    height: 24px;
    line-height: 24px;
    padding-left: 5px;
}
</style>
<script language="JavaScript" type="text/javascript">
var DATA_BLOCK_DEFAULT=56;
var REPEATE_TIME_DEFAULT=4;
var DSCP_DEFAULT=0;
var MaxTimeout_DEFAULT = 10;

var PING_FLAG="Ping";
var CLICK_INIT_FLAG="None";
var CLICK_START_FLAG="START";
var CLICK_TERMINAL_FLAG="TERMIANL";

var STATE_INIT_FLAG="None";
var STATE_DOING_FLAG="Doing";
var STATE_DONE_FLAG="Done";

var TimerHandlePing;
var TimerHandlePingDns;

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
var LanHostInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},IPInterfaceIPAddress|IPInterfaceSubnetMask,Br0IPAddressItem);%>;
var LanHostInfo = LanHostInfos[0];
var PingResultList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.IPPingDiagnostics,DiagnosticsState|Interface|Host|NumberOfRepetitions|Timeout|DataBlockSize|DSCP|FailureCount|SuccessCount|MinimumResponseTime|MaximumResponseTime|AverageResponseTime, PingResultClass);%>;
var PingResult = PingResultList[0];
var splitobj = "[@#@]";
var dnsString = "";

var PingClickFlag= "<%HW_WEB_GetRunState("Ping");%>";
var PingState=STATE_INIT_FLAG;

function OnApply()
{
    var IPAddress = getValue("Ping_host_text");
    var WanName = getSelectVal("Ping_interface_select");
    IPAddress = removeSpaceTrim(IPAddress);
    if (IPAddress.length == 0)
    {
		AlertEx(diagnose_language['bbsp_taraddrisreq']);
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
	
  var NumberOfRepetitions = getValue("Ping_repetition_Number_text");
  NumberOfRepetitions = removeSpaceTrim(NumberOfRepetitions);
  if(NumberOfRepetitions!="")
	{
       if ( false == CheckNumber(NumberOfRepetitions,1, 10) )
       {
         AlertEx("重复次数范围为1~10，并且必须为整数。");
         return false;
       }
  }else
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
	
	setDisable("Ping_diag_start_button", "1");	
	getElement('Ping_result_lable').innerHTML = '<B><FONT color=red>'+'正在进行Ping测试，请稍等…'+ '</FONT><B>';
	getElement('DnsTitle').innerHTML ="";
	getElement('DnsText').innerHTML ="";
	getElement('PingTitle').innerHTML ="";
	getElement('Ping_result').innerHTML ="";
	
    var Form = new webSubmitForm();

    Form.addParameter('x.Host', IPAddress);
    Form.addParameter('x.DiagnosticsState','Requested');
    Form.addParameter('x.NumberOfRepetitions',NumberOfRepetitions);
    if(DSCP != "")
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
    Form.setAction('complex.cgi?x=InternetGatewayDevice.IPPingDiagnostics&RUNSTATE_FLAG='+PING_FLAG+'&RequestFile=html/bbsp/maintenance/diagnoseping.asp');   
    Form.submit(); 
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
			getElement('Ping_result_lable').innerHTML ='';
			showPingDnsInfo('', '');
			getElement('PingTitle').innerHTML = '';
			getElement('Ping_result').innerHTML = '';
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
			result = ChangeRetsult(result);
			getElement('Ping_result_lable').innerHTML = '<B><FONT color=red>'+'正在进行Ping测试，请稍等…'+ '</FONT><B>';
			PingState=STATE_DOING_FLAG;
		 }
		 else if(CLICK_INIT_FLAG == PingClickFlag)
		 {
		    PingState=STATE_INIT_FLAG;
		 }		

		 showPingDnsInfo('', '');
		 getElement('PingTitle').innerHTML = '';
		 getElement('Ping_result').innerHTML = '';
	 }
	 else if( status.indexOf("Complete_Err") >= 0)
	 {
		PingState=STATE_DONE_FLAG;		
		setDisable('Ping_diag_start_button',0);		
		getElement('Ping_result_lable').innerHTML ='<B><FONT color=red>'+'Ping测试失败！'+ '</FONT><B>';
		showPingDnsInfo(diagnose_language['bbsp_dnstitle'], dnsString);
		getElement('PingTitle').innerHTML = diagnose_language['bbsp_pingtitle'];
		getElement('Ping_result').innerHTML = diagnose_language['bbsp_pingfail1'];
	 }
	 else if( status.indexOf("Complete") >= 0)
	 {
		PingState=STATE_DONE_FLAG;		
		setDisable('Ping_diag_start_button',0);		
		var tmpResult = ChangeRetsult(result);
		var SubStatisticResult = tmpResult.split("ping statistics ---<br/>");
		var StatisticResult = SubStatisticResult[1];
		var Result = StatisticResult.split("<br/>");
		
		getElement('Ping_result_lable').innerHTML = '<B><FONT color=red>'+'Ping Result具体内容显示'+ '</FONT><B>';
		showPingDnsInfo(diagnose_language['bbsp_dnstitle'], dnsString);
		getElement('PingTitle').innerHTML = diagnose_language['bbsp_pingtitle'];
		getElement('Ping_result').innerHTML = Result[0] + '<br/>' + Result[1];			
	 }
	 else 
	 {
		PingState=STATE_DONE_FLAG;		
		setDisable('Ping_diag_start_button',0);	
		getElement('Ping_result_lable').innerHTML ='<B><FONT color=red>'+'Ping测试失败！'+ '</FONT><B>';
		if( false == CheckIsIpOrNot(removeSpaceTrim(getValue("Ping_host_text"))) )
		{
			if (dnsString.indexOf("NONE") == -1)
			{
				getElement('DnsTitle').innerHTML = diagnose_language['bbsp_dnstitle'];
				getElement('DnsText').innerHTML = dnsString;
			}
			else
			{
				getElement('DnsTitle').innerHTML = diagnose_language['bbsp_dnstitle'];
				getElement('DnsText').innerHTML = diagnose_language['bbsp_pingfail1'];
			}
		}
		getElement('PingTitle').innerHTML = diagnose_language['bbsp_pingtitle'];
		getElement('Ping_result').innerHTML = diagnose_language['bbsp_pingfail1'];
	 }
	 
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

function LoadFrame()
{
   	 if(CLICK_START_FLAG == PingClickFlag)
	 {
		getElement('Ping_result_lable').innerHTML = '<B><FONT color=red>'+'正在进行Ping测试，请稍等…'+ '</FONT><B>';
		setDisable('Ping_diag_start_button',1);
		GetPingAllResult();
	 }
	 else if(CLICK_TERMINAL_FLAG == PingClickFlag)
	 {
		var href = window.location.href.split('&');
		if( (href.length == 3) && (href[2] == 1) )
		{
			getElement('Ping_result_lable').innerHTML = '<B><FONT color=red>'+diagnose_language['bbsp_stopping']+ '</FONT><B>';
		}
		else
		{

		}
		setDisable('Ping_diag_start_button',0);	 
	 }
	 else if(CLICK_INIT_FLAG == PingClickFlag)
	 {
	    setDisable('Ping_diag_start_button',0);
     }
     else
     {

     }

	loadlanguage();
}

</script>
<title>Diagnose Ping Configuration</title>
</head>
<body  class="mainbody" onLoad="LoadFrame();"> 
<form> 
  <div id="PromptPanel"> 
    <table width="100%" border="0" cellpadding="0" cellspacing="0"> 
      <tr> 
        <td class="prompt"> <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
            <tr> 
              <td width="100%" class="title_01" style="padding-left: 10px;" BindText='bbsp_diagnose_titleuser'></td> 
            </tr> 
          </table></td> 
      </tr> 
      <tr> 
        <td height="5px"></td> 
      </tr> 
    </table> 
  </div> 

<table border="0" cellpadding="0" cellspacing="0" id="table_ping" width="100%"> 
    <tr class="tabal_tr">
    <td  class="table_title width_per25">网络连接</td> 
    <td class="table_right"><select id="Ping_interface_select"  style="width:260px" name="Ping_interface_select"> </select></td> 
    </tr> 
    <tr class="tabal_tr">
    <td class="table_title">IP版本</td> 
    <td class="table_right"><select id="Ping_ip_version_select"  style="width:260px" name="Ping_ip_version_select"> 
        <option value="IPv4">IPv4</option><option value="IPv6">IPv6</option></select>
    </td> 
    </tr> 
    <tr class="tabal_tr">
    <td class="table_title">目的地址</td> 
    <td class="table_right"><input name="Ping_host_text" type="text" id="Ping_host_text" style="width:254px"/>
      <font color="red">*</font><span id="PingResult" class='width_20px'></span> </td> 
    </tr> 
    <tr class="tabal_tr">
    <td class="table_title">重复次数</td> 
    <td class="table_right"><input name="Ping_repetition_Number_text" type="text" value="4" id="Ping_repetition_Number_text" style="width:254px"/>
	<label id="Title_ping_diag_start_button_lable" class="gray">(1~10次)</script></label> </td> 
    </tr> 
    <tr class="tabal_tr">
    <td class="table_title" >数据块大小</td> 
    <td class="table_right"><input name="DataBlockSize" type="text" value="56" id="DataBlockSize" style="width:254px"/>
	<span class="gray"><script>document.write(diagnose_language['bbsp_pingdatablocksizerange']);</script></span> 
       </td> 
    </tr> 

    <tr class="tabal_tr">
    <td class="table_title">最大超时时间</td> 
    <td  class="table_right"><input name="MaxTimeout" type="text" value="10" id="MaxTimeout" style="width:254px"/>
	<span class="gray"><script>document.write(diagnose_language['bbsp_pingmaxtimeoutrange']);</script></span> 
       </td> 
    </tr> 
    <tr class="tabal_tr">
    <td  class="table_title">DSCP值</td> 
    <td class="table_right" ><input name="DscpValue" type="text" id="DscpValue" value="0" style="width:254px"/>
    <span class="gray"><script>document.write(diagnose_language['bbsp_dscpPrompt']);</script></span> 
    </td> 
    </tr> 
</table> 
<br/>
<table id="OperatorPanel" class="table_button" width="100%"> 
  <tr> 
    <td width="145px"></td> 
    <td >
	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	<button id="Ping_diag_start_button"  type="button" onclick="javascript: OnApply();" class="submit" >开始测试</button></td> 
    <td></td> 
  </tr> 
  <br/>
</table> 
	<label name="Ping_result_lable" id="Ping_result_lable"></label> 
	<div name="DnsTitle" id="DnsTitle"></div> 
     <div name="DnsText" id="DnsText" style="word-break:break-all"></div> 
	 <div name="PingTitle" id="PingTitle"></div> 
	 <label name="Ping_result" id="Ping_result"></label> 
  <script>

    function IsValidWan(Wan)
    {
		if ((Wan.Mode == "IP_Routed") && (Wan.Enable == 1))
		{
			return true;
		}
		else
		{
			return false;
		}
    }
    function InitWanList()
    {
        var Option = document.createElement("Option");
        Option.value = "";
        Option.innerText = "";
        Option.text = "";
        getElById("Ping_interface_select").appendChild(Option);

        if (LanHostInfo != null)
        {
            var OptionBr0 = document.createElement("Option");
            OptionBr0.value = LanHostInfo.domain;
            OptionBr0.innerText = "br0";
            OptionBr0.text = "br0";
            getElById("Ping_interface_select").appendChild(OptionBr0);            
        }
        
        InitWanNameListControl2("Ping_interface_select", IsValidWan);
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
        }
    }
    InitWanList();
    ControlPage();
	if(PingResult.Host!="")
	{	
      setText("Ping_host_text",PingResult.Host);
      setText("DataBlockSize", PingResult.DataBlockSize);
      setText("Ping_repetition_Number_text",PingResult.NumberOfRepetitions);
      setText("DscpValue",PingResult.DSCP); 
	  setText("MaxTimeout",parseInt(PingResult.Timeout/1000,10)); 	
	  setSelect("Ping_interface_select",PingResult.Interface);
  }

	
	for (var i=0; i < document.getElementById("Ping_interface_select").length; i++)
	{
		if (document.getElementById("Ping_interface_select")[i].value == PingResult.Interface)
		{
			try
			{
				document.getElementById("Ping_interface_select")[i].selected = true;
			}
			catch(Exception)
			{
			}
		}
	}

  </script> 
</form> 
</body>
</html>
