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
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">

var MaxQosSmartRule = 64;
var OperatorFlag = 0;
var selIndex = -1;
var EthNumMax = 4;
var ReMarkModeNum = 0;
var DisplayControl = <% HW_WEB_GetFeatureSupport(BBSP_FT_MODIFY_PRI_OR_TC);%>;


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
    return qos_smart_language[filedName]+qos_smart_language['bbsp_qosPrompt'];
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
		b.innerHTML = qos_smart_language[b.getAttribute("BindText")];
	}
}

function SubmitEnableForm()
{ 
    var Form = new webSubmitForm();
    
    var Enable = getElById("QosSmartEnableValue").checked;
    if (Enable == true)
    {
        Form.addParameter('x.X_HW_ClassificationEnable',1); 
    }
    else
    {
        Form.addParameter('x.X_HW_ClassificationEnable',0); 
    }
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('set.cgi?x=InternetGatewayDevice.QueueManagement'
                        + '&RequestFile=html/bbsp/qossmart/qossmart.asp');
    Form.submit();     
}

function TopoInfo(Domain, EthNum, SSIDNum)
{   
    this.Domain = Domain;
    this.EthNum = EthNum;
    this.SSIDNum = SSIDNum;
}

function QosSmartEnableInfo(_Domain, _QosSmartEnableValue)
{
    this.Domain = _Domain;
    
	this.QosSmartEnableValue = _QosSmartEnableValue;
	
}

function QosSmartItem(_Domain, _ClassInterface, _DomainName, _DestIP, _DestMask, _SourceIP, _SourceMask, _Protocol, _DestPort, _DestPortRangeMax, _SourcePort, _SourcePortRangeMax, _DSCPMark, _VLANIDCheck, _TRAFFIC, _PRIMARK, _TRAFFICMARK)
{
	this.Domain = _Domain;
    this.ClassInterface = LanDomain2LanName(_ClassInterface);
    this.QosSmartDomain = _DomainName;
    this.DestIP = _DestIP;
    this.DestMask = _DestMask;
    this.SourceIP = _SourceIP;
    this.SourceMask = _SourceMask;
    this.Protocol = _Protocol;
    this.DestPort = _DestPort;
    this.DestPortRangeMax = _DestPortRangeMax;
    this.SourcePort = _SourcePort;
    this.SourcePortRangeMax = _SourcePortRangeMax;    
    this.DSCPMark = _DSCPMark;
    this.VLANIDCheck = _VLANIDCheck;
    this.TRAFFIC = _TRAFFIC;
    this.TRAFFICMARK = _TRAFFICMARK;
    this.PRIMARK = _PRIMARK;
}

var QosSmartList = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaQosSmart,InternetGatewayDevice.QueueManagement.X_HW_Classification.{i},ClassInterface|DomainName|DestIP|DestMask|SourceIP|SourceMask|Protocol|DestPort|DestPortRangeMax|SourcePort|SourcePortRangeMax|DSCPMark|VLANIDCheck|TRAFFIC|PRIMARK|TRAFFICMARK, QosSmartItem);%>  
var QosSmartEnable = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.QueueManagement, X_HW_ClassificationEnable, QosSmartEnableInfo);%>
var QosSmartEn = QosSmartEnable[0];
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

function ReMarkModeNum2ReMarkModeName(QosSmartItem)
{
	if (-1 == QosSmartItem.PRIMARK || '' == QosSmartItem.PRIMARK)
	{
		return qos_smart_language['bbsp_qossmarttcremark'];
	}
	else
	{
		return qos_smart_language['bbsp_qossmartprimark'];
	}
}

function ReMarkModeInitOption()
{
	var ReMarkModeList = getElementById('ReMarkMode');

	ReMarkModeList.options.add(new Option(qos_smart_language['bbsp_qossmarttcremark'], '0'));
	ReMarkModeList.options.add(new Option(qos_smart_language['bbsp_qossmartprimark'], '1'));
}

function LoadSmartEnable()
{    
	var enable = QosSmartEn.QosSmartEnableValue;
		
	if (enable == true)
    {
        getElById("QosSmartEnableValue").checked = true;
    }
	else
	{
	    getElById("QosSmartEnableValue").checked = false;
	}
}

