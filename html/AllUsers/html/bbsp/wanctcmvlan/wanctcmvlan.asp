<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/chinese/jsdiff.js?201411241751591771388803-1425773353"></script>
<script language="javascript" src="../../bbsp/common/managemode.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_check.asp"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>Chinese -- Portmapping</title>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var Wans = GetWanList();
var currentdomain = "";
var currentindex = 0;
var IPv4Enableflag = 0 ;
var IPv6Enableflag = 0 ;
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';

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
		b.innerHTML = wanmvlan_language[b.getAttribute("BindText")];
	}
}

function NoMVlanID(wan)
{
	if((wan.ServiceList =="TR069") || (wan.ServiceList == "VOIP")|| (wan.ServiceList =="TR069_VOIP") || ( '0' == FeatureInfo.RouteWanMulticastIPoE && "IP_ROUTED" == wan.Mode.toString().toUpperCase()) || ('0' == FeatureInfo.BridgeWanMulticast && ("IP_BRIDGED" == wan.Mode.toString().toUpperCase() || "PPPOE_BRIDGED" == wan.Mode.toString().toUpperCase())) )
	{
		return true;
	}
	return false;
}

function WanListNoMVlanID()
{
	for (i = 0;i < Wans.length;i++)
	{
		if(NoMVlanID(Wans[i]) == true)
		{
			continue;
		}
		return false ;
	}
	return true;
}

function writelistzero()
{
	document.write('<tr id="record_no"' + ' class="tabal_center01" >');
	document.write('<td >'+'--'+'</td>');
	document.write('<td >'+'--'+'</td>');
	document.write('<td >'+'--'+'</td>');
	document.write('</tr>');
}

function ShowListTable()
{
	if (Wans.length == 0)
    {
        writelistzero();
		return ;
    }
	else
	{
		if(WanListNoMVlanID() == true )
		{
			writelistzero();
			return;
		}
		
		for (i = 0;i < Wans.length;i++)
		{
			var Wan = Wans[i];
			if(NoMVlanID(Wan) == true)
			{
				continue;
			}
			
			document.write('<TR id="record_' + i +'" class="tabal_center01" onclick="selectLine(this.id);">');
			document.write('<td >'+Wan.Name   +'</td>');

            if ( 0 != parseInt(Wan.VlanId,10) )
            {
				var pri = ('Specified' == Wan.PriorityPolicy) ? Wan.Priority : Wan.DefaultPriority;
                document.write('<td >'+Wan.VlanId+'/'+pri+' </td>');
            }
			else
			{
				document.write('<td >'+'-'+'/'+'-'+' </td>');
			}
			
			document.write('<td >'+Wan.ProtocolType+'</td>');
		}
	}
}

function setControl(index)
{ 
	currentindex = index;
	currentdomain = Wans[index].domain;
    IPv4Enableflag = Wans[index].IPv4Enable ;
    IPv6Enableflag = Wans[index].IPv6Enable ;
	setText("IPV4MultiVlanID", Wans[index].IPv4WanMVlanId);
	setText("IPV6MultiVlanID", Wans[index].IPv6WanMVlanId);
	setDisable("IPV4MultiVlanID",(curUserType == sysUserType) ? 0 : 1 );
	setDisable("IPV6MultiVlanID",(curUserType == sysUserType) ? 0 : 1 ); 
	setDisplay("IPV4MultiCastVlanID",(Wans[index].IPv4Enable == 0) ? 0 : 1);
	setDisplay("IPV6MultiCastVlanID",(Wans[index].IPv6Enable == 0) ? 0 : 1);
	setDisplay("applican", 1);
}

function CheckVlanValid(VlanID,filedDesc)
{
	    errmsg="";
	    errmsg=checkVlanID(VlanID,""); 
	    if(""!=errmsg)
	    {
	  	   AlertEx(filedDesc+errmsg);
	  	   return false;
	  	}
	  	return true;
}
function check()
{
	var IPv4MVlanID = getValue('IPV4MultiVlanID');
	var IPv6MVlanID = getValue('IPV6MultiVlanID');
	
	if (( "" != IPv4MVlanID) && (IPv4Enableflag == 1 ))
	{
		if(CheckVlanValid(IPv4MVlanID,wanmvlan_language['bbsp_ipv4multicast']) == false)
		{
			return false;
		}

	}
	if (( "" != IPv6MVlanID) && (IPv6Enableflag == 1))
	{
		if(CheckVlanValid(IPv6MVlanID,wanmvlan_language['bbsp_ipv6multicast']) == false)
		{
			return false;
		}
	}
}

