<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/userinfo.asp"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<script language="javascript" src="../common/wan_control.asp"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<title>WAN Information</title>
<script>
var MobileBackupWanSwitch = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Mobile_Backup.Enable);%>';
if (MobileBackupWanSwitch == '')
{
	MobileBackupWanSwitch = 0;
}

function PONPackageInfo(domain,PacketsSent,PacketsReceived)
{
	this.PacketsSent=PacketsSent;
	this.PacketsReceived=PacketsReceived;
}

function dhcpmainst(domain,enable,MainDNS)
{
	this.domain     = domain;
	this.enable     = enable;
	if(MainDNS == "")
	{
		this.MainPriDNS = "";
		this.MainSecDNS = "";
	}
	else
	{
		var MainDnss    = MainDNS.split(',');
		this.MainPriDNS = MainDnss[0];
		this.MainSecDNS  = MainDnss[1];
		if (MainDnss.length <=1)
		{
			this.MainSecDNS = "";
		}
	}
}

function stLanHostInfo(domain,ipaddr,subnetmask)
{
	this.domain = domain;
	this.ipaddr = ipaddr;
	this.subnetmask = subnetmask;
}

var TELMEX = false;
var IPv4VendorId="--"
var PackageList =  "";
var ponPackage = "";
if (GetCfgMode().TELMEX == "1")
{
	TELMEX = true;
	PackageList =  <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetPonPackageStat, InternetGatewayDevice.WANDevice.1.X_HW_PonInterface.Stats,PacketsSent|PacketsReceived,PONPackageInfo);%>;
	ponPackage = PackageList[0];
}
else
{
	TELMEX = false;
}

var MainDhcpRange = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaMainDhcpPool,InternetGatewayDevice.LANDevice.1.LANHostConfigManagement,DHCPServerEnable|X_HW_DNSList,dhcpmainst);%>;
var dhcpmain = MainDhcpRange[0];
var LanHostInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},IPInterfaceIPAddress|IPInterfaceSubnetMask,stLanHostInfo);%>;
var LanHostInfo = LanHostInfos[0];
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
var curCfgMode ='<%HW_WEB_GetCfgMode();%>';
function IsRDSGatewayUser()
{
	if('RDSGATEWAY' == curCfgMode.toUpperCase() && curUserType != sysUserType)
	{
		return true;
	}
	else
	{
		return false;
	}
}
function IsSonetUser()
{
	if(('SONET' == curCfgMode.toUpperCase() || 'JAPAN8045D' == curCfgMode.toUpperCase())
	   && curUserType != '0')
	{
		return true;
	}
	else
	{
		return false;
	}
}

function IsPtvdfUser()
{
	if('PTVDF' == curCfgMode.toUpperCase() && curUserType != '0')
	{
		return true;
	}
	else
	{
		return false;
	}
}

var ClickWanType = "";
function selectLineipv4(id)
{
	if(true == IsRDSGatewayUser())
	{
		return;
	}
	ClickWanType = "IPV4";
	selectLine(id);
}

function selectLineipv6(id)
{
	ClickWanType = "IPV6";
	selectLine(id);
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
		b.innerHTML = waninfo_language[b.getAttribute("BindText")];
	}
}
function PPPLastErrTrans(ErrCode)
{
	var errStr = "";
	switch(ErrCode)
	{
		case 'ERROR_USER_DISCONNECT':
		  errStr = waninfo_language['Telmex_UserDisconn_err'];
		  break;
		case 'ERROR_ISP_DISCONNECT':
		  errStr = waninfo_language['Telmex_ISPDisconn_err'];
		  break;
	  case 'ERROR_IDLE_DISCONNECT':
		errStr = waninfo_language['Telmex_IdleDisconn_err'];
		  break;
		case 'ERROR_AUTHENTICATION_FAILURE':
		  errStr = waninfo_language['Telmex_AuthFailuer_err'];
		  break;
		default:
		  errStr = waninfo_language['Telmex_ConnTimeout_err'];
		  break;
	}
	return errStr;
}

function GetIPv4PPPoeError(CurrentWan)
{
	var errStr = "";
	if (GetOntState()!= "ONLINE")
	{
		errStr = waninfo_language['bbsp_wanerror_offline'];
		return errStr;
	}

	if (CurrentWan.Enable == "0")
	{
		errStr = waninfo_language['bbsp_wanerror_disable'];
		return errStr;
	}

	if((CurrentWan.ConnectionTrigger == "Manual") && (CurrentWan.ConnectionControl == "0"))
	{
	   errStr = waninfo_language['bbsp_wanerror_nodial'];
	   return errStr;
	}

	if (CurrentWan.Status.toUpperCase() == "UNCONFIGURED")
	{
		errStr = waninfo_language['bbsp_wanerror_noaddress'];
		return errStr;
	}

	if (CurrentWan.IPv4Enable == "1" && CurrentWan.IPv6Enable == "1")
	{
		errStr = waninfo_language['bbsp_wanerror_noaddress'];
		return errStr;
	}

	switch(CurrentWan.LastConnErr)
	{
		case "ERROR_NOT_ENABLED_FOR_INTERNET":
			errStr = waninfo_language['bbsp_wanerror_neg'];
			break;

		case "ERROR_AUTHENTICATION_FAILURE":
			errStr = waninfo_language['bbsp_wanerror_usrpass'];
			break;

		case "ERROR_ISP_DISCONNECT":
			errStr = waninfo_language['bbsp_wanerror_srvdown'];
			break;

		case "ERROR_ISP_TIME_OUT":
			errStr = waninfo_language['bbsp_wanerror_timeout'];
			break;

		case "ERROR_IDLE_DISCONNECT":
			errStr = waninfo_language['bbsp_wanerror_notraffic'];
			break;

		default:
			errStr = waninfo_language['bbsp_wanerror_noaddress'];
			break;
	}

	return errStr;

}


function IsDisplayIPv6DialCode(Origin, lla, gua)
{

	if (lla != "")
	{
		return false;
	}

	return true;
}

function GetIPv6PPPoeError(CurrentWan, lla, gua)
{
	var errStr = "";

	if (GetOntState()!= "ONLINE")
	{
		errStr = waninfo_language['bbsp_wanerror_offline'];
		return errStr;
	}

	if (CurrentWan.Enable == "0")
	{
		errStr = waninfo_language['bbsp_wanerror_disable'];
		return errStr;
	}

	if (CurrentWan.IPv4Enable == "1" && CurrentWan.IPv6Enable == "1")
	{
		errStr = waninfo_language['bbsp_wanerror_noaddress'];
		return errStr;
	}

	switch(CurrentWan.LastConnErr)
	{
		case "ERROR_NOT_ENABLED_FOR_INTERNET":
			errStr = waninfo_language['bbsp_wanerror_neg'];
			break;

		case "ERROR_AUTHENTICATION_FAILURE":
			errStr = waninfo_language['bbsp_wanerror_usrpass'];
			break;

		case "ERROR_ISP_DISCONNECT":
			errStr = waninfo_language['bbsp_wanerror_srvdown'];
			break;

		case "ERROR_ISP_TIME_OUT":
			errStr = waninfo_language['bbsp_wanerror_timeout'];
			break;

		case "ERROR_IDLE_DISCONNECT":
			errStr = waninfo_language['bbsp_wanerror_notraffic'];
			break;

		default:
			errStr = waninfo_language['bbsp_wanerror_noaddress'];
			break;
	}

	return errStr;

}
function ChangeLanguageWanStatus(WanStatus)
{
	if ("DISCONNECTED" == WanStatus.toUpperCase())
	{
		return waninfo_language['bbsp_waninfo_disconnected'];
	}
	else if ("CONNECTED" == WanStatus.toUpperCase())
	{
		return waninfo_language['bbsp_waninfo_connected'];
	}
	else if ("UNCONFIGURED" == WanStatus.toUpperCase())
	{
		return waninfo_language['bbsp_waninfo_unconfigured'];
	}
		else if ("CONNECTING" == WanStatus.toUpperCase())
	{
		return waninfo_language['bbsp_waninfo_connecting'];
	}
	else
	{
		return WanStatus;
	}
}


