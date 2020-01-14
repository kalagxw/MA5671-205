<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<title>Network Information</title>
<style type="text/css">
.trTabContent_ex 
{ 
    background-color:#f4f4f4;
    color:#000000;
}  
</style>
</head>
<body class="mainbody"  onLoad="LoadFrame();">
<div style="position:inherit; overflow-x:auto; overflow-y:auto;width:100%; height:100%">
<div style=" margin-left:20px;  margin-right:10px; position:inherit; width:100%; height:100%">
<script>
function LoadFrame()
{
}

function OpticInfo(domain,transOpticPower,revOpticPower)
{
    this.Domain = domain;
	this.TransOpticPower = transOpticPower;
	this.RevOpticPower = revOpticPower;
}

function stLinkStats(Domain,BytesSent,BytesReceived,PacketsSent,PacketsReceived)
{
    this.Domain = Domain;
	this.BytesSent = BytesSent;
	this.BytesReceived = BytesReceived;
	this.PacketsSent = PacketsSent;
	this.PacketsReceived = PacketsReceived;
}

var LinkStats = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.X_HW_PonInterface.Stats,BytesSent|BytesReceived|PacketsSent|PacketsReceived,stLinkStats);%>;

var PonLinkStats = LinkStats[0];
var ontPonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';
</script>
<table width="100%">
<tr>
<td>

<table id="table_ponstatustitle" width="100%">
	<tr>
		<td class="prompt">
		<label id="Title_base_lable" class="title_common">在本页面上，您可以查询网络侧连接信息。</label>
		</td>
	</tr>
	<tr>
		<td  style="height:5px;">
		</td>
	</tr>
</table>

<table class="tabal_bg" width="100%" id="TableEponInfo" name="table1" cellspacing="1">
	<tr class="table_title">
	<td id="Table_pon1_table" align="left" colspan="2" >网络链路连接信息</td>
	</tr>
	
	<tr>
	  <td align="left" id="Table_pon2_1_table" name="Table_pon2_1_table" class="table_left" width="150px">PON链路连接状态:</td>
	  <td id="Table_pon2_2_table" name="Table_pon2_2_table" class="table_right">
	  <div id="EponLinkState" class="table_right"></div>
	  </td>
	</tr>
</table>

<table class="tabal_bg" width="100%" id="TableLinkStatsInfo" name="table1" cellspacing="1">

	<tr class="table_title">
	<td id="Table_pon5_table" align="left" colspan="2" >链路性能统计</td>
	</tr>

	<tr >
		<td  id="Table_pon6_1_table" name="Table_pon6_1_table" class="table_left"  width="150px">PON口发包数:</td>
		<td  id="Table_pon6_2_table" name="Table_pon6_2_table" class="table_right">
		<div id="LinkStatsSendPackets" ></div>
		</td>
	</tr>

	<tr>
		<td id="Table_pon7_1_table" name="Table_pon7_1_table" class="table_left" >PON口收包数:</td>
		<td id="Table_pon7_2_table" name="Table_pon7_2_table" class="table_right">
		<div id="LinkStatsReceivePackets"  ></div>
		</td>
	</tr>

	<tr>
		<td id="Table_pon8_1_table" name="Table_pon8_1_table" class="table_left" >PON口接收字节:</td>
		<td id="Table_pon8_2_table" name="Table_pon8_2_table" class="table_right">
		<div id="LinkStatsReceiveBytes"  ></div>
		</td>
	</tr>

	<tr>
		<td id="Table_pon9_1_table" name="Table_pon9_1_table" class="table_left" >PON口发送字节:</td>
		<td id="Table_pon9_2_table" name="Table_pon9_2_table" class="table_right">
		<div id="LinkStatsSendBytes"  ></div>
		</td>
	</tr>
</table>

<table class="tabal_bg" width="100%" id="TableOpticalInfo" name="table2"  cellspacing="1">

	<tr  class="table_title">
	<td colspan="2" align="left">ONT光模块信息</td>
	</tr>

	<tr>
		<td width="150px" align="left" id="Table_pon10_1_table" name="Table_pon10_1_table" class="table_left">发送光功率:</td>
		<td id="Table_pon10_2_table" name="Table_pon10_2_table" class="table_right">
		<div id="SendPower" class="table_right"></div></td>
	</tr>

	<tr>
		<td width="150px" align="left" id="Table_pon11_1_table" name="Table_pon11_1_table" class="table_left">接收光功率:</td>
		<td id="Table_pon11_2_table" name="Table_pon11_2_table" class="table_right">
		<div id="ReceivePower" class="table_right"></div>
		</td>
	</tr>
</table>
 
