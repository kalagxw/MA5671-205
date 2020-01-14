function SelfTestResultClass(domain, SD5113Result, WifiResult, ExtLswResult, CodecResult, OpticResult, Port1Result, Port2Result, Port3Result, Port4Result, Port5Result, Port6Result)
{
	this.domain = domain;
	this.SD5113Result = SD5113Result;
	this.WifiResult = WifiResult;
	this.LswResult = ExtLswResult;
	this.CodecResult = CodecResult;
	this.OpticResult = OpticResult;
	this.Port1Result = Port1Result;
	this.Port2Result = Port2Result;
	this.Port3Result = Port3Result;
	this.Port4Result = Port4Result;
	this.Port5Result = Port5Result;
	this.Port6Result = Port6Result;
}

function EquipResult(domain, result)
{
	this.domain = domain;
	this.result = result;
}

function EquipTestResultClass(SD5113Result, WifiResult, ExtLswResult, CodecResult, OpticResult, Port1Result, Port2Result, Port3Result, Port4Result, Port5Result, Port6Result, LinkTestResult)
{
	this.SD5113Result = SD5113Result;
	this.WifiResult = WifiResult;
	this.LswResult = ExtLswResult;
	this.CodecResult = CodecResult;
	this.OpticResult = OpticResult;
	this.Port1Result = Port1Result;
	this.Port2Result = Port2Result;
	this.Port3Result = Port3Result;
	this.Port4Result = Port4Result;
	this.Port5Result = Port5Result;
	this.Port6Result = Port6Result;
	this.LinkTestResult = LinkTestResult;
}

var stSelfTestResult = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.GetSelfTest, SD5113Result|WifiResult|ExtLswResult|CodecResult|OpticResult|Port1Result|Port2Result|Port3Result|Port4Result|Port5Result|Port6Result, SelfTestResultClass);%>;
var SelfTestResult = stSelfTestResult[0];
var LinkTestResult = '<%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetLinkTestResult, InternetGatewayDevice.X_HW_DEBUG.BBSP.ExtendPortTransCheck, result, EquipResult);%>';
LinkTestResult = LinkTestResult.toString().replace(/&#40;/g, "\(");
LinkTestResult = LinkTestResult.toString().replace(/&#41;/g, "\)");

var stEquipTestResult = new EquipTestResultClass("0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0");
stEquipTestResult.SD5113Result = SelfTestResult.SD5113Result;
stEquipTestResult.WifiResult = SelfTestResult.WifiResult;
stEquipTestResult.LswResult = SelfTestResult.LswResult;
stEquipTestResult.CodecResult = SelfTestResult.CodecResult;
stEquipTestResult.OpticResult = SelfTestResult.OpticResult;
stEquipTestResult.Port1Result = SelfTestResult.Port1Result;
stEquipTestResult.Port2Result = SelfTestResult.Port2Result;
stEquipTestResult.Port3Result = SelfTestResult.Port3Result;
stEquipTestResult.Port4Result = SelfTestResult.Port4Result;
stEquipTestResult.Port5Result = SelfTestResult.Port5Result;
stEquipTestResult.Port6Result = SelfTestResult.Port6Result;
stEquipTestResult.LinkTestResult = LinkTestResult;

function GetEquipTestResultInfo()
{
    return stEquipTestResult;
}

GetEquipTestResultInfo();