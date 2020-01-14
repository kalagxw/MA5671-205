<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" type="text/javascript">
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var devicename ='<%GetAspPoductName();%>';
var deviceTag = "<%HW_WEB_GetDeviceTag();%>";
function stDeviceInfo(domain,SerialNumber,HardwareVersion,SoftwareVersion,ModelName,VendorID,ReleaseTime,Mac,Description,ManufacturerOUI,specsn,DeviceType,AccessType,ManufactureInfo)
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
	this.ManufacturerOUI    = ManufacturerOUI;
	this.specsn             = specsn;
	this.DeviceType         = DeviceType;
	this.AccessType         = AccessType;
	this.ManufactureInfo	= ManufactureInfo;
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

function ONTInfo(domain,ONTID,Status)
{
	this.domain 		= domain;
	this.ONTID			= ONTID;
	this.Status			= Status;
}

function WANIP(domain,name,status,ipGetMode,ip,subnetMask,
                              vlanid, pri8021,serviceList,ExServiceList,modeType,macAddress,enable, dns,defaultGateway,Tr069Flag,IPv4Enable,IPv6Enable)
{
	this.domain 	= domain;
	this.name 		= name;
	this.status 	= status;	
		
	if (modeType == 'IP_Bridged')
	{
	   this.ipGetMode 	= '';
	   this.ip			= '';
	   this.subnetMask	= '';
	   this.defaultGateway = '';
	   this.dns = '';
   }
   else
   {
  	   this.ipGetMode 	= ipGetMode;
	   this.ip			= ip;
	   this.subnetMask	= subnetMask;
	   this.defaultGateway = defaultGateway;
	   this.dns        = dns;
	}

    this.vlanid = vlanid;
    this.pri8021 = pri8021;
    this.serviceList = (ExServiceList.length == 0)?serviceList:ExServiceList;
    this.modeType = modeType;
	this.macAddress = macAddress;
	this.Enable = enable;
	this.Tr069Flag = Tr069Flag;
	this.IPv4Enable = IPv4Enable;
    this.IPv6Enable = IPv6Enable;
	
}

function WANPPP(domain,name,status,ip,vlanid, 
	                        pri8021,serviceList, ExServiceList, modeType,macAddress, ConnectionTrigger, Enable, dns,defaultGateway,Tr069Flag,LastConnectionError,IPv4Enable,IPv6Enable)
{
	this.domain				= domain;
	this.name		 		= name;
	this.status				= status;	
	
	if (modeType == 'PPPoE_Bridged')
	{
	   this.ipGetMode 	= '';
	   this.ip			= '';
	   this.subnetMask	= '';
	   this.defaultGateway = '';
	   this.dns = '';
   }
   else
   {
	  this.ipGetMode	 		= 'PPPoE';
      this.ip				 	= ip;
	  this.subnetMask			= '255.255.255.255';	
	  this.defaultGateway = defaultGateway;
	  this.dns = dns;
   }	

    this.vlanid = vlanid;
    this.pri8021 = pri8021;
    this.serviceList = (ExServiceList.length == 0)?serviceList:ExServiceList;
    this.modeType = modeType;
	this.macAddress = macAddress;
	this.ConnectionTrigger = ConnectionTrigger;
	this.Enable = Enable;
	this.Tr069Flag = Tr069Flag;
	this.LastConnectionError=LastConnectionError;
	this.IPv4Enable = IPv4Enable;
    this.IPv6Enable = IPv6Enable;
	
}

function EPONLinkStatus(domain,FECEnable,EncryptionEnable,LinkAlarmInfo,PONTxPacketsHigh,PONRxPacketsHigh,PONTxPacketsLow,PONRxPacketsLow)
{
    this.Domain = domain;
	this.FECEnable = FECEnable;                 
	this.EncryptionEnable = EncryptionEnable;  
	this.LinkAlarmInfo = LinkAlarmInfo;        
	this.PONTxPacketsHigh = PONTxPacketsHigh;
	this.PONRxPacketsHigh = PONRxPacketsHigh;
	this.PONTxPacketsLow = PONTxPacketsLow;
	this.PONRxPacketsLow = PONRxPacketsLow;

}

