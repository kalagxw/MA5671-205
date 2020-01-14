<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />

<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<title>Dhcpv6 staitc ipv6 address config</title>
<style>
.InputDhcp 
{
	width:123px;
}
</style>
<script language="JavaScript" type="text/javascript">
var selctIndex = -1;
var AddFlag = true;
var TableName = "DSAConfigList";

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
		b.innerHTML = dhcpv6_staticip_language[b.getAttribute("BindText")];
	}
}

function RaConfigInfoClass(domain, ManagedFlag, OtherConfigFlag)
{
    this.domain = domain;
    this.ManagedFlag = ManagedFlag;
    this.OtherConfigFlag = OtherConfigFlag;
}
          
var RaConfigs = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.X_HW_RouterAdvertisement, ManagedFlag|OtherConfigFlag, RaConfigInfoClass);%>;  
var RaConfig = RaConfigs[0];
    
function stConfig(domain,InterfaceID,Chaddr)
{
    this.domain = domain;
    this.InterfaceID = InterfaceID;
	this.Chaddr = Chaddr;
}

var Configs = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.X_HW_DHCPv6.Server.StaticAllocation.{i},InterfaceID|Chaddr,stConfig);%>
var Config = new Array();
for (var i = 0; i < Configs.length-1; i++)
{
    Config[i] = Configs[i];
}

function LoadFrame()
{ 
   if (Config.length > 0)
   {
	   selectLine(TableName + '_record_0');
       setDisplay('TableConfigInfo',1);
   }	
   else
   {   
	   selectLine('record_no');
       setDisplay('TableConfigInfo',0);
   }

   loadlanguage();
}
function IsUshortValid(Short)
{

    if (Short.length != 4)
    {
        return false;
    }
    
    for (var i = 0; i < Short.length; i++)
    {
        var Char = Short.charAt(i);
        if (!((Char >= '0' && Char <= '9') || (Char >= 'a' && Char <= 'f') || (Char >= 'A' && Char <= 'F')))
        {
            return false;
        }
    }
    
    return true;
}


function IsZero(interfaceid)
{
    for (var i = 0; i < interfaceid.length; i++)
    {
        if (interfaceid.charAt(i) != '0' && interfaceid.charAt(i) != ':')
        {
            return false;
        }
    }
    
    return true;
}

function IsAllFF(interfaceid)
{
    for (var i = 0; i < interfaceid.length; i++)
    {
        if (interfaceid.charAt(i) != 'f' && interfaceid.charAt(i) != 'F' && interfaceid.charAt(i) != ':')
        {
            return false;
        }
    }
    
    return true;
}
function IsValid(interfaceid)
{    

    if (interfaceid.length != 19)
    {
        return false;
    }
    if (IsZero(interfaceid) == true)
    {
        return false;
    }
	
	if (IsAllFF(interfaceid) == true)
    {
        return false;
    }  
	
    var List = interfaceid.split(":");
    if (List.length != 4)
    {
        return false;
    }
	

    for (var i = 0; i < List.length; i++)
    {
        if (false == IsUshortValid(List[i]))
        {
            return false;
        }
    }
    return true;
}

function AddSubmitParam()
{					
	if (false == CheckForm())
	{
		return;
	}
	var DSASpecCfgParaList = new Array(new stSpecParaArray("x.InterfaceID",getValue('interfaceid'), 1),
									 new stSpecParaArray("x.Chaddr",getValue('macAddr'), 1));
	var url = '';	
	if( selctIndex == -1 )
	{
		url = 'add.cgi?x=InternetGatewayDevice.LANDevice.1.X_HW_DHCPv6.Server.StaticAllocation'
							+ '&RequestFile=html/bbsp/dhcpstaticaddr/dhcpstaticaddress.asp';
	}
	else
	{
	     url = 'set.cgi?x=' + Config[selctIndex].domain
							+ '&RequestFile=html/bbsp/dhcpstaticaddr/dhcpstaticaddress.asp';
	}
	
	var Parameter = {};
	Parameter.OldValueList = null;
	Parameter.asynflag = null;
	Parameter.FormLiList = DSAConfigFormList;
	Parameter.SpecParaPair = null;//DSASpecCfgParaList;
	var tokenvalue = getValue('onttoken');
	HWSetAction(null, url, Parameter, tokenvalue);	
	
    setDisable('btnApply_ex',1);
    setDisable('cancel',1);
}

