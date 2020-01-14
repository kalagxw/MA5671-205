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
<title>Upport Mode Configration</title>
<script language="JavaScript" type="text/javascript">
function AccessInfo(domain, accessMode, capAccessMode, capUppotid)
{
	this.domain        = domain;
	this.accessMode    = accessMode;
	if (accessMode.toUpperCase() == "10G-GPON") this.accessMode = "XGPON";
	if (accessMode.toUpperCase() == "ASYMMETRIC 10G-EPON") this.accessMode = "10GEPONA";
	if (accessMode.toUpperCase() == "SYMMETRIC 10G-EPON") this.accessMode = "10GEPONS";
	this.capAccessMode = capAccessMode;
	this.capUppotid    = capUppotid;
}

var curLanguage='<%HW_WEB_GetCurrentLanguage();%>';
var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType='0';
var curWebFrame='<%HW_WEB_GetWEBFramePath();%>';
var AccessInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp,XG_AccessMode|CAP_AccessMode|CAP_UpportID, AccessInfo);%>;
var isOpticUpMode = '<%HW_WEB_IsOpticUpMode();%>';
var UpportId = '<%HW_WEB_Upportid();%>';

var PonMode = AccessInfos[0].accessMode;
var capAccessModes = AccessInfos[0].capAccessMode.split(';');
var capUppotids = AccessInfos[0].capUppotid.split(';');

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

function AccessMode(ModeType, ModeValue, ModeDes)
{
    this.ModeType   = ModeType;
	this.ModeValue  = ModeValue;
	this.ModeDes    = ModeDes;
}



var AccessModeInfos = new Array(new AccessMode('1', "GPON", upportmode_cfg_language["upportmode_cfg_gpon"]),
                                new AccessMode('2', "EPON", upportmode_cfg_language["upportmode_cfg_epon"]), 
						        new AccessMode('3', "GE", upportmode_cfg_language["upportmode_cfg_ge"]),
						        new AccessMode('4', "AUTO", upportmode_cfg_language["upportmode_cfg_auto"]),
						        new AccessMode('5', "XGPON", upportmode_cfg_language["upportmode_cfg_xgpon"]),
						        new AccessMode('6', "10GEPONA", upportmode_cfg_language["upportmode_cfg_10epona"]),
						        new AccessMode('7', "10GEPONS", upportmode_cfg_language["upportmode_cfg_10epons"]),
						        null);

function GetUpportModeByValue(ModeValue)
{
	for (var i = 0; i < AccessModeInfos.length-1; i++)
	{
		if (ModeValue.toUpperCase() == AccessModeInfos[i].ModeValue)
		{
			return AccessModeInfos[i];
		}
	}

	return null;
}

function IsSupportAccessMode(ModeValue)
{
	for (var i = 0; i < capAccessModes.length; i++)
	{
		if (ModeValue.toUpperCase() == capAccessModes[i].toUpperCase())
		{
			return true;
		}
	}

	return false;
}

function IsETHMode(ModeValue)
{
	if (ModeValue.toUpperCase() == "GE")
   {
		return true;
   }
   else
   {
		return false;
   }
}

function UpportIdInfo(PortId, PortValue, PortDes)
{
	this.PortId     = PortId;
    this.PortValue  = PortValue;
	this.PortDes    = PortDes;
}

/* 1056769 == 0x102001 */
var AccessPortInfos = new Array(new UpportIdInfo('1056769', "OPTICAL", "OPTICAL"),
                                new UpportIdInfo('1', "LAN1", "LAN1"), 
						        new UpportIdInfo('2', "LAN2", "LAN2"),
						        new UpportIdInfo('3', "LAN3", "LAN3"),
						        new UpportIdInfo('4', "LAN4", "LAN4"),
						        new UpportIdInfo('5', "LAN5", "LAN5"),
						        null);

function GetUpportIdById(PortId)
{
	for (var i = 0; i < AccessPortInfos.length-1; i++)
	{
		if (PortId == AccessPortInfos[i].PortId)
		{
			return AccessPortInfos[i];
		}
	}

	return null;
}

function GetUpportIdByValue(PortValue)
{
	for (var i = 0; i < AccessPortInfos.length-1; i++)
	{
		if (PortValue.toUpperCase() == AccessPortInfos[i].PortValue.toUpperCase())
		{
			return AccessPortInfos[i];
		}
	}

	return null;
}

