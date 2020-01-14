<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>Chinese -- IP Incoming Filter</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="javascript" src="../../bbsp/common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../../bbsp/common/managemode.asp"></script>
<script language="JavaScript" type="text/javascript">
var addFlag = false;

function ipFilterAppTempPortAdd(proto_name)
{   
    var start_tcp_port = "";
    var end_tcp_port = "";
    var start_udp_port = "";
    var end_udp_port = "";
    
    this.name = proto_name;

    this.portinfo = function(s, e) {
        this.start = s;
        this.end = e;
    };
    
    var myport = new Object;

    if (arguments.length > 2) {
        start_tcp_port = arguments[1];
        end_tcp_port = arguments[2];
    }

    if (arguments.length > 4) {
        start_udp_port = arguments[3];
        end_udp_port = arguments[4];
    }
    myport.tcpPort = new this.portinfo(start_tcp_port,end_tcp_port);
    myport.udpPort = new this.portinfo(start_udp_port,end_udp_port);
    this.port = myport;
}


function IpFilterAppTempAdd()
{    
    var appTemps = new Array();
    
    nullTemps = new ipFilterAppTempPortAdd("NULL");
    
    this.appTemps = appTemps;
    
    appTemps.push(new ipFilterAppTempPortAdd("AIM Talk", "5190", "5190"));
    appTemps.push(new ipFilterAppTempPortAdd("Apple Remote desktop", "3283", "3283"));
    appTemps.push(new ipFilterAppTempPortAdd("XP Remote desktop", "3389", "3389"));
    appTemps.push(new ipFilterAppTempPortAdd("BearShare", "6346", "6346"));
    appTemps.push(new ipFilterAppTempPortAdd("BitTorrent", "6881:6900", "6881:6900", "6881:6900", "6881:6900"));
    appTemps.push(new ipFilterAppTempPortAdd("IP Camera 1", "80", "8120"));
    appTemps.push(new ipFilterAppTempPortAdd("IP Camera 2", "80", "8121"));
    appTemps.push(new ipFilterAppTempPortAdd("IP Camera 3", "80", "8122"));
    appTemps.push(new ipFilterAppTempPortAdd("IP Camera 4", "80", "8123"));
    appTemps.push(new ipFilterAppTempPortAdd("Checkpoint FW1 VPN", "259", "259", "259", "259"));
    appTemps.push(new ipFilterAppTempPortAdd("DirectX", "2300:2400,47624", "2300:2400,47624", "2302:2400,6073,47624","2302:2400,6073,47624"));
    appTemps.push(new ipFilterAppTempPortAdd("eMule", "4662,4711,64583", "4662,4711,64583", "4672,27673","4672,27673"));
    appTemps.push(new ipFilterAppTempPortAdd("Remote desktop", "3389", "3389"));
    appTemps.push(new ipFilterAppTempPortAdd("Gnutella", "6346:6347", "6346:6347","6346:6347", "6346:6347"));
    appTemps.push(new ipFilterAppTempPortAdd("ICQ", "5190", "5190"));
    appTemps.push(new ipFilterAppTempPortAdd("iMesh", "1214", "1214"));
    appTemps.push(new ipFilterAppTempPortAdd("IRC", "194,5100,6665:6669", "194,5100,6665:6669"));
    appTemps.push(new ipFilterAppTempPortAdd("iTunes", "3689", "3689","3689", "3689"));
    appTemps.push(new ipFilterAppTempPortAdd("KaZaa", "1214", "1214"));
    appTemps.push(new ipFilterAppTempPortAdd("Napster", "6699", "6699","6699", "6699"));
    appTemps.push(new ipFilterAppTempPortAdd("Netmeeting", "389,522,1023,1502:1504,1720:1732,65534", "389,522,1023,1502:1504,1720:1732,65534","1024:65535", "1024:65535"));
    appTemps.push(new ipFilterAppTempPortAdd("OpenVPN", "1194", "1194","1194", "1194"));
    appTemps.push(new ipFilterAppTempPortAdd("pcAnywhere", "5631:5632", "5631:5632","5631:5632", "5631:5632"));
    appTemps.push(new ipFilterAppTempPortAdd("PlayStation", "80,443,5223,10070:10080", "80,443,5223,10070:10080","3478:3479,3658,10070:10080", "3478:3479,3658,10070:10080"));
    appTemps.push(new ipFilterAppTempPortAdd("PPTP", "1723", "1723"));
    appTemps.push(new ipFilterAppTempPortAdd("FTP", "21", "21"));
    appTemps.push(new ipFilterAppTempPortAdd("DHCPv6", "547", "547","547", "547"));
    appTemps.push(new ipFilterAppTempPortAdd("DNS", "53", "53","53", "53"));
    appTemps.push(new ipFilterAppTempPortAdd("HTTPS", "443", "443"));
    appTemps.push(new ipFilterAppTempPortAdd("IMAP", "143,220,585,993", "143,220,585,993"));
    appTemps.push(new ipFilterAppTempPortAdd("Lotus Notes", "1352", "1352"));
    appTemps.push(new ipFilterAppTempPortAdd("MAMP", "8888:8889", "8888:8889"));
    appTemps.push(new ipFilterAppTempPortAdd("MySQL", "3306", "3306","3306", "3306"));
    appTemps.push(new ipFilterAppTempPortAdd("NNTP", "119,123", "119,123"));
    appTemps.push(new ipFilterAppTempPortAdd("POP3", "110,995", "110,995"));
    appTemps.push(new ipFilterAppTempPortAdd("SQL", "1433", "1433"));
    appTemps.push(new ipFilterAppTempPortAdd("SSH", "22", "22"));
    appTemps.push(new ipFilterAppTempPortAdd("SMTP", "25", "25"));
    appTemps.push(new ipFilterAppTempPortAdd("Telnet", "23", "23"));
    appTemps.push(new ipFilterAppTempPortAdd("TFTP", "","","69", "69"));
    appTemps.push(new ipFilterAppTempPortAdd("WEB", "80", "80"));
    appTemps.push(new ipFilterAppTempPortAdd("Skype", "80,443,23399", "80,443,23399","443,23399", "443,23399"));
    appTemps.push(new ipFilterAppTempPortAdd("VNC", "5500,5800,5900", "5500,5800,5900"));
    appTemps.push(new ipFilterAppTempPortAdd("Vuze", "6880,6969,7000,45100", "6880,6969,7000,45100","16680,49001", "16680,49001"));
    appTemps.push(new ipFilterAppTempPortAdd("Wii", "80,443,28910,29900,29901", "80,443,28910,29900,29901","80,443,28910,29900", "80,443,28910,29900"));
    appTemps.push(new ipFilterAppTempPortAdd("Windows Live Messenger", "80,443,1025,1503,1863,3389,5061,6891:6901,7001,30000:65535", "80,443,1025,1503,1863,3389,5061,6891:6901,7001,30000:65535",
                    "9,1025,1863,5004,6891:6901,7001,30000:65535", "9,1025,1863,5004,6891:6901,7001,30000:65535"));
    appTemps.push(new ipFilterAppTempPortAdd("WinMX", "6699", "6699", "6257", "6257"));
    appTemps.push(new ipFilterAppTempPortAdd("X Windows", "", "", "6000", "6000"));
    appTemps.push(new ipFilterAppTempPortAdd("Xbox Live", "53,80,1863,3074", "53,80,1863,3074","53,80,1863,3074","53,80,1863,3074"));
    appTemps.push(new ipFilterAppTempPortAdd("Yahoo Messenger", "5050", "5050"));
    
    this.GetTcpPortInfoByAppName = function(tempName){
        for(var i = 0; i < appTemps.length; i++){
            if( tempName == appTemps[i].name ){
                return appTemps[i].port.tcpPort;
            }
        }
        return nullTemps.port.tcpPort;
    };
    this.GetUdpPortInfoByAppName = function(tempName){
        for(var i = 0; i < appTemps.length; i++){
            if( tempName == appTemps[i].name ){
                return appTemps[i].port.udpPort;
            }
        }
        return nullTemps.port.udpPort;
    };
}

