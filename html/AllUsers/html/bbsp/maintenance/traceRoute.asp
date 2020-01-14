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
var TraceRoute_DATA_BLOCK_DEFAULT = 38;
var TRACEROUTE_FLAG="Traceroute";
var CLICK_INIT_FLAG="None";
var CLICK_START_FLAG="START";
var CLICK_TERMINAL_FLAG="TERMIANL";
var STATE_INIT_FLAG="None";
var STATE_DOING_FLAG="Doing";
var STATE_DONE_FLAG="Done";
var TimerHandle;

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
var TracertResultList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.TraceRouteDiagnostics,DiagnosticsState|Interface|Host|NumberOfTries|Timeout|DataBlockSize|DSCP|MaxHopCount|ResponseTime|RouteHopsNumberOfEntries, TracertResultClass);%>;
var TracerResult = TracertResultList[0];
var splitobj = "[@#@]";
var dnsString = "";
var TracerouteClickFlag= "<%HW_WEB_GetRunState("Traceroute");%>";
var TraceRouteState=STATE_INIT_FLAG;
function LoadFrame()
{
    if (CLICK_START_FLAG == TracerouteClickFlag)
	{
		getElement('Tracert_result_lable').innerHTML = '<B><FONT color=red>'+'正在进行Tracert测试，请稍等…'+ '</FONT><B>';
		setDisable('Tracert_diag_start_button',1);
		GetRouteResult();		
	}
	
	loadlanguage();
}

function WriteOptionFortraceRoute()
{
   	InitWanNameListControlWanname("Tracert_interface_select", function(item){
   		if ((item.Mode == 'IP_Routed') && (item.Tr069Flag == '0')&& (item.Enable == 1))
			return true;
		else
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
		var url = getValue('Tracert_host_text');
		var wanVal;

		if (url.length == 0)
		{
			AlertEx(diagnose_language['bbsp_taraddrisreq']);
			return false;
		}

		if (IsIPv6AddressValid(url) == true && IsIPv6LinkLocalAddress(url) == true)
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

		setDisable('Tracert_host_text',1);
		setDisable('TraceRouteDataBlockSize',1);
		setDisable('Tracert_diag_start_button',1);
		getElement('Tracert_result_lable').innerHTML = '<B><FONT color=red>'+'正在进行Tracert测试，请稍等…'+ '</FONT><B>';

		var Form = new webSubmitForm();
		wanVal = getSelectVal('Tracert_interface_select');
		if (wanVal != "")
    	{
			Form.addParameter('x.Interface',wanVal); 
    	}
		Form.addParameter('x.DiagnosticsState',"Requested"); 
		Form.addParameter('x.Host',url); 
		Form.addParameter('x.MaxHopCount',14); 
		Form.addParameter('x.NumberOfTries',3); 
		Form.addParameter('x.Timeout',120000); 
		Form.addParameter('x.DataBlockSize',DataBlockSize);
		Form.addParameter('x.DSCP',0);
        Form.addParameter('RUNSTATE_FLAG.value',CLICK_START_FLAG);
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
        Form.setAction('complex.cgi?x=InternetGatewayDevice.TraceRouteDiagnostics&RUNSTATE_FLAG='+TRACEROUTE_FLAG+'&RequestFile=html/bbsp/maintenance/traceRoute.asp');                                                  
        Form.submit();
	}
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
			getElement('Tracert_result_lable').innerHTML ='<B><FONT color=red>'+'正在进行Tracert测试，请稍等…'+ '</FONT><B>';
			getElement('TraceRouteText').innerHTML =result;						
		}
		TraceRouteState=STATE_DOING_FLAG;
	 }
	 else if( status.indexOf("Complete") >= 0)
	 {
		TraceRouteState=STATE_DONE_FLAG;
		setDisable('Tracert_diag_start_button',0);
		var tmpResult = ChangeRetsult(newString[0]);
		getElement('Tracert_result_lable').innerHTML = '<B><FONT color=red>'+'Tracert Result显示'+ '</FONT><B>';
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
		setDisable('Tracert_diag_start_button',0);
		getElement('Tracert_result_lable').innerHTML ='<B><FONT color=red>'+'Tracert测试失败'+ '</FONT><B>';
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
               }
               else
               {

               }
            }                  

            traceRouteTxt=null;
            

            XHR = null;
       }
    });
}



</script>
<title>TraceRoute Configuration</title>
</head>
<body onload="LoadFrame();" class="mainbody"> 
<form id="TraceRouteForm"> 
    <table width="100%"  border="0" cellpadding="0" cellspacing="0" id="tabTest"> 
      <tr> 
        <td class="prompt"><table width="100%" border="0" cellspacing="0" cellpadding="0"> 
            <tr> 
              <td class="title_common"  BindText='bbsp_diagnose_title2'></td> 
            </tr> 
          </table></td> 
      </tr> 
    </table> 
    <table width="100%" height="5" cellpadding="0" cellspacing="0"> 
      <tr> 
        <td></td> 
      </tr> 
    </table> 
    <table border="0" cellpadding="0" cellspacing="0" id="table_trace" width="100%">
      <tr class="tabal_tr">
        <td class="table_title width_per25">网络连接</td> 
        <td class="table_right"> <select id="Tracert_interface_select" name="Tracert_interface_select" style="width:260px"> 
                  <option value=""></option> 
                  <option value="br0">br0</option> 
                  <script language="JavaScript" type="text/javascript">
		              WriteOptionFortraceRoute();
		          </script> </select>
        </td> 
      </tr>
    <tr class="tabal_tr">
    <td class="table_title">IP版本</td> 
            <td class="table_right"><select id="Tracert_ip_version_select"  name="Tracert_ip_version_select" style="width:260px"> 
                <option value="IPv4">IPv4</option><option value="IPv6">IPv6</option></select>
            </td> 
    </tr> 
      <tr class="tabal_tr">
        <td class="table_title">目的地址</td> 
        <td class="table_right"><input name="Tracert_host_text" type="text" id="Tracert_host_text" style="width:254px"/> <font color="red">*</font> </td> 
      </tr> 
	  <tr class="tabal_tr">
        <td class="table_title">数据块大小</td> 
            <td class="table_right"><input name="TraceRouteDataBlockSize" type="text" value="38" id="TraceRouteDataBlockSize" style="width:254px"/> 
		    <span class="gray"><script>document.write(diagnose_language['bbsp_tracertdatablocksizerange']);</script></span> </td> 
      </tr> 
    </table>
    <br/> 
    <table width="100%" border="0" cellspacing="1" cellpadding="0" id="table_trace_button" class="table_button">  
        <td width="155px"></td>
        <td > 
		<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
		<button  class="submit" name="Tracert_diag_start_button" id= "Tracert_diag_start_button" type="button" onClick="startTraceroute();">开始测试</button></td> 
      </tr> </table> 
    <br/>
    <label name="Tracert_result_lable" id="Tracert_result_lable"></label> 
    <div name="TraceRouteText" id="TraceRouteText"></div> 
    <script>
	setText("TraceRouteDataBlockSize",TracerResult.DataBlockSize);
	setText("Tracert_host_text",TracerResult.Host);
	setSelect("Tracert_interface_select",TracerResult.Interface);
  	</script> 
</form> 
</div> 
</body>
</html>
