<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  id="Page" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html"; charset="utf-8">
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="javascript" src="../../bbsp/common/wanaddressacquire.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list.asp"></script>
<script language="javascript" src="../../bbsp/common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>
<script language="javascript" src="../../bbsp/common/wan_check.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script>

function Br0IPv6AddressClass(domain, Alias, IPv6Address)
{
    this.domain = domain;
    this.Alias = Alias;
    this.IPv6Address = IPv6Address;
}

function Br0IPv6PrefixClass(domain, Alias, ParentPrefix, ChildPrefixMask, Mode, Prefix, PreferredLifeTime, ValidLifeTime)
{ 
    this.domain = domain;
    this.Alias = Alias;
    this.ParentPrefix = ParentPrefix;
    this.ChildPrefixMask = ChildPrefixMask;
    this.Mode = Mode;
    this.Prefix = Prefix;
    this.PreferredLifeTime = PreferredLifeTime;
    this.ValidLifeTime = ValidLifeTime;     
}
function IPv6DNSConfigClass(domain, DomainName, IPv6DNSConfigType, IPv6DNSWANConnection, IPv6DNSServers)
{ 
    this.domain = domain;
    this.DomainName = DomainName;
    this.IPv6DNSConfigType = IPv6DNSConfigType;
    this.IPv6DNSWANConnection = IPv6DNSWANConnection;
    this.IPv6DNSServers = IPv6DNSServers;
}

function IPv6BindLanClass(domain, LanInterface)
{ 
    this.domain = domain;
    this.LanInterface = LanInterface;
}

function RaConfigInfoClass(domain, ManagedFlag, OtherConfigFlag, mode,minRaInterval,maxRaInterval,MTU)
{
    this.domain = domain;
    this.ManagedFlag = ManagedFlag;
    this.OtherConfigFlag = OtherConfigFlag;
    this.Mode = mode;
    this.minRaInterval = minRaInterval;
    this.maxRaInterval = maxRaInterval;
    this.MTU = MTU;
}
function UlaConfigInfoClass(domain, ULAPrefix, ULAPrefixLen, ValidLifetime, PreferredLifetime)
{
    this.domain = domain;
    this.ULAPrefix = ULAPrefix;
	this.ULAPrefixLen = ULAPrefixLen;
	this.ValidLifetime = ValidLifetime;
	this.PreferredLifetime = PreferredLifetime;
}
function DhcpConfigInfoClass(domain, dhcpEn,beginAddr,endAddr)
{
    this.domain = domain;
    this.dhcpEn = dhcpEn;
    this.beginAddr = beginAddr;
    this.endAddr = endAddr;
}
 
var Temp1 = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetBr0Ipv6Address, InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.X_HW_IPv6Interface.1.IPv6Address.{i},Alias|IPv6Address, Br0IPv6AddressClass);%>;
var Br0IPv6Address = Temp1[0];

var Temp2 = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetIPv6Prefix,InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.X_HW_IPv6Interface.1.IPv6Prefix.{i},Alias|ParentPrefix|ChildPrefixMask|Mode|Prefix|PreferredLifeTime|ValidLifeTime, Br0IPv6PrefixClass);%>;
var Br0IPv6Prefix = Temp2[0];

var Temp3 =  <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.X_HW_IPv6Interface.1, LanInterface, IPv6BindLanClass);%>;  
var LanInterface = Temp3[0];
 
var Temp4 = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetRaConfig, InternetGatewayDevice.LANDevice.1.X_HW_RouterAdvertisement, ManagedFlag|OtherConfigFlag|mode|MinRtrAdvInterval|MaxRtrAdvInterval|MTU, RaConfigInfoClass);%>;  
var RaConfig = Temp4[0];

