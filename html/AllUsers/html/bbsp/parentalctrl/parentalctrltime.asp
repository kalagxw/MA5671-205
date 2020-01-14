<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>PCC</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="javascript" src="../common/userinfo.asp"></script>
<script language="javascript" src="../common/parentalctrlinfo.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<style>
.InputTime
    {
        width:18px;  
    }
.nomargin {
	margin-left: 0px;
	margin-right:0px;
	margin-top: 0px;
}
</style>
<script language="JavaScript" type="text/javascript">

var selctIndex = -1;
var FlagStatus = "";
var DurationListMax = 4;
var LastAddInst = "<%HW_WEB_GetLastAddInstNum();%>";

var para = "";
var paraTemplate = "";
var paraFlagStatus = "";
var CurTemplateId = "";
if( window.location.href.indexOf("?") > 0)
{
	if (window.location.href.indexOf("TemplateId") != -1)
	{
		para = window.location.href.split("?"); 
		para = para[para.length -1];
		paraTemplate = para.split("&")[0];
		paraFlagStatus = para.split("&")[1];
		CurTemplateId = paraTemplate.split("=")[1];
		FlagStatus = paraFlagStatus.split("=")[1];
	}
	else
	{
		para = LastAddInst.split(";");
		para = para[para.length -1];
		CurTemplateId = para.split(":")[1];
		FlagStatus = "AddTemplate";
	}
}


var DurationList = GetDurationList();

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

function LoadFrame()
{
	if (DurationList.length -1 == 0)
	{
		selectLine('record_no');
	}
	else
	{
		selectLine('record_0');
	} 
	
	loadlanguage();
	if (FlagStatus == "AddTemplate")
	{
		SetDivValue("DivTimedurationTitle",parentalctrl_language['bbsp_step2']);
		document.getElementById("buttonTime").innerHTML = parentalctrl_language['bbsp_next'];
	}
	else if (FlagStatus == "EditTemplate")
	{
		SetDivValue("DivTimedurationTitle",parentalctrl_language['bbsp_accesstimeduration']);
		document.getElementById("buttonTime").innerHTML = parentalctrl_language['bbsp_return'];
	}
	

}

function HourTimeEx(StrTime)
{
	var valueEx = StrTime.split(':');
	var strH = valueEx[0];
	return strH;

}

function MinTimeEx(StrTime)
{
	var valueEx = StrTime.split(':');
	var strM = valueEx[1];
	return strM;
}

function getDayIndex(day) 
{
	var Index = "";
	switch(day)
	{
		case '0':
			Index = 0;
			break;
		case '7':
			Index = 1;
			break;
		case '1':
			Index = 2;
			break;
		case '2':
			Index = 3;
			break;
		case '3':
			Index = 4;
			break;
		case '4':
			Index = 5;
			break;
		case '5':
			Index = 6;
			break;
		case '6':
			Index = 7;
			break;
		default:
			break;
	}
	return Index;
}

function RepeatDayEx(strRepeatDay, nIndex)
{
	var daySelArray = document.getElementsByName("AccessDay");
	for(var i = 0; i < daySelArray.length; i++)
	{
		setDisable(daySelArray[i].id, 0);
		daySelArray[i].checked = false;
	}
	if(nIndex == 0)
	{
	}
	if(nIndex == 1)
	{
		strRepeatDay = strRepeatDay.replace(/[,]/g,""); 
		for(var j = 0 ; j < strRepeatDay.length ; j++)
		{
			var ch = strRepeatDay.charAt(j);
			var index = getDayIndex(ch);
			var newid = index -1;
			daySelArray[newid].checked = true;
		}
	}   
}

