function stManageFlag(ManageFlag)
{
	this.ManageFlag = ManageFlag;
}

var stManageFlaginfo = new stManageFlag(0);
stManageFlaginfo.ManageFlag = "<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_CWMP_JSCT);%>";
var CfgModeWord ='<%HW_WEB_GetCfgMode();%>'; 

function stFtFlag(HLJCT, SHCT, AHCT, GDCT, JSCT, SZCT, PCCWHK, MOBILY, TELMEX, CQCT, BJCU,JXCT,GSCT,QHCT,GZCT,JLCT,SDCT,HUNCT,PTVDFB,PTVDF, BJUNICOM, CUVOICE)
{
	this.HLJCT = HLJCT;
	this.SHCT = SHCT;
	this.AHCT = AHCT;
	this.GDCT = GDCT;
	this.JSCT = JSCT;
	this.SZCT = SZCT;
	this.PCCWHK = PCCWHK;
	this.MOBILY = MOBILY;
	this.TELMEX = TELMEX;
	this.CQCT = CQCT;
	this.BJCU = BJCU;
	this.JXCT = JXCT;
	this.GSCT = GSCT;
	this.QHCT = QHCT;
	this.GZCT = GZCT;
	this.JLCT = JLCT;
	this.SDCT = SDCT;
	this.HUNCT = HUNCT;
	this.PTVDFB = PTVDFB;
	this.PTVDF = PTVDF;
	this.BJUNICOM = BJUNICOM;
	this.CUVOICE = CUVOICE;
}

var CfgMode = new stFtFlag("0", "0", "0", "0", "0", "0", "0", "0", "0", "0","0","0","0","0","0","0","0","0","0","0","0","0");
CfgMode.HLJCT = "<% HW_WEB_GetFeatureSupport(BBSP_FT_HLJCT);%>";
CfgMode.HUNCT = "<% HW_WEB_GetFeatureSupport(BBSP_FT_HUNCT);%>";
CfgMode.GDCT = "<% HW_WEB_GetFeatureSupport(BBSP_FT_GDCT);%>";
CfgMode.SHCT = "<% HW_WEB_GetFeatureSupport(BBSP_FT_SHCT);%>";
CfgMode.AHCT = "<% HW_WEB_GetFeatureSupport(BBSP_FT_AHCT);%>";
CfgMode.JSCT = "<%HW_WEB_GetFeatureSupport(BBSP_FT_JSCT);%>";
CfgMode.SZCT = "<%HW_WEB_GetFeatureSupport(BBSP_FT_SZCT);%>";
CfgMode.PCCWHK = ('PCCWHK' == CfgModeWord.toUpperCase() || 'PCCW3MAC' == CfgModeWord.toUpperCase() || 'PCCW4MAC' == CfgModeWord.toUpperCase())?"1" : "0";
CfgMode.MOBILY = "<%HW_WEB_GetFeatureSupport(BBSP_FT_MOBILY);%>";
CfgMode.TELMEX = "<%HW_WEB_GetFeatureSupport(BBSP_FT_TELMEX);%>";
CfgMode.CQCT = "<%HW_WEB_GetFeatureSupport(BBSP_FT_CQCT);%>";
CfgMode.BJCU = "<%HW_WEB_GetFeatureSupport(BBSP_FT_BJCU);%>"; 
CfgMode.GSCT = "<%HW_WEB_GetFeatureSupport(BBSP_FT_GSCT);%>";
CfgMode.QHCT = "<%HW_WEB_GetFeatureSupport(BBSP_FT_QHCT);%>";
CfgMode.GZCT = "<%HW_WEB_GetFeatureSupport(BBSP_FT_GZCT);%>";
CfgMode.JLCT = "<%HW_WEB_GetFeatureSupport(BBSP_FT_JLCT);%>";
CfgMode.JXCT = "<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_JXCT);%>"; 
CfgMode.SDCT = "<%HW_WEB_GetFeatureSupport(BBSP_FT_SDCT);%>";
CfgMode.PTVDFB = "<%HW_WEB_GetFeatureSupport(BBSP_FT_PTVDFB);%>";
CfgMode.PTVDF = "<%HW_WEB_GetFeatureSupport(BBSP_FT_PTVDF);%>";
CfgMode.BJUNICOM = "<%HW_WEB_GetFeatureSupport(BBSP_FT_BJUNICOM);%>";
CfgMode.CUVOICE = "<%HW_WEB_GetFeatureSupport(BBSP_FT_UNICOM_DIS_VOICE);%>";


function GetManageFlag()
{
    if ("1" == CfgMode.GDCT)
    {
        stManageFlaginfo.ManageFlag = 1;
    }
    return stManageFlaginfo;
}

