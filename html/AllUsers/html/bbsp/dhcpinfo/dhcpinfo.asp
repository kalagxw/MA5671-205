<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>

<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/topoinfo.asp"></script>
<script language="javascript" src="../common/lanuserinfo.asp"></script>                                      

<title>Dhcp Information</title>
<script language="JavaScript" type="text/javascript">

var MAX_DEV_TYPE=16;

var MAX_HOST_TYPE=16;

var appName = navigator.appName;

function MainDhcpInfo(domain, enable, minaddr, maxaddr)
{
	this.domain    = domain;
	this.enable    = enable;
	this.minaddr   = minaddr;
	this.maxaddr   = maxaddr;
}

function SlaveDhcpInfo(domain, startip, endip, enable)
{
	this.domain    = domain;
	this.startip   = startip;
	this.endip     = endip;
	this.enable    = enable;
}

function stLanHostInfo(domain,ipaddr,subnetmask)
{
	this.domain = domain;
	this.ipaddr = ipaddr;
	this.subnetmask = subnetmask;
}

function stLanHostInfos(domain,ipaddr)
{
	this.domain = domain;
	this.ipaddr = ipaddr;
}



var MainDhcpInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement,DHCPServerEnable|MinAddress|MaxAddress,MainDhcpInfo);%>;  
var SlaveDhcpInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DHCPSLVSERVER,StartIP|EndIP|DHCPEnable,SlaveDhcpInfo);%>;  

var LanHostInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},IPInterfaceIPAddress|IPInterfaceSubnetMask,stLanHostInfo);%>;
var SlaveIpAddress = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},IPInterfaceIPAddress,stLanHostInfos);%>;
var SlaveIpAddr = "";

if (SlaveIpAddress[1] != null)
{
    SlaveIpAddr = SlaveIpAddress[1].ipaddr;
}


var LanHostInfo = LanHostInfos[0];

var EthPortIpNum = 0;
var WifiPortIpNum = 0;
var TotalIpNum = 0;
var ActiveIpNum = 0;
var LeftIpAddrNum = 0;

function IpToInteger(str)
{
	var ipSeg;
	var IpInteger;
	ipSeg = str.split('.');	
	IpInteger = ((parseInt(ipSeg[0],10) << 24 + parseInt(ipSeg[1],10) << 16) + parseInt(ipSeg[2],10) << 8) + parseInt(ipSeg[3],10);

	return IpInteger;
}

function GetDeviceInfoByIpAndMac(userdeviceinfos, ipaddr, macaddr)
{
	for (var i = 0;i < userdeviceinfos.length - 1; i++)
	{
		if ((ipaddr == userdeviceinfos[i].IpAddr) && (macaddr == userdeviceinfos[i].MacAddr))
		{
			return userdeviceinfos[i];
		}
	}
	return null;
}

function CalcIpNumOfPortType(userdhcpinfos, userdeviceinfos)
{
	var userdevice;
	
	if (1 != MainDhcpInfos[0].enable)
	{
	    EthPortIpNum = 0;
		WifiPortIpNum = 0;
		return;
	}
	
	for (var i = 0; i < userdhcpinfos.length - 1; i++)
	{
		if (userdhcpinfos[i].remaintime <= 0)
		{
			continue;
		}
		
		
		if ("Ethernet" == userdhcpinfos[i].interfacetype)
		{
			EthPortIpNum++;
		}
		else if ("802.11" == userdhcpinfos[i].interfacetype)
		{
			WifiPortIpNum++;
		}
	}
}

function CalcTotalIpNum()
{
	var MainDhcpIpNum = 0;
	var SlaveDhcpIpNum = 0;
	if (1 == MainDhcpInfos[0].enable)
	{
		MainDhcpIpNum = IpToInteger(MainDhcpInfos[0].maxaddr) - IpToInteger(MainDhcpInfos[0].minaddr) + 1;
		if((IpToInteger(MainDhcpInfos[0].minaddr) <= IpToInteger(LanHostInfo.ipaddr))&& (IpToInteger(LanHostInfo.ipaddr) <= IpToInteger(MainDhcpInfos[0].maxaddr))) 
		{
			MainDhcpIpNum = MainDhcpIpNum - 1;
		}
	}
	
	if (1 == SlaveDhcpInfos[0].enable)
	{
		SlaveDhcpIpNum = IpToInteger(SlaveDhcpInfos[0].endip) - IpToInteger(SlaveDhcpInfos[0].startip) + 1;
		if((IpToInteger(SlaveDhcpInfos[0].startip) <= IpToInteger(SlaveIpAddr)) && (IpToInteger(SlaveIpAddr) <= IpToInteger(SlaveDhcpInfos[0].endip))) 
		{
			SlaveDhcpIpNum = SlaveDhcpIpNum - 1;
		}
	}

	return MainDhcpIpNum + SlaveDhcpIpNum;
}

function CalcActiveIpNum()
{
	var IpNum = EthPortIpNum + WifiPortIpNum;
	
	if (1 != MainDhcpInfos[0].enable)
	{
		return 0;
	}
		
	return IpNum;
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
		b.innerHTML = dhcpinfo_language[b.getAttribute("BindText")];
	}
}

function LoadFrame()
{ 
	loadlanguage();	
}


function CheckForm(type)
{	
	with (getElById ("ConfigForm"))
	{
	  
	}
    return true;
}

