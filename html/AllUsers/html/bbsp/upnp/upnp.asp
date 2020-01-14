<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>UPnP</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var enblMainUpnp = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_MainUPnP.Enable);%>';
var enblSlvUpnp = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_SlvUPnP.Enable);%>';

var currentFile= 'upnp.asp';
var listNum = 12;

function changeIp(IP)
{
	var IPAddress = '';
	IP = parseInt(IP,10);
	var IPStr = IP.toString(16);
	if ('' != IPStr)
	{
		if(IPStr.length < 8)
		{
			IPStr = "00000000".substring(0, 8 - IPStr.length) + IPStr; 
		}
		IPAddress = parseInt(IPStr.substring(6,8), 16) + '.' + parseInt(IPStr.substring(4,6), 16) + '.' + parseInt(IPStr.substring(2,4), 16) + '.' + parseInt(IPStr.substring(0,2), 16);
	}
	return IPAddress;
}

function stUpnpPortMapping(PortMappingEnabled, PortMappingLeaseDuration, RemoteHost, ExternalPort, InternalPort, PortMappingProtocol, InternalClient, PortMappingDescription)
{
    this.PortMappingEnabled = PortMappingEnabled;
	this.PortMappingLeaseDuration = PortMappingLeaseDuration;
	this.RemoteHost = changeIp(RemoteHost);
	this.ExternalPort = ExternalPort;
	this.InternalPort = InternalPort;
	this.PortMappingProtocol = PortMappingProtocol;
	this.InternalClient = changeIp(InternalClient);
	this.PortMappingDescription = PortMappingDescription;
	this.IndexNum = 0;
}      

var UpnpPortMapping = <%HW_WEB_GetUpnpPortMap();%>;

var UpnpPortMappingNr = UpnpPortMapping.length-1;

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
		b.innerHTML = upnp_language[b.getAttribute("BindText")];
	}
}

var firstpage = 1;
if(UpnpPortMappingNr == 0)
{
	firstpage = 0;
}

var lastpage = UpnpPortMappingNr/listNum;
if(lastpage != parseInt(lastpage,10))
{
	lastpage = parseInt(lastpage,10) + 1;	
}

var page = firstpage;

if( window.location.href.indexOf("del.cgi") == -1 && window.location.href.indexOf("add.cgi") == -1 && window.location.href.indexOf("set.cgi") == -1 && window.location.href.indexOf("?") > 0 )
{
  page = parseInt(window.location.href.split("?")[1],10); 
}

if(page < firstpage)
{
	page = firstpage;
}
else if( page > lastpage ) 
{
	page = lastpage;
}

function IsValidPage(pagevalue)
{
	if (true != isInteger(pagevalue))
	{
		return false;
	}
	return true;
}

function MakeEnabledStatus(PortMappingEnabled)
{
	if ("1" == PortMappingEnabled)
	{
		return upnp_language['bbsp_enable'];
	}
	else
	{
		return upnp_language['bbsp_disable'];
	}
}
function ShowListControl()
{
	var ColumnNum = 7;
	var UpnpPortMapListlen = 0;
	var TableDataInfo = HWcloneObject(UpnpPortMapping, 1);
	var TablePageDataInfo = new Array();
	
	if(UpnpPortMappingNr == 0)
	{
		HWShowTableListByType(1, "portMappingInst", false, ColumnNum, TableDataInfo, UpnpConfiglistInfo, upnp_language, null);
	}
	else if( UpnpPortMappingNr >= listNum*parseInt(page,10) )
	{
		startIdx = (parseInt(page,10)-1)*listNum;
		endIdx = parseInt(page,10)*listNum;
	    for(i = startIdx; i < endIdx; i++)
		{
			TablePageDataInfo[UpnpPortMapListlen] = new  stUpnpPortMapping();
			TablePageDataInfo[UpnpPortMapListlen].IndexNum = i + 1;
			TablePageDataInfo[UpnpPortMapListlen].PortMappingEnabled = MakeEnabledStatus(TableDataInfo[i].PortMappingEnabled);
			TablePageDataInfo[UpnpPortMapListlen].RemoteHost = TableDataInfo[i].RemoteHost;
			TablePageDataInfo[UpnpPortMapListlen].ExternalPort = TableDataInfo[i].ExternalPort;
			TablePageDataInfo[UpnpPortMapListlen].InternalPort = TableDataInfo[i].InternalPort;
			TablePageDataInfo[UpnpPortMapListlen].PortMappingProtocol = TableDataInfo[i].PortMappingProtocol;
			TablePageDataInfo[UpnpPortMapListlen].InternalClient = TableDataInfo[i].InternalClient;
			TablePageDataInfo[UpnpPortMapListlen].PortMappingDescription = TableDataInfo[i].PortMappingDescription;			
			UpnpPortMapListlen++;
		}
		TablePageDataInfo.length = UpnpPortMapListlen;
		TablePageDataInfo.push(null);
        HWShowTableListByType(1, "portMappingInst", false, ColumnNum, TablePageDataInfo, UpnpConfiglistInfo, upnp_language, null);

	}
	else
	{
		startIdx = (parseInt(page,10)-1)*listNum;
		endIdx = UpnpPortMappingNr;
	    for(i = startIdx; i < endIdx; i++)
		{
			TablePageDataInfo[UpnpPortMapListlen] = new  stUpnpPortMapping();
			TablePageDataInfo[UpnpPortMapListlen].IndexNum = i + 1;
			TablePageDataInfo[UpnpPortMapListlen].PortMappingEnabled = MakeEnabledStatus(TableDataInfo[i].PortMappingEnabled);
			TablePageDataInfo[UpnpPortMapListlen].RemoteHost = TableDataInfo[i].RemoteHost;
			TablePageDataInfo[UpnpPortMapListlen].ExternalPort = TableDataInfo[i].ExternalPort;
			TablePageDataInfo[UpnpPortMapListlen].InternalPort = TableDataInfo[i].InternalPort;
			TablePageDataInfo[UpnpPortMapListlen].PortMappingProtocol = TableDataInfo[i].PortMappingProtocol;
			TablePageDataInfo[UpnpPortMapListlen].InternalClient = TableDataInfo[i].InternalClient;
			TablePageDataInfo[UpnpPortMapListlen].PortMappingDescription = TableDataInfo[i].PortMappingDescription;		
			UpnpPortMapListlen++;
		}
		TablePageDataInfo.length = UpnpPortMapListlen;
		TablePageDataInfo.push(null);
        HWShowTableListByType(1, "portMappingInst", false, ColumnNum, TablePageDataInfo, UpnpConfiglistInfo, upnp_language, null);
	}
}

