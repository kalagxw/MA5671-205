<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../../bbsp/common/managemode.asp"></script>
<script language="javascript" src="../../bbsp/common/lanuserinfo.asp"></script>
<title>Eth Port Information</title>
<script language="JavaScript" type="text/javascript">

function LoadFrame()
{
	var all = document.getElementsByTagName("td");
	for (var i = 0; i <all.length ; i++) 
	{
		var b = all[i];
		if(b.getAttribute("BindText") == null)
		{
			continue;
		}

		b.innerHTML = status_ethinfo_language[b.getAttribute("BindText")];
	}
}

function GEInfo(domain,Mode,Speed,Status)
{
	this.domain		= domain;
	this.Mode 		= Mode;
	if(Mode==0)this.Mode = status_ethinfo_language['amp_port_halfduplex'];
	if(Mode==1)this.Mode = status_ethinfo_language['amp_port_fullduplex'];

	this.Speed 		= Speed;
	if(Speed==0)this.Speed = status_ethinfo_language['amp_port_10M'];
	if(Speed==1)this.Speed = status_ethinfo_language['amp_port_100M'];
	if(Speed==2)this.Speed = status_ethinfo_language['amp_port_1000M'];
	if(Speed==3)this.Speed = status_ethinfo_language['amp_port_10000M'];
	
	this.Status 	= Status; 
	if(Status==0)this.Status = status_ethinfo_language['amp_port_linkdown'];
	if(Status==1)this.Status = status_ethinfo_language['amp_port_linkup'];
}

var geInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.LANPort.{i}.CommonConfig,Duplex|Speed|Link,GEInfo);%>;
</script>

</head>
<body onLoad="LoadFrame();" class="mainbody">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="prompt">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>                   
          <td class="title_common" BindText='amp_ethinfo_desc'></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr ><td class="height_15px"></td></tr> </table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr class="tabal_head">
    <td BindText='amp_ethinfo_title'></td>
    </tr>
</table>
<table id="eth_status_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
	<tr class="head_title">
    <td colspan="1" rowspan="2" BindText='amp_ethinfo_portnum'></td>
	<td colspan="3" BindText='amp_ethinfo_portstatus'></td>    
	</tr>
                    
    <tr class="head_title">
    <td BindText='amp_ethinfo_duplex'></td>
    <td BindText='amp_ethinfo_speed'></td>
    <td BindText='amp_ethinfo_link'></td>
    </tr>

    <script type="text/javascript" language="javascript">
	if( 1 == geInfos.length || null == geInfos)
	{
		document.write("<tr class=\"tabal_01\">");
		document.write('<td>'+'&nbsp '	+'</td>');
		document.write('<td>'+'&nbsp '	+'</td>');
		document.write('<td>'+'&nbsp '	+'</td>');
		document.write('<td>'+'&nbsp '	+'</td>');		

		document.write("</tr>");
	}

	var lanid;
	for(i=0;i<geInfos.length - 1;i++)
	{
	    lanid = i+1;
		if(i%2 == 0)
		{
		    document.write("<tr class=\"tabal_01\">");
		}
		else
		{
		    document.write("<tr class=\"tabal_02\">");
		}
		document.write('<td>'+  lanid	+'</td>');
		document.write('<td>'+geInfos[i].Mode	+'</td>');
		document.write('<td>'+geInfos[i].Speed	+'</td>');
		document.write('<td>'+geInfos[i].Status	+'</td>');

		document.write("</tr>");
	}
	</script>
</table>
<table width="100%" border="0" cellspacing="5" cellpadding="0">
<tr ><td class="height_10p"></td></tr>
</table>
</body>
</html>
