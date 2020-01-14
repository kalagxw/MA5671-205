<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Cache-Control" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<style type="text/css">
#div_visite {
	margin-left: 50px;
	margin-top: 50px;
	margin-right: 50px;
	margin-bottom: 100px;
	font-family: "宋体";
	font-size: 12px;
	color: #333333;	
}

table {
	font-family: "宋体";
	font-size: 15px;
}
</style>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(md5.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
<script language="JavaScript" src="../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" type="text/javascript">
function GetRandCnt() { return '<%HW_WEB_GetRandCnt();%>'; }
function MD5(str) { return hex_md5(str); }

var errValidateCode = '<%HW_WEB_GetCheckCodeResult();%>';
function SetErrorInfo(Id, Value)
{
    try
    {
        var ErrorInfo = document.getElementById(Id);
        ErrorInfo.innerHTML = Value;
    }
    catch(ex)
    {

    }
}
function WanPPP(domain,ConnectionType,X_HW_SERVICELIST,X_HW_ExServiceList,Username,Password)
{
	this.domain 	       = domain;
	this.ConnectionType 	       = ConnectionType;
	this.X_HW_SERVICELIST 	       = X_HW_SERVICELIST;
	this.X_HW_ExServiceList 	       = X_HW_ExServiceList;
	this.Username 	       = Username;
	this.Password 	       = Password;
}

function WanPPPResult(PwdCheckResult,PPPoEdomain,PPPoEUsername,PPPoEPassword)
{
	this.PwdCheckResult 	   = PwdCheckResult;
	this.PPPoEdomain 	       = PPPoEdomain;
	this.PPPoEUsername 	       = PPPoEUsername;
	this.PPPoEPassword 	       = PPPoEPassword;
}
var WanList = new Array(null);
var ontPPPoEWANStatus = new WanPPPResult(null);
var oldPasswd = '';

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
		b.innerHTML = trip3bb_language[b.getAttribute("BindText")];
	}
}

var LoginTimes = <%HW_WEB_GetLoginFailCount();%>;
var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var Var_DefaultLang = '<%HW_WEB_GetCurrentLanguage();%>';
var Language = "chinese";
document.title = "3bb";

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

function SubmitForm()
{
	var Username = getValue('txt_Username');
    var Password = getValue('txt_Password');
	var Form = new webSubmitForm();
	
	if ((Username != '') && (!isValidAscii(Username)))          
	{  
		AlertEx(Languages['IPv4UserName1'] + Languages['Hasvalidch'] + Username + '".');          
		return false;       
	}
	
	if ((Password != '') && (!isValidAscii(Password)))         
	{  
		AlertEx(Languages['IPv4Password1'] + Languages['Hasvalidch'] + Password + '".');         
		return false;       
	}
	
	Form.addParameter('x.Username', Username);
	if(oldPasswd != Password){
	    Form.addParameter('x.Password', Password);
    }

	if (ontPPPoEWANStatus.PPPoEdomain==null) 
	{
		AlertEx(trip3bb_language['bbsp_nointernetwan']);
		return false;
	}

	Form.addParameter('CheckCode', getValue('ValidateCode'));
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('3bbset.cgi?x='+ontPPPoEWANStatus.PPPoEdomain+'&CheckCodeErrFile=trip_3bb.asp&RequestFile=trip_3bb.asp'); 
		
	setDisable('btnSubmit', 1);
    setDisable('btnClose', 1);
    Form.submit(); 
}


function LoadFrame() {

    if( ( window.location.href.indexOf("set.cgi?") > 0) )
	{
		AlertEx(trip3bb_language['bbsp_savecompleted']);
	}
	
	document.getElementById("imgcode").src = 'getCheckCode.cgi?&rand=' + new Date().getTime();
	
	if( 1== errValidateCode)
	{
		SetErrorInfo("errorInfo", "Incorrect verification code!");
	}
	SubmitUserInfo();
}

function ClickClose() 
{
	 if (navigator.userAgent.indexOf("MSIE") > 0) 
	 {     
		if (navigator.userAgent.indexOf("MSIE 6.0") > 0) 
		{
			window.opener = null; window.close();
		}
		else 
		{
			window.open('', '_top'); window.top.close();
		}
     }
     else if (navigator.userAgent.indexOf("Firefox") > 0) 
	 {
		 window.location.href = 'about:blank ';
     }
     else
	 {
		window.opener = null; 
		window.open('', '_self', '');
		window.close();
	 }
	 
}


function SubmitUserInfo() 
{
        $.ajax(
		{
        type : "POST",
        async : false,
        cache : false,
        url : 'asp/CheckUserInfo.asp?&1=1',
        success : function(data) {
			    ontPPPoEWANStatus=eval(data);
			}
		});

		if (null!= ontPPPoEWANStatus.PPPoEdomain)	
		{
			setText('txt_Username',ontPPPoEWANStatus.PPPoEUsername);
			setText('txt_Password',ontPPPoEWANStatus.PPPoEPassword);
			oldPasswd = ontPPPoEWANStatus.PPPoEPassword;
		}
		else
		{
			setText('txt_Username',"");
			setText('txt_Password',"");
		}
		return;		
}

