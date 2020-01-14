<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<title>Intelligent Channel</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">

var MaxQosSmartRule = 64;
var OperatorFlag = 0;
var selIndex = -1;


function LanName2LanDomain(LanName)
{

    if(LanName.length == 0)
    {
        return '';
    }
     
    var EthNum = LanName.charAt(LanName.length - 1);
    
    return  "InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig." + EthNum;
}

function appendPrompt(filedName)
{   
   return qos_L2smart_language[filedName]+qos_L2smart_language['bbsp_qosPrompt'];
}


function LanDomain2LanName(Domain)
{
    if(Domain.length == 0)
    {
        return '';
    }
    
    var EthNum = Domain.charAt(Domain.length - 1);
    
    return  "LAN" + EthNum;
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
		b.innerHTML = qos_L2smart_language[b.getAttribute("BindText")];
	}
}


function TopoInfo(Domain, EthNum, SSIDNum)
{   
    this.Domain = Domain;
    this.EthNum = EthNum;
    this.SSIDNum = SSIDNum;
}

function QosSmartItem(_Domain,_OperationType, _ClassInterface, _Ethertype, _SourceMACAddress, _DestMACAddress, _DestIP, _DestMask, _SourceIP, _SourceMask, _Protocol, _DestPort, _DestPortRangeMax, _SourcePort, _SourcePortRangeMax, _VLANIDCheck, _EthernetPriorityCheck, _EthernetPriorityMark, _BpduGarpFlag, _BpduCfmFlag, _MultiFlowFlag)
{
	this.Domain = _Domain;
	this.OperationType =_OperationType;
	this.ClassInterface = LanDomain2LanName(_ClassInterface);
	if( -1 != _Ethertype && '' != _Ethertype )
	{
		_Ethertype = parseInt(_Ethertype);
		this.Ethertype ='0x'+_Ethertype.toString(16);
	}
	else
	{
		this.Ethertype = _Ethertype;
	}
	this.SourceMACAddress =_SourceMACAddress;
	this.DestMACAddress =_DestMACAddress;
	this.DestIP = _DestIP;
	this.DestMask = _DestMask;
	this.SourceIP = _SourceIP;
	this.SourceMask = _SourceMask;
	this.Protocol = _Protocol;
	this.DestPort = _DestPort;
	this.DestPortRangeMax = _DestPortRangeMax;
	this.SourcePort = _SourcePort;
	this.SourcePortRangeMax = _SourcePortRangeMax;    
	this.VLANIDCheck = _VLANIDCheck;
	this.EthernetPriorityCheck =_EthernetPriorityCheck;
	this.EthernetPriorityMark =_EthernetPriorityMark;
	this.BpduGarpFlag =_BpduGarpFlag;
	this.BpduCfmFlag =_BpduCfmFlag;
	this.MultiFlowFlag =_MultiFlowFlag;
}

function stLayer3Enable(domain, lay3enable)
{
	this.domain = domain;
	this.lay3enable = lay3enable;
}

var QosSmartList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_SpecialPacket.{i},OperationType|ClassInterface|Ethertype|SourceMACAddress|DestMACAddress|DestIP|DestMask|SourceIP|SourceMask|Protocol|DestPort|DestPortRangeMax|SourcePort|SourcePortRangeMax|VLANIDCheck|EthernetPriorityCheck|EthernetPriorityMark|BpduGarpFlag|BpduCfmFlag|MultiFlowFlag, QosSmartItem);%>    

var TopoInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Topo,X_HW_EthNum|X_HW_SsidNum,TopoInfo);%>
var TopoInfo = TopoInfoList[0];


function ClassInterfaceInitOption()
{
	var InterfaceList = getElementById('ClassInterface');
	var EthNum = TopoInfo.EthNum;
    var i;
    
	InterfaceList.options.add(new Option('', ''));
	for(i=1; i<=EthNum;i++)
	{
	    InterfaceList.options.add(new Option('LAN' + i, LanName2LanDomain('LAN' + i)));
	}
}

function paraCompensate()
{
	var i = 0;
	var RecordCount = QosSmartList.length - 1;
	for(i = 0; i < RecordCount; i ++)
	{
	
		  QosSmartList[i].Ethertype = (QosSmartList[i].Ethertype == '-1')?'':QosSmartList[i].Ethertype;
		  QosSmartList[i].SourceMACAddress = (QosSmartList[i].SourceMACAddress == '-1')?'':QosSmartList[i].SourceMACAddress;
		  QosSmartList[i].DestMACAddress = (QosSmartList[i].DestMACAddress == '-1')?'':QosSmartList[i].DestMACAddress;
		  QosSmartList[i].SourceIP = (QosSmartList[i].SourceIP == '-1')?'':QosSmartList[i].SourceIP;
		  QosSmartList[i].Protocol = (QosSmartList[i].Protocol == '-1')?'':QosSmartList[i].Protocol;
	    QosSmartList[i].DestIP = (QosSmartList[i].DestIP == '-1')?'':QosSmartList[i].DestIP;  
	    QosSmartList[i].SourcePort = (QosSmartList[i].SourcePort == '-1')?'':QosSmartList[i].SourcePort;
	    QosSmartList[i].DestPort = (QosSmartList[i].DestPort == '-1')?'':QosSmartList[i].DestPort;
	    QosSmartList[i].VLANIDCheck = (QosSmartList[i].VLANIDCheck == '-1')?'':QosSmartList[i].VLANIDCheck;
	    QosSmartList[i].EthernetPriorityCheck = (QosSmartList[i].EthernetPriorityCheck == '-1')?'':QosSmartList[i].EthernetPriorityCheck;
	    QosSmartList[i].EthernetPriorityMark = (QosSmartList[i].EthernetPriorityMark == '-1')?'':QosSmartList[i].EthernetPriorityMark;
	}
}

function LoadFrame()
{	
  ClassInterfaceInitOption();
	loadlanguage();	

  if (QosSmartList.length -1 == 0)
	{
		selectLine('record_no');
		setDisplay('TableConfigInfo', 0);
	
	}
	else
	{
	  selectLine('record_0');
	  setDisplay('TableConfigInfo', 1);
	 
	}
	
}

function ShortFormatStr( originData)
{
     var shortData = '';
     var shortLen  = 16;
    	    
    if(originData.length <= shortLen)
    {
        shortData = originData;    	        
    }
    else
    {
        shortData = originData.substr(0, shortLen) + '...';
    }
    
    return shortData;
}


