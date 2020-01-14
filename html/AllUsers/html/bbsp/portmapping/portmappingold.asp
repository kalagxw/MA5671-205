<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>

<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<title>Portmapping</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/lanuserinfo.asp"></script>
<script language="JavaScript" type="text/javascript">
var LoginRequestLanguage = '<%HW_WEB_GetLoginRequestLangue();%>';
var WebInnerPort = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.Services.X_HW_WebServerConfig.ListenInnerPort);%>';
var WebOuterPort = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.Services.X_HW_WebServerConfig.ListenOuterPort);%>';
var telnetInnerPort = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.UserInterface.X_HW_CLITelnetAccess.TelnetPort);%>';
var telnetOuterPort = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.UserInterface.X_HW_CLITelnetAccess.OutTelnetPort);%>';

var PublicIpFlag = '<%HW_WEB_GetFeatureSupport(BBSP_FT_SNAT_IPMAPPING);%>';
var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType = '0';
var curCfgModeWord ='<%HW_WEB_GetCfgMode();%>'; 
var WanIndex = -1;
var appName = navigator.appName;
var realConstSrvName='constsrvName';
var realDivSrvName='DivServiceList_common';
var TELMEX = false; 
if (GetCfgMode().TELMEX == "1")
{
	TELMEX = true;
	realConstSrvName='constsrvName_tlemex_en';
	realDivSrvName='DivServiceList_tlemex_en';

}
else
{
	TELMEX = false;
	realConstSrvName='constsrvName';
	realDivSrvName='DivServiceList_common';
}

var numpara = "";
if( window.location.href.indexOf("?") > 0)
{
    numpara = window.location.href.split("?")[1]; 
}

function stExtportConflitInfo(conflitstate, freeport)
{
    this.conflitstate = conflitstate;
    this.freeport     = freeport;  
} 

function stNoteInfo(isnote, noteindex, freeport)
{
    this.isnote    = isnote;
    this.noteindex = noteindex;
    this.freeport  = freeport;
}

function StartFileOpt()
{
    XmlHttpSendAspFlieWithoutResponse("/asp/StartFileLoad.asp");
}

function ConflitInfoIsEqual(conflit1, conflit2)
{
    if ((conflit1.conflitstate == conflit2.conflitstate)
        && (conflit1.freeport == conflit2.freeport))
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

var LANhostIP = new Array();
var LANhostName = new Array();

LANhostIP[0] = "";
LANhostName[0] = portmapping_language['bbsp_hostName_select'];


function dhcpcnst(domain,dhcpStart,dhcpEnd,Enable)
{
    this.domain 	= domain;
    this.dhcpStart 	= dhcpStart;
	this.dhcpEnd 	= dhcpEnd;
	this.Enable 	= Enable;  
}

function dhcpmainst(domain,startip,endip)
{
	this.domain 	= domain;
	this.startip	= startip;
	this.endip		= endip;
}

function stipaddr(domain,enable,ipaddr,subnetmask)
{
	this.domain		= domain;
	this.enable		= enable;
	this.ipaddr		= ipaddr;
	this.subnetmask	= subnetmask;	
}

var LanIpInfos = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_FilterSlaveLanHostIp, InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},Enable|IPInterfaceIPAddress|IPInterfaceSubnetMask,stipaddr);%>;
var SlaveDhcpInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DHCPSLVSERVER,StartIP|EndIP|DHCPEnable,dhcpcnst);%>;  

var MainDhcpRange = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement,MinAddress|MaxAddress ,dhcpmainst);%>;  

function setlanhostnameip(UserDevices)
{
	var UserDevicesnum = UserDevices.length - 1;
	
	for (var i = 0, j = 1; i < UserDevicesnum; i++)
	{
		if ("--" != UserDevices[i].HostName)
		{
			LANhostName[j] = UserDevices[i].HostName;
			LANhostIP[j] = UserDevices[i].IpAddr;
			j++;
		}
		else
	   {
			LANhostName[j] = UserDevices[i].MacAddr;
			LANhostIP[j] = UserDevices[i].IpAddr;
			j++;
	   }  
	}
}

function HostNameChange()
{
	setText('InternalClient',LANhostIP[getSelectVal('HostName')]);
}

function loadlanguage()
{
	var all = document.getElementsByTagName("td");
	for (var i = 0; i <all.length ; i++) 
	{
		var b = all[i];
		if(b.getAttribute("BindText") == null)
		{
			continue;
		}
		b.innerHTML = portmapping_language[b.getAttribute("BindText")];
	}
}

function filterWan(WanItem)
{
	if (!(WanItem.Tr069Flag == '0' && (IsWanHidden(domainTowanname(WanItem.domain)) == false)))
	{
		return false;	
	}
	
	if ((curCfgModeWord == 'DT_HUNGARY') && (curUserType != sysUserType))
    {
        if (WanItem.Name.toUpperCase().indexOf("INTERNET") >= 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
	
	return true;
}

var WanInfo = GetWanListByFilter(filterWan);

function stPortMap(domain,ProtMapEnabled,Protocol,RemoteHost,ExPort,ExEndPort,InPort,InEndPort,InClient,ExSrcPort,ExSrcEndPort,Description,ExternalIP,flag)
{
   this.domain = domain;
	 this.ProtMapEnabled = ProtMapEnabled;
	 this.Protocol = Protocol;
	 this.RemoteHost = RemoteHost;
	 this.ExPort = ExPort;
	 this.ExEndPort = ExEndPort;
	 this.InPort = InPort;
	 this.InEndPort = InEndPort;
	 this.InClient = InClient;	
	 this.ExSrcPort = ExSrcPort;
	 this.ExSrcEndPort = ExSrcEndPort;
	 this.Description = Description;
	 this.ExternalIP = ExternalIP;
	 var index = domain.lastIndexOf('PortMapping');
	 this.Interface = domain.substr(0,index - 1);	
	 this.flag = 0; 
}

function IsBelongAddrPool(InternalHost)
{
	var Ipjudge1 = InternalHost.split(".");
	var Ipjudge_lan_hostip = LanIpInfos[0].ipaddr.split(".");
	var Ipjudge_main_startip = MainDhcpRange[0].startip.split(".");
	var Ipjudge_main_endip = MainDhcpRange[0].endip.split(".");	
	var Ipjudge_slave_startip = SlaveDhcpInfos[0].dhcpStart.split(".");
	var Ipjudge_slave_endip = SlaveDhcpInfos[0].dhcpEnd.split(".");

	if( (parseInt(Ipjudge1[0]) != parseInt(Ipjudge_main_startip[0])) || (parseInt(Ipjudge1[1]) != parseInt(Ipjudge_main_startip[1]) ) 
	|| (parseInt(Ipjudge1[2]) != parseInt(Ipjudge_main_startip[2]) ) || (parseInt(Ipjudge1[3]) < parseInt(Ipjudge_main_startip[3])) || (parseInt(Ipjudge1[3]) > parseInt(Ipjudge_main_endip[3])))
	{
		if(SlaveDhcpInfos[0].Enable == 1)
		{
			if((parseInt(Ipjudge1[0]) != parseInt(Ipjudge_slave_startip[0])) || (parseInt(Ipjudge1[1]) != parseInt(Ipjudge_slave_startip[1]) ) 
			|| (parseInt(Ipjudge1[2]) != parseInt(Ipjudge_slave_startip[2])) || (parseInt(Ipjudge1[3]) < parseInt(Ipjudge_slave_startip[3])) || (parseInt(Ipjudge1[3]) > parseInt(Ipjudge_slave_endip[3])))
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}
}

var WanIPPortMapping = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i}.PortMapping.{i},PortMappingEnabled|PortMappingProtocol|RemoteHost|ExternalPort|ExternalPortEndRange|InternalPort|X_HW_InternalEndPort|InternalClient|X_HW_ExternalSrcPort|X_HW_ExternalSrcEndPort|PortMappingDescription|X_HW_ExternalIP,stPortMap);%>;
var WanPPPPortMapping = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i}.PortMapping.{i},PortMappingEnabled|PortMappingProtocol|RemoteHost|ExternalPort|ExternalPortEndRange|InternalPort|X_HW_InternalEndPort|InternalClient|X_HW_ExternalSrcPort|X_HW_ExternalSrcEndPort|PortMappingDescription|X_HW_ExternalIP,stPortMap);%>; 
function FindWanInfoByPortMapping(portMappingItem)
{
	var wandomain_len = 0;
	var temp_domain = null;
	
	for(var k = 0; k < WanInfo.length; k++ )
	{
		wandomain_len = WanInfo[k].domain.length;
		temp_domain = portMappingItem.domain.substr(0, wandomain_len);
		
		if (temp_domain == WanInfo[k].domain)
		{
			return WanInfo[k];
		}
	}
	return false;
}

var PortMapping = new Array();
var Idx = 0;
for (i = 0; i < WanIPPortMapping.length-1; i++)
{
	if(WanIPPortMapping[i].InClient=="")
	{
		continue;
	}
	
	if(false == FindWanInfoByPortMapping(WanIPPortMapping[i]))
	{
		continue;
	}

	var tmpWan = FindWanInfoByPortMapping(WanIPPortMapping[i]);   


    if (tmpWan.ServiceList != 'TR069'
       && tmpWan.ServiceList != 'VOIP'
       && tmpWan.ServiceList != 'TR069_VOIP'
       && tmpWan.Mode == 'IP_Routed')
	{
	    PortMapping[Idx] = WanIPPortMapping[i];
		PortMapping[Idx].Interface = MakeWanName(tmpWan);
		Idx ++;
	}
}
for (j = 0; j < WanPPPPortMapping.length-1; j++,i++)
{
	if(WanPPPPortMapping[j].InClient=="")
	{
		continue;
	}
	
	if(false == FindWanInfoByPortMapping(WanPPPPortMapping[j]))
	{
		continue;
	}

    var tmpWan = FindWanInfoByPortMapping(WanPPPPortMapping[j]);   

    if (tmpWan.ServiceList != 'TR069'
		&& tmpWan.ServiceList != 'VOIP'
		&& tmpWan.ServiceList != 'TR069_VOIP'
		&& tmpWan.Mode == 'IP_Routed')
	{
		PortMapping[Idx] = WanPPPPortMapping[j];
		PortMapping[Idx].Interface = MakeWanName(tmpWan);
		Idx ++;   
	}
}
function MakePortMappingName(PortMappingDomain)
{
	var wandomain_len = 0;
	var temp_domain = null;
	
	for(var k = 0; k < WanInfo.length; k++ )
	{
		wandomain_len = WanInfo[k].domain.length;
		temp_domain = PortMappingDomain.substr(0, wandomain_len);
		if (temp_domain == WanInfo[k].domain)
		{
			return MakeWanName1(WanInfo[k]);
		}
	}
}

function CheckConflictState(ObjPort1, ObjPort2, conflit1, conflit2)
{
    var conflitInfo = new stExtportConflitInfo();
    
    if ((conflit1 == 1) && (conflit2 == 1))
    {
        conflitInfo.conflitstate = 2;      
    }
    else if ((conflit1 == 0) && (conflit2 == 1))
    {
        conflitInfo.conflitstate = 1;
        conflitInfo.freeport     = ObjPort1;
    }
    else if ((conflit1 == 1) && (conflit2 == 0))
    {
        conflitInfo.conflitstate = 1;
        conflitInfo.freeport     = ObjPort2;
    }
    else
    {
        conflitInfo.conflitstate = 0;
        conflitInfo.freeport     = ObjPort1;
    }

    return conflitInfo;
}

function CheckExPortConflict(ObjPort1, ObjPort2, ExceptItem)
{
    var conflit1 = 0;
    var conflit2 = 0;
    var extstartport = 0;
    var extendport   = 0;
    for (i = 0; i < PortMapping.length; i++)
    {
        if (i == ExceptItem)
        {
            continue;
        }
        if (PortMapping[i].ProtMapEnabled != 1)
        {
            continue;
        }

        if (PortMapping[i].flag == 1)
        {
            continue;
        }

        extstartport = parseInt(PortMapping[i].ExPort, 10);
        extendport   = parseInt(PortMapping[i].ExEndPort, 10);
        if ((ObjPort1 >= extstartport) && (ObjPort1 <= extendport))
        {
            conflit1 = 1;
        }

        if ((ObjPort2 >= extstartport) && (ObjPort2 <= extendport))
        {
            conflit2 = 1;
        }
        
    }

    return CheckConflictState(ObjPort1, ObjPort2, conflit1, conflit2);
    
}

function CheckCurExPortConflict(StartExport, EndExport, ObjPort1, ObjPort2)
{
    var conflit1 = 0;
    var conflit2 = 0;

    if ((ObjPort1 >= StartExport) && (ObjPort1 <= EndExport))
    {
        conflit1 = 1;
    }

    if ((ObjPort2 >= StartExport) && (ObjPort2 <= EndExport))
    {
        conflit2 = 1;
    }

    return CheckConflictState(ObjPort1, ObjPort2, conflit1, conflit2);
}

