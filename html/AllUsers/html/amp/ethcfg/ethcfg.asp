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
<title>Eth Port Configration</title>
<script language="JavaScript" type="text/javascript">

var curLanguage='<%HW_WEB_GetCurrentLanguage();%>';
var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var curWebFrame='<%HW_WEB_GetWEBFramePath();%>';
var PonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';
var isOpticUpMode = '<%HW_WEB_IsOpticUpMode();%>';
var UpportId = '<%HW_WEB_Upportid();%>';

function IsOpticUpMode()
{
	if (isOpticUpMode == '1') return true;
	else return false;
}

function IsETHUpMode()
{
	if ("GE" == PonMode.toUpperCase() || "ETH" == PonMode.toUpperCase())
	{
        return true;
	}
	else
	{
        return false;
	}
}

function IsETHOpticUpMode()
{
	if (IsOpticUpMode() && IsETHUpMode())
	{
        return true;
	}
	else
	{
        return false;
	}
}

function IsLanUpMode()
{
	if (IsOpticUpMode() && IsETHUpMode())
	{
        return true;
	}
	else
	{
        return false;
	}
}

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

		b.innerHTML = status_ethcfg_language[b.getAttribute("BindText")];
	}

    for (var i = 0; i <= EthNum ; i++)
	{
		var lanid = i + 1;
		var enblid =  'ethEnbl' + lanid;
		var duplexModeid = "duplexMode" + lanid;
		var portSpeedid = "portSpeed" + lanid

        if (i < EthNum)
		{
			setCheck(enblid, ExtPortInfos[i].Enable);
    	    setSelect(duplexModeid,ExtPortInfos[i].Mode);
			setSelect(portSpeedid,ExtPortInfos[i].Speed);
		}
		/* MxU不支持独立的上行电口
		if (i == 4)
		{ 
            if ('0' == isOpticUpMode)
			{
				setDisable(enblid, 1);
				setDisable(duplexModeid, 1);
				setDisable(portSpeedid, 1);
				getElById('EnableNote').className = "gray";
				getElById('ExtNote').className = "gray";
			}
		}
		
		if(i == EthNum && IsETHOpticUpMode())
		{
		    setCheck(enblid, WanEthInfos[0].Enable);
			setSelect(duplexModeid,WanEthInfos[0].Mode);
			setSelect(portSpeedid,WanEthInfos[0].Speed);
		}
		*/
	}

	if(IsETHUpMode())
	{
		setCheck('ethEnblUpPort', WanEthInfos[0].Enable);
		setSelect('duplexModelUpPort',WanEthInfos[0].Mode);
		setSelect('portSpeedUpPort',WanEthInfos[0].Speed);
	}

	if (IsETHUpMode())
	{
		setDisplay("portinfo_div", 1);
	}
	else
	{
		setDisplay("portinfo_div", 0);
	}
}




function ExtPortInfo(domain,Enable,Mode,Speed)
{
	this.domain	= domain;
	this.Enable 	= Enable; 
	this.Mode 	= Mode;
	this.Speed 	= Speed; 
}

var ExtPortInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.{i}, Enable|DuplexMode|MaxBitRate,ExtPortInfo);%>;
var EthNum = ExtPortInfos.length - 1;

function WanEthInfo(domain,Enable,Mode,Speed)
{
	this.domain	= domain;
	this.Enable 	= Enable; 
	this.Mode 	= Mode;
	this.Speed 	= Speed; 
}

var WanEthInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANEthernetInterfaceConfig.1, Enable|DuplexMode|MaxBitRate, WanEthInfo);%>;

function getLanInstById(id)
{
    if ('' != id)
    {
        return parseInt(id.charAt(id.length - 1));    
    }
}

function EnableSubmit(enableid)
{
/*
    var Form = new webSubmitForm();
	var lanid = getLanInstById(enableid);
    var enable = getCheckVal(enableid);
    Form.addParameter('x.Enable',enable);
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	if (lanid <= EthNum)
	{
    Form.setAction('set.cgi?x=InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.'
	                              + lanid
                                + '&RequestFile=html/amp/ethcfg/ethcfg.asp');
	}
	else
	{
	    Form.setAction('set.cgi?x=InternetGatewayDevice.WANDevice.1.WANEthernetInterfaceConfig'
                                + '&RequestFile=html/amp/ethcfg/ethcfg.asp');
	}
    Form.submit();
*/
}

