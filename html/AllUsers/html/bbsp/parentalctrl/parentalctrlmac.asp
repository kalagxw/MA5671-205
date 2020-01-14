 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<style type="text/css">
.table_title1 {
	background-color: #f2f2f2;
	padding-left: 2px;
	height: 12px;
	line-height: 12px;
}
.SelectChildList
{
	width:250px;
}

.Inputclass
{
	width:245px;
}

.nomargin {
	margin-left: 0px;
	margin-right:0px;
	margin-top: 0px;
}
</style>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<title>Children List</title>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/parentalctrlinfo.asp"></script>
<script language="javascript" src="../common/lanuserinfo.asp"></script>
<script language="JavaScript" type="text/javascript">

var ChildListArray = GetChildList();
var ChildListArrayNr = ChildListArray.length-1;
var VarFilterApplyRange = GetFilterApplyRange();
var TemplatesListArray = GetTemplatesList();
var TemplatesListArrayNr = TemplatesListArray.length-1;

var FOR_NULL="--";
var FOR_AllDevice = "All devices";
var selectindex = -1;
var listNum = 8;
var currentFile='parentalctrlmac.asp';
var MAX_DEVICES = 8;
var MAX_TEMPLATES = 8;
var CurDevSelect;
var TableName = "PCtrMacConfigList";

if( window.location.href.indexOf("?") > 0)
{
	if (window.location.href.indexOf("AddAllDev") != -1)
	{
		VarFilterApplyRange = "ALLDEVICE";
	}
}

function WriteTemplateOption()
{
	var output = '';
	for (var i = 0; i < TemplatesListArrayNr; i++)
	{
		output = '<option value=' + encodeURIComponent(TemplatesListArray[i].Name) + ' id="RadioTemplate'+i+'">' + TemplatesListArray[i].Name + '</option>';
		$("#TemplateList").append(output);
	}
}

function MakeDeviceOption(MacAddr,HostName)
{
   var DeviceStr;

	if (HostName=='')
	{
		return MacAddr;
	}
	else
	{
		HostName = GetStringContent(HostName,16);
		DeviceStr=MacAddr+'&nbsp;'+HostName;
		return DeviceStr;
	}
}

function WriteDeviceOption(UserDevices)
{
	var UserDevicesnum = UserDevices.length - 1;
	var output = "";

	if (UserDevicesnum<=0)
	{
		output = '<option value="OtherMac">' + parentalctrl_language['bbsp_manually'] + '</option>';
		$("#ChildrenList").append(output);
	}
	else
	{
		for (var i = 0; i < UserDevicesnum; i++)
		{
			for(var j = 0; j < ChildListArrayNr;j++)
			{
				if (UserDevices[i].MacAddr == ChildListArray[j].MACAddress )
					break;
			}

			if(j == ChildListArrayNr)
			{
				output = '<option value=' + UserDevices[i].MacAddr +'>'+MakeDeviceOption(UserDevices[i].MacAddr,UserDevices[i].HostName) + '</option>';
				$("#ChildrenList").append(output);
			}
		}
		output = '<option value="OtherMac">' + parentalctrl_language['bbsp_manually'] + '</option>';
		$("#ChildrenList").append(output);
	}
}

function OnChildListChange()
{
	var SelectMac= getSelectVal("ChildrenList");

	setText("ChildrenInfo",'');
	if (SelectMac=="OtherMac")
	{
		setDisplay("macAddr"+"Row",1);
	}
	else
	{
		setDisplay("macAddr"+"Row",0);
		for (var j = 0; j < ChildListArrayNr; j++)
		{
			if ( ChildListArray[j].MACAddress == SelectMac)
			{
				if (ChildListArray[j].Description != '')
				{
					setText("ChildrenInfo",ChildListArray[j].Description);
				}
			}
		}
	}
}

function GetTemplateInstByName(TemplateName)
{
	var TemplateInst = "";
	if (TemplateName == '-1')
	{
		return TemplateInst;
	}

	for (var i = 0; i < TemplatesListArrayNr; i++)
	{
		if (TemplateName == encodeURIComponent(TemplatesListArray[i].Name))
		{
			var id = TemplatesListArray[i].domain.split(".");
			TemplateInst = id[4];
			return TemplateInst;
		}
	}
}

