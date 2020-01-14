<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<title>DMZ</title>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/lanuserinfo.asp"></script>
<style>
.Select
{
	width:260px;  
}
.TextBox
{
	width:254px;  
}
.Select_2
{
	width:133px;
}
</style>

<script language="JavaScript" type="text/javascript">
var WanIndex = -1;
var DmzAddFlag = true;
var appName = navigator.appName;
var curUserType='<%HW_WEB_GetUserType();%>';
var sysUserType = '0';
var WebInnerPort = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.Services.X_HW_WebServerConfig.ListenInnerPort);%>';
var WebOuterPort = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.Services.X_HW_WebServerConfig.ListenOuterPort);%>';
var telnetInnerPort = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.UserInterface.X_HW_CLITelnetAccess.TelnetPort);%>';
var telnetOuterPort = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.UserInterface.X_HW_CLITelnetAccess.OutTelnetPort);%>';
var CfgModeWord ='<%HW_WEB_GetCfgMode();%>'; 

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
		b.innerHTML = dmz_language[b.getAttribute("BindText")];
	}
}

function stDMZInfo(domain,DMZEnable,DMZHostIPAddress, flag)
{
	this.domain = domain;
	this.DMZEnable = DMZEnable;
	this.DMZHostIPAddress = DMZHostIPAddress;
	this.flag = 0;
}


var LANhostIP = new Array();
var LANhostName = new Array();

LANhostIP[0] = "";
LANhostName[0] = dmz_language['bbsp_hostName_select'];

var SelectIP = "";

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

function setSelectHostName()
{
	setSelect('DMZHostName', '0');
	for (var k = 0; k < LANhostIP.length; k++)
	{
		if (SelectIP == LANhostIP[k])
		{
			setSelect('DMZHostName', k);
			break;
		}
	}
}

function StartFileOpt()
{
    XmlHttpSendAspFlieWithoutResponse("/asp/StartFileLoad.asp");
}

function DMZHostNameChange()
{
	setText('DMZHostIPAddress',LANhostIP[getSelectVal('DMZHostName')]);
}


function stWanInfo(domain,Name,Enable,NATEnabled,ConnectionType,ServiceList, ExServiceList, vlanid,connectionstatus,Tr069Flag,MacId,IPv4Enable)
{
	this.domain = domain; 	
	this.Name = Name;
	this.Enable = Enable;
	this.NATEnabled = NATEnabled;
	this.Mode = ConnectionType;
	this.ServiceList = (ExServiceList.length == 0)?ServiceList.toUpperCase():ExServiceList.toUpperCase();
	this.VlanId = vlanid;
	this.connectionstatus = connectionstatus;
	this.Tr069Flag = Tr069Flag;
	this.MacId     = MacId;
	this.IPv4Enable = IPv4Enable;
	this.DMZ_Array = new Array(null);
}

var IpDmzInfo = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaArrayFilterWan, InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i}.X_HW_DMZ,DMZEnable|DMZHostIPAddress,stDMZInfo);%>;
var PppDmzInfo = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaArrayFilterWan, InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i}.X_HW_DMZ,DMZEnable|DMZHostIPAddress,stDMZInfo);%>;

