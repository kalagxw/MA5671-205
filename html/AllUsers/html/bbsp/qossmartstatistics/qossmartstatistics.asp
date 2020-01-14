<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="GetQosStatisticsResult.asp"></script>
<title>Intelligent Channel Statistics</title>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" src="<%HW_WEB_GetReloadCus(qossmartstatistics.cus);%>"></script>
<script language="JavaScript" type="text/javascript">
var DisplayControl = "<% HW_WEB_GetFeatureSupport(BBSP_FT_MODIFY_PRI_OR_TC);%>";
var TimerHandleRefresh;
var RefreshCount = 0;
var TimeoutCount = '<%HW_WEB_GetSPEC(SSMP_SPEC_WEB_CLEANOUTOFOPT.UINT32);%>';
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
		b.innerHTML = qos_smart_statistics_language[b.getAttribute("BindText")];
	}
}

function LanDomain2LanName(Domain)
{
    if(Domain.length == 0)
    {
        return "--";
    }
    
    var EthNum = Domain.charAt(Domain.length - 1);
    
    return  "LAN" + EthNum;
}

function ShortFormatStr(originData)
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

function FormatEmptyStr(originData)
{
	if("" == originData)
	{
		return "--";
	}
	else
	{
		return originData;
	}
}

function GetIPMaskStruct(DestIP, DestMask)
{
	if("" != DestIP)
	{
		return ShortFormatStr(DestIP) + '/<br>' + ShortFormatStr(DestMask);
	}
	else
	{
		return "--";
	}
}

function GetCountedBytes(CountedBytesLo, CountedBytesHi)
{
	var BytesHigh = parseInt(CountedBytesHi,10);
	var BytesLow = parseInt(CountedBytesLo,10);
	var BytesHighStr = BytesHigh.toString(16);
	var BytesLowStr = BytesLow.toString(16);
	var BytesLowSubZeroLen = 8 - BytesLowStr.length;
	for(var i = 0; i < BytesLowSubZeroLen; i++)
	{
		BytesLowStr = '0' + BytesLowStr;
	}
	var BytesStr = BytesHighStr + BytesLowStr;
	var CountedBytes = parseInt(BytesStr, 16);
	return CountedBytes;
}

function GetPortRange(StartPort, EndPort)
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
    return (StartPort == novalue)? EndPort : StartPort;	
}

function ReMarkModeNum2ReMarkModeName(QosSmartItem)
{
	if (-1 == QosSmartItem.PRIMARK || '' == QosSmartItem.PRIMARK)
	{
		return qos_smart_statistics_language['bbsp_qossmarttcremark'];
	}
	else
	{
		return qos_smart_statistics_language['bbsp_qossmartprimark'];
	}
}

function QosSmartInfo()
{
	this.domain = null;
    this.ClassInterface = "";
    this.QosSmartDomain = "";
    this.DestIPMask = "";
    this.SourceIPMask = "";
    this.Protocol = "";
    this.DestPortRange = "";
    this.SourcePortRange = "";    
    this.DSCPMark = "";
	this.Pri8021Mark = "";
    this.VLANIDCheck = "";
    this.TRAFFIC = "";
    this.TRAFFICMARK = "";
    this.PRIMARK = "";
	this.RemarkMode = "";
	this.CountEnable = "0";
	this.TotalCountedPackets = "";
	this.TotalCountedBytes = "";
	this.ClassPolicer = "";
}

