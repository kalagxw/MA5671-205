<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>

<title>dnsconfig</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="javascript" src="../common/userinfo.asp"></script>
<script language="javascript" src="../common/topoinfo.asp"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<script language="javascript" src="../common/lanmodelist.asp"></script>
<script language="javascript" src="../common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="javascript" src="../common/dnshostslist.asp"></script>
<script language="JavaScript" src="<%HW_WEB_GetReloadCus(html/bbsp/dnsconfiguration/dnssearchlist.cus);%>"></script>
<script language="JavaScript" src="<%HW_WEB_GetReloadCus(html/bbsp/dnsconfiguration/dnshosts.cus);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<style>
.InputDns{
	width: 311px;
}
</style>
<script language="JavaScript" type="text/javascript">
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
		b.innerHTML = dnscfg_language[b.getAttribute("BindText")];
	}
}

function DnsSearchListItemClass(domain, DNSServer, DomainName, Interface)
{
	this.domain     = domain;
	this.DNSServer  = DNSServer;
	this.DomainName = DomainName;
	this.Interface  = Interface;
}

var curUserType='<%HW_WEB_GetUserType();%>';
var DSLTableName = "DSLConfigList";

var DNS_NULL_INTERFACE_NAME="";
var DnsSearchListTemp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DNS.SearList.{i},DNSServer|DomainName|Interface,DnsSearchListItemClass);%>;  
var DnsSearchList = new Array();
var Count = 0;
var DSLselctIndex = -1;	

var sysUserType = '0';
var SonFlag = '<%HW_WEB_GetFeatureSupport(BBSP_FT_SONET);%>'; 
var DHTableName = "DnsHostConfigList";
var DHselctIndex = -1;
var DnsHostsList = GetDnsHostsList();

for (var i = 0; i < DnsSearchListTemp.length-1; i++)
{
	 DnsSearchList[Count++] = DnsSearchListTemp[i];
}

function GetDnsSearchList()
{
	return DnsSearchList;
}

function DSLBindPageData(DnsSearchListInfo)
{    
	setText("DSLdomain", DnsSearchListInfo.domain);
	setText("DNSServer", DnsSearchListInfo.DNSServer); 
	setText("DSLDomainName", DnsSearchListInfo.DomainName);  	
	
	if('' != DnsSearchListInfo.Interface) 
	{
		setSelect("WanNameList", DnsSearchListInfo.Interface);
	}
	else
	{ 
		setSelect("WanNameList", DNS_NULL_INTERFACE_NAME);	
	}
}		

function GetDnsSearchListData()
{
	var CurrentDomain = (DnsSearchList[DSLselctIndex] != null)?DnsSearchList[DSLselctIndex].domain:"";
	return new DnsSearchListItemClass(CurrentDomain, getValue("DNSServer"), getValue("DSLDomainName"), getValue("WanNameList"));
}

function DSLCheckIpv6Adress(DnsSearchListItem)
{
	if (DnsSearchListItem.DNSServer != '' )
	{
		if ( IsIPv6AddressValid(DnsSearchListItem.DNSServer) == false)
		{
			AlertEx(dnscfg_language['bbsp_ipx']+ DnsSearchListItem.DNSServer + dnscfg_language['bbsp_invalid']);
			return false;
		}
		
		if (parseInt(DnsSearchListItem.DNSServer.split(":")[0], 16) >= parseInt("0xFF00", 16))
		{
			AlertEx(dnscfg_language['bbsp_ipx']+ DnsSearchListItem.DNSServer + dnscfg_language['bbsp_invalid']);
			return false;   
		} 

		if (IsIPv6ZeroAddress(DnsSearchListItem.DNSServer) == true)
		{
		   AlertEx(dnscfg_language['bbsp_ipx']+ DnsSearchListItem.DNSServer + dnscfg_language['bbsp_invalid']);
		   return false;  
		}

		if (IsIPv6LoopBackAddress(DnsSearchListItem.DNSServer) == true)
		{
			AlertEx(dnscfg_language['bbsp_ipx']+ DnsSearchListItem.DNSServer + dnscfg_language['bbsp_invalid']);
			return false;    
		}

		if (DnsSearchListItem.DNSServer.toUpperCase().substr(0, 4) == "FE80" || DnsSearchListItem.DNSServer.toUpperCase().substr(0, 4) == "FEC0" )
		{
			AlertEx(dnscfg_language['bbsp_ipx']+ DnsSearchListItem.DNSServer + dnscfg_language['bbsp_invalid']);
			return false;    
		} 			
		
	}   
	return true;
}