function DuplexModeChange(tagid)
{
/*
    var Form = new webSubmitForm();
	var lanid = getLanInstById(tagid);
    var mode = getSelectVal(tagid);
	var speed = getSelectVal("portSpeed" + lanid);
    Form.addParameter('x.DuplexMode',mode);
	Form.addParameter('x.MaxBitRate',speed);
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	if (lanid <= EthNum)
	{
        Form.setAction('set.cgi?x=InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.'
	                            + lanid
                                + '&RequestFile=html/amp/ethcfg/ethcfg.asp');
    }
	else
	{
	    Form.setAction('set.cgi?x=InternetGatewayDevice.WANDevice.1.WANEthernetInterfaceConfig'
                                + '&RequestFile=html/amp/ethcfg/ethcfg.asp');
	}
    Form.submit();
*/
}


function PortSpeedChange(tagid)
{
/*
    var Form = new webSubmitForm();
	var lanid = getLanInstById(tagid);
    var speed = getSelectVal(tagid);
	var mode = getSelectVal("duplexMode" + lanid);
    Form.addParameter('x.DuplexMode',mode);
    Form.addParameter('x.MaxBitRate',speed);
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	if (lanid <= EthNum)
	{
        Form.setAction('set.cgi?x=InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.'
	                            + lanid
                                + '&RequestFile=html/amp/ethcfg/ethcfg.asp');
	}
	else
	{
	    Form.setAction('set.cgi?x=InternetGatewayDevice.WANDevice.1.WANEthernetInterfaceConfig'
                                + '&RequestFile=html/amp/ethcfg/ethcfg.asp');
	}
    
    Form.submit();
*/
}

function SubmitForm()
{
    var Form = new webSubmitForm();
	var portid = 0;
	var speed = 0;
	var duplex = 0;
	var enable = 0;
	var prefix = new Array('a','x', 'y', 'z', 'o', 'p', 'q');
	var url = 'set.cgi?';

	/* LAN口配置 */
	for (var portid = 1; portid <= EthNum; portid++)
	{
		if (portid == UpportId)
		{
			continue ;
		}
		
		enable = getCheckVal("ethEnbl" + portid);
		mode   = getSelectVal("duplexMode" + portid);
		speed  = getSelectVal("portSpeed" + portid);

		Form.usingPrefix(prefix[portid]);
	    Form.addParameter('Enable',enable);
		Form.addParameter('DuplexMode',mode);
		Form.addParameter('MaxBitRate',speed);
		Form.endPrefix();
		url += prefix[portid] + '=InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.' + portid +'&';
	}

	/* 上行口配置 */
	if (IsETHUpMode())
	{
		enable = getCheckVal("ethEnblUpPort");
		mode   = getSelectVal("duplexModelUpPort");
		speed  = getSelectVal("portSpeedUpPort");
	    Form.addParameter('w.Enable',enable);
		Form.addParameter('w.DuplexMode',mode);
		Form.addParameter('w.MaxBitRate',speed);
		url += 'w=InternetGatewayDevice.WANDevice.1.WANEthernetInterfaceConfig&';
	}
	url += '&RequestFile=html/amp/ethcfg/ethcfg.asp';

	Form.setAction(url);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.submit()
}

</script>

</head>
<body onLoad="LoadFrame();" class="mainbody">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="prompt">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>   
				 <script type="text/javascript" language="javascript"> 
				 if (IsETHUpMode()) 
				 {             
                  document.write('<td class="title_common" BindText=\'amp_ethcfg_desc\'></td>');
				 }
				 else
				 {
				  document.write('<td class="title_common" BindText=\'amp_ethcfg_pon_upmode_desc\'></td>');
				 }
		         </script>
                </tr>
            </table>
        </td>
    </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr ><td class="height15p"></td></tr> </table>
<div id="portinfo_div" style="overflow:auto;overflow-y:hidden;display:none"> 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr class="tabal_head">
    <td BindText='amp_ethcfg_title'></td>
    </tr>
