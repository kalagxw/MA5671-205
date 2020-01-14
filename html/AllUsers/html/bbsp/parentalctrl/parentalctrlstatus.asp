 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<style type="text/css">
.head_title {
	border: #d9d9d9;
	font-family:"微软雅黑";
	background-color: #feffe0;
	font-size: 12px;
	font-weight: bold;
	text-align: center;
	color: #000;
	height: 18px;
	line-height: 16px;
}
.table_title {
	background-color: #feffe0;
	padding-left: 5px;
	height: 18px;
	line-height: 16px;
}

#pccframeWarpContent {
	height: 610px;
}
</style>

<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<title>PCCstatus</title>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">

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
	ClickAllInfo();
	loadlanguage();
}

function ClickAllInfo()
{
	document.getElementById("ParentalctrlAllInfo").style.color = $(".TagTitleClick").css("color");
	document.getElementById("ParentalctrlTemplate").style.color = $(".TagTitleNoClick").css("color");
	document.getElementById("ParentalctrlStatistics").style.color = $(".TagTitleNoClick").css("color");
	document.getElementById("pccframeContent").src="/html/bbsp/parentalctrl/parentalctrlmac.asp";
}
function ClickTemplate()
{
	document.getElementById("ParentalctrlAllInfo").style.color = $(".TagTitleNoClick").css("color");
	document.getElementById("ParentalctrlTemplate").style.color = $(".TagTitleClick").css("color");;
	document.getElementById("ParentalctrlStatistics").style.color = $(".TagTitleNoClick").css("color");
	document.getElementById("pccframeContent").src="/html/bbsp/parentalctrl/parentalctrltemplate.asp";
}
function ClickStatistics()
{
	document.getElementById("ParentalctrlAllInfo").style.color = $(".TagTitleNoClick").css("color");
	document.getElementById("ParentalctrlTemplate").style.color = $(".TagTitleNoClick").css("color");
	document.getElementById("ParentalctrlStatistics").style.color = $(".TagTitleClick").css("color");
	document.getElementById("pccframeContent").src="/html/bbsp/parentalctrl/parentalctrlStat.asp";
}

function showdiag()
{
	var d = document.getElementById("diag");
	//d.style.left = document.getElementById("DivContent").offsetLeft+20;
	//d.style.top = document.getElementById("DivContent").offsetTop;
	d.style.left  =20;
	d.style.top =0;
	d.style.display = "block";
}
function closeDiag()
{
	var d = document.getElementById("diag");
	d.style.display = "none";
}

function adjustParentHeight(containerID, newHeight)
{
	$("#DivContent").css("height", 'auto');
	var newHeight1 = (newHeight > 700) ? newHeight : 700;
	$("#" + containerID).css("height", newHeight1 + "px");

	if ((navigator.appName.indexOf("Internet Explorer") == -1)
		&& (containerID == "pccframeWarpContent"))
	{
		var height1 = document.body.scrollHeight;
		var height = (height1 > 700) ? height1 : 700;
		$("#DivContent").css("height", height + "px");
	}
}

