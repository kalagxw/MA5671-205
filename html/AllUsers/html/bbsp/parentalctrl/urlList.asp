 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<style type="text/css"> 
.mainbody1 {
	background-color: #d3d3d3;
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
}
</style>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<title>PCCUrlList</title>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/parentalctrlinfo.asp"></script>
<script language="javascript" src="../common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>
<script language="JavaScript" type="text/javascript">

var urlListTemplateId = '0';

var CurPage = 0;

if( window.location.href.indexOf("?") > 0)
{
	if (window.location.href.indexOf("id") != -1)
	{
		para = window.location.href.split("?"); 
		para = para[para.length -1];
		para1 = para.split("&"); 
		if (para1.length == 1)
		{
			paraTemplate = para1[0];
			urlListTemplateId = paraTemplate.split("=")[1];
		}
		else if (para1.length == 2)
		{
			CurPage = para1[0];
			paraTemplate = para1[1];
			urlListTemplateId = paraTemplate.split("=")[1];
		}
	}
}

var currentFile='urlList.asp';
var UrlValueArray = GetUrlValueArray(urlListTemplateId);
var UrlValueArrayNr = UrlValueArray.length;
var FltsecLevel = GetFltsecLevel().toUpperCase();
var UrlEnable = GetTemplateUrlEnable(urlListTemplateId);
var TemplatesListArray = GetTemplatesList();

if((FltsecLevel != 'CUSTOM') || ('0' == UrlEnable))
{
	UrlValueArrayNr = 0;
}
var firstpage = 1;
var list = 4;
if(UrlValueArrayNr == 0)
{
	firstpage = 0;
}
var lastpage = UrlValueArrayNr/list;
if(lastpage != parseInt(lastpage,10))
{
	lastpage = parseInt(lastpage,10) + 1;	
}

var page = firstpage;
if( window.location.href.indexOf("?") > 0)
{
  page = parseInt(CurPage,10); 
}

if(page < firstpage)
{
	page = firstpage;
}
else if( page > lastpage ) 
{
	page = lastpage;
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
	page = firstpage;
	
	if (false == IsValidPage(page))
	{
		return;
	}
	window.location= currentFile + "?" + parseInt(page,10)+ '&id=' + urlListTemplateId;
}

function submitprv()
{
	if (false == IsValidPage(page))
	{
		return;
	}
	page--;
	window.location = currentFile + "?" + parseInt(page,10)+ '&id=' + urlListTemplateId;
}

function submitnext()
{
	if (false == IsValidPage(page))
	{
		return;
	}
	page++;
	window.location= currentFile + "?" + parseInt(page,10)+ '&id=' + urlListTemplateId;
}

function submitlast()
{
	page = lastpage;
	if (false == IsValidPage(page))
	{
		return;
	}
	
	window.location= currentFile + "?" + parseInt(page,10)+ '&id=' + urlListTemplateId;
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
	window.location= currentFile + "?" + jumppage+ '&id=' + urlListTemplateId;
}


function showlist(startlist , endlist)
{
	var TableDataInfo = new Array();
	var i = 0;
	var UrlListlen = 0;
	
	if( 0 == UrlValueArrayNr )
	{
		TableDataInfo[UrlListlen] = new UrlShowClass();
		TableDataInfo[UrlListlen].seq = '--';
		TableDataInfo[UrlListlen].UrlAddress = '--';
		TableDataInfo.push(null);
		HWShowTableListByType(1, "urlListTblId", ShowButtonFlag, ColumnNum, TableDataInfo, UrlListConfiglistInfo, parentalctrl_language, null);
		return;
	}

	for(i=startlist;i <= endlist - 1;i++)   
	{
		TableDataInfo[UrlListlen] = new UrlShowClass();
		TableDataInfo[UrlListlen].seq = i + 1;
		TableDataInfo[UrlListlen].UrlAddress = GetStringContent(UrlValueArray[i].UrlAddress,64);
		UrlListlen++;
	}
	TableDataInfo.push(null);
	HWShowTableListByType(1, "urlListTblId", ShowButtonFlag, ColumnNum, TableDataInfo, UrlListConfiglistInfo, parentalctrl_language, null);
}

function showlistcontrol()
{	
	if(UrlValueArrayNr == 0)
	{
		showlist(0 , 0);
	}
	else if( UrlValueArrayNr >= list*parseInt(page,10) )
	{
		showlist((parseInt(page,10)-1)*list , parseInt(page,10)*list);
	}
	else
	{
		showlist((parseInt(page,10)-1)*list , UrlValueArrayNr);
	}
}

function setControl()
{

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
	
	loadlanguage();
	
}

</script>   
</head>
<body  onLoad="LoadFrame();" class="mainbody1">
<form id="urlListForm"> 
<div id="DivUrlList" style="display:block"> 
	<script language="JavaScript" type="text/javascript">
	var UrlListConfiglistInfo = new Array(new stTableTileInfo("bbsp_seq","width_per10","seq"),									
										new stTableTileInfo("bbsp_urladdr","","UrlAddress"),null);	
	var ColumnNum = 2;
	var ShowButtonFlag = false;
	var UrlListTableConfigInfoList = new Array();	
	showlistcontrol();
	</script>
	<table class='width_100p' border="0" cellspacing="0" cellpadding="0" > 
		<tr > 
			<td > 
				<input name="first" id="first" class="PageNext jumppagejumplastbutton_wh_px" type="button" value="<<" onClick="submitfirst();"/> 
				<input name="prv" id="prv"  class="PageNext jumppagejumpbutton_wh_px" type="button" value="<" onClick="submitprv();"/> 
					<script language="JavaScript" type="text/javascript">
						if (false == IsValidPage(page))
						{
							page = (0 == UrlValueArrayNr) ? 0:1;
						}
						document.write(parseInt(page,10) + "/" + lastpage);
					</script>
				<input name="next"  id="next" class="PageNext jumppagejumpbutton_wh_px" type="button" value=">" onClick="submitnext();"/> 
				<input name="last"  id="last" class="PageNext jumppagejumplastbutton_wh_px" type="button" value=">>" onClick="submitlast();"/> 
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<script> document.write(parentalctrl_language['bbsp_goto']); </script> 
				<input  type="text" name="pagejump" id="pagejump" size="2" maxlength="2" style="width:20px;" />
				<script> document.write(parentalctrl_language['bbsp_page']); </script>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input name="jump"  id="jump" class="PageNext jumpbutton_wh_px" type="button" onClick="submitjump();"></td>
				<script>setText("jump",parentalctrl_language["bbsp_jump"]);</script>
			</td>
		</tr> 
	</table> 
	<script> 
		if(page == firstpage)
		{
			setDisable('first',1);
			setDisable('prv',1);
		}
		if(page == lastpage)
		{
			setDisable('next',1);
			setDisable('last',1);
		}
	</script>
</div>
</form>
</body>
</html>
