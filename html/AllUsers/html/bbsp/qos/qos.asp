<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/topoinfo.asp"></script>
<script language="javascript" src="../common/qosinfo.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<title>qos</title>
<script language="JavaScript" src="./<%HW_WEB_CleanCache_Resource(muljsdiff.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" type="text/javascript">
var curUserType='<%HW_WEB_GetUserType();%>';
var E8CQoSMode = "<% HW_WEB_GetFeatureSupport(BBSP_FT_UPLINKQOS);%>";
var CUVoiceFeature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_UNICOM_DIS_VOICE);%>";
var QueueNum = 8;
var AppListMax = 2;
var ClassListMax = 16;
var ClassTypeItemMax = 4;
var TotoalTypeListMax = ClassTypeItemMax * ClassListMax;
var appIdx = -1;
var classIdx = -1;
var classtypeIdx = -1;
var showVoipWithVoice = false;
if( window.location.href.indexOf("?") > 0)
{
	if (window.location.href.indexOf("VOIP2VOICE") != -1 || CUVoiceFeature == "1")
	{
	    showVoipWithVoice = true;
	}
}
if("1" == GetCfgMode().SHCT){
    showVoipWithVoice = true;
}

function stWlan(Domain, name, enable)
{
    this.Domain = Domain;
    this.name = name;
    this.enable = enable;
}

var QosBasicInfoList = GetQosBasicInfoList();
var AppInfoList = GetAppInfoList();
var ClassificationInfoList = GetClassificationInfoList();
var ClassificationTypeInfoList = GetClassificationTypeInfoList();
var PriorityQueueInfoList = GetPriorityQueueInfoList();
var SortClassIdList = new Array();
SortClassIdList = GetSortClassInfoList();
var TopoInfo = GetTopoInfo();
var WlanInfoList = '<%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},Name|Enable,stWlan);%>';
if (WlanInfoList.length > 0) 
{
	WlanInfoList = eval(WlanInfoList);
}
else
{
	WlanInfoList = new Array(null);
}
function selectRemoveCnt(curCheck)
{

}
 
function setCtlDisplayApp(record)
{
	if (record.Domain == '')
	{
		setSelect("AppNameList", "");	
		setSelect("AppQueueList", "1");	
	}
	else
	{
		setSelect("AppNameList", record.AppName);	
		setSelect("AppQueueList", record.ClassQueue);	
	}
}

function setCtlDisplayClass(record)
{
	if (record.Domain == '')
	{
		setSelect("ClassQueueList", "1");	
		setText("ClassDhcp", "");
		setSelect("Class8021pList", "0");	
	}
	else
	{
		setSelect("ClassQueueList", record.ClassQueue);	
		setText("ClassDhcp", record.DSCPMarkValue);
		setSelect("Class8021pList", record.PriorityValue);	
	}
}

function setCtlDisplayClassType(record)
{
	var LanTopoRangeInfo = "";
	var TcpEnable = 0;
	var UdpEnable = 0;
	var IcmpEnable = 0;
	var RtpEnable = 0;

	if (record.Domain == '')
	{
		if (ClassificationInfoList.length - 1 > 0)
		{
			setSelect("ClassTypeIdList", SortClassIdList[0]);	
		}
		else if (ClassificationInfoList.length == 1)
		{
			setSelect("ClassTypeIdList", "");	
		}
		setDisable('ClassTypeIdList',0);
		setSelect("TypeList", "SMAC");	
		setText("ClassTypeMin", "");
		setText("ClassTypeMax", "");
		getElById("ClassTypeMin").title = "";
		getElById("ClassTypeMax").title = "";
		setCheck('cb_Tcp', 0);
		setCheck('cb_Udp', 0);
		setCheck('cb_Icmp', 0);
		setCheck('cb_Rtp', 0);
		setDisable('cb_Icmp',0);
	}
	else
	{
		setSelect("ClassTypeIdList", record.ClassificationId);	
		setDisable('ClassTypeIdList',1);
		setSelect("TypeList", record.Type);	
		LanTopoRangeInfo = getLanTopoRange();
		if (record.Type == "LANInterface")
		{
			setText("ClassTypeMin", record.MinShow);
			setText("ClassTypeMax", record.MaxShow);
			getElById("ClassTypeMin").title = qos_language['bbsp_startlanrange'] + LanTopoRangeInfo + qos_language['bbsp_classtypelantitle'];
			getElById("ClassTypeMax").title = qos_language['bbsp_endlanrange'] + LanTopoRangeInfo + qos_language['bbsp_classtypelantitle'];
		}
		else
		{
			setText("ClassTypeMin", record.Min);
			setText("ClassTypeMax", record.Max);
			getElById("ClassTypeMin").title = "";
			getElById("ClassTypeMax").title = "";
		}
		
		if ((record.Type == "TC") || (record.Type == "FL"))
		{
			setDisable('cb_Icmp',1);
		}
		else
		{
		    setDisable('cb_Icmp',0);
		}
		
		var Protocol = record.ProtocolList.split(","); 
		for (var i = 0;i < Protocol.length; i++)
		{
			if (Protocol[i] == "TCP")
			{
				TcpEnable = 1;
			}
			else if (Protocol[i] == "UDP")
			{
				UdpEnable = 1;
			}
			else if (Protocol[i] == "ICMP")
			{
				IcmpEnable = 1;
			}
			else if (Protocol[i] == "RTP")
			{
				RtpEnable = 1;
			}
		}
		setCheck('cb_Tcp', TcpEnable);
		setCheck('cb_Udp', UdpEnable);
		setCheck('cb_Icmp', IcmpEnable);
		setCheck('cb_Rtp', RtpEnable);
	}
}

function setControlApp(index)
{
	var record;
    appIdx = index;
	
	if (index == -1)
	{
		if (AppInfoList.length - 1 >= AppListMax)
		{
			setDisplay('QosAppConfigForm', 0);
			AlertEx(qos_language['bbsp_AppFull']);
			return;
		}
		else
		{
			record = new AppInfo('','','','');
			setDisplay('QosAppConfigForm', 1);
			setCtlDisplayApp(record);
		}
	}
	else if (index == -2)
	{
		setDisplay('QosAppConfigForm', 0);
	}
	else
	{
		record = AppInfoList[index];
		setDisplay('QosAppConfigForm', 1);
		setCtlDisplayApp(record);
	}
	
	setDisable('btnAppApply',0);
    setDisable('btnAppCancel',0);
}

function setControlClass(index)
{
	var record;
    classIdx = index;
	
	if (index == -1)
	{
		if (ClassificationInfoList.length - 1 >= ClassListMax)
		{
			setDisplay('QosClassConfigForm', 0);
			AlertEx(qos_language['bbsp_ClassFull']);
			return;
		}
		else
		{
			record = new ClassificationInfo('','','','');
			setDisplay('QosClassConfigForm', 1);
			setCtlDisplayClass(record);
		}
	}
	else if (index == -2)
	{
		setDisplay('QosClassConfigForm', 0);
	}
	else
	{
		record = ClassificationInfoList[index];
		setDisplay('QosClassConfigForm', 1);
		setCtlDisplayClass(record);
	}
	
	setDisable('btnClassApply',0);
    setDisable('btnClassCancel',0);
}

function setControlClassType(index)
{
	var record;
    classtypeIdx = index;
	
	if (index == -1)
	{
		if (ClassificationTypeInfoList.length - 1 >= TotoalTypeListMax)
		{
			setDisplay('QosClassTypeConfigForm', 0);
			AlertEx(qos_language['bbsp_ClassTypeFull']);
			return;
		}
		else
		{
			record = new ClassificationTypeInfo('','','','','');
			setDisplay('QosClassTypeConfigForm', 1);
			setCtlDisplayClassType(record);
		}
	}
	else if (index == -2)
	{
		setDisplay('QosClassTypeConfigForm', 0);
	}
	else
	{
		record = ClassificationTypeInfoList[index];
		setDisplay('QosClassTypeConfigForm', 1);
		setCtlDisplayClassType(record);
	}
	
	setDisable('btnClassTypeApply',0);
    setDisable('btnClassTypeCancel',0);
}

function IsClassIdBind(idx)
{
	var classId = ClassificationInfoList[idx].ClassificationId;
	if (ClassificationTypeInfoList.length == 1)
	{
		return false;
	}
	else if (ClassificationTypeInfoList.length > 1)
	{
		for (var i = 0; i < ClassificationTypeInfoList.length - 1; i++)
		{
			if (ClassificationTypeInfoList[i].ClassificationId == classId)
			{
				return true;
			}
		}
	}
	return false;
}

function clickRemoveApp() 
{
	if ((AppInfoList.length - 1) == 0)
	{
	    AlertEx(qos_language['bbsp_noApp']);
	    document.getElementById("QosApp_DeleteButton").disabled = false;
	    return;
	}
	
	var QosApprm1 = getElement('QosApp_rml');
	var noChooseFlag = true;
    if (QosApprm1.length > 0)
    {
         for (var i = 0; i < QosApprm1.length; i++)
         {
             if (QosApprm1[i].checked == true)
             {   
                 noChooseFlag = false;
             }
         }
    }
    else if (QosApprm1.checked == true)
    {
        noChooseFlag = false;
    }
    if ( noChooseFlag )
    {
        AlertEx(qos_language['bbsp_selecApp']);
        document.getElementById("QosApp_DeleteButton").disabled = false;
        return ;
    }
	
	if (ConfirmEx(qos_language['bbsp_confirmApp']) == false)
	{
		document.getElementById("QosApp_DeleteButton").disabled = false;
		return;
	}
	setDisable('btnAppApply',1);
	setDisable('btnAppCancel',1);
	removeInst('QosApp', 'html/bbsp/qos/qos.asp');
}

function clickRemoveClass() 
{
    if ((ClassificationInfoList.length - 1) == 0)
    {
        AlertEx(qos_language['bbsp_noClass']);
        document.getElementById("QosClass_DeleteButton").disabled = false;
        return;
    }

    var QosClassrm1 = getElement('QosClass_rml');
    var noChooseFlag = true;
    if (QosClassrm1.length > 0)
    {
        for (var i = 0; i < QosClassrm1.length; i++)
        {
            if (QosClassrm1[i].checked == true)
            {   
                if (IsClassIdBind(i) == true)
                {
                    AlertEx(qos_language['bbsp_ClassTypeId'] + ClassificationInfoList[i].ClassificationId + qos_language['bbsp_BindClass']);
                    document.getElementById("QosClass_DeleteButton").disabled = false;
                    return;
                }
                noChooseFlag = false;
            }
        }
    }
    else if (QosClassrm1.checked == true)
    {
        var UniqueInstIdx = 0;
        
        if (IsClassIdBind(UniqueInstIdx) == true)
        {
            AlertEx(qos_language['bbsp_ClassTypeId'] + ClassificationInfoList[UniqueInstIdx].ClassificationId + qos_language['bbsp_BindClass']);
            document.getElementById("QosClass_DeleteButton").disabled = false;
            return;
        }
        noChooseFlag = false;
    }
    
    if ( noChooseFlag )
    {
        AlertEx(qos_language['bbsp_selecClass']);
        document.getElementById("QosClass_DeleteButton").disabled = false;
        return ;
    }

    if (ConfirmEx(qos_language['bbsp_confirmClass']) == false)
    {
        document.getElementById("QosClass_DeleteButton").disabled = false;
        return;
    }
    setDisable('btnClassApply',1);
    setDisable('btnClassCancel',1);
    removeInst('QosClass', 'html/bbsp/qos/qos.asp');
}

