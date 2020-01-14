<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<title>igmp</title>
<script language="javascript" src="../../bbsp/common/managemode.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_check.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">

function stIGMPInfo(domain,IGMPEnable,ProxyEnable,SnoopingEnable,Robustness,GenQueryInterval,GenResponseTime,SpQueryNumber,SpQueryInterval,SpResponseTime,STBNumber)
{
    this.domain = domain;
    this.IGMPEnable = IGMPEnable;
    this.ProxyEnable = ProxyEnable;
    this.SnoopingEnable = SnoopingEnable;
    this.Robustness = Robustness;
    this.GenQueryInterval = GenQueryInterval;
    this.GenResponseTime = GenResponseTime;
    this.SpQueryNumber = SpQueryNumber;
    this.SpQueryInterval = SpQueryInterval;
    this.SpResponseTime = SpResponseTime;
	this.STBNumber = STBNumber;
}
var IGMPInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.X_HW_IPTV, IGMPEnable|ProxyEnable|SnoopingEnable|Robustness|GenQueryInterval|GenResponseTime|SpQueryNumber|SpQueryInterval|SpResponseTime|STBNumber,stIGMPInfo);%>; 
var IGMPInfo = IGMPInfos[0];

var IPv4Enableflag = 0 ;
var currentdomain = "";

function filterWan(wan)
{
	if(((wan.IPv4Enable=="0")&&(wan.IPv6Enable == "1")) || (wan.ServiceList =="TR069") || (wan.ServiceList == "VOIP")|| (wan.ServiceList =="TR069_VOIP") || ( '0' == FeatureInfo.RouteWanMulticastIPoE && "IP_ROUTED" == wan.Mode.toString().toUpperCase()) || ('0' == FeatureInfo.BridgeWanMulticast && ("IP_BRIDGED" == wan.Mode.toString().toUpperCase() || "PPPOE_BRIDGED" == wan.Mode.toString().toUpperCase())) )
	{
		return false;
	}
	return true;
}

var WanInfo = GetWanListByFilter(filterWan);

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
		b.innerHTML = igmp_language[b.getAttribute("BindText")];
	}
}

function WriteOption()
{
	for (i = 0; i < WanInfo.length; i++)
	{
		document.write('<option id="wan_' + i + '" value="' + WanInfo[i].domain + '">' + MakeWanName1(WanInfo[i]) + '</option>');
	}    
}

function getWanIndexByDomain(domain)
{
	var index = -1;
	for (var i = 0;i < WanInfo.length;i++)
	{
		if (domain == WanInfo[i].domain)
		{
			index = i;
		}
	}
	return index;
}

function onWanNameChange()
{
	if (WanInfo.length > 0)
	{
		var index = getWanIndexByDomain(getSelectVal('InterfaceSelect_select'));
		if (1 == WanInfo[index].IPv4Enable)
		{
			setText('MulticastSettings_text',WanInfo[index].IPv4WanMVlanId);
		}
	}
}

function CheckVlanValid(VlanID,filedDesc)
{
	var errmsg="";
	errmsg=checkVlanID(VlanID,""); 
	if(""!=errmsg)
	{
	   AlertEx(filedDesc+errmsg);
	   return false;
	}
	return true;
}