function DSLCheckItemRepeat(DnsSearchListItem)
{							
	var Dns_Search_List = GetDnsSearchList();
	var RecordCount = Dns_Search_List.length;
	var i = 0;
				
	 for(i=0;i<RecordCount;i++)
	 {
			if (DSLselctIndex != i)
			{
				if(DnsSearchListItem.Interface == DNS_NULL_INTERFACE_NAME)
				{
			    if((DnsSearchListItem.DomainName==Dns_Search_List[i].DomainName) 
             && ('' != Dns_Search_List[i].Interface ))
			    {
				    return true;	
			    }	
			    if ((DnsSearchListItem.DomainName==Dns_Search_List[i].DomainName) 
	           && (DnsSearchListItem.DNSServer==Dns_Search_List[i].DNSServer)
	           && ('' == Dns_Search_List[i].Interface ))	
	        {
	        	return true;	
	        }		
			  }else
			  {
			  	if((DnsSearchListItem.DomainName==Dns_Search_List[i].DomainName))
			    {
				    return true;	
			    }
			  }
		  }
		}
	
	return false;	
	
}

function DSLCheckParameter(DnsSearchListItem)
{ 
	if(DnsSearchListItem.DomainName == '' )
	{
		AlertEx(dnscfg_language['bbsp_domainisreq']);
		return false;
	}

		if(DnsSearchListItem.DNSServer == '' && DnsSearchListItem.Interface == DNS_NULL_INTERFACE_NAME)
	{
		AlertEx(dnscfg_language['bbsp_dnsisreq']);
		return false;
	}  
	if ( DnsSearchListItem.DNSServer != '' && (isValidIpAddress(DnsSearchListItem.DNSServer) == false || isAbcIpAddress(DnsSearchListItem.DNSServer) == false))
	{
			if(DSLCheckIpv6Adress(DnsSearchListItem) == false)
			{
				return false;
			}
	}      
			
	if(CheckDomainName(DnsSearchListItem.DomainName)==false)
	{
			AlertEx(dnscfg_language['bbsp_domaint'] + dnscfg_language['bbsp_invalidx']);
			return false;
	}   	
		
	return true;        
}
    
function clickRemove() 
{
	return OnRemoveButtonClick();
}
	
function setControl(Index, LineId)
{
	var TableId = LineId.split('_')[0];
	if (DSLTableName == TableId)
	{
		DSLselctIndex = Index;
		if (Index < -1)
		{
			return;
		}
		if (Index == -1)
		{
			SetAddMode();
			if (GetDnsSearchList().length >= 32)
			{
				AlertEx(dnscfg_language['bbsp_dnscfgfull']);
				DSLOnCancelButtonClick();
				return false;
			}
			return DSLOnAddButtonClick();  
		}
		else
		{   
			SetEditMode();
			return DSLOnEditButtonClick(Index);
		}
	}
	else if (DHTableName == TableId)
	{
		DHselctIndex = Index;
        if (Index < -1)
        {
            return;
        }
        if (Index == -1)
        {
            SetAddMode();
            if (GetDnsHostsList().length >= 20)
            {
                AlertEx(dnscfg_language['bbsp_sdnsfull']);
                DSLOnCancelButtonClick();
                return false;
            }
            return OnAddButtonClick();  
        }
        else
        {   
            SetEditMode();
            return OnEditButtonClick(Index);
        }
	}
	
}
	
function DSLOnAddButtonClick()
{
	DSLBindPageData(new DnsSearchListItemClass("","","",""));
	setDisplay("DSLTableConfigInfo", 1);
	return false;   
}

function DSLOnEditButtonClick(Index)
{	 
	DSLBindPageData(GetDnsSearchList()[Index]);
	setDisplay("DSLTableConfigInfo", 1);
	return false;           
}  

