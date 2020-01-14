<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="expires" content="Fri, 12 Jan 2001 18:18:18 GMT">
<link href="../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" rel="stylesheet" type="text/css" />
<link href="Cuscss/<%HW_WEB_CleanCache_Resource(frame.css);%>" rel="stylesheet" type="text/css" />
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<script src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" type="text/javascript">
function GetLanguageDesc(Name)
{
    return Tr069LgeDes[Name];
}

function stCWMP(domain,AcsEnb,InformEnb)
{
    this.domain = domain;
    this.AcsEnb = AcsEnb;
    this.URL = "";
    this.Username = "";
    this.Password = "";
	this.InformEnb = InformEnb;
	this.Interval = "";
    this.CntReqName = "";
    this.CntReqPwd = "";
    this.CntReqURL  = "";
	this.X_HW_Path  = "";
	this.X_HW_Port  = "";
}

function stManageFlag(ManageFlag)
{
    this.ManageFlag = ManageFlag;
}
 
var setpasswordflag = 0;
var stCWMPs = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.ManagementServer,EnableCWMP|PeriodicInformEnable,stCWMP);%>;

var cwmp = stCWMPs[0];


function setACSStatus()
{
	if (0 == getCheckVal("EnableACS"))
  {
    document.getElementById("URL").disabled = true;
    document.getElementById("Username").disabled = true;
    document.getElementById("Password").disabled = true;
    document.getElementById("ConnectionRequestUsername").disabled = true;
    document.getElementById("ConnectionRequestPassword").disabled = true;
    document.getElementById("Path").disabled = true;
    document.getElementById("Port").disabled = true;
    document.getElementById("PeriodicInformInterval").disabled = true;
	document.getElementById("PeriodicInformForbid").disabled = true;
	document.getElementById("PeriodicInformEnableEx").disabled = true;
	
  }
  else
  {
    document.getElementById("ACSbtnApply").disabled = false;
    document.getElementById("ACScancelValue").disabled = false;
    document.getElementById("URL").disabled = false;
    document.getElementById("Username").disabled = false;
    document.getElementById("Password").disabled = false;
    document.getElementById("ConnectionRequestUsername").disabled = false;
    document.getElementById("ConnectionRequestPassword").disabled = false;
    document.getElementById("Path").disabled = false;
    document.getElementById("Port").disabled = false;
	if('Enable' == getRadioVal('PeriodicInformEnable'))
    {
		document.getElementById("PeriodicInformInterval").disabled = false;
    }
    else
    {
        document.getElementById("PeriodicInformInterval").disabled = true;
    }
	document.getElementById("PeriodicInformForbid").disabled = false;
	document.getElementById("PeriodicInformEnableEx").disabled = false;
  }
	
}

function stCntReqURL(host,port,path)
{
	this.host = host;
	this.port = port;
	this.path = path;
}
var CntReqURLInfo = new stCntReqURL("", "", "");
function GetCntReqURLInfo(inputUrl)
{
  	if("" != inputUrl)
	{
		if(inputUrl.indexOf('http://')!=-1)
		{
			inputUrl=inputUrl.substring(7);
		}
		var CutUrl=inputUrl.split('/');
		var Domine=CutUrl[0];
		var path="";
		if (CutUrl.length>1)
		{
			path=CutUrl[1];
		}
		var ports=Domine.split(':');
		var port="";
		var len=ports.length;
		if(ports.length>1)
		{
			port=parseInt(ports[len-1],10);
			Domine=Domine.substring(0,(Domine.length)-1-ports[len-1].length);
		}
		
		CntReqURLInfo.host = Domine;
		CntReqURLInfo.port = port;
		CntReqURLInfo.path = path;
		AlertEx("Domine="+Domine+" port="+port+"path="+path);
	}
}

function LoadFrame()
{

	if ( null != cwmp )
	{
		setCheck('EnableACS',cwmp.AcsEnb);
		setText('URL',cwmp.URL);
		setText('Username',cwmp.Username);
		setText('Password',cwmp.Password);
		setText('PeriodicInformInterval',cwmp.Interval);
		setText('ConnectionRequestUsername',cwmp.CntReqName);
		setText('ConnectionRequestPassword',cwmp.CntReqPwd);
		if ('1' == cwmp.InformEnb)
		{
			setRadio('PeriodicInformEnable','Enable');
		}
		else
		{
			setRadio('PeriodicInformEnable','Forbid');
		}
		
		GetCntReqURLInfo(cwmp.CntReqURL);
		setText('Path',cwmp.X_HW_Path);
		setText('Port',cwmp.X_HW_Port);
		setACSStatus();
	}
}