var Temp6 = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetUlaPrefix, InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.X_HW_IPv6Interface.1.ULAIPv6Prefix.prefix.{i}, ULAPrefix|ULAPrefixLen|ValidLifetime|PreferredLifetime, UlaConfigInfoClass);%>;  
var DefaultUla = new UlaConfigInfoClass("","fd00::1","64","7200","3600");
var UlaConfig = (Temp6.length==1)?DefaultUla:Temp6[0];
var Temp7 = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.X_HW_IPv6Config,DomainName|IPv6DNSConfigType|IPv6DNSWANConnection|IPv6DNSServers, IPv6DNSConfigClass);%>;
var IPv6DNSConfig = Temp7[0];
var Temp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.X_HW_DHCPv6,X_HW_E8C_Enable|X_HW_E8C_MinAddress|X_HW_E8C_MaxAddress, DhcpConfigInfoClass);%>;
var IPv6DhcpCfg = Temp[0];
</script>
<script>

	
function isWanname(domain)
{
    AlertEx("isWanname")
	if((null != domain) && (undefined != domain))
	{
		var domaina = domain.split('.'); 
		if(domaina[3] == null || undefined == domaina[3])
			return  true
		else
			return false;
	}
}

function IsValidWan(Wan)
{
    if (Wan.Mode != "IP_Routed")
    {
        return false;
    }

    if (Wan.IPv6Enable == "0")
    {
        return false;
    }

    return true;
}
 
var wan_domain = "";   
function IsinWanList(domain)
{

    var WanList = GetWanListByFilter(IsValidWan);
    var i = 0;
    
    for (i = 0; i < WanList.length; i++)
    {        
        if( domain == WanList[i].domain || domain == domainTowanname(WanList[i].domain)) 
        {
            wan_domain =  WanList[i].domain;
            return true;
        }
    }  
    return false;
    
}

function BindPageData()
{
    setText("IPv6Address", Br0IPv6Address.IPv6Address);		
    setText("LanPrefix_text", Br0IPv6Prefix.Prefix);
    setText("PreferredLifeTime", ((Br0IPv6Prefix.PreferredLifeTime == 0) ? 3600 : Br0IPv6Prefix.PreferredLifeTime));
    setText("ValidLifeTime", ((Br0IPv6Prefix.ValidLifeTime == 0) ? 7200 : Br0IPv6Prefix.ValidLifeTime));
    setSelect("LanPrefix_select", Br0IPv6Prefix.Mode);
    setSelect("LanInterface_select", Br0IPv6Prefix.ParentPrefix);
    setText("SubPrefixMask", Br0IPv6Prefix.ChildPrefixMask);
    
    setCheck('LanDHCPv6_checkbox', IPv6DhcpCfg.dhcpEn);
	  IPv6DhcpCfg.beginAddr = (IPv6DhcpCfg.beginAddr == "0000:0000:0000:0001")?"0000:0000:0000:0002":IPv6DhcpCfg.beginAddr;
    setText("LanStartAddress_text", IPv6DhcpCfg.beginAddr);
    setText("LanEndAddress_text", IPv6DhcpCfg.endAddr);
    var ipWithDhcp = (1 == RaConfig.ManagedFlag)?true:false;
    setCheck("LanAddressInfo_checkbox", ipWithDhcp);
    var otherInfoWithDhcp = (1 == RaConfig.OtherConfigFlag)?true:false;
    setCheck("LanOtherInfo_checkbox", otherInfoWithDhcp);
    
    setSelect("LanDNS_select", IPv6DNSConfig.IPv6DNSConfigType); 
    
    setText("LanMaxRA_text", RaConfig.maxRaInterval);
    setText("LanMinRA_text", RaConfig.minRaInterval);
    setText("RAMXUCol", RaConfig.MTU);
    
    if(IsinWanList(IPv6DNSConfig.IPv6DNSWANConnection))  
    {                      
    	setSelect("LanDNS_Interface_select", wan_domain);
    }    
    var Ipv6DnsServer = IPv6DNSConfig.IPv6DNSServers.split(",");       
    setText("LanPri_DNS_text", ((Ipv6DnsServer.length >= 1) ? Ipv6DnsServer[0] : ""));
    setText("LanSec_DNS_text", ((Ipv6DnsServer.length >= 2) ? Ipv6DnsServer[1] : ""));

   Ipv6landnsSelect(IPv6DNSConfig.IPv6DNSConfigType);
   PreFixModeSelect(Br0IPv6Prefix.Mode);
	
    var LanInterfaceList = LanInterface.LanInterface.split(",");
    for (var i = 0; i < LanInterfaceList.length; i++)
    {
        setCheck(LanInterfaceList[i].toUpperCase(), "1");	
    }
    return true;
}

	
function OnPageLoad()
{
    BindPageData();

    SetIPv6DHCPServerEn(getCheckVal("LanDHCPv6_checkbox"));
    return true;
}
function IsValidWan(Wan)
{
    if (Wan.Mode != "IP_Routed")
    {
        return false;
    }

    if (Wan.IPv6Enable == "0")
    {
        return false;
    }

    return true;
}   

