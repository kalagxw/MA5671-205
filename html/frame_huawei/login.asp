<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="Cuscss/<%HW_WEB_CleanCache_Resource(login.css);%>"  media="all" rel="stylesheet" />
<style type="text/css">
#first{
	background-color:white;
	height:25px;
	text-align: center;
	color: red;
	position:absolute;
	width: 380px;
	top: 312px;
}
</style>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(md5.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(safelogin.js);%>"></script>
<script language="JavaScript" type="text/javascript">
function MD5(str) { return hex_md5(str); }

var FailStat ='<%HW_WEB_GetLoginFailStat();%>';
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var LoginTimes = '<%HW_WEB_GetLoginFailCount();%>';
var ModeCheckTimes = '<%HW_WEB_GetModPwdFailCnt();%>';
var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var Var_DefaultLang = '<%HW_WEB_GetCurrentLanguage();%>';
var Var_LastLoginLang = '<%HW_WEB_GetLoginRequestLangue();%>';
var LockTime = '<%HW_WEB_GetLockTime();%>';
var LockLeftTime = '<%HW_WEB_GetLeftLockTime();%>';
var errloginlockNum = '<%HW_WEB_GetTryLoginTimes();%>';
var errVerificationCode = '<%HW_WEB_GetCheckCodeResult();%>';
var Language = '';
var locklefttimerhandle;

if(Var_LastLoginLang == '')
{
	Language = Var_DefaultLang;
}
else
{
	Language = Var_LastLoginLang;
}

document.title = ProductName;

function getValue(sId)
{
	var item;
	if (null == (item = getElement(sId)))
	{
		debug(sId + " is not existed" );
		return -1;
	}

	return item.value;
}

var CfgCTArea = '<%GetConfigCTAreaInfo_MxU();%>';

function CTAreaRelationInfo(Des, Area)
{
	this.Des = Des;
	this.Area = Area;
}

var ctAreaInfos = new Array(new CTAreaRelationInfo("移动", 'CHOOSE_CMCC'),
                            new CTAreaRelationInfo("电信", 'CHOOSE_XINAN'),
                            new CTAreaRelationInfo("联通", 'CHOOSE_UNICOM'),
							null);

var CfgFtWordArea = '<%GetConfigAreaInfo();%>';
var CfgFtWord = '<%HW_WEB_GetCfgMode();%>';

function AreaRelationInfo(ChineseDes, E8CArea)
{
this.ChineseDes = ChineseDes;
this.E8CArea = E8CArea;
}

var AreaRelationInfos = new Array();
var userEthInfos = new Array(new AreaRelationInfo("重庆","023"),
							 new AreaRelationInfo("四川","028"),
							 new AreaRelationInfo("云南","0871"),
							 new AreaRelationInfo("贵州","0851"),			 
							 new AreaRelationInfo("北京","010"),
							 new AreaRelationInfo("上海","021"),
							 new AreaRelationInfo("天津","022"),	 
							 new AreaRelationInfo("安徽","0551"),
							 new AreaRelationInfo("福建","0591"),
							 new AreaRelationInfo("甘肃","0931"),
							 new AreaRelationInfo("广东","020"),
							 new AreaRelationInfo("广西","0771"),			 
							 new AreaRelationInfo("海南","0898"),
							 new AreaRelationInfo("河北","0311"),
							 new AreaRelationInfo("河南","0371"),
							 new AreaRelationInfo("湖北","027"),
							 new AreaRelationInfo("湖南","0731"),
							 new AreaRelationInfo("吉林","0431"),
							 new AreaRelationInfo("江苏","025"),
							 new AreaRelationInfo("江西","0791"),
							 new AreaRelationInfo("辽宁","024"),
							 new AreaRelationInfo("宁夏","0951"),
							 new AreaRelationInfo("青海","0971"),
							 new AreaRelationInfo("山东","0531"),
							 new AreaRelationInfo("山西","0351"),
							 new AreaRelationInfo("陕西","029"),	 
							 new AreaRelationInfo("西藏","0891"),
							 new AreaRelationInfo("新疆","0991"),				 
							 new AreaRelationInfo("浙江","0571"),
							 new AreaRelationInfo("黑龙江","0451"),
							 new AreaRelationInfo("内蒙古","0471"),
							 null);
							 
function GetE8CAreaByCfgFtWord(userEthInfos,E8CArea,ctAreaInfos,CTArea)
{
	var dec = "";
	var length = userEthInfos.length;
	var i = 0;

	for(i = 0; i <  length - 1; i++)
	{
		if(E8CArea == userEthInfos[i].E8CArea)
		{
			dec = userEthInfos[i].ChineseDes;
			break;
		}
	}
	
	if (i ==  length - 1) return "";
	
	length = ctAreaInfos.length;
	for(i = 0; i <  length - 1; i++)
	{
		if(CTArea == ctAreaInfos[i].Area)
		{
			return dec + ctAreaInfos[i].Des;
		}
	}
	return "";
}
		
var CfgFtChineseArea = GetE8CAreaByCfgFtWord(userEthInfos,CfgFtWordArea,ctAreaInfos,CfgCTArea);

function showlefttime()
{
	if(LockLeftTime <= 0)
	{
		window.location="/login.asp";
		return;
	}

	if(LockLeftTime == 1)
	{
		if(Language == 'portuguese')
		{
			if('PTVDF' == CfgMode.toUpperCase())
			{
				var errhtml = 'Demasiadas tentativas, volte a tentar daqui a ' +  LockLeftTime + ' segundo';
			}
			else
			{
				var errhtml = 'Demasiadas tentativas, tente ' +  LockLeftTime + ' segundos mais tarde';
			}
		}
		else if(Language == 'japanese')
		{
			var errhtml = '再試行回数が多すぎます。' +  LockLeftTime + '秒後に再試行してください。';
		}
		else if(Language == 'spanish')
		{
			var errhtml = 'Ha intentado muchas veces. Vuelva a intentarlo dentro de ' +  LockLeftTime + ' segundo/s.';
		}
		else if(Language == 'chinese')
		{
			var errhtml = '您登录失败的次数已超出限制，请' +  LockLeftTime + '秒后重试！';
		}
		else
		{
			if('PTVDF' == CfgMode.toUpperCase())
			{
				var errhtml = 'Too many retries, please retry in ' +  LockLeftTime + ' second.';
			}
			else
			{
				var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' second later.';
			}
		}
	}
	else
	{
		if(Language == 'portuguese')
		{
			if('PTVDF' == CfgMode.toUpperCase())
			{
				var errhtml = 'Demasiadas tentativas, volte a tentar daqui a ' +  LockLeftTime + ' segundos';
			}
			else
			{
				var errhtml = 'Demasiadas tentativas, tente ' +  LockLeftTime + ' segundos mais tarde.';
			}
		}
		else if(Language == 'japanese')
		{
			var errhtml = '再試行回数が多すぎます。' +  LockLeftTime + '秒後に再試行してください。';
		}
		else if(Language == 'spanish')
		{
			var errhtml = 'Ha intentado muchas veces. Vuelva a intentarlo dentro de ' +  LockLeftTime + ' segundos.';
		}
		else if(Language == 'chinese')
		{
			var errhtml = '您登录失败的次数已超出限制，请' +  LockLeftTime + '秒后重试！';
		}
		else
		{
			if('PTVDF' == CfgMode.toUpperCase())
			{
				var errhtml = 'Too many retries, please retry in ' +  LockLeftTime + ' seconds.';
			}
			else
			{
				var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' seconds later.';
			}
		}
	}

	SetDivValue("DivErrPage", errhtml);
	LockLeftTime = LockLeftTime - 1;
}

function setErrorStatus()
{
	clearInterval(locklefttimerhandle);
	if('1' == FailStat || (ModeCheckTimes >= errloginlockNum))
	{

		if(Language == 'portuguese')
		{
			var errhtml = "Demasiadas tentativas.";
		}
		else if(Language == 'japanese')
		{
			var errhtml = "再試行回数が多すぎます。";
		}
		else if(Language == 'spanish')
		{
			var errhtml = "Ha intentado muchas veces.";
		}
		else
		{
			var errhtml = 'Too many retrials.';
		}
		SetDivValue("DivErrPage", errhtml);
		setDisable('txt_Username',1);
		setDisable('txt_Password',1);
		if ( 'TRIPLET' == CfgMode.toUpperCase())
		{
			setDisable('VerificationCode',1);
			setDisable('tripletbtn',1);
		}
		setDisable('button',1);
	}
	else if(LoginTimes >= errloginlockNum && parseInt(LockLeftTime) > 0)
	{
		if(Language == 'portuguese')
		{
			if('PTVDF' == CfgMode.toUpperCase())
			{
				var errhtml = 'Demasiadas tentativas, volte a tentar daqui a ' +  LockLeftTime + ' segundos';
			}
			else
			{
				var errhtml = 'Demasiadas tentativas, tente ' +  LockLeftTime + ' segundos mais tarde.';
			}
		}
		else if(Language == 'japanese')
		{
			var errhtml = '再試行回数が多すぎます。' +  LockLeftTime + ' 秒後に再試行してください。';
		}
		else if(Language == 'spanish')
		{
			var errhtml = 'Ha intentado muchas veces. Vuelva a intentarlo dentro de ' +  LockLeftTime + ' segundos.';
		}
		else if(Language == 'chinese')
		{
			var errhtml = '您登录失败的次数已超出限制，请' +  LockLeftTime + '秒后重试！';
		}
		else
		{
			if('PTVDF' == CfgMode.toUpperCase())
			{
				var errhtml = 'Too many retries, please retry in ' +  LockLeftTime + ' seconds.';
			}
			else
			{
				var errhtml = 'Too many retrials, please retry ' +  LockLeftTime + ' seconds later.';
			}
		}

		SetDivValue("DivErrPage", errhtml);
		setDisable('txt_Username',1);
		setDisable('txt_Password',1);
		if ( 'TRIPLET' == CfgMode.toUpperCase())
		{
			setDisable('VerificationCode',1);
			setDisable('tripletbtn',1);
		}
		setDisable('button',1);
		locklefttimerhandle = setInterval('showlefttime()', 1000);
	}
	else if( 1== errVerificationCode)
	{
		SetDivValue("DivErrPage", "Incorrect verification code.");
	}
	else if( 2== errVerificationCode)
	{
		SetDivValue("DivErrPage", "Login failure.");
	}
	else if((LoginTimes > 0) && (LoginTimes < errloginlockNum))
	{
		if(Language == 'portuguese')
		{
			var errhtml = "Nome de conta ou palavra-passe inválidos. Tente novamente.";
		}
		else if(Language == 'japanese')
		{
			var errhtml = "アカウントとパスワードの組み合わせが不正確です。 もう一度やり直してください。";
		}
		else if(Language == 'spanish')
		{
			var errhtml = "La combinación de la usuario/contraseña es incorrecta. Favor de volver a intentarlo.";
		}
		else if ( 'TRIPLET' == CfgMode.toUpperCase())
		{
			var errhtml = 'Login failure.';
		}
		else if(Language == 'chinese')
		{
			var errhtml = '用户名或密码错误，请重新登录。';
		}
		else
		{
			var errhtml = 'Incorrect account/password combination. Please try again.';
		}

		SetDivValue("DivErrPage", errhtml);
	}
	else
	{
		document.getElementById('loginfail').style.display = 'none';
	}
}


function SubmitForm() {
	var Username = document.getElementById('txt_Username');
	var Password = document.getElementById('txt_Password');
	var appName = navigator.appName;
	var version = navigator.appVersion;

	if(Language == "portuguese")
	{
		if (appName == "Microsoft Internet Explorer")
		{
			var versionNumber = version.split(" ")[3];
			if (parseInt(versionNumber.split(";")[0]) < 6)
			{
				alert("Versões IE inferiores a 6.0 não são compatíveis.");
				return false;
			}
		}

		if (Username.value == "") {
			alert("Conta não pode ficar em branco.");
			Username.focus();
			return false;
		}

		if (!isValidAscii(Username.value))
		{
			alert("Nome de conta inválido.");
			Username.focus();
			return false;
		}

		if (Password.value == "") {
			alert("Palavra-passe não pode ficar em branco.");
			Password.focus();
			return false;
		}

		if (!isValidAscii(Password.value))
		{
			alert("Palavra-passe inválida.");
			Password.focus();
			return false;
		}
	}
	else if(Language == "japanese")
	{
		if (appName == "Microsoft Internet Explorer")
		{
			var versionNumber = version.split(" ")[3];
			if (parseInt(versionNumber.split(";")[0]) < 6)
			{
				alert("6.0以前のIEバージョンには対応していません。");
				return false;
			}
		}

		if (Username.value == "") {
			alert("アカウントは必須項目です。");
			Username.focus();
			return false;
		}

		if (!isValidAscii(Username.value))
		{
			alert("アカウントは無効です。");
			Username.focus();
			return false;
		}

		if (Password.value == "") {
			alert("パスワードは必須項目です。");
			Password.focus();
			return false;
		}

		if (!isValidAscii(Password.value))
		{
			alert("パスワードは無効です。");
			Password.focus();
			return false;
		}
	}
	else if(Language == "spanish")
	{
		if (appName == "Microsoft Internet Explorer")
		{
			var versionNumber = version.split(" ")[3];
			if (parseInt(versionNumber.split(";")[0]) < 6)
			{
				alert("No se puede soportar la versión de IE inferior a la 6.0.");
				return false;
			}
		}

		if (Username.value == "") {
			alert("La usuario es un campo obligatorio.");
			Username.focus();
			return false;
		}

		if (!isValidAscii(Username.value))
		{
			alert("La usuario es invalida.");
			Username.focus();
			return false;
		}

		if (Password.value == "")
		{
			alert("La contraseña es un campo requerido.");
			Password.focus();
			return false;
		}

		if (!isValidAscii(Password.value))
		{
			alert("La contraseña es invalida.");
			Password.focus();
			return false;
		}
	}
	else
	{
		if (appName == "Microsoft Internet Explorer")
		{
			var versionNumber = version.split(" ")[3];
			if (parseInt(versionNumber.split(";")[0]) < 6)
			{
				alert("We cannot support the IE version which is lower than 6.0.");
				return false;
			}
		}

		if (Username.value == "") {
			alert("Account is a required field.");
			Username.focus();
			return false;
		}

		if (!isValidAscii(Username.value))
		{
			alert("Account is invalid.");
			Username.focus();
			return false;
		}

		if (Password.value == "") {
			alert("Password is a required field.");
			Password.focus();
			return false;
		}

		if (!isValidAscii(Password.value))
		{
			alert("Password is invalid.");
			Password.focus();
			return false;
		}

	}

	/*让浏览器中已存在的COOKIE立即失效*/
	var cookie = document.cookie;
	if ("" != cookie)
	{
		var date=new Date();
		date.setTime(date.getTime()-10000);
		var cookie22 = cookie + ";expires=" + date.toGMTString();
		document.cookie=cookie22;
	}

	var cnt;

	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : '/asp/GetRandCount.asp',
		success : function(data) {
			cnt = data;
		}
		});

	var Form = new webSubmitForm();
	if('DT' == CfgMode.toUpperCase())
	{
		var cookie2 = "Cookie=" + "rid=" + RndSecurityFormat("" + cnt) + RndSecurityFormat(Username.value + cnt ) + RndSecurityFormat(RndSecurityFormat(MD5(Password.value)) + cnt) + ":" + "Language:" + Language + ":" +"id=-1;path=/";
	}
	else
	{
		var cookie2 = "Cookie=" + "UserName:" + Username.value + ":" + "PassWord:" + base64encode(Password.value) + ":" + "Language:" + Language + ":" + "id=-1;path=/";
	}
	document.cookie = cookie2;

	Username.disabled = true;
	Password.disabled = true;

	if('TRIPLET' == CfgMode.toUpperCase())
	{
		Form.addParameter('CheckCode', getValue('VerificationCode'));
		Form.setAction('login.cgi?' +'&CheckCodeErrFile=login.asp');
	}
	else
	{
		Form.setAction('/login.cgi');
	}
	Form.addParameter('x.X_HW_Token', cnt);
	Form.submit();
	return true;
}

