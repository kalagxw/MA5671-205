<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="javascript" src="../../bbsp/common/managemode.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list.asp"></script>
<title>DMZ</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">

var WanIndex = -1;
var DmzAddFlag = true;
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
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
		b.innerHTML = dmz_language[b.getAttribute("BindText")];
	}
}

function stDMZInfo(domain,DMZEnable,DMZHostIPAddress)
{
	this.domain = domain;
	this.DMZEnable = DMZEnable;
	this.DMZHostIPAddress = DMZHostIPAddress;
}


var LANhostIP = new Array();
var LANhostName = new Array();

LANhostIP[0] = "";
LANhostName[0] = dmz_language['hostName_select'];

function USERDevice(Domain,IpAddr,HostName)
{
	this.Domain 	= Domain;
	this.IpAddr	    = IpAddr;
	this.HostName	= HostName;
}

var UserDevices = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecialGetUserDevInfo,InternetGatewayDevice.LANDevice.1.X_HW_UserDev.{i},IpAddr|HostName,USERDevice);%>;
var UserDevicesnum = UserDevices.length - 1;

for (var i = 0, j = 1; i < UserDevicesnum; i++)
{
	if ('' != UserDevices[i].HostName)
	{
  	LANhostName[j] = UserDevices[i].HostName;
  	LANhostIP[j] = UserDevices[i].IpAddr;
  	j++;
  }
}

function DMZHostNameChange()
{
	setText('DMZ_text',LANhostIP[getSelectVal('DMZHostName')]);
}


function stWanInfo(domain,Name,Enable,NATEnabled,ConnectionType,ServiceList, ExServiceList, vlanid,connectionstatus,Tr069Flag,MacId,IPv4Enable)
{
	this.domain = domain; 	
	this.Name = Name;
	this.Enable = Enable;
	this.NATEnabled = NATEnabled;
	this.Mode = ConnectionType;
	this.ServiceList = (ExServiceList.length == 0)?ServiceList.toUpperCase():ExServiceList.toUpperCase();
	this.VlanId = vlanid;
	this.connectionstatus = connectionstatus;
	this.Tr069Flag = Tr069Flag;
	this.MacId     = MacId;
	this.IPv4Enable = IPv4Enable;
	this.DMZ_Array = new Array(null);
}

var IpDmzInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i}.X_HW_DMZ,DMZEnable|DMZHostIPAddress,stDMZInfo);%>;
var PppDmzInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i}.X_HW_DMZ,DMZEnable|DMZHostIPAddress,stDMZInfo);%>;

function filterWan(WanItem)
{
	if (!(WanItem.Tr069Flag == '0' && (IsWanHidden(domainTowanname(WanItem.domain)) == false)))
	{
		return false;	
	}
	
	return true;
}

var AllWanInfoTemp = GetWanListByFilter(filterWan);
var AllWanInfo = new Array();

for (var i = 0; i < AllWanInfoTemp.length; i++)
{
	AllWanInfo[i] = new stWanInfo("","","","","","","","","","","","");
	AllWanInfo[i].domain = AllWanInfoTemp[i].domain;
	AllWanInfo[i].Name = AllWanInfoTemp[i].Name;
	AllWanInfo[i].Enable = AllWanInfoTemp[i].Enable;
	AllWanInfo[i].NATEnabled = AllWanInfoTemp[i].NATEnabled;
	AllWanInfo[i].Mode = AllWanInfoTemp[i].Mode;
	AllWanInfo[i].ServiceList = AllWanInfoTemp[i].ServiceList;
	AllWanInfo[i].VlanId = AllWanInfoTemp[i].VlanId;
	AllWanInfo[i].connectionstatus = AllWanInfoTemp[i].connectionstatus;
	AllWanInfo[i].Tr069Flag = AllWanInfoTemp[i].Tr069Flag;
	AllWanInfo[i].MacId = AllWanInfoTemp[i].MacId;
	AllWanInfo[i].IPv4Enable = AllWanInfoTemp[i].IPv4Enable;
	AllWanInfo[i].DMZ_Array = new Array(null);
}

function FindWanInfoByDmz(DmzItem)
{
	var wandomain_len = 0;
	var temp_domain = null;
	
	for(var k = 0; k < AllWanInfo.length; k++ )
	{
		wandomain_len = AllWanInfo[k].domain.length;
		temp_domain = DmzItem.domain.substr(0, wandomain_len);
		
		if (temp_domain == AllWanInfo[k].domain)
		{
			return AllWanInfo[k];
		}
	}
}