var IpFilterAppTemps = new IpFilterAppTempAdd();

var LANhostIP = new Array();
var LANhostName = new Array();

LANhostIP[0] = "";
LANhostName[0] = ipincoming_language['hostName_select'];
function USERDevice(Domain,IpAddr,MacAddr,Port,IpType,DevType,DevStatus,PortType,Time,HostName)
{
	this.Domain 	= Domain;
	this.IpAddr	= IpAddr;
	this.MacAddr	= MacAddr;
	this.Port 	= Port;
	this.PortType	= PortType;
	this.DevType	= DevType;
	this.DevStatus 	= DevStatus;
	this.IpType	= IpType;
	this.Time	= Time;
	this.HostName	= HostName;
}

var UserDevices = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.X_HW_UserDev.{i},IpAddr|MacAddr|PortID|IpType|DevType|DevStatus|PortType|time|HostName,USERDevice);%>;

var UserDevicesnum = UserDevices.length - 1;

for (var i = 0,j = 1; i < UserDevicesnum; i++)
{
	if ('' != UserDevices[i].HostName)
	{
  	LANhostName[j] = UserDevices[i].HostName;
  	LANhostIP[j] = UserDevices[i].IpAddr;
  	j++;
  }
  else if(UserDevices[i].IpType == 'Static')
  {
  	LANhostName[j] = UserDevices[i].MacAddr;
  	LANhostIP[j] = UserDevices[i].IpAddr;
  	j++;
  }
  		
  LANhostIP[i+1] = UserDevices[i].IpAddr;
}

function SHostNameChange(item)
{

	setText('SourceIPStart',LANhostIP[getSelectVal('SHostName')]);

}

function EHostNameChange(item)
{
	
	setText('SourceIPEnd',LANhostIP[getSelectVal('EHostName')]);

}


var numpara = "";
if( window.location.href.indexOf("?") > 0)
{
    numpara = window.location.href.split("?")[1]; 
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
		b.innerHTML = ipincoming_language[b.getAttribute("BindText")];
	}
}



function stPortFilter(domain, ipFilterInRight, ipFilterInPolicy, FirewallLevel)
{
    this.domain = domain;
	this.ipFilterInRight = ipFilterInRight;
	this.ipFilterInPolicy = ipFilterInPolicy;
	this.FirewallLevel    = FirewallLevel;
}



var portFilters = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security,IpFilterInRight|IpFilterInPolicy|X_HW_FirewallLevel,stPortFilter);%>
var portFilter = portFilters[0]; 

var enblIn = portFilter.ipFilterInRight;
var Mode = portFilter.ipFilterInPolicy;
var FltsecLevel = portFilters[0].FirewallLevel.toUpperCase();
var selctIndex = -1;

function stFilterIn(Domain, Priority, Protocol, Direction, SourceIPStart, SourceIPEnd, DestIPStart, DestIPEnd, Action, lanTcpPort, lanUdpPort, wanTcpPort, wanUdpPort,Name)
{
    this.Domain = Domain;
	this.Priority = Priority;
    this.Direction = Direction;
	this.Protocol = Protocol;
    this.SourceIPStart = SourceIPStart;
    this.SourceIPEnd = SourceIPEnd;
    this.DestIPStart = DestIPStart;    
    this.DestIPEnd = DestIPEnd;
    this.Action = Action;
    this.lanTcpPort = lanTcpPort;
    this.lanUdpPort = lanUdpPort;
    this.wanTcpPort = wanTcpPort;
    this.wanUdpPort = wanUdpPort;
    this.name = Name;
}

function DirAndPriCmp(stFilterIn1, stFilterIn2)
{
	var cmp = 0;
	
	if(stFilterIn1.Direction != stFilterIn2.Direction)
	{
		if(stFilterIn1.Direction.toUpperCase() == "DOWNSTREAM")
			cmp = 1;
		else
			cmp = -1;
	}
	else
	{
		var IntAPri = parseInt(stFilterIn1.Priority, 10);
		var IntBPri = parseInt(stFilterIn2.Priority, 10);
		if(IntAPri > IntBPri)
			cmp = 1;
		else if(IntAPri < IntBPri)
			cmp = -1;
		else 
			cmp = 0;
	}
	
	return cmp;
}
var FilterIn = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.IpFilterIn.{i},Priority|Protocol|Direction|SourceIPStart|SourceIPEnd|DestIPStart|DestIPEnd|Action|LanSideTcpPort|LanSideUdpPort|WanSideTcpPort|WanSideUdpPort|Name,stFilterIn);%>;

if(Mode == 2)
{
	FilterIn.splice(FilterIn.length - 1, 1);	
	FilterIn.sort(DirAndPriCmp);
	FilterIn.push(null);
}

function setBtnDisable()
{
	setDisable('EnableIpFilter',1);
    setDisable('FilterMode',1);
	setDisable('ModeSave_button',1);
    setDisable('IpIncomingAdd_button',1);
	setDisable('IpIncomingEdit_button',1);
	setDisable('IpIncomingApply_button',1);
	setDisable('IpIncomingDelete_button',1);
}

function clickRemove() 
{
	var noChooseFlag = true;
	var SubmitForm = new webSubmitForm();	
    if ((FilterIn.length-1) == 0)
	{
	    AlertEx(ipincoming_language['bbsp_norule']);
	    return;
	}

	if (selctIndex == -1)
	{
	    AlertEx(ipincoming_language['bbsp_cannotdel']);
	    return;
	}
	
	for (var i = 0; i < FilterIn.length - 1; i++)
	{
		var j = i + 1;
		var rmId = 'IpIncoming' + j +'_checkbox';
		var rm = getElement(rmId);
		if (rm.checked == true)
		{
			noChooseFlag = false;
			SubmitForm.addParameter(FilterIn[i].Domain,'');
		}
	}
    if ( noChooseFlag )
    {
        AlertEx(ipincoming_language['bbsp_plschoose']);
        return ;
    }
 
	if (ConfirmEx(ipincoming_language['bbsp_isdel']) == false)
	{
		return;
    }
    setBtnDisable();
	SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
	SubmitForm.setAction('del.cgi?RequestFile=html/bbsp/ipincoming/ipincominge8c.asp');
	SubmitForm.submit();	
}

