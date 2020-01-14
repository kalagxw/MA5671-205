<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>MAC Filter</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<style type="text/css">
.tabnoline td
{
   border:0px;
}
</style>
<script language="JavaScript" type="text/javascript"> 
var selctIndex = -1;
var numpara = "";
var TableName = "MacfilterConfigList";

if( window.location.href.indexOf("?") > 0)
{
    numpara = window.location.href.split("?")[1]; 
}

var enableFilter = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Security.MacFilterRight);%>';

var Mode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Security.MacFilterPolicy);%>';



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
		b.innerHTML = macfilter_language[b.getAttribute("BindText")];
	}
}

function stMacFilter(domain,MACAddress)
{
   this.domain = domain;
   this.MACAddress = MACAddress;
}

var MacFilter = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.MacFilter.{i},SourceMACAddress,stMacFilter);%>;
function ShowMacFilter(obj)
{
	if (obj.checked)
	{
		setDisplay('FilterInfo', 1);
	}
	else
	{
		setDisplay('FilterInfo', 0);
	}
}

function removeClick() 
{
   var rml = getElement('rml');
  
   if (rml == null)
   	   return;
 
   var Form = new webSubmitForm();

   var k;	   
   if (rml.length > 0)
   {
      for (k = 0; k < rml.length; k++) 
	  {
         if ( rml[k].checked == true )
         {
			 Form.addParameter(rml[k].value,'');
		 }	
      }
   }  
   else if ( rml.checked == true )
   {
	  Form.addParameter(rml.value,'');
   }
   Form.addParameter('x.X_HW_Token', getValue('onttoken'));	  
   Form.setAction('del.cgi?RequestFile=html/bbsp/macfilter/macfilter.asp');
   Form.submit();
}

function LoadFrame()
{
   if (enableFilter != '' && Mode != '')
   {    
       setDisplay('FilterInfo',1);
       setSelect('FilterMode',Mode);
       if (MacFilter.length - 1 == 0)
       {
           selectLine('record_no');
           setDisplay('TableConfigInfo',0);
       }
       else
       {
           selectLine(TableName + '_record_0');
           setDisplay('TableConfigInfo',1);
       }
       setDisable('EnableMacFilter',0);
       setDisable('FilterMode',0);
       setDisable('btnApply_ex',0);
       setDisable('cancel',0);
   }
   else
   {
       setDisplay('FilterInfo',0);
   }
   
   if (enableFilter == "1")
   {
       getElById("EnableMacFilter").checked = true;
   }

	if(isValidMacAddress(numpara) == true)
	{
		clickAdd(TableName + '_head');
		setText('SourceMACAddress', numpara);
	}
	loadlanguage();
}

function selFilter(filter)
{
   if (filter.checked)
   {   
       FilterInfo.style.display = "";
	   if (enableFilter == 0)
	   {
		   var mode = getElement('FilterMode');
		   mode[0].disabled = true;
		   mode[1].disabled = true;
	   }
   }
   else
   {
	   setDisplay('FilterInfo',0);
   }
   SubmitForm();
   setDisable('EnableMacFilter',1);
}

function ChangeMode()
{
	var MacfilterPolicySpecCfgParaList = new Array();

    var FilterMode = getElById("FilterMode");

    if (FilterMode[0].selected == true)
	{ 
		if (ConfirmEx(macfilter_language['bbsp_macfilterconfirm1']))
		{
			MacfilterPolicySpecCfgParaList.push(new stSpecParaArray("x.MacFilterPolicy", 0, 1));
		}
		else
		{
		    FilterMode[0].selected = false;
			FilterMode[1].selected = true;
			return;
		}
	}
	else if (FilterMode[1].selected == true)
	{ 
		if (ConfirmEx(macfilter_language['bbsp_macfilterconfirm2']))
		{
			MacfilterPolicySpecCfgParaList.push(new stSpecParaArray("x.MacFilterPolicy", 1, 1));
		}
		else
		{
		    FilterMode[0].selected = true;
		    FilterMode[1].selected = false;
			return;
		}
	}
	
	var Parameter = {};
	Parameter.asynflag = null;
	Parameter.FormLiList = MacfilterInfoConfigFormList;
	Parameter.SpecParaPair = MacfilterPolicySpecCfgParaList;
	var tokenvalue = getValue('onttoken');
	var url = 'set.cgi?x=InternetGatewayDevice.X_HW_Security'
                + '&RequestFile=html/bbsp/macfilter/macfilter.asp';
	HWSetAction(null, url, Parameter, tokenvalue);	
}

