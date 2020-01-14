<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>PCCTemplate</title>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/time.asp"></script>
<script language="javascript" src="../common/parentalctrlinfo.asp"></script>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<style>
.InputCfgName
{
	width:194px;
}
.InputDate
{
	width:80px;
}
.nomargin {
	margin-left: 0px;
	margin-right:0px;
	margin-top: 0px;
}
</style>
<script language="JavaScript" type="text/javascript">

var TemplatesListArray = GetTemplatesList();
var DurationListArray = GetDurationList();
var ChildListArray = GetChildList();
var ChildListArrayNr = ChildListArray.length-1;
var VarFilterApplyRange = GetFilterApplyRange();
var resizeTimer;
var selctIndex = -1;
var TemplateListMax = 8;
var DurationListMax = 4;
var ChildListMax = 8;
var FOR_AllDevice = "All devices";

function IsBindTemplate(TemplateId)
{
	if(VarFilterApplyRange=="ALLDEVICE")
	{
		if (TemplateId == ChildListArray[0].TemplateInst)
		{
			return parentalctrl_language['bbsp_yes'];
		}
		return parentalctrl_language['bbsp_no'];
	}
	else
	{
		for (var i=0; i<ChildListArray.length-1;i++)
		{
			if (ChildListArray[i].TemplateInst == TemplateId)
			{
				return parentalctrl_language['bbsp_yes'];
			}
		}
		return parentalctrl_language['bbsp_no'];
	}
}

function MakeDuration(StartTime,EndTime)
{
	return StartTime+'-'+EndTime;
}

function MakeRepeatDay(RepeatDay)
{
	var RepeatDayStr="";

	for (var i=0; i<RepeatDay.length;i++)
	{
		if (RepeatDay.charAt(i)=="1")
		{
			RepeatDayStr=RepeatDayStr+parentalctrl_language['bbsp_Monday']+"/";
		}
		if (RepeatDay.charAt(i)=="2")
		{
			RepeatDayStr=RepeatDayStr+parentalctrl_language['bbsp_Tuesday']+"/";
		}
		if (RepeatDay.charAt(i)=="3")
		{
			RepeatDayStr=RepeatDayStr+parentalctrl_language['bbsp_Wednesday']+"/";
		}
		if (RepeatDay.charAt(i)=="4")
		{
			RepeatDayStr=RepeatDayStr+parentalctrl_language['bbsp_Thursday']+"/";
		}
		if (RepeatDay.charAt(i)=="5")
		{
			RepeatDayStr=RepeatDayStr+parentalctrl_language['bbsp_Friday']+"/";
		}
		if (RepeatDay.charAt(i)=="6")
		{
			RepeatDayStr=RepeatDayStr+parentalctrl_language['bbsp_Saturday']+"/";
		}
		if (RepeatDay.charAt(i)=="7")
		{
			RepeatDayStr=RepeatDayStr+parentalctrl_language['bbsp_Sunday']+"/";
		}
	}

	return RepeatDayStr.substr(0,RepeatDayStr.length-1);
}

function DeleteLineRow()
{
   var tableRow = getElementById("TableTemplateList");
   if (tableRow.rows.length > 2)
   tableRow.deleteRow(tableRow.rows.length-1);
   return false;
}