function setCtlDisplay(record)
{
    if (record == null)
    {
	    setText('macAddr','');
    	setText('interfaceid','');

    }
    else
    {
	    setText('macAddr',record.Chaddr);
        setText('interfaceid',record.InterfaceID);
    	
    }
}

function setControl(index)
{
	var record;
	selctIndex = index;
    if (index == -1)
    {
	    if(Config.length >= 16)
	    {
	        setDisplay('TableConfigInfo', 0);
		    AlertEx(dhcpv6_staticip_language['bbsp_configfull']);
		      return;
	}
	record = null;
        AddFlag = true;
        setDisplay('TableConfigInfo', 1);
        setCtlDisplay(record);
     }
     else if (index == -2)
     {
        setDisplay('TableConfigInfo', 0);
     }
    else
    {
	    record = Config[index];
        AddFlag = false;
        setDisplay('TableConfigInfo', 1);
        setCtlDisplay(record);
    }

    setDisable('btnApply_ex',0);
    setDisable('cancel',0);
}

function DSAConfigListselectRemoveCnt(val)
{

}

function OnDeleteButtonClick(TableID)
{ 
    if (Config.length == 0)
	{
	    AlertEx(dhcpv6_staticip_language['bbsp_noconfig']);
	    return;
	}
	
	if (selctIndex == -1)
	{
	    AlertEx(dhcpv6_staticip_language['bbsp_saveconfig']);
	    return;
	}
    var CheckBoxList = document.getElementsByName(TableName+'rml');
	var Form = new webSubmitForm();
	var Count = 0;
	for (var i = 0; i < CheckBoxList.length; i++)
	{
		if (CheckBoxList[i].checked != true)
		{
			continue;
		}
		
		Count++;
		Form.addParameter(CheckBoxList[i].value,'');
	}
	if (Count <= 0)
	{
		AlertEx(dhcpv6_staticip_language['bbsp_selectconfig']);
		return;
	}
        
	if (ConfirmEx(dhcpv6_staticip_language['bbsp_confirm1']) == false)
	{
		document.getElementById("DeleteButton").disabled = false;
	    return;
    }
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('del.cgi?' +'x=InternetGatewayDevice.LANDevice.1.X_HW_DHCPv6.Server.StaticAllocation' + '&RequestFile=html/bbsp/dhcpstaticaddr/dhcpstaticaddress.asp');
	Form.submit();
	
    setDisable('btnApply_ex',1);
    setDisable('cancel',1);
    removeInst('html/bbsp/dhcpstaticaddr/dhcpstaticaddress.asp');
}  

function CheckForm()
{	
    var Interfaceid;
	var MacAddress;

	Interfaceid = getValue('interfaceid');
	MacAddress = getValue('macAddr'); 
	
	if (Interfaceid == "") 
	{
	    AlertEx(dhcpv6_staticip_language['bbsp_idisreq']);
		return false;
	}    

	if (MacAddress == "")
	{
	    AlertEx(dhcpv6_staticip_language['bbsp_macisreq']);
		return false;
	}
    
    for (var i = 0; i < Config.length; i++)
    {
        if (selctIndex != i)
        {
            if (Config[i].InterfaceID == Interfaceid)
            {
                AlertEx(dhcpv6_staticip_language['bbsp_idrepeat']);
                return false;
            }
        }
        else
        {
            continue;
        }
    }

	for (var i = 0; i < Config.length; i++)
    {
        if (selctIndex != i)
        {
            if (Config[i].Chaddr.toUpperCase() == MacAddress.toUpperCase())
            {
                AlertEx(dhcpv6_staticip_language['bbsp_macrepeat']);			
                return false;
            }
        }
        else
        {
            continue;
        }
    }

	if(isValidMacAddress(MacAddress) == false)
	{
	    AlertEx(dhcpv6_staticip_language['bbsp_macaddr']+ MacAddress + dhcpv6_staticip_language['bbsp_invalid']);
		return false;
	}	
   
   	if(isMulticastMacAddress(MacAddress) == false)
	{
	    AlertEx(dhcpv6_staticip_language['bbsp_macaddr']+ MacAddress + dhcpv6_staticip_language['bbsp_invalid']);
		return false;
	}
   
   if(IsValid(Interfaceid) == false)
   {
   	    AlertEx(dhcpv6_staticip_language['bbsp_interfaceid'] + dhcpv6_staticip_language['bbsp_invalid2']);
		return false;
   }
   	return true;
}