function isSafeCharSN(val)
{
    if ( ( val == '<' )
      || ( val == '>' )
      || ( val == '\'' )
      || ( val == '\"' )
      || ( val == ' ' )
      || ( val == '%' )
      || ( val == '#' )
      || ( val == '{' )
      || ( val == '}' )
      || ( val == '\\' )
      || ( val == '|' )
      || ( val == '^' )
      || ( val == '[' )
      || ( val == ']' ) )
	{
	    return false;
	}
	
    return true;
}

function isSafeStringSN(val)
{
    if ( val == "" )
    {
        return false;
    }

    for ( var j = 0 ; j < val.length ; j++ )
    {
        if ( !isSafeCharSN(val.charAt(j)) )
        {
            return false;
        }
    }

    return true;
}


function isNum(str)
{
    var valid=/[0-9]/;
    var i;
    for(i=0; i<str.length; i++)
    {
        if(false == valid.test(str.charAt(i)))
        {
        	return false;
        }
    }
    return true;
}

function isNull( str )
{
    if ( str == "" ) return true;
    var regu = "^[ ]+$";
    var re = new RegExp(regu);
    return re.test(str);
}

function checkUrlPort(urlinfo)
{
    var url_values = urlinfo.split("://");

	if (url_values.length <= 1) 
	{
		var port_value = urlinfo.split(":");

		if (port_value.length <= 1)
		{
			return true;
		}
	    else
		{
			var othervalue = port_value[port_value.length-1].split("/");
			
			if (othervalue.length == 0)
		    {
				return true;
			}

			if(true == isNull(othervalue[0]))
			{
				return false;
			}
			
			if(false == isNum(othervalue[0]))
			{
				return false;
			}
			
			var port = parseInt(othervalue[0], 10);
	    	if ((port >= 65536) || ( port < 1))
			{
				return false;
			}
			return true;
		}
	}
    else
    {
		var port_value = url_values[url_values.length-1].split(":");
		if (port_value.length <= 1)
		{
			return true;
		}

		var othervalue = port_value[port_value.length-1].split("/");
		if (othervalue.length == 0)
		{
			return true;
		}
		
		if(true == isNull(othervalue[0]))
		{
			return false;
		}
			
		if(false == isNum(othervalue[0]))
		{
			return false;
		}
		
		var port = parseInt(othervalue[0], 10);
		if ((port >= 65536) || ( port < 1))
		{
			return false;
		}
    }
    
    return true;
}