function clickCheckbox(index)
{
    var chkboxShow = 'IpIncoming' + index +'_checkbox';
    var chkboxHide = 'IpIncoming' + index +'_checkboxCopy';
    var enableVal = getCheckVal(chkboxShow);
    setCheck(chkboxHide,enableVal);
}

function clickCheckboxAll()
{
    for (var i = 0; i < FilterIn.length - 1; i++){
        var index = i + 1;
        var chkboxShow = 'IpIncoming' + index +'_checkbox';
        var enableVal = getCheckVal("IpIncoming_checkbox");
        setCheck(chkboxShow,enableVal);
        clickCheckbox(index);
    }
}

function LoadFrame()
{  
	setDisplay('Newbutton',0);
	setDisplay('DeleteButton',0);
 
    InitOption();

    if (enblIn != '' && Mode != '')
    {   
        setDisplay('ConfigForm1',1);
        setSelect('FilterMode',Mode);

        if (FilterIn.length - 1 == 0)
        {   
            selectLine('record_no');
            setDisplay('ConfigForm',0);
        }
        else
        {
            selectLine('record_0');
            setDisplay('ConfigForm',1);
        }
		setDisable('FilterMode',0);
		setDisable('IpIncomingMACApply_button',0);
    }

    if (enblIn == true)
    {
        getElById("EnableIpFilter").checked = true;
    }

    
	InitControlDataType();
    protocalChange();
    
	if(isValidIpAddress(numpara) == true)
	{
		clickAdd('IP Incoming Filter');
		setText('SourceIPStart', numpara);

		for (var k = 0; k < LANhostIP.length; k++)
		{
			if (numpara == LANhostIP[k])
			{
				setSelect('SHostName', k);
				break;
			}
		}
	}
	if(FltsecLevel != 'CUSTOM')
	{
		setDisable('EnableIpFilter' , 1);
		setDisable('FilterMode' , 1);
	}
	
	loadlanguage();
}


function setCtlDisplay(record)
{
    setText('RuleNameId',record.name);
	setSelect('Protocol',(record.Protocol).toUpperCase());

	setSelect('Direction',record.Direction);
	setText('Priority',record.Priority);
	setSelect('Action',record.Action);
	
    setText('SourceIPStart',record.SourceIPStart);
	setText('SourceIPEnd',record.SourceIPEnd);
	setText('DestIPStart',record.DestIPStart);
	setText('DestIPEnd',record.DestIPEnd);

	setText('lanTcpPortId',record.lanTcpPort);
	setText('lanUdpPortId',record.lanUdpPort);
	setText('wanTcpPortId',record.wanTcpPort);
	setText('wanUdpPortId',record.wanUdpPort);
	
	protocalChange();
}

function setControl(index)
{
    var record;
    selctIndex = index;
    if (index == -1)
	{
	    if (FilterIn.length >= 32+1)
        {
            setDisplay('ConfigForm', 0);
            AlertEx(ipincoming_language['bbsp_ipfilterfull']);
			setDisable('WlanMACApply_button',1);
            return;
        }
        else
        {
			record = new stFilterIn('', '', 'ALL', 'Upstream', '', '', '', '', 0, '', '', '', '','');
            setDisplay('ConfigForm', 1);
	        setCtlDisplay(record);
        }
	}
    else if (index == -2)
    {
        setDisplay('ConfigForm', 0);
    }
	else
	{
	    record = FilterIn[index];
        setDisplay('ConfigForm', 1);
	    setCtlDisplay(record);
	}

    setDisable('btnApply_ex',0);
    setDisable('cancelButton',0);
}

function ChangeMode()
{
    var FilterMode = getElById("FilterMode");
    if (FilterMode[0].selected == true)
	{ 
		if (false == ConfirmEx(ipincoming_language['bbsp_changemodenote1']))
		{
	        setSelect('FilterMode', Mode);
			return;
		}
	}
	else if (FilterMode[1].selected == true)
	{ 
		if (false == ConfirmEx(ipincoming_language['bbsp_changemodenote2']))
		{
		     setSelect('FilterMode', Mode);
			 return;
		}
	}
	else if (FilterMode[2].selected == true)
	{ 
		if (false == ConfirmEx(ipincoming_language['bbsp_changemodenote3']))
		{
			 setSelect('FilterMode', Mode);
			 return;
		}
	}
}

function SubmitForm()
{ 
    var Form = new webSubmitForm();
    var Enable = getElById("EnableIpFilter").checked;
    if (Enable == true)
    {
        Form.addParameter('x.IpFilterInRight',1); 
    }
    else
    {
        Form.addParameter('x.IpFilterInRight',0); 
    }
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_Security'
                        + '&RequestFile=html/bbsp/ipincoming/ipincominge8c.asp');
    Form.submit();
}

function OnSaveIPIncomingFilterMode()
{
	var Form = new webSubmitForm();   
	var Enable = getElById("EnableIpFilter").checked;
	if (Enable == true)
	{
	   Form.addParameter('x.IpFilterInRight',1);
	}
	else
	{
	   Form.addParameter('x.IpFilterInRight',0);
	}
	
	var FilterMode = getElById("FilterMode");
	if (FilterMode[0].selected == true)
	{
		Form.addParameter('x.IpFilterInPolicy',0);		
	}
	else if (FilterMode[1].selected == true)
	{
		Form.addParameter('x.IpFilterInPolicy',1);
	}
	else if (FilterMode[2].selected == true)
	{
		Form.addParameter('x.IpFilterInPolicy',2);
	}
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_Security'
						+ '&RequestFile=html/bbsp/ipincoming/ipincominge8c.asp');
	setBtnDisable();
	Form.submit();
}

function OnSelectIPIncomingRecord(recId)
{
    if(false == addFlag){
        selectLine(recId);
    }
}

function OnEditIpIncomingFilter()
{
    var recordId = 'record_' + selctIndex;
    setDisplay('IpIncoming_edit_tr',0);
    if((selctIndex < 0) && (FilterIn.length <= 1)){
        AlertEx("没有可以修改的配置记录");
        return;
    }
    selectLine(recordId);
    setDisplay('IpIncoming_edit_tr',1);
}