function paraCompensate ()
{
	var i = 0;
	var RecordCount = QosSmartList.length - 1;
	for(i = 0; i < RecordCount; i ++)
	{
	    QosSmartList[i].QosSmartDomain = (QosSmartList[i].QosSmartDomain == '-1')?'':QosSmartList[i].QosSmartDomain;
		QosSmartList[i].Protocol = (QosSmartList[i].Protocol == '-1')?'':QosSmartList[i].Protocol;
	    QosSmartList[i].DestPort = (QosSmartList[i].DestPort == '-1')?'':QosSmartList[i].DestPort;
	    QosSmartList[i].DestPortRangeMax = (QosSmartList[i].DestPortRangeMax == '-1')?'':QosSmartList[i].DestPortRangeMax;
	    QosSmartList[i].SourcePort = (QosSmartList[i].SourcePort == '-1')?'':QosSmartList[i].SourcePort;
	    QosSmartList[i].SourcePortRangeMax = (QosSmartList[i].SourcePortRangeMax == '-1')?'':QosSmartList[i].SourcePortRangeMax;    
	    QosSmartList[i].VLANIDCheck = (QosSmartList[i].VLANIDCheck == '-1')?'':QosSmartList[i].VLANIDCheck;
	    QosSmartList[i].TRAFFIC = ('-1' == QosSmartList[i].TRAFFIC) ? '' : QosSmartList[i].TRAFFIC;
	    QosSmartList[i].PRIMARK = ('-1' == QosSmartList[i].PRIMARK) ? '' : QosSmartList[i].PRIMARK;
	    QosSmartList[i].TRAFFICMARK = ('-1' == QosSmartList[i].TRAFFICMARK) ? '' : QosSmartList[i].TRAFFICMARK;
	}
}
	

function LoadFrame()
{	
    ClassInterfaceInitOption();
    ReMarkModeInitOption()
	loadlanguage();	
	
	Get802dot1pByDSCP();
	
	setDisable('PRIMark', 1);
	LoadSmartEnable();
	paraCompensate();
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

function PortDisp(StartPort, EndPort)
{
    var defaultStr = '--';
    var novalue = '';
    if (novalue == StartPort && novalue == EndPort)
    {
        return defaultStr;
    }
    if (novalue != StartPort && novalue != EndPort) 
    {
        return StartPort + '-' + EndPort;
    }
    return (StartPort == novalue)? EndPort:StartPort;
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
        if (DisplayControl)
        {
			HtmlCode += '<TD>--</TD>';
        	HtmlCode += '<TD>--</TD>';
        	HtmlCode += '<TD>--</TD>';
        	HtmlCode += '<TD>--</TD>';
        }
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
    	
    	if ('' != QosSmartList[i].VLANIDCheck)
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + QosSmartList[i].VLANIDCheck + '</TD>'; 
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
    	
    	if ('' != QosSmartList[i].DestIP)
    	{  	
    	    HtmlCode += '<TD class="restrict_dir_ltr" id = "RecordDestIP'+i+ '" title = "' + QosSmartList[i].DestIP + '/' + QosSmartList[i].DestMask + '">' 
    	               + ShortFormatStr(QosSmartList[i].DestIP) + '/<br>' + ShortFormatStr(QosSmartList[i].DestMask) + '</TD>'; 
    	}
    	else
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
    	}
    	
    	if ('' != QosSmartList[i].SourceIP)
    	{       	    
    	    HtmlCode += '<TD class="restrict_dir_ltr" id = "RecordDestIP'+i+ '" title = "' + QosSmartList[i].SourceIP + '/' + QosSmartList[i].SourceMask + '">' 
    	                + ShortFormatStr(QosSmartList[i].SourceIP) + '/<br>' + ShortFormatStr(QosSmartList[i].SourceMask) + '</TD>'; 
    	}
    	else
    	{
    	    HtmlCode += '<TD  id = \"RecordClassInterface'+i+'\">' + '--' + '</TD>'; 
    	} 
    	
        HtmlCode += '<TD  id = \"RecordDestPort'+i+'\">' + PortDisp(QosSmartList[i].DestPort, QosSmartList[i].DestPortRangeMax) + '</TD>';        
        HtmlCode += '<TD  id = \"RecordSourcePort'+i+'\">' + PortDisp(QosSmartList[i].SourcePort, QosSmartList[i].SourcePortRangeMax) + '</TD>';
        HtmlCode += '<TD  id = \"RecordDSCPMark'+i+'\">' + QosSmartList[i].DSCPMark + '</TD>';
        HtmlCode += '<TD  id = \"RecordDSCPMark'+i+'\">' + (QosSmartList[i].DSCPMark>>3) + '</TD>';
        if (DisplayControl)
        {
        	HtmlCode += '<TD  id = \"RecordTCMark'+i+'\">' + QosSmartList[i].TRAFFIC + '</TD>';
        	HtmlCode += '<TD  id = \"RecordReMarkMode'+i+'\">' + ReMarkModeNum2ReMarkModeName(QosSmartList[i]) + '</TD>';
        	if (-1 == QosSmartList[i].PRIMARK || '' == QosSmartList[i].PRIMARK)
        	{
        		HtmlCode += '<TD  id = \"RecordTCReMark'+i+'\">' + QosSmartList[i].TRAFFICMARK + '</TD>';
        		HtmlCode += '<TD  id = \"RecordPriMark'+i+'\">' + '--' + '</TD>';
        	}
        	else
        	{
        		HtmlCode += '<TD  id = \"RecordTCReMark'+i+'\">' + '--' + '</TD>';
        		HtmlCode += '<TD  id = \"RecordPriMark'+i+'\">' + QosSmartList[i].PRIMARK + '</TD>';	
			}
        }
    	HtmlCode += '</TR>';
    }
    return HtmlCode;

}