var noteresult = new Array(new stNoteInfo(0,0,0), new stNoteInfo(0,0,0), new stNoteInfo(0,0,0));

function CheckAddActionExtPortConflict(protocal)
{
    var expitem = -1;
    var curstartport = 0;
    var curendport   = 0;
    var conflitInfo = new stExtportConflitInfo(0, 0);
    var lastconflitInfo = new stExtportConflitInfo(0, 0);
    var checkinnerport   = 0;
    var checkouterport   = 0;
    var curmapingstate = parseInt(getCheckVal('PortMappingEnable'), 10);

    if (curmapingstate == 0)
    {
        noteresult[protocal].isnote = 0;
        return;        
    }

    if (0 == protocal)
    {
        checkinnerport = WebInnerPort;
        checkouterport = WebOuterPort;
    }
    else
    {
        checkinnerport = telnetInnerPort;
        checkouterport = telnetOuterPort;
    }

    curstartport = parseInt(getValue('ExternalPort'), 10);
	curendport   = parseInt(getValue('ExternalEndPort'), 10);
    
    conflitInfo = CheckCurExPortConflict(curstartport, curendport, checkinnerport, checkouterport);
    if (conflitInfo.conflitstate == 0)
    {
        noteresult[protocal].isnote = 0;
        noteresult[protocal].noteindex = -1;
        return;
    }

    lastconflitInfo = CheckExPortConflict(checkinnerport, checkouterport, expitem);
    if (ConflitInfoIsEqual(conflitInfo, lastconflitInfo))
    {
        noteresult[protocal].isnote = 0;
        noteresult[protocal].noteindex = -1;
        return;           
    }

    if (lastconflitInfo.conflitstate == 0)
    {
        if (conflitInfo.conflitstate == 1)
        {
            noteresult[protocal].isnote = 1;
            noteresult[protocal].noteindex = 0;
            noteresult[protocal].freeport = conflitInfo.freeport; 
            return;
        }
        else
        {
            noteresult[protocal].isnote = 1;
            noteresult[protocal].noteindex = 1;
            return;
        }           
    }
    else if (lastconflitInfo.conflitstate == 1)
    {
        noteresult[protocal].isnote = 1;
        noteresult[protocal].noteindex = 1;  
        return;
    }

    noteresult[protocal].isnote = 0;
    noteresult[protocal].noteindex = -1;
    return;    
}

function CheckDelActionExtPortConflict(protocal, curitem)
{
    var expitem = curitem;
    var curstartport = 0;
    var curendport   = 0;
    var conflitInfo = new stExtportConflitInfo(0, 0);
    var lastconflitInfo = new stExtportConflitInfo(0, 0);
    var checkinnerport   = 0;
    var checkouterport   = 0;
    var curmapingstate = parseInt(PortMapping[curitem].ProtMapEnabled, 10);

    if (curmapingstate == 0)
    {
        noteresult[protocal].isnote = 0;
        noteresult[protocal].noteindex = -1;
        return;        
    }

    if (0 == protocal)
    {
        checkinnerport = WebInnerPort;
        checkouterport = WebOuterPort;
    }
    else
    {
        checkinnerport = telnetInnerPort;
        checkouterport = telnetOuterPort;
    }

    curstartport = parseInt(PortMapping[curitem].ExPort, 10);
    curendport   = parseInt(PortMapping[curitem].ExEndPort, 10);

    PortMapping[curitem].flag = 1;
        
    conflitInfo    = CheckCurExPortConflict(curstartport, curendport, checkinnerport, checkouterport);
    if (conflitInfo.conflitstate == 0)
    {
        noteresult[protocal].isnote = 0;
        noteresult[protocal].noteindex = -1;
        return;
    }

    lastconflitInfo = CheckExPortConflict(checkinnerport, checkouterport, expitem);

    if (lastconflitInfo.conflitstate == 0)
    {
        noteresult[protocal].isnote = 1;
        noteresult[protocal].noteindex = 0;
        noteresult[protocal].freeport = lastconflitInfo.freeport; 
        return;
    }
    else if (lastconflitInfo.conflitstate == 1)
    {
        if (ConflitInfoIsEqual(conflitInfo, lastconflitInfo))
        {
            noteresult[protocal].isnote = 0;
            noteresult[protocal].noteindex = -1;
            return;
        }
        else
        {
            noteresult[protocal].isnote = 1;
            noteresult[protocal].noteindex = 0;  
            noteresult[protocal].freeport = lastconflitInfo.freeport; 
            return;
        }
    }

    noteresult[protocal].isnote = 0;
    noteresult[protocal].noteindex = -1;
    return;
} 

function CheckModifyActionExtPortConflict(protocal)
{
    var expitem = selctIndex;
    var curstartport = 0;
    var curendport   = 0;
    var conflitInfo = new stExtportConflitInfo(0, 0);
    var lastconflitInfo = new stExtportConflitInfo(0 , 0);
	var conflittotalInfo = new stExtportConflitInfo(0, 0);
    var checkinnerport   = 0;
    var checkouterport   = 0;
    var curmapingstate = parseInt(getCheckVal('PortMappingEnable'), 10); 
    var befmapingstate = parseInt(PortMapping[selctIndex].ProtMapEnabled, 10);

    if (curmapingstate == 0 && befmapingstate == 0)
    {
        noteresult[protocal].isnote = 0;
        noteresult[protocal].noteindex = -1;
        return;        
    }
    
    if (0 == protocal)
    {
        checkinnerport = WebInnerPort;
        checkouterport = WebOuterPort;
    }
    else
    {
        checkinnerport = telnetInnerPort;
        checkouterport = telnetOuterPort;
    }

    curstartport = parseInt(getValue('ExternalPort'), 10);
	curendport   = parseInt(getValue('ExternalEndPort'), 10);
    
    conflitInfo    = CheckCurExPortConflict(curstartport, curendport, checkinnerport, checkouterport);
    lastconflitInfo = CheckExPortConflict(checkinnerport, checkouterport, expitem);

    if (curmapingstate == 1)
    {
        if (lastconflitInfo.conflitstate == 2)
        {
            conflittotalInfo.conflitstate = 2;
        }
        else if (lastconflitInfo.conflitstate == 1) 
        {
            if (conflitInfo.conflitstate == 0)
            {
                conflittotalInfo = lastconflitInfo;
            }
            else if (conflitInfo.conflitstate == 1)
            {
                if (!ConflitInfoIsEqual(conflitInfo,lastconflitInfo))
                {
                     conflittotalInfo.conflitstate = 2;
                }
                else
                {
                     conflittotalInfo = lastconflitInfo;
                }
            }
            else
            {
                conflittotalInfo.conflitstate = 2;
            }                         
        }
        else
        {
            conflittotalInfo = conflitInfo;
        }
    }
    else
    {
        conflittotalInfo = lastconflitInfo;        
    }

    expitem = -1;
    lastconflitInfo = CheckExPortConflict(checkinnerport, checkouterport, expitem);

    if (ConflitInfoIsEqual(conflittotalInfo, lastconflitInfo))
    {
        noteresult[protocal].isnote = 0;
        noteresult[protocal].noteindex = -1;
        return;        
    }

    if (lastconflitInfo.conflitstate == 0)
    {
        if (conflittotalInfo.conflitstate == 1)
        {
            noteresult[protocal].isnote = 1;
            noteresult[protocal].noteindex = 0;
            noteresult[protocal].freeport = conflittotalInfo.freeport; 
            return;
        }
        else if (conflittotalInfo.conflitstate == 2)
        {
            noteresult[protocal].isnote = 1;
            noteresult[protocal].noteindex = 1;
            return;
        }
    }
    else if (lastconflitInfo.conflitstate == 1)
    {
        if (conflittotalInfo.conflitstate == 0)
        {
            noteresult[protocal].isnote = 1;
            noteresult[protocal].noteindex = 0;
            noteresult[protocal].freeport = conflittotalInfo.freeport; 
            return;
        }
        else if (conflittotalInfo.conflitstate == 1)
        {
            noteresult[protocal].isnote = 1;
            noteresult[protocal].noteindex = 0;
            noteresult[protocal].freeport = conflittotalInfo.freeport;
            return;
        }
        else if (conflittotalInfo.conflitstate == 2)
        {
            noteresult[protocal].isnote = 1;
            noteresult[protocal].noteindex = 1;
            return;  
        }
    }
    else 
    {
        if (conflittotalInfo.conflitstate != 2)
        {
            noteresult[protocal].isnote = 1;
            noteresult[protocal].noteindex = 0;
            noteresult[protocal].freeport = conflittotalInfo.freeport; 
            return;
        }       
    }

    noteresult[protocal].isnote = 0;
    noteresult[protocal].noteindex = -1;

    return;    
}

function ProductConflitNote()
{
    var notestring = '';

    if (GetFeatureInfo().httpportmode == 1) 
    {
        if (noteresult[0].noteindex == 1)
        {
            notestring = portmapping_language['bbsp_exportconflithttp3'];        
        }
        else if (noteresult[0].noteindex == 0)
        {
            if (noteresult[0].freeport == 8080)
            {
                notestring = portmapping_language['bbsp_exportconflithttp1']; 
            }
            else if (noteresult[0].freeport == 80)
            {
                notestring = portmapping_language['bbsp_exportconflithttp2']; 
            }
            else
            {
                notestring = portmapping_language['bbsp_exportconflithttp4'];
            }           
        }
    }

    if (GetFeatureInfo().telportmode == 1)
    {
        if (noteresult[1].noteindex == 1)
        {
            notestring += portmapping_language['bbsp_exportconflittel3'];        
        }
        else if (noteresult[1].noteindex == 0)
        {
            if (noteresult[1].freeport == 2323)
            {
                notestring += portmapping_language['bbsp_exportconflittel1']; 
            }
            else if (noteresult[1].freeport == 23)
            {
                notestring += portmapping_language['bbsp_exportconflittel2']; 
            }
            else
            {
                notestring += portmapping_language['bbsp_exportconflittel4'];
            }           
        } 
    }

    return notestring;
}
    
var AddFlag = true;

var selctIndex = -1;
function AddSubmitParam(SubmitForm,type)
{
	var Interface = getSelectVal('PortMappingInterface');
	var url;
 
	SubmitForm.addParameter('x.PortMappingProtocol',getValue('PortMappingProtocol'));
	SubmitForm.addParameter('x.InternalPort',getValue('InternalPort'));
	if(getValue('InternalEndPort') == "")
	{
	    SubmitForm.addParameter('x.X_HW_InternalEndPort',"0");
	}
	else
	{
	    SubmitForm.addParameter('x.X_HW_InternalEndPort',getValue('InternalEndPort'));
	}
	SubmitForm.addParameter('x.ExternalPort',getValue('ExternalPort'));
	SubmitForm.addParameter('x.ExternalPortEndRange',getValue('ExternalEndPort'));
	SubmitForm.addParameter('x.InternalClient',getValue('InternalClient'));

	SubmitForm.addParameter('x.PortMappingDescription',getValue('PortMappingDescription'));
	if (true == TELMEX && getElement("radiosrv")[1].checked == true && getValue('PortMappingDescription') == "")
	{
		var srvname = getValue(realConstSrvName);
		var endCh = srvname.indexOf('(');
		if(endCh > 0)
		{
		    srvname = srvname.substr(0,endCh);
		}
		var splitdata = srvname.split(' ');
		var newsrvname = '';
		for (i = 0; i <splitdata.length; i++)
		{
			newsrvname += splitdata[i];
		}
		newsrvname += '_app';
		SubmitForm.addParameter('x.PortMappingDescription',newsrvname);
	}
	
	SubmitForm.addParameter('x.PortMappingEnabled',getCheckVal('PortMappingEnable'));
	if (getValue('ExternalSrcPort') != "" && getValue('ExternalSrcEndPort') != "")
	{   
	    SubmitForm.addParameter('x.X_HW_ExternalSrcPort',getValue('ExternalSrcPort'));
    	SubmitForm.addParameter('x.X_HW_ExternalSrcEndPort',getValue('ExternalSrcEndPort'));
	}
    else
    {
        if ( AddFlag == false )
	    {
    	    SubmitForm.addParameter('x.X_HW_ExternalSrcPort',0);
    		SubmitForm.addParameter('x.X_HW_ExternalSrcEndPort',0);
        } 
    }

    if (getValue('RemoteHost') != '')
    {
        SubmitForm.addParameter('x.RemoteHost',getValue('RemoteHost'));
    }
    else
    {
        if ( AddFlag == false )
        {
            SubmitForm.addParameter('x.RemoteHost','');
        }
    }
	
	if (PublicIpFlag == 1)
	{
	    SubmitForm.addParameter('x.X_HW_ExternalIP',getValue('PublicIP'));
	}

	
	if ( AddFlag == true )
	{
		url = 'add.cgi?x=' + Interface + '.PortMapping' 
							 +'&RequestFile=html/bbsp/portmapping/portmappingold.asp';
	}
	else
	{
		url = 'set.cgi?x=' + PortMapping[selctIndex].domain
							 +'&RequestFile=html/bbsp/portmapping/portmappingold.asp';
	}
	
	SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
	SubmitForm.setAction(url);
    setDisable('btnApply_ex',1);	
    setDisable('cancelValue',1);
}

