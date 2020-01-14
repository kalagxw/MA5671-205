<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  id="Page" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>

<script language="javascript" src="../common/userinfo.asp"></script>
<script language="javascript" src="../common/topoinfo.asp"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<script language="javascript" src="../common/lanmodelist.asp"></script>
<script language="javascript" src="../common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>

<script>
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
			b.innerHTML = dhcp_info_language[b.getAttribute("BindText")];
		}
	}

    function DhcpInfoClass(domain, DUID, IPAddress, PrefixLen, Duration)
    {
        this.domain = domain;
        this.DUID    = DUID;
        this.IPAddress = IPAddress;
        this.PrefixLen = PrefixLen;
		this.Duration = Duration;
    }
	
	function DhcpPoolClass(domain, Prefix, MinAddress, MaxAddress)
    {
        this.domain = domain;
        this.Prefix    = Prefix;
        this.MinAddress = MinAddress;
        this.MaxAddress = MaxAddress;
    }

	function DhcpHostClass(domain, HostNumberOfEntries)
    {
        this.domain = domain;
        this.HostNumberOfEntries = HostNumberOfEntries;
    }

	var appName = navigator.appName;
    var RecordList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.X_HW_DHCPv6.Hosts.Host.{i},DUID|IPAddress|PrefixLen|Duration, DhcpInfoClass);%>;
	var DhcpPoolInfos = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_DhcpInfos, InternetGatewayDevice.LANDevice.1.X_HW_DHCPv6.Server.Pool.1,Prefix|MinAddress|MaxAddress, DhcpPoolClass);%>;
	var DhcpHostInfos = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_DhcpInfos, InternetGatewayDevice.LANDevice.1.X_HW_DHCPv6.Hosts,HostNumberOfEntries, DhcpHostClass);%>;

    var DhcpPoolInfo = DhcpPoolInfos[0];
	var DhcpHostInfo = DhcpHostInfos[0];
	var TotalIpNum = 0;
	var LeftIpAddrNum = 0;
	
	function IpToInteger(str)
	{
		var ipSeg;
		var IpInteger;
		ipSeg = str.split(':');
		IpInteger = ((parseInt(ipSeg[0],16) << 48 + parseInt(ipSeg[1],16) << 32) + parseInt(ipSeg[2],16) << 16) + parseInt(ipSeg[3],16);
		 
		return IpInteger;
	}

	function CalcIpNum()
	{
		if (DhcpPoolInfos.length-1>0)
		{
			TotalIpNum = IpToInteger(DhcpPoolInfo.MaxAddress) - IpToInteger(DhcpPoolInfo.MinAddress) + 1;
			LeftIpAddrNum = TotalIpNum - DhcpHostInfo.HostNumberOfEntries;
		}
	}

	function IsSupportStatandLeasedInfo()
	{
		if(!IsE8cFrame())
		{
			return true;
		}
		
		return false;
	}
	</script>
<script>

    function OnPageLoad()
    {
		if (IsSupportStatandLeasedInfo() == true)
		{
			setDisplay("DivDhcpStatInfo", 1);
		}
		else
		{
			setDisplay("DivDhcpStatInfo", 0);
		}
		loadlanguage();
        return true;
    }

</script>
<title>DHCPv6 Server Information</title>
</head>
<script language="JavaScript" type="text/javascript"> 
if (appName == "Microsoft Internet Explorer")
{
	document.write('<body onLoad="OnPageLoad();" class="mainbody" scroll="auto">');
}
else
{
	document.write('<body onLoad="OnPageLoad();" class="mainbody" >');
	document.write('<DIV style="overflow-x:auto; overflow-y:auto; WIDTH: 100%; HEIGHT: 460px">');
}
</script>
<form id="ConfigForm"> 
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("dhcpv6infotitle", GetDescFormArrayById(dhcp_info_language, ""), GetDescFormArrayById(dhcp_info_language, ""), false);
	if (IsSupportStatandLeasedInfo() == true)
	 {
		  document.getElementById("dhcpv6infotitle_content").innerHTML = dhcp_info_language["bbsp_dhcp_info_title"];
	 }
	 else
	 {
	 	 document.getElementById("dhcpv6infotitle_content").innerHTML = dhcp_info_language["bbsp_dhcp_info_title_e8c"];
	 }
