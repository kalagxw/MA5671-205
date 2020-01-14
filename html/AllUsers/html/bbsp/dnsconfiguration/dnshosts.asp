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
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<script language="javascript" src="../common/dnshostslist.asp"></script>
<script language="JavaScript" src="<%HW_WEB_GetReloadCus(html/bbsp/dnsconfiguration/dnshosts.cus);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<style>
.InputDns{
	width: 311px;
}
</style>
	<script language="JavaScript" type="text/javascript">
	
	var sysUserType = '0';
    var curUserType = '<%HW_WEB_GetUserType();%>';
	var SonFlag = '<%HW_WEB_GetFeatureSupport(BBSP_FT_SONET);%>'; 
	
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
	
	var TableName = "DnsHostConfigList";
	var selctIndex = -1;
	var DnsHostsList = GetDnsHostsList();
	
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

    function BindPageData(DnsHostsInfo)
    {    
        setText("domain", DnsHostsInfo.domain);
     	setText("IPAddress", DnsHostsInfo.IPAddress); 
        setText("DomainName", DnsHostsInfo.DomainName);  	
	}

	
    function GetDnsHostsData()
    {
	    var CurrentDomain = (GetDnsHostsList()[selctIndex] != null)?GetDnsHostsList()[selctIndex].domain:"";
        return new DnsHostsItemClass(CurrentDomain,getValue("IPAddress"), getValue("DomainName"));
    }

    function OnPageLoad()
    {
		loadlanguage();
		adjustParentHeight();
        return true;
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
			if (selctIndex != i)
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

	        if (selctIndex != i)
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
		var height = 100+(dh > 0 ? dh : 0) + (dh1 > 0 ? dh1 : 0);
		if (undefined != window.parent.adjustParentHeight)
		{
			window.parent.adjustParentHeight("DnsHostsFrameContent", height);
		}
	}
	
    function clickRemove() 
    {
        return OnRemoveButtonClick();
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
            if (GetDnsHostsList().length >= 20)
            {
                AlertEx(dnscfg_language['bbsp_sdnsfull']);
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
		
        BindPageData(new DnsHostsItemClass("","",""));
        setDisplay("TableConfigInfo", "1");
		adjustParentHeight();
        return ;   
    }
    

    function OnEditButtonClick(Index)
    {	    
        BindPageData(GetDnsHostsList()[Index]);
        setDisplay("TableConfigInfo", "1");
		adjustParentHeight();
    	return ;           
	}  

	function DnsHostConfigListselectRemoveCnt(val)
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
		
		if (isshowtitle == 1)
		{
			window.location.href='/html/bbsp/dnsconfiguration/dnshosts.asp'+'?Title='+1;   
		}
		else
		{
			window.location.href='/html/bbsp/dnsconfiguration/dnshosts.asp';     
		}
        
        return false;        
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
		if( selctIndex == -1 )
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
		
		
		if (isshowtitle == 1)
		{
			window.location.href='/html/bbsp/dnsconfiguration/dnshosts.asp'+'?Title='+1;   
		}
		else
		{
			window.location.href='/html/bbsp/dnsconfiguration/dnshosts.asp';     
		}
        DisableRepeatSubmit();
        
        return false;
    }


    function OnCancelButtonClick()
    {
        if (GetDnsHostsList().length > 0 && IsAddMode())
        {
            var tableRow = getElementById(TableName);
            tableRow.deleteRow(tableRow.rows.length-1);
        }
        setDisplay("TableConfigInfo", "0");
        return false;

    }
</script>
    <title>Static Domain Name Resolve</title>

</head>
<body  class="mainbody" onload="OnPageLoad();" scroll="no" style="overflow-y:hidden; overflow-x:hidden">
<script language="JavaScript" type="text/javascript">
if ((SonFlag != 1)&& ((isshowtitle == 1)||(curUserType != sysUserType)))
{
    HWCreatePageHeadInfo("dnshosttitleinfo", GetDescFormArrayById(dnscfg_language, "bbsp_mune"), GetDescFormArrayById(dnspolicy_language, "bbsp_dnshost_title"), false);
	document.write('<div class="title_spread"></div>');
}
</script>

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="func_title"> 
<tr><td BindText="bbsp_dns_host_titlehead"></td></tr></table> 
<script language="JavaScript" type="text/javascript">
	var TableClass = new stTableClass("width_per15", "width_per85", "ltr");
	var DnsHostConfiglistInfo = new Array(new stTableTileInfo("Empty","align_center width_per5","DomainBox"),									
									new stTableTileInfo("bbsp_domain","align_center width_per60","DomainName",false,50),
									new stTableTileInfo("bbsp_ip","align_center width_per40","IPAddress"),null);
									
	var ColumnNum = 3;
	var ShowButtonFlag = true;
	var DnsHostTableConfigInfoList = new Array();
	var TableDataInfo = HWcloneObject(DnsHostsList, 1);
	TableDataInfo.push(null);
	HWShowTableListByType(1, TableName, ShowButtonFlag, ColumnNum, TableDataInfo, DnsHostConfiglistInfo, dnscfg_language, null);
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
				<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
				<button id="ButtonApply"  type="button" onclick="javascript:return OnApplyButtonClick();" class="ApplyButtoncss buttonwidth_100px" ><script>document.write(dnscfg_language['bbsp_app']);</script></button>
				<button id="ButtonCancel" type="button" onclick="javascript:OnCancelButtonClick();" class="CancleButtonCss buttonwidth_100px" ><script>document.write(dnscfg_language['bbsp_cancel']);</script></button>
			</td>
		</tr>
	</table>
</form>
</body>
</html>
