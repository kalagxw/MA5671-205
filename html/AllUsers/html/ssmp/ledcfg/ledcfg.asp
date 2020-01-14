<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>

<script language="JavaScript" type="text/javascript">
function stLedOffTimeInfo(domain,StartTime,EndTime)
{
    this.domain = domain;
    this.StartTime = StartTime;
	this.EndTime = EndTime;
}

function stDataFlowInfo(domain,Total,Alarm,Warning, Used)
{
    this.domain = domain;
    this.Total = Total;
	this.Alarm = Alarm;
	this.Warning = Warning;
	this.Used = Used;
}

var ModifyConfigDomain = "";
var stLedOffConfig = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_SSMPPDT.Deviceinfo.X_HW_LedOffTime.{i}, StartTime|EndTime, stLedOffTimeInfo);%>;
var LedInfoPaxu = new Array();

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

var ConfigLen = stLedOffConfig.length - 1;
for(var j = 0; j < ConfigLen; j++)  
{ 
	for(var i = j+1; i < ConfigLen; i++) 
	{	
		var HousValue_j = parseInt(HourTimeEx(stLedOffConfig[j].StartTime),10);
		var MinValue_j = parseInt(MinTimeEx(stLedOffConfig[j].StartTime),10);
		var ValueCalcByMin_j = HousValue_j*60 + MinValue_j;
		var HousValue_i = parseInt(HourTimeEx(stLedOffConfig[i].StartTime), 10);
		var MinValue_i = parseInt(MinTimeEx(stLedOffConfig[i].StartTime), 10);
		var ValueCalcByMin_i = HousValue_i*60 + MinValue_i;
		
		if( ValueCalcByMin_j >  ValueCalcByMin_i)        
	    {         
		    LedInfoPaxu[0] = stLedOffConfig[j];        
		    stLedOffConfig[j] = stLedOffConfig[i];        
		    stLedOffConfig[i] = LedInfoPaxu[0];        
		}
	}    
}

var EnableLedSwitch = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_SSMPPDT.Deviceinfo.X_HW_LedSwitch);%>';  

var stDataCardFlowTotal = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DATACARD_FLOW_CONFIG.Total);%>';  
var stDataCardFlowAlarm = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DATACARD_FLOW_CONFIG.Alarm);%>';  
var stDataCardFlowWarning = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DATACARD_FLOW_CONFIG.Warning);%>';  
var Feature_LTE_DATACNT_LED = "<% HW_WEB_GetFeatureSupport(BBSP_FT_DATACARDFLOW_LED_EXIST);%>";

function LoadFrame()
{	
	if ( '0' == EnableLedSwitch )
	{
		setDisplay('OffTimeConfig', 0);
		setDisplay('offtimesetbutton', 0);
		setRadio("LedSwitchEnable", "Enable");

	}
	else
	{
		setDisplay('OffTimeConfig', 1);
		setDisplay('offtimesetbutton', 1);
		setRadio("LedSwitchEnable", "Forbid");
	}	
	
	if (stLedOffConfig.length -1 == 0)
	{
		setDisplay('AddConfigPanel', 0);
		selectLine('LedPanInfo_record_no');
	}
	else
	{
		selectLine('LedPanInfo_record_0');
	} 

    setText("DatacardFlowTotal",stDataCardFlowTotal);
    setText("DatacardFlowAlarm",stDataCardFlowAlarm);
    setText("DatacardFlowWarning",stDataCardFlowWarning);
	
	setDisplay("LTEDATECNT_TBL",0);
	setDisplay("LTEDATECNT_TBL_BUT",0);
	setDisplay("LTEDATECNT_LEB",0);
	
	if(Feature_LTE_DATACNT_LED == '1')
	{
		setDisplay("LTEDATECNT_TBL",1);
		setDisplay("LTEDATECNT_TBL_BUT",1);
		setDisplay("LTEDATECNT_LEB",1);
	}
}

function GetLanguageDesc(Name)
{
    return LedcfgLgeDes[Name];
}

function SubmitFormLedEnableInfo()
{
	var Form = new webSubmitForm();
	var EnableLedSwitch = getRadioVal("LedSwitchEnable", "Enable");
	var Value
    if ("Enable" == EnableLedSwitch)
	{
	    var Value = 0;
	}
	else
    {
	    var Value = 1;
	}
	
	Form.addParameter('x.X_HW_LedSwitch', Value);
	Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_SSMPPDT.Deviceinfo&RequestFile=html/ssmp/ledcfg/ledcfg.asp');	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.submit();			  
}

