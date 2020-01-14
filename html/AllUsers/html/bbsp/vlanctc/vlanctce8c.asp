<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  id="Page" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="Pragma" content="no-cache" />
	<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
 	<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
	<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
    <script language="javascript" src="../../bbsp/common/userinfo.asp"></script>
    <script language="javascript" src="../../bbsp/common/topoinfo.asp"></script>
    <script language="javascript" src="../../bbsp/common/managemode.asp"></script>
	<script language="javascript" src="../../bbsp/common/wan_list_info.asp"></script>
    <script language="javascript" src="../../bbsp/common/wan_list.asp"></script>
    <script language="javascript" src="../../bbsp/common/lanmodelist.asp"></script>
    <script language="javascript" src="../../bbsp/common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>
    <script language="javascript" src="../../bbsp/common/wan_check.asp"></script>
    <script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
    <script language="javascript" src="../../amp/common/wlan_list.asp"></script>
    <script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
    <script>
	
	var MaxVlanPairsPerPort = 4;
	var MaxVlanPairs = 8;
	var SelectIndex = -1;
	var wans = GetWanList();
	var TopoInfo = GetTopoInfo();
	
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
			b.innerHTML = vlan_ctc_language[b.getAttribute("BindText")];
		}
	}
	
	function IsLanPortType(BindInfo)
	{
		if(BindInfo.domain.indexOf("LANEthernetInterfaceConfig") >= 0)
			return true;
		else
			return false;
	}
	

	function BindInfoClass(domain, Mode, Vlan)
	{
		this.domain = domain;
		this.Mode = Mode;
		if(Mode == 1)
			this.Vlan = Vlan.replace(/;/g, ",");
		else
			this.Vlan = "";
		this.PortName = '';
	}
	
	var LanArray = new Array();
	var __LanArray = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.{i},X_HW_Mode|X_HW_VLAN,BindInfoClass);%>;
	var __SSIDArray = '<%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},X_HW_Mode|X_HW_VLAN,BindInfoClass);%>';
	if (__SSIDArray.length > 0) 
	{
		__SSIDArray = eval(__SSIDArray);
	}
	else
	{
		__SSIDArray = new Array(null);
	}

	var wlanstate = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.X_HW_WlanEnable);%>'; 

	for(var i = 0; i < __LanArray.length - 1; i++)
	{
		__LanArray[i].PortName = 'LAN' + __LanArray[i].domain.charAt(__LanArray[i].domain.length-1)
		LanArray.push(__LanArray[i]);
	}
	
	for(var j = 0, SL = GetSSIDList(); (TopoInfo.SSIDNum != 0) && (j < SL.length) ; j++)
	{		
		for(var i = 0; i < __SSIDArray.length - 1; i++)
		{
			if(__SSIDArray[i].domain == SL[j].domain)
			{
				__SSIDArray[i].PortName = "SSID" + getWlanInstFromDomain(SL[j].domain);
				LanArray.push(__SSIDArray[i]);
				
				break;
			}
		}
	}

	function ControlLanWanBind()
	{
		var ISPPortList = GetISPPortList();
		var FeatureInfo = GetFeatureInfo(); 
		
		for (var i = 1; i <= parseInt(TopoInfo.EthNum); i++)
		{
			if (IsL3Mode(i) == "0")
			{
				setDisable("Vlan_Port_checkbox"+i, 1);
			}
		}
		
		for (var i = parseInt(TopoInfo.EthNum)+1; i <= 4; i++)
		{
			setDisplay("DivVlan_Port_checkbox"+i, 0);
		}
	
		var DoubleFreqFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_DOUBLE_WLAN);%>';      
	
		if (1 != DoubleFreqFlag)
		{
			for (var i = parseInt(TopoInfo.SSIDNum)+5; i <= 12; i++)
				{
					setDisplay("DivVlan_Port_checkbox"+i, 0);
				}
		}
		
		if(ISPPortList.length > 0)
		{
			for (var i = 1; i <= parseInt(TopoInfo.SSIDNum); i++)
			{
				var pos = ArrayIndexOf(ISPPortList, 'SSID'+i);
				if(pos >= 0)
				{
					var DivID = i + 4;
					setDisplay("DivVlan_Port_checkbox"+DivID, 0);
				}
			}
		}
		
	
		if(1 == DoubleFreqFlag)
		{
			for (var i = 0; i < WlanList.length; i++)
			{
				var tid = parseInt(i+5);
				if (WlanList[i].bindenable == "0")
				{  
					setDisable("Vlan_Port_checkbox"+tid, 1);
				}
	
				if((WlanList[i].bindenable == "1")&&(enbl5G != 1))
				{			
					if(tid > 8)
					{
						setDisable("Vlan_Port_checkbox"+tid, 1);
					}
				}
				
				if((WlanList[i].bindenable == "1")&&(enbl2G != 1))
				{
					if(tid < 9)
					{
						setDisable("Vlan_Port_checkbox"+tid, 1);
					}
				}
			}
		}
		else
		{
			for (var i = 0; i < WlanList.length; i++)
			{
				var tid = parseInt(i+1+4);
				if (WlanList[i].bindenable == "0")
				{  
					setDisable("Vlan_Port_checkbox"+tid, 1);
				}
			}
		}
	}
		
    function OnPageLoad()
    {
		loadlanguage();
		ControlLanWanBind();
        return true; 
    }

    function IsBindBindVlanValid(BindVlan)
    {   
	var LanVlanWanVlanList = BindVlan.split(",");
	var LanVlan0;
	var WanVlan;
	var TempList;
	var vlanpairnum = 0;
		
	for (var i = 0; i < LanVlanWanVlanList.length; i++)
	{
		TempList = LanVlanWanVlanList[i].split("/");
			
		if (TempList.length != 2)
		{
			AlertEx(vlan_ctc_language['bbsp_vlanpairs']+vlan_ctc_language['bbsp_vlanpainvalid1']);
			return false;
		}
			
		if ((!isNum(TempList[0])) || (!isNum(TempList[1])))
		{
			AlertEx(vlan_ctc_language['bbsp_vlanpairs']+vlan_ctc_language['bbsp_vlanpainvalid1']);
			return false;				
		}
			
		if (!(parseInt(TempList[0],10) >= 1 && parseInt(TempList[0],10) <= 4094))
		{
			AlertEx(vlan_ctc_language['bbsp_vlanpairs']+vlan_ctc_language['bbsp_invlan']+vlan_ctc_language['bbsp_vlanpainvalid1']);
			return false;
		}
			
		if (!(parseInt(TempList[1],10) >= 1 && parseInt(TempList[1],10) <= 4094))
		{
			AlertEx(vlan_ctc_language['bbsp_vlanpairs']+vlan_ctc_language['bbsp_wan_vlan']+vlan_ctc_language['bbsp_vlanpainvalid1']);
			return false;
		}	
		
		vlanpairnum++;
		
		if (vlanpairnum > MaxVlanPairsPerPort)
		{
			AlertEx(vlan_ctc_language['bbsp_vp_per_port_overflow']);
			return false;
		}
	}

	for(var i in LanArray)
	{
		if((LanArray[i].Vlan.length != 0) && ((SelectIndex - 1) != i))
		{
			vlanpairnum += LanArray[i].Vlan.split(",").length;
		}
	}
	
	if (vlanpairnum > MaxVlanPairs)
	{
		AlertEx(vlan_ctc_language['bbsp_vlanpairs_overflow']);
		return false;
	}		
	
	return true;		        
		        
    }
	
    function getSelectUserPort()
	{
		var UserPortStr = "";
		var UserPortId = "";
		for (var i = 1; i <= 8; i++)
		{
			UserPortId = 'Vlan_Port_checkbox' + i;
			if (true == getElement(UserPortId).checked)
			{
				if (i <= 4)
				{
					UserPortStr += "/LAN" + i;
				}
				else
				{
					UserPortStr += "/SSID" + (i - 4);
				}
			}
		}
		UserPortStr = UserPortStr.substring(1,UserPortStr.length);
		return UserPortStr;
	}
	
	function CheckVlanValid(VlanID,filedDesc)
	{
		var errmsg="";
		errmsg=checkVlanID(VlanID,""); 
		if("" != errmsg)
		{
			AlertEx(filedDesc+errmsg);
			return false;
		}
	  return true;
	}

    function CheckParameter(BindVlan, Mode)
    {
		var UserPortList = getSelectUserPort().split('/'); 
	
		if ((Mode == "vlanbinding") && (0 == BindVlan.length) )
		{
			AlertEx(vlan_ctc_language['bbsp_vlanpairs']+vlan_ctc_language['bbsp_vlanisreq']);
			return false;
		}

	   if (Mode == "vlanbinding")
	   {
		   if (IsBindBindVlanValid(BindVlan) == false)
		  {
			  return false;
		  }
	   }

	   for (var i = 0;i < UserPortList.length; i++)
	   {
		   if((UserPortList[i].indexOf("SSID") >= 0) && (1 != wlanstate))
		   {
				AlertEx(vlan_ctc_language['bbsp_vlan_wifi_invalid']);
				return false;
		   }
	   }
	   
	   return true;
    }
    
	function getNewBindVlanInfo()
	{
		var UserVlan = getValue('Vlan_text');
		var wanDomain = getSelectVal('Vlan_WanConnect_select');
		var WanVlan = getWanVlanByDomain(wanDomain);
		var CurBindVlan = UserVlan + '/' + WanVlan;
		var OldBindVlan = "";
		var NewLanArray = new Array();
		var Idx = 0;

		var UserPortList = getSelectUserPort().split('/'); 
		for (var i = 0; i < UserPortList.length; i++) 
		{
			OldBindVlan = "";
			if((UserPortList[i].indexOf("LAN") >= 0)||(UserPortList[i].indexOf("SSID") >= 0))
			{
				for (var j = 0; j < LanArray.length; j++)
				{
					if (UserPortList[i] == LanArray[j].PortName)
					{
						OldBindVlan = LanArray[j].Vlan;
						break;
					}
				}
				if ('' == OldBindVlan)
				{
					NewLanArray[Idx] = new BindInfoClass(LanArray[j].domain,1,CurBindVlan);
				}
				else
				{
					NewLanArray[Idx] = new BindInfoClass(LanArray[j].domain,1,OldBindVlan + ',' + CurBindVlan);
				}
				NewLanArray[Idx].PortName = LanArray[j].PortName;
				Idx++;
			}
		}
		return NewLanArray;
	}
	
	function getWanVlanByDomain(domain)
	{
		var vlan = "";
		for (var i = 0; i < wans.length; i++)
		{
			if (domain == wans[i].domain)
			{
				vlan = wans[i].VlanId;
			}
		}
		return vlan;
	}
	function checkRepeateCfg(userVlan,wanVlan,portList)
	{
		var strVlan = userVlan+"/"+wanVlan;
		for(var i = 0; i < portList.length; i++){
    	    for (var j = 0; j < LanArray.length; j++){
                if (portList[i] == LanArray[j].PortName){
					var LanArrayVlan = LanArray[j].Vlan.split(','); 
					for(var m = 0; m < LanArrayVlan.length; m++)
					{
						if (strVlan == LanArrayVlan[m])
						{
							 AlertEx(vlan_ctc_language['bbsp_vlanBindcfgrepeat']);
							 return false;
						} 
					}
    		    }
    	    }
	    }
	    return true;
	}
	function checkForm()
	{
		var UserVlan = getValue('Vlan_text');
		var UserPortList = getSelectUserPort().split('/'); 
		var wanDomain = getSelectVal('Vlan_WanConnect_select');

		if ('' == getSelectUserPort())
		{
			AlertEx(vlan_ctc_language['bbsp_SelectUserPort']);
			return false;
		}
		if (''== UserVlan)	
		{
			AlertEx(vlan_ctc_language['bbsp_UserVlanReq']);
			return false;
		}
		if(('' != UserVlan)&&(CheckVlanValid(UserVlan,"") == false))
		{
			return false;
		}
		if ('' == wanDomain)
		{
			AlertEx(route_language['bbsp_alert_wan']);
			return false;
		}
		for (var i = 0;i < UserPortList.length; i++)
		{
		   if((UserPortList[i].indexOf("SSID") >= 0) && (1 != wlanstate))
		   {
				AlertEx(vlan_ctc_language['bbsp_vlan_wifi_invalid']);
				return false;
		   }
		}
		var WanVlan = getWanVlanByDomain(wanDomain);
		if(false == checkRepeateCfg(UserVlan,WanVlan,UserPortList))
		{
			return false;
		}

		return true;
	}
    function FillPerBindInfo(Form,newLanArray,prefix)
    {
		var BindVlan = newLanArray.Vlan;
		var vlanpairnum = BindVlan.split(',').length;
		
		if (vlanpairnum > MaxVlanPairsPerPort)
		{
			AlertEx(vlan_ctc_language['bbsp_vp_per_port_overflow']);
			return false;
		}
		Form.addParameter(prefix + '.X_HW_Mode', 1);
        Form.addParameter(prefix + '.X_HW_VLAN', BindVlan);
        return true;
    }

    function OnApplyButtonClick()
    {
		if (false == checkForm())
		{
			return false;
		}
		var NewLanArray = getNewBindVlanInfo();
		var url = "";
		var prefix = "";
		var oldvlanpairnum = 0;
		var addvlanpairnum = NewLanArray.length;
		var newvlanpairnum = 0;
		var Form = new webSubmitForm();
		
		for (var i = 0; i < NewLanArray.length; i++) 
		{
			if ((NewLanArray[i].PortName.indexOf("LAN") >= 0) || (NewLanArray[i].PortName.indexOf("SSID") >= 0))
			{
				url += '&x' + i + '=' + NewLanArray[i].domain;
			}
			prefix = 'x' + i;
			if (FillPerBindInfo(Form, NewLanArray[i],prefix) == false)
			{
				return false;
			}
		}
		
		for (var j = 0; j < LanArray.length; j++) 
		{
			if((LanArray[j].Vlan.length != 0))
			{
				oldvlanpairnum += LanArray[j].Vlan.split(",").length;
			}
		}
		newvlanpairnum = oldvlanpairnum + addvlanpairnum;
		if (newvlanpairnum > MaxVlanPairs)
		{
			AlertEx(vlan_ctc_language['bbsp_vlanpairs_overflow']);
			return false;
		}		
		
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
        Form.setAction('complex.cgi?' +url+ '&RequestFile=html/bbsp/vlanctc/vlanctce8c.asp');   
        Form.submit();
        return false;
    }

    function OnCancelButtonClick()
    {
        document.getElementById("TableUrlInfo").style.display = "none";
        return false;

    } 
 
    function OnChooseDeviceType(Select)
    {
       var Mode = getElementById("ChooseDeviceType").value;
    
       if (Mode == "lanwanbinding")
       {
           getElById("BindVlanRow").style.display = "none";        
       }
       else if (Mode == "vlanbinding")
       {
           getElById("BindVlanRow").style.display = "";
       }
        
    }

	function onClickDel(id)
	{
		var CommonLanArray = getCommonLanListInfo();
		var rmId = id.charAt(id.length-1);
		var vlanPairList = "";
		var BindVlan = "";
		
		for (var i = 0; i < CommonLanArray.length; i++)
		{
			if (rmId != i)
			{
				if (CommonLanArray[rmId].PortName == CommonLanArray[i].PortName)
				{
					vlanPairList += ',' + CommonLanArray[i].Vlan;
				}
			}
		}
		
		BindVlan =  vlanPairList.substring(1,vlanPairList.length);
		var Form = new webSubmitForm();
		Form.addParameter('x.X_HW_Mode', CommonLanArray[rmId].Mode);
        Form.addParameter('x.X_HW_VLAN', BindVlan);
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.setAction('set.cgi?x=' + CommonLanArray[rmId].domain + '&RequestFile=html/bbsp/vlanctc/vlanctce8c.asp');
		Form.submit();
	}
	function getCommonLanListInfo()
	{
		var Idx = 0;
		var CommonLanArray = new Array();
		for (var i = 0; i < LanArray.length; i++)
		{  
		  var UserVlan = "";
		  var WanVlan = "";
		  var vlanPairList = "";
		  var vlanPairNum = 0;

		  if(!((LanArray[i].Vlan == "") || (LanArray[i].Mode == 0)))
		  {
			 vlanPairList = LanArray[i].Vlan.split(',');
			 vlanPairNum = vlanPairList.length;
			 for (var j = 0; j < vlanPairNum; j++)
			 {
				UserVlan = (vlanPairList[j]).split('/')[0];
				WanVlan = (vlanPairList[j]).split('/')[1];
				CommonLanArray[Idx] = new BindInfoClass(LanArray[i].domain,LanArray[i].Mode,UserVlan + '/' + WanVlan);
				CommonLanArray[Idx].PortName = LanArray[i].PortName;
				Idx++;
			 }
		  }
	  }
	  return CommonLanArray;
	}
	
	function showPortName(name)
	{
		var PortName = "";
		switch(name)
		{
			case "LAN1":
				PortName = vlan_ctc_language['bbsp_lan1'];
				break;
			case "LAN2":
				PortName = vlan_ctc_language['bbsp_lan2'];
				break;
			case "LAN3":
				PortName = vlan_ctc_language['bbsp_lan3'];
				break;
			case "LAN4":
				PortName = vlan_ctc_language['bbsp_lan4'];
				break;
			default:
			    PortName = name;
				break;
		}
		return PortName;
	}
	
	function CreateLanList()
	{
		var CommonLanArray = getCommonLanListInfo();
		var HtmlCode = ""; 
		var UserVlan = "";
		var WanVlan = "";
		if (0 == CommonLanArray.length)
		{
			HtmlCode += '<tr id= "record_no" align = "center" class="tabal_01">';
			HtmlCode += '<td >' + '--'+ '</td>';
			HtmlCode += '<td >' + '--'+ '</td>';
			HtmlCode += '<td >' + '--'+ '</td>';
			HtmlCode += '<td >' + '--'+ '</td>';
			HtmlCode += '</tr>'; 
		}
		else
		{
			for (var i = 0; i < CommonLanArray.length; i++)
			{
				HtmlCode += '<tr id= "record_' + i +'" align = "center" class="tabal_01">';
				HtmlCode += '<td >' + showPortName(CommonLanArray[i].PortName) + '</td>';
				if ('' != CommonLanArray[i].Vlan)
				{
					UserVlan = CommonLanArray[i].Vlan.split('/')[0];
					WanVlan = CommonLanArray[i].Vlan.split('/')[1];
					HtmlCode += '<td>' + UserVlan+ '</td>'; 
					HtmlCode += '<td>' + WanVlan+ '</td>';
				}
				else
				{
					HtmlCode += '<td>' + '--'+ '</td>'; 
					HtmlCode += '<td>' + '--'+ '</td>';
				}
				HtmlCode += '<td>' + '<input name="rm" type="button" id="rm' + i +'" onClick="onClickDel(this.id);" value="' + vlan_ctc_language['bbsp_del'] + '"/>'+'</td>';
				HtmlCode += '</tr>'; 
			}
		}
		return HtmlCode;
	}
	
	function setControl(index) 
	{ 
	}

	function WriteOption()
	{
		for (var k = 0; k < wans.length; k++)
		{
		   if ((wans[k].VlanId != 0)&&((wans[k].ServiceList.match("INTERNET"))||(wans[k].ServiceList.match("OTHER"))||(wans[k].ServiceList.match("IPTV"))))
		   {
			   document.write('<option value="' + wans[k].domain + '">' 
							+ MakeWanName1(wans[k]) + '</option>');	 					
		   }	   	 					
		}	
	}
	
    </script>
    <title>LAN VLAN Bind Configuration</title>

