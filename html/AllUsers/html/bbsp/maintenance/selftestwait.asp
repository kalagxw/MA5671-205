﻿<html>
<head>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<title>Wait...</title>
</head>

<body class="mainbody">
<script>
function RedirectPingResult()
{
    document.location = "diagnosecommon.asp";
}

window.setInterval(RedirectPingResult, 30000);
</script>
<table height="200px">
    <tr><td></td></tr>
    
</table>
<table align="center" width="100%">
    <tr>
        <td align="center">
         <script>document.write(diagnose_language['selftestwait']);</script>
        <td>
    </tr>
</table>
</body>
</html>