function UpdateUI(QosSmartList)
{
    var HtmlCode = "";
    var DataGrid = getElById("DataGrid");
    var RecordCount = QosSmartList.length - 1;
    var i = 0;

    paraCompensate();
    if (RecordCount == 0)
    {
        HtmlCode += '<TR id="record_no" class="tabal_center01" onclick="selectLine(this.id);">';
        HtmlCode += '<TD></TD>';
        HtmlCode += '<TD>--</TD>';
        HtmlCode += '<TD>--</TD>';
        HtmlCode += '<TD>--</TD>';
        HtmlCode += '<TD>--</TD>';
        HtmlCode += '<TD>--</TD>';
        HtmlCode += '<TD>--</TD>';
        HtmlCode += '<TD>--</TD>';
        HtmlCode += '<TD>--</TD>';
        HtmlCode += '<TD>--</TD>';
        HtmlCode += '<TD>--</TD>';
        HtmlCode += '<TD>--</TD>';
        HtmlCode += '<TD>--</TD>';
        HtmlCode += '<TD>--</TD>';
        HtmlCode += '<TD>--</TD>';
    	  HtmlCode += '</TR>';
    	return HtmlCode;
    }

    for (i = 0; i < RecordCount; i++)
    {
    	HtmlCode += '<TR id="record_' + i 
    	                + '" class="tabal_center01" onclick="selectLine(this.id);">';
        HtmlCode += '<TD>' + '<input type="checkbox" name="rml"'  + ' value=' 
    	                 + QosSmartList[i].Domain  + '>' + '</TD>';
    	if ('' != QosSmartList[i].ClassInterface)
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + QosSmartList[i].ClassInterface + '</TD>'; 
    	}
    	else
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
    	}
    	
    	if ('' != QosSmartList[i].Ethertype) 
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + QosSmartList[i].Ethertype + '</TD>'; 
    	}
    	else
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
    	}
    	
    	if ('' != QosSmartList[i].Protocol)
    	
    	
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + QosSmartList[i].Protocol + '</TD>'; 
    	}
    	else
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
    	}
    	
    	if ('' != QosSmartList[i].SourceMACAddress)
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + QosSmartList[i].SourceMACAddress + '</TD>'; 
    	}
    	else
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
    	}
    	
    	if ('' != QosSmartList[i].DestMACAddress)
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + QosSmartList[i].DestMACAddress + '</TD>'; 
    	}
    	else
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
    	}
    	
    	if ('' != QosSmartList[i].VLANIDCheck)
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + QosSmartList[i].VLANIDCheck + '</TD>'; 
    	}
    	else
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
    	}
    	
    	if ('' != QosSmartList[i].SourceIP)
    	{       	    
    	    HtmlCode += '<TD  id = "RecordDestIP'+i+ '" title = "' + QosSmartList[i].SourceIP + '/' + QosSmartList[i].SourceMask + '">' 
    	                + ShortFormatStr(QosSmartList[i].SourceIP) + '/<br>' + ShortFormatStr(QosSmartList[i].SourceMask) + '</TD>'; 
    	}
    	else
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
    	} 
    	
    	if ('' != QosSmartList[i].DestIP)
    	{  	
    	    HtmlCode += '<TD  id = "RecordDestIP'+i+ '" title = "' + QosSmartList[i].DestIP + '/' + QosSmartList[i].DestMask + '">' 
    	               + ShortFormatStr(QosSmartList[i].DestIP) + '/<br>' + ShortFormatStr(QosSmartList[i].DestMask) + '</TD>'; 
    	}
    	else
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
    	}
    	
    	if(1 == QosSmartList[i].OperationType)
    	{
				if ('' != QosSmartList[i].EthernetPriorityCheck)
				{
					HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + QosSmartList[i].EthernetPriorityCheck + '</TD>'; 
				}
				else
				{
					HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
				}
				
				HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>';
				HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>';
				HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>';
    	}
    	else if(2 == QosSmartList[i].OperationType)
    	{
				if ('' != QosSmartList[i].EthernetPriorityCheck)
				{
					HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + QosSmartList[i].EthernetPriorityCheck + '</TD>'; 
				}
				else
				{
					HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
				}
				
				HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>';
				HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>';
				
				if ('' != QosSmartList[i].EthernetPriorityMark)
				{
					HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + QosSmartList[i].EthernetPriorityMark + '</TD>'; 
				}
				else
				{
					HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
				}
				
    	}
    	else if(3 == QosSmartList[i].OperationType)
    	{
				
				HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
				
				if ('' != QosSmartList[i].EthernetPriorityCheck)
				{
					HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + QosSmartList[i].EthernetPriorityCheck + '</TD>'; 
				}
				else
				{
					HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
				}
				
				HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>';
				HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>';
						
    	}
    	else if( 4 == QosSmartList[i].OperationType )
  		{
  			HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
  			HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>';
				if ('' != QosSmartList[i].EthernetPriorityMark)
				{
					HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + QosSmartList[i].EthernetPriorityMark + '</TD>'; 
				}
				else
				{
					HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
				} 
				
				HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>';
  		}
  		else
			{
				HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
  			HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>';
  			HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
  			HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>';
			}
    		  	
    	if ('' != QosSmartList[i].SourcePort)
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + QosSmartList[i].SourcePort + '</TD>'; 
    	}
    	else
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
    	}
    	
    	if ('' != QosSmartList[i].DestPort)
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + QosSmartList[i].DestPort + '</TD>'; 
    	}
    	else
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
    	}
    
    	HtmlCode += '</TR>';
    }
    return HtmlCode;

}



function GetInputRuleInfo()
{
 var qosSmartItem = new QosSmartItem("",getSelectVal("OperationType"),getSelectVal("ClassInterface"), getValue("Ethertype"),
                                     getValue("SourceMACAddress"),getValue("DestMACAddress"),getValue("DestIP"),
                                     getValue("DestMask"),getValue("SourceIP"),getValue("SourceMask"),
                                     getValue("Protocol"), getValue("DestPort"),getValue("DestPortRangeMax"),
                                     getValue("SourcePort"), getValue("SourcePortRangeMax"),getValue("VLANIDCheck"),
                                     getValue("EthernetPriorityCheck"),getValue("EthernetPriorityMark"),getSelectVal("BpduGarpFlag"),
                                     getSelectVal("BpduCfmFlag"),getSelectVal("MultiFlowFlag")); 

 return qosSmartItem;
}

function SetInputRuleInfo(QosSmartItem)
{
	  setSelect("OperationType", QosSmartItem.OperationType);
    setSelect("ClassInterface", LanName2LanDomain(QosSmartItem.ClassInterface)); 
    setText("Ethertype", QosSmartItem.Ethertype);
    setText("SourceMACAddress", QosSmartItem.SourceMACAddress);
    setText("DestMACAddress", QosSmartItem.DestMACAddress);
    setText("DestIP", QosSmartItem.DestIP);
    setText("DestMask", QosSmartItem.DestMask);
    setText("SourceIP", QosSmartItem.SourceIP);
    setText("SourceMask", QosSmartItem.SourceMask);
    setText("Protocol", QosSmartItem.Protocol);
    setText("DestPort", QosSmartItem.DestPort);
    setText("DestPortRangeMax", QosSmartItem.DestPortRangeMax);
    setText("SourcePort", QosSmartItem.SourcePort);
    setText("SourcePortRangeMax", QosSmartItem.SourcePortRangeMax);
    setText("VLANIDCheck", QosSmartItem.VLANIDCheck);
    setText("EthernetPriorityCheck", QosSmartItem.EthernetPriorityCheck);
    setText("EthernetPriorityMark", QosSmartItem.EthernetPriorityMark);
    setSelect("BpduGarpFlag", QosSmartItem.BpduGarpFlag);
    setSelect("BpduCfmFlag", QosSmartItem.BpduCfmFlag);
    setSelect("MultiFlowFlag", QosSmartItem.MultiFlowFlag);
}