function IsSupportUpportid(PortValue)
{
	for (var i = 0; i < capUppotids.length; i++)
	{
		if (PortValue.toUpperCase() == capUppotids[i].toUpperCase())
		{
			return true;
		}
	}

	return false;
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

		b.innerHTML = upportmode_cfg_language[b.getAttribute("BindText")];
	}

	var ponModeValue = PonMode.toUpperCase();
	var upportIdValue = GetUpportIdById(UpportId).PortValue;

	setSelect("upportmode", ponModeValue);
	if (IsETHUpMode())
	{
		setDisplay("upportid_tr", 1);
		setSelect("upportid", upportIdValue);
	}
	else
	{
		setDisplay("upportid_tr", 0);
	}
}

function UpportModeChange(tagid)
{
	if (IsETHMode(getSelectVal(tagid)))
	{
		setDisplay("upportid_tr", 1);
	}
	else
	{
	    setDisplay("upportid_tr", 0);
	}
}

function UpportIdChange(tagid)
{
}

function SubmitForm()
{
    var Form = new webSubmitForm();
	var portid = GetUpportIdByValue(getSelectVal("upportid")).PortId;
	var mode = GetUpportModeByValue(getSelectVal("upportmode")).ModeType;

	if (mode.toUpperCase() != '3')
	{
		/* 如果上行PON模式没有变化，直接返回 */
	    if (mode.toUpperCase() == GetUpportModeByValue(PonMode).ModeType)
		{
	       return ;
	    }
	    else
	    {
		    portid =  GetUpportIdByValue("optical").PortId;
	    }
	}
	else
	{
		/* 如果上行已经是GE模式且端口号没有变化，直接返回 */
		if ('3' == GetUpportModeByValue(PonMode).ModeType && UpportId == portid)
		{
		    return ;
		}
	}

	if (confirm(upportmode_cfg_language["upportmode_cfg_mode_change_alert"]))
	{
		Form.addParameter('x.X_HW_UpPortMode',mode);
		Form.addParameter('x.X_HW_UpPortID',portid);
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.setAction('set.cgi?x=InternetGatewayDevice.DeviceInfo&RequestFile=html/ssmp/reset/reset.asp');

		Form.submit();
	}
}

</script>

</head>
<body onLoad="LoadFrame();" class="mainbody">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="prompt">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>     
                  <td BindText='upportmode_cfg_desc' class="title_common"></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr ><td class="height15p"></td></tr> </table>
<div id="portid_div"> 
<table id="portid_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
	<tr class="head_title">
    <td BindText='upportmode_cfg_Mode'></td>
	<td align="left"><select id="upportmode" size="1" onChange="UpportModeChange(this.id)" class="width_150px">
	<script type="text/javascript" language="javascript">
	for (var i = 0; i < AccessModeInfos.length - 1; i++)
	{
		if(IsSupportAccessMode(AccessModeInfos[i].ModeValue))
		{
			document.write('<option value="' + AccessModeInfos[i].ModeValue + '">' + AccessModeInfos[i].ModeDes + '</option>');
		}
	}
	</script>
	</select>
	</td>
	</tr>
    <tr id="upportid_tr" class="head_title" style="display:none">
    <td BindText='upportmode_cfg_portid'></td>
	<td align="left"><select id="upportid" size="1" onChange="UpportIdChange(this.id)" class="width_150px">
	<script type="text/javascript" language="javascript">
	for (var i = 0; i < AccessPortInfos.length - 1; i++)
	{
		if (IsSupportUpportid(AccessPortInfos[i].PortValue))
		{
			document.write('<option value="' + AccessPortInfos[i].PortValue + '">' + AccessPortInfos[i].PortDes + '</option>');
		}
	}
	</script>
	</select>
	</td>
	</tr>                
</table>
<table id="OperatorPanel" class="table_button" style="width: 100%" cellpadding="0">
  <tr>
  <td class="table_submit width_per40"></td>
  <td class="table_submit">
  <button name="btnApply" id="btnApply" type="button"  onClick="SubmitForm();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(upportmode_cfg_language['upportmode_cfg_applay']);</script></button>
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