function CheckForm()
{
	var SelectMac=getSelectVal('ChildrenList');
	var  ChildInfo= getValue('ChildrenInfo');
	ChildInfo = removeSpaceTrim(ChildInfo);
	var MacAddress = getValue('macAddr');
	var IsAnyTempSelect = false;

	if (SelectMac=="OtherMac" && VarFilterApplyRange != "ALLDEVICE")
	{
		var MacAddress = getValue('macAddr');
		if(isValidMacAddress(MacAddress) == false)
		{
			AlertEx(arp_language['bbsp_macaddr']+ MacAddress + arp_language['bbsp_invalid']);
			return false;
		}
	}

   if((ChildInfo!='')&&(isValidAscii(ChildInfo)!= ''))
   {
		AlertEx(parentalctrl_language['bbsp_devicescription'] + parentalctrl_language['bbsp_hasvalidch'] + isValidAscii(ChildInfo) + parentalctrl_language['bbsp_end']);
		return false;
   }

	if(selectindex == -1)
	{
		for(var i = 0; i < ChildListArrayNr; i++)
		{
			if (SelectMac=="OtherMac")
			{
				if(MacAddress.toUpperCase() == (ChildListArray[i].MACAddress).toUpperCase() )
				{
					AlertEx(parentalctrl_language["bbsp_repeatmac"]);
					return false;
				}
			}
		}
	}

   return true;
}

function OnApply()
{
	var SelectMac = getSelectVal('ChildrenList');
	var ChildInfo = getValue('ChildrenInfo');
	ChildInfo = removeSpaceTrim(ChildInfo);
	var MacAddress = getValue('macAddr');
	var TemplateName = getSelectVal('TemplateList');
	var TemplateInst = GetTemplateInstByName(TemplateName);

	if( CheckForm()==false)
	{
		return;
	}

	var PCtrMacSpecCfgParaList = new Array();
	var url = '';
	if(VarFilterApplyRange=="ALLDEVICE")
	{
		PCtrMacSpecCfgParaList.push(new stSpecParaArray("x.MACAddress","FF:FF:FF:FF:FF:FF", 1));
		PCtrMacSpecCfgParaList.push(new stSpecParaArray("x.Description",ChildInfo, 1));
		PCtrMacSpecCfgParaList.push(new stSpecParaArray("x.TemplateInst",TemplateInst, 1));

		if(selectindex == -1)
		{
			url = 'add.cgi?' + 'x=InternetGatewayDevice.X_HW_Security.ParentalCtrl.MAC' + '&RequestFile=html/bbsp/parentalctrl/parentalctrlmac.asp';
		}
		else
		{
			url = 'set.cgi?x=' + ChildListArray[selectindex].domain + '&RequestFile=html/bbsp/parentalctrl/parentalctrlmac.asp';
		}
	}
	else
	{
		if (SelectMac=="OtherMac")
		{
			PCtrMacSpecCfgParaList.push(new stSpecParaArray("x.MACAddress",MacAddress, 1));
		}
		else
		{
			PCtrMacSpecCfgParaList.push(new stSpecParaArray("x.MACAddress",SelectMac, 1));
		}

		PCtrMacSpecCfgParaList.push(new stSpecParaArray("x.Description",ChildInfo, 1));
		if ("" != TemplateInst)
		{
			PCtrMacSpecCfgParaList.push(new stSpecParaArray("x.TemplateInst",TemplateInst, 1));
		}

		if(selectindex == -1)
		{
			url = 'add.cgi?' +'x=InternetGatewayDevice.X_HW_Security.ParentalCtrl.MAC' + '&RequestFile=html/bbsp/parentalctrl/parentalctrlmac.asp';
		}
		else
		{
			url = 'set.cgi?x=' + ChildListArray[selectindex].domain + '&RequestFile=html/bbsp/parentalctrl/parentalctrlmac.asp';
		}
	}

	setDisable("ButtonApply", 1);
	setDisable("ButtonCancel", 1);

	var Parameter = {};
	Parameter.asynflag = null;
	Parameter.FormLiList = PCtrMacConfigFormList;
	Parameter.SpecParaPair = PCtrMacSpecCfgParaList;
	var tokenvalue = getValue('onttoken');
	HWSetAction(null, url, Parameter, tokenvalue);
	DisableRepeatSubmit();
}

function OnCancel()
{
	if (selectindex == -1)
	{
		var tableRow = getElement(TableName);

		if (tableRow.rows.length == 1)
		{
		}
		else if (tableRow.rows.length == 2)
		{
			//addNullInst('Children');

			if (ChildListArrayNr <= 0)
			{
				document.getElementById("TableConfigInfo").style.display = "none";
			}
		}
		else
		{
			tableRow.deleteRow(tableRow.rows.length-1);
			selectLine(TableName + '_record_0');
		}
	}
	else
	{
		if(VarFilterApplyRange=="ALLDEVICE")
		{
			setDisplay('TableConfigInfo', 0);
		}
		else
		{
			selectLine(TableName + '_record_0');
		}
	}
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
		b.innerHTML = parentalctrl_language[b.getAttribute("BindText")];
	}
}

