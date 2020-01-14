<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="Javascript" src="../../bbsp/common/managemode.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list.asp"></script>
<title>Chinese -- Static Route</title>
<script language="javascript" src="../../bbsp/common/wan_check.asp"></script>
<script language="javascript" src="../../bbsp/common/ipv6staticroute.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">

var IPv4SRoutelistMaxNum = '<%HW_WEB_GetSPEC(BBSP_SPEC_IPV4_ROUTE_MAXNUM.UINT32);%>';
var IPv6SRoutelistMaxNum = '<%HW_WEB_GetSPEC(BBSP_SPEC_IPV6_ROUTE_MAXNUM.UINT32);%>';

var SRoutelistMaxNum = IPv4SRoutelistMaxNum + IPv6SRoutelistMaxNum;

var currentFile='staticroutee8c.asp';

var appName = navigator.appName;

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
		b.innerHTML = sroute_language[b.getAttribute("BindText")];
	}
}

function stDftRoute(domain,autoenable,ip,wandomain)
{
	this.domain 	= domain;
	this.autoenable = autoenable;
	this.ip 		= ip;
	this.wandomain 	= wandomain;
}

function filterWan(WanItem)
{
	if (!(WanItem.Tr069Flag == '0' && (IsWanHidden(domainTowanname(WanItem.domain)) == false)))
	{
		return false;	
	}
	
	return true;
}

var WanInfo = GetWanListByFilter(filterWan);

function stHost(Domain, IPInterfaceIPAddress, IPInterfaceSubnetMask)
{
    this.Domain = Domain;
	this.IPInterfaceIPAddress = IPInterfaceIPAddress;
	this.IPInterfaceSubnetMask = IPInterfaceSubnetMask;
}

var host = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},IPInterfaceIPAddress|IPInterfaceSubnetMask,stHost);%>;
var IpAddress = host[0].IPInterfaceIPAddress;
var SubnetMask = host[0].IPInterfaceSubnetMask;

var AddFlag = true;
var PreRouteIdx = -1;
var routeIdx = -1;

function ShowIfName(val)
{
   for (var i = 0; i < WanInfo.length; i++)
   {
      if (WanInfo[i].domain == val)
	  {
	      return WanInfo[i].Name;
	  }
	  else if ('br0' == val)
	  {
	     return 'br0';
	  }
   }
   return '&nbsp;';
}

function getWanOfStaticRoute(val)
{
   for (var i = 0; i < WanInfo.length; i++)
   {
      if (WanInfo[i].domain == val)
	  {
	      return WanInfo[i];
	  }
   }
   return '&nbsp;';
}

function stIPv4StaticRoute(domain, StaticRouteDomain,DestIPAddress, Gateway, mask, Interface)
{
    this.domain = domain;
    this.StaticRouteDomain = StaticRouteDomain;
	this.DestIPAddress = DestIPAddress;
	this.Gateway = Gateway;
	this.mask = mask;
	this.Interface = Interface;
}    

function stStaticRoute(domain, IpVersion,StaticRouteDomain,DestIPAddress, DestIPPrefix, Gateway, mask, Interface)
{
    this.domain = domain;
	this.IpVersion = IpVersion;
    this.StaticRouteDomain = StaticRouteDomain;
	this.DestIPAddress = DestIPAddress;
	this.DestIPPrefix = DestIPPrefix;
	this.Gateway = Gateway;
	this.mask = mask;
	this.Interface = Interface;
} 

var AllWanInfoTemp = GetWanList();
var Ipv4StaticRoute = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Layer3Forwarding.Forwarding.{i},X_HW_DomainName|DestIPAddress|GatewayIPAddress|DestSubnetMask|Interface,stIPv4StaticRoute);%>;  
var Ipv6StaticRoute = GetStaticRouteList();
var StaticRoutes = new Array(); 

function getIPv4PrefixByMask(mask)
{
	var IPv4Prefix = "";
	var maskList = mask.split('.');
	var num = 0;
	for (var i = 0; i< maskList.length;i++)
	{
		IPv4Prefix = parseInt(maskList[i]).toString(2);
		for (var j = 0; j < IPv4Prefix.length; j++)
		{
			if (IPv4Prefix.charAt(j) == '1')
			{
				num++;
			}
		}
	}
	return num;
}
function ConvertIPV4SRoute(IPv4SRoute, CommonSRouteInfo)
{
	CommonSRouteInfo.domain = IPv4SRoute.domain;
	CommonSRouteInfo.IpVersion = "IPv4";
	CommonSRouteInfo.StaticRouteDomain = IPv4SRoute.StaticRouteDomain;
	CommonSRouteInfo.DestIPAddress = IPv4SRoute.DestIPAddress;
	CommonSRouteInfo.DestIPPrefix = IPv4SRoute.DestIPAddress+"/"+ getIPv4PrefixByMask(IPv4SRoute.mask);
	CommonSRouteInfo.Gateway = IPv4SRoute.Gateway;
	CommonSRouteInfo.mask = IPv4SRoute.mask;
	CommonSRouteInfo.Interface = IPv4SRoute.Interface;
}
 
