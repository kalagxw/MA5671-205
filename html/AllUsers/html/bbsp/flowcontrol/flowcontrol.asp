<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="<%HW_WEB_CleanCache_Resource(muljsdiff.js);%>"></script>
<script language="Javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<title>Flow Control</title>
<script language="javascript" src="../common/wan_check.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">

var Flowcontrol_AddFlag = true;
var Qosmode_AddFlag = true;
var flowcontrolIdx = -1;
var qosmodeIdx = -1;
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';

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
		b.innerHTML = flowcontrol_language[b.getAttribute("BindText")];
	}
}

function GetUnsignedIngterValue(data)
{
	return (data == '-1')?'':data;
}

function FlowcontrolInfo(domain,ClassInterface,DestIP,DestMask,SourceIP,SourceMask,Protocol,DestPort,DestPortRangeMax,SourcePort,SourcePortRangeMax,DSCPCheck,DSCPMark,EthernetPriorityMark,ClassPolicer,X_HW_Drop,X_HW_OutHardwareQueue)
{
    this.domain = domain;
    this.ClassInterface = ClassInterface;
    this.DestIP = DestIP;
    this.DestMask = DestMask;
    this.SourceIP = SourceIP;
    this.SourceMask = SourceMask;
    this.Protocol = Protocol;
	this.DestPort = GetUnsignedIngterValue(DestPort);
	this.DestPortRangeMax = GetUnsignedIngterValue(DestPortRangeMax);
	this.SourcePort = GetUnsignedIngterValue(SourcePort);
	this.SourcePortRangeMax = GetUnsignedIngterValue(SourcePortRangeMax);
	this.DSCPCheck = GetUnsignedIngterValue(DSCPCheck);
	this.DSCPMark = GetUnsignedIngterValue(DSCPMark);
	this.EthernetPriorityMark = GetUnsignedIngterValue(EthernetPriorityMark);
	this.ClassPolicer = ClassPolicer;
	this.X_HW_Drop = X_HW_Drop;
	this.X_HW_OutHardwareQueue = X_HW_OutHardwareQueue;
}

var FlowcontrolInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.QueueManagement.Classification.{i},ClassInterface|DestIP|DestMask|SourceIP|SourceMask|Protocol|DestPort|DestPortRangeMax|SourcePort|SourcePortRangeMax|DSCPCheck|DSCPMark|EthernetPriorityMark|ClassPolicer|X_HW_Drop|X_HW_OutHardwareQueue|,FlowcontrolInfo);%>;

function QosmodeInfo(domain,CommittedRate)
{
    this.domain = domain;
    this.CommittedRate = CommittedRate;
}

var QosmodeInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.QueueManagement.Policer.{i},CommittedRate,QosmodeInfo);%>;

function stLan(domain,name,enable)
{
    this.domain = domain;
    this.name = name;
    this.enable = enable;
}

function stWlan(domain,name,enable)
{
    this.domain = domain;
    this.name = name;
    this.enable = enable;
}

var LanInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.{i},Name|Enable,stLan);%>;
var WlanInfoList = '<%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|Enable,stWlan);%>';
if (WlanInfoList.length > 0) 
{
	WlanInfoList = eval(WlanInfoList);
}
else
{
	WlanInfoList = new Array(null);
}
function setCtlDisplayQosmode(record)
{
    if (record != null)
	{
		setText('CommittedRate',(record.CommittedRate)/1024);	
    }
    else
    {
		setText('CommittedRate','');	
    }
}

function setCtlDisplayFlowcontrol(record)
{
    if (record != null)
	{
		setSelect('Protocol',record.Protocol);
    	setText('SourceIP',record.SourceIP);	
    	setText('SourceMask',record.SourceMask);
		setText('DestIP',record.DestIP);
		setText('DestMask',record.DestMask);
		setText('SourcePort',record.SourcePort);
		setText('SourcePortRangeMax',record.SourcePortRangeMax);
		setText('DestPort',record.DestPort);
		setText('DestPortRangeMax',record.DestPortRangeMax);
		setText('DSCPCheck',record.DSCPCheck);
		setSelect('ClassInterface',record.ClassInterface);
		if ('1' == record.X_HW_Drop)
		{
			setSelect('ActType','DROP');
			setSelect('TrafficMode','1');
			setText('DSCPMark','');
			setText('EthernetPriorityMark','');
			setSelect('X_HW_OutHardwareQueue','-1');			
		}
		else if ('0' == record.X_HW_Drop)
		{
			setSelect('ActType','CAR');
			setSelect('TrafficMode',record.ClassPolicer);			
			setText('DSCPMark',record.DSCPMark);
			setText('EthernetPriorityMark',record.EthernetPriorityMark);
			setSelect('X_HW_OutHardwareQueue',record.X_HW_OutHardwareQueue);
		}		
    }
    else
    {
		setSelect('Protocol','');
    	setText('SourceIP','');	
    	setText('SourceMask','');
		setText('DestIP','');
		setText('DestMask','');
		setText('SourcePort','');
		setText('SourcePortRangeMax','');
		setText('DestPort','');
		setText('DestPortRangeMax','');
		setText('DSCPCheck','');
		setSelect('ClassInterface','');	
		setSelect('ActType','');
		setText('DSCPMark','');	
		setText('EthernetPriorityMark','');
		setSelect('X_HW_OutHardwareQueue','');		
    }
}

