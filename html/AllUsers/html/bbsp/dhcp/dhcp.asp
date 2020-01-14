<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<title>DHCP Configure</title>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="JavaScript" type="text/javascript">
var curUserType='<%HW_WEB_GetUserType();%>';
var curCfgModeWord ='<%HW_WEB_GetCfgMode();%>'; 
var sysUserType='0';
var CfgModeWord ='<%HW_WEB_GetCfgMode();%>'; 
var norightslavepool='<%HW_WEB_GetFeatureSupport(FT_NOMAL_NO_RIGHT_SLAVE_POOL);%>';
var conditionpoolfeature ='<%HW_WEB_GetFeatureSupport(BBSP_FT_DHCPS_COND_POOL);%>';
var businesswlan ='<%HW_WEB_GetFeatureSupport(HW_BUSINESS_WLAN_ENABLE);%>';
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
		b.innerHTML = dhcp_language[b.getAttribute("BindText")];
	}
}

function stLanHostInfo(domain,enable,ipaddr,subnetmask,AddressConflictDetectionEnable)
{
	this.domain = domain;
	this.enable = enable;
	this.ipaddr = ipaddr;
	this.subnetmask = subnetmask;
	this.AddressConflictDetectionEnable = AddressConflictDetectionEnable;
}

function PolicyRouteItem(_Domain, _Type, _VenderClassId, _WanName)
{
    this.Domain = _Domain;
    this.Type = _Type;
    this.VenderClassId = _VenderClassId;
    this.WanName = _WanName;
}

function SlaveDhcpInfo(domain, enable)
{
	this.domain    = domain;
	this.enable    = enable;
}

function GetPolicyRouteListLength(PolicyRouteList, Type)
{
	var Count = 0;

	if (PolicyRouteList == null)
	{
		return 0;
	}

	for (var i = 0; i < PolicyRouteList.length; i++)
	{
		if (PolicyRouteList[i] == null)
		{
			continue;
		}

		if (PolicyRouteList[i].Type == Type)
		{
			Count++;
		}
	}

	return Count;
}
	
var LanHostInfos = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_FilterSlaveLanHostIp, InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},Enable|IPInterfaceIPAddress|IPInterfaceSubnetMask|X_HW_AddressConflictDetectionEnable,stLanHostInfo);%>;
var LanHostInfo2 = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_FilterSlaveLanHostIp, InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.2,Enable|IPInterfaceIPAddress|IPInterfaceSubnetMask|X_HW_AddressConflictDetectionEnable,stLanHostInfo);%>;
var PolicyRouteListAll = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_FilterPolicyRoute, InternetGatewayDevice.Layer3Forwarding.X_HW_policy_route.{i},PolicyRouteType|VenderClassId|WanName,PolicyRouteItem);%>;  
var SlaveDhcpInfos = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaSlaveDhcpPool, InternetGatewayDevice.X_HW_DHCPSLVSERVER,DHCPEnable,SlaveDhcpInfo);%>;
var LanHostInfo = LanHostInfos[0];
var SlaveIpAddr = "";
var SlaveIpMask = "";
if (LanHostInfos[1] != null)
{
    SlaveEnable = LanHostInfos[1].enable;
	SlaveIpAddr = LanHostInfos[1].ipaddr;
	SlaveIpMask = LanHostInfos[1].subnetmask;
}
else if(LanHostInfos[1] == null && LanHostInfo2[0] != null && '1' == conditionpoolfeature)
{
	SlaveEnable = LanHostInfo2[0].enable;
	SlaveIpAddr = LanHostInfo2[0].ipaddr;
	SlaveIpMask = LanHostInfo2[0].subnetmask;
}
function setAllDisable()
{
	setDisable('ethIpAddress',1);
	setDisable('ethSubnetMask',1);
	setDisable('enableslaveaddress',1);
	setDisable('slaveIpAddress',1);
	setDisable('slaveSubnetMask',1);
	setDisable('btnApply',1);
	setDisable('cancelValue',1);
}

