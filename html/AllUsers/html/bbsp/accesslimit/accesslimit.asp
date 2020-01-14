<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>

<title>portal</title>
</head>
<body class="mainbody"> 
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("accesslimittitle", GetDescFormArrayById(accesslimit_language, ""), GetDescFormArrayById(accesslimit_language, "bbsp_accesslimit_title"), false);
</script>
<div class="title_spread"></div>

<table border="0" cellpadding="0" cellspacing="0" id="Table1" width="100%"> </table> 
<table border="0" cellpadding="0" cellspacing="1" id="Table2" width="100%"> 
  <tr> 
    <td  class="table_title width_per20" BindText='bbsp_limitmodemh'></td> 
    <td  class="table_right"><select id = "LimitMode" class="width_155px" onchange="OnChangeLimitMode(this[this.selectedIndex].value)"> 
        <option value="Off"><script>document.write(accesslimit_language['bbsp_off']);</script></option>
        <option value="GlobalLimit"><script>document.write(accesslimit_language['bbsp_globallimit']);</script></option> 
        <option value="TypeLimit"><script>document.write(accesslimit_language['bbsp_typelimit']);</script></option> 
      </select></td> 
  </tr> 
  <tr id="TotalLimitPanel" style="display:none"> 
    <td class="table_title width_per20" BindText='bbsp_limitnummh'></td> 
    <td class="table_right" > 
	<input type = "text" id = "TotalLimit" onclick="" style="width: 150px" maxlength="3" /> 
      <font color="red">*</font><span class="gray">(0-253)</span></td> 
  </tr>
</table> 
<table id="OperatorPanel" class="table_button width_per100" cellpadding="0"> 
  <tr> 
    <td class="table_submit width_per20"></td> 
    <td class="table_submit align_left"> 
		<button id='Apply' type=button onclick = "javascript:return OnApplyGlobal();" class="submit"><script>document.write(accesslimit_language['bbsp_app']);</script></button>
      	<button id='Cancel' type=button onclick = "javascript:return OnCancelGlobal();" class="submit"><script>document.write(accesslimit_language['bbsp_cancel']);</script></button> 
&nbsp;</td> 
  </tr> 
</table> 
<div class="func_spread"></div>

<script language="javascript">
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
		b.innerHTML = accesslimit_language[b.getAttribute("BindText")];
	}
}


function GetLanguageEnable(Language, Enable)
{
    if (Enable == "1" || Enable == 1)
    {
        return accesslimit_language['bbsp_enable'];
    }
    else
    {
        return accesslimit_language['bbsp_disable'];
    }
}
function BasicInfo(_Domain, _LimitMode, _TotalLimit)
{
	this.Domain = _Domain;
	this.LimitMode = _LimitMode;
	this.TotalLimit = _TotalLimit;
}

function TypeLimitInfo(_Domain, _Enable, _DeviceType, _LimitNum)
{
    this.Domain = _Domain;
    this.Enable = _Enable;
    this.DeviceType = _DeviceType;
    this.LimitNum = _LimitNum;
}

var DeviceList = new Array("Computer", "Phone", "STB", "Camera");
var BasicInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.X_HW_AccessLimit,Mode|TotalTerminalNumber,BasicInfo);%>;
var TypeLimitInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.X_HW_AccessLimit.TypeLimit.{i},Enable|VenderClassId|LimitNumber,TypeLimitInfo);%>;
var BasicInfo = BasicInfoList[0];
var CfgModeWord ='<%HW_WEB_GetCfgMode();%>'; 