function CheckTimeValue(PreferredTime, VaildTime)
{
    if(true != CommonNumberChk(PreferredTime,600,4294967295,"首选期")){
        return false;
    }
    
    if(true != CommonNumberChk(VaildTime,600,4294967295,"合法期")){
        return false;
    }
	if (parseInt(VaildTime, 10) < parseInt(PreferredTime, 10))
	{
		AlertEx(lan_address_language['bbsp_vaildtimereqvalue']);
		return false; 
	}
	
	return true;
}

function CheckIpAddPrefix(Ipv6AddPrefix)
{
    if (Ipv6AddPrefix.length == 0)
    {
        AlertEx(Languages['IPv6PrefixEmpty']);
        return false;
    }
    var List = Ipv6AddPrefix.split("/");
    if (List.length != 2)
    {
        AlertEx(Languages['IPv6PrefixInvalid']);
        return false;
    }
    if ('' == List[1])
    {
        AlertEx(Languages['IPv6PrefixInvalid']);
        return false;
    }
    if ( List[1].length > 1 && List[1].charAt(0) == '0' )
    {
         AlertEx(Languages['IPv6PrefixInvalid']);
         return false;  
    }
    if (parseInt(List[1],10) < 1 || isNaN(List[1].replace(' ', 'a')) == true || parseInt(List[1],10) > 64)
    {
        	AlertEx(Languages['IPv6PrefixInvalid']);
        	return false;    
    }
    if (IsIPv6AddressValid(List[0]) == false)
    {
        	AlertEx(Languages['IPv6PrefixInvalid']);
        	return false;  
    }
    if ( IsIPv6ZeroAddress(List[0]) == true)
    {
        	AlertEx(Languages['IPv6PrefixInvalid']);
        	return false;  
    } 
    if (parseInt(List[0].split(":")[0], 16) >= parseInt("0xFF00", 16))
    {
        AlertEx(Languages['IPv6PrefixInvalid']);
        return false;   
    }  
}

