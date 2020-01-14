<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<style type="text/css">
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
<script language="javascript" src="../common/wan_check.asp"></script>
<script language="javascript" src="../common/userinfo.asp"></script>
<script language="javascript" src="../common/parentalctrlinfo.asp"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>

<title>URL Filter</title>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var TableName = "PCtrUrlConfigList";
var TELMEX = false; 
var UrlListMax = 0;

if (GetCfgMode().TELMEX == "1")
{
	TELMEX = true;
	UrlListMax = 64;
}
else
{
	TELMEX = false;
	UrlListMax = 128;
}

var IPV6Flag = "<%HW_WEB_GetFeatureSupport(BBSP_FT_IPV6);%>";
var FlagStatus = "";
var LastAddInst = "<%HW_WEB_GetLastAddInstNum();%>";

var para = "";
var para1 = "";
var CurPage = "";
var paraTemplate = "";
var paraFlagStatus = "";
var CurTemplateId = "";

if( window.location.href.indexOf("?") > 0)
{
	if (window.location.href.indexOf("TemplateId") != -1)
	{
		para = window.location.href.split("?"); 
		para = para[para.length -1];
		para1 = para.split("&"); 
		if (para1.length == 2)
		{
			paraTemplate = para1[0];
			paraFlagStatus = para1[1];
			CurTemplateId = paraTemplate.split("=")[1];
			FlagStatus = paraFlagStatus.split("=")[1];
		}
		else if (para1.length == 3)
		{
			CurPage = para1[0];
			paraTemplate = para1[1];
			paraFlagStatus = para1[2];
			CurTemplateId = paraTemplate.split("=")[1];
			FlagStatus = paraFlagStatus.split("=")[1];
		}
	}
}
else
{
	para = LastAddInst.split(";");
	para = para[para.length -1];
	CurTemplateId = para.split(":")[1];
	FlagStatus = "AddTemplate";
}

var FltsecLevel = GetFltsecLevel().toUpperCase();

function IpConcernClass(_Domain, _IpConcern)
{
	this.Domain = _Domain;
	this.IpConcern = _IpConcern;
}
function UrlFilterBaseValueClass(_Domain, _Policy, _Right)
{
    this.Domain = _Domain;
    this.Policy = _Policy;
    this.Right = _Right;
}
var BaseUrlFilterValue = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.ParentalCtrl.Templates.{i},UrlFilterPolicy|UrlFilterRight,UrlFilterBaseValueClass);%>;

var UrlValueArray = GetUrlValueArray(CurTemplateId);
var BaseIpConcernValue = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security,UrlFilterIpConcern,IpConcernClass);%>;

var TemplatesListArray = GetTemplatesList();

var selectindex = -1;
var UrlValueArrayNr = UrlValueArray.length;
var list = 10;
var currentFile='parentalctrlurl.asp';
if(FltsecLevel != 'CUSTOM')
{
	UrlValueArrayNr = 0;
}

var firstpage = 1;
if(UrlValueArrayNr == 0)
{
	firstpage = 0;
}

var lastpage = UrlValueArrayNr/list;
if(lastpage != parseInt(lastpage,10))
{
	lastpage = parseInt(lastpage,10) + 1;	
}

var currentpage = firstpage;
if( window.location.href.indexOf("?") > 0)
{
	if ('' != CurPage)
	{
		currentpage =parseInt(CurPage,10); 
	}
}
if(currentpage < firstpage)
{
	currentpage = firstpage;
}
else if( currentpage > lastpage ) 
{
	currentpage = lastpage;
}

function IsValidPage(pagevalue)
{
	if (true != isInteger(pagevalue))
	{
		return false;
	}
	return true;
}

function submitfirst()
{
	currentpage = firstpage;
	
	if (false == IsValidPage(currentpage))
	{
		return;
	}
	window.location= currentFile + "?" + parseInt(currentpage,10) + '&TemplateId=' + CurTemplateId +'&FlagStatus='+FlagStatus;
	
}

function submitprv()
{
	if (false == IsValidPage(currentpage))
	{
		return;
	}
	currentpage--;
	window.location = currentFile + "?" + parseInt(currentpage,10) +'&TemplateId=' + CurTemplateId +'&FlagStatus='+FlagStatus;
}