var DmzInfo = new Array();
var Idx = 0;
for (i = 0; i < IpDmzInfo.length-1; i++)
{
    var tmpWan = FindWanInfoByDmz(IpDmzInfo[i]);
	
	if (tmpWan.ServiceList != 'TR069'
       && tmpWan.ServiceList != 'VOIP'
       && tmpWan.ServiceList != 'TR069_VOIP'
       && tmpWan.Mode == 'IP_Routed')
	{
   		DmzInfo[Idx] = IpDmzInfo[i];
		Idx ++;
	}
}
for (j = 0; j < PppDmzInfo.length-1; j++,i++)
{
	var tmpWan = FindWanInfoByDmz(PppDmzInfo[j]);   

    if (tmpWan.ServiceList != 'TR069'
		&& tmpWan.ServiceList != 'VOIP'
		&& tmpWan.ServiceList != 'TR069_VOIP'
		&& tmpWan.Mode == 'IP_Routed')
	{
   		DmzInfo[Idx] = PppDmzInfo[j];
		Idx ++;
	}
}

var WanInfo = new Array();

InitWanDmzInfo();

function InitWanDmzInfo()
{
	var WanIPInfo_len = 0;	
	var temp_domain = null;
	var k = 0;
	
	for (i = 0; i < DmzInfo.length; i++)
	{
		for (j = 0; j < AllWanInfo.length; j++)
		{
			WanIPInfo_len = AllWanInfo[j].domain.length;
			temp_domain = DmzInfo[i].domain.substr(0, WanIPInfo_len);
			if (temp_domain == AllWanInfo[j].domain)
			{
				WanInfo[k] = AllWanInfo[j];
				WanInfo[k].DMZ_Array[0] = DmzInfo[i];
				WanInfo[k].DMZ_Array[1] = null;
				k++;
				break;
			}
		}
	}
}

function getFirstInternetWanIndex()
{
	var idx = -1;
	var HU='<%HW_WEB_GetFeatureSupport(BBSP_FT_HU);%>';
	for (i = 0; i < AllWanInfo.length; i++)
	{ 
		if (AllWanInfo[i].ServiceList != 'TR069'
			&& AllWanInfo[i].ServiceList != 'VOIP'
			&& AllWanInfo[i].ServiceList != 'TR069_VOIP'
			&& AllWanInfo[i].Mode == 'IP_Routed'
			&& AllWanInfo[i].IPv4Enable == '1')
		{
	
			if((HU==1) && (curUserType != sysUserType) && ((AllWanInfo[i].ServiceList == 'IPTV') || (AllWanInfo[i].ServiceList == 'OTHER')))
			{
				continue;
			}
			else
			{
				if (-1 != AllWanInfo[i].ServiceList.toUpperCase().indexOf("INTERNET"))
				{
					idx = i;
					return idx;
				}
			}
		}
	}	   
    return idx;                          
}

function getDmzAddFlag(WanItem)
{
	if (DmzInfo.length > 0)
	{
		for (var i = 0; i < DmzInfo.length; i++)
		{
			var tmpWan = FindWanInfoByDmz(DmzInfo[i]);
			if (WanItem.domain == tmpWan.domain)
			{
				if ("" == DmzInfo[i].DMZHostIPAddress)
				{
					DmzAddFlag = true;
				}
				else
				{
					DmzAddFlag = false;
				}
			}
		}
	}
	else
	{
		DmzAddFlag = true;
	}
}

function AddSubmitParam(SubmitForm,type)
{
	var index = getFirstInternetWanIndex();
	var url;
	if(DmzAddFlag == false && getValue('DMZ_text') == "")
	{
		var urlValue = AllWanInfo[index].domain + '.X_HW_DMZ';
		SubmitForm.addParameter(urlValue,'');
		url = 'del.cgi?RequestFile=html/bbsp/dmz/dmze8c.asp';
	}
	else
	{
		SubmitForm.addParameter('x.DMZEnable',1);
		SubmitForm.addParameter('x.DMZHostIPAddress',getValue('DMZ_text'));
		
		if(DmzAddFlag == true)
		{
			url = 'add.cgi?x=' + AllWanInfo[index].domain + '.X_HW_DMZ'
							   + '&RequestFile=html/bbsp/dmz/dmze8c.asp'
		}
		else
		{
			url = 'set.cgi?x=' + AllWanInfo[index].domain + '.X_HW_DMZ'
							   + '&RequestFile=html/bbsp/dmz/dmze8c.asp'
		}
	}
	SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
	SubmitForm.setAction(url);
}