</head>
<body  class="mainbody" onload="OnPageLoad();">
<form id="ConfigForm">
<div id="PromptPanel">
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="font-weight: bold;" BindText='bbsp_vlan_ctc_title1'>
			</td>
		</tr>
		<tr>
			<td class='height5p'></td>
		</tr>
		<tr>
			<td class="title_common" BindText='bbsp_vlan_ctc_title2'>
			</td>
		</tr>
        <tr>
        <td class='height10p'></td>
        </tr>
    </table>
</div>

  <table class="tabal_bg" id="tabinfo" border="0" cellspacing="1"  width="100%">
    <tr  class="head_title">
        <td BindText='bbsp_UserPort'></td>
		<td BindText='bbsp_UserVlan'></td>
		<td BindText='bbsp_WanVlan'></td>
        <td BindText='bbsp_del'></td>
     </tr>    
    <script>
   document.write(CreateLanList());              
   </script>  
 </table>
 <table id="tabinfo" border="0" cellspacing="1"  width="100%">
	 <tr>
			<td class='height20p'></td>
	</tr>
 </table>

  <div id="TableUrlInfo" style="display:block">
  <table cellspacing="0" cellpadding="0" border="0" width="100%">
	  <tr class="trTabConfigure" id="BindLanListRow"> 
	 	<td  class="table_title width_per25" BindText='bbsp_UserPort'></td> 
		<td  class="table_right width_per75">
		<span id="DivVlan_Port_checkbox1" ><input id="Vlan_Port_checkbox1" name="Vlan_Port_checkbox1" type="checkbox" value="True"><script>document.write(vlan_ctc_language['bbsp_lan1']);</script> &nbsp;</span>
		<span id="DivVlan_Port_checkbox2" ><input id="Vlan_Port_checkbox2" name="Vlan_Port_checkbox2" type="checkbox" value="True"><script>document.write(vlan_ctc_language['bbsp_lan2']);</script> &nbsp;</span>
		<span id="DivVlan_Port_checkbox3" ><input id="Vlan_Port_checkbox3" name="Vlan_Port_checkbox3" type="checkbox" value="True"><script>document.write(vlan_ctc_language['bbsp_lan3']);</script> &nbsp;</span>
        <span id="DivVlan_Port_checkbox4" ><input id="Vlan_Port_checkbox4" name="Vlan_Port_checkbox4" type="checkbox" value="True"><script>document.write(vlan_ctc_language['bbsp_lan4']);</script> &nbsp;</span>
		</br>
		<span id="DivVlan_Port_checkbox5" ><input id="Vlan_Port_checkbox5" name="Vlan_Port_checkbox5" type="checkbox" value="True"><script>document.write(vlan_ctc_language['bbsp_ssid1']);</script> &nbsp;</span>
        <span id="DivVlan_Port_checkbox6" ><input id="Vlan_Port_checkbox6" name="Vlan_Port_checkbox6" type="checkbox" value="True"><script>document.write(vlan_ctc_language['bbsp_ssid2']);</script> &nbsp;</span>
        <span id="DivVlan_Port_checkbox7" ><input id="Vlan_Port_checkbox7" name="Vlan_Port_checkbox7" type="checkbox" value="True"><script>document.write(vlan_ctc_language['bbsp_ssid3']);</script> &nbsp;</span>
        <span id="DivVlan_Port_checkbox8" ><input id="Vlan_Port_checkbox8" name="Vlan_Port_checkbox8" type="checkbox" value="True"><script>document.write(vlan_ctc_language['bbsp_ssid4']);</script> &nbsp;</span>
		</td> 
	  </tr>
    <tr class="trTabConfigure">
    	<td  class="table_title width_per25 align_left" BindText='bbsp_UserVlan'></td>
		<td  class="table_right"><input name="Vlan_text" type="text" id="Vlan_text" maxlength="4" size="4"><font color="red">*</font><span class="gray"><script>document.write(vlan_ctc_language['bbsp_mvlanidrange']);</script></span> </td> 
    </tr>
    <tr > 
	  <td  class="table_title" BindText='bbsp_BindWanName'></td> 
	  <td  class="table_right"> <select name='Vlan_WanConnect_select'  id="Vlan_WanConnect_select" maxlength="30" size="1"> 
		  <script language="javascript">
			   WriteOption();
			</script> 
		</select> </td> 
	</tr> 
  </table>
	<table class="table_button" cellspacing="1" id="cfg_table" width="100%"> 
      <tr align="right">
	    <td class="width_per20"></td>
        <td> 
		  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
		  <button id="addButton" name="addButton" type="button" class="submit" onClick="javascript:return OnApplyButtonClick();"><script>document.write(vlan_ctc_language['bbsp_app']);</script></button>
		</td> 
      </tr>   
    </table>
</div>

</form>
<script>
</script>

</body>
</html>