function DisplayDate(varDate)
{
	var strDate = "";
	if (("" != varDate) && (8 == varDate.length))
	{
		strDate = varDate.substr(0, 4)+"-"+varDate.substr(4, 2)+"-"+varDate.substr(6, 2);
	}
	return strDate;
}
function showUrlListByTemplate(templateDomain)
{
	var searchPath = "InternetGatewayDevice.X_HW_Security.ParentalCtrl.Templates.";
	var position = templateDomain.indexOf(searchPath);
	var currentTempId = (templateDomain.substr(searchPath.length).split("."))[0];
	if(position >= 0){
		document.getElementById("frameUrlList").src = "urlList.asp?id=" + currentTempId ;
	}
}
function setCtlDisplayDuration(recordTemplatesList)
{
	var Timeflag = 0;
	var k = 0;
	var TimeDivName = "";
	var RepeatDayDivName = "";

	if (DurationListArray.length - 1 <= 0)
	{
		TimeDivName = "TabTime_" + 0 + "_0";
		RepeatDayDivName = "TabTime_" + 0 + "_1";
		SetDivValue(TimeDivName, "--");
		SetDivValue(RepeatDayDivName, "--");
		document.getElementById('TabTime_record_'+ 0).style.display = "";
	}
	else
	{
		for (var i = 0; i < DurationListMax; i++)
		{
			var tr = document.getElementById('TabTime_record_'+ i);
			tr.style.display = "";
		}

		for (var i = 0; i < DurationListArray.length - 1; i++)
		{
			if (DurationListArray[i].TemplateId == recordTemplatesList.TemplateId)
			{
				TimeDivName = "TabTime_" + k + "_0";
				RepeatDayDivName = "TabTime_" + k + "_1";
				SetDivValue(TimeDivName, MakeDuration(DurationListArray[i].StartTime,DurationListArray[i].EndTime));
				SetDivValue(RepeatDayDivName, MakeRepeatDay(DurationListArray[i].RepeatDay));
				k++;
				Timeflag =1;
			}
		}

		if (0 == Timeflag)
		{
			TimeDivName = "TabTime_" + 0 + "_0";
			RepeatDayDivName = "TabTime_" + 0 + "_1";
			SetDivValue(TimeDivName, "--");
			SetDivValue(RepeatDayDivName, "--");
			document.getElementById('TabTime_record_'+ 0).style.display = "";
			for (var i = 1; i < DurationListMax; i++)
			{
				var tr = document.getElementById('TabTime_record_'+ i);
				tr.style.display = "none";
			}
		}
		else
		{
			for(var i = k; i < DurationListMax; i++)
			{
				var tr = document.getElementById('TabTime_record_'+ i);
				tr.style.display = "none";
			}
		}
	}
}