function DeleteLineRow()
{
	var tableRow = getElementById(TableName);
	if (tableRow.rows.length > 2)
	tableRow.deleteRow(tableRow.rows.length-1);
	return false;
}

function setControl(index)
{
	selectindex = index;

	if (selectindex < -1)
	{
		adjustParentHeight();
		return;
	}

	if (-1 == selectindex)
	{
		if (TemplatesListArrayNr === 0)
		{
			AlertEx(parentalctrl_language['bbsp_notemplate']);
			adjustParentHeight();
			return;
		}
		if(VarFilterApplyRange=="ALLDEVICE")
		{
			if(ChildListArrayNr >= 1)
			{
				DeleteLineRow();
				setDisplay('TableConfigInfo', 0);
				adjustParentHeight();
				return;
			}
		}
		else
		{
			if(ChildListArrayNr >= MAX_DEVICES)
			{
				DeleteLineRow();
				setDisplay('TableConfigInfo', 0);
				AlertEx(parentalctrl_language["bbsp_maxdevice"]);
				adjustParentHeight();
				return ;
			}
		 }

		setDisable("ChildrenList",0);
		setText("ChildrenInfo","");
		setDisable("ChildrenInfo",0);
		setText("macAddr","");

		document.getElementById("ChildrenList")[0].selected = true;
		setDisplay("ChildrenInfo",1);
		if (VarFilterApplyRange=="ALLDEVICE")
		{
			setDisplay('DisplayAllDevice'+'Row', 1);
			setDisplay('DisplaySpecifiedDevice'+'Row', 0);
			setDisplay('ChildrenList'+'Row', 0);
			setDisplay('macAddr'+'Row', 0);
		}
		else
		{
			setDisplay('DisplayAllDevice'+'Row', 0);
			setDisplay('DisplaySpecifiedDevice'+'Row', 0);
			setDisplay('ChildrenList'+'Row', 1);
			setDisplay('macAddr'+'Row', 1);
		}
		var selectObj = document.getElementById('ChildrenList');
		var optionArry = selectObj.options;
		if (1==optionArry.length)
		{
			setDisplay("macAddr"+"Row",1);
		}
		else
		{
			setDisplay("macAddr"+"Row",0);
		}
		setDisplay('TableConfigInfo', 1);
	}
	else
	{
		var selectObj = document.getElementById('ChildrenList');
		var optionArry = selectObj.options;
		var TemplateName = "";

		setDisable("ChildrenList",1);

		selectObj.selectedIndex = optionArry.length-1;
		setDisplay("macAddr"+"Row",1);
		if(VarFilterApplyRange=="ALLDEVICE")
		{
			setText("ChildrenInfo",ChildListArray[0].Description);
			setDisable("ChildrenInfo",0);
			TemplateName = GetBindTemplate(ChildListArray[0].TemplateInst);
		}
		else
		{
			setText("ChildrenInfo",ChildListArray[selectindex].Description);
			setDisable("ChildrenInfo",0);
			TemplateName = GetBindTemplate(ChildListArray[selectindex].TemplateInst);
			setText("macAddr",ChildListArray[selectindex].MACAddress);
		}
		setSelect("TemplateList",TemplateName);

		if (VarFilterApplyRange=="ALLDEVICE")
		{
			setDisplay('DisplayAllDevice'+'Row', 1);
			setDisplay('DisplaySpecifiedDevice'+'Row', 0);
			setDisplay('ChildrenList'+'Row', 0);
			setDisplay('macAddr'+'Row', 0);
		}
		else
		{
			document.getElementById("DisplaySpecifiedDevice").innerHTML = ChildListArray[selectindex].MACAddress;
			setDisplay('DisplayAllDevice'+'Row', 0);
			setDisplay('DisplaySpecifiedDevice'+'Row', 1);
			setDisplay('ChildrenList'+'Row', 0);
			setDisplay('macAddr'+'Row', 0);
		}
		setDisplay('TableConfigInfo', 1);
	}
	adjustParentHeight();
	return;
}

function PCtrMacConfigListselectRemoveCnt(val)
{

}

function OnDeleteButtonClick(TableID)
{
	var CheckBoxList = document.getElementsByName(TableName + "rml");
	var Count = 0;
	var i;

	if (ChildListArrayNr==0)
	{
		AlertEx(parentalctrl_language['bbsp_nomac']);
		return false;
	}
	for (i = 0; i < CheckBoxList.length; i++)
	{
		if (CheckBoxList[i].checked == true)
		{
			Count++;
		}
	}

	if (Count === 0)
	{
		AlertEx(parentalctrl_language['bbsp_selectmac']);
		return false;
	}

	setDisable("ButtonApply", 1);
	setDisable("ButtonCancel", 1);

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

	Form.setAction('del.cgi?RequestFile=html/bbsp/parentalctrl/parentalctrlmac.asp');
	Form.submit();
}