</table>
<table id="eth_cfg_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
	<tr class="head_title">
    <td BindText='amp_ethcfg_portnum'></td>
	<td BindText='amp_ethcfg_portenable'></td>
    <td BindText='amp_ethcfg_duplex'></td>
    <td BindText='amp_ethcfg_speed'></td>
	</tr>
                    
    <script type="text/javascript" language="javascript">

	var lanid,duplexModeid,portSpeedid,col = 0;
	for(i=0;i<EthNum;i++)
	{
	    lanid = i+1;
		portid = "LAN" + lanid;
		enableid = "ethEnbl"+  lanid;
		duplexModeid = "duplexMode" + lanid;
		portSpeedid = "portSpeed" + lanid

		/* 如果LAN口作为上行口，则不需要在lan中显示该端口*/
        if (UpportId == lanid)
        {
            continue ;
        }

		if(col%2 == 0)
		{
		    document.write("<tr class=\"tabal_01\" align=\"center\">");
		}
		else
		{
		    document.write("<tr class=\"tabal_02\" align=\"center\">");
		}
        col++;

		document.write('<td>'+  portid	+'</td>');
        document.write('<td>');
		document.write('<input type="checkbox" id=' + enableid + ' onClick="EnableSubmit(this.id)" value="ON">');
		document.write(status_ethcfg_language['amp_ethcfg_portenable']);
		document.write('</td>');
		

		document.write('<td>');
        document.write('<select id=' + duplexModeid + ' size="1" onChange="DuplexModeChange(this.id)" class="width_100px">');
	    document.write('<option value="Auto">' + status_ethcfg_language["amp_port_auto"] + '</option>');
		document.write('<option value="Full">' + status_ethcfg_language["amp_port_full"] + '</option>');
		document.write('<option value="Half">' + status_ethcfg_language["amp_port_half"] + '</option>'); 
	    document.write('</select></td>');

	    document.write('<td>');
        document.write('<select id=' + portSpeedid + ' size="1" onChange="PortSpeedChange(this.id)"  class="width_100px">');
	    document.write('<option value="Auto">' + status_ethcfg_language["amp_port_auto"] + '</option>');
		document.write('<option value="10">' + status_ethcfg_language["amp_port_10M"] + '</option>');
		document.write('<option value="100">' + status_ethcfg_language["amp_port_100M"] + '</option>');
		document.write('<option value="1000">' + status_ethcfg_language["amp_port_1000M"] + '</option>'); 
	    document.write('</select></td>');

		document.write("</tr>");
	   
	}

	if (IsETHUpMode())
	{
		if(col%2 == 0)
		{
		    document.write("<tr class=\"tabal_01\" align=\"center\">");
		}
		else
		{
		    document.write("<tr class=\"tabal_02\" align=\"center\">");
		}
        document.write('<td BindText=\'amp_ethcfg_wan\'></td>'); 
        document.write('<td><input type=\'checkbox\' name=\'ethEnblUpPort\' id=\'ethEnblUpPort\' onClick=\'EnableSubmit(this.id)\' value="ON">' + status_ethcfg_language['amp_ethcfg_portenable'] + '</input></td>');
        document.write('<td>');
        document.write('<select id=\'duplexModelUpPort\' name=\'duplexModelUpPort\' size=\'1\' onChange=\'DuplexModeChange(this.id)\' class=\'width_100px\'>');
        document.write('<option value="Auto">' + status_ethcfg_language['amp_port_auto'] + '</option> ');
        document.write('<option value="Full">' + status_ethcfg_language['amp_port_full'] + '</option>');
        document.write('<option value="Half">' + status_ethcfg_language['amp_port_half'] + '</option>');
        document.write('</select>');
        document.write('</td>');
        document.write('<td>');
        document.write('<select id=\'portSpeedUpPort\' name=\'portSpeedUpPort\' size=\'1\' onChange=\'PortSpeedChange(this.id)\' class=\'width_100px\'>');
        document.write('<option value="Auto">' + status_ethcfg_language['amp_port_auto'] + '</option>');
        document.write('<option value="10">' + status_ethcfg_language['amp_port_10M'] + '</option>');
        document.write('<option value="100">' + status_ethcfg_language['amp_port_100M'] + '</option>');
        document.write('<option value="1000">' + status_ethcfg_language['amp_port_1000M'] + '</option>');
        document.write('</select>');
        document.write('</td>');
        document.write('</tr>');
	}
   </script>
</table>
<table id="OperatorPanel" class="table_button" style="width: 100%" cellpadding="0">
  <tr>
  <td class="table_submit width_per40"></td>
  <td class="table_submit">
  <button name="btnApply" id="btnApply" type="button"  onClick="SubmitForm();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(status_ethcfg_language['amp_ethcfg_apply']);</script></button>
  </td>
  </tr>
</table>
</div>

<table width="100%" border="0" cellspacing="5" cellpadding="0">
<tr >
<td class="height_10p">
<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
</td>
</tr>
</table>
</body>

</html>