function clickRemoveClassType() 
{
	if (ClassificationTypeInfoList.length - 1== 0)
	{
	    AlertEx(qos_language['bbsp_noClassType']);
	    document.getElementById("QosClassType_DeleteButton").disabled = false;
	    return;
	}
	
	var QosClassTyperm1 = getElement('QosClassType_rml');
	var noChooseFlag = true;
    if (QosClassTyperm1.length > 0)
    {
         for (var i = 0; i < QosClassTyperm1.length; i++)
         {
             if (QosClassTyperm1[i].checked == true)
             {   
                 noChooseFlag = false;
             }
         }
    }
    else if (QosClassTyperm1.checked == true)
    {
        noChooseFlag = false;
    }
    if ( noChooseFlag )
    {
        AlertEx(qos_language['bbsp_selecClassType']);
        document.getElementById("QosClassType_DeleteButton").disabled = false;
        return ;
    }
	
	if (ConfirmEx(qos_language['bbsp_confirmClassType']) == false)
	{
		document.getElementById("QosClassType_DeleteButton").disabled = false;
		return;
	}
	setDisable('btnClassTypeApply',1);
	setDisable('btnClassTypeCancel',1);
	removeInst('QosClassType', 'html/bbsp/qos/qos.asp');
}

function clickRemove(tabTitle) 
{
	switch(tabTitle)
	{
		case "QosApp":
			clickRemoveApp();
			break;
		case "QosClass":
			clickRemoveClass();
			break;
		case "QosClassType":
			clickRemoveClassType();
			break;
		default:
			break;
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
		b.innerHTML = qos_language[b.getAttribute("BindText")];
	}
}


function QosBasicBindPageData()
{
	if (null == QosBasicInfoList[0])
	{
		setCheck('QMQosEnable',0);
		if (E8CQoSMode == 1)
		{
			setText('QMQosModeText','OTHER');
			setText("Bandwidth", 0);
			setSelect("Planlist", "priority");	
			setDisplay("EnableForceWeightRow",0);
			setCheck('EnableForceWeight',0);
			setCheck('EnableDSCPMark',0);
			setSelect("PriorityValuelist", "0");	
		}
		else
		{
			setText('QMQosMode','');
		}
	}
	else
	{
		setCheck('QMQosEnable',QosBasicInfoList[0].Enable);
		if (E8CQoSMode == 1)
		{		
			if(true == showVoipWithVoice)
			{
				setText('QMQosModeText',QosBasicInfoList[0].X_HW_Mode.replace(new RegExp(/(VOIP)/g),"VOICE"));
			}
			else
			{
				setText('QMQosModeText',QosBasicInfoList[0].X_HW_Mode);
			}	
			
			setText("Bandwidth", parseInt(QosBasicInfoList[0].X_HW_Bandwidth/1024,10));
			setSelect("Planlist", QosBasicInfoList[0].X_HW_Plan);	
			if (QosBasicInfoList[0].X_HW_Plan == "weight")
			{
				setCheck('EnableForceWeight',QosBasicInfoList[0].X_HW_EnableForceWeight);
			}
			setCheck('EnableDSCPMark',QosBasicInfoList[0].X_HW_EnableDSCPMark);
			setSelect("PriorityValuelist", QosBasicInfoList[0].X_HW_Enable8021p);	
			
			setSelect('QMQosMode',qos_language['bbsp_selectdd']);
		}
		else
		{	
			if(true == showVoipWithVoice)
			{
				setText('QMQosModeText',QosBasicInfoList[0].X_HW_Mode.replace(new RegExp(/(VOIP)/g),"VOICE"));
			}
			else
			{
				setText('QMQosModeText',QosBasicInfoList[0].X_HW_Mode);
			}	
			setText('QMQosMode',QosBasicInfoList[0].X_HW_Mode);
		}
	}

	if(curUserType != '0')
	{
		setDisable("QMQosEnable",1);
		setDisable("QMQosMode",1);			
		setDisable("btnQosBasicApply",1);
		setDisable("QosBasiccancelValue",1);
	}
}

function DisplayQueueEnable(plan)
{
	var QueueId = "";
	var WeightId = "";
	
	for (var i = 0; i < PriorityQueueInfoList.length; i++)
	{
		if (plan == "weight")
		{
			QueueId = 'WRRRecord' + i;
			WeightId = 'WeightValue' + i;
			setCheck(QueueId,PriorityQueueInfoList[i].Enable);
			setText(WeightId, PriorityQueueInfoList[i].Weight);
		}
		else
		{
			QueueId = 'SPRecord' + i;
			setCheck(QueueId,PriorityQueueInfoList[i].Enable);
		}
	}
}

function QMBindPageData()
{
	if (null != PriorityQueueInfoList)
	{
		for (var i = 0; i < PriorityQueueInfoList.length; i++)
		{
			var QueueId = "";
			var WeightId = "";
			if (QosBasicInfoList[0] == null)
			{
				QueueId = 'SPRecord' + i;
				setCheck(QueueId,PriorityQueueInfoList[i].Enable);
			}
			else
			{
				DisplayQueueEnable(QosBasicInfoList[0].X_HW_Plan);
			}
		}
	}
}

function AppBindPageData()
{
	if (AppInfoList.length - 1 == 0)
	{
		selectLine('QosApp_record_no');
		setDisplay('QosAppConfigForm',0);
	}
	else
	{
		selectLine('QosApp_record_0');
		setDisplay('QosAppConfigForm',1);
	}
}

function ClassBindPageData()
{
	if (ClassificationInfoList.length - 1 == 0)
	{
		selectLine('QosClass_record_no');
		setDisplay('QosClassConfigForm',0);
	}
	else
	{
		selectLine('QosClass_record_0');
		setDisplay('QosClassConfigForm',1);
	}
}

function ClassTypeBindPageData()
{
	if (ClassificationTypeInfoList.length - 1 == 0)
	{
		selectLine('QosClassType_record_no');
		setDisplay('QosClassTypeConfigForm',0);
	}
	else
	{
		selectLine('QosClassType_record_0');
		setDisplay('QosClassTypeConfigForm',1);
	}
}

function setQosBasicDisplay(enableFlag)
{
	if (enableFlag == 0)
	{
		document.getElementById("BandwidthRow").style.display = "none";
		document.getElementById("PlanRow").style.display = "none";
		document.getElementById("EnableForceWeightRow").style.display = "none";
		document.getElementById("EnableDSCPMarkRow").style.display = "none";
		document.getElementById("Enable8021pRow").style.display = "none";
	}
	else if (enableFlag == 1)
	{
		document.getElementById("BandwidthRow").style.display = "";
		document.getElementById("PlanRow").style.display = "";
		document.getElementById("EnableForceWeightRow").style.display = "";
		document.getElementById("EnableDSCPMarkRow").style.display = "";
		document.getElementById("Enable8021pRow").style.display = "";
	}
}

function AddPriorityQueueInstance(Id)
{
	var InstanceId = Id + 1;
	if(PriorityQueueInfoList[Id].Domain != '')
	{	
		return ;
	}
	
	$.ajax({
	type : "POST",
	async : false,
	cache : false,
	data : 'o.Enable=' + PriorityQueueInfoList[Id].Enable + '&o.Priority=' + PriorityQueueInfoList[Id].Priority 
		   + '&o.Weight=' + PriorityQueueInfoList[Id].Weight + '&x.X_HW_Token=' + getValue('onttoken'),
	url :  'add.cgi?o=InternetGatewayDevice.X_HW_UplinkQos.PriorityQueue'
	  + '&RequestFile=html/application/not_find_file.asp',
	error:function(XMLHttpRequest, textStatus, errorThrown) 
	{
		if(XMLHttpRequest.status == 404)
		{
			PriorityQueueInfoList[Id].Domain = 'InternetGatewayDevice.X_HW_UplinkQos.PriorityQueue'+ InstanceId;
		}
	}
	});	
}

function setQosWebDisplay(flag)
{
	setQosBasicDisplay(flag);
	setDisplay("DivApp",flag);
	setDisplay("DivClassification",flag);
	setDisplay("DivClassificationType",flag);
	setDisplay("DivQueueManagement",flag);

	if (flag == 1)
	{
		QMBindPageData();
		AppBindPageData();
		ClassBindPageData();
		ClassTypeBindPageData();
	}
}

function LoadFrame()
{
	if (QosBasicInfoList[0] == null)
	{
		if (E8CQoSMode == 1)
		{
			setQosWebDisplay(1);
			setDisplay("EnableForceWeightRow",0);
		}
		else
		{
			setQosWebDisplay(0);
		}
	}
	else
	{
		if ((E8CQoSMode == 1) && (QosBasicInfoList[0].X_HW_Mode == "OTHER"))
		{
			setQosWebDisplay(1);
			if (QosBasicInfoList[0].X_HW_Plan == "weight")
			{
				setDisplay("EnableForceWeightRow",1);
			}
			else
			{
				setDisplay("EnableForceWeightRow",0);
			}
			setDisable('ClassTypeIdList',1);
			
		}
		else
		{
			setQosWebDisplay(0);
		}
	}
	
	QosBasicBindPageData();
	loadlanguage();
}

function setQosMode()
{
	var QosMode = getSelectVal('QMQosMode');

	if(QosMode != qos_language['bbsp_selectdd'])
	{
		if(true == showVoipWithVoice)
		{
			setText('QMQosModeText',QosMode.replace(new RegExp(/(VOIP)/g),"VOICE"));
		}
		else
		{
			setText('QMQosModeText',QosMode);
		}            
			
		if ((E8CQoSMode == 1) && (QosMode == "OTHER"))
		{
			setQosWebDisplay(1);
			if (getSelectVal('Planlist') == "weight")
			{
				setDisplay("EnableForceWeightRow",1);
			}
			else
			{
				setDisplay("EnableForceWeightRow",0);
			}
		}
		else
		{
			setQosWebDisplay(0);
		}
	}
	
}

function setQosPlan()
{
	var Plan = getSelectVal('Planlist');
	if (Plan == "weight")
	{
		setDisplay("DivSP",0);
		setDisplay("DivWRR",1);
		setDisplay("EnableForceWeightRow",1);
	}
	else
	{
		setDisplay("DivSP",1);
		setDisplay("DivWRR",0);
		setDisplay("EnableForceWeightRow",0);
	}
	DisplayQueueEnable(Plan);
}