function setControlQosmode(index)
{
    var record;
    qosmodeIdx = index;

    if (index == -1)
	{           
		setDisplay('QosmodeConfigForm', 1);
		Qosmode_AddFlag = true;
		record = new QosmodeInfo('', '');
		setCtlDisplayQosmode(record);			        
	}
    else if (index == -2)
    {
        setDisplay('QosmodeConfigForm', 0);
    }
    else
	{
	    setDisplay('QosmodeConfigForm', 1);
        Qosmode_AddFlag = false;
		record = QosmodeInfoList[index];
		setCtlDisplayQosmode(record);
	}
    
    setDisable('btnQosmodeApply',0);
    setDisable('btnQosmodeCancel',0);
}

function setControlFlowcontrol(index)
{
    var record;
    flowcontrolIdx = index;

    if (index == -1)
	{   
		setDisplay('FlowcontrolConfigForm', 1);
		Flowcontrol_AddFlag = true;

		record = new FlowcontrolInfo("","InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.1","","","","","-1","","","","","","","","1","0","-1");
		setCtlDisplayFlowcontrol(record);
		if (record.X_HW_Drop == '1')
		{
			setDisplay('isCommittedRate',0);
			setDisplay('is8021pRemark',0);
			setDisplay('isDscpRemark',0);
			setDisplay('isQueueId',0);
		}
		else if (record.X_HW_Drop == '0')
		{
			setDisplay('isCommittedRate',1);
			setDisplay('is8021pRemark',1);
			setDisplay('isDscpRemark',1);
			setDisplay('isQueueId',1);		
		}			
	}
    else if (index == -2)
    {
        setDisplay('FlowcontrolConfigForm', 0);
    }
    else
	{
	    setDisplay('FlowcontrolConfigForm', 1);
        Flowcontrol_AddFlag = false;
	    record = FlowcontrolInfoList[index];
		setCtlDisplayFlowcontrol(record);
		if (record.X_HW_Drop == '1')
		{
			setDisplay('isCommittedRate',0);
			setDisplay('is8021pRemark',0);
			setDisplay('isDscpRemark',0);
			setDisplay('isQueueId',0);
		}
		else if (record.X_HW_Drop == '0')
		{
			setDisplay('isCommittedRate',1);
			setDisplay('is8021pRemark',1);
			setDisplay('isDscpRemark',1);
			setDisplay('isQueueId',1);		
		}
	}
    
    setDisable('btnFlowcontrolApply',0);
    setDisable('btnFlowcontrolCancel',0);
}

function clickRemoveFlowcontrol() 
{
	if ((FlowcontrolInfoList.length-1) == 0)
	{
	    AlertEx(flowcontrol_language['bbsp_noFlowcontrol']);
	    return;
	}
	
	if (flowcontrolIdx == -1)
	{
	    AlertEx(flowcontrol_language['bbsp_saveFlowcontrol']);
	    return;
	}
	
	var Flowcontrolrml = getElement('Flowcontrol_rml');
	var noChooseFlag = true;
    if (Flowcontrolrml.length > 0)
    {
         for (var i = 0; i < Flowcontrolrml.length; i++)
         {
             if (Flowcontrolrml[i].checked == true)
             {   
                 noChooseFlag = false;
             }
         }
    }
    else if (Flowcontrolrml.checked == true)
    {
        noChooseFlag = false;
    }
    if ( noChooseFlag )
    {
        AlertEx(flowcontrol_language['bbsp_selecFlowcontrol']);
        return;
    }
	
	if (ConfirmEx(flowcontrol_language['bbsp_confirmFlowcontrol']) == false)
	{
		return;
	}
	
	setDisable('btnFlowcontrolApply',1);
	setDisable('btnFlowcontrolCancel',1);
	removeInst('Flowcontrol', 'html/bbsp/flowcontrol/flowcontrol.asp');
}

function checkMultiQosmode(Qosmoderml)
{
	for (var i = 0; i < Qosmoderml.length; i++)
	{
		if (Qosmoderml[i].checked == true)
		{
			for(var j = 0; j < FlowcontrolInfoList.length - 1; j++)
			{					
				if ((FlowcontrolInfoList[j].ClassPolicer -1)  == i)
				{
					AlertEx(flowcontrol_language['bbsp_qosmodeused']);
					return false;	 					
				}				
			}
		}	
	}
}

function checkSingelQosmode(Qosmoderml)
{
	var selectqosindex = Qosmoderml.value.charAt(Qosmoderml.value.length - 1);

	for(var i = 0; i < FlowcontrolInfoList.length - 1; i++)
	{					
		if ((FlowcontrolInfoList[i].ClassPolicer)  == selectqosindex)
		{
			AlertEx(flowcontrol_language['bbsp_qosmodeused']);
			return false;						
		}			
	}
}

function checkBindByFlowcontrol(Qosmoderml)
{
	if (Qosmoderml.length > 0)
	{
		return checkMultiQosmode(Qosmoderml);		
	}
	else (Qosmoderml.length == undefined && Qosmoderml.checked == true)
	{
		return checkSingelQosmode(Qosmoderml);
	}
}

function clickRemoveQosmode() 
{
	if ((QosmodeInfoList.length-1) == 0)
	{
	    AlertEx(flowcontrol_language['bbsp_noQosmode']);
	    return;
	}
	
	if (qosmodeIdx == -1)
	{
	    AlertEx(flowcontrol_language['bbsp_saveQosmode']);
	    return;
	}
		
	var Qosmoderml = getElement('Qosmode_rml');
	var noChooseFlag = true;
    if (Qosmoderml.length > 0)
    {
         for (var i = 0; i < Qosmoderml.length; i++)
         {
             if (Qosmoderml[i].checked == true)
             {   
                 noChooseFlag = false;
             }
         }
    }
    else if (Qosmoderml.checked == true)
    {
        noChooseFlag = false;
    }
	
    if ( noChooseFlag )
    {
        AlertEx(flowcontrol_language['bbsp_selecQosmode']);
        return ;
    }
	
	if (ConfirmEx(flowcontrol_language['bbsp_confirmQosmode']) == false)
	{
		return;
	}	

	var checkreturn = checkBindByFlowcontrol(Qosmoderml);
	if (checkreturn == false)
	{
		return;
	}

	setDisable('btnQosmodeApply',1);
	setDisable('btnQosmodeCancel',1);
	removeInst('Qosmode', 'html/bbsp/flowcontrol/flowcontrol.asp');
}