function DefaultRule()
{
	if ((getSelectVal('Protocol') == 'ALL')
		&& (getValue('SourceIPStart') == '')
		&& (getValue('SourceIPEnd') == ''))
	{
		return true;
	}
	else
	{
		return false;
	}
}
function MakePortInfoPairs(s,e)
{
    this.start = s;
    this.end = e;
}
function IpFilterParsePortInfo(portInfo)
{
    var portInfoList = new Array(0);
    var portList1;
    var portList2;

    if('' == portInfo)
    {
        var portPairs = new MakePortInfoPairs("","");
        portInfoList.push(portPairs);
        return portInfoList;
    }
    
    portList1 = portInfo.split(',');

    for(var i = 0; i < portList1.length; i++)
    {
        var portPairs;       
        var portList2 = portList1[i].split(':');
        if(portList2.length > 1)
        {
            portPairs = new MakePortInfoPairs(portList2[0],portList2[1]);
        }
        else
        {
            portPairs = new MakePortInfoPairs(portList1[i],portList1[i]);
        }
        portInfoList.push(portPairs)
    }
    return portInfoList;
}
function IpFilterPortInputChk(portInfo)
{
    var portList = portInfo.split(',');
    var numbersMatch = new RegExp("^[1-9][0-9]*$");
    var result;

    for(var i = 0; i < portList.length; i++)
    {       
        if(portList[i].indexOf(":") > 0)
        {
            var list2 = portList[i].split(':');
            
            if(2 != list2.length)
            {
                return false;
            }
            for(var j = 0; j < 2;j++)
            {
                result = numbersMatch.exec(list2[j]);
                if(null == result)
                {
                    return false;
                }
            }

            if(parseInt(list2[0],10) > parseInt(list2[1],10))
            {
                return false;
            }
        }
        else
        {
            result = numbersMatch.exec(portList[i]);
            if(null == result)
            {
                return false;
            }
        }        
    }
    return true;
}
function IpFilterGetPortSum(portInfo)
{
    var portList1 = portInfo.split(',');
    var portList2 = portInfo.split(':');
    var sum = (portList1.length - 1) + (portList2.length - 1) + 1;
    return sum;
}

function PortValidChk(portIn,descp)
{
    var portList;
    if('' == portIn)
    {
        return true;
    }
    if(true != IpFilterPortInputChk(portIn))
    {
        AlertEx(ipincoming_language['invalid_port'] + "("+portIn+")");
        return false;
    }
    if(IpFilterGetPortSum(portIn) > 15)
    {
        AlertEx(ipincoming_language['port_sum_exceed']);
        return false;
    }
    portList = IpFilterParsePortInfo(portIn);
    for(var i = 0; i < portList.length; i++)
    {
        var portInt = portList[i].start;
        if(isValidPort(portInt) == false)
        {
            AlertEx(ipincoming_language['port_port_invalid'] +"("+ portInt+ ")");
            return false;
        }
        portInt = portList[i].end;
        if(isValidPort(portInt) == false)
        {
            AlertEx(ipincoming_language['port_port_invalid'] +"("+ portInt+ ")");
            return false;
        }
    }
    var errorPort;
    var repeateFound = false;

    for(var i = 0; i < portList.length; i++)
    {
        var portStart = parseInt(portList[i].start,10);
        var portEnd = parseInt(portList[i].end,10);
        for(var j = 0; j < portList.length; j++)
        {
            if(i === j){
                continue;
            }

    		if( (portStart >= parseInt(portList[j].start,10)) && (portStart <= parseInt(portList[j].end,10)) )
    		{
    		    errorPort = portStart;
    		    repeateFound = true;
    		    break;
    		}

    		if( (portEnd >= parseInt(portList[j].end,10)) && (portEnd <= parseInt(portList[j].end,10)) )
    		{
    		    errorPort = portEnd;
    		    repeateFound = true;
    		    break;
    		}

    		if( (portStart < parseInt(portList[j].start,10)) && (portEnd > parseInt(portList[j].end,10)) )
    		{
    		    errorPort = portList[j].start;
    		    repeateFound = true;
    		    break;
    		}
        }
        if(true == repeateFound)
        {
            AlertEx(descp  +" \"" + errorPort + ipincoming_language['bbsp_repeated']);
            return false;
        }
    }
    
    return true;
}
function IpFilterPortValidChk()
{
    var lanTcpPort = getValue('lanTcpPortId');
    var wanTcpPort = getValue('wanTcpPortId');
    var lanUdpPort = getValue('lanUdpPortId');
    var wanUdpPort = getValue('wanUdpPortId');
 

    if(true != PortValidChk(lanTcpPort,ipincoming_language['port_lan_tcp']))
    {
        return false;
    }
    if(true != PortValidChk(wanTcpPort,ipincoming_language['port_wan_tcp']))
    {
        return false;
    }

    if(true != PortValidChk(lanUdpPort,ipincoming_language['port_lan_udp']))
    {
        return false;
    }
    if(true != PortValidChk(wanUdpPort,ipincoming_language['port_wan_udp']))
    {
        return false;
    }
    
    return true;
}
function IpFilterRepeateCfgChk()
{
    var Direction = getSelectVal('Direction');
    var Priority = getValue('Priority');
    var sourceIPStart = getValue('SourceIPStart');
    var sourceIPEnd = getValue('SourceIPEnd');
    var destIPStart = getValue('DestIPStart');
    var destIPEnd = getValue('DestIPEnd');
	var protocolVal = getSelectVal('Protocol');
	var dir = getSelectVal('Direction');
	var Action = getValue('Action');
    var lanTcpPort = getValue('lanTcpPortId');
    var wanTcpPort = getValue('wanTcpPortId');
    var lanUdpPort = getValue('lanUdpPortId');
    var wanUdpPort = getValue('wanUdpPortId');
    var Action = getSelectVal('Action');
    
	for (i = 0; i < FilterIn.length-1; i++)
	{	
		if(i != selctIndex)
		{	
			if (( Mode == 2 )
				&& (FilterIn[i].Direction == Direction)
				&& (FilterIn[i].Priority == Priority))
			{
			    AlertEx(ipincoming_language['bbsp_invaliddirandpri'] + ipincoming_language[Direction]
					  + ipincoming_language['bbsp_priorityvalue1'] + Priority
					  + ipincoming_language['bbsp_repeated']);
				return false;
			}
	    	if ((FilterIn[i].SourceIPStart == sourceIPStart)
			    && (FilterIn[i].SourceIPEnd == sourceIPEnd)
				&& (FilterIn[i].DestIPStart == destIPStart)
				&& (FilterIn[i].DestIPEnd == destIPEnd)
				&& (FilterIn[i].Protocol == protocolVal)
				&& (FilterIn[i].Direction == dir)
				&& (FilterIn[i].lanTcpPort == lanTcpPort)
				&& (FilterIn[i].lanUdpPort == lanUdpPort)
				&& (FilterIn[i].wanTcpPort == wanTcpPort)
				&& (FilterIn[i].wanUdpPort == wanUdpPort))
    		    {
    		    	if (2 == Mode){
    					if( FilterIn[i].Action == Action){
    			    	    AlertEx(ipincoming_language['bbsp_rulerepeat']);		    
    				    	return false;
    			    	}
    		    	}else{
				        AlertEx(ipincoming_language['bbsp_rulerepeat']);		    
			    	    return false;	
			        }	    
    			}
		}
	} 
	return true;   
}
function IpFilterDescpChk()
{
    var descrip = getValue("RuleNameId");
	if ("" == descrip)
	{
	    AlertEx(ipincoming_language['rule_name_cannot_blank']);
        return false;
    }
    if (isValidName(descrip) == false) 
    {
        AlertEx(ipincoming_language['rule_name_invalid']);
        return false;
    }

    for(var i = 0; i < FilterIn.length - 1; i++)
    {
        if((FilterIn[i].name  == descrip)&&(i != selctIndex))
        {
            AlertEx(ipincoming_language['rule_name_cannot_repeated']);
            return false;
        }
    }
    return true;
}

