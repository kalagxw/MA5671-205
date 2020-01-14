<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Cache-Control" content="no-cache" />
<meta http-equiv="expires" content="Fri, 12 Jan 2001 18:18:18 GMT">
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
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(md5.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(safelogin.js);%>"></script>
<script language="JavaScript" type="text/javascript">
function GetRandCnt() { return '<%HW_WEB_GetRandCnt();%>'; }
function MD5(str) { return hex_md5(str); }
var LoginTimes = <%HW_WEB_GetLoginFailCount();%>;
var Language = '<%HW_WEB_GetCurrentLanguage();%>';
var errloginlockNum = '<%HW_WEB_GetTryLoginTimes();%>';
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

document.title = "tripleT";

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
	var Username= document.getElementById("txt_Username_manul");
  var Password=document.getElementById("txt_Password_manul");
  var appName = navigator.appName;
	var version = navigator.appVersion;
	
	if (appName == "Microsoft Internet Explorer")
	{
		var versionNumber = version.split(" ")[3];
		if (parseInt(versionNumber.split(";")[0]) < 6)
		{
			AlertEx("We cannot support the IE version which is lower than 6.0.");
			return false;
		}
	}
		
	if (Username.value == "") {
		AlertEx("Account is a required field.");
		Username.focus();
      	return false;
	}
	
	if (!isValidAscii(Username.value))
	{
		AlertEx("Account is invalid.");
		Username.focus();
		return false;
	}
	
	if (Password.value == "") {
		AlertEx("Password is a required field.");
		Password.focus();
      	return false;
	}
	
	if (!isValidAscii(Username.value))
	{
		AlertEx("Password is invalid.");
		Password.focus();
		return false;
	}
	
var cnt = GetRandCnt();
var cookie2 = "Cookie=" + "UserName:" + Username.value + ":" + "PassWord:" + base64encode(Password.value) + ":" + "Language:" + Language + ":SubmitType=SetAcs" + ":" + "id=-1;path=/";

document.cookie = cookie2;

Username.disabled = true;
Password.disabled = true;

	var Form = new webSubmitForm();
	Form.addParameter('CheckCode', getValue('VerificationCode'));	
	Form.addParameter('x.X_HW_Token', cnt);
	Form.setAction('login.cgi?' +'&CheckCodeErrFile=tripleTAuthAcs.asp');
	Form.submit();	
  
  return true;
		
}