function AuthInfo(domain, AuthUserName)
{
	this.Domain = domain;
	this.AuthUserName = AuthUserName;
}

function LineInfo(domain, Status)
{
	this.Domain = domain;
	this.Status = Status;
}
var MngtGdct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_GDCT);%>';
var MngtJsct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_JSCT);%>';
var MngtSzct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SZCT);%>';
var MngtYnct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_YNCT);%>';
var MngtFjct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_FJCT);%>';
var MngtScct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SCCT);%>';
var MngtCqct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_CQCT);%>';
var Mngtct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_CT);%>';
var Wan = new Array();

function VoiceRelationInfo(ErrorDes, ChineseDes)
{
	this.ErrorDes = ErrorDes;
	this.ChineseDes = ChineseDes;
}
var VoiceErrorDes = '<%HW_WEB_GetVoiceRegState();%>';

var VoiceStateInfo = new Array(new VoiceRelationInfo("Error_None", "正常注册"),
							   new VoiceRelationInfo("Error_SBCUnreachable", "网络（SBC）不可达"),
							   new VoiceRelationInfo("Error_AuthenticationFail", "鉴权失败"),
							   new VoiceRelationInfo("Error_VOIPPathFail", "业务通道异常"),
							   new VoiceRelationInfo("Error_Unknown", "其它异常"),
							   null);

function GetVoiceChineseDes(VoiceStateInfo, ErrorDes)
{
	var length = VoiceStateInfo.length;
	
	for( var i = 0; i <  length - 1; i++)
	{
	    if((ErrorDes != '') && (ErrorDes == VoiceStateInfo[i].ErrorDes))
		{
			return VoiceStateInfo[i].ChineseDes;
		}
	}
	return '/';
}

function isFirst8VisibleChar(sn)
{    
    if ( ((sn.charAt(0) >= '2')&&(sn.charAt(0) <= '7'))
         &&((sn.charAt(2) >= '2')&&(sn.charAt(2) <= '7'))
         &&((sn.charAt(4) >= '2')&&(sn.charAt(4) <= '7'))
         &&((sn.charAt(6) >= '2')&&(sn.charAt(6) <= '7')) )
    {
        if ( ((sn.charAt(0) == '7')&&(sn.charAt(1) == 'F'))
             ||((sn.charAt(2) == '7')&&(sn.charAt(3) == 'F'))
             ||((sn.charAt(4) == '7')&&(sn.charAt(5) == 'F'))
             ||((sn.charAt(6) == '7')&&(sn.charAt(7) == 'F')) )
        {            
            return false;
        }

        return true;
    }

    return false;
}
							 

    var ontPonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';
	var ontLedMode = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_LOID_O5AUTH_SHOW);%>';
	var opticInfo = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.Optic.RxPower);%>'; 
	var stInfoStatus = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_UserInfo.X_HW_InformStatus);%>'; 
	
	var ontInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.ONT,Ontid|State,ONTInfo);%>;
    var ontEPONInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.OAM.ONT,Ontid|State,ONTInfo);%>;
    var deviceInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo, SerialNumber|HardwareVersion|SoftwareVersion|ModelName|X_HW_VendorId|X_HW_ReleaseTime|X_HW_LanMac|Description|ManufacturerOUI|X_HW_SpecSn|DeviceType|AccessType|ManufactureInfo, stDeviceInfo);%>; 
	var EponLinkStates = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.EPONLinkInfo,FECEnable|EncryptionEnable|LinkAlarmInfo|PONTxPacketsHigh|PONRxPacketsHigh|PONTxPacketsLow|PONRxPacketsLow,EPONLinkStatus);%>;
    var ontInfo = ontInfos[0];
	var ontEPONInfo = ontEPONInfos[0];
    var deviceInfo = deviceInfos[0];
	var EponLinkState = EponLinkStates[0];
	
	var AllLine = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.1.Line.{i}, Status, LineInfo);%>;
	var AllAuth = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.VoiceService.1.VoiceProfile.1.Line.{i}.SIP, AuthUserName, AuthInfo);%>;
    var WanIp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i},Name|ConnectionStatus|AddressingType|ExternalIPAddress|SubnetMask|X_HW_VLAN|X_HW_PRI|X_HW_SERVICELIST|X_HW_ExServiceList|ConnectionType|MACAddress|Enable|DNSServers|DefaultGateway|X_HW_TR069FLAG|X_HW_IPv4Enable|X_HW_IPv6Enable,WANIP);%>;
	var WanPpp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i},Name|ConnectionStatus|ExternalIPAddress|X_HW_VLAN|X_HW_PRI|X_HW_SERVICELIST|X_HW_ExServiceList|ConnectionType|MACAddress|ConnectionTrigger|Enable|DNSServers|DefaultGateway|X_HW_TR069FLAG|LastConnectionError|X_HW_IPv4Enable|X_HW_IPv6Enable,WANPPP);%>;

	var SN = deviceInfo.SerialNumber;	
	var sn = deviceInfo.SerialNumber; 

	for (i=0, j=0; WanIp.length > 1 && j < WanIp.length - 1; i++,j++)
	{
	  	if("1" == WanIp[j].Tr069Flag || "1" == WanIp[j].IPv6Enable)
		{
			i--;
			continue;
		}
		Wan[i]	= WanIp[j];
	}
	

	for (j=0; WanPpp.length > 1 && j<WanPpp.length - 1; i++,j++)
	{
		if("1" == WanPpp[j].Tr069Flag || "1" == WanPpp[j].IPv6Enable)
		{
			i--;
			continue;
		}
		Wan[i]	= WanPpp[j];
	}