function checkForm()
{
	if (WanInfo.length == 0)
	{
		AlertEx(route_language['bbsp_alert_wan']);
		return false;
	}
	var MVlanID = getValue('MulticastSettings_text');
	currentdomain = getSelectVal('InterfaceSelect_select');
	var index = getWanIndexByDomain(currentdomain);
	IPv4Enableflag = WanInfo[index].IPv4Enable;
	
	if (( "" != MVlanID) && (IPv4Enableflag == 1 ))
	{
		if(CheckVlanValid(MVlanID,igmp_language['bbsp_ipv4multicast']) == false)
		{
			return false;
		}

	}
	return true;
}
function IgmpModeChange()
{
	var enableIgmpSnooping = (true == getElement('IGMPSnooping_checkbox').checked) ? 1 : 0;
	var enableIgmpProxy = (true == getElement('IGMPProxy_checkbox').checked) ? 1 : 0;
	var Form = new webSubmitForm();
	Form.addParameter('x.ProxyEnable',enableIgmpProxy);
	Form.addParameter('x.SnoopingEnable',enableIgmpSnooping);
	if(enableIgmpSnooping || enableIgmpProxy){
	    Form.addParameter('x.IGMPEnable',1);
	}else{
	    Form.addParameter('x.IGMPEnable',0);
	}
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('complex.cgi?x=InternetGatewayDevice.Services.X_HW_IPTV' + '&RequestFile=html/bbsp/igmp/igmpe8c.asp');
	Form.submit();
}
function OnSave()
{
	var MVlanID;

	
	if (false == checkForm())
	{
		return false;
	}
	
	var Form = new webSubmitForm();	
	
	if (1 == IPv4Enableflag)
	{
		MVlanID = (getValue('MulticastSettings_text') != "") ? getValue('MulticastSettings_text') : 0xFFFFFFFF;
		Form.addParameter('y.X_HW_MultiCastVLAN',MVlanID);
	}
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('complex.cgi?y='+currentdomain + '&RequestFile=html/bbsp/igmp/igmpe8c.asp');
	setDisable('Save_button',1);
	Form.submit();
}

function LoadFrame()
{
	onWanNameChange();
	if ( null != IGMPInfo )
	{
		getElement('IGMPSnooping_checkbox').checked = false;
		getElement('IGMPProxy_checkbox').checked = false;
		if('1' == IGMPInfo.IGMPEnable){
			if('1' == IGMPInfo.SnoopingEnable)
			{
				getElement('IGMPSnooping_checkbox').checked = true;
			}
			if('1' == IGMPInfo.ProxyEnable)
			{
				getElement('IGMPProxy_checkbox').checked = true;
			}
		}
	}
	
	loadlanguage();
}
</script>
<body onLoad="LoadFrame();" class="mainbody"> 
<form id="ConfigForm"> 
  <table width="100%" border="0" cellpadding="0" cellspacing="1"> 
	  <tr> 
		<td class="title_common" width="100%"><script>document.write(igmp_language['bbsp_igmp_title1']);</script></td> 
	  </tr> 
	  <tr> 
		  <td class="height10p"></td> 
	  </tr> 
  </table> 

	<table cellpadding="0" cellspacing="0" width="100%"> 
		<tr> 
			<td class="table_title"> <input type='checkbox' value='True' id='IGMPSnooping_checkbox' name='IGMPSnooping_checkbox' onclick="IgmpModeChange()"> <script>document.write(igmp_language['bbsp_enableIgmpSnooping']);</script></td> 
		</tr>
		<tr> 
			<td class="table_title"> <input type='checkbox' value='True' id='IGMPProxy_checkbox' name='IGMPProxy_checkbox' onclick="IgmpModeChange()"> <script>document.write(igmp_language['bbsp_enableIgmpProxy']);</script></td> 
		</tr>
		<tr> 
		  <td class="height20p"></td> 
	    </tr> 
	</table>
	
	 <table cellpadding="0" cellspacing="1" width="100%"> 
		<label id="MulticastVLAN_lable" class="align_left" width="100%" style="font-weight: bold;"><script>document.write(igmp_language['bbsp_MultiVlan']);</script></label> 
		<tr> 
		  <td class="height10p"></td> 
	    </tr> 
		<table cellpadding="0" cellspacing="0" width="100%"> 
			<tr> 
				<td  width="25%" class="table_title" BindText='bbsp_wanname'></td> 
				<td  width="75%" class="table_right"> 
					<select id="InterfaceSelect_select" name="InterfaceSelect_select" maxlength="30" onChange="onWanNameChange();"> 
						<script language="javascript">
							WriteOption();
						</script> 
					</select> 
				</td> 
			</tr> 
			<tr> 
				<td width="25%" class="table_title"><script>document.write(igmp_language['bbsp_MultiVlan']);</script></td> 
				<td width="75%" class="table_right"> <input type='text' id="MulticastSettings_text" name="MulticastSettings_text" maxlength='15'></td> 
			</tr> 
		</table>
	</table>
	
	<table width="100%" border="0"  class="table_button"> 
		<tr align="right">
			<td >
				<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
				<button id="Save_button" type="button" class="submit" onClick="OnSave();"><script>document.write(igmp_language['bbsp_save']);</script></button>
			</td>
		</tr> 
	</table> 
</form>
</body>
</html>