function CheckForm()
{	
    var SourceIPStart = getValue('SourceIPStart');
    var SourceIPEnd = getValue('SourceIPEnd');
    var DestIPStart = getValue('DestIPStart');
    var DestIPEnd = getValue('DestIPEnd');
	var Priority = getValue('Priority');


    if(true != IpFilterDescpChk())
    {
        return false;
    }

	if ( Mode == 2 )
	{
		Priority = removeSpaceTrim(Priority);
		if(Priority!="")
		{
		   if ( false == CheckNumber(Priority,0, 255) )
		   {
			 AlertEx(ipincoming_language['bbsp_priorityvalue'] + Priority + ipincoming_language['bbsp_isvalid1']);
			 return false;
		   }
		}
		else
		{
			AlertEx(ipincoming_language['bbsp_priorityneed']);
			return false;
		}
	}	
	

	if (SourceIPStart != "" && isAbcIpAddress(SourceIPStart) == false)
	{
		AlertEx(ipincoming_language['bbsp_lanstartaddr'] + SourceIPStart + ipincoming_language['bbsp_isvalid']);
		return false;
	}
	if (SourceIPEnd != "" && isAbcIpAddress(SourceIPEnd) == false)
	{
		AlertEx(ipincoming_language['bbsp_lanendaddr'] + SourceIPEnd + ipincoming_language['bbsp_isvalid']);
		return false;
	}
    if (SourceIPEnd != "" 
	    && (IpAddress2DecNum(SourceIPStart) > IpAddress2DecNum(SourceIPEnd)))
	{
		AlertEx(ipincoming_language['bbsp_lanstartaddrinvalid']);
		return false;     	
	}
    if (SourceIPStart == "" && SourceIPEnd != "" ) 
	{
		AlertEx(ipincoming_language['bbsp_lanstartaddrisreq']);
		return false;
	}
	
	

	if (DestIPStart != ""  && isAbcIpAddress(DestIPStart) == false) 
	{
		AlertEx(ipincoming_language['bbsp_wanstartaddr'] + DestIPStart + ipincoming_language['bbsp_isvalid']);
		return false;
	}
	if (DestIPEnd != "" && isAbcIpAddress(DestIPEnd) == false) 
	{
		AlertEx(ipincoming_language['bbsp_wanendaddr'] + DestIPEnd + ipincoming_language['bbsp_isvalid']);
		return false;
	}
    if (DestIPEnd != "" 
	    && (IpAddress2DecNum(DestIPStart) > IpAddress2DecNum(DestIPEnd)))
	{
		AlertEx(ipincoming_language['bbsp_wanstartaddrinvalid']);
		return false;     	
	}
    if (DestIPStart == "" && DestIPEnd != "" ) 
	{
		AlertEx(ipincoming_language['bbsp_wanstartaddrisreq']);
		return false;
	}
	

    if(true != IpFilterPortValidChk())
    {
        return false;
    }

    if(true != IpFilterRepeateCfgChk())
    {
        return false;
    }
    
	if ((Mode == 2) && (Priority != 255) && (true == DefaultRule()))
	{
	    AlertEx(ipincoming_language['bbsp_prioritydefault']);
		return false;
	}

   	return true;
}
function AddSubmitParam(SubmitForm,type)
{
	var Priority = getValue('Priority');
	Priority = removeSpaceTrim(Priority);

    SubmitForm.addParameter('x.Protocol',getSelectVal('Protocol'));
    SubmitForm.addParameter('x.Direction',getSelectVal('Direction')); 
    SubmitForm.addParameter('x.Name',getSelectVal('RuleNameId'));
    if ( Mode == 2 )
    {
    	SubmitForm.addParameter('x.Priority',Priority);
    	SubmitForm.addParameter('x.Action',getValue('Action'));	  
    }

    SubmitForm.addParameter('x.SourceIPStart',getValue('SourceIPStart'));
    SubmitForm.addParameter('x.SourceIPEnd',getValue('SourceIPEnd'));
    SubmitForm.addParameter('x.DestIPStart',getValue('DestIPStart'));
    SubmitForm.addParameter('x.DestIPEnd',getValue('DestIPEnd'));

    if (getSelectVal('Protocol') != 'ALL' && getSelectVal('Protocol') != 'ICMP')
    {
        SubmitForm.addParameter('x.LanSideTcpPort',getValue('lanTcpPortId'));
        SubmitForm.addParameter('x.LanSideUdpPort',getValue('lanUdpPortId'));
        SubmitForm.addParameter('x.WanSideTcpPort',getValue('wanTcpPortId'));
        SubmitForm.addParameter('x.WanSideUdpPort',getValue('wanUdpPortId'));
    }
    else
    {
        SubmitForm.addParameter('x.LanSideTcpPort',"");
        SubmitForm.addParameter('x.LanSideUdpPort',"");
    	SubmitForm.addParameter('x.WanSideTcpPort',"");
    	SubmitForm.addParameter('x.WanSideUdpPort',"");
    }
    
    SubmitForm.addParameter('x.Direction', getSelectVal('Direction'));
    if ( Mode == 2 )
    {
    	SubmitForm.addParameter('x.Priority',Priority);
    	SubmitForm.addParameter('x.Action', getSelectVal('Action'));	  
    }

	setBtnDisable();
    SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
	if (selctIndex == -1)
	{
        SubmitForm.setAction('add.cgi?x=InternetGatewayDevice.X_HW_Security.IpFilterIn'
    	                         + '&RequestFile=html/bbsp/ipincoming/ipincominge8c.asp');
    }
    else
    {
		SubmitForm.setAction('set.cgi?x=' + FilterIn[selctIndex].Domain
				+ '&RequestFile=html/bbsp/ipincoming/ipincominge8c.asp');
    }

}

function CancelValue()
{
    if (selctIndex == -1)
    {
        var tableRow = getElement("ipfilter");

        if (tableRow.rows.length == 1)
        {

        }
        else if (tableRow.rows.length == 2)
        {
            addNullInst('IP Incoming Filter');
        }
        else
        {
            tableRow.deleteRow(tableRow.rows.length-1);
            selectLine('record_0');
        }
    }
    else
    {
        var record = FilterIn[selctIndex];
        setCtlDisplay(record);
    }
    setSelect('EHostName',0);
    setSelect('SHostName',0);
}