function ShowLedConfigInfo(val)
{	
	if("Enable" == val)
	{	
		setDisplay('OffTimeConfig', 0);
		setDisplay('offtimesetbutton', 0);
		
	}

	SubmitFormLedEnableInfo();
}

function CancelConfig()
{	
	setDisplay('AddConfigPanel', 1);
    LoadFrame();
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

function DeleteLineRow()
{
	var tableRow = getElementById("LedPanInfo");
	if (tableRow.rows.length > 2)
	tableRow.deleteRow(tableRow.rows.length-1);
	return false;
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
		if(stLedOffConfig.length - 1 >= 4)
		{	
			DeleteLineRow();
			AlertEx(GetLanguageDesc("s1807"));
			setDisplay('AddConfigPanel', 0);
			return ;
		}
		else
		{	
			/* add */
			setDisplay('AddConfigPanel', 1);
			setText('StartHour', '');
			setText('StartMinute', '');
			setText('EndHour', '');
			setText('EndMinute', '');
		}
	}
	else
	{ 
		setDisplay('AddConfigPanel', 1);
    	setText('StartHour',HourTimeEx(stLedOffConfig[Index].StartTime));
		setText('StartMinute',MinTimeEx(stLedOffConfig[Index].StartTime));
		setText('EndHour',HourTimeEx(stLedOffConfig[Index].EndTime));
		setText('EndMinute',MinTimeEx(stLedOffConfig[Index].EndTime));
	}
}

function LedPanInfoselectRemoveCnt(obj)
{

}

function clickRemove()
{        
	var SelectCount = 0;

	if(0 == stLedOffConfig.length - 1)
	{
		AlertEx(GetLanguageDesc("s1815"));
		return false;
	}
	
	var Form = new webSubmitForm();
	
	for (var i = 0; i < stLedOffConfig.length - 1; i++)
	{
		if (getCheckVal("LedPanInfo_rml"+i) == "1")
		{
			SelectCount++;
			Form.addParameter(stLedOffConfig[i].domain, '');
		}
	}

	if (SelectCount == 0)
	{				
		AlertEx(GetLanguageDesc("s1816"));
		return false;
	}
	
	setDisable("btnApplyLed", "1");
    setDisable("cancelValueLed", "1");
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('del.cgi?RequestFile=html/ssmp/ledcfg/ledcfg.asp');   
	Form.submit();       
}

function isValidTimeDuration(startHour, startMin, endHour, endMin)
{
	if((parseInt(startHour,10) == parseInt(endHour,10)) && (parseInt(startMin,10) == parseInt(endMin,10)))
	{	
		return false;
	}

	return true;
}

function CheckNewTime(BaseStartTime, BaseEndTime, CheckStartTime, CheckEndTime)
{	
	var BaseStHTime = parseInt(HourTimeEx(BaseStartTime), 10);
	var BaseStMTime = parseInt(MinTimeEx(BaseStartTime), 10);
	var BaseStTimeCalcByMin = BaseStHTime*60 + BaseStMTime;
	
	var BaseEndHTime = parseInt(HourTimeEx(BaseEndTime), 10);
	var BaseEndMTime = parseInt(MinTimeEx(BaseEndTime), 10);
	var BaseEndTimeCalcByMin = BaseEndHTime*60 + BaseEndMTime;
	
	var CheckStHTime = parseInt(HourTimeEx(CheckStartTime), 10);
	var CheckStMTime = parseInt(MinTimeEx(CheckStartTime), 10);
	var CheckStTimeCalcByMin = CheckStHTime*60 + CheckStMTime;
	
	var CheckEndHTime = parseInt(HourTimeEx(CheckEndTime), 10);
	var CheckEndMTime = parseInt(MinTimeEx(CheckEndTime), 10);
	var CheckEndTimeCalcByMin = CheckEndHTime*60 + CheckEndMTime;
	var Value24Min = 24*60;
	
	if(CheckStTimeCalcByMin < CheckEndTimeCalcByMin)
	{	
		if(BaseStTimeCalcByMin < BaseEndTimeCalcByMin)
		{	
			if( CheckStTimeCalcByMin >= BaseEndTimeCalcByMin)
			{
				return true;
			}
			
			if(CheckEndTimeCalcByMin <= BaseStTimeCalcByMin)
			{
				return true;
			}
			return false;
		}
		else 
		{
			if(CheckEndTimeCalcByMin <= BaseStTimeCalcByMin && CheckStTimeCalcByMin >= BaseEndTimeCalcByMin)
			{
				return true;
			}

			return false;
		}
	}
	else 
	{
		if(BaseStTimeCalcByMin < BaseEndTimeCalcByMin)
		{	
			if(CheckStTimeCalcByMin >= BaseEndTimeCalcByMin && CheckEndTimeCalcByMin <= BaseStTimeCalcByMin)
			{
				return true;
			}
			
			return false;
		}
		else 
		{
			return false;
		}
	}
		
	return true;
}

