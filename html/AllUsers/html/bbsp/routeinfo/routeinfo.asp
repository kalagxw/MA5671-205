<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<link rel="stylesheet" href='../../../resource/<%HW_WEB_Resource(diffcss.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>RouteShow</title>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/userinfo.asp"></script>
<script language="javascript" src="../common/topoinfo.asp"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<script language="javascript" src="../common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<script language="JavaScript" type="text/javascript">
var list = 15;
var currentFile='routeinfo.asp';

function GetMatchWanName(Interface)
{
	var Wans = GetWanList();
	for(var i in Wans)
	{
		if(Interface.toUpperCase() == ('WAN' + Wans[i].MacId))
		{
			return MakeWanName1(Wans[i]);
		}
	}
	return Interface;
}

function RouteInfo(Domain,DestIPAddress,DestSubnetMask,GatewayIPAddress,Interface)
{
	this.Domain = Domain;
	this.DestIPAddress = DestIPAddress;
	this.DestSubnetMask	= DestSubnetMask;
	this.GatewayIPAddress = GatewayIPAddress;
	this.Interface = Interface;
}

var RouteInfos = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_FilterRouteInfo, InternetGatewayDevice.Layer3Forwarding.X_HW_CurrentForwarding.{i}, DestIPAddress|DestSubnetMask|GatewayIPAddress|Interface,RouteInfo);%>;
var RouteInfoNr = RouteInfos.length - 1;

var firstpage = 1;
if(RouteInfoNr == 0)
{
	firstpage = 0;
}

var lastpage = RouteInfoNr/list;
if(lastpage != parseInt(lastpage,10))
{
	lastpage = parseInt(lastpage,10) + 1;	
}

var page = firstpage;
if( window.location.href.indexOf("?") > 0)
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

function shoulist(startlist , endlist)
{
	if( 0 == RouteInfoNr )
	{
		document.write("<tr class=\"tabal_center01\">");
		document.write('<td >'+'--'+'</td>');
		document.write('<td >'+'--'+'</td>');
		document.write('<td >'+'--'+'</td>');
		document.write('<td >'+'--'+'</td>');
		document.write('<td >'+'--'+'</td>');
		document.write("</tr>");
		return;
	}

	for(i=startlist;i <= endlist - 1;i++)   
	{
		var seq = i+1;
		document.write("<tr class=\"tabal_center01 trTabContent\" >");
		document.write('<td>'+ seq +'</td>');
		document.write('<td>'+RouteInfos[i].DestIPAddress +'</td>');
		document.write('<td>'+RouteInfos[i].DestSubnetMask +'</td>');
		document.write('<td>'+RouteInfos[i].GatewayIPAddress +'</td>');
		document.write('<td>'+GetMatchWanName(RouteInfos[i].Interface) +'</td>');
		document.write("</tr>");
	}
}

function showlistcontrol()
{
	if(RouteInfoNr == 0)
	{
		shoulist(0 , 0);
	}
	else if( RouteInfoNr >= list*parseInt(page,10) )
	{
		shoulist((parseInt(page,10)-1)*list , parseInt(page,10)*list);
	}
	else
	{
		shoulist((parseInt(page,10)-1)*list , RouteInfoNr);
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
		b.innerHTML = routeinfo_language[b.getAttribute("BindText")];
	}
}

function LoadFrame()
{
	loadlanguage();
}

</script>
</head>
<body  class="mainbody" onLoad="LoadFrame();"> 
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("routeinfotitle", GetDescFormArrayById(routeinfo_language, ""), GetDescFormArrayById(routeinfo_language, "bbsp_routeinfo_title"), false);
</script> 
<div class="title_spread"></div>

  <table class='tabal_bg' border="0" align="center" cellpadding="0" cellspacing="1" id='devlist' width="100%">
    <tr class="head_title">
    <td class='width_per10' BindText='bbsp_seq'></td> 
    <td class='per_18_21' BindText='bbsp_ip'></td> 
    <td class="per_18_21" BindText='bbsp_mask'></td> 
    <td class="per_18_21" BindText='bbsp_gw'></td> 
    <td BindText='bbsp_if'></td> 
  </tr> 

<script>
	showlistcontrol();
</script> 

</table> 
  <table class='width_per100' border="0" cellspacing="0" cellpadding="0" > 
	<tr > 
		<td class='width_per40'></td> 
		<td class='title_bright1' >
		 	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
			<input name="first" id="first" class="submit" type="button" value="<<" onClick="submitfirst();"/> 
			<input name="prv" id="prv"  class="submit" type="button" value="<" onClick="submitprv();"/> 
				<script>
					if (false == IsValidPage(page))
					{
						page = (0 == RouteInfoNr) ? 0:1;
					}
					document.write(parseInt(page,10) + "/" + lastpage);
				</script>
			<input name="next"  id="next" class="submit" type="button" value=">" onClick="submitnext();"/> 
			<input name="last"  id="last" class="submit" type="button" value=">>" onClick="submitlast();"/> 
		</td>
		<td class='width_per5'></td>
		<td  class='title_bright1'>
			<script> document.write(routeinfo_language['bbsp_goto']); </script> 
				<input  type="text" name="pagejump" id="pagejump" size="2" maxlength="2" style="width:20px;" />
			<script> document.write(routeinfo_language['bbsp_page']); </script>
		</td>
		<td class='title_bright1'>
			<button name="jump"  id="jump" class="submit" type="button" onClick="submitjump();"> <script> document.write(routeinfo_language['bbsp_jump']); </script></button> 
		</td>
	</tr> 
</table> 
<script> 
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