function OnChangeLimitMode(LimitMode)
{
    setDisplay("TotalLimitPanel",0);
    setDisplay("TypeLimitPanel",0);
    
    if (LimitMode == "GlobalLimit")
    {
        setDisplay("TotalLimitPanel",1);
    }
}
function ShowConfigPanel(LimitMode)
{
    setDisplay("TotalLimitPanel",0);
    setDisplay("TypeLimitPanel",0);
    
    if (LimitMode == "GlobalLimit")
    {
        setDisplay("TotalLimitPanel",1);
    }
    if (LimitMode == "TypeLimit")
    {
        setDisplay("TypeLimitPanel",1);
    }
    
}
function UpdateUI(BasicInfo, TypeLimitInfoList)
{
    setSelect("LimitMode", BasicInfo.LimitMode);
    setText("TotalLimit", BasicInfo.TotalLimit);

    ShowConfigPanel(BasicInfo.LimitMode);
	
	if ((CfgModeWord.toUpperCase() == 'LNCU') || (CfgModeWord.toUpperCase() == 'YNCMCC'))
	{
        setDisable('TotalLimit',1);
        setDisable('LimitMode',1);
	    setDisable('Apply',1);
        setDisable('Cancel',1);
		setDisable('Applys',1);
        setDisable('Cancels',1);
		setDisable('DeleteButton',1);
        setDisable('Newbutton',1);
		setDisable('EnableTypeLimit',1);
	}
	
    var HtmlCode = "";
    var DataGrid = getElById("DataGrid");
    var RecordCount = TypeLimitInfoList.length - 1;
    var i = 0;
     
    if (RecordCount == 0)
    {
        HtmlCode += '<TR id="record_no"' + '  class="tabal_01 align_center" onclick="selectLine(this.id);">';
        HtmlCode += '<TD>--</TD>';
        HtmlCode += '<TD>--</TD>';
        HtmlCode += '<TD>--</TD>';
        HtmlCode += '<TD>--</TD>';
    	HtmlCode += '</TR>';
    	return HtmlCode;
    }

    for (i = 0; i < RecordCount; i++)
    {
	     if (CfgModeWord.toUpperCase() == 'LNCU')
		{
		    HtmlCode += '<TR id="record_' + i 
    	                + '" class="tabal_01" onclick="selectLine(this.id);">';
            HtmlCode += '<TD>' + '<input type="checkbox" name="rml" disabled="disabled"'  + ' value=' 
    	                 + TypeLimitInfoList[i].Domain  + '>' + '</TD>';
    	    HtmlCode += '<TD  class="align_center" id = \"RecordEnable'+i+'\">' + GetLanguageEnable("Chinese",TypeLimitInfoList[i].Enable) + '</TD>';
		}
		else
		{
		    HtmlCode += '<TR id="record_' + i 
    	                + '" class="tabal_01" onclick="selectLine(this.id);">';
            HtmlCode += '<TD>' + '<input type="checkbox" name="rml"'  + ' value=' 
    	                 + TypeLimitInfoList[i].Domain  + '>' + '</TD>';
    	    HtmlCode += '<TD  class="align_center" id = \"RecordEnable'+i+'\">' + GetLanguageEnable("Chinese",TypeLimitInfoList[i].Enable) + '</TD>';
		}
		if (IsDeviceTypeNormal(TypeLimitInfoList[i].DeviceType) == false)
		{
			HtmlCode += '<TD id = \"RecordDevice'+i+'\">' + GetStringContent(TypeLimitInfoList[i].DeviceType,45) + '</TD>';
		}
		else 
		{
			HtmlCode += '<TD id = \"RecordDevice'+i+'\">' + accesslimit_language[TypeLimitInfoList[i].DeviceType] + '</TD>';
		}
		if (CfgModeWord.toUpperCase() == 'LNCU')
        {
    		setDisable('LimitNum',1);
        }
        HtmlCode += '<TD  class="align_center" id = \"RecordLimitNum'+i+'\">' + TypeLimitInfoList[i].LimitNum + '</TD>';
    	HtmlCode += '</TR>';
    }

    return HtmlCode;

}

window.onload = function()
{
    UpdateUI(BasicInfo, TypeLimitInfoList);
    InitControlDataType();
	loadlanguage();
}


