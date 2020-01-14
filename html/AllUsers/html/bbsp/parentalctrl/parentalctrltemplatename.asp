 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/parentalctrlinfo.asp"></script>
<script language="javascript" src="../common/time.asp"></script>
<title>PCCTemplateName</title>
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

var para = "";
var CurTemplateId = "";
if( window.location.href.indexOf("?") > 0)
{
	if (window.location.href.indexOf("TemplateId") != -1)
	{
		para = window.location.href.split("?"); 
		para = para[para.length -1];
		CurTemplateId = para.split("=")[1];
		FlagStatus = "EditTemplate";
	}
}

function OnClickCBVaildDate()
{
	var ValidDateEnable = getCheckVal('cbvalidDate');
	if (ValidDateEnable == "1")
	{
		setDisable("StartDate",0);
		setDisable("EndDate",0);
	}
	else
	{
		setDisable("StartDate",1);
		setDisable("EndDate",1);
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
	var index = GetIndexByTemplateId(CurTemplateId);
	for (var i = 0; i < TemplatesListArray.length - 1; i++)
	{
		if (TemplateName != TemplatesListArray[index].Name)
		{
			if (TemplateName == TemplatesListArray[i].Name)
			{
				return true;
			}
		}
	}
	return false;
}

function GetIndexByTemplateId(TemplateId)
{
	var index = "";
	for (var i = 0; i < TemplatesListArray.length - 1; i++)
	{
		if (TemplateId == TemplatesListArray[i].TemplateId)
		{
			index = i;
			return index;
		}
	}
	return index;
}

function OnClickBtnApply()
{
	var CfgName = getValue('CfgName');
	CfgName = removeSpaceTrim(CfgName);
	var ValidDateEnable = getCheckVal('cbvalidDate');
	var StartDate = getValue('StartDate');
	var EndDate = getValue('EndDate');
	var Onttoken = getValue('onttoken');
	var strdata = "";

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
	strdata += 'x.Name=' + CfgName;
	
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
		strdata += '&x.StartDate=' + StartDate + '&x.EndDate=' + EndDate;
	}
	else
	{
		strdata += '&x.StartDate=' + "" + '&x.EndDate=' + "";
	}
	
	strdata += '&x.X_HW_Token=' + Onttoken;
	
	var index = GetIndexByTemplateId(CurTemplateId);

	var action = '';
	action = 'set.cgi?x=' + TemplatesListArray[index].domain;
	
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		data : strdata,
		url :  action + '&RequestFile=html/ipv6/not_find_file.asp',
		error:function(XMLHttpRequest, textStatus, errorThrown) 
		{
			if(XMLHttpRequest.status == 404)
			{
			}
		}
	});	

	setDisable("BtnApply", "1");
	setDisable("BtnCancel", "1");
	window.location.href='/html/bbsp/parentalctrl/parentalctrltemplatename.asp'+'?TemplateId='+CurTemplateId;
}

function OnClickBtnCancel()
{
	setDiplayData();
}

function OnNameFinsh()
{
	window.location='/html/bbsp/parentalctrl/parentalctrltemplate.asp';
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

function setDiplayData()
{
	var index = GetIndexByTemplateId(CurTemplateId);
	setText('CfgName', GetStringContent(TemplatesListArray[index].Name,32));
	if ((TemplatesListArray[index].StartDate != "") && (TemplatesListArray[index].EndDate != ""))
	{
		setCheck('cbvalidDate',"1");
		setDisable('StartDate',0);
		setDisable('EndDate',0);	
		setText('StartDate', DisplayDate(TemplatesListArray[index].StartDate));
		setText('EndDate', DisplayDate(TemplatesListArray[index].EndDate));
	}
	else
	{
		setCheck('cbvalidDate',"0");
		setDisable('StartDate',1);
		setDisable('EndDate',1);	
		setText('StartDate', '');
		setText('EndDate', '');
	}
}

function LoadFrame()
{	                   
	loadlanguage();
	setDiplayData();
}
	
</script>   
</head>
<body  onLoad="LoadFrame();" class="mainbody nomargin">
<form id="TableConfigInfo" style="display:block">
	<table border="0" cellpadding="0" cellspacing="1"  width="100%"> 
		<li   id="CfgNameInfoBar"                    RealType="HorizonBar"         DescRef="bbsp_template"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/> 
		<li   id="CfgName"                           RealType="TextBox"            DescRef="bbsp_template"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.Name"   Elementclass="InputCfgName"  InitValue="Empty"      MaxLength="32"/>
		<li   id="CfgDateInfoBar"                    RealType="HorizonBar"         DescRef="bbsp_validDate"          RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/> 
		<li   id="cbvalidDate"                       RealType="CheckBox"           DescRef="bbsp_validDate"          RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"             InitValue="Empty" ClickFuncApp="onclick=OnClickCBVaildDate"/>
		<li   id="StartDate"                         RealType="TextBox"            DescRef="bbsp_StartDate"          RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.StartDate"   Elementclass="InputDate"  InitValue="Empty"   ClickFuncApp="onfocus=this.select"   MaxLength="10"/>
		<li   id="EndDate"                           RealType="TextBox"            DescRef="bbsp_EndDate"            RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.EndDate"   Elementclass="InputDate"  InitValue="Empty"     ClickFuncApp="onfocus=this.select"   MaxLength="10"/>
	</table>
	<script>
		var TableClass = new stTableClass("width_per25", "width_per75", "ltr");
		PCtrTempNameConfigFormList = HWGetLiIdListByForm("TableConfigInfo", null);
		HWParsePageControlByID("TableConfigInfo", TableClass, parentalctrl_language, null);
	</script>
	<table id="ConfigPanelButtons" width="100%" cellspacing="1" class="table_button"> 
	  <tr> 
		<td class="table_submit" style = "text-align:center;"> 
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
			<button id="BtnApply"  type="button" onclick="OnClickBtnApply();" class="ApplyButtoncss buttonwidth_100px" ><script>document.write(parentalctrl_language['bbsp_app']);</script></button>
			<button id="BtnCancel" type="button" onclick="OnClickBtnCancel();" class="CancleButtonCss buttonwidth_100px" ><script>document.write(parentalctrl_language['bbsp_cancel']);</script></button> 
		</td> 
	  </tr>         
	</table>

	<table cellpadding="0" cellspacing="0"  width="100%" class="table_button"> 
		<tr> 
		  <td width="90%"></td>
		  <td class="align_right table_submit" style="text-align:center">
			   <button type="button" id='ButtonFinsh' onclick="OnNameFinsh();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(parentalctrl_language['bbsp_return']);</script> </button>
		  </td>
		</tr> 
    </table> 
</form>
<script>
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