function GetInputRuleInfo()
{
 var qosSmartItem = new QosSmartItem("",getSelectVal("ClassInterface"), getValue("QosSmartDomainId"),getValue("DestIP"),
                                     getValue("DestMask"),getValue("SourceIP"),getValue("SourceMask"),
                                     getValue("Protocol"), getValue("DestPort"),getValue("DestPortRangeMax"),
                                     getValue("SourcePort"), getValue("SourcePortRangeMax"),
                                     getValue("DSCPMark"),getValue("VLANIDCheck"),
                                     getValue("TcMark"),
                                     getValue("TcPriMark"), getValue("TcReMark")); 

 return qosSmartItem;
}

function SetInputRuleInfo(QosSmartItem)
{
    setSelect("ClassInterface", LanName2LanDomain(QosSmartItem.ClassInterface)); 
    setText("DestIP", QosSmartItem.DestIP);
    setText("DestMask", QosSmartItem.DestMask);
    setText("SourceIP", QosSmartItem.SourceIP);
    setText("SourceMask", QosSmartItem.SourceMask);
    setText("QosSmartDomainId", QosSmartItem.QosSmartDomain);
    setText("Protocol", QosSmartItem.Protocol);
    setText("DestPort", QosSmartItem.DestPort);
    setText("DestPortRangeMax", QosSmartItem.DestPortRangeMax);
    setText("SourcePort", QosSmartItem.SourcePort);
    setText("SourcePortRangeMax", QosSmartItem.SourcePortRangeMax);
    setText("DSCPMark", QosSmartItem.DSCPMark);
    Get802dot1pByDSCP();
    setText("VLANIDCheck", QosSmartItem.VLANIDCheck);
    setText("TcMark", QosSmartItem.TRAFFIC);
    setSelect("ReMarkMode", ((-1 == QosSmartItem.PRIMARK || '' == QosSmartItem.PRIMARK ) ? 0 : 1));
    setText("TcReMark", QosSmartItem.TRAFFICMARK);
    setText("TcPriMark", QosSmartItem.PRIMARK);
}

function ReMarkModeChange()
{
	var ReMarkModeVal = getSelectVal('ReMarkMode');

	if (0 == ReMarkModeVal)
	{
		document.getElementById("bbsp_qossmarttcremark_tr").style.display = "";
		document.getElementById("bbsp_qossmartprimark_tr").style.display = "none";
	}
	else if (1 == ReMarkModeVal)
	{
		document.getElementById("bbsp_qossmarttcremark_tr").style.display = "none";
		document.getElementById("bbsp_qossmartprimark_tr").style.display = "";	
	}
}