<table class="tabal_bg" width="100%" id="TableOLTOpticalInfo" name="table3" cellspacing="1">

	<tr  class="table_title">
	<td colspan="2" align="left">OLT光模块信息</td>
	</tr>
	<tr class="trTabContent_ex" id="tr13" name="tr7">
	<td   width="150px" align="left" id="td1" name="td1_1" class="table_left">光模块类型:</td>
	<td id="td2" name="td1_2" class="table_right">
	<div id="OLTOpticalMode" class="table_right"></div>
	</td>
	</tr>
	<tr class="trTabContent_ex" id="tr14" name="tr8">
	<td width="150px" align="left" id="td3" name="td2_1" class="table_left">发送光功率:</td>
	<td id="td4" name="td2_2" class="table_right">
	<div id="OLTSendPower" class="table_right"></div></td>
	</tr>
	<tr class="trTabContent_ex" id="tr15" name="tr9">
	<td width="150px" align="left" id="td5" name="td3_1" class="table_left">PON口标识:</td>
	<td id="td6" name="td3_2" class="table_right"> 
	<div id="OLTPONIdentifier" class="table_right"></div>
	</td>
	</tr>
</table> 

</td>
</tr>
</table>

<script>
function SetDivValue(Id, Value)
{
	try
	{
		var Div = document.getElementById(Id);
		Div.innerHTML = Value;
	}
	catch(ex)
	{
	}
}

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

function FillLinkInfo()
{
	SetDivValue("EponLinkState",GetLinkState());
}
try
{
	FillLinkInfo();
}
catch(ex)
{

}

function FillLinkStats()
{
	SetDivValue("LinkStatsSendPackets",PonLinkStats.PacketsSent);
	SetDivValue("LinkStatsReceivePackets",PonLinkStats.PacketsReceived);
	SetDivValue("LinkStatsReceiveBytes",PonLinkStats.BytesReceived);
	SetDivValue("LinkStatsSendBytes",PonLinkStats.BytesSent);
}
try
{
	FillLinkStats();
}
catch(ex)
{

}

var OpticInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.Optic,TxPower|RxPower, OpticInfo);%>; 
var OpticInfo = OpticInfoList[0];
function FillOpticInfo()
{
	SetDivValue("SendPower", OpticInfo.TransOpticPower+"dBm");
	SetDivValue("ReceivePower", OpticInfo.RevOpticPower+"dBm");
}
try
{
	FillOpticInfo();
}
	catch(ex)
{
}
 
function DeleteAllZero(hexpasswd)
{
    var str;
    var len = hexpasswd.length ;
    var i = len/2;
 
    for (  i ; i >= 0 ; i-- )
    {   
        if((hexpasswd.substring(i*2 - 1, i*2 ) != '0')||(hexpasswd.substring(i*2 - 2, i*2 - 1) != '0'))   
        {                      
            str = hexpasswd.substring(0, i*2); 
            break;
        }
    }        
    
    return str; 
                    
}

function ChangeHextoAscii(hexpasswd)
{
	var str;  
	var str2;
	var len = 0;
	
	len = hexpasswd.length;
	
	if (0 != len%2)
	{
		hexpasswd += "0";
	}
	
	str2 = DeleteAllZero(hexpasswd); 

	str = str2.replace(/[a-f\d]{2}/ig, function(m){
	return String.fromCharCode(parseInt(m, 16));});
	
	return str;
}

function isValidAscii(val)
{
	for ( var i = 0 ; i < val.length ; i++ )
	{
		var ch = val.charAt(i);
		if ( ch < ' ' || ch > '~' )
		{
		  return false;
		}
	}
	return true;
}

function conversionblankAscii(val)
{
	var str='';
	for ( var i = 0 ; i < val.length ; i++ )
	{
		var ch = val.charAt(i);
		if ( ch == ' ')
		{
			str+="&nbsp;";
		}
		else
		{
			str+= ch;	
		}
	}
	
	return str;
}

 
function stOLTOpticInfo(domain,BudgetClass,TxPower,PONIdentifier)
{
	this.domain = domain;
	this.BudgetClass = BudgetClass;
	this.TxPower = TxPower;
	this.PONIdentifier = PONIdentifier;
}
	
var OltOptics = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.OltOptic,BudgetClass|TxPower|PONIdentifier, stOLTOpticInfo);%>;
var OltOptic = OltOptics[0];

function FillOLTOpticInfo()
{
	SetDivValue("OLTOpticalMode", OltOptic.BudgetClass);
	SetDivValue("OLTSendPower", OltOptic.TxPower+"dBm");
	
	if(OltOptic.PONIdentifier =='')
	{
		SetDivValue("OLTPONIdentifier", '--');
	}
	else
	{	
		if(isValidAscii(ChangeHextoAscii(OltOptic.PONIdentifier)) == true)
		{
			
			SetDivValue("OLTPONIdentifier", conversionblankAscii(ChangeHextoAscii(OltOptic.PONIdentifier))+'('+'0x'+OltOptic.PONIdentifier+')');
		}
		else
		{
			
			SetDivValue("OLTPONIdentifier", '('+'0x'+OltOptic.PONIdentifier+')');
		}
	}
	
	if( ontPonMode.toUpperCase() == 'EPON' )
	{	
		getElById("TableOLTOpticalInfo").style.display = "none";	
	}

}
try
{
	FillOLTOpticInfo();
}
catch(ex)
{
}
</script>

 </div>
 </div>
</body>
</html>
