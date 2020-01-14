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
<title>Dhcp static config</title>
<style type="text/css">
.tabnoline td
{
   border:0px;
}

 .firstCol
{
   width:24%;
   text-align:right ;
}

.secondCol
{
   width:24%;
}

.thirdCol
{
   width:20%;
   text-align:right ;
}

.alignledge
{
   width:3%;
}

.InputDhcp
{
	width:123px;
}
</style>
<script language="JavaScript" type="text/javascript">
var selctIndex = -1;
var AddFlag = true;
var ipaddrarg = ""
var macaddrarg = "";
var TableName = "DhcpStaticConfigList";

if( window.location.href.indexOf("?") > 0)
{
    ipaddrarg = window.location.href.split("?")[1]; 
    macaddrarg = window.location.href.split("?")[2]; 
}

function stDhcp(domain,Enable,ipAddress,macAddress)
{
    this.domain = domain;
	this.Enable = Enable;
    this.ipAddress = ipAddress;
	this.macAddress = macAddress;
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
		b.innerHTML = dhcpstatic_language[b.getAttribute("BindText")];
	}
}

var Dhcps = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.DHCPStaticAddress.{i},Enable|Yiaddr|Chaddr,stDhcp);%>


var Dhcp = new Array();
for (var i = 0; i < Dhcps.length-1; i++)
{
    Dhcp[i] = Dhcps[i];
}

function LoadFrame()
{ 
   if (Dhcp.length > 0)
   {
	   selectLine(TableName + '_record_0');
	   setDisplay('TableConfigInfo',1);
   }	
   else
   {   
	   selectLine('record_no');
	   setDisplay('TableConfigInfo',0);
   }
   
   if ((isValidIpAddress(ipaddrarg) == true)
   		&& (isValidMacAddress(macaddrarg) == true))
   {
	   clickAdd(TableName + '_head');
	   setText('ipAddr', ipaddrarg);
	   setText('macAddr', macaddrarg);
   }
   
   loadlanguage();
}

function AddSubmitParam()
{					
	if (false == CheckForm())
	{
		return;
	}
	var DhcpStaticSpecCfgParaList = new Array(new stSpecParaArray("x.Yiaddr",getValue('ipAddr'), 1),
									 new stSpecParaArray("x.Chaddr",getValue('macAddr'), 1));
	var url = '';
	if( selctIndex == -1 )
	{
		 DhcpStaticSpecCfgParaList.push(new stSpecParaArray("x.Enable","1", 1));
	     url = 'add.cgi?'+'x=InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.DHCPStaticAddress'
							+ '&RequestFile=html/bbsp/dhcpstatic/dhcpstatic.asp';
	}
	else
	{
		url = 'set.cgi?x=' + Dhcp[selctIndex].domain
							+ '&RequestFile=html/bbsp/dhcpstatic/dhcpstatic.asp';
	}

	var Parameter = {};
	Parameter.asynflag = null;
	Parameter.FormLiList = DhcpStaticConfigFormList;
	Parameter.SpecParaPair = DhcpStaticSpecCfgParaList;
	var tokenvalue = getValue('onttoken');
	HWSetAction(null, url, Parameter, tokenvalue);	
    setDisable('btnApply_ex',1);
    setDisable('cancel',1);
}

function setCtlDisplay(record)
{
    if (record == null)
    {
    	setText('ipAddr','');
    	setText('macAddr','');
    }
    else
    {
        setText('ipAddr',record.ipAddress);
    	setText('macAddr',record.macAddress);
    }
}

function DeleteLineRow()
{
   var tableRow = getElementById(TableName);
   if (tableRow.rows.length > 2)
   tableRow.deleteRow(tableRow.rows.length-1);
   return false;
}