function CheckForm(type)
{
    return CheckDMZ();
}

function CheckDMZ()
{
    var Interface = getElement('DMZInterface');
	var optionID = 0;
	var index = -1;

	index = getFirstInternetWanIndex();
	if (-1 == index)
	{
		 AlertEx("请先创建一个上网WAN");
		 return false;
	}

	if ( AllWanInfo[index].NATEnabled < 1 )
	{
	     AlertEx(dmz_language['bbsp_natof'] + MakeWanName1(AllWanInfo[index]) + dmz_language['bbsp_disable']);
         return false;
	}
	
	getDmzAddFlag(AllWanInfo[index]);
    with (getElement('dmzForm')) 
	{
		if (getElement('DMZ_text').value == '' && DmzAddFlag == true)
		{
			AlertEx(dmz_language['bbsp_dmzisreq']);
			return false;
		}

		if (isAbcIpAddress(getElement('DMZ_text').value) == false && getElement('DMZ_text').value != "") 
		{
			AlertEx(dmz_language['bbsp_dmzinvalid']);
			return false;
		}
		
		if(DmzAddFlag == true)
		{
			for(i = 0; i < WanInfo.length; i++)
			{
				if(WanInfo[i].Name == AllWanInfo[index].Name)
				{
					AlertEx(dmz_language['bbsp_interface'] + MakeWanName1(WanInfo[i]) + dmz_language['bbsp_dmzrepeat']);
					return false;
				}
			}
		}
	}
   setDisable('SaveApply_button', 1);
   return true;
}

function setDMZHostIPAddressDisplay()
{
	var index =  getFirstInternetWanIndex();
	if (-1 == index)
	{
		setText('DMZ_text','');
	}
	else
	{
		for (var i = 0; i < DmzInfo.length; i++)
		{
			var tmpWan = FindWanInfoByDmz(DmzInfo[i]);
			if (AllWanInfo[index].domain == tmpWan.domain)
			{
				if ("" == DmzInfo[i].DMZHostIPAddress)
				{
					setText('DMZ_text','');
				}
				else
				{
					setText('DMZ_text',DmzInfo[i].DMZHostIPAddress);
				}
			}
		}
	}
}


function LoadFrame()
{
	loadlanguage();
	setDMZHostIPAddressDisplay();
}

var selctIndex = -1;

function selectRemoveCnt(obj) 
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
	document.write('<DIV style="overflow-x:auto; overflow-y:auto; WIDTH: 100%; HEIGHT: 460px">');
}
</script>
<body onLoad="LoadFrame();" class="mainbody"> 
<table width="100%" border="0" cellpadding="0" cellspacing="0" id="tabTest" > 
  <tr> 
    <td class="prompt"> <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
        <tr> 
          <td class="title_common" BindText='bbsp_dmz_title1'>  </td> 
        </tr> 
      </table></td> 
  </tr> 
  <tr> 
    <td class="height5p"></td> 
  </tr> 
</table> 

<div id="ConfigForm"> 
  <table cellpadding="0" cellspacing="0" width="100%" > 
    <tr> 
      <td> <div name="dmzForm" id="dmzForm"> 
          <table width="100%" cellpadding="2" cellspacing="1"> 
            <tr> 
			  <td class="table_title" BindText='bbsp_hostaddrmh1' width="20%"></td> 
			  <td class="table_right" width="50%"> <input id="DMZ_text" type='text' name='DMZ_text' maxlength='15' size='15'> 
				<font color="red">*</font>
			 </td>
			 <td class="table_right" width="30%"></td>
			</tr> 
			<tr> 
			<td class="height20p"></td> 
		  </tr> 
          </table> 
        </div></td> 
    </tr> 
  </table> 
  <table width="100%"  class="table_button"> 
    <tr align="right">
      <td> 
	  	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	  	<button id="SaveApply_button" name="SaveApply_button" type="button" class="submit" onClick="Submit(2);"><script>document.write(dmz_language['bbsp_saveApply']);</script></button> 
	</td> 
    </tr> 
  </table> 
</div> 
</body>
</html>