function GetChineseStatus(EnglishStatus)
{
	var statusEnum = '{"Disconnected":"异常", "Connected" : "正常"}';
	var status = eval('('+statusEnum+')'); 
    return status[EnglishStatus] == undefined || typeof(status[EnglishStatus]) == 'undefined' ? "" : status[EnglishStatus];
}

if (isFirst8VisibleChar(sn) == true)  
{
    SN = deviceInfo.SerialNumber + ' ' + '(' + conv16to12Sn(deviceInfo.SerialNumber) + ')';          
}

function MakeWanName(wan)
{
	var wanInst = 0;
	var wanServiceList = '';
	var wanMode = '';
	var vlanId = 0;
	var tmpVirtualDevice = '';
	var currentWanName = '';       

    DomainElement = wan.domain.split(".");
	wanInst = DomainElement[4];
	   
    wanServiceList  = wan.serviceList;
    wanMode         = (wan.modeType == 'IP_Routed' ) ? "R" : "B";
    vlanId          = wan.vlanid;
    
    if ((wanServiceList == "TR069") ||(wanServiceList == "TR069_VOIP")||(wanServiceList == "TR069_INTERNET")||(wanServiceList == "TR069_VOIP_INTERNET")||(wanServiceList == "TR069_IPTV")||(wanServiceList == "TR069_VOIP_IPTV"))
	{
		currentWanName = "ITMS管理通道状态";
	}
	if (wanServiceList == "INTERNET")
	{
		currentWanName = "INTERNET（上网业务）";
	}
	if ((wanServiceList == "VOIP")||(wanServiceList == "VOIP_INTERNET")||(wanServiceList == "VOIP_IPTV"))
	{
		currentWanName = "VOIP（语音业务）";
	}
	if (wanServiceList == "OTHER")
	{
		currentWanName = "ITV业务";
	}
    

      return currentWanName;
    
}


function IsPonOnline()
{
    if (ontPonMode.toUpperCase() != 'GPON' && ontPonMode.toUpperCase() != 'EPON') return true;
	if (ontPonMode.toUpperCase() == 'GPON' && ontInfo.Status.toUpperCase() == 'O5')  return true;
	if (ontPonMode.toUpperCase() == 'GPON' && ontInfo.Status.toUpperCase() == 'O5AUTH')  return true;
	if (ontPonMode.toUpperCase() == 'EPON' && ontEPONInfo.Status.toUpperCase() == 'ONLINE') return true;
	return false;
}