function setCtlDisplayDeviceBind(recordTemplatesList)
{
	var m = 0;
	var Deviceflag = 0;
	var DevicesDivName = "";
	var DescriptionDivName = "";

	if(VarFilterApplyRange == "ALLDEVICE")
	{
		if (ChildListArray[0].TemplateInst == 0)
		{
			DevicesDivName = "tabdevice_" + 0 + "_0";
			DescriptionDivName = "tabdevice_" + 0 + "_1";
			SetDivValue(DevicesDivName, parentalctrl_language["bbsp_allDevice"]);
			SetDivValue(DescriptionDivName, "--");
			document.getElementById('tabdevice_record_'+ 0).style.display = "";
		}
		else
		{
			for (var i = 0; i < ChildListMax; i++)
			{
				var tr = document.getElementById('tabdevice_record_'+ i);
				tr.style.display = "";
			}

			if (ChildListArray[0].TemplateInst == recordTemplatesList.TemplateId)
			{
				DevicesDivName = "tabdevice_" + m + "_0";
				DescriptionDivName = "tabdevice_" + m + "_1";
				SetDivValue(DevicesDivName, parentalctrl_language["bbsp_allDevice"]);
				SetDivValue(DescriptionDivName, ChildListArray[0].Description);
				m++;
				Deviceflag =1;
			}

			if (0 == Deviceflag)
			{
				DevicesDivName = "tabdevice_" + 0 + "_0";
				DescriptionDivName = "tabdevice_" + 0 + "_1";
				SetDivValue(DevicesDivName, "--");
				SetDivValue(DescriptionDivName, "--");
				document.getElementById('tabdevice_record_'+ 0).style.display = "";
				for (var i = 1; i < ChildListMax; i++)
				{
					var tr = document.getElementById('tabdevice_record_'+ i);
					tr.style.display = "none";
				}
			}
			else
			{
				for(var i = m; i < ChildListMax; i++)
				{
					var tr = document.getElementById('tabdevice_record_'+ i);
					tr.style.display = "none";
				}
			}
		}
	}
	else
	{
		if (ChildListArray.length - 1 <= 0)
		{
			DevicesDivName = "tabdevice_" + 0 + "_0";
			DescriptionDivName = "tabdevice_" + 0 + "_1";
			SetDivValue(DevicesDivName, "--");
			SetDivValue(DescriptionDivName, "--");
			document.getElementById('tabdevice_record_'+ 0).style.display = "";
		}
		else
		{
			for (var i = 0; i < ChildListMax; i++)
			{
				var tr = document.getElementById('tabdevice_record_'+ i);
				tr.style.display = "";
			}

			for (var i = 0; i < ChildListArray.length - 1; i++)
			{
				if (ChildListArray[i].TemplateInst == recordTemplatesList.TemplateId)
				{
					DevicesDivName = "tabdevice_" + m + "_0";
					DescriptionDivName = "tabdevice_" + m + "_1";
					SetDivValue(DevicesDivName, ChildListArray[i].MACAddress);
					if (ChildListArray[i].Description == "")
					{
						SetDivValue(DescriptionDivName, "--");
					}
					else
					{
						SetDivValue(DescriptionDivName, GetStringContent(ChildListArray[i].Description, 64));
					}
					m++;
					Deviceflag =1;
				}
			}

			if (0 == Deviceflag)
			{
				DevicesDivName = "tabdevice_" + 0 + "_0";
				DescriptionDivName = "tabdevice_" + 0 + "_1";
				SetDivValue(DevicesDivName, "--");
				SetDivValue(DescriptionDivName, "--");
				document.getElementById('tabdevice_record_'+ 0).style.display = "";
				for (var i = 1; i < ChildListMax; i++)
				{
					var tr = document.getElementById('tabdevice_record_'+ i);
					tr.style.display = "none";
				}
			}
			else
			{
				for(var i = m; i < ChildListMax; i++)
				{
					var tr = document.getElementById('tabdevice_record_'+ i);
					tr.style.display = "none";
				}
			}
		}
	}

}

function setCtlDisplayTemplate(recordTemplatesList)
{
	if (recordTemplatesList.domain == '')
	{
		SetDivValue("DivTemplateName","");
		SetDivValue("DivTemplateStartDate","--");
		SetDivValue("DivTemplateEndDate","--");
		SetDivValue("DivTemplateDevices","--");
		SetDivValue("DivTemplateDescription","--");
		SetDivValue("DivTemplateTime","--");
		SetDivValue("DivTemplateRepeatDay","--");
	}
	else
	{
		showUrlListByTemplate(recordTemplatesList.domain);
		SetDivValue("DivTemplateName",GetStringContent(recordTemplatesList.Name,32));

		if (recordTemplatesList.StartDate == "")
		{
			SetDivValue("DivTemplateStartDate","--");
		}
		else
		{
			SetDivValue("DivTemplateStartDate",DisplayDate(recordTemplatesList.StartDate));
		}
		if (recordTemplatesList.EndDate == "")
		{
			SetDivValue("DivTemplateEndDate","--");
		}
		else
		{
			SetDivValue("DivTemplateEndDate",DisplayDate(recordTemplatesList.EndDate));
		}

		setCtlDisplayDuration(recordTemplatesList);
		setCtlDisplayDeviceBind(recordTemplatesList);
		var UrlEnable = GetTemplateUrlEnable(recordTemplatesList.TemplateId);
		if ((recordTemplatesList.UrlFilterPolicy == 0) || ('0' == UrlEnable))
		{
			SetDivValue("DivTemplateUrlTitle",parentalctrl_language["bbsp_disabledurl"]);
		}
		else
		{
			SetDivValue("DivTemplateUrlTitle",parentalctrl_language["bbsp_enabledurl"]);
		}
	}
}

function DeleteLineRow()
{
	var tableRow = getElementById("TableTemplateList");
	if (tableRow.rows.length > 2)
	tableRow.deleteRow(tableRow.rows.length-1);
	return false;
}