function LoadFrame() 
{
    with ( document.forms[0] ) 
    {
		setText('ethIpAddress',LanHostInfo.ipaddr);
		setText('ethSubnetMask',LanHostInfo.subnetmask);
		setCheck('enableFreeArp', LanHostInfo.AddressConflictDetectionEnable);
		
		if (LanHostInfos[1] != null)
		{    
		    setCheck('enableslaveaddress',LanHostInfos[1].enable);
			setText('slaveIpAddress', LanHostInfos[1].ipaddr);
			setText('slaveSubnetMask',LanHostInfos[1].subnetmask);
		}
		else if(LanHostInfos[1] == null && LanHostInfo2[0] != null && '1' == conditionpoolfeature)
		{
			setCheck('enableslaveaddress',LanHostInfo2[0].enable);
			setText('slaveIpAddress', LanHostInfo2[0].ipaddr);
			setText('slaveSubnetMask',LanHostInfo2[0].subnetmask);
		}
		
		if (((GetCfgMode().PCCWHK == "1" || 'TELECOM' == CfgModeWord.toUpperCase()) && (curUserType != sysUserType))
            || (GetCfgMode().PTVDFB == "1"))
		{
			setAllDisable();
		}
		
		if((CfgModeWord.toUpperCase() == "TELMEX") || (GetCfgMode().PCCWHK == "1") || ('DT_HUNGARY' == curCfgModeWord.toUpperCase())
	       || ((curUserType != sysUserType) && (curCfgModeWord.toUpperCase() == "RDSGATEWAY"))
		   ||((curUserType != sysUserType) && (curCfgModeWord.toUpperCase() == "PTVDF")))
	    {
			if(curUserType == sysUserType && GetCfgMode().PCCWHK == "1")
			{
				setDisplay('SecondaryDhcp', 1);
			}
			else
			{
				setDisplay('SecondaryDhcp', 0);
			}
	    }
		else
		{
			setDisplay('SecondaryDhcp', 1);
		}
		configEnableSaddress();
    }
    
    
		
    if (true == IsSupportConfigFreeArp())
    {   
    	setDisplay('ConfigFreeArp', 1);
		setDisplay('ConfigFreeArpSpace', 1);
    }
    else
    {
    	setDisplay('ConfigFreeArp', 0);
		setDisplay('ConfigFreeArpSpace', 0);
    }
}

function CheckForm(type) 
{
   var result = false;

   var enableslavevalue = getCheckVal('enableslaveaddress');
   with ( document.forms[0] ) 
   {
      if ( isValidIpAddress(ethIpAddress.value) == false ) {
         AlertEx(dhcp_language['bbsp_ipmhaddrp'] + ethIpAddress.value + dhcp_language['bbsp_isinvalidp']);
         return false;
      }
      if ( isValidSubnetMask(ethSubnetMask.value) == false ) {
         AlertEx(dhcp_language['bbsp_subnetmaskmh'] + ethSubnetMask.value + dhcp_language['bbsp_isinvalidp']);
         return false;
      }
      if ( isMaskOf24BitOrMore(ethSubnetMask.value) == false ) 
      {
          AlertEx(dhcp_language['bbsp_subnetmaskmh'] + ethSubnetMask.value + dhcp_language['bbsp_isinvalidp']);
          return false;
      }
      
      if(isHostIpWithSubnetMask(ethIpAddress.value, ethSubnetMask.value) == false)
      {
          AlertEx(dhcp_language['bbsp_ipmhaddrp'] + ethIpAddress.value + dhcp_language['bbsp_isinvalidp']);
          return false;
      }
      if ( isBroadcastIp(ethIpAddress.value, ethSubnetMask.value) == true ) {
         AlertEx(dhcp_language['bbsp_ipmhaddrp'] + ethIpAddress.value + dhcp_language['bbsp_isinvalidp']);
         return false;
      }
      if((CfgModeWord.toUpperCase() == "TELMEX") 
	      || ((GetCfgMode().PCCWHK == "1") && (curUserType != sysUserType)) 
		  || ('DT_HUNGARY' == curCfgModeWord.toUpperCase())
          || ((curUserType != sysUserType) && (curCfgModeWord.toUpperCase() == "RDSGATEWAY"))
          ||((curUserType != sysUserType) && (curCfgModeWord.toUpperCase() == "PTVDF")))
	  {
	  }
	  else
	  {
		   if(enableslavevalue == '0')
		   {
		   }
		   else
		   {
		   	   if ( isValidIpAddress(slaveIpAddress.value) == false ) {
				 AlertEx(dhcp_language['bbsp_ipaddrp'] + slaveIpAddress.value + dhcp_language['bbsp_isinvalidp']);
				 return false;
			  }
			  if ( isValidSubnetMask(slaveSubnetMask.value) == false ) {
				 AlertEx(dhcp_language['bbsp_subnetmaskp'] + slaveSubnetMask.value + dhcp_language['bbsp_isinvalidp']);
				 return false;
			  }
			  if ( isMaskOf24BitOrMore(slaveSubnetMask.value) == false ) 
			  {
				  AlertEx(dhcp_language['bbsp_subnetmaskp'] + slaveSubnetMask.value + dhcp_language['bbsp_isinvalidp']);
				  return false;
			  }
			  
			  if(isHostIpWithSubnetMask(slaveIpAddress.value, slaveSubnetMask.value) == false)
			  {
				  AlertEx(dhcp_language['bbsp_ipaddrp'] + slaveIpAddress.value + dhcp_language['bbsp_isinvalidp']);
				  return false;
			  }
			  if ( isBroadcastIp(slaveIpAddress.value, slaveSubnetMask.value) == true ) {
				 AlertEx(dhcp_language['bbsp_ipaddrp'] + slaveIpAddress.value + dhcp_language['bbsp_isinvalidp']);
				 return false;
			  }
		   }
	
	  }
	  //不论使能DHCP备用服务器，都需要判断从地址IP地址和掩码是否符合规范。只有从地址池不使能，才不会去判断
	if(enableslavevalue == '1')
	{
	  if (slaveIpAddress.value == ethIpAddress.value) 
	  {
          AlertEx(dhcp_language['bbsp_pridhcpsecdhcp']);		  
		  return false;
	  }
			
	  if(true==isSameSubNet(ethIpAddress.value, ethSubnetMask.value,slaveIpAddress.value,slaveSubnetMask.value))
	  {
	      AlertEx(dhcp_language['bbsp_pridhcpsecdhcp']);		
		  return false;
	  }
	}

	  if(( getValue('ethIpAddress').split(".")[3] > 127 ) && ( GetCfgMode().PCCWHK == "1" ) && (curUserType != sysUserType))
	  {
		  AlertEx(dhcp_language['bbsp_iprangeinvalid']);
          return false;   				
	  }
    } 

    var Reboot = (GetPolicyRouteListLength(PolicyRouteListAll, "SourceIP") > 0 && getValue('ethIpAddress') != LanHostInfos[0].ipaddr) ? dhcp_language['bbsp_resetont']:"";
	var CmcWifi = (businesswlan == 1 ? dhcp_language['bbsp_cmc_wifi_inform'] :"");
	result = true;
	if (getValue('ethIpAddress') != LanHostInfos[0].ipaddr)
	{
		result = ConfirmEx(dhcp_language['bbsp_dhcpconfirmnote']+CmcWifi+Reboot);
	}

	if ( result == true )
	{
		setDisable('btnApply', 1);
        setDisable('cancelValue', 1);
	}
	
	return result;
}