function setQosClassType()
{
	setText('ClassTypeMin','');
	setText('ClassTypeMax','');
	var LanTopoRangeInfo = "";
	LanTopoRangeInfo = getLanTopoRange();

	if (getSelectVal('TypeList') == "LANInterface")
	{
		getElById("ClassTypeMin").title = qos_language['bbsp_startlanrange'] + LanTopoRangeInfo + qos_language['bbsp_classtypelantitle'];
		getElById("ClassTypeMax").title = qos_language['bbsp_endlanrange'] + LanTopoRangeInfo + qos_language['bbsp_classtypelantitle'];
		setDisable("cb_Icmp",0);
	}
	else if (getSelectVal('TypeList') == "FL")
	{
		getElById("ClassTypeMin").title = qos_language['bbsp_flprnote'];
		getElById("ClassTypeMax").title = qos_language['bbsp_flprnote'];
		setDisable("cb_Icmp",1);
	}
	else if ((getSelectVal('TypeList') == "FL")
		     ||(getSelectVal('TypeList') == "TC"))
	{
		setDisable("cb_Icmp",1);
	}
	else
	{
		getElById("ClassTypeMin").title = "";
		getElById("ClassTypeMax").title = "";
		setDisable("cb_Icmp",0);
	}
}

function CheckQosMode(QosMode)
{
	var QosModeArray ;
	if(true == showVoipWithVoice)
	{
		QosModeArray = new Array("TR069","VOICE","IPTV","INTERNET","OTHER");
	}
	else
	{
		QosModeArray = new Array("TR069","VOIP","IPTV","INTERNET","OTHER");
	}
	
	var QosModeTemp = QosMode.split(",");	
	for (i = 0; i < QosModeTemp.length; i++ )
	{
		for (j = i+1; j < QosModeTemp.length; j++ )
		{
			if((QosModeTemp[i]==QosModeTemp[j]) )
			{	
				return false;
			}	 
		}
	
		for (var k = 0; k < QosModeArray.length; k++)
		{   
			if( QosModeTemp[i] == QosModeArray[k] )
			{
			 	break;
			}	   
		}
		if(k == QosModeArray.length )
		{
			return false;
		}
	
		if (QosModeTemp[i]== "OTHER" && QosModeTemp.length > 1 )
		{
			return false;
		}   
	 
	}
	
	return true;
}

function OnQosBasicApply()
{
	var QosMode;
	if ( E8CQoSMode ==1 )
	{
		QosMode = getValue("QMQosModeText");
		QosMode = QosMode.toUpperCase();	
		if(!CheckQosMode(QosMode))
		{
			AlertEx(qos_language['bbsp_qosmodeinvalid']);
			return false;
		}
	}
	else
	{
		QosMode = getSelectVal('QMQosMode');
	}
	
	if(true == showVoipWithVoice)
	{
		QosMode = QosMode.replace(new RegExp(/(VOICE)/g),"VOIP");  
	}
		
	if ((E8CQoSMode ==1) && (QosMode == "OTHER"))
	{
		var Bandwidth = getValue("Bandwidth");
		Bandwidth = removeSpaceTrim(Bandwidth);
		if(Bandwidth!="")
		{
		   if ( false == CheckNumber(Bandwidth, 0, 1048576) )
		   {
			 AlertEx(qos_language['bbsp_bandwidthinvaild']);
			 return false;
		   }
		}
		else
		{
		   Bandwidth = 0;
		}
		Bandwidth = parseInt(Bandwidth,10)*1024;
	}

	var Form = new webSubmitForm();
	Form.addParameter('x.Enable',getCheckVal('QMQosEnable'));
	Form.addParameter('x.X_HW_Mode',QosMode);
	if ((E8CQoSMode ==1) && (QosMode == "OTHER"))
	{
		var Plan = getSelectVal('Planlist');
		Form.addParameter('x.X_HW_Bandwidth',Bandwidth);	
		Form.addParameter('x.X_HW_Plan',Plan);	
		if (Plan == "weight")
		{
			Form.addParameter('x.X_HW_EnableForceWeight',getCheckVal('EnableForceWeight'));	
		}
		Form.addParameter('x.X_HW_EnableDSCPMark',getCheckVal('EnableDSCPMark'));	
		Form.addParameter('x.X_HW_Enable8021p',getSelectVal('PriorityValuelist'));		
	}
	 	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('set.cgi?' + 'x=InternetGatewayDevice.QueueManagement' + '&RequestFile=html/bbsp/qos/qos.asp');
	setDisable('btnQosBasicApply',1);
    setDisable('QosBasiccancelValue',1);
	Form.submit();
}

function QosBasicCancelConfig()
{
    LoadFrame();
}

function IsQosModeOther()
{
	if (QosBasicInfoList[0] == null)
	{
		AlertEx(qos_language['bbsp_qosmodenull']);
		return false;
	}
	else 
	{
		if (QosBasicInfoList[0].X_HW_Mode != "OTHER")
		{
			AlertEx(qos_language['bbsp_qosmodereq']);
			return false;
		}
	}
	return true;
}

function OnQMApply()
{
	if (IsQosModeOther() == false)
	{
		return false;
	}

	var Plan = QosBasicInfoList[0].X_HW_Plan;
	var url = "";
	var weightSum = 0;
	var weightVal = "";
	var QueueId = "";
	var queuewightId = "";
	var i;
	var Form = new webSubmitForm();
	
	if (Plan == "weight")
	{        
		var SelectedQueueNr = 0;
		
		for (var j = 0; j < QueueNum; j++) 
		{
			QueueId = 'WRRRecord' + j;
			queuewightId = 'WeightValue' + j;

			if (getCheckVal(QueueId) == 1)
			{
				weightVal = getValue('WeightValue' + j);
				weightVal = removeSpaceTrim(weightVal);
				if(weightVal!="")
				{
				   if ( false == CheckNumber(weightVal, 0, 100) )
				   {
					 AlertEx(qos_language['bbsp_weightRange']);
					 return false;
				   }
				}
				else
				{
				   weightVal = 0;
				}
				
				SelectedQueueNr++;
				weightSum += parseInt(weightVal, 10);
			}
		}
		
		if (weightSum != 100 && SelectedQueueNr > 0)
		{
			AlertEx(qos_language['bbsp_weightsummsg']);
			return false;
		}
	}
	
	for (i = 0; i < QueueNum; i++) 
	{
		if (Plan == "weight")
		{
			QueueId = 'WRRRecord' + i;
			weightVal = getValue('WeightValue' + i);
			if (weightVal == "")
			{
				weightVal = 0;
			}
			else
			{
				weightVal = parseInt(weightVal, 10);
			}
			Form.addParameter('y'+i+'.Weight', weightVal);	
		}
		else
		{
			QueueId = 'SPRecord' + i;
		}
		Form.addParameter('y'+i+'.Enable', getCheckVal(QueueId));	
		Form.addParameter('y'+i+'.Priority', i+1);	
		if (i == 0)
		{
			url += "y" + i + "=InternetGatewayDevice.X_HW_UplinkQos.PriorityQueue." + (i+1);
		}
		else if (i > 0)
		{
			url += "&y" + i + "=InternetGatewayDevice.X_HW_UplinkQos.PriorityQueue." + (i+1);
		}
	}
	
	for (i = 0; i < QueueNum; i++)
	{
		AddPriorityQueueInstance(i);
	}
	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('set.cgi?' + url + '&RequestFile=html/bbsp/qos/qos.asp');
	setDisable('btnQMApply',1);
    setDisable('QMcancelValue',1);
	Form.submit();
}

function QMCancelConfig()
{
    LoadFrame();
}

function IsRepeateAppConfig()
{
	for(var i = 0; i < AppInfoList.length - 1; i++)
	{
		if (i != appIdx)
		{
			if (getSelectVal('AppNameList') == "")
			{
				if ((AppInfoList[i].AppName == getSelectVal('AppNameList'))
					&& (AppInfoList[i].ClassQueue == getSelectVal('AppQueueList')))
				{
					AlertEx(qos_language['bbsp_appruleexist']);
					return true;
				}
			}
			else
			{
				if (AppInfoList[i].AppName == getSelectVal('AppNameList'))
				{
					if(true == showVoipWithVoice)
					{
						AlertEx(qos_language['bbsp_appnameexist'] + AppInfoList[i].AppName.replace(new RegExp(/(VOIP)/g),"VOICE") + qos_language['bbsp_appruleexist1']);
					}
					else
					{
						AlertEx(qos_language['bbsp_appnameexist'] + AppInfoList[i].AppName + qos_language['bbsp_appruleexist1']);
					}
					return true;
				}
			}		
		}
	}
	return false;
}

function OnAppApply()
{
	if (IsQosModeOther() == false)
	{
		return false;
	}
	
	if (true == IsRepeateAppConfig())
	{
        return false;
	}
	
 	var Form = new webSubmitForm();
	Form.addParameter('x.AppName',getSelectVal('AppNameList'));
	Form.addParameter('x.ClassQueue',getSelectVal('AppQueueList'));	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	
	if( appIdx == -1 )
	{
		Form.setAction('add.cgi?x=InternetGatewayDevice.X_HW_UplinkQos.App' + '&RequestFile=html/bbsp/qos/qos.asp');
	}
	else
	{
		Form.setAction('set.cgi?x=' + AppInfoList[appIdx].Domain + '&RequestFile=html/bbsp/qos/qos.asp');
	}

	Form.submit();
	DisableRepeatSubmit();
	setDisable('btnAppApply',1);
    setDisable('btnAppCancel',1);
}

function IsRepeateClassConfig(ClassDhcp)
{
	for(var i = 0; i < ClassificationInfoList.length - 1; i++)
	{
		if (i != classIdx)
		{
			if ((ClassificationInfoList[i].ClassQueue == getSelectVal('ClassQueueList'))
				&& (ClassificationInfoList[i].DSCPMarkValue == ClassDhcp)
				&& (ClassificationInfoList[i].PriorityValue == getSelectVal('Class8021pList')))
			{
				return true;
			}
		}
	}
	return false;
}

function OnClassApply()
{
	if (IsQosModeOther() == false)
	{
		return false;
	}

	var ClassDhcp = getValue("ClassDhcp");
	ClassDhcp = removeSpaceTrim(ClassDhcp);

	if(ClassDhcp!="")
	{
	   if ( false == CheckNumber(ClassDhcp, 0, 63) )
	   {
		 AlertEx(qos_language['bbsp_classdhcpinvaild']);
		 return false;
	   }
	}
	else
	{
	   ClassDhcp = 0;
	}
	ClassDhcp = parseInt(ClassDhcp, 10);
	
	if (true == IsRepeateClassConfig(ClassDhcp))
	{
		AlertEx(qos_language['bbsp_classruleexist']);
        return false;
	}

	var Form = new webSubmitForm();
	Form.addParameter('x.ClassQueue',getSelectVal('ClassQueueList'));
	Form.addParameter('x.DSCPMarkValue',ClassDhcp);
	Form.addParameter('x.PriorityValue',getSelectVal('Class8021pList'));
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));	
	if(classIdx == -1)
	{
		Form.setAction('add.cgi?x=InternetGatewayDevice.X_HW_UplinkQos.Classification' + '&RequestFile=html/bbsp/qos/qos.asp');
	}
	else
	{
		Form.setAction('set.cgi?x=' + ClassificationInfoList[classIdx].Domain + '&RequestFile=html/bbsp/qos/qos.asp');
	}
	
	Form.submit();
	DisableRepeatSubmit();
	setDisable('btnClassApply',1);
    setDisable('btnClassCancel',1);
}