function OnApplyGlobal()
{ 
    var LimitMode = getSelectVal("LimitMode");
    var TotalLimit = getValue("TotalLimit"); 

    if (LimitMode == "GlobalLimit")
    {
				if (isValidAscii(TotalLimit) != '')         
				{  
					AlertEx(accesslimit_language['bbsp_limitnummh1'] + Languages['Hasvalidch'] + isValidAscii(TotalLimit) + accesslimit_language['bbsp_sign']);          
					return false;       
				}
        if(TotalLimit.charAt(0) == '0' && TotalLimit != '0')
        {
            AlertEx(accesslimit_language['bbsp_glimitnuminvalid']);
            return false;
        }
        if (false == CheckNumber(TotalLimit, 0, 253))
        {
        	AlertEx(accesslimit_language['bbsp_totallimitmsg']);
        	return false;
        }
    }
 
    var Form = new webSubmitForm();
    Form.addParameter('x.Mode',LimitMode);
    if (LimitMode == "GlobalLimit")
    {
    	Form.addParameter('x.TotalTerminalNumber',TotalLimit);	
    }
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('set.cgi?' +'x=InternetGatewayDevice.Services.X_HW_AccessLimit' + '&RequestFile=html/bbsp/accesslimit/accesslimit.asp');
	Form.submit();
}

function OnCancelGlobal()
{
    UpdateUI(BasicInfo, TypeLimitInfoList);
}
</script> 
<script language="JavaScript" type="text/javascript">
var OperatorFlag = 0;
var OperatorIndex = 0;

function GetInputTypeLimitInfo()
{
    var TypeEnable = getCheckVal("EnableTypeLimit");
    var DeviceName = getElById("DeviceNameControl").value;
    var LimitNum = getElById("LimitNum").value; 
   
    return new TypeLimitInfo("", TypeEnable, DeviceName, LimitNum);    
}

function CheckValueBeforeApply(TypeLimitInfo)
{
    if (TypeLimitInfo.DeviceType.length == 0)
    {
        AlertEx(accesslimit_language['bbsp_devtypeisreq']);
        return false;	
    }

    if (TypeLimitInfo.LimitNum.length == 0)
    {
        AlertEx(accesslimit_language['bbsp_limitnumisreq']);
        return false;
    }

    if ((TypeLimitInfo.LimitNum.charAt(0) == '0') && (TypeLimitInfo.LimitNum != '0'))
    {
        AlertEx(accesslimit_language['bbsp_limitnuminvalid']);
        return false;
    }
	
	if (isValidAscii(TypeLimitInfo.LimitNum) != '')         
	{  
		AlertEx(accesslimit_language['bbsp_typelimitnum'] + Languages['Hasvalidch'] + isValidAscii(TypeLimitInfo.LimitNum) + accesslimit_language['bbsp_sign']);          
		return false;       
	}
		if (false == CheckNumber(TypeLimitInfo.LimitNum, 0, 253))
		{
			AlertEx(accesslimit_language['bbsp_limitnummsg']);
			return false;	
		}


    return true;

}


function OnNewInstance(index)
{
   OperatorFlag = 1;

   getElById("ChooseDeviceType").disabled = false;
   getElById("LimitNum").value = "";
   setDisable("DeviceNameControl", 0);
   setCheck("EnableTypeLimit", "1");
   InitDeviceTypeComlexControl("Computer");

   document.getElementById("TableConfigInfo").style.display = "block";
}
function OnAddNewSubmit()
{
    var TypeLimitInfoInput = GetInputTypeLimitInfo();

  
    var i;

	if (BasicInfo.LimitMode != "TypeLimit")
	{
	    AlertEx(accesslimit_language['bbsp_selectmode']);
	    return false;
	}

    for (i = 0; i < TypeLimitInfoList.length-1; i++)
    {
        if (TypeLimitInfoList[i].DeviceType == TypeLimitInfoInput.DeviceType)
        {
            AlertEx(getElById("DeviceNameControl").ErrorMsg);
            return false;
        }
    }

    if (false == CheckValueBeforeApply(TypeLimitInfoInput))
    {
        return false;
    }


    var Form = new webSubmitForm();
    Form.addParameter('x.Enable', TypeLimitInfoInput.Enable);
    Form.addParameter('x.VenderClassId',TypeLimitInfoInput.DeviceType);
    Form.addParameter('x.LimitNumber',TypeLimitInfoInput.LimitNum);	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('add.cgi?' +'x=InternetGatewayDevice.Services.X_HW_AccessLimit.TypeLimit' + '&RequestFile=html/bbsp/accesslimit/accesslimit.asp');
    Form.submit();
}