function OnNewInstance(index)
{
   OperatorFlag = 1;

   var qossmartitem = new QosSmartItem("", "", "", "", "", "", "", "", "", "", "", "", "", "","","","","","","","");
   setDisplay('TableConfigInfo', 1);
  
   SetInputRuleInfo(qossmartitem);
}

function ModifyInstance(index)
{
    OperatorFlag = 2;
    
    setDisplay('TableConfigInfo', 1);
    SetInputRuleInfo(QosSmartList[index]);
		if(1 == QosSmartList[index].OperationType)
		{
		 setDisplay('showEthertype', 1);
		 setDisplay('showSourceMac', 1);
		 setDisplay('showDestMac', 1);
		 setDisplay('showVlan', 0);
		 setDisplay('showSourceIP', 1);
		 setDisplay('showDestIP', 1);
		 setDisplay('showPriorityMark', 1);
		 setDisplay('showPriorityCover', 0);
		 setDisplay('showSourceL4Port', 1);
		 setDisplay('showDestL4Port', 1);
		 setDisplay('showGARPAppAddress', 1);
		 setDisplay('showCFMAddress', 1);
		 setDisplay('showFiltMulticastStream', 1);
		 setDisplay('showProtocol', 1);
		 document.getElementById("Priorityflgs").innerHTML = qos_L2smart_language['bbsp_Priorityflgs'];
		}
		else if( 2 == QosSmartList[index].OperationType)
	{
		 setDisplay('showEthertype', 1);
		 setDisplay('showSourceMac', 1);
		 setDisplay('showDestMac', 1);
		 setDisplay('showVlan', 1);
		 setDisplay('showSourceIP', 0);
		 setDisplay('showDestIP', 0);
		 setDisplay('showPriorityMark', 1);
		 setDisplay('showPriorityCover', 1);
		
		 setDisplay('showSourceL4Port', 0);
		 setDisplay('showDestL4Port', 0);
		 setDisplay('showGARPAppAddress', 0);
		 setDisplay('showCFMAddress', 0);
		 setDisplay('showFiltMulticastStream', 0);
		 setDisplay('showProtocol', 0);
		 document.getElementById("Priorityflgs").innerHTML = qos_L2smart_language['bbsp_Priorityflgs'];
		 document.getElementById("PriorityMarkflgs").innerHTML = qos_L2smart_language['bbsp_PriorityMarkflgs'];
		
	}
	else if( 3 == QosSmartList[index].OperationType)
	{
		 setDisplay('showEthertype', 0);
		 setDisplay('showSourceMac', 0);
		 setDisplay('showDestMac', 0);
		 setDisplay('showVlan', 0);
		 setDisplay('showSourceIP', 0);
		 setDisplay('showDestIP', 0);
		 setDisplay('showPriorityMark', 1);
		
		 setDisplay('showPriorityCover', 0);
		
		 setDisplay('showSourceL4Port', 0);
		 setDisplay('showDestL4Port', 0);
		 setDisplay('showGARPAppAddress', 0);
		 setDisplay('showCFMAddress', 0);
		 setDisplay('showFiltMulticastStream', 0);
		 setDisplay('showProtocol', 0);
		 document.getElementById("Priorityflgs").innerHTML = qos_L2smart_language['bbsp_Priorityfilts'];
	}
	else if( 4 == QosSmartList[index].OperationType)
	{
		 setDisplay('showEthertype', 0);
		 setDisplay('showSourceMac', 0);
		 setDisplay('showDestMac', 0);
		 setDisplay('showVlan', 0);
		 setDisplay('showSourceIP', 0);
		 setDisplay('showDestIP', 0);
		 setDisplay('showPriorityMark', 0);
		 setDisplay('showPriorityCover', 1);
		
		 setDisplay('showSourceL4Port', 0);
		 setDisplay('showDestL4Port', 0);
		 setDisplay('showGARPAppAddress', 0);
		 setDisplay('showCFMAddress', 0);
		 setDisplay('showFiltMulticastStream', 0);
		 setDisplay('showProtocol', 0);
		 document.getElementById("PriorityMarkflgs").innerHTML = qos_L2smart_language['bbsp_Prioritycover'];
	}
}

function setControl(index)
{ 
    if (-1 == index)
    {
        if (QosSmartList.length-1 == MaxQosSmartRule)
        {
            var tableRow = getElementById("xxxInst");
            tableRow.deleteRow(tableRow.rows.length-1);
            AlertEx(qos_L2smart_language['bbsp_qossmartfull']);
            return false;
        }
    }
    
  selIndex = index;
	if (index < -1)
	{
		return;
	}

    if (-1 == index)
    {        
        return OnNewInstance(index);
    }
    else
    {
        return ModifyInstance(index);
    }
}

function IsRepeateConfig(RuleInfo)
{
    var i = 0;
    for(i = 0; i < QosSmartList.length-1; i++)
    {
        if (i != selIndex)
        {
            if ((QosSmartList[i].ClassInterface == RuleInfo.ClassInterface)
                && (QosSmartList[i].VLANIDCheck == RuleInfo.VLANIDCheck)
                && (QosSmartList[i].DestIP == RuleInfo.DestIP)
                && (QosSmartList[i].DestMask == RuleInfo.DestMask)
                && (QosSmartList[i].SourceIP == RuleInfo.SourceIP)
                && (QosSmartList[i].SourceMask == RuleInfo.SourceMask)
                && (QosSmartList[i].DestPort == RuleInfo.DestPort)
                && (QosSmartList[i].SourcePort == RuleInfo.SourcePort))
            {
                return true;
            }        
        }
    }
    return false;
}

function IPV6IpCheck(Address, Mask)
{
    if (Address != "")
    {
	    if (IsIPv6AddressValid(Address) == false || IsIPv6ZeroAddress(Address) == true || IsIPv6LoopBackAddress(Address) == true || IsIPv6MulticastAddress(Address) == true)
        {
            return 4;
        }
    }
    if ((Mask != '') && ( isValidIPV6SubnetMask(Mask) == false) )
    {            
        return 5;
    }
    return 6;
}

function IPV4IpCheck(Address, Mask)
{
    if(Address != "")
    {
        if ( isAbcIpAddress(Address) == false 
            || isDeIpAddress(Address) == true 
            || isBroadcastIpAddress(Address) == true 
            || isLoopIpAddress(Address) == true ) 
        {              	
            return 1;
        }
    }	 	  

    if ((Mask != '') && ( isValidSubnetMask(Mask) == false) )
    {            
        return 2;
    }

    return 3;
}



