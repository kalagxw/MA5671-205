<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="javascript" src="../../bbsp/common/managemode.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list.asp"></script>
<title>Portmapping</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var LoginRequestLanguage = '<%HW_WEB_GetLoginRequestLangue();%>';
var WanIndex = -1;
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
var appName = navigator.appName;
var realConstSrvName='constsrvName';
var TELMEX = false; 
if (GetCfgMode().TELMEX == "1")
{
	TELMEX = true;
	realConstSrvName='constsrvName_tlemex_en';

}
else
{
	TELMEX = false;
	realConstSrvName='constsrvName';
}

var numpara = "";
if( window.location.href.indexOf("?") > 0)
{
    numpara = window.location.href.split("?")[1]; 
}

var LANhostIP = new Array();
var LANhostName = new Array();

LANhostIP[0] = "";
LANhostName[0] = portmapping_language['hostName_select'];

function USERDevice(Domain,IpAddr,HostName)
{
	this.Domain 	= Domain;
	this.IpAddr	    = IpAddr;
	this.HostName	= HostName;
}

function dhcpcnst(domain,dhcpStart,dhcpEnd,LeaseTime,Enable,option60,SlaDNS,ipaddr,subnetMask)
{
    this.domain 	= domain;
    this.dhcpStart 	= dhcpStart;
	this.dhcpEnd 	= dhcpEnd;
	this.LeaseTime 	= LeaseTime;
	this.Enable 	= Enable;  
	this.option60 	= option60;
	if(SlaDNS == "")
	{
		this.SlaPriDNS	= "";  
		this.SlaSecDNS  = "";
	}
	else
	{
		var SlaDnss 	= SlaDNS.split(',');
		this.SlaPriDNS	= SlaDnss[0];  
		this.SlaSecDNS  = SlaDnss[1];
		
		if (SlaDnss.length <=1)
		{
		    this.SlaSecDNS = "";
		}
	}
}

function dhcpmainst(domain,enable,startip,endip,leasetime,l2relayenable,HGWstartip,HGWendip,STBstartip,STBendip,Camerastartip,Cameraendip,Computerstartip,Computerendip,Phonestartip,Phoneendip,MainDNS)
{
	this.domain 	= domain;
	this.enable		= enable;
	this.startip	= startip;
	this.endip		= endip;
	this.leasetime  = leasetime;
	this.l2relayenable = l2relayenable;
	this.HGWstartip = HGWstartip;
	this.HGWendtip = HGWendip;
	this.STBstartip = STBstartip;
	this.STBendtip = STBendip;	
	this.Camerastartip = Camerastartip;
	this.Cameraendtip = Cameraendip;
	this.Computerstartip = Computerstartip;
	this.Computerendtip = Computerendip;		
	this.Phonestartip = Phonestartip;
	this.Phoneendtip = Phoneendip;	
	if(MainDNS == "")
	{
		this.MainPriDNS	= "";  
		this.MainSecDNS = "";
	}
	else
	{
	var MainDnss 	= MainDNS.split(',');
	this.MainPriDNS	= MainDnss[0];  
	this.MainSecDNS  = MainDnss[1];
	if (MainDnss.length <=1)
	{
	    this.MainSecDNS = "";
	}
	}
}

function stipaddr(domain,enable,ipaddr,subnetmask)
{
	this.domain		= domain;
	this.enable		= enable;
	this.ipaddr		= ipaddr;
	this.subnetmask	= subnetmask;	
}

var LanIpInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},Enable|IPInterfaceIPAddress|IPInterfaceSubnetMask,stipaddr);%>;
var SlaveDhcpInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DHCPSLVSERVER,StartIP|EndIP|LeaseTime|DHCPEnable|Option60|DNSList,dhcpcnst);%>;  

var MainDhcpRange = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement,DHCPServerEnable|MinAddress|MaxAddress|DHCPLeaseTime|X_HW_DHCPL2RelayEnable|X_HW_HGWStart|X_HW_HGWEnd|X_HW_STBStart|X_HW_STBEnd|X_HW_CameraStart|X_HW_CameraEnd|X_HW_ComputerStart|X_HW_ComputerEnd|X_HW_PhoneStart|X_HW_PhoneEnd|X_HW_DNSList  ,dhcpmainst);%>;  

var UserDevices = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecialGetUserDevInfo,InternetGatewayDevice.LANDevice.1.X_HW_UserDev.{i},IpAddr|HostName,USERDevice);%>;
var UserDevicesnum = UserDevices.length - 1;

