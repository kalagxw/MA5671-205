<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<link rel="stylesheet" href='../../../resource/<%HW_WEB_Resource(diffcss.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>ACL</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="javascript" src="../common/userinfo.asp"></script>
<script language="javascript" src="../common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../../amp/common/wlan_list.asp"></script>

<script language="JavaScript" type="text/javascript">
var FltsecLevel = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Security.X_HW_FirewallLevel);%>'.toUpperCase();

var SingleFreqFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_SINGLE_WLAN);%>';
var DoubleFreqFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_DOUBLE_WLAN);%>';

var selctIndex = -1;
var wantelflag = '<%HW_WEB_GetRemoteTelnetAbility();%>';
var curUserType='<%HW_WEB_GetUserType();%>';

var CfgModeWord ='<%HW_WEB_GetCfgMode();%>'; 

function wanwhitelist(domain,WANSrcWhiteListEnable,WANSrcWhiteListNumberOfEntries)
{
	this.domain = domain;
	this.WANSrcWhiteListEnable = WANSrcWhiteListEnable;
	this.WANSrcWhiteListNumberOfEntries = WANSrcWhiteListNumberOfEntries;
}

function IsOSKNormalUser()
{
	if ('OSK' == CfgModeWord.toUpperCase() && curUserType != '0')
	{
		return true;
	}
	else
	{
		return false;
	}
}

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
		b.innerHTML = acl_language[b.getAttribute("BindText")];
	}
}

function list(domain,SrcIPPrefix)
{
	this.domain = domain;
	this.SrcIPPrefix = SrcIPPrefix;
}

var WANSrcWhiteList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_WANSrcWhiteList, InternetGatewayDevice.X_HW_Security.WANSrcWhiteList,WANSrcWhiteListEnable|WANSrcWhiteListNumberOfEntries, wanwhitelist);%>;

var WhiteList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaWhiteList, InternetGatewayDevice.X_HW_Security.WANSrcWhiteList.List.{i},SrcIPPrefix,list);%>;
function stAclInfo(domain,HttpLanEnable,HttpWanEnable,FtpLanEnable,FtpWanEnable,TelnetLanEnable,TelnetWanEnable,HTTPWifiEnable,TELNETWifiEnable, SSHLanEnable, SSHWanEnable)
{
	this.domain = domain;
	this.HttpWifiEnable = HTTPWifiEnable;
	this.TelnetWifiEnable = TELNETWifiEnable;
	this.HttpLanEnable = HttpLanEnable;
	this.HttpWanEnable = HttpWanEnable;
	this.FtpLanEnable = FtpLanEnable;
	this.FtpWanEnable = FtpWanEnable;
	this.TelnetLanEnable = TelnetLanEnable;
	this.TelnetWanEnable = TelnetWanEnable;
	this.SSHLanEnable = SSHLanEnable;
	this.SSHWanEnable = SSHWanEnable;
}

var aclinfos = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecAclInfos, InternetGatewayDevice.X_HW_Security.AclServices,HTTPLanEnable|HTTPWanEnable|FTPLanEnable|FTPWanEnable|TELNETLanEnable|TELNETWanEnable|HTTPWifiEnable|TELNETWifiEnable|SSHLanEnable|SSHWanEnable,stAclInfo);%>;  
var AclInfo = aclinfos[0];