function ModifyInstance(index)
{
    OperatorFlag = 2;
    var InstanceId = TypeLimitInfoList[index].Domain;
    var EnableTypeLimit = TypeLimitInfoList[index].Enable;
    var DeviceType = TypeLimitInfoList[index].DeviceType;
    var LimitNum = TypeLimitInfoList[index].LimitNum;

    getElById("DeviceNameControl").disabled = true;
    getElById("ChooseDeviceType").disabled = true;
    getElById("TableConfigInfo").style.display = "block";
    getElById("LimitNum").value = LimitNum;
    setCheck("EnableTypeLimit", EnableTypeLimit);
    InitDeviceTypeComlexControl(DeviceType);

} 
function OnModifySubmit()
{
    var TypeLimitInfoInput = GetInputTypeLimitInfo();

    if (false == CheckValueBeforeApply(TypeLimitInfoInput))
    {
        return false;
    }

    var Form = new webSubmitForm();
    Form.addParameter('x.Enable',TypeLimitInfoInput.Enable);
    Form.addParameter('x.LimitNumber',TypeLimitInfoInput.LimitNum);	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('set.cgi?' +'x='+ TypeLimitInfoList[OperatorIndex].Domain + '&RequestFile=html/bbsp/accesslimit/accesslimit.asp');
    Form.submit();

}
  
function setControl(index)
{ 
	if (index < -1)
	{
		return;
	}


    OperatorIndex = index;   

    if (-1 == index)
    {
        if (TypeLimitInfoList.length-1 == 4)
        {
	        AlertEx(accesslimit_language['bbsp_devtypefull']);
	        return false;
        }
        return OnNewInstance(index);
    }
    else
    {
        return ModifyInstance(index);
    }
}

function clickRemove() 
{
    var CheckBoxList = document.getElementsByName("rml");
    var Count = 0;
    var i;
    for (i = 0; i < CheckBoxList.length; i++)
    {
        if (CheckBoxList[i].checked == true)
        {
            Count++;
        }
    }

   
    if (Count == 0)
    {
        AlertEx(accesslimit_language['bbsp_selectrecord']);
        return false;
    }
    

    var Form = new webSubmitForm();
    for (i = 0; i < CheckBoxList.length; i++)
    {
        if (CheckBoxList[i].checked != true)
        {
            continue;
        }

        Form.addParameter(CheckBoxList[i].value,'');
    }

	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('del.cgi?' +'x=InternetGatewayDevice.Services.X_HW_AccessLimit.TypeLimit' + '&RequestFile=html/bbsp/accesslimit/accesslimit.asp');
    Form.submit();
}
  
function OnApply()
{
    if (OperatorFlag == 1)
    {
        return OnAddNewSubmit();
    }
    else
    {
        return OnModifySubmit();
    }
}

