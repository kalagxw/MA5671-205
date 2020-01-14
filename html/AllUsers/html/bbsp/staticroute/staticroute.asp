<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="Javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<title>Static Route</title>
<script language="javascript" src="../common/wan_check.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">

var IPv4SRoutelistMaxNum = '<%HW_WEB_GetSPEC(BBSP_SPEC_IPV4_ROUTE_MAXNUM.UINT32);%>';

var currentFile='staticroute.asp';

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

var host = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_FilterSlaveLanHostIp, InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},IPInterfaceIPAddress|IPInterfaceSubnetMask,stHost);%>;
var IpAddress = host[0].IPInterfaceIPAddress;
var SubnetMask = host[0].IPInterfaceSubnetMask;

var AddFlag = true;
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

function stStaticRoute(domain, StaticRouteDomain,DestIPAddress, Gateway, mask, Interface)
{
    this.domain = domain;
    this.StaticRouteDomain = StaticRouteDomain;
	this.DestIPAddress = DestIPAddress;
	this.Gateway = Gateway;
	this.mask = mask;
	this.Interface = Interface;
}      
var AllWanInfoTemp = GetWanList();

var StaticRoutes = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Layer3Forwarding.Forwarding.{i},X_HW_DomainName|DestIPAddress|GatewayIPAddress|DestSubnetMask|Interface,stStaticRoute);%>;  

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
for (i = 0; i < StaticRoutes.length-1; i++)
{
	if (FindWanInfo(StaticRoutes[i]) == true)
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

function showlist(startlist , endlist)
{
	if( 0 == RouteInfoNr )
	{
        document.write('<TR id="record_no"' 
    	                + ' class="tabal_center01 " onclick="selectLine(this.id);">');
        document.write('<TD >--</TD>');
        document.write('<TD >--</TD>');
        document.write('<TD >--</TD>');
    	document.write('<TD >--</TD>');
    	document.write('<TD >--</TD>');
    	document.write('</TR>');
		return;
	}

	for(i=startlist;i <= endlist - 1;i++)   
	{
	    if ((StaticRoute[i].Interface) != "")
        {
		    document.write('<TR id="record_' + i 
				    + '" class="tabal_01" onclick="selectLine(this.id);">');
		    document.write('<TD>' + '<input type="checkbox" name="rml"'  + ' value=' 
				     + StaticRoute[i].domain  + '>' + '</TD>');
		    document.write('<TD>' + MakeWanName(getWanOfStaticRoute(StaticRoute[i].Interface)) + '</TD>');
		    if ("" != StaticRoute[i].DestIPAddress)
		    {
		        document.write('<TD>' + StaticRoute[i].DestIPAddress + '</TD>');
		    }
		    else
	        {
	            document.write('<TD>' + GetStringContent(StaticRoute[i].StaticRouteDomain,30) + '</TD>');
	        }
		    document.write('<TD>' + StaticRoute[i].Gateway + '</TD>');
		    document.write('<TD>' + StaticRoute[i].mask + '</TD>');
		    document.write("</tr>");
	    }
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
    if (GetCfgMode().BJUNICOM == "1")
    {
        setDisable("DestIPAddress", 1);
        setDisable("DestSubnetMask", 1);
        setDisable("GatewayIPAddress", 1);
        setDisable("Interface", 1);        
    }
	StaticRouteCfgIpOrDomain();
}

function AddSubmitParam(SubmitForm,type)
{

}

function WriteOption()
{
    for (i = 0; i < WanInfo.length; i++)
    {
   	   if (WanInfo[i].Mode == 'IP_Routed' && WanInfo[i].IPv4Enable == '1')
   	   {
	         document.write('<option id="wan_' + i + '" value="' + WanInfo[i].domain + '">' + MakeWanName1(WanInfo[i]) + '</option>');
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
		  setText('DestIPAddress','');
		  setText('DestSubnetMask','');
		  setText('GatewayIPAddress','');
   }
}

function setDefaultgateway()
{ 
     var selectObj = getElement('Interface');
	 var index = parseInt(selectObj.selectedIndex);

	 setText('GatewayIPAddress','');
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
        
    setDisable('btnApply_ex',1);
    setDisable('canelButton',1);
	removeInst('html/bbsp/staticroute/staticroute.asp');
}       

function CheckForm_DstIp()
{
    var DestIp = getValue('DestIPAddress');
    var index1 = IpAddress.lastIndexOf('.');
    var index2 = DestIp.lastIndexOf('.');
    
    if ((DestIp == '') || (getValue('DestSubnetMask') == ''))
    {           
		AlertEx(sroute_language['bbsp_alert_ipmaskuil']);	
        return false;
    }

    if ( isAbcIpAddress(DestIp) == false 
        || isDeIpAddress(DestIp) == true 
        || isBroadcastIpAddress(DestIp) == true 
        || isLoopIpAddress(DestIp) == true ) 
    {              
		AlertEx(sroute_language['bbsp_alert_addrunvail']);	
        return false;
    }

    if (IpAddress == DestIp
        || (DestIp.substr(index1 + 1) == '0' && IpAddress.substr(0,index1)
        == DestIp.substr(0,index2))) 
    {           
		AlertEx(sroute_language['bbsp_alert_addrunvail2']);	
        return false;
    }
    return true;
}	

function CheckForm_DstMask()
{
    if (getValue('DestSubnetMask') == null)
    {            
    	AlertEx(sroute_language['bbsp_alert_masknill']);	
        return false;
    }
    
    if ( isValidSubnetMask(getValue('DestSubnetMask')) == false 
        &&  getValue('DestSubnetMask') != '255.255.255.255')
    {            
    	AlertEx(sroute_language['bbsp_alert_mask'] + getValue('DestSubnetMask') + sroute_language['bbsp_alert_invail']);	
        return false;
    }
    return true;
}

function CheckForm_Gateway()
{
    var Dsub = getValue('DestSubnetMask').split('.');
    var Dgw = getValue('GatewayIPAddress').split('.');
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
  
        if (getValue('GatewayIPAddress').length > 0)
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

        if (getValue('GatewayIPAddress').length > 0)
        {
            if ( isAbcIpAddress(getValue('GatewayIPAddress')) == false  || (getValue('GatewayIPAddress') == getValue('DestIPAddress')))
            {
    			AlertEx(sroute_language['bbsp_alert_defgwunvail'] + getValue('GatewayIPAddress') + sroute_language['bbsp_alert_invail']);
                return false;
            }       
        }
        if (isMatchedIpAndMask(getValue('DestIPAddress'), getValue('DestSubnetMask')) == false)
        {            
    		AlertEx(sroute_language['bbsp_alert_ipaddr']  + getValue('DestIPAddress') + sroute_language['bbsp_alert_andmask'] + getValue('DestSubnetMask') + sroute_language['bbsp_alert_notmatch']);
            return false;          
        }
    }
    else
    {

        if (getValue('GatewayIPAddress').length > 0)
        {
            if ( isAbcIpAddress(getValue('GatewayIPAddress')) == false  || (getValue('GatewayIPAddress') == getValue('DestIPAddress')))
            {
    			AlertEx(sroute_language['bbsp_alert_defgwunvail'] + getValue('GatewayIPAddress') + sroute_language['bbsp_alert_invail']);
                return false;
            }       
        }
    }

    return true;
}

function CheckForm_Interface()
{
    var selectObj = getElement('Interface');
    var index = parseInt(selectObj.selectedIndex,10);

    if ( index < 0 )
    {
		AlertEx(sroute_language['bbsp_alert_createwan']);
        return false;
    }
    return true;
}
function CheckForm(Form)
{   
    var selectObj = getElement('Interface');
    var index = parseInt(selectObj.selectedIndex,10);
    var idx = 0, i =0, netaddlen = 0;
    var isavlideGWip = false;

    if ( index < 0 )
    {
		AlertEx(sroute_language['bbsp_alert_setwan']);	
        return false;
    }

    for (i = 0; i < StaticRoute.length - 1; i++)
    {
        if (routeIdx != i)
        {
            if (StaticRoute[i].DestIPAddress == getValue('DestIPAddress') && "" != getValue('DestIPAddress'))
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
            Form.addParameter('x.DestIPAddress',getValue('DestIPAddress'));

            if (false == CheckForm_DstMask())
            {
                return false;
            }
            Form.addParameter('x.DestSubnetMask',getValue('DestSubnetMask'));
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
        Form.addParameter('x.GatewayIPAddress',getValue('GatewayIPAddress'));
        

        if (false == CheckForm_Interface())
        {
            return false;
        }
        Form.addParameter('x.Interface',getSelectVal('Interface'));
    }

    return true;
}

function SubmitForm()
{   
    var Form = new webSubmitForm();
	
    if(AddFlag == false)
    {   
        if (CheckForm(Form) == false)
        {
            return;
        }
		var routemain = StaticRoute[routeIdx].domain;
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.setAction('set.cgi?x=' + routemain 
    		  	        + '&RequestFile=html/bbsp/staticroute/staticroute.asp');
    }
    else
    {
		if (CheckForm(Form) == false)
    	{
    	     return;
    	}
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
        Form.setAction('add.cgi?x=InternetGatewayDevice.Layer3Forwarding.Forwarding'
    		  	              + '&RequestFile=html/bbsp/staticroute/staticroute.asp');  
    }

    setDisable('btnApply_ex',1);
    setDisable('canelButton',1);
    Form.submit();
	DisableRepeatSubmit();
}

function setCtlDisplay(record, WanIndex)
{
    if (record != null)
	{
    	setText('DestIPAddress',record.DestIPAddress);
		if (record.Gateway == '0.0.0.0')
		{
			setText('GatewayIPAddress','');	
		}
		else
		{
			setText('GatewayIPAddress',record.Gateway);	
		}
	
		if (record.mask == '0.0.0.0')
		{
			setText('DestSubnetMask','');	
		}
		else
		{
			setText('DestSubnetMask',record.mask);
		}
		
		if (record.DestIPAddress == "" && true != AddFlag )
		{
			setText('DestIPAddress','');	
			setRadio("StaticRouteCfgMode",'DomainMode');
		}
		else
	    {
	        setRadio("StaticRouteCfgMode",'IpMode');
	        setText('DestIPAddress',record.DestIPAddress);
	    }

		setText('StaticRouteDomain',record.StaticRouteDomain);
    	setSelect('Interface',record.Interface);
    	StaticRouteCfgIpOrDomain();
    }
    else
    {
        setText('StaticRouteDomain','');
        setText('DestIPAddress','');
    	setText('GatewayIPAddress','');		
    	setText('DestSubnetMask','');
    }

}

function setControl(index)
{
    var record;
	var selectObj = getElement('Interface');
	var i = parseInt(selectObj.selectedIndex);
    routeIdx = index;
		
    if (index == -1)
	{   
	    setDisable('Interface',0);
	    if (StaticRoute.length >= (parseInt(IPv4SRoutelistMaxNum,10)))
        {
            setDisplay('ConfigForm', 0);            
			AlertEx(sroute_language['bbsp_alert_sroutefull']);
            return;
        }
        else
        {
            setDisplay('ConfigForm', 1);
            AddFlag = true;
            if (i == -1)
	        {
	            record = new stStaticRoute('', '', '', '', '', '');
            }
            else
            {
                var idx = selectObj.options[i].id.split('_')[1];
                record = new stStaticRoute('', '', '', '', '', '');
            }
			setCtlDisplay(record);
        }
	}
    else if (index == -2)
    {
        setDisplay('ConfigForm', 0);
    }
    else
	{
	    setDisplay('ConfigForm', 1);
        setDisable('Interface',1);
        AddFlag = false;
	    record = StaticRoute[index];
		setCtlDisplay(record);
	}

    if (GetCfgMode().BJUNICOM == "1")
    {
        setDisable('btnApply_ex',1);
        setDisable('canelButton',1);
    }
    else
    {
        setDisable('btnApply_ex',0);
        setDisable('canelButton',0);
    }
}

function CancelValue()
{
    setDisplay("ConfigForm", 0);
	
	if (routeIdx == -1)
    {
        var tableRow = getElement("staticRouteInst");

        if (tableRow.rows.length == 1)
        {
        }
        else if (tableRow.rows.length == 2)
        {
            addNullInst('Static Route');
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
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("ipv4staticroutetitle", GetDescFormArrayById(sroute_language, ""), GetDescFormArrayById(sroute_language, "bbsp_title_prompt"), false);
</script> 
<div class="title_spread"></div>
  
  <script language="JavaScript" type="text/javascript">
if (GetCfgMode().BJUNICOM != "1")
{
    writeTabCfgHeader('Static Route','100%');
}
</script> 
  <table class="tabal_bg" id="staticRouteInst" width="100%" cellspacing="1"> 
	<tr  class="head_title">
		<td>&nbsp;</td>
		<td><script>document.write(sroute_language['bbsp_td_wanname']);</script></td>
		<td><script>document.write(sroute_language['bbsp_td_ip']);</script></td>  
		<td><script>document.write(sroute_language['bbsp_td_gw']);</script></td>
		<td><script>document.write(sroute_language['bbsp_td_submask']);</script></td> 		
    </tr>
    <script language="JavaScript" type="text/javascript">
		showlistcontrol();
   </script> 
  </table>
  
  <div id="ConfigForm2"> 
  <div class="list_table_spread"></div>
    <table cellpadding="0" cellspacing="0"  width="100%" class="table_button"> 
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
  <div id="ConfigForm" style="display:none"> 
    <table class="tabal_bg" cellpadding="0" cellspacing="1" border="0" id="cfg_table" width="100%"> 
      <tr> 
        <td> <table cellpadding="0" cellspacing="1" class="tabal_bg" width="100%">
            <tr > 
              <td  class="table_title" BindText='bbsp_static_route_addr_format'></td>
                <td  class="table_title"> 
                    <input name="StaticRouteCfgMode" id="StaticRouteCfgMode" type="radio" value="IpMode" checked="checked" onclick="StaticRouteCfgIpOrDomain()"/>
                <script>document.write(sroute_language['bbsp_cfg_type_ip']);</script>
                    <input name="StaticRouteCfgMode" id="StaticRouteCfgMode" type="radio" value="DomainMode" onclick="StaticRouteCfgIpOrDomain()"/>
                <script>document.write(sroute_language['bbsp_cfg_type_domain']);</script>
                </td>
            </tr> 
            <tr id="StaticRouteDomainTr"> 
              <td  class="table_title width_per25" BindText='bbsp_domain'></td> 
              <td  class="table_right"> <input type='text' id='StaticRouteDomain' name='StaticRouteDomain' size="255" maxlength='255' class='width_254px'/> 
                <font class='color_red'>*</font><span class="gray" ><script>document.write(sroute_language['bbsp_sroute_domaintips']);</script></span>
              </td> 
            </tr> 
            <tr id="StaticRouteIpTr"> 
              <td  class="table_title width_per25" BindText='bbsp_td_ip2'></td> 
              <td  class="table_right"> <input type='text' id='DestIPAddress' name='DestIPAddress' maxlength='15' class='width_254px'/>
                <font class='color_red'>*</font> 
                <span class="gray" ><script>document.write(sroute_language['bbsp_sroute_domaintips']);</script></span>
              </td> 
            </tr> 
            <tr id="StaticRouteIpMaskTr"> 
              <td  class="table_title" BindText='bbsp_td_submask2'></td> 
              <td  class="table_right"> <input type='text' id='DestSubnetMask' name='DestSubnetMask' maxlength='15' class='width_254px'/> 
                <font class='color_red'>*</font> </td> 
            </tr> 
            <tr > 
              <td  class="table_title" BindText='bbsp_td_gw2'></td> 
              <td  class="table_right"> <input type='text' maxlength='15' id='GatewayIPAddress' name='GatewayIPAddress' class='width_254px'/>
              <span class="gray" ><script>document.write(sroute_language['bbsp_gw_blank']);</script></span>
              </td> 
            </tr> 
            <tr > 
              <td  class="table_title" BindText='bbsp_td_wanname2'></td> 
              <td  class="table_right"> <select name='Interface'  id="Interface" maxlength="30" onChange="setDefaultgateway()" class='width_260px'> 
                  <script language="javascript">
                               WriteOption();
                            </script> 
                </select> </td> 
            </tr> 
          </table></td> 
      </tr>	  
    </table> 
	<table class="table_button" cellspacing="1" id="cfg_table" width="100%"> 
      <tr> 
	    <td class='width_per15'>&nbsp;</td>
        <td class="table_submit pad_left5p"> 
		  <button id="btnApply_ex" name="btnApply_ex" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="SubmitForm();"><script>document.write(sroute_language['bbsp_app']);</script></button>
          <button id="canelButton" name="canelButton" type="button" class="CancleButtonCss buttonwidth_100px" onClick="CancelValue();"><script>document.write(sroute_language['bbsp_cancel']);</script></button>  
		</td> 
      </tr>   
    </table>
  </div>  
  <script language="JavaScript" type="text/javascript">
	loadlanguage();
    if (GetCfgMode().BJUNICOM != "1")
	{
		writeTabTail();
	}
	
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