function setControl(index, LineId)
{
	var record;
	selctIndex = index;
	var TableId = LineId.split('_')[0];

	if ('TableTemplateList' != TableId)
	{
		return;
	}
	if (index == -1)
	{
		if (TemplatesListArray.length - 1 >= TemplateListMax)
		{
			DeleteLineRow();
			AlertEx(parentalctrl_language['bbsp_maxtemplate']);
			setDisplay('DivTemplateConfigForm', 0);
			setDisplay("DivTemplateConfigStep1",0);
			adjustParentHeight();
			return;
		}
		else
		{
			recordTemplatesList = new TemplatesListClass('','','','','','');
			setDisplay('DivTemplateConfigForm', 0);
			setDisplay("DivTemplateConfigStep1",1);
			adjustParentHeight();
		}
	}
	else if (index == -2)
	{
		setDisplay('DivTemplateConfigForm', 0);
		setDisplay("DivTemplateConfigStep1",0);
	}
	else
	{
		recordTemplatesList = TemplatesListArray[index];
		setDisplay('DivTemplateConfigForm', 1);
		setDisplay("DivTemplateConfigStep1",0);
		setCtlDisplayTemplate(recordTemplatesList);
	}

//	adjustParentHeight();
}

function IsTemplateIdBind(idx)
{
	var templateId = TemplatesListArray[idx].TemplateId;
	if(VarFilterApplyRange == "ALLDEVICE")
	{
		if (templateId == ChildListArray[0].TemplateInst)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	else
	{
		if (ChildListArray.length == 1)
		{
			return false;
		}
		else if (ChildListArray.length > 1)
		{
			for (var i = 0; i < ChildListArray.length - 1; i++)
			{
				if (ChildListArray[i].TemplateInst == templateId)
				{
					return true;
				}
			}
		}
	}

	return false;
}

function TableTemplateListselectRemoveCnt()
{
}
function removeInst()
{
   var rml = getElement('TableTemplateListrml');
   var Onttoken = getValue('onttoken');
	if (rml == null)
	   return;

	var cnt = 0;
	var str = "";
	with (document.forms[0])
	{
		if (rml.length > 0)
		{
			for (var i = 0; i < rml.length; i++)
			{
				if (rml[i].checked == true)
				{
					cnt++;
					if (cnt >1)
					{
						str +='&';
					}
					str += rml[i].value + '=' + '';
				}
			}
		}
		else if (rml.checked == true)
		{
			 str += rml.value + '=' + '';
			 cnt++;
		}
	}

   str += '&x.X_HW_Token=' + Onttoken;
   var action = '';
	action = 'del.cgi?';

	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		data : str,
		url :  action + '&RequestFile=/html/bbsp/parentalctrl/parentalctrlstatus.asp',
		error:function(XMLHttpRequest, textStatus, errorThrown)
		{
			if(XMLHttpRequest.status == 404)
			{
			}
		}
	});

}

function clickRemove()
{
	if (TemplatesListArray.length == 0)
	{
		AlertEx(parentalctrl_language['bbsp_notemplate']);
		document.getElementById("DeleteButton").disabled = false;
		return;
	}

	var rml = getElement('TableTemplateListrml');
	var noChooseFlag = true;
	if ( rml.length > 0)
	{
		 for (var i = 0; i < rml.length; i++)
		 {
			 if (rml[i].checked == true)
			 {
				 if (IsTemplateIdBind(i) == true)
				 {
					 AlertEx(parentalctrl_language['bbsp_templateused']);
					 document.getElementById("DeleteButton").disabled = false;
					 return;
				 }
				 noChooseFlag = false;
			 }
		 }
	}
	else if (rml.checked == true)
	{
		var UniqueInstIdx = 0;
		if (IsTemplateIdBind(UniqueInstIdx) == true)
		{
			AlertEx(parentalctrl_language['bbsp_template'] +TemplatesListArray[UniqueInstIdx].Name + parentalctrl_language['bbsp_templateused']);
			document.getElementById("DeleteButton").disabled = false;
			return;
		}
		noChooseFlag = false;
	}
	if ( noChooseFlag )
	{
		AlertEx(parentalctrl_language['bbsp_selecttemplate']);
		document.getElementById("DeleteButton").disabled = false;
		return ;
	}

	if (ConfirmEx(parentalctrl_language['bbsp_deltemplate']) == false)
	{
		document.getElementById("DeleteButton").disabled = false;
		return;
	}
	removeInst();
	window.parent.ClickTemplate();
}

