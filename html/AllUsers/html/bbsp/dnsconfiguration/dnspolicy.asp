<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<title>dns policy</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">


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
		b.innerHTML = dnspolicy_language[b.getAttribute("BindText")];
	}
}

function stDnsInfo(domain,type,policy)
{
    this.domain = domain;
	this.type = type;
	this.policy = policy;
}

var curUserType='<%HW_WEB_GetUserType();%>';
var DnspolicyInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DNS, SupportedRecordTypes|LocalDNSPolicy,stDnsInfo);%>; 
var DnspolicyInfo = DnspolicyInfos[0];


function LoadFrame()
{
 	if ( null != DnspolicyInfo )
	{
	    setSelect('Dnspolicy',DnspolicyInfo.policy);
	}

	if(curUserType != '0')
    {
    	setDisable("Dnspolicy",1);			
		setDisable("btnApply",1);
		setDisable("cancelValue",1);
	}
	setDisplay('TableConfigInfo',1);
	loadlanguage();	
}

function OnApply()
{
	var val = getSelectVal('Dnspolicy');
	if("" == val)
	{
		AlertEx('please select a mode for dns policy!');
		return false;
	}
							 				
	var Parameter = {};
	Parameter.asynflag = null;
	Parameter.FormLiList = DnsPolicyConfigFormList;
	Parameter.SpecParaPair = null;
	var tokenvalue = getValue('onttoken'); 
	var url = 'set.cgi?' +'x=InternetGatewayDevice.X_HW_DNS' + '&RequestFile=html/bbsp/dnsconfiguration/dnspolicy.asp';
	HWSetAction(null, url, Parameter, tokenvalue);
   
	setDisable('btnApply',1);
    setDisable('cancelValue',1);
}

function CancelConfig()
{
    LoadFrame();
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("dnspolicytitleinfo", GetDescFormArrayById(dnscfg_language, "bbsp_mune"), GetDescFormArrayById(dnspolicy_language, "bbsp_dnspolicy_title"), false);
</script>
<div class="title_spread"></div>

<form id="TableConfigInfo" style="display:none;">
<table border="0" cellpadding="0" cellspacing="1"  width="100%"> 
<li   id="Dnspolicy"   RealType="DropDownList"     DescRef="bbsp_dnsmodemh"     RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.LocalDNSPolicy"      InitValue="[{TextRef:'bbsp_DEFAULT',Value:'1'},{TextRef:'bbsp_PRIORITY',Value:'2'},{TextRef:'bbsp_INTERNET',Value:'3'}]" />                                                                   
</table>
<script LANGUAGE="JavaScript"> 
	 var TableClass = new stTableClass("width_per25", "width_per75", "ltr");
	 DnsPolicyConfigFormList = HWGetLiIdListByForm("TableConfigInfo", null);
	 HWParsePageControlByID("TableConfigInfo", TableClass, dnspolicy_language, null);
	 getElById("Dnspolicy").title = dnspolicy_language['bbsp_dnshelp'];
</script>
<table cellpadding="0" cellspacing="1" width="100%" class="table_button"> 
<tr> 
  <td class="width_per25" ></td> 
  <td class="table_submit">
	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
	<button name="btnApply" id="btnApply" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="OnApply();"><script>document.write(dnspolicy_language['bbsp_app']);</script></button> 
	<button name="cancelValue" id="cancelValue" class="CancleButtonCss buttonwidth_100px"  type="button" onClick="CancelConfig();"><script>document.write(dnspolicy_language['bbsp_cancel']);</script></button>
</td> 
</tr> 
</table> 
</form>
  
  
</body>
</html>