function LoadFrame()
{
         
	if (WhiteList.length > 1)
	{
		selectLine('record_0');
	}
	
    with (getElement('ConfigForm'))
	{                                 

		setCheck('ftplan',AclInfo.FtpLanEnable);
		setCheck('ftpwan',AclInfo.FtpWanEnable);
		setCheck('httpwifi',AclInfo.HttpWifiEnable);
		setCheck('httplan',AclInfo.HttpLanEnable);
		setCheck('httpwan',AclInfo.HttpWanEnable);
		setCheck('telnetlan',AclInfo.TelnetLanEnable);
		setCheck('telnetwan',AclInfo.TelnetWanEnable);
		setCheck('telnetwifi',AclInfo.TelnetWifiEnable);
		setCheck('sshlan',AclInfo.SSHLanEnable);
		setCheck('sshwan',AclInfo.SSHWanEnable);
		setCheck('wanwhite',WANSrcWhiteList[0].WANSrcWhiteListEnable);
	}       
        if( AclInfo.TelnetLanEnable == 0)
	{
	    setDisable('telnetwifi' , 1);
	}   
	if(parseInt(AclInfo.HttpLanEnable,10) == 0)
	{
	    setDisable('httpwifi' , 1);  
	}

	if(FltsecLevel != 'CUSTOM')
	{                
	       setDisable('httpwifi', 1);
	       setDisable('telnetwifi', 1);
		setDisable('ftplan' , 1);
		setDisable('httplan' , 1);
		setDisable('telnetlan' , 1);
		setDisable('ftpwan' , 1);
		setDisable('httpwan' , 1);
		setDisable('telnetwan' , 1);
		setDisable('bttnApply' , 1);
		setDisable('cancelValue' , 1);
		setDisable('sshlan' , 1);
		setDisable('sshwan' , 1);
	}    
	
       if((IsAdminUser() == false) || IsE8cFrame())     		
	{              
	    setDisplay('lan_table', 0);    	    
	    setDisplay('wifi_telnet', 0); 
	    setDisplay('wan_table', 0);                     
	    setDisplay('ListConfigPanel', 0);  
	    setDisplay('ConfigPanel', 0);
		setDisplay('wifi_space', 0);
		setDisplay('wan_space', 0);
	}
	else
	{
		setDisplay('lan_table', 1);    	    
	    setDisplay('wifi_telnet', 1); 
	    setDisplay('wan_table', 1);                     
	    setDisplay('ListConfigPanel', 1);  
	}

    if (true == IsOSKNormalUser())
    {
	    setDisplay('lan_table', 1);    	    
	    setDisplay('wifi_telnet', 1); 
	    setDisplay('wan_table', 1);                     
	    setDisplay('ListConfigPanel', 1);  
	    setDisplay('ConfigPanel', 1);    
    }

	if('0' == wantelflag)
	{
		setDisable('telnetwan' , 1);
		setCheck('telnetwan', 0);
	}
	
	if(SingleFreqFlag != 1 && DoubleFreqFlag != 1)
	{ 
	  setDisplay('wifi_space', 0);
		setDisplay('wifi_table', 0);   
	} 
	
	loadlanguage();
}

function FormCheck()
{
    with (getElement('ConfigForm'))
	{	
		  
		    if((AclInfo.HttpWifiEnable != getCheckVal('httpwifi'))&&(0 == getCheckVal('httpwifi')))
		    {
		    
    		    if(false == ConfirmEx(acl_language['bbsp_confirm_wifi']))
			{
        		    setCheck('httpwifi',1);
			    return false;
			}
		    }
		


		if((AclInfo.HttpLanEnable != getCheckVal('httplan'))&&(0 == getCheckVal('httplan')))
		{
		    
    		if(false == ConfirmEx(acl_language['bbsp_confirm_lan']))
			{
        		setCheck('httplan',1);
				return false;
			}
		}

		if((AclInfo.HttpWanEnable != getCheckVal('httpwan'))&&(0 == getCheckVal('httpwan')))
		{
    		if(false == ConfirmEx(acl_language['bbsp_confirm_wan']))
			{
        		setCheck('httpwan',1);
				return false;
			}
		}
    }

	return true;
}

function SubmitForm()
{
	if(false == FormCheck())
    {
        return;
    }

	setDisable('btnApply', 1);
    setDisable('cancelValue', 1);

    var Form = new webSubmitForm();

    Form.usingPrefix('x');
    
	    
		if(((IsAdminUser() == true) && !IsE8cFrame())
			|| (true == IsOSKNormalUser()))
		{
			Form.addParameter('FTPLanEnable',getCheckVal('ftplan'));
			Form.addParameter('FTPWanEnable',getCheckVal('ftpwan'));	
			Form.addParameter('HTTPLanEnable',getCheckVal('httplan'));
			Form.addParameter('HTTPWanEnable',getCheckVal('httpwan'));
			Form.addParameter('TELNETLanEnable',getCheckVal('telnetlan'));
			Form.addParameter('TELNETWanEnable',getCheckVal('telnetwan'));
			Form.addParameter('HTTPWifiEnable',getCheckVal('httpwifi'));	
			Form.addParameter('TELNETWifiEnable',getCheckVal('telnetwifi'));
			Form.addParameter('SSHLanEnable',getCheckVal('sshlan'));
			Form.addParameter('SSHWanEnable',getCheckVal('sshwan'));
		}
		else
		{ 
			 Form.addParameter('HTTPWifiEnable',getCheckVal('httpwifi')); 
		}
    Form.endPrefix();		
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_Security.AclServices&RequestFile=html/bbsp/acl/acl.asp');	
	Form.submit();			
	setDisable('bttnApply',1);
    setDisable('cancelValue',1);  
}

