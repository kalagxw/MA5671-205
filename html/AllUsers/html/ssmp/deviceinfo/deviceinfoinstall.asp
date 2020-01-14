<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
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

function ONTInfo(domain,ONTID,Status)
{
	this.domain 		= domain;
	this.ONTID			= ONTID;
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

var ONTUserServices =  '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_UserServiceInfo.ServiceDescription);FT=HW_SSMP_FEATURE_MNGT_PCCW&USER=3%>';
var ontInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.ONT,Ontid|State,ONTInfo);%>;
var ontEPONInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.OAM.ONT,Ontid|State,ONTInfo);%>;
var ontPonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';
var deviceInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo, SerialNumber|HardwareVersion|SoftwareVersion|ModelName|X_HW_VendorId|X_HW_ReleaseTime|X_HW_LanMac|Description|ManufactureInfo, stDeviceInfo);%>; 
var ontInfo = ontInfos[0];
var ontEPONInfo = ontEPONInfos[0];
var deviceInfo = deviceInfos[0];
var showCPUnMemUsed = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_SHOWCPUMEM);%>';
var cpuUsed = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.X_HW_CpuUsed);%>%';
var memUsed = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.X_HW_MemUsed);%>%';
var MngtPccw = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_PCCW);%>';
var MngtTelmex = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_TELMEX);%>'; 
var SonetNorType = "<%HW_WEB_GetUserType();FT=HW_SSMP_FEATURE_MNGT_SONET&USER=1%>";


var customizeDes = '<%HW_WEB_GetCustomizeDesc();%>';

var dev_uptime = '<%HW_WEB_GetOsUpTime();FT=HW_SSMP_FEATURE_MNGT_TELMEX&USER=3%>';
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

function SetUptime()
{
	dev_uptime++;
	var second = parseInt(dev_uptime);
	var dd = parseInt(second/(3600*24));
	var hh = parseInt((second%(3600*24))/3600);
	var mm = parseInt((second%3600)/60);
	var ss = parseInt(second%60);
	var strtime = "";

	if (dd <= 1)
	{
		strtime += dd + GetLanguageDesc("s020f");
	}
	else
	{
		strtime += dd + GetLanguageDesc("s0213");
	}

	if (hh <= 1)
	{
		strtime += hh + GetLanguageDesc("s0210");
	}
	else
	{
		strtime += hh + GetLanguageDesc("s0214");
	}

	if (mm <= 1)
	{
		strtime += mm + GetLanguageDesc("s0211");
	}
	else
	{
		strtime += mm + GetLanguageDesc("s0215");
	}

	if (ss <= 1)
	{
		strtime += ss + GetLanguageDesc("s0212");
	}
	else
	{
		strtime += ss + GetLanguageDesc("s0216");
	}
	getElById("ShowTime").innerHTML = strtime;
}

function LoadFrame()
{  
	if ( showCPUnMemUsed != 1 
		|| (MngtPccw == 1) )
	{
		document.getElementById('td9_2Row').style.display="none";
		document.getElementById('td10_2Row').style.display="none";
	}
	
	if ( MngtPccw != 1 )
	{
		document.getElementById('td11_2Row').style.display="none";
	}
	
	if(ontPonMode.toUpperCase() == 'EPON')
	{
		document.getElementById('td8_2Row').style.display="none";
	}
	if (1 == SonetNorType)
	{
		document.getElementById('td8_2Row').style.display="none";
		document.getElementById('td9_2Row').style.display="none";
		document.getElementById('td10_2Row').style.display="none";
	}
	
	if(MngtTelmex != 1)
	{
		document.getElementById('ShowTimeRow').style.display="none";
	}
	else
	{
		SetUptime();
		document.getElementById('td3_2').innerHTML=conv16to12Sn(deviceInfo.SerialNumber).toUpperCase();
		setInterval("SetUptime();", 1000);
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
		document.getElementById('td14_2Row').style.display="";
	}
	else
	{
		document.getElementById('td14_2Row').style.display="none";
	}
	ParseSystemTime(systemdsttime);
}