function submitfirst()
{
	page = firstpage;
	
	if (false == IsValidPage(page))
	{
		return;
	}
	window.location= currentFile + "?" + parseInt(page,10);
}

function submitprv()
{
	if (false == IsValidPage(page))
	{
		return;
	}
	page--;
	window.location = currentFile + "?" + parseInt(page,10);
}

function submitnext()
{
	if (false == IsValidPage(page))
	{
		return;
	}
	page++;
	window.location= currentFile + "?" + parseInt(page,10);
}

function submitlast()
{
	page = lastpage;
	if (false == IsValidPage(page))
	{
		return;
	}
	
	window.location= currentFile + "?" + parseInt(page,10);
}

function submitjump()
{
	var jumppage = getValue('pagejump');
	if((jumppage == '') || (isInteger(jumppage) != true))
	{
		setText('pagejump', '');
		return;
	}
	
	jumppage = parseInt(jumppage, 10);
	if(jumppage < firstpage)
	{
		jumppage = firstpage;
	}
	if(jumppage > lastpage)
	{
		jumppage = lastpage;
	}
	window.location= currentFile + "?" + jumppage;
}

function setControl(index)
{
    var record;
	if (index == -2)
    {
        setDisplay('PortMapConfigForm', 0);
    }
    else
	{
	    setDisplay('PortMapConfigForm', 1);
	    record = UpnpPortMapping[index + (parseInt(page,10) - 1)*listNum];
		var recordInfo = HWcloneObject(record, 1);
		recordInfo.PortMappingEnabled = MakeEnabledStatus(recordInfo.PortMappingEnabled);
		HWSetTableByLiIdList(PortMapConfigFormList, recordInfo, null);
		return;
	}
}

function LoadFrame()
{
    if (enblMainUpnp != '' && enblSlvUpnp != '')
    {
        setCheck('Enable',enblMainUpnp);	
    }
	loadlanguage();
}

function ApplyConfig()
{
	setDisable('buttonApply', 1);
    setDisable('cancelValue', 1);
	
	var SpecUpnpCfgParaList = new Array(new stSpecParaArray("x.Enable", getCheckVal('Enable'), 1),
										new stSpecParaArray("y.Enable", getCheckVal('Enable'), 1));
	var Parameter = {};
	Parameter.asynflag = null;
	Parameter.FormLiList = UpnpConfigFormList;
	Parameter.SpecParaPair = SpecUpnpCfgParaList;
	var tokenvalue = getValue('onttoken');
	var url = 'set.cgi?x=InternetGatewayDevice.X_HW_MainUPnP'
   	              + '&y=InternetGatewayDevice.X_HW_SlvUPnP' + '&RequestFile=html/bbsp/upnp/upnp.asp';
				  
	HWSetAction(null, url, Parameter, tokenvalue);
}

var TableClass = new stTableClass("table_title width_per25", "table_right", "", "");
var TableClass2 = new stTableClass("table_title width_per30", "table_right align_left", "", "");

function CancelConfig()
{
    LoadFrame();
}

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("upnp", GetDescFormArrayById(upnp_language, "bbsp_mune"), GetDescFormArrayById(upnp_language, "bbsp_upnp_title"), false);
</script>
<div class="title_spread"></div>