for (var i = 0, j = 1; i < UserDevicesnum; i++)
{
	if ('' != UserDevices[i].HostName)
	{
  	LANhostName[j] = UserDevices[i].HostName;
  	LANhostIP[j] = UserDevices[i].IpAddr;
  	j++;
  }
  
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
	
	return true;
}

var WanInfo = GetWanListByFilter(filterWan);

function stPortMap(domain,ProtMapEnabled,Protocol,RemoteHost,ExPort,ExEndPort,InPort,InEndPort,InClient,ExSrcPort,ExSrcEndPort,Description)
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
	 var index = domain.lastIndexOf('PortMapping');
	 this.Interface = domain.substr(0,index - 1);	 
}

var WanIPPortMapping = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i}.PortMapping.{i},PortMappingEnabled|PortMappingProtocol|RemoteHost|ExternalPort|ExternalPortEndRange|InternalPort|X_HW_InternalEndPort|InternalClient|X_HW_ExternalSrcPort|X_HW_ExternalSrcEndPort|PortMappingDescription,stPortMap);%>;
var WanPPPPortMapping = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i}.PortMapping.{i},PortMappingEnabled|PortMappingProtocol|RemoteHost|ExternalPort|ExternalPortEndRange|InternalPort|X_HW_InternalEndPort|InternalClient|X_HW_ExternalSrcPort|X_HW_ExternalSrcEndPort|PortMappingDescription,stPortMap);%>; 
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
}