function ConvertIPV6SRoute(IPv6SRoute, CommonSRouteInfo)
{
	CommonSRouteInfo.domain = IPv6SRoute.domain;
	CommonSRouteInfo.IpVersion = "IPv6";
	CommonSRouteInfo.StaticRouteDomain = "";
	CommonSRouteInfo.DestIPAddress = "";
	CommonSRouteInfo.DestIPPrefix = IPv6SRoute.DestIPPrefix;
	CommonSRouteInfo.Gateway = IPv6SRoute.NextHop;
	CommonSRouteInfo.mask = "";
	CommonSRouteInfo.Interface = IPv6SRoute.WanName;
}

var SRouteIdx = 0;

for (var i = 0; i < Ipv4StaticRoute.length-1; i++)
{
	StaticRoutes[SRouteIdx] = new stStaticRoute();
	ConvertIPV4SRoute(Ipv4StaticRoute[i], StaticRoutes[SRouteIdx]);
	SRouteIdx++;
}

for (var j = 0; j < Ipv6StaticRoute.length; j++)
{
	StaticRoutes[SRouteIdx] = new stStaticRoute();
	ConvertIPV6SRoute(Ipv6StaticRoute[j], StaticRoutes[SRouteIdx]);
	SRouteIdx++;
}

var StaticRoute = new Array();

var listNum = 10;

function FindWanInfo(Item)
{
	var wandomain_len = 0;
	var temp_domain = null;
	
	for(var k = 0; k < AllWanInfoTemp.length; k++ )
	{            
		wandomain_len = AllWanInfoTemp[k].domain.length;
		temp_domain = Item.Interface;

		if (domainTowanname(temp_domain) == domainTowanname(AllWanInfoTemp[k].domain))
		{
			return true;
		}
	} 
	
	return false;
}

var Idx = 0;
for (i = 0; i < StaticRoutes.length; i++)
{
	if ((StaticRoutes[i].IpVersion == "IPv4") && (FindWanInfo(StaticRoutes[i]) == true))
	{
   		StaticRoute[Idx] = StaticRoutes[i];
		Idx ++;
	}
	else if (StaticRoutes[i].IpVersion == "IPv6")
	{
		StaticRoute[Idx] = StaticRoutes[i];
		Idx ++;
	}
}

var RouteInfoNr = Idx;

var firstpage = 1;
if(RouteInfoNr == 0)
{
	firstpage = 0;
}

var lastpage = RouteInfoNr/listNum;
if(lastpage != parseInt(lastpage,10))
{
	lastpage = parseInt(lastpage,10) + 1;	
}

var page = firstpage;

if( window.location.href.indexOf("del.cgi") == -1 && window.location.href.indexOf("add.cgi") == -1 && window.location.href.indexOf("set.cgi") == -1 && window.location.href.indexOf("?") > 0 )
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

function getIpVersionByIpAddr(IpAddr)
{
	var IpVersion = "";
	if (false == IsIPv6AddressValid(IpAddr))
	{
		IpVersion = "IPv4";
	}
	else
	{
		IpVersion = "IPv6";
	}
	return IpVersion;
}

function showlist(startlist , endlist)
{
	var tableID = "";
	if( 0 == RouteInfoNr )
	{
		tableID = 2;
        document.write('<TR id="record_no"' 
    	                + ' class="tabal_center01 " onclick="selectLine(this.id);">');
        document.write('<TD id='+getStaticRouterListId(tableID,1)+'>--</TD>');
		document.write('<TD id='+getStaticRouterListId(tableID,2)+'>--</TD>');
        document.write('<TD id='+getStaticRouterListId(tableID,3)+'>--</TD>');
        document.write('<TD id='+getStaticRouterListId(tableID,4)+'>--</TD>');
    	document.write('<TD id='+getStaticRouterListId(tableID,5)+'>--</TD>');
    	document.write('</TR>');
		return;
	}

	for(i=startlist;i <= endlist - 1;i++)    
	{
		var tableID = i + 2;
		document.write('<TR id="record_' + i 
				+ '" align = "center" class="tabal_01" onclick="selectLine(this.id);">');
		document.write('<TD id=' + getStaticRouterListId(tableID,1) + '>' + StaticRoute[i].IpVersion + '</TD>');
		if (StaticRoute[i].IpVersion == "IPv4")
		{
			if ("" != StaticRoute[i].DestIPAddress)
			{
				document.write('<TD id=' + getStaticRouterListId(tableID,2) + '>' + GetStringContent(StaticRoute[i].DestIPPrefix,20) + '</TD>');
			}
			else
			{
				document.write('<TD id=' + getStaticRouterListId(tableID,2) + '>' + GetStringContent(StaticRoute[i].StaticRouteDomain,30) + '</TD>');
			}
		}
		else if (StaticRoute[i].IpVersion == "IPv6")
		{
			document.write('<TD id=' + getStaticRouterListId(tableID,2) + '>' + GetStringContent(StaticRoute[i].DestIPPrefix, 20) + '</TD>');
		}
		document.write('<TD id=' + getStaticRouterListId(tableID,3) + '>' + StaticRoute[i].Gateway + '</TD>');
		if (StaticRoute[i].IpVersion == "IPv4")
		{
			document.write('<TD id=' + getStaticRouterListId(tableID,4) + '>' + MakeWanName(getWanOfStaticRoute(StaticRoute[i].Interface)) + '</TD>');
		}
		else if (StaticRoute[i].IpVersion == "IPv6")
		{
			document.write('<TD id=' + getStaticRouterListId(tableID,4) + '>' + GetWanFullName(StaticRoute[i].Interface) + '</TD>');
		}
		document.write('<TD >' + '<input disabled="disabled" name="' + getStaticRouterListId(tableID,5) + '" type="button" id="' + getStaticRouterListId(tableID,5) + '" onClick="onClickDel()" value="' + sroute_language['bbsp_td_del'] + '"/>'+'</TD>');
		document.write("</tr>");
	}
}