function CheckParameter()
{
	var strStartHour = getValue('StartHour');
	var strStartMin = getValue('StartMinute');
	var strEndHour = getValue('EndHour');
	var strEndMin = getValue('EndMinute');
	
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
		AlertEx(GetLanguageDesc("s1810"));
		return false;
	}
	
	if(!isValidNumber(strEndHour) || !isValidNumber(strEndMin))
	{
		AlertEx(GetLanguageDesc("s1811"));
		return false;
	}
	
	if(!isValidHour(strStartHour) || !isValidHour(strEndHour))
	{
		AlertEx(GetLanguageDesc("s1812"));
		return false;
	}
	
	if(!isValidMinute(strStartMin) || !isValidMinute(strEndMin))
	{
		AlertEx(GetLanguageDesc("s1813"));
		return false;
	}
	
	if(!isValidTimeDuration(strStartHour, strStartMin, strEndHour, strEndMin))
	{
		AlertEx(GetLanguageDesc("s1814"));
		return false;
	}
	
	for (var i = 0; i < stLedOffConfig.length - 1;i++)
	{	
		if(ModifyConfigDomain == stLedOffConfig[i].domain)
		{
			continue;
		}
		
		var Result = CheckNewTime(stLedOffConfig[i].StartTime, stLedOffConfig[i].EndTime,strStartTime, strEndTime);
		if(false == Result)
		{
			AlertEx(GetLanguageDesc("s1817"));
			return false;
		}
	}
	
	return true;
}

function CheckParameterDataflow()
{
	var strDataflowTotal = removeSpaceTrim(getValue('DatacardFlowTotal'));
	var strDatacardFlowAlarm = removeSpaceTrim(getValue('DatacardFlowAlarm'));
	var strDatacardFlowWarning = removeSpaceTrim(getValue('DatacardFlowWarning'));
	
	if((isInteger(strDataflowTotal)) && (strDataflowTotal>=0) && (strDataflowTotal<4294967294))
	{
		strDataflowTotal = parseInt(strDataflowTotal);
	}
	else
	{
		AlertEx(GetLanguageDesc("s1827"));
		return false;
	}
	
	if((isInteger(strDatacardFlowAlarm)) && (strDatacardFlowAlarm>=0))
	{
		strDatacardFlowAlarm = parseInt(strDatacardFlowAlarm);
	}	
	else
	{
		AlertEx(GetLanguageDesc("s1828"));
		return false;
	}
	
	if((isInteger(strDatacardFlowWarning)) && (strDatacardFlowWarning>=0))
	{
		strDatacardFlowWarning = parseInt(strDatacardFlowWarning);
	}	
	else
	{
		AlertEx(GetLanguageDesc("s1829"));
		return false;
	}
	
	if((strDatacardFlowAlarm <= strDatacardFlowWarning) && (strDataflowTotal != 0 ))
	{
		AlertEx(GetLanguageDesc("s1823"));
		return false;
	}

	if(strDataflowTotal > 0)
	{
		AlertEx(GetLanguageDesc("s1824"));
	}
	
	return true;
}

function parseTime(str)
{
	if(str.length == 1)
	{
		str = '0' + str;
	}
	return str;
}