function IpValidCheck(RuleInfo)
{  
    var v4DipCheckRet = 0; 
    var v6DipCheckRet = 0; 
    if ((RuleInfo.DestIP == '') && (RuleInfo.DestMask == '') 
        && (RuleInfo.SourceIP == '') && (RuleInfo.SourceMask == ''))
    {
        return true;
    }
    
    if (((RuleInfo.DestIP == '') && (RuleInfo.DestMask != ''))
       || ((RuleInfo.SourceIP == '') && (RuleInfo.SourceMask != '')))
    {
        AlertEx(qos_L2smart_language['bbsp_ipneed']);
	    return false;
    }
    
    v4DipCheckRet = IPV4IpCheck(RuleInfo.DestIP, RuleInfo.DestMask );
    v6DipCheckRet = IPV6IpCheck(RuleInfo.DestIP, RuleInfo.DestMask);
    
    if ((RuleInfo.DestIP != '') && (3 != v4DipCheckRet) && (6 != v6DipCheckRet))
    {
        if ((1 == v4DipCheckRet) && (4 == v6DipCheckRet))
        {
            AlertEx(qos_L2smart_language['bbsp_ipaddress'] + RuleInfo.DestIP + qos_L2smart_language['bbsp_alert_invail']);
        }
        if (((2 == v4DipCheckRet) && (4 == v6DipCheckRet))
            ||((1 == v4DipCheckRet) && (5 == v6DipCheckRet)))
        {
            AlertEx(qos_L2smart_language['bbsp_mask'] + RuleInfo.DestMask + qos_L2smart_language['bbsp_alert_invail']);
        }
        
	    return false;
    }

	var v4SipCheckRet = 0;
	var v6SipCheckRet = 0;

	v4SipCheckRet = IPV4IpCheck(RuleInfo.SourceIP, RuleInfo.SourceMask );
    v6SipCheckRet = IPV6IpCheck(RuleInfo.SourceIP, RuleInfo.SourceMask);
    
    if ((RuleInfo.SourceIP != '')  && (3 != v4SipCheckRet) && (6 != v6SipCheckRet))
    {
        if ((1 == v4SipCheckRet) && (4 == v6SipCheckRet))
        {
            AlertEx(qos_L2smart_language['bbsp_ipaddress'] + RuleInfo.SourceIP + qos_L2smart_language['bbsp_alert_invail']);
        }
        if (((2 == v4SipCheckRet) && (4 == v6SipCheckRet))
            ||((1 == v4SipCheckRet) && (5 == v6SipCheckRet)))
        {
            AlertEx(qos_L2smart_language['bbsp_mask'] + RuleInfo.SourceMask + qos_L2smart_language['bbsp_alert_invail']);
        }
        
	    return false;
    }
    
    if ((RuleInfo.SourceIP != '') && (RuleInfo.DestIP != ''))
    {
        if ((3 == v4DipCheckRet ) && (6 == v6SipCheckRet))
        {
            AlertEx(qos_L2smart_language['bbsp_alert_ipaddr_v4_v6_not_match']);
	        return false;
        }

        if ((6 == v6DipCheckRet)  && (3 == v4SipCheckRet))
        {
            AlertEx(qos_L2smart_language['bbsp_alert_ipaddr_v4_v6_not_match']);
	        return false;
        } 
    } 
        
	return true;
}

function PortCheck(Protocol, StartPort, EndPort)
{	
	if ((StartPort == '') && (EndPort == ''))
	{
	    return true;
	}
	
	if ((Protocol != 6) && (Protocol != 17))
	{
	    AlertEx(qos_L2smart_language['bbsp_port_protocol_not_match']);
        return false;
	}
	
	if ((StartPort != "") && (false == CheckNumber(StartPort, 1, 65535)))
    {
        AlertEx(qos_L2smart_language['bbsp_port'] + StartPort + qos_L2smart_language['bbsp_alert_invail']);
        return false;
    }
    
    if ((EndPort != "") && (false == CheckNumber(EndPort, 1, 65535)))
    {
        AlertEx(qos_L2smart_language['bbsp_port'] + EndPort + qos_L2smart_language['bbsp_alert_invail']);
        return false;
    }
    
    if (parseInt(StartPort, 10) > parseInt(EndPort, 10))
    {
        AlertEx(qos_L2smart_language['bbsp_portrangeinvalid']);
        return false;
    }

	return true;
}

function EthertypeCheck(value)
{
    if (value == "")
    {
        return true;
    }

	if (value.charAt(0) != '0' || (value.charAt(1) != 'x' && value.charAt(1) != 'X'))
    {
        AlertEx(qos_L2smart_language['bbsp_qossmartethtype']+value+qos_L2smart_language['bbsp_qossmartethtypevalue']);
        return false;
    }

    for (var index = 2; index < value.length; index++)
    {
        if (isHexaDigit(value.charAt(index)) == false)
        {
            AlertEx(qos_L2smart_language['bbsp_qossmartethtype']+value+qos_L2smart_language['bbsp_qossmartethtypevalue']);
            return false;
        }
    }
    return true;
}