function CheckForm(type)
{
    switch (type)
    {
       case 3:
          return CheckPortMapping();
          break;
    }
	
	return true;
}

function CheckExport(newStPort,newEndPort,oldStPort,oldEndPort)
{
	newStPort = parseInt(newStPort,10);
	newEndPort = parseInt(newEndPort,10);
	oldStPort = parseInt(oldStPort,10);
	oldEndPort = parseInt(oldEndPort,10);
        
        if(newEndPort != 0)
        {
			if(((newStPort < oldStPort) && (newEndPort < oldStPort)) || ((newStPort > oldEndPort) && (newEndPort > oldEndPort)))
			{
				return true;
			}
		}
		else
		{   		
			if((newStPort < oldStPort)  || (newStPort > oldEndPort))
			{
				return true;
			}  
		
		}
	return false;
}



function CheckPortMapping() 
{
	var selectObj = getElement('PortMappingInterface');
	var index = 0;
	var idx = 0;

   if(getElement("radiosrv")[1].checked == true && getElById(realConstSrvName).selectedIndex == 0)
   {
  	    AlertEx(portmapping_language['bbsp_notChoiceTemplate']); 
  	    return false;
   }

	if ( selectObj.selectedIndex < 0 )
	{
		 AlertEx(portmapping_language['bbsp_creatwan']);
		 return false;
	}
		 
	index = parseInt(selectObj.selectedIndex,10);
	idx = selectObj.options[index].id.split('_')[1];
	if ( WanInfo[idx].NATEnabled < 1 )
	{
		 AlertEx(MakeWanName1(WanInfo[idx]) + portmapping_language['bbsp_notnat']);
		 return false;
	}

	if (getElement('PortMappingInterface').length == 0)
	{
	    AlertEx(portmapping_language['bbsp_wanconinvalid']);
	    return false;	
	}	

    with (getElById('PortMappingForm')) 
    {      
        var i=0;
		for(i=0;i<PortMapping.length;i++)
		{
			if(MakeWanName1(WanInfo[idx])!=PortMapping[i].Interface||(getValue('PortMappingProtocol').indexOf(PortMapping[i].Protocol)==-1&&PortMapping[i].Protocol.indexOf(getValue('PortMappingProtocol'))==-1))
			{
				continue;
			}
			
			if (getValue("PublicIP") != '')
			{
				if (isValidIpAddress(getValue("PublicIP")) == false)
				{
					AlertEx(portmapping_language['bbsp_publicipvolid']);
					return false;
				}
				if (isAbcIpAddress(getValue("PublicIP")) == false 
				   || isDeIpAddress(getValue("PublicIP")) == true 
				   || isBroadcastIpAddress(getValue("PublicIP")) == true 
				   || isLoopIpAddress(getValue("PublicIP")) == true ) 
			   {              
					AlertEx(portmapping_language['bbsp_publicipvolid']);
					return false;
			   }
			}
			
			if((getValue('ExternalEndPort') == '0' || PortMapping[i].ExEndPort == '0') && AddFlag == true)
			{                   
				AlertEx(portmapping_language['bbsp_extportinvalid']);
				return false;
			} 
			
			if(parseInt(getValue('ExternalEndPort'),10)<=parseInt(PortMapping[i].ExEndPort,10)&&parseInt(getValue('ExternalEndPort'),10)>=parseInt(PortMapping[i].ExPort,10) && parseInt(getValue('ExternalEndPort'),10) >= parseInt(getValue('ExternalPort'),10))
			{
				if(i!=selctIndex)
				{
				AlertEx(portmapping_language['bbsp_extportinvalid']);
                return false;
				}
			}
			if(parseInt(getValue('ExternalPort'),10)<=parseInt(PortMapping[i].ExEndPort,10)&&parseInt(getValue('ExternalPort'),10)>=parseInt(PortMapping[i].ExPort,10) && parseInt(getValue('ExternalEndPort'),10) >= parseInt(getValue('ExternalPort'),10))
			{
				if(i!=selctIndex)
				{
				AlertEx(portmapping_language['bbsp_extportinvalid']);
                return false;
				}
			}
			if(parseInt(getValue('ExternalPort'),10)<=parseInt(PortMapping[i].ExPort,10)&&parseInt(getValue('ExternalEndPort'),10)>=parseInt(PortMapping[i].ExEndPort,10) && parseInt(getValue('ExternalEndPort'),10) >= parseInt(getValue('ExternalPort'),10))
			{
				if(i!=selctIndex)
				{
				AlertEx(portmapping_language['bbsp_extportinvalid']);
                return false;
				}
			}
		}
		if (getValue('RemoteHost') != "")
        {
            if (isValidIpAddress(getValue('RemoteHost')) == false)
            {
                AlertEx(portmapping_language['bbsp_extsrcipinvalid']);
                return false;
            }
        }           
        if (getValue('ExternalPort') == "")
        {
            AlertEx(portmapping_language['bbsp_extstartportisreq']);
            return false;
        }

		if (getValue('ExternalEndPort') == "")
        {
            AlertEx(portmapping_language['bbsp_extendportisreq']);
            return false;
        }

        if (getValue('InternalPort') == "")
        {
            AlertEx(portmapping_language['bbsp_intstartportisreq']);
            return false;
        }
		else if (getValue('InternalPort').charAt(0) == '0')
		{
		    AlertEx(portmapping_language['bbsp_intstartport'] +  getValue('InternalPort') + portmapping_language['bbsp_invalid']);
            return false;
		}

        if (getValue('InternalClient') == "")
        {
            AlertEx(portmapping_language['bbsp_hostipisreq']);
            return false;
        }  
		if (getValue('InternalClient') == getValue('RemoteHost'))
		{
		    AlertEx(portmapping_language['bbsp_intipdifhostip']);
            return false;
		}

        if (isAbcIpAddress(getValue('InternalClient')) == false)
        {
            AlertEx(portmapping_language['bbsp_hostipinvalid']);
            return false;
        }


        if (isValidPort2(getValue('ExternalPort')) == false )
        {
            AlertEx(portmapping_language['bbsp_extstartport']+getValue('ExternalPort')+portmapping_language['bbsp_invalid'] );
         
		    return false;
        }
		if (isValidPort2(getValue('ExternalEndPort')) == false )
        {
            AlertEx(portmapping_language['bbsp_extendport']+getValue('ExternalEndPort')+portmapping_language['bbsp_invalid'] );
            return false;
        }


        if (isValidPort(getValue('InternalPort')) == false )
        {
            AlertEx(portmapping_language['bbsp_intstartport']+getValue('InternalPort')+portmapping_language['bbsp_invalid'] );
            return false;
        }

		if (getValue('InternalEndPort') != "")
		{
			if (isValidPort2(getValue('InternalEndPort')) == false )
	        {
            	AlertEx(portmapping_language['bbsp_intendport']+getValue('InternalEndPort')+portmapping_language['bbsp_invalid'] );
	            return false;
	        }
		}
		
		if (true == TELMEX && getElement("radiosrv")[0].checked == true && getValue('PortMappingDescription') == "")
		{
            AlertEx(portmapping_language['bbsp_mappingisreq']);
            return false;
        }

        if (isValidName(getValue('PortMappingDescription')) == false) 
        {
            AlertEx(portmapping_language['bbsp_mappinginvalid']);
            return false;
        }

		var ExtPort=0;
		var ExtEndPort=0;
		ExtPort = parseInt(getValue("ExternalPort"),10);
		ExtEndPort = parseInt(getValue("ExternalEndPort"),10);
		if ((7070 <= ExtPort) && (7079 >= ExtPort) || (7070 <= ExtEndPort) && (7079 >= ExtEndPort))
		{
			if ( ConfirmEx(portmapping_language['bbsp_confirm1']) == false )
			{
				return false;
			}
		}

        if ((getValue('ExternalSrcPort') == "" && getValue('ExternalSrcEndPort') != "")
			|| (getValue('ExternalSrcPort') != "" && getValue('ExternalSrcEndPort') == ""))
        {
           AlertEx(portmapping_language['bbsp_extsrcstartandendport']);
		   return false;
        }
		else if (getValue('ExternalSrcPort') != "" && getValue('ExternalSrcEndPort') != "")
		{
		    if (isValidPort2(getValue('ExternalSrcPort')) == false)
            {
                AlertEx(portmapping_language['bbsp_extsrcstartport']+getValue('ExternalSrcPort')+portmapping_language['bbsp_invalid'] );
                return false;
            }
		    if (isValidPort2(getValue('ExternalSrcEndPort')) == false)
            {
                AlertEx(portmapping_language['bbsp_extsrcendport']+getValue('ExternalSrcEndPort')+portmapping_language['bbsp_invalid']);
                return false;
            }
		}
    }
	
	var InternalHost = getValue('InternalClient');
	var Ipjudge1 = getValue('InternalClient').split(".");

    if ( parseInt(Ipjudge1[3],10) == 0 )
    {
		AlertEx(portmapping_language['bbsp_hostipoutran']);
		return false;
    }

	if (GetCfgMode().PCCWHK == "1" )
	{
		if (false == IsBelongAddrPool(InternalHost))
		{
			AlertEx(portmapping_language['bbsp_hostipoutran']);
			return false;
		}
	}
	
    if (AddFlag == true)
    {
        CheckAddActionExtPortConflict(0);
        CheckAddActionExtPortConflict(1);       
    }
    else
    {
        CheckModifyActionExtPortConflict(0);
        CheckModifyActionExtPortConflict(1);
    }

    var notestring = ProductConflitNote();
    
    if (notestring.length != 0)
    {
		StartFileOpt();
        AlertEx(notestring);
    }
	
    return true;
}

function LoadFrame()
{
	setDisplay(realDivSrvName,1);
    if (PortMapping.length > 0)
    {
     	if(GetCfgMode().PCCWHK == "1")
     	{  
     		 selectLine('record_no');
        setDisplay('ConfigForm',0);
     		for (i = 0; i < PortMapping.length; i++)
				{  
					var ipjudge2=PortMapping[i].InClient.split("."); 	
					if((ipjudge2[0] == 192) && (ipjudge2[1] == 168) && (ipjudge2[2] == 8) && (ipjudge2[3] > 127 ))
					{
						continue;
					}
					selectLine('record_'+i);
        			setDisplay('ConfigForm',1);
					break;
				}
     	}
     	else
     		{
 	    selectLine('record_0');
        setDisplay('ConfigForm',1);
      }
    }	
    else
    {	
 	    selectLine('record_no');
        setDisplay('ConfigForm',0);
    }

	if(isValidIpAddress(numpara) == true)
	{
		clickAdd('Portmapping');
		setText('InternalClient', numpara);
		for (var k = 0; k < LANhostIP.length; k++)
		{
			if (numpara == LANhostIP[k])
			{
				setSelect('HostName', k);
				break;
			}
		}
	}
	loadlanguage();
}

function ShowPortMapping()
{
   var Interface = getElement('PortMappingInterface');
   
   if(Interface.options.length > 0 && (Interface.selectedIndex >= 0))
   {
   		Interface.title = Interface.options[Interface.selectedIndex].text;
   }
   var html = '<table border="1" cellpadding="0" cellspacing="0" width="100%" style="table-layout:fixed;word-break:break-all">'
   			 +  '<tr align="middle">'
   			 +  '<td class="head_title width_8p">' + portmapping_language['bbsp_protocol'] + '</td>'
   			 +  '<td class="head_title width_10p">' + portmapping_language['bbsp_srcip'] + '</td>'
   			 +  '<td class="head_title width_20p">' + portmapping_language['bbsp_extport'] + '</td>'
   			 +  '<td class="head_title width_20p">' + portmapping_language['bbsp_intport'] + '</td>'
   			 +  '<td class="head_title width_10p">' + portmapping_language['bbsp_host'] + '</td>' 
   			 +  '<td class="head_title width_20p">' + portmapping_language['bbsp_extsrcport'] + '</td>'
   			 +  '<td class="head_title width_6p">' + portmapping_language['bbsp_enable'] + '</td>' 
   			 +  '<td class="head_title width_6p">' + portmapping_language['bbsp_del'] + '</td>'
   			 + '</tr>'            

   for (i = 0; i < PortMapping.length; i++)
   {
	    if (PortMapping[i].domain.indexOf(getSelectVal('PortMappingInterface')) > -1)
		{
			html += '<TR class="align_center">'
			html +=  '<TD >' + PortMapping[i].Protocol + '&nbsp;</TD>';
			html += '<TD >' + PortMapping[i].RemoteHost + '&nbsp;</TD>';
			html += '<TD >' + PortMapping[i].ExPort + '-' + PortMapping[i].ExEndPort + '&nbsp;</TD>';
			html += '<TD >' + PortMapping[i].InPort + '-' + PortMapping[i].InEndPort + '&nbsp;</TD>';
			html += '<TD >' + PortMapping[i].InClient + '&nbsp;</TD>';
			html += '<TD >' + PortMapping[i].ExSrcPort + '-' + '&nbsp;</TD>';
			html += '<TD >' + PortMapping[i].ExSrcEndPort + '&nbsp;</TD>';
			if (PortMapping[i].ProtMapEnabled == 1)
			{
			   html += '<TD >' + portmapping_language['bbsp_enable'] + '&nbsp;</TD>';
			}
			else
			{
			   html += '<TD >' + portmapping_language['bbsp_disable'] + '&nbsp;</TD>';
			}	
			html += '<TD ><input type="checkbox" name="rml" value="' 
							+ PortMapping[i].domain + '"></TD>';
			html += '</TR>';
		}			
   }
   html += '</table>';	
}

