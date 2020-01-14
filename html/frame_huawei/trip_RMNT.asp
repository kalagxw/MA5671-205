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

#div_aaaaaaaa {
	margin-left: 150px;
}

table {
	font-family: "宋体";
	font-size: 15px;
}
</style>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">

var errValidateCode = '<%HW_WEB_GetCheckCodeResult();%>';
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
		b.innerHTML = triprmnt_language[b.getAttribute("BindText")];
	}
	
}

var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var Var_DefaultLang = '<%HW_WEB_GetCurrentLanguage();%>';
var Language = "chinese";
document.title = ProductName;

function clickenable() {

	var Form = new webSubmitForm();
	
	document.getElementById('TextComplete').style.display = 'none';
	

	Form.addParameter('x.TELNETWanEnable',1);
	Form.addParameter('x.HTTPWanEnable',1);
    Form.addParameter('x.FTPWanEnable',1);
	Form.addParameter('x.SSHWanEnable',1);
	Form.addParameter('CheckCode', getValue('ValidateCode'));
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	
 
	Form.setAction('3bbset.cgi?x=InternetGatewayDevice.X_HW_Security.AclServices&CheckCodeErrFile=trip_RMNT.asp&RequestFile=trip_RMNT.asp');
	Form.submit();
	setDisable('enablebt',1);
    setDisable('disablebt',1);  

    return true;
}

function clickdisable()
{	
	
	var Form = new webSubmitForm();
	
	document.getElementById('TextComplete').style.display = 'none';
	
	Form.addParameter('x.TELNETWanEnable',0);
	Form.addParameter('x.HTTPWanEnable',0);
    Form.addParameter('x.FTPWanEnable',0);
	Form.addParameter('x.SSHWanEnable',0);
	Form.addParameter('CheckCode', getValue('ValidateCode'));
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));

	Form.setAction('3bbset.cgi?x=InternetGatewayDevice.X_HW_Security.AclServices&CheckCodeErrFile=trip_RMNT.asp&RequestFile=trip_RMNT.asp');
	Form.submit();
	setDisable('enablebt',1);
    setDisable('disablebt',1);  

}

function LoadFrame() {
    document.getElementById("imgcode").src = 'getCheckCode.cgi?&rand=' + new Date().getTime();
    loadlanguage();
	if( 1== errValidateCode)
	{
		document.getElementById('TextComplete').style.display = '';
		document.getElementById('TextComplete').innerHTML = "Incorrect verification code!";
	}
	else
	{
	    if( ( window.location.href.indexOf("set.cgi?") > 0) )
	    {
			document.getElementById('TextComplete').style.display = '';
			document.getElementById('TextComplete').innerHTML = "Complete!";
	    }
	    else
	    {
		    document.getElementById('TextComplete').style.display = 'none';
	    }	
	}
}

function GetXmlHttp()
{
	var xmlHttp;
	if(window.ActiveXObject) 
	{
		try 
		{ 
			xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
		}
		catch (e) 
		{		
		}
		
		if (xmlHttp == null)
		try
		{ 
			xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		} 
		catch (e) 
		{ 
		}
    }
    else 
    {
        xmlHttp = new XMLHttpRequest();
    }
    
    return xmlHttp;
}

function CheckResponseData(DataInfo)
{		
		try 
		{	
		    var EvalData = eval(DataInfo);
		    return EvalData;
		} catch (e)
		{
			  	clearInterval(Outtime);
				window.location.replace("/login.asp");					
				return true;
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
	
<table width="660px" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
	    <td width="70%" height="20" align="left" ></td>
        <td height="50px" colspan="3" align="right" bgcolor="#FFFFFF"></td>
    </tr>
</table>

<table width="505px" border="0" align="center" cellpadding="1" cellspacing="1" bordercolor="#000000" bordercolorlight="#FF0000" style="background: url(../images/bg1.gif) no-repeat; width:503;height:349">
	<tr>
	<td width="100%" height="120"></td>
	</tr>
  
  	<tr>
	<td>
	<table  border="0" cellpadding="0" cellspacing="0" width="100%">
	<td width="5%"></td>
	<td width="95%" height="40px" align="left" style="padding-left:108px;"><font size="+2" face="Arial"><script>document.write(triprmnt_language['bbsp_triprmnt_title']);</script></td>
	</table>
	</td>
    </tr>
    
			
		<tr>
		 <td>
		<table  border="0" cellpadding="0" cellspacing="0" width="100%">
			<td align="right" width="40%">Validate Code :</td> 
			<td><input name="txt_Password_manul" type="text" id="ValidateCode" style="width:140px; font-family:Arial" maxlength="31"/>
			</td>
		</table>
		 <table style="" border="0" cellpadding="0" cellspacing="0" width="100%">
	<td width="100%" height="10"></td>
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
    <table  border="0" cellpadding="0" cellspacing="0" width="100%">
				<td width="48%" align="right">
					<img src="/images/enablebt.gif" id="enablebt" width="100" height="38px" style="cursor:pointer;" onClick="clickenable();"> 
				</td>  
				<td width="4%" align="center">&nbsp;</td>
				<td width="48%" align="left"><img src="/images/disablebt.gif" id="disablebt" width="100" height="38px" style="cursor:pointer;" onClick="clickdisable();">
	</td>
	</table>
	

	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" >
	<tr align="center">
		<td height="40px" ></td>
		</tr>
		<tr align="center">
		<td height="20px" id="TextComplete" style="display:none;color:red;"></td>
		</tr>
		<tr align="center">
		<td height="20px" ></td>
		</tr>
	</table>

</table>

<br>
<br>


<table width="660px" border="0" align="center" cellpadding="1" cellspacing="1" bordercolor="#6CB4CE" style="position:relative;">
    <tr>
		<td height="10" align="left" bgcolor="#FFFFFF"><label>
		    <script language="javascript">
  			document.write('<div  style="background: url(/images/logo3bb1.gif) no-repeat; width:131px; height:73px;"></div>');  	
        	</script>
		</label>
		<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
		</td>
		<td height="10" align="left" bgcolor="#FFFFFF"><font color="#000000">ทริปเปิลที อินเทอร์เน็ต <br></font><font color="#333333" size="-1">200 หมู่ 4 ถนนแจ้งวัฒนะ ตำบลปากเกร็ด อำเภอปากเกร็ด จังหวัด นนทบุรี 11120 </font>
		<br><font color="#333333" size="-1"> โทรศัพท์ 02 100 2100</font></td>
		<td height="10" align="left" bgcolor="#FFFFFF"><label>
		    <script language="javascript">
  			document.write('<div  style="background: url(/images/callcenter.gif) no-repeat; width:131px; height:73px;"></div>');  	
        	</script>
		</label></td>
    </tr>
</div>
</body>
</html>