function IPv6AddrChk(ipv6Addr,userTips)
{
    var moreTips = "";
    if("undefined" != typeof(userTips)){
        moreTips = "" + userTips;
    }
    
	if (IsIPv6AddressValid(ipv6Addr) == false)
	{
		AlertEx(moreTips+lan_address_language['bbsp_ipv6invalid']);
		return false;
	}
	if (IsIPv6MulticastAddress(ipv6Addr) == true)
	{
		AlertEx(moreTips+lan_address_language['bbsp_ipv6invalid']);
		return false;  
	} 
	if (IsIPv6ZeroAddress(ipv6Addr) == true)
	{
		AlertEx(moreTips+lan_address_language['bbsp_ipv6invalid']);
		return false;
	}
	if (IsIPv6LoopBackAddress(ipv6Addr) == true)
	{
		AlertEx(moreTips+lan_address_language['bbsp_ipv6invalid']);
		return false;  
	}
	
	return true;
}
function SubPrefixMaskChk()
{
	if(getValue("SubPrefixMask").length == 0)
	{
		AlertEx(lan_address_language['bbsp_premaskisreq']);
		return false;  
	}
    var List = getValue("SubPrefixMask").split("/");
	if (List.length != 2)
	{
		AlertEx(lan_address_language['bbsp_premaskinvalid']);
		return false;   
	}
	if (parseInt(List[1],10) < 1 || isNaN(List[1].replace(' ', 'a')) == true || parseInt(List[1],10) != 64)
	{
		AlertEx(lan_address_language['bbsp_premaskinvalid']);
		return false;    
	}
	if (IsIPv6AddressValid(List[0]) == false)
	{
		AlertEx(lan_address_language['bbsp_premaskinvalid']);
		return false;  
	} 
}
function Dhcpv6ServerAddrChkConvert(ipv6DhcpAddr)
{
    var j = 0;
    var standIpv6Addr = "";
    for(var i = 0; i < ipv6DhcpAddr.length; i++){
        if(":" == ipv6DhcpAddr.charAt(i)){
            continue;
        }
        standIpv6Addr += ipv6DhcpAddr.charAt(i);
        if(!(++j%2)){
            standIpv6Addr += ":";
        }
    }
    return standIpv6Addr.substring(0,23);
}
function Dhcpv6ServerAddrChk()
{
    var begainAddr = getValue("LanStartAddress_text");
    var endAddr = getValue("LanEndAddress_text");
    var theIpReg = /(([0-9a-fA-F]{4}(:)){3})([0-9a-fA-F]{4})/g;
     
    if((null == begainAddr.match(theIpReg))) {
        AlertEx("DHCPv6服务器起始地址输入格式不合法。");
        return false;
    }
    if(true != IPv6AddrChk(Dhcpv6ServerAddrChkConvert(begainAddr),"DHCPv6服务器起始地址的")){
        return false;
    }
    if((null == endAddr.match(theIpReg))) {
        AlertEx("DHCPv6服务器结束地址输入格式不合法。");
        return false;
    }
    if(true != IPv6AddrChk(Dhcpv6ServerAddrChkConvert(endAddr),"DHCPv6服务器结束地址的")){
        return false;
    }
    if(true == isStartIpbigerEndIp(begainAddr,endAddr)){
        AlertEx("DHCPv6服务器起始地址不能大于结束地址。");
        return false;
    }
    return true;
}