function CancelConfig(tableID)
{
	var Index;
	var record;
	switch (tableID)
	{
		case "QosApp":
			Index = appIdx;
			break;
		case "QosClass":
			Index = classIdx;
			break;
		case "QosClassType":
			Index = classtypeIdx;
			break;
		default:
			break;
	}

	setDisplay(tableID+"ConfigForm", 0);
	if (Index == -1)
	{
		var tableRow = getElement(tableID+"Inst");
		if (tableRow.rows.length == 1)
        {
		
        }
		else if (tableRow.rows.length == 2)
		{
            addNullInst(tableID);
        }
		else
		{
			tableRow.deleteRow(tableRow.rows.length-1);
            selectLine(tableID+'_record_0');
		}
	}
	else
	{
		switch (tableID)
		{
			case "QosApp":
			{
				record = AppInfoList[Index];
				setCtlDisplayApp(record);
				break;
			}
			case "QosClass":
			{
				record = ClassificationInfoList[Index];
				setCtlDisplayClass(record);
				break;
			}
			case "QosClassType":
			{
				record = ClassificationTypeInfoList[Index];
				setCtlDisplayClassType(record);
				break;
			}
			default:
				break;
		}
	}
}

function CheckSMAC(MacStart, MacEnd)
{   
	if((MacStart != "") && (isValidMacAddress(MacStart) == false))
    {
        AlertEx(qos_language['bbsp_startsmac'] + MacStart + qos_language['bbsp_macisinvalid']);
        return false;
    }
	if((MacEnd != "") && (isValidMacAddress(MacEnd) == false))
    {
        AlertEx(qos_language['bbsp_endsmac'] + MacEnd + qos_language['bbsp_macisinvalid']);
        return false;
    }
	if (MacEnd != "" 
	    && (MacAddress2DecNum(MacStart) > MacAddress2DecNum(MacEnd)))
	{
		AlertEx(qos_language['bbsp_startsmacinvalid']);
		return false;     	
	}		
	if (MacStart == "" && MacEnd != "") 
	{
		AlertEx(qos_language['bbsp_startsmacisreq']);
		return false;
	}
	return true;
}
 
function Check8021P(PriStart, PriEnd)
{
	if ((PriStart != "") && (false == CheckNumber(PriStart, 0, 7)))
	{
		AlertEx(qos_language['bbsp_start8021Prange']);
		return false;
	}
	
	if ((PriEnd != "") && (false == CheckNumber(PriEnd, 0, 7)))
	{
		AlertEx(qos_language['bbsp_end8021Prange']);
		return false;
	}
	if (PriEnd != "" 
		&& parseInt(PriStart, 10) > parseInt(PriEnd, 10))
	{
		AlertEx(qos_language['bbsp_start8021Pinvalid']);
		return false;     	
	}	
	if (PriStart == "" && PriEnd != "") 
	{
		AlertEx(qos_language['bbsp_start8021Pisreq']);
		return false;
	}
	return true;
}

function CheckIpv6Parameter(IPv6Address)
{
	if (IsIPv6AddressValid(IPv6Address) == false)
	{
	    return false;
	}

	if (IsIPv6MulticastAddress(IPv6Address) == true)
	{
	    return false;  
	} 

	if (IsIPv6ZeroAddress(IPv6Address) == true) 
	{
	    return false;
	}

	if (IsIPv6LoopBackAddress(IPv6Address) == true)
	{
	    return false;  
	}
	return true; 
}

function CheckSIP(IPStart, IPEnd)
{
	if (IPStart != "" && (isAbcIpAddress(IPStart) == false && CheckIpv6Parameter(IPStart) == false))
	{
		AlertEx(qos_language['bbsp_startsip'] + IPStart + qos_language['bbsp_isvalid']);
		return false;
	}
	if (IPEnd != "" && (isAbcIpAddress(IPEnd) == false && CheckIpv6Parameter(IPEnd) == false))
	{
		AlertEx(qos_language['bbsp_endsip'] + IPEnd + qos_language['bbsp_isvalid']);
		return false;
	}
	if ((isAbcIpAddress(IPStart) == true && CheckIpv6Parameter(IPEnd) == true)
		|| (isAbcIpAddress(IPEnd) == true && CheckIpv6Parameter(IPStart) == true))
	{
		AlertEx(qos_language['bbsp_ipcollide']);
		return false;
	}
	if (IPEnd != "" 
	    && (isAbcIpAddress(IPStart) == true)
	    &&(IpAddress2DecNum(IPStart) > IpAddress2DecNum(IPEnd)))
	{
		AlertEx(qos_language['bbsp_startsipinvalid']);
		return false;     	
	}	
	if (IPEnd != ""
		&& (CheckIpv6Parameter(IPStart) == true)
		&& (isStartIpbigerEndIp(IPStart,IPEnd) == true))
	{
		AlertEx(qos_language['bbsp_startsipinvalid']);
		return false;     	
	}
    if (IPStart == "" && IPEnd != "" ) 
	{
		AlertEx(qos_language['bbsp_startsipisreq']);
		return false;
	}
	return true;
}

function CheckDIP(IPStart, IPEnd)
{
	if (IPStart != "" && (isAbcIpAddress(IPStart) == false && CheckIpv6Parameter(IPStart) == false))
	{
		AlertEx(qos_language['bbsp_startdip'] + IPStart + qos_language['bbsp_isvalid']);
		return false;
	}
	if (IPEnd != "" && (isAbcIpAddress(IPEnd) == false && CheckIpv6Parameter(IPEnd) == false))
	{
		AlertEx(qos_language['bbsp_enddip'] + IPEnd + qos_language['bbsp_isvalid']);
		return false;
	}
	if ((isAbcIpAddress(IPStart) == true && CheckIpv6Parameter(IPEnd) == true)
		|| (isAbcIpAddress(IPEnd) == true && CheckIpv6Parameter(IPStart) == true))
	{
		AlertEx(qos_language['bbsp_ipcollide']);
		return false;
	}
	if (IPEnd != "" 
	    && (isAbcIpAddress(IPStart) == true)
	    &&(IpAddress2DecNum(IPStart) > IpAddress2DecNum(IPEnd)))
	{
		AlertEx(qos_language['bbsp_startdipinvalid']);
		return false;     	
	}	
	if (IPEnd != ""
		&& (CheckIpv6Parameter(IPStart) == true)
		&& (isStartIpbigerEndIp(IPStart,IPEnd) == true))
	{
		AlertEx(qos_language['bbsp_startdipinvalid']);
		return false;     	
	}
		
    if (IPStart == "" && IPEnd != "") 
	{
		AlertEx(qos_language['bbsp_startdipisreq']);
		return false;
	}
	return true;
}

function CheckSPORT(PortStart, PortEnd)
{
	if ((PortStart != "") && (false == CheckNumber(PortStart, 1, 65535)))
	{
		AlertEx(qos_language['bbsp_startsportrange']);
		return false;
	}
	
	if ((PortEnd != "") && (false == CheckNumber(PortEnd, 1, 65535)))
	{
		AlertEx(qos_language['bbsp_endsportrange']);
		return false;
	}

	 if (PortEnd != "" 
		&& parseInt(PortStart, 10) > parseInt(PortEnd, 10))
	{
		AlertEx(qos_language['bbsp_startsportinvalid']);
		return false;     	
	}	
	if (PortStart == "" && PortEnd != "" ) 
	{
		AlertEx(qos_language['bbsp_startsportisreq']);
		return false;
	}
	return true;
}

function CheckDPORT(PortStart, PortEnd)
{
	if ((PortStart != "") && (false == CheckNumber(PortStart, 1, 65535)))
	{
		AlertEx(qos_language['bbsp_startdportrange']);
		return false;
	}
	
	if ((PortEnd != "") && (false == CheckNumber(PortEnd, 1, 65535)))
	{
		AlertEx(qos_language['bbsp_enddportrange']);
		return false;
	}
	if (PortEnd != "" 
		&& parseInt(PortStart, 10) > parseInt(PortEnd, 10))
	{
		AlertEx(qos_language['bbsp_startdportinvalid']);
		return false;     	
	}	
	if (PortStart == "" && PortEnd != "" ) 
	{
		AlertEx(qos_language['bbsp_startdportisreq']);
		return false;
	}
	return true;
}

function CheckTOS(TosStart, TosEnd)
{
	if ((TosStart != "") && (false == CheckNumber(TosStart, 0, 7)))
	{
		AlertEx(qos_language['bbsp_starttosrange']);
		return false;
	}
	
	if ((TosEnd != "") && (false == CheckNumber(TosEnd, 0, 7)))
	{
		AlertEx(qos_language['bbsp_endtosrange']);
		return false;
	}
	if (TosEnd != "" 
		&& parseInt(TosStart, 10) > parseInt(TosEnd, 10))
	{
		AlertEx(qos_language['bbsp_starttosinvalid']);
		return false;     	
	}	
	if (TosStart == "" && TosEnd != "" ) 
	{
		AlertEx(qos_language['bbsp_starttosisreq']);
		return false;
	}
	return true;
}

function CheckDSCP(DhcpStart, DhcpEnd)
{
	if ((DhcpStart != "") && (false == CheckNumber(DhcpStart, 0, 63)))
	{
		AlertEx(qos_language['bbsp_startdhcprange']);
		return false;
	}
	
	if ((DhcpEnd != "") && (false == CheckNumber(DhcpEnd, 0, 63)))
	{
		AlertEx(qos_language['bbsp_enddhcprange']);
		return false;
	}
	if (DhcpEnd != "" 
		&& parseInt(DhcpStart, 10) > parseInt(DhcpEnd, 10))
	{
		AlertEx(qos_language['bbsp_startdhcpinvalid']);
		return false;     	
	}	
	if (DhcpStart == "" && DhcpEnd != "" ) 
	{
		AlertEx(qos_language['bbsp_startdhcpisreq']);
		return false;
	}
	return true;
}

function CheckTC(TCStart, TCEnd)
{
	if ((TCStart != "") && (false == CheckNumber(TCStart, 0, 7)))
	{
		AlertEx(qos_language['bbsp_starttcrange']);
		return false;
	}
	
	if ((TCEnd != "") && (false == CheckNumber(TCEnd, 0, 7)))
	{
		AlertEx(qos_language['bbsp_endtcrange']);
		return false;
	}
	if (TCEnd != "" 
		&& parseInt(TCStart, 10) > parseInt(TCEnd, 10))
	{
		AlertEx(qos_language['bbsp_starttcinvalid']);
		return false;     	
	}	
	if (TCStart == "" && TCEnd != "" ) 
	{
		AlertEx(qos_language['bbsp_starttcisreq']);
		return false;
	}
	return true;
}