function ConvertQosSmart(QosSmartInfo, CommonQosSmartInfo)
{
	CommonQosSmartInfo.domain = QosSmartInfo.domain;
	CommonQosSmartInfo.ClassInterface = LanDomain2LanName(QosSmartInfo.ClassInterface);
	CommonQosSmartInfo.QosSmartDomain = QosSmartInfo.QosSmartDomain;
	CommonQosSmartInfo.DestIPMask = GetIPMaskStruct(QosSmartInfo.DestIP, QosSmartInfo.DestMask);
	CommonQosSmartInfo.SourceIPMask = GetIPMaskStruct(QosSmartInfo.SourceIP, QosSmartInfo.SourceMask);
	CommonQosSmartInfo.Protocol = FormatEmptyStr(QosSmartInfo.Protocol);
	CommonQosSmartInfo.DestPortRange = GetPortRange(QosSmartInfo.DestPort, QosSmartInfo.DestPortRangeMax);
	CommonQosSmartInfo.SourcePortRange = GetPortRange(QosSmartInfo.SourcePort, QosSmartInfo.SourcePortRangeMax);
	CommonQosSmartInfo.DSCPMark = FormatEmptyStr(QosSmartInfo.DSCPMark);
	CommonQosSmartInfo.Pri8021Mark = (QosSmartInfo.DSCPMark == "") ? "--": (QosSmartInfo.DSCPMark >> 3);
	CommonQosSmartInfo.VLANIDCheck = FormatEmptyStr(QosSmartInfo.VLANIDCheck);
	CommonQosSmartInfo.TRAFFIC = FormatEmptyStr(QosSmartInfo.TRAFFIC);
	CommonQosSmartInfo.TRAFFICMARK = FormatEmptyStr(QosSmartInfo.TRAFFICMARK);
	CommonQosSmartInfo.PRIMARK = FormatEmptyStr(QosSmartInfo.PRIMARK);
	CommonQosSmartInfo.RemarkMode = ReMarkModeNum2ReMarkModeName(QosSmartInfo);
	CommonQosSmartInfo.CountEnable = QosSmartInfo.CountEnable;
	CommonQosSmartInfo.TotalCountedPackets = QosSmartInfo.TotalCountedPackets;
	CommonQosSmartInfo.TotalCountedBytes = GetCountedBytes(QosSmartInfo.TotalCountedBytesLo, QosSmartInfo.TotalCountedBytesHi);
}

var QosSmartInfoList = new Array();
var QosSmartList = GetQosSmartData();
var QosSmartEnable = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.QueueManagement.X_HW_ClassificationEnable);%>';
function GetQosSmartList(DataList)
{
	var QosSmartInfoTemp = new Array();
	for(i=0,j=0; DataList.length > 0 && i < DataList.length -1; i++,j++)
	{
		QosSmartInfoTemp[j] = new QosSmartInfo();
		ConvertQosSmart(DataList[i], QosSmartInfoTemp[j]);
	}
	return QosSmartInfoTemp;
}

function SetStatisticsInfo(DataList)
{
	QosSmartInfoList = GetQosSmartList(DataList);
	
	for (var i = 0; i < QosSmartInfoList.length; i++)
	{
		setCheck("QossmartTable_rml" + i, QosSmartInfoList[i].CountEnable);
		$("#QossmartTable_" + i + "_1").text(QosSmartInfoList[i].TotalCountedPackets);
		$("#QossmartTable_" + i + "_2").text(QosSmartInfoList[i].TotalCountedBytes);
		document.getElementById("QossmartTable_" + i + "_1").title = QosSmartInfoList[i].TotalCountedPackets;
		document.getElementById("QossmartTable_" + i + "_2").title = QosSmartInfoList[i].TotalCountedBytes;
		
		$("#QossmartTable_" + i + "_3").text(QosSmartInfoList[i].ClassInterface);
		$("#QossmartTable_" + i + "_4").text(QosSmartInfoList[i].VLANIDCheck);
		$("#QossmartTable_" + i + "_5").text(QosSmartInfoList[i].Protocol);
		document.getElementById("QossmartTable_" + i + "_6").innerHTML = QosSmartInfoList[i].DestIPMask;
		document.getElementById("QossmartTable_" + i + "_7").innerHTML = QosSmartInfoList[i].SourceIPMask;
		document.getElementById("QossmartTable_" + i + "_6").title = QosSmartInfoList[i].DestIPMask.replace(new RegExp(/(<br>)/g),"");
		document.getElementById("QossmartTable_" + i + "_7").title = QosSmartInfoList[i].SourceIPMask.replace(new RegExp(/(<br>)/g),"");
		$("#QossmartTable_" + i + "_8").text(QosSmartInfoList[i].DestPortRange);
		$("#QossmartTable_" + i + "_9").text(QosSmartInfoList[i].SourcePortRange);
		$("#QossmartTable_" + i + "_10").text(QosSmartInfoList[i].DSCPMark);
		$("#QossmartTable_" + i + "_11").text(QosSmartInfoList[i].Pri8021Mark);
		
		if("1" == DisplayControl)
		{
			$("#QossmartTable_" + i + "_12").text(QosSmartInfoList[i].TRAFFIC);
			$("#QossmartTable_" + i + "_13").text(QosSmartInfoList[i].RemarkMode);
			$("#QossmartTable_" + i + "_14").text(QosSmartInfoList[i].TRAFFICMARK);
			$("#QossmartTable_" + i + "_15").text(QosSmartInfoList[i].PRIMARK);
		}
	}
}