function convertDHCPLeaseTimeRemaining(DHCPLeaseTimeRemaining)
{
	if('0' == DHCPLeaseTimeRemaining || '' == DHCPLeaseTimeRemaining)
	{
	   return "";
	}
	else
	{
	   return DHCPLeaseTimeRemaining;
	}

}

function LoadFrame()
{
	if( window.location.href.indexOf("?") > 0)
	{
		var WanPage = window.location.href.split("?")[1];
	}
	if(true == IsRDSGatewayUser())
	{
		setDisplay("IPv6PrefixPanelRds", 1);
	}
	if((true == IsRDSGatewayUser()) || (true == IsPtvdfUser()))
	{
		setDisplay("IPv6TitleInfoBar", 0);
		setDisplay("IPv6PrefixPanel", 0);
		
		setDisplay("IPv6AddressPanel", 0);
	}
}

</script>
</head>
<body class="mainbody" onLoad="LoadFrame();">
<script language="javascript" src="../common/ontstate.asp"></script>
<script language="javascript" src="../common/wanipv6state.asp"></script>
<script language="javascript" src="../common/wanaddressacquire.asp"></script>
<script type="text/javascript" language="javascript">
if (true == TELMEX)
{
	document.write('<div style="overflow-x:auto;overflow-y:auto;width:100%; height:100%;">');
}
</script>
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("waninfo", GetDescFormArrayById(waninfo_language, "bbsp_mune"), GetDescFormArrayById(waninfo_language, "bbsp_waninfo_titile"), false);
</script>
<script type="text/javascript" language="javascript">
if (true == TELMEX)
{
	document.write('<div id="IPTable">');
}
else
{
	document.write('<div  id="IPTable" style="overflow-x:auto;overflow-y:hidden;width:100%;">');
}
</script>
<div class="title_spread"></div>

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="func_title"> 
<tr><td class="width_per100" BindText="bbsp_ipv4info"></td></tr></table>  