<form id="ConfigForm">
<table border="0" cellpadding="0" cellspacing="1"  width="100%">
<li   id="Enable"        RealType="CheckBox"      DescRef="bbsp_enableupnpmh"        RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.Enable"   InitValue="Empty"/>
</table>
<script>
UpnpConfigFormList = HWGetLiIdListByForm("ConfigForm");
HWParsePageControlByID("ConfigForm", TableClass, upnp_language, null);
</script>
<table width="100%"  cellpadding="5" cellspacing="0" class="table_button"> 
<tr > 
  <td class="width_per25"></td> 
  <td class="pad_left5p">
	<button id="buttonApply" name="buttonApply" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="ApplyConfig();"><script>document.write(upnp_language['bbsp_app']);</script></button>
	<button name="cancelValue" id="cancelValue" type="button" class="CancleButtonCss buttonwidth_100px" onClick="CancelConfig();"> <script>document.write(upnp_language['bbsp_cancel']);</script></button>
 </td> 
</tr> 
</table> 
</form>
<div class="func_spread"></div>

<script type="text/javascript">
var UpnpConfiglistInfo = new Array(new stTableTileInfo("bbsp_seq","align_center","IndexNum"),
								new stTableTileInfo("bbsp_description","align_center","PortMappingDescription", false, 16),
								new stTableTileInfo("bbsp_extport","align_center","ExternalPort"),
								new stTableTileInfo("bbsp_intport","align_center","InternalPort"),
								new stTableTileInfo("bbsp_proto","align_center","PortMappingProtocol"),
								new stTableTileInfo("bbsp_ip","align_center","InternalClient"),
								new stTableTileInfo("bbsp_state","align_center","PortMappingEnabled"),null);

ShowListControl();
</script>

<form id="PortMapConfigForm" style="display:none">
<div class="list_table_spread"></div>
<table border="0" cellpadding="0" cellspacing="1"  width="100%">
<li   id="Description"    RealType="HtmlText"     DescRef="bbsp_descriptionmh"      RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="PortMappingDescription"   InitValue="Empty"/>
<li   id="Extport"        RealType="HtmlText"     DescRef="bbsp_extportmh"          RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="ExternalPort"  InitValue="Empty"/>                                                                   
<li   id="Intport"        RealType="HtmlText"     DescRef="bbsp_intportmh"          RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="InternalPort"  InitValue="Empty"/>                                                                  
<li   id="Protocol"       RealType="HtmlText"     DescRef="bbsp_protomh"          RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="PortMappingProtocol"  InitValue="Empty"/>                                                                  
<li   id="IP"             RealType="HtmlText"     DescRef="bbsp_ipmh"          RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="InternalClient"  InitValue="Empty"/>                                                                  
<li   id="EndOnIP"        RealType="HtmlText"     DescRef="bbsp_endonIPmh"          RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="RemoteHost"  InitValue="Empty"/>                                                                  
<li   id="State"          RealType="HtmlText"     DescRef="bbsp_statemh"          RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="PortMappingEnabled"  InitValue="Empty"/>
</table>
<script>
PortMapConfigFormList = HWGetLiIdListByForm("PortMapConfigForm");
HWParsePageControlByID("PortMapConfigForm", TableClass2, upnp_language, null);
</script>
</form>
<div id="ConfigForm2"> 
<table cellpadding="0" cellspacing="0"  width="100%" class="table_button"> 
	<tr > 
		<td class='width_per40'></td> 
		<td class='title_bright1' >
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
			<input name="first" id="first" class="PageNext jumppagejumplastbutton_wh_px" type="button" value="<<" onClick="submitfirst();"/> 
			<input name="prv" id="prv"  class="PageNext jumppagejumpbutton_wh_px" type="button" value="<" onClick="submitprv();"/> 
				<script>
					if (false == IsValidPage(page))
					{
						page = (0 == UpnpPortMappingNr) ? 0:1;
					}
					document.write(parseInt(page,10) + "/" + lastpage);
				</script>
			<input name="next"  id="next" class="PageNext jumppagejumpbutton_wh_px" type="button" value=">" onClick="submitnext();"/> 
			<input name="last"  id="last" class="PageNext jumppagejumplastbutton_wh_px" type="button" value=">>" onClick="submitlast();"/> 
		</td>
		<td class='width_per5'></td>
		<td  class='title_bright1'>
			<script> document.write(upnp_language['bbsp_goto']); </script> 
				<input  type="text" name="pagejump" id="pagejump" size="2" maxlength="2" style="width:20px;" />
			<script> document.write(upnp_language['bbsp_page']); </script>
		</td>
		<td class='title_bright1'>
			<input name="jump"  id="jump" class="PageNext jumpbutton_wh_px" type="button" onClick="submitjump();"></td>
			<script> setText("jump",upnp_language["bbsp_jump"]);</script>
		</td>
	</tr> 	 
	<tr> 
	  <td class="height10p"></td> 
	</tr> 
</table> 
</div>
<script language="JavaScript" type="text/javascript">
if(page == firstpage)
{
	setDisable('first',1);
	setDisable('prv',1);
}
if(page == lastpage)
{
	setDisable('next',1);
	setDisable('last',1);
}	
</script>   

</body>
</html>
