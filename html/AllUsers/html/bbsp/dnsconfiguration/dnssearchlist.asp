<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  id="Page" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>

<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
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
<script language="JavaScript" src="<%HW_WEB_GetReloadCus(html/bbsp/dnsconfiguration/dnssearchlist.cus);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<style>
.InputDns{
	width: 311px;
}
</style>
	<script>
	var para = "";
	var isshowtitle = "";
	if( window.location.href.indexOf("?") > 0)
	{
		if (window.location.href.indexOf("Title") != -1)
		{
		para = window.location.href.split("?"); 
		para = para[para.length -1];
		isshowtitle = para.split("=")[1];
		}
	}
	
	var TableName = "DSLConfigList";
	
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

   
	var DNS_NULL_INTERFACE_NAME="";
	var DnsSearchListTemp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DNS.SearList.{i},DNSServer|DomainName|Interface,DnsSearchListItemClass);%>;  
	var DnsSearchList = new Array();
	
	var Count = 0;
	
	for (var i = 0; i < DnsSearchListTemp.length-1; i++)
	{
		 DnsSearchList[Count++] = DnsSearchListTemp[i];
	}
    
	function GetDnsSearchList()
	{
		return DnsSearchList;
	}		
		
	var selctIndex = -1;	
	
    function CreateDnsSearchList()
    {      
	    var Dns_Search_List = GetDnsSearchList();
		var HtmlCode = "";
        var DataGrid = getElById("DataGrid");
        var RecordCount = Dns_Search_List.length;
        var i = 0;
		
        if (RecordCount == 0)
        {
            HtmlCode += '<TR id="record_no" class="tabal_01" onclick="selectLine(this.id);">';
            HtmlCode += '<TD align="center">--</TD>';
            HtmlCode += '<TD align="center">--</TD>';
            HtmlCode += '<TD align="center">--</TD>';
            HtmlCode += '<TD align="center">--</TD>';
    	    HtmlCode += '</TR>';
    	    return HtmlCode;
        }
		
        for (i = 0; i < RecordCount; i++)
        {
    	    HtmlCode += '<TR id="record_' + i + '" class="tabal_center01"  onclick="selectLine(this.id);">';
            HtmlCode += '<TD>' + '<input type="checkbox" name="rml"'  + ' value=' + Dns_Search_List[i].domain  + '>' + '</TD>';
			HtmlCode +=  '<TD id = \"RecordDomainName' +i + '\" title=\"' + ShowNewRow(Dns_Search_List[i].DomainName) +'\">' + GetStringContent(Dns_Search_List[i].DomainName, 50) + '</TD>';
            HtmlCode += '<TD id = \"RecordWanName'+i+'\">' + GetWanFullName(Dns_Search_List[i].Interface) + '</TD>';
			HtmlCode += '<TD id = \"RecordIPAddress'+i+'\">' + Dns_Search_List[i].DNSServer + '</TD>';
            HtmlCode += '</TR>';
        }
        
        return HtmlCode;

    }

    function BindPageData(DnsSearchListInfo)
    {    
        setText("domain", DnsSearchListInfo.domain);
     	setText("DNSServer", DnsSearchListInfo.DNSServer); 
        setText("DomainName", DnsSearchListInfo.DomainName);  	
        
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
		var CurrentDomain = (DnsSearchList[selctIndex] != null)?DnsSearchList[selctIndex].domain:"";
        return new DnsSearchListItemClass(CurrentDomain, getValue("DNSServer"), getValue("DomainName"), getValue("WanNameList"));
    }
	
	
	
    function OnPageLoad()
    {
		loadlanguage();
		adjustParentHeight();
        return true;
    }


    function CheckIpv6Adress(DnsSearchListItem)
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
	