function AddPreParameter(data)
{
	var Onttoken = getValue('onttoken');
	
	$.ajax({
	type : "POST",
	async : false,
	cache : false,
	data : 'o.Enable=' + data  + '&x.X_HW_Token=' + Onttoken,
	url :  'set.cgi?o=InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.2'
		   + '&RequestFile=html/ipv6/not_find_file.asp',
	error:function(XMLHttpRequest, textStatus, errorThrown) 
	{
		if(XMLHttpRequest.status == 404)
		{
		}
	}
	});	
}

function AddSubmitParam(Form,type)
{
	var RequestFile = 'html/bbsp/dhcp/dhcp.asp';
	var enableslave = getCheckVal('enableslaveaddress');

	if(!(( 'TELECOM' == CfgModeWord.toUpperCase()) && (curUserType != sysUserType)))
	{
		with (document.forms[0])
		{	 
			Form.addParameter('x.IPInterfaceIPAddress',getValue('ethIpAddress'));
			Form.addParameter('x.IPInterfaceSubnetMask',getValue('ethSubnetMask'));
			if (true == IsSupportConfigFreeArp())
			{
				Form.addParameter('x.X_HW_AddressConflictDetectionEnable',getCheckVal('enableFreeArp'));
				if((1 == norightslavepool) && (curUserType != sysUserType))
				{
					
				}
				else
				{
					Form.addParameter('z.X_HW_AddressConflictDetectionEnable',getCheckVal('enableFreeArp'));
				}
			}
			
			if((CfgModeWord.toUpperCase() == "TELMEX") || (GetCfgMode().PCCWHK == "1") || ('DT_HUNGARY' == curCfgModeWord.toUpperCase())
	           || ((curUserType != sysUserType) && (curCfgModeWord.toUpperCase() == "RDSGATEWAY"))
		       ||((curUserType != sysUserType) && (curCfgModeWord.toUpperCase() == "PTVDF")))
			{
				if(curUserType == sysUserType && GetCfgMode().PCCWHK == "1")
				{
					AddPreParameter(enableslave);
					if (enableslave == '1')
					{
						Form.addParameter('z.IPInterfaceIPAddress',getValue('slaveIpAddress'));
						Form.addParameter('z.IPInterfaceSubnetMask',getValue('slaveSubnetMask'));
					}
				}
			}
			else
			{
				AddPreParameter(enableslave);
			    if (enableslave == '1')
			    {
					Form.addParameter('z.IPInterfaceIPAddress',getValue('slaveIpAddress'));
					Form.addParameter('z.IPInterfaceSubnetMask',getValue('slaveSubnetMask'));
			    }
				
			}
			Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		}	
	
		var url = 'set.cgi?'
				  + 'x=InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.1'
				  + '&z=InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.2'
				  + '&RequestFile=' + RequestFile;
	
		Form.setAction(url);
	}
	setDisable('dhcpSrvType',1);
}	