function OnClickCBVaildDate()
{
	var ValidDateEnable = getCheckVal('cbvalidDate');
	if (ValidDateEnable == "1")
	{
		setDisable("StartDate","0");
		setDisable("EndDate","0");
	}
	else
	{
		setDisable("StartDate","1");
		setDisable("EndDate","1");
		setText('StartDate', '');
		setText('EndDate', '');
	}
}

function ToChangeDate(varDate)
{
	var strDate = "";
	var str = "";
	var dDay;
	var mMonth;

	if (varDate != "")
	{
		str = varDate.split("-");
		var mMonth = str[1];
		if(1 == str[1].length){
			mMonth = '0' + str[1];
		}
		dDay = str[2];
		if(1 == str[2].length){
			var dDay = '0' + str[2];
		}
		strDate = str[0]+mMonth+dDay;
	}
	return strDate;
}

function CheckDate(StartDate, EndDate)
{
	 if (EndDate != ""
		&& parseInt(StartDate, 10) > parseInt(EndDate, 10))
	{
		AlertEx(parentalctrl_language['bbsp_startdateinvalid']);
		return false;
	}
	if (StartDate == "" && EndDate != "" )
	{
		AlertEx(parentalctrl_language['bbsp_startdateisreq']);
		return false;
	}
	return true;
}

function IsRepeateConfig(TemplateName)
{
	for (var i = 0; i < TemplatesListArray.length - 1; i++)
	{
		if (TemplateName == TemplatesListArray[i].Name)
		{
			return true;
		}
	}
	return false;
}
function CheckDateManualInput(StartDate, EndDate)
{
	if(false == CheckDateIsValid(StartDate)){
		AlertEx(parentalctrl_language['bbsp_stimeformatinvaild']);
		return false;
	}
	if(false == CheckDateIsValid(EndDate)){
		AlertEx(parentalctrl_language['bbsp_etimeformatinvaild']);
		return false;
	}
	return true;
}
function OnClickBtnStep1Apply()
{
	var CfgName = getValue('CfgName');
	CfgName = removeSpaceTrim(CfgName);
	var ValidDateEnable = getCheckVal('cbvalidDate');
	var StartDate = getValue('StartDate');
	var EndDate = getValue('EndDate');

	if(CfgName == "")
	{
		AlertEx(parentalctrl_language['bbsp_templatenameisreq']);
		return false;
	}

	if((CfgName!='')&&(isValidAscii(CfgName)!= ''))
	{
		AlertEx(parentalctrl_language['bbsp_templatenameinvalid']);
		return false;
	}

	if (IsRepeateConfig(CfgName) == true)
	{
		AlertEx(parentalctrl_language['bbsp_templatenameisexit']);
		return false;
	}

	var Form = new webSubmitForm();
	Form.addParameter('x_SAVE_A.Name',CfgName);
	if (ValidDateEnable == "1")
	{
		if (true != CheckDateManualInput(StartDate,EndDate))
		{
			return false;
		}
		StartDate = ToChangeDate(StartDate);
		EndDate = ToChangeDate(EndDate);
		if (CheckDate(StartDate, EndDate) == false)
		{
			return false;
		}
		Form.addParameter('x_SAVE_A.StartDate',StartDate);
		Form.addParameter('x_SAVE_A.EndDate',EndDate);
	}
	else
	{
		Form.addParameter('x_SAVE_A.StartDate',"");
		Form.addParameter('x_SAVE_A.EndDate',"");
	}

	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	if( selctIndex == -1 )
	{
		Form.setAction('add.cgi?' + 'x_SAVE_A=InternetGatewayDevice.X_HW_Security.ParentalCtrl.Templates'+'&RequestFile=html/bbsp/parentalctrl/parentalctrltime.asp');
	}

	setDisable("BtnStep1Apply", "1");
	setDisable("BtnStep1Cancel", "1");
	Form.submit();
	DisableRepeatSubmit();
}