function CheckItemRepeat(DnsSearchListItem)
{							
	var Dns_Search_List = GetDnsSearchList();
	var RecordCount = Dns_Search_List.length;
	var i = 0;
				
	 for(i=0;i<RecordCount;i++)
	 {
			if (selctIndex != i)
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


    function CheckParameter(DnsSearchListItem)
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
	    		if(CheckIpv6Adress(DnsSearchListItem) == false)
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
	
	function getHeight(id)
	{
		var item = id;
		if (item != null)
		{
			if (item.style.display == 'none')
			{
				//item invisible
				return 0;
			}
			if (typeof item.scrollHeight == 'number')
			{
				return item.scrollHeight;
			}
			return null;
		}
	
		return null;
	}

	function adjustParentHeight()
	{
		var dh = getHeight(document.getElementById(TableName));
		var dh1 = getHeight(document.getElementById("TableConfigInfo"));
		var height = 200+(dh > 0 ? dh : 0) + (dh1 > 0 ? dh1 : 0);
		if (undefined != window.parent.adjustParentHeight)
		{
			window.parent.adjustParentHeight("DnsSearchListFrameContent", height);
		}
		
	}
	
    function setControl(Index)
    {
        selctIndex = Index;
        if (Index < -1)
        {
			adjustParentHeight();
            return;
        }
        if (Index == -1)
        {
            SetAddMode();
            if (GetDnsSearchList().length >= 32)
            {
                AlertEx(dnscfg_language['bbsp_dnscfgfull']);
                OnCancelButtonClick();
				adjustParentHeight();
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
    

    function OnAddButtonClick()
    {
		
        BindPageData(new DnsSearchListItemClass("","","",""));
        setDisplay("TableConfigInfo", 1);
		adjustParentHeight();
        return false;   
    }
    

    function OnEditButtonClick(Index)
    {	 
        BindPageData(GetDnsSearchList()[Index]);
        setDisplay("TableConfigInfo", 1);
		adjustParentHeight();
    	return false;           
	}  
	function DSLConfigListselectRemoveCnt(val)
	{
	
	}
    function OnDeleteButtonClick(TableID)
    {        

        var CheckBoxList = document.getElementsByName(TableName+"rml");
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
		
		if (isshowtitle == 1)
		{
			window.location.href='/html/bbsp/dnsconfiguration/dnssearchlist.asp'+'?Title='+1;   
		}
		else
		{
			window.location.href='/html/bbsp/dnsconfiguration/dnssearchlist.asp';     
		}
        
        return false;        
    }

    function OnApplyButtonClick()
    { 	
        var DnsSearchListItem = GetDnsSearchListData();
      
        if (CheckParameter(DnsSearchListItem) == false)
        {
            return false;
        }
		
		if (CheckItemRepeat(DnsSearchListItem) == true)
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
		if( selctIndex == -1 )
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
		
		
		if (isshowtitle == 1)
		{
			window.location.href='/html/bbsp/dnsconfiguration/dnssearchlist.asp'+'?Title='+1;   
		}
		else
		{
			window.location.href='/html/bbsp/dnsconfiguration/dnssearchlist.asp';     
		}
		DisableRepeatSubmit();   
        return false;
    }


    function OnCancelButtonClick()
    {
        var tableRow = getElementById(TableName);
		if ((tableRow.rows.length > 2) && IsAddMode())
        {
            
            tableRow.deleteRow(tableRow.rows.length-1);
        }
        setDisplay("TableConfigInfo", 0);
        return false;

    }
	
	function InitDSLTableList()
	{
		for (var i = 0; i < TableDataInfo.length - 1; i++)
		{
			TableDataInfo[i].Interface =  GetWanFullName(TableDataInfo[i].Interface);
		}
	}
	
</script>
    <title>Domain Name Resolving</title>

</head>
<body  class="mainbody" onload="OnPageLoad();" scroll="no" style="overflow-y:hidden; overflow-x:hidden">
<script language="JavaScript" type="text/javascript">
if (isshowtitle == 1)
{
    HWCreatePageHeadInfo("dnssearchlisttitleinfo", GetDescFormArrayById(dnscfg_language, "bbsp_mune"), GetDescFormArrayById(dnspolicy_language, "bbsp_dnssearchlist_title"), false);
	document.write('<div class="title_spread"></div>');
}
var TableClass = new stTableClass("width_per15", "width_per85", "ltr");
</script>
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="func_title"> 
<tr><td BindText="bbsp_dns_search_titlehead"></td></tr></table> 
<script language="JavaScript" type="text/javascript">
	var DSLConfiglistInfo = new Array(new stTableTileInfo("Empty","align_center width_per5","DomainBox"),									
								new stTableTileInfo("bbsp_domain","align_center width_per40","DomainName",false,30),
								new stTableTileInfo("bbsp_waninterface","align_center width_per30","Interface"),
								new stTableTileInfo("bbsp_dnssvr","align_center width_per30","DNSServer"),null);
	var ColumnNum = 4;
	var ShowButtonFlag = true;
	var DSLTableConfigInfoList = new Array();
	var TableDataInfo = HWcloneObject(DnsSearchList, 1);
	TableDataInfo.push(null);
	InitDSLTableList();
	HWShowTableListByType(1, TableName, ShowButtonFlag, ColumnNum, TableDataInfo, DSLConfiglistInfo, dnscfg_language, null);
</script>

<form id="TableConfigInfo" style="display:none;"> 
<div class="list_table_spread"></div>
	<table border="0" cellpadding="0" cellspacing="1"  width="100%">
		<li   id="domain"        RealType="TextBox"          DescRef="Instance"         RemarkRef=""     ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.domain"      InitValue="Empty" MaxLength="255"/>
		<li   id="DomainName"    RealType="TextBox"          DescRef="bbsp_domainmh"         RemarkRef=""     ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.DomainName"     Elementclass="InputDns"  InitValue="Empty" MaxLength="255"/>
		<li   id="WanNameList"   RealType="DropDownList"     DescRef="bbsp_waninterfacemh"      RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.Interface"    Elementclass="InputDns"  InitValue="Empty"/>
		<li   id="DNSServer"     RealType="TextBox"          DescRef="bbsp_dnssvrmh"         RemarkRef=""     ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.DNSServer"     Elementclass="InputDns"  InitValue="Empty" MaxLength="39"/>
	</table>
	<script language="JavaScript" type="text/javascript">
	DSLConfigFormList = HWGetLiIdListByForm("TableConfigInfo", DnsSearchListReload);
	HWParsePageControlByID("TableConfigInfo", TableClass, dnscfg_language, DnsSearchListReload);
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
				<button id="ButtonApply"  type="button" onclick="javascript:return OnApplyButtonClick();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(dnscfg_language['bbsp_app']);</script></button>
				<button id="ButtonCancel" type="button" onclick="javascript:OnCancelButtonClick();" class="CancleButtonCss buttonwidth_100px"><script>document.write(dnscfg_language['bbsp_cancel']);</script></button>
			</td>
		</tr>
	</table>

</form>

</body>
</html>