function CheckFL(FLStart, FLEnd)
{
	if ((FLStart != "") && (false == CheckNumberHex(FLStart, 0, 'fffff')))
	{
		AlertEx(qos_language['bbsp_startflrange']);
		return false;
	}
	
	if ((FLEnd != "") && (false == CheckNumberHex(FLEnd, 0, 'fffff')))
	{
		AlertEx(qos_language['bbsp_endflrange']);
		return false;
	}
	if (FLEnd != "" 
		&& parseInt(FLStart, 16) > parseInt(FLEnd, 16))
	{
		AlertEx(qos_language['bbsp_startflinvalid']);
		return false;     	
	}	
	if (FLStart == "" && FLEnd != "" ) 
	{
		AlertEx(qos_language['bbsp_startflisreq']);
		return false;
	}
	return true;
}
function IsBindISPPort(Idx)
{
	var ret = false;
	
	try
	{
		var ISPPortList = GetISPPortList();
		if(ISPPortList.length > 0)
		{
			var pos = ArrayIndexOf(ISPPortList, 'SSID'+Idx);
			if(pos >= 0)
			{
				ret = true;
			}
		}
	}
	catch(e)
	{
		ret = false;
	}
		
	return ret;
}

function findSSIDIndexValid(CurIndex)
{
	var index;
	if (WlanInfoList.length -1 > 0)
	{
		for (var i = 0; i < WlanInfoList.length -1; i++)
		{
			index = parseInt(WlanInfoList[i].name.charAt(WlanInfoList[i].name.length -1),10) + 1;
			if (CurIndex == index)
			{
				if(IsBindISPPort(index) == false)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}
	}
	return false;
}

function getLanTopoRange()
{
	var EthNum = TopoInfo.EthNum;
	var SSIDNum = TopoInfo.SSIDNum;
	var LanTopoRange = "";
	var i;
	
	if (EthNum > 0)
	{
		if (EthNum == 1)
		{
			LanTopoRange += "LAN" + EthNum;
		}
		else
		{
			LanTopoRange += "LAN1-LAN" + EthNum;
		}
	}
	
	if (WlanInfoList.length -1 > 0)
	{
		for (i = 0; i < WlanInfoList.length -1; i++)
		{
			var idex = parseInt(WlanInfoList[i].name.charAt(WlanInfoList[i].name.length -1),10) + 1;
			if(IsBindISPPort(idex) == false)
			{
				LanTopoRange += "，" + "SSID" + idex;
			}
		}
	}
    
	LanTopoRange += "。";
	return LanTopoRange;
}

function setLanInterfaceVaildMsg(errorfalg)
{
	var errormsg = "";
	var LanTopoRangeInfo = "";
	LanTopoRangeInfo = getLanTopoRange();
	
	if (errorfalg == "start")
	{
		errormsg = qos_language['bbsp_startlanrange'] + LanTopoRangeInfo;
	}
	else if (errorfalg == "end")
	{
		errormsg = qos_language['bbsp_endlanrange'] + LanTopoRangeInfo;
	}
	return errormsg;
}

function CheckLanInterfaceVaild(LanInterfaceValue)
{
	var EthNum = TopoInfo.EthNum;
	var SSIDNum = TopoInfo.SSIDNum;
	
	if (LanInterfaceValue != "")
	{
		var lanIdex = LanInterfaceValue.substring(3,LanInterfaceValue.length);
		var ssidIdex = LanInterfaceValue.substring(4,LanInterfaceValue.length);

		if ((LanInterfaceValue.toUpperCase().substr(0,3) != "LAN") && (LanInterfaceValue.toUpperCase().substr(0,4) != "SSID"))
		{
			return false;  
		}
		
		if (LanInterfaceValue.toUpperCase().substr(0,3) == "LAN")
		{
			if (!isInteger(lanIdex))
			{
				return false;
			}
			
			lanIdex = parseInt(lanIdex, 10);
			if (EthNum > 0)
			{			
				if (lanIdex < 0 || lanIdex > EthNum)
				{
					return false;
				}
			}
			else
			{
				return false;  
			}
		}
		else if (LanInterfaceValue.toUpperCase().substr(0,4) == "SSID")
		{
			if (!isInteger(ssidIdex))
			{
				return false;
			}
			
			ssidIdex = parseInt(ssidIdex, 10);
			if ((ssidIdex < 0) || (findSSIDIndexValid(ssidIdex) == false))
			{
				return false;
			}
		}
	}
	return true;
}

function CheckLANInterface(LanStart, LanEnd)
{
	LanStart = removeSpaceTrim(LanStart);
	LanEnd = removeSpaceTrim(LanEnd);
	var lanStartIdex = "";
	var lanEndIdex = "";
	var ssidStartIdex = "";
	var ssidEndIdex = "";
	
	if (CheckLanInterfaceVaild(LanStart) == false)
	{
		AlertEx(setLanInterfaceVaildMsg("start"));
		return false;  
	}	

	if (CheckLanInterfaceVaild(LanEnd) == false)
	{
		AlertEx(setLanInterfaceVaildMsg("end"));
		return false;  
	}	
	
	if (LanStart != "" && LanEnd != "")
	{
		lanStartIdex = LanStart.substring(3,LanStart.length);
		lanEndIdex = LanEnd.substring(3,LanEnd.length);
		lanStartIdex = parseInt(lanStartIdex, 10);
		lanEndIdex = parseInt(lanEndIdex, 10);
		if (LanStart.toUpperCase().substr(0,3) == "LAN")
		{
			if (LanEnd.toUpperCase().substr(0,3) == "LAN")
			{
				if (lanStartIdex > lanEndIdex)
				{
					AlertEx(qos_language['bbsp_startlaninvalid']);
					return false; 
				}
			}
			else if (LanEnd.toUpperCase().substr(0,4) == "SSID")
			{
				AlertEx(qos_language['bbsp_laninterfacediff']);
				return false;  
			}
		}
		else if (LanStart.toUpperCase().substr(0,4) == "SSID")
		{
			if (LanEnd.toUpperCase().substr(0,3) == "LAN")
			{
				AlertEx(qos_language['bbsp_laninterfacediff']);
				return false;  
			}
			else if (LanEnd.toUpperCase().substr(0,4) == "SSID")
			{
				if (lanStartIdex > lanEndIdex)
				{
					AlertEx(qos_language['bbsp_startlaninvalid']);
					return false; 
				}
			}
		}
	}
	
	if (LanStart == "" && LanEnd != "")
	{
		AlertEx(qos_language['bbsp_startlanisreq']);
		return false;
	}
	return true;
}

function getSelectProtocol()
{	
	var EnableList = new Array();
	var ProtocolList = "";
	
	EnableList[0] = (1 == getCheckVal('cb_Tcp')) ? "TCP" : "";
	EnableList[1] = (1 == getCheckVal('cb_Udp')) ? "UDP" : "";
	EnableList[2] = (1 == getCheckVal('cb_Icmp')) ? "ICMP" : "";
	EnableList[3] = (1 == getCheckVal('cb_Rtp')) ? "RTP" : "";
	
	for (var i=0; i<EnableList.length; i++)
	{
		if (EnableList[i] != "")
		{
			ProtocolList += EnableList[i] + ",";
		}
	}
    
	if(ProtocolList.length)
		ProtocolList = ProtocolList.substr(0,ProtocolList.length-1);
        
	return ProtocolList;
}

function IsRepeateClassTypeConfig(ClassId, Min, Max, ProtocolList)
{
	var TypeInfo = getSelectVal('TypeList');
	
	for(var i = 0; i < ClassificationTypeInfoList.length - 1; i++)
	{
		if (i != classtypeIdx)
		{
			if ((ClassificationTypeInfoList[i].ClassificationId == ClassId)
				&& (ClassificationTypeInfoList[i].Type == TypeInfo)
				&& (ClassificationTypeInfoList[i].Min == Min)
				&& (ClassificationTypeInfoList[i].Max == Max)
				&& (ClassificationTypeInfoList[i].ProtocolList == ProtocolList))
			{
				return true;
			}
		}
	}
	return false;
}

function GetClsTypeItemNum(ClassId)
{
	var Num = 0;
	
	for(var i = 0; i < ClassificationTypeInfoList.length - 1; i++)
	{
		if (ClassificationTypeInfoList[i].ClassificationId == ClassId)
		{
			Num ++;
		}
	}
	
	return Num;
}

function findClassIdValid(classId)
{
	var id;
	if (ClassificationInfoList.length - 1 > 0)
	{
		for (var i = 0; i < ClassificationInfoList.length - 1; i++)
		{
			id = parseInt(ClassificationInfoList[i].Domain.charAt(ClassificationInfoList[i].Domain.length -1),10);
			if (classId == id)
			{
				return true;
			}
		}
	}
	return false;
}

function checkClassId(classId)
{
	var id;
	classId = removeSpaceTrim(classId);
	if(classId != "")
	{
		if (!isInteger(classId))
		{
			AlertEx(qos_language['bbsp_classidinvalid']);
			return false;
		} 
		classId = parseInt(classId, 10);
		if (ClassificationInfoList.length == 1)
		{
			AlertEx(qos_language['bbsp_createclassid']);
			return false;
		}
		if (findClassIdValid(classId) == false)
		{
			AlertEx(qos_language['bbsp_classidreq']);
			return false;
		}
	}
	else
	{
		AlertEx(qos_language['bbsp_classidnull']);
		return false;
	}
	return false;
}


function OnClassTypeApply()
{
	if (IsQosModeOther() == false)
	{
		return false;
	}

	var CurClassificationId = getSelectVal('ClassTypeIdList');
	if (CurClassificationId == "")
	{
		AlertEx(qos_language['bbsp_createclassid']);
		return false;
	}
	
	if(classtypeIdx == -1)
	{
		var ItemNum = GetClsTypeItemNum(CurClassificationId);
		if(ItemNum >= ClassTypeItemMax)
		{
			AlertEx(qos_language['bbsp_TypeItemFull']);
			return false;
		}
	}
	
	var TypeList = getSelectVal('TypeList');
	var ClassTypeMin = getValue("ClassTypeMin");	
	ClassTypeMin = removeSpaceTrim(ClassTypeMin);
	var ClassTypeMax = getValue("ClassTypeMax");
	ClassTypeMax = removeSpaceTrim(ClassTypeMax);

	if ((TypeList == "SMAC") && (CheckSMAC(ClassTypeMin, ClassTypeMax) == false))
	{
		return false;
	}
	else if ((TypeList == "8021P") && (Check8021P(ClassTypeMin, ClassTypeMax) == false))
	{
		return false;
	}
	else if ((TypeList == "SIP") && (CheckSIP(ClassTypeMin, ClassTypeMax) == false))
	{
		return false;
	}
	else if ((TypeList == "DIP") && (CheckDIP(ClassTypeMin, ClassTypeMax) == false))
	{
		return false;
	}
	else if ((TypeList == "SPORT") && (CheckSPORT(ClassTypeMin, ClassTypeMax) == false)) 
	{
		return false;
	}
	else if ((TypeList == "DPORT") && (CheckDPORT(ClassTypeMin, ClassTypeMax) == false))
	{
		return false;
	}
	else if ((TypeList == "TOS") && (CheckTOS(ClassTypeMin, ClassTypeMax) == false))
	{
		return false;
	}
	else if ((TypeList == "DSCP") && (CheckDSCP(ClassTypeMin, ClassTypeMax) == false))
	{
		return false;
	}
	else if ((TypeList ==  "LANInterface") && (CheckLANInterface(ClassTypeMin, ClassTypeMax) == false))
	{
		return false;
	}
	else if ((TypeList ==  "TC") && (CheckTC(ClassTypeMin, ClassTypeMax) == false))
	{
		return false;
	}
	else if ((TypeList ==  "FL") && (CheckFL(ClassTypeMin, ClassTypeMax) == false))
	{
		return false;
	}
	
	if ((TypeList == "8021P") || (TypeList == "SPORT") || (TypeList == "DPORT") || (TypeList == "TOS") || (TypeList == "DSCP"))
	{
		ClassTypeMin = ClassTypeMin.length?parseInt(ClassTypeMin, 10):"";
		ClassTypeMax = ClassTypeMax.length?parseInt(ClassTypeMax, 10):"";
	}
	else if (TypeList ==  "LANInterface")
	{
	    var lanminindex = ClassTypeMin.charAt(ClassTypeMin.length-1);
		var lanmaxindex = ClassTypeMax.charAt(ClassTypeMax.length-1);
		var lanurl = "InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.";
		var ssidurl = "InternetGatewayDevice.LANDevice.1.WLANConfiguration.";
		if (ClassTypeMin.toUpperCase().indexOf("LAN") != -1)
		{
			ClassTypeMin = lanurl + lanminindex;
		}
		else if (ClassTypeMin.toUpperCase().indexOf("SSID") != -1)
		{
			ClassTypeMin = ssidurl + lanminindex;
		}
		
		if (ClassTypeMax.toUpperCase().indexOf("LAN") != -1)
		{
			ClassTypeMax = lanurl + lanmaxindex;
		}
		else if (ClassTypeMax.toUpperCase().indexOf("SSID") != -1)
		{
			ClassTypeMax = ssidurl + lanmaxindex;
		}
	}
	
	var ProtocolList = getSelectProtocol();
	if (true == IsRepeateClassTypeConfig(CurClassificationId, ClassTypeMin, ClassTypeMax, ProtocolList))
	{
		AlertEx(qos_language['bbsp_classtyperuleexist']);
        return false;
	}
	
	var Form = new webSubmitForm();
	Form.addParameter('x.Type',getSelectVal('TypeList'));	
	Form.addParameter('x.Min',ClassTypeMin);
	Form.addParameter('x.Max',ClassTypeMax);		
	Form.addParameter('x.ProtocolList',ProtocolList);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	
	if( classtypeIdx == -1 )
	{
		Form.setAction('add.cgi?x=InternetGatewayDevice.X_HW_UplinkQos.Classification.' + CurClassificationId + ".type" + '&RequestFile=html/bbsp/qos/qos.asp');
	}
	else
	{
		var CurClassificationTypeId = ClassificationTypeInfoList[classtypeIdx].ClassificationTypeId ;
		var classmain = "InternetGatewayDevice.X_HW_UplinkQos.Classification." + CurClassificationId + ".type." + CurClassificationTypeId;
		Form.setAction('set.cgi?x=' + classmain + '&RequestFile=html/bbsp/qos/qos.asp');
	}

	Form.submit();
	setDisable('btnClassTypeApply',1);
    setDisable('btnClassTypeCancel',1);
}

function setControlDispatch(tableID, index)
{
	switch(tableID)
	{
		case "QosApp":
			setControlApp(index);
			break;
		case "QosClass":
			setControlClass(index);
			break;
		case "QosClassType":
			setControlClassType(index);
			break;
		default:
			break;
	}
}
</script>

</head>
<body onLoad="LoadFrame();" class="mainbody"> 

<form id="ConfigForm" action="../application/set.cgi"> 
  <table width="100%" border="0" cellpadding="0" cellspacing="0" id="tabTest"> 
    <tr> 
      <td class="prompt"> <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
          <tr> 
		   <script language="JavaScript" type="text/javascript">
		   if (E8CQoSMode == 1)
		   {
				document.write("<td class='title_common'  BindText='bbsp_qos_e8c_title'>  </td>");
		   }
		   else
		   {
				document.write("<td class='title_common'  BindText='bbsp_qos_title'>  </td>");
		   }
		   </script> 
          </tr> 
        </table></td> 
    </tr> 
    <tr> 
      <td height="10px"></td> 
    </tr> 
  </table> 
  
  <div id="DivQosBasic">
  <table cellpadding="0" cellspacing="1" width="100%" class="tabal_bg"> 
	<tr id="QosEnableRow"> 
	  <td class="table_title width_per25" BindText='bbsp_enableqosmh'></td> 
	  <td class="table_right width_per75"> <input  id='QMQosEnable' name='QMQosEnable' type='checkbox'> </td> 
	</tr> 	
	<tr id="QosModeRow"> 
	  <td class="table_title width_per25" BindText='bbsp_qosmodemh'></td> 
	  <td class="table_right width_per75"> 
	  <script>
	  if(E8CQoSMode == 1)
	  {
	  	document.write('<input id="QMQosModeText" type="text" name="QMQosModeText" style="width: 194px"><font color="red">*</font>'); 
	  }
	  else
	  {
	 	document.write('<input id="QMQosModeText" type="text" name="QMQosModeText" style="display:none">'); 
	  }
	  </script>
	 <select id="QMQosMode" name="QMQosMode" class="width_200px" onChange="setQosMode();"> 
	 <script>
	 if(E8CQoSMode == 1)
	 {
	 	document.write('<option value=' + qos_language['bbsp_selectdd'] + '>' + qos_language['bbsp_selectdd'] + '</option>'); 
	 }
	 </script>  
		  <option value="INTERNET,TR069">INTERNET,TR069</option> 
		  <script language="JavaScript" type="text/javascript">
					if ((true == showVoipWithVoice))
					{
						document.write('<option value="INTERNET,TR069,VOIP">INTERNET,TR069,VOICE</option> ');
					}
					else
					{
						document.write('<option value="INTERNET,TR069,VOIP">INTERNET,TR069,VOIP</option> ');
					}
		  </script> 
          <option value="INTERNET,TR069,IPTV">INTERNET,TR069,IPTV</option> 
          <script language="JavaScript" type="text/javascript">                  
					if ((GetCfgMode().JSCT == "1") || (GetCfgMode().SZCT == "1"))
					{
						if ((true == showVoipWithVoice))
						{
							document.write("<option value='INTERNET,TR069,IPTV,VOIP'>INTERNET,TR069,IPTV,VOICE</option>");
							document.write("<option value='INTERNET,TR069,VOIP,IPTV'>INTERNET,TR069,VOICE,IPTV</option>");
						}
						else
						{
							document.write("<option value='INTERNET,TR069,IPTV,VOIP'>INTERNET,TR069,IPTV,VOIP</option>");
							document.write("<option value='INTERNET,TR069,VOIP,IPTV'>INTERNET,TR069,VOIP,IPTV</option>");	
						}
					}
					else
				    {
				    	if ((true == showVoipWithVoice))
				    	{
				    		document.write("<option value='INTERNET,TR069,VOIP,IPTV'>INTERNET,TR069,VOICE,IPTV</option>");
				    	}
				    	else
				    	{
							document.write("<option value='INTERNET,TR069,VOIP,IPTV'>INTERNET,TR069,VOIP,IPTV</option>");
				    	}
				    }
					</script>
		  <script language="JavaScript" type="text/javascript">
					if ((true == showVoipWithVoice))
					{
						document.write('<option value="TR069,VOIP,IPTV,INTERNET">TR069,VOICE,IPTV,INTERNET</option> ');
					}
					else
					{
						document.write('<option value="TR069,VOIP,IPTV,INTERNET">TR069,VOIP,IPTV,INTERNET</option> ');
					}
		  </script> 

          <option value="OTHER">OTHER</option> 
        </select> </td> 
    </tr> 
	<tr id="BandwidthRow">
	  <td  class="table_title width_per25" BindText='bbsp_Bandwidth'></td> 
      <td  class="table_right width_per75"> <input type='text' id='Bandwidth' name='Bandwidth' style="width: 194px"/>
	  <script>document.write(qos_language['bbsp_kbps']);</script></td> 
	</tr>
	<script>
	getElById("Bandwidth").title = qos_language['bbsp_Bandwidthtitle'];
	</script>
	<tr id="PlanRow">
	  <td  class="table_title width_per25" BindText='bbsp_Plan'></td> 
      <td  class="table_right width_per75"> <select name='Planlist'  id="Planlist" class="width_200px"  onChange="setQosPlan();"> 
		<option value="priority"><script>document.write(qos_language['bbsp_priority']);</script></option> 
		<option value="weight"><script>document.write(qos_language['bbsp_weight']);</script></option> 
		</select></td> 
	</tr>
	<tr id="EnableForceWeightRow"> 
      <td class="table_title width_per25" BindText='bbsp_EnableForceWeight'></td> 
      <td class="table_right width_per75"> <input  id='EnableForceWeight' name='EnableForceWeight' type='checkbox'> </td> 
    </tr> 
	<tr id="EnableDSCPMarkRow"> 
      <td class="table_title width_per25" BindText='bbsp_EnableDSCPMark'></td> 
      <td class="table_right width_per75"> <input  id='EnableDSCPMark' name='EnableDSCPMark' type='checkbox'></td>
    </tr> 
	<tr id="Enable8021pRow">
	  <td  class="table_title width_per25" BindText='bbsp_Enable8021p'></td> 
      <td  class="table_right width_per75"> <select name='PriorityValuelist'  id="PriorityValuelist" class="width_200px"> 
		<option value="0"><script>document.write(qos_language['bbsp_Disable']);</script></option> 
		<option value="1"><script>document.write(qos_language['bbsp_Transparent']);</script></option> 
		<option value="2"><script>document.write(qos_language['bbsp_Modify']);</script></option> 
		</select></td> 
	</tr>	
  </table> 
  <table cellpadding="0" cellspacing="1" width="100%" class="table_button"> 
    <tr> 
      <td class="width_per25" ></td> 
      <td class="table_submit"> 
	    <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	  	<button id="btnQosBasicApply" name="btnQosBasicApply" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="OnQosBasicApply();"><script>document.write(qos_language['bbsp_app']);</script></button> 
        <button name="QosBasiccancelValue" id="QosBasiccancelValue" class="CancleButtonCss buttonwidth_100px" type="button" onClick="QosBasicCancelConfig();"><script>document.write(qos_language['bbsp_cancel']);</script></button>
	</td> 
    </tr> 	
  </table> 
    <table width="100%" border="0" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td class="height10p"></td> 
    </tr> 
  </table> 
  </div>
  
  <div id="DivApp" style="display:none">
   <script language="JavaScript" type="text/javascript">
   writeTabCfgHeader('QosApp',qos_language['bbsp_AppManage'],"100%");
   </script>
  <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="QosAppInst"> 
  <tr class="head_title">
    	<td>&nbsp;</td>
          <td ><div class="align_center"><script>document.write(qos_language['bbsp_AppName']);</script></div></td>
	      <td ><div class="align_center"><script>document.write(qos_language['bbsp_ClassQueue']);</script></div></td>
  </tr>  
  <script language="JavaScript" type="text/javascript">
  	 if (AppInfoList.length - 1 == 0)
	 {
		document.write('<TR id="QosApp_record_no"' + ' class="tabal_01" onclick="selectLine(this.id);">');
		document.write('<TD align="center" width="5%">--</TD>');
		document.write('<TD align="center" width="47%">--</TD>');
		document.write('<TD align="center" width="47%">--</TD>');
		document.write('</TR>');
	 }
	 else
	 {
	 	var AppList = 0;
		if (AppInfoList.length - 1 > AppListMax)
		{
			AppList = AppListMax;
		}
		else
		{
			AppList = AppInfoList.length - 1;
		}
	 	for (var i = 0; i < AppList; i++)
		{
			document.write('<TR id="QosApp_record_' + i + '" class="tabal_01" onclick="selectLine(this.id);">');
			document.write('<TD align="center" width="5%">' + '<input type="checkbox" name="QosApp_rml"' + ' value="' + AppInfoList[i].Domain + '" onclick="selectRemoveCnt(this);">' + '</TD>');
			if ((true == showVoipWithVoice))
			{
				document.write('<TD align="center" width="47%">' + AppInfoList[i].AppName.replace(new RegExp(/(VOIP)/g),"VOICE") + '</TD>');
			}
			else
			{
				document.write('<TD align="center" width="47%">' + AppInfoList[i].AppName + '</TD>');
			}
			document.write('<TD align="center" width="47%">' + AppInfoList[i].ClassQueue + '</TD>');
			document.write('</TR>');
		}
	 }
  </script>
  </table>
  <div id="QosAppConfigForm">
     <table class="tabal_bg" cellpadding="0" cellspacing="1" border="0" id="app_cfg_table" width="100%"> 
	   <tr>
	     <td  class="table_title width_per25" BindText='bbsp_AppNamemh'></td> 
         <td  class="table_right"><select name='AppNameList'  id="AppNameList" class="width_200px"> 
		  <option value=""><script>document.write("");</script></option> 
		   <script language="JavaScript" type="text/javascript">
				if ((true == showVoipWithVoice))
				{
					document.write('<option value="VOIP">VOICE</option>');
				}
				else
				{
					document.write('<option value="VOIP">'+qos_language['bbsp_VOIP']+'</option>');
				}
		  </script>  
		  <option value="TR069"><script>document.write(qos_language['bbsp_TR069']);</script></option> 
		  </select></td> 
	   </tr>
	   <tr>
	     <td  class="table_title width_per25" BindText='bbsp_ClassQueuemh'></td> 
		 <td  class="table_right"><select name='AppQueueList'  id="AppQueueList" class="width_200px"> 
		  <option value="1"><script>document.write("1");</script></option> 
		  <option value="2"><script>document.write("2");</script></option> 
		  <option value="3"><script>document.write("3");</script></option> 
		  <option value="4"><script>document.write("4");</script></option> 
		  <option value="5"><script>document.write("5");</script></option> 
		  <option value="6"><script>document.write("6");</script></option> 
		  <option value="7"><script>document.write("7");</script></option> 
		  <option value="8"><script>document.write("8");</script></option>
		  </select></td> 
	   </tr>
	 </table>
  <table cellpadding="0" cellspacing="1" width="100%" class="table_button"> 
    <tr> 
      <td class="width_per25" ></td> 
      <td class="table_submit"> 
	  	<button id="btnAppApply" name="btnAppApply" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="OnAppApply();"><script>document.write(qos_language['bbsp_app']);</script></button> 
        <button id="btnAppCancel" name="btnAppCancel" class="CancleButtonCss buttonwidth_100px" type="button" onClick="CancelConfig('QosApp');"><script>document.write(qos_language['bbsp_cancel']);</script></button>
	</td> 
    </tr> 	
  </table> 
  </div>
  <script language="JavaScript" type="text/javascript">
    writeTabTail();
  </script>
  <table width="100%" border="0" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td class="height10p"></td> 
    </tr> 
  </table> 
  </div>
  
  <div id="DivClassification" style="display:none">
  <script language="JavaScript" type="text/javascript">
   writeTabCfgHeader('QosClass',qos_language['bbsp_ClassManage'],"100%");
  </script>
  <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="QosClassInst"> 
    <tr class="head_title">
    	<td>&nbsp;</td>
          <td ><div class="align_center"><script>document.write(qos_language['bbsp_ClassificationId']);</script></div></td>
	      <td ><div class="align_center"><script>document.write(qos_language['bbsp_ClassQueue']);</script></div></td>
		  <td ><div class="align_center"><script>document.write(qos_language['bbsp_DSCP']);</script></div></td>
		  <td ><div class="align_center"><script>document.write(qos_language['bbsp_8021p']);</script></div></td>
    </tr>  
	<script language="JavaScript" type="text/javascript">
  	 if (ClassificationInfoList.length - 1 == 0)
	 {
		document.write('<TR id="QosClass_record_no"' + ' class="tabal_01" onclick="selectLine(this.id);">');
		document.write('<TD align="center" width="5%">--</TD>');
		document.write('<TD align="center" width="23%">--</TD>');
		document.write('<TD align="center" width="23%">--</TD>');
		document.write('<TD align="center" width="23%">--</TD>');
		document.write('<TD align="center" width="23%">--</TD>');
		document.write('</TR>');
	 }
	 else
	 {
		var ClassList = 0;
		if (ClassificationInfoList.length - 1 > ClassListMax)
		{
			ClassList = ClassListMax;
		}
		else
		{
			ClassList = ClassificationInfoList.length - 1;
		}
	 	for (var i = 0; i < ClassList; i++)
		{
			document.write('<TR id="QosClass_record_' + i + '" class="tabal_01" onclick="selectLine(this.id);">');
			document.write('<TD align="center" width="5%">' + '<input type="checkbox" id = "QosClass_rml" name="QosClass_rml"' + ' value="' + ClassificationInfoList[i].Domain + '" onclick="selectRemoveCnt(this);">' + '</TD>');
			document.write('<TD align="center" width="23%">' + ClassificationInfoList[i].ClassificationId + '</TD>');
			document.write('<TD align="center" width="23%">' + ClassificationInfoList[i].ClassQueue + '</TD>');
			document.write('<TD align="center" width="23%">' + ClassificationInfoList[i].DSCPMarkValue + '</TD>');
			document.write('<TD align="center" width="23%">' + ClassificationInfoList[i].PriorityValue + '</TD>');
			document.write('</TR>');
		}
	 }
  </script>
  </table>
  <div id="QosClassConfigForm">
     <table class="tabal_bg" cellpadding="0" cellspacing="1" border="0" id="Class_cfg_table" width="100%"> 
	   <tr>
	     <td  class="table_title width_per25" BindText='bbsp_ClassQueuemh'></td> 
         <td  class="table_right"><select name='ClassQueueList'  id="ClassQueueList" class="width_200px"> 
		  <option value="1">1</option> 
		  <option value="2">2</option> 
		  <option value="3">3</option> 
		  <option value="4">4</option>
		  <option value="5">5</option> 
		  <option value="6">6</option> 
		  <option value="7">7</option> 
		  <option value="8">8</option> 
		  </select></td> 
	   </tr>
	   <tr>
	    <td  class="table_title width_per25" BindText='bbsp_DSCPmh'></td> 
        <td  class="table_right width_per75"> <input type='text' id='ClassDhcp' name='ClassDhcp' style="width: 194px"/>
		 <script>document.write(qos_language['bbsp_DSCPRange']);</script>
		</td> 
	  </tr>
	   <tr>
	     <td  class="table_title width_per25" BindText='bbsp_8021pmh'></td> 
		 <td  class="table_right"><select name='Class8021pList'  id="Class8021pList" class="width_200px"> 
		  <option value="0">0</option> 
		  <option value="1">1</option> 
		  <option value="2">2</option> 
		  <option value="3">3</option> 
		  <option value="4">4</option> 
		  <option value="5">5</option> 
		  <option value="6">6</option> 
		  <option value="7">7</option> 
		  </select></td> 
	   </tr>
	 </table>
   <table cellpadding="0" cellspacing="1" width="100%" class="table_button"> 
    <tr> 
      <td class="width_per25" ></td> 
      <td class="table_submit"> 
	  	<button id="btnClassApply" name="btnClassApply" type="button" class="submit" onClick="OnClassApply();"><script>document.write(qos_language['bbsp_app']);</script></button> 
        <button id="btnClassCancel" name="btnClassCancel" class="submit"  type="button" onClick="CancelConfig('QosClass');"><script>document.write(qos_language['bbsp_cancel']);</script></button>
	</td> 
    </tr> 	
  </table> 
  </div>
  <script language="JavaScript" type="text/javascript">
    writeTabTail();
  </script>
  <table width="100%" border="0" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td class="height10p"></td> 
    </tr> 
  </table> 
  </div>
  
  <div id="DivClassificationType" style="display:none">
  <script language="JavaScript" type="text/javascript">
   writeTabCfgHeader('QosClassType',qos_language['bbsp_ClassTypeManage'],'100%');
  </script>
  <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="QosClassTypeInst"> 
    <tr class="head_title">
    	<td>&nbsp;</td>
          <td ><div class="align_center"><script>document.write(qos_language['bbsp_Type']);</script></div></td>
	      <td ><div class="align_center"><script>document.write(qos_language['bbsp_Min']);</script></div></td>
		  <td ><div class="align_center"><script>document.write(qos_language['bbsp_Max']);</script></div></td>
		  <td ><div class="align_center"><script>document.write(qos_language['bbsp_Protocol']);</script></div></td>
		  <td ><div class="align_center"><script>document.write(qos_language['bbsp_ClassTypeId']);</script></div></td>
    </tr>  
	<script language="JavaScript" type="text/javascript">
  	 if (ClassificationTypeInfoList.length -1 == 0)
	 {
		document.write('<TR id="QosClassType_record_no"' + ' class="tabal_01" onclick="selectLine(this.id);">');
		document.write('<TD align="center" width="5%">--</TD>');
		document.write('<TD align="center" width="19%">--</TD>');
		document.write('<TD align="center" width="19%">--</TD>');
		document.write('<TD align="center" width="19%">--</TD>');
		document.write('<TD align="center" width="19%">--</TD>');
		document.write('<TD align="center" width="19%">--</TD>');
		document.write('</TR>');
	 }
	 else      
	 {
		var ClassTypeList = 0;
		if (ClassificationTypeInfoList.length - 1 > TotoalTypeListMax)
		{
			ClassTypeList = TotoalTypeListMax;
		}
		else
		{
			ClassTypeList = ClassificationTypeInfoList.length - 1;
		}
	 	for (var i = 0; i < ClassTypeList; i++)
		{
			document.write('<TR id="QosClassType_record_' + i + '" class="tabal_01" onclick="selectLine(this.id);">');
			document.write('<TD align="center" width="5%">' + '<input type="checkbox" name="QosClassType_rml"' + ' value="' + ClassificationTypeInfoList[i].Domain + '" onclick="selectRemoveCnt(this);">' + '</TD>');
			document.write('<TD align="center" width="19%">' + ClassificationTypeInfoList[i].Type + '</TD>');
			if(ClassificationTypeInfoList[i].Type == "LANInterface")
			{
				document.write('<TD align="center" width="19%" title="' + ClassificationTypeInfoList[i].Min + '">' +  ClassificationTypeInfoList[i].MinShow + '</TD>');
				document.write('<TD align="center" width="19%" title="' + ClassificationTypeInfoList[i].Max + '">' +  ClassificationTypeInfoList[i].MaxShow + '</TD>');
			}
			else
			{
				document.write('<TD align="center" width="19%">' + ClassificationTypeInfoList[i].Min + '</TD>');
				document.write('<TD align="center" width="19%">' + ClassificationTypeInfoList[i].Max + '</TD>');
			}
			document.write('<TD align="center" width="19%">' + ClassificationTypeInfoList[i].ProtocolList + '</TD>');
			document.write('<TD align="center" width="19%">' + ClassificationTypeInfoList[i].ClassificationId + '</TD>');
			document.write('</TR>');
		}
	 }
  </script>
  </table>
  <div id="QosClassTypeConfigForm">
     <table class="tabal_bg" cellpadding="0" cellspacing="1" border="0" id="ClassType_cfg_table" width="100%"> 
	   <tr>
	     <td  class="table_title width_per25" BindText='bbsp_ClassTypeIdmh'></td> 
         <td  class="table_right"><select name='ClassTypeIdList'  id="ClassTypeIdList" class="width_200px"> 
		 <script language="JavaScript" type="text/javascript">
		 if (ClassificationInfoList.length == 1)
		 {
		 	document.write('<option value=""></option>');
		 }
		 else
		 {
		 	for (var i = 0; i < ClassificationInfoList.length - 1; i++)
			{
				document.write('<option value="'+SortClassIdList[i]+'">'+SortClassIdList[i]+'</option>');
			}
		 }
		 </script>
		 </td> 
	   </tr>
	   <tr>
	     <td  class="table_title width_per25" BindText='bbsp_Typemh'></td> 
         <td  class="table_right"><select name='TypeList'  id="TypeList" class="width_200px" onChange="setQosClassType();"> 
		  <option value="SMAC"><script>document.write(qos_language['bbsp_SMAC']);</script></option> 
		  <option value="8021P"><script>document.write(qos_language['bbsp_Type_8021P']);</script></option> 
		  <option value="SIP"><script>document.write(qos_language['bbsp_SIP']);</script></option> 
		  <option value="DIP"><script>document.write(qos_language['bbsp_DIP']);</script></option> 
		  <option value="SPORT"><script>document.write(qos_language['bbsp_SPORT']);</script></option> 
		  <option value="DPORT"><script>document.write(qos_language['bbsp_DPORT']);</script></option> 
		  <option value="TOS"><script>document.write(qos_language['bbsp_TOS']);</script></option> 
		  <option value="DSCP"><script>document.write(qos_language['bbsp_Type_DSCP']);</script></option> 
		  <option value="LANInterface"><script>document.write(qos_language['bbsp_LANInterface']);</script></option>
		  <option value="TC"><script>document.write(qos_language['bbsp_TC']);</script></option> 
		  <option value="FL"><script>document.write(qos_language['bbsp_FL']);</script></option>
		  </select></td>		
	   </tr>
	   <tr id="trMin">
	    <td  class="table_title width_per25" BindText='bbsp_Minmh'></td> 
        <td  class="table_right width_per75"> <input type='text' id='ClassTypeMin' name='ClassTypeMin' maxlength="256" style="width: 194px"/></td> 
	  </tr>
	   <tr id="trMax">
	    <td  class="table_title width_per25" BindText='bbsp_Maxmh'></td> 
        <td  class="table_right width_per75"> <input type='text' id='ClassTypeMax' name='ClassTypeMax' maxlength="256" style="width: 194px"/></td> 
		 </tr>
	  <tr> 
	 	<td  class="table_title width_per25" BindText='bbsp_Protocolmh'></td> 
		<td  class="table_right width_per75">
		<input id="cb_Tcp" name="cb_Tcp" type="checkbox" value="TCP" >TCP &nbsp;
        <input id="cb_Udp" name="cb_Udp" type="checkbox" value="UDP">UDP &nbsp;
        <input type="checkbox" id="cb_Icmp" name="cb_Icmp" value="ICMP">ICMP &nbsp;
        <input type="checkbox" id="cb_Rtp" name="cb_Rtp" value="RTP">RTP &nbsp;
		</td> 
	  </tr>
   </table>
   <table cellpadding="0" cellspacing="1" width="100%" class="table_button"> 
    <tr> 
      <td class="width_per25" ></td> 
      <td class="table_submit"> 
	  	<button id="btnClassTypeApply" name="btnClassTypeApply" type="button" class="submit" onClick="OnClassTypeApply();"><script>document.write(qos_language['bbsp_app']);</script></button> 
        <button id="btnClassTypeCancel" name="btnClassTypeCancel" class="submit"  type="button" onClick="CancelConfig('QosClassType');"><script>document.write(qos_language['bbsp_cancel']);</script></button>
	</td> 
    </tr> 	
  </table> 
  </div>
  <script language="JavaScript" type="text/javascript">
    writeTabTail();
  </script>
  <table width="100%" border="0" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td class="height10p"></td> 
    </tr> 
  </table> 
 </div>
  
  <div id="DivQueueManagement" style="display:none">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_head"> 
  <tr> 
    <td  class="width_100p align_left" BindText='bbsp_QueueManage'></td> 
  </tr> 
  </table>
  <div id="DivSP" style="display:none">
  <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="priQueueInst"> 
  <tr class="head_title">
    	<td>&nbsp;</td>
          <td ><div class="align_center"><script>document.write(qos_language['bbsp_QueueNumber']);</script></div></td>
  </tr>  
  <script language="JavaScript" type="text/javascript">
	if (PriorityQueueInfoList.length == 0)
	{
		document.write('<TR id="SPrecord_no"' + ' class="tabal_01">');
		document.write('<TD align="center" width="5%">--</TD>');
		document.write('<TD align="center" width="95%">--</TD>');
		document.write('</TR>');
	}
	else
	{
		for (i = 0; i < PriorityQueueInfoList.length; i++)
		{
			document.write('<TR id="SPrecord_' + i + '" class="tabal_01">');
			document.write('<TD align="center" width="5%">' + '<input type="checkbox" name="SPrml" id="SPRecord' + i + '"+ value="'+ PriorityQueueInfoList[i].Enable+'">' + '</TD>');
			document.write('<TD align="center" width="95%">' + 'Q' + PriorityQueueInfoList[i].Priority + '</TD>');
			document.write('</TR>');
		}
	}
  </script>
  </table> 
  </div>
  <div id="DivWRR" style="display:none">
  <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="priQueueInst"> 
  <tr class="head_title">
    	<td>&nbsp;</td>
          <td ><div class="align_center"><script>document.write(qos_language['bbsp_QueueNumber']);</script></div></td>
		  <script language="JavaScript" type="text/javascript">
	      	document.write('<td ><div class="align_center">'+qos_language["bbsp_Weight"]+'</div></td>');
		  </script>
  </tr>  
  <script language="JavaScript" type="text/javascript">
	if (PriorityQueueInfoList.length == 0)
	{
		document.write('<TR id="WRRrecord_no"' + ' class="tabal_01">');
		document.write('<TD align="center" width="5%">--</TD>');
		document.write('<TD align="center" width="47%">--</TD>');
		document.write('<TD align="center" width="47%">--</TD>');
		document.write('</TR>');
	}
	else
	{
		for (i = 0; i < PriorityQueueInfoList.length; i++)
		{
			var QueueIndex = '';
			
			if(PriorityQueueInfoList[i].Domain.length == 0)
			{
				QueueIndex = PriorityQueueInfoList[i].Priority;
			}
			else
			{
				QueueIndex = PriorityQueueInfoList[i].Domain.charAt(PriorityQueueInfoList[i].Domain.length - 1);
			}
			
			document.write('<TR id="WRRrecord_' + i + '" class="tabal_01">');
			document.write('<TD align="center" width="5%">' + '<input type="checkbox" name="WRRrml" id="WRRRecord' + i + '"+ value="'+ PriorityQueueInfoList[i].Enable+'">' + '</TD>');
			document.write('<TD align="center" width="47%">' + 'Q' + QueueIndex + '</TD>');
			document.write('<TD align="center" width="47%">' + '<input type="text" id="WeightValue' + i +'" style="width: 100px"' + 'value="' + PriorityQueueInfoList[i].Weight + '"/>'+'</TD>');
			document.write('</TR>');
		}
	}
  </script>
  </table> 
  </div>
  <script language="JavaScript" type="text/javascript">
	  if (QosBasicInfoList[0] == null)
	  {
		 setDisplay("DivSP",1);
	  }
	  else
	  {
		if (QosBasicInfoList[0].X_HW_Plan == "weight")
		{
			setDisplay("DivWRR",1);
		}
		else
		{
			setDisplay("DivSP",1);
		}
	  }
  </script>
   <table cellpadding="0" cellspacing="1" width="100%" class="table_button"> 
    <tr> 
      <td class="width_per25" ></td> 
      <td class="table_submit"> 
	  	<button id="btnQMApply" name="btnQMApply" type="button" class="submit" onClick="OnQMApply();"><script>document.write(qos_language['bbsp_app']);</script></button> 
        <button name="QMcancelValue" id="QMcancelValue" class="submit"  type="button" onClick="QMCancelConfig();"><script>document.write(qos_language['bbsp_cancel']);</script></button>
	</td> 
    </tr> 	
  </table> 
  </div>
  
</form> 

</body>

</html>