<table class="tabal_bg width_per100"  cellspacing="1" id="IPv4Panel">
  <tr class="head_title">
   <script type="text/javascript" language="javascript">
		if (false == IsRDSGatewayUser())
		{
			document.write('<td>'+waninfo_language['bbsp_wanname']+'</td>');
		}
	</script>
	<td BindText = 'bbsp_linkstate'></td>
	<td BindText = 'bbsp_ipmode'></td>
	<td BindText = 'bbsp_ip'></td>
	<td BindText = 'bbsp_mask'></td>
		<script type="text/javascript" language="javascript">
		if(false == IsSonetUser() && false == IsRDSGatewayUser() && false == IsPtvdfUser())
		{
			document.write('<td>'+waninfo_language['bbsp_vlanpri']+'</td>');
		}
	  </script>
	<td BindText = 'bbsp_mac'></td>
	<script type="text/javascript" language="javascript">
		if (false == IsRDSGatewayUser())
		{
			document.write('<td>'+waninfo_language['bbsp_con']+'</td>');
		}
		</script>
  </tr>
	<script type="text/javascript" language="javascript">

	function replaceSpace(str)
	{
		if(str.indexOf(" ")!=-1)
		{
			str=str.replace(/ /g,"&#160;");
		}
		return str;
	}

	function AddTimeUnit(time,timeunit)
	{
		if(time.toString().length == 0||(time == "--"))
			return time;
		else
			return time.toString() +" "+ timeunit;
	}


	function FormatDigit(Number)
	{
		if (Number < 10)
		{
			return ('0' + Number);
		}
		else
		{
			return Number;
		}
	}

	function DisplayIPv6WanDetail(WanIndex)
	{
		var CurrentWan = GetWanList()[WanIndex];
		var ipv6Wan = GetIPv6WanInfo(CurrentWan.MacId);
		var AddressAcquire = GetIPv6AddressAcquireInfo(CurrentWan.domain);
		var AddressList = GetIPv6AddressList(CurrentWan.MacId);
		var AcquireHtml = "";
		var AddressHtml = "";
		var AddressStatusHtml = "";
		var AddressPreferredTimeHtml = "";
		var AddressValidTimeHtml = "";
		var AddressValidTimeRemainingHtml="";

		for (var m = 0; m < AddressList.length; m++)
		{
			if (AddressList[m].Origin.toUpperCase() != "LINKLOCAL")
			{
				if (CurrentWan.Enable == "1")
				{
					if(AddressHtml == '')
						AddressHtml += AddressList[m].IPAddress;
					else
						AddressHtml += "<br>" + AddressList[m].IPAddress;

					if(AddressStatusHtml == '')
						AddressStatusHtml += AddressList[m].IPAddressStatus;
					else
						AddressStatusHtml += "<br>" +  AddressList[m].IPAddressStatus;

					if(AddressPreferredTimeHtml == '')
						AddressPreferredTimeHtml += AddressList[m].PreferredTime;
					else
						AddressPreferredTimeHtml += "<br>" +  AddressList[m].PreferredTime;

					if(AddressValidTimeHtml == '')
						AddressValidTimeHtml += AddressList[m].ValidTime;
					else
						AddressValidTimeHtml += "<br>" +  AddressList[m].ValidTime;

					if(AddressValidTimeRemainingHtml == '')
					{
						AddressValidTimeRemainingHtml += convertDHCPLeaseTimeRemaining(AddressList[m].ValidTimeRemaining);
					}
					else
					{
						AddressValidTimeRemainingHtml += "<br>" +  convertDHCPLeaseTimeRemaining(AddressList[m].ValidTimeRemaining);
					}
				}
			}
		}

		setDisplay("IPv6WanDetail",1);
		setDisplay("ipv6InformationForm",1);
		if (GetCfgMode().BJUNICOM == "1")
		{
			CurrentWan.MACAddress = ConvertMac(CurrentWan.MACAddress);
		}
		document.getElementById("IPv6MacAddress").innerHTML = CurrentWan.MACAddress;		
		document.getElementById("IPv6PriorityPolicy").innerHTML = ('SPECIFIED' == CurrentWan.PriorityPolicy.toUpperCase()) ? waninfo_language['bbsp_wanpriority'] : waninfo_language['bbsp_wandefaultpri'];

		if ( 0 == parseInt(CurrentWan.VlanId,10) )
		{
			if((ipv6Wan.ConnectionStatus.toUpperCase()=="CONNECTED") && (CurrentWan.Mode == 'IP_Routed') )
			{
				document.getElementById("IPv6Vlan").innerHTML = "";
				document.getElementById("IPv6Priority").innerHTML = "";
				document.getElementById("IPv6PriorityPolicy").innerHTML = "";
			}
			else
			{
				document.getElementById("IPv6Vlan").innerHTML = "--";
				document.getElementById("IPv6Priority").innerHTML = "--";
				document.getElementById("IPv6PriorityPolicy").innerHTML = "--";
			}
		}
		else
		{
			document.getElementById("IPv6Vlan").innerHTML = CurrentWan.VlanId;
			document.getElementById("IPv6Priority").innerHTML = ('SPECIFIED' == CurrentWan.PriorityPolicy.toUpperCase()) ? CurrentWan.Priority : CurrentWan.DefaultPriority;
			document.getElementById("IPv6PriorityPolicy").innerHTML = waninfo_language[CurrentWan.PriorityPolicy];
		}

		if(true == IsSonetUser())
		{
			setDisplay("IPv6VlanRow",0);
			setDisplay("IPv6PriorityPolicyRow",0);
			setDisplay("IPv6PriorityRow",0);
		}

		if('IP_Routed' == CurrentWan.Mode)
		{
			setDisplay("IPv6GateWayRow",1);
			setDisplay("IPv6DnsServerRow",1);
			setDisplay("IPv6PrefixRow",1);
			setDisplay("IPv6PrefixModeRow",1);
			setDisplay("IPv6PrefixPreferredTimeRow",1);
			setDisplay("IPv6PrefixVaildTimeRow",1);
			setDisplay("IPv6PrefixVaildTimeRemainingRow",1);
			setDisplay("IPv6IpAddressRow",1);
			setDisplay("IPv6IpAccessModeRow",1);
			setDisplay("Ipv6IpStateRow",1);
			setDisplay("IPv6PreferredTimeRow",1);
			setDisplay("IPv6VaildTimeRow",1);
			setDisplay("IPv6VaildTimeRemainingRow",1);
			setDisplay("IPv6DsliteAftrnameRow",1);
			setDisplay("IPv6DslitePeerAddressRow",1);
			

			if(true == IsSonetUser())
			{
				setDisplay("IPv6IpAccessModeRow",0);
				setDisplay("Ipv6IpStateRow",0);
				setDisplay("IPv6PreferredTimeRow",0);
				setDisplay("IPv6VaildTimeRow",0);
				setDisplay("IPv6DsliteAftrnameRow",0);
				setDisplay("IPv6VaildTimeRemainingRow",0);
				setDisplay("IPv6DslitePeerAddressRow",0);
			}

			var PrefixList = GetIPv6PrefixList(CurrentWan.MacId);
			var Prefix = ((PrefixList!=null)?(PrefixList.length > 0?PrefixList[0].Prefix:'') :(PrefixList[0].Prefix));
			Prefix = (CurrentWan.Enable == "1") ? Prefix : "";

			var PrefixAcquire = GetIPv6PrefixAcquireInfo(CurrentWan.domain);
			PrefixAcquire = ((PrefixAcquire==null) ? '' : PrefixAcquire.Origin);
			document.getElementById("IPv6PrefixMode").innerHTML = PrefixAcquire;

			AcquireHtml = AddressAcquire.Origin;
			document.getElementById("IPv6IpAccessMode").innerHTML = AcquireHtml;

			var PrefixPreferredTime = ((PrefixList!=null)?(PrefixList.length > 0?PrefixList[0].PreferredTime:'') :(PrefixList[0].PreferredTime));
			PrefixPreferredTime = ((CurrentWan.Enable == "1") && (Prefix.length != 0))? PrefixPreferredTime : "";

			var PrefixValidTime = ((PrefixList!=null)?(PrefixList.length > 0?PrefixList[0].ValidTime:'') :(PrefixList[0].ValidTime));
			PrefixValidTime = ((CurrentWan.Enable == "1") && (Prefix.length != 0)) ? PrefixValidTime : "";

			var PrefixValidTimeRemaining = ((PrefixList!=null)?(PrefixList.length > 0?PrefixList[0].ValidTimeRemaining:'') :(PrefixList[0].ValidTimeRemaining));
			PrefixValidTimeRemaining = ((CurrentWan.Enable == "1") && (Prefix.length != 0)) ? PrefixValidTimeRemaining : "";
			PrefixValidTimeRemaining = convertDHCPLeaseTimeRemaining(PrefixValidTimeRemaining);

			if("CONNECTED" == ipv6Wan.ConnectionStatus.toUpperCase() )
			{
				document.getElementById("IPv6GateWay").innerHTML = ipv6Wan.DefaultRouterAddress;
				document.getElementById("IPv6DnsServer").innerHTML = ipv6Wan.DNSServers;
				document.getElementById("IPv6PreferredTime").innerHTML = AddTimeUnit(AddressPreferredTimeHtml,waninfo_language['bbsp_timeunit']);
				document.getElementById("IPv6VaildTime").innerHTML = AddTimeUnit(AddressValidTimeHtml,waninfo_language['bbsp_timeunit']);
				document.getElementById("IPv6VaildTimeRemaining").innerHTML = AddTimeUnit(AddressValidTimeRemainingHtml,waninfo_language['bbsp_timeunit']);
				document.getElementById("IPv6Prefix").innerHTML = Prefix;
				document.getElementById("IPv6PrefixPreferredTime").innerHTML = AddTimeUnit(PrefixPreferredTime,waninfo_language['bbsp_timeunit']);
				document.getElementById("IPv6PrefixVaildTime").innerHTML = AddTimeUnit(PrefixValidTime,waninfo_language['bbsp_timeunit']);
				document.getElementById("IPv6PrefixVaildTimeRemaining").innerHTML = AddTimeUnit(PrefixValidTimeRemaining,waninfo_language['bbsp_timeunit']);
				document.getElementById("IPv6IpAddress").innerHTML = AddressHtml;
				document.getElementById("Ipv6IpState").innerHTML = AddressStatusHtml;
				document.getElementById("IPv6DsliteAftrname").innerHTML = CurrentWan.IPv6AFTRName;
				document.getElementById("IPv6DslitePeerAddress").innerHTML = ipv6Wan.AFTRPeerAddr;

			}
			else
			{
				document.getElementById("IPv6GateWay").innerHTML = "--";
				document.getElementById("IPv6DnsServer").innerHTML = "--";
				document.getElementById("IPv6PreferredTime").innerHTML = "--";
				document.getElementById("IPv6VaildTime").innerHTML = "--";
				document.getElementById("IPv6Prefix").innerHTML = "--";
				document.getElementById("IPv6PrefixPreferredTime").innerHTML = "--";
				document.getElementById("IPv6PrefixVaildTime").innerHTML = "--";
				document.getElementById("IPv6PrefixVaildTimeRemaining").innerHTML = "--";
				document.getElementById("IPv6IpAddress").innerHTML = "--";
				document.getElementById("Ipv6IpState").innerHTML = "--";
				document.getElementById("IPv6DsliteAftrname").innerHTML = "--";
				document.getElementById("IPv6DslitePeerAddress").innerHTML = "--";
		  }

		  if('IPoE' == CurrentWan.EncapMode)
		  {
			  setDisplay("IPv6DialCodeRow",0);
		  }
		  else
		  {
			  var lla = "";
			  var gua = "";
			  for (var m = 0; m < AddressList.length; m++)
			  {
					if (AddressList[m].Origin.toUpperCase() != "LINKLOCAL")
					{
						gua = AddressList[m].IPAddress;
					}
					else
					{
						lla = AddressList[m].IPAddress;
					}
			  }

			  if (IsDisplayIPv6DialCode(AddressAcquire.Origin, lla, gua) == false)
			  {
				  setDisplay("IPv6DialCodeRow",0);
			  }
			  else
			  {
				  setDisplay("IPv6DialCodeRow",1)

				  var error = GetIPv6PPPoeError(CurrentWan, lla, gua);
				  document.getElementById("IPv6DialCode").innerHTML = error;
			  }
		  }

		  if (true == TELMEX)
		  {
			  setDisplay("IPv6DialCodeRow",0);
		  }

		}
		else
		{	
			setDisplay("IPv6GateWayRow",0);
			setDisplay("IPv6DnsServerRow",0);
			setDisplay("IPv6PrefixRow",0);
			setDisplay("IPv6PrefixModeRow",0);
			setDisplay("IPv6PrefixPreferredTimeRow",0);
			setDisplay("IPv6PrefixVaildTimeRow",0);
			setDisplay("IPv6PrefixVaildTimeRemainingRow",0);
			setDisplay("IPv6IpAddressRow",0);
			setDisplay("IPv6IpAccessModeRow",0);
			setDisplay("Ipv6IpStateRow",0);
			setDisplay("IPv6PreferredTimeRow",0);
			setDisplay("IPv6VaildTimeRow",0);
			setDisplay("IPv6DsliteAftrnameRow",0);
			setDisplay("IPv6VaildTimeRemainingRow",0);
			setDisplay("IPv6DslitePeerAddressRow",0);
			setDisplay("IPv6DialCodeRow",0);
		}
		var days = 0;
		var hours = 0;
		var minutes = 0;
		var seconds = 0;
		seconds = ipv6Wan.V6UpTime%60;
		minutes = Math.floor(ipv6Wan.V6UpTime/60);
		hours  = Math.floor(minutes/60);
		minutes = minutes%60;
		days = Math.floor(hours/24);
		hours = hours%24;

		setDisplay("V6UpTimeRow",1);

		if (days != '0' || hours != '0' || minutes != '0' || seconds != '0')
		{
			 document.getElementById("V6UpTime").innerHTML
				= FormatDigit(days) + ':' + FormatDigit(hours) + ':' + FormatDigit(minutes) + ':' + FormatDigit(seconds);
		}
		else
		{
			document.getElementById("V6UpTime").innerHTML = "--";
		}
	}

	function GetStaticRouteInfo(string)
	{
		if (typeof(string) != "undefined") {
			document.getElementById("StaticRoute").innerHTML = string;
		}
	}

	function GetOption121(wanindex)
	{
		var Option121Info="";

		$.ajax({
			type : "POST",
			async : true,
			cache : false,
			timeout : 2000,
			data : "x.X_HW_Token="+getValue('onttoken'),
			url : "option121.cgi?WANNAME=wan"+wanindex,
			success : function(data) {
				res = data.split("\n");
				GetStaticRouteInfo(res[1]);
			},
			complete: function (XHR, TS) {

				Option121Info=null;

				XHR = null;
		  }
		});
	}

	function DisplayIPv4WanDetail(WanIndex)
	{
		var CurrentWan = GetWanList()[WanIndex];
		document.getElementById("WanDetail").style.display = "";
		setDisplay("ipv4InformationForm",1);
		
		if (GetCfgMode().BJUNICOM == "1")
		{
			CurrentWan.MACAddress = ConvertMac(CurrentWan.MACAddress);
		}
		document.getElementById("MacAddress").innerHTML = CurrentWan.MACAddress;
		setText("MacAddress",CurrentWan.MACAddress);
		
		document.getElementById("PriorityColleft").innerHTML = ('SPECIFIED' == CurrentWan.PriorityPolicy.toUpperCase()) ? waninfo_language['bbsp_wanpriority'] : waninfo_language['bbsp_wandefaultpri'];
				
		if ( 0 == parseInt(CurrentWan.VlanId,10) )
		{
			if(("Connected" == CurrentWan.Status) && ('' != CurrentWan.IPv4IPAddress) )
			{
				document.getElementById("Vlan").innerHTML = "";
				document.getElementById("Priority").innerHTML = "";
				document.getElementById("PriorityPolicy").innerHTML = "";
			}
			else
			{
				document.getElementById("Vlan").innerHTML = "--";
				document.getElementById("Priority").innerHTML = "--";
				document.getElementById("PriorityPolicy").innerHTML = "--";
			}
		}
		else
		{
			document.getElementById("Vlan").innerHTML = CurrentWan.VlanId;
			document.getElementById("Priority").innerHTML = ('SPECIFIED' == CurrentWan.PriorityPolicy.toUpperCase()) ? CurrentWan.Priority : CurrentWan.DefaultPriority;
			document.getElementById("PriorityPolicy").innerHTML = waninfo_language[CurrentWan.PriorityPolicy];			
		}

		setDisplay("RDModeRow", 0);
		setDisplay("RDPrefixRow", 0);
		setDisplay("RDPrefixLenthRow", 0);
		setDisplay("RDBrAddrRow", 0);
		setDisplay("RDIpv4MaskLenthRow", 0);

		if(true == IsSonetUser())
		{		
			setDisplay("VlanRow",0);
			setDisplay("PriorityRow",0);
			setDisplay("PriorityPolicyRow",0);
		}

		if( 'IP_Routed' == CurrentWan.Mode )
		{
			document.getElementById("NatSwitch").innerHTML = CurrentWan.IPv4NATEnable == "1" ? waninfo_language['bbsp_enable']: waninfo_language['bbsp_disable'];
			
			setDisplay("NatSwitchRow",1);
			setDisplay("IpAdressRow",1);
			setDisplay("GateWayRow",1);
			setDisplay("DnsServerRow",1);			
			
			var servicetypeIsMatch = (-1 != CurrentWan.ServiceList.indexOf("INTERNET")) || (-1 != CurrentWan.ServiceList.indexOf("IPTV")) || (-1 != CurrentWan.ServiceList.indexOf("OTHER"));
			if( (1 == CurrentWan.IPv4Enable) && (0 == CurrentWan.IPv6Enable) &&
				(true == servicetypeIsMatch)&&(true == Is6RdSupported()))
			{
				setDisplay("RDModeRow", 1);
				document.getElementById("RDMode").innerHTML = CurrentWan.RdMode;
				if (1 == CurrentWan.Enable6Rd)
				{
					setDisplay("RDPrefixRow", 1);
					setDisplay("RDPrefixLenthRow", 1);
					setDisplay("RDBrAddrRow", 1);
					setDisplay("RDIpv4MaskLenthRow", 1);
					document.getElementById("RDPrefix").innerHTML = CurrentWan.RdPrefix;
					document.getElementById("RDPrefixLenth").innerHTML = CurrentWan.RdPrefixLen;
					document.getElementById("RDBrAddr").innerHTML = CurrentWan.RdBRIPv4Address;
					document.getElementById("RDIpv4MaskLenth").innerHTML = CurrentWan.RdIPv4MaskLen;					
				}
			}

			if(("Connected" == CurrentWan.Status ) && ('' != CurrentWan.IPv4IPAddress) )
			{
				document.getElementById("IpAdress").innerHTML = CurrentWan.IPv4IPAddress + "/" + CurrentWan.IPv4SubnetMask;
				document.getElementById("GateWay").innerHTML = CurrentWan.IPv4Gateway;
				
				if((true == TELMEX) && (dhcpmain.enable == 1))
				{
					if(((dhcpmain.MainPriDNS == "") && (dhcpmain.MainSecDNS == ""))
					|| (dhcpmain.MainPriDNS == LanHostInfo.ipaddr) || (dhcpmain.MainSecDNS == LanHostInfo.ipaddr))
					{
						document.getElementById("DnsServer").innerHTML = CurrentWan.IPv4PrimaryDNS + " " +CurrentWan.IPv4SecondaryDNS;
					}
					else
					{
						document.getElementById("DnsServer").innerHTML = CurrentWan.IPv4PrimaryDNS + " " +CurrentWan.IPv4SecondaryDNS + '<br>' + '<font color="red">' + waninfo_language['bbsp_waninfo_dnsser'] + '</font>';
					}
				}
				else
				{
					document.getElementById("DnsServer").innerHTML = CurrentWan.IPv4PrimaryDNS + " " +CurrentWan.IPv4SecondaryDNS;
				}
			}
			else
			{
				document.getElementById("IpAdress").innerHTML = "--";
				document.getElementById("GateWay").innerHTML = "--";
				document.getElementById("DnsServer").innerHTML = "--";
			}

			if('IPoE' == CurrentWan.EncapMode)
			{
				setDisplay("BrasNameRow",0);
				setDisplay("DialCodeRow",0);
				
				if ("STATIC" == CurrentWan.IPv4AddressMode.toUpperCase())
				{
					setDisplay("LeaseTimeRow",0);
					setDisplay("LeaseTimeRemainingRow",0);
					setDisplay("NtpServerRow",0);
					setDisplay("STimeRow",0);
					setDisplay("SipServerRow",0);
					setDisplay("StaticRouteRow",0);
					setDisplay("VenderInfoRow",0);
				}
				else
				{
					setDisplay("LeaseTimeRow",1);
					setDisplay("LeaseTimeRemainingRow",1);
					setDisplay("NtpServerRow",1);
					setDisplay("STimeRow",1);
					setDisplay("SipServerRow",1);
					setDisplay("StaticRouteRow",1);
					setDisplay("VenderInfoRow",1);
				}

				if(true == IsSonetUser())
				{
					setDisplay("SipServerRow",0);
					setDisplay("StaticRouteRow",0);
					setDisplay("VenderInfoRow",0);
				}
				if("Connected" == CurrentWan.Status)
				{
					document.getElementById("LeaseTime").innerHTML = AddTimeUnit(CurrentWan.DHCPLeaseTime,waninfo_language['bbsp_timeunit']);
					document.getElementById("LeaseTimeRemaining").innerHTML = AddTimeUnit(convertDHCPLeaseTimeRemaining(CurrentWan.DHCPLeaseTimeRemaining),waninfo_language['bbsp_timeunit']);
					document.getElementById("NtpServer").innerHTML = CurrentWan.NTPServer;
					document.getElementById("STime").innerHTML = CurrentWan.TimeZoneInfo;
					document.getElementById("SipServer").innerHTML = CurrentWan.SIPServer;
					
					document.getElementById("StaticRoute").innerHTML = "";
					if ("DHCP" == CurrentWan.IPv4AddressMode.toUpperCase())
					{
						GetOption121(CurrentWan.MacId);
					}
					else
					{
						document.getElementById("StaticRoute").innerHTML = CurrentWan.StaticRouteInfo;
					}
					IPv4VendorId = CurrentWan.IPv4VendorId;
					document.getElementById("VenderInfo").innerHTML = replaceSpace(GetStringContent(IPv4VendorId,16));
					document.getElementById("VenderInfo").title = IPv4VendorId;
				}
				else
				{
					document.getElementById("LeaseTime").innerHTML = "--";
					document.getElementById("LeaseTimeRemaining").innerHTML = "--";
					document.getElementById("NtpServer").innerHTML = "--";
					document.getElementById("STime").innerHTML = "--";
					document.getElementById("SipServer").innerHTML = "--";
					document.getElementById("StaticRoute").innerHTML = "--";
					document.getElementById("VenderInfo").innerHTML = "--";
				}
				if ( bin4board_nonvoice() == true )
				{				
					setDisplay("SipServerRow",0);
				}
			}
			else
			{			
				setDisplay("BrasNameRow",1);
				setDisplay("LeaseTimeRow",0);
				setDisplay("LeaseTimeRemainingRow",0);
				setDisplay("NtpServerRow",0);
				setDisplay("STimeRow",0);
				setDisplay("SipServerRow",0);
				setDisplay("StaticRouteRow",0);
				setDisplay("VenderInfoRow",0);			
				
				if("Connected" == CurrentWan.Status)
				{
					document.getElementById("BrasName").innerHTML = CurrentWan.PPPoEACName;
										
					setDisplay("DialCodeRow",0);
				}
				else
				{				
					setDisplay("DialCodeRow",1);
					
					var error = GetIPv4PPPoeError(CurrentWan);
					
					document.getElementById("DialCode").innerHTML = error;
					document.getElementById("BrasName").innerHTML = "--";
				}

				if (true == TELMEX)
				{
					setDisplay("DialCodeRow",0);
				}
			}
		}
		else
		{				
			setDisplay("NatSwitchRow",0);
			setDisplay("IpAdressRow",0);
			setDisplay("GateWayRow",0);
			setDisplay("DnsServerRow",0);
			setDisplay("BrasNameRow",0);
			setDisplay("LeaseTimeRow",0);
			setDisplay("LeaseTimeRemainingRow",0);
			setDisplay("NtpServerRow",0);
			setDisplay("STimeRow",0);
			setDisplay("SipServerRow",0);
			setDisplay("StaticRouteRow",0);
			setDisplay("VenderInfoRow",0);
			setDisplay("DialCodeRow",0);
		}


		var days = 0;
		var hours = 0;
		var minutes = 0;
		var seconds = 0;
		seconds = CurrentWan.Uptime%60;
		minutes = Math.floor( CurrentWan.Uptime/60);
		hours  = Math.floor(minutes/60);
		minutes = minutes%60;
		days = Math.floor(hours/24);
		hours = hours%24;

		setDisplay("V4UpTimeRow",1);

		if (days != '0' || hours != '0' || minutes != '0' || seconds != '0')
		{
			document.getElementById("V4UpTime").innerHTML
				= FormatDigit(days) + ':' + FormatDigit(hours) + ':' + FormatDigit(minutes) + ':' + FormatDigit(seconds);
		}
		else
		{
			document.getElementById("V4UpTime").innerHTML = "--";
		}
	}

	function setControl(WanIndex)
	{
		if (true == IsPtvdfUser())
		{
			return;
		}
		var CurrentWan = GetWanList()[WanIndex];
		var ProtocolType = GetProtocolType(CurrentWan.IPv4Enable, CurrentWan.IPv6Enable);
		if ("IPv4" == ProtocolType)
		{
			DisplayIPv4WanDetail(WanIndex);
		}
		else if ("IPv6" == ProtocolType)
		{
			DisplayIPv6WanDetail(WanIndex);
		}
		else if ("IPv4/IPv6" == ProtocolType)
		{
			if ("IPV4" == ClickWanType)
			{
				DisplayIPv4WanDetail(WanIndex);
			}
			else if ("IPV6" == ClickWanType)
			{
				DisplayIPv6WanDetail(WanIndex);
			}
		}
	}

	var IPv4WanCount = 0;
	var IPv6WanCount = 0;
	var IPv6WanRdsCount = 0;
	for (i = 0;i < GetWanList().length;i++)
	{
		var CurrentWan = GetWanList()[i];
		if ((CurrentWan.IPv4Enable != "1") ||
			((GetCfgMode().PTVDF == 1) && (IsAdminUser() == false) && (MobileBackupWanSwitch == 0) && (CurrentWan.Name.toUpperCase().indexOf("MOBILE") >=0)))
		{
			continue;
		}
		IPv4WanCount ++;

		document.write('<TR id="record_' + i + '" onclick="selectLineipv4(this.id);" class="tabal_01" align="center">');
		if (false == IsRDSGatewayUser())
		{
			document.write('<td>'+CurrentWan.Name+'</td>');
		}

		if (CurrentWan.Name.toUpperCase().indexOf("MOBILE") >=0)
		{
			document.write('<td>'+ChangeLanguageWanStatus(CurrentWan.Status)+'</td>');
		}
		else if (GetOntState()!='ONLINE')
		{
			document.write('<td>'+ChangeLanguageWanStatus('Disconnected')+'</td>');
		}
		else
		{
			if ("UNCONFIGURED" == CurrentWan.Status.toUpperCase())
			{
				document.write('<td>'+ChangeLanguageWanStatus('Disconnected')+'</td>');
			}
			else
			{
				document.write('<td>'+ChangeLanguageWanStatus(CurrentWan.Status)+'</td>');
			}
		}

		if (CurrentWan.Mode.toUpperCase().indexOf("BRIDGE") >= 0)
		{
				 document.write('<td align="center">--</td>');
		}
		else
		{
				document.write('<td align="center">'+CurrentWan.IPv4AddressMode+'</td>');
		}

		if((CurrentWan.Status=="Connected") && (CurrentWan.IPv4IPAddress != '') && (CurrentWan.Mode == 'IP_Routed'))
		{
			document.write('<td>'+CurrentWan.IPv4IPAddress + '</td>');
		}
		else
		{
			document.write('<td align="center">--</td>');
		}

		if((CurrentWan.Status=="Connected") && (CurrentWan.IPv4SubnetMask != '') && (CurrentWan.Mode == 'IP_Routed'))
		{
			document.write('<td>'+CurrentWan.IPv4SubnetMask+'</td>');
		}
		else
		{
			document.write('<td align="center">--</td>');
		}

		if(false == IsSonetUser() && false == IsRDSGatewayUser() && false == IsPtvdfUser())
		{
			if ( 0 != parseInt(CurrentWan.VlanId,10) )
			{
				var pri = ('Specified' == CurrentWan.PriorityPolicy) ? CurrentWan.Priority : CurrentWan.DefaultPriority ;
				document.write('<td>'+CurrentWan.VlanId+'/'+pri+'</td>');
			}
			else
			{
				document.write('<td>'+'-/-'+'</td>');
			}
		}

		if (GetCfgMode().BJUNICOM == "1")
		{
			CurrentWan.MACAddress = ConvertMac(CurrentWan.MACAddress);
		}

		if(CurrentWan.MACAddress != '')
		{
			document.write('<td>'+CurrentWan.MACAddress +'</td>');
		}
		else
		{
			document.write('<td align="center">--</td>');
		}

		if (false == IsRDSGatewayUser())
		{
		if (NeedAddConnectButton(CurrentWan) == true && CurrentWan.Enable == "1")
		{

			var btText = CurrentWan.ConnectionControl == "1" ? waninfo_language['bbsp_discon']: waninfo_language['bbsp_con'];
			var ctrFlag = CurrentWan.ConnectionControl == "1" ? "0": "1";
			document.write("<td align='center'><a style='color:blue' onclick = 'OnConnectionControlButton(this,"+i+","+ctrFlag+")' RecordId = '"+i+"' href='#'>"+btText+"</a></td>");
		}
		else
		{
			var innerText = CurrentWan.Enable == "1" ? "AlwaysOn":"AlwaysOn";
			if (CurrentWan.ConnectionTrigger == "OnDemand")
			{
				innerText = waninfo_language['bbsp_needcon'];
			}
			else if (CurrentWan.ConnectionTrigger == "Manual")
			{
				innerText = waninfo_language['bbsp_Manual'];
			}
			document.write("<td>"+innerText+"</td>");
		}
	 }
		document.write('</tr>');
	}
	if(0 == IPv4WanCount)
	{
		document.write("<tr class= \"tabal_01\" align=\"center\">");
		if(false == IsSonetUser() && false == IsPtvdfUser())
		{
			document.write('<td >'+'--'+'</td>');
		}
		if (false == IsRDSGatewayUser())
		{
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
	 }
		document.write('<td >'+'--'+'</td>');
		document.write('<td >'+'--'+'</td>');
		document.write('<td >'+'--'+'</td>');
		document.write('<td >'+'--'+'</td>');
		document.write("</tr>");
	}
	</script>