function RefreshStatistics()
{
	$.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "./GetQosStatisticsResult.asp",
            success : function(data) {
            QosSmartList = eval(data);
			SetStatisticsInfo(QosSmartList);
            }
        });
		RefreshCount ++;
		if((RefreshCount * 10) >= (parseInt(TimeoutCount)/2))
	    {
	        clearInterval(TimerHandleRefresh);
	    }	
}

function setControl()
{
	return;
}

function QossmartTableselectRemoveCnt(SelectItem)
{
	var Form = new webSubmitForm();
    
    if ("1" == getCheckVal(SelectItem.id))
    {
        Form.addParameter('x.CountEnable', 1); 
    }
    else
    {
        Form.addParameter('x.CountEnable', 0); 
    }
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('set.cgi?x=' + SelectItem.value + '&RequestFile=html/bbsp/qossmartstatistics/qossmartstatistics.asp');
    Form.submit();  
}

function LoadFrame()
{
	loadlanguage();
	RefreshStatistics();
	TimerHandleRefresh = setInterval(
	function() {
		try 
		{
			RefreshStatistics();
		}
	    catch (e) 
		{
	
		}
	}, 10000);
}

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody">
<div  id="QosSmartListTable" style="overflow-x:auto;overflow-y:hidden;width:100%;">  
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("qossmartstattitle", GetDescFormArrayById(qos_smart_statistics_language, ""), GetDescFormArrayById(qos_smart_statistics_language, "bbsp_qos_smart_statistics_title"), false);
</script> 
<div class="title_spread"></div>

<script type="text/javascript">
var PRI_TC_HideFlag = ("1" == DisplayControl) ? false : true;
var QossmartConfiglistInfo = new Array(new stTableTileInfo("bbsp_CountEnable","align_center","DomainBox"),
                                    new stTableTileInfo("bbsp_TotalCountedPackets","align_center","TotalCountedPackets"),
									new stTableTileInfo("bbsp_TotalCountedBytes","align_center","TotalCountedBytes"),
									new stTableTileInfo("bbsp_qossmartclassinterface","align_center","ClassInterface"),
									new stTableTileInfo("bbsp_qossmartvlan","align_center","VLANIDCheck"),
									new stTableTileInfo("bbsp_qossmartprotocol","align_center","Protocol"),
									new stTableTileInfo("bbsp_qossmartdestipmask","align_center","DestIPMask"),
									new stTableTileInfo("bbsp_qossmartsrcipmask","align_center","SourceIPMask"),
									new stTableTileInfo("bbsp_qossmartdestportrange","align_center","DestPortRange"),
									new stTableTileInfo("bbsp_qossmartsrcportrange","align_center","SourcePortRange"),
									new stTableTileInfo("bbsp_qossmartdscpmark","align_center","DSCPMark"),
									new stTableTileInfo("bbsp_qossmartpbitmark","align_center","Pri8021Mark"),
									new stTableTileInfo("bbsp_qossmarttcmark","align_center","TRAFFIC",PRI_TC_HideFlag),
									new stTableTileInfo("bbsp_qossmartremarkmode","align_center","RemarkMode",PRI_TC_HideFlag),
									new stTableTileInfo("bbsp_qossmarttcremark","align_center","TRAFFICMARK",PRI_TC_HideFlag),
									new stTableTileInfo("bbsp_qossmartprimark","align_center","PRIMARK",PRI_TC_HideFlag),null);

var TableDataInfo = GetQosSmartList(QosSmartList);
TableDataInfo.push(null);						
HWShowTableListByType(1, "QossmartTable", false, 16, TableDataInfo, QossmartConfiglistInfo, qos_smart_statistics_language, QosSmartCallBack);
</script>
<table>
<tr> 
  <td class="height20p">
  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
  </td> 
</tr> 
</table> 
</div> 
</body>
</html>