function ChangeLevel(level)
{
	 
}

function CancelConfig()
{
    LoadFrame();
}

	function CheckParameter()
	{
		var SrcIPPrefix = getElement('SrcIPPrefix').value;
		if (SrcIPPrefix == '')
		{
			AlertEx(acl_language['bbsp_alert_srcip1']);			
	        return false;
		}

		if (SrcIPPrefix.length > 64)
		{		    
			AlertEx(acl_language['bbsp_alert_srcip2']);	
	        return false;
		}

		var addrParts = SrcIPPrefix.split('/');
		if (addrParts.length != 2) 
		{			
			AlertEx(acl_language['bbsp_alert_addaddr']);	
			return false;
		}
		
        	if((addrParts[1].length>2)
		||((addrParts[1]=='8 ') &&(addrParts[1].length==2)))
		{
			AlertEx(acl_language['bbsp_alert_addaddr']);
			return false;
		}


       if ((isValidIpAddress(addrParts[0]) == false) && (IsIPv6AddressValid(addrParts[0]) == false))
		{			
			AlertEx(acl_language['bbsp_alert_invalidipaddr']);	
			return false;
	 	}

		if(isNaN(addrParts[1].replace(' ', 'a')) == true)
		{
			AlertEx(acl_language['bbsp_maskinvalid1']);
			return false;
		}


	var IsIPv4 = isValidIpAddress(addrParts[0]);
	var num = parseInt(addrParts[1],10);
	if (num == 0 || ((IsIPv4 == true) && (num > 32)))
	{
		AlertEx(acl_language['bbsp_maskinvalid3']);
		return false;
	}

	if ((IsIPv4 == true) && (iSIPmatchMask(addrParts[0],num) == false))
	{
		AlertEx(acl_language['bbsp_maskinvalid4']);
		return false;    
	}

	if (IsIPv4 == true)
	{
		var addrs=SrcIPPrefix.split('.');
		var addr=parseInt(addrs[0],10);
		if(addr>=224&&addr<=239)
		{
			AlertEx(acl_language['bbsp_alert_invalidipaddr']);
			return false; 
		}
	}
	for (i = 0; i < WhiteList.length-1; i++)
	{
		if((selctIndex != i) && (WhiteList[i].SrcIPPrefix == SrcIPPrefix))
		{
			AlertEx(acl_language['bbsp_iprepeat']);
			return false; 
		}
	}

	return true;
}
function checkzeronum(num)
{
	var temp = 0;
	var ZeroNum = 0;
	
	for(var i = 0; i<= 7; i++)
	{
		temp = num >> i ;
		if((temp & 1) == 0)
		{
			ZeroNum++;
		}
		else
		{
			return ZeroNum;
		}
	}
	return ZeroNum;
}

function iSIPmatchMask(ip ,mask)
{
	var addripv4 = ip.split('.')
	var ZeroTotal = 0;
	
	for(var k=3; k>=0; k--)
	{
		ZeroTotal += checkzeronum(addripv4[k]);
		if(8 != checkzeronum(addripv4[k]))
		{		
			if((mask < (32 - ZeroTotal)) || (mask >32))
			{
				return false; 
			} 
			return true;  
		}
	}
}

function DeleteLineRow()
{
   var tableRow = getElementById("ACLInfo");
   if (tableRow.rows.length > 2)
   tableRow.deleteRow(tableRow.rows.length-1);
   return false;
}