</table>

<div  align='center' style="display:none" id="WanDetail"> 
<div class="list_table_spread"></div>
<form id="ipv4InformationForm" name="ipv4InformationForm">
<table id="ipv4InformationFormPanel" class="tabal_bg width_per100"  cellspacing="1" >
<li id="wanInfoTitle" RealType="HorizonBar" DescRef="bbsp_wandetailinfo" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/> 
<li id="MacAddress" RealType="HtmlText" DescRef="bbsp_wanmacaddress" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="MacAddress" InitValue="Empty"/> 
<li id="Vlan" RealType="HtmlText" DescRef="bbsp_wanvlan" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Vlan" InitValue="Empty"/> 
<li id="PriorityPolicy" RealType="HtmlText" DescRef="bbsp_wanpripolicy" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="PriorityPolicy" InitValue="Empty"/> 
<li id="Priority" RealType="HtmlText" DescRef="bbsp_wanpriority" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Priority" InitValue="Empty"/> 
<li id="NatSwitch" RealType="HtmlText" DescRef="bbsp_wannat" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="NatSwitch" InitValue="Empty"/> 
<li id="IpAdress" RealType="HtmlText" DescRef="bbsp_wanip" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IpAdress" InitValue="Empty"/> 
<li id="GateWay" RealType="HtmlText" DescRef="bbsp_wangateway" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="GateWay" InitValue="Empty"/> 
<li id="DnsServer" RealType="HtmlText" DescRef="bbsp_wandns" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="DnsServer" InitValue="Empty"/> 
<li id="BrasName" RealType="HtmlText" DescRef="bbsp_wanbras" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="BrasName" InitValue="Empty"/> 
<li id="DialCode" RealType="HtmlText" DescRef="bbsp_wandialcode" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="DialCode" InitValue="Empty"/> 
<li id="LeaseTime" RealType="HtmlText" DescRef="bbsp_wanlease" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="LeaseTime" InitValue="Empty"/> 
<li id="LeaseTimeRemaining" RealType="HtmlText" DescRef="bbsp_wanlease_remaining" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="LeaseTimeRemaining" InitValue="Empty"/> 
<li id="NtpServer" RealType="HtmlText" DescRef="bbsp_wanntp" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="NtpServer" InitValue="Empty"/> 
<li id="STime" RealType="HtmlText" DescRef="bbsp_wanstime" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="STime" InitValue="Empty"/> 
<li id="SipServer" RealType="HtmlText" DescRef="bbsp_wansip" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="SipServer" InitValue="Empty"/> 
<li id="StaticRoute" RealType="HtmlText" DescRef="bbsp_wansroute" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="StaticRoute" InitValue="Empty"/> 
<li id="VenderInfo" RealType="HtmlText" DescRef="bbsp_wanvendor" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="VenderInfo" InitValue="Empty"/> 
<li id="RDMode" RealType="HtmlText" DescRef="Des6RDMode" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="RDMode" InitValue="Empty"/> 
<li id="RDPrefix" RealType="HtmlText" DescRef="Des6RDPrefix" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="RDPrefix" InitValue="Empty"/> 
<li id="RDPrefixLenth" RealType="HtmlText" DescRef="Des6RDPrefixLenth" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="RDPrefixLenth" InitValue="Empty"/> 
<li id="RDBrAddr" RealType="HtmlText" DescRef="Des6RDBrAddr" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="RDBrAddr" InitValue="Empty"/> 
<li id="RDIpv4MaskLenth" RealType="HtmlText" DescRef="Des6RDIpv4MaskLenth" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="RDIpv4MaskLenth" InitValue="Empty"/> 
<li id="V4UpTime" RealType="HtmlText" DescRef="uptime_tips" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="V4UpTime" InitValue="Empty"/> 
</table>