function submitnext()
{
	if (false == IsValidPage(currentpage))
	{
		return;
	}
	currentpage++;
	window.location= currentFile + "?" + parseInt(currentpage,10)+'&TemplateId=' + CurTemplateId +'&FlagStatus='+FlagStatus;
}

function submitlast()
{
	currentpage = lastpage;
	if (false == IsValidPage(currentpage))
	{
		return;
	}
	
	window.location= currentFile + "?" + parseInt(currentpage,10)+'&TemplateId=' + CurTemplateId +'&FlagStatus='+FlagStatus;
}

function submitjump()
{
	var jumppage = getValue('pagejump');
	if((jumppage == '') || (isInteger(jumppage) != true))
	{
		setText('pagejump', '');
		return;
	}
	
	jumppage = parseInt(jumppage, 10);
	if(jumppage < firstpage)
	{
		jumppage = firstpage;
	}
	if(jumppage > lastpage)
	{
		jumppage = lastpage;
	}
	window.location= currentFile + "?" + jumppage+'&TemplateId=' + CurTemplateId +'&FlagStatus='+FlagStatus;
}

function OnUrlFinsh()
{
	window.location='/html/bbsp/parentalctrl/parentalctrltemplate.asp';
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

function LoadFrame()
{	
	if(FltsecLevel != 'CUSTOM')
	{
		setDisable('UrlEnable' , 1);
		setDisable('SmartEnable' , 1);
		setDisable('FilterMode' , 1);
	}
	
	var UrlEnable = GetUrlFilterRight(CurTemplateId);
	if (UrlEnable == "1")
	{
		setDisplay("FilterMode"+"Row",1);
		setDisplay("divConfigUrlForm",1);
		setCheck('UrlEnable',1);
		setDisplay("tabBtnFinsh",1)
		setDisplay("tabBtnFinsh1",0)
	}
	else
	{
		setDisplay("FilterMode"+"Row",0);
		setDisplay("divConfigUrlForm",0);
		setCheck('UrlEnable',0);
		setDisplay("tabBtnFinsh",0)
		setDisplay("tabBtnFinsh1",1)
	}
	
	if (FlagStatus == "AddTemplate")
	{
		SetDivValue("DivUrlTitle",parentalctrl_language['bbsp_step3']);
		document.getElementById("ButtonFinsh").innerHTML = parentalctrl_language['bbsp_finsh'];
		document.getElementById("ButtonFinsh1").innerHTML = parentalctrl_language['bbsp_finsh'];
	}
	else if (FlagStatus == "EditTemplate")
	{
		SetDivValue("DivUrlTitle",parentalctrl_language['bbsp_inputurllist']);
		document.getElementById("ButtonFinsh").innerHTML = parentalctrl_language['bbsp_return'];
		document.getElementById("ButtonFinsh1").innerHTML = parentalctrl_language['bbsp_return'];
	}

	if (TELMEX == true)
	{
		$("#UrlValue").attr("MaxLength",30);
	}
	
	loadlanguage();

}
	
function showlist(startlist , endlist)
{
	var TableDataInfo = new Array();
	var i = 0;
	var UrlListlen = 0;
	
	for(i=startlist;i <= endlist - 1;i++)
	{
		if (UrlValueArray[i] == null)
		{
			continue;
		}
		var urlArray = GetUrlValueArray(CurTemplateId);
		TableDataInfo[UrlListlen] = new UrlFilterUrlAddress();
		TableDataInfo[UrlListlen].domain = urlArray[i].Domain;
		TableDataInfo[UrlListlen].UrlAddress = GetStringContent(UrlValueArray[i].UrlAddress,64);
		UrlListlen++;
	}
	TableDataInfo.push(null);
	HWShowTableListByType(1, TableName, ShowButtonFlag, ColumnNum, TableDataInfo, PCtrUrlConfiglistInfo, parentalctrl_language, null);
}

function showlistcontrol()
{
	if(UrlValueArrayNr == 0)
	{
		showlist(0 , 0);
	}
	else if( UrlValueArrayNr >= list*parseInt(currentpage,10) )
	{
		showlist((parseInt(currentpage,10)-1)*list , parseInt(currentpage,10)*list);
	}
	else
	{
		showlist((parseInt(currentpage,10)-1)*list , UrlValueArrayNr);
	}
}
</script> 
  
</head>
<body  onLoad="LoadFrame();" class="mainbody nomargin">
	<div id="DivContent" style="display:block"> 
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="func_title" >
			<tr> 
				<td class="align_left" >
					<div id="DivUrlTitle"></div>
				</td> 
			</tr>
		</table>
		
		<form id="UrlFilterCfg" style="display:block;">
			<table border="0" cellpadding="0" cellspacing="1"  width="100%"> 
				<li   id="UrlEnable"                 RealType="CheckBox"           DescRef="bbsp_enableurlfilter"       RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.UrlFilterRight"             InitValue="Empty" ClickFuncApp="onclick=OnUrlEnableClick"/>
				<li   id="FilterMode"                RealType="DropDownList"       DescRef="bbsp_urlfiltermodemh1"                RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.UrlFilterPolicy"         InitValue="[{TextRef:'bbsp_blacklist',Value:'0'},{TextRef:'bbsp_whitelist',Value:'1'}]" ClickFuncApp="onchange=OnNameListModeChange"/>
			</table>
			<script>
				var TableClass = new stTableClass("width_per20", "width_per80", "ltr");
				UrlfilterInfoConfigFormList = HWGetLiIdListByForm("UrlFilterCfg", null);
				HWParsePageControlByID("UrlFilterCfg", TableClass, parentalctrl_language, null);
				getElById("FilterMode").title = parentalctrl_language['bbsp_urlfilternote3'];
			</script>
			<div class="func_spread"></div>
	  </form>
	  
	  <table id="tabBtnFinsh1" style="display:none" cellpadding="0" cellspacing="0"  width="100%" class="table_button"> 
		<tr> 
		  <td width="90%"></td>
		  <td class="align_right table_submit" style="text-align:center">
			   <button type="button" id='ButtonFinsh1' onclick="OnUrlFinsh();" class="ApplyButtoncss buttonwidth_100px" value=""></button>
		  </td>
		</tr> 
	 </table> 

  
 	<div id="divConfigUrlForm">
		<script language="JavaScript" type="text/javascript">
			var PCtrUrlConfiglistInfo = new Array(new stTableTileInfo("Empty","","DomainBox"),									
												new stTableTileInfo("bbsp_urladdr","","UrlAddress"),null);	
			var ColumnNum = 2;
			var ShowButtonFlag = false;
			if (FltsecLevel == 'CUSTOM')
			{
				ShowButtonFlag = true;
			}
			var PCtrUrlTableConfigInfoList = new Array();				
			showlistcontrol();
		</script>
		
		<div id="ConfigUrlPanel" style="display:none;"> 
		<div class="list_table_spread"></div>
			<form id="TableConfigInfo" style="display:block;"> 
				<table border="0" cellpadding="0" cellspacing="1"  width="100%"> 
					<li   id="UrlValue"    RealType="TextBox"          DescRef="bbsp_urladdrmh"         RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.UrlAddress"      InitValue="Empty"     MaxLength='64'/>
				</table>
				<script language="JavaScript" type="text/javascript">
					MPCtrUrlConfigFormList = HWGetLiIdListByForm("TableConfigInfo", null);
					HWParsePageControlByID("TableConfigInfo", TableClass, parentalctrl_language, null);
					if (IPV6Flag == 1)
					{
						document.getElementById("UrlValueRemark").innerHTML = parentalctrl_language['bbsp_urlnote1'];
					}
				</script>			
				<table width="100%" class="table_button"> 
				  <tr > 
					<td class="table_submit" style="text-align:center"> 
						<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
						<button id='btnApply_ex' name="btnApply_ex" class="ApplyButtoncss buttonwidth_100px" type="button" onClick="OnBtAddUrlClick(this)"><script>document.write(parentalctrl_language['bbsp_app']);</script></button> 
						<button id='Cancel' name="cancel" class="CancleButtonCss buttonwidth_100px" type="button" onclick="OnCancel();"><script>document.write(parentalctrl_language['bbsp_cancel']);</script></button> </td> 
				  </tr> 
				</table> 
			</form>
		</div> 

	  <table class='width_per100' border="0" cellspacing="0" cellpadding="0" > 
		<tr > 
			<td > 
				<input name="first" id="first" class="PageNext jumppagejumplastbutton_wh_px" type="button" value="<<" onClick="submitfirst();"/> 
				<input name="prv" id="prv"  class="PageNext jumppagejumpbutton_wh_px" type="button" value="<" onClick="submitprv();"/> 
				<script>
						if (false == IsValidPage(currentpage))
						{
							currentpage = (0 == UrlValueArrayNr) ? 0:1;
						}
						document.write(parseInt(currentpage,10) + "/" + lastpage);
				</script>
				<input name="next"  id="next" class="PageNext jumppagejumpbutton_wh_px" type="button" value=">" onClick="submitnext();"/> 
				<input name="last"  id="last" class="PageNext jumppagejumplastbutton_wh_px" type="button" value=">>" onClick="submitlast();"/> 
			  
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<script> document.write(parentalctrl_language['bbsp_goto']); </script> 
					<input  type="text" name="pagejump" id="pagejump" size="2" maxlength="2" style="width:20px;" />
				<script> document.write(parentalctrl_language['bbsp_page']); </script>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input name="jump"  id="jump" class="PageNext jumpbutton_wh_px" type="button" onClick="submitjump();"></td>
				<script>setText("jump",parentalctrl_language["bbsp_jump"]); </script>
			</td>
		</tr> 
	</table> 
	
	<table id="tabBtnFinsh" cellpadding="0" cellspacing="0"  width="100%" class="table_button"> 
		<tr> 
		  <td width="90%"></td>
		  <td class="align_right table_submit" style="text-align:center">
			   <button type="button" id='ButtonFinsh' onclick="OnUrlFinsh();" class="ApplyButtoncss buttonwidth_100px" value=""></button>
		  </td>
		</tr> 
	 </table> 
 </div>
 
<script> 
if(currentpage == firstpage)
{
	setDisable('first',1);
	setDisable('prv',1);
}
if(currentpage == lastpage)
{
	setDisable('next',1);
	setDisable('last',1);
}
</script> 
</div> 


<script language="javascript">

if(1 == BaseUrlFilterValue.length)
{
	BaseUrlFilterValue = new Array();
	BaseUrlFilterValue[0] = new UrlFilterBaseValueClass();
	BaseUrlFilterValue[0].Right = "0";
	BaseUrlFilterValue[0].Policy = "1";
	BaseIpConcernValue = new IpConcernClass();
    BaseIpConcernValue.IpConcern = "0";
	UrlValueArray = new Array();
}

function GetUrlFilterRight(TemplateId)
{
	var UrlFilterRight = "";
	for (var i = 0; i < TemplatesListArray.length-1; i++)
	{
		if (TemplatesListArray[i].TemplateId == TemplateId)
		{
			UrlFilterRight = TemplatesListArray[i].UrlFilterRight;
		}
	}
	return UrlFilterRight;
}

function GetUrlFilterPolicy(TemplateId)
{
	var UrlFilterPolicy = "";
	for (var i = 0; i < TemplatesListArray.length-1; i++)
	{
		if (TemplatesListArray[i].TemplateId == TemplateId)
		{
			UrlFilterPolicy = TemplatesListArray[i].UrlFilterPolicy;
		}
	}
	return UrlFilterPolicy;
}

function DataPersistentClass()
{   
	this.GetData = function()
	{
		var UrlFilterInfo = new UrlFilterInfoClass();
		var UrlEnable = GetUrlFilterRight(CurTemplateId);
		var NameListMode = GetUrlFilterPolicy(CurTemplateId);
  		var SmartEnable = BaseIpConcernValue.IpConcern;
		var ArrayOfUrl = UrlValueArray;
		var i = 0;
		
        var UrlFilterInfo = new UrlFilterInfoClass(UrlEnable, NameListMode, SmartEnable, ArrayOfUrl);
		UrlFilterInfo.SetEnable(UrlEnable);

		return UrlFilterInfo;
	}

	this.SaveData = function(UrlFilterInfo)
	{   
		document.getElementById("UrlEnableData").value = UrlFilterInfo.GetEnable();
		document.getElementById("NameListModeData").value = UrlFilterInfo.GetNameListMode();
		document.getElementById("SmartEnableData").value = UrlFilterInfo.GetSmartEnable();
		document.getElementById("UrlData").value = UrlFilterInfo.GetUrlString(); 
	}
}


function DataUIObserverClass()
{
	this.UpdateUI = function(UrlFilterInfo)
	{
		document.getElementById("UrlEnable").checked = UrlFilterInfo.GetEnable() == "1" ? true:false;
		 
		document.getElementById("DivContent").style.display = "block";
		if ("1" == UrlFilterInfo.GetEnable())
		{
		   document.getElementById("DivContent").style.display = "block";
		}

		getElById("FilterMode")[0].selected = true;
		if (UrlFilterInfo.GetNameListMode() == "1")
		{
			getElById("FilterMode")[1].selected = true;
		}
	

	}
}

function UrlFilterPage()
{
	this.UrlFileInfoObj = null;
	this.UIObserver = null;

	this.SetUIObserver = function(_UIObserver)
	{
		this.UIObserver = _UIObserver;
		this.UrlFileInfoObj.AddObserver(this.UIObserver);
	}
	this.GetUIObserver = function()
	{
		return this.UIObserver;
	}

	this.SetData = function(_UrlFilterInfo)
	{
		this.UrlFileInfoObj = _UrlFilterInfo;
		this.UrlFileInfoObj.NotifyObserver();
	}
	this.GetData = function()
	{
		return this.UrlFileInfoObj;
	}        

	this.LoadData = function()
	{
		var DataObj = new DataPersistentClass();
		var UIObserver = new DataUIObserverClass();
		var UrlFilterInfo = DataObj.GetData();
		UrlFilterInfo.AddObserver(UIObserver);
		this.SetData(UrlFilterInfo);
	}
	this.SaveData = function()
	{
		this.UrlFileInfoObj.SaveData(new DataPersistentClass());
	} 
}

var Page = new UrlFilterPage();

Page.LoadData();

function OnDeleteUrlClick(Url)
{
	Page.GetData().DeleteUrl(Url);
}

function OnUrlEnableClick(UrlEnableControl)
{
	var Checked = UrlEnableControl.checked;
	var Display = true == Checked ? "block" : "none";
	var Right = Checked == true?"1":"0";
	var Onttoken = getValue('onttoken');
	document.getElementById("DivContent").style.display = "block";
	Page.GetData().SetEnable(Right);
	if (Checked == true)
	{
		setDisplay("FilterMode"+"Row",1);
		setDisplay("divConfigUrlForm",1);
	}
	else
	{
		setDisplay("FilterMode"+"Row",0);
		setDisplay("divConfigUrlForm",0);
	}
	
	var action = '';
	action = 'set.cgi?x=InternetGatewayDevice.X_HW_Security.ParentalCtrl.Templates.' + CurTemplateId;
	
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		data : 'x.UrlFilterRight=' + Right +'&x.X_HW_Token='+ Onttoken,
		url :  action + '&RequestFile=html/ipv6/not_find_file.asp',
		error:function(XMLHttpRequest, textStatus, errorThrown) 
		{
		}
	});	

	window.location='/html/bbsp/parentalctrl/parentalctrlurl.asp'+'?TemplateId='+CurTemplateId+'&FlagStatus='+FlagStatus;  
}