function DSLConfigListselectRemoveCnt(val)
{

}
function OnDeleteButtonClick(TableID)
{      
	var TableId = TableID.split('_')[0];  
	if (DSLTableName == TableId)
	{
		var CheckBoxList = document.getElementsByName(DSLTableName+"rml");
		var Form = new webSubmitForm();
		var Count = 0;
		
		var str = "";
		var Onttoken = getValue('onttoken');
		for (var i = 0; i < CheckBoxList.length; i++)
		{
			if (CheckBoxList[i].checked != true)
			{
				continue;
			}
			
			Count++;
			if (Count > 1)
			{
				str +='&';
			}
			str += CheckBoxList[i].value + '=' + '';
		}
		str += '&x.X_HW_Token=' + Onttoken;
		if (Count <= 0)
		{
			return false;
		}
		var action = '';
		action = 'del.cgi?' +'x=InternetGatewayDevice.X_HW_DNS.SearList';
		
		$.ajax({
			type : "POST",
			async : false,
			cache : false,
			data : str,
			url :  action + '&RequestFile=html/ipv6/not_find_file.asp',
			error:function(XMLHttpRequest, textStatus, errorThrown) 
			{
				if(XMLHttpRequest.status == 404)
				{
				}
			}
		});	
		
		window.location.href='/html/bbsp/dnsconfiguration/dnsconfig.asp';     
		return false;       
	}
	else if (DHTableName == TableId)
	{
		var CheckBoxList = document.getElementsByName(DHTableName+"rml");
        var Form = new webSubmitForm();
        var Count = 0;
		
		var str = "";
		var Onttoken = getValue('onttoken');
		for (var i = 0; i < CheckBoxList.length; i++)
		{
		    if (CheckBoxList[i].checked != true)
            {
                continue;
            }
            
            Count++;
			if (Count > 1)
			{
				str +='&';
			}
			str += CheckBoxList[i].value + '=' + '';
		}
		str += '&x.X_HW_Token=' + Onttoken;
        if (Count <= 0)
        {
            return false;
        }
		var action = '';
		action = 'del.cgi?' +'x=InternetGatewayDevice.X_HW_DNS.HOSTS';
		
		$.ajax({
			type : "POST",
			async : false,
			cache : false,
			data : str,
			url :  action + '&RequestFile=html/ipv6/not_find_file.asp',
			error:function(XMLHttpRequest, textStatus, errorThrown) 
			{
				if(XMLHttpRequest.status == 404)
				{
				}
			}
		});	
		
		window.location.href='/html/bbsp/dnsconfiguration/dnsconfig.asp';     
        return false;        
	}
	 
}

function DSLOnApplyButtonClick()
{ 	
	var DnsSearchListItem = GetDnsSearchListData();
  
	if (DSLCheckParameter(DnsSearchListItem) == false)
	{
		return false;
	}
	
	if (DSLCheckItemRepeat(DnsSearchListItem) == true)
	{
		AlertEx(dnscfg_language['bbsp_dnscfgrepeat']);
		return true;
	}   
	
	var interface = '';
	if(DnsSearchListItem.Interface != DNS_NULL_INTERFACE_NAME) 
	{ 
		 interface = DnsSearchListItem.Interface;
	}

	var tokenvalue = getValue('onttoken');
	var action = '';
	if( DSLselctIndex == -1 )
	{
		action = 'add.cgi?' +'x=InternetGatewayDevice.X_HW_DNS.SearList';
	}
	else
	{
		action = 'set.cgi?' +'x='+DnsSearchListItem.domain;
	}
	
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		data : 'x.DNSServer=' + DnsSearchListItem.DNSServer + '&x.DomainName=' + DnsSearchListItem.DomainName + '&x.Interface=' + interface + '&x.X_HW_Token=' + tokenvalue,
		url :  action + '&RequestFile=html/ipv6/not_find_file.asp',
		error:function(XMLHttpRequest, textStatus, errorThrown) 
		{
			if(XMLHttpRequest.status == 404)
			{
			}
		}
	});	
	
	window.location.href='/html/bbsp/dnsconfiguration/dnsconfig.asp';    
	setDisable("policybtnApply",1);
	setDisable("policycancelValue",1); 
	return false;
}

function DSLOnCancelButtonClick()
{
	var tableRow = getElementById(DSLTableName);
	if ((tableRow.rows.length > 2) && IsAddMode())
	{
		
		tableRow.deleteRow(tableRow.rows.length-1);
	}
	setDisplay("DSLTableConfigInfo", 0);
	return false;

}
	