function RepeatDayCount(strRepeatDay)
{
	var DayString ='';
	for ( var i = 0 ; i < strRepeatDay.length ; i++ )
    {
        var ch = strRepeatDay.charAt(i);
        if ( ch == 1 )
        {
            DayString += parentalctrl_language['bbsp_Monday'] + "/";
        }
        else if (ch == 2)
      	{
      		DayString += parentalctrl_language['bbsp_Tuesday'] + "/";
      	}
      	else if(ch == 3)
      	{
      		DayString += parentalctrl_language['bbsp_Wednesday'] + "/";
      	}
      	else if(ch == 4)
      	{
      		DayString += parentalctrl_language['bbsp_Thursday'] + "/";
      	}
      	else if(ch == 5)
      	{
      		DayString += parentalctrl_language['bbsp_Friday'] + "/";
      	}
      	else if(ch == 6)
      	{
      		DayString += parentalctrl_language['bbsp_Saturday'] + "/";
      	}
      	else if(ch == 7)
      	{
      		DayString += parentalctrl_language['bbsp_Sunday'] + "/";
      	}
    }
    DayString = DayString.substring(0,DayString.lastIndexOf('/'));
    return DayString;
}

function parseTime(str)
{
	if(str.length == 1)
	{
		str = '0' + str;
	}
	return str;
}