function OnNameListModeChange()
{
	var UrlFilterPolicy = "";
	var control = getElById("FilterMode");
	var Onttoken = getValue('onttoken');
	if (control[0].selected == true)
	{ 	
		if (ConfirmEx(parentalctrl_language['bbsp_ischange']))
		{
			UrlFilterPolicy = 0;
		}
		else
		{
			control[0].selected = false;
			control[1].selected = true;
			return;
		}
	}
	else if (control[1].selected == true)
	{ 
		if (ConfirmEx(parentalctrl_language['bbsp_ischange']))
		{
			UrlFilterPolicy = 1;
		}
		else
		{
			 control[0].selected = true;
			 control[1].selected = false;
			 return;
		}
	}
	
	var action = '';
	action = 'set.cgi?x=InternetGatewayDevice.X_HW_Security.ParentalCtrl.Templates.' + CurTemplateId;
	
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		data : 'x.UrlFilterPolicy=' + UrlFilterPolicy +'&x.X_HW_Token='+ Onttoken,
		url :  action + '&RequestFile=html/ipv6/not_find_file.asp',
		error:function(XMLHttpRequest, textStatus, errorThrown) 
		{
		}
	});	

	window.location='/html/bbsp/parentalctrl/parentalctrlurl.asp'+'?TemplateId='+CurTemplateId+'&FlagStatus='+FlagStatus; 
}