function CheckForm(RuleInfo)
{
  var FiltIndex = getSelectVal('OperationType');
 
  if(0 == FiltIndex)
  {
  	AlertEx(qos_L2smart_language['bbsp_qossmartoperationType']);
  	return false;
  }
	else if( 1 == FiltIndex)  
	{

		if (false == EthertypeCheck(RuleInfo.Ethertype))
		{
			return false;
		}
		
		if ((RuleInfo.EthernetPriorityCheck != "") && (false == CheckNumber(RuleInfo.EthernetPriorityCheck, 0, 7)))
		{
			AlertEx(qos_L2smart_language['bbsp_qossmart_invailvalue']);
			return false;
		}  
		

		if ((RuleInfo.SourceMACAddress != "") && (false == isValidMacAddress(RuleInfo.SourceMACAddress)) ) 
    {
        AlertEx(macfilter_language['bbsp_themac'] + RuleInfo.SourceMACAddress + macfilter_language['bbsp_macisinvalid']);
        return false;
    }
    

		if ((RuleInfo.DestMACAddress != "") && (false == isValidMacAddress(RuleInfo.DestMACAddress)) ) 
    {
        AlertEx(macfilter_language['bbsp_themac'] + RuleInfo.DestMACAddress + macfilter_language['bbsp_macisinvalid']);
        return false;
    }


		if(false == IpValidCheck(RuleInfo))
		{
		  return false;
		}
			

		if ((RuleInfo.SourcePort != "") && (false == CheckNumber(RuleInfo.SourcePort, 1, 65535)))
		{
		  AlertEx(qos_L2smart_language['bbsp_port'] + RuleInfo.SourcePort + qos_L2smart_language['bbsp_alert_invail']);
		  return false;
		}
		

		if ((RuleInfo.DestPort != "") && (false == CheckNumber(RuleInfo.DestPort, 1, 65535)))
		{
		  AlertEx(qos_L2smart_language['bbsp_port'] + RuleInfo.DestPort + qos_L2smart_language['bbsp_alert_invail']);
		  return false;
		}
		
 
		if ((RuleInfo.Protocol != "") && (false == CheckNumber(RuleInfo.Protocol, 0, 255)))
		{
		    AlertEx(qos_L2smart_language['bbsp_protocolidinvalid']);
		    return false;
		}
	}
	else if( 2 == FiltIndex)　
	{

		if (false == EthertypeCheck(RuleInfo.Ethertype))
		{
			return false;
		}
		

		if ((RuleInfo.VLANIDCheck != "") && (false == CheckNumber(RuleInfo.VLANIDCheck, 1, 4094)))
		{
		  AlertEx(qos_L2smart_language['bbsp_vlanidinvalid']);
		  return false;
		}
		

		if ((RuleInfo.SourceMACAddress != "") && (false == isValidMacAddress(RuleInfo.SourceMACAddress)) ) 
    {
        AlertEx(macfilter_language['bbsp_themac'] + RuleInfo.SourceMACAddress + macfilter_language['bbsp_macisinvalid']);
        return false;
    }
    

		if ((RuleInfo.DestMACAddress != "") && (false == isValidMacAddress(RuleInfo.DestMACAddress)) ) 
    {
        AlertEx(macfilter_language['bbsp_themac'] + RuleInfo.DestMACAddress + macfilter_language['bbsp_macisinvalid']);
        return false;
    }
		

		if ((RuleInfo.EthernetPriorityCheck != "") && (false == CheckNumber(RuleInfo.EthernetPriorityCheck, 0, 7)))
		{
			AlertEx(qos_L2smart_language['bbsp_qossmart_invailvalue']);
			return false;
		} 
		

		if ((RuleInfo.EthernetPriorityMark != "") && (false == CheckNumber(RuleInfo.EthernetPriorityMark, 0, 7)))
		{
			AlertEx(qos_L2smart_language['bbsp_qossmart_invailvalue']);
			return false;
		}   
		
	}
	else if(3 == FiltIndex)
	{

		if ((RuleInfo.EthernetPriorityCheck != "") && (false == CheckNumber(RuleInfo.EthernetPriorityCheck, 0, 7)))
		{
			AlertEx(qos_L2smart_language['bbsp_qossmart_invailvalue']);
			return false;
		} 
	}
	else if(4 == FiltIndex)　
	{

		if ((RuleInfo.EthernetPriorityMark != "") && (false == CheckNumber(RuleInfo.EthernetPriorityMark, 0, 7)))
		{
			AlertEx(qos_L2smart_language['bbsp_qossmart_invailvalue']);
			return false;
		}   
	}

    return true;
}

function FillupSubmitPara(Form, RuleInfo)
{
　　
	var FiltIndex = getSelectVal('OperationType');
	Form.addParameter('x.OperationType', FiltIndex);
	
	if(RuleInfo.ClassInterface.length)
	{
		Form.addParameter('x.ClassInterface', RuleInfo.ClassInterface);
	}
	else
	{
		Form.addParameter('x.ClassInterface', '');
	}
	
	if( 1 == FiltIndex)  
	{	
		if (!RuleInfo.Ethertype.length)
		{
			RuleInfo.Ethertype = -1;
		}	
    Form.addParameter('x.Ethertype', RuleInfo.Ethertype);
    
     if (!RuleInfo.Protocol.length)
    {
        RuleInfo.Protocol = -1;
    }
    Form.addParameter('x.Protocol', RuleInfo.Protocol);
    
    
    if(RuleInfo.SourceMACAddress.length)
		{
			Form.addParameter('x.SourceMACAddress', RuleInfo.SourceMACAddress);
		}
		else
		{
			Form.addParameter('x.SourceMACAddress', '');
		}
		
		if(RuleInfo.DestMACAddress.length)
		{
			Form.addParameter('x.DestMACAddress', RuleInfo.DestMACAddress);
		}
		else
		{
			Form.addParameter('x.DestMACAddress', '');
		}
	   
    if (RuleInfo.SourceIP.length)
    {
        Form.addParameter('x.SourceIP', RuleInfo.SourceIP);
    }
    else
    {
    	Form.addParameter('x.SourceIP', '');
    }
    if (RuleInfo.SourceMask.length)
    {
        Form.addParameter('x.SourceMask', RuleInfo.SourceMask);
    }
    else
    {
    	Form.addParameter('x.SourceMask', '');
    }
    
    if (RuleInfo.DestIP.length)
    {
        Form.addParameter('x.DestIP', RuleInfo.DestIP);
    } 
    else
    {
    	Form.addParameter('x.DestIP', '');
    }  
    if (RuleInfo.DestMask.length)
    {
        Form.addParameter('x.DestMask', RuleInfo.DestMask);
    }
    else
    {
    	Form.addParameter('x.DestMask', '');
    }
    
    if(!RuleInfo.EthernetPriorityCheck.length)
    {
        RuleInfo.EthernetPriorityCheck = -1;
    }
    Form.addParameter('x.EthernetPriorityCheck', RuleInfo.EthernetPriorityCheck);
    
    if(!RuleInfo.SourcePort.length)
    {
        RuleInfo.SourcePort = -1;
    }
    Form.addParameter('x.SourcePort', RuleInfo.SourcePort);
    
    if(!RuleInfo.DestPort.length)
    {
        RuleInfo.DestPort = -1;
    }
    Form.addParameter('x.DestPort', RuleInfo.DestPort);
    
        
    if(getSelectVal('BpduGarpFlag')== 0)
    {
    	 Form.addParameter('x.BpduGarpFlag', -1);
    }
    else
  	{
  		 Form.addParameter('x.BpduGarpFlag', getSelectVal('BpduGarpFlag'));
  	}
  	
  	if(getSelectVal('BpduCfmFlag')== 0)
    {
    	 Form.addParameter('x.BpduCfmFlag', -1);
    }
    else
  	{
  		Form.addParameter('x.BpduCfmFlag', getSelectVal('BpduCfmFlag'));    
  	}
    
    if(getSelectVal('MultiFlowFlag')== 0)
    {
    	 Form.addParameter('x.MultiFlowFlag', -1);
    }
    else
  	{
  		Form.addParameter('x.MultiFlowFlag',getSelectVal('MultiFlowFlag'));   
  	}
  	
   

    Form.addParameter('x.VLANIDCheck', -1);
    Form.addParameter('x.EthernetPriorityMark', -1);
	}
	else if(2 == FiltIndex)
	{
		if (!RuleInfo.Ethertype.length)
		{
			RuleInfo.Ethertype = -1;
		}	
    Form.addParameter('x.Ethertype', RuleInfo.Ethertype);
    
    if(RuleInfo.SourceMACAddress.length)
		{
			Form.addParameter('x.SourceMACAddress', RuleInfo.SourceMACAddress);
		}
		else
		{
			Form.addParameter('x.SourceMACAddress', '');
		}
		
		if(RuleInfo.DestMACAddress.length)
		{
			Form.addParameter('x.DestMACAddress', RuleInfo.DestMACAddress);
		}
		else
		{
			Form.addParameter('x.DestMACAddress', '');
		}
		
		if(!RuleInfo.VLANIDCheck.length)
    {
        RuleInfo.VLANIDCheck = -1;
    }
    Form.addParameter('x.VLANIDCheck', RuleInfo.VLANIDCheck);
    
    if(!RuleInfo.EthernetPriorityCheck.length)
    {
        RuleInfo.EthernetPriorityCheck = -1;
    }
    Form.addParameter('x.EthernetPriorityCheck', RuleInfo.EthernetPriorityCheck);
    
    if(!RuleInfo.EthernetPriorityMark.length)
    {
        RuleInfo.EthernetPriorityMark = -1;
    }
    Form.addParameter('x.EthernetPriorityMark', RuleInfo.EthernetPriorityMark);

    Form.addParameter('x.SourceIP', '');
    Form.addParameter('x.SourceMask', '');
    Form.addParameter('x.DestIP', '');
    Form.addParameter('x.DestMask', '');
    Form.addParameter('x.SourcePort', -1);
    Form.addParameter('x.DestPort', -1);
    Form.addParameter('x.Protocol', -1);
		Form.addParameter('x.BpduGarpFlag', -1);
		Form.addParameter('x.BpduCfmFlag', -1);
		Form.addParameter('x.MultiFlowFlag', -1);
			
	}
	else if(3 == FiltIndex)
	{
		if(!RuleInfo.EthernetPriorityCheck.length)
    {
        RuleInfo.EthernetPriorityCheck = -1;
    }
    Form.addParameter('x.EthernetPriorityCheck', RuleInfo.EthernetPriorityCheck);

    Form.addParameter('x.Ethertype', -1);
    Form.addParameter('x.VLANIDCheck', -1);
    Form.addParameter('x.EthernetPriorityMark', -1);
    Form.addParameter('x.SourceIP', '');
    Form.addParameter('x.SourceMask', '');
    Form.addParameter('x.DestIP', '');
    Form.addParameter('x.DestMask', '');
    Form.addParameter('x.SourcePort', -1);
    Form.addParameter('x.DestPort', -1);
    Form.addParameter('x.BpduGarpFlag', -1);
		Form.addParameter('x.BpduCfmFlag', -1);
		Form.addParameter('x.MultiFlowFlag', -1);
		Form.addParameter('x.Protocol', -1);
		
	}
	else if(4 == FiltIndex)
	{
		if(!RuleInfo.EthernetPriorityMark.length)
    {
        RuleInfo.EthernetPriorityMark = -1;
    }
    Form.addParameter('x.EthernetPriorityMark', RuleInfo.EthernetPriorityMark);

    Form.addParameter('x.Ethertype', -1);
    Form.addParameter('x.VLANIDCheck', -1);
    Form.addParameter('x.EthernetPriorityCheck', -1);
    Form.addParameter('x.SourceIP', '');
    Form.addParameter('x.SourceMask', '');
    Form.addParameter('x.DestIP', '');
    Form.addParameter('x.DestMask', '');
    Form.addParameter('x.SourcePort', -1);
    Form.addParameter('x.DestPort', -1);
    
    Form.addParameter('x.BpduGarpFlag', -1);
		Form.addParameter('x.BpduCfmFlag', -1);
		Form.addParameter('x.MultiFlowFlag', -1);
		Form.addParameter('x.Protocol', -1);
	}
        
}