function Cancel()
{         
    setDisplay("TableConfigInfo", 0);
	
	if (AddFlag == true)
    {
        var tableRow = getElement("ConfigInst");

        if (tableRow.rows.length == 1)
        {
            selectLine('record_no');
        }
        else if (tableRow.rows.length == 2)
        {
            addNullInst('Config');
        } 
        else
        {
            tableRow.deleteRow(tableRow.rows.length-1);
            selectLine(TableName+'_record_0');
        }
    }
    else
    {
        setText('ipAddr',Config[selctIndex].InterfaceID);
    	setText('macAddr',Config[selctIndex].Chaddr);
    }
    setDisable('btnApply_ex',0);
    setDisable('cancel',0);
}

</script>

</head>
<body onLoad="LoadFrame();" class="mainbody">
<script language="JavaScript" type="text/javascript">
if (0 == RaConfig.ManagedFlag)
{
    HWCreatePageHeadInfo("dhcpstaticaddress", GetDescFormArrayById(dhcpv6_staticip_language, "bbsp_mune"), GetDescFormArrayById(dhcpv6_staticip_language, "bbsp_dhcpv6_staticip_title2"), false);
}
else
{
    HWCreatePageHeadInfo("dhcpstaticaddress", GetDescFormArrayById(dhcpv6_staticip_language, "bbsp_mune"), GetDescFormArrayById(dhcpv6_staticip_language, "bbsp_dhcpv6_staticip_title"), false);
}
</script>
<div class="title_spread"></div>
<script language="JavaScript" type="text/javascript">
	var TableClass = new stTableClass("width_per25", "width_per75", "ltr");
	var DSAConfiglistInfo = new Array(new stTableTileInfo("Empty","","DomainBox"),									
									new stTableTileInfo("bbsp_mac","","Chaddr"),
									new stTableTileInfo("bbsp_interfaceid","","InterfaceID"),null);									
	var ColumnNum = 3;
	var ShowButtonFlag = true;
	var DhcpStaticTableConfigInfoList = new Array();
	var TableDataInfo = HWcloneObject(Config, 1);
	TableDataInfo.push(null);
	HWShowTableListByType(1, TableName, ShowButtonFlag, ColumnNum, TableDataInfo, DSAConfiglistInfo, dhcpv6_staticip_language, null);
</script>

<form id="TableConfigInfo" style="display:none;"> 
<div class="list_table_spread"></div>
	<table border="0" cellpadding="0" cellspacing="1"  width="100%"> 
		<li   id="macAddr"    RealType="TextBox"          DescRef="bbsp_macmh"         RemarkRef="bbsp_note1"     ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.Chaddr"   Elementclass="InputDhcp"   InitValue="Empty"/>
		<li   id="interfaceid"     RealType="TextBox"          DescRef="bbsp_id"         RemarkRef="bbsp_note2"     ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.InterfaceID"  Elementclass="InputDhcp"    InitValue="Empty"/>
	</table>
	<script language="JavaScript" type="text/javascript">
	DSAConfigFormList = HWGetLiIdListByForm("TableConfigInfo", null);
	HWParsePageControlByID("TableConfigInfo", TableClass, dhcpv6_staticip_language, null);
	</script>
	 <table cellpadding="0" cellspacing="0" width="100%" class="table_button"> 
       <tr>
	      <td class="width_per25"></td>
            <td class="table_submit">
				<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
                <button id="btnApply_ex" name="btnApply_ex" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="AddSubmitParam();"><script>document.write(dhcpv6_staticip_language['bbsp_app']);</script></button>
                <button id="cancel" name="cancel" type="button" class="CancleButtonCss buttonwidth_100px" onClick="Cancel();"><script>document.write(dhcpv6_staticip_language['bbsp_cancel']);</script></button>
            </td>
          
        </tr>
    </table>
</form>
</body>
</html>