function OnClickBtnStep1Cancel()
{
	setText('CfgName', '');
	setCheck('cbvalidDate',"0");
	setText('StartDate', '');
	setText('EndDate', '');
}

function SetNameAndDate()
{
	window.location='/html/bbsp/parentalctrl/parentalctrltemplatename.asp'+'?TemplateId='+TemplatesListArray[selctIndex].TemplateId;
}

function SetTime()
{
	window.location='/html/bbsp/parentalctrl/parentalctrltime.asp'+'?TemplateId='+TemplatesListArray[selctIndex].TemplateId+'&FlagStatus=EditTemplate';
}

function SetUrl()
{
	window.location='/html/bbsp/parentalctrl/parentalctrlurl.asp'+'?TemplateId='+TemplatesListArray[selctIndex].TemplateId+'&FlagStatus=EditTemplate';
}

function OnStep1()
{
	OnClickBtnStep1Apply();
}

function LoadFrame()
{
	OnClickCBVaildDate();
}

function adjustParentHeight()
{
	var dh = getHeight(document.getElementById("DivTableInfo"));
	var dh1 = getHeight(document.getElementById("DivTemplateConfigForm"));
	var dh2 = getHeight(document.getElementById("DivTemplateConfigStep1"));
	var height = 200 + (dh != null ? dh : 0) + (dh1 != null ? dh1 : 0) + (dh2 != null ? dh2 : 0);

	window.parent.adjustParentHeight("pccframeWarpContent", height);
}


window.clearInterval(resizeTimer);
function resizeUrlListHeight(){
	var theIframe = document.getElementById('frameUrlList');
	var urlListTable = document.getElementById('frameUrlList').contentWindow.document.getElementById("DivUrlList");
	if(null == urlListTable){
		return;
	}
	var dh = getHeight(urlListTable);
	var theHeight = (dh > 0 ? dh : 0);

	if(theIframe.height != theHeight){
		theIframe.height = theHeight;
		adjustParentHeight();
	}
}
resizeTimer = window.setInterval("resizeUrlListHeight()", 200);

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody nomargin">
<div id="DivTableInfo">
<script language="JavaScript" type="text/javascript">
var PCtrTempConfiglistInfo = new Array(new stTableTileInfo("Empty","align_center width_per10","DomainBox"),
								new stTableTileInfo("bbsp_template","align_center width_per15","Name"),
								new stTableTileInfo("bbsp_isbinddevice","align_center width_per75","BindTemplate"),null);
var ColumnNum = 3;
var ShowButtonFlag = true;
var PctrTempConfigFormList = new Array();
var TableDataInfo = HWcloneObject(TemplatesListArray, 1);
for (var i = 0; i < TemplatesListArray.length - 1; i++)
{
	TableDataInfo[i].domain = TemplatesListArray[i].domain;
	TableDataInfo[i].Name = TemplatesListArray[i].Name;
	TableDataInfo[i].BindTemplate = IsBindTemplate(TemplatesListArray[i].TemplateId);
}
TableDataInfo.length = TemplatesListArray.length;
//TableDataInfo.push(null);
HWShowTableListByType(1, "TableTemplateList", ShowButtonFlag, ColumnNum, TableDataInfo, PCtrTempConfiglistInfo, parentalctrl_language, null);
</script>
</div>