function OnModifySubmit()
{
    var RuleInfo = GetInputRuleInfo();
    
    if (CheckForm(RuleInfo) == false)
    {
        return false;
    }
    
  
    var Form = new webSubmitForm();
    FillupSubmitPara(Form, RuleInfo);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));   
    Form.setAction('set.cgi?' +'x='+ QosSmartList[selIndex].Domain + '&RequestFile=html/bbsp/qosL2smart/qosL2smart.asp');
    Form.submit();

}


function OnAddNewSubmit()
{
    var RuleInfo = GetInputRuleInfo();
    if (CheckForm(RuleInfo) == false)
    {
        return false;
    }


    var Form = new webSubmitForm();
    FillupSubmitPara(Form, RuleInfo);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('add.cgi?' +'x=InternetGatewayDevice.X_HW_SpecialPacket' + '&RequestFile=html/bbsp/qosL2smart/qosL2smart.asp');
    Form.submit();   
    DisableRepeatSubmit();
}

function clickRemove() 
{
    var CheckBoxList = document.getElementsByName("rml");
    var Count = 0;
    var i;
    for (i = 0; i < CheckBoxList.length; i++)
    {
        if (CheckBoxList[i].checked == true)
        {
            Count++;
        }
    }

    if (Count == 0)
    {
        return false;
    }

    var Form = new webSubmitForm();
    for (i = 0; i < CheckBoxList.length; i++)
    {
        if (CheckBoxList[i].checked != true)
        {
            continue;
        }

        Form.addParameter(CheckBoxList[i].value,'');
    }
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('del.cgi?' +'x=InternetGatewayDevice.X_HW_SpecialPacket' + '&RequestFile=html/bbsp/qosL2smart/qosL2smart.asp');
    Form.submit();
}


function OnApply()
{
    if (OperatorFlag == 1)
    {
        return OnAddNewSubmit();
    }
    else
    {
        return OnModifySubmit();
    }
}

function OnCancel()
{
    setDisplay('TableConfigInfo', 0);
    if (selIndex == -1)
    {
         var tableRow = getElementById("xxxInst");
         if (tableRow.rows.length > 2)
         tableRow.deleteRow(tableRow.rows.length-1);
         return false;
     }
}