var g_Index = -1;
function setControl(index)
{
	var record;
	selctIndex = index;
	
    if (index == -1)
	{
	    if(Dhcp.length >= 16)
	    {
			DeleteLineRow();
			setDisplay('TableConfigInfo', 0);
			AlertEx(dhcpstatic_language['bbsp_num']);
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
	    record = Dhcp[index];
        AddFlag = false;
        setDisplay('TableConfigInfo', 1);
        setCtlDisplay(record);
	}

    g_Index = index;
    setDisable('btnApply_ex',0);
    setDisable('cancel',0);
}

function DhcpStaticConfigListselectRemoveCnt(val)
{

}

function OnDeleteButtonClick(TableID)
{ 
    if (Dhcp.length == 0)
	{
	    AlertEx(dhcpstatic_language['bbsp_removealert1']);
	    return;
	}
	
	if (selctIndex == -1)
	{
	    AlertEx(dhcpstatic_language['bbsp_removealert2']);
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
		AlertEx(dhcpstatic_language['bbsp_removealert3']);
		return;
	}
	
	if (ConfirmEx(dhcpstatic_language['bbsp_removealert4']) == false)
	{
	    document.getElementById("DeleteButton").disabled = false;
	    return;
    }
	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('del.cgi?' +'x=InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.DHCPStaticAddress' + '&RequestFile=html/bbsp/dhcpstatic/dhcpstatic.asp');
	Form.submit();
        
    setDisable('btnApply_ex',1);
    setDisable('cancel',1);
}  

function CheckForm()
{	
    var IpAddress;
	var MacAddress;
    var right = 0;

	IpAddress = getValue('ipAddr');
	MacAddress = getValue('macAddr'); 
	
	if (MacAddress == "")
	{
	    msg = dhcpstatic_language['bbsp_macnull'];
	    AlertEx(msg);
		return false;
	}

	if(isValidMacAddress(MacAddress) == false)
	{
	    AlertEx(dhcpstatic_language['bbsp_mac']+ MacAddress + dhcpstatic_language['bbsp_invalid']);
		return false;
	}	

	if (IpAddress == "") 
	{
	    msg = dhcpstatic_language['bbsp_ipnull'];
	    AlertEx(msg);
		return false;
	}

	if((isAbcIpAddress(IpAddress) == false) || (isDeIpAddress(IpAddress) == true) 
       || (isBroadcastIpAddress(IpAddress) == true) || (isLoopIpAddress(IpAddress) == true) )
	{
	    AlertEx(dhcpstatic_language['bbsp_ipinvalid1']+ IpAddress + dhcpstatic_language['bbsp_invalid']);
		return false;
	}	

    for (var i = 0; i < Dhcp.length; i++)
    {
        if (selctIndex != i)
        {
			if (Dhcp[i].macAddress.toUpperCase() == MacAddress.toUpperCase())
            {
                AlertEx(dhcpstatic_language['bbsp_macused']);
                return false;
            }

            if (Dhcp[i].ipAddress == IpAddress)
            {
                AlertEx(dhcpstatic_language['bbsp_isused']);
                return false;
            }
        }
        else
        {
            continue;
        }
    }

   	return true;
}

function Cancel()
{
	setDisplay("TableConfigInfo", 0);
	
	if (AddFlag == true)
    {
        var tableRow = getElement("dhcpInst");
        
        if (tableRow.rows.length == 1)
        {
            selectLine('record_no');
        }
        else if (tableRow.rows.length == 2)
        {
            addNullInst('Dhcp');
        } 
        else
        {
            tableRow.deleteRow(tableRow.rows.length-1);
            selectLine('record_0');
        }
    }
    else
    {
        setText('ipAddr',Dhcp[selctIndex].ipAddress);
    	setText('macAddr',Dhcp[selctIndex].macAddress);
    }
    setDisable('btnApply_ex',0);
    setDisable('cancel',0);
}

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("dhcpstatic", GetDescFormArrayById(dhcpstatic_language, "bbsp_mune"), GetDescFormArrayById(dhcpstatic_language, "bbsp_dhcpstatic_title"), false);
</script>
<div class="title_spread"></div>
<script language="JavaScript" type="text/javascript">
	var TableClass = new stTableClass("width_per25", "width_per75", "ltr");
	var DhcpStaticConfiglistInfo = new Array(new stTableTileInfo("Empty","","DomainBox"),									
									new stTableTileInfo("bbsp_macaddrtitle","","macAddress"),
									new stTableTileInfo("bbsp_ipaddrtitle","","ipAddress"),null);									
	var ColumnNum = 3;
	var ShowButtonFlag = true;
	var DhcpStaticTableConfigInfoList = new Array();
	var TableDataInfo = HWcloneObject(Dhcp, 1);
	TableDataInfo.push(null);
	HWShowTableListByType(1, TableName, ShowButtonFlag, ColumnNum, TableDataInfo, DhcpStaticConfiglistInfo, dhcpstatic_language, null);
</script>


<form id="TableConfigInfo" style="display:none;"> 
<div class="list_table_spread"></div>
	<table border="0" cellpadding="0" cellspacing="1"  width="100%"> 
		<li   id="macAddr"    RealType="TextBox"          DescRef="bbsp_macaddr"         RemarkRef="bbsp_macaddform"     ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.Chaddr"   Elementclass="InputDhcp"   InitValue="Empty"/>
		<li   id="ipAddr"     RealType="TextBox"          DescRef="bbsp_ipaddr"         RemarkRef=""     ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.Yiaddr"  Elementclass="InputDhcp"    InitValue="Empty"/>
	</table>
	<script language="JavaScript" type="text/javascript">
	DhcpStaticConfigFormList = HWGetLiIdListByForm("TableConfigInfo", null);
	HWParsePageControlByID("TableConfigInfo", TableClass, dhcpstatic_language, null);
	</script>
    <table   cellpadding="0" cellspacing="0" width="100%" class="table_button"> 
       <tr>
	      <td class='width_per25'></td>
            <td class="table_submit">
				<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
                <button id="btnApply_ex" name="btnApply_ex" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="AddSubmitParam();"/><script>document.write(dhcpstatic_language['bbsp_apply']);</script></button>
                <button id="cancel" name="cancel" type="button" class="CancleButtonCss buttonwidth_100px" onClick="Cancel();"/><script>document.write(dhcpstatic_language['bbsp_cancle']);</script></button>
            </td>
          
        </tr>
    </table>
</form>

</body>
</html>