function OnSmartEnableClick(Control)
{
	var CheckValue = Control.checked == true ? "1":"0";
	var Onttoken = getValue('onttoken');
	var action = '';
	action = 'set.cgi?x=InternetGatewayDevice.X_HW_Security';
	
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		data : 'x.UrlFilterIpConcern=' + CheckValue +'&x.X_HW_Token='+ Onttoken,
		url :  action + '&RequestFile=html/ipv6/not_find_file.asp',
		error:function(XMLHttpRequest, textStatus, errorThrown) 
		{
		}
	});	

	window.location='/html/bbsp/parentalctrl/parentalctrlurl.asp'+'?TemplateId='+CurTemplateId+'&FlagStatus='+FlagStatus; 
}

function PCtrUrlConfigListselectRemoveCnt()
{

}

function OnDeleteButtonClick(TableID)
{
	var i = 0;
	var count = Page.GetData().GetUrlList().length;
	var control = null;
	var DeleteInstanceArray = new Array();

	if(0 == (count))
	{
		AlertEx(parentalctrl_language['bbsp_nourl']);
		return;
	}

	for (i = 0; i < count; i++)
	{
		control = document.getElementById(TableName+'_rml'+i);
		if (null == control)
		{
			continue;
		}
		if (control.checked == false)
		{
			continue;
		}

		DeleteInstanceArray.push(control.value);
	}

	if (DeleteInstanceArray.length == 0)
	{
		AlertEx(parentalctrl_language['bbsp_selecturl']);
		return;
	}

	var Form = new webSubmitForm();
	var str = "";
	var Onttoken = getValue('onttoken');
	var SelectCount = 0;
	for (i = 0; i < count; i++)
	{
		control = document.getElementById(TableName+'_rml'+i);
		SelectCount++;
		if (null == control)
		{
			continue;
		}
		if (control.checked == false)
		{
			continue;
		}
		if (SelectCount > 1)
		{
			str +='&';
		}
		str += control.value + '=' + '';
	}
	
	str += '&x.X_HW_Token=' + Onttoken;
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
		}
	});	
	window.location='/html/bbsp/parentalctrl/parentalctrlurl.asp'+'?TemplateId='+CurTemplateId+'&FlagStatus='+FlagStatus;  
}