function LoadFrame() {

	if ( 'TRIPLET' == CfgMode.toUpperCase())
	{
		document.getElementById('tablecheckcode').style.display = '';
		document.getElementById('txtVerificationCode').style.display = '';
		document.getElementById("imgcode").src = 'getCheckCode.cgi?&rand=' + new Date().getTime();
	}
	else
	{
		document.getElementById('Copyrightfooter').style.display = '';
		document.getElementById('button').style.display = '';
		document.getElementById('regdevice').style.display = '';
	}
	document.getElementById('txt_Username').focus();
	clearInterval(locklefttimerhandle);

	var UserLeveladmin = '<%HW_WEB_CheckUserInfo();%>';

    if (Language == "chinese") {
        document.getElementById('Chinese').style.color = '#9b0000';
        document.getElementById('English').style.color = '#434343';
	document.getElementById('account').innerHTML = '用户名';
	document.getElementById('Password').innerHTML = '密  码';
	document.getElementById('button').innerHTML = '登录';
	document.getElementById('regdevice').innerHTML = '设备注册';
	document.getElementById('footer').innerHTML = '版权所有 © 华为技术有限公司 2009-2017。保留一切权利。';
	
	//document.getElementById('regdevice').style.display = '';
	//document.getElementById('divChooseArea').style.display = '';
    } else {
        document.getElementById('Chinese').style.color = '#434343';
        document.getElementById('English').style.color = '#9b0000';
		document.getElementById('account').innerHTML = 'Account';
		document.getElementById('Password').innerHTML = 'Password';
		document.getElementById('button').innerHTML = 'Login';
		document.getElementById('regdevice').innerHTML = 'Register';
		document.getElementById('footer').innerHTML = 'Copyright © Huawei Technologies Co., Ltd. 2009-2017. All rights reserved';
		
		//document.getElementById('regdevice').style.display = 'none';
		//document.getElementById('divChooseArea').style.display = 'none';
    }

	if ((LoginTimes != null) && (LoginTimes != '') && (LoginTimes > 0)) {
		document.getElementById('loginfail').style.display = '';
		setErrorStatus();
	}
	if( "1" == FailStat || (ModeCheckTimes >= errloginlockNum))
	{
		document.getElementById('loginfail').style.display = '';
		setErrorStatus();
	}
	init();

	if((UserLeveladmin == '0'))
	{
		if (Language == "chinese") 
		{
		alert("当前用户不允许登录。");
			return false;
		}
		else
		{
			alert("The current user is not allowed to log in.");
			return false;
		}
	}

	if (ProductName.toUpperCase() == "MA5671")
	{
	    document.getElementById('divChooseArea').style.display = 'none';
	    document.getElementById('regdevice').style.display = 'none'
	}

	document.getElementById('ChooseInfo').innerHTML = CfgFtChineseArea;
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
function onChangeLanguage(language) {
	Language = language;
    if (Language == "chinese") {
        document.getElementById('Chinese').style.color = '#9b0000';
        document.getElementById('English').style.color = '#434343';
	document.getElementById('account').innerHTML = '用户名';
	document.getElementById('Password').innerHTML = '密  码';
	document.getElementById('button').innerHTML = '登录';
	document.getElementById('regdevice').innerHTML = '设备注册';
	document.getElementById('footer').innerHTML = '版权所有 © 华为技术有限公司 2009-2017。保留一切权利。';
	
	//document.getElementById('regdevice').style.display = '';
	//document.getElementById('divChooseArea').style.display = '';

    } else {
        document.getElementById('Chinese').style.color = '#434343';
        document.getElementById('English').style.color = '#9b0000';
		document.getElementById('account').innerHTML = 'Account';
		document.getElementById('Password').innerHTML = 'Password';
		document.getElementById('button').innerHTML = 'Login';
		document.getElementById('regdevice').innerHTML = 'Register';
		document.getElementById('footer').innerHTML = 'Copyright © Huawei Technologies Co., Ltd. 2009-2017. All rights reserved';
		
		//document.getElementById('regdevice').style.display = 'none';
		//document.getElementById('divChooseArea').style.display = 'none';
    }

	if (((LoginTimes != null) && (LoginTimes != '') && (LoginTimes > 0))
	   ||( "1" == FailStat) || (ModeCheckTimes >= errloginlockNum) )
	{
		document.getElementById('loginfail').style.display = '';
		setErrorStatus();
	}
}

//function stResultInfo(domain, Result, Status)
//{
//	this.domain = domain;
//	this.Result = Result;
//	this.Status = Status;
//}
//
//var stResultInfos = new stResultInfo("0", "0", "0");
//
//function getRegStatus()
//{
//	$.ajax({
//			type : "POST",
//			async : false,
//			cache : false,
//			url : "asp/GetRegStatusInfo.asp",
//			success : function(data) {
//				stResultInfos = eval(data);
//				
//			}
//		});
//}

function JumpToReg()
{
//  getRegStatus();
//  var Infos = stResultInfos[0];
//  if ((((parseInt(Infos.Status) == 0) && (parseInt(Infos.Result) == 1)) ) )
//  {
//	 window.location="/loidgregsuccess.asp";	
//  }
//  else
//  {
     window.location="/loidreg.asp";
//  }	
}

function BthRefresh()
{
	document.getElementById("imgcode").src = 'getCheckCode.cgi?&rand=' + new Date().getTime();
}
</script>
</head>
<body onLoad="LoadFrame();">
<div id="main_wrapper">
<div id="divChooseArea" style="position:absolute; top:30px;margin-left:250px;height:100px; width:490px;">
<table  border="0" cellpadding="0" cellspacing="0" width="100%">
	<td width="100%" style="height:100px">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<td width="70%" style="height:10px"><td width="30%" style="height:10px">
			<span id="ChooseInfo" style="margin-left:45px;font-weight:bolder;font-size:18px;font-family:Arial;color:red;text-align:center;"></span>
			</td>
		</table>
	</td>
</table>
</div>
<div style="position:absolute; top:300px;margin-left:250px;height:300px; width:490px;background: url('images/pic.jpg') no-repeat center;">
<table id="tablecheckcode" border="0" cellpadding="0" cellspacing="0" width="100%" style="display: none">
	<tr>
	<td height="8"></td>
	</tr>
	<tr>
		<td>
			<img id="imgcode" style="margin-left:111px;height:30px;width:100px;" onClick="BthRefresh();">
			<input type="button" id="changecode" style="margin-left:20px;width:58px;" class="submit" value="Refresh" onClick="BthRefresh();"/>
		</td>
	</tr>

	<tr>
		<td height="8"></td>
	</tr>
	<tr align="center">
	<td>
	 <button style="font-size:12px;font-family:Tahoma,Arial;margin-left:-70px;" id="tripletbtn" class="submit" name="tripletbtn" onClick="SubmitForm();" type="button">Login</button>
	</td>
  </tr>
	  <tr>
	  <td class="info_text" height="25" id="tipletfooter"><span style="margin-left:-55px;">Copyright © Huawei Technologies Co., Ltd 2009-2017. All rights reserved.</span></td>
	</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr id="Copyrightfooter" style="position:absolute; margin-left:20px;top:-25px;display: none;color:#9d9d9d;">
	<td height="25" id="footer" style="font-size:11px;"></td>
	</tr>
	<tr>
	<td valign="top" style="padding-top: 20px;"> <div id="loginfail" style="display: none">
		<table border="0" cellpadding="0" cellspacing="5" height="33" width="99%">
		  <tr>
			<td align="center" bgcolor="#FFFFFF" height="21"> <span style="color:red;font-size:12px;font-family:Arial;">
			  <div id="DivErrPage"></div>
			  </span> </td>
		  </tr>
		</table>
	  </div>
	  </td>
  </tr>
</table>
</div>
  <table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<script language="JavaScript" type="text/javascript">
							if ( 'TRIPLET' == CfgMode.toUpperCase())
							{
								document.write('<td align="center" height="210" valign="bottom"> <table border="0" cellpadding="0" cellspacing="0" width="44%"> ');
							}
							else
							{
								document.write('<td align="center" height="210" valign="bottom"> <table border="0" cellpadding="0" cellspacing="0" width="50%"> ');
							}
			</script>
		  <tr>
			<td align="right" width="25%">

				<script language="JavaScript" type="text/javascript">
							if ( 'TRIPLET' == CfgMode.toUpperCase())
							{
								document.write('<img height="70" src="images/logo3bb.gif" width="144" alt="">');
							}
							else if ('ORANGEMT' == CfgMode.toUpperCase())
							{
								document.write('<img height="118" src="images/logo_MA.gif" width="118" alt="">');
							}
							else if('NOS' == CfgMode.toUpperCase())
							{
								document.write('<img height="72" src="images/logo_nos.gif" width="136" alt="">');
							}
							else if('ANTEL' == CfgMode.toUpperCase())
							{
								document.write('<img height="36" src="images/logo_antel.gif" width="100" alt="">');
							}
							else if ('SONET' == CfgMode.toUpperCase() || 'SONETHG8040H' == CfgMode.toUpperCase() || 'JAPAN8045D' == CfgMode.toUpperCase())
							{
								document.write('<img height="0" src="images/logo.gif" width="0" alt="">');
							}
							else
							{
								document.write('<img height="75" src="images/logo.gif" width="70" alt="">');
							}
							</script>
				</td>
			<td align="left" class="hg_logo" width="50%" id="hg_logo" nowrap> <script language="JavaScript" type="text/javascript">
							document.write(ProductName);
						</script> </td>
			<td align="left" valign="bottom" width="25%"> <table border="0" cellpadding="0" cellspacing="0" class="text_copyright" width="100%">
				<tr>
							<td width="47%">
								<a id="English" href="#" name="English" onClick="onChangeLanguage('english');" title="English" style="font-size:12px;font-family:Arial;">[English]</a>
							</td>
							<td width="53%">
								<a id="Chinese" href="#" name="Chinese" onClick="onChangeLanguage('chinese');" title="Chinese" style="font-size:12px;font-family:Arial;">[中文]</a>
							</td>
				</tr>
			  </table></td>
		  </tr>
		</table></td>
	</tr>
	<tr>
	  <td align="center" height="65"> <table border="0" cellpadding="0" cellspacing="0" class="tblcalss" height="65" width="55%" style="margin-left:60px;">
		  <tr>
			<td class="whitebold" height="37" align="right" width="20%" id="account"></td>
			<td class="whitebold" height="37" align="center" width="2%">:</td>
			<td width="78%"> <input style="font-size:12px;font-family:Tahoma,Arial;" id="txt_Username" class="input_login" name="txt_Username" type="text" maxlength="31"> </td>
		  </tr>
		  <tr>
			<td class="whitebold" height="28" align="right" id="Password"></td>
			<td class="whitebold" height="28" align="center" >:</td>
			<td> <input style="font-size:12px;font-family:Tahoma,Arial;" id="txt_Password" class="input_login" name="txt_Password" type="password" maxlength="127">
&nbsp;
			<button style="font-size:12px;font-family:Tahoma,Arial;display: none;" id="button" class="submit" name="Submit" onClick="SubmitForm();" type="button"></button>
			<button style="font-size:12px;font-family:Tahoma,Arial;display: none;" id="regdevice" class="submit" name="regdevice" onClick="JumpToReg();" type="button"/>
			</td>
		  </tr>

		  <tr id="txtVerificationCode" style="display: none">
			<td class="whitebold" height="28" align="right" id="Validate">Verification code</td>
			<td class="whitebold" height="32" align="center" >:</td>
			<td>
			<input style="font-size:12px;font-family:Tahoma,Arial;height:21px;" id="VerificationCode" class="input_login" name="VerificationCode" type="text" maxlength="127"></td>
		  </tr>

		</table></td>
	</tr>
  </table>
</div>
</body>
</html>