function setControl(Index)
{
	selctIndex = Index;
	if (Index < -1)
	{
		return;
	}
	if (Index == -1)
	{
		if(WhiteList.length >= 17)
		{
			DeleteLineRow();
			AlertEx(acl_language['bbsp_ipaddrfull']);
			setDisplay('ConfigPanel', 0);
			setControl(0);
			return ;
		}
		else
		{
			SetAddMode();
			setText('SrcIPPrefix', '');
			setDisplay("ConfigPanel", "1"); 
		}
	}
	else
	{ 
		SetEditMode();
		setDisplay("ConfigPanel", "1");
        setText('SrcIPPrefix',WhiteList[Index].SrcIPPrefix);
	}
}


    function clickRemove()
    {        
        var Form = new webSubmitForm();
        var SelectCount = 0;

        for (var i = 0; i < WhiteList.length-1; i++)
	{
		if (getCheckVal("Record"+i) == "1")
		{
			SelectCount++;
        	    Form.addParameter(WhiteList[i].domain, '');
		}
	}

        if (SelectCount == 0)
        {			
			AlertEx(acl_language['bbsp_alert_selwhite']);	
            return false;
        }
		
		Form.addParameter('x.X_HW_Token', getValue('onttoken')); 
        Form.setAction('del.cgi?' +'x=InternetGatewayDevice.X_HW_Security.WANSrcWhiteList.List' + '&RequestFile=html/bbsp/acl/acl.asp');   
        Form.submit();       
    }


    function OnApplyButtonClick()
    {
		if (CheckParameter() == false)
		{
			return false;
		}

		var Form = new webSubmitForm();

		Form.addParameter('x.SrcIPPrefix', getValue('SrcIPPrefix'));
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		
		if (IsAddMode() == true)
		{
			 Form.setAction('add.cgi?' +'x=InternetGatewayDevice.X_HW_Security.WANSrcWhiteList.List' + '&RequestFile=html/bbsp/acl/acl.asp');
		}
	   else
		{
			 Form.setAction('set.cgi?x=' + WhiteList[selctIndex].domain + '&RequestFile=html/bbsp/acl/acl.asp'); 
		}

		Form.submit();
		DisableRepeatSubmit();
    }


    function OnCancelButtonClick()
    {
		setDisplay("ConfigPanel", 0);
        var tableRow = getElement("ACLInfo");
        
        if ((tableRow.rows.length > 2) && (IsAddMode() == true))
        {
            tableRow.deleteRow(tableRow.rows.length-1);
        }
    }


	function EnableForm()
	{
		var Form = new webSubmitForm();
		var Enable = getElById("wanwhite").checked;
		if (Enable == true)
		{
		   Form.addParameter('x.WANSrcWhiteListEnable',1);
		}
		else
		{
		   Form.addParameter('x.WANSrcWhiteListEnable',0);
		}
		
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_Security.WANSrcWhiteList'
							+ '&RequestFile=html/bbsp/acl/acl.asp');
		Form.submit();
	}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<script language="JavaScript" type="text/javascript">
if ('PTVDF' == CfgModeWord.toUpperCase())
{
	HWCreatePageHeadInfo("acltitle", GetDescFormArrayById(acl_language, ""), GetDescFormArrayById(acl_language, "bbsp_title_prompt1"), false);
}
else
{
	HWCreatePageHeadInfo("acltitle", GetDescFormArrayById(acl_language, ""), GetDescFormArrayById(acl_language, "bbsp_title_prompt"), false);
}
</script>
<div class="title_spread"></div>

  <form id="ConfigForm" action=""> 
    <table width="100%" class="tabal_bg"  cellpadding="2" cellspacing="1" id="lan_table" style="display:none"> 
      <tr class="head_title align_center"> 
        <td  colspan="2" class="tabal_head width_per20 align_left" BindText='bbsp_table_lan'></td> 
      </tr> 
      <tr class='align_left'> 
        <td class="table_title per_35_52" BindText='bbsp_table_lanftp'></td> 
        <td class="table_right per_65_48"> <input value='InternetGatewayDevice.X_ATP_Security.AclServices.FTPLanEnable' type='checkbox' name='ftplan' id="ftplan" checked> 