function record_click(id)
{
	selectLine(id);
	setDisplay("typeTR",0);
}
function ShowPortMap()
{

    var html = '' ;
    var i = 0;
	for (i = 0; i < PortMapping.length; i++)
	{  
	   var ipjudge2=PortMapping[i].InClient.split("."); 	
	   if((GetCfgMode().PCCWHK == "1") && (ipjudge2[0] == 192) && (ipjudge2[1] == 168) && (ipjudge2[2] == 8) && (ipjudge2[3] > 127 ))
	   {
	   	continue;
	   }


		html += '<TR id=record_' + i 
				+' class="tabal_center01" onclick="record_click(this.id);">';
		html += '<TD ><input type="checkbox" name="rml" value="' 
						+ PortMapping[i].domain + '"></TD>';
		html +=  '<TD >' + PortMapping[i].Interface + '</TD>';
		if (PortMapping[i].Description == "")
		{
			html +=  '<TD >' + '--' + '</TD>';
		}
		else
		{
		html +=  '<TD title="' + ShowNewRow(PortMapping[i].Description) +'">' + GetStringContent(PortMapping[i].Description,16) + '</TD>';
		}
		html +=  '<TD >' + (PortMapping[i].Protocol).toUpperCase() + '</TD>';
		html +=  '<TD >' + PortMapping[i].ExPort + '--'+PortMapping[i].ExEndPort+'</TD>';
		if ("0" == PortMapping[i].InEndPort)
		{
			html += '<TD >' + PortMapping[i].InPort + '&nbsp;</TD>';
		}
		else
		{
		    if('' != PortMapping[i].InEndPort){
			    html += '<TD >' + PortMapping[i].InPort + '--' + PortMapping[i].InEndPort + '&nbsp;</TD>';
		    }else{
		        html += '<TD >' + PortMapping[i].InPort + '&nbsp;</TD>';
		    }
		}
		html +=  '<TD >' + PortMapping[i].InClient + '</TD>';

		if (PortMapping[i].ProtMapEnabled == 1)
		{
		   html += '<TD >' + portmapping_language['bbsp_enable'] + '&nbsp;</TD>';
		}
		else
		{
		   html += '<TD >' + portmapping_language['bbsp_disable'] + '&nbsp;</TD>';
		}	
		html += '</TR>';	
	}
	document.write(html);
}

var TOTAL_APP = 14;
var FIRST_APP = portmapping_language['bbsp_selectdd'];
var v = new Array(TOTAL_APP);

v[0] = new cV("Domain Name Server (DNS)",1);
v[0].e[0] = new iVe("53", "53", "2", "53", "53");

v[1] = new cV("FTP Server",1);
v[1].e[0] = new iVe("21", "21", "1", "21", "21");
    
v[2] = new cV("IPSEC",1); 
v[2].e[0] = new iVe("500", "500", "2", "500", "500"); 

v[3] = new cV("Mail (POP3)",1);
v[3].e[0] = new iVe("110", "110", "1", "110", "110");

v[4] = new cV("Mail (SMTP)",1);
v[4].e[0] = new iVe("25", "25", "1", "25", "25");
   
v[5] = new cV("PPTP",1);
v[5].e[0] = new iVe("1723", "1723", "1", "1723", "1723");

v[6] = new cV("Real Player 8 Plus",1);
v[6].e[0] = new iVe("7070", "7070", "2", "7070", "7070");

v[7] = new cV("Secure Shell Server (SSH)",1);
v[7].e[0] = new iVe("22", "22", "1", "22", "22");

v[8] = new cV("Secure Web Server (HTTPS)",1);
v[8].e[0] = new iVe("443", "443", "1", "443", "443");

v[9] = new cV("SNMP",1);
v[9].e[0] = new iVe("161", "161", "2", "161", "161");

v[10] = new cV("SNMP Trap",1);
v[10].e[0] = new iVe("162", "162", "2", "162", "162");

v[11] = new cV("Telnet Server",1);   
v[11].e[0] = new iVe("23", "23", "1", "23", "23");
        
v[12] = new cV("TFTP",1);   
v[12].e[0] = new iVe("69", "69", "2", "69", "69");

v[13] = new cV("Web Server (HTTP)",1);
v[13].e[0] = new iVe("80", "80", "1", "80", "80");

TOTAL_APP_telmex = 54;
var v_telmex_en = new Array(TOTAL_APP_telmex);
v_telmex_en[0] = new cV("AIM Talk",1);
v_telmex_en[0].e[0] = new iVe("5190", "5190", "1", "5190", "5190");

v_telmex_en[1] = new cV("Apple Remote desktop",1);
v_telmex_en[1].e[0] = new iVe("3283", "3283", "1", "3283", "3283");

v_telmex_en[2] = new cV("BearShare",1); 
v_telmex_en[2].e[0] = new iVe("6346", "6346", "1", "6346", "6346"); 

v_telmex_en[3] = new cV("BitTorrent",1); 
v_telmex_en[3].e[0] = new iVe("6881", "6900", "0", "6881", "6900");

v_telmex_en[4] = new cV("Checkpoint FW1 VPN",1); 
v_telmex_en[4].e[0] = new iVe("259", "259", "0", "259", "259"); 

v_telmex_en[5] = new cV("DHCPv6 Server",1); 
v_telmex_en[5].e[0] = new iVe("547", "547", "0", "547", "547"); 

v_telmex_en[6] = new cV("DirectX",1); 
v_telmex_en[6].e[0] = new iVe("47624", "47624", "0", "47624", "47624"); 

v_telmex_en[7] = new cV("DNS Server",1); 
v_telmex_en[7].e[0] = new iVe("53", "53", "0", "53", "53");

v_telmex_en[8] = new cV("eMule",1);
v_telmex_en[8].e[0] = new iVe("4662", "4662", "1", "4662", "4662"); 

v_telmex_en[9] = new cV("FTP Server",1);
v_telmex_en[9].e[0] = new iVe("21", "21", "1", "21", "21"); 

v_telmex_en[10] = new cV("Gnutella",1);
v_telmex_en[10].e[0] = new iVe("6346", "6346", "0", "6346", "6346");

v_telmex_en[11] = new cV("HTTPS Server",1);
v_telmex_en[11].e[0] = new iVe("443", "443", "1", "443", "443"); 

v_telmex_en[12] = new cV("ICQ",1);
v_telmex_en[12].e[0] = new iVe("5190", "5190", "1", "5190", "5190");

v_telmex_en[13] = new cV("IMAP Server",1);
v_telmex_en[13].e[0] = new iVe("143", "143", "1", "143", "143"); 

v_telmex_en[14] = new cV("iMesh",1);
v_telmex_en[14].e[0] = new iVe("1214", "1214", "1", "1214", "1214"); 

v_telmex_en[15] = new cV("IP Camera 1",1);
v_telmex_en[15].e[0] = new iVe("8120", "8120", "1", "80", "80"); 

v_telmex_en[16] = new cV("IP Camera 2",1);
v_telmex_en[16].e[0] = new iVe("8121", "8121", "1", "80", "80"); 

v_telmex_en[17] = new cV("IP Camera 3",1);
v_telmex_en[17].e[0] = new iVe("8122", "8122", "1", "80", "80"); 

v_telmex_en[18] = new cV("IP Camera 4",1);
v_telmex_en[18].e[0] = new iVe("8123", "8123", "1", "80", "80"); 
        
v_telmex_en[19] = new cV("IPSEC",1); 
v_telmex_en[19].e[0] = new iVe("500", "500", "2", "500", "500");  

v_telmex_en[20] = new cV("IRC",1); 
v_telmex_en[20].e[0] = new iVe("194", "194", "1", "194", "194");

v_telmex_en[21] = new cV("iTunes",1); 
v_telmex_en[21].e[0] = new iVe("3689", "3689", "0", "3689", "3689"); 

v_telmex_en[22] = new cV("KaZaa",1); 
v_telmex_en[22].e[0] = new iVe("1214", "1214", "1", "1214", "1214"); 

v_telmex_en[23] = new cV("Lotus Notes Server",1); 
v_telmex_en[23].e[0] = new iVe("1352", "1352", "1", "1352", "1352");

v_telmex_en[24] = new cV("MAMP Server",1);
v_telmex_en[24].e[0] = new iVe("8888", "8888", "1", "8888", "8888"); 

v_telmex_en[25] = new cV("MySQL Server",1);
v_telmex_en[25].e[0] = new iVe("3306", "3306", "0", "3306", "3306"); 

v_telmex_en[26] = new cV("Napster",1);
v_telmex_en[26].e[0] = new iVe("6699", "6699", "0", "6699", "6699"); 

v_telmex_en[27] = new cV("Netmeeting",1);
v_telmex_en[27].e[0] = new iVe("389", "389", "1", "389", "389");

v_telmex_en[28] = new cV("NNTP Server",1);
v_telmex_en[28].e[0] = new iVe("119", "119", "1", "119", "119");

v_telmex_en[29] = new cV("OpenVPN",1);
v_telmex_en[29].e[0] = new iVe("1194", "1194", "0", "1194", "1194");

v_telmex_en[30] = new cV("pcAnywhere",1);
v_telmex_en[30].e[0] = new iVe("5631", "5632", "0", "5631", "5632"); 

v_telmex_en[31] = new cV("PlayStation",1);
v_telmex_en[31].e[0] = new iVe("10070", "10080", "0", "10070", "10080");

v_telmex_en[32] = new cV("POP3 Server",1);
v_telmex_en[32].e[0] = new iVe("110", "110", "1", "110", "110"); 
      
v_telmex_en[33] = new cV("PPTP",1);
v_telmex_en[33].e[0] = new iVe("1723", "1723", "1", "1723", "1723"); 

v_telmex_en[34] = new cV("Real Player 8 Plus",1);
v_telmex_en[34].e[0] = new iVe("7070", "7070", "2", "7070", "7070");

v_telmex_en[35] = new cV("Remote Desktop",1);
v_telmex_en[35].e[0] = new iVe("3389", "3389", "1", "3389", "3389");

v_telmex_en[36] = new cV("Remote support of XP",1);
v_telmex_en[36].e[0] = new iVe("3389", "3389", "1", "3389", "3389");

v_telmex_en[37] = new cV("Skype",1);
v_telmex_en[37].e[0] = new iVe("443", "443", "0", "443", "443");

v_telmex_en[38] = new cV("SMTP	Server",1);
v_telmex_en[38].e[0] = new iVe("25", "25", "1", "25", "25"); 

v_telmex_en[39] = new cV("SNMP",1);
v_telmex_en[39].e[0] = new iVe("161", "161", "2", "161", "161");

v_telmex_en[40] = new cV("SNMP Trap",1);
v_telmex_en[40].e[0] = new iVe("162", "162", "2", "162", "162");

v_telmex_en[41] = new cV("SQL Server",1);
v_telmex_en[41].e[0] = new iVe("1433", "1433", "1", "1433", "1433"); 

v_telmex_en[42] = new cV("SSH Server",1);
v_telmex_en[42].e[0] = new iVe("22", "22", "1", "22", "22"); 

v_telmex_en[43] = new cV("Telnet Server",1);   
v_telmex_en[43].e[0] = new iVe("23", "23", "1", "23", "23");
        
v_telmex_en[44] = new cV("TFTP",1);   
v_telmex_en[44].e[0] = new iVe("69", "69", "2", "69", "69");

v_telmex_en[45] = new cV("Web Server",1);
v_telmex_en[45].e[0] = new iVe("80", "80", "1", "80", "80");

v_telmex_en[46] = new cV("VNC",1);  
v_telmex_en[46].e[0] = new iVe("5900", "5900", "1", "5900", "5900"); 

v_telmex_en[47] = new cV("Vuze",1); 
v_telmex_en[47].e[0] = new iVe("6880", "6880", "1", "6880", "6880"); 

v_telmex_en[48] = new cV("Wii",1);   
v_telmex_en[48].e[0] = new iVe("80", "80", "0", "80", "80"); 