function IsUrlRepeat(UrlList, NewUrl)
{
	var i;
	for (i = 0; i < UrlList.length; i++)
	{   
		if (UrlList[i] == null)
		{
			break;
		}
	
		if (TextTranslate(UrlList[i].UrlAddress.toLowerCase()) == NewUrl.toLowerCase())
		{
			return true;
		}
	}
	return false;
}

function IsUrlIncludeIpv6Addr(strUrl)
{
	if (IPV6Flag == 1)
	{
		if ((strUrl.indexOf("[") != -1) && (strUrl.indexOf("]") != -1))
		{
			return true;
		}
	}
	return false;
}

function GetIPv6Addr(strUrl)
{	
	var ipv6Addr = "";
	
	var startIndex = strUrl.indexOf('[');
	var endIndex = strUrl.indexOf(']');
	ipv6Addr = strUrl.substring(startIndex+1,endIndex);
	return ipv6Addr;
}

function ChangeUrl(strUrl)
{
	var strNewUrl = "";
	var startIndex = strUrl.indexOf('[');
	var endIndex = strUrl.indexOf(']');
	var ipv6Addr = strUrl.substring(startIndex+1,endIndex);
	ipv6Addr = ipv6Addr.replace(new RegExp(/(:)/g),'');
	strNewUrl = strUrl.substring(0,startIndex) + ipv6Addr+strUrl.substring(endIndex+1,strUrl.length);
	return strNewUrl;
}