&nbsp;&nbsp;</td> 
      </tr> 
      <tr > 
        <td class="table_title per_35_52 align_left" BindText='bbsp_table_lanhttp'></td> 
        <td class="table_right per_65_48"> <input value='InternetGatewayDevice.X_ATP_Security.AclServices.HTTPLanEnable' type='checkbox' name='httplan' id="httplan" checked> </td> 
      </tr> 
      <tr class='align_left'> 
        <td class="table_title per_35_52" BindText='bbsp_table_lantel'></td> 
        <td class="table_right per_65_48"> <input value='InternetGatewayDevice.X_ATP_Security.AclServices.TELNETLanEnable' type='checkbox' name='telnetlan' id="telnetlan" checked> 
&nbsp;&nbsp;</td> 
      </tr> 
      <tr class='align_left'> 
        <td class="table_title per_35_52" BindText='bbsp_table_lanssh'></td> 
        <td class="table_right per_65_48"> <input value='InternetGatewayDevice.X_ATP_Security.AclServices.SSHLanEnable' type='checkbox' name='sshlan' id="sshlan" checked> 
&nbsp;&nbsp;</td> 
      </tr> 
    </table> 
	
   <div class="func_spread"></div>
	 <table width="100%" class="tabal_bg"  cellpadding="2" cellspacing="1" id="wifi_table"> 
      <tr class="head_title align_center"> 
        <td  colspan="2" class="tabal_head width_per20 align_left" BindText='bbsp_table_wifi'></td> 
      </tr> 
      <tr class='align_left'> 
        <td class="table_title per_35_52">
		<script language="JavaScript" type="text/javascript">
		  if ('PTVDF' == CfgModeWord.toUpperCase())
		  {
			  document.write(acl_language['bbsp_table_wifihttp1']);
		  }
		  else
		  {
		      document.write(acl_language['bbsp_table_wifihttp']);
		  }
		</script>
		</td> 
        <td class="table_right per_65_48"> <input type='checkbox' name='httpwifi' id="httpwifi" checked></input>
&nbsp;&nbsp;</td> 
      </tr> 
	  <tr class='align_left' id='wifi_telnet' style="display:none"> 
        <td class="table_title per_35_52" BindText='bbsp_table_wifitelnet'></td> 
        <td class="table_right per_65_48"> <input type='checkbox' name='telnetwifi' id="telnetwifi" checked></input>
&nbsp;&nbsp;</td> 
      </tr> 
    </table> 
	
    <div class="func_spread"></div>
    <table width="100%" class="tabal_bg"  cellpadding="2" cellspacing="1"  id="wan_table" style="display:none"> 
      <tr class="head_title align_center"> 
        <td colspan="2"  class="tabal_head align_left" BindText='bbsp_table_wan'></td> 
      </tr> 
      <tr class='align_left'> 
        <td class="table_title per_35_52" BindText='bbsp_table_wanftp'></td> 
        <td class="table_right  per_65_48"> <input value='InternetGatewayDevice.X_ATP_Security.AclServices.FTPWanEnable' type='checkbox' name='ftpwan' id="ftpwan"> 
&nbsp;&nbsp;</td> 
      </tr> 
      <tr class='align_left'> 
        <td class="table_title per_35_52" BindText='bbsp_table_wanhttp'></td> 
        <td class="table_right  per_65_48"> <input value='InternetGatewayDevice.X_ATP_Security.AclServices.HTTPLanEnable' type='checkbox' name='httpwan' id="httpwan"> 
&nbsp;&nbsp;</td> 
      </tr> 
      <tr class='align_left'> 
        <td class="table_title per_35_52" BindText='bbsp_table_wantel'></td> 
        <td class="table_right per_65_48"> <input value='InternetGatewayDevice.X_ATP_Security.AclServices.TELNETWanEnable' type='checkbox' name='telnetwan' id="telnetwan" > 
&nbsp;&nbsp;</td> 
      </tr> 
      <tr class='align_left'> 
        <td class="table_title per_35_52" BindText='bbsp_table_wanssh'></td> 
        <td class="table_right per_65_48"> <input value='InternetGatewayDevice.X_ATP_Security.AclServices.SSHWanEnable' type='checkbox' name='sshwan' id="sshwan" checked> 
