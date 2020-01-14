<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>User Device detail Information</title>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="JavaScript" type="text/javascript">

var num = 0;
var page = 1;
var MAX_LINE_TYPE=129;
var HW_USER_DEVICE_IP_STATIC="Static";
var FOR_NULL="--";

if(( window.location.href.indexOf("?") > 0) &&( window.location.href.split("?").length == 3))
{
	 num  = window.location.href.split("?")[1];  
	 page = window.location.href.split("?")[2];  
}

function USERDevice(Domain,IpAddr,MacAddr,Port,IpType,DevType,DevStatus,PortType,Time,HostName)
{
	this.Domain 	= Domain;
	this.IpAddr	    = IpAddr;
	this.MacAddr	= MacAddr;
	if(Port=="LAN0" || Port=="SSID0")
	{
		this.Port 	= FOR_NULL;
	}
	else
	{
	   this.Port 	= Port;
	}	
	this.PortType	= PortType;
	this.DevStatus 	= DevStatus;
	this.IpType		= IpType;

	if(IpType==HW_USER_DEVICE_IP_STATIC)
	{
	  this.DevType = FOR_NULL;
	}
	else
	{
		if(DevType=="")
		{
			this.DevType	= FOR_NULL;	
		}
		else
		{
			this.DevType	= DevType;		
		}	
	}
		
	this.Time	    = Time;
	if(HostName=="")
	{
		this.HostName	= FOR_NULL;
	}else
	{
	   this.HostName	= HostName;
	}
}

function DhcpInfo(Domain, IPAddress, MACAddress, LeaseTimeRemaining)
{
	this.Domain     = Domain;
	this.IPAddress  = IPAddress;
	this.MACAddress = MACAddress;
	this.LeaseTimeRemaining = LeaseTimeRemaining;
}

var UserDevices = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecialGetUserDevInfo,InternetGatewayDevice.LANDevice.1.X_HW_UserDev.{i},IpAddr|MacAddr|PortID|IpType|DevType|DevStatus|PortType|time|HostName,USERDevice);%>;
var DhcpInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.Hosts.Host.{i},IPAddress|MACAddress|LeaseTimeRemaining, DhcpInfo);%>;
var UserDevicesnum = UserDevices.length - 1;
var DhcpInfosNum = DhcpInfos.length - 1;

function GetRemainLeaseTime(ipaddr, macaddr)
{
	for (var i = 0; i < DhcpInfosNum; i++)
	{
		if ((ipaddr == DhcpInfos[i].IPAddress) && (macaddr == DhcpInfos[i].MACAddress))
		{
			return DhcpInfos[i].LeaseTimeRemaining;
		}
	}
	
	return -1;
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

function LoadFrame()
{
	if ( "1" == GetCfgMode().TELMEX )
	{
		document.getElementById('ShowOnlineTimeInfo').style.display="none";
	}
	loadlanguage();
}
</script>
</head>
<body  class="mainbody" onLoad="LoadFrame();"> 
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("userdetdevinfotitle", GetDescFormArrayById(userdevinfo_language, ""), GetDescFormArrayById(userdevinfo_language, "bbsp_userdetdevinfo_title"), false);
</script> 
<div class="title_spread"></div>

<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id='devdetinfo'> 
  <tr> 
    <td class="table_title  width_per25" BindText='bbsp_hostnamemh'></td> 
    <td class="table_right width_per75"> <script language="JavaScript">
                if(('--' == UserDevices[num].HostName) && ("1" == GetCfgMode().TELMEX))
                {
					document.write(UserDevices[num].MacAddr);
                }
                else
                {
				    document.write(UserDevices[num].HostName.substr(0,MAX_LINE_TYPE));
				}
				</script> </td> 
  </tr> 
  <tr> 
    <td  class="table_title width_per25" BindText='bbsp_devtypemh'></td> 
    <td  class="table_right width_per75"> <script language="JavaScript">
				document.write(UserDevices[num].DevType.substr(0,MAX_LINE_TYPE));
				</script> </td> 
  </tr> 
  <tr> 
    <td  class="table_title width_per25" BindText='bbsp_ipmh'></td> 
    <td  class="table_right width_per75"> <script language="JavaScript">
				document.write(UserDevices[num].IpAddr);
				</script> </td> 
  </tr> 
  <tr> 
    <td  class="table_title width_per25" BindText='bbsp_macmh'></td> 
    <td  class="table_right width_per75"> <script language="JavaScript">-
				document.write(UserDevices[num].MacAddr);
				</script> </td> 
  </tr> 
  <tr> 
    <td  class="table_title width_per25" BindText='bbsp_devstatemh'></td> 
    <td  class="table_right width_per75"> <script language="JavaScript">
				document.write(userdevinfo_language[UserDevices[num].DevStatus]);
				</script> </td> 
  </tr> 
  <tr> 
    <td  class="table_title width_per25" BindText='bbsp_porttypemh'></td> 
    <td  class="table_right width_per75"> <script language="JavaScript">
				document.write(UserDevices[num].PortType);
				</script> </td> 
  </tr> 
  <tr> 
    <td  class="table_title width_per25" BindText='bbsp_portmh'></td> 
    <td  class="table_right width_per75"> <script language="JavaScript">
				document.write(UserDevices[num].Port);
				</script> </td> 
  </tr> 
  <tr id="ShowOnlineTimeInfo"> 
    <td  class="table_title width_per25"> 
	<script>
	if('ONLINE' == UserDevices[num].DevStatus.toUpperCase())
	{
		document.write(userdevinfo_language['bbsp_onlinetimemh']);
	}
	else
	{
		document.write(userdevinfo_language['bbsp_offlineiimemh']);
	}
	</script></td>
    <td  class="table_right width_per75"> <script language="JavaScript">
				var unit_h = (parseInt(UserDevices[num].Time.split(":")[0],10) > 1) ? userdevinfo_language['bbsp_hours'] : userdevinfo_language['bbsp_hour'];
				var unit_m = (parseInt(UserDevices[num].Time.split(":")[1],10) > 1) ? userdevinfo_language['bbsp_mins'] : userdevinfo_language['bbsp_min'];
				document.write(UserDevices[num].Time.split(":")[0] + unit_h + UserDevices[num].Time.split(":")[1] + unit_m);
				</script> </td> 
  </tr> 
  <tr> 
    <td  class="table_title width_per25" BindText='bbsp_ipacmodemh' ></td> 
    <td  class="table_right width_per75"> <script language="JavaScript">
				document.write(userdevinfo_language[UserDevices[num].IpType]);
				</script> </td> 
  </tr> 
  <tr> 
    <td class="table_title width_per25" BindText='bbsp_remainleasedtime'></td> 
    <td class="table_right width_per75"> <script language="JavaScript">
	if ('DHCP' == UserDevices[num].IpType)
	{
		var remainleasetime = GetRemainLeaseTime(UserDevices[num].IpAddr, UserDevices[num].MacAddr);
		if (remainleasetime > 0)
		{
			document.write(remainleasetime + userdevinfo_language['bbsp_second']);
		}
		else
		{
			document.write('--');
		}
	}
	else
	{
		document.write('--');
	}				
	</script> </td> 
  </tr> 
</table> 
<table width="100%" height="30"> 
  <tr> 
    <td class='title_bright1'> <button id="back" name="back" type="button" class="submit" onClick="window.location='userdevinfo.asp?'+page;" enable=true ><script>document.write(userdevinfo_language['bbsp_back']);</script></button> </td> 
  </tr> 
</table> 
</body>
</html>