<script>
var TableClass = new stTableClass("align_left width_per30", "align_left width_per70", "ltr");
var Ipv4WanInfoFormList = new Array();
	Ipv4WanInfoFormList = HWGetLiIdListByForm("ipv4InformationForm",null);
	HWParsePageControlByID("ipv4InformationForm",TableClass,waninfo_language,null);
	var Ipv4WaninfoArray = new Array();
	
	HWSetTableByLiIdList(Ipv4WanInfoFormList,Ipv4WaninfoArray,null);
</script>
</form>
</div>

<div class="func_spread"></div>


<table width="100%" border="0" cellpadding="0" cellspacing="0" class="func_title" id="IPv6TitleInfoBar"> 
<tr><td class="width_per100" BindText="bbsp_inv6info"></td>
  	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
</tr></table>  

<table class="tabal_bg width_per100" cellspacing="1"  id="IPv6PrefixPanelRds" style="display:none">
  <tr class="head_title">
	<td BindText = 'bbsp_linkstate'></td>
	<td BindText = 'bbsp_ipmode'></td>
	<td BindText = 'bbsp_prefixmaskmode'></td>
	<td BindText = 'bbsp_ip'></td>
	<td BindText = 'bbsp_ipstate'></td>
  </tr>
  <script type="text/javascript" language="javascript">

		for (i = 0;i < GetWanList().length;i++)
		{
			var CurrentWan = GetWanList()[i];
			var AddressAcquire = GetIPv6AddressAcquireInfo(CurrentWan.domain);
				var AddressList = GetIPv6AddressList(CurrentWan.MacId);

			if (CurrentWan.IPv6Enable != "1")
			{
				continue;
			}

			IPv6WanRdsCount++;

			var ipv6Wan = GetIPv6WanInfo(CurrentWan.MacId);
			if (ipv6Wan == null)
			{
				continue;
			}

			document.write('<tr id="ipv6recordRds_' + i + '"  class="tabal_01" align="center">');
			document.write('<td>'+ChangeLanguageWanStatus(ipv6Wan.ConnectionStatus)+'</td>');

			var PrefixAcquire = GetIPv6PrefixAcquireInfo(CurrentWan.domain);
			PrefixAcquire = ((PrefixAcquire==null) ? '' : PrefixAcquire.Origin);
			PrefixAcquire = (CurrentWan.Mode.toUpperCase().indexOf("BRIDGE") >= 0) ? '--' : PrefixAcquire;

			var AcquireHtml = "";
			var AddressHtml = "";
			var AddressStatusHtml = "";
			for (var m = 0; m < AddressList.length; m++)
			{
				 AcquireHtml += (AddressList[m].Origin == ""?AddressAcquire.Origin:AddressList[m].Origin) +"<br>";
				 if (CurrentWan.Enable == "1")
				 {
					 AddressHtml += AddressList[m].IPAddress+"<br>";
					 AddressStatusHtml += AddressList[m].IPAddressStatus +"<br>";
				 }
			}

			if (CurrentWan.Mode.toUpperCase().indexOf("BRIDGE") >= 0)
			{
				AcquireHtml = "--<br>";
				AddressHtml = "--<br>";
				AddressStatusHtml = "--<br>";
			}

			document.write('<td>'+AcquireHtml+'</td>');
			document.write('<td>'+PrefixAcquire+'</td>');
			document.write('<td>'+AddressHtml+'</td>');
			document.write('<td>'+AddressStatusHtml+'</td>');

			document.write('</tr>');
		}

	if( 0 == IPv6WanRdsCount)
		{
			document.write("<tr class= \"tabal_01\" align=\"center\">");
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
			document.write("</tr>");
		}
		</script>