&nbsp;&nbsp;</td> 
      </tr> 
    </table> 
    <table class="table_button" width="100%"> 
      <tr>
        <td class='width_per35'></td> 
        <td class="table_submit width_per65"> <button id="bttnApply" name="bttnApply" type="button" class="submit" onClick="SubmitForm();" id="Button1"><script>document.write(acl_language['bbsp_app']);</script></button>
          <button name="cancelValue" id="cancelValue" type="button" class="submit" onClick="CancelConfig();"><script>document.write(acl_language['bbsp_cancel']);</script></button></td> 
      </tr> 
    </table> 
	
    <div class="func_spread"></div>
    <div id="ListConfigPanel" style="display:none"> 
      <table width="100%" class="tabal_bg"  cellpadding="2" cellspacing="1" id="tables"> 
        <tr class="head_title align_left"> 
          <td colspan="2" class="tabal_head" BindText='bbsp_title_wanwhite'></td> 
        </tr> 
        <tr class='align_left'> 
          <td class="table_title per_35_52" BindText='bbsp_title_wanwhiteenable'></td> 
          <td class="table_right per_65_48"> <input value='InternetGatewayDevice.X_HW_Security.WANSrcWhiteList.WANSrcWhiteListEnable' type='checkbox' name='wanwhite' id="wanwhite" onclick = "EnableForm();"> </td> 
        </tr> 
      </table> 
	  
      <div class="func_spread"></div>
      <script language="JavaScript" type="text/javascript">
    writeTabCfgHeader('ACL','100%');
    </script> 
      <table width="100%" class="tabal_bg"  cellpadding="2" cellspacing="1" id="ACLInfo"> 
        <tr> 
          <td class=" head_title width_per20">&nbsp;</td> 
          <td class=" head_title" BindText='bbsp_title_ipwhitelist'></td> 
        </tr> 
        <script language="JavaScript" type="text/javascript">
			if (WhiteList.length - 1 == 0)
			{
				document.write('<tr id="record_no"' 
            	                + ' class="tabal_center01 " >');
                document.write('<td class="width_20p" >--</td>');
    			document.write('<td  >--</td>');    
    			document.write('</tr>');
			}
			else
			{
				for (i = 0; i < WhiteList.length - 1; i++)
				{						
            			document.write('<tr id="record_' + i 
            	                 + '" class="tabal_01"  onclick="selectLine(this.id);">');
                        document.write('<td >' + '<input type=\'checkbox\' id=\'Record'+i+'\' name=\'rml\''
            			         + ' value=\'' + WhiteList[i].domain + '\'>' + '</td>');
            			document.write('<td >' + WhiteList[i].SrcIPPrefix + '&nbsp;</td>');  
            			document.write('</tr>');
				}
			}
		</script> 
      </table> 
	  
      <div id="ConfigPanel" style="display:none"> 
	  <div class="list_table_spread"></div>
        <table width="100%" class="tabal_bg"  cellpadding="2" cellspacing="1"> 
          <tr> 
            <td  class="table_title width_per20 align_left" BindText='bbsp_table_srcaddrwlist'></td> 
            <td  class="table_right align_left"> <input type='text' name="SrcIPPrefix" id="SrcIPPrefix" style="width:150px" maxlength='64'/> 
              <strong class='color_red'>*</strong><span class="gray">(A.B.C.D/E)</span> </td> 
          </tr> 
        </table> 
        <table id="ConfigPanelButtons" width="100%"  class="table_button"> 
          <tr> 
            <td class='width_per20'> </td> 
            <td class="table_submit pad_left5p"> 
			  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
			  <button id="ButtonApply"  type="button" onclick="javascript:return OnApplyButtonClick();" class="ApplyButtoncss buttonwidth_100px" ><script>document.write(acl_language['bbsp_app']);</script></button>
              <button id="ButtonCancel" type="button" onclick="javascript:OnCancelButtonClick();" class="CancleButtonCss buttonwidth_100px" ><script>document.write(acl_language['bbsp_cancel']);</script></button> </td> 
          </tr>
		  <tr> 
			  <td  style="display:none"> <input type='text'> </td> 
		  </tr>          
        </table> 
      </div> 
      <script language="JavaScript" type="text/javascript">
		writeTabTail();
	  </script>  
    </div> 
   
</form>    
<br>
<br>
</body>
</html>