v_telmex_en[49] = new cV("Windows Live Messenger",1);  
v_telmex_en[49].e[0] = new iVe("1025", "1025", "0", "1025", "1025"); 

v_telmex_en[50] = new cV("WinMX",1);   
v_telmex_en[50].e[0] = new iVe("6699", "6699", "1", "6699", "6699"); 

v_telmex_en[51] = new cV("X Windows",1);  
v_telmex_en[51].e[0] = new iVe("6000", "6000", "2", "6000", "6000"); 

v_telmex_en[52] = new cV("Xbox Live",1);  
v_telmex_en[52].e[0] = new iVe("53", "53", "0", "53", "53"); 

v_telmex_en[53] = new cV("Yahoo Messenger",1);  
v_telmex_en[53].e[0] = new iVe("5050", "5050", "1", "5050", "5050"); 

var v_telmex_sp = new Array(TOTAL_APP_telmex);
v_telmex_sp[0] = new cV("AIM Talk",1);
v_telmex_sp[0].e[0] = new iVe("5190", "5190", "1", "5190", "5190");

v_telmex_sp[1] = new cV("Apple Remote desktop",1);
v_telmex_sp[1].e[0] = new iVe("3283", "3283", "1", "3283", "3283");

v_telmex_sp[2] = new cV("Assistance remote XP",1); 
v_telmex_sp[2].e[0] = new iVe("3389", "3389", "1", "3389", "3389"); 

v_telmex_sp[3] = new cV("BearShare",1); 
v_telmex_sp[3].e[0] = new iVe("6346", "6346", "1", "6346", "6346"); 

v_telmex_sp[4] = new cV("BitTorrent",1); 
v_telmex_sp[4].e[0] = new iVe("6881", "6900", "0", "6881", "6900"); 

v_telmex_sp[5] = new cV("Camera IP 1",1); 
v_telmex_sp[5].e[0] = new iVe("8120", "8120", "1", "80", "80"); 

v_telmex_sp[6] = new cV("Camera IP 2",1); 
v_telmex_sp[6].e[0] = new iVe("8121", "8121", "1", "80", "80"); 

v_telmex_sp[7] = new cV("Camera IP 3",1); 
v_telmex_sp[7].e[0] = new iVe("8122", "8122", "1", "80", "80"); 

v_telmex_sp[8] = new cV("Camera IP 4",1); 
v_telmex_sp[8].e[0] = new iVe("8123", "8123", "1", "80", "80"); 

v_telmex_sp[9] = new cV("Checkpoint FW1 VPN",1); 
v_telmex_sp[9].e[0] = new iVe("259", "259", "0", "259", "259"); 

v_telmex_sp[10] = new cV("DirectX",1);  
v_telmex_sp[10].e[0] = new iVe("47624", "47624", "0", "47624", "47624"); 

v_telmex_sp[11] = new cV("eMule",1);   
v_telmex_sp[11].e[0] = new iVe("4662", "4662", "1", "4662", "4662"); 

v_telmex_sp[12] = new cV("Escritorio Remote",1);  
v_telmex_sp[12].e[0] = new iVe("3389", "3389", "1", "3389", "3389"); 

v_telmex_sp[13] = new cV("Gnutella",1);  
v_telmex_sp[13].e[0] = new iVe("6346", "6346", "0", "6346", "6346"); 

v_telmex_sp[14] = new cV("ICQ",1);  
v_telmex_sp[14].e[0] = new iVe("5190", "5190", "1", "5190", "5190"); 

v_telmex_sp[15] = new cV("iMesh",1);  
v_telmex_sp[15].e[0] = new iVe("1214", "1214", "1", "1214", "1214"); 

v_telmex_sp[16] = new cV("IPSEC",1); 
v_telmex_sp[16].e[0] = new iVe("500", "500", "2", "500", "500"); 

v_telmex_sp[17] = new cV("IRC",1);  
v_telmex_sp[17].e[0] = new iVe("194", "194", "1", "194", "194"); 

v_telmex_sp[18] = new cV("iTunes",1);  
v_telmex_sp[18].e[0] = new iVe("3689", "3689", "0", "3689", "3689"); 

v_telmex_sp[19] = new cV("KaZaa",1);  
v_telmex_sp[19].e[0] = new iVe("1214", "1214", "1", "1214", "1214"); 

v_telmex_sp[20] = new cV("SNMP Trap",1);
v_telmex_sp[20].e[0] = new iVe("162", "162", "2", "162", "162");

v_telmex_sp[21] = new cV("Napster",1);  
v_telmex_sp[21].e[0] = new iVe("6699", "6699", "0", "6699", "6699"); 

v_telmex_sp[22] = new cV("Netmeeting",1); 
v_telmex_sp[22].e[0] = new iVe("389", "389", "1", "389", "389"); 

v_telmex_sp[23] = new cV("OpenVPN",1);  
v_telmex_sp[23].e[0] = new iVe("1194", "1194", "0", "1194", "1194"); 

v_telmex_sp[24] = new cV("pcAnywhere",1);  
v_telmex_sp[24].e[0] = new iVe("5631", "5632", "0", "5631", "5632"); 

v_telmex_sp[25] = new cV("PlayStation",1);  
v_telmex_sp[25].e[0] = new iVe("10070", "10080", "0", "10070", "10080"); 

v_telmex_sp[26] = new cV("PPTP",1);  
v_telmex_sp[26].e[0] = new iVe("1723", "1723", "1", "1723", "1723"); 

v_telmex_sp[27] = new cV("Real Player 8 Plus",1);
v_telmex_sp[27].e[0] = new iVe("7070", "7070", "2", "7070", "7070");

v_telmex_sp[28] = new cV("Server DHCPv6",1);  
v_telmex_sp[28].e[0] = new iVe("547", "547", "0", "547", "547"); 

v_telmex_sp[29] = new cV("Server DNS",1);  
v_telmex_sp[29].e[0] = new iVe("53", "53", "0", "53", "53"); 

v_telmex_sp[30] = new cV("FTP Server",1);  
v_telmex_sp[30].e[0] = new iVe("21", "21", "1", "21", "21"); 

v_telmex_sp[31] = new cV("Server HTTPS",1);  
v_telmex_sp[31].e[0] = new iVe("443", "443", "1", "443", "443"); 

v_telmex_sp[32] = new cV("Server IMAP",1);  
v_telmex_sp[32].e[0] = new iVe("143", "143", "1", "143", "143"); 

v_telmex_sp[33] = new cV("Server Lotus Notes",1);  
v_telmex_sp[33].e[0] = new iVe("1352", "1352", "1", "1352", "1352"); 

v_telmex_sp[34] = new cV("Server MAMP",1);  
v_telmex_sp[34].e[0] = new iVe("8888", "8888", "1", "8888", "8888"); 

v_telmex_sp[35] = new cV("Server MySQL",1);  
v_telmex_sp[35].e[0] = new iVe("3306", "3306", "0", "3306", "3306"); 

v_telmex_sp[36] = new cV("Server NNTP",1);  
v_telmex_sp[36].e[0] = new iVe("119", "119", "1", "119", "119"); 

v_telmex_sp[37] = new cV("Server POP3",1);  
v_telmex_sp[37].e[0] = new iVe("110", "110", "1", "110", "110"); 

v_telmex_sp[38] = new cV("Server SQL",1);  
v_telmex_sp[38].e[0] = new iVe("1433", "1433", "1", "1433", "1433"); 

v_telmex_sp[39] = new cV("Server SSH",1);  
v_telmex_sp[39].e[0] = new iVe("22", "22", "1", "22", "22"); 

v_telmex_sp[40] = new cV("Server SMTP",1);  
v_telmex_sp[40].e[0] = new iVe("25", "25", "1", "25", "25"); 

v_telmex_sp[41] = new cV("Telnet Server",1);  
v_telmex_sp[41].e[0] = new iVe("23", "23", "1", "23", "23"); 

v_telmex_sp[42] = new cV("TFTP",1);  
v_telmex_sp[42].e[0] = new iVe("69", "69", "2", "69", "69"); 

v_telmex_sp[43] = new cV("Server WEB",1);  
v_telmex_sp[43].e[0] = new iVe("80", "80", "1", "80", "80"); 

v_telmex_sp[44] = new cV("Skype",1);  
v_telmex_sp[44].e[0] = new iVe("443", "443", "0", "443", "443"); 

v_telmex_sp[45] = new cV("SNMP",1);
v_telmex_sp[45].e[0] = new iVe("161", "161", "2", "161", "161");

v_telmex_sp[46] = new cV("VNC",1);  
v_telmex_sp[46].e[0] = new iVe("5900", "5900", "1", "5900", "5900"); 

v_telmex_sp[47] = new cV("Vuze",1);  
v_telmex_sp[47].e[0] = new iVe("6880", "6880", "1", "6880", "6880"); 

v_telmex_sp[48] = new cV("Wii",1);   
v_telmex_sp[48].e[0] = new iVe("80", "80", "0", "80", "80"); 

v_telmex_sp[49] = new cV("Windows Live Messenger",1);   
v_telmex_sp[49].e[0] = new iVe("1025", "1025", "0", "1025", "1025"); 

v_telmex_sp[50] = new cV("WinMX",1);   
v_telmex_sp[50].e[0] = new iVe("6699", "6699", "1", "6699", "6699"); 

v_telmex_sp[51] = new cV("X Windows",1);  
v_telmex_sp[51].e[0] = new iVe("6000", "6000", "2", "6000", "6000"); 

v_telmex_sp[52] = new cV("Xbox Live",1);  
v_telmex_sp[52].e[0] = new iVe("53", "53", "0", "53", "53"); 

v_telmex_sp[53] = new cV("Yahoo Messenger",1);  
v_telmex_sp[53].e[0] = new iVe("5050", "5050", "1", "5050", "5050"); 

function cV(name, entryNum)
{   
   this.name = name;
   this.eNum = entryNum;
   this.e = new Array(5);
}

function iVe(eStart, eEnd, proto, iStart, iEnd)
{
   this.eStart = eStart;
   this.eEnd = eEnd;
   this.proto = proto;
   this.iStart = iStart;
   this.iEnd = iEnd;
}

function trimspace(str)
{
    var strTemp = new String(str);
    while (-1 != strTemp.search(" "))
    {
        strTemp = strTemp.replace(" ", "");  
    }
    return strTemp; 
}

function setDataDisable()
{
    if (getValue('InternalPort') == 21)
    {
        setDisable('InternalPort',1);
        setDisable('InternalEndPort',1);
    }
    else
    {
        setDisable('InternalPort',0);
        setDisable('InternalEndPort',0);
    }
    if (true == TELMEX)
    {
        setDisable('InternalPort',1);
        setDisable('InternalEndPort',1);
        setDisable('ExternalPort',1);
        setDisable('ExternalEndPort',1);
	}
}
function appSelect_telmex_en(sName)
{
   with (getElement('PortMappingForm')) 
   {   
      if (sName == FIRST_APP) 
      {
         return;
      }

      for(i = 0; i < TOTAL_APP_telmex; i++) 
      {
          if(v_telmex_en[i].name == sName) 
          {	 
			  switch (v_telmex_en[i].e[0].proto)
			  {
    			  case '0':
    			      setSelect('PortMappingProtocol','TCP/UDP');
    			      break;
    			  case '1':
       			      setSelect('PortMappingProtocol','TCP');
       			      break;
    			  case '2':
    			      setSelect('PortMappingProtocol','UDP');
    			      break;
			  }

              getElement('RemoteHost').value = "";
              getElement('ExternalPort').value = v_telmex_en[i].e[0].eStart;
			  getElement('ExternalEndPort').value = v_telmex_en[i].e[0].eEnd;
              getElement('InternalPort').value = v_telmex_en[i].e[0].iStart;
			  getElement('InternalEndPort').value = v_telmex_en[i].e[0].iEnd;
			  if (getValue('InternalPort') == 21)
			  {
			      setDisable('InternalPort',1);
				  setDisable('InternalEndPort',1);
			  }
			  else
			  {
			      setDisable('InternalPort',0);
				  setDisable('InternalEndPort',0);
			  }
          }
      }
   }
}