function IsStaticIP(wanTemp)
{
	return wanTemp.ipGetMode.toUpperCase() == "STATIC";
}

function LoadFrame()
{ 
	if (CfgMode.toUpperCase() != 'LNCU')
	{
		document.getElementById('tr13').style.display="none";
		document.getElementById('tr50').style.display="none";
	}
	else
	{
		document.getElementById('tr5').style.display="none";	
	}
}

function ComBinVersionAndTime(Version, Time)
{
	return Version + "_" + Time.substr(2, 2) + Time.substr(5, 2);
}


</script>
</head>
<body  class="mainbody" onLoad="LoadFrame();"> 
<table width="100%" border="0" cellspacing="0" cellpadding="0" id="tabTest"> 
  <tr> 
    <td class="prompt"><table width="100%" border="0" cellspacing="0" cellpadding="0"> 
        <tr> 
          <td class="title_01" style="padding-left:10px;" width="100%">在本页面上，您可以查看设备的基本信息。</td> 
        </tr> 
      </table></td> 
  </tr> 
</table> 
<table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"> 
  <tr> 
    <td></td> 
  </tr> 
</table> 
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="Tabledeviceinfo"> 
  <tr  id="tr3" name="tr3"> 
    <td class="table_title" width="25%" align="left" id="td3_1" name="td3_1" >设备型号:&nbsp;</td> 
    <td class="table_right" width="75%" id="td3_2" name="td3_2"> 
		<script language="javascript">
		if (deviceInfo != null)
		{
			document.write(devicename);
		}
		else
		{
			document.write('');
		}
		</script>
 	</td> 
  </tr> 
  <tr id="tr4" name="tr4"> 
    <td  class="table_title" align="left" id="td4_1" name="td4_1">描述:&nbsp;</td> 
    <td class="table_right" id="td4_2" name="td4_2">
<script language="javascript">
	if (deviceInfo != null)
	{
		document.write(deviceInfo.Description);
	}
	else
	{
		document.write('');
	}
</script> </td> 
  </tr> 
  <tr id="tr5" name="tr5"> 
    <td class="table_title" width="25%" align="left" id="td5_1" name="td5_1">设备标识号:&nbsp;</td> 
    <td class="table_right" align="left" width="75%" id="td5_2" name="td5_2"> <script language="javascript">
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
  
  <tr id="tr50" name="tr50"> 
    <td class="table_title"  id="td50_1" </td> 
    <script language="javascript">
	if (ontPonMode.toUpperCase() == 'GPON')
	{
		document.write("SN:&nbsp;");
	}
	else if (ontPonMode.toUpperCase() == 'EPON')
	{
		document.write("Mac:&nbsp;");
	}
	</script> </td>
	<td class="table_right" align="left" id="td50_2"> 
	<script language="javascript">
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
      
  <tr id="tr6" name="tr6"> 
    <td  class="table_title" align="left" id="td6_1" name="td6_1">硬件版本:&nbsp;</td> 
    <td class="table_right" id="td6_2" name="td6_2"> 
<script language="javascript">
	if (deviceInfo != null)
	{
		document.write(deviceInfo.HardwareVersion);
	}
	else
	{
		document.write('');
	}
</script> </td> 
  </tr> 
  <tr  id="tr7" name="tr7"> 
    <td class="table_title" align="left" id="td7_1" name="td7_1">软件版本:&nbsp;</td> 
    <td class="table_right" id="td7_2" name="td7_2"> <script language="javascript">
	if ('GDCU' == CfgMode.toUpperCase())
	{
		var VersionAndTime = ComBinVersionAndTime(deviceInfo.SoftwareVersion, deviceInfo.ReleaseTime);
		document.write(VersionAndTime);
	}
	else
	{
		document.write(deviceInfo.SoftwareVersion);
	}
</script> </td> 
  </tr> 
  <tr  id="tr8" name="tr8"> 
    <td class="table_title" align="left" id="td8_1" name="td8_1">制造信息:&nbsp;</td> 
    <td class="table_right" id="td8_2" name="td8_2"> <script language="javascript">
	if (deviceInfo != null)
	{
		document.write(deviceInfo.ManufactureInfo);
	}
	else
	{
		document.write('');
	}
