<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  id="Page" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8">
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
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="javascript" src="../common/parentalctrlinfo.asp"></script>
<script language="javascript" src="../common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var TemplatesListArray = GetTemplatesList();
var StatsListArray  = GetStatsList();
var TableName = "PCtrStatConfigList";

var appName = navigator.appName;

function GetTimeBlockNum(StatsListArray,index)
{
	var TimeHigh = parseInt(StatsListArray[index].PacketsBlockedByTime_High,16);
	var TimeLow = parseInt(StatsListArray[index].PacketsBlockedByTime_Low,16);
	var TimeHighStr = TimeHigh.toString(16);
	var TimeLowStr = TimeLow.toString(16);
	var TimeLowlen= 8 - TimeLowStr.length;
	for(var i = 0; i < TimeLowlen; i++)
	{
		TimeLowStr = '0' + TimeLowStr;
	}
	var TimeStr = TimeHighStr + TimeLowStr;
	var TimeBlockNum = parseInt(TimeStr,16);
	return TimeBlockNum;
}

function GetUrlBlockNum(StatsListArray,index)
{
	var UrlHigh = parseInt(StatsListArray[index].PacketsBlockedByUrl_High,16);
	var UrlLow = parseInt(StatsListArray[index].PacketsBlockedByUrl_Low,16);
	var UrlHighStr = UrlHigh.toString(16);
	var UrlLowStr = UrlLow.toString(16);
	var UrlLowlen= 8 - UrlLowStr.length;
	for(var i = 0; i < UrlLowlen; i++)
	{
		UrlLowStr = '0' + UrlLowStr;
	}
	var UrlStr = UrlHighStr + UrlLowStr;
	var UrlBlockNum = parseInt(UrlStr,16);
	return UrlBlockNum;
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

function StatsRefresh()
{
	var Onttoken = getValue('onttoken');
	$.ajax({
            type : "POST",
            async : false,
            cache : false,
			data : '&x.X_HW_Token='+ Onttoken,
            url : "/html/bbsp/parentalctrl/GetParentalctrlStatResult.asp",
            success : function(data) {
            StatsListArray = eval(data);
			setStatInfo(StatsListArray);
            }
        });
}

function setStatInfo(StatsListArray)
{
	var TemplateName = "";
	var TimeBlockNum = "";
	var UrlBlockNum = "";
	for (var i = 0; i < TemplatesListArray.length - 1; i++)
	{
		TemplateName = TableName + '_' + i + '_0';
		TimeBlockNum = TableName + '_' + i + '_1';
		UrlBlockNum = TableName + '_' + i + '_2';
		document.getElementById(TemplateName).innerHTML = GetStringContent(TemplatesListArray[i].Name,32);
		
		for (var j = 0; j < StatsListArray.length - 1; j++)
		{
			if (TemplatesListArray[i].TemplateId == StatsListArray[j].TemplateId)
			{
				document.getElementById(TimeBlockNum).innerHTML = GetTimeBlockNum(StatsListArray,j);
				document.getElementById(UrlBlockNum).innerHTML = GetUrlBlockNum(StatsListArray,j);
			}
		}
	}
}

function StatsClear()
{
    var urlpara = "";
	var index = "";
	var expList = new Array('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p');
	var PCtrStatSpecConfigParaList = new Array();
	for (var i = 0; i < StatsListArray.length - 1; i++)
	{
		index = expList[i];
		PCtrStatSpecConfigParaList.push(new stSpecParaArray(index+'.PacketsBlockedByTime_High',0, 1));
		PCtrStatSpecConfigParaList.push(new stSpecParaArray(index+'.PacketsBlockedByTime_Low',0, 1));
		PCtrStatSpecConfigParaList.push(new stSpecParaArray(index+'.PacketsBlockedByUrl_High',0, 1));
		PCtrStatSpecConfigParaList.push(new stSpecParaArray(index+'.PacketsBlockedByUrl_Low',0, 1));
		if(i != 0){
		    urlpara += '&' ;
	    }
	    urlpara +=  index + '=' + StatsListArray[i].domain;
	}
	var Parameter = {};
	Parameter.asynflag = null;
	Parameter.FormLiList = PCtrStatConfigFormList;
	Parameter.SpecParaPair = PCtrStatSpecConfigParaList;
	var tokenvalue = getValue('onttoken');	
	var url = 'set.cgi?' + urlpara + '&RequestFile=html/bbsp/parentalctrl/parentalctrlStat.asp';
	HWSetAction(null, url, Parameter, tokenvalue);
}

function OnPageLoad()
{
	loadlanguage();
	adjustParentHeight();
	return true;
}

function setControl()
{

}
function InitTableData()
{
	for (var i = 0; i < TemplatesListArray.length - 1; i++)
	{
		TableDataInfo[i].Name = GetStringContent(TemplatesListArray[i].Name,32);
		for (var j = 0; j < TableDataInfo.length - 1; j++)
		{
			if (TemplatesListArray[i].TemplateId == TableDataInfo[j].TemplateId)
			{
				TableDataInfo[i].PacketsBlockedByTime = GetTimeBlockNum(StatsListArray,j);
				TableDataInfo[i].PacketsBlockedByUrl = GetUrlBlockNum(StatsListArray,j);
			}
		}
	}
}

function adjustParentHeight()
{
	var dh = getHeight(document.getElementById("DivTableInfo"));
	var height = 50 + (dh > 0 ? dh : 0);
	window.parent.adjustParentHeight("pccframeWarpContent", height);
}

</script>
<title>PCCStat</title>
</head>
<body  onLoad="OnPageLoad();" class="mainbody nomargin">
<div id="DivTableInfo">
<script language="JavaScript" type="text/javascript">
	var PCtrStatConfiglistInfo = new Array(new stTableTileInfo("bbsp_template","align_center width_per30","Name"),
									new stTableTileInfo("bbsp_timeblocknum","align_center width_per30","PacketsBlockedByTime"),
									new stTableTileInfo("bbsp_urlblocknum","align_center width_per30","PacketsBlockedByUrl"),
									null);
	var ColumnNum = 3;
	var ShowButtonFlag = false;
	var PCtrStatConfigFormList = new Array();
	var TableDataInfo =  HWcloneObject(StatsListArray, 1);
	InitTableData();
	HWShowTableListByType(1, TableName, ShowButtonFlag, ColumnNum, TableDataInfo, PCtrStatConfiglistInfo, parentalctrl_language, null);
</script>
<table cellpadding="0" cellspacing="1" width="100%" class="table_button"> 
    <tr> 
      <td class="title_bright1">
	  	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
	  	<button id="btnRefresh" name="btnRefresh" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="StatsRefresh();"><script>document.write(parentalctrl_language['bbsp_refresh']);</script></button> 
        <button name="btnClear" id="btnClear" class="CancleButtonCss buttonwidth_100px"  type="button" onClick="StatsClear();"><script>document.write(parentalctrl_language['bbsp_clear']);</script></button>
	</td> 
    </tr> 	
</table> 
</div>
</body>
</html>
