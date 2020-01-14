<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="opensoftware.html"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
function GetSFLanguageDesc(Name)
{
    return opensoftwareinfo[Name];
}

function GetSFNumDesc()
{
    return opensoftwareNum["num"];
}

var CfgModeWord ='<%HW_WEB_GetCfgMode();%>';

function LoadFrame()
{
	if ( "BELL" ==  CfgModeWord.toUpperCase()
		|| "TELUS" ==  CfgModeWord.toUpperCase()
		|| "SONET" ==  CfgModeWord.toUpperCase()
		|| 'SONETHG8040H' == CfgModeWord.toUpperCase()
		|| 'JAPAN8045D' == CfgModeWord.toUpperCase())
	{
		document.getElementById('returnfromnotice').style.display="";
	}
	
	if("QTEL" ==  CfgModeWord.toUpperCase())
	{
		document.getElementById('title_01').style.color = '#ed1c24';
		document.getElementById('title_02').style.color = '#ed1c24';
		document.getElementById('title_03').style.color = '#ed1c24';
	}
}

function Goback()
{
	window.location="/index.asp";
		if ( "BELL" ==  CfgModeWord.toUpperCase()
		|| "TELUS" ==  CfgModeWord.toUpperCase())
	{
		window.location="/index.asp";
	}
	else if("SONET" ==  CfgModeWord.toUpperCase() || 'SONETHG8040H' == CfgModeWord.toUpperCase()|| 'JAPAN8045D' == CfgModeWord.toUpperCase())
	{
		window.location="/html/ssmp/softnotice/sonetnotice.asp";
	}
	else
	{
		;
	}
}
</script>
</head>
<body class="mainbody" onLoad="LoadFrame();"> 
	<div class="func_title" BindText="s2002"></div><!-- function 1: OPEN SOURCE SOFTWARE NOTICE -->
	<table width="100%" border="0" cellpadding="0" cellspacing="1"> 
		<tr><td id="title_01" class="table_title width_per30" BindText="s2003"></td></tr> 
	</table> 
	
	<div class="func_spread"></div>
	<div class="func_title" BindText="s2004"></div><!-- function 2: Warranty Disclaimer -->
	<table width="100%" border="0" cellpadding="0" cellspacing="1"> 
		<tr><td id="title_02" class="table_title width_per30" BindText="s2005"></td></tr> 
	</table> 
	
	<div class="func_spread"></div>
	<div class="func_title" BindText="s2006"></div><!-- function 3: Open Source Software Information -->
	<div id="OpenSFInfo"> 
		<table height="5" class="tabal_bg" cellpadding="1" cellspacing="1"> 
			<tr class="head_title" style="position:relative;"> 
				<td style="word-break: break-all;" width="20%" class="table_right" BindText="s2007"></td> 
				<td style="word-break: break-all;" width="10%" class="table_right" BindText="s2008"></td> 
				<td style="word-break: break-all;" width="35%" class="table_right" BindText="s2009"></td> 
				<td style="word-break: break-all;" width="13%" class="table_right" BindText="s2010"></td> 
				<td style="word-break: break-all;" width="22%" class="table_right" BindText="s2011"></td> 
			</tr> 
			<script>
				var indexnum = GetSFNumDesc();
				var totalnum = parseInt(indexnum);
				for(var i = 0; i < totalnum; i++)
				{
					var InfoPreIndex = 'sw' + i ;
					document.write('<tr width="100%" style="position:relative;">');
					document.write('<td  class="table_right" dir="ltr" style="word-break: break-all;" width="20%">' + GetSFLanguageDesc(InfoPreIndex + "01") + '</td>');
					document.write('<td  class="table_right" dir="ltr" style="word-break: break-all;" width="10%">' + GetSFLanguageDesc(InfoPreIndex + "02") + '</td>');
					document.write('<td  class="table_right" dir="ltr" style="word-break: break-all;" width="35%">' + GetSFLanguageDesc(InfoPreIndex + "03") + '</td>');
					document.write('<td  class="table_right" dir="ltr" style="word-break: break-all;" width="13%">' + GetSFLanguageDesc(InfoPreIndex + "04") + '</td>');
					document.write('<td  class="table_right" dir="ltr" style="word-break: break-all;" width="22%">' + GetSFLanguageDesc(InfoPreIndex + "05") + '</td>');
					document.write('</tr>');
				}
			</script>
		</table> 
	</div> 
	
	<div class="func_spread"></div>
	<div class="func_title" BindText="s2012"></div><!-- function 4: Written Offer -->
	<table width="100%" border="0" cellpadding="0" cellspacing="1"> 
		<tr><td id="title_03" class="table_title width_per30" BindText="s2013"></td></tr>
	</table> 
	
	<div class="func_spread"></div>
	<div id="returnfromnotice" style="display:none;">
		<input type="button" name="MdyPwdApply" id="MdyPwdApply" class="CancleButtonCss buttonwidth_100px" onClick="Goback();" BindText="s2015" />
	</div>
	<div class="func_spread"></div>
	
	<script>
		ParseBindTextByTagName(SoftNoticeDes, "div",   1);
		ParseBindTextByTagName(SoftNoticeDes, "td",    1);
		ParseBindTextByTagName(SoftNoticeDes, "input", 2);
	</script>	
</body>
</html>