</table>
<table class="tabal_bg width_per100" cellspacing="1"  id="IPv6PrefixPanel">
  <tr class="head_title">
	<td BindText = 'bbsp_wanname'></td>
	<td BindText = 'bbsp_linkstate'></td>
	<td BindText = 'bbsp_prefixmaskmode'></td>
	<td BindText = 'bbsp_prefixmask'></td>
	<script type="text/javascript" language="javascript">
		if(false == IsSonetUser() && false == IsPtvdfUser())
		{
			document.write('<td>'+waninfo_language['bbsp_vlanpri']+'</td>');
		}
	</script>
	<td BindText = 'bbsp_mac'></td>
	<td BindText = 'bbsp_gateway'></td>
  </tr>
  <script type="text/javascript" language="javascript">

		for (i = 0;i < GetWanList().length;i++)
		{
			var CurrentWan = GetWanList()[i];

			if (CurrentWan.IPv6Enable != "1")
			{
				continue;
			}

			IPv6WanCount++;

			var ipv6Wan = GetIPv6WanInfo(CurrentWan.MacId);
			if (ipv6Wan == null)
			{
				continue;
			}

			document.write('<tr id="ipv6record_' + i + '" onclick="selectLineipv6(this.id);" class="tabal_01" align="center">');
			document.write('<td>'+CurrentWan.Name+'</td>');
			document.write('<td>'+ChangeLanguageWanStatus(ipv6Wan.ConnectionStatus)+'</td>');

			var PrefixAcquire = GetIPv6PrefixAcquireInfo(CurrentWan.domain);
			PrefixAcquire = ((PrefixAcquire==null) ? '' : PrefixAcquire.Origin);
			PrefixAcquire = (CurrentWan.Mode.toUpperCase().indexOf("BRIDGE") >= 0) ? '--' : PrefixAcquire;
			document.write('<td>'+PrefixAcquire+'</td>');

			var PrefixList = GetIPv6PrefixList(CurrentWan.MacId)
			var Prefix = ((PrefixList!=null)?(PrefixList.length > 0?PrefixList[0].Prefix:'') :(PrefixList[0].Prefix));
			Prefix = (CurrentWan.Enable == "1") ? Prefix : "";
			Prefix = (CurrentWan.Mode.toUpperCase().indexOf("BRIDGE") >= 0) ? '--' : Prefix;
			if(ipv6Wan.ConnectionStatus.toUpperCase()=="CONNECTED")
			{
				document.write('<td class="restrict_dir_ltr">'+Prefix+ '</td>');
			}
			else
			{
				document.write('<td>'+'--'+ '</td>');
			}

			if(false == IsSonetUser() && false == IsPtvdfUser())
			{
				if (0 != parseInt(CurrentWan.VlanId,10))
				{
					var pri = ('Specified' == CurrentWan.PriorityPolicy) ? CurrentWan.Priority : CurrentWan.DefaultPriority ;
					document.write('<td>'+CurrentWan.VlanId+'/'+pri+'</td>');
				}
				else
				{
					document.write('<td>'+'-/-'+'</td>');
				}
			}

			if (GetCfgMode().BJUNICOM == "1")
			{
				CurrentWan.MACAddress = ConvertMac(CurrentWan.MACAddress);
			}

			if(CurrentWan.MACAddress != '')
			{
				document.write('<td>'+CurrentWan.MACAddress +'</td>');
			}
			else
			{
				document.write('<td >--</td>');
			}

			var ipv6WanForGw = GetIPv6WanInfo(CurrentWan.MacId);
			var IPv6Gw = ipv6WanForGw.DefaultRouterAddress;
			if( null == IPv6Gw || "" == IPv6Gw)
			{
				IPv6Gw = "--";
			}

			document.write('<td align="center" class="restrict_dir_ltr">'+IPv6Gw+'</td>');

			document.write('</tr>');
		}

		if( 0 == IPv6WanCount)
		{
			document.write("<tr class= \"tabal_01\" align=\"center\">");
			if(false == IsSonetUser() && false == IsPtvdfUser())
			{
				document.write('<td >'+'--'+'</td>');
			}
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
			document.write("</tr>");
		}
		</script>