</script>
</head>
<body  onLoad="LoadFrame();" class="mainbody">
	<div id="DivContent" style="display:block">
	<table width="100%" height="0" border="0" cellpadding="0" cellspacing="0"><tr> <td></td></tr>
		<script language="JavaScript" type="text/javascript">
        HWCreatePageHeadInfo("parental", GetDescFormArrayById(parentalctrl_language, "bbsp_mune"), GetDescFormArrayById(parentalctrl_language, "bbsp_parental_control_title"), false);
       </script>
	   </table>  
	   <div class="title_spread"></div>

		<table>
			<tr>
				<td width="5%" class="TagTitle1"><a id="ParentalctrlAllInfo" href="#" name="ParentalctrlAllInfo" onClick="ClickAllInfo();"><span class="TagTitle"><script> document.write(parentalctrl_language['bbsp_all']); </script></span></a></td>
				<td class="TagLineSpace"></td>
				<td class="TagLine">|</td>
				<td class="TagLineSpace"></td>
				<td width="5%"><a id="ParentalctrlTemplate" href="#" name="ParentalctrlTemplate" onClick="ClickTemplate();"><span class="TagTitle"><script> document.write(parentalctrl_language['bbsp_template']); </script></span></a></td>
				<td class="TagLineSpace"></td>
				<td class="TagLine">|</td>
				<td class="TagLineSpace"></td>
				<td width="5%"><a id="ParentalctrlStatistics" href="#" name="ParentalctrlStatistics" onClick="ClickStatistics();"><span class="TagTitle"><script> document.write(parentalctrl_language['bbsp_stat']); </script></span></a></td>
				<td width="75%"></td>
				<td width="10%"><a id="Parentalctrlhelp" href="#" name="Parentalctrlhelp" onClick="showdiag();" style="text-decoration:underline;font-size:14px;color:#0000FF;white-space:nowrap;"><script> document.write(parentalctrl_language['bbsp_help']); </script></a></td>
			</tr>
		</table>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr ><td height="10">
			<div id="tagclick" class="TagTitleClick"></div>
			<div id="tagnoclick" class="TagTitleNoClick"></div>
			</td></tr>
		</table>

		<div id="diag" width="100%" style="position:absolute; display:none;height:700px;background-color:#feffe0;" onClick="closeDiag();">
			<table  id="TableHelp"   width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr class="head_title">
					<td class='align_left' colspan="2" BindText ='bbsp_pcchelptitle'></td>
				</tr>
				<tr>
					<td class="table_title" BindText ='bbsp_pcchelpinfo'> </td>
				</tr>

				<tr class="head_title">
					<td class='align_left' colspan="2" BindText ='bbsp_template'></td>
				</tr>
				<tr>
					<td class="table_title"  colspan="2"  BindText ='bbsp_pcchelptempalteinfo1'> </td>
				</tr>
				<tr>
					<td class="table_title"  colspan="2" BindText ='bbsp_pcchelpexplain'> </td>
				</tr>
				<tr>
					<td class="table_title"  colspan="2" BindText ='bbsp_pcchelptempalteinfo2'> </td>
				</tr>
				<tr>
					<td class="table_title"  colspan="2" BindText ='bbsp_pcchelptempalteinfo3'> </td>
				</tr>
				<tr>
					<td class="table_title"  colspan="2" BindText ='bbsp_pcchelptempalteinfo4'> </td>
				</tr>
				<tr>
					<td class="table_title"  colspan="2" BindText ='bbsp_pcchelptempalteinfo5'> </td>
				</tr>

				<tr class="head_title">
					<td class='align_left' colspan="2" BindText ='bbsp_all'></td>
				</tr>
				<tr>
					<td class="table_title"  colspan="2"  BindText ='bbsp_pcchelpallinfo1'> </td>
				</tr>
				<tr>
					<td class="table_title"  colspan="2" BindText ='bbsp_pcchelpexplain'> </td>
				</tr>
				<tr>
					<td class="table_title"  colspan="2" BindText ='bbsp_pcchelpallinfo2'> </td>
				</tr>
				<tr>
					<td class="table_title"  colspan="2" BindText ='bbsp_pcchelpallinfo3'> </td>
				</tr>

				<tr class="head_title">
					<td class='align_left' colspan="2" BindText ='bbsp_stattitle'></td>
				</tr>
				<tr>
					<td class="table_title"  colspan="2"  BindText ='bbsp_statinfo1'> </td>
				</tr>

				<tr class="head_title">
					<td class='align_left' colspan="2" BindText ='bbsp_FAQtitle'></td>
				</tr>
				<tr>
					<td class="table_title"  colspan="2"  BindText ='bbsp_FAQQ1info'> </td>
				</tr>
				<tr>
					<td class="table_title"  colspan="2"  BindText ='bbsp_FAQA1info1'> </td>
				</tr>
				<tr>
					<td class="table_title"  colspan="2"  BindText ='bbsp_FAQA1info2'> </td>
				</tr>
				<tr>
					<td class="table_title"  colspan="2"  BindText ='bbsp_FAQA1info3'> </td>
				</tr>
				<tr>
					<td class="table_title"  colspan="2"  BindText ='bbsp_FAQQ2info'> </td>
				</tr>
				<tr>
					<td class="table_title"  colspan="2"  BindText ='bbsp_FAQA2info1'> </td>
				</tr>
				<tr>
					<td class="table_title"  colspan="2"  BindText ='bbsp_FAQA2info2'> </td>
				</tr>
				<tr>
					<td class="table_title"  colspan="2"  BindText ='bbsp_FAQA2info3'> </td>
				</tr>
			</table>
		</div>

		<div id="pccframeWarpContent">
			<iframe id="pccframeContent" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" width="100%" height="100%" />
		</div>
	</div>
</body>
</html>