<div id="DivTemplateConfigForm" style="display:none">
<div class="list_table_spread"></div>
	<form id="TableConfigInfo" style="display:block;">
		<table width="100%" border="0"  cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
				</td>
			</tr>
		</table>
		
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class='alignment_rule'><input type="button" id='BtnCfgName' name="BtnCfgName" class="NewDelbuttoncss" type="button" onClick="SetNameAndDate();" BindText="bbsp_config" style="margin-bottom: 5px;"></td>
			</tr>
		</table>
		<div class="func_title" BindText="bbsp_templatenamedate"></div>
		<table border="0" cellpadding="0" cellspacing="1"  width="100%">
			<li   id="DivTemplateName"                        RealType="HtmlText"            DescRef="bbsp_templatename"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.Name"  InitValue="Empty"/>
			<li   id="DivTemplateStartDate"                   RealType="HtmlText"            DescRef="bbsp_templatevaliddate"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.StartDate"  InitValue="Empty"/>
			<li   id="DivTemplateEndDate"                     RealType="HtmlText"            DescRef="bbsp_templateinvaliddate"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.EndDate"  InitValue="Empty"/>
		</table>
		<script>
			var TableClass = new stTableClass("width_per40", "width_per60", "ltr");
			PCtrTempConfigFormList = HWGetLiIdListByForm("TableConfigInfo", null);
			HWParsePageControlByID("TableConfigInfo", TableClass, parentalctrl_language, null);
		</script>
	</form>

	<div class="func_spread"></div>
	<table  width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td class='alignment_rule'><input type="button" id='BtnCfgTime'  name="BtnCfgTime" class="NewDelbuttoncss" onClick="SetTime();" BindText="bbsp_config" style="margin-bottom: 5px;"></td>
		</tr>
	</table>
	<div class="func_title" BindText="bbsp_allownettime"></div>
	<script language="JavaScript" type="text/javascript">
		var PCTTimeConfiglistInfo = new Array(new stTableTileInfo("bbsp_duration","align_center width_per40","TemplateTime"),
										new stTableTileInfo("bbsp_repeat","align_center width_per60","TemplateRepeatDay"),null);
		var ColumnNum = 2;
		var ShowButtonFlag = false;
		var PCTTimeConfigFormList = new Array();
		var PCTTimeTableDataInfo = new Array();
		if(DurationListArray.length -1 <= 0)
		{
			PCTTimeTableDataInfo.push(new TimeShowClass("--","--"));
		}
		else
		{
			for (var i = 0; i < DurationListMax ; i++)
			{
				PCTTimeTableDataInfo.push(new TimeShowClass("",""));
			}
		}
		PCTTimeTableDataInfo.push(null);
		HWShowTableListByType(1, "TabTime", ShowButtonFlag, ColumnNum, PCTTimeTableDataInfo, PCTTimeConfiglistInfo, parentalctrl_language, null);
	</script>
	<div class="func_spread"></div>
	<table  width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
		<td class='alignment_rule'><input type="button" id='BtnCfgUrl'  name="BtnCfgUrl" class="NewDelbuttoncss" onClick="SetUrl();" BindText="bbsp_config" style="margin-bottom: 5px;"></td>
		</tr>
	</table>
	<div id="DivTemplateUrlTitle" class="func_title" BindText=""></div>
	<iframe id="frameUrlList" src="urlList.asp" class='width_per100' frameborder="0" marginheight="0" marginwidth="0" scrolling="no">
	</iframe>
	<div class="func_spread"></div>
	<div id="DivTemplateBindListTitle" class="func_title" BindText="bbsp_binddevicelist"></div>
	<script language="JavaScript" type="text/javascript">
		var PCTBindConfiglistInfo = new Array(new stTableTileInfo("bbsp_childlist","align_center width_per40","MACAddress"),
										new stTableTileInfo("bbsp_scription","align_center width_per60","Description"),null);
		var ColumnNum = 2;
		var ShowButtonFlag = false;
		var PCTBindConfigFormList = new Array();
		//var PCTBindTableDataInfo =  HWcloneObject(ChildListArray, 1);
		var PCTBindTableDataInfo = new Array();
		if(VarFilterApplyRange == "ALLDEVICE")
		{
			if (ChildListArray[0].TemplateInst == 0)
			{
				PCTBindTableDataInfo.push(new BindShowClass("--","--"));
			}
			else
			{
				for (var i = 0; i < ChildListMax; i++)
				{
					PCTBindTableDataInfo.push(new BindShowClass("",""));
				}
			}
		}
		else
		{
			if(ChildListArray.length -1 <= 0)
			{
				PCTBindTableDataInfo.push(new BindShowClass("--","--"));
			}
			else
			{
				for (var i = 0; i < ChildListMax; i++)
				{
					PCTBindTableDataInfo.push(new BindShowClass("",""));
				}
			}
		}
		PCTBindTableDataInfo.push(null);
		HWShowTableListByType(1, "tabdevice", ShowButtonFlag, ColumnNum, PCTBindTableDataInfo, PCTBindConfiglistInfo, parentalctrl_language, null);
	</script>