function OnNewInstance(index)
{
   OperatorFlag = 1;

   var qossmartitem = new QosSmartItem("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "");
   document.getElementById("TableConfigInfo").style.display = "block";

  if (!DisplayControl)
  {
    document.getElementById("bbsp_qossmarttcmark_tr").style.display = "none";
    document.getElementById("bbsp_qossmartprimark_tr").style.display = "none";
    document.getElementById("bbsp_qossmarttcremark_tr").style.display = "none";
    document.getElementById("bbsp_qossmartremarkmode_tr").style.display = "none";
  }
  else
  {
    document.getElementById("bbsp_qossmartprimark_tr").style.display = "none";
    document.getElementById("bbsp_qossmarttcremark_tr").style.display = "";
  }

   SetInputRuleInfo(qossmartitem);
}

function ModifyInstance(index)
{
    OperatorFlag = 2;

    document.getElementById("TableConfigInfo").style.display = "block";
	if (!DisplayControl)
	{
   		document.getElementById("bbsp_qossmarttcmark_tr").style.display = "none";
   		document.getElementById("bbsp_qossmartprimark_tr").style.display = "none";
   		document.getElementById("bbsp_qossmarttcremark_tr").style.display = "none";
   		document.getElementById("bbsp_qossmartremarkmode_tr").style.display = "none";
	}
	else if (-1 == QosSmartList[index].PRIMARK || '' == QosSmartList[index].PRIMARK)
	{
		document.getElementById("bbsp_qossmartprimark_tr").style.display = "none";
		document.getElementById("bbsp_qossmarttcremark_tr").style.display = "";
	}
	else
	{
		document.getElementById("bbsp_qossmarttcremark_tr").style.display = "none";
		document.getElementById("bbsp_qossmartprimark_tr").style.display = "";	
	}
    SetInputRuleInfo(QosSmartList[index]);
}

function setControl(index)
{ 
    if (-1 == index)
    {
        if (QosSmartList.length-1 == MaxQosSmartRule)
        {
            var tableRow = getElementById("xxxInst");
            tableRow.deleteRow(tableRow.rows.length-1);
            AlertEx(qos_smart_language['bbsp_qossmartfull']);
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
                && (QosSmartList[i].QosSmartDomain == RuleInfo.QosSmartDomain)
                && (QosSmartList[i].Protocol == RuleInfo.Protocol)
                && (QosSmartList[i].DestIP == RuleInfo.DestIP)
                && (QosSmartList[i].DestMask == RuleInfo.DestMask)
                && (QosSmartList[i].SourceIP == RuleInfo.SourceIP)
                && (QosSmartList[i].SourceMask == RuleInfo.SourceMask)
                && (QosSmartList[i].DestPort == RuleInfo.DestPort)
                && (QosSmartList[i].DestPortRangeMax == RuleInfo.DestPortRangeMax)
                && (QosSmartList[i].SourcePort == RuleInfo.SourcePort)
                && (QosSmartList[i].SourcePortRangeMax == RuleInfo.SourcePortRangeMax))
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
        AlertEx(qos_smart_language['bbsp_ipneed']);
	    return false;
    }
    
    v4DipCheckRet = IPV4IpCheck(RuleInfo.DestIP, RuleInfo.DestMask );
    v6DipCheckRet = IPV6IpCheck(RuleInfo.DestIP, RuleInfo.DestMask);
    
    if ((RuleInfo.DestIP != '') && (3 != v4DipCheckRet) && (6 != v6DipCheckRet))
    {
        if ((1 == v4DipCheckRet) && (4 == v6DipCheckRet))
        {
            AlertEx(qos_smart_language['bbsp_ipaddress'] + RuleInfo.DestIP + qos_smart_language['bbsp_alert_invail']);
        }
        if (((2 == v4DipCheckRet) && (4 == v6DipCheckRet))
            ||((1 == v4DipCheckRet) && (5 == v6DipCheckRet)))
        {
            AlertEx(qos_smart_language['bbsp_mask'] + RuleInfo.DestMask + qos_smart_language['bbsp_alert_invail']);
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
            AlertEx(qos_smart_language['bbsp_ipaddress'] + RuleInfo.SourceIP + qos_smart_language['bbsp_alert_invail']);
        }
        if (((2 == v4SipCheckRet) && (4 == v6SipCheckRet))
            ||((1 == v4SipCheckRet) && (5 == v6SipCheckRet)))
        {
            AlertEx(qos_smart_language['bbsp_mask'] + RuleInfo.SourceMask + qos_smart_language['bbsp_alert_invail']);
        }
        
	    return false;
    }
    
    if ((RuleInfo.SourceIP != '') && (RuleInfo.DestIP != ''))
    {
        if ((3 == v4DipCheckRet ) && (6 == v6SipCheckRet))
        {
            AlertEx(qos_smart_language['bbsp_alert_ipaddr_v4_v6_not_match']);
	        return false;
        }

        if ((6 == v6DipCheckRet)  && (3 == v4SipCheckRet))
        {
            AlertEx(qos_smart_language['bbsp_alert_ipaddr_v4_v6_not_match']);
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
	    AlertEx(qos_smart_language['bbsp_port_protocol_not_match']);
        return false;
	}
	
	if ((StartPort != "") && (false == CheckNumber(StartPort, 1, 65535)))
    {
        AlertEx(qos_smart_language['bbsp_port'] + StartPort + qos_smart_language['bbsp_alert_invail']);
        return false;
    }
    
    if ((EndPort != "") && (false == CheckNumber(EndPort, 1, 65535)))
    {
        AlertEx(qos_smart_language['bbsp_port'] + EndPort + qos_smart_language['bbsp_alert_invail']);
        return false;
    }
    
    if (parseInt(StartPort, 10) > parseInt(EndPort, 10))
    {
        AlertEx(qos_smart_language['bbsp_portrangeinvalid']);
        return false;
    }

	return true;
}

function CheckForm(RuleInfo)
{

	if ((RuleInfo.VLANIDCheck != "") && (false == CheckNumber(RuleInfo.VLANIDCheck, 1, 4094)))
    {
        AlertEx(qos_smart_language['bbsp_vlanidinvalid']);
        return false;
    }

	if ((RuleInfo.QosSmartDomain != "") && (false == CheckDomainNameWithWildcard(RuleInfo.QosSmartDomain)))
    {
        AlertEx(qos_smart_language['bbsp_domaininvalid']);
        return false;
    }
 
	if ((RuleInfo.Protocol != "") && (false == CheckNumber(RuleInfo.Protocol, 0, 255)))
    {
        AlertEx(qos_smart_language['bbsp_protocolidinvalid']);
        return false;
    }

	if(false == IpValidCheck(RuleInfo))
	{
        return false;
    }
    

	if(false == PortCheck(RuleInfo.Protocol, RuleInfo.DestPort, RuleInfo.DestPortRangeMax))
    {
        return false;
    }
    
	if(false == PortCheck(RuleInfo.Protocol, RuleInfo.SourcePort, RuleInfo.SourcePortRangeMax))
    {
        return false;
    }

	if ( "" == RuleInfo.DSCPMark)
    {
         AlertEx(qos_smart_language['bbsp_dscpneed']);
         return false;
    }
    
	if ((RuleInfo.DSCPMark != "") && (false == CheckNumber(RuleInfo.DSCPMark, 0, 63)))
    {
        AlertEx(qos_smart_language['bbsp_dscpidinvalid']);
        return false;
    }

	if (DisplayControl)
	{
		if (false == CheckNumber(RuleInfo.TRAFFIC, 0, 255))
		{
			AlertEx(qos_smart_language['bbsp_tcmarkinvalid']);
			return false;
		}
	
		if ((("" == RuleInfo.TRAFFICMARK) && 0 == getSelectVal("ReMarkMode")) 
			|| ("" != RuleInfo.TRAFFICMARK && 0 == getSelectVal("ReMarkMode") && (false == CheckNumber(RuleInfo.TRAFFICMARK, 0, 255))))
		{
			AlertEx(qos_smart_language['bbsp_tcremarkinvalid']);
			return false;	
		}
		
		if ((("" == RuleInfo.PRIMARK) && 1 == getSelectVal("ReMarkMode")) 
			|| ("" != RuleInfo.PRIMARK && 1== getSelectVal("ReMarkMode") && (false == CheckNumber(RuleInfo.PRIMARK, 0, 7))))
		{
			AlertEx(qos_smart_language['bbsp_tcprimarkinvalid']);
			return false;
		}	
	}
	
    return true;
}

function FillupSubmitPara(Form, RuleInfo)
{
    if(RuleInfo.ClassInterface.length)
    {
        Form.addParameter('x.ClassInterface', RuleInfo.ClassInterface);
    }
    else
    {
    	Form.addParameter('x.ClassInterface', '');
    }
   
    if(RuleInfo.QosSmartDomain.length)
    {
        Form.addParameter('x.DomainName', RuleInfo.QosSmartDomain);
    }
    else
    {
    	Form.addParameter('x.DomainName', '');
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
    if (!RuleInfo.Protocol.length)
    {
        RuleInfo.Protocol = -1;
    }
    Form.addParameter('x.Protocol', RuleInfo.Protocol);
    
    if (!RuleInfo.DestPort.length)
    {
    	RuleInfo.DestPort = -1;        
    }
    Form.addParameter('x.DestPort', RuleInfo.DestPort);
    
    if (!RuleInfo.DestPortRangeMax.length)
    {
        RuleInfo.DestPortRangeMax = -1;
    }
    Form.addParameter('x.DestPortRangeMax', RuleInfo.DestPortRangeMax);
    
    if (!RuleInfo.SourcePort.length)
    {
        RuleInfo.SourcePort = -1;
    }
    Form.addParameter('x.SourcePort', RuleInfo.SourcePort);
    
    if (!RuleInfo.SourcePortRangeMax.length)
    {
        RuleInfo.SourcePortRangeMax = -1; 
    }
    Form.addParameter('x.SourcePortRangeMax', RuleInfo.SourcePortRangeMax);
    
    if (RuleInfo.DSCPMark.length)
    {
        Form.addParameter('x.DSCPMark', RuleInfo.DSCPMark);
    }
    
    if(!RuleInfo.VLANIDCheck.length)
    {
        RuleInfo.VLANIDCheck = -1;
    }
    Form.addParameter('x.VLANIDCheck', RuleInfo.VLANIDCheck);
    
    if (!DisplayControl)
    {
    	RuleInfo.TRAFFIC = -1;
    	RuleInfo.PRIMARK = -1;
    	RuleInfo.TRAFFICMARK = -1;	
    }
    if (0 == getSelectVal("ReMarkMode"))
    {
    	RuleInfo.PRIMARK = -1;
    }
    else
    {
		RuleInfo.TRAFFICMARK = -1;		
   	}
	if (DisplayControl)
	{
		Form.addParameter('x.TRAFFIC', ('' == RuleInfo.TRAFFIC) ? -1 : RuleInfo.TRAFFIC);
		Form.addParameter('x.PRIMARK', ('' == RuleInfo.PRIMARK) ? -1 : RuleInfo.PRIMARK);
		Form.addParameter('x.TRAFFICMARK', ('' == RuleInfo.TRAFFICMARK) ? -1 : RuleInfo.TRAFFICMARK);
	}
}

function OnModifySubmit()
{
    var RuleInfo = GetInputRuleInfo();
    
    if (CheckForm(RuleInfo) == false)
    {
        return false;
    }
    

    if (true == IsRepeateConfig(RuleInfo))
    {
        AlertEx(qos_smart_language['bbsp_ruleexist']);
        return false;
    }
  
    var Form = new webSubmitForm();
    FillupSubmitPara(Form, RuleInfo);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));   
    Form.setAction('set.cgi?' +'x='+ QosSmartList[selIndex].Domain + '&RequestFile=html/bbsp/qossmart/qossmart.asp');
    Form.submit();

}


function OnAddNewSubmit()
{
    var RuleInfo = GetInputRuleInfo();
    if (CheckForm(RuleInfo) == false)
    {
        return false;
    }

    if (true == IsRepeateConfig(RuleInfo))
    {
        AlertEx(qos_smart_language['bbsp_ruleexist']);
        return false;
    } 

    var Form = new webSubmitForm();
    FillupSubmitPara(Form, RuleInfo);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('add.cgi?' +'x=InternetGatewayDevice.QueueManagement.X_HW_Classification' + '&RequestFile=html/bbsp/qossmart/qossmart.asp');
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
    
    Form.setAction('del.cgi?' +'x=InternetGatewayDevice.QueueManagement.X_HW_Classification' + '&RequestFile=html/bbsp/qossmart/qossmart.asp');
    Form.submit();
	DisableRepeatSubmit();
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
    getElById('TableConfigInfo').style.display = 'none';
    getElById('TableConfigInfo').style.display = 'none';
    
    if (selIndex == -1)
    {
         var tableRow = getElementById("xxxInst");
         if (tableRow.rows.length > 2)
         tableRow.deleteRow(tableRow.rows.length-1);
         return false;
     }
}

function Get802dot1pByDSCP()
{   
    var DSCP = 0;
    
    if ('' == getValue("DSCPMark"))
    {
        setText("PRIMark",'');  
        return;
    }
    DSCP = parseInt(getValue("DSCPMark"), 10); 
    setText("PRIMark", DSCP>>3);  
    return; 
}


</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<form id="ConfigForm" action="../application/set.cgi"> 
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("qossmarttitle", GetDescFormArrayById(qos_smart_language, ""), GetDescFormArrayById(qos_smart_language, "bbsp_qos_smart_title"), false);
</script> 
<div class="title_spread"></div>
  
  <table cellpadding="0" cellspacing="1" width="100%" class="tabal_bg"> 
    <tr> 
      <td class="table_title width_per25" BindText='bbsp_enableqossmart'></td> 
      <td class="table_right width_per75"> <input  id='QosSmartEnableValue' name='QosSmartEnableValue' type='checkbox' onclick="SubmitEnableForm();" > </td> 
    </tr> 
  </table> 
  <div class="func_spread"></div>
  
<script language="JavaScript" type="text/javascript">
    writeTabCfgHeader('QOSSMART','100%');
</script> 
<table class="tabal_bg" id="xxxInst" width="100%" cellspacing="1"> 
    <tr  class="head_title"> 
      <td class="width_per3">&nbsp;</td> 
      <td BindText='bbsp_qossmartclassinterface'></td>
      <td BindText='bbsp_qossmartvlan'></td>      
      <td BindText='bbsp_qossmartprotocol'></td>  
      <td BindText='bbsp_qossmartdestipmask'></td>  
      <td BindText='bbsp_qossmartsrcipmask'></td>  
      <td BindText='bbsp_qossmartdestportrange'></td>  
      <td BindText='bbsp_qossmartsrcportrange'></td>  
      <td BindText='bbsp_qossmardscpmark'></td>  
      <td BindText='bbsp_qossmartpbitmark'></td>
      <script>
      	if (DisplayControl)
      	{
      		document.write("<td BindText='bbsp_qossmarttcmark'></td>");
      		document.write("<td BindText='bbsp_qossmartremarkmode'></td>");
      		document.write("<td BindText='bbsp_qossmarttcremark'></td>");
      		document.write(" <td BindText='bbsp_qossmartprimark'></td>");
      	}
      </script>                                   
    </tr> 
    <script>    
    document.write(UpdateUI(QosSmartList));
    </script> 
  </table> 
  
 
<div id="TableConfigInfo" class="displaynone"> 
 <div class="list_table_spread"></div>

    <table class="tabal_bg tabCfgArea" border="0" cellpadding="0" cellspacing="1"  width="100%"> 
    <tr>
        <td  class="table_title align_left width_per15" id='bbsp_qossmartclassinterface'>
           <script LANGUAGE="JavaScript"> 
		        document.write(appendPrompt('bbsp_qossmartclassinterface'));
		    </script>
        </td> 
        <td class="table_right">
          <select id='ClassInterface' class="width_260px" name='ClassInterface' size="1"> 
            </select>
        </td>
    </tr> 
         <tr>
        <td  class="table_title align_left width_per15" id='bbsp_qossmartvlan'> 
            <script LANGUAGE="JavaScript"> 
		        document.write(appendPrompt('bbsp_qossmartvlan'));
		    </script>
        </td> 
        <td class="table_right">
          <input type='text' id="VLANIDCheck" size='46'  maxlength=4 /> 
          <span class="gray">(1~4094)</span>
        </td>
    </tr>   
     <tr>
        <td  class="table_title align_left width_per15" id='bbsp_qossmartprotocol'>
            <script LANGUAGE="JavaScript"> 
		        document.write(appendPrompt('bbsp_qossmartprotocol'));
		    </script>
        </td> 
        <td class="table_right">
          <input type=text id="Protocol" size='46'  maxlength=3 /> 
          <span class="gray">(0~255)</span>
        </td>
        <script LANGUAGE="JavaScript"> 
		    getElById("Protocol").title = qos_smart_language['bbsp_protocol_title'];
		</script>
    </tr>  
    <tr>
        <td  class="table_title align_left width_per15" id='bbsp_qossmartdomain'>
            <script LANGUAGE="JavaScript"> 
		        document.write(appendPrompt('bbsp_qossmartdomain'));
		    </script>
        </td> 
        <td class="table_right">
          <input type=text id="QosSmartDomainId" size='46'  maxlength=64/>
            <span class="gray" ><script>document.write(qos_smart_language['bbsp_qossmartdomaintips']);</script></span>
        </td>
    </tr>
    <tr>
        <td  class="table_title align_left width_per15" id='bbsp_qossmartdestipmask'>
            <script LANGUAGE="JavaScript"> 
		        document.write(appendPrompt('bbsp_qossmartdestipmask'));
		    </script>
        </td> 
        <td class="table_right">
          <input type=text id="DestIP" size='46' class="restrict_dir_ltr"  maxlength=64/> 
          &nbsp; / &nbsp;&nbsp;<input type=text id="DestMask" size='46'  maxlength=64/> 
        </td>
    </tr>
      
    <tr>
        <td  class="table_title align_left width_per15" id='bbsp_qossmartsrcipmask'>
            <script LANGUAGE="JavaScript"> 
		        document.write(appendPrompt('bbsp_qossmartsrcipmask'));
		    </script>
        </td> 
        <td class="table_right">
          <input type=text id="SourceIP" class="restrict_dir_ltr" size='46'  maxlength=64/> 
          &nbsp; / &nbsp;&nbsp;<input type=text id="SourceMask" size='46'  maxlength=64/> 
        </td>
    </tr>     
          <tr>
        <td  class="table_title align_left width_per15" id='bbsp_qossmartdestportrange'>
            <script LANGUAGE="JavaScript"> 
		        document.write(appendPrompt('bbsp_qossmartdestportrange'));
		    </script>
        </td> 
        <td class="table_right">
          <input type=text id="DestPort" size='46'  maxlength=5 /> 
          &nbsp; -- &nbsp;<input type=text id="DestPortRangeMax" size='46'  maxlength=5 /> 
        </td>
    </tr>
          <tr>
        <td  class="table_title align_left width_per15" id='bbsp_qossmartsrcportrange'>
            <script LANGUAGE="JavaScript"> 
		        document.write(appendPrompt('bbsp_qossmartsrcportrange'));
		    </script>
        </td> 
        <td class="table_right">
          <input type=text id="SourcePort" size='46'  maxlength=5  /> 
          &nbsp; -- &nbsp;<input type=text id="SourcePortRangeMax" size='46' maxlength=5/> 
        </td>
    </tr>
    <tr> 
      <td class="table_title align_left width_per15" id='bbsp_qossmardscpmark'>
            <script LANGUAGE="JavaScript"> 
		        document.write(appendPrompt('bbsp_qossmardscpmark'));
		    </script>
      </td> 
      <td class="table_right">      
      <input type=text id="DSCPMark" size='46'  maxlength=2 onchange="Get802dot1pByDSCP();"/> 
        <font color="red">*</font><span class="gray">(0~63)</span>  
      </td> 
    </tr>      
    <tr> 
      <td class="table_title align_left width_per15" id='bbsp_qossmartpbitmark'>
            <script LANGUAGE="JavaScript"> 
		        document.write(appendPrompt('bbsp_qossmartpbitmark'));
		    </script>
      </td> 
      <td class="table_right">      
       <input type=text id="PRIMark" size='46'/>
          </font><span class="gray" ><script>document.write(qos_smart_language['bbsp_dscprelation']);</script></span>
      </td> 
    </tr> 
    <tr id='bbsp_qossmarttcmark_tr'>
    	 <td class="table_title align_left width_per15">
            <script LANGUAGE="JavaScript"> 
		        document.write(appendPrompt('bbsp_qossmarttcmark'));
		    </script>
      </td>
      <td class="table_right">      
       <input type=text id="TcMark" size='46'/>
          <font color="red">*</font><span class="gray">(0~255)</span>
      </td>
  	</tr>
  	<tr id='bbsp_qossmartremarkmode_tr'>
        <td  class="table_title align_left width_per15" id='bbsp_qossmartremarkmode'>
           <script LANGUAGE="JavaScript"> 
		        document.write(appendPrompt('bbsp_qossmartremarkmode'));
		    </script>
        </td> 
        <td class="table_right">
          <select id='ReMarkMode' class="width_260px" name='ReMarkMode' onchange='ReMarkModeChange()' size="1"> 
            </select>
        </td>
    </tr> 
    <tr id='bbsp_qossmarttcremark_tr'>
    	 <td class="table_title align_left width_per15">
            <script LANGUAGE="JavaScript"> 
		        document.write(appendPrompt('bbsp_qossmarttcremark'));
		    </script>
      </td>
      <td class="table_right">      
       <input type=text id="TcReMark" size='46'/>
          <font color="red">*</font><span class="gray">(0~255)</span>
      </td>
  	</tr>
  	<tr id='bbsp_qossmartprimark_tr'>
  		<td class="table_title align_left width_per15">
            <script LANGUAGE="JavaScript"> 
		        document.write(appendPrompt('bbsp_qossmartprimark'));
		    </script>
      </td> 
      <td class="table_right">      
       <input type=text id="TcPriMark" size='46'/>
          <font color="red">*</font><span class="gray">(0~7)</span>
      </td>
  	</tr>        
    </table> 
    
    <table width="100%"  cellspacing="1" class="table_button"> 
      <tr> 
        <td class="width_per15"></td> 
        <td class="table_submit pad_left5p">
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
			<button id='Apply' type=button onclick = "javascript:return OnApply();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(qos_smart_language['bbsp_qossmartapp']);</script></button>
          	<button id='Cancel' type=button onclick="javascript:OnCancel();" class="CancleButtonCss buttonwidth_100px"><script>document.write(qos_smart_language['bbsp_qossmartcancel']);</script></button> 
		</td> 
      </tr> 
    </table> 
  </div> 
  <script language="JavaScript" type="text/javascript">
	writeTabTail();
  </script>
  <table width="100%" height="20" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td></td> 
    </tr> 
  </table>   
</form>  
</body>
</html>