function GetCfgMode()
{
    return CfgMode;
}

var RunningMode = "<% HW_WEB_GetFeatureSupport(BBSP_FT_CTC);%>";

function GetRunningMode()
{
	return RunningMode;
}

var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
function GetProductName()
{
    return ProductName;
}

var CurrentBin = '<%HW_WEB_GetBinMode();%>';

function GetCurrentBin()
{
	return CurrentBin;
}

function isE8cAndCMCC()
{
    if('E8C' == CurrentBin.toUpperCase() || 'CMCC' == CurrentBin.toUpperCase())
    {
        return true;
    }
    else
    {
        return false;
    }
}

function IsE8cFrame()
{
    if('E8C' == CurrentBin.toUpperCase())
    {
        return true;
    }
    else
    {
        return false;
    }
}

function FeatureInfoClass(domain, RouteWanMulticastIPoE, RouteWanMulticastPPPoE, BridgeWanMulticast, WanMulticastProxy, LanSsidWanBind, IPv6, WanPriPolicy, dslite, LanPppWanBind, Wan, httpportmode, telportmode, dmzpri, WebCfgRgEnValid)
{
    this.domain = domain;
    this.RouteWanMulticastIPoE = RouteWanMulticastIPoE;
    this.RouteWanMulticastPPPoE = RouteWanMulticastPPPoE;
    this.BridgeWanMulticast = BridgeWanMulticast;
    this.WanMulticastProxy = WanMulticastProxy;
    this.LanSsidWanBind  = LanSsidWanBind;
    this.IPv6            = IPv6;
    this.WanPriPolicy    = WanPriPolicy;
    this.Dslite = dslite;
	this.LanPppWanBind  = LanPppWanBind;
	this.Wan  = Wan;
	this.httpportmode = httpportmode;
	this.telportmode  = telportmode;
	this.dmzpri       = dmzpri;
	this.WebCfgRgEnValid = WebCfgRgEnValid;
}

var MngtAhct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_AHCT);%>';
var RouteWanMax = '<%HW_WEB_GetSPEC(BBSP_SPEC_ROUTEWAN_MAXNUM.UINT32);%>';
var FeatureInfo = new FeatureInfoClass("", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1","1", "0", "0", "0", "0");
FeatureInfo.WanMulticastProxy = "<% HW_WEB_GetFeatureSupport(BBSP_FT_MULTICAST_WANPROXY);%>";
FeatureInfo.RouteWanMulticastIPoE = "<% HW_WEB_GetFeatureSupport(BBSP_FT_MULTICAST_ROUTEIP);%>";
FeatureInfo.RouteWanMulticastPPPoE = "<% HW_WEB_GetFeatureSupport(BBSP_FT_MULTICAST_ROUTEPPP);%>";
FeatureInfo.BridgeWanMulticast = "<% HW_WEB_GetFeatureSupport(BBSP_FT_MULTICAST_BRIDGE);%>";
FeatureInfo.LanSsidWanBind = "<% HW_WEB_GetFeatureSupport(BBSP_FT_LANBIND_IP);%>";
FeatureInfo.IPv6 = "<% HW_WEB_GetFeatureSupport(BBSP_FT_IPV6_WANCFG);%>";
FeatureInfo.WanPriPolicy = "<% HW_WEB_GetFeatureSupport(BBSP_FT_WANPRI_POLICY);%>";
FeatureInfo.Dslite = "<% HW_WEB_GetFeatureSupport(BBSP_FT_IPV6_DSLITE);%>";
FeatureInfo.LanPppWanBind = "<% HW_WEB_GetFeatureSupport(BBSP_FT_LANBIND_PPP);%>";
FeatureInfo.Wan = "<% HW_WEB_GetFeatureSupport(BBSP_FT_WAN);%>";
FeatureInfo.IPProtChk = "<% HW_WEB_GetFeatureSupport(BBSP_FT_IP_PROTOCOL_CFG_CHK);%>";
FeatureInfo.httpportmode = "<% HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_HTTP_PORT_MODE);%>";
FeatureInfo.telportmode  = "<% HW_WEB_GetFeatureSupport(BBSP_FT_TELNET_PORT_MODE);%>";
FeatureInfo.dmzpri       = "<% HW_WEB_GetFeatureSupport(BBSP_FT_DMZ_PRIORITY);%>";
FeatureInfo.WebCfgRgEnValid = "<% HW_WEB_GetFeatureSupport(BBSP_FT_WEB_CFG_RG_EN_VALID);%>";

function GetFeatureInfo()
{
    return FeatureInfo;
}

function IsFeatureSupport(FeatureName)
{
    return FeatureInfo[FeatureName];
}

function GetRouteWanMax()
{
	return RouteWanMax;
}