function SubmitFormTimeInfo()
{
	if(selctIndex >=0 )
	{
		ModifyConfigDomain = stLedOffConfig[selctIndex].domain;
	}
	
	if(!CheckParameter())
	{
		return false;
	}
	
 	var StartHour = getValue('StartHour');
	var StartMin = getValue('StartMinute');
	var EndHour = getValue('EndHour');
	var EndMin = getValue('EndMinute');
	var StartTimeStr = "";
	var EndTimeStr = "";
	StartHour = parseTime(StartHour);
 	StartMin = parseTime(StartMin);
  	EndHour = parseTime(EndHour);
  	EndMin = parseTime(EndMin);
 
	StartTimeStr = StartHour + ":" + StartMin;
	EndTimeStr = EndHour + ":" + EndMin;

	var Form = new webSubmitForm();
	Form.addParameter('x.StartTime',StartTimeStr);
	Form.addParameter('x.EndTime',EndTimeStr);
	
	setDisable("btnApplyLed", "1");
    setDisable("cancelValueLed", "1");
	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	
	if( selctIndex == -1 )
	{
  		Form.setAction('add.cgi?' + 'x=InternetGatewayDevice.X_HW_SSMPPDT.Deviceinfo.X_HW_LedOffTime' + '&RequestFile=html/ssmp/ledcfg/ledcfg.asp');
	}
	else
	{
 		Form.setAction('set.cgi?x=' + stLedOffConfig[selctIndex].domain + '&RequestFile=html/ssmp/ledcfg/ledcfg.asp');
	}
	
	Form.submit();
}

function SubmitFormDataflowInfo()
{
	if(!CheckParameterDataflow())
	{
		return false;
	}
	
	var DatacardFlowTotal = getValue('DatacardFlowTotal');
	var DatacardFlowAlarm = getValue('DatacardFlowAlarm');
	var DatacardFlowWarning = getValue('DatacardFlowWarning');
	
	DatacardFlowTotal = parseInt(DatacardFlowTotal);
 	DatacardFlowAlarm = parseInt(DatacardFlowAlarm);
  	DatacardFlowWarning = parseInt(DatacardFlowWarning);
 
	var Form = new webSubmitForm();
	Form.addParameter('x.Total',DatacardFlowTotal);
	Form.addParameter('x.Alarm',DatacardFlowAlarm);
	Form.addParameter('x.Warning',DatacardFlowWarning);

	setDisable("btnApplydataflow", "1");
    setDisable("cancelValuedataflow", "1");
	
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	
    Form.setAction('set.cgi?' + 'x=InternetGatewayDevice.X_HW_DATACARD_FLOW_CONFIG' + '&RequestFile=html/ssmp/ledcfg/ledcfg.asp');
	
	Form.submit();
}

</script>
</head>
<body class="mainbody" onLoad="LoadFrame();">
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("ledcfg", GetDescFormArrayById(LedcfgLgeDes, "s0100"), GetDescFormArrayById(LedcfgLgeDes, "s1500"), false);
</script>
<div class="title_spread"></div>  
<div class="func_title" BindText="s1501"></div>
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg"> 
  <tr> 
    <td class="table_title width_per20" BindText="s1803"></td> 
    <td class="table_right width_per15"><input type='radio' name='LedSwitchEnable' id='LedSwitchEnable' value="Enable" onclick="ShowLedConfigInfo(this.value)">
	<script>document.write(GetLanguageDesc("s1808"));</script></td> 
	<td class="table_right width_per65"><input type='radio' name='LedSwitchEnable' id='LedSwitchEnable' value="Forbid" onclick="ShowLedConfigInfo(this.value)">
	<script>document.write(GetLanguageDesc("s1809"));</script></td> 
  </tr> 
</table>
<div id="OffTimeConfig" name="OffTimeConfig" class="z_index_2">
<div class="func_spread"></div> 
<div class="func_title" BindText="s1818"></div>
<form id="ConfigForm">
	<script type="text/javascript">
		var ledConfiglistInfo = new Array(new stTableTileInfo("Empty",null,"DomainBox"),
											new stTableTileInfo("s1801",null,"StartTime"),
											new stTableTileInfo("s1802",null,"EndTime"),null);

		var ColumnNum = 3;
		var TableDataInfo =  HWcloneObject(stLedOffConfig, 1);
		setDisplay("OffTimeConfig", EnableLedSwitch);
		HWShowTableListByType(EnableLedSwitch, "LedPanInfo", 1, ColumnNum, TableDataInfo, ledConfiglistInfo, LedcfgLgeDes, null);
	</script>