</div>

<div id="DivTemplateConfigStep1" style="display:none">
	<div class="list_table_spread"></div>
	<div id="Step1InfoBar" class="func_title" BindText="bbsp_step1"></div>
	<form id="TabCfgStep1" style="display:block">
		<table border="0" cellpadding="0" cellspacing="1"  width="100%">
				<li   id="CfgNameInfoBar"                    RealType="HorizonBar"         DescRef="bbsp_template"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/>
				<li   id="CfgName"                           RealType="TextBox"            DescRef="bbsp_template"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.Name"  Elementclass="InputCfgName"  InitValue="Empty"      MaxLength="32"/>
				<li   id="CfgDateInfoBar"                    RealType="HorizonBar"         DescRef="bbsp_validDate"          RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/>
				<li   id="cbvalidDate"                       RealType="CheckBox"           DescRef="bbsp_validDate"          RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"             InitValue="Empty" ClickFuncApp="onclick=OnClickCBVaildDate"/>
				<li   id="StartDate"                         RealType="TextBox"            DescRef="bbsp_StartDate"          RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.StartDate"  Elementclass="InputDate"  InitValue="Empty"      ClickFuncApp="onfocus=this.select"   MaxLength="10"/>
				<li   id="EndDate"                           RealType="TextBox"            DescRef="bbsp_EndDate"            RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.EndDate"    Elementclass="InputDate"  InitValue="Empty"      ClickFuncApp="onfocus=this.select"   MaxLength="10"/>
		</table>
		<script>
			TableClass = new stTableClass("width_per25", "width_per75", "ltr");
			PCTStep1ConfigFormList = HWGetLiIdListByForm("TabCfgStep1", null);
			HWParsePageControlByID("TabCfgStep1", TableClass, parentalctrl_language, null);
		</script>
		<table id="TabCfgBtnStep1" cellpadding="0" cellspacing="1" width="100%" class="table_button">
		<tr>
			<td class="table_submit" align="right">
				<button id="btnStep1" name="btnStep1" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="OnClickBtnStep1Apply();"><script>document.write(parentalctrl_language['bbsp_next']);</script></button>
			</td>
		</tr>
	   </table>
	</form>
</div>
<script>
ParseBindTextByTagName(parentalctrl_language, "td",    1);
ParseBindTextByTagName(parentalctrl_language, "div",   1);
ParseBindTextByTagName(parentalctrl_language, "input", 2);
getElById('StartDate').onclick = function ()
{	
	var oevent = window.event||arguments[0];
	var ValidDateEnable = getCheckVal('cbvalidDate');
	if (ValidDateEnable == "1")
	{
		fPopCalendar(oevent,this,this,0);
	} 
}
getElById('EndDate').onclick = function ()
{	
	var oevent = window.event||arguments[0];
	var ValidDateEnable = getCheckVal('cbvalidDate');
	if (ValidDateEnable == "1")
	{
		fPopCalendar(oevent,this,this,0);
	} 
}
</script>
</body>
</html>
