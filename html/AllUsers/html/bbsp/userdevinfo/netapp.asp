<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<title>network application</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<script language="javascript" src="../common/wan_control.asp"></script>
<script language="JavaScript" type="text/javascript">
var CurrentLang = '<%HW_WEB_GetCurrentLanguage();%>';

var numpara1 = "";
var numpara1 = "";
var porttype = "";
var portid   = "";
var page = 1;
var FltsecLevel = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Security.X_HW_FirewallLevel);%>'.toUpperCase();
var PccwFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_PCCW);%>';
var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var curCfgModeWord ='<%HW_WEB_GetCfgMode();%>'; 

if(( window.location.href.indexOf("?") > 0) &&( window.location.href.split("?").length == 6))
{
	 numpara1 = window.location.href.split("?")[1];
	 numpara2 = window.location.href.split("?")[2];
	 porttype = window.location.href.split("?")[3];
	 portid   = window.location.href.split("?")[4];
	 page     = window.location.href.split("?")[5];	 
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
		b.innerHTML = userdevinfo_language[b.getAttribute("BindText")];
	}
}

function GetHpa(MainName)
{
	var menuItems = top.Frame.menuItems;	
	
	for(var i in menuItems)
	{		
		if(MainName == menuItems[i].name)
		{
			return menuItems.length - i;
		}
	}
	
	return -1;
}

function GetZpa(MainName, SubItemName)
{
	var Hpa = GetHpa(MainName);
	if(Hpa == -1)
	{
		return -1;
	}
	
	var subItems = top.Frame.menuItems[top.Frame.menuItems.length - Hpa].subMenus;
	for(var i in subItems)
	{
		if(SubItemName == subItems[i].name)
		{	
			return i;
		}
	}
	
	return -1;
}

function LoadFrame()
{
	if((curUserType != sysUserType) && (curCfgModeWord.toUpperCase() == "RDSGATEWAY"))
	{
		setDisplay('DivBtnipfilt',0);
	}
	if(FltsecLevel != 'CUSTOM')
	{
		setDisable('Value1' , 1);
	}
	loadlanguage();
}


function submit1()
{
	var MainName = userdevinfo_language['bbsp_ipincoming_main_item'];
	var SubItemName = userdevinfo_language['bbsp_ipincoming_sub_item'];

	var hpa = GetHpa(MainName);
	var zpa = GetZpa(MainName, SubItemName);

	if(hpa != -1 && zpa != -1)
	{
		top.Frame.showjump(hpa, zpa);
	}
	else
	{
		if(curUserType == sysUserType)
		{
			if(1 == PccwFlag)
			{
				top.Frame.showjump(5,0);
			}
			else
			{
				if (bin4board_nonvoice() == true)
				{
					top.Frame.showjump(5,1);
				}
				else
				{
					top.Frame.showjump(6,1);
				}
			}
		}
		else
		{
			if(1 == PccwFlag)
			{
				top.Frame.showjump(4,0);
			}
			else
			{
				top.Frame.showjump(4,1);
			}
		}
	}
	window.location='../../../html/bbsp/ipincoming/ipincoming.asp?' + numpara1;
}

function submit2()
{
	if ("ETH" == porttype)
	{
		var MainName = userdevinfo_language['bbsp_macfilter_main_item'];
		var SubItemName = userdevinfo_language['bbsp_macfilter_sub_item'];

		var hpa = GetHpa(MainName);
		var zpa = GetZpa(MainName, SubItemName);

		if(hpa != -1 && zpa != -1)
		{
			top.Frame.showjump(hpa, zpa);
		}
		else
		{
			if(curUserType == sysUserType)
			{
				if(1 == PccwFlag)
				{
					top.Frame.showjump(5,1);
				}
				else
				{
					if (bin4board_nonvoice() == true)
					{
						top.Frame.showjump(5,2);
					}
					else
					{
						top.Frame.showjump(6,2);
					}
				}
			}
			else
			{
				if(1 == PccwFlag)
				{
					top.Frame.showjump(4,1);
				}else if(curCfgModeWord.toUpperCase() == "RDSGATEWAY"){
				    top.Frame.showjump(4,0);
				}
				else
				{
					top.Frame.showjump(4,2);
				}
			}
		}
		window.location='../../../html/bbsp/macfilter/macfilter.asp?' + numpara2;
	}
	else
	{
		var MainName = userdevinfo_language['bbsp_wlanmacfil_main_item'];
		var SubItemName = userdevinfo_language['bbsp_wlanmacfil_sub_item'];

		var hpa = GetHpa(MainName);
		var zpa = GetZpa(MainName, SubItemName);

		if(hpa != -1 && zpa != -1)
		{
			top.Frame.showjump(hpa, zpa);
		}
		else
		{
			if(curUserType == sysUserType)
			{
				if(1 == PccwFlag)
				{
					top.Frame.showjump(5,2);
				}
				else
				{
					if (bin4board_nonvoice() == true)
					{
						top.Frame.showjump(5,3);
					}
					else
					{
						top.Frame.showjump(6,3);
					}
				}
			}
			else
			{
				if((1 == PccwFlag)||(curCfgModeWord.toUpperCase() == "RDSGATEWAY"))
				{
					top.Frame.showjump(4,1);
				}
				else
				{
					top.Frame.showjump(4,2);
				}
			}
		}
		window.location='../../../html/bbsp/wlanmacfilter/wlanmacfilter.asp?' + numpara2 + '?' + portid;
	}
}