function CommonNumberChk(beChkedNum,minNum,maxNum,userTips)
{
    var num = removeSpaceTrim(beChkedNum);
    if("" != num){
        if ( true != CheckNumber(beChkedNum, minNum, maxNum) ){
            AlertEx(userTips+"范围为" + minNum + "-" + maxNum);
            return false;
        }
    }else{
        AlertEx(userTips+"不能为空。");
        return false;
    }
    return true;
}
function Dhcpv6RaInvertChk()
{
    var maxRaInvert = getValue("LanMaxRA_text");
    var minRaInvert = getValue("LanMinRA_text");
    
    if(true != CommonNumberChk(maxRaInvert,4,1800,"RA报文最大自动发送时间")){
        return false;
    }
    if(true != CommonNumberChk(minRaInvert,3,1800,"RA报文最小自动发送时间")){
        return false;
    }
    
	if (parseInt(maxRaInvert, 10) < parseInt(minRaInvert, 10)){
		AlertEx("RA报文最大自动发送时间不能小于RA报文最小自动发送时间。");
		return false; 
	}
    return true;
}
function CheckParameter()
{ 
	var IPAddress = getValue("IPv6Address");
	var WANName = getSelectVal("LanDNS_Interface_select");
	var DNSSourceMode = getSelectVal("LanDNS_select");
	var IpPrimaryDNS = getValue("LanPri_DNS_text");
	var IpsecondDNS = getValue("LanSec_DNS_text");
  var RAMXU = getValue("RAMXUCol");
	
	if ((false == isNum(RAMXU)) || isNaN(RAMXU) || parseInt(RAMXU,10) > 1500 || parseInt(RAMXU,10) < 1280)
	{
      AlertEx(Languages['RAMxuAlert']);
		  return false;
	}
    if (IPAddress.length == 0)
    {
        AlertEx(lan_address_language['bbsp_ipv6isreq']);
        return false;
    }
    if(false == IPv6AddrChk(IPAddress)){
        return false;
    }
    
	if((DNSSourceMode.toUpperCase() == "WANCONNECTION") && (WANName == "") )
	{
		AlertEx(lan_address_language['bbsp_selectwan']);
		return false;
	}
	if(DNSSourceMode.toUpperCase() == "STATIC")
	{
		if(IpPrimaryDNS.length == 0 && IpsecondDNS.length == 0)
		{
			AlertEx("首选DNS或者备选DNS必须至少填写一个。");
			return false;
		}
		
		if(IpPrimaryDNS.length != 0)
		{
            if(false == IPv6AddrChk(IpPrimaryDNS,"首选DNS的")){
                return false;
            }
		}
		
		if(IpsecondDNS.length != 0)
		{
            if(false == IPv6AddrChk(IpsecondDNS,"备选DNS的")){
                return false;
            }
		}
	}

    if(false == SubPrefixMaskChk()){
        return false;
    }
    
	var Ipv6PrefixMode = getSelectVal("LanPrefix_select");
	if ("STATIC" == Ipv6PrefixMode.toUpperCase()) 
	{
		var Ipv6AddPrefix = getValue("LanPrefix_text");
		if (false == CheckIpAddPrefix(Ipv6AddPrefix))
		{
			return false;
		}	
		var Ipv6PreferredLifeTime = getValue("PreferredLifeTime");
		var Ipv6ValidLifeTime = getValue("ValidLifeTime");
			
		if (false == CheckTimeValue(Ipv6PreferredLifeTime, Ipv6ValidLifeTime))
		{
			return false;
		}	
	}
	if(true == getCheckVal("LanDHCPv6_checkbox")){
    	if(true != Dhcpv6ServerAddrChk()){
    	    return false;
    	}
    }
    
    if(true != Dhcpv6RaInvertChk()){
        return false;
    }
	
    return true;     
}
	
function GetIpv6WanDnsServerString(PrimaryDnsServer, SecondaryDnsServer)
{
	var DnsServerString = "";
	if ("" != PrimaryDnsServer && "" != SecondaryDnsServer)
	{
		DnsServerString = PrimaryDnsServer + "," + SecondaryDnsServer;
	}
	else
	{
		DnsServerString = PrimaryDnsServer  + SecondaryDnsServer;
	}
	return DnsServerString;
}