function GetLanguageDesc(Name)
{
    return DevInfoDes[Name];
}
function GetONTRegisterStatus()
{
	if (ontPonMode.toUpperCase() == 'GPON')
	{   
		if (ontInfo.Status == 'o1' || ontInfo.Status == 'O1')
		{
			document.getElementById('td7_2').innerHTML = ontInfo.Status + DevInfoDes['s1322'];
		}
		else if (ontInfo.Status == 'o2' || ontInfo.Status == 'O2')
		{
			document.getElementById('td7_2').innerHTML = ontInfo.Status + DevInfoDes['s1323'];
		}
		else if (ontInfo.Status == 'o3' || ontInfo.Status == 'O3')
		{
			document.getElementById('td7_2').innerHTML = ontInfo.Status + DevInfoDes['s1324'];
		}
		else if (ontInfo.Status == 'o4' || ontInfo.Status == 'O4')
		{
			document.getElementById('td7_2').innerHTML = ontInfo.Status + DevInfoDes['s1325'];
		}
		else if (ontInfo.Status == 'o5' || ontInfo.Status == 'O5')
		{
			document.getElementById('td7_2').innerHTML = ontInfo.Status + DevInfoDes['s1326'];
		}
		else if (ontInfo.Status == 'o6' || ontInfo.Status == 'O6')
		{
			document.getElementById('td7_2').innerHTML = ontInfo.Status + DevInfoDes['s1327'];
		}
		else if (ontInfo.Status == 'o7' || ontInfo.Status == 'O7')
		{
			document.getElementById('td7_2').innerHTML = ontInfo.Status + DevInfoDes['s1328'];
		}
	}
	else if (ontPonMode.toUpperCase() == 'EPON')
	{
		if (ontEPONInfo != null)
		{
			if(curLanguage.toUpperCase() == 'CHINESE')
			{	
				if ( "OFFLINE" == ontEPONInfo.Status)
				{
					document.getElementById('td7_2').innerHTML = GetLanguageDesc("s020b");
				}
				else if("ONLINE" == ontEPONInfo.Status)
				{
					document.getElementById('td7_2').innerHTML = GetLanguageDesc("s020c");
				}
				else
				{
					document.getElementById('td7_2').innerHTML = GetLanguageDesc("s020d");
				}
			
			}
			else
			{
				document.getElementById('td7_2').innerHTML = ontEPONInfo.Status;
			}

		}
		else
		{
			document.getElementById('td7_2').innerHTML = '';
		}
	}
	else
	{
		document.getElementById('td7_2').innerHTML = '';
	}
}
function GetSnOrMacInfo()
{
	if (ontPonMode.toUpperCase() == 'GPON')
	{
		document.getElementById('td3_2Colleft').innerHTML = DevInfoDes['s1611'];
	}
	else if (ontPonMode.toUpperCase() == 'EPON')
	{
		document.getElementById('td3_2Colleft').innerHTML = DevInfoDes['s1612'];
	}
	var  var_deviceMac = "";
	if (ontPonMode.toUpperCase() == 'GPON')
	{
		document.getElementById('td3_2').innerHTML = SN;
	}
	else if (ontPonMode.toUpperCase() == 'EPON')
	{
	   if (CfgMode.toUpperCase()  == 'BJUNICOM')
	   {
			var_deviceMac = deviceInfo.Mac.replace(/\:/g,"-");
			document.getElementById('td3_2').innerHTML = var_deviceMac;
	   }
	   else
	   {
			document.getElementById('td3_2').innerHTML = deviceInfo.Mac;
	   }
	}
}
function GetOntId()
{
	if (ontInfo != null)
	{
		document.getElementById('td8_2').innerHTML = ontInfo.ONTID;
	}
	else
	{
		document.getElementById('td8_2').innerHTML = '';
	}
}
function GetCpuUsed()
{
	if (cpuUsed != null)
	{
		document.getElementById('td9_2').innerHTML = cpuUsed;
	}
	else
	{
		document.getElementById('td9_2').innerHTML = '';
	}
}
function GetMemUsed()
{
	if (memUsed != null)
	{
		document.getElementById('td10_2').innerHTML = memUsed;
	}
	else
	{
		document.getElementById('td10_2').innerHTML = '';
	}
}
function GetCustomizeInfo()
{
	if (customizeDes != null)
	{
		document.getElementById('td13_2').innerHTML = customizeDes;
	}
	else
	{
		document.getElementById('td13_2').innerHTML = '';
	}
}
</script>
</head>
<body  class="mainbody" onLoad="LoadFrame();"> 
<table width="100%" border="0" cellspacing="0" cellpadding="0" id="tabTest"> 
<tr> 
<td class="prompt"><table width="100%" border="0" cellspacing="0" cellpadding="0"> 
<tr> 
<td class="title_common">Información básica de dispositivo.</td> 
</tr> 
</table></td> 
</tr> 
</table> 
<div class="title_spread"></div>