function CheckParameter()
{
	var strStartHour = getValue('StartHour');
	var strStartMin = getValue('StartMinute');
	var strEndHour = getValue('EndHour');
	var strEndMin = getValue('EndMinute');
	var daySelArray = document.getElementsByName("AccessDay");
	var strRepeatDay = "";
	
	if(isValidNumber(strStartHour))
	{
		strStartHour = parseTime(strStartHour);
	}
	if(isValidNumber(strStartMin))
	{
		strStartMin = parseTime(strStartMin);
	}
	if(isValidNumber(strEndHour))
	{
		strEndHour = parseTime(strEndHour);
	}
	if(isValidNumber(strEndMin))
	{
		strEndMin = parseTime(strEndMin);
	}
	
	var strStartTime = strStartHour +":" + strStartMin; 
	var strEndTime = strEndHour +":" + strEndMin;
	
	if(!isValidNumber(strStartHour) || !isValidNumber(strStartMin))
	{
		AlertEx(parentalctrl_language['bbsp_stimeformatinvaild']);
		return false;
	}
	
	if(!isValidNumber(strEndHour) || !isValidNumber(strEndMin))
	{
		AlertEx(parentalctrl_language['bbsp_etimeformatinvaild']);
		return false;
	}
	
	if(!isValidHour(strStartHour) || !isValidHour(strEndHour))
	{
		AlertEx(parentalctrl_language['bbsp_htimerangeinvaild']);
		return false;
	}
	
	if(!isValidMinute(strStartMin) || !isValidMinute(strEndMin))
	{
		AlertEx(parentalctrl_language['bbsp_mtimerangeinvalid']);
		return false;
	}
	
	if(!isValidTimeDuration(strStartHour, strStartMin, strEndHour, strEndMin))
	{
		AlertEx(parentalctrl_language['bbsp_timedurationinvalid']);
		return false;
	}

	if(!CheckDaySelect(daySelArray))
	{
		AlertEx(parentalctrl_language['bbsp_selectrepeatday']);
		return false;
	}

	for(var i = 0; i < daySelArray.length; i++)
	{
		if(daySelArray[i].checked == true)
		{
			strRepeatDay += daySelArray[i].value + ",";
		}
	}
	strRepeatDay = strRepeatDay.substring(0,strRepeatDay.lastIndexOf(','));

	for (var j = 0; j < DurationList.length-1; j++)
	{
		if (selctIndex != j)
		{
			if (DurationList[j].TemplateId == CurTemplateId)
			{
				if ((strStartTime == DurationList[j].StartTime) && (strEndTime == DurationList[j].EndTime) && (strRepeatDay == DurationList[j].RepeatDay) )
				{
					AlertEx(parentalctrl_language['bbsp_timedurationrepeat']);
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


function CheckDaySelect(dayArray)
{
	var index = 0;
	for(var i = 0; i < dayArray.length; i++)
	{
		if(!dayArray[i].checked)
		{
			index++;
			continue;	
		}
	}
	if(index == (dayArray.length))
	{
		return false;
	}
	return true;
}

function DeleteLineRow()
{
	var tableRow = getElementById("PCCInfo");
	if (tableRow.rows.length > 2)
	tableRow.deleteRow(tableRow.rows.length-1);
	return false;
}

function GetSelectIdByIndex(Index)
{
	var domain = getValue('PCCInfo_rml'+Index);
	for(var i = 0; i < DurationList.length - 1; i++)
	{
		if (DurationList[i].domain == domain)
		{
			return i;
		}
	}
	return -1;
}

function GetOneDurationNum(CurTemplateId)
{
	var num = 0;
	for (var i = 0; i < DurationList.length -1; i++)
	{
		if (DurationList[i].TemplateId == CurTemplateId)
		{
			num++;
		}
	}
	
	return num;
}

function setControl(Index)
{
	selctIndex = Index;
	
	if (Index < -1)
	{
		return;
	}
	if (Index == -1)
	{
		if(GetOneDurationNum(CurTemplateId) >= DurationListMax)
		{
			DeleteLineRow();
			AlertEx(parentalctrl_language['bbsp_timedurationfull']);
			setDisplay('ConfigPanel', 0);
			return;
		}
		else
		{
			setDisable('StartHour',0);
		  	setDisable('StartMinute',0);
		  	setDisable('EndHour',0);
		  	setDisable('EndMinute',0);
		  	setCheck('AllDay',0);
			setText('StartHour', '');
			setText('StartMinute', '');
			setText('EndHour', '');
			setText('EndMinute', '');
			RepeatDayEx('',0);
			setDisplay("ConfigPanel", "1"); 
		}
	}
	else
	{ 
		setDisplay("ConfigPanel", "1");
		setDisable('StartHour',0);
		setDisable('StartMinute',0);
		setDisable('EndHour',0);
		setDisable('EndMinute',0);
		setCheck('AllDay',0);
		var Id = GetSelectIdByIndex(Index);
		setText('StartHour',HourTimeEx(DurationList[Id].StartTime));
		setText('StartMinute',MinTimeEx(DurationList[Id].StartTime));
		setText('EndHour',HourTimeEx(DurationList[Id].EndTime));
		setText('EndMinute',MinTimeEx(DurationList[Id].EndTime));
		RepeatDayEx(DurationList[Id].RepeatDay,1);
	}
}

function PCCInfoselectRemoveCnt(val)
{

}

function clickRemove()
{        
	var SelectCount = 0;

	if(0 == GetOneDurationNum(CurTemplateId))
	{
		AlertEx(parentalctrl_language['bbsp_notimerule']);
		return false;
	}
	
	var Form = new webSubmitForm();
	var str = "";
	var Onttoken = getValue('onttoken');
	for (var i = 0; i < DurationList.length-1; i++)
	{
		if (getCheckVal("PCCInfo_rml"+i) == "1")
		{
			SelectCount++;
			var Id = GetSelectIdByIndex(i);
			if (SelectCount > 1)
			{
				str +='&';
			}
			str += getValue("PCCInfo_rml"+i) + '=' + '';
		}
	}
	str += '&x.X_HW_Token=' + Onttoken;
	if (SelectCount == 0)
	{				
		AlertEx(parentalctrl_language['bbsp_selecttimeduration']);
		return false;
	}
	
    setDisable("ButtonApply", 1);
    setDisable("ButtonCancel", 1);
	
	var action = '';
	action = 'del.cgi?';

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
	window.location='/html/bbsp/parentalctrl/parentalctrltime.asp'+'?TemplateId='+CurTemplateId+'&FlagStatus='+FlagStatus;   
}


function isValidHour(val)
{
	if((isValidNumber(val) == true) && (parseInt(val,10) < 24))
	{
		return true;
	}
	return false;
}

function isValidMinute(val)
{
	if((isValidNumber(val) == true) && (parseInt(val,10) < 60))
	{
		return true;
	}
	return false;
}

function isValidTimeDuration(startHour, startMin, endHour, endMin)
{
	if(parseInt(startHour,10) < parseInt(endHour,10))
	{
		return true;
	}
	else if((parseInt(startHour,10) == parseInt(endHour,10)) && (parseInt(startMin,10) < parseInt(endMin,10)))
	{
		return true;
	}
	else
	{
		return false;
	}
}

function isValidNumber(number)
{
	var numberLen = number.length;
	if(numberLen != 2 && numberLen != 1)
	{
		return false;
	}
	for(var i = 0 ; i < numberLen ; i++)
	{
		if(!isDecDigit(number.charAt(i)))
		{
			return false;
		}
	}
	return true;
}

function isDecDigit(digit) 
{
   var decVals = new Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9");
   var len = decVals.length;
   var i = 0;
   var ret = false;

   for ( i = 0; i < len; i++ )
      if ( digit == decVals[i] ) break;

   if ( i < len )
      ret = true;
   return ret;
}

function OnAllDayClick(AllDayControl)
{
	var checked = AllDayControl.checked;
	if(checked == true)
	{
	 	document.getElementById("StartHour").value = "00"; 
	   	document.getElementById("StartMinute").value = "00"; 
	   	document.getElementById("EndHour").value = "23";
	   	document.getElementById("EndMinute").value = "59";
	   	setDisable('StartHour',1);
	   	setDisable('StartMinute',1);
	   	setDisable('EndHour',1);
	   	setDisable('EndMinute',1);
	}
	else
	{
	   	document.getElementById("StartHour").value = ""; 
	   	document.getElementById("StartMinute").value = ""; 
	   	document.getElementById("EndHour").value = "";
	   	document.getElementById("EndMinute").value = "";
	   	setDisable('StartHour',0);
	   	setDisable('StartMinute',0);
	   	setDisable('EndHour',0);
	   	setDisable('EndMinute',0);
	}
}

function OnDaySelectClick(EveryDayControl)
{
	var checked = EveryDayControl.checked;
	var daySelArray = document.getElementsByName("AccessDay");
	if(checked)
	{
	   for(var i = 0; i < daySelArray.length; i++)
	   {
			daySelArray[i].checked = true;
			setDisable(daySelArray[i].id , 1);
	   }
	}
	else
	{
		for(var i = 0; i < daySelArray.length; i++)
	   	{
		  	daySelArray[i].checked = false;
			setDisable(daySelArray[i].id , 0);
	   	}
	}
}
	

function OnApplyButtonClick()
{
	if(!CheckParameter())
	{
		return false;
	}
	
 	var StartHour = getValue('StartHour');
	var StartMin = getValue('StartMinute');
	var EndHour = getValue('EndHour');
	var EndMin = getValue('EndMinute');
	var Onttoken = getValue('onttoken');
	var dayArray = document.getElementsByName("AccessDay");
	var StartTimeStr = "";
	var EndTimeStr = "";
	var RepeatDayStr = "";
	StartHour = parseTime(StartHour);
 	StartMin = parseTime(StartMin);
  	EndHour = parseTime(EndHour);
  	EndMin = parseTime(EndMin);
 
	StartTimeStr = StartHour + ":" + StartMin;
	EndTimeStr = EndHour + ":" + EndMin;
	
	for(var i = 0; i < dayArray.length; i++)
	{
		if(dayArray[i].checked == true)
		{
			RepeatDayStr += dayArray[i].value + ",";
		}
	}
	RepeatDayStr = RepeatDayStr.substring(0,RepeatDayStr.lastIndexOf(','));
	
	var Id = GetSelectIdByIndex(selctIndex);
	var action = '';
	if( selctIndex == -1 )
	{
		action = 'add.cgi?x=InternetGatewayDevice.X_HW_Security.ParentalCtrl.Templates.' + CurTemplateId + ".Duration";
	}
	else
	{
		action = 'set.cgi?x=' + DurationList[Id].domain;
	}
	
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		data : 'x.StartTime=' + StartTimeStr + '&x.EndTime=' + EndTimeStr + '&x.RepeatDay=' + RepeatDayStr + '&x.X_HW_Token=' + Onttoken,
		url :  action + '&RequestFile=html/ipv6/not_find_file.asp',
		error:function(XMLHttpRequest, textStatus, errorThrown) 
		{
			if(XMLHttpRequest.status == 404)
			{
			}
		}
	});	
	
	setDisable("ButtonApply", 1);
    setDisable("ButtonCancel", 1);
	window.location.href='/html/bbsp/parentalctrl/parentalctrltime.asp'+'?TemplateId='+CurTemplateId+'&FlagStatus='+FlagStatus;
}

function OnCancelButtonClick()
{   
	if (selctIndex == -1)
	{
		var tableRow = getElement("PCCInfo");
		if (tableRow.rows.length == 1)
		{
		}
		else if (tableRow.rows.length == 2)
		{
			//addNullInst('PCC');
			setDisplay("ConfigPanel", "0");
		}   
		else
		{
			tableRow.deleteRow(tableRow.rows.length-1);
			selectLine('record_0');
		}
	}
	else
	{
		selectLine('record_' + selctIndex);
	}
}
 
function OnTimeButton()
{
	if (FlagStatus == "AddTemplate")
	{
		window.location='/html/bbsp/parentalctrl/parentalctrlurl.asp';
	}
	else if (FlagStatus == "EditTemplate")
	{
		window.location='/html/bbsp/parentalctrl/parentalctrltemplate.asp'+'?TemplateId='+CurTemplateId;
	}
}	

function InitTableData()
{
	var num = GetOneDurationNum(CurTemplateId);
	var k = 0;
	for (var i = 0; i < DurationList.length -1; i++)
	{
		if (DurationList[i].TemplateId == CurTemplateId)
		{
			TableDataInfo[k] = new DurationListClass();
			TableDataInfo[k].domain = DurationList[i].domain;
			TableDataInfo[k].Duration = DurationList[i].StartTime + '-' + DurationList[i].EndTime;
			TableDataInfo[k].RepeatDay = RepeatDayCount(DurationList[i].RepeatDay);
			k++;
		}
	}
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody nomargin"> 
<table>
<table width="100%" class="func_title"  cellpadding="0" cellspacing="0" id="PCCTimeTitle"> 
  <tr> 
    <td class="align_left">
		<div id="DivTimedurationTitle"></div>
	</td> 
  </tr> 
</table> 
<script language="JavaScript" type="text/javascript">
	var TableClass = new stTableClass("width_per20", "width_per80", "ltr");
	var PCtrTimeConfiglistInfo = new Array(new stTableTileInfo("Empty","align_center width_per10","DomainBox"),
                                    new stTableTileInfo("Empty","align_center ","Duration"),
									new stTableTileInfo("bbsp_accesstimeduration","align_center width_per70","RepeatDay"),
									null);
	var ColumnNum = 3;
	var ShowButtonFlag = true;
	var PtrTimeConfigFormList = new Array();
	var TableDataInfo = new Array();
	InitTableData();
	TableDataInfo.push(null);
	HWShowTableListByType(1, "PCCInfo", ShowButtonFlag, ColumnNum, TableDataInfo, PCtrTimeConfiglistInfo, parentalctrl_language, null);
</script>
 
  <div id="ConfigPanel" style="display:none"> 
   <div class="list_table_spread"></div>
	<form id="TableConfigInfo" style="display:block"> 
		<table border="0" cellpadding="0" cellspacing="1"  width="100%"> 
		<li   id="AccessTimeInfoBar"                    RealType="HorizonBar"         DescRef="bbsp_accesstimedurationmh1"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/> 
		<li   id="AllDay"     RealType="CheckBox"         DescRef="bbsp_allday"    RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"        InitValue="Empty"   ClickFuncApp="onclick=OnAllDayClick"/>
		<li   id="StartHour"           RealType="TextOtherBox"       DescRef="bbsp_starttime"             RemarkRef="Empty"    			ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.StartTime"   Elementclass="InputTime"  MaxLength="2"  
		InitValue="[{Type:'span',Item:[{AttrName:'id',AttrValue:'startColon'}]},
					{Type:'input',Item:[{AttrName:'id',AttrValue:'StartMinute'},{AttrName:'BindFileld', AttrValue:'Empty'},{AttrName:'MaxLength', AttrValue:'2'},{AttrName:'class', AttrValue:'InputTime'}]},
				    {Type:'span',Item:[{AttrName:'innerhtml', AttrValue:'bbsp_timeremark'},{AttrName:'class', AttrValue:'gray'}]}]"/>
		<li   id="EndHour"           RealType="TextOtherBox"       DescRef="bbsp_endtime"             RemarkRef="Empty"    			ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.EndTime"   Elementclass="InputTime"  MaxLength="2"  
		InitValue="[{Type:'span',Item:[{AttrName:'id',AttrValue:'endColon'}]},
					{Type:'input',Item:[{AttrName:'id',AttrValue:'EndMinute'},{AttrName:'BindFileld', AttrValue:'Empty'},{AttrName:'MaxLength', AttrValue:'2'},{AttrName:'class', AttrValue:'InputTime'}]},
				    {Type:'span',Item:[{AttrName:'innerhtml', AttrValue:'bbsp_timeremark'},{AttrName:'class', AttrValue:'gray'}]}]"/>
		<li   id="RepeatInfoBar"                    RealType="HorizonBar"         DescRef="bbsp_repeatday1"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/> 
		<li   id="EveryDay"     RealType="CheckBox"         DescRef="bbsp_everyday"    RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"        InitValue="0"   ClickFuncApp="onclick=OnDaySelectClick"/>
		<li   id="AccessDay"           RealType="CheckBoxList"       DescRef="bbsp_repeatday1"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"    InitValue="[{TextRef:'bbsp_Sunday',Value:'7'},{TextRef:'bbsp_Monday',Value:'1'},{TextRef:'bbsp_Tuesday',Value:'2'},{TextRef:'bbsp_Wednesday',Value:'3'},{TextRef:'bbsp_Thursday',Value:'4'},{TextRef:'bbsp_Friday',Value:'5'},{TextRef:'bbsp_Saturday',Value:'6'}]" />                                                                   
		</table>
		<script language="JavaScript" type="text/javascript">
			PCtrTimeConfigFormList = HWGetLiIdListByForm("TableConfigInfo", null);
			var formid_hide_id = null;
			HWParsePageControlByID("TableConfigInfo", TableClass, parentalctrl_language, formid_hide_id);
			document.getElementById("startColon").innerHTML = '&nbsp;&nbsp;'+ parentalctrl_language['bbsp_colon'] + '&nbsp;&nbsp;';
			document.getElementById("endColon").innerHTML = '&nbsp;&nbsp;'+ parentalctrl_language['bbsp_colon'] + '&nbsp;&nbsp;';
		</script>
        <table id="ConfigPanelButtons" width="100%" cellspacing="1" class="table_button"> 
          <tr> 
            <td class="table_submit" style = "text-align:center;">
			  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
			  <button id="ButtonApply"  type="button" onclick="javascript:return OnApplyButtonClick();" class="ApplyButtoncss buttonwidth_100px" ><script>document.write(parentalctrl_language['bbsp_app']);</script></button>
              <button id="ButtonCancel" type="button" onclick="javascript:OnCancelButtonClick();" class="CancleButtonCss buttonwidth_100px" ><script>document.write(parentalctrl_language['bbsp_cancel']);</script></button> </td> 
          </tr>         
        </table>
		</form>
    </div> 
  
      	<table cellpadding="0" cellspacing="0"  width="100%" class="table_button"> 
		<tr> 
		  <td width="90%"></td>
		  <td class="align_right table_submit" style="text-align:center">
			   <button type="button" id='buttonTime' onclick="OnTimeButton();" class="ApplyButtoncss buttonwidth_100px" value=""></button>
		  </td>
		</tr> 
	 </table>  

  </table> 
</body>
</html>