var PortMapping = new Array();
var Idx = 0;
for (i = 0; i < WanIPPortMapping.length-1; i++)
{
	if(WanIPPortMapping[i].InClient=="")
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

var AddFlag = true;

var selctIndex = -1;
function AddSubmitParam(SubmitForm,type)
{
	var Interface = getSelectVal('WANselect_select');
	var url;
 
	SubmitForm.addParameter('x.PortMappingProtocol',getValue('PortMappingProtocol_select'));
	SubmitForm.addParameter('x.InternalPort',getValue('InternalPort_text'));
	SubmitForm.addParameter('x.ExternalPort',getValue('ExternalPort_text'));
	SubmitForm.addParameter('x.ExternalPortEndRange',getValue('ExternalPort_text'));
	SubmitForm.addParameter('x.InternalClient',getValue('InternalClient_text'));
	SubmitForm.addParameter('x.PortMappingEnabled',1);
	
	if ( AddFlag == false )
	{
		SubmitForm.addParameter('x.X_HW_ExternalSrcPort',0);
		SubmitForm.addParameter('x.X_HW_ExternalSrcEndPort',0);
		SubmitForm.addParameter('x.RemoteHost','');
	} 
  
	if ( AddFlag == true )
	{
		url = 'add.cgi?x=' + Interface + '.PortMapping' 
							 +'&RequestFile=html/bbsp/portmapping/portmappingolde8c.asp';
	}
	else
	{
		url = 'set.cgi?x=' + PortMapping[selctIndex].domain
							 +'&RequestFile=html/bbsp/portmapping/portmappingolde8c.asp';
	}
	
	SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
	SubmitForm.setAction(url);
    setDisable('btnApply_ex',1);	
    setDisable('cancelValue',1);
	setDisable('Add_button',1);
	setDisable('Del_button',1);
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
	var selectObj = getElement('WANselect_select');
	var index = 0;
	var idx = 0;

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

	if (getElement('WANselect_select').length == 0)
	{
	    AlertEx(portmapping_language['bbsp_wanconinvalid']);
	    return false;	
	}	

    with (getElById('PortMappingForm')) 
    {      
        var i=0;
		for(i=0;i<PortMapping.length;i++)
		{
			if(MakeWanName1(WanInfo[idx])!=PortMapping[i].Interface||(getValue('PortMappingProtocol_select').indexOf(PortMapping[i].Protocol)==-1&&PortMapping[i].Protocol.indexOf(getValue('PortMappingProtocol_select'))==-1))
			{
				continue;
			}
			
			if((getValue('ExternalPort_text') == '0' || PortMapping[i].ExPort == '0') && AddFlag == true)
			{                   
				AlertEx(portmapping_language['bbsp_extportinvalid']);
				return false;
			} 
			
			if(parseInt(getValue('ExternalPort_text'),10)==parseInt(PortMapping[i].ExPort,10))
			{
				if(i!=selctIndex)
				{
					AlertEx(portmapping_language['bbsp_extportinvalid']);
					return false;
				}
			}
		}
        if (getValue('ExternalPort_text') == "")
        {
            AlertEx(portmapping_language['bbsp_extportisreq']);
            return false;
        }

        if (getValue('InternalPort_text') == "")
        {
            AlertEx(portmapping_language['bbsp_intportisreq']);
            return false;
        }
		else if (getValue('InternalPort_text').charAt(0) == '0')
		{
		    AlertEx(portmapping_language['bbsp_intport1'] +  getValue('InternalPort_text') + portmapping_language['bbsp_invalid']);
            return false;
		}

        if (getValue('InternalClient_text') == "")
        {
            AlertEx(portmapping_language['bbsp_hostipisreq1']);
            return false;
        }  

        if (isAbcIpAddress(getValue('InternalClient_text')) == false)
        {
            AlertEx(portmapping_language['bbsp_hostipinvalid1']);
            return false;
        }

        if (isValidPort2(getValue('ExternalPort_text')) == false )
        {
            AlertEx(portmapping_language['bbsp_extport1']+getValue('ExternalPort_text')+portmapping_language['bbsp_invalid'] );
            return false;
        }

        if (isValidPort(getValue('InternalPort_text')) == false )
        {
            AlertEx(portmapping_language['bbsp_intport1']+getValue('InternalPort_text')+portmapping_language['bbsp_invalid'] );
            return false;
        }
		
		var ExtPort=0;
		var ExtEndPort=0;
		ExtPort = parseInt(getValue("ExternalPort_text"),10);
		if ((7070 <= ExtPort) && (7079 >= ExtPort))
		{
			if ( ConfirmEx(portmapping_language['bbsp_confirm1']) == false )
			{
				return false;
			}
		}
    }
	
	var InternalHost = getValue('InternalClient_text');
	var Ipjudge1 = getValue('InternalClient_text').split(".");

    if ( parseInt(Ipjudge1[3],10) == 0 )
    {
		AlertEx(portmapping_language['bbsp_hostipoutran1']);
		return false;
    }
	
    return true;
}

function LoadFrame()
{
	setDisplay('Newbutton',0);
	setDisplay('DeleteButton',0);

    if (PortMapping.length > 0)
    {
 	    selectLine('record_0');
        setDisplay('ConfigForm',1);
    }	
    else
    {	
 	    selectLine('record_no');
        setDisplay('ConfigForm',0);
    }

	if(isValidIpAddress(numpara) == true)
	{
		clickAdd('Portmapping');
		setText('InternalClient_text', numpara);
	}
	loadlanguage();
}

function record_click(id)
{
	selectLine(id);
	setDisplay("typeTR",0);
}

function getVirtualServerId(tableID,colID)
{
	var VirtualServerListId = "VirtualServer_" + tableID + "_" + colID + "_table";
	return VirtualServerListId;
}

function ShowPortMap()
{
    var html = '' ;
    var i = 0;
	for (i = 0; i < PortMapping.length; i++)
	{  
		var tableID = i + 2;
		html += '<TR id=record_' + i 
				+' class="tabal_center01" onclick="record_click(this.id);">';
		html +=  '<TD id=' + getVirtualServerId(tableID,1) + '>' + PortMapping[i].Interface + '</TD>';
		html +=  '<TD id=' + getVirtualServerId(tableID,2) + '>' + PortMapping[i].ExPort + '</TD>';
		html +=  '<TD id=' + getVirtualServerId(tableID,3) + '>' + (PortMapping[i].Protocol).toUpperCase() + '</TD>';
		html +=  '<TD id=' + getVirtualServerId(tableID,4) + '>' + PortMapping[i].InClient + '</TD>';
		html +=  '<TD id=' + getVirtualServerId(tableID,5) + '>' + PortMapping[i].InPort + '</TD>';
		html += '<TD ><input id=' + getVirtualServerId(tableID,6) + ' + type="checkbox" name=' + getVirtualServerId(tableID,6) + ' + value="True"></TD>';
		html += '</TR>';	
	}
	document.write(html);
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
    if (getValue('InternalPort_text') == 21)
    {
        setDisable('InternalPort_text',1);
    }
    else
    {
        setDisable('InternalPort_text',0);
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
    			  case '1':
       			      setSelect('PortMappingProtocol_select','TCP');
       			      break;
    			  case '2':
    			      setSelect('PortMappingProtocol_select','UDP');
    			      break;
			  }

              getElement('RemoteHost').value = "";
              getElement('ExternalPort_text').value = v[i].e[0].eStart;
			  getElement('ExternalEndPort').value = v[i].e[0].eEnd;
              getElement('InternalPort_text').value = v[i].e[0].iStart;
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
	   setDisable('InternalPort_text',0);
	   setDisable('InternalEndPort',0);
	   setDisable('ExternalPort_text',0);
	   setDisable('ExternalEndPort',0);
	   setDisable('PortMappingProtocol_select',0);
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

	setSelect('WANselect_select',Interface);
	setSelect('PortMappingProtocol_select',(record.Protocol).toUpperCase());

	setCheck('PortMappingEnable',record.ProtMapEnabled);
	setText('RemoteHost',record.RemoteHost);
	setText('ExternalPort_text',record.ExPort);
	setText('ExternalEndPort',record.ExEndPort);
	setText('InternalPort_text',record.InPort);
	setText('InternalEndPort',record.InEndPort);
    setText('ExternalSrcPort',record.ExSrcPort);
    setText('ExternalSrcEndPort',record.ExSrcEndPort);
	setText('InternalEndPort',record.InEndPort);
	setText('InternalClient_text',record.InClient);
	setText('PortMappingDescription',record.Description);
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
		    return;
	    }
		AddFlag = true;
	    record = new stPortMap('','1','','','','','','','','','','');
        setDisplay('ConfigForm', 1);
        setCtlDisplay(record);
		setDisable('WANselect_select', 0);
		setDisplay("typeTR",1);
		setSelect(realConstSrvName,'FIRST_APP');
		setDisable("constsrvName",1);
		setSelect('PortMappingProtocol','TCP');
	}
    else if (index == -2)
    {
        setDisplay('ConfigForm', 0);
    }
	else
	{
		AddFlag = false;
	    record = PortMapping[index];
        setDisplay('ConfigForm', 1);
        setCtlDisplay(record);
		setDisable('WANselect_select', 1);
		getElById('WANselect_select').title = getElById('WANselect_select').options[getElById('WANselect_select').selectedIndex].text;
	}

    setDisable('btnApply_ex',0);	
    setDisable('cancelValue',0);
	setDisable('Add_button',0);
	setDisable('Del_button',0);
}