function CheckForm(type)
{ 
  
	if(0 == getCheckVal("EnableACS"))
	{
		return true;
	} 
	with(document.getElementById("ConfigForm"))
    {
        if (URL.value == '')
        {
            AlertEx(GetLanguageDesc("s0d01"));
            URL.focus();
            return false;
        }
        
        if (!isSafeStringSN(URL.value))
        {
            AlertEx(GetLanguageDesc("s0d02"));
            URL.focus();
            return false;
        }
        
		if (!checkUrlPort(URL.value))
        {
        	AlertEx(GetLanguageDesc("s0d2d"));
            URL.focus();
            return false;
        }
        
        if ('' != isValidAscii(URL.value))
        {
			AlertEx(GetLanguageDesc("s0d2e"));
            URL.focus();
            return false;
		}
		
        if (getRadioVal("PeriodicInformEnable") == 'Enable')
        {
            if ((PeriodicInformInterval.value == '') || (isPlusInteger(PeriodicInformInterval.value) == false))
            {
                AlertEx(GetLanguageDesc("s0d03"));
                PeriodicInformInterval.focus();
                return false;
            }
            
            var info = parseInt(PeriodicInformInterval.value,10);
            if (info < 1 || info > 2147483647)
            {
                AlertEx(GetLanguageDesc("s0d03"));
                PeriodicInformInterval.focus();
                return false;
            }
        }       
        
        if (Username.value == '')
        {
            AlertEx(GetLanguageDesc("s0d05"));
            Username.focus();
            return false;
        }
        if (isValidString(Username.value) == false )
        {
            AlertEx(GetLanguageDesc("s0d06"));
            Username.focus();
            return false;
        }
        
        if (Password.value == '')
        {
            AlertEx(GetLanguageDesc("s0d07"));
            Password.focus();
            return false;
        }       
		
        if (isValidString(Password.value) == false )
        {
            AlertEx(GetLanguageDesc("s0d08"));
            Password.focus();
            return false;
        }
        
        if (ConnectionRequestUsername.value == '')
        {
            AlertEx(GetLanguageDesc("s0d09"));
            ConnectionRequestUsername.focus();
            return false;
        }
        if (isValidString(ConnectionRequestUsername.value) == false )
        {
            AlertEx(GetLanguageDesc("s0d0a"));
            ConnectionRequestUsername.focus();
            return false;
        }
        
        if ('' == ConnectionRequestPassword.value)
        {
            AlertEx(GetLanguageDesc("s0d0b"));
            ConnectionRequestPassword.focus();
            return false;
        }
        
        if (isValidString(ConnectionRequestPassword.value) == false )
        {
            AlertEx(GetLanguageDesc("s0d0c"));
            ConnectionRequestPassword.focus();
            return false;
        }
		
		if (("" != Path.value)&&(isValidAscii(Path.value) != ''))         
		{  
			AlertEx(GetLanguageDesc("s1716") + GetLanguageDesc("s1717") + isValidAscii(Path.value) + '".');          
			return false;       
		}
		 
        if ("" != Port.value)
		{
			if (Port.value.charAt(0) == '0')
			{
				AlertEx(GetLanguageDesc("s1719"));
				return false; 
			}	
			if(isValidPort(Port.value) == false)
			{			
				AlertEx(GetLanguageDesc("s1718"));
				return false;
			}
        }
	}
    
    return true;
}

function ChangePeriodicInformEnable()
{
	var itemPeriodicInformEnable = getRadioVal('PeriodicInformEnable');
	var itemPeriodicInformInterval = document.getElementById("ConfigForm").PeriodicInformInterval;
    
    if ('Enable' == itemPeriodicInformEnable) {
        itemPeriodicInformInterval.disabled = false;
    } else {
        itemPeriodicInformInterval.disabled = true;
    }
}

function AddSubmitParam(SubmitForm,type)
{
	if(0 == getCheckVal("EnableACS"))
	{
		SubmitForm.addParameter('x.EnableCWMP',getCheckVal('EnableACS'));
		SubmitForm.setAction('3bbset.cgi?x=InternetGatewayDevice.ManagementServer'
                         + '&RequestFile=tripacs.asp');
    setDisable('ACSbtnApply',1);
    setDisable('ACScancelValue',1);
    return;
	}
	
    SubmitForm.addParameter('x.EnableCWMP',getCheckVal('EnableACS'));
	SubmitForm.addParameter('x.URL',getValue('URL'));
	SubmitForm.addParameter('x.Username',getValue('Username'));
	SubmitForm.addParameter('x.Password',getValue('Password'));
	
    if (getRadioVal('PeriodicInformEnable') == 'Enable')
    {
		SubmitForm.addParameter('x.PeriodicInformEnable','1');
        SubmitForm.addParameter('x.PeriodicInformInterval',parseInt(getValue('PeriodicInformInterval'),10));
    }
	else
	{
		SubmitForm.addParameter('x.PeriodicInformEnable','0');
	}
    
    SubmitForm.addParameter('x.ConnectionRequestUsername',getValue('ConnectionRequestUsername'));

	SubmitForm.addParameter('x.ConnectionRequestPassword',getValue('ConnectionRequestPassword'));   	

	if (getValue('Path')!="")
	{	
		SubmitForm.addParameter('x.X_HW_Path', getValue('Path'));
	}
	
	if (getValue('Port')!="")
	{
		SubmitForm.addParameter('x.X_HW_Port', getValue('Port'));
	}
	
    SubmitForm.setAction('3bbset.cgi?x=InternetGatewayDevice.ManagementServer'
                         + '&RequestFile=tripacs.asp');
    setDisable('ACSbtnApply',1);
    setDisable('ACScancelValue',1);

}

function CancelConfig()
{
	LoadFrame();
}