function protocalChange(event_invoke)
{   
    var currentPro = getSelectVal('Protocol');
    
    if ("1" == GetCfgMode().TELMEX){
        setDisplay('trFamiliarAppId',1);
        if((arguments.length > 0)&&(event_invoke)){
            IpFilterAppTempSelect();
        }
    }
    setDisplay('trLanSidePortId',1);
    setDisplay('trWanSidePortId',1);
    setDisable('lanUdpPortId',0);
    setDisable('wanUdpPortId',0);
    setDisable('lanTcpPortId',0);
    setDisable('wanTcpPortId',0);
    
    switch (currentPro)
    {
        case "ALL":
        case "ICMP":
            setDisplay('trFamiliarAppId',0);
            setDisplay('trLanSidePortId',0);
            setDisplay('trWanSidePortId',0);
            break;
        case "TCP":
            setText('lanUdpPortId',"");
            setText('wanUdpPortId',"");
            setDisable('lanUdpPortId',1);
            setDisable('wanUdpPortId',1);
            break;
        case "UDP":
            setText('lanTcpPortId',"");
            setText('wanTcpPortId',"");
            setDisable('lanTcpPortId',1);
            setDisable('wanTcpPortId',1);
            break;
        default:
            break;
    }
}

function GetFmiliarAppOptions()
{
    var appTempsLists = getElementById('sfamiliarAppId');
    var apps = new Array(
        "FIRST_APP","bbsp_selectdd",                   
        "AIM Talk","bbsp_AIMTalk",                    
        "Apple Remote desktop","bbsp_AppleRemoteDesktop",  
        "BearShare","bbsp_BearShare",                     
        "BitTorrent","bbsp_BitTorrent",
        "Checkpoint FW1 VPN","bbsp_CheckpointFW1VPN",       
        "DHCPv6","bbsp_ServerDHCPv6",                       
        "DirectX","bbsp_DirectX",                          
        "DNS","bbsp_ServerDNS",                             
        "eMule","bbsp_eMule",                               
        "FTP","bbsp_FTPServer",                             
        "Gnutella","bbsp_Gnutella",                         
        "HTTPS","bbsp_ServerHTTPS",                         
        "ICQ","bbsp_ICQ",                                   
        "IMAP","bbsp_ServerIMAP",                           
        "iMesh","bbsp_iMesh",                               
        "IP Camera 1","bbsp_CameraIP1",                     
        "IP Camera 2","bbsp_CameraIP2",                     
        "IP Camera 3","bbsp_CameraIP3",                     
        "IP Camera 4","bbsp_CameraIP4",                     
        "IRC","bbsp_IRC",                                   
        "iTunes","bbsp_iTunes",                             
        "KaZaa","bbsp_KaZaa",                               
        "Lotus Notes","bbsp_ServerLotusNotes",              
        "MAMP","bbsp_ServerMAMP",                           
        "MySQL","bbsp_ServerMySQL",                         
        "Napster","bbsp_Napster",                           
        "Netmeeting","bbsp_Netmeeting",                     
        "NNTP","bbsp_ServerNNTP",                           
        "OpenVPN","bbsp_OpenVPN",                           
        "pcAnywhere","bbsp_pcAnywhere",                     
        "PlayStation","bbsp_PlayStation",                   
        "POP3","bbsp_ServerPOP3",                              
        "PPTP","bbsp_PPTP",                                 
        "Remote desktop","bbsp_RemoteDesktop",              
        "Skype","bbsp_Skype",                               
        "SMTP","bbsp_ServerSMTP",                           
        "SQL","bbsp_ServerSQL",                             
        "SSH","bbsp_ServerSSH",                             
        "Telnet","bbsp_TelnetServer",                       
        "TFTP","bbsp_TFTP",                                 
        "WEB","bbsp_ServerWEB",                             
        "VNC","bbsp_VNC",                                   
        "Vuze","bbsp_Vuze",                                 
        "Wii","bbsp_Wii",                                   
        "Windows Live Messenger","bbsp_WindowsLiveMessenger",
        "WinMX","bbsp_WinMX",                               
        "XP Remote desktop","bbsp_RemoteSupportXP",         
        "X Windows","bbsp_XWindows",                        
        "Xbox Live","bbsp_XboxLive",                        
        "Yahoo Messenger","bbsp_YahooMessenger");
                  
    appTempsLists.options.length = 0; 
    for(var i = 0; i < apps.length; i += 2 )
    {
        appTempsLists.options.add(new Option(portmapping_language[apps[i+1]], apps[i]));
    }
    
}
function InitOption()
{
	var Directionlist = getElementById('Direction');

	Directionlist.options.length = 0;

	if(Mode == 2)
	{		
		Directionlist.options.add(new Option(ipincoming_language['Upstream'], 'Upstream'));
		Directionlist.options.add(new Option(ipincoming_language['Downstream'], 'Downstream'));
	}
	else
	{
		Directionlist.options.add(new Option(ipincoming_language['Bidirectional'], 'Bidirectional'));
		setDisable('Direction', 1);
		setDisplay('PriorityDiv',0);
		setDisplay('ActionTblId',0);
    }
	if ("1" == GetCfgMode().TELMEX)
	{	
	    setDisplay('DirectionDiv',0);		
	}
	
	GetFmiliarAppOptions();
}
function IpFilterAppTempSelect(event_invoke)
{
    var currentAppTemp = getSelectVal('sfamiliarAppId');

    setText("lanTcpPortId","");
    setText("wanTcpPortId","");
    setText("lanUdpPortId","");
    setText("wanUdpPortId","");


    setText("wanTcpPortId",IpFilterAppTemps.GetTcpPortInfoByAppName(currentAppTemp).end);
    setText("wanUdpPortId",IpFilterAppTemps.GetUdpPortInfoByAppName(currentAppTemp).end);

    if((arguments.length > 0) && (event_invoke))
    {
        setSelect('Protocol',"TCP/UDP");
        protocalChange();
    }
    
    
}
function IpFilterShowInst()
{
    if(FltsecLevel != 'CUSTOM')
	{
		FilterIn.length = 1;
	}
    if (FilterIn.length - 1 == 0)
    {   
		document.write('<tr id="record_no" class="tabal_01 align_center" onclick="OnSelectIPIncomingRecord(this.id);">');
		document.write('<td id=\"IpIncoming1_checkbox\" onclick="selectLine(this.id);" align="center">--</td>');
        document.write('<td >--</td>');
	    document.write('<td >--</td>'); 
        document.write('<td >--</td>');
        document.write('<td >--</td>');
		if (GetCfgMode().TELMEX != "1")
		{
			document.write('<td >--</td>');
		}
        if(Mode == 2)
		{
			document.write('<td >--</td>');
	        document.write('<td >--</td>');
		}
		document.write('</tr>');
    }
    else
    {
        for (var i = 0; i < FilterIn.length - 1; i++)
        {
            var ruleName = FilterIn[i].name;
            if('' == ruleName){
                ruleName = "--"
            }
		    var j = i+1;
			document.write('<tr id="record_' + i + '" class="tabal_01 align_center"  onclick="OnSelectIPIncomingRecord(this.id)">');
			document.write('<td align="center"><input id=\"IpIncoming' + j +'_checkbox\"'  + 'type=\'checkbox\''+ 'value=\'false\'' + 'onclick=\"clickCheckbox('+j+');\">' );
			document.write('<input id=\"IpIncoming' + j +'_checkboxCopy\"'  + 'type=\'checkbox\''
							+ ' value=\'' + FilterIn[i].Domain + '\' style=\"display:none\" >'+ '</td>' );
        	document.write('<td >' + ruleName + '</td>');
			if(Mode == 2)
			{
				document.write('<td >' + FilterIn[i].Priority + '</td>');
			}
			
			if((FilterIn[i].Protocol).toUpperCase() == "TCP/UDP")
			{
			document.write('<td >' + ipincoming_language['TCPUDP'] + '&nbsp;</td>'); 
			}
			else
			{
			document.write('<td >' + ipincoming_language[(FilterIn[i].Protocol).toUpperCase()] + '&nbsp;</td>'); 
			}
        	
			if ( GetCfgMode().TELMEX != "1" )
			{
		 	    document.write('<td >' + ipincoming_language[FilterIn[i].Direction] + '&nbsp;</td>');
			}		 	
    	    if (FilterIn[i].SourceIPStart != '' && FilterIn[i].SourceIPEnd != '') 
    	    {
        	     document.write('<td >' + FilterIn[i].SourceIPStart + '-'
        	                + FilterIn[i].SourceIPEnd + '&nbsp;</td>');
            }
            else if (FilterIn[i].SourceIPStart != '' && FilterIn[i].SourceIPEnd == '')
            {
                 document.write('<td >' + FilterIn[i].SourceIPStart + '&nbsp;</td>');
            }
            else
            {
                document.write('<td >'  + '--' + '&nbsp;</td>');
            }

            if (FilterIn[i].DestIPStart != '' && FilterIn[i].DestIPEnd != '')
			{   
        	    document.write('<td >' + FilterIn[i].DestIPStart + '-'
        	                 + FilterIn[i].DestIPEnd + '&nbsp;</td>'); 
            }
            else if (FilterIn[i].DestIPStart != '' && FilterIn[i].DestIPEnd == '')
            {
                document.write('<td >' + FilterIn[i].DestIPStart + '&nbsp;</td>'); 
            }
            else
            {
                document.write('<td >' + '--' + '&nbsp;</td>');
            }

			if(Mode == 2)
			{
				document.write('<td >' + ipincoming_language[FilterIn[i].Action] + '</td>');
			}
        	 document.write('</tr>');
        
       } 	 
    }
}