function clickRemove(tabTitle) 
{
	switch(tabTitle)
	{
		case "Flowcontrol":
			clickRemoveFlowcontrol();
			break;
		case "Qosmode":
			clickRemoveQosmode();
			break;
		default:
			break;
	}
}

function LoadFrame()
{
	if(curUserType != sysUserType)
	{
		setDisable("QosmodeConfigForm",1);
		setDisable("FlowcontrolConfigForm",1);
	}	
	
	loadlanguage();	
}

function CheckIpAndMask(ip,mask,sourcedest)
{
	if ((ip != '') && (isValidIpAddress(ip) == false))
	{
		AlertEx(flowcontrol_language['bbsp_alert_'+sourcedest+'ipinvalid']);
		return false; 
	}
	
	if ((mask != '') && (isValidSubnetMask(mask) == false))
	{
		AlertEx(flowcontrol_language['bbsp_alert_'+sourcedest+'ipmaskinvalid']);
		return false; 
	}

	if ((ip != '') && (mask != '') && (isMatchedIpAndMask(ip, mask) == false))
	{
		AlertEx(flowcontrol_language['bbsp_alert_'+sourcedest+'ipportnotmatch']);
		return false; 
	}

	if ((ip == '') && (mask != ''))
	{
		AlertEx(flowcontrol_language['bbsp_alert_'+sourcedest+'ipportnotmatch']);
		return false; 
	}
}

function CheckSourceIpAndMask()
{
	var sourceip = getValue('SourceIP');
	var sourcemask = getValue('SourceMask');	
	return CheckIpAndMask(sourceip,sourcemask,'s');
}

function CheckDestIpAndMask()
{
	var destip = getValue('DestIP');
	var destmask = getValue('DestMask');	
	return CheckIpAndMask(destip,destmask,'d');
}

function CheckPort(port,maxport,sourcedest)
{	
	if((port != '') && (CheckNumber(port,'1','65535') == false))
	{
		AlertEx(flowcontrol_language['bbsp_alert_'+sourcedest+'portinvalid']);
		return false;
	}

	if((maxport != '') && (CheckNumber(maxport,'1','65535') == false))
	{
		AlertEx(flowcontrol_language['bbsp_alert_'+sourcedest+'portmaxinvalid']);		
		return false;
	}

	if((port != '') && (maxport != '') && (parseInt(port) > parseInt(maxport)))	
	{
		AlertEx(flowcontrol_language['bbsp_alert_'+sourcedest+'portmaxportnotmatch']);		
		return false;
	}	
}

function CheckSourcePort()
{
	var sourceport = getValue('SourcePort');
	var sourcemaxport = getValue('SourcePortRangeMax');
	return CheckPort(sourceport,sourcemaxport,'s');	
}

function CheckDestPort()
{
	var destport = getValue('DestPort');
	var destmaxport = getValue('DestPortRangeMax');	
	return CheckPort(destport,destmaxport,'d');	
}

function CheckDscpCheck()
{
	var dscpcheck = getValue('DSCPCheck');
	if((dscpcheck != '') && (CheckNumber(dscpcheck,'0','63') == false))
	{
		AlertEx(flowcontrol_language['bbsp_alert_dscpinvalid']);		
		return false;
	}	
}

function CheckTrafficMode()
{
	var qos_idx = getValue('TrafficMode');
	var acttype = getValue('ActType');
	if (acttype == 'CAR')
	{
		if (qos_idx <=0)
		{
			AlertEx(flowcontrol_language['bbsp_fc_qosmodeindexinvalid']);			
			return false;	
		}		
	}
}

function CheckDscpMark()
{
	var dscpmark = getValue('DSCPMark');
	var acttype = getValue('ActType');
	if (acttype == 'CAR')
	{
		if((dscpmark != '') && (CheckNumber(dscpmark,'0','63') == false))
		{
			AlertEx(flowcontrol_language['bbsp_alert_dscpremarkinvalid']);			
			return false;
		}
	}
}

function Check8021pMark()
{
	var ethernetprioritymark = getValue('EthernetPriorityMark');
	var acttype = getValue('ActType');
	if (acttype == 'CAR')
	{
		if((ethernetprioritymark != '') && (CheckNumber(ethernetprioritymark,'0','7') == false))
		{
			AlertEx(flowcontrol_language['bbsp_alert_8021pinvalid']);			
			return false;
		}
	}
}

function CheckProtocolPort()
{
	var protocol = getValue('Protocol');
	var sourceport = getValue('SourcePort');
	var sourcemaxport = getValue('SourcePortRangeMax');
	var destport = getValue('DestPort');
	var destmaxport = getValue('DestPortRangeMax');	
	if (protocol == '-1' && (sourceport != '' || sourcemaxport != '' || destport != '' || destmaxport != ''))
	{
		AlertEx(flowcontrol_language['bbsp_protocolportnotmatch1']);
		return false;
	}

	if (protocol == '2' && (sourceport != '' || sourcemaxport != '' || destport != '' || destmaxport != ''))
	{
		AlertEx(flowcontrol_language['bbsp_protocolportnotmatch2']);
		return false;
	}	
}

