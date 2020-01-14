<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' rel="stylesheet" type="text/css" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(guide.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<style type="text/css">
.nofloat{
	float:none;
}

/*IE7 compatible begin*/
.contentItem{
	*text-align:left;
}

.contenbox{
	*width:300px;
	*text-align:left;
	*padding-left:10px;
}

.txt_Username{
	*padding-left:10px;
}

.textboxbg{
	*margin:auto 0px;
}
/*IE7 compatible end*/

#btnpre{
	margin-left:-90px;
}
#guideskip{
	text-decoration:none;
	color:#666666;
	white-space:nowrap;
	*display:block;			/*IE7 compatible*/
	*margin-top:-26px;		/*IE7 compatible*/
	*margin-left:230px;		/*IE7 compatible*/
	*text-decoration:none;	/*IE7 compatible*/
}
a span{
	font-size:16px;
	margin-left:10px;
}
table{
	border:0px;
	cellspacing:0;
	cellpadding:0;
}
.acctablehead{
	font-size:16px;
	color:#666666;
	font-weight:bold;
}
</style>
</head>
<script language="javascript">
var inter_index = -1;
var IsSupportWifi = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>';

function WANIP(domain,ipGetMode,serviceList,modeType,Tr069Flag)
{
	this.domain = domain;
	
	if (modeType.toString().toUpperCase().indexOf("BRIDGED") >= 0)
	{
		this.modeType = "BRIDGED";
	}
	else
	{
		this.modeType = "ROUTED";
	}
	
	this.ipGetMode = "DHCP";
	this.serviceList = serviceList;	
	this.Tr069Flag = Tr069Flag;
}

function WANPPP(domain,serviceList,modeType,Username,Password,IdleDisconnectTime,Tr069Flag,LastConnectionError)
{
	this.domain	= domain;
	
	if (modeType.toString().toUpperCase().indexOf("BRIDGED") >= 0)
	{
		this.modeType = "BRIDGED";
	}
	else
	{
		this.modeType = "ROUTED";
	}
   	
	this.ipGetMode = "PPPOE";
 	this.Username = Username;
  	this.Password = Password;

  	if ((Password == 'd41d8cd98f00b204e9800998ecf8427e') 
	 || (Password == 'D41D8CD98F00B204E9800998ECF8427E'))
	{	
		this.Password = '';
  	}
  	else
  	{
		this.Password = Password;
  	}
	 
  	this.IdleDisconnectTime = IdleDisconnectTime;    
  	this.serviceList = serviceList;
	this.Tr069Flag = Tr069Flag;
}
	
var WanIp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i},AddressingType|X_HW_SERVICELIST|ConnectionType|X_HW_TR069FLAG,WANIP);%>;
var WanPpp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i},X_HW_SERVICELIST|ConnectionType|Username|Password|IdleDisconnectTime|X_HW_TR069FLAG,WANPPP);%>;

var Wan = new Array();
var g_CurrentDomain = '';

for (i=0, j=0; WanIp.length > 1 && j < WanIp.length - 1; i++,j++)
{
  if("1" == WanIp[j].Tr069Flag)
	{
		  i--;
    	continue;
	}
	Wan[i]	= WanIp[j];
}

for (j=0; WanPpp.length > 1 && j<WanPpp.length - 1; i++,j++)
{
	if("1" == WanPpp[j].Tr069Flag)
	{
		  i--;
    	continue;
	}
	Wan[i]	= WanPpp[j];
}

function CheckForm()
{
	var Username = document.getElementById('AccountValue').value;
	var Password = document.getElementById('PwdValue').value;

	if ((Username != '') && (isValidAscii(Username) != ''))        
	{  
		AlertEx(guideinternet_language['bbsp_userh'] + Languages['Hasvalidch'] + isValidAscii(Username) + '".');          
		return false;       
	}
	
	if ((Password != '') && (isValidAscii(Password) != ''))      
	{  
		AlertEx(guideinternet_language['bbsp_pwdh'] + Languages['Hasvalidch'] + isValidAscii(Password) + '".');          
		return false;       
	}
	return true;
}

function ShowNoneWan()
{
	setText('AccountValue', "");
	setText('PwdValue', "");
	
	setDisable('AccountValue', 1);
	setDisable('PwdValue', 1);	
	
	return;
}