function OnclickAdd(tabTitle)
{
	clickAdd(tabTitle);
	setDisplay('IpIncoming_edit_tr',1);
	var record = new stFilterIn('', '', 'ALL', 'Upstream', '', '', '', '', 0, '', '', '', '','');
	setDisplay('ConfigForm', 1);
	setCtlDisplay(record);
	addFlag = true;
    setDisable('IpIncomingDelete_button',1);
    setDisable('IpIncomingEdit_button',1);
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<form id="ConfigForm1"style="display:inline"> 
  <table width="100%" border="0" cellpadding="0" cellspacing="0" id="tabTest"> 
    <tr> 
      <td class="prompt"><table width="100%" border="0" cellspacing="0" cellpadding="0"> 
          <tr> 
            <td class='title_common' BindText='bbsp_ipincoming_title'></td> 
          </tr> 
        </table></td> 
    </tr> 
    <tr> 
      <td class='height5p'></td> 
    </tr> 
  </table> 
  <div id="ipIncomingFlt"> 
  <table cellspacing="0" cellpadding="0" width="100%"> 
    <tr class='align_left'> 
      <td class="table_title width_20p">
        <script> document.write(ipincoming_language['bbsp_enable']+ (("1" == "<% HW_WEB_GetFeatureSupport(BBSP_FT_CTC);%>" )?(ipincoming_language['bbsp_e8cport']):(ipincoming_language['bbsp_comip'])) + ipincoming_language['bbsp_filtermh1']);
            </script> 
      </td> 
      <td class="table_right "><input type=checkbox id="EnableIpFilter" value="True"/>
        <span id="enableIpFilterTipsId" class="gray">
          <script>
		  	document.write('('+ipincoming_language['tip_perfence']+')');
          </script>
        </span>
      </td> 
    </tr> 
    <tr class='align_left'> 
      <td class="table_title width_20p">过滤模式</td> 
      <td class="table_right" id="FilterModeTitle"><select id="FilterMode" size='1' onchange="setTimeout(function(){ChangeMode();})"> 
          <option value="0" id="FilterMode1"><script>document.write(ipincoming_language['bbsp_blackList']);</script></option> 
          <option value="1" id="FilterMode2"><script>document.write(ipincoming_language['bbsp_whiteList']);</script></option> 
          <script>
          if ("1" != GetCfgMode().TELMEX)
		  {
		  	document.write('<option value="2" id="FilterMode3" title="' + ipincoming_language['title3'] + '">' + ipincoming_language['bbsp_hybridList'] + '</option>');
          }
          </script>
        </select></td> 
		<script LANGUAGE="JavaScript">  
		 if ("1" == GetCfgMode().TELMEX)
		 {
		     getElById("FilterModeTitle").title = ipincoming_language['title4'];
		 }
		 else
		 {
		     getElById("FilterModeTitle").title = ipincoming_language['title'];
		 }
		 getElById("FilterMode1").title = ipincoming_language['title1'];
		 getElById("FilterMode2").title = ipincoming_language['title2'];
		</script>
    </tr> 
  </table> 
  <br/> 
	<table width="100%" class="table_button"> 
	  <tr align="right"> 
	  <td><button id="ModeSave_button" type="button" onclick="OnSaveIPIncomingFilterMode();">保存/应用</button></td>
	  </tr>
	</table>
	 <hr style="color:#C9C9C9"></hr>
  <script language="JavaScript" type="text/javascript">
    ((FltsecLevel == 'CUSTOM') ? writeTabCfgHeader : writeTabInfoHeader)('IP Incoming Filter',"100%","140");
</script> 
  <table class="tabal_bg" id="ipfilter" width="100%" border="0" align="center" cellpadding="0" cellspacing="1"> 
    <tr class=" head_title"> 
      <td >&nbsp<input id="IpIncoming_checkbox" type="checkbox" onclick="clickCheckboxAll();"  value="false" ></td> 
      <td BindText='tip_rule_name2'></td>
	  <script>
	  if(Mode == 2)
	  	document.write("<td  BindText='bbsp_priority'></td>");
      </script>
      <td  BindText='bbsp_protocol'></td>
      <script>
      if (GetCfgMode().TELMEX != "1")
        document.write("<td  BindText='bbsp_direction'></td>");
      </script>
      <td  BindText='bbsp_lanip'></td> 
      <td  BindText='bbsp_wanip'></td> 
      <script>
      if(Mode == 2)
      	document.write("<td  BindText='bbsp_action'></td>");
      </script>
    </tr> 
    <script language="JavaScript" type="text/javascript">
	    IpFilterShowInst();
    </script> 
  </table> 
  <div id="ConfigForm"> 
  <table cellpadding="2" cellspacing="0" width="100%"> 
  <tr> 
	  <td id="IpIncoming_edit_tr" style="display:none">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" > 
      <tr> 
        <td class="table_title width_20p" BindText='tip_rule_name2'></td> 
	    <td class="table_right width_20p"> 
	            <input type='text' style="width: 96px" id="RuleNameId" name="RuleName" maxLength=32> 	 
	            <strong class='color_red'>*</strong>
	    </td> 
      </tr>
      <tr> 
        <td class="table_title width_20p"   BindText='bbsp_protocol'></td> 
        <script language="JavaScript" type="text/javascript"> 
            document.write('<td class="table_right width_80p" >'); 
        </script>
        <select id='Protocol' style="width: 103px" name='Protocol' size="1" onChange='protocalChange(1)'> 
            <option value="ALL" selected><script>document.write(ipincoming_language['ALL']);</script> </option> 
            <option value="TCP/UDP"><script>document.write(ipincoming_language['TCPUDP']);</script>  </option> 
            <option value="TCP"><script>document.write(ipincoming_language['TCP']);</script>  </option>
            <option value="UDP"><script>document.write(ipincoming_language['UDP']);</script>  </option> 
            <option value="ICMP"><script>document.write(ipincoming_language['ICMP']);</script>  </option> 
        </select>
      </tr>
    <tr id="trFamiliarAppId" style="display:none"> 
        <td class="table_title width_20p" BindText='tip_familiar_app1'></td> 
        <td class="table_right width_80p" ><select id='sfamiliarAppId' style="width: 127px" name='familiarApp' size="1" onChange="IpFilterAppTempSelect(1)"> 
        </select></td>
    </tr> 
	  </table>
      <div id="PriorityDiv">
	  <table width="100%" border="0" cellpadding="0" cellspacing="0" > 
      <tr> 
        <td class="table_title width_20p"   BindText='bbsp_priority'></td> 
        <script language="JavaScript" type="text/javascript"> 	        
        	 document.write('<td class="table_right width_80p" >');	       
        </script> 
	        <table width="100%" border="0" cellpadding="0" cellspacing="0"> 
	          <tr> 
	            <input type='text' style="width: 96px" id="Priority" name="Priority" maxLength=6> 	 
	            <strong class='color_red'>*</strong><span class="gray">(0-255)</span> 
	          </tr> 
	        </table>           
      </tr>
	  </table>
	  </div>
	  <div id="DirectionDiv">
	  <table width="100%" border="0" cellpadding="0" cellspacing="0"> 
      <tr> 
        <td class="table_title width_20p"   BindText='bbsp_direction'></td> 
		<td class="table_right width_80p" ><select id='Direction' style="width: 103px" name='Direction' size="1"> </select></td>
      </tr>
	  </table>
	  </div>
	  <table width="100%" border="0" cellpadding="0" cellspacing="0" > 
      <tr> 
        <td class="table_title width_20p"  BindText='bbsp_lanip'></td> 
        <td class="table_right width_80p" > <input type='text'  id="SourceIPStart" name="SourceIPStart" maxLength=15> 
          <script language="JavaScript" type="text/javascript">
          	document.write('<select name=' + "'SHostName'" + ' id=' + "'SHostName'" + ' size="1" onChange=' + '"SHostNameChange(item)"' + ' style="width: 110px">');
            for (i = 0; i < LANhostName.length; i++)
            {
              document.write('<option value="' + i + '" id="' + LANhostName[i] + '">' + LANhostName[i] + '</option>');			   
            } 
          	document.write('</select>');
          </script> --
          <input type='text' " id="SourceIPEnd" name="SourceIPEnd" maxLength=15>
          <script language="JavaScript" type="text/javascript">
          	document.write('<select name=' + "'EHostName'" + ' id=' + "'EHostName'" + ' size="1" onChange=' + '"EHostNameChange(item)"' + ' style="width: 110px">');
            for (i = 0; i < LANhostName.length; i++)
            {
              document.write('<option value="' + i + '" id="' + LANhostName[i] + '">' + LANhostName[i] + '</option>');			   
            } 
          	document.write('</select>'); 
          </script>
        </td> 
      </tr> 
    </table> 

    
    <table width="100%" border="0" cellpadding="0" cellspacing="0" > 
    <tr> 
    <td class="table_title width_20p" BindText='bbsp_wanip'></td> 
    <td class="table_right width_80p" > 
        <input type='text' size="20" id="DestIPStart" name="DestIPStart" maxLength=15> --
        <input type='text' size="20" id="DestIPEnd" name="DestIPEnd" maxLength=15> </td> 
    </tr> 
    </table> 

    <table width="100%" border="0" cellpadding="0" cellspacing="0" > 
    <tr id="trLanSidePortId"> 
    <td  class="table_title width_20p" BindText='bbsp_lanport'></td> 
    <td  class="table_right width_40p" >
      <script>document.write(ipincoming_language['tcp_port1']);</script>
      <input type='text' size="20" id="lanTcpPortId" name="lanTcpPort" maxLength="90"> 
    </td> 
    <td  class="table_right width_40p">
      <script>document.write(ipincoming_language['udp_port1']);</script>
      <input type='text' size="20" id="lanUdpPortId" name="lanUdpPort" maxLength="90"> 
    </td> 
    </tr> 
    <tr id="trWanSidePortId"> 
    <td  class="table_title width_20p" BindText='bbsp_wanport'></td> 
    <td  class="table_right width_40p">
      <script>document.write(ipincoming_language['tcp_port1']);</script>
      <input type='text' size="20" id="wanTcpPortId" name="wanTcpPort"  maxLength="90"> 
    </td> 
    <td  class="table_right width_40p">
      <script>document.write(ipincoming_language['udp_port1']);</script>
      <input type='text' size="20" id="wanUdpPortId" name="wanUdpPort"  maxLength="90"> 
    </td> 
    </tr> 
    </table>
    <table id="ActionTblId" width="100%" border="0" cellpadding="0" cellspacing="0" > 
      <tr> 
        <td class="table_title width_20p"   BindText='bbsp_action'></td> 
        <td class="table_right width_80p" >
        <select id='Action' name='Action' size="1"> 
            <option value="Accept" selected><script>document.write(ipincoming_language['Accept']);</script> </option> 
            <option value="Drop"><script>document.write(ipincoming_language['Drop']);</script>  </option> 
		</select>
		</td>
      </tr>
	</table>
	</td>
	</tr>
	</table>
	 </div>
    <table width="100%" border="0" class="table_button"> 
    <tr align="right">
    <td class='width_35p'></td> 
    <td >
		<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
		<button id='IpIncomingAdd_button'  type="button" onClick="OnclickAdd('IP Incoming Filter');">添加</button>
		<button id='IpIncomingEdit_button' type="button" onclick="OnEditIpIncomingFilter();" >编辑</button>
		<button id='IpIncomingApply_button' name="WlanMACApply_button" type="button" onClick="Submit();"> <script>document.write(ipincoming_language['bbsp_app']);</script> </button> 
		<button id='IpIncomingDelete_button' name="WlanMACDelete_button"  type="button" onClick="OnDeleteButtonClick('IP Incoming Filter');">删除</button> </td>
	</tr> 
    </table> 
  <script language="JavaScript" type="text/javascript">
    writeTabTail();
  </script>
</form> 
</body>
</html>