function CheckRepeatedFlowCondition()
{
	for (i = 0; i < FlowcontrolInfoList.length - 1; i++)
    {
        if (flowcontrolIdx != i)
        {
            if ((FlowcontrolInfoList[i].ClassInterface == getValue('ClassInterface'))
			 && (FlowcontrolInfoList[i].DestIP == getValue('DestIP'))
			 && (FlowcontrolInfoList[i].DestMask == getValue('DestMask'))
			 && (FlowcontrolInfoList[i].SourceIP == getValue('SourceIP'))
			 && (FlowcontrolInfoList[i].SourceMask == getValue('SourceMask'))
			 && (FlowcontrolInfoList[i].Protocol == getValue('Protocol'))
			 && (FlowcontrolInfoList[i].DestPort == getValue('DestPort'))
			 && (FlowcontrolInfoList[i].DestPortRangeMax == getValue('DestPortRangeMax'))
			 && (FlowcontrolInfoList[i].SourcePort == getValue('SourcePort'))
			 && (FlowcontrolInfoList[i].SourcePortRangeMax == getValue('SourcePortRangeMax'))
			 && (FlowcontrolInfoList[i].DSCPCheck == getValue('DSCPCheck')))
            {               
				AlertEx(flowcontrol_language['bbsp_flowconditionrpeated']);
                return false;
            }
        }
        else
        {
            continue;
        }
    }
}
	
function CheckFlowcontrolInput()
{
	var returnsip = CheckSourceIpAndMask();
	if (returnsip == false)
	{
		return false;
	}
	
	var returndip = CheckDestIpAndMask();
	if (returndip == false)
	{
		return false;
	}	
	
	var returnsport = CheckSourcePort();
	if (returnsport == false)
	{
		return false;
	}
	
	var returndport = CheckDestPort();
	if (returndport == false)
	{
		return false;
	}

	var returnprotocolandport = CheckProtocolPort();
	if (returnprotocolandport == false)
	{
		return false;
	}
	
	var returndscpcheck = CheckDscpCheck();
	if (returndscpcheck == false)
	{
		return false;
	}	
	
	var returntrafficmode = CheckTrafficMode();
	if (returntrafficmode == false)
	{
		return false;
	}
	
	var returndscpmark = CheckDscpMark();
	if (returndscpmark == false)
	{
		return false;
	}
	
	var return8021pmark = Check8021pMark();
	if (return8021pmark == false)
	{
		return false;
	}	

	var returnRepeatedFlowCondition = CheckRepeatedFlowCondition();
	if (returnRepeatedFlowCondition == false)
	{
		return false;
	}	
}

function FormAddConditionParameter(Form)
{
	Form.addParameter('x.Protocol',getValue('Protocol'));	
	Form.addParameter('x.SourceIP',getValue('SourceIP'));		
	Form.addParameter('x.SourceMask',getValue('SourceMask'));			
	Form.addParameter('x.DestIP',getValue('DestIP'));			
	Form.addParameter('x.DestMask',getValue('DestMask'));
			
	if (getValue('SourcePort') != '')
	{
		Form.addParameter('x.SourcePort',getValue('SourcePort'));
	}
	else
	{
		Form.addParameter('x.SourcePort','-1');	
	}	
	
	if (getValue('SourcePortRangeMax') != '')
	{
		Form.addParameter('x.SourcePortRangeMax',getValue('SourcePortRangeMax'));
	}
	else
	{
		Form.addParameter('x.SourcePortRangeMax','-1');	
	}	

	if (getValue('DestPort') != '')
	{
		Form.addParameter('x.DestPort',getValue('DestPort'));
	}
	else
	{
		Form.addParameter('x.DestPort','-1');
	}	
	
	if (getValue('DestPortRangeMax') != '')
	{
		Form.addParameter('x.DestPortRangeMax',getValue('DestPortRangeMax'));
	}
	else
	{
		Form.addParameter('x.DestPortRangeMax','-1');
	}	
	
	if (getValue('DSCPCheck') != '')
	{
		Form.addParameter('x.DSCPCheck',getValue('DSCPCheck'));
	}
	else
	{
		Form.addParameter('x.DSCPCheck','-1');
	}	

	Form.addParameter('x.ClassInterface',getValue('ClassInterface'));
}

function FormAddActionParameter(Form)
{
	var qos_idx = getValue('TrafficMode');
	
	if ( 'DROP' == getValue('ActType'))
	{
		Form.addParameter('x.X_HW_Drop','1');
		Form.addParameter('x.ClassPolicer','-1');
		Form.addParameter('x.DSCPMark','-1');
		Form.addParameter('x.EthernetPriorityMark','-1');
		Form.addParameter('x.X_HW_OutHardwareQueue','-1');
	}	
	else if ('CAR' == getValue('ActType'))
	{
		Form.addParameter('x.X_HW_Drop','0');						
		Form.addParameter('x.ClassPolicer',qos_idx);

		if (getValue('DSCPMark') != '')
		{
			Form.addParameter('x.DSCPMark',getValue('DSCPMark'));
		}
		else
		{
			Form.addParameter('x.DSCPMark','-1');
		}			

		if (getValue('EthernetPriorityMark') != '')
		{
			Form.addParameter('x.EthernetPriorityMark',getValue('EthernetPriorityMark'));
		}
		else
		{
			Form.addParameter('x.EthernetPriorityMark','-1');
		}		
		
		Form.addParameter('x.X_HW_OutHardwareQueue',getValue('X_HW_OutHardwareQueue'));					
	}
}