function filterWan(WanItem)
{
	if (!(WanItem.Tr069Flag == '0' && (IsWanHidden(domainTowanname(WanItem.domain)) == false)))
	{
		return false;	
	}
	
    if ((CfgModeWord == 'DT_HUNGARY') && (curUserType != sysUserType))
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

var AllWanInfoTemp = GetWanListByFilter(filterWan);
var AllWanInfo = new Array();

for (var i = 0; i < AllWanInfoTemp.length; i++)
{
	AllWanInfo[i] = new stWanInfo("","","","","","","","","","","","");
	AllWanInfo[i].domain = AllWanInfoTemp[i].domain;
	AllWanInfo[i].Name = AllWanInfoTemp[i].Name;
	AllWanInfo[i].Enable = AllWanInfoTemp[i].Enable;
	AllWanInfo[i].NATEnabled = AllWanInfoTemp[i].NATEnabled;
	AllWanInfo[i].Mode = AllWanInfoTemp[i].Mode;
	AllWanInfo[i].ServiceList = AllWanInfoTemp[i].ServiceList;
	AllWanInfo[i].VlanId = AllWanInfoTemp[i].VlanId;
	AllWanInfo[i].connectionstatus = AllWanInfoTemp[i].connectionstatus;
	AllWanInfo[i].Tr069Flag = AllWanInfoTemp[i].Tr069Flag;
	AllWanInfo[i].MacId = AllWanInfoTemp[i].MacId;
	AllWanInfo[i].IPv4Enable = AllWanInfoTemp[i].IPv4Enable;
	AllWanInfo[i].DMZ_Array = new Array(null);
}

function FindWanInfoByDmz(DmzItem)
{
	var wandomain_len = 0;
	var temp_domain = null;
	
	for(var k = 0; k < AllWanInfo.length; k++ )
	{
		wandomain_len = AllWanInfo[k].domain.length;
		temp_domain = DmzItem.domain.substr(0, wandomain_len);
		
		if (temp_domain == AllWanInfo[k].domain)
		{
			return AllWanInfo[k];
		}
	}
	return null;
}

var DmzInfo = new Array();
var Idx = 0;
for (i = 0; i < IpDmzInfo.length-1; i++)
{
    var tmpWan = FindWanInfoByDmz(IpDmzInfo[i]);
	
    if (tmpWan == null)
    {
        continue;
    }
	
	if (tmpWan.ServiceList != 'TR069'
       && tmpWan.ServiceList != 'VOIP'
       && tmpWan.ServiceList != 'TR069_VOIP'
       && tmpWan.Mode == 'IP_Routed')
	{
   		DmzInfo[Idx] = IpDmzInfo[i];
		Idx ++;
	}
}
for (j = 0; j < PppDmzInfo.length-1; j++,i++)
{
	var tmpWan = FindWanInfoByDmz(PppDmzInfo[j]); 
	 
	if (tmpWan == null)
    {
        continue;
    }  

    if (tmpWan.ServiceList != 'TR069'
		&& tmpWan.ServiceList != 'VOIP'
		&& tmpWan.ServiceList != 'TR069_VOIP'
		&& tmpWan.Mode == 'IP_Routed')
	{
   		DmzInfo[Idx] = PppDmzInfo[j];
		Idx ++;
	}
}

var WanInfo = new Array();

InitWanDmzInfo();

function InitWanDmzInfo()
{
	var WanIPInfo_len = 0;	
	var temp_domain = null;
	var k = 0;
	
	for (i = 0; i < DmzInfo.length; i++)
	{
		for (j = 0; j < AllWanInfo.length; j++)
		{
			WanIPInfo_len = AllWanInfo[j].domain.length;
			temp_domain = DmzInfo[i].domain.substr(0, WanIPInfo_len);
			if (temp_domain == AllWanInfo[j].domain)
			{
				WanInfo[k] = AllWanInfo[j];
				WanInfo[k].DMZ_Array[0] = DmzInfo[i];
				WanInfo[k].DMZ_Array[1] = null;
				k++;
				break;
			}
		}
	}
}

function ApplyConfig()
{
	if(CheckDMZ() == false)
	{
		return false;
	}
	
	setDisable('btnApply1',1);
	setDisable('cancelValue',1);
	setDisable('DMZInterface',1);
	
	var Interface = getElement('DMZInterface');
	var optionID = Interface.options[Interface.selectedIndex].id;
	var index = optionID.split('_')[1];
	var url;
	var SpecDmzCfgParaList = new Array(new stSpecParaArray("x.Name","", 2));
	var Parameter = {};
	Parameter.asynflag = null;
	Parameter.FormLiList = DmzConfigFormList;
	Parameter.SpecParaPair = SpecDmzCfgParaList;
	if(DmzAddFlag == true)
	{
		url = 'add.cgi?x=' + AllWanInfo[index].domain + '.X_HW_DMZ'
						   + '&RequestFile=html/bbsp/dmz/dmz.asp'
	}
	else
	{
		url = 'set.cgi?x=' + AllWanInfo[index].domain + '.X_HW_DMZ'
						   + '&RequestFile=html/bbsp/dmz/dmz.asp'
	}
	
	var tokenvalue = getValue('onttoken');
	HWSetAction(null, url, Parameter, tokenvalue);
}

function CheckAddDMZNote()
{
    var i = 0;
    var num = 0;
    for (i = 0; i < DmzInfo.length; i++)
    {
        if (DmzInfo[i].DMZEnable == 1)
        {
            num++;
        }
    }

    if (num >= 1)
    {
        return 0;
    }

    if (parseInt(getCheckVal('DMZEnable'), 10) == 0)
    {
        return 0;
    }

    return 1;
}

function CheckModifyDMZNote()
{
    var i = 0;
    var num = 0;

    for (i = 0; i < DmzInfo.length; i++)
    {
        if (DmzInfo[i].DMZEnable == 1)
        {
            num++;
        }
    }

    if (num >= 2)
    {
        return 0;
    }
    else if (num == 0)
    {
        if (parseInt(getCheckVal('DMZEnable'), 10) == 0)
        {
            return 0;
        }
        else
        {
            return 1;
        }
    }
    else if (num == 1)
    {
        if (DmzInfo[selctIndex].DMZEnable != 1)
        {
            return 0;            
        }
        else
        {
            if (parseInt(getCheckVal('DMZEnable'), 10) == 0)
            {
                return 2;
            }
        }
    }

    return 0;    
}

function CheckDelDMZNote(curitem)
{
    var i = 0;
    var num = 0;

    for (i = 0; i < DmzInfo.length; i++)
    {
        if ((DmzInfo[i].DMZEnable == 1)
            && (DmzInfo[i].flag == 0))
        {
            num++;
        }
    }

    DmzInfo[curitem].flag = 1;

    if (num == 0 || num >= 2)
    {
        return 0;
    }

    return 2;
}

function ProductNoteString(result)
{
    var notestring = '';

    if (GetFeatureInfo().dmzpri == 0)
    {
        return notestring;
    }

    if (result == 1)
    {
        if (GetFeatureInfo().httpportmode == 1)
        {
            if (WebOuterPort == 8080)
            {
                notestring = dmz_language['bbsp_dmzconflithttp1'];
            }
            else
            {
                notestring = dmz_language['bbsp_dmzconflithttp3'];          
            } 
        }

        if (GetFeatureInfo().telportmode == 1)
        {
            if (telnetOuterPort == 2323)
            {
                notestring += dmz_language['bbsp_dmzconflittel1'];           
            }
            else
            {
                notestring += dmz_language['bbsp_dmzconflittel3'];  
                
            }
        }

    }
    else if (result == 2)
    {
        if (GetFeatureInfo().httpportmode == 1)
        {
            if (WebInnerPort == 80)
            {
                notestring = dmz_language['bbsp_dmzconflithttp2'];
            }
            else
            {
                notestring = dmz_language['bbsp_dmzconflithttp3'];           
            }
        }

        if (GetFeatureInfo().telportmode == 1)
        {
            if (telnetInnerPort == 23)
            {
                notestring += dmz_language['bbsp_dmzconflittel2'];           
            }
            else
            {
                notestring += dmz_language['bbsp_dmzconflittel3'];               
            }
        }
    } 

    return notestring;
}

function CheckDMZ()
{
    var Interface = getElement('DMZInterface');
	var optionID = 0;
	var index = 0;
	var result = 0;
    var notestring = '';

	if ( Interface.selectedIndex < 0 )
	{
	    AlertEx(dmz_language['bbsp_creatwan']);
        return false;
	}

    optionID = Interface.options[Interface.selectedIndex].id;
	
	index = optionID.split('_')[1];

	if ( AllWanInfo[index].NATEnabled < 1 )
	{
	     AlertEx(dmz_language['bbsp_natof'] + MakeWanName1(AllWanInfo[index]) + dmz_language['bbsp_disable']);
         return false;
	}

	if (getElement('DMZInterface').length == 0)
	{
	  AlertEx(dmz_language['bbsp_nowan']);
	  return false;	
	}

    with (getElement('divTableConfigForm')) 
	{

		if (getElement('DMZHostIPAddress').value == '')
		{
			AlertEx(dmz_language['bbsp_dmzisreq']);
			return false;
		}

		if (isAbcIpAddress(getElement('DMZHostIPAddress').value) == false ) 
		{
			AlertEx(dmz_language['bbsp_dmzinvalid']);
			return false;
		}

		if(DmzAddFlag == true)
		{
			for(i = 0; i < WanInfo.length; i++)
			{
				if(WanInfo[i].Name == Interface.value)
				{
					AlertEx(dmz_language['bbsp_interface'] + MakeWanName1(WanInfo[i]) + dmz_language['bbsp_dmzrepeat']);
					return false;
				}
			}
		}
	}
	
    if (DmzAddFlag == true) 
    {
        result = CheckAddDMZNote();
    }
    else
    {
        result = CheckModifyDMZNote();
    }

    notestring = ProductNoteString(result);

    if (notestring.length != 0)
    {
		StartFileOpt();
        AlertEx(notestring);
    }
    
   setDisable('btnApply1', 1);
   setDisable('cancelValue', 1);
   return true;
}

function LoadFrame()
{
	loadlanguage();	
}

function ShowDMZ()
{

}

function setCtlDisplay(record)
{
	setSelect('DMZInterface',record.Name);

	if ( record.domain == '' )
	{
        setDisable('DMZInterface', 0);
		setCheck('DMZEnable','');		
		setText('DMZHostIPAddress','');
		SelectIP = '';
		setSelectHostName();
	}
	else
	{
        setDisable('DMZInterface', 1);
		setCheck('DMZEnable',record.DMZ_Array[0].DMZEnable);		
		setText('DMZHostIPAddress',record.DMZ_Array[0].DMZHostIPAddress);
		SelectIP = record.DMZ_Array[0].DMZHostIPAddress;
		setSelectHostName();
	}
}

var selctIndex = -1;

function getInterfaceWanList()
{
    var HU='<%HW_WEB_GetFeatureSupport(BBSP_FT_HU);%>';
	var WANNamelist = getElementById("DMZInterface");
	WANNamelist.options.length = 0;
    for (i = 0; i < AllWanInfo.length; i++)
    { 
        if (AllWanInfo[i].ServiceList != 'TR069'
            && AllWanInfo[i].ServiceList != 'VOIP'
            && AllWanInfo[i].ServiceList != 'TR069_VOIP'
            && AllWanInfo[i].Mode == 'IP_Routed'
            && AllWanInfo[i].IPv4Enable == '1')
        {
            if((HU==1) && (curUserType != '0') && ((AllWanInfo[i].ServiceList == 'IPTV') || (AllWanInfo[i].ServiceList == 'OTHER')))
            {
                continue;
            }
            else
            {
                $("#DMZInterface").append('<option value=' + AllWanInfo[i].Name + ' id="wan_'
                        + i + '">'
                        + AllWanInfo[i].Name + '</option>');
            }
        }
    }	 
}
function getInterfaceInternetWanList()
{
    var WANNamelist = getElementById("DMZInterface");
	WANNamelist.options.length = 0;
    for (i = 0; i < AllWanInfo.length; i++)
    { 
        if (AllWanInfo[i].Mode == 'IP_Routed' && AllWanInfo[i].IPv4Enable == '1')
        {
           if (AllWanInfo[i].ServiceList.toString().toUpperCase().indexOf("INTERNET") == -1
                || IsRadioWanSupported(AllWanInfo[i]))
            {
                continue;
            }
            else
            {
                $("#DMZInterface").append('<option value=' + AllWanInfo[i].Name + ' id="wan_'
                        + i + '">'
                        + AllWanInfo[i].Name + '</option>');
            }
        }
    }	   
}

function RefreshWanInterface(isAdd)
{
    if ((curUserType != sysUserType) && (CfgModeWord.toUpperCase() == "PTVDF"))
    {
        if(isAdd==true)
        {
            getInterfaceInternetWanList();
        }
        else
        {
            getInterfaceWanList();
        }
    }
}

function InitWanInterface()
{
	var HU='<%HW_WEB_GetFeatureSupport(BBSP_FT_HU);%>';
	for (i = 0; i < AllWanInfo.length; i++)
	{ 
		if (AllWanInfo[i].ServiceList != 'TR069'
			&& AllWanInfo[i].ServiceList != 'VOIP'
			&& AllWanInfo[i].ServiceList != 'TR069_VOIP'
			&& AllWanInfo[i].Mode == 'IP_Routed'
			&& AllWanInfo[i].IPv4Enable == '1')
		{
			if((HU==1) && (curUserType != '0') && ((AllWanInfo[i].ServiceList == 'IPTV') || (AllWanInfo[i].ServiceList == 'OTHER')))
			{
				continue;
			}
			else
			{
				$("#DMZInterface").append('<option value=' + AllWanInfo[i].Name + ' id="wan_'
                        + i + '">'
                        + AllWanInfo[i].Name + '</option>');
			}
		}
	}	
}

function setControl(index)
{
    var record;

	selctIndex = index;

	if (index == -1)
	{
	    if (DmzInfo.length >= 4)
        {
            setDisplay('ConfigForm', 0);
            AlertEx(dmz_language['bbsp_full']);
            return;
        }
        else
        {
    	    record = new stWanInfo('','','','','','','','','','');
    		DmzAddFlag = true;
            RefreshWanInterface(DmzAddFlag);
            setCtlDisplay(record);
            setDisplay('ConfigForm', 1);
			record.DMZEnable = '';
			record.DMZHostIPAddress = '';
			HWSetTableByLiIdList(DmzConfigFormList, record, null);
			return; 	
        }
	}
    else if (index == -2)
    {
        setDisplay('ConfigForm', 0);
    }
	else
	{
		DmzAddFlag = false;
        RefreshWanInterface(DmzAddFlag);
	    record = WanInfo[index];
        setCtlDisplay(record);
        setDisplay('ConfigForm', 1);
		record.DMZEnable = record.DMZ_Array[0].DMZEnable;
		record.DMZHostIPAddress = record.DMZ_Array[0].DMZHostIPAddress;
		HWSetTableByLiIdList(DmzConfigFormList, record, null);
		return; 
	}

    setDisable('btnApply1', 0);
    setDisable('cancelValue', 0);
}

function dmzInstselectRemoveCnt(obj) 
{

}  

function RemoveInst(url, rmlId)
{
	var rml = getElement(rmlId);
	if (rml == null)
		return;

	var SubmitForm = new webSubmitForm();
	var cnt = 0;
	with (document.forms[0])
	{
		if (rml.length > 0)
		{
			for (var i = 0; i < rml.length; i++)
			{
				if (rml[i].checked == true)
				{
					SubmitForm.addParameter(rml[i].value + '.X_HW_DMZ','');
					cnt++;
				}
			}
		}
		else if (rml.checked == true)
		{
			SubmitForm.addParameter(rml.value + '.X_HW_DMZ','');
			cnt++;
		}
	}

	SubmitForm.setAction('del.cgi?RequestFile=' + url);
	SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
	SubmitForm.submit();
}

function OnDeleteButtonClick(id)
{
	var notestring = '';
    var result = 0;
    if (DmzInfo.length == 0)
	{
	    AlertEx(dmz_language['bbsp_nodmz']);
	    return;
	}

	if (selctIndex == -1)
	{
	    AlertEx(dmz_language['bbsp_savedmz']);
	    return;
	}
    var rml = getElement('dmzInstrml');
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
        AlertEx(dmz_language['bbsp_choosedmz']);
        return ;
    }

	if (ConfirmEx(dmz_language['bbsp_deldmz']) == false)
	{
		document.getElementById("DeleteButton").disabled = false;
	    return;
    }
	
    if (rml.length > 0)
    {
         for (var i = 0; i < rml.length; i++)
         {
             if (rml[i].checked == true)
             {   
                result = CheckDelDMZNote(i);
                notestring = ProductNoteString(result);
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
        result = CheckDelDMZNote(selctIndex);
        notestring = ProductNoteString(result);
        if (notestring.length != 0)
        {
			StartFileOpt();
            AlertEx(notestring);
        }
    }
    
    setDisable('btnApply1', 1);
    setDisable('cancelValue', 1);
	RemoveInst('html/bbsp/dmz/dmz.asp', 'dmzInstrml');
}

function CancelConfig()
{
    setDisplay("ConfigForm", 0);
	
	if (selctIndex == -1)
    {
        var tableRow = getElement("dmzInst");

        if (tableRow.rows.length > 2)
        {
            tableRow.deleteRow(tableRow.rows.length-1);
			return;
        }
    }
}

function ShowDMZEnableStatus(statusflag)
{
	if (statusflag == "1" || statusflag == 1)
	{
		return dmz_language['bbsp_dmz_enable'] + '&nbsp;';
	}
	else
	{
		return dmz_language['bbsp_dmz_disable'] + '&nbsp;';
	}	
}

var TableClass = new stTableClass("table_title width_per25", "table_right", "", "Select");

function CreateDMZSelectInfo()
{
	var output = '';
	for (i = 0; i < LANhostName.length; i++)
	{
		output = '<option value=' + i + ' id="' + LANhostName[i] + '">' + LANhostName[i] + '</option>';
		$("#DMZHostName").append(output);
	} 			
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("dmz", GetDescFormArrayById(dmz_language, "bbsp_mune"), GetDescFormArrayById(dmz_language, "bbsp_dmz_title"), false);
</script>
<div class="title_spread"></div>

<script type="text/javascript">
var DmzConfiglistInfo = new Array(new stTableTileInfo("Empty","align_center","DomainBox"),
								new stTableTileInfo("bbsp_wanname","align_center","Name"),
								new stTableTileInfo("bbsp_enabledmz","align_center","EnableDMZ"),
								new stTableTileInfo("bbsp_hostaddr","align_center","HostAddress"),null);

var TableDataInfo =  HWcloneObject(WanInfo, 1);
TableDataInfo.push(null);
for(var i = 0; i < TableDataInfo.length-1; i++)
{
	TableDataInfo[i].EnableDMZ = ShowDMZEnableStatus(TableDataInfo[i].DMZ_Array[0].DMZEnable);
	TableDataInfo[i].HostAddress = TableDataInfo[i].DMZ_Array[0].DMZHostIPAddress;
}								
HWShowTableListByType(1, "dmzInst", true, 4, TableDataInfo, DmzConfiglistInfo, dmz_language, null);

</script>

<form id="ConfigForm" style="display:none">
<div class="list_table_spread"></div>
<table border="0" cellpadding="0" cellspacing="0"  width="100%">
<li   id="DMZEnable"         RealType="CheckBox"      DescRef="bbsp_enabledmzmh"        RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.DMZEnable"   InitValue="Empty"/>
<li   id="DMZInterface"      RealType="DropDownList"  DescRef="bbsp_wannamemh"          RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.Name"  InitValue="Empty" ClickFuncApp="onchange=ShowDMZ"/>                                                                   
<li   id="DMZHostIPAddress"  RealType="TextOtherBox"  DescRef="bbsp_hostaddrmh"         RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="TRUE"    BindField="x.DMZHostIPAddress"  MaxLength="15"  InitValue="[{Type:'select',Item:[{AttrName:'id',AttrValue:'DMZHostName'},{AttrName:'class',AttrValue:'Select_2'}]}]"/>                                                                  
</table>
<script>
DmzConfigFormList = HWGetLiIdListByForm("ConfigForm");
HWParsePageControlByID("ConfigForm", TableClass, dmz_language, null);
</script>
  <table id="ConfigPanelButtons" width="100%" cellpadding="2" cellspacing="0" class="table_button"> 
    <tr> 
      <td class="width_per25"></td> 
      <td class="table_submit">
	    <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
	  	<button name="btnApply1" id="btnApply1" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="ApplyConfig();"><script>document.write(dmz_language['bbsp_app']);</script></button> 
        <button name="cancelValue" id="cancelValue" type="button" class="CancleButtonCss buttonwidth_100px" onClick="CancelConfig();"><script>document.write(dmz_language['bbsp_cancel']);</script></button> 
	</td> 
    </tr> 
  </table> 
</form>
<div style="height:20px;"></div>
<script language="JavaScript" type="text/javascript">
InitWanInterface();
GetLanUserDevInfo(function(para)
{
	setlanhostnameip(para);
	CreateDMZSelectInfo();
	setSelectHostName();
});
getElById('DMZHostName').onchange = function()
{
	DMZHostNameChange();
}
</script> 
</body>
</html>
