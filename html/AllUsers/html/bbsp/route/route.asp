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
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<title>Chinese -- Static Route</title>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">


function stDftRoute(domain,autoenable,wandomain)
{
	this.domain 	= domain;
	this.autoenable = autoenable;
	this.wandomain 	= wandomain;
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
		b.innerHTML = route_language[b.getAttribute("BindText")];
	}
}


	var dftRoutes = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Layer3Forwarding,X_HW_AutoDefaultGatewayEnable|DefaultConnectionService,stDftRoute);%>;

var dftRoute = dftRoutes[0];

function filterWan(WanItem)
{
	if (!(WanItem.Tr069Flag == '0' && (IsWanHidden(domainTowanname(WanItem.domain)) == false)))
	{
		return false;	
	}
	
	return true;
}

var WanInfo = GetWanListByFilter(filterWan);

function MakeWanName(wan)
{
	var wanInst = 0;
	var wanServiceList = '';
	var wanMode = '';
	var vlanId = 0;
	var currentWanName = ''; 

	if('&nbsp;'!= wan)
	{
		DomainElement = wan.domain.split(".");
		wanInst = DomainElement[4];
		wanServiceList  = wan.ServiceList;
		wanMode         = (wan.CntType  ==  'IP_Routed' ) ? "R" : "B";
		vlanId          = wan.vlanid;

		if (GetCfgMode().PCCWHK == "1")
		{
			wanMode = (wan.CntType == 'IP_Routed' ) ? "Route" : "Bridge"
    		currentWanName = wanInst + "_" + wanMode + "_" + "WAN";	
		}
		else
		{
			if (0 != parseInt(vlanId,10))
			{
				currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_" + vlanId;
			}
			else
			{
				currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_";
			}
		}

  	    return currentWanName;
   	}
    else
  	{
  	   	return '&nbsp;';
  	}  
}

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

function LoadFrame()
{
    if (typeof(dftRoute) == 'undefined')
    {
        setCheck('dftIfStr',0);
    }
	else if (dftRoute.autoenable == '0')
	{
		setCheck('dftIfStr',0);
        setSelect('DefaultConnectionService',dftRoute.wandomain);
	}
	else
	{
		setCheck('dftIfStr',1);
		setSelect('DefaultConnectionService',dftRoute.wandomain);
	}
	
	loadlanguage();
}

function IsIPv4RouteWan(Wan)
{
	if (Wan.IPv4Enable == "1" && Wan.Mode =="IP_Routed")
	{
		return true;
	} 
	return false;
}      


function SubmitForm()
{   
	 var Form = new webSubmitForm();
     
     var selectObj = getElement('DefaultConnectionService');
	 var index = 0;
     var idx = 0;
 
	 index = parseInt(selectObj.selectedIndex,10);
	 if ( index < 0 )
	 {
	 	  AlertEx(route_language['bbsp_alert_wan']);		      
          return false;
	 }
     idx = selectObj.options[index].id.split('_')[1];

	 Form.addParameter('x.X_HW_AutoDefaultGatewayEnable',getCheckVal('dftIfStr'));
	 Form.addParameter('x.DefaultConnectionService',getSelectVal('DefaultConnectionService'));
	 Form.addParameter('x.X_HW_Token', getValue('onttoken'));

     Form.setAction('set.cgi?x=InternetGatewayDevice.Layer3Forwarding&RequestFile=html/bbsp/route/route.asp');
     setDisable('btnApply', 1);
     setDisable('cancelValue', 1);
     Form.submit();   
}

function CancelConfig()
{
    LoadFrame();
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<form id="Configure"> 
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("routetitle", GetDescFormArrayById(route_language, ""), GetDescFormArrayById(route_language, "bbsp_title_prompt"), false);
</script> 
<div class="title_spread"></div>
 
  <table cellpadding="0" cellspacing="1" class="tabal_bg" width="100%"> 
    <tr> 
      <td class="table_title width_per25" BindText='bbsp_td_deroute'></td> 
      <td class="table_right"> <input type="checkbox" id='dftIfStr' name='dftIfStr'></td> 
    </tr> 
    <tr> 
      <td  class="table_title width_per25" BindText='bbsp_td_wanname'></td> 
      <td class="table_right"> <select name="DefaultConnectionService" id="DefaultConnectionService" maxlength="30" class="width_260px"> </select> </td> 
    </tr> 
  </table> 
  <table cellpadding="0" cellspacing="0"  width="100%" class="table_button"> 
    <tr> 
      <td class='width_per25's></td> 
      <td class="table_submit">
	  	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
	 	<button name="btnApply" id="btnApply" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="SubmitForm();"><script>document.write(route_language['bbsp_app']);</script></button>
        <button name="cancelValue" id="cancelValue" type="button" class="CancleButtonCss buttonwidth_100px" onClick="CancelConfig();"><script>document.write(route_language['bbsp_cancel']);</script></button> </td> 
    </tr> 
  </table> 
  <script>
  	InitWanNameListControl1("DefaultConnectionService", IsIPv4RouteWan);
  </script>
</form> 
</body>
</html>