</table>

<div  align='center' style="display:none" id="IPv6WanDetail">
<div class="list_table_spread"></div>
<form id="ipv6InformationForm" name="ipv6InformationForm">
<table id="ipv6InformationFormPanel" class="tabal_bg width_per100"  cellspacing="1">
<li id="IPv6WanDetailTitle" RealType="HorizonBar" DescRef="bbsp_wandetailinfo" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" InitValue="Empty"/> 
<li id="IPv6MacAddress" RealType="HtmlText" DescRef="bbsp_wanmacaddress" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6MacAddress" InitValue="Empty"/> 
<li id="IPv6Vlan" RealType="HtmlText" DescRef="bbsp_wanvlan" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6Vlan" InitValue="Empty"/> 
<li id="IPv6PriorityPolicy" RealType="HtmlText" DescRef="bbsp_wanpripolicy" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6PriorityPolicy" InitValue="Empty"/> 
<li id="IPv6Priority" RealType="HtmlText" DescRef="bbsp_wanpriority" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6Priority" InitValue="Empty"/> 
<li id="IPv6DnsServer" RealType="HtmlText" DescRef="bbsp_wandns" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6DnsServer" InitValue="Empty"/> 
<li id="IPv6Prefix" RealType="HtmlText" DescRef="bbsp_ipv6prefix" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6Prefix" InitValue="Empty"/> 
<li id="IPv6PrefixMode" RealType="HtmlText" DescRef="bbsp_ipv6prefixmode" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6PrefixMode" InitValue="Empty"/> 
<li id="IPv6PrefixPreferredTime" RealType="HtmlText" DescRef="bbsp_prefixpreferredtime" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6PrefixPreferredTime" InitValue="Empty"/> 
<li id="IPv6PrefixVaildTime" RealType="HtmlText" DescRef="bbsp_prefixvaildtime" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6PrefixVaildTime" InitValue="Empty"/> 
<li id="IPv6PrefixVaildTimeRemaining" RealType="HtmlText" DescRef="bbsp_prefixvaild_remaining" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6PrefixVaildTimeRemaining" InitValue="Empty"/> 
<li id="IPv6IpAddress" RealType="HtmlText" DescRef="bbsp_ipv6ipaddress" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6IpAddress" InitValue="Empty"/> 
<li id="IPv6IpAccessMode" RealType="HtmlText" DescRef="bbsp_ipacmode" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6IpAccessMode" InitValue="Empty"/> 
<li id="Ipv6IpState" RealType="HtmlText" DescRef="bbsp_ipv6ipstate" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Ipv6IpState" InitValue="Empty"/> 
<li id="IPv6PreferredTime" RealType="HtmlText" DescRef="bbsp_ippreferredtime" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6PreferredTime" InitValue="Empty"/> 
<li id="IPv6VaildTime" RealType="HtmlText" DescRef="bbsp_ipvaildtime" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6VaildTime" InitValue="Empty"/> 
<li id="IPv6VaildTimeRemaining" RealType="HtmlText" DescRef="bbsp_ipvaildtime_remaining" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6VaildTimeRemaining" InitValue="Empty"/> 
<li id="IPv6GateWay" RealType="HtmlText" DescRef="bbsp_ipv6_default_route" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6GateWay" InitValue="Empty"/> 
<li id="IPv6DsliteAftrname" RealType="HtmlText" DescRef="bbsp_dsliteaftrname" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6DsliteAftrname" InitValue="Empty"/> 
<li id="IPv6DslitePeerAddress" RealType="HtmlText" DescRef="bbsp_dslitepeeraddress" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6DslitePeerAddress" InitValue="Empty"/> 
<li id="IPv6DialCode" RealType="HtmlText" DescRef="bbsp_wandialcode" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="IPv6DialCode" InitValue="Empty"/> 
<li id="V6UpTime" RealType="HtmlText" DescRef="uptime_tips" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="V6UpTime" InitValue="Empty"/> 