function OnApplyButtonClick()
{
    if (CheckParameter() == false)
    {
        return false;
    }
    
    
    var url = "";
    var Form = new webSubmitForm();
    Form.addParameter('x.IPv6Address', getValue("IPv6Address"));
    Form.addParameter('y.Prefix', getValue("LanPrefix_text"));
    Form.addParameter('y.PreferredLifeTime', getValue("PreferredLifeTime"));
    Form.addParameter('y.ValidLifeTime', getValue("ValidLifeTime"));
    Form.addParameter('y.Mode', getSelectVal("LanPrefix_select"));
    Form.addParameter('y.ParentPrefix',getSelectVal("LanInterface_select"));
    Form.addParameter('y.ChildPrefixMask',getValue("SubPrefixMask"));
    
    if(true == getCheckVal("LanDHCPv6_checkbox")){
        Form.addParameter('n.X_HW_E8C_Enable',1);
        Form.addParameter('n.X_HW_E8C_MinAddress',getValue("LanStartAddress_text"));
        Form.addParameter('n.X_HW_E8C_MaxAddress',getValue("LanEndAddress_text"));
    }else{
        Form.addParameter('n.X_HW_E8C_Enable',0);
    }
    
    Form.addParameter('m.Enable',1);
    Form.addParameter('m.mode','Manual');
    Form.addParameter('m.ManagedFlag',(true == getCheckVal('LanAddressInfo_checkbox'))? 1 : 0);
    Form.addParameter('m.OtherConfigFlag',(true == getCheckVal('LanOtherInfo_checkbox')) ? 1 : 0);
    Form.addParameter('m.MaxRtrAdvInterval',getValue("LanMaxRA_text"));
    Form.addParameter('m.MinRtrAdvInterval',getValue("LanMinRA_text"));
    Form.addParameter('m.MTU',getValue("RAMXUCol"));
    
    Form.addParameter('p.IPv6DNSConfigType',getSelectVal("LanDNS_select"));
    Form.addParameter('p.IPv6DNSWANConnection',getSelectVal("LanDNS_Interface_select")); 
    Form.addParameter('p.IPv6DNSServers',GetIpv6WanDnsServerString(getValue("LanPri_DNS_text"), getValue("LanSec_DNS_text")));
	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	url = 'x='+Br0IPv6Address.domain+"&y="+Br0IPv6Prefix.domain + "&p="+IPv6DNSConfig.domain + "&m=InternetGatewayDevice.LANDevice.1.X_HW_RouterAdvertisement";
	url += "&n=InternetGatewayDevice.LANDevice.1.X_HW_DHCPv6";
	
	if(getValue("IPv6Address").toUpperCase()!=(Br0IPv6Address.IPv6Address).toUpperCase())
	{
		if(ConfirmEx(lan_address_language['bbsp_note']))
		{
		 	Form.setAction('set.cgi?' + url + '&RequestFile=html/logout.html');
		}
		else
		{
			return false;
		}
	}
	else
	{
		Form.setAction('set.cgi?' + url + '&RequestFile=html/bbsp/lanaddress/lanaddresse8c.asp');
	}
	
    Form.submit();
	
    setDisable('Apply_button',1);
	setDisable('ButtonCancel',1);
    return false;
}

function OnCancelButtonClick()
{       
    BindPageData();
    return true;
}
	
	
	
function PreFixModeSelect(PreFixMode)
{
	if ("STATIC" == PreFixMode.toUpperCase()) 
	{
		setDisplay("PrefixRow", 1);  
		setDisplay("PreferredLifeTimeRow", 1);
		setDisplay("ValidLifeTimeRow", 1);
		setDisplay("Ipv6parentPreList", 0);
	}
	else
	{
	    setDisplay("PrefixRow", 0);  
		setDisplay("PreferredLifeTimeRow", 0);
		setDisplay("ValidLifeTimeRow", 0);
		setDisplay("Ipv6parentPreList", 1);
	}		
}
	
function Ipv6landnsSelect(Ipv6landns)
{
	if ("WANCONNECTION" == Ipv6landns.toUpperCase()) 
	{
        setDisplay("LanDNS_Interface_selectRow", 1);
        setDisplay("LanPri_DNS_textRow", 0);
        setDisplay("LanSec_DNS_textRow", 0);
		
	}
	else if ("STATIC" == Ipv6landns.toUpperCase()) 
	{
        setDisplay("LanPri_DNS_textRow", 1);
        setDisplay("LanSec_DNS_textRow", 1);
        setDisplay("LanDNS_Interface_selectRow", 0);
		if ("FE80::1" == getValue("LanPri_DNS_text").toUpperCase() && "STATIC" != IPv6DNSConfig.IPv6DNSConfigType.toUpperCase())
        {
              setText("LanPri_DNS_text", "");
        }
	}
	else
	{
		setDisplay("LanPri_DNS_textRow", 0);
        setDisplay("LanSec_DNS_textRow", 0);
        setDisplay("LanDNS_Interface_selectRow", 0);
	}		
}