function onClickAdd()
{
	clickAdd('Portmapping');
}

function onClickDel()
{
	var noChooseFlag = true;
	var SubmitForm = new webSubmitForm();	
	
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

	for (var i = 0; i < PortMapping.length; i++)
	{
		var tableID = i + 2;
		var rmId = getVirtualServerId(tableID,6);
		var rm = getElement(rmId);
		if (rm.checked == true)
		{
			noChooseFlag = false;
			SubmitForm.addParameter(PortMapping[i].domain,'');
		}
	}
	if ( noChooseFlag )
    {
        AlertEx(portmapping_language['bbsp_selectmapping']);
        return ;
    }
    if (ConfirmEx(portmapping_language['bbsp_confirm2']) == false)
	{
		setDisable('Del_button',0);	
	    return;
    }
	
	SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
    setDisable('btnApply_ex',1);	
    setDisable('cancelValue',1);
	setDisable('Add_button',1);	
    setDisable('Del_button',1);
	SubmitForm.setAction('del.cgi?RequestFile=html/bbsp/portmapping/portmappingolde8c.asp');   
	SubmitForm.submit();
	DisableRepeatSubmit();
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
  <table width="100%"  border="0" cellpadding="0" cellspacing="0" id="tabTest" > 
	<label id="VirtualServer_lable" class="align_left title_common" width="100%"><script>document.write(portmapping_language['bbsp_portmapping_title1']);</script></label> 
    <tr> 
      <td class="height10p"></td> 
    </tr> 
  </table> 
  <script language="JavaScript" type="text/javascript">
	writeTabCfgHeader('Portmapping',"100%");
  </script>
  <table class="tabal_bg" id="portMappingInst" width="100%" cellpadding="0" cellspacing="1"> 
    <tr class="head_title"> 
	  <td id="VirtualServer_1_1_table" BindText='bbsp_wanname1'></td> 
	  <td id="VirtualServer_1_2_table" BindText='bbsp_extport'></td> 
      <td id="VirtualServer_1_3_table" BindText='bbsp_protocol'></td> 
      <td id="VirtualServer_1_4_table" BindText='bbsp_inthost1'></td> 
      <td id="VirtualServer_1_5_table" BindText='bbsp_intport'></td> 
      <td id="VirtualServer_1_6_table" BindText='bbsp_select'></td> 
    </tr> 
    <script language="JavaScript" type="text/javascript">
        if (PortMapping.length == 0)
        {
            document.write('<tr id="record_no"' 
            	           + ' class="tabal_01 align_center" onclick="selectLine(this.id);">');
            document.write('<td id=' + getVirtualServerId(2,1) + '>--</td>');
            document.write('<td id=' + getVirtualServerId(2,2) + '>--</td>');
            document.write('<td id=' + getVirtualServerId(2,3) + '>--</td>');
            document.write('<td id=' + getVirtualServerId(2,4) + '>--</td>');
            document.write('<td id=' + getVirtualServerId(2,5) + '>--</td>');
			document.write('<td id=' + getVirtualServerId(2,6) + '>--</td>');
            document.write('</tr>');
        }
        else
        {
            ShowPortMap();
        }
        </script> 
  </table> 
	<table class="table_button" id="cfg_table" width="100%"> 
      <tr align="right">
        <td > 
		  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
		  <button id="Add_button" name="Add_button" type="button" class="submit" onClick="onClickAdd();"><script>document.write(portmapping_language['bbsp_add']);</script></button>
		  <button id="Del_button" name="Del_button" type="button" class="submit" onClick="onClickDel();"><script>document.write(portmapping_language['bbsp_del']);</script></button>
		</td> 
      </tr>   
    </table>

  <div id="ConfigForm"> 
   <table cellpadding="0" cellspacing="0" border="0" id="cfg_table" width="100%"> 
		<tr> 
			<td class="table_title width_per25"  BindText='bbsp_selectwan'></td> 
			<td class="table_right width_per75" id="PortMappingInterfacetitle"> <select id="WANselect_select" name='WANselect_select' size="1" >  
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
						if((HU==1) && (curUserType != sysUserType) && ((WanInfo[i].ServiceList == 'IPTV') || (WanInfo[i].ServiceList == 'OTHER')))
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
				var optionInterface=getElById('WANselect_select');
				if( optionInterface.options.length > 0 && (optionInterface.selectedIndex >= 0) )
				{
					getElById("PortMappingInterfacetitle").title = optionInterface.options[optionInterface.selectedIndex].text;
				}
			</script> 
		  </select> </td> 
		</tr>
           
		   <tr> 
			<td class="table_title width_per25" BindText='bbsp_exttport'></td> 
			<td class="table_right width_per75"> <input type='text' id='ExternalPort_text' name='ExternalPort_text' size='20' maxlength='5'> 
			  <strong style="color:#FF0033">*</strong> </td> 
		  </tr> 
		   
		  <tr> 
			<td class="table_title width_per25" BindText='bbsp_protocol'></td> 
			<td class="table_right width_per75"> <select size="1" id='PortMappingProtocol_select' name='PortMappingProtocol_select'> 
				<option value="TCP" selected>TCP</option> 
				<option value="UDP">UDP</option> 
			  </select> </td> 
		  </tr> 
		 
		  <tr>
			<td class="table_title width_per25" BindText='bbsp_inthost2'></td> 
			<td class="table_right width_per75" colspan="3" > <input type='text' id='InternalClient_text' name='InternalClient_text' size='20' maxlength='32'> 
			  <strong style="color:#FF0033">*</strong>
			</td> 
		  </tr>
		  
         <tr> 
			<td class="table_title width_per25" BindText='bbsp_intport'></td> 
			<td class="table_right width_per75"> <input type='text' id='InternalPort_text' name='InternalPort_text' size='20' maxlength='5'> 
			  <strong style="color:#FF0033">*</strong> </td> 
		  </tr> 
    </table> 
    <table width="100%" border="0" class="table_button"> 
      <tr align="right">
        <td class="width_per25"></td> 
        <td > 
			<button name="btnApply_ex" id="btnApply_ex" type="button" class="submit" onClick="Submit(3);" enable=true ><script>document.write(portmapping_language['bbsp_app']);</script></button>
          	<button name="cancelValue" id="cancelValue" type="button" class="submit" style="padding-left:4px;" onClick="CancelConfig();"><script>document.write(portmapping_language['bbsp_cancel']);</script></button> </td> 
      </tr> 
    </table> 
  </div> 
</form> 
<script language="JavaScript" type="text/javascript"> 
	if (appName != "Microsoft Internet Explorer")
	{
		document.write('</DIV>');
	}
</script>
</body>
</html>
