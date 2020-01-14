<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="javascript" src="../../../html/bbsp/common/managemode.asp"></script>
<script language="javascript" src="../../../html/bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="../../../html/bbsp/common/wan_list.asp"></script>
<script language="javascript" src="../../../html/bbsp/common/wan_control.asp"></script>
<script language="JavaScript" type="text/javascript">
    var nethelpIsBin5Board = bin5board();
</script>
<title>宽带设置信息</title>
</head>
<body class="mainbody" >
<blockquote>
<table border="0">
  <tr>
    <td><strong>模式: </strong></td>
    <td>Route</td>
    <td>路由模式</td>
  </tr>
    <script language="JavaScript" type="text/javascript">
        if (false == nethelpIsBin5Board){
            document.write("<tr><td>&nbsp;</td><td>Bridge</td><td>桥接模式</td></tr>");
        }
    </script>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td width="80" ><strong>服务模式:</strong></td>
    <td>TR069</td>
    <td>专用于远程网管</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>VOICE</td>
    <td>专用于宽带语音</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>TR069_VOICE</td>
    <td>同时用于宽带语音和远程网管</td>
  </tr>
    <script language="JavaScript" type="text/javascript">
        if (false == nethelpIsBin5Board){
            document.write("<tr><td>&nbsp;</td><td width=\"80\">TR069_VOICE_INTERNET</td><td>同时用于上网、宽带语音和远程网管</td></tr>");
            document.write("<tr><td>&nbsp;<td>INTERNET</td><td>专用于上网</td></tr>");
            document.write("<tr><td>&nbsp;<td>TR069_INTERNET</td><td>同时用于上网和远程网管</td></tr>");
            document.write("<tr><td>&nbsp;<td>VOICE_INTERNET</td><td>同时用于宽带语音和上网</td></tr>");
            document.write("<tr><td>&nbsp;<td>OTHER</td><td>专用于IPTV</td></tr>");
        }
    </script>
</table>
</blockquote>

</body>
</html>