<form id="deviceInfoForm" name="deviceInfoForm">
<table id="deviceInfoFormPanel" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">
<li id="td1_2" RealType="HtmlText" DescRef="s0202" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="td1_2" InitValue="Empty" />
<li id="td2_2" RealType="HtmlText" DescRef="s0203" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="td2_2" InitValue="Empty" />
<li id="td3_2" RealType="HtmlText" DescRef="Empty" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="td3_2" InitValue="Empty" />
<li id="td4_2" RealType="HtmlText" DescRef="s0204" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="td4_2" InitValue="Empty" />
<li id="td5_2" RealType="HtmlText" DescRef="s0205" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="td5_2" InitValue="Empty" />
<li id="td6_2" RealType="HtmlText" DescRef="s0217" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="td6_2" InitValue="Empty" />
<li id="td7_2" RealType="HtmlText" DescRef="s0206" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="td7_2" InitValue="Empty" />
<li id="td8_2" RealType="HtmlText" DescRef="s0207" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="td8_2" InitValue="Empty" />
<li id="td9_2" RealType="HtmlText" DescRef="s0208" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="td9_2" InitValue="Empty" />
<li id="td10_2" RealType="HtmlText" DescRef="s0209" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="td10_2" InitValue="Empty" />
<li id="td11_2" RealType="HtmlText" DescRef="s020a" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="td11_2" InitValue="Empty" />
<li id="ShowTime" RealType="HtmlText" DescRef="s020e" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="ShowTime" InitValue="Empty" />
<li id="td13_2" RealType="HtmlText" DescRef="s0225" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="td13_2" InitValue="Empty" />
<li id="td14_2" RealType="HtmlText" DescRef="s0226" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="td14_2" InitValue="Empty" />
</table>
<script>
var TableClass = new stTableClass("table_title", "table_right align_left","ltr");
var deviceInfoFormList = new Array();
deviceInfoFormList = HWGetLiIdListByForm("deviceInfoForm",null);
HWParsePageControlByID("deviceInfoForm",TableClass,DevInfoDes,null);
document.getElementById('td1_2').innerHTML = deviceInfo.ModelName;
document.getElementById('td2_2').innerHTML = deviceInfo.Description;
GetSnOrMacInfo();
document.getElementById('td4_2').innerHTML = deviceInfo.HardwareVersion;
document.getElementById('td5_2').innerHTML = deviceInfo.SoftwareVersion;
document.getElementById('td6_2').innerHTML = deviceInfo.ManufactureInfo;
GetONTRegisterStatus();
GetOntId();
GetCpuUsed();
GetMemUsed();
document.getElementById('td11_2').innerHTML = ONTUserServices;
GetCustomizeInfo();
</script>
</form>
</body>
</html>