function OnCancel()
{
	getElById('TableConfigInfo').style.display='none';
	getElById('OperatorPanel').style.display = 'block';
	
	var tableRow = getElementById("TableLimitList");
	if ( (OperatorFlag == 1) && (tableRow.rows.length > 2))
	{
		tableRow.deleteRow(tableRow.rows.length-1);
		return false;
	}
}

   function IsDeviceTypeNormal(Value)
   {
        var i;
        
        for (i = 0; i < DeviceList.length; i++)
        {
            if (Value == DeviceList[i])
            {
                return true;
            }
        }
        return false;
   }

   function InitDeviceTypeComlexControl(Value)
   {
        setSelect("ChooseDeviceType", Value);
        setText("DeviceNameControl", Value);
        setDisplay("DeviceNameControl",0);
        if (IsDeviceTypeNormal(Value) == false)
        {   
            if (Value == "Other")
            {
               setText("DeviceNameControl", ""); 
            }
            setSelect("ChooseDeviceType", "Other");
            setDisplay("DeviceNameControl",1);
        }
   }  

   function OnChooseDeviceType(Select)
   {
        InitDeviceTypeComlexControl(getSelectVal(Select.id));
   }

   </script> 
<div id="TypeLimitPanel" style="display:none"> 
  <script language="JavaScript" type="text/javascript">
    writeTabCfgHeader('aaa','100%');
</script> 
  <table class="tabal_bg" id="TableLimitList" width="100%" cellspacing="1"> 
    <tr  class="head_title"> 
      <td>&nbsp;</td> 
      <td BindText='bbsp_enable_status'></td> 
      <td BindText='bbsp_devtype'></td> 
      <td BindText='bbsp_typelimitnum'></td> 
    </tr> 
    <script>
    document.write(UpdateUI(BasicInfo, TypeLimitInfoList));
    </script> 
  </table> 
 
  <div id="TableConfigInfo" style="display:none"> 
  <div class="list_table_spread"></div>
    <table class="tabal_bg" class="tabCfgArea" border="0" cellpadding="0" cellspacing="1"  width="100%"> 
    <tr class="trTabConfigure"> 
      <td  class="table_title align_left" width="20%" BindText='bbsp_enabletypelimitmh'></td> 
      <td  class="table_right"> <input type="checkbox"  id="EnableTypeLimit"/></td> 
    </tr> 
    <tr class="trTabConfigure"> 
      <td  class="table_title align_left" width="20%" BindText='bbsp_devtypemh'></td> 
      <td  class="table_right"> <select id="ChooseDeviceType" onchange="OnChooseDeviceType(this);" 
                    style="width: 156px"> 
		  <option value="Computer"><script>document.write(accesslimit_language['Computer']);</script></option>
		  <option value="Phone"><script>document.write(accesslimit_language['Phone']);</script></option>
		  <option value="STB"><script>document.write(accesslimit_language['STB']);</script></option>
		  <option value="Camera"><script>document.write(accesslimit_language['Camera']);</script></option>
		  <option value="Other"><script>document.write(accesslimit_language['Other']);</script></option>
        </select> 
        <input type=text id="DeviceNameControl"  style="width:214px; display: none;" maxlength=255 value="Computer"> </td> 
    </tr> 
    <tr class="trTabConfigure"> 
      <td  class="table_title align_left"  width="20%" BindText='bbsp_typelimitnummh'></td> 
      <td class="table_right"> <input type=text id="LimitNum"  style="width:150px" maxlength=3/> 
        <font color="red">*</font><span class="gray">(0-253)</span></td> 
    </tr>
		<script>
			getElById('DeviceNameControl').ErrorMsg = accesslimit_language['bbsp_devnamemsg'];
		</script>
    </table> 
    <table width="100%"  cellspacing="1" class="table_button"> 
      <tr> 
        <td class="width_per20"></td> 
        <td class="table_submit pad_left5p"> 
			 <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
			<button id='Applys' type=button onclick = "javascript:return OnApply();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(accesslimit_language['bbsp_app']);</script></button> 
          	<button id='Cancels' type=button onclick="javascript:OnCancel();" class="CancleButtonCss buttonwidth_100px"><script>document.write(accesslimit_language['bbsp_cancel']);</script></button>
		  </td> 
      </tr> 
    </table> 
  </div> 
</div> 
</body>
</html>