function OnBtAddUrlClick(BtAddUrlControl)
{
	var UrlValueControl = document.getElementById("UrlValue");
	var UrlString = UrlValueControl.value;
	var ArrayOfUrl = Page.GetData().GetUrlList();
	var Ipv6Addr = "";
	var strNewUrl = "";
	var Onttoken = getValue('onttoken');

	if (isValidAscii(UrlString) != '')         
	{  
		AlertEx(parentalctrl_language['bbsp_urladdr'] + parentalctrl_language['bbsp_hasvalidch'] + isValidAscii(UrlString) + parentalctrl_language['bbsp_end']);  
		return false;       
	}
	
	if (IsUrlIncludeIpv6Addr(UrlString) == true)
	{
		Ipv6Addr = GetIPv6Addr(UrlString);
		if (IsIPv6AddressValid(Ipv6Addr) == false || IsIPv6ZeroAddress(Ipv6Addr) == true || IsIPv6LoopBackAddress(Ipv6Addr) == true || IsIPv6MulticastAddress(Ipv6Addr) == true)
	    {
	        AlertEx(parentalctrl_language['bbsp_urlipv6invalid']);
	        return false;   
	    } 
		strNewUrl = ChangeUrl(UrlString);
		if((CheckUrlParameter(strNewUrl) == false) || (IsUrlValid(strNewUrl) == false))
		{
			AlertEx(parentalctrl_language['bbsp_urlinvalid']);
			return false;
		}
	}
	else
	{
		if((CheckUrlParameter(UrlString) == false) || (IsUrlValid(UrlString) == false))
		{
			AlertEx(parentalctrl_language['bbsp_urlinvalid']);
			return false;
		}
	}

	if (IsUrlRepeat(ArrayOfUrl, UrlString) == true)
	{
		AlertEx(parentalctrl_language['bbsp_urlrepeat']);

		return false;
	}

	Page.GetData().AddUrl(new UrlValueClass("domain",UrlString));
	
	UrlString = encodeURIComponent(UrlString);
	
	var action = '';
	action = 'add.cgi?x=InternetGatewayDevice.X_HW_Security.ParentalCtrl.Templates.'+ CurTemplateId + '.UrlFilter';
	
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		data : 'x.UrlAddress=' + UrlString +'&x.X_HW_Token='+ Onttoken,
		url :  action + '&RequestFile=html/ipv6/not_find_file.asp',
		error:function(XMLHttpRequest, textStatus, errorThrown) 
		{
		}
	});	


	window.location='/html/bbsp/parentalctrl/parentalctrlurl.asp'+'?TemplateId='+CurTemplateId+'&FlagStatus='+FlagStatus;  
}

function DeleteLineRow()
{
   var tableRow = getElementById("TableUrlList");
   if (tableRow.rows.length > 2)
   tableRow.deleteRow(tableRow.rows.length-1);
   return false;
}

function setControl(Index)
{
	selectindex = Index;
	if (-1 == Index)
	{
		if(Page.GetData().GetUrlList().length >= UrlListMax)
		{
			DeleteLineRow();
			AlertEx(parentalctrl_language['bbsp_urlfull']);
			return ;
		} 
	}
	else
	{
		return ;
	}
	getElById("ConfigUrlPanel").style.display = "block";
}


function OnCancel()
{   
	getElById("ConfigUrlPanel").style.display = "none";
	var tableRow = getElementById("TableUrlList");
	tableRow.deleteRow(tableRow.rows.length-1);
	return false;
}
</script> 

<br> 
<br> 

</body>
</html>