</table>
<script>
var TableClassTwo = new stTableClass("align_left width_per30", "align_left width_per70", "ltr");
var Ipv6WanInfoFormList = new Array();
	Ipv6WanInfoFormList = HWGetLiIdListByForm("ipv6InformationForm",null);
	HWParsePageControlByID("ipv6InformationForm",TableClassTwo,waninfo_language,null);
</script>
</form>
</div>

<div class="func_spread"></div>

<table class="tabal_bg width_per100" cellspacing="1" id="IPv6AddressPanel">
  <tr class="head_title">
	<td BindText = 'bbsp_wanname'></td>
	<td BindText = 'bbsp_ipmode'></td>
	<script type="text/javascript" language="javascript">
		//if (false == IsSonetUser())
		{
			document.write('<td>'+waninfo_language['bbsp_ip']+'</td>');
		}
	</script>
	<td BindText = 'bbsp_ipstate'></td>
	<td BindText = 'bbsp_dns'></td>
  </tr>
  <script type="text/javascript" language="javascript">
		if( 0 == IPv6WanCount)
		{
			document.write("<tr  class= \"tabal_01\" align=\"center\">");
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
	 // if (false == IsSonetUser())
	  {
		 document.write('<td >'+'--'+'</td>');
	  }
			document.write('<td >'+'--'+'</td>');
			document.write('<td >'+'--'+'</td>');
			document.write("</tr>");
		}
		for (i = 0;i < GetWanList().length && IPv6WanCount > 0;i++)
		{
			var CurrentWan = GetWanList()[i];
			var AddressAcquire = GetIPv6AddressAcquireInfo(CurrentWan.domain);
			var AddressList = GetIPv6AddressList(CurrentWan.MacId);

			if (CurrentWan.IPv6Enable != "1")
			{
				continue;
			}

			document.write('<tr class = \"tabal_01\" align=\"center\">');
			document.write('<td>'+CurrentWan.Name+'</td>');

			var AcquireHtml = "";
			var AddressHtml = "";
			var AddressStatusHtml = "";
			for (var m = 0; m < AddressList.length; m++)
			{
				 AcquireHtml += (AddressList[m].Origin == ""?AddressAcquire.Origin:AddressList[m].Origin) +"<br>";
				 if(AddressList[m].Origin == "" && AddressAcquire.Origin == "")
				 {
					AcquireHtml = "--<br>";
				 }
				 if (CurrentWan.Enable == "1")
				 {
					 AddressHtml += (AddressList[m].IPAddress == ""?"--":AddressList[m].IPAddress)+"<br>";
					 AddressStatusHtml += (AddressList[m].IPAddressStatus == ""?"--":AddressList[m].IPAddressStatus) +"<br>";
				 }
			}

			if (CurrentWan.Mode.toUpperCase().indexOf("BRIDGE") >= 0 || AddressList.length < 1)
			{
				AcquireHtml = "--<br>";
				AddressHtml = "--<br>";
				AddressStatusHtml = "--<br>";
			}

			document.write('<td>'+AcquireHtml+'</td>');
			//if (false == IsSonetUser())
			{
				document.write('<td class="restrict_dir_ltr">'+AddressHtml+'</td>');
			}
			document.write('<td>'+AddressStatusHtml+'</td>');

			var ipv6WanForDns = GetIPv6WanInfo(CurrentWan.MacId);
			if (null == ipv6WanForDns)
			{
				continue;
			}
			var IPv6DNS = ipv6WanForDns.DNSServers;
			if( null == IPv6DNS || "" == IPv6DNS)
			{
				IPv6DNS = "--";
			}
			var DnsList = IPv6DNS.split(",");
			var DnsHtml = DnsList[0] + "<br>";
			if (DnsList[1] != null)
			{
				DnsHtml += DnsList[1] + "<br>";
			}
			document.write('<td  class="restrict_dir_ltr">'+DnsHtml+'</td>');

			document.write('</tr>');
		}

		</script>
</table>
<div  align='center' style="display:none" id="PonPortStatistics">
<table class="tabal_bg width_per100" cellspacing="1">
  <tr>
	<td colspan="8"  class='height20p'></td>
  </tr>
  <tr class="head_title">
	<td class="align_left" colspan="8" BindText = 'bbsp_PonPortStatistics'></td>
  </tr>
  <tr>
	<td class="table_title width_per35" BindText='bbsp_RxPackets'></td>
	<td  class="table_right">
		<script language="JavaScript" type="text/javascript">
			document.write(ponPackage.PacketsSent);
		</script>
	</td>
  </tr>
  <tr>
	<td class="table_title width_per35" BindText='bbsp_TxPackets'></td>
	<td  class="table_right">
		<script language="JavaScript" type="text/javascript">
			document.write(ponPackage.PacketsReceived);
		</script>
	</td>
  </tr>
</table>
</div>
<table>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
</div>
<script>
	if (true == TELMEX)
	{
		document.write('</div>');
	}
</script>
<div style="height:20px;"></div>
<script>
	if ((GetFeatureInfo().IPv6 == "0") || (true == bin5board()) || (true == IsPtvdfUser()) )
	{
		setDisplay("IPv6TitleInfoBar", "0");
		setDisplay("IPv6PrefixPanel", "0");
		setDisplay("IPv6AddressPanel", "0");
	}
	if (true == TELMEX)
	{
		setDisplay("PonPortStatistics",1);
	}
	loadlanguage();
</script>
</body>
</html>