function AddSubmitParam(SubmitForm,type)
{
}
</script>
</head>
<script language="JavaScript" type="text/javascript"> 
if (appName == "Microsoft Internet Explorer")
{
	document.write('<body onLoad="LoadFrame();" class="mainbody" scroll="auto">');
}
else
{
	document.write('<body onLoad="LoadFrame();" class="mainbody" >');
	document.write('<DIV style="overflow-x:hidden; overflow-y:auto; WIDTH: 100%; HEIGHT: 460px">');
}
</script>
<form id="ConfigForm"> 
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("dhcpinfotitle", GetDescFormArrayById(dhcpinfo_language, ""), GetDescFormArrayById(dhcpinfo_language, ""), false);
	if(TopoInfo.SSIDNum != 0)
	{
		  document.getElementById("dhcpinfotitle_content").innerHTML = dhcpinfo_language['bbsp_dhcpinfo_titile'];
	}else
	{
		  document.getElementById("dhcpinfotitle_content").innerHTML = dhcpinfo_language['bbsp_titile_nowifi'];
	}
</script>
<div class="title_spread"></div>

  <table class='width_per100' border="0" align="center" cellpadding="0" cellspacing="1" id='dhcpinfo'>  
    <tr> 
    <td class="table_title width_per35" BindText='bbsp_addrtotalnum'></td> 
    <td class="table_right width_65p" id="lanuser_TotalIpNum">0</td> 
	</tr>
	<tr> 
    <td class="table_title width_per35" BindText='bbsp_ethaddrnum'></td> 
    <td class="table_right width_per65"  id="lanuser_EthPortIpNum">0</td> 
	</tr>  
	<tr id="wifiaddrnumrow">
	<td class="table_title width_per35"  BindText='bbsp_wifiaddrnum'></td>
	<td class="table_right width_65p" id="lanuser_WifiPortIpNum">0</td>
	</tr>
    <tr> 
    <td class="table_title width_per35" BindText='bbsp_leftaddrnum'></td> 
    <td class="table_right width_65p" id="lanuser_LeftIpAddrNum">0</td> 
	</tr> 
	 <div class="func_spread"></div>
  </table> 
 
  <table class='width_per100' border="0" align="center" cellpadding="0" cellspacing="1" id="dhcpinfodat"> 
    <tr class="head_title"> 
      <td BindText = 'bbsp_hostname'></td> 
      <td BindText = 'bbsp_ip'></td> 
      <td BindText = 'bbsp_mac'></td> 
      <td BindText = 'bbsp_leased'></td> 
      <td BindText = 'bbsp_devtype'></td> 
    </tr> 
    <tr class="tabal_center01 trTabContent">
           <td style="width:20%">--</td>
           <td style="width:20%">--</td>
           <td style="width:20%">--</td>
           <td style="width:20%">--</td>
           <td style="width:20%">--</td>
     </tr>

	<script language="JavaScript" type="text/javascript"> 
		function FillDhcpInfo(info)
		{
			var MyTable = document.getElementById("dhcpinfodat");
			var result = "";
			
			for(i=1;i<MyTable.rows.length;i++)
			{
				MyTable.deleteRow(i);
			}

			for(i=0;i<info.length-1;i++)
			{
				if (0 == info[i].remaintime)
				{
					continue;
				}
				
				result += "<tr class='tabal_center01 trTabContent'><td>"+GetStringContent(info[i].name, MAX_HOST_TYPE)+"</td>";
				result += "<td>"+info[i].ip+"</td>";
				result += "<td>"+info[i].mac+"</td>";
				result += "<td>"+info[i].remaintime+dhcpinfo_language['bbsp_sec']+"</td>";
				result += "<td>"+GetStringContent(info[i].devtype, MAX_DEV_TYPE)+"</td></tr>";
			}

			if (0 == result.length)
			{
				result = "<tr class='tabal_center01 trTabContent'><td>--</td>";
				result += "<td>--</td>";
				result += "<td>--</td>";
				result += "<td>--</td>";
				result += "<td>--</td></tr>";
			}

			$("#dhcpinfodat").append(result);
		}

		function FillAllNum(lanuserdhcpinfo, lanuserdevinfo)
		{
			CalcIpNumOfPortType(lanuserdhcpinfo, lanuserdevinfo);
			TotalIpNum = (1 == MainDhcpInfos[0].enable) ? CalcTotalIpNum() : 0;
			ActiveIpNum = (1 == MainDhcpInfos[0].enable) ? CalcActiveIpNum() : 0;
			LeftIpAddrNum = TotalIpNum - ActiveIpNum;
	
			$("#lanuser_TotalIpNum").text(TotalIpNum);
			$("#lanuser_EthPortIpNum").text(EthPortIpNum);
			
			if (TopoInfo.SSIDNum != 0)
			{
				$("#lanuser_WifiPortIpNum").text(WifiPortIpNum);
				$("#wifiaddrnumrow").show();
			}
			else
			{
			   $("#wifiaddrnumrow").hide();
			}

			$("#lanuser_LeftIpAddrNum").text(LeftIpAddrNum);
		}

		if(TopoInfo.SSIDNum <= 0)
		{
			$("#wifiaddrnumrow").hide();
		}

	

		GetLanUserInfo(function(lanuserdhcpinfo, lanuserdevinfo)
		{
			
			FillAllNum(lanuserdhcpinfo, lanuserdevinfo);
			FillDhcpInfo(lanuserdhcpinfo);
			
		});
	</script> 
  </table> 
</form> 
<script language="JavaScript" type="text/javascript"> 
document.write('</DIV>');
</script>
</body>
</html>