function CheckFormPassword(type)
{	
	with(document.getElementById("ConfigForm"))
    {
        if(certPassword.value.length > 32)
        {
            AlertEx(GetLanguageDesc("s0d0e"));
            setText('certPassword', '');
	        setText("CfmPassword", "");
            return false;
        }
        
        if(certPassword.value != CfmPassword.value)
        {
            AlertEx(GetLanguageDesc("s0d0f"));
			setText("certPassword", "");
			setText("CfmPassword", "");
			return false;
        }
		
		if (certPassword.value != '')
		{
		    setpasswordflag = 1;
		}
    }
    return true;
}

var refreshData = 1;

function requestCgi()
{
	  $.ajax({
			type : "POST",
			async : true,
			cache : false,
			url : "../html/ssmp/common/refreshTime.asp",
			success : function(data) {
				refreshData = data;
			}
		});

		if (1 != refreshData)
		{
			clearInterval(TimerHandle );
			window.location.replace("login.asp");
		}	
}

var TimerHandle  = setInterval("requestCgi()", 5000);




function OnEnableACSClick()
{
  setACSStatus();

}


</script>

<style type="text/css">
.table_title_taiguo {
	padding-left: 5px;
	height: 24px;
	line-height: 24px;
	font-weight: bold;
}
.table_right_taiguo {
	padding-left: 5px;
	height: 24px;
	line-height: 24px;
}
</style>
</head>
<body  class="mainbody"  style="background-color:#EEEEEE;" onLoad="LoadFrame();"> 
<form id="ConfigForm" > 

  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_head"> 
    <tr> 
      <td  width="100%"  align="left" > <font size="+1" face="Arial"><strong style=" color:#0000FF"><script>document.write(GetLanguageDesc("s1700"));</script></strong></td> 
    </tr> 
  </table> 
<br>
<br> 
<table width="100%" border="0" cellspacing="0" cellpadding="0"> 
    <tr> 
      <td>
	  <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
          <tr> 
            <td width="100%"> <font face="Arial" ><script>document.write(GetLanguageDesc("s1701"));</script></font> </td> 
          </tr> 
        </table></td> 
    </tr> 
</table> 

<table width="50%" border="0" cellspacing="0" cellpadding="0"> 
<tr> 
<td><hr style="border-bottom; color:#666666;" size="1"></hr>
</td> 
</tr> 
</table> 

  <table width="100%" border="0" cellpadding="0" cellspacing="1"> 
      <tr align="left"> 
      <td class="table_title_taiguo" width="13%" align="left" BindText="s1702"></td> 
      <td width="87%" colspan="8" align="left" class="table_right_taiguo"></td> 
    </tr> 
	
    <tr align="left"> 
      <td class="table_title_taiguo" width="13%" align="left" BindText="s1703"></td> 
      <td class="table_right_taiguo" colspan="8" align="left"> <input  id='EnableACS' name='EnableACS'  value='1' type='checkbox' onclick="OnEnableACSClick();"> </td> 
    </tr> 
    <tr> 
	
    <tr> 
      <td  class="table_title_taiguo" align="left" BindText="s1704">URL:</td> 
      <td class="table_right_taiguo" colspan="8"> <input name='URL' type='text' id="URL" size="20" maxlength="256"> 
        <strong style="color:#FF0033">*</strong> </td> 
    </tr> 
	
	    <tr> 
      <td  class="table_title_taiguo" align="left" BindText="s1705"></td> 
      <td class="table_right_taiguo" colspan="8"> <input name='Username' type='text' id="Username" size="20" maxlength="256"> 
        <strong style="color:#FF0033">*</strong> </td> 
    </tr> 
    <tr> 
      <td  class="table_title_taiguo" align="left" BindText="s1706"></td> 
      <td class="table_right_taiguo" colspan="8" align="left"> <input name='Password' type='password' id="Password" size="20" maxlength="256">
	  <script language="javascript">
		document.write('<strong class="color_red">*</strong>');
		document.write('<span class="gray">' + GetLanguageDesc("s0d1d") + '</span>');
		</script> 
	  </td> 
    </tr> 
  </table> 
	
