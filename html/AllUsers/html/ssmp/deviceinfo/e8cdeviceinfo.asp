<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../../bbsp/common/topoinfo.asp"></script>
<script language="javascript" src="../../bbsp/common/wanipv6state.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list_info.asp"></script> 
<script language="javascript" src="../../bbsp/common/wan_list.asp"></script>
<script language="javascript" src="../../amp/common/wlan_list.asp"></script>
<script language="javascript" src="../../bbsp/common/lanuserinfo.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var TopoInfo = GetTopoInfo();
var curUserType = '<%HW_WEB_GetUserType();%>';

function stDeviceInfo(domain,SerialNumber,HardwareVersion,SoftwareVersion,ModelName,VendorID,ReleaseTime,Mac,Description,ManufacturerOUI,specsn,DeviceType,AccessType,ManufactureInfo,ImageSize)
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
	this.ImageSize       	= ImageSize;
}	

function ONTInfo(domain,ONTID,Status)
{
	this.domain 		= domain;
	this.ONTID			= ONTID;
	this.Status			= Status;
}

var SimConnStates=<%HW_Web_GetCardOntAuthState(stAuthState);%>;
var SimIsAuth=SimConnStates[0].AuthState;
function filterWanOnlyTr069(WanItem)
{
	if ("0" == SimIsAuth && WanItem.serviceList.indexOf("TR069") < 0)
	{
	    return false;
	}
	return true;
}
function stWlanInfo(domain,enable,name,ssid)
{
    this.domain = domain;
    this.enable = enable;
    this.name = name;
    this.ssid = ssid;
}

function GetProtocolType(IPv4Enable, IPv6Enable)
{
    if (IPv4Enable == "1" && IPv6Enable == "1")
    {
        return "IPv4/IPv6";
    }
    if (IPv4Enable == "1")
    {
        return "IPv4";
    }
    return "IPv6"
}

function GetWanName(wan)
{
    var wanInst = 0;
    var wanServiceList = '';
    var wanMode = '';
    var vlanId = 0;
    var currentWanName = '';

    wanInst = wan.MacId;
    wanServiceList  = wan.serviceList;
    wanMode         = (wan.modeType == 'IP_Routed' ) ? "R" : "B";
    vlanId          = wan.vlanid;
   
	if (0 != parseInt(vlanId))
	{
		currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_" + vlanId;
	}
	else
	{
		currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_";
	}
    
	for (i = 0;i < GetWanList().length;i++)
	{
		var CurrentWan = GetWanList()[i];
		if (CurrentWan.MacId ==  wan.MacId)
		{
			return CurrentWan.Name;
		}        
	}

    return currentWanName;
}    

function WANIP(domain,name,status,ipGetMode,ip,subnetMask,
                              vlanid, pri8021,serviceList,ExServiceList,modeType,macAddress,enable, dns,defaultGateway,Tr069Flag,MacId,IPv4Enable,IPv6Enable)
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
	this.MacId = MacId;
	this.IPv4Enable = IPv4Enable;
    this.IPv6Enable = IPv6Enable;
	this.ProtocolType = GetProtocolType(IPv4Enable, IPv6Enable);
	
}

function WANPPP(domain,name,status,ip,vlanid, 
	                        pri8021,serviceList, ExServiceList, modeType,macAddress, ConnectionTrigger, Enable, dns,defaultGateway,Tr069Flag,LastConnectionError,MacId,IPv4Enable,IPv6Enable)
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
	this.MacId = MacId;
	this.IPv4Enable = IPv4Enable;
    this.IPv6Enable = IPv6Enable;
	this.ProtocolType = GetProtocolType(IPv4Enable, IPv6Enable);

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
							 
function stResultInfo(domain, Result, Status, InformStatus)
{
	this.domain = domain;
	this.Result = Result;
	this.Status = Status;
    this.InformStatus	= InformStatus;
}
function stAuthGetLoidPwd(domain,Loid,Password)
{
    this.domain   = domain;
    this.Loid     = Loid;
    this.Password = Password;
}

function PonOpticInfo(domain,transOpticPower, revOpticPower)
{
    this.Domain = domain;
	this.TransOpticPower = transOpticPower;
	this.RevOpticPower = revOpticPower;
}
var PonOpticInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.Optic,TxPower|RxPower, PonOpticInfo);%>;
var PonOpticInfo = PonOpticInfoList[0];

var AuthInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_UserInfo, UserName|UserId, stAuthGetLoidPwd);%>;
var LoidPwdInfo = AuthInfo[0]; 
    var ontPonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';
	var ontLedMode = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_LOID_O5AUTH_SHOW);%>';
	var opticInfo = PonOpticInfo.RevOpticPower;
	var stInfoStatus = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_UserInfo.X_HW_InformStatus);%>'; 
var stResultInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_UserInfo, Result|Status|X_HW_InformStatus, stResultInfo);%>;
var Infos = stResultInfos[0];
	var ontInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.ONT,Ontid|State,ONTInfo);%>;
    var ontEPONInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.OAM.ONT,Ontid|State,ONTInfo);%>;
    var deviceInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo, SerialNumber|HardwareVersion|SoftwareVersion|ModelName|X_HW_VendorId|X_HW_ReleaseTime|X_HW_LanMac|Description|ManufacturerOUI|X_HW_SpecSn|DeviceType|AccessType|ManufactureInfo|X_HW_ImageSize, stDeviceInfo);%>; 
	var EponLinkStates = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.EPONLinkInfo,FECEnable|EncryptionEnable|LinkAlarmInfo|PONTxPacketsHigh|PONRxPacketsHigh|PONTxPacketsLow|PONRxPacketsLow,EPONLinkStatus);%>;
    var ontInfo = ontInfos[0];
	var ontEPONInfo = ontEPONInfos[0];
    var deviceInfo = deviceInfos[0];
	var EponLinkState = EponLinkStates[0];
	
    var WanIp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i},Name|ConnectionStatus|AddressingType|ExternalIPAddress|SubnetMask|X_HW_VLAN|X_HW_PRI|X_HW_SERVICELIST|X_HW_ExServiceList|ConnectionType|MACAddress|Enable|DNSServers|DefaultGateway|X_HW_TR069FLAG|X_HW_MacId|X_HW_IPv4Enable|X_HW_IPv6Enable,WANIP);%>;
	var WanPpp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i},Name|ConnectionStatus|ExternalIPAddress|X_HW_VLAN|X_HW_PRI|X_HW_SERVICELIST|X_HW_ExServiceList|ConnectionType|MACAddress|ConnectionTrigger|Enable|DNSServers|DefaultGateway|X_HW_TR069FLAG|LastConnectionError|X_HW_MacId|X_HW_IPv4Enable|X_HW_IPv6Enable,WANPPP);%>;

	for (i=0, j=0; WanIp.length > 1 && j < WanIp.length - 1; i++,j++)
	{
	  	if("1" == WanIp[j].Tr069Flag )
		{
			i--;
			continue;
		}
		if(filterWanOnlyTr069(WanIp[j]) == false )
		{
			i--;
			continue;
		}
		if (( 1 == MngtFjct || 1 == MngtScct || 1 == MngtCqct) && ("1" == WanIp[j].IPv6Enable))
		{
			i--;
			continue;
			
		}
		Wan[i]	= WanIp[j];
	}
	

	for (j=0; WanPpp.length > 1 && j<WanPpp.length - 1; i++,j++)
	{
		if("1" == WanPpp[j].Tr069Flag )
		{
			i--;
			continue;
		}
		if(filterWanOnlyTr069(WanPpp[j]) == false )
		{
			i--;
			continue;
		}
		if (( 1 == MngtFjct || 1 == MngtScct || 1 == MngtCqct) && ("1" == WanPpp[j].IPv6Enable))
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
function MakeConnectionMode(Wan,Type)
{
	var currentConnectionMode = "";
	if( Wan.modeType =="IP_Routed")
	{	
		if(Wan.serviceList.indexOf("INTERNET") >= 0 && Type == "INTERNET")
		{
			currentConnectionMode = "路由（网关拨号）";
		}
		else
		{
			currentConnectionMode = "路由";
		}
	}
	if((Wan.modeType =="IP_Bridged"|| Wan.modeType =="PPPoE_Bridged"))
	{
		if(Wan.serviceList.indexOf("INTERNET") >= 0 && Type == "INTERNET")
		{
			currentConnectionMode = "桥接（电脑拨号）";
		}
		else
		{
			currentConnectionMode = "桥接";
		}
	}
	return currentConnectionMode;
}

function GetStatus(Status)
{
	var currentStatus = "";
	if("UNCONFIGURED" == Status.toUpperCase())
	{
		currentStatus = "未配置";
	}
	else if("CONNECTED" == Status.toUpperCase())
	{
		currentStatus = "可用";
	}
	else
	{
		currentStatus = "不可用";
	}
	return currentStatus;
}

function MakeStatus(Wan,type)
{
	var currentStatus = "";
	if("1" != Wan.Enable)
	{
		currentStatus = "未启用";
	}
	else if(ontPonMode == 'gpon' || ontPonMode == 'GPON')
	{
		if ((ontInfo.Status.toUpperCase() != 'O5') && (ontInfo.Status.toUpperCase() != 'O5AUTH'))
		{
			currentStatus = "不可用";
		}
		else
		{
			if((Wan.serviceList == "TR069") ||(Wan.serviceList == "TR069_VOIP")||(Wan.serviceList == "TR069_INTERNET")||(Wan.serviceList == "TR069_VOIP_INTERNET"))
			{
				if( '0' == stInfoStatus )
				{
					currentStatus = "可用";
				}
				else
				{
					currentStatus = "不可用";
				} 
			}
			else
			{
				if("IPv6" == type)
				{
					var ipv6Wan = GetIPv6WanInfo(Wan.MacId);
					currentStatus = GetStatus(ipv6Wan.ConnectionStatus);
				}
				else
				{
					currentStatus = GetStatus(Wan.status);
				}
			}
		  
		}
	}
	else if (ontPonMode == 'epon' || ontPonMode == 'EPON')
	{
			if (ontEPONInfo != null)
			{
				if (ontEPONInfo.Status == 'OFFLINE')
				{
					currentStatus = "不可用";
				}
				else if (ontEPONInfo.Status == 'ONLINE')
				{
					if((Wan.serviceList == "TR069") ||(Wan.serviceList == "TR069_VOIP")||(Wan.serviceList == "TR069_INTERNET")||(Wan.serviceList == "TR069_VOIP_INTERNET"))
					{
						if( '0' == stInfoStatus)
						{
							currentStatus = "可用";
						}
						else
						{
							currentStatus = "不可用";
						} 
					}
					else
					{
						if("IPv6" == type)
						{
							var ipv6Wan = GetIPv6WanInfo(Wan.MacId);
							currentStatus = GetStatus(ipv6Wan.ConnectionStatus);
						}
						else
						{
							currentStatus = GetStatus(Wan.status);
						}
					}
					
				}
				else
				{
					currentStatus = "不可用";
				}
			}
			else
			{
				currentStatus = "不可用";
			}
	}
	else
	{
		currentStatus = "不可用";
	}
	return currentStatus;
}

function MakeBindPort(Wan,Type)
{
	var currentBindPortInfo = "";
	var WlanBindPortInfo = "";
	var LanBindPortInfo = "";
	var BindPortInfo = GetLanWanBindInfo(domainTowanname(Wan.domain));
	var WlanInfo = new Array();
	
	if (BindPortInfo != null && BindPortInfo != undefined)
    {
		var BindPortInfoList = BindPortInfo.PhyPortName.split(",");
		var LanBindPortNumber = 0;
		var WlanBindPortNumber = 0;
		for(var i = 0; i < BindPortInfoList.length; i++)
		{
			if("LAN1" == BindPortInfoList[i].toUpperCase())
			{
				LanBindPortInfo += "网口1，";
				LanBindPortNumber++;
			}
			if("LAN2" == BindPortInfoList[i].toUpperCase())
			{
				if(parseInt(TopoInfo.EthNum,10) > 2)
				{
					LanBindPortInfo += "iTV，";
				}
				else
				{
					LanBindPortInfo += "网口2，";
				}
				LanBindPortNumber++;
			}
			if("LAN3" == BindPortInfoList[i].toUpperCase())
			{
				LanBindPortInfo += "网口3，";
				LanBindPortNumber++;
			}
			if("LAN4" == BindPortInfoList[i].toUpperCase())
			{
				LanBindPortInfo += "网口4，";
				LanBindPortNumber++;
			}

			if("SSID1" == BindPortInfoList[i].toUpperCase())
			{
				WlanInfo = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.1,Enable|Name|SSID,stWlanInfo);%>; 
				if(WlanInfo.length - 1 > 0)
				{
					WlanBindPortInfo += WlanInfo[0].ssid + qos_language['bbsp_comma'];
					WlanBindPortNumber++;
			  }
			}
			if("SSID2" == BindPortInfoList[i].toUpperCase())
			{
				WlanInfo = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.2,Enable|Name|SSID,stWlanInfo);%>; 
				if(WlanInfo.length - 1 > 0)
				{
					WlanBindPortInfo += WlanInfo[0].ssid + qos_language['bbsp_comma'];
					WlanBindPortNumber++;
			  }
			}
			if("SSID3" == BindPortInfoList[i].toUpperCase())
			{
				WlanInfo = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.3,Enable|Name|SSID,stWlanInfo);%>; 
				if(WlanInfo.length - 1 > 0)
				{
					WlanBindPortInfo += WlanInfo[0].ssid + qos_language['bbsp_comma'];
					WlanBindPortNumber++;
			  }
			}
			if("SSID4" == BindPortInfoList[i].toUpperCase())
			{
				WlanInfo = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.4,Enable|Name|SSID,stWlanInfo);%>; 
				if(WlanInfo.length - 1 > 0)
				{
					WlanBindPortInfo += WlanInfo[0].ssid + qos_language['bbsp_comma'];
					WlanBindPortNumber++;
			  }
			}
			
		}
		LanBindPortInfo = LanBindPortInfo.substring(0,LanBindPortInfo.lastIndexOf('，'));
		WlanBindPortInfo = WlanBindPortInfo.substring(0,WlanBindPortInfo.lastIndexOf('，'));
		if(("INTERNET" == Type) || (("OTHER" == Type) && (WlanBindPortNumber > 0)))
		{
			if(LanBindPortNumber > 0)
			{
				currentBindPortInfo = "有线：" + LanBindPortInfo;
			}
			if(WlanBindPortNumber > 0)
			{
				if(LanBindPortNumber > 0)
				{
					currentBindPortInfo = currentBindPortInfo + "<br>";
				}
				currentBindPortInfo = currentBindPortInfo + "无线：" + WlanBindPortInfo;
			}
		}
		else if("OTHER" == Type)
		{
			currentBindPortInfo = LanBindPortInfo;
		}
		else if("VOIP" == Type)
		{
			currentBindPortInfo = "电话";
		}
		else
		{
			currentBindPortInfo = "";
		}
		
    }
	else
	{
		currentBindPortInfo = "";
	}
	return currentBindPortInfo;
}


function JumpToPage1()
{
	top.Frame.changeMenuShow('Menu1_Network','Menu2_Net_Network','Menu3_NN_WAN');
}

function JumpToPage2()
{
	top.Frame.changeMenuShow('Menu1_Status','Menu2_Sta_Overview','Menu3_SO_Wizard');
}

function IsPonOnline()
{
    if (ontPonMode.toUpperCase() != 'GPON' && ontPonMode.toUpperCase() != 'EPON') return true;
	if (ontPonMode.toUpperCase() == 'GPON' && ontInfo.Status.toUpperCase() == 'O5')  return true;
	if (ontPonMode.toUpperCase() == 'GPON' && ontInfo.Status.toUpperCase() == 'O5AUTH')  return true;
	if (ontPonMode.toUpperCase() == 'EPON' && ontEPONInfo.Status.toUpperCase() == 'ONLINE') return true;
	return false;
}