function ChooseDeviceOption()
{
	var RadioValue = getRadioVal('idRadioDevice');
	var requestUrl = "";
	var Onttoken = getValue('onttoken');

	if(CurDevSelect == RadioValue){
		return;
	}

	if (RadioValue == 'AllDevice')
	{
		if(ConfirmEx(parentalctrl_language['bbsp_confirm_alldevice']))
		{
			for(var i = 0; i < ChildListArrayNr; i++)
			{
				if(0 === i){
					requestUrl +=  ChildListArray[i].domain + "=";
				}else{
					requestUrl += '&' + ChildListArray[i].domain + "=";
				}
			}

			requestUrl += '&x.X_HW_Token=' + Onttoken;

			$.ajax({
				type : "POST",
				async : false,
				cache : false,
				data : requestUrl,
				url : "del.cgi?&RequestFile=html/bbsp/parentalctrl/parentalctrlmac.asp",
				error:function(XMLHttpRequest, textStatus, errorThrown)
				{
					window.location.replace("parentalctrlmac.asp");
				},
				success:function()
				{
					window.location="/html/bbsp/parentalctrl/parentalctrlmac.asp?AddAllDev=1";
				}
			});
			CurDevSelect = RadioValue;
		}
		else
		{
			setRadio('idRadioDevice','SpecifiedDevice');
		}
	}
	else
	{
		if(ConfirmEx(parentalctrl_language['bbsp_confirm_specdevice']))
		{
			var Form = new webSubmitForm();
			var searchList = new Array('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p');
			for(var i = 0; i < ChildListArrayNr; i++)
			{
				var urlPrefix = 'Del_d' + searchList[i];
				if(0 === i){
					requestUrl += urlPrefix + '=' + ChildListArray[i].domain;
				}else{
					requestUrl += '&' + urlPrefix + '=' + ChildListArray[i].domain;
				}
			}

			Form.addParameter('x.X_HW_Token', getValue('onttoken'));
			Form.setAction("complex.cgi?" + requestUrl + "&RequestFile=html/bbsp/parentalctrl/parentalctrlmac.asp");
			Form.submit();
			CurDevSelect = RadioValue;
		}
		else
		{
			setRadio('idRadioDevice','AllDevice');
		}
	}

}


function GetBindTemplate(TemplateInst)
{
	var TemplateName = "--";
	for (var i = 0; i < TemplatesListArray.length-1; i++)
	{
		if (TemplatesListArray[i].TemplateId == TemplateInst)
		{
			TemplateName = TemplatesListArray[i].Name;
		}
	}
	return TemplateName;
}

function LoadFrame()
{
	if (ChildListArrayNr == 0)
	{
		selectLine('record_no');
	}
	else
	{
		setDisplay('TableConfigInfo', 0);
	}

	if(VarFilterApplyRange=="ALLDEVICE")
	{
		document.getElementById("RadioAllDevice").checked = true;
		if(ChildListArrayNr > 0){
			setDisable('Newbutton',1);
		}
	}
	else
	{
		document.getElementById("RadioSpecifiedDevice").checked = true;
	}

	loadlanguage();

	CurDevSelect = getRadioVal('idRadioDevice');
}

function InitTableData()
{
	if((TableDataInfo.length - 1 > 0)&&(VarFilterApplyRange=="ALLDEVICE"))
	{
		TableDataInfo[0].domain = TableDataInfo[0].domain;
		TableDataInfo[0].MACAddress = parentalctrl_language["bbsp_allDevice"];
		if (TableDataInfo[0].Description == '')
		{
			TableDataInfo[0].Description = FOR_NULL;
		}
		TableDataInfo[0].TemplateInst = GetBindTemplate(TableDataInfo[0].TemplateInst);
	}
	else
	{
		for (var i = 0; i < TableDataInfo.length - 1 ; i++)
		{
			if (TableDataInfo[0].Description == '')
			{
				TableDataInfo[0].Description = FOR_NULL;
			}
			TableDataInfo[i].TemplateInst = GetBindTemplate(TableDataInfo[i].TemplateInst);
		}
	}
}