function appSelect_telmex_sp(sName)
{
   with (getElement('PortMappingForm')) 
   {   
      if (sName == FIRST_APP) 
      {
         return;
      }

      for(i = 0; i < TOTAL_APP_telmex; i++) 
      {
          if(v_telmex_sp[i].name == sName) 
          {	 
			  switch (v_telmex_sp[i].e[0].proto)
			  {
    			  case '0':
    			      setSelect('PortMappingProtocol','TCP/UDP');
    			      break;
    			  case '1':
       			      setSelect('PortMappingProtocol','TCP');
       			      break;
    			  case '2':
    			      setSelect('PortMappingProtocol','UDP');
    			      break;
			  }

              getElement('RemoteHost').value = "";
              getElement('ExternalPort').value = v_telmex_sp[i].e[0].eStart;
			  getElement('ExternalEndPort').value = v_telmex_sp[i].e[0].eEnd;
              getElement('InternalPort').value = v_telmex_sp[i].e[0].iStart;
			  getElement('InternalEndPort').value = v_telmex_sp[i].e[0].iEnd;
			  if (getValue('InternalPort') == 21)
			  {
			      setDisable('InternalPort',1);
				  setDisable('InternalEndPort',1);
			  }
			  else
			  {
			      setDisable('InternalPort',0);
				  setDisable('InternalEndPort',0);
			  }
          }
      }
   }
}
function appSelect(sName) 
{
   getElById(realConstSrvName).title = getElById(realConstSrvName).options[getElById(realConstSrvName).selectedIndex].text;
   with (getElement('PortMappingForm')) 
   {   
      if (sName == FIRST_APP) 
      {
        return;
      }

      for(i = 0; i < TOTAL_APP; i++) 
      {
          if(v[i].name == sName) 
          {	 				    
			  switch (v[i].e[0].proto)
			  {
    			  case '0':
    			      setSelect('PortMappingProtocol','TCP/UDP');
    			      break;
    			  case '1':
       			      setSelect('PortMappingProtocol','TCP');
       			      break;
    			  case '2':
    			      setSelect('PortMappingProtocol','UDP');
    			      break;
			  }

              getElement('RemoteHost').value = "";
              getElement('ExternalPort').value = v[i].e[0].eStart;
			  getElement('ExternalEndPort').value = v[i].e[0].eEnd;
              getElement('InternalPort').value = v[i].e[0].iStart;
			  getElement('InternalEndPort').value = v[i].e[0].iEnd;
				
			  setDataDisable();
		      return;
          }
      }
   }
}

function radioClick()
{
   if(getElement("radiosrv")[0].checked == true)
   {
       setDisable(realConstSrvName,1);
	   setDisable('InternalPort',0);
	   setDisable('InternalEndPort',0);
	   setDisable('ExternalPort',0);
	   setDisable('ExternalEndPort',0);
	   setDisable('PortMappingProtocol',0);
   }
   else
   {
      setDisable(realConstSrvName,0);     
       setDataDisable();
   }
}

function setCtlDisplay(record)
{
    var endIndex = record.domain.lastIndexOf('PortMapping') - 1;
	var Interface = record.domain.substring(0,endIndex);

	setSelect('PortMappingInterface',Interface);
	setSelect('PortMappingProtocol',(record.Protocol).toUpperCase());

	setCheck('PortMappingEnable',record.ProtMapEnabled);
	setText('RemoteHost',record.RemoteHost);
	setText('ExternalPort',record.ExPort);
	setText('ExternalEndPort',record.ExEndPort);
	setText('InternalPort',record.InPort);
	setText('InternalEndPort',record.InEndPort);
    setText('ExternalSrcPort',record.ExSrcPort);
    setText('ExternalSrcEndPort',record.ExSrcEndPort);
	setText('InternalEndPort',record.InEndPort);
	setText('InternalClient',record.InClient);
	setText('PortMappingDescription',record.Description);
	setText('PublicIP',record.ExternalIP);
	setSelect('HostName', '0');
	for (var k = 0; k < LANhostIP.length; k++)
	{
		if (record.InClient == LANhostIP[k])
		{
			setSelect('HostName', k);
			break;
		}
	}
	
	SelectIP = record.InClient;
}


function setControl(index)
{
    var record;

	selctIndex = index;

    if (index == -1)
	{
	    if(PortMapping.length >= 32)
	    {
	        setDisplay('ConfigForm', 0);
			if(GetCfgMode().PCCWHK == "1")
			{
				AlertEx(portmapping_language['bbsp_mappingfullpccw']);
			}
			else
			{
		    	AlertEx(portmapping_language['bbsp_mappingfull']);
			}
			if (PublicIpFlag == 1)
			{
				setDisplay('publicipid', 1);
			}
			else
			{
				setDisplay('publicipid', 0);
			}
		    return;
	    }
		AddFlag = true;
	    record = new stPortMap('','1','','','','','','','','','','','');
        setDisplay('ConfigForm', 1);
        setCtlDisplay(record);
		setDisable('PortMappingInterface', 0);
		setDisplay("typeTR",1);
		getElement("radiosrv")[0].checked="checked";
		setSelect(realConstSrvName,'FIRST_APP');
		setDisable("constsrvName",1);
		setSelect('PortMappingProtocol','TCP');
	}
    else if (index == -2)
    {
        setDisplay('ConfigForm', 0);
	    if (PublicIpFlag == 1)
	    {
	        setDisplay('publicipid', 1);
	    }
		else
		{
		    setDisplay('publicipid', 0);
		}
    }
	else
	{
		AddFlag = false;
	    record = PortMapping[index];
        setDisplay('ConfigForm', 1);
        setCtlDisplay(record);
		setDisable('PortMappingInterface', 1);
		if (PublicIpFlag == 1)
	    {
	        setDisplay('publicipid', 1);
	    }
		else
		{
		    setDisplay('publicipid', 0);
		}
		getElById('PortMappingInterface').title = getElById('PortMappingInterface').options[getElById('PortMappingInterface').selectedIndex].text;
	}

    setDisable('btnApply_ex',0);	
    setDisable('cancelValue',0);
}

function clickRemove() 
{ 
	var notestring;
    if (PortMapping.length == 0)
	{
	    AlertEx(portmapping_language['bbsp_nomapping']);
	    return;
	}

	if (selctIndex == -1)
	{
	    AlertEx(portmapping_language['bbsp_savemapping']);
	    return;
	}
    var rml = getElement('rml');
    var noChooseFlag = true;
    if ( rml.length > 0)
    {
         for (var i = 0; i < rml.length; i++)
         {
             if (rml[i].checked == true)
             {   
                 noChooseFlag = false;
             }
         }
    }
    else if (rml.checked == true)
    {
        noChooseFlag = false;
    }
    if ( noChooseFlag )
    {
        AlertEx(portmapping_language['bbsp_selectmapping']);
        return ;
    }
   
	if (ConfirmEx(portmapping_language['bbsp_confirm2']) == false)
	{
		document.getElementById("DeleteButton").disabled = false;
	    return;
    }
	
	if ( rml.length > 0)
	{
	   for (var i = 0; i < rml.length; i++)
	   {
		   if (rml[i].checked == true)
		   {   
			   CheckDelActionExtPortConflict(0, i);
			   CheckDelActionExtPortConflict(1, i);
			   notestring = ProductConflitNote();
			   if (notestring.length != 0)
			   {
			   	   StartFileOpt();
				   AlertEx(notestring);
			   }
		   }
	   }
	}
	else if (rml.checked == true)
	{
	   CheckDelActionExtPortConflict(0, selctIndex);
	   CheckDelActionExtPortConflict(1, selctIndex);
	   notestring = ProductConflitNote();
	   if (notestring.length != 0)
	   {
	       StartFileOpt();
		   AlertEx(notestring);
	   }
	}    
    setDisable('btnApply_ex',1);	
    setDisable('cancelValue',1);
	removeInst('html/bbsp/portmapping/portmappingold.asp');
} 

function displayBlankValue()
{
    setSelect('PortMappingProtocol','TCP');
    setSelect('PortMappingInterface','');
	setCheck('PortMappingEnable','');
	setText('RemoteHost','');
	setText('ExternalPort','');
	setText('ExternalEndPort','');
	setText('InternalPort','');
	setText('InternalEndPort','');
    setText('ExternalSrcPort','');
    setText('ExternalSrcEndPort','');
    setText('InternalClient','');
	setText('PortMappingDescription','');
	setSelect('HostName',LANhostName[0]);
}

var SelectIP = "";

function setSelectHostName()
{
	for (var k = 0; k < LANhostIP.length; k++)
	{
		if (SelectIP == LANhostIP[k])
		{
			setSelect('HostName', k);
			break;
		}
	}
}

function CancelConfig()
{
    setDisplay("ConfigForm", 0);

    if (selctIndex == -1)
    {
        var tableRow = getElement("portMappingInst");
        
        if (tableRow.rows.length == 1)
        {
            selectLine('record_no');
        }
        else if (tableRow.rows.length == 2)
        {
            addNullInst('Portmapping');
        }
        else
        {
            tableRow.deleteRow(tableRow.rows.length-1);
            selectLine('record_0');
        }
    }
    else
    {
        var record = PortMapping[selctIndex];
        setCtlDisplay(record);
    } 
    
}
</script>
</head>
<body>
<script language="JavaScript" type="text/javascript"> 
	if (appName == "Microsoft Internet Explorer")
	{
		document.write('<body onLoad="LoadFrame();" class="mainbody" scroll="auto">');
	}
	else
	{
		document.write('<body onLoad="LoadFrame();" class="mainbody" >');
    document.write('<DIV style="overflow-x:auto; overflow-y:auto; WIDTH: 100%; HEIGHT: 460px">');
}