function SetIPv6DHCPServerEn(en)
{ 
	if(true == en){
	    setDisplay('ipv6LanAddBeginRow',1); 
	    setDisplay('ipv6LanAddEndRow',1);  
	}else{
	    setDisplay('ipv6LanAddBeginRow',0); 
	    setDisplay('ipv6LanAddEndRow',0); 
	}
}
</script>
<title>TODO:XXX Configuration</title>
</head>
<body  class="mainbody" onload="OnPageLoad();"> 
<form id="ConfigForm"> 
  <div id="PromptPanel"> 
    <table width="100%" border="0" cellpadding="0" cellspacing="0"> 
      <tr> 
        <td class="prompt"> <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
            <tr> 
              <td class='title_common'>在本网页上，您可以配置与IPv6相关的特性参数。</td> 
            </tr> 
          </table></td> 
      </tr> 
      <tr> 
        <td class='height5p'></td> 
      </tr> 
    </table> 
  </div> 
  <table border="0" cellpadding="0" cellspacing="0"  width="100%"> 
    <tr> 
      <td  class="table_title width_30p">IPv6地址</td> 
      <td  class="table_right width_70p"><input type=text id="IPv6Address"  class="width_254px" maxlength=255/><font color="red">*</font><span class="gray"></span></td> 
    </tr>
  </table>
  <br/><br/>
  <table border="0" cellpadding="0" cellspacing="0"  width="100%"> 
    <tr>
    	<td class="table_title width_30p">DNS来源</td> 
    	<td class="table_right width_70p"><select id="LanDNS_select"  class="width_260px" name="LanDNS_select" onChange='Ipv6landnsSelect(this.value)' >
		<option value='HGWProxy'>家庭网关代理</option>
		<option value='Static'>静态配置</option>
		<option value='WANConnection'>网络连接</option></select></td> 
    </tr>
    <tr id="LanDNS_Interface_selectRow">
    	<td class="table_title">接口</td> 
    	<td class="table_right"><select id="LanDNS_Interface_select" class="width_260px" name="LanDNS_Interface_select"></select></td> 
    </tr>
    <tr id="LanPri_DNS_textRow"> 
      <td  class="table_title">首选DNS</td> 
      <td  class="table_right"><input type=text id="LanPri_DNS_text"  class="width_254px" maxlength="23" /></td> 
    </tr> 
     <tr id="LanSec_DNS_textRow"> 
      <td class="table_title">备选DNS</td> 
      <td class="table_right"><input type=text id="LanSec_DNS_text"  class="width_254px" maxlength="23" /> </td>
    </tr> 
	<tr id="LanPrefix_selectRow">
    	<td class="table_title">前缀来源</td> 
    	<td class="table_right"><select id="LanPrefix_select"  class="width_260px" name="LanPrefix_select" onChange='PreFixModeSelect(this.value)' >
		<option value='WANDelegated'>WANDelegated</option>
		<option value='Static'>Static</option>
		</select></td> 
	</tr>
    <tr id="Ipv6parentPreList"> 
      <td class="table_title">接口</td> 
      <td class="table_right"><select id="LanInterface_select"  class="width_260px" name="LanInterface_select"> </select></td> 
    </tr>
    <tr id="PrefixRow"> 
        <td class="table_title">前缀</td> 
        <td class="table_right"><input type=text id="LanPrefix_text"  class="width_254px" maxlength=255 /> 
        <font color="red">*</font><span class="gray"><script>document.write(Languages['PrefixRemark']);</script></span></td>
    </tr> 
    <tr id="Ipv6SubPrefixList"> 
      <td class="table_title">子前缀掩码</td> 
      <td class="table_right"><input type=text id="SubPrefixMask"  class="width_254px" maxlength=255 /> 
        <font color="red">*</font><span class="gray"><script>document.write(lan_address_language['bbsp_lanaddressnote']);</script></span></td> 
        <script>getElById("SubPrefixMask").title 	= Languages['AddressStuffTitle'];</script> 
    </tr> 
    <tr id="RAMXURow" border="1" style=""> 
      <td  class="table_title align_left width_25p">MTU:</td> 
      <td  class="table_right align_left width_75p"><input type=text id="RAMXUCol"  class="width_254px" maxlength=255 /> 
        <font color="red">*</font><span id="" class="gray">(1280-1500)</span></td> 
    </tr> 
     <tr id="PreferredLifeTimeRow"> 
      <td class="table_title">首选期</td> 
      <td class="table_right"><input type=text id="PreferredLifeTime"  class="width_254px" maxlength=255 /> 
        <font color="red">*</font><span class="gray"><script>document.write(lan_address_language['bbsp_preferredtimenoteE8c']);</script></span></td> 
    </tr> 
     <tr id="ValidLifeTimeRow"> 
      <td class="table_title">合法期</td> 
      <td class="table_right"><input type=text id="ValidLifeTime"  class="width_254px" maxlength=255 /> 
        <font color="red">*</font><span class="gray"><script>document.write(lan_address_language['bbsp_vaildtimenoteE8c']);</script></span></td>
    </tr> 
    </table>

	<br/><br/>
    <table border="0" cellpadding="0" cellspacing="0"  width="100%"> 
        <tr><td class="table_title"><input id="LanDHCPv6_checkbox" type="checkbox" onclick="SetIPv6DHCPServerEn(this.checked);" name="LanDHCPv6_checkbox" value="true">启用DHCPv6服务器</td></tr>      
    </table>
    <table border="0" cellpadding="0" cellspacing="0"  width="100%"> 
        <tr id="ipv6LanAddBeginRow"> 
        <td  class="table_title width_30p">起始地址</td> 
        <td  class="table_right width_70p"><input type=text id="LanStartAddress_text"  class="width_254px" maxlength="19" /><font color="red">*</font></td></tr>    
        <tr id="ipv6LanAddEndRow"> <td class="table_title">结束地址</td> 
        <td class="table_right"><input type=text id="LanEndAddress_text"  class="width_254px" maxlength="19" /><font color="red">*</font></td></tr>    
    </table>
    <br/><br/>
    <table border="0" cellpadding="0" cellspacing="0"  width="100%"> 
     <tr > <td  class="table_title"><input id="LanAddressInfo_checkbox" type="checkbox"  name="LanAddressInfo_checkbox" value="true">地址信息是否通过DHCP获取</td></tr>
     <tr > <td  class="table_title"><input id="LanOtherInfo_checkbox" type="checkbox"  name="LanOtherInfo_checkbox" value="true">其他信息是否通过DHCP获取</td></tr>      
    </table>
    <table border="0" cellpadding="0" cellspacing="0"  width="100%"> 
        <tr id="ipv6LanAddBeginRow1"> 
            <td  class="table_title width_30p">RA报文最大自动发送时间</td> 
            <td  class="table_right width_70p"><input type=text id="LanMaxRA_text"  class="width_254px" maxlength="4" /><font color="red">*</font><span class="gray">(4-1800秒)</span></td></tr>    
        <tr id="ipv6LanAddEndRow1"> 
            <td class="table_title">RA报文最小自动发送时间</td> 
            <td class="table_right"><input type=text id="LanMinRA_text"  class="width_254px" maxlength="4" /><font color="red">*</font><span class="gray">(3-1800秒)</span></td></tr>    
    </table>
    <br/>
    <table id="ConfigPanelButtons" width="100%"  class="table_button"> 
    <tr align="right">
      <td class='width_30p'> </td> 
      <td > 
	    <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	    <button id="Apply_button"  type="button" onclick="javascript:return OnApplyButtonClick();" >保存/应用</button> 
        <button id="ButtonCancel" type="button" onclick="javascript:OnCancelButtonClick();">取消</button> </td> 
    </tr> 
    </table> 
</form> 
<script>

InitWanNameListControl("LanInterface_select", IsValidWan);    
InitWanNameListControl1("LanDNS_Interface_select", IsValidWan);

</script> 
</body>
</html>