function BthRefresh()
{
	document.getElementById("imgcode").src = 'getCheckCode.cgi?&rand=' + new Date().getTime();
}


</script>
</head>
<body onload="LoadFrame();">
<div id="div_visite">
<table width="660px" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
	    <td width="70%" height="20" align="left" ></td>
        <td height="10" colspan="3" align="right" bgcolor="#FFFFFF"><label>
        <a href="login.asp"><img style="width:80px; height:60px;" border="0" src="../images/help3BB.gif"></a>	
		</label></td>
    </tr>
</table>

<table width="505px" border="0" align="center" cellpadding="1" cellspacing="1" bordercolor="#000000" bordercolorlight="#FF0000" style="background: url(/images/bg1.gif) no-repeat;width:503;height:349">
	<tr>
	<td width="100%" height="120"></td>
	</tr>
	<tr>
	<td>
	<table  border="0" cellpadding="0" cellspacing="0" width="100%">
	<td width="11%"></td>
	<td width="89%" height="20" align="left">
	    <script language="javascript">
		    document.write(trip3bb_language['bbsp_trip3bb_title']);  	
    	</script>	    
	</td>
	</table>
	</td>
    </tr>
    
	<tr>
	<td>		
		<table   border="0" cellpadding="0" cellspacing="0" width="100%">
		<td align="right" width="40%">User Name :</td> 
        <td><label>
            <input name="txt_Username" type="text" id="txt_Username" style="width:140px; font-family:Arial" maxlength="31"/>

        </label>
		</td>
		</table>
	</td>
    </tr>
    <tr>
	<td>	
	<table   border="0" cellpadding="0" cellspacing="0" width="100%">
		<td align="right" width="40%">Password :</td> 
        <td><label>
            <input name="txt_Password" type="password" id="txt_Password" style="width:140px; font-family:Arial" maxlength="31"/>

        </label>
		</td>
	</table>
   </td>
    </tr>
		
		<tr>
		 <td>
		<table  border="0" cellpadding="0" cellspacing="0" width="100%">
			<td align="right" width="40%">Verification code :</td> 
			<td><input name="txt_Password_manul" type="text" id="ValidateCode" style="width:140px; font-family:Arial" maxlength="31"/>
			</td>
		</table>
		<table style="" border="0" cellpadding="0" cellspacing="0" width="100%">
	<td width="100%" height="5"></td>
	</table>
		</td>
		</tr>
		
		
	<tr>
	 <td>		
		<table  border="0" cellpadding="0" cellspacing="0" width="100%">
			<td align="right" width="42%"></td> 
			<td>
			<img id="imgcode" style="height:30px;width:100px;" onClick="BthRefresh();">		
			<input type="button" id="btnRefresh" style="font-size:12px;font-family:Tahoma,Arial;margin-left:30px;" class="submit" value="Refresh" onclick="BthRefresh();"/>
			</td>
		</table>
	</td>
    </tr>
	 <tr>
	 <td>
	<table style="" border="0" cellpadding="0" cellspacing="0" width="100%">
	<td width="100%" height="10"></td>
	</table>
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<td width="20%"></td>
		<td width="12%"><button id="btnSubmit" name="btnSubmit" type="button" class="submit" onclick="SubmitForm();"/><script>document.write(trip3bb_language['bbsp_save']);</script></td>
		<td width="3%"></td>
		<td width="12%"><button id="btnClose" name="btnClose" type="button" class="submit" onclick="ClickClose();"/><script>document.write(trip3bb_language['bbsp_close']);</script></td>
		<td width="13%"></td>
	</table>
	<tr>
	 <td>	
	 <table style="" border="0" cellpadding="0" cellspacing="0" width="100%">
		<td width="100%" height="10"></td>	
	</table>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" >
		<tr align="center"><td height="20px" id="errorInfo" style="color:red;"></td></tr>
	</table>
	<table style="" border="0" cellpadding="0" cellspacing="0" width="100%">
		<td width="100%" height="35"></td>	
	</table>
	</td>
    </tr>
</table>

<br>
<br>
<br>

<table width="660px" border="0" align="center" cellpadding="1" cellspacing="1" bordercolor="#6CB4CE" style="position:relative;">
    <tr>
		<td height="10" align="left" bgcolor="#FFFFFF"><label>
		    <script language="javascript">
  			document.write('<div  style="background: url(/images/logo3bb1.gif) no-repeat; width:131px; height:73px;"></div>');  	
        	</script>
		</label>
		<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"></td>
		<td height="10" align="left" bgcolor="#FFFFFF"><font color="#000000">ทริปเปิลที อินเทอร์เน็ต <br></font><font color="#333333" size="-1">200 หมู่ 4 ถนนแจ้งวัฒนะ ตำบลปากเกร็ด อำเภอปากเกร็ด จังหวัด นนทบุรี 11120 </font>
		<br><font color="#333333" size="-1"> โทรศัพท์ 02 100 2100</font></td>
		<td height="10" align="left" bgcolor="#FFFFFF"><label>
		    <script language="javascript">
  			document.write('<div  style="background: url(/images/callcenter.gif) no-repeat; width:131px; height:73px;"></div>');  	
        	</script>
		</label></td>
    </tr>
</table>
</div>
<script language="JavaScript" type="text/javascript">
</script>
</body>
</html>