<div id="AddConfigPanel">
<div class="list_table_spread"></div>  
<table cellpadding="0" cellspacing="1" class="tabal_bg" width="100%"> 
<tr class='height20p'> 
<td class="table_title width_per20 align_left" nowrap="nowrap" BindText='s1804'></td> 
<td class="table_right align_left">
<span><script>document.write('&nbsp;&nbsp;&nbsp;' + GetLanguageDesc("s1801"));</script></span>
<input type="text" id="StartHour" style="width: 18px" maxlength="2">
<span><script>document.write(GetLanguageDesc("s1805"));</script></span>
<input type="text" id="StartMinute" style="width: 18px" maxlength="2">
<span><script>document.write('&nbsp;&nbsp;&nbsp;' + GetLanguageDesc("s1802"));</script></span>
<input type="text" id="EndHour" style="width: 18px" maxlength="2">
<span><script>document.write(GetLanguageDesc("s1805"));</script></span>
<input type="text" id="EndMinute"  style="width: 18px" maxlength="2">
<span  class="gray"><script>document.write(GetLanguageDesc("s1806"));</script></span>
</td>
</tr>  
</table> 
</div> 
</form> 
</div>

<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button"> 
<tr id="offtimesetbutton" name="offtimesetbutton"> 
<td class="table_submit width_per20"></td> 
<td  class="table_submit"> 
<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
<input  class="ApplyButtoncss buttonwidth_100px" name="btnApplyLed" id="btnApplyLed" type="button" BindText="s0e08" onClick="SubmitFormTimeInfo();"> 
<input  class="CancleButtonCss buttonwidth_100px" name="cancelValueLed" id="cancelValueLed" type="button" BindText="s0e09" onClick="CancelConfig();"> 
</td> 
</tr> 
</table> 

<div>

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_head" name="LTEDATECNT_LEB" id="LTEDATECNT_LEB"> 
  <tr> 
    <td></td> 
  </tr> 
  <tr> 
    <td class="width_100p" BindText="s1503"></td> 
  </tr> 
</table> 
<table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"> 
  <tr> 
    <td></td> 
  </tr> 
</table> 


<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg"  name="LTEDATECNT_TBL" id="LTEDATECNT_TBL"> 
	<tr> </tr> 

	<tr> 
	<td class="table_title width_per30" BindText="s1820"></td> 
	<td class="table_right width_per70"><input type="text" name="DatacardFlowTotal" id="DatacardFlowTotal" maxlength="9" value="0" style="width: 75px">
	 <script>document.write(GetLanguageDesc("s1825"));</script></td> 
	</tr> 
  

	<tr>        
	<td class="table_title align_left width_per30" BindText='s1822'></td>
	<td class="table_right align_left width_per70" colspan="2">
		<input type="text" name="DatacardFlowWarning" id="DatacardFlowWarning" maxlength="2" value="50" style="width: 80px" />
		 <script>document.write(GetLanguageDesc("s1826"));</script>  
	</td>
	</tr>  
	  
	<tr>        
	<td class="table_title align_left width_per30" BindText='s1821'></td>
		<td class="table_right align_left width_per70" colspan="2">
			<input type="text" name="DatacardFlowAlarm" id="DatacardFlowAlarm" maxlength="2" value="90" style="width: 75px" />
			 <script>document.write(GetLanguageDesc("s1830"));</script>    
	</td>
	</tr>

	<table width="100%" border="0" cellspacing="0" cellpadding="1" class="tabal_bg" name="LTEDATECNT_TBL_BUT" id="LTEDATECNT_TBL_BUT"> 
	<tr id="dataflowsetbutton" name="dataflowsetbutton"> 
	<td class="table_title width_per30"></td> 
	<td  class="table_title"> 
	<input  class="submit" name="btnApplydataflow" id="btnApplydataflow" type="button" BindText="s0e08" onClick="SubmitFormDataflowInfo();"> 
	<input  class="submit" name="cancelValuedataflow" id="cancelValuedataflow" type="button" BindText="s0e09" onClick="CancelConfig();"> 
	</td> 
	</tr> 
	</table> 

</table>
</div>

<script>
ParseBindTextByTagName(LedcfgLgeDes, "div",    1);
ParseBindTextByTagName(LedcfgLgeDes, "td",    1);
ParseBindTextByTagName(LedcfgLgeDes, "input", 2);
</script>
</body>
</html>