function Apply()
{
	if(check() == false)
	{
		return false ;
	}
	var IPv4MVlanID = (getValue('IPV4MultiVlanID') != "") ? getValue('IPV4MultiVlanID') : 0xFFFFFFFF;
	var IPv6MVlanID = (getValue('IPV6MultiVlanID') != "") ? getValue('IPV6MultiVlanID') : -1;

	var Form = new webSubmitForm();
	Form.addParameter('x.X_HW_MultiCastVLAN',IPv4MVlanID);
	Form.addParameter('x.X_HW_IPv6MultiCastVLAN',IPv6MVlanID);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('set.cgi?x=' + currentdomain+ '&RequestFile=html/bbsp/wanctcmvlan/wanctcmvlan.asp');
	Form.submit();
	setDisable("IPV4MultiVlanID",1 );
	setDisable("IPV6MultiVlanID",1 );
	setDisable("btnApp",1 );
	setDisable("cancelValue",1 );
}

function Cancel()
{
	setText("IPV4MultiVlanID", Wans[currentindex].IPv4WanMVlanId);
	setText("IPV6MultiVlanID", Wans[currentindex].IPv6WanMVlanId);	
}

function onLoadFrame()
{
	loadlanguage();
}

</script>
</head>
<body onLoad="onLoadFrame();" class="mainbody"> 
<table width="100%" border="0" cellpadding="0" cellspacing="0" id="tabTest"> 
  <tr> 
    <td class="prompt"> <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
        <tr> 
          <td width="100%" class="title_common" BindText='bbsp_wanmvlan_title'></td> 
        </tr> 
      </table></td> 
  </tr> 
  <tr> 
    <td height="5px"></td> 
  </tr> 
</table>
 
<table class="tabal_bg" width="100%" id="DdnsInst" cellspacing="1"> 
	<tr class="head_title"> 
		<td ><script>document.write(wanmvlan_language['bbsp_connectionname']);</script></td> 
		<td ><script>document.write(wanmvlan_language['bbsp_vlanpri']);</script></td> 
		<td ><script>document.write(wanmvlan_language['bbsp_protocoltype']);</script></td> 
	</tr> 
	<script>
		ShowListTable();
	</script> 
</table> 

<div id='IPV4MultiCastVlanID' style="display:none">
<table class="tabal_bg" width="100%" id="DdnsInst" cellspacing="1"> 
   <tr style="">  
    <td class="table_title" width="25%" BindText='bbsp_ipv4mvlanidmh'></td>
	<td class="table_right" width="75%"><input disabled="true" name="IPV4MultiVlanID" type="text" id="IPV4MultiVlanID" maxlength="4" style="width: 150px"> <span class="gray"><script>document.write(wanmvlan_language['bbsp_mvlanidrange']);</script></span> </td> 
	</tr>
</table> 
</div>

<div id='IPV6MultiCastVlanID' style="display:none">
<table class="tabal_bg" width="100%" id="DdnsInst" cellspacing="1"> 
  <tr style=""> 
    <td class="table_title" width="25%" BindText='bbsp_ipv6mvlanidmh'></td>
	<td class="table_right" width="75%"><input disabled="true" name="IPV6MultiVlanID" type="text" id="IPV6MultiVlanID" maxlength="4" style="width: 150px"> <span class="gray"><script>document.write(wanmvlan_language['bbsp_mvlanidrange']);</script></span> </td> 
	</tr>
</table> 
</div>

<div id='applican' style="display:none">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" > 
        <td width="25%"></td> 
        <td style="padding-top:5px;">
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
			<button id="btnApp" name="btnApp" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="Apply();"><script>document.write(wanmvlan_language['bbsp_app']);</script></button>
			<button name="cancelValue" id="cancelValue" class="CancleButtonCss buttonwidth_100px"  type="button" onClick="Cancel();"><script>document.write(wanmvlan_language['bbsp_cancel']);</script></button>
		</td> 
      </tr> 
    </table> 
</div>
</body>
</html>