function SubmitForm()
{
	var MacfilterRightSpecCfgParaList = new Array();

	var Enable = getElById("EnableMacFilter").checked;
	if (Enable == true)
	{
	   MacfilterRightSpecCfgParaList.push(new stSpecParaArray("x.MacFilterRight", 1, 1));
	}
	else
	{
	   MacfilterRightSpecCfgParaList.push(new stSpecParaArray("x.MacFilterRight", 0, 1));
	}
	var Parameter = {};
	Parameter.asynflag = null;
	Parameter.FormLiList = MacfilterInfoConfigFormList;
	Parameter.SpecParaPair = MacfilterRightSpecCfgParaList;
	var tokenvalue = getValue('onttoken');
	var url = 'set.cgi?x=InternetGatewayDevice.X_HW_Security'
				+ '&RequestFile=html/bbsp/macfilter/macfilter.asp';
				
	HWSetAction(null, url, Parameter, tokenvalue);	
}

function CheckForm()
{   
    var macAddress = getElement('SourceMACAddress').value;
    if (macAddress == '') 
    {
		AlertEx(macfilter_language['bbsp_macfilterisreq']);
        return false;
    }
    if (macAddress != '' && isValidMacAddress1(macAddress) == false ) 
    {
        AlertEx(macfilter_language['bbsp_themac'] + macAddress + macfilter_language['bbsp_macisinvalid']);
        return false;
    }

    for (var i = 0; i < MacFilter.length-1; i++)
    {
        if (selctIndex != i)
        {
            if (macAddress.toUpperCase() == MacFilter[i].MACAddress.toUpperCase())
            {
                AlertEx(macfilter_language['bbsp_themac'] + macAddress + macfilter_language['bbsp_macrepeat']);
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

function AddSubmitParam()
{
	if (false == CheckForm())
	{
		return;
	}
	var MacfilterSpecCfgParaList = new Array(new stSpecParaArray("x.SourceMACAddress",getValue('SourceMACAddress'), 1));
	var url = '';
    if( selctIndex == -1 )
	{
		 url = 'add.cgi?x=InternetGatewayDevice.X_HW_Security.MacFilter'
		                        + '&RequestFile=html/bbsp/macfilter/macfilter.asp';
	}
	else
	{
	     url = 'set.cgi?x=' + MacFilter[selctIndex].domain
							+ '&RequestFile=html/bbsp/macfilter/macfilter.asp';
	}
	
	var Parameter = {};
	Parameter.asynflag = null;
	Parameter.FormLiList = MacfilterConfigFormList;
	Parameter.SpecParaPair = MacfilterSpecCfgParaList;
	var tokenvalue = getValue('onttoken');
	HWSetAction(null, url, Parameter, tokenvalue);	
	
    setDisable('EnableMacFilter',1);
    setDisable('FilterMode',1);
    setDisable('btnApply_ex',1);
    setDisable('cancel',1);
}

function setCtlDisplay(record)
{
	setText('SourceMACAddress',record.MACAddress);
}

function setMacInfo()
{
	if (Mode == 1)
    {   
        setDisplay("MacAlert",1);
        AlertEx(macfilter_language['bbsp_linkmacfilter']);
    }
    else 
    {
        setDisplay("MacAlert",0);
    }
}

function setControl(index)
{   
    var record;
    selctIndex = index;
    if (index == -1)
	{
	    if (MacFilter.length >= 8+1)
        {
            setDisplay('TableConfigInfo', 0);
            AlertEx(macfilter_language['bbsp_macfilterfull']);
            return;
        }
        else
        {
	        record = new stMacFilter('','');
            setDisplay('TableConfigInfo', 1);
			setMacInfo();
            setCtlDisplay(record);
        }
	}
    else if (index == -2)
    {
        setDisplay('TableConfigInfo', 0);
    }
	else
	{
	    record = MacFilter[index];
        setDisplay('TableConfigInfo', 1);
        setCtlDisplay(record);
	}
    setDisable('btnApply_ex',0);
    setDisable('cancel',0);
}

function MacfilterConfigListselectRemoveCnt(val)
{

}

function OnDeleteButtonClick(TableID)
{ 
    if ((MacFilter.length-1) == 0)
	{
	    AlertEx(macfilter_language['bbsp_nomacfilter']);
	    return;
	}

	if (selctIndex == -1)
	{
	    AlertEx(macfilter_language['bbsp_savemacfilter']);
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
		AlertEx(macfilter_language['bbsp_selectmacfilter']);
		return;
	}

    if (enableFilter == 1 && Mode == 1)
    {   
        if(ConfirmEx(macfilter_language['bbsp_macfilterconfirm3']))
        {
			Form.addParameter('x.X_HW_Token', getValue('onttoken'));
			Form.setAction('del.cgi?' +'x=InternetGatewayDevice.X_HW_Security.MacFilter' + '&RequestFile=html/bbsp/macfilter/macfilter.asp');
			Form.submit();
            setDisable('btnApply_ex',1);
            setDisable('cancel',1);
        }
        else
        {
            return;
        }
    }
    else
    {
        if (ConfirmEx(macfilter_language['bbsp_macfilterconfirm4']) == false)
    	{
    	    document.getElementById("DeleteButton").disabled = false;
    	    return;
        }
		
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.setAction('del.cgi?' +'x=InternetGatewayDevice.X_HW_Security.MacFilter' + '&RequestFile=html/bbsp/macfilter/macfilter.asp');
		Form.submit();
        setDisable('btnApply_ex',1);
        setDisable('cancel',1);
    }  
}

function CancelValue()
{   
    if (selctIndex == -1)
    {
        var tableRow = getElement(TableName);

        if (tableRow.rows.length == 1)
        {
        }
        else if (tableRow.rows.length == 2)
        {
            // addNullInst('MAC Filter');
		   setDisplay('TableConfigInfo',0);
        }   
        else
        {
            tableRow.deleteRow(tableRow.rows.length-1);
            selectLine(TableName + '_record_0');
        }
    }
    else
    {
        setText('SourceMACAddress',MacFilter[selctIndex].MACAddress);
    }
}

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody">
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("macfilter", GetDescFormArrayById(macfilter_language, "bbsp_mune"), GetDescFormArrayById(macfilter_language, "bbsp_macfilter_title"), false);
</script>
<div class="title_spread"></div>

<div id="FilterInfo">
<form id="MacFilterCfg" style="display:block;">
	<table border="0" cellpadding="0" cellspacing="1"  width="100%"> 
		<li   id="EnableMacFilter"                 RealType="CheckBox"           DescRef="bbsp_enablemacfiltermh"       RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.MacFilterRight"             InitValue="Empty" ClickFuncApp="onclick=SubmitForm"/>
		<li   id="FilterMode"                RealType="DropDownList"       DescRef="bbsp_filtermodemh"                RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.MacFilterPolicy"         InitValue="[{TextRef:'bbsp_blacklist',Value:'0'},{TextRef:'bbsp_whitelist',Value:'1'}]" ClickFuncApp="onchange=ChangeMode"/>
	</table>
	<script>
		var TableClass = new stTableClass("width_per20", "width_per80", "ltr");
		MacfilterInfoConfigFormList = HWGetLiIdListByForm("MacFilterCfg", null);
		HWParsePageControlByID("MacFilterCfg", TableClass, macfilter_language, null);
		getElById("EnableMacFilter").title = macfilter_language['bbsp_macfilternote1'];
		getElById("FilterMode").title = macfilter_language['bbsp_macfilternote2'];
	</script>
	<div class="func_spread"></div>
</form>

<script language="JavaScript" type="text/javascript">
	var MacfilterConfiglistInfo = new Array(new stTableTileInfo("Empty","","DomainBox"),									
								new stTableTileInfo("bbsp_sourcemac","","MACAddress"),null);	
	var ColumnNum = 2;
	var ShowButtonFlag = true;
	var MacfilterTableConfigInfoList = new Array();
	var TableDataInfo = HWcloneObject(MacFilter, 1);
	HWShowTableListByType(1, TableName, ShowButtonFlag, ColumnNum, TableDataInfo, MacfilterConfiglistInfo, macfilter_language, null);
</script>

<form id="TableConfigInfo" style="display:none;"> 
<div class="list_table_spread"></div>
	<table border="0" cellpadding="0" cellspacing="1"  width="100%"> 
		<li   id="SourceMACAddress"    RealType="TextBox"          DescRef="bbsp_sourcemacmh"         RemarkRef="bbsp_macfilternote3"     ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.SourceMACAddress"      InitValue="Empty" MaxLength='17'/>
	</table>
	<script language="JavaScript" type="text/javascript">
		MacfilterConfigFormList = HWGetLiIdListByForm("TableConfigInfo", null);
		HWParsePageControlByID("TableConfigInfo", TableClass, macfilter_language, null);
	</script>
	<div id="MacAlert" style="display:none;"> 
		<table cellpadding="2" cellspacing="0" class="pm_tabal_bg" width="100%"> 
		  <tr> 
			<td class='color_red' BindText='bbsp_rednote'></td> 
		  </tr> 
		</table> 
	 </div>
	 <table cellpadding="0" cellspacing="0" width="100%" class="table_button"> 
          <tr > 
            <td class='width_per20'></td> 
            <td class="table_submit">
			  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
			  <button id='btnApply_ex' name="btnApply_ex" class="ApplyButtoncss buttonwidth_100px" type="button" onClick="AddSubmitParam();"><script>document.write(macfilter_language['bbsp_app']);</script></button> 
              <button id='Cancel' name="cancel" class="CancleButtonCss buttonwidth_100px" type="button" onClick="CancelValue();"><script>document.write(macfilter_language['bbsp_cancel']);</script></button> </td> 
          </tr> 
		  <tr> 
			  <td  style="display:none"> <input type='text'> </td> 
		  </tr>          
	</table> 
</form>
</div>

</body>
</html>
