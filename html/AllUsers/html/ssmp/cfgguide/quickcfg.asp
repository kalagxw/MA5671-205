<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="javascript" src="../../bbsp/common/managemode.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_control.asp"></script>
<script language="JavaScript" type="text/javascript">
var quickCfgIsBin5Board = bin5board();
var WLANFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>';
function LoadFrame()
{ 
    if (WLANFlag == '1')
	{
		setDisplay('wlanQuickCfg', 1); 
	}
	else
	{
		setDisplay('wlanQuickCfg', 0); 
	}
	if (true == quickCfgIsBin5Board){
	    setDisplay('wlanQuickCfg', 0); 
	    setDisplay('SecQuickCfg', 0); 
	}
}

function LoidQuickConfig()
{
	window.parent.document.location.href = "/loidreg.asp";
}
function WanQuickCfg()
{
	top.Frame.changeMenuShow("基本配置","上行线路配置","",true);
}
function UrlQuickCfg()
{
    top.Frame.changeMenuShow("高级配置","安全设置","广域网接入配置",true);
}
function WLANQuickCfg()
{
	if (WLANFlag == '1')
	{
		  top.Frame.changeMenuShow("基本配置","WLAN配置",true);
	}
	else
	{
      
		  top.Frame.changeMenuShow("基本配置","WLAN配置",false);
	}    
}

</script>
</head>
<body class="mainbody" onLoad="LoadFrame();"> 
<div> 
  <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
    <tr> 
      <td class="prompt"><table width="100%" border="0" cellspacing="0" cellpadding="0"> 
          <tr> 
			<script language="javascript">
				if(WLANFlag == '1')
				{
					document.write('<td class="title_01"  style="padding-left:10px;" width="100%">在本页面上，您可以通过点击相应按钮来配置LOID注册、WAN连接、WLAN、安全等。</td> ');	
				}
				else
				{
					document.write('<td class="title_01"  style="padding-left:10px;" width="100%">在本页面上，您可以通过点击相应按钮来配置LOID注册、WAN连接、安全等。</td> ');
				}							
			</script>
          </tr> 
        </table></td> 
    </tr> 
  </table> 
  <table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td></td> 
    </tr> 
  </table> 
  <table width="100%" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td align="left" style="height:25px"> <input  class = "submit" name="btnloidCfg" id="btnloidCfg" type='button' style="width:110px" onClick='LoidQuickConfig()' value='LOID注册'> </td> 
    </tr>
    <tr> 
      <td align="left" style="height:25px"> <input  class = "submit" type='button' style="width:110px" onClick='WanQuickCfg()' value='WAN连接配置'></td>
    </tr>
	<tr> 
      <td id = 'wlanQuickCfg' align="left" style="height:25px"> <input  class = "submit" type='button' style="width:110px" onClick='WLANQuickCfg()' value='WLAN配置'></td>
    </tr>
    <tr> 
      <td id = 'SecQuickCfg'  align="left" style="height:25px"> <input  class = "submit" type='button' style="width:110px" onClick='UrlQuickCfg()' value='安全配置'></td>
    </tr>
  </table> 
  <table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td> </td> 
    </tr> 
  </table> 
  <table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td> </td> 
    </tr> 
  </table> 
</div> 
</body>
</html>