function InitDSLTableList()
{
	for (var i = 0; i < DSLTableDataInfo.length - 1; i++)
	{
		DSLTableDataInfo[i].Interface =  GetWanFullName(DSLTableDataInfo[i].Interface);
	}
}

function BindPageData(DnsHostsInfo)
{    
	setText("domain", DnsHostsInfo.domain);
	setText("IPAddress", DnsHostsInfo.IPAddress); 
	setText("DomainName", DnsHostsInfo.DomainName);  	
}


function GetDnsHostsData()
{
	var CurrentDomain = (GetDnsHostsList()[DHselctIndex] != null)?GetDnsHostsList()[DHselctIndex].domain:"";
	return new DnsHostsItemClass(CurrentDomain,getValue("IPAddress"), getValue("DomainName"));
}
	
function CheckIpv6Adress(DnsHostsItem)
{
	 if (DnsHostsItem.IPAddress != '' )
	{
		if ( IsIPv6AddressValid(DnsHostsItem.IPAddress) == false)
		{
			return false;
		}
		
		if (parseInt(DnsHostsItem.IPAddress.split(":")[0], 16) >= parseInt("0xFF00", 16))
		{
			return false;   
		} 

		if (IsIPv6ZeroAddress(DnsHostsItem.IPAddress) == true)
		{
		   return false;  
		}

		if (IsIPv6LoopBackAddress(DnsHostsItem.IPAddress) == true)
		{
			return false;    
		}

		if (DnsHostsItem.IPAddress.toUpperCase().substr(0, 4) == "FE80" || DnsHostsItem.IPAddress.toUpperCase().substr(0, 4) == "FEC0" )
		{
			return false;    
		} 			
		
	}   
	return true;
}

function CheckItemRepeat(DnsHostsItem)
{		
  	if( (DnsHostsItem.DomainName != '')&&(DnsHostsItem.IPAddress != ''))
	{					
	    var Dns_Host_List = GetDnsHostsList();
        var RecordCount = Dns_Host_List.length;
        var i = 0;
						
		for(i=0;i<RecordCount;i++)
		{
			if (DHselctIndex != i)
			{
				if((DnsHostsItem.DomainName==Dns_Host_List[i].DomainName) &&(DnsHostsItem.IPAddress==Dns_Host_List[i].IPAddress))
				{
					return true;	
				}				
			}
		}
	}
	
	return false;	
}

function CheckParameter(DnsHostsItem)
{   
	if(DnsHostsItem.DomainName == '' )
	{
		AlertEx(dnscfg_language['bbsp_domainisreq']);
		return false;
	}

	if(DnsHostsItem.IPAddress == '' )
	{
		AlertEx(dnscfg_language['bbsp_ipisreq']);
		return false;
	}

	if ( DnsHostsItem.IPAddress != '' && (isValidIpAddress(DnsHostsItem.IPAddress) == false || isAbcIpAddress(DnsHostsItem.IPAddress) == false))
	{
			if(CheckIpv6Adress(DnsHostsItem) == false)
			{
				AlertEx(dnscfg_language['bbsp_ipx']+ DnsHostsItem.IPAddress + dnscfg_language['bbsp_invalid']);
				return false;
			}
	}       
					
	if(CheckDomainName(DnsHostsItem.DomainName)==false)
	{
		AlertEx(dnscfg_language['bbsp_domainx']+ DnsHostsItem.DomainName + dnscfg_language['bbsp_invalid']);
		return false;
	}   

	for (i = 0; i < GetDnsHostsList().length; i++)
	{	
		if (DHselctIndex != i)
		{
			if (DnsHostsListTemp[i].DomainName.toUpperCase() == DnsHostsItem.DomainName.toUpperCase() &&  DnsHostsItem.IPAddress != '' &&  DnsHostsListTemp[i].IPAddress != '' )
			{
				if((isAbcIpAddress(DnsHostsItem.IPAddress) == true &&  isAbcIpAddress(DnsHostsListTemp[i].IPAddress) == true)
				|| (CheckIpv6Adress(DnsHostsItem) == true &&  CheckIpv6Adress(DnsHostsListTemp[i]) == true))
				{
					AlertEx(dnscfg_language['bbsp_domainrepeat']);
					return false;
				}
			}
		}
		else
		{
			continue;
		}
	}
	return true;        
}