var DhcpsFeature = "<% HW_WEB_GetFeatureSupport(BBSP_FT_DHCP_MAIN);%>";
var CfgModeValue = '<%HW_WEB_GetCfgMode();%>';
function IsSupportConfigFreeArp()
{
    if(DhcpsFeature == "0")
    {
    	return false;
    }
    
    if((CfgModeValue.toUpperCase() == 'COMMON') || (CfgModeValue.toUpperCase() == 'SINGTEL') || (CfgModeValue.toUpperCase() == 'M1'))
    {
	return true;
    }
    
    return false;
}

function CancelConfig()
{
    LoadFrame();
}

function configFreeArp()
{
    var enable = getCheckVal('enableFreeArp');
}

function configEnableSaddress()
{
    var enableslaveaddress = getCheckVal('enableslaveaddress');
	setDisplay('slaveip', enableslaveaddress);
	setDisplay('slavemask', enableslaveaddress);
}

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<form id="ConfigForm" action="" > 
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("dhcptitle", GetDescFormArrayById(dhcp_language, ""), GetDescFormArrayById(dhcp_language, ""), false);
	if (DhcpsFeature == "1" && bin5board() == false)
	{
	  if (true == IsSupportConfigFreeArp())
	  {
		document.getElementById("dhcptitle_content").innerHTML = dhcp_language['bbsp_dhcp_title']+dhcp_language['bbsp_dhcp_title1']+dhcp_language['bbsp_dhcp_title2'];
	  }
	  else
	  {
		document.getElementById("dhcptitle_content").innerHTML = dhcp_language['bbsp_dhcp_title']+dhcp_language['bbsp_dhcp_title1'];
	  }
	}
	else
	{
	  document.getElementById("dhcptitle_content").innerHTML = dhcp_language['bbsp_dhcp_title'];
	}
</script> 
<div class="title_spread"></div>

  <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
      <tr id='ConfigFreeArp'> 
      <td  class="table_title width_per30" BindText = 'bbsp_enablefreearpmh'></td> 
      <td  class="table_right width_per70" > <input type='checkbox' value=0 id='enableFreeArp' name='enableFreeArp' onClick='configFreeArp();'> </td> 
    </tr>
  </table>
  <div id="ConfigFreeArpSpace" class="func_spread"></div>
  
  <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
      <tr class="head_title"> 
        <td class='align_left' colspan="2" BindText = 'bbsp_dhcp_pripool'></td> 
      </tr> 
    <tr> 
      <td  class="table_title width_per30" BindText='bbsp_ipmh_common'></td> 
      <td  class="table_right width_per70"> <input type='text' id='ethIpAddress' name='ethIpAddress' maxlength='15'> 
        <font color="red">*</font> </td> 
    </tr> 
    <tr> 
      <td  class="table_title width_per30" BindText='bbsp_maskmh_common'></td> 
      <td  class="table_right width_per70"> <input type='text' id='ethSubnetMask' name='ethSubnetMask' maxlength='15'> 
        <font color="red">*</font> </td> 
    </tr>   
    <tr class="trTabConfigure align_left" style="display:none "> 
      <td class="table_title" BindText='bbsp_enableser'></td> 
      <td colspan="3"> </td> 
    </tr>
  </table>
  
  <div id='SecondaryDhcp' style="display:none">
  <div class="func_spread"></div>
  <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
      <tr class="head_title"> 
	<script LANGUAGE="JavaScript"> 
	   document.write('<td class="align_left" colspan="2" BindText = ' + '\''+ 'bbsp_dhcp_secpool'+ '\'' + '></td>'); 
	</script>
      </tr> 
	<tr > 
      <td  class="table_title width_per30" BindText = 'bbsp_enableslaveaddress'></td> 
      <td  class="table_right width_per70" > <input type='checkbox' value=0 id='enableslaveaddress' name='enableslaveaddress' onClick='configEnableSaddress();'> </td>
      <script LANGUAGE="JavaScript"> 
		 getElById("SecondaryDhcp").title = dhcp_language['bbsp_dhcp_slave_enable'];
     </script>	  
    </tr>
	<tr id="slaveip"> 
      <td  class="table_title width_per30" BindText='bbsp_ipslavemh'></td> 
      <td  class="table_right width_per70"> <input type='text' id='slaveIpAddress' name='slaveIpAddress' maxlength='15'> 
        <font color="red">*</font> </td> 
    </tr> 
    <tr id="slavemask"> 
      <td  class="table_title width_per30" BindText='bbsp_maskslavemh'></td> 
      <td  class="table_right width_per70"> <input type='text' id='slaveSubnetMask' name='slaveSubnetMask' maxlength='15'> 
        <font color="red">*</font> </td> 
    </tr>
  </table>