</script> </td> 
  </tr> 
<script type="text/javascript" language="javascript">
			document.write('<tr  id="tr9" name="tr9">');

		
			document.write('<td class="table_title" align="left" id="td9_1" name="td9_1">ONT注册状态:&nbsp;</td>');
			document.write('<td class="table_right" id="td9_1" name="td9_2">');
			
			if (ontPonMode == 'gpon' || ontPonMode == 'GPON')
			{ 
				if ('1' == ontLedMode)
				{
        			if (ontInfo.Status == 'o5AUTH' || ontInfo.Status == 'O5AUTH')
					{
						document.write("失败 - 已注册未认证。");
					}
					else if (ontInfo.Status == 'o5' || ontInfo.Status == 'O5')
					{
						document.write("成功 - 已注册已认证。");
					}
					else
					{
						document.write("失败 - 未注册未认证。");
					}
				}
				else
				{			
						if (ontInfo.Status == 'o1' || ontInfo.Status == 'O1')
						{
							document.write(ontInfo.Status+' (Initial state)'); 
						}
						else if (ontInfo.Status == 'o2' || ontInfo.Status == 'O2')
						{
							document.write(ontInfo.Status+' (Standby state)'); 
						}
						else if (ontInfo.Status == 'o3' || ontInfo.Status == 'O3')
						{
							document.write(ontInfo.Status+' (Serial-Number state)'); 
						}
						else if (ontInfo.Status == 'o4' || ontInfo.Status == 'O4')
						{
							document.write(ontInfo.Status+' (Ranging state)'); 
						}
						else if (ontInfo.Status == 'o5' || ontInfo.Status == 'O5')
						{
							document.write(ontInfo.Status+' (Operation state)'); 
						}
						else if (ontInfo.Status == 'o6' || ontInfo.Status == 'O6')
						{
							document.write(ontInfo.Status+' (POPUP state)'); 
						}
						else if (ontInfo.Status == 'o7' || ontInfo.Status == 'O7')
						{
							document.write(ontInfo.Status+' (Emergency-Stop state)'); 
						}
						else
						{
							document.write(''); 
						}
				}	
				
			}
			else if (ontPonMode == 'epon' || ontPonMode == 'EPON')
			{
			   if (ontEPONInfo != null)
				{
					if ('1' == ontLedMode)
					{
            			if ("ONLINE AUTHING" == ontEPONInfo.Status)
						{
                			document.write("失败 - 已注册未认证。");
						}
						else if("ONLINE" == ontEPONInfo.Status)
						{
							document.write("成功 - 已注册已认证。");
						}
						else
						{
                			document.write("失败 - 未注册未认证。");
						}
					}
					else
					{
						if ( "OFFLINE" == ontEPONInfo.Status)
						{
							document.write("未注册，未授权。");
						}
						else if("ONLINE" == ontEPONInfo.Status)
						{
							document.write("已注册，已授权。");;
						}
						else
						{
							document.write("已注册，未授权。");
						}
					}
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
		
		<script type="text/javascript" language="javascript">

			if (ontPonMode == 'gpon' || ontPonMode == 'GPON')
			{
				document.write('<tr id="tr12" name="tr12">');
				document.write('<td  class="table_title" align="left" id="tr12_1" name="tr12_1">ONT ID:&nbsp;</td>');
				document.write('<td  class="table_right" id="tr12_2" name="tr12_2">');
				if (ontInfo != null)
				{
					document.write(ontInfo.ONTID);
				}
				else
				{
					document.write('');
				}
				document.write('</td></tr>');
			}
    
		</script>
		
      <tr id="tr13" name="tr13"> 
    <td class="table_title" width="25%" align="left" id="td13_1" name="td13_1">设备标识号:&nbsp;</td> 
    <td class="table_right" width="75%" id="td13_2" name="td13_2"> <script language="javascript">
		document.write(deviceTag);
	</script> </td> 
  </tr>     	 
</table> 
</body>
</html>