function OnAddButtonClick()
{
	
	BindPageData(new DnsHostsItemClass("","",""));
	setDisplay("TableConfigInfo", "1");
	return ;   
}


function OnEditButtonClick(Index)
{	    
	BindPageData(GetDnsHostsList()[Index]);
	setDisplay("TableConfigInfo", "1");
	return ;           
}

function DnsHostConfigListselectRemoveCnt(val)
{

}  

function OnApplyButtonClick()
{ 	
	var url = '';
	var DnsHostsItem = GetDnsHostsData();
  
	if (CheckParameter(DnsHostsItem) == false)
	{
		return false;
	}
	
	if (CheckItemRepeat(DnsHostsItem) == true)
	{
		AlertEx(dnscfg_language['bbsp_sdnsrepeat']);
		return true;
	}   
	var tokenvalue = getValue('onttoken');
	
	var action = '';
	if( DHselctIndex == -1 )
	{
		action = 'add.cgi?' +'x=InternetGatewayDevice.X_HW_DNS.HOSTS';
	}
	else
	{
		action = 'set.cgi?' +'x='+DnsHostsItem.domain;
	}
	
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		data : 'x.IPAddress=' + DnsHostsItem.IPAddress + '&x.DomainName=' + DnsHostsItem.DomainName + '&x.X_HW_Token=' + tokenvalue,
		url :  action + '&RequestFile=html/ipv6/not_find_file.asp',
		error:function(XMLHttpRequest, textStatus, errorThrown) 
		{
			if(XMLHttpRequest.status == 404)
			{
			}
		}
	});	
	
	window.location.href='/html/bbsp/dnsconfiguration/dnsconfig.asp';  
	setDisable("policybtnApply",1);
	setDisable("policycancelValue",1);   
	return false;
}

function OnCancelButtonClick()
{
	if (GetDnsHostsList().length > 0 && IsAddMode())
	{
		var tableRow = getElementById(DHTableName);
		tableRow.deleteRow(tableRow.rows.length-1);
	}
	setDisplay("TableConfigInfo", "0");
	return false;
}

