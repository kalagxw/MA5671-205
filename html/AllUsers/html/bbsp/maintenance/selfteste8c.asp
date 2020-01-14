<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>

<script>

var PhyResult = new Array();

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
		b.innerHTML = e8c_selftest_language[b.getAttribute("BindText")];
	}
}

function SelfTestResultClass(domain, SD5113Result, WifiResult, ExtLswResult, CodecResult, OpticResult, Port1Result, Port2Result, Port3Result, Port4Result, Port5Result, Port6Result)
{
	this.domain = domain;
	this.SD5113Result = SD5113Result;
	this.WifiResult = WifiResult;
	this.LswResult = ExtLswResult;
	this.CodecResult = CodecResult;
	this.OpticResult = OpticResult;
	PhyResult[0] = Port1Result;
	PhyResult[1] = Port2Result;
	PhyResult[2] = Port3Result;
	PhyResult[3] = Port4Result;
	PhyResult[4] = Port5Result;
	PhyResult[5] = Port6Result;
}

function EquipResult(domain, result)
{
	this.domain = domain;
	this.result = result;
}

var stSelfTestResult = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.GetSelfTest, SD5113Result|WifiResult|ExtLswResult|CodecResult|OpticResult|Port1Result|Port2Result|Port3Result|Port4Result|Port5Result|Port6Result, SelfTestResultClass);%>;
var SelfTestResult = stSelfTestResult[0];
var LinkTestResult = '<%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetLinkTestResult, InternetGatewayDevice.X_HW_DEBUG.BBSP.ExtendPortTransCheck, result, EquipResult);%>';
LinkTestResult = LinkTestResult.toString().replace(/&#40;/g, "\(");
LinkTestResult = LinkTestResult.toString().replace(/&#41;/g, "\)");


function ParseSelfTestResult()
{
	var result = "";
	var resulttemp = "";
	if (SelfTestResult.SD5113Result.indexOf("Failed") >= 0)
	{
		result += e8c_selftest_language['bbsp_5113chipfault'];
	}
	
	if (SelfTestResult.WifiResult.indexOf("Failed") >= 0)
	{
		result += e8c_selftest_language['bbsp_wifichipfault'];
	}
	
	if (SelfTestResult.LswResult.indexOf("Failed") >= 0)
	{
		result += e8c_selftest_language['bbsp_lswchipfault'];
	}
	
	if (SelfTestResult.CodecResult.indexOf("Failed") >= 0)
	{
		result += e8c_selftest_language['bbsp_codecchipfault'];
	}
	
	if (SelfTestResult.OpticResult.indexOf("Failed") >= 0)
	{
		result += e8c_selftest_language['bbsp_opticmodulechipfault'];
	}
	
	for (i = 0; i < 6; i++)
	{
		if (PhyResult[i].indexOf("Failed") >= 0)
		{
			resulttemp = "ETH" + (i+1) + e8c_selftest_language['bbsp_phychipfault'];
			result += resulttemp;
		}
	}
	
	return result;
}


function ParseLinkTestResult(rawresult)
{
	var result = "";
	var resulttemp = "";
	var nochecknum = 0;

	portres = rawresult.split(";");

	for (i =0; i < 12; i++)
	{

		innerres = portres[i].split(":");
		finalres = innerres[1];
		

		if (finalres.indexOf("NoCheck") >= 0)
		{
			nochecknum++;
			continue;
		}
		

		if (!(i % 2))
		{
			if (finalres.indexOf("Failed") >= 0)
			{
				resulttemp = "511X ETH" + (i + 2)/2 + e8c_selftest_language['bbsp_macchipfwfault'];
				result += resulttemp;
			}			
		}

		else
		{
			if (finalres.indexOf("Failed") >= 0)
			{
				resulttemp = "ETH" + (i + 1)/2 + e8c_selftest_language['bbsp_phychipfwfault'];
				result += resulttemp;
			}
		}
	}
	

	if (nochecknum == 12)
	{
		result = "NoCheck";
	}	

	return result;
}


function EquipTestResult()
{
	var ShowStr = "";
	var PrifixStr = e8c_selftest_language['bbsp_checkresult'];
	LinkResult = ParseLinkTestResult(LinkTestResult);
	EquipFinalStr = ParseSelfTestResult() + LinkResult;
	

	if (EquipFinalStr == "")
	{
		ShowStr = PrifixStr + e8c_selftest_language['bbsp_resultnormal'];
	}

	else
	{
		ShowStr = PrifixStr + EquipFinalStr + "!";
		ShowStr = ShowStr.replace("；!", "");
	}
	

	if (LinkResult.indexOf("NoCheck") >= 0)
	{
		ShowStr = "";
	}
	
	return ShowStr;
}

function OnEquipCheck()
{
	var lanid = "";
    setDisable('EquipCheck', 1);

    var Form = new webSubmitForm();
	
	if (SelfTestResult.SD5113Result.indexOf("OK") >= 0)
	{
		for (i = 0; i < 6; i++)
		{

			if (PhyResult[i].indexOf("OK") >= 0)
			{
				lanid += "" + (i +1);
				
			}
		}
	}
	
	Form.addParameter('x.portid', lanid);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_DEBUG.BBSP.ExtendPortTransCheck&RequestFile=html/bbsp/maintenance/selftestwaite8c.asp');
	Form.submit();
	
}

function LoadFrame()
{	
	loadlanguage();
}

</script>
<title>Hardware Fault Detection</title>
</head>
<body  onload="LoadFrame();" class="mainbody"">

<form id="EquipForm">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td class="prompt">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td width="100%" class="title_01" style="padding-left: 10px;" BindText='bbsp_title_prompt'></td>
                    </tr>
					<tr>
						<td width="100%" class="title_01" style="padding-left: 10px;" BindText='bbsp_title_prompt2'></td>
                    </tr>
                </table>
            </td>
        </tr>
</table>

<table id= "EquipButton"  width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button">
   <tr >
		<td class="table_submit" width="1%">
		</td>
		<td width="99%" class="table_submit">
		<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
		<button id="EquipCheck" name="EquipCheck" type="button" class="submit" onClick="OnEquipCheck();"><script>document.write(e8c_selftest_language['bbsp_startcheck']);</script></button>
			<script language="javascript" type="text/javascript">
			document.write(EquipTestResult());
			</script>
        </td>	    
   </tr>
</table>
</form>
 
</body>
</html>