function OnFlowcontrolApply()
{
	var checkflowcontrolinput = CheckFlowcontrolInput();
	if (checkflowcontrolinput == false)
	{
		return false;
	}

	var Form = new webSubmitForm();
	
	FormAddConditionParameter(Form);
	FormAddActionParameter(Form);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
			
	if( flowcontrolIdx == -1 )
	{
		Form.setAction('add.cgi?x=InternetGatewayDevice.QueueManagement.Classification' + '&RequestFile=html/bbsp/flowcontrol/flowcontrol.asp');
	}
	else
	{
		Form.setAction('set.cgi?x=' + FlowcontrolInfoList[flowcontrolIdx].domain + '&RequestFile=html/bbsp/flowcontrol/flowcontrol.asp');
	}
	
	Form.submit();
	DisableRepeatSubmit();
	setDisable('btnFlowcontrolApply',1);
    setDisable('btnFlowcontrolCancel',1);
}

function FlowcontrolCancelConfig()
{
	setDisplay("FlowcontrolConfigForm", 0);
	if (flowcontrolIdx == -1)
	{
		var tableRow = getElement("FlowcontrolInst");
		if (tableRow.rows.length == 1)
        {
		
        }
		else if (tableRow.rows.length == 2)
		{
            addNullInst('Flowcontrol');
        }
		else
		{
			tableRow.deleteRow(tableRow.rows.length-1);
            selectLine('Flowcontrol_record_0');
		}
	}
	else
	{
		var record = FlowcontrolInfoList[flowcontrolIdx];
		setCtlDisplayFlowcontrol(record);
	}
}

function CheckQosmodeInputRange()
{
	var committedrate = getValue('CommittedRate');
	if((committedrate != '') && (CheckNumber(committedrate,'1','1048576') == false))
	{		
		AlertEx(flowcontrol_language['bbsp_alert_rateinvalid']);
		return false;
	}	
}

function CheckRepeatedQosmode()
{
	var committedrate = getValue('CommittedRate');
	for (i = 0; i < QosmodeInfoList.length - 1; i++)
    {
        if (qosmodeIdx != i)
        {
            if (QosmodeInfoList[i].CommittedRate == committedrate*1024)
            {               
				AlertEx(flowcontrol_language['bbsp_raterepeated']);	
                return false;
            }
        }
        else
        {
            continue;
        }
    }
}

function OnQosmodeApply()
{
 	var Form = new webSubmitForm();
	var returnqosmoderange = CheckQosmodeInputRange();	
	if (returnqosmoderange == false)
	{
		return false;
	}

	var returnrepeatedqosmode = CheckRepeatedQosmode();	
	if (returnrepeatedqosmode == false)
	{
		return false;
	}
	
	Form.addParameter('x.CommittedRate',(getValue('CommittedRate'))*1024);
	Form.addParameter('x.X_HW_Token', getValue('onttoken')); 
	
	if( qosmodeIdx == -1 )
	{
		Form.setAction('add.cgi?x=InternetGatewayDevice.QueueManagement.Policer' + '&RequestFile=html/bbsp/flowcontrol/flowcontrol.asp');
	}
	else
	{
		Form.setAction('set.cgi?x=' + QosmodeInfoList[qosmodeIdx].domain + '&RequestFile=html/bbsp/flowcontrol/flowcontrol.asp');
	}
	
	Form.submit();
	DisableRepeatSubmit();
	setDisable('btnQosmodeApply',1);
    setDisable('btnQosmodeCancel',1);
}

function QosmodeCancelConfig()
{
	setDisplay("QosmodeConfigForm", 0);
	if (qosmodeIdx == -1)
	{
		var tableRow = getElement("QosmodeInst");
		if (tableRow.rows.length == 1)
        {
		
        }
		else if (tableRow.rows.length == 2)
		{
            addNullInst('Qosmode');
        }
		else
		{
			tableRow.deleteRow(tableRow.rows.length-1);
            selectLine('Qosmode_record_0');
		}
	}
	else
	{
		var record = QosmodeInfoList[qosmodeIdx];
		setCtlDisplayQosmode(record);
	}
}

function ActChange()
{
	with (document.forms[0])
	{
		if ('CAR' == getValue('ActType'))
		{	
		    setDisplay('isCommittedRate', 1);	
		    setDisplay('is8021pRemark', 1);		
		    setDisplay('isDscpRemark', 1);	
		    setDisplay('isQueueId', 1);	
		}
		else
		{			
		    setDisplay('isCommittedRate', 0);	
		    setDisplay('is8021pRemark', 0);		
		    setDisplay('isDscpRemark', 0);	
		    setDisplay('isQueueId', 0);
		}
	}
}

function GetQosModeInstID(domain)
{
	if(0 == domain.length)
	{
		return -1;
	}
	
	return domain.charAt(domain.length - 1);
}

function WriteOptionInterface()
{	
	var index;
	if (WlanInfoList.length -1 > 0)
	{
		for (var i = 0; i < WlanInfoList.length -1; i++)
		{
			index = parseInt(WlanInfoList[i].name.charAt(WlanInfoList[i].name.length -1),10) + 1;
			document.write('<option value="' + WlanInfoList[i].domain + '">' + ('SSID'+index) + '</option>');
		}
	}
	
	if (LanInfoList.length -1 > 0)
	{
		for (var i = 0; i < LanInfoList.length -1; i++)
		{
			index = parseInt(LanInfoList[i].name.charAt(LanInfoList[i].name.length -1),10);
			document.write('<option value="' + LanInfoList[i].domain + '">' + ('LAN'+index) + '</option>');
		}
	}	
}

function WriteOption()
{
	if (QosmodeInfoList.length >=2)
	{
		for (i = 0; i < QosmodeInfoList.length-1; i++)
		{
			var TrafficInst = GetQosModeInstID(QosmodeInfoList[i].domain);
			if(-1 == TrafficInst)
			{
				continue;
			}
			document.write('<option value="' + TrafficInst + '">' + TrafficInst + '</option>');
		}    
	}
}