function adjustParentHeight()
{
	var dh = getHeight(document.getElementById("DivTableInfo"));
	var dh1 = getHeight(document.getElementById("TableConfigInfo"));
	var height = 150 + (dh > 0 ? dh : 0) + (dh1 > 0 ? dh1 : 0);
	window.parent.adjustParentHeight("pccframeWarpContent", height);
}

</script>
</head>
<body  onLoad="LoadFrame();" class="mainbody nomargin">
<div id="DivTableInfo">
<td >
<input name="idRadioDevice" id="RadioAllDevice" type="radio" value="AllDevice"  onclick="ChooseDeviceOption();"/>
<span class="RadioDevice"><script>document.write(parentalctrl_language["bbsp_setalldevice"]);</script></span>
<input name="idRadioDevice" id="RadioSpecifiedDevice" type="radio" value="SpecifiedDevice" class="RadioDevice" onclick="ChooseDeviceOption();"/>
<span class="RadioDevice"><script>document.write(parentalctrl_language["bbsp_setspecifieddevice"]);</script></span>
</td>
<div class="button_spread"></div>
<script language="JavaScript" type="text/javascript">
var TableClass = new stTableClass("width_per25", "width_per75", "ltr");
var PCtrMacConfiglistInfo = new Array(new stTableTileInfo("Empty","align_center width_per10","DomainBox"),
								new stTableTileInfo("bbsp_device","align_center width_per20","MACAddress"),
								new stTableTileInfo("bbsp_scription","align_center width_per20","Description",false,15),
								new stTableTileInfo("bbsp_bindtemplate","align_center width_per20","TemplateInst",false,15),null);
var ColumnNum = 4;
var ShowButtonFlag = true;
var PctrMacConfigFormList = new Array();
var TableDataInfo = HWcloneObject(ChildListArray, 1);
InitTableData();
HWShowTableListByType(1, TableName, ShowButtonFlag, ColumnNum, TableDataInfo, PCtrMacConfiglistInfo, parentalctrl_language, null);
</script>
</div>

<form id="TableConfigInfo" style="display:none">
<div class="list_table_spread"></div>
	<table border="0" cellpadding="0" cellspacing="1"  width="100%">
		<li   id="DeviceInfoBar"                    RealType="HorizonBar"         DescRef="bbsp_device"              RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/>
		<li   id="DisplayAllDevice"                 RealType="HtmlText"           DescRef="bbsp_selectdevice"              RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/>
		<li   id="DisplaySpecifiedDevice"           RealType="HtmlText"           DescRef="bbsp_selectdevice"              RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/>
		<li   id="ChildrenList"                     RealType="DropDownList"       DescRef="bbsp_selectdevice"        RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"      Elementclass="SelectChildList"        InitValue="Empty" ClickFuncApp="onchange=OnChildListChange"/>
		<li   id="macAddr"                          RealType="TextBox"            DescRef="bbsp_childmacmh"          RemarkRef="bbsp_childmacremark1"    ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.MACAddress"  Elementclass="Inputclass" InitValue="Empty"      MaxLength="32"/>
		<li   id="ScriptionInfoBar"                 RealType="HorizonBar"         DescRef="bbsp_scription"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/>
		<li   id="ChildrenInfo"                     RealType="TextBox"            DescRef="bbsp_devicescription"     RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.Description"   Elementclass="Inputclass"   InitValue="Empty"      MaxLength="64"/>
		<li   id="BindTemplateInfoBar"              RealType="HorizonBar"         DescRef="bbsp_bindtemplate"        RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/>
		<li   id="TemplateList"                     RealType="DropDownList"       DescRef="bbsp_template"        RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.TemplateInst"         InitValue="Empty"/>
	</table>
	<script>
	PCtrMacConfigFormList = HWGetLiIdListByForm("TableConfigInfo", null);
	var formid_hide_id = null;
	HWParsePageControlByID("TableConfigInfo", TableClass, parentalctrl_language, formid_hide_id);
	document.getElementById("DisplayAllDevice").innerHTML = parentalctrl_language["bbsp_allDevice"];
	GetLanUserDevInfoNoDelay(function(para)
	{
		WriteDeviceOption(para);
	});
	WriteTemplateOption();
	</script>
	<table cellpadding="0" cellspacing="0"  width="100%" class="table_button">
		<tr>
		<td class="table_submit" style="text-align:center">
		 
				<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
				<button type="button" id='ButtonApply' onclick = "OnApply();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(parentalctrl_language['bbsp_app']);</script> </button>
				&nbsp;
				<button type="button" id='ButtonCancel' onclick="OnCancel();" class="CancleButtonCss buttonwidth_100px"><script>document.write(parentalctrl_language['bbsp_cancel']);</script> </button>
			</td>
		</tr>
	</table>
</form>
</body>
</html>