</script>
<div class="title_spread"></div>

  <script>
  CalcIpNum();
  </script>
  <div id="DivDhcpStatInfo">
   <table class='width_per100' border="0" align="center" cellpadding="0" cellspacing="1" id='dhcpStatisticInfo'> 
	<tr>
		<td class="table_title width_per35" BindText='bbsp_addrtotalnum'></td> 
		<td class="table_right width_per65"><script language="JavaScript">document.write(TotalIpNum);</script></td> 
	</tr>
	<tr> 
		<td class="table_title width_per35" BindText='bbsp_leftaddrnum'></td> 
		<td class="table_right width_per65"><script language="JavaScript"> document.write(LeftIpAddrNum);</script></td> 
	</tr>  
	</table>
	<div class="func_spread"></div>
  </div>
  
  <script>
    document.write('<table id="dhcpinfo" class="tabal_bg" border="0" cellpadding="0" cellspacing="1"  width="100%">');
    if (IsSupportStatandLeasedInfo() == true)
	{
		document.write('<tr class="head_title width_per50">');
		document.write('<td  >' + dhcp_info_language['bbsp_uuid'] + '</td>');
		document.write('<td  >' + dhcp_info_language['bbsp_ipPrefix'] + '</td>');
		document.write('<td  >' + dhcp_info_language['bbsp_leased'] + '</td>');
		document.write('</tr>');  
		for (var i = 0; i < RecordList.length-1; i++)
		{
		  document.write('<tr class="tabal_center01">');
		  document.write('<td class="width_per30" id = \"RecordListDUID'+i+'\">'+RecordList[i].DUID+'</td>');
		  document.write('<td class="width_per30 restrict_dir_ltr" id = \"RecordListPref'+i+'\">'+RecordList[i].IPAddress+((RecordList[i].PrefixLen=="0")?(''):('/'+RecordList[i].PrefixLen))+'</td>');
		  document.write('<td class="width_per30" id = \"RecordListLeased'+i+'\">'+RecordList[i].Duration+dhcpinfo_language['bbsp_sec']+'</td>');
		  document.write('</tr>');  
		}
		if (RecordList.length == 1)
		{
			document.write('<tr class="tabal_center01">');
			document.write('<td class="width_per30">--</td>');
			document.write('<td class="width_per30">--</td>');
			document.write('<td class="width_per30">--</td>');
			document.write('</tr>');      
		}
	}
	else
	{
		document.write('<tr class="head_title align_left width_per50">');
		document.write('<td  >' + dhcp_info_language['bbsp_uuid'] + '</td>');
		document.write('<td  >' + dhcp_info_language['bbsp_ipPrefix'] + '</td>');
		document.write('</tr>');  
		for (var i = 0; i < RecordList.length-1; i++)
		{
		  document.write('<tr class="align_left">');
		  document.write('<td class="table_title width_per50" id = \"RecordListDUID'+i+'\">'+RecordList[i].DUID+'</td>');
		  document.write('<td class="table_right width_per50" id = \"RecordListPref'+i+'\">'+RecordList[i].IPAddress+((RecordList[i].PrefixLen=="0")?(''):('/'+RecordList[i].PrefixLen))+'</td>');
		  document.write('</tr>');  
		}
		if (RecordList.length == 1)
		{
			document.write('<tr class="align_left">');
			document.write('<td class="table_title width_per50">--</td>');
			document.write('<td class="table_right width_per50">--</td>');
			document.write('</tr>');      
		}
	}
    document.write('</table>');
  </script> 
</form> 
<script language="JavaScript" type="text/javascript">
if (appName != "Microsoft Internet Explorer")
{
	document.write('</DIV>');
}
</script> 
</body>
</html>