function getMostRightPosOf1(str)
{
    for (i = str.length - 1; i >= 0; i--)
    {
        if (str.charAt(i) == '1')
        {
            break;
        }
    }
    return i;
}

function getBinaryString(str)
{
    var numArr = [128, 64, 32, 16, 8, 4, 2, 1];
    var addrParts = str.split('.');
    if (addrParts.length < 3)
    {
        return "00000000000000000000000000000000";
    }
    var binstr = '';
    for (i = 0; i < 4; i++)
    {
        var num = parseInt(addrParts[i])

        for ( j = 0; j < numArr.length; j++ )
        {
            if ( (num & numArr[j]) != 0 )
            {
                binstr += '1';
            }
            else
            {
                binstr += '0';
            }    
        }
    }
    return binstr;
}

function isMatchedIpAndMask(ip, mask)
{
    var locIp = getBinaryString(ip);
    var locMask = getBinaryString(mask);
    
    if (locIp.length != locMask.length)
    {
        return false;
    } 
    var most_right_pos_1 = getMostRightPosOf1(locMask);
    
    if (most_right_pos_1 == -1)
    {
        if (locIp == '00000000000000000000000000000000')
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    for (var i = most_right_pos_1 + 1; i < locIp.length; i++)
    {
        if (locIp.charAt(i) != '0')
        {
            return false;
        }
    }
    return true;
}

   
function setControlDispatch(tableID, index)
{
	switch(tableID)
	{
		case "Flowcontrol":
			setControlFlowcontrol(index);
			break;
		case "Qosmode":
			setControlQosmode(index);
			break;
		default:
			break;
	}
}

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<form id="Configure" action="../application/set.cgi"> 
  <table width="100%"  border="0" cellpadding="0" cellspacing="0" id="tabTest"> 
    <tr> 
      <td class="prompt"> <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
          <tr> 
            <td class='title_common' BindText='bbsp_title_prompt'></td> 
          </tr> 
        </table></td> 
    </tr> 
    <tr> 
      <td class='height5p'></td> 
    </tr> 
  </table> 
  
	<script language="JavaScript" type="text/javascript">
	writeTabCfgHeader('Qosmode',flowcontrol_language['bbsp_qosmodeManage'], "100%");
	</script>

  <table class="tabal_bg" id="qosmodeInst" width="100%" cellspacing="1"> 
    <tr class="head_title"> 
      <td>&nbsp;</td> 
      <td  BindText='bbsp_fc_qosindex'></td> 
      <td  BindText='bbsp_fc_committedRate'></td>  	  
    </tr> 
    <script language="JavaScript" type="text/javascript">
    if (QosmodeInfoList.length - 1 == 0)
    {
        document.write('<TR id="Qosmode_record_no"' 
    	                + ' class="tabal_center01 " onclick="selectLine(this.id);">');
        document.write('<TD >--</TD>');
        document.write('<TD >--</TD>');	
		document.write('<TD >--</TD>');		
    	document.write('</TR>');
    }
    else
    {
        for (var i = 0; i < QosmodeInfoList.length - 1; i++)
        {       	
			 document.write('<TR id="Qosmode_record_' + i 
						+ '" class="tabal_01" onclick="selectLine(this.id);">');
             document.write('<TD>' + '<input id = \"Qosmode_rml'+i+'\" type="checkbox" name="Qosmode_rml"'  + ' value=' 
        	            + QosmodeInfoList[i].domain  + '>' + '</TD>');
			 document.write('<TD>' + GetQosModeInstID(QosmodeInfoList[i].domain) + '</TD>');
			 document.write('<TD>' + (QosmodeInfoList[i].CommittedRate)/1024 + '</TD>');						 
			 document.write('</TR>');
        }
    }
   </script> 
  </table> 
  <div id="QosmodeConfigForm" style="display:none"> 
    <table class="tabal_bg" cellpadding="0" cellspacing="1" border="0" id="cfg_table" width="100%"> 
      <tr> 
        <td> <table cellpadding="0" cellspacing="1" class="tabal_bg" width="100%"> 			
            <tr> 
              <td  class="table_title width_per10" BindText='bbsp_fc_committedRate2'></td> 
              <td  class="table_right"> <input type='text' id='CommittedRate' name='CommittedRate' maxlength='15' class='width_126px'>
				<span class="gray"><script>document.write(flowcontrol_language['bbsp_fc_committedRateUnit']);</script></span> </td>
            </tr> 			
          </table></td> 
      </tr> 
    </table> 
	  <table cellpadding="0" cellspacing="1" width="100%" class="table_button"> 
		<tr> 
		  <td class="width_per25" ></td> 
		  <td class="table_submit">
		    <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
			<button id="btnQosmodeApply" name="btnQosmodeApply" type="button" class="submit" onClick="OnQosmodeApply();"><script>document.write(flowcontrol_language['bbsp_app']);</script></button> 
			<button id="btnQosmodeCancel" name="btnQosmodeCancel" class="submit"  type="button" onClick="QosmodeCancelConfig();"><script>document.write(flowcontrol_language['bbsp_cancel']);</script></button>
		</td> 
		</tr> 	
	  </table> 
  </div> 
  
	<script language="JavaScript" type="text/javascript">
	writeTabTail();
	</script>	
		
  <script language="JavaScript" type="text/javascript">
    writeTabCfgHeader('Flowcontrol',flowcontrol_language['bbsp_flowcontrolManage'], "100%");
</script> 
  <table class="tabal_bg" id="flowcontrolInst" width="100%" cellspacing="1"> 
    <tr class="head_title"> 
      <td>&nbsp;</td> 
      <td BindText='bbsp_fc_protocol'></td> 
      <td BindText='bbsp_fc_sip'></td> 
      <td BindText='bbsp_fc_sipmask'></td>
      <td BindText='bbsp_fc_dip'></td> 
      <td BindText='bbsp_fc_dipmask'></td>
      <td BindText='bbsp_fc_sport'></td> 
      <td BindText='bbsp_fc_dport'></td>
      <td BindText='bbsp_fc_acttype'></td>   	  
    </tr> 
    <script language="JavaScript" type="text/javascript">
    if (FlowcontrolInfoList.length - 1 == 0)
    {
        document.write('<TR id="Flowcontrol_record_no"' 
    	                + ' class="tabal_center01 " onclick="selectLine(this.id);">');
        document.write('<TD >--</TD>');
        document.write('<TD >--</TD>');
        document.write('<TD >--</TD>');
    	document.write('<TD >--</TD>');
        document.write('<TD >--</TD>');
    	document.write('<TD >--</TD>');	
        document.write('<TD >--</TD>');
    	document.write('<TD >--</TD>');	
		document.write('<TD >--</TD>');			
    	document.write('</TR>');
    }
    else
    {
        for (var i = 0; i < FlowcontrolInfoList.length - 1; i++)
        {       	
			 document.write('<TR id="Flowcontrol_record_' + i 
						+ '" class="tabal_01" onclick="selectLine(this.id);">');
             document.write('<TD>' + '<input id = \"Flowcontrol_rml'+i+'\" type="checkbox" name="Flowcontrol_rml"'  + ' value=' 
        	            + FlowcontrolInfoList[i].domain  + '>' + '</TD>');
			 if ('6' == FlowcontrolInfoList[i].Protocol)
			 {
				document.write('<TD>' + 'TCP' + '</TD>');
			 }
			 else if ('17' == FlowcontrolInfoList[i].Protocol)
			 {
				document.write('<TD>' + 'UDP' + '</TD>');
			 }
			 else if ('2' == FlowcontrolInfoList[i].Protocol)
			 {
				document.write('<TD>' + 'IGMP' + '</TD>');
			 }
			 else if ('-1' == FlowcontrolInfoList[i].Protocol)
			 {
				document.write('<TD>' + '</TD>');
			 }
			 document.write('<TD>' + FlowcontrolInfoList[i].SourceIP + '</TD>');
			 document.write('<TD>' + FlowcontrolInfoList[i].SourceMask + '</TD>');
			 document.write('<TD>' + FlowcontrolInfoList[i].DestIP + '</TD>');
			 document.write('<TD>' + FlowcontrolInfoList[i].DestMask + '</TD>');
			 document.write('<TD>' + FlowcontrolInfoList[i].SourcePort +'-'+FlowcontrolInfoList[i].SourcePortRangeMax + '</TD>');
			 document.write('<TD>' + FlowcontrolInfoList[i].DestPort +'-'+FlowcontrolInfoList[i].DestPortRangeMax + '</TD>');
			 if ('1' == FlowcontrolInfoList[i].X_HW_Drop)
			 {
				document.write('<TD>' + 'DROP' + '</TD>');
			 }
			 else if ('0' == FlowcontrolInfoList[i].X_HW_Drop)
			 {
				document.write('<TD>' + 'CAR' + '</TD>');
			 }
			 document.write('</TR>');
        }
    }
   </script> 
  </table> 
  <div id="FlowcontrolConfigForm" style="display:none"> 
    <table class="tabal_bg" cellpadding="0" cellspacing="1" border="0" id="cfg_table" width="100%"> 
      <tr> 
        <td> <table cellpadding="0" cellspacing="1" class="tabal_bg" width="100%"> 
            <tr> 
              <td BindText='bbsp_fc_condition'></td> 
            </tr> 		
			<tr> 
			  <td class="table_title width_per15" BindText='bbsp_fc_protocol2'> </td> 
			  <td class="table_right width_per75"><select id="Protocol" name='Protocol' size="1" 
										 class="width_126px"> 
				  <option value="-1"></option>					 
				  <option value="6">TCP</option> 
				  <option value="17">UDP</option> 
				  <option value="2">IGMP</option>  				  
				</select></td> 
			</tr>
            <tr> 
              <td  class="table_title width_per15" BindText='bbsp_fc_sip2'></td> 
              <td  class="table_right"> <input type='text' id='SourceIP' name='SourceIP' maxlength='15' class='width_126px'> </td>  
            </tr> 
			<script>
			getElById("SourceIP").title = flowcontrol_language['bbsp_fc_note'];
			</script>
            <tr > 
              <td  class="table_title" BindText='bbsp_fc_sipmask2'></td> 
              <td  class="table_right"> <input type='text' id='SourceMask' name='SourceMask' maxlength='15' class='width_126px'> </td> 
            </tr>
			<script>
			getElById("SourceMask").title = flowcontrol_language['bbsp_fc_note3'];
			</script>			
            <tr> 
              <td  class="table_title width_per15" BindText='bbsp_fc_dip2'></td> 
              <td  class="table_right"> <input type='text' id='DestIP' name='DestIP' maxlength='15' class='width_126px'> </td>
            </tr>
			<script>
			getElById("DestIP").title = flowcontrol_language['bbsp_fc_note'];
			</script>			
            <tr > 
              <td  class="table_title" BindText='bbsp_fc_dipmask2'></td> 
              <td  class="table_right"> <input type='text' id='DestMask' name='DestMask' maxlength='15' class='width_126px'> </td> 
            </tr>
			<script>
			getElById("DestMask").title = flowcontrol_language['bbsp_fc_note3'];
			</script>			
            <tr > 
              <td  class="table_title" BindText='bbsp_fc_sport2'></td> 
              <td  class="table_right"> <input type='text' id='SourcePort' name='SourcePort' maxlength='15' class='width_126px'> </td> 
            </tr>
			<script>
			getElById("SourcePort").title = flowcontrol_language['bbsp_fc_note'];
			</script>			
            <tr > 
              <td  class="table_title" BindText='bbsp_fc_sportmax'></td> 
              <td  class="table_right"> <input type='text' id='SourcePortRangeMax' name='SourcePortRangeMax' maxlength='15' class='width_126px'> </td> 
            </tr>
			<script>
			getElById("SourcePortRangeMax").title = flowcontrol_language['bbsp_fc_note'];
			</script>
            <tr > 
              <td  class="table_title" BindText='bbsp_fc_dport2'></td> 
              <td  class="table_right"> <input type='text' id='DestPort' name='DestPort' maxlength='15' class='width_126px'> </td> 
            </tr>
			<script>
			getElById("DestPort").title = flowcontrol_language['bbsp_fc_note'];
			</script>
            <tr > 
              <td  class="table_title" BindText='bbsp_fc_dportmax'></td> 
              <td  class="table_right"> <input type='text' id='DestPortRangeMax' name='DestPortRangeMax' maxlength='15' class='width_126px'> </td> 
            </tr>
			<script>
			getElById("DestPortRangeMax").title = flowcontrol_language['bbsp_fc_note'];
			</script>
            <tr > 
              <td  class="table_title" BindText='bbsp_fc_dscp'></td> 
              <td  class="table_right"> <input type='text' id='DSCPCheck' name='DSCPCheck' maxlength='15' class='width_126px'> 
			  <span class="gray"><script>document.write(flowcontrol_language['bbsp_fc_DSCPrange']);</script></span> </td> 
            </tr>
			<script>
			getElById("DSCPCheck").title = flowcontrol_language['bbsp_fc_note'];
			</script>
			<tr> 
			  <td class="table_title width_per15" BindText='bbsp_fc_classinterface'> </td> 
			  <td class="table_right width_per75"><select id="ClassInterface" name='ClassInterface' size="1" class="width_126px"> 
                  <script language="JavaScript" type="text/javascript">
                               WriteOptionInterface();
                  </script>  				  
				</select></td> 
			</tr>
            <tr> 
              <td BindText='bbsp_fc_actconfig'></td> 
            </tr>
			<tr> 
			  <td class="table_title width_per15" BindText='bbsp_fc_acttype2'> </td> 
			  <td class="table_right width_per75">
			    <select id="ActType" name='ActType' size="1" onChange="ActChange();" class="width_126px"> 
				  <option value="CAR">CAR</option> 
				  <option value="DROP">DROP</option> 
				</select>
			   </td> 
			</tr>
            <tr id = 'isCommittedRate'> 
              <td  class="table_title width_per15" BindText='bbsp_fc_qosmode'></td> 
              <td  class="table_right width_per75">
			     <select id="TrafficMode" name='TrafficMode' size="1" class='width_126px'> 
                  <script language="JavaScript" type="text/javascript">
                               WriteOption();
                            </script> 
                </select> </td>

            </tr>
            <tr id = 'is8021pRemark'> 
              <td  class="table_title" BindText='bbsp_fc_8021pRemark'></td> 
              <td  class="table_right"> <input type='text' id='EthernetPriorityMark' name='EthernetPriorityMark' maxlength='15' class='width_126px'>
				<span class="gray"><script>document.write(flowcontrol_language['bbsp_fc_8021prange']);</script></span> </td>
            </tr>
			<script>
			getElById("EthernetPriorityMark").title = flowcontrol_language['bbsp_fc_note2'];
			</script>
            <tr id = 'isDscpRemark'> 
              <td  class="table_title" BindText='bbsp_fc_dscpRemark'></td> 
              <td  class="table_right"> <input type='text' id='DSCPMark' name='DSCPMark' maxlength='15' class='width_126px'>
				<span class="gray"><script>document.write(flowcontrol_language['bbsp_fc_DSCPrange']);</script></span> </td> 
            </tr>
			<script>
			getElById("DSCPMark").title = flowcontrol_language['bbsp_fc_note2'];
			</script>
			<tr id = 'isQueueId'> 
			  <td class="table_title width_per15" BindText='bbsp_fc_queueId'> </td> 
			  <td class="table_right width_per75"><select id="X_HW_OutHardwareQueue" name='X_HW_OutHardwareQueue' size="1" 
										 class="width_126px"> 
				  <option value="-1"></option>
				  <option value="0">1</option>
				  <option value="1">2</option> 
				  <option value="2">3</option> 
				  <option value="3">4</option> 
				  <option value="4">5</option> 
				  <option value="5">6</option> 
				  <option value="6">7</option> 
				  <option value="7">8</option> 				  
				</select></td> 
			</tr> 			
          </table></td> 
      </tr> 
    </table> 
  <table cellpadding="0" cellspacing="1" width="100%" class="table_button"> 
    <tr> 
      <td class="width_per25" ></td> 
      <td class="table_submit"> 
	  	<button id="btnFlowcontrolApply" name="btnFlowcontrolApply" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="OnFlowcontrolApply();"><script>document.write(flowcontrol_language['bbsp_app']);</script></button> 
        <button id="btnFlowcontrolCancel" name="btnFlowcontrolCancel" class="CancleButtonCss buttonwidth_100px"  type="button" onClick="FlowcontrolCancelConfig();"><script>document.write(flowcontrol_language['bbsp_cancel']);</script></button>
	</td> 
    </tr> 	
  </table>  
  </div> 
  <script language="JavaScript" type="text/javascript">
	writeTabTail();
</script> 

</form> 
</body>
</html>
