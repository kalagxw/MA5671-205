<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" type="text/javascript">
var curLanguage='<%HW_WEB_GetCurrentLanguage();%>';
function stDeviceInfo(domain,SerialNumber,HardwareVersion,SoftwareVersion,ModelName,VendorID,ReleaseTime,Mac,Description,ManufactureInfo)
{
	this.domain 			= domain;
	this.SerialNumber 		= SerialNumber;
	this.HardwareVersion 	= HardwareVersion;		
	this.SoftwareVersion 	= SoftwareVersion;
	this.ModelName 		    = ModelName;
	this.VendorID			= VendorID;
	this.ReleaseTime 		= ReleaseTime;
	this.Mac				= Mac;
    this.Description        = Description;
	this.ManufactureInfo	= ManufactureInfo;
}	

function ONTInfo(domain,Status)
{
	this.domain 		= domain;
	this.Status			= Status;
}

function isFirst8VisibleChar(sn)
{    
    if (
         ((sn.charAt(0) >= '2')&&(sn.charAt(0) <= '7'))
         &&((sn.charAt(2) >= '2')&&(sn.charAt(2) <= '7'))
         &&((sn.charAt(4) >= '2')&&(sn.charAt(4) <= '7'))
         &&((sn.charAt(6) >= '2')&&(sn.charAt(6) <= '7'))
       )
    {
        if ( 
             ((sn.charAt(0) == '7')&&(sn.charAt(1) == 'F'))
             ||((sn.charAt(2) == '7')&&(sn.charAt(3) == 'F'))
             ||((sn.charAt(4) == '7')&&(sn.charAt(5) == 'F'))
             ||((sn.charAt(6) == '7')&&(sn.charAt(7) == 'F'))
           )
        {            
            return false;
        }       
        return true;
    }
    return false;
}

function getMinus(a)
{
	if ( a > '9' )
	{
		if ( (a >= 'A') && (a <= 'F') )  
		{
			return 55;
		}
		else
		{
			return 87;  
		}		  
    }
    else
    {
        return 48;
    }
}

function conv16to12Sn(SerialNum)
{
    var charVid = "";
	var hexVid = "";
	var vssd = "";
	var i;

    hexVid = SerialNum.substr(0,8);
	vssd = SerialNum.substr(8,8);
	
	for(i=0; i<8; i+=2)
	{
		charVid += String.fromCharCode("0x"+hexVid.substr(i, 2));
	}

	return charVid+vssd;
}

var ontInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.ONT,State,ONTInfo);%>;
var ontEPONInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.OAM.ONT,State,ONTInfo);%>;
var ontInfoID = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.ONT.Ontid);&USER=2%>';
var ontPonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';
var deviceInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo, SerialNumber|HardwareVersion|SoftwareVersion|ModelName|X_HW_VendorId|X_HW_ReleaseTime|X_HW_LanMac|Description|ManufactureInfo, stDeviceInfo);%>; 
var ontInfo = ontInfos[0];
var ontEPONInfo = ontEPONInfos[0];
var deviceInfo = deviceInfos[0];

var customizeDes = '<%HW_WEB_GetCustomizeDesc();%>';
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var IsDefaultPwd = '<%IsDefaultPwd();FT=HW_SSMP_FEATURE_WEBADMIN_EXIST&USER=2%>';
var SN = deviceInfo.SerialNumber;	
var sn = deviceInfo.SerialNumber; 
var minus = 0;			
var temp1 = 0;
var temp2 = 0;

var ParentalFlag = '<%HW_WEB_GetFeatureSupport(BBSP_FT_PARENTAL_CONTROL);%>'; 
var systemdsttime = '<%HW_WEB_GetSystemTime();%>'; 
function ParseSystemTime(SystemTime)
{
	if(SystemTime == "")
	{
	  SystemTime = "1970-01-01 01:01#01/01/1970 01:01";
	}
	
	var timeArray=SystemTime.split("#");
	if(curLanguage.toUpperCase() == 'CHINESE')
	{
		document.getElementById('td14_2').innerHTML=timeArray[0];
	}
	else
	{
		document.getElementById('td14_2').innerHTML=timeArray[1];
	}
}

if (isFirst8VisibleChar(sn) == true)  
{
    SN = deviceInfo.SerialNumber + ' ' + '(' + conv16to12Sn(deviceInfo.SerialNumber) + ')';          
}

function LoadFrame()
{
	if(IsDefaultPwd == 1 && 'NOS' == CfgMode.toUpperCase())
	{
		document.getElementById('DefaultNotice').style.display="";
	}
	if(ontPonMode.toUpperCase() == 'GPON' && 'NOS' == CfgMode.toUpperCase())
	{
		document.getElementById('OntId').style.display="";
	}
	var all = document.getElementsByTagName("td");
	for (var i = 0; i < all.length; i++)
	{
		var b = all[i];
		var c = b.getAttribute("BindText");
		if(c == null)
		{
			continue;
		}
		b.innerHTML = DevInfoDes[c];
	}
	
	if (ParentalFlag==1)
	{
		document.getElementById('currenttime').style.display="";
	}
	else
	{
		document.getElementById('currenttime').style.display="none";
	}
	ParseSystemTime(systemdsttime);
}