function showlistcontrol()
{
	if(RouteInfoNr == 0)
	{
		showlist(0 , 0);
	}
	else if( RouteInfoNr >= listNum*parseInt(page,10) )
	{
		showlist((parseInt(page,10)-1)*listNum , parseInt(page,10)*listNum);
	}
	else
	{
		showlist((parseInt(page,10)-1)*listNum , RouteInfoNr);
	}
}

function getStaticRouterListId(tableID,colID)
{
	var StaticRouterListId = "StaticRouteInfo_" + tableID + "_" + colID + "_table";
	return StaticRouterListId;
}

function onClickDel()
{
	var Form = new webSubmitForm();
	if (-1 == routeIdx)
	{
		AlertEx(sroute_language['bbsp_alert_nodel']);	
		return;
	}
	Form.addParameter(StaticRoute[routeIdx].domain,'');
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('del.cgi?' + '&RequestFile=html/bbsp/staticroute/staticroutee8c.asp');
	Form.submit();
	DisableRepeatSubmit();
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

function LoadFrame()
{
	loadlanguage();
	setDisplay('Newbutton',0);
	setDisplay('DeleteButton',0);
	if (StaticRoute.length == 0)
	{
		selectLine('record_no');
	}
	else
	{
		var record_id  = (parseInt(page, 10) - 1) * listNum;
		selectLine('record_' + record_id);
	}
}

function AddSubmitParam(SubmitForm,type)
{

}

function setStaticRouteCfgDisplay(ipVersion)
{
	if ("IPv4" == ipVersion)
	{
		setDisplay('StaticRouteAddrFormatTr',1);
		StaticRouteCfgIpOrDomain();
	}
	else if("IPv6" == ipVersion)
	{
		setDisplay('StaticRouteAddrFormatTr',0);
		setDisplay("StaticRouteDomainTr", 0);
        setDisplay("StaticRouteIpTr",1);
        setDisplay("StaticRouteIpMaskTr",0);
	}
}

function OnChangeIpVersion()
{
	var ipVersion = getSelectVal('IpVersion_select');
	var InterfaceList = getElementById('Interface_select');
	InterfaceList.options.length = 0;
	if ("IPv4" == ipVersion)
	{
		getElementById('DivSrouteIp').innerHTML = sroute_language['bbsp_ipv4submaskmh'];
		getElementById('DivSrouteIpTips').innerHTML = sroute_language['bbsp_sroute_domaintips'];
		setStaticRouteCfgDisplay(ipVersion);
		for (i = 0; i < WanInfo.length; i++)
		{
			if (WanInfo[i].Mode == 'IP_Routed' && WanInfo[i].IPv4Enable == '1')
			{
				InterfaceList.options.add(new Option(MakeWanName1(WanInfo[i]),WanInfo[i].domain));
			}
		}
	}
	else if ("IPv6" == ipVersion)
	{
		getElementById('DivSrouteIp').innerHTML = sroute_language['bbsp_ipv6submaskmh'];
		getElementById('DivSrouteIpTips').innerHTML = sroute_language['bbsp_staticroutenotel'];
		setStaticRouteCfgDisplay(ipVersion);
		
		for (i = 0; i < WanInfo.length; i++)
		{
			if (WanInfo[i].Mode == 'IP_Routed' && WanInfo[i].IPv6Enable == '1')
			{
				InterfaceList.options.add(new Option(MakeWanName1(WanInfo[i]),WanInfo[i].domain));
			}
		}
	}
}

function WriteOption()
{
	var ipVersion = getSelectVal('IpVersion_select');
	var i;
	if ("IPv4" == ipVersion)
	{
		for (i = 0; i < WanInfo.length; i++)
		{
			if (WanInfo[i].Mode == 'IP_Routed' && WanInfo[i].IPv4Enable == '1')
			{
				 document.write('<option id="wan_' + i + '" value="' + WanInfo[i].domain + '">' + MakeWanName1(WanInfo[i]) + '</option>');
			}
		}
	}
	else if ("IPv6" == ipVersion)
	{
		for (i = 0; i < WanInfo.length; i++)
		{
			if (WanInfo[i].Mode == 'IP_Routed' && WanInfo[i].IPv6Enable == '1')
			{
				 document.write('<option id="wan_' + i + '" value="' + WanInfo[i].domain + '">' + MakeWanName1(WanInfo[i]) + '</option>');
			}
		}
	}    
}

function StaticRouteCfgModeIsIpType()
{
    if ("DomainMode" == getRadioVal("StaticRouteCfgMode"))
    {
        return  false;
    }
    return  true;
}
function StaticRouteCfgIpOrDomain()
{
    if (false == StaticRouteCfgModeIsIpType())
    {  
        setDisplay("StaticRouteDomainTr", 1);
        setDisplay("StaticRouteIpTr",0);
        setDisplay("StaticRouteIpMaskTr",0);
    }
    else
    {
        setDisplay("StaticRouteDomainTr", 0);
        setDisplay("StaticRouteIpTr",1);
        setDisplay("StaticRouteIpMaskTr",1);
    }
}
function btnClear() 
{
   with ( document.forms[0] ) 
   {
		  setText('DestIPAddress_text','');
		  setText('DestSubnetMask_text','');
		  setText('GatewayIPAddress_text','');
   }
}

function getMostRightPosOf1(str)
{
    for (i = str.length - 1; i >= 0; i--)
    {
        if (str.charAt(i) == '1')
        {
            break;
        }
    }
    return i;
}

function getBinaryString(str)
{
    var numArr = [128, 64, 32, 16, 8, 4, 2, 1];
    var addrParts = str.split('.');
    if (addrParts.length < 3)
    {
        return "00000000000000000000000000000000";
    }
    var binstr = '';
    for (i = 0; i < 4; i++)
    {
        var num = parseInt(addrParts[i])

        for ( j = 0; j < numArr.length; j++ )
        {
            if ( (num & numArr[j]) != 0 )
            {
                binstr += '1';
            }
            else
            {
                binstr += '0';
            }    
        }
    }
    return binstr;
}

function isMatchedIpAndMask(ip, mask)
{
    var locIp = getBinaryString(ip);
    var locMask = getBinaryString(mask);
    
    if (locIp.length != locMask.length)
    {
        return false;
    } 
    var most_right_pos_1 = getMostRightPosOf1(locMask);
    
    if (most_right_pos_1 == -1)
    {
        if (locIp == '00000000000000000000000000000000')
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    for (var i = most_right_pos_1 + 1; i < locIp.length; i++)
    {
        if (locIp.charAt(i) != '0')
        {
            return false;
        }
    }
    return true;
}

function clickRemove() 
{      
    if ((StaticRoute.length) == 0)
	{	
	    return;
	}
	
	if (routeIdx == -1)
	{	
	    return;
	}
    var rml = getElement('rml');
    var noChooseFlag = true;
    if ( rml.length > 0)
    {
         for (var i = 0; i < rml.length; i++)
         {
             if (rml[i].checked == true)
             {   
                 noChooseFlag = false;
             }
         }
    }
    else if (rml.checked == true)
    {
        noChooseFlag = false;
    }
    if ( noChooseFlag )
    {       
        return ;
    }
       
    setDisable('addButton',1);
    setDisable('btnApply_ex',1);
    setDisable('canelButton',1);
	removeInst('html/bbsp/staticroute/staticroutee8c.asp');
}       

function CheckForm_DstIp()
{
    var DestIp = getValue('DestIPAddress_text');
    var index1 = IpAddress.lastIndexOf('.');
    var index2 = DestIp.lastIndexOf('.');
    
    if ((DestIp == '') || (getValue('DestSubnetMask_text') == ''))
    {           
		AlertEx(sroute_language['bbsp_alert_ipmaskuil']);	
        return false;
    }

    if ( isAbcIpAddress(DestIp) == false 
        || isDeIpAddress(DestIp) == true 
        || isBroadcastIpAddress(DestIp) == true 
        || isLoopIpAddress(DestIp) == true ) 
    {              
		AlertEx(sroute_language['bbsp_alert_addrunvail3']);	
        return false;
    }

    if (IpAddress == DestIp
        || (DestIp.substr(index1 + 1) == '0' && IpAddress.substr(0,index1)
        == DestIp.substr(0,index2))) 
    {           
		AlertEx(sroute_language['bbsp_alert_addrunvail3']);	
        return false;
    }
    return true;
}	

function CheckForm_DstMask()
{
    if (getValue('DestSubnetMask_text') == null)
    {            
    	AlertEx(sroute_language['bbsp_alert_masknill']);	
        return false;
    }
    
    if ( isValidSubnetMask(getValue('DestSubnetMask_text')) == false 
        &&  getValue('DestSubnetMask_text') != '255.255.255.255')
    {            
    	AlertEx(sroute_language['bbsp_alert_mask'] + getValue('DestSubnetMask_text') + sroute_language['bbsp_alert_invail']);	
        return false;
    }
    return true;
}

function CheckForm_Gateway()
{
    var Dsub = getValue('DestSubnetMask_text').split('.');
    var Dgw = getValue('GatewayIPAddress_text').split('.');
    var Locip = (IpAddress).split('.');
    var i = 0, netaddlen = 0;

    if (true == StaticRouteCfgModeIsIpType())
    {
        for ( i = 0 ; i < 4 ; i++ )
        {
            if ( Dsub[i] == '255' )
            {
                 netaddlen ++;
            }
            else
            {
                break;
            }
        }
  
        if (getValue('GatewayIPAddress_text').length > 0)
        {
            for ( i = 0 ; i < netaddlen ; i++ )
            {
                if ( Dgw[i] != Locip[i] )
                {
                    break;
                }
            }
    
            if ( i >= netaddlen )
            {                    
    			AlertEx(sroute_language['bbsp_alert_samesubnet']);
                return false;
            }
        }

        if (getValue('GatewayIPAddress_text').length > 0)
        {
            if ( isAbcIpAddress(getValue('GatewayIPAddress_text')) == false  || (getValue('GatewayIPAddress_text') == getValue('DestIPAddress_text')))
            {
    			AlertEx(sroute_language['bbsp_alert_defgwunvail1'] + getValue('GatewayIPAddress_text') + sroute_language['bbsp_alert_invail']);
                return false;
            }       
        }
        if (isMatchedIpAndMask(getValue('DestIPAddress_text'), getValue('DestSubnetMask_text')) == false)
        {            
    		AlertEx(sroute_language['bbsp_alert_ipaddr']  + getValue('DestIPAddress_text') + sroute_language['bbsp_alert_andmask'] + getValue('DestSubnetMask_text') + sroute_language['bbsp_alert_notmatch']);
            return false;          
        }
    }
    else
    {

        if (getValue('GatewayIPAddress_text').length > 0)
        {
            if ( isAbcIpAddress(getValue('GatewayIPAddress_text')) == false  || (getValue('GatewayIPAddress_text') == getValue('DestIPAddress_text')))
            {
    			AlertEx(sroute_language['bbsp_alert_defgwunvail1'] + getValue('GatewayIPAddress_text') + sroute_language['bbsp_alert_invail']);
                return false;
            }       
        }
    }

    return true;
}

function CheckForm_Interface()
{
    var selectObj = getElement('Interface_select');
    var index = parseInt(selectObj.selectedIndex,10);

    if ( index < 0 )
    {
		AlertEx(sroute_language['bbsp_alert_createwan']);
        return false;
    }
    return true;
}

function CheckFormIPv4(Form)
{   
    var selectObj = getElement('Interface_select');
    var index = parseInt(selectObj.selectedIndex,10);
    var idx = 0, i =0, netaddlen = 0;
    var isavlideGWip = false;

    if ( index < 0 )
    {
		AlertEx(sroute_language['bbsp_alert_setwan']);	
        return false;
    }

    for (i = 0; i < StaticRoute.length; i++)
    {
        if (routeIdx != i)
        {
            if (StaticRoute[i].DestIPAddress == getValue('DestIPAddress_text') && "" != getValue('DestIPAddress_text'))
            {               
				AlertEx(sroute_language['bbsp_alert_ipused']);	
                return false;
            }
            if (StaticRoute[i].StaticRouteDomain == getValue('StaticRouteDomain')&& ('' != getValue('StaticRouteDomain')))
            {               
				AlertEx(sroute_language['bbsp_alert_domainused']);	
                return false;
            }
        }
        else
        {
            continue;
        }
    }

    with ( document.forms[0] )
    {
        if (true == StaticRouteCfgModeIsIpType())
        {

            Form.addParameter('x.X_HW_DomainName','');

            if (false == CheckForm_DstIp())
            {
                return false;
            }
            Form.addParameter('x.DestIPAddress',getValue('DestIPAddress_text'));

            if (false == CheckForm_DstMask())
            {
                return false;
            }
            Form.addParameter('x.DestSubnetMask',getValue('DestSubnetMask_text'));
        }
        else
        {

            Form.addParameter('x.DestIPAddress','');
            Form.addParameter('x.DestSubnetMask','');

            if ( '' == getValue('StaticRouteDomain') )
            {           
        		AlertEx(sroute_language['bbsp_alert_null_domain']);	
                return false;
            }
    		if(false == CheckDomainNameWithWildcard(getValue('StaticRouteDomain')))
    		{
				AlertEx(sroute_language['bbsp_alert_invalid_domain']);
				return false;
    		}

    		Form.addParameter('x.X_HW_DomainName',getSelectVal('StaticRouteDomain'));
        }

        if (false == CheckForm_Gateway())
        {
            return false;
        }
        Form.addParameter('x.GatewayIPAddress',getValue('GatewayIPAddress_text'));
        

        if (false == CheckForm_Interface())
        {
            return false;
        }
        Form.addParameter('x.Interface',getSelectVal('Interface_select'));
    }

    return true;
}

function GetBindPageData()
{
	return new RouteItemClass(getValue("domain"), getValue("DestIPAddress_text"), getValue("GatewayIPAddress_text"), getSelectVal("Interface_select"));
}

function processipv6(ipv6)
{
	var ipv6array=ipv6.split(":");
	if(ipv6array.length!=8)
	{
		var str="::";
		for(var i=0;i<8-ipv6array.length;i++)
		{
			str+=":";
		}
	}
	return ipv6.replace("::",str);

}
	
function CheckFormIPv6(RouteItem)
{ 
	if (RouteItem.DestIPPrefix =="")
	{
		AlertEx(sroute_language['bbsp_prefixreq1']);
		return false;
	}
	var List = RouteItem.DestIPPrefix.split("/");
	if (List.length != 2)
	{
		AlertEx(sroute_language['bbsp_prefixinvalid1']);
		return false;   
	}
	if ('' == List[1])
	{
		AlertEx(sroute_language['bbsp_prefixinvalid']);
		return false;
	}
	if (isNaN(List[1]) == true || parseInt(List[1],10) <= 0 || parseInt(List[1],10) > 128 || isNaN(List[1].replace(' ', 'a')) == true)
	{
		AlertEx(sroute_language['bbsp_prefixinvalid']);
		return false;     
	}

	if (IsIPv6AddressValid(List[0]) == false || IsIPv6ZeroAddress(List[0]) == true || IsIPv6LoopBackAddress(List[0]) == true || IsIPv6MulticastAddress(List[0]) == true)
	{
		AlertEx(sroute_language['bbsp_prefixinvalid']);
		return false;   
	} 
	 
	if (RouteItem.NextHop != "")
	{
	if (IsIPv6AddressValid(RouteItem.NextHop) == false || IsIPv6ZeroAddress(RouteItem.NextHop) == true || IsIPv6LoopBackAddress(RouteItem.NextHop) == true || IsIPv6MulticastAddress(RouteItem.NextHop) == true)
		{
			AlertEx(sroute_language['bbsp_nexthopinvalid1']);
			return false;
		}
	}

	if (RouteItem.WanName == "")
	{
		AlertEx(sroute_language['bbsp_wanreq']);
		return false;
	}  
	var ipv6=processipv6(List[0]).split(":");
	var j=0;
	for(var i=0;i<StaticRoute.length;i++)
	{
		if ("IPv6" != StaticRoute[i].IpVersion)
		{
			continue;
		}
		
		if(StaticRoute[i]==null)
		{
			continue;
		}
		
		if(i==routeIdx)
		{
			continue;
		}
		Ipv6Route=StaticRoute[i].DestIPPrefix.split("/");

		if(List[1]!=Ipv6Route[1])
			continue;
		

		var itemipv6=processipv6(Ipv6Route[0]).split(":");
		var isequal=1;

		var k=parseInt((List[1]/16).toString().split(".")[0]);

		for(j=0;j<k;j++)
		{
			if(itemipv6[j]!=ipv6[j]&&parseInt(itemipv6[j],16)!=parseInt(ipv6[j],16))
			{
				isequal=0;
				break;
			}
		}
		if(isequal==0)
		{
			continue;
		}
		

		if(itemipv6[j]==ipv6[j]||parseInt(itemipv6[j],16)==parseInt(ipv6[j],16))
		{
			AlertEx(sroute_language['bbsp_prefixrepeated']);
			return false;
		}
		else
		{
			var y=List[1]%16;
			if(ipv6[j]!='')
			{
				var str1=parseInt(ipv6[j],16).toString(2);
			}
			else
			{
				str1='0';
			}
			if(itemipv6[j]!='')
			{
				var str2=parseInt(itemipv6[j],16).toString(2);
			}
			else
			{
				str2='0';
			}
			var addstr1='';
			var addstr2='';
			for(var n=0;n<16-str1.length;n++)
			{
				addstr1+='0';
			}
			for(var n=0;n<16-str2.length;n++)
			{
				addstr2+='0';
			}
			str1=addstr1+str1;
			str2=addstr2+str2;
			var substr1=str1.substring(0,y);
			var substr2=str2.substring(0,y);

			if(substr1==substr2)
			{
				AlertEx(sroute_language['bbsp_prefixrepeated']);
				return false;
			}
		}
	}                  	    
	return true;        
}

function SubmitFormIPv4()
{
	var Form = new webSubmitForm();
	
	if(AddFlag == false)
    {   
        if (CheckFormIPv4(Form) == false)
        {
            return;
        }
		var routemain = StaticRoute[routeIdx].domain;
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.setAction('set.cgi?x=' + routemain 
    		  	        + '&RequestFile=html/bbsp/staticroute/staticroutee8c.asp');
    }
    else
    {
		if (CheckFormIPv4(Form) == false)
    	{
    	     return;
    	}
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
        Form.setAction('add.cgi?x=InternetGatewayDevice.Layer3Forwarding.Forwarding'
    		  	              + '&RequestFile=html/bbsp/staticroute/staticroutee8c.asp');  
    }

	setDisable('addButton',1);
    setDisable('btnApply_ex',1);
    setDisable('canelButton',1);
    Form.submit();
    DisableRepeatSubmit();
}

function SubmitFormIPv6()
{
	var RouteItem = GetBindPageData();
	if (CheckFormIPv6(RouteItem) == false)
	{
		return false;
	}
	
	var Form = new webSubmitForm();
	Form.addParameter('x.WanName', domainTowanname(RouteItem.WanName));
	Form.addParameter('x.DestIPPrefix',RouteItem.DestIPPrefix);
	Form.addParameter('x.NextHop',RouteItem.NextHop);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	if(AddFlag == true)
	{
		Form.setAction('add.cgi?' +'x=InternetGatewayDevice.X_HW_IPv6Layer3Forwarding.Forwarding' + '&RequestFile=html/bbsp/staticroute/staticroutee8c.asp');
	}
	else
	{
		Form.setAction('set.cgi?' +'x='+RouteItem.domain + '&RequestFile=html/bbsp/staticroute/staticroutee8c.asp');
	}

	Form.submit();
	DisableRepeatSubmit();
}

function SubmitForm()
{  
	var ipVersion = getSelectVal('IpVersion_select');
	if ("IPv4" == ipVersion)
	{
		SubmitFormIPv4();
	}
	else if ("IPv6" == ipVersion)
	{
		SubmitFormIPv6();
	}
    
}

function onClickAdd()
{
	clickAdd('e8cstaticroute');
}

function setCtlDisplay(record, WanIndex)
{
    if (record != null)
	{
		if ('' == record.IpVersion)
		{
			setSelect("IpVersion_select", "IPv4");
		}
		else
		{
			setSelect("IpVersion_select", record.IpVersion);
		}
		
		if ("IPv4" == getSelectVal('IpVersion_select'))
		{
			setText('DestIPAddress_text',record.DestIPAddress);
			if (record.mask == '0.0.0.0')
			{
				setText('DestSubnetMask_text','');	
			}
			else
			{
				setText('DestSubnetMask_text',record.mask);
			}
			
			if (record.DestIPAddress == "" && true != AddFlag )
			{
				setText('DestIPAddress_text','');	
				setRadio("StaticRouteCfgMode",'DomainMode');
			}
			else
			{
				setRadio("StaticRouteCfgMode",'IpMode');
				setText('DestIPAddress_text',record.DestIPAddress);
			}
			setText('StaticRouteDomain',record.StaticRouteDomain);
		}
		else if ("IPv6" == getSelectVal('IpVersion_select'))
		{
			setText('DestIPAddress_text',record.DestIPPrefix);
			setText("domain", record.domain);
		}
    	
		if (record.Gateway == '0.0.0.0')
		{
			setText('GatewayIPAddress_text','');	
		}
		else
		{
			setText('GatewayIPAddress_text',record.Gateway);	
		}
	
    }
    else
    {
		setSelect("IpVersion_select", "IPv4");
        setText('StaticRouteDomain','');
        setText('DestIPAddress_text','');
    	setText('GatewayIPAddress_text','');		
    	setText('DestSubnetMask_text','');
		setText("domain", '');
    }
	OnChangeIpVersion();
	if (record != null)
	{
		setStaticRouteCfgDisplay(record.IpVersion);
		setSelect('Interface_select',record.Interface);
	}
	else
	{
		setStaticRouteCfgDisplay("IPv4");
	}
}

function setControl(index)
{
    var record;
	var selectObj = getElement('Interface_select');
	var i = parseInt(selectObj.selectedIndex);
	PreRouteIdx = routeIdx;
    routeIdx = index;
		
    if (index == -1)
	{   
		setDisable('IpVersion_select',0);
	    setDisable('Interface_select',0);
	  	if (StaticRoute.length>= (parseInt(SRoutelistMaxNum,10)))
        {
            setDisplay('ConfigForm', 1); 
			setDisplay('DivAddButton', 0); 
			AlertEx(sroute_language['bbsp_alert_sroutefull']);
			setDisable('btnApply_ex',1);
            return;
        }
        else
        {
            setDisplay('ConfigForm', 1);
			setDisplay('DivAddButton', 0);
            AddFlag = true;
            if (i == -1)
	        {
	            record = new stStaticRoute('', '', '', '', '', '','','');
            }
            else
            {
                var idx = selectObj.options[i].id.split('_')[1];
                record = new stStaticRoute('', '', '', '', '', '','','');
            }
			setCtlDisplay(record);
        }
	}
    else if (index == -2)
    {
        setDisplay('ConfigForm', 0);
		setDisplay('DivAddButton', 1);
    }
    else
	{
		if (index != PreRouteIdx)
		{
			var tableID = index + 2;
			var DelId = getStaticRouterListId(tableID,5);
			setDisable(DelId,0);
			if (PreRouteIdx != -1)
			{
				tableID = PreRouteIdx + 2;
				DelId = getStaticRouterListId(tableID,5);
				setDisable(DelId,1);
			}
		}
		
	    setDisplay('ConfigForm', 1);
		setDisplay('DivAddButton', 0);
		setDisable('IpVersion_select',1);
        setDisable('Interface_select',1);
        AddFlag = false;
	    record = StaticRoute[index];
		setCtlDisplay(record);
	}
	
    setDisable('addButton',0);
    setDisable('btnApply_ex',0);
    setDisable('canelButton',0);
}

function CancelValue()
{
    if (routeIdx == -1)
    {
        var tableRow = getElement("staticRouteInst");

        if (tableRow.rows.length == 1)
        {
        }
        else if (tableRow.rows.length == 2)
        {
            addNullInst('e8cstaticroute');
        }
        else
        {
            tableRow.deleteRow(tableRow.rows.length-1);
            selectLine('record_0');
        }
    }
    else
    {
        var record = StaticRoute[routeIdx];
		setCtlDisplay(record);
    }
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<form id="Configure"> 
  <table width="100%"  border="0" cellpadding="0" cellspacing="0" id="tabTest"> 
    <tr> 
      <td class="prompt"> <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
          <tr> 
            <td class='title_common' BindText='bbsp_title_prompt1'></td> 
          </tr> 
        </table></td> 
    </tr> 
    <tr> 
      <td class='height5p'></td> 
    </tr> 
  </table> 
  <script language="JavaScript" type="text/javascript">
    writeTabCfgHeader('e8cstaticroute','100%');
  </script>
  <table class="tabal_bg" id="staticRouteInst" width="100%" cellspacing="1"> 
	<label id="StaticRouteInfo_lable" class="align_left" width="100%" style="font-weight: bold;"><script>document.write(sroute_language['bbsp_staticRouteInfo']);</script></label> 
    <tr class="head_title"> 
	  <td id="StaticRouteInfo_1_1_table" BindText='bbsp_td_ipversion'></td> 
      <td id="StaticRouteInfo_1_2_table" BindText='bbsp_td_ipsubmask'></td> 
      <td id="StaticRouteInfo_1_3_table" BindText='bbsp_td_gw1'></td> 
      <td id="StaticRouteInfo_1_4_table" BindText='bbsp_td_wanname1'></td> 
      <td id="StaticRouteInfo_1_5_table" BindText='bbsp_td_del'></td> 
    </tr> 
    <script language="JavaScript" type="text/javascript">
		showlistcontrol();
   </script> 
  </table>
  <div id="ConfigForm2"> 
    <table  width="100%" class="table_button"> 
		<tr > 
			<td class='width_40p'></td> 
			<td class='title_bright1' > 
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
			<td class='width_5p'></td>
			<td  class='title_bright1'>
				<script> document.write(sroute_language['bbsp_goto']); </script> 
					<input  type="text" name="pagejump" id="pagejump" size="2" maxlength="2" style="width:20px;" />
				<script> document.write(sroute_language['bbsp_page']); </script>
			</td>
			<td class='title_bright1'>
				<button name="jump"  id="jump" class="submit" type="button" onClick="submitjump();"> <script> document.write(sroute_language['bbsp_jump']); </script></button> 
			</td>
		</tr> 	  
    </table> 
  </div>  
  <div id="ConfigForm" style="display:block;"> 
  <table cellpadding="0" cellspacing="1" border="0" width="100%"> 
	 <tr> 
	  <td class="height20p"></td> 
   </tr> 
   </table>
    <table cellpadding="0" cellspacing="0" border="0" id="cfg_table" width="100%"> 
		<tr class="trTabConfigure" style="display:none"> 
		  <td  class="table_title align_left width_20p"  BindText='bbsp_instancemh'></td> 
		  <td  class="table_right"> <input type=text id="domain" maxlength='255' ErrorMsg="" datatype="int" minvalue="0" maxvalue="253" default="0"/> </td> 
		</tr> 
      <tr> 
        <td> <table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr id="StaticRouteIpVersionTr"> 
				<td  class="table_title width_25p" BindText='bbsp_ipversion'></td>
				<td  class="table_right"><select name='IpVersion_select'  id="IpVersion_select" size='1' onChange="OnChangeIpVersion();"> 
					<option value="IPv4"><script>document.write(sroute_language['bbsp_IPv4']);</script></option>
					<option value="IPv6"><script>document.write(sroute_language['bbsp_IPv6']);</script></option>
				 </select></td> 
			</tr>
           <tr id="StaticRouteAddrFormatTr"> 
              <td  class="table_title" BindText='bbsp_static_route_addr_format1'></td>
                <td  class="table_right"> 
                    <input name="StaticRouteCfgMode" id="StaticRouteCfgMode" type="radio" value="IpMode" checked="checked" onclick="StaticRouteCfgIpOrDomain()"/>
                <script>document.write(sroute_language['bbsp_cfg_type_ip']);</script>
                    <input name="StaticRouteCfgMode" id="StaticRouteCfgMode" type="radio" value="DomainMode" onclick="StaticRouteCfgIpOrDomain()"/>
                <script>document.write(sroute_language['bbsp_cfg_type_domain']);</script>
                </td>
            </tr> 
            <tr id="StaticRouteDomainTr"> 
              <td  class="table_title width_25p" BindText='bbsp_cfg_type_domain'></td> 
              <td  class="table_right"> <input type='text' id='StaticRouteDomain' name='StaticRouteDomain' maxlength='255'/> 
                <font class='color_red'>*</font><span class="gray" ><script>document.write(sroute_language['bbsp_sroute_domaintips']);</script></span>
              </td> 
            </tr>
            <tr id="StaticRouteIpTr"> 
              <td  class="table_title width_25p"><div id="DivSrouteIp"></div></td> 
              <td  class="table_right"> <input type='text' id='DestIPAddress_text' name='DestIPAddress_text'/>
                <font class='color_red'>*</font> 
                <span class="gray" id="DivSrouteIpTips"></span>
              </td> 
            </tr> 
           <tr id="StaticRouteIpMaskTr"> 
              <td  class="table_title" BindText='bbsp_td_submask'></td> 
              <td  class="table_right"> <input type='text' id='DestSubnetMask_text' name='DestSubnetMask_text'/> 
                <font class='color_red'>*</font> </td> 
            </tr> 
            <tr > 
              <td  class="table_title" BindText='bbsp_td_gw1'></td> 
              <td  class="table_right"> <input type='text' id='GatewayIPAddress_text' name='GatewayIPAddress_text' /><script>document.write(sroute_language['bbsp_gw_blank']);</script></td> 
            </tr> 
            <tr > 
              <td  class="table_title" BindText='bbsp_td_wanname2mh'></td> 
              <td  class="table_right"> <select name='Interface_select'  id="Interface_select" size='1'> 
                  <script language="javascript">
					   WriteOption();
					</script> 
                </select> </td> 
            </tr> 
          </table></td> 
      </tr>	  
    </table> 
	<table class="table_button" cellspacing="1" id="cfg_table" width="100%"> 
      <tr align="right">
	    <td class='width_15p'></td>
        <td > 
		  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
		  <button id="addButton" name="addButton" type="button" class="submit" onClick="onClickAdd();"><script>document.write(sroute_language['bbsp_add']);</script></button>
		  <button id="btnApply_ex" name="btnApply_ex" type="button" class="submit" onClick="SubmitForm();"><script>document.write(sroute_language['bbsp_app']);</script></button>
          <button id="canelButton" name="canelButton" type="button" class="submit" onClick="CancelValue();"><script>document.write(sroute_language['bbsp_cancel']);</script></button>
		</td> 
      </tr>   
    </table>
  </div> 
  <div id="DivAddButton" style="display:none;">
  <table class="table_button"  id="cfg_table" width="100%"> 
      <tr align="right">
        <td class='width_15p'></td>
        <td> 
		  <button id="addButton1" name="addButton1" type="button" class="submit" onClick="onClickAdd();"><script>document.write(sroute_language['bbsp_add']);</script></button>
		</td> 
      </tr>   
    </table>
  </div>

  <script language="JavaScript" type="text/javascript">
	writeTabTail();
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
</form> 
</body>
</html>