</div>  
  <div id='dhcpInfo' style="display:none "> 
    <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg"> 
      <tr> 
        <td  class="table_title width_per25" BindText='bbsp_startipmh'></td> 
        <td  class="table_right width_per70"> <input type='text' id='dhcpEthStart' name='dhcpEthStart' maxlength='15'> </td> 
      </tr> 
      <tr> 
        <td  class="table_title width_per25" BindText='bbsp_endipmh'></td> 
        <td  class="table_right width_per70"> <input type='text' id='dhcpEthEnd' name='dhcpEthEnd' maxlength='15'> </td> 
      </tr> 
      <tr > 
        <td  class="table_title width_per25" BindText='bbsp_leaseunitmh'></td> 
        <td  class="table_right width_per70"> <input type="text" id="dhcpLeasedTime" name="dhcpLeasedTime" value="1" size="6"> 
          <select id='dhcpLeasedTimeFrag' name='dhcpLeasedTimeFrag' size='1'> 
            <option value='60'><script>document.write(dhcp_language['bbsp_minute']);</script>
            <option value='3600'><script>document.write(dhcp_language['bbsp_hou']);</script>
            <option value='86400'><script>document.write(dhcp_language['bbsp_day']);</script>
            <option value='604800'><script>document.write(dhcp_language['bbsp_week']);</script>
          </select> </td> 
      </tr> 
      <tr  style="display:none "> 
        <td  class="table_title width_per25" BindText='bbsp_devtypemh' ></td> 
        <td  class="table_right width_per70"> <select id='IpPoolIndex' name='IpPoolIndex' size='15' onChange='IpPoolIndexChange()'> 
            <option value='1'><script>document.write(dhcp_language['bbsp_stb']);</script>
            <option value='2'><script>document.write(dhcp_language['bbsp_phone']);</script>
            <option value='3'><script>document.write(dhcp_language['bbsp_camera']);</script>
            <option value='4'><script>document.write(dhcp_language['bbsp_computer']);</script>
          </select> </td> 
      </tr> 
      <tr  style="display:none "> 
        <td  class="table_title width_per25" BindText='bbsp_startipmh'></td> 
        <td  class="table_right width_per70"> <input type='text' id='dhcpEthStartFrag' name='dhcpEthStartFrag' maxlength='15'> </td> 
      </tr> 
      <tr style="display:none "> 
        <td  class="table_title width_per25" BindText='bbsp_endipmh'></td> 
        <td  class="table_right width_per70"> <input type='text' id='dhcpEthEndFrag' name='dhcpEthEndFrag' maxlength='15'> </td> 
      </tr> 
      <tr style="display:none "> 
        <td  class="table_title width_per25" BindText='bbsp_dhcprelaymh'></td> 
        <td  class="table_right width_per70"> <input type='checkbox' id='enableRelay' name='enableRelay'> </td> 
      </tr> 
    </table> 
  </div> 
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button"> 
    <tr > 
      <td class='width_per30'></td> 
      <td class="table_submit"> 
	    <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	    <button id="btnApply" name="btnApply" type="button" class="ApplyButtoncss buttonwidth_100px"  onClick="Submit(0);"><script>document.write(dhcp_language['bbsp_app']);</script></button> 
        <button name="cancelValue" id="cancelValue" class="CancleButtonCss buttonwidth_100px"  type="button" onClick="CancelConfig();"><script>document.write(dhcp_language['bbsp_cancel']);</script></button> </td> 
    </tr> 
  </table> 
  <br> 
</form>
<script>
loadlanguage();
</script>
</body>
</html>