function LoadFrame() {

	document.getElementById("imgcode").src = 'getCheckCode.cgi?&rand=' + new Date().getTime();
		var cookie = document.cookie;
		if ("" != cookie)
		{
			var date=new Date();
			date.setTime(date.getTime()-10000);
			var cookie22 = cookie + ";expires=" + date.toGMTString();
			document.cookie=cookie22;	
		} 
		
 	document.getElementById('txt_Username_manul').focus();
	init();
	
	if ((LoginTimes != null) && (LoginTimes != '') && (LoginTimes > 0)) 
	{
		if( 1== errValidateCode)
		{
			SetErrorInfo("errorInfo", "Incorrect verification code.");
		}
		else if( 2== errValidateCode)
		{
			SetErrorInfo("errorInfo", "Login failure.");
		}
		else if((LoginTimes > 0) && (LoginTimes < errloginlockNum)) 
		{			
			SetErrorInfo("errorInfo", "Login failure.");
		}		
	}
    
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

function init() {
    if (document.addEventListener) {
        document.addEventListener("keypress", onHandleKeyDown, false);
    } else {
        document.onkeypress = onHandleKeyDown;
    }
}
function onHandleKeyDown(event) {
    var e = event || window.event;
    var code = e.charCode || e.keyCode;

    if (code == 13) {
        SubmitForm();
    }
}

function BthRefresh()
{
	document.getElementById("imgcode").src = 'getCheckCode.cgi?&rand=' + new Date().getTime();
}
</script>
</head>
<body onload="LoadFrame();">
<div id="div_visite">
<table width="660px" height="60px" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
	    <td width="70%" height="20" align="left" ></td>
        <td height="10" colspan="3" align="right" bgcolor="#FFFFFF"></td>
    </tr>
</table>


<table width="505px" border="0" align="center" cellpadding="1" cellspacing="1" bordercolor="#000000" bordercolorlight="#FF0000" style="background: url(../images/bg1.gif) no-repeat; width:503;height:349">
	<tr>
	<td width="100%" height="100"></td>
	</tr>
	<tr>

	<td width="95%" height="40px" align="left" style="padding-left:126px;"><font size="+2" face="Arial">TR069 Management</td>


    </tr>
    
	<tr>
	 <td>
<table   border="0" cellpadding="0" cellspacing="0" width="100%">
		<td align="right" width="40%">Account :</td> 
        <td><label>
            <input name="txt_Username_manul" type="text" id="txt_Username_manul" style="width:140px; font-family:Arial" maxlength="31"/>

        </label>
		</td>
</table>
   </td>
    </tr>
	 <tr>
	 <td>
	 
	<table  border="0" cellpadding="0" cellspacing="0" width="100%">

        <td align="right" width="40%">Password :</td> 

        <td><input name="txt_Password_manul" type="password" id="txt_Password_manul" style="width:140px; font-family:Arial" maxlength="127"/>
		</td>
    </table>

		</td>
    </tr>
	
    <tr>
	 <td>
	 
	<table  border="0" cellpadding="0" cellspacing="0" width="100%">

        <td align="right" width="40%">Verification code :</td> 

        <td><input name="VerificationCode" type="text" id="VerificationCode" style="width:140px; font-family:Arial" maxlength="31"/>
		</td>
    </table>

		</td>
    </tr>
	
	<tr>
	 <td>
	 
	<table  border="0" cellpadding="0" cellspacing="0" width="100%">

        <td align="right" width="40%"></td> 

        <td>
		<img id="imgcode" style="height:30px;width:100px;" onClick="BthRefresh();">		
		<input type="button" id="btnRefresh" style="font-size:12px;font-family:Tahoma,Arial;margin-left:30px;" class="submit" value="Refresh" onclick="BthRefresh();"/>
		</td>
    </table>
	</td>
    </tr>
	
		<tr>
	 <td>
	 
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
        <td align="right" width="48%"></td> 
        <td>
		<button style="font-size:12px;font-family:Tahoma,Arial;" id="buttonmanul" class="submit" name="Submit" onClick="SubmitForm();" type="button">Submit</button>
		</td>
    </table>
	</td>
    </tr>
    <tr>
	<td>

<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	<tr align="center"><td height="20px" id="errorInfo" style="color:red;"></td></tr>
</table>
	
   </td>	
    </tr>
	 <tr>
	 <td>

	</td>
</tr>
</table>

<br>
<br>
<br>
<br>
<br>
<table width="660px" border="0" align="center" cellpadding="1" cellspacing="1" bordercolor="#6CB4CE" style="position:relative;">
    <tr>
		<td height="10" align="left" bgcolor="#FFFFFF"><label>
		    <script language="javascript">
  			document.write('<div  style="background: url(../images/logo3bb1.gif) no-repeat; width:131px; height:73px;"></div>');  	
        	</script>
		</label></td>
		<td height="10" align="left" bgcolor="#FFFFFF">ทริปเปิลที อินเทอร์เน็ต <br><font color="#333333" size="-1">200 หมู่ 4 ถนนแจ้งวัฒนะ ตำบลปากเกร็ด อำเภอปากเกร็ด จังหวัด นนทบุรี 11120 โทรศัพท์ 02 100 2100</font></td>
		<td height="10" align="left" bgcolor="#FFFFFF"><label>
		    <script language="javascript">
  			document.write('<div  style="background: url(../images/callcenter.gif) no-repeat; width:131px; height:73px;"></div>');  	
        	</script>
		</label></td>
    </tr>
</table>
</div>
<script language="JavaScript" type="text/javascript">
</script>
</body>
</html>