</script>
<form id="PortMappingForm"> 
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("portmappingoldtitle", GetDescFormArrayById(portmapping_language, ""), GetDescFormArrayById(portmapping_language, "bbsp_portmapping_title"), false);
</script> 
<div class="title_spread"></div>

  <script language="JavaScript" type="text/javascript">
	writeTabCfgHeader('Portmapping',"100%");
	</script> 
  <table class="tabal_bg" id="portMappingInst" width="100%" cellpadding="0" cellspacing="1"> 
    <tr class="head_title"> 
      <td>&nbsp;</td> 
      <td BindText='bbsp_wanname'></td>  
      <td BindText='bbsp_mapping'></td> 
      <td BindText='bbsp_protocol'></td> 
      <td BindText='bbsp_extport'></td> 
      <td BindText='bbsp_intport'></td> 
      <td BindText='bbsp_inthost'></td> 
      <td BindText='bbsp_enable_status'></td> 
    </tr> 
    <script language="JavaScript" type="text/javascript">
    	var preIndex = 0;
    	if(GetCfgMode().PCCWHK == "1")
    	{
    		
				for (i = 0; i < PortMapping.length; i++)
					{  
					   var ipjudge2=PortMapping[i].InClient.split("."); 	
					   if((ipjudge2[0] == 192) && (ipjudge2[1] == 168) && (ipjudge2[2] == 8) && (ipjudge2[3] > 127 ))
					   {
					   	preIndex++;
					   }
					}
			}
        if (PortMapping.length == 0 || (GetCfgMode().PCCWHK == "1") && (PortMapping.length - preIndex == 0))
        {
            document.write('<tr id="record_no"' 
            	           + ' class="tabal_01 align_center" onclick="selectLine(this.id);">');
            document.write('<td >--</td>');
            document.write('<td >--</td>');
            document.write('<td >--</td>');
            document.write('<td >--</td>');
            document.write('<td >--</td>');
            document.write('<td >--</td>');
            document.write('<td >--</td>');
            document.write('<td >--</td>');
            document.write('</tr>');
        }
        else
        {
            ShowPortMap();
        }
        </script> 
  </table> 
  
  <div id="ConfigForm" style="display:none"> 
  <div class="list_table_spread"></div>
    <table width="100%" class="tabal_bg" cellpadding="0" cellspacing="1"> 
      <tr> 
        <td> <div id="PortMappingDiv"> 
            <table cellpadding="2" cellspacing="1" class="tabal_bg" width="100%"> 
              <tr id="typeTR" style="display: none"> 
                <td class="table_title width_per25" BindText='bbsp_typemh'></td> 
                <td class="table_right width_per25"> <input type="radio" id="radiosrv" name="radiosrv" onclick='radioClick();' checked="true" value="1"> 
                  <script>document.write(portmapping_language['bbsp_custom']);</script></td> 
                <td class="table_title width_per25"> <input type="radio" name="radiosrv" onclick='radioClick();' value="2"> 
                  <script>document.write(portmapping_language['bbsp_application']);</script></td> 
                <td class="table_right width_per25"> 
				<div id="DivServiceList_common" style="display:none">
				<select id='constsrvName' name='constsrvName' size="1" onChange='appSelect(this.value)' disabled style="width: 160px"> 
                    <option value="FIRST_APP"><script>document.write(portmapping_language['bbsp_selectdd']);</script></option> 
                    <option value="Domain Name Server (DNS)"><script>document.write(portmapping_language['bbsp_DomainNameServer']);</script></option> 
                    <option value="FTP Server"><script>document.write(portmapping_language['bbsp_FTPServer']);</script></option> 
                    <option value="IPSEC">IPSEC</option> 
                    <option value="Mail (POP3)"><script>document.write(portmapping_language['bbsp_MailPOP']);</script></option> 
                    <option value="Mail (SMTP)"><script>document.write(portmapping_language['bbsp_MailSMTP']);</script></option> 
                    <option value="PPTP">PPTP</option> 
                    <option value="Real Player 8 Plus"><script>document.write(portmapping_language['bbsp_RealPlayer']);</script></option> 
                    <option value="Secure Shell Server (SSH)"><script>document.write(portmapping_language['bbsp_SecureShellServer']);</script></option> 
                    <option value="Secure Web Server (HTTPS)"><script>document.write(portmapping_language['bbsp_SecureWebServer']);</script></option> 
                    <option value="SNMP">SNMP</option> 
                    <option value="SNMP Trap"><script>document.write(portmapping_language['bbsp_SNMPTrap']);</script></option> 
                    <option value="Telnet Server"><script>document.write(portmapping_language['bbsp_TelnetServer']);</script></option> 
                    <option value="TFTP">TFTP</option> 
                    <option value="Web Server (HTTP)"><script>document.write(portmapping_language['bbsp_WebServerHTTP']);</script></option> 
                  </select>
			  </div>
			  <div id="DivServiceList_tlemex_en" style="display:none">
			  <select id='constsrvName_tlemex_en' name='constsrvName_tlemex_en' size="1" onChange='appSelect_telmex_en(this.value)' disabled style="width: 162px"> 
					<script language="JavaScript" type="text/javascript">
						if ( "SPANISH" == LoginRequestLanguage.toUpperCase() )
						{
							document.write("<option value=\"FIRST_APP\">"+portmapping_language['bbsp_selectdd']+"</option>"); 
							document.write("<option value=\"AIM Talk\">"+portmapping_language['bbsp_AIMTalk']+"</option>");
							document.write("<option value=\"BearShare\">"+portmapping_language['bbsp_BearShare']+"</option>");
							document.write("<option value=\"BitTorrent\">"+portmapping_language['bbsp_BitTorrent']+"</option>");
							document.write("<option value=\"IP Camera 1\">"+portmapping_language['bbsp_CameraIP1']+"</option>");
							document.write("<option value=\"IP Camera 2\">"+portmapping_language['bbsp_CameraIP2']+"</option>");
							document.write("<option value=\"IP Camera 3\">"+portmapping_language['bbsp_CameraIP3']+"</option>");
							document.write("<option value=\"IP Camera 4\">"+portmapping_language['bbsp_CameraIP4']+"</option>");
							document.write("<option value=\"Checkpoint FW1 VPN\">"+portmapping_language['bbsp_CheckpointFW1VPN']+"</option>");
							document.write("<option value=\"DirectX\">"+portmapping_language['bbsp_DirectX']+"</option>");
							document.write("<option value=\"eMule\">"+portmapping_language['bbsp_eMule']+"</option>");
							document.write("<option value=\"Remote Desktop\">"+portmapping_language['bbsp_RemoteDesktop']+"</option>");
							document.write("<option value=\"Apple Remote desktop\">"+portmapping_language['bbsp_AppleRemoteDesktop']+"</option>");
							document.write("<option value=\"Gnutella\">"+portmapping_language['bbsp_Gnutella']+"</option>");
							document.write("<option value=\"ICQ\">"+portmapping_language['bbsp_ICQ']+"</option>");
							document.write("<option value=\"iMesh\">"+portmapping_language['bbsp_iMesh']+"</option>");
							document.write("<option value=\"IPSEC\">"+portmapping_language['bbsp_IPSEC']+"</option>");
							document.write("<option value=\"IRC\">"+portmapping_language['bbsp_IRC']+"</option>");
							document.write("<option value=\"iTunes\">"+portmapping_language['bbsp_iTunes']+"</option>");
							document.write("<option value=\"KaZaa\">"+portmapping_language['bbsp_KaZaa']+"</option>");
							document.write("<option value=\"Napster\">"+portmapping_language['bbsp_Napster']+"</option>");
							document.write("<option value=\"Netmeeting\">"+portmapping_language['bbsp_Netmeeting']+"</option>");
							document.write("<option value=\"OpenVPN\">"+portmapping_language['bbsp_OpenVPN']+"</option>");
							document.write("<option value=\"pcAnywhere\">"+portmapping_language['bbsp_pcAnywhere']+"</option>");
							document.write("<option value=\"PlayStation\">"+portmapping_language['bbsp_PlayStation']+"</option>");
							document.write("<option value=\"PPTP\">"+portmapping_language['bbsp_PPTP']+"</option>");
							document.write("<option value=\"Real Player 8 Plus\">"+portmapping_language['bbsp_RealPlayer']+"</option>");
							document.write("<option value=\"DHCPv6 Server\">"+portmapping_language['bbsp_ServerDHCPv6']+"</option>");
							document.write("<option value=\"DNS Server\">"+portmapping_language['bbsp_ServerDNS']+"</option>");
							document.write("<option value=\"FTP Server\">"+portmapping_language['bbsp_FTPServer']+"</option>");
							document.write("<option value=\"HTTPS Server\">"+portmapping_language['bbsp_ServerHTTPS']+"</option>");
							document.write("<option value=\"IMAP Server\">"+portmapping_language['bbsp_ServerIMAP']+"</option>");
							document.write("<option value=\"Lotus Notes Server\">"+portmapping_language['bbsp_ServerLotusNotes']+"</option>");
							document.write("<option value=\"MAMP Server\">"+portmapping_language['bbsp_ServerMAMP']+"</option>");         
							document.write("<option value=\"MySQL Server\">"+portmapping_language['bbsp_ServerMySQL']+"</option>");
							document.write("<option value=\"NNTP Server\">"+portmapping_language['bbsp_ServerNNTP']+"</option>");
							document.write("<option value=\"POP3 Server\">"+portmapping_language['bbsp_ServerPOP3']+"</option>");
							document.write("<option value=\"Remote support of XP\">"+portmapping_language['bbsp_RemoteSupportXP']+"</option>");
							document.write("<option value=\"Skype\">"+portmapping_language['bbsp_Skype']+"</option>");
							document.write("<option value=\"SMTP Server\">"+portmapping_language['bbsp_ServerSMTP']+"</option>");
							document.write("<option value=\"SNMP\">"+portmapping_language['bbsp_SNMP']+"</option>");
							document.write("<option value=\"SNMP Trap\">"+portmapping_language['bbsp_SNMPTrap']+"</option>");
							document.write("<option value=\"SQL Server\">"+portmapping_language['bbsp_ServerSQL']+"</option>");
							document.write("<option value=\"SSH Server\">"+portmapping_language['bbsp_ServerSSH']+"</option>");
							document.write("<option value=\"Telnet Server\">"+portmapping_language['bbsp_TelnetServer']+"</option>");
							document.write("<option value=\"TFTP\">"+portmapping_language['bbsp_TFTP']+"</option>");
							document.write("<option value=\"Web Server\">"+portmapping_language['bbsp_ServerWEB']+"</option>");
							document.write("<option value=\"VNC\">"+portmapping_language['bbsp_VNC']+"</option>");
							document.write("<option value=\"Vuze\">"+portmapping_language['bbsp_Vuze']+"</option>");
							document.write("<option value=\"Wii\">"+portmapping_language['bbsp_Wii']+"</option>");
							document.write("<option value=\"Windows Live Messenger\">"+portmapping_language['bbsp_WindowsLiveMessenger']+"</option>");
							document.write("<option value=\"WinMX\">"+portmapping_language['bbsp_WinMX']+"</option>");
							document.write("<option value=\"X Windows\">"+portmapping_language['bbsp_XWindows']+"</option>");
							document.write("<option value=\"Xbox Live\">"+portmapping_language['bbsp_XboxLive']+"</option>");
							document.write("<option value=\"Yahoo Messenger\">"+portmapping_language['bbsp_YahooMessenger']+"</option>");
						}
						else
						{
							document.write("<option value=\"FIRST_APP\">"+portmapping_language['bbsp_selectdd']+"</option>"); 
							document.write("<option value=\"AIM Talk\">"+portmapping_language['bbsp_AIMTalk']+"</option>");
							document.write("<option value=\"Apple Remote desktop\">"+portmapping_language['bbsp_AppleRemoteDesktop']+"</option>");
							document.write("<option value=\"BearShare\">"+portmapping_language['bbsp_BearShare']+"</option>");
							document.write("<option value=\"BitTorrent\">"+portmapping_language['bbsp_BitTorrent']+"</option>");
							document.write("<option value=\"Checkpoint FW1 VPN\">"+portmapping_language['bbsp_CheckpointFW1VPN']+"</option>");
							document.write("<option value=\"DHCPv6 Server\">"+portmapping_language['bbsp_ServerDHCPv6']+"</option>");
							document.write("<option value=\"DirectX\">"+portmapping_language['bbsp_DirectX']+"</option>");
							document.write("<option value=\"DNS Server\">"+portmapping_language['bbsp_ServerDNS']+"</option>");
							document.write("<option value=\"eMule\">"+portmapping_language['bbsp_eMule']+"</option>");
							document.write("<option value=\"FTP Server\">"+portmapping_language['bbsp_FTPServer']+"</option>");
							document.write("<option value=\"Gnutella\">"+portmapping_language['bbsp_Gnutella']+"</option>");
							document.write("<option value=\"HTTPS Server\">"+portmapping_language['bbsp_ServerHTTPS']+"</option>");
							document.write("<option value=\"ICQ\">"+portmapping_language['bbsp_ICQ']+"</option>");
							document.write("<option value=\"IMAP Server\">"+portmapping_language['bbsp_ServerIMAP']+"</option>");
							document.write("<option value=\"iMesh\">"+portmapping_language['bbsp_iMesh']+"</option>");
							document.write("<option value=\"IP Camera 1\">"+portmapping_language['bbsp_CameraIP1']+"</option>");
							document.write("<option value=\"IP Camera 2\">"+portmapping_language['bbsp_CameraIP2']+"</option>");
							document.write("<option value=\"IP Camera 3\">"+portmapping_language['bbsp_CameraIP3']+"</option>");
							document.write("<option value=\"IP Camera 4\">"+portmapping_language['bbsp_CameraIP4']+"</option>");
							document.write("<option value=\"IPSEC\">"+portmapping_language['bbsp_IPSEC']+"</option>");
							document.write("<option value=\"IRC\">"+portmapping_language['bbsp_IRC']+"</option>");
							document.write("<option value=\"iTunes\">"+portmapping_language['bbsp_iTunes']+"</option>");
							document.write("<option value=\"KaZaa\">"+portmapping_language['bbsp_KaZaa']+"</option>");
							document.write("<option value=\"Lotus Notes Server\">"+portmapping_language['bbsp_ServerLotusNotes']+"</option>");
							document.write("<option value=\"MAMP Server\">"+portmapping_language['bbsp_ServerMAMP']+"</option>");         
							document.write("<option value=\"MySQL Server\">"+portmapping_language['bbsp_ServerMySQL']+"</option>");
							document.write("<option value=\"Napster\">"+portmapping_language['bbsp_Napster']+"</option>");
							document.write("<option value=\"Netmeeting\">"+portmapping_language['bbsp_Netmeeting']+"</option>");
							document.write("<option value=\"NNTP Server\">"+portmapping_language['bbsp_ServerNNTP']+"</option>");
							document.write("<option value=\"OpenVPN\">"+portmapping_language['bbsp_OpenVPN']+"</option>");
							document.write("<option value=\"pcAnywhere\">"+portmapping_language['bbsp_pcAnywhere']+"</option>");
							document.write("<option value=\"PlayStation\">"+portmapping_language['bbsp_PlayStation']+"</option>");
							document.write("<option value=\"POP3 Server\">"+portmapping_language['bbsp_ServerPOP3']+"</option>");
							document.write("<option value=\"PPTP\">"+portmapping_language['bbsp_PPTP']+"</option>");
							document.write("<option value=\"Real Player 8 Plus\">"+portmapping_language['bbsp_RealPlayer']+"</option>");
							document.write("<option value=\"Remote Desktop\">"+portmapping_language['bbsp_RemoteDesktop']+"</option>");
							document.write("<option value=\"Remote support of XP\">"+portmapping_language['bbsp_RemoteSupportXP']+"</option>");
							document.write("<option value=\"Skype\">"+portmapping_language['bbsp_Skype']+"</option>");
							document.write("<option value=\"SMTP Server\">"+portmapping_language['bbsp_ServerSMTP']+"</option>");
							document.write("<option value=\"SNMP\">"+portmapping_language['bbsp_SNMP']+"</option>");
							document.write("<option value=\"SNMP Trap\">"+portmapping_language['bbsp_SNMPTrap']+"</option>");
							document.write("<option value=\"SQL Server\">"+portmapping_language['bbsp_ServerSQL']+"</option>");
							document.write("<option value=\"SSH Server\">"+portmapping_language['bbsp_ServerSSH']+"</option>");
							document.write("<option value=\"Telnet Server\">"+portmapping_language['bbsp_TelnetServer']+"</option>");
							document.write("<option value=\"TFTP\">"+portmapping_language['bbsp_TFTP']+"</option>");
							document.write("<option value=\"Web Server\">"+portmapping_language['bbsp_ServerWEB']+"</option>");
							document.write("<option value=\"VNC\">"+portmapping_language['bbsp_VNC']+"</option>");
							document.write("<option value=\"Vuze\">"+portmapping_language['bbsp_Vuze']+"</option>");
							document.write("<option value=\"Wii\">"+portmapping_language['bbsp_Wii']+"</option>");
							document.write("<option value=\"Windows Live Messenger\">"+portmapping_language['bbsp_WindowsLiveMessenger']+"</option>");
							document.write("<option value=\"WinMX\">"+portmapping_language['bbsp_WinMX']+"</option>");
							document.write("<option value=\"X Windows\">"+portmapping_language['bbsp_XWindows']+"</option>");
							document.write("<option value=\"Xbox Live\">"+portmapping_language['bbsp_XboxLive']+"</option>");
							document.write("<option value=\"Yahoo Messenger\">"+portmapping_language['bbsp_YahooMessenger']+"</option>");
						}
					</script>    
			  </select>
			  </div>
			  <div id="DivServiceList_tlemex_sp" style="display:none">
			   <select id='constsrvName_tlemex_sp' name='constsrvName_tlemex_sp' size="1" onChange='appSelect_telmex_sp(this.value)' disabled style="width: 162px"> 
					<option value="FIRST_APP"><script>document.write(portmapping_language['bbsp_selectdd']);</script></option> 
					<option value="AIM Talk">AIM Talk</option> 
                    <option value="Apple Remote desktop"><script>document.write(portmapping_language['bbsp_AppleRemoteDesktop']);</script></option> 
					<option value="Assistance remote XP"><script>document.write(portmapping_language['bbsp_AssistanceRemoteXP']);</script></option>
					<option value="BearShare">BearShare</option>
					<option value="BitTorrent">BitTorrent</option>
					<option value="Camera IP 1"><script>document.write(portmapping_language['bbsp_CameraIP1']);</script></option>
					<option value="Camera IP 2"><script>document.write(portmapping_language['bbsp_CameraIP2']);</script></option>
					<option value="Camera IP 3"><script>document.write(portmapping_language['bbsp_CameraIP3']);</script></option>
					<option value="Camera IP 4"><script>document.write(portmapping_language['bbsp_CameraIP4']);</script></option>
					<option value="Checkpoint FW1 VPN">Checkpoint FW1 VPN</option>
					<option value="DirectX">DirectX</option>
					<option value="eMule">eMule</option>
					<option value="Escritorio Remote">Escritorio Remoto</option>
					<option value="Gnutella">Gnutella</option>
					<option value="ICQ">ICQ</option>
					<option value="iMesh">iMesh</option>
					<option value="IPSEC">IPSEC</option>
					<option value="IRC">IRC</option>
					<option value="iTunes">iTunes</option>
					<option value="KaZaa">KaZaa</option>
					<option value="SNMP Trap"><script>document.write(portmapping_language['bbsp_SNMPTrap']);</script></option>
					<option value="Napster">Napster</option>
					<option value="Netmeeting">Netmeeting</option>
					<option value="OpenVPN">OpenVPN</option>
					<option value="pcAnywhere">pcAnywhere</option>
					<option value="PlayStation">PlayStation</option>
					<option value="PPTP">PPTP</option>
					<option value="Real Player 8 Plus">Real Player 8 Plus</option>
					<option value="Server DHCPv6"><script>document.write(portmapping_language['bbsp_ServerDHCPv6']);</script></option>
					<option value="Server DNS"><script>document.write(portmapping_language['bbsp_ServerDNS']);</script></option>
					<option value="FTP Server"><script>document.write(portmapping_language['bbsp_FTPServer']);</script></option>
					<option value="Server HTTPS"><script>document.write(portmapping_language['bbsp_ServerHTTPS']);</script></option>
					<option value="Server IMAP"><script>document.write(portmapping_language['bbsp_ServerIMAP']);</script></option>
					<option value="Server Lotus Notes"><script>document.write(portmapping_language['bbsp_ServerLotusNotes']);</script></option>
					<option value="Server MAMP"><script>document.write(portmapping_language['bbsp_ServerMAMP']);</script></option>
					<option value="Server MySQL"><script>document.write(portmapping_language['bbsp_ServerMySQL']);</script></option>
					<option value="Server NNTP"><script>document.write(portmapping_language['bbsp_ServerNNTP']);</script></option>
					<option value="Server POP3"><script>document.write(portmapping_language['bbsp_ServerPOP3']);</script></option>
					<option value="Server SQL"><script>document.write(portmapping_language['bbsp_ServerSQL']);</script></option>
					<option value="Server SSH"><script>document.write(portmapping_language['bbsp_ServerSSH']);</script></option>
					<option value="Server SMTP"><script>document.write(portmapping_language['bbsp_ServerSMTP']);</script></option>
					<option value="Telnet Server"><script>document.write(portmapping_language['bbsp_TelnetServer']);</script></option>
					<option value="TFTP"><script>document.write(portmapping_language['bbsp_TFTP']);</script></option>
					<option value="Server WEB"><script>document.write(portmapping_language['bbsp_ServerWEB']);</script></option>
					<option value="Skype">Skype</option>
					<option value="SNMP">SNMP</option>
					<option value="VNC">VNC</option>
					<option value="Vuze">Vuze</option>
					<option value="Wii">Wii</option>
					<option value="Windows Live Messenger">Windows Live Messenger</option>
					<option value="WinMX">WinMX</option>
					<option value="X Windows">X Windows</option>
					<option value="Xbox Live">Xbox Live</option>
					<option value="Yahoo Messenger">Yahoo Messenger</option>
			   </select>
			  </div>
			  </td> 
              </tr>
              <tr > 
                <td class="table_title width_per25" style="display" BindText='bbsp_enablemappingmh'></td> 
                <td class="table_right width_per25"> <input type='checkbox' id='PortMappingEnable' name='PortMappingEnable' > </td> 
                <td class="table_title width_per25" ></td> 
                <td class="table_right width_per25"></td> 
              </tr>
              <tr> 
                <td class="table_title width_per25" BindText='bbsp_wannamemh'></td> 
                <td class="table_right width_per25" id="PortMappingInterfacetitle"> <select id="PortMappingInterface" name='PortMappingInterface' size="1" onChange="ShowPortMapping()" 
                                    style="width: 133px"> 
                    <script language="JavaScript" type="text/javascript">
                    					var HU='<%HW_WEB_GetFeatureSupport(BBSP_FT_HU);%>';
                                        for (i = 0; i < WanInfo.length; i++)
                        				{
                        				    if (WanInfo[i].ServiceList != 'TR069'
												&& WanInfo[i].ServiceList != 'VOIP'
												&& WanInfo[i].ServiceList != 'TR069_VOIP'
                        					    && WanInfo[i].Mode == 'IP_Routed'
												&& WanInfo[i].IPv4Enable == '1')
                        				    {
												if((HU==1) && (curUserType != '0') && ((WanInfo[i].ServiceList == 'IPTV') || (WanInfo[i].ServiceList == 'OTHER')))
												{
													continue;
												}
												else
												{
													document.write('<option value=' + WanInfo[i].domain 
																   + ' id="wan_' + i + '" title="' + MakeWanName1(WanInfo[i]) 
																   + '">'
																   + MakeWanName1(WanInfo[i]) + '</option>');
											    }
                        					}				   
                        				}
                        				var optionInterface=getElById('PortMappingInterface');
										if( optionInterface.options.length > 0 && (optionInterface.selectedIndex >= 0) )
										{
											getElById("PortMappingInterfacetitle").title = optionInterface.options[optionInterface.selectedIndex].text;
										}
                        			</script> 
                  </select> </td>
				 
                <td class="table_title width_per25" BindText='bbsp_protocolmh'></td> 
                <td class="table_right width_per25"> <select id='PortMappingProtocol' name='PortMappingProtocol' size="1" style="width: 133px"> 
                    <option value="TCP" selected>TCP</option> 
                    <option value="UDP">UDP</option> 
                    <option value="TCP/UDP">TCP/UDP</option> 
                  </select> </td> 
              </tr> 
			  <tr id="publicipid" style="display:none">
                <td class="table_title width_per25" BindText='bbsp_publicip'></td> 
                <td class="table_right width_per25" colspan="3" > <input type='text' id='PublicIP' class="restrict_dir_ltr" name='PublicIP' size='20' maxlength='256'>
				<span class="gray"><script>document.write(portmapping_language['bbsp_publicnote']);</script></span></td>
				<script LANGUAGE="JavaScript"> 
				 getElById("publicipid").title = portmapping_language['bbsp_public_prompt'];
				</script>
              </td>
              </tr>  
              <tr> 
                <td class="table_title width_per25" BindText='bbsp_extstartportmh'></td> 
                <td class="table_right width_per25"> <input type='text' id='ExternalPort' name='ExternalPort' size='20' maxlength='5'> 
                  <strong style="color:#FF0033">*</strong> </td> 
                <td class="table_title width_per25" BindText='bbsp_extendportmh'></td> 
                <td class="table_right width_per25"> <input type='text' id='ExternalEndPort' name='ExternalEndPort' size='20' maxlength='5'> 
                  <strong style="color:#FF0033">*</strong> </td> 
              </tr> 
              <tr> 
                <td class="table_title width_per25" BindText='bbsp_intstartportmh'></td> 
                <td class="table_right width_per25"> <input type='text' id='InternalPort' name='InternalPort' size='20' maxlength='5'> 
                  <strong style="color:#FF0033">*</strong> </td> 
                <td class="table_title width_per25" BindText='bbsp_intendportmh'></td> 
                <td class="table_right width_per25"> <input type='text' id='InternalEndPort' name='InternalEndPort' size='20' maxlength='5'> </td> 
              </tr> 
              <tr > 
                <td class="table_title width_per25" BindText='bbsp_extsrcstartportmh'></td> 
                <td class="table_right width_per25"> <input type='text' id='ExternalSrcPort' name='ExternalSrcPort' size='20' maxlength='5'> </td> 
                <td class="table_title width_per25" BindText='bbsp_extsrcendportmh'></td> 
                <td class="table_right width_per25"> <input type='text' id='ExternalSrcEndPort' name='ExternalSrcEndPort' size='20' maxlength='5'> </td> 
              </tr> 
              <tr > 
                <td class="table_title width_per25" BindText='bbsp_mappingmh'></td> 
                <td class="table_right width_per25"> <input type='text' id='PortMappingDescription' name='PortMappingDescription' size='20' maxlength='31'>
					<script>
						if (true == TELMEX)
						{
						    document.write('<strong style="color:#FF0033">*</strong>');
						}
					</script>
                </td> 
                <td class="table_title width_per25" BindText='bbsp_extsrcipmh'> </td> 
                <td class="table_right width_per25"> <input id="RemoteHost" type='text' name='RemoteHost' size='20' maxlength='15'> </td> 
              </tr> 
              <tr>
              	<td class="table_title width_per25" BindText='bbsp_inthostmh'></td> 
                <td class="table_right width_75p" colspan="3" > <input type='text' id='InternalClient' name='InternalClient' size='20' maxlength='32'> 
                  <strong style="color:#FF0033" id="portmapselectinfotable">*</strong>
				          <script language="JavaScript" type="text/javascript">
				          function createportmapselectinfo()
                    	  {
                            var output = '<select name=' + "'HostName'" + ' id=' + "'HostName'" + ' size="1" onChange=' + "'HostNameChange()'" + ' class="width_123px">';
                            for (i = 0; i < LANhostName.length; i++)
                            {
                                output = output + '<option value="' + i + '" title="'+LANhostName[i]+'">' + LANhostName[i] + '</option>';			   
                            } 
                            output = output + '</select>'; 
					        $("#portmapselectinfotable").after(output);
                	     }  
				          </script> 
                </td> 
              </tr>
            </table> 
          </div></td> 
      </tr> 
    </table> 
    <table width="100%" border="0" cellspacing="0" cellpadding="0" > 
      <tr> 
        <td class="width_per25"></td> 
        <td class="width_per25"></td> 
        <td class="width_per25"></td> 
        <td class="align_right pad_top5p" > 
		    <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
			<button name="btnApply_ex" id="btnApply_ex" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="Submit(3);" enable=true ><script>document.write(portmapping_language['bbsp_app']);</script></button>
          	<button name="cancelValue" id="cancelValue" type="button" class="CancleButtonCss buttonwidth_100px" style="padding-left:4px;" onClick="CancelConfig();"><script>document.write(portmapping_language['bbsp_cancel']);</script></button> </td> 
      </tr> 
    </table> 
  </div> 
  <script language="JavaScript" type="text/javascript">
    writeTabTail();
	GetLanUserDevInfo(function(para)
	{
		setlanhostnameip(para);
		createportmapselectinfo();
		setSelectHostName();
	});
  </script>
</form> 
<script language="JavaScript" type="text/javascript"> 
	if (appName != "Microsoft Internet Explorer")
	{
		document.write('</DIV>');
}
</script>
</body>
</html>