function FrameFiltChange()
{
	var FiltIndex = getSelectVal('OperationType');
	if( 1 == FiltIndex)
	{
		 setDisplay('showEthertype', 1);
		 setDisplay('showSourceMac', 1);
		 setDisplay('showDestMac', 1);
		 setDisplay('showVlan', 0);
		 setDisplay('showSourceIP', 1);
		 setDisplay('showDestIP', 1);
		 setDisplay('showPriorityMark', 1);
		 setDisplay('showPriorityCover', 0);
		 setDisplay('showSourceL4Port', 1);
		 setDisplay('showDestL4Port', 1);
		 setDisplay('showGARPAppAddress', 1);
		 setDisplay('showCFMAddress', 1);
		 setDisplay('showFiltMulticastStream', 1);
		 setDisplay('showProtocol', 1);
		 document.getElementById("Priorityflgs").innerHTML = qos_L2smart_language['bbsp_Priorityflgs'];
		
    
	}
	else if( 2 == FiltIndex)
	{
		 setDisplay('showEthertype', 1);
		 setDisplay('showSourceMac', 1);
		 setDisplay('showDestMac', 1);
		 setDisplay('showVlan', 1);
		 setDisplay('showSourceIP', 0);
		 setDisplay('showDestIP', 0);
		 setDisplay('showPriorityMark', 1);
		 setDisplay('showPriorityCover', 1);
		
		 setDisplay('showSourceL4Port', 0);
		 setDisplay('showDestL4Port', 0);
		 setDisplay('showGARPAppAddress', 0);
		 setDisplay('showCFMAddress', 0);
		 setDisplay('showFiltMulticastStream', 0);
		 setDisplay('showProtocol', 0);
		 document.getElementById("Priorityflgs").innerHTML = qos_L2smart_language['bbsp_Priorityflgs'];
		 document.getElementById("PriorityMarkflgs").innerHTML = qos_L2smart_language['bbsp_PriorityMarkflgs'];
		
	}
	else if( 3 == FiltIndex)
	{
		 setDisplay('showEthertype', 0);
		 setDisplay('showSourceMac', 0);
		 setDisplay('showDestMac', 0);
		 setDisplay('showVlan', 0);
		 setDisplay('showSourceIP', 0);
		 setDisplay('showDestIP', 0);
		 setDisplay('showPriorityMark', 1);
		
		 setDisplay('showPriorityCover', 0);
		
		 setDisplay('showSourceL4Port', 0);
		 setDisplay('showDestL4Port', 0);
		 setDisplay('showGARPAppAddress', 0);
		 setDisplay('showCFMAddress', 0);
		 setDisplay('showFiltMulticastStream', 0);
		 setDisplay('showProtocol', 0);
		 document.getElementById("Priorityflgs").innerHTML = qos_L2smart_language['bbsp_Priorityfilts'];
	}
	else if( 4 == FiltIndex)
	{
		 setDisplay('showEthertype', 0);
		 setDisplay('showSourceMac', 0);
		 setDisplay('showDestMac', 0);
		 setDisplay('showVlan', 0);
		 setDisplay('showSourceIP', 0);
		 setDisplay('showDestIP', 0);
		 setDisplay('showPriorityMark', 0);
		 setDisplay('showPriorityCover', 1);
		
		 setDisplay('showSourceL4Port', 0);
		 setDisplay('showDestL4Port', 0);
		 setDisplay('showGARPAppAddress', 0);
		 setDisplay('showCFMAddress', 0);
		 setDisplay('showFiltMulticastStream', 0);
		 setDisplay('showProtocol', 0);
		 document.getElementById("PriorityMarkflgs").innerHTML = qos_L2smart_language['bbsp_Prioritycover'];
	}
   
}

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<form id="ConfigForm"> 
  <table width="100%" border="0" cellpadding="0" cellspacing="0" id="tabTest"> 
    <tr> 
      <td class="prompt"> <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
          <tr> 
            <td class="title_common" BindText='bbsp_qos_L2_smart_title'></td> 
          </tr> 
      </table></td> 
    </tr> 
    <tr> 
      <td class="height5p"></td> 
    </tr> 
  </table> 

<script language="JavaScript" type="text/javascript">
    writeTabCfgHeader('aaa','100%');
</script> 
<table class="tabal_bg" id="xxxInst" width="100%" cellspacing="1"> 
    <tr id="titleList"  class="head_title"> 
      <td class="width_per3">&nbsp;</td> 
      <td BindText='bbsp_qossmartclassinterface'></td>
      <td BindText='bbsp_qosL2smartethtype'></td>  
      <td BindText='bbsp_qossmartprotocol'></td>   
      <td BindText='bbsp_qosL2smartsrcmac'></td>  
      <td BindText='bbsp_qosL2smartdestmac'></td>
      <td BindText='bbsp_qossmartvlan'></td>  
      <td BindText='bbsp_qossmartsrcip'></td>  
      <td BindText='bbsp_qossmartdestip'></td>  
      <td BindText='bbsp_qosL2smartPriorityflgs'></td>
      <td BindText='bbsp_qosL2smartPriorityfilt'></td>
      <td BindText='bbsp_qosL2smartPrioritycover'></td>
      <td BindText='bbsp_qossmartpbitmark'></td> 
      <td BindText='bbsp_qosL2smartsrcL4port'></td>  
      <td BindText='bbsp_qosL2smartdestL4port'></td>          
                 
    </tr> 
    <script>    
    document.write(UpdateUI(QosSmartList));
    </script> 
  </table> 
  
<div id="TableConfigInfo"> 

    <table class="tabal_bg tabCfgArea" border="0" cellpadding="0" cellspacing="1"  width="100%">
		<tr>
			<td  class="table_title align_left width_per15" id='bbsp_qossmarttesttype'>
				<script language="JavaScript"> 
				document.write(appendPrompt('bbsp_qosL2smarttesttype'));
				</script>
			</td> 
			<td class="table_right">
				<select id="OperationType" onChange="FrameFiltChange();" style="width:200px">
			  <script language="JavaScript" type="text/javascript">
			  document.write('<option value="0"></option>');
				document.write('<option value="1">' + qos_L2smart_language['bbsp_qosL2smartFrameFilt'] + '</option>');
				document.write('<option value="2">' + qos_L2smart_language['bbsp_qosL2smartupward_primark'] + '</option>');
				document.write('<option value="3">' + qos_L2smart_language['bbsp_qosL2smartupward_filt'] + '</option>');
				document.write('<option value="4">' + qos_L2smart_language['bbsp_qosL2smartupward_cover'] + '</option>');
			</script>
			</select>
			</td>
		</tr>
     
    <tr>
        <td  class="table_title align_left width_per25" id='bbsp_qossmartclassinterface'>
           <script language"JavaScript"> 
		        document.write(appendPrompt('bbsp_qossmartclassinterface'));
		    </script>
        </td> 
        <td class="table_right">
          <select id='ClassInterface' style="width:126px" name='ClassInterface'> 
            </select>
        </td>
    </tr>
     
    <tr id="showEthertype">
        <td  class="table_title align_left width_per25" id='bbsp_qossmartEthertype'> 
            <script language="JavaScript"> 
		        document.write(appendPrompt('bbsp_qosL2smartethtype'));
		    </script>
        </td> 
        <td class="table_right">
          <input type=text id="Ethertype" style="width:120px" /> 
         
        </td>
    </tr> 
    
 <tr id="showProtocol">
    <td  class="table_title align_left width_per25" id='bbsp_qossmartprotocol'>
        <script language="JavaScript"> 
        document.write(appendPrompt('bbsp_qossmartprotocol'));
    </script>
    </td> 
    <td class="table_right">
      <input type=text id="Protocol" size='46'  maxlength=3 style="width:120px" /> 
      <span class="gray">(0~255)</span>
    </td>
    <script LANGUAGE="JavaScript"> 
    getElById("Protocol").title = qos_L2smart_language['bbsp_protocol_title'];