function GetLanguageDesc(Name)
{
    return DevInfoDes[Name];
}

</script>
</head>
<body  class="mainbody" onLoad="LoadFrame();"> 
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("deviceinfo", GetDescFormArrayById(DevInfoDes, "s0200"), GetDescFormArrayById(DevInfoDes, "s0201"), false);
</script>

<table width="100%" height="5"><tr><td></td></tr></table> 

<div id="deviceinfo" class="configborder">
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg" id="Tabledeviceinfo">
<tr> 
<td class="table_title width_diff11" id="td1_1" BindText="s0202"></td> 
<td class="table_right" id="td1_2">
<script language="javascript">
document.write(deviceInfo.ModelName);
</script> </td> 
</tr>

<tr id="tr2"> 
<td  class="table_title" id="td2_1" BindText="s0203"></td> 
<td class="table_right align_left" id="td2_2" dir="ltr">
<script language="javascript">
document.write(deviceInfo.Description);
</script> </td> 
</tr> 

<tr id="tr3"> 
<td class="table_title" id="td3_1"> 
<script language="javascript">
if (ontPonMode.toUpperCase() == 'GPON')
{
document.write(DevInfoDes['s1611']); 
}
else if (ontPonMode.toUpperCase() == 'EPON')
{
document.write(DevInfoDes['s1612']); 
}
</script> </td> 
<td class="table_right align_left" id="td3_2" dir="ltr"> <script language="javascript">
if (ontPonMode.toUpperCase() == 'GPON')
{
document.write(SN);
}
else if (ontPonMode.toUpperCase() == 'EPON')
{
document.write(deviceInfo.Mac);
}
</script> </td> 
</tr> 

<tr id="tr4"> 
<td  class="table_title" id="td4_1" BindText="s0204"></td> 
<td class="table_right" id="td4_2"> <script language="javascript">
document.write(deviceInfo.HardwareVersion);
</script> </td> 
</tr> 

<tr  id="tr5"> 
<td class="table_title" id="td5_1" BindText="s0205"></td> 
<td class="table_right" id="td5_2"> <script language="javascript">
document.write(deviceInfo.SoftwareVersion);
</script> </td> 
</tr> 

<tr  id="tr6"> 
<td class="table_title" id="td6_1" BindText="s0217"></td> 
<td class="table_right" id="td6_2"> <script language="javascript">
document.write(deviceInfo.ManufactureInfo);
</script> </td> 
</tr> 

<tr  id="tr7"> 
<td class="table_title" id="td7_1" BindText="s0206"></td> 
<td class="table_right" id="td7_2"> <script type="text/javascript" language="javascript">
if (ontPonMode.toUpperCase() == 'GPON')
{   
	if (ontInfo.Status == 'o1' || ontInfo.Status == 'O1')
	{
	document.write(ontInfo.Status + DevInfoDes['s1322']); 
	}
	else if (ontInfo.Status == 'o2' || ontInfo.Status == 'O2')
	{
	document.write(ontInfo.Status + DevInfoDes['s1323']); 
	}
	else if (ontInfo.Status == 'o3' || ontInfo.Status == 'O3')
	{
	document.write(ontInfo.Status+DevInfoDes['s1324']); 
	}
	else if (ontInfo.Status == 'o4' || ontInfo.Status == 'O4')
	{
	document.write(ontInfo.Status+DevInfoDes['s1325']); 
	}
	else if (ontInfo.Status == 'o5' || ontInfo.Status == 'O5')
	{
	document.write(ontInfo.Status+DevInfoDes['s1326']); 
	}
	else if (ontInfo.Status == 'o6' || ontInfo.Status == 'O6')
	{
	document.write(ontInfo.Status+DevInfoDes['s1327']); 
	}
	else if (ontInfo.Status == 'o7' || ontInfo.Status == 'O7')
	{
	document.write(ontInfo.Status+DevInfoDes['s1328']); 
	}
}
else if (ontPonMode.toUpperCase() == 'EPON')
{
	if (ontEPONInfo != null)
	{
		document.write(ontEPONInfo.Status);
	}
	else
	{
		document.write('');
	}
}
else
{
	document.write('');
}
</script> 
</td> 
</tr>

<tr id="currenttime">
<td class="table_title" id="td14_1" BindText="s0226"></td>
<td class="table_right" id="td14_2"></td>
</tr>

<tr  id="OntId" style="display:none"> 
<td  class="table_title" id="tr8_1" BindText="s0207"></td> 
<td class="table_right" id="td8_2">
<script language="javascript">
if (ontInfoID != null)
{
	document.write(ontInfoID);
}
else
{
	document.write('');
}
</script> 
</td> 
</tr> 

<tr id="ShowCustomizeDes">
<td class="table_title" id="td13_1" BindText="s0225"></td>
<td class="table_right" id="td13_2">
<script type="text/javascript" language="javascript">
if (customizeDes != null)
{
	document.write(customizeDes);
}
else
{
	document.write('');
}

</script>
</td>
</tr>
</table> 
</div>
<table width="100%" height="30"><tr><td></td></tr></table> 
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
<tr id="DefaultNotice" style="display:none">
<td class="table_title" id="td13_1" BindText="s2016" style="color:#FF0000"></td>
</tr>
</table> 

</body>
</html>