function LoadFrame()
{
	loadlanguage();	
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("dnssearchlisttitleinfo", GetDescFormArrayById(dnscfg_language, "bbsp_mune"), GetDescFormArrayById(dnspolicy_language, "bbsp_dnssearchlist_title"), false);
</script>
<div class="title_spread"></div>

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="func_title"> 
<tr><td BindText="bbsp_dns_search_titlehead"></td></tr></table> 
<script language="JavaScript" type="text/javascript">
	var DSLTableClass = new stTableClass("width_per15", "width_per85", "ltr");
	var DSLConfiglistInfo = new Array(new stTableTileInfo("Empty","align_center width_per5","DomainBox"),									
								new stTableTileInfo("bbsp_domain","align_center width_per40","DomainName",false,30),
								new stTableTileInfo("bbsp_waninterface","align_center width_per30","Interface"),
								new stTableTileInfo("bbsp_dnssvr","align_center width_per30","DNSServer"),null);
	var DSLColumnNum = 4;
	var DSLShowButtonFlag = true;
	var DSLTableConfigInfoList = new Array();
	var DSLTableDataInfo = HWcloneObject(DnsSearchList, 1);
	DSLTableDataInfo.push(null);
	InitDSLTableList();
	HWShowTableListByType(1, DSLTableName, DSLShowButtonFlag, DSLColumnNum, DSLTableDataInfo, DSLConfiglistInfo, dnscfg_language, null);
</script>

<form id="DSLTableConfigInfo" style="display:none;"> 
<div class="list_table_spread"></div>
	<table border="0" cellpadding="0" cellspacing="1"  width="100%">
		<li   id="DSLdomain"        RealType="TextBox"          DescRef="Instance"         RemarkRef=""     ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.domain"      InitValue="Empty" MaxLength="255"/>
		<li   id="DSLDomainName"    RealType="TextBox"          DescRef="bbsp_domainmh"         RemarkRef=""     ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.DomainName"     Elementclass="InputDns"  InitValue="Empty" MaxLength="255"/>
		<li   id="WanNameList"   RealType="DropDownList"     DescRef="bbsp_waninterfacemh"      RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.Interface"    Elementclass="InputDns"  InitValue="Empty"/>
		<li   id="DNSServer"     RealType="TextBox"          DescRef="bbsp_dnssvrmh"         RemarkRef=""     ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.DNSServer"     Elementclass="InputDns"  InitValue="Empty" MaxLength="39"/>
	</table>
	<script language="JavaScript" type="text/javascript">
	DSLConfigFormList = HWGetLiIdListByForm("DSLTableConfigInfo", DnsSearchListReload);
	HWParsePageControlByID("DSLTableConfigInfo", DSLTableClass, dnscfg_language, DnsSearchListReload);
	function IsRouteWan(Wan)
	{
		if (Wan.Mode =="IP_Routed")
		{
			return true;
		} 
		return false;
	}
	InitWanNameListControl("WanNameList", IsRouteWan);
	</script>

	<table id="ConfigPanelButtons" width="100%" cellspacing="1" class="table_button">
		<tr>
			<td width="15%">
			</td>
			<td class="table_submit pad_left5p" >
				<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
				<button id="DSLButtonApply"  type="button" onclick="DSLOnApplyButtonClick();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(dnscfg_language['bbsp_app']);</script></button>
				<button id="DSLButtonCancel" type="button" onclick="DSLOnCancelButtonClick();" class="CancleButtonCss buttonwidth_100px"><script>document.write(dnscfg_language['bbsp_cancel']);</script></button>
			</td>
		</tr>
	</table>
</form> 
<div class="func_spread"></div>

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="func_title"> 
<tr><td BindText="bbsp_dns_host_titlehead"></td></tr></table> 
<script language="JavaScript" type="text/javascript">
	TableClass = new stTableClass("width_per15", "width_per85", "ltr");
	var DnsHostConfiglistInfo = new Array(new stTableTileInfo("Empty","align_center width_per5","DomainBox"),									
									new stTableTileInfo("bbsp_domain","align_center width_per60","DomainName",false,50),
									new stTableTileInfo("bbsp_ip","align_center width_per40","IPAddress"),null);
									
	var ColumnNum = 3;
	var ShowButtonFlag = true;
	var DnsHostTableConfigInfoList = new Array();
	var TableDataInfo = HWcloneObject(DnsHostsList, 1);
	TableDataInfo.push(null);
	HWShowTableListByType(1, DHTableName, ShowButtonFlag, ColumnNum, TableDataInfo, DnsHostConfiglistInfo, dnscfg_language, null);
</script>

<form id="TableConfigInfo" style="display:none"> 
 <div class="list_table_spread"></div>
	<table border="0" cellpadding="0" cellspacing="1"  width="100%"> 
		<li   id="domain"        RealType="TextBox"          DescRef="Instance"         RemarkRef=""     ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.domain"      InitValue="Empty" MaxLength="255" datatype="int" minvalue="0" maxvalue="253" default="0" />
		<li   id="DomainName"    RealType="TextBox"          DescRef="bbsp_domainmh"         RemarkRef=""     ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.DomainName"     Elementclass="InputDns"  InitValue="Empty" MaxLength="255"/>
		<li   id="IPAddress"     RealType="TextBox"          DescRef="bbsp_ipmh"         RemarkRef=""     ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.IPAddress"   Elementclass="InputDns"    InitValue="Empty" MaxLength="39"/>
	</table>
	<script language="JavaScript" type="text/javascript">
		DnsHostConfigFormList = HWGetLiIdListByForm("TableConfigInfo", DnsHostReload);
		HWParsePageControlByID("TableConfigInfo", TableClass, dnscfg_language, DnsHostReload);
	</script>
	<table id="ConfigPanelButtons" width="100%" cellspacing="1" class="table_button">
		<tr>
			<td class="width_per15">
			</td>
			<td class="table_submit pad_left5p" >
				<button id="ButtonApply"  type="button" onclick="OnApplyButtonClick();" class="ApplyButtoncss buttonwidth_100px" ><script>document.write(dnscfg_language['bbsp_app']);</script></button>
				<button id="ButtonCancel" type="button" onclick="OnCancelButtonClick();" class="CancleButtonCss buttonwidth_100px" ><script>document.write(dnscfg_language['bbsp_cancel']);</script></button>
			</td>
		</tr>
	</table>
</form>
<div class="func_spread"></div>

</body>
</html>