</script>
</tr>  

     <tr id="showSourceMac">
        <td  class="table_title align_left width_per25" id='bbsp_qossmartSourceMac'>
            <script language="JavaScript"> 
		        document.write(appendPrompt('bbsp_qosL2smartsrcmac'));
		    </script>
        </td> 
        <td class="table_right">
          <input type=text id="SourceMACAddress" style="width:120px"/> 
          
        </td>
        <script language="JavaScript"> 

		</script>
    </tr>  
    <tr id="showDestMac">
        <td  class="table_title align_left width_per25" id='bbsp_qossmartDestMac'>
            <script language="JavaScript"> 
		        document.write(appendPrompt('bbsp_qosL2smartdestmac'));
		    </script>
        </td> 
        <td class="table_right">
          <input type=text id="DestMACAddress" style="width:120px"/> 
          
        </td>
        <script language="JavaScript"> 

		</script>
    </tr>
    
    <tr id="showVlan">
        <td class="table_title align_left width_per15" id='bbsp_qossmartVlan'> 
            <script language="JavaScript"> 
		        document.write(appendPrompt('bbsp_qossmartvlan'));
		    </script>
        </td> 
        <td class="table_right">
          <input type='text' id="VLANIDCheck"  style="width:120px" maxlength=4 /> 
          <span class="gray">(1~4094)</span>
        </td>
    </tr>
       
     <tr id="showSourceIP">
        <td  class="table_title align_left width_per25" id='bbsp_qossmartsrcipmask'>
            <script language="JavaScript"> 
		        document.write(appendPrompt('bbsp_qossmartsrcipmask'));
		    </script>
        </td> 
        <td class="table_right">
          <input type=text id="SourceIP" style="width:120px" maxlength=64/> 
          &nbsp; / &nbsp;&nbsp;<input type=text id="SourceMask" style="width:120px" maxlength=64/> 
        </td>
    </tr>     
      
    <tr id="showDestIP">
        <td  class="table_title align_left width_per25" id='bbsp_qossmartdestipmask'>
            <script language="JavaScript"> 
		        document.write(appendPrompt('bbsp_qossmartdestipmask'));
		    </script>
        </td> 
        <td class="table_right">
          <input type=text id="DestIP" style="width:120px" maxlength=64/> 
          &nbsp; / &nbsp;&nbsp;<input type=text id="DestMask" style="width:120px" maxlength=64/> 
        </td>
    </tr>
      
    <tr id="showPriorityMark"> 
      <td class="table_title align_left width_per15" id='bbsp_qossmarPriorityMark'>
      	<span id="Priorityflgs">
      		<script language="JavaScript"> 
		        document.write(appendPrompt('bbsp_qosL2smartPriorityflgs'));
		    </script>
      		</span>   
      </td> 
      <td class="table_right">      
      <input type=text id="EthernetPriorityCheck" style="width:120px" /> 
        <span class="gray">(0~7)</span>  
      </td> 
    </tr>
      
    <tr id="showPriorityCover"> 
      <td class="table_title align_left width_per15" id='bbsp_qossmarPriorityCover'>
      	<span id="PriorityMarkflgs">
      		<script language="JavaScript"> 
		        document.write(appendPrompt('bbsp_qossmartpbitmark'));
		    </script>
      		</span>         
      </td> 
      <td class="table_right">      
      <input type=text id="EthernetPriorityMark" style="width:120px" /> 
      <span class="gray">(0~7)</span> 
      </td> 
    </tr>          
      
      <tr id="showSourceL4Port"> 
      <td class="table_title align_left width_per15" id='bbsp_qossmarSourceL4Port'>
            <script language="JavaScript"> 
		        document.write(appendPrompt('bbsp_qosL2smartsrcL4port'));
		    </script>
      </td> 
      <td class="table_right">      
      <input type=text id="SourcePort" style="width:120px"/> 
      </td> 
    </tr> 
     <tr id="showDestL4Port"> 
      <td class="table_title align_left width_per25" id='bbsp_qossmarDestL4Port'>
            <script language="JavaScript"> 
		        document.write(appendPrompt('bbsp_qosL2smartdestL4port'));
		    </script>
      </td> 
      <td class="table_right">      
      <input type=text id="DestPort" style="width:120px"/> 
      </td> 
    </tr>
            
		<tr id="showGARPAppAddress">
			<td  class="table_title align_left width_per15" id='bbsp_qossmartGARPAppAddress'>
				<script language="JavaScript"> 
				document.write(appendPrompt('bbsp_qosL2smartBpduGarpFlag'));
				</script>
			</td> 
			<td class="table_right">
				<select id="BpduGarpFlag" style="width:126px">
			  <script language="JavaScript" type="text/javascript">
			  document.write('<option value="0"></option>');
				document.write('<option value="1">' + 'Block' + '</option>');
				document.write('<option value="2">' + 'Forward' + '</option>');
				
			</script>
			</select>
			</td>
		</tr>
		<tr id="showCFMAddress">
			<td  class="table_title align_left width_per25" id='bbsp_qossmartCFMAddress'>
				<script language="JavaScript"> 
				document.write(appendPrompt('bbsp_qosL2smartBpduCfmFlag'));
				</script>
			</td> 
			<td class="table_right">
				<select id="BpduCfmFlag" style="width:126px">
			  <script language="JavaScript" type="text/javascript">
			  document.write('<option value="0"></option>');
				document.write('<option value="1">' + 'Block' + '</option>');
				document.write('<option value="2">' + 'Forward' + '</option>');
				
			</script>
			</select>
			</td>
		</tr> 
		<tr id="showFiltMulticastStream"> 
      <td class="table_title align_left width_per25" id='bbsp_qossmartFiltMulticastStream'>
      	<script language="JavaScript"> 
				document.write(appendPrompt('bbsp_qosL2smartMultiFlowFlag'));
				</script>   	
      	</td> 
      <td class="table_title"> 
      	<select id="MultiFlowFlag" style="width:126px">
			  <script language="JavaScript" type="text/javascript">
			  document.write('<option value="0"></option>');
				document.write('<option value="1">' + 'Block' + '</option>');
				document.write('<option value="2">' + 'Forward' + '</option>');
				
			</script>
			</select> 
      </td> 
    </tr>  
		
    </table>
    <table id ="SubmitTable" width="100%"  cellspacing="1" class="table_button"> 
      <tr> 
        <td class="width_per15"></td> 
        <td class="table_submit pad_left5p">
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
		　　<button id='Apply' type=button onclick = "javascript:return OnApply();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(qos_L2smart_language['bbsp_qossmartapp']);</script></button>
          	<button id='Cancel' type=button onclick="javascript:OnCancel();" class="CancleButtonCss buttonwidth_100px"><script>document.write(qos_L2smart_language['bbsp_qossmartcancel']);</script></button> 
		</td> 
      </tr> 
    </table>  
  </div> 
   
</form> 
</body>
</html>