function submit3()
{
	var MainName = userdevinfo_language['bbsp_portmapping_main_item'];
	var SubItemName = userdevinfo_language['bbsp_portmapping_sub_item'];

	var hpa = GetHpa(MainName);
	var zpa = GetZpa(MainName, SubItemName);

	if(hpa != -1 && zpa != -1)
	{
		top.Frame.showjump(hpa, zpa);
	}
	else
	{
		if(curUserType == sysUserType)
		{
			if(1 == PccwFlag)
			{
				top.Frame.showjump(3,1);
			}
			else
			{
				if (bin4board_nonvoice() == true)
				{
					top.Frame.showjump(3,1);
				}
				else
				{
					top.Frame.showjump(4,1);
				}
			}
		}
		else
		{
			if(curCfgModeWord.toUpperCase() == "RDSGATEWAY")
			{
				top.Frame.showjump(3,0);
			}
			else
			{
				top.Frame.showjump(3,1);
			}
		}
	}
	window.location='../../../html/bbsp/portmapping/portmapping.asp?' + numpara1;
}

function submit4()
{
	var MainName = userdevinfo_language['bbsp_dhcp_static_main_item'];
	var SubItemName = userdevinfo_language['bbsp_dhcp_static_sub_item'];

	var hpa = GetHpa(MainName);
	var zpa = GetZpa(MainName, SubItemName);

	if(hpa != -1 && zpa != -1)
	{
		top.Frame.showjump(hpa, zpa);
	}
	else
	{	
		if (curUserType == sysUserType)
		{
			if (("1" == "<% HW_WEB_GetFeatureSupport(BBSP_FT_IPV6);%>") 
				&& ("1" == "<% HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>"))
			{
				top.Frame.showjump(9,3);
			}
			else if (("1" != "<% HW_WEB_GetFeatureSupport(BBSP_FT_IPV6);%>") 
					 && ("1" != "<% HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>"))
			{
				top.Frame.showjump(7,3);
			}
			else
			{
				top.Frame.showjump(8,3);
			}
		}
		else
		{
			top.Frame.showjump(6, 2);
		}
	}
	window.location = '../../../html/bbsp/dhcpstatic/dhcpstatic.asp?' + numpara1 + '?' + numpara2;
}

</script>
</head>
<body  class="mainbody" onLoad="LoadFrame();"> 

<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	<tr>
		<script>         
		if(CurrentLang == 'arabic')
		{
			document.write('<button style="padding-left:px;text-align:right;" name="Value1" id="Value1"  type="button" class="submit" onClick="submit1();">'+ '&nbsp;');
			document.write(userdevinfo_language['bbsp_ipfilt']);
			document.write('</button>');
			document.write('<br />');
			document.write('<button style="padding-left:px;text-align:right;" name="Value2" id="Value2"  type="button" class="submit" onClick="submit2();">'+ '&nbsp;');
			document.write(userdevinfo_language['bbsp_macfilt']);
			document.write('</button>');
			document.write('<br />');
			document.write('<button style="padding-left:px;text-align:right;" name="Value3" id="Value3"  type="button" class="submit" onClick="submit3();">'+ '&nbsp;');
			document.write(userdevinfo_language['bbsp_poermap']);
			document.write('</button>');
			document.write('<br />');
			if(1 != PccwFlag)
			{
				document.write('<button style="padding-left:px;text-align:right;width:275px" name="Value4" id="Value4"  type="button" class="submit" onClick="submit4();">'+ '&nbsp;');
				document.write(userdevinfo_language['bbsp_dhcpresipconfig']);
				document.write('</button>');
			}
		}
		else
		{
			document.write('<div id="DivBtnipfilt">');
			document.write('<button style="padding-left:px;text-align:left;" name="Value1" id="Value1"  type="button" class="submit" onClick="submit1();">'+ '&nbsp;');
			document.write(userdevinfo_language['bbsp_ipfilt']);
			document.write('</button>');
			document.write('<br />');
			document.write('</div>');
			document.write('<button style="padding-left:px;text-align:left;" name="Value2" id="Value2"  type="button" class="submit" onClick="submit2();">'+ '&nbsp;');
			document.write(userdevinfo_language['bbsp_macfilt']);
			document.write('</button>');
			document.write('<br />');
			document.write('<button style="padding-left:px;text-align:left;" name="Value3" id="Value3"  type="button" class="submit" onClick="submit3();">'+ '&nbsp;');
			document.write(userdevinfo_language['bbsp_poermap']);
			document.write('</button>');
			document.write('<br />');
			if(1 != PccwFlag)
			{
				document.write('<button style="padding-left:px;text-align:left;" name="Value4" id="Value4"  type="button" class="submit" onClick="submit4();">'+ '&nbsp;');
				document.write(userdevinfo_language['bbsp_dhcpresipconfig']);
				document.write('</button>');
			}
		}
		</script>	
	</tr>
</table>
<table width="100%" height="30"> 
  <tr> 
    <td class='title_bright1'> <button id="back" name="back" type="button" class="submit" onClick="window.location='userdevinfo.asp?'+page;" enable=true ><script>document.write(userdevinfo_language['bbsp_back']);</script></button> </td> 
  </tr> 
</table> 
</body>
</html>