function filterChooseWan()
{
	var i = 0;
	
	for (i = 0; i < Wan.length; i++)
	{
		if ((Wan[i].serviceList.toString().toUpperCase().indexOf("INTERNET") < 0)
		 || (Wan[i].serviceList.toString().toUpperCase().indexOf("TR069") >= 0)
		 || (Wan[i].serviceList.toString().toUpperCase().indexOf("VOIP") >= 0)
         || (Wan[i].ipGetMode.toUpperCase() != "PPPOE"))
		{
			continue;
		}
		
		if ((Wan[i].modeType != "ROUTED") && (Wan[i].modeType != "BRIDGED"))
		{
			continue;
		}
		
		g_CurrentDomain = Wan[i].domain;  
		inter_index = i;
		
		setText('AccountValue',Wan[i].Username);
		setText('PwdValue', Wan[i].Password);
				
		setDisable('AccountValue', 0);
		setDisable('PwdValue', 0);	
			
		if (Wan[i].serviceList == "INTERNET")
		{
			break;
		}
	}
	
	return;
}

function LoadFrame()
{
	ShowNoneWan();
	
	if (0 == Wan.length)
	{
		return;
	}
	
	filterChooseWan();
	
	return;
}

function SubmitPre()
{
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : '/smartguide.cgi?1=1&RequestFile=index.asp',
		data:'Parainfo='+'0',
		success : function(data) {
		}
	});
	window.parent.location="../../../index.asp";
}

function directionweb(val)
{
	if ('1' == IsSupportWifi)
	{
		val.id = "guidewificfg";
		val.name = "/html/amp/wlanbasic/guidewificfg.asp";
		window.parent.onchangestep(val); 
	}
	else
	{
		val.id = "guidesyscfg";
		val.name = "/html/ssmp/accoutcfg/guideaccountcfg.asp";
		window.parent.onchangestep(val);
	}
}

function SubmitNext(val)
{
	if (false == CheckForm())
	{
		return false;
	}
	

	if (-1 != inter_index)
	{
		var guideConfigParaList = new Array(new stSpecParaArray("x.Username",getValue('AccountValue'), 0),
									  new stSpecParaArray("x.Password",getValue('PwdValue'), 0));
											  
		var Parameter = {};	
		Parameter.OldValueList = null;
		Parameter.FormLiList = null;
		Parameter.UnUseForm = true;
		Parameter.asynflag = false;
		Parameter.SpecParaPair = guideConfigParaList;
	
		var ConfigUrl = "setajax.cgi?x=" + Wan[inter_index].domain + '&RequestFile=/html/bbsp/guideinternet/guideinternet.asp';							  
		var tokenvalue = getValue('onttoken');
		HWSetAction("ajax", ConfigUrl, Parameter, tokenvalue);
	}
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : '/smartguide.cgi?1=1&RequestFile=index.asp',
		data:'Parainfo='+'0',
		success : function(data) {
		}
	});
	directionweb(val);
}

function onskip(val)
{
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : '/smartguide.cgi?1=1&RequestFile=index.asp',
		data:'Parainfo='+'0',
		success : function(data) {
		}
	});
	directionweb(val);
}

</script>
<body onload="LoadFrame();" style="background-color: #ffffff; overflow-x:hidden; overflow-y:hidden;" scroll="no">  
<div align="center">
	<table width="550px" style="margin-left:350px;">
		<tr>
			<td height="35px"></td>
		</tr>
		<tr align="left">
			<td class="acctablehead" BindText="bbsp_title"></td>
		</tr>
	</table>

<div id="userinfo">
	<div id="username" class="contentItem nofloat">
		<div class="labelBox"><span id="user" BindText="bbsp_user"></span></div>
		<div class="contenbox nofloat">
			<input type="text" disabled="disabled" id="AccountValue" name="AccountValue" style="line-height:34px;" class="textboxbg"/>
		</div>
	</div>
	<div id="userpwd" class="contentItem nofloat">
		<div class="labelBox"><span id="userpassword" BindText="bbsp_pwd"></span></div>
		<div class="contenbox nofloat"><input type="password" id="PwdValue" name="PwdValue" class="textboxbg" style="font-size:14px;line-height:34px;" maxlength="63"/></div>
	</div>
	<div class="contentItem btnGuideRow nofloat">
		<div class="labelBox"></div>
		<div class="contenbox nofloat">
			<input type="button" id="btnpre" name="/html/amp/wlanbasic/guidewificfg.asp"     class="CancleButtonCss buttonwidth_100px" onClick="SubmitPre(this);" BindText="bbsp_exit">
			<input type="button" id="guidewificfg" name="/html/amp/wlanbasic/guidewificfg.asp" class="ApplyButtoncss buttonwidth_100px"  onClick="SubmitNext(this);" BindText="bbsp_next">
			<a id="guideskip" name="/html/amp/wlanbasic/guidewificfg.asp" href="#" onClick="onskip(this);">
				<span BindText="bbsp_skip"></span>
			</a>
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
		</div>
	</div>
</div>
	<script>
		ParseBindTextByTagName(guideinternet_language, "span",  1);
		ParseBindTextByTagName(guideinternet_language, "td",    1);
		ParseBindTextByTagName(guideinternet_language, "input", 2);
	</script>
</div>
</body>
</html>