<table width="100%" border="0" cellpadding="0" cellspacing="1"> 
	<tr > 
	<td width="13%" align="left" class="table_title_taiguo" BindText="s1707"></td> 
	<td width="10%"  class="table_right_taiguo"  > <input disabled="true" name="PeriodicInformEnable" id="PeriodicInformForbid" type="radio" onClick="ChangePeriodicInformEnable();" value="Forbid">Disable</td>
	<td width="77%"  class="table_right_taiguo" > <input disabled="true" name="PeriodicInformEnable" id="PeriodicInformEnableEx" type="radio" onClick="ChangePeriodicInformEnable();" value="Enable">Enable </td>
	</tr> 
</table> 
  
  <table width="100%" border="0" cellpadding="0" cellspacing="1"> 
	<tr> 
	<td width="13%" align="left" class="table_title_taiguo" BindText="s1708"></td> 
      <td width="87%" class="table_right_taiguo" colspan="8"> <input name='PeriodicInformInterval' id="PeriodicInformInterval" type='text' size="20" maxlength="10">
	  <strong class="color_red">*</strong><span class="gray">[1 - 2147483647](s)</span></td> 
	</tr> 
</table> 

<table width="50%" border="0" cellspacing="0" cellpadding="0"> 
<tr> 
<td><hr style="border-bottom; color:#666666;" size="2"></hr>
</td> 
</tr> 
</table> 

 <table width="100%" border="0" cellpadding="0" cellspacing="1"> 
    <tr> 
      <td width="20%" align="left"  class="table_title_taiguo" BindText="s1709"></td> 
      <td width="80%" colspan="8" class="table_right_taiguo"></td> 
    </tr> 
 </table>
 
    <table width="100%" border="0" cellpadding="0" cellspacing="1"> 
	 <tr> 
      <td  width="13%" class="table_title_taiguo" align="left" BindText="s1710"></td> 
      <td width="87%" class="table_right_taiguo" colspan="8"> <input name='ConnectionRequestUsername' type='text' id="ConnectionRequestUsername" size="20" maxlength="256">
	  <strong class="color_red">*</strong>
	  </td> 
    </tr> 
    <tr> 
      <td  class="table_title_taiguo" align="left" BindText="s1711"></td> 
      <td class="table_right_taiguo" colspan="8"> <input name='ConnectionRequestPassword' type='password' id="ConnectionRequestPassword" size="20"  maxlength="256">
	  <script language="javascript">
		document.write('<strong class="color_red">*</strong>');
		document.write('<span class="gray">' + GetLanguageDesc("s0d1d") + '</span>');
		</script>
	  </td> 
    </tr> 
	
	    <tr> 
      <td  class="table_title_taiguo" align="left" BindText="s1712"></td> 
      <td class="table_right_taiguo" colspan="8"> <input name='Path' type='text' id="Path" size="20" maxlength="256"> </td> 
    </tr> 
    <tr> 
      <td  class="table_title_taiguo" align="left" BindText="s1713"></td> 
      <td class="table_right_taiguo"> <input name='Port' type='text' id="Port" size="20"  maxlength="6"></td> 
    </tr> 
  </table> 

<table width="50%" border="0" cellspacing="0" cellpadding="0"> 
<tr> 
<td><hr style="border-bottom; color:#666666;" size="2"></hr>
</td> 
</tr> 
</table> 
  <table width="100%" border="0" cellspacing="1" cellpadding="0">  
      <td  class="table_title_taiguo" width="13%"></td> 
      <td width="87%" align="left"  class="table_title_taiguo"> <input  class="submit" name="btnApply" id= "ACSbtnApply" type="button" BindText="s1714" onClick="Submit();"> 
        <input class="submit" name="cancelValue" id="ACScancelValue" type="button" BindText="s1715" onClick="CancelConfig();"> </td> 
    </tr>
 </table> 
 <br>

  <table width="100%" height="18" border="0" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td></td> 
    </tr> 
  </table> 
  
</form> 
<script>
var all = document.getElementsByTagName("td");
for (var i = 0; i < all.length; i++)
{
    var b = all[i];
	var c = b.getAttribute("BindText");
	if(c == null)
	{
		continue;
	}
    b.innerHTML = Tr069LgeDes[c];
}

var all = document.getElementsByTagName("input");
for (var i = 0; i < all.length; i++)
{
    var b = all[i];
	var c = b.getAttribute("BindText");
	if(c == null)
	{
		continue;
	}
    b.value = Tr069LgeDes[c];
}
</script>

</body>
</html>