function OltRegStatusInfo()
{
	if (ontPonMode == 'gpon' || ontPonMode == 'GPON')
	{ 
		if ('1' == ontLedMode)
		{
			if (ontInfo.Status == 'o5AUTH' || ontInfo.Status == 'O5AUTH')
			{
				document.write("失败 - 已注册未认证（请检查收光功率或确认LOID是否正确）");
			}
			else if (ontInfo.Status == 'o5' || ontInfo.Status == 'O5')
			{
				document.write("成功 - 已注册已认证");
			}
			else
			{
				document.write("失败 - 未注册未认证（请检查收光功率或确认LOID是否正确）");
			}
		} 
		else
		{
			if (ontInfo.Status == 'o1' || ontInfo.Status == 'O1')
			{
				document.write("注册失败（请检查收光功率或确认LOID是否正确）"); 
			}
			else if (ontInfo.Status == 'o2' || ontInfo.Status == 'O2')
			{
				document.write("注册失败（请检查收光功率或确认LOID是否正确）"); 
			}
			else if (ontInfo.Status == 'o3' || ontInfo.Status == 'O3')
			{
				document.write("注册失败（请检查收光功率或确认LOID是否正确）"); 
			}
			else if (ontInfo.Status == 'o4' || ontInfo.Status == 'O4')
			{
				document.write("注册失败（请检查收光功率或确认LOID是否正确）"); 
			}
			else if (ontInfo.Status == 'o5' || ontInfo.Status == 'O5')
			{
				document.write("注册正常"); 
			}
			else if (ontInfo.Status == 'o6' || ontInfo.Status == 'O6')
			{
				document.write("注册失败（请检查收光功率或确认LOID是否正确）"); 
			}
			else if (ontInfo.Status == 'o7' || ontInfo.Status == 'O7')
			{
				document.write("注册失败（请检查收光功率或确认LOID是否正确）"); 
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
				if ( "OFFLINE" == ontEPONInfo.Status)
				{
					document.write("注册失败（请检查收光功率或确认LOID是否正确）");
				}
				else if("ONLINE" == ontEPONInfo.Status)
				{
					document.write("注册正常");
				}
				else
				{
					document.write("注册失败（请检查收光功率或确认LOID是否正确）");
				}
			}
			else
			{
				if ( "OFFLINE" == ontEPONInfo.Status)
				{
					document.write("注册失败（请检查收光功率或确认LOID是否正确）");
				}
				else if("ONLINE" == ontEPONInfo.Status)
				{
					document.write("注册正常");
				}
				else
				{
					document.write("注册失败（请检查收光功率或确认LOID是否正确）");
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
}

function ONTRegStatusInfo()
{
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
}


function IsStaticIP(wanTemp)
{
	return wanTemp.ipGetMode.toUpperCase() == "STATIC";
}

function LoadFrame()
{ 
	if (1 == MngtScct)
	{
		setDisplay("Table_base7_0_table", 1);
	}
	if ( 1 == MngtFjct || 1 == MngtScct || 1 == MngtCqct)
	{
		setDisplay("Div_BusinessInfo", 0);
		setDisplay("Div_Special_BusinessInfo", 1);
	} 
	else
	{
		setDisplay("Div_BusinessInfo", 1);
		setDisplay("Div_Special_BusinessInfo", 0);
	}
}

</script>
</head>
<body  class="mainbody" onLoad="LoadFrame();"> 
<div class="func_title">设备基本信息</div>

<table id="table_devicetype" width="100%" border="0" cellpadding="0" cellspacing="1" class="table_bg">
<tr>
<td class="table_title" width="25%" align="left" id="Table_base1_1_table" name="Table_base1_1_table">设备类型:&nbsp;</td>
<td class="table_right" width="75%" id="Table_base1_2_table" name="Table_base1_2_table">
<script type="text/javascript" language="javascript">
if (deviceInfo != null)
{
	if( MngtYnct == 1 )
	{
		document.write(deviceInfo.DeviceType);
	}
	else
	{
		document.write(deviceInfo.AccessType);
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
if (MngtYnct == 1)
{
  document.write('<tr>');
  document.write('<td  class="table_title" width="25%" align="left" id="td2_1" name="td2_1">设备接入类型:&nbsp;</td>');
  document.write('<td class="table_right" width="75%" id="td2_2" name="td2_2">');
  if (deviceInfo != null)
  {
	   document.write(deviceInfo.AccessType);
  }
  else
  {
	   document.write('');
  }
  document.write('</td></tr>');
}
</script> 
<tr>
<td class="table_title" width="25%" align="left" id="Table_base2_1_table" name="Table_base2_1_table">生产厂家:&nbsp;</td>
<td class="table_right" width="75%" id="Table_base2_2_table" name="Table_base2_2_table">华为</td>
</tr>

<tr> 
<td class="table_title" width="25%" align="left" id="Table_base3_1_table" name="Table_base3_1_table">设备型号:&nbsp;</td> 
<td class="table_right" width="75%" id="Table_base3_2_table" name="Table_base3_2_table"> 
<script language="javascript">
if (deviceInfo != null)
{
	if( MngtGdct == 1 )
	{
		document.write(deviceInfo.DeviceType + "-" + deviceInfo.AccessType);
	}
	else
	{
		document.write(deviceInfo.ModelName);
	}
}
else
{
	document.write('');
}
</script>
</td> 
</tr> 
<tr> 
<td class="table_title" width="25%" align="left" id="Table_base4_1_table" name="Table_base4_1_table">设备标识号:&nbsp;</td> 
<td class="table_right" width="75%" id="Table_base4_2_table" name="Table_base4_2_table"> <script language="javascript">
	if(deviceInfo.specsn !='')
	{
		document.write(deviceInfo.ManufacturerOUI + '-' +deviceInfo.specsn);
	}
	else
	{
		document.write(deviceInfo.ManufacturerOUI + '-' +deviceInfo.SerialNumber);
	}
</script> </td> 
</tr> 
      
<tr> 
<td class="table_title" align="left" id="Table_base5_1_table" name="Table_base5_1_table">硬件版本:&nbsp;</td> 
<td class="table_right" id="Table_base5_2_table" name="Table_base5_2_table"> 
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
 <tr> 
    <td class="table_title" align="left" id="Table_base6_1_table" name="Table_base6_1_table">软件版本:&nbsp;</td> 
    <td class="table_right" id="Table_base6_2_table" name="Table_base6_2_table"> <script language="javascript">
	if (deviceInfo != null)
	{
	    //广东电信，版本号要求加年、月
		if (1 == MngtGdct)
		{
			document.write(deviceInfo.SoftwareVersion + '_' + deviceInfo.ReleaseTime.substring(0, 4) + deviceInfo.ReleaseTime.substring(5, 7));
		}
		else
		{
			document.write(deviceInfo.SoftwareVersion);
		}
	}
	else
	{
		document.write('');
	}
</script> </td> 
</tr>

<tr  id="Table_base7_0_table" name="Table_base7_0_table" style="display:none"> 
	<td class="table_title" align="left" id="Table_base7_1_table" name="Table_base7_1_table">软件大小:&nbsp;</td> 
	<td class="table_right" id="Table_base7_2_table" name="Table_base7_2_table"> 
		<script language="javascript">
			if (deviceInfo != null)
			{
				if (deviceInfo.ImageSize != 0)
				{
					document.write(parseInt(deviceInfo.ImageSize/1024) + " KB（" + deviceInfo.ImageSize + " 字节）");
				}
				else
				{
					document.write("16185 KB（16573544 字节）");
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
if (MngtJsct == 1 || MngtSzct == 1)
{
  document.write('<tr>');
  document.write('<td class="table_title" width="25%" align="left" id="td8_1" name="td8_1">版本发布时间:&nbsp;</td>');
  document.write('<td class="table_right" width="75%" id="td8_2" name="td8_2">');
  if (deviceInfo != null)
  {
	   document.write(deviceInfo.ReleaseTime);
  }
  else
  {
	   document.write('');
  }
  document.write('</td></tr>');
}
</script>
<script type="text/javascript" language="javascript">
	document.write('<tr>');
	if ( 1 == MngtFjct || 1 == MngtScct || 1 == MngtCqct)
	{
		document.write('<td class="table_title" align="left" id="td9_1" name="td9_1">OLT注册状态:&nbsp;</td>');
		document.write('<td class="table_right" id="td9_1" name="td9_2">');	
		OltRegStatusInfo();
	}
	else
	{
		document.write('<td class="table_title" align="left" id="td9_1" name="td9_1">ONT注册状态:&nbsp;</td>');
		document.write('<td class="table_right" id="td9_1" name="td9_2">');	
		ONTRegStatusInfo();
	}	
</script>
</td>
</tr>
		
<script type="text/javascript" language="javascript">
if ( 1 == MngtFjct || 1 == MngtScct || 1 == MngtCqct)
{
	document.write('<tr>');
	document.write('<td  class="table_title" align="left" id="td10_1" name="td10_1">ITMS注册状态:&nbsp;</td>');
	document.write('<td class="table_right" id="td10_2" name="td10_2">');
	if( (parseInt(Infos.Status) == 99) && (parseInt(Infos.Result) == 99))
	{
		document.write('未注册');
	}
	else if(IsPonOnline())
	{
		if( (parseInt(Infos.Status) == 0) && (parseInt(Infos.Result) == 0))
		{
			document.write('注册成功');
		}
		else if ((((parseInt(Infos.Status) == 0) && (parseInt(Infos.Result) == 1)) || (parseInt(Infos.Status) == 5) ) )
		{
			document.write('注册成功');
		}
		else
		{
			document.write('注册失败');
		}
	}
	else
	{
		document.write('注册失败');
	}
    document.write('</td></tr>');
}
</script>
    
 <script type="text/javascript" language="javascript">
	 if (1 == MngtFjct || 1 == MngtScct || 1 == MngtCqct)
	 {
		document.write('<tr>');
		document.write('<td  class="table_title" align="left" id="td11_1" name="td11_1">接收光功率:&nbsp;</td>');
		document.write('<td class="table_right" id="td11_2" name="td11_2">');
		if(opticInfo == null)
		{
			document.write('<font size="2" color="#ff0000">光功率过低，请检查光路或ODF是否有接错</font>');
		}
		else
		{						  	
			if(opticInfo < -24)
			{
				document.write('<font size="2" color="#ff0000">光功率过低，请检查光路或ODF是否有接错</font>');
			}
			else if(opticInfo == "--")
			{ 
				document.write('<font size="2" color="#ff0000">光纤插接不正常，请检查光路或ODF是否有接错</font>');
			}
			else
			{
				document.write(opticInfo+'dBm');
			}
		}
		document.write('</td></tr>');
	 }
</script> 
       	
<script type="text/javascript" language="javascript">
if ( 1 != MngtFjct && 1 != MngtScct && 1 != MngtCqct)
{
if (ontPonMode == 'gpon' || ontPonMode == 'GPON')
{
	document.write('<tr id="tr12" name="tr12">');
	document.write('<td  class="table_left" align="left" id="tr12_1" name="tr12_1">ONT ID:&nbsp;</td>');
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
}		    
</script>	     	 
</table> 

<div class="func_spread"></div>
<div class="func_title">PON信息</div>
<script type="text/javascript" language="javascript">


var GUIDE_NULL = "--";
var GUIDE_OPEN = "开启";
var GUIDE_CLOSE = "关闭";


function GetLinkState()
{
	var State = <%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.OntOnlineStatus.ontonlinestatus);%>;

	if (State == 1 || State == "1")
	{
		return "已连接";
	}
	else
	{
		return "未连接";
	}
}

function GetAccessMode()
{
	var ontPonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';
	if (ontPonMode == 'gpon' || ontPonMode == "GPON")
	{
		return "GPON";
	}
	else
	{
		return "EPON";
	}
}

function GetLinkTime()
{
	var LinkTime = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.EPONLinkInfo.PONLinkTime);%>';
	var LinkDesc;

	LinkDesc = parseInt(LinkTime/3600) + "小时" + parseInt((LinkTime%3600)/60) + "分钟" + parseInt(((LinkTime%3600)%60)) + "秒";
	if (GetLinkState() == "未连接")
	{
		LinkDesc = GUIDE_NULL;
	}

	return LinkDesc;
}
</script>

<table id="table_poninfo" width="100%" border="0" cellpadding="0" cellspacing="1" class="table_bg">
	<tr>
		<td class="table_left"  width="25%" id="Table_pon1_1_table" name="Table_pon1_1_table">线路协议:&nbsp;</td>
		<td class="table_right" width="75%" id="Table_pon1_2_table" name="Table_pon1_2_table">
		<script type="text/javascript" language="javascript">document.write(GetAccessMode());</script>
		</td>
	</tr>
	
	<tr>
		<td class="table_left"  width="25%" id="Table_pon2_1_table" name="Table_pon2_1_table">连接状态:&nbsp;</td>
		<td class="table_right" width="75%" id="Table_pon2_2_table" name="Table_pon2_2_table">
		<script type="text/javascript" language="javascript">document.write(GetLinkState());</script>
		</td>
	</tr>
	
	<tr>
		<td class="table_left"  width="25%" id="Table_pon3_1_table" name="Table_pon3_1_table">连接时间:&nbsp;</td>
		<td class="table_right" width="75%" id="Table_pon3_2_table" name="Table_pon3_2_table">
		<script type="text/javascript" language="javascript">document.write(GetLinkTime());</script>
		</td>
	</tr>
	
	<tr>
		<td class="table_left"  width="25%" id="Table_pon4_1_table" name="Table_pon4_1_table">发送光功率:&nbsp;</td>
		<td class="table_right" width="75%" id="Table_pon4_2_table" name="Table_pon4_2_table">
		<script type="text/javascript" language="javascript">document.write(PonOpticInfo.TransOpticPower+"dBm");</script>
		</td>
	</tr>
	
	<tr>
		<td class="table_left"  width="25%" id="Table_pon5_1_table" name="Table_pon5_1_table">接收光功率:&nbsp;</td>
		<td class="table_right" width="75%" id="Table_pon5_2_table" name="Table_pon5_2_table">
		<script type="text/javascript" language="javascript">document.write(PonOpticInfo.RevOpticPower+"dBm");</script>
		</td>
	</tr>
</table>

<div class="func_spread"></div>
<div class="func_title">网关注册信息</div>

<table id="table_loidreg" width="100%" border="0" cellpadding="0" cellspacing="1" class="table_bg">
<tr>
<td class="table_title" width="25%" align="left" id="Table_reg1_1_table" name="Table_reg1_1_table">逻辑ID:&nbsp;</td>
<td class="table_right" width="75%" id="Table_reg1_2_table" name="Table_reg1_2_table">
<script type="text/javascript" language="javascript">document.write(LoidPwdInfo.Loid);</script>
</td>
</tr>
<tr>
<td class="table_title" width="25%" align="left" id="Table_reg2_1_table" name="Table_reg2_1_table">光路（OLT）认证:&nbsp;</td>
<td class="table_right" width="75%" id="Table_reg2_2_table" name="Table_reg2_2_table">
<script type="text/javascript" language="javascript">
if(opticInfo == "--")
{ 
	document.write('光纤未连接');
}
else
{
	if (ontPonMode.toUpperCase() == 'GPON')
	{
		if (ontInfo.Status.toUpperCase() == 'O5')
		{
			document.write('认证成功');
		}
		else
		{
			document.write('认证失败');
		}
	}
	else if (ontPonMode.toUpperCase() == 'EPON')
	{
		if (ontEPONInfo.Status.toUpperCase() =="ONLINE" )
		{
			document.write('认证成功');
		}
		else
		{
			document.write('认证失败');
		}
	}
	else
	{
		document.write('认证失败');
	}
	
}
</script>
</td>
</tr>
<tr>
<td class="table_title" width="25%" align="left" id="Table_reg3_1_table" name="Table_reg3_1_table">管理（ITMS）注册:&nbsp;</td>
<td class="table_right" width="75%" id="Table_reg3_2_table" name="Table_reg3_2_table">
<script type="text/javascript" language="javascript">

if( (parseInt(Infos.Status) == 99) && (parseInt(Infos.Result) == 99))
{
	document.write('未注册');
}
else if(IsPonOnline())
{
	if( (parseInt(Infos.Status) == 0) && (parseInt(Infos.Result) == 0))
	{
		document.write('注册成功');
	}
	else if ((((parseInt(Infos.Status) == 0) && (parseInt(Infos.Result) == 1)) || (parseInt(Infos.Status) == 5) ) )
	{
		document.write('注册成功');
	}
	else
	{
		document.write('注册失败');
	}
}
else
{
	document.write('注册失败');
}

</script>
</td>
</tr>  
</table> 

<div class="func_spread"></div>
<div class="func_title">业务信息</div>

<div id="Div_BusinessInfo" style="display:none">
	<script type="text/javascript" language="javascript">
		document.write('<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="Table_wan_table">');
		document.write('<tr class="head_title">');
		document.write('<td width="10%" id="Table_wan0_1_table">业务类型</td>');
		document.write('<td id="Table_wan0_2_table">状态</td>');
		document.write('<td id="Table_wan0_3_table">IP协议</td>');
		document.write('<td id="Table_wan0_4_table">连接方式</td>');
		document.write('<td id="Table_wan0_5_table">可用端口</td>');
		document.write('<td id="Table_wan0_6_table">连接名称</td>');
		document.write('</tr>');
		
		 if( 0 == Wan.length )
		 {
			document.write("<tr class=\"tabal_center01\">");
			document.write('<td width="10%">--</td>');
			document.write('<td width="10%">--</td>');
			document.write('<td width="10%">--</td>');
			document.write('<td width="10%">--</td>');
			document.write('<td width="20%">--</td>');
			document.write('<td width="20%">--</td>');
			document.write("</tr>");
		 }

		var InternetNumber = 0;
		var iTVNumber = 0;
		var VoipNumber = 0;
		var ItmsNumber = 0;
		for (i = 0;i < Wan.length;i++)
		{
			if(Wan[i].serviceList.indexOf("INTERNET") >= 0)
			{
				InternetNumber++;
			}
			if(Wan[i].serviceList.indexOf("OTHER") >= 0)
			{
				iTVNumber++;
			}
			if(Wan[i].serviceList.indexOf("VOIP") >= 0)
			{
				VoipNumber++;
			}
			if(Wan[i].serviceList.indexOf("TR069") >= 0)
			{
				ItmsNumber++;
			}
		}
		var j = 1;
		if(0 != InternetNumber)
		{
			var rowInternet = false;
			var WanMacId = 0;
			var url1 = "";
			var url2 = "";
			for (i = 0;i < Wan.length;i++)
			{
				rowInternet = false;
				
				if(Wan[i].serviceList.indexOf("INTERNET") >= 0)
				{
					WanMacId = Wan[i].MacId;
					url1 = '../../bbsp/wan/wane8c.asp?' + WanMacId;
					url2 = '../cfgguide/cfgwizard.asp?' + WanMacId;
					if("IPv4/IPv6" == Wan[i].ProtocolType)
					{
						for(var k = 0;k < 2;k++)
						{
							var IPProtocolType = (false == rowInternet)?"IPv4":"IPv6";
							var IPStatus = (false == rowInternet)?MakeStatus(Wan[i],"IPv4"):MakeStatus(Wan[i],"IPv6");
							document.write('<tr class = \"tabal_01\">');
							if(false == rowInternet)
							{
								if(curUserType == '0')
								{
									document.write('<td width="10%" rowspan="2" id ="Table_wan'+j+'_1_admin_table" ><a onclick = "JumpToPage1();"  href="'+url1+'">上网</a></td>');
								}
								else
								{
									if("可用" == MakeStatus(Wan[i],"IPv4") && "可用" == MakeStatus(Wan[i],"IPv6"))
									{
										document.write('<td width="10%" rowspan="2" id ="Table_wan'+j+'_1_user_table" >上网</td>');
									}
									else
									{
										document.write('<td width="10%" rowspan="2" id ="Table_wan'+j+'_1_user_table" ><a onclick = "JumpToPage2();"  href="'+url2+'">上网</a></td>');
									}
								}
								rowInternet = true;
							}
							document.write('<td width="10%" id ="Table_wan'+j+'_2_table">'+IPStatus+'</td>');
							document.write('<td width="10%" id ="Table_wan'+j+'_3_table">'+IPProtocolType+'</td>');
							document.write('<td width="10%" id ="Table_wan'+j+'_4_table">'+MakeConnectionMode(Wan[i],"INTERNET")+'</td>');
							document.write('<td width="20%" id ="Table_wan'+j+'_5_table">'+MakeBindPort(Wan[i],"INTERNET")+'</td>');
							document.write('<td width="20%" id ="Table_wan'+j+'_6_table">'+GetWanName(Wan[i])+'</td>');
							document.write('</tr>');
							j++;
						}
					}
					else
					{
						document.write('<tr class = \"tabal_01\">');
						
						if(curUserType == '0')
						{
							document.write('<td width="10%" id ="Table_wan'+j+'_1_admin_table" ><a onclick = "JumpToPage1();"  href="'+url1+'">上网</a></td>');
						}
						else
						{
							if("可用" == MakeStatus(Wan[i],Wan[i].ProtocolType))
							{
								document.write('<td width="10%" id ="Table_wan'+j+'_1_user_table" >上网</td>');
							}
							else
							{
								document.write('<td width="10%" id ="Table_wan'+j+'_1_user_table" ><a onclick = "JumpToPage2();"  href="'+url2+'">上网</a></td>');
							}
						}
							
						document.write('<td width="10%" id ="Table_wan'+j+'_2_table">'+MakeStatus(Wan[i],Wan[i].ProtocolType)+'</td>');
						document.write('<td width="10%" id ="Table_wan'+j+'_3_table">'+Wan[i].ProtocolType+'</td>');
						document.write('<td width="10%" id ="Table_wan'+j+'_4_table">'+MakeConnectionMode(Wan[i],"INTERNET")+'</td>');
						document.write('<td width="20%" id ="Table_wan'+j+'_5_table">'+MakeBindPort(Wan[i],"INTERNET")+'</td>');
						document.write('<td width="20%" id ="Table_wan'+j+'_6_table">'+GetWanName(Wan[i])+'</td>');
						document.write('</tr>');
						j++;
					}
				}
			}
		 }
		 
		 if(0 != iTVNumber)
		{
			var rowiTV = false;
			for (i = 0;i < Wan.length;i++)
			{
				rowiTV = false;
				if(Wan[i].serviceList.indexOf("OTHER") >= 0)
				{
					if("IPv4/IPv6" == Wan[i].ProtocolType)
					{
						for(var k = 0;k < 2;k++)
						{
							var IPProtocolType = (false == rowiTV)?"IPv4":"IPv6";
							var IPStatus = (false == rowiTV)?MakeStatus(Wan[i],"IPv4"):MakeStatus(Wan[i],"IPv6");
							document.write('<tr class = \"tabal_01\">');
							if(false == rowiTV)
							{
								document.write('<td width="10%" rowspan="2" id ="Table_wan'+j+'_1_table">其它</td>');
								rowiTV = true;
							}
							document.write('<td width="10%" id ="Table_wan'+j+'_2_table">'+IPStatus+'</td>');
							document.write('<td width="10%" id ="Table_wan'+j+'_3_table">'+IPProtocolType+'</td>');
							document.write('<td width="10%" id ="Table_wan'+j+'_4_table">'+MakeConnectionMode(Wan[i],"OTHER")+'</td>');
							document.write('<td width="20%" id ="Table_wan'+j+'_5_table">'+MakeBindPort(Wan[i],"OTHER")+'</td>');
							document.write('<td width="20%" id ="Table_wan'+j+'_6_table">'+GetWanName(Wan[i])+'</td>');
							document.write('</tr>');
							j++;
						}
					}
					else
					{
						document.write('<tr class = \"tabal_01\">');
						document.write('<td width="10%" id ="Table_wan'+j+'_1_table">其它</td>');
						document.write('<td width="10%" id ="Table_wan'+j+'_2_table">'+MakeStatus(Wan[i],Wan[i].ProtocolType)+'</td>');
						document.write('<td width="10%" id ="Table_wan'+j+'_3_table">'+Wan[i].ProtocolType+'</td>');
						document.write('<td width="10%" id ="Table_wan'+j+'_4_table">'+MakeConnectionMode(Wan[i],"OTHER")+'</td>');
						document.write('<td width="20%" id ="Table_wan'+j+'_5_table">'+MakeBindPort(Wan[i],"OTHER")+'</td>');
						document.write('<td width="20%" id ="Table_wan'+j+'_6_table">'+GetWanName(Wan[i])+'</td>');
						document.write('</tr>');
						j++;
					}
				}
			}
		 }
		 
		 if(0 != VoipNumber)
		{
			var rowVoip = false;
			for (i = 0;i < Wan.length;i++)
			{
				rowVoip = false;
				if(Wan[i].serviceList.indexOf("VOIP") >= 0)
				{
					if("IPv4/IPv6" == Wan[i].ProtocolType)
					{
						for(var k = 0;k < 2;k++)
						{
							var IPProtocolType = (false == rowVoip)?"IPv4":"IPv6";
							var IPStatus = (false == rowVoip)?MakeStatus(Wan[i],"IPv4"):MakeStatus(Wan[i],"IPv6");
							document.write('<tr class = \"tabal_01\">');
							if(false == rowVoip)
							{
								document.write('<td width="10%" rowspan="2" id ="Table_wan'+j+'_1_table">语音</td>');
								rowVoip = true;
							}
							document.write('<td width="10%" id ="Table_wan'+j+'_2_table">'+IPStatus+'</td>');
							document.write('<td width="10%" id ="Table_wan'+j+'_3_table">'+IPProtocolType+'</td>');
							document.write('<td width="10%" id ="Table_wan'+j+'_4_table">'+MakeConnectionMode(Wan[i],"VOIP")+'</td>');
							document.write('<td width="20%" id ="Table_wan'+j+'_5_table">'+MakeBindPort(Wan[i],"VOIP")+'</td>');
							document.write('<td width="20%" id ="Table_wan'+j+'_6_table">'+GetWanName(Wan[i])+'</td>');
							document.write('</tr>');
							j++;
						}
					}
					else
					{
						document.write('<tr class = \"tabal_01\">');
						document.write('<td width="10%" id ="Table_wan'+j+'_1_table">语音</td>');
						document.write('<td width="10%" id ="Table_wan'+j+'_2_table">'+MakeStatus(Wan[i],Wan[i].ProtocolType)+'</td>');
						document.write('<td width="10%" id ="Table_wan'+j+'_3_table">'+Wan[i].ProtocolType+'</td>');
						document.write('<td width="10%" id ="Table_wan'+j+'_4_table">'+MakeConnectionMode(Wan[i],"VOIP")+'</td>');
						document.write('<td width="20%" id ="Table_wan'+j+'_5_table">'+MakeBindPort(Wan[i],"VOIP")+'</td>');
						document.write('<td width="20%" id ="Table_wan'+j+'_6_table">'+GetWanName(Wan[i])+'</td>');
						document.write('</tr>');
						j++;
					}
				}
			}
		 }
		 
		  if(0 != ItmsNumber)
		{
			var rowItms = false;
			for (i = 0;i < Wan.length;i++)
			{
				rowItms = false;
				if(Wan[i].serviceList.indexOf("TR069") >= 0)
				{
					if("IPv4/IPv6" == Wan[i].ProtocolType)
					{
						for(var k = 0;k < 2;k++)
						{
							var IPProtocolType = (false == rowItms)?"IPv4":"IPv6";
							var IPStatus = (false == rowItms)?MakeStatus(Wan[i],"IPv4"):MakeStatus(Wan[i],"IPv6");
							document.write('<tr class = \"tabal_01\">');
							if(false == rowItms)
							{
								document.write('<td width="10%" rowspan="2" id ="Table_wan'+j+'_1_table">管理</td>');
								rowItms = true;
							}
							document.write('<td width="10%" id ="Table_wan'+j+'_2_table">'+IPStatus+'</td>');
							document.write('<td width="10%" id ="Table_wan'+j+'_3_table">'+IPProtocolType+'</td>');
							document.write('<td width="10%" id ="Table_wan'+j+'_4_table">'+MakeConnectionMode(Wan[i],"TR069")+'</td>');
							document.write('<td width="20%" id ="Table_wan'+j+'_5_table">'+MakeBindPort(Wan[i],"TR069")+'</td>');
							document.write('<td width="20%" id ="Table_wan'+j+'_6_table">'+GetWanName(Wan[i])+'</td>');
							document.write('</tr>');
							j++;
						}
					}
					else
					{
						document.write('<tr class = \"tabal_01\">');
						document.write('<td width="10%" id ="Table_wan'+j+'_1_table">管理</td>');
						document.write('<td width="10%" id ="Table_wan'+j+'_2_table">'+MakeStatus(Wan[i],Wan[i].ProtocolType)+'</td>');
						document.write('<td width="10%" id ="Table_wan'+j+'_3_table">'+Wan[i].ProtocolType+'</td>');
						document.write('<td width="10%" id ="Table_wan'+j+'_4_table">'+MakeConnectionMode(Wan[i],"TR069")+'</td>');
						document.write('<td width="20%" id ="Table_wan'+j+'_5_table">'+MakeBindPort(Wan[i],"TR069")+'</td>');
						document.write('<td width="20%" id ="Table_wan'+j+'_6_table">'+GetWanName(Wan[i])+'</td>');
						document.write('</tr>');
						j++;
					}
				}
			}
		 }
		 document.write('</table>');
	</script>
</div>
<div id="Div_Special_BusinessInfo" style="display:none">
	<script type="text/javascript" language="javascript">
	 if ( 1 == MngtFjct || 1 == MngtScct || 1 == MngtCqct)
	 {
	 		document.write('<table width="100%" border="0" cellpadding="0" cellspacing="0">');
	 		 		
	 		document.write('<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">');
	 		document.write('<tr class="head_title">');
	 		document.write('<td width="10%" style="height: 21px">&nbsp;</td>');
	 		document.write('<td style="height: 21px;">通道（WAN连接）状态</td>');
	 		document.write('<td style="height: 21px;">&nbsp;IP地址获取方式</td>');
	 		document.write('<td style="height: 21px;">&nbsp;获取的IP地址</td>');
	 		document.write('<td style="height: 21px;">&nbsp;上网拨号状态</td>');
	 		document.write('<td style="height: 21px;">&nbsp;语音注册状态</td>');
	 		document.write('</tr>');
	 		
	 	 if( 0 == Wan.length )
		 {
				document.write("<tr class=\"tabal_01\">");
				document.write('<td width="10%" style="height: 21px">/</td>');
				document.write('<td width="10%" style="height: 21px">/</td>');
				document.write('<td width="10%" style="height: 21px">/</td>');
				document.write('<td width="10%" style="height: 21px">/</td>');
				document.write('<td width="10%" style="height: 21px">/</td>');
				document.write('<td width="10%" style="height: 21px">/</td>');
				
				document.write("</tr>");
		 }
		 
		var wanName;
		for (i = 0;i < Wan.length;i++)
		{
		    wanName = MakeWanName(Wan[i]);
            document.write('<tr class = \"tabal_01\">');
            document.write('<td width="10%" style="height: 21px">'+wanName+'</td>');	
			
			if (ontPonMode == 'gpon' || ontPonMode == 'GPON')  
			{
				if ((ontInfo.Status.toUpperCase() != 'O5') && (ontInfo.Status.toUpperCase() != 'O5AUTH'))
        		{
            		document.write('<td width="10%" style="height: 21px">'+GetChineseStatus('Disconnected')+'</td>');
        		}
       			else
        		{
        			if((Wan[i].serviceList == "TR069") ||(Wan[i].serviceList == "TR069_VOIP")||(Wan[i].serviceList == "TR069_INTERNET")||(Wan[i].serviceList == "TR069_VOIP_INTERNET"))
        			{
        					if( '0' == stInfoStatus )
                			{
								document.write('<td width="10%" style="height: 21px">'+GetChineseStatus('Connected')+'</td>');
							}
							else
							{
								document.write('<td width="10%" style="height: 21px">'+GetChineseStatus('Disconnected')+'</td>');
							} 
        			}
        			else
      				{					
      					document.write('<td width="10%" style="height: 21px">'+GetChineseStatus(Wan[i].status)+'</td>');
      				}
        		  
        		}
		  }			
		  else if (ontPonMode == 'epon' || ontPonMode == 'EPON')
		  {
				if (ontEPONInfo != null)
				{
					if (ontEPONInfo.Status == 'OFFLINE')
					{
						document.write('<td width="10%" style="height: 21px">'+GetChineseStatus('Disconnected')+'</td>');
					}
					else if (ontEPONInfo.Status == 'ONLINE')
					{
						if((Wan[i].serviceList == "TR069") ||(Wan[i].serviceList == "TR069_VOIP")||(Wan[i].serviceList == "TR069_INTERNET")||(Wan[i].serviceList == "TR069_VOIP_INTERNET"))
						{
							if( '0' == stInfoStatus)
							{
								document.write('<td width="10%" style="height: 21px">'+GetChineseStatus('Connected')+'</td>');
							}
							else
							{
								document.write('<td width="10%" style="height: 21px">'+GetChineseStatus('Disconnected')+'</td>');
							} 
						}
						else
						{
							document.write('<td width="10%" style="height: 21px">'+GetChineseStatus(Wan[i].status)+'</td>');
						}
					 	
					}
					else
					{
						document.write('<td width="10%" style="height: 21px">异常</td>');
					}
	      		}
				else
				{
					document.write('<td width="10%" style="height: 21px">异常</td>');
				}
		}
		else
		{
			document.write('<td width="10%" style="height: 21px">异常</td>');
		}
		
		if( (Wan[i].modeType =="IP_Routed") && (Wan[i].ipGetMode.toUpperCase() == "DHCP"))
		{
			document.write('<td width="10%" style="height: 21px">路由（DHCP自动获取）</td>');
		}
		if(Wan[i].modeType =="IP_Routed"&& Wan[i].ipGetMode.toUpperCase() == "STATIC")
		{
			document.write('<td width="10%" style="height: 21px">路由（静态获取）</td>');
		}
		if(Wan[i].modeType =="IP_Routed"&& Wan[i].ipGetMode.toUpperCase() == "PPPOE")
		{
			document.write('<td width="10%" style="height: 21px">路由（终端内置拨号）</td>');
		}
			
		if((Wan[i].modeType =="IP_Bridged"|| Wan[i].modeType =="PPPoE_Bridged")&& Wan[i].serviceList=="INTERNET")
		{
			document.write('<td width="10%" style="height: 21px">桥接（电脑拨号）</td>');
		}
		if((Wan[i].modeType =="IP_Bridged"|| Wan[i].modeType =="PPPoE_Bridged")&& Wan[i].serviceList=="OTHER")
		{
			document.write('<td width="10%" style="height: 21px">桥接（ITV终端自动获取）</td>');
		}
				
		if((IsPonOnline() || IsStaticIP(Wan[i])) && Wan[i].status=="Connected")
		{
			  if (Wan[i].modeType == 'IP_Routed')
			  {				  	
			     document.write('<td width="10%" style="height: 21px">'+Wan[i].ip + '</td>');				
			  }
			  else
			  {	  	 
			     document.write('<td width="10%" style="height: 21px">/</td>');			      
			  }		     
		}
		else
		{
			if (Wan[i].modeType == 'IP_Routed')
		  	{				  	
				document.write('<td width="10%" style="height: 21px">0.0.0.0</td>');				
		  	}
		  	else
		  	{	  	 
			 	document.write('<td width="10%" style="height: 21px">/</td>');			      
		  	}			  
		}
			
		if((Wan[i].modeType =="IP_Bridged" || Wan[i].modeType =="PPPoE_Bridged")&&(Wan[i].serviceList=="INTERNET"))
		{
			document.write('<td width="10%" style="height: 21px">在电脑终端上看具体的状态</td>');
		}
		else if(Wan[i].modeType =="IP_Routed"&& Wan[i].ipGetMode.toUpperCase() == "PPPOE")
		{
		  	if((IsPonOnline() || IsStaticIP(Wan[i])) && Wan[i].status=="Connected")
			{
				document.write('<td width="10%" style="height: 21px">正常</td>');
			}
			else
			{
				if (Wan[i].Enable == "0") 
				{				
					document.write('<td width="10%" style="height: 21px">其它错误</td>');	
				}
				else if(Wan[i].LastConnectionError == "ERROR_AUTHENTICATION_FAILURE")
				{
					document.write('<td width="10%" style="height: 21px">认证失败（691错误）</td>');
				}
				else if((Wan[i].LastConnectionError == "ERROR_SERVER_OUT_OF_RESOURCES")
					 || (Wan[i].LastConnectionError == "ERROR_USER_DISCONNECT")
					 || (Wan[i].LastConnectionError == "ERROR_ISP_TIME_OUT")
					 || (Wan[i].LastConnectionError == "ERROR_ISP_DISCONNECT"))
				{
					document.write('<td width="10%" style="height: 21px">通道异常（678错误）</td>');
				}
				else if(Wan[i].LastConnectionError == "ERROR_NONE")
				{
					document.write('<td width="10%" style="height: 21px">拨号中</td>');	
			    }
                else
                {
				    document.write('<td width="10%" style="height: 21px">其它错误</td>');
				}				
			}
		}
		else
		{
			document.write('<td width="10%" style="height: 21px">/</td>');
		}
	   
		if(Wan[i].serviceList=="VOIP"|| Wan[i].serviceList=="VOIP_INTERNET")
		{  
			document.write('<td width="10%" style="height: 21px">'+GetVoiceChineseDes(VoiceStateInfo, VoiceErrorDes)+'</td>');		
		}
		else
		{
			document.write('<td width="10%" style="height: 21px">/</td>');
		}
		document.write('</tr>');
	}	
	document.write('</table>');
}
 </script>
</div>

<div id='guide_wlaninfo' style="display:none">

<div class="func_spread"></div>
<div class="func_title">无线信息</div>

<script type="text/javascript" language="javascript">
function stWlan(domain,enable,name,ssid,BeaconType,BasicEncrypt,BasicAuth,WPAEncrypt,WPAAuth,IEEE11iEncrypt,IEEE11iAuth,WPAand11iEncrypt,WPAand11iAuth,RadiusKey)
{
    this.domain = domain;
    this.enable = enable;
    this.name = name;
    this.ssid = ssid;
    this.BeaconType = BeaconType;    
    this.BasicAuth = BasicAuth;
	this.BasicEncrypt = BasicEncrypt;    
    this.WPAAuth = WPAAuth;
	this.WPAEncrypt = WPAEncrypt;    
    this.IEEE11iAuth = IEEE11iAuth;
	this.IEEE11iEncrypt = IEEE11iEncrypt;
	this.WPAand11iAuth = WPAand11iAuth;
	this.WPAand11iEncrypt = WPAand11iEncrypt;
	this.RadiusKey = RadiusKey;
}

WlanInfoArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.1,Enable|Name|SSID|BeaconType|BasicEncryptionModes|BasicAuthenticationMode|WPAEncryptionModes|WPAAuthenticationMode|IEEE11iEncryptionModes|IEEE11iAuthenticationMode|X_HW_WPAand11iEncryptionModes|X_HW_WPAand11iAuthenticationMode|X_HW_RadiusKey,stWlan);%>;  
var WlanInfo = WlanInfoArr[0];

function stPreSharedKey(domain, value)
{
    this.domain = domain;
    this.value = value;
}

var wpaPskKeyArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.PreSharedKey.1,PreSharedKey,stPreSharedKey);%>;
var wpaPskKey = wpaPskKeyArr[0];
if (null == wpaPskKey)
{
	wpaPskKey = new stPreSharedKey("","");
}

function stWEPKey(domain, value)
{
    this.domain = domain;
    this.value = value;
}

var wepKeyArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.WEPKey.1,WEPKey,stWEPKey);%>;
var wepKey = wepKeyArr[0];
if (null == wepKey)
{
	wepKey = new stWEPKey("", "");
}

function GetWlanEnable()
{
	var wlanEnbl = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.X_HW_WlanEnable);%>';
	if (wlanEnbl == 1)
	{
		return GUIDE_OPEN;
	}
	else
	{
		return GUIDE_CLOSE;
	}
}

function GetWlanName()
{
	if ((GetWlanEnable() == GUIDE_CLOSE) || (null == WlanInfo))
	{
		return GUIDE_NULL;
	}
	else
	{
		return WlanInfo.ssid;
	}
}

function GetWlanPass()
{
	if ((GetWlanEnable() == GUIDE_CLOSE) || (null == WlanInfo))
	{
		return GUIDE_NULL;
	}
	else
	{
		if ((WlanInfo.BeaconType == "Basic"))
		{
			if ((WlanInfo.BasicEncrypt != "None"))
			{
				return wepKey.value;
			}
		}
		else if (WlanInfo.BeaconType == "WPA")
		{
			if (WlanInfo.WPAAuth == "PSKAuthentication")
			{
				return wpaPskKey.value;
			}
			else
			{
				return WlanInfo.RadiusKey;
			}
		}
		else if ((WlanInfo.BeaconType == "WPA2") || (WlanInfo.BeaconType == "11i"))
		{
			if (WlanInfo.IEEE11iAuth == "PSKAuthentication")
			{
				return wpaPskKey.value;
			}
			else
			{
				return WlanInfo.RadiusKey;
			}
		}
		else if ((WlanInfo.BeaconType == "WPAand11i") || (WlanInfo.BeaconType == "WPA/WPA2"))
		{
			if (WlanInfo.WPAand11iAuth == "PSKAuthentication")
			{
				return wpaPskKey.value;
			}
			else
			{
				return WlanInfo.RadiusKey;
			}
		}

		return "";
	}
}

function GetWlanSecuConfig()
{
	if ((GetWlanEnable() == GUIDE_CLOSE) || (null == WlanInfo))
	{
		return GUIDE_NULL;
	}
	else
	{
		if (((WlanInfo.BeaconType == "None") || (WlanInfo.BeaconType == "Basic")) && (WlanInfo.BasicEncrypt == "None"))
		{
			return GUIDE_CLOSE;
		}
		else
		{
			return GUIDE_OPEN;
		}
	}
}
</script>

<table width="100%" border="0" cellpadding="0" cellspacing="1" class="table_bg">
	<tr>
		<td class="table_left"  width="25%" id="Table_wifi1_1_table" name="Table_wifi1_1_table">无线网络名称:&nbsp;</td>
		<td class="table_right" width="75%" id="Table_wifi1_2_table" name="Table_wifi1_2_table">
		<script type="text/javascript" language="javascript">document.write(GetSSIDStringContent(GetWlanName()));</script>
		</td>
	</tr>

	<tr>
		<td class="table_left"  width="25%" id="Table_wifi2_1_table" name="Table_wifi2_1_table">无线网络密钥:&nbsp;</td>
		<td class="table_right" width="75%" id="Table_wifi2_2_table" name="Table_wifi2_2_table">
		<script type="text/javascript" language="javascript">document.write(GetWlanPass());</script>
		</td>
	</tr>

	<tr>
		<td class="table_left"  width="25%" id="Table_wifi3_1_table" name="Table_wifi3_1_table">无线状态:&nbsp;</td>
		<td class="table_right" width="75%" id="Table_wifi3_2_table" name="Table_wifi3_2_table">
		<script type="text/javascript" language="javascript">document.write(GetWlanEnable());</script>
		</td>
	</tr>

	<tr>
		<td class="table_left"  width="25%" id="Table_wifi4_1_table" name="Table_wifi4_1_table">安全模式:&nbsp;</td>
		<td class="table_right" width="75%" id="Table_wifi4_2_table" name="Table_wifi4_2_table">
		<script type="text/javascript" language="javascript">document.write(GetWlanSecuConfig());</script>
		</td>
	</tr>		
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="1" class="table_bg">
	<script type="text/javascript" language="javascript">
	function AdminJump()
	{
		top.Frame.changeMenuShow('Menu1_Network','Menu2_Net_WLAN','Menu3_NW_Basic');
	}
	
	function UserJump()
	{
		top.Frame.changeMenuShow('Menu1_Status','Menu2_Sta_Overview','Menu3_SO_Wizard');
	}
	
	var id_guidewlan;
	var url;
	if ('0' == '<%HW_WEB_GetUserType();%>')
	{
		url = "/html/amp/wlanbasic/e8cWlanBasic.asp";
	    id_guidewlan = "Table_wifi5_1_admin_table";

		document.writeln("<tr>");
		document.writeln("<td class='table_left' id=" + id_guidewlan + ">" + "<a onclick='AdminJump();' href=" + url + ">" + "无线配置向导&nbsp;" + "</td>");
		document.writeln("</tr>");
	}
	else
	{
		url = "/html/ssmp/cfgguide/cfgwizard.asp";
		id_guidewlan = "Table_wifi5_1_user_table";

		document.writeln("<tr>");
		document.writeln("<td class='table_left' id=" + id_guidewlan + ">" + "<a onclick='UserJump();' href=" + url + ">" + "无线配置向导&nbsp;" + "</td>");
		document.writeln("</tr>");
	}
	</script>

</table>
</div>
<script type="text/javascript" language="javascript">
if ('<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>' == 1)
{
	setDisplay('guide_wlaninfo', 1);
}
</script>

<div class="func_spread"></div>
<div class="func_title">用户侧以太网口信息</div>

<script type="text/javascript" language="javascript">
function GEInfo(domain,Status)
{
	this.domain		= domain;
	if(Status==0)this.Status = "未连接设备";
	if(Status==1)this.Status = "已连接设备";
}

var geInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.LANPort.{i}.CommonConfig,Link,GEInfo);%>;

function getlandesc(lanid)
{
	var landesc;
	landesc = "网口" + lanid;
	if ((2 == lanid) && (4 == geInfos.length - 1))
	{
		landesc = "iTV";
	}

	if ((lanid == 0) || (lanid > geInfos.length - 1))
	{
		landesc = "";
	}

	return landesc;
}

</script>

<table width="100%" border="0" cellpadding="0" cellspacing="1" class="table_bg">
	<tr class="table_title" id="lanuserdevinfotitle">
	    <td width="25%">端口号</td>
	    <td width="25%">状态</td>
	    <td width="25%">MAC地址</td>
	</tr>
	
	<script type="text/javascript" language="javascript">
	function appendstr(str)
	{
		return str;
	}
	
	function createlanuserdevtable(lanuserdevinfos)
	{
		var lanid;
		var UserDevicesNum = lanuserdevinfos.length - 1;
		var output = "";
		var mac = ""
		for(i=0; i<geInfos.length - 1; i++)
		{
	        mac = ""
			lanid = i+1;
			
			for (j = 0; j < UserDevicesNum; j++)
			{
				if("ETH" != lanuserdevinfos[j].PortType)
				{
					continue;
				}

				if (lanid == parseInt(lanuserdevinfos[j].Port.charAt(lanuserdevinfos[j].Port.length -1)))
				{
					mac = lanuserdevinfos[j].MacAddr;
				}
			}

			output = output + appendstr("<tr class=\"tabal_01\">");

			output = output + appendstr('<td class=\"align_left\">' +  getlandesc(lanid) +'</td>');
			output = output + appendstr('<td class=\"align_left\">' + geInfos[i].Status +'</td>');
			output = output + appendstr('<td class=\"align_left\">' + mac +'</td>');
			output = output + appendstr("</tr>");
			
		}
		$("#lanuserdevinfotitle").after(output);
	}
	
	GetLanUserDevInfo(function(lanuserdevinfos)
	{
		createlanuserdevtable(lanuserdevinfos);	
	});
	</script>
</table>

</body>
</html>
