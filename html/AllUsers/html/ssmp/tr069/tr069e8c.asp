<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" type="text/javascript">
function stCWMP(domain,InformEnb,Interval,Time,URL,Username,Password,CntReqName,CertEnable)
{
    this.domain = domain;
    this.InformEnb = InformEnb;
    this.Interval = Interval;
    this.Time = Time;
    this.URL = URL;
    this.Username = Username;
    this.Password = Password;
    this.CntReqName = CntReqName;
    this.CntReqPwd = '********************************';
    this.CertEnable  = CertEnable ;
}

function stMiddleware(domain,MiddlewareURL,Tr069Enable,Port)
{
    this.domain = domain;
    this.MiddlewareURL = MiddlewareURL;
    this.Tr069Enable = Tr069Enable;
    this.Port = Port;
}

function stManageFlag(ManageFlag)
{
    this.ManageFlag = ManageFlag;
}
 
var UnChangeURL = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_UNCHANGEURL);%>'
var UnChangeUser = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_UNCHANGEUSER);%>'
var UnChangePeriod = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_UNCHANGEPERIOD);%>'
var DisableACSApply = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_DISABLEACSAPPLY);%>'
var UnchangeTimePeriod = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_UNCHANGETIME);%>'

var CfgMode ='<%HW_WEB_GetCfgMode();%>';

var setpasswordflag = 0;

var stCWMPs = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.ManagementServer,PeriodicInformEnable|PeriodicInformInterval|PeriodicInformTime|URL|Username|Password|ConnectionRequestUsername|X_HW_EnableCertificate,stCWMP);%>;


var cwmp = stCWMPs[0];

var Middlewares = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo.X_HW_MiddlewareMgt,MiddlewareURL|Tr069Enable|Port,stMiddleware);%>;
var Middleware = Middlewares[0];
function LoadFrame()
{
	if ( null != cwmp )
	{
	    setCheck('Tr69Inform_checkbox',cwmp.InformEnb);
	    setText('Informinter_text',cwmp.Interval);
	    
	    setText('Acsurl_text',cwmp.URL);
	    setText('AcsUserName_text',cwmp.Username);
	    setText('AcsPassWord_password',cwmp.Password);
	    setText('ConnReqName_text',cwmp.CntReqName);
	    setText('ConnReqPassWord_password',cwmp.CntReqPwd);
	    setCheck('CertificateEnable', cwmp.CertEnable);
		if ('0' == cwmp.InformEnb)
		{
			document.getElementById("Informinter_text").disabled = true;
			
		}
	}
	
	if(  null != Middleware )
	{
		 setSelect("Middleware_select", Middleware.Tr069Enable);
		 setText('MldAddr_text',Middleware.MiddlewareURL);
		 setText('MldPort_text',Middleware.Port);
	}
	
	if (1 == UnChangeURL)
	{
		setDisable('Acsurl_text',1);
	}
	if (1 == UnChangeUser)
	{
		setDisable('AcsUserName_text',1);
		setDisable('AcsPassWord_password',1);
		setDisable('ConnReqName_text',1);
		setDisable('ConnReqPassWord_password',1);
	}
	if (1 == UnChangePeriod)
	{
		setDisable('Tr69Inform_checkbox',1);
		
		setDisable('Informinter_text',1);
	}
	if (1 == DisableACSApply)
	{
		setDisable('Apply_button',1);
		setDisable('Middleware_select',1);
		setDisable('MldAddr_text',1);
		setDisable('MldPort_text',1);
		setDisable('HrefCert_input_button',1);
       
	}

	if (1 == UnchangeTimePeriod)
	{
		setDisable('Informinter_text',1);
	}

	var Mngtscct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SCCT);%>';
	if(Mngtscct == 1)
	{ 
		setDisable('Apply_button',1);
		setDisable('HrefCert_input_button',1);
		setDisable('Informinter_text',1);
		setDisable('Acsurl_text',1);
		setDisable('AcsUserName_text',1);
		setDisable('AcsPassWord_password',1);
		setDisable('ConnReqName_text',1);
		setDisable('ConnReqPassWord_password',1);
		setDisable('Middleware_select',1);
		
		setDisable('MldAddr_text',1);
		setDisable('MldPort_text',1);
		setDisable('Tr69Inform_checkbox',1);		
	}

	
}

function CheckTime(str_date)
{
	var date_reg = new RegExp("^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)$");
	var time_reg = new RegExp("^((0[0-9])|(1[0-9])|(2[0-3])):([0-5][0-9]):([0-5][0-9])$");
	
	date_time = str_date.split("T");
	if (date_time.length != 2)
	{
		return false;
	}

	if ((!date_reg.test(date_time[0])) || (!time_reg.test(date_time[1])))
	{
		return false;
	}

	return true;	
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

//MldPort可以取0
function isValidMldPort(port) 
{ 
   if (!isInteger(port) || port < 0 || port > 65535)
   {
       return false;
   }
   
   return true;
}

function CheckForm(type)
{   
	with(document.getElementById("ConfigForm"))
    {
        if (Acsurl_text.value == '')
        {
            AlertEx("请输入ITMS认证地址。");
            Acsurl_text.focus();
            return false;
        }
        
        if (!isSafeStringSN(Acsurl_text.value))
        {
            AlertEx('ITMS认证地址不能包含空格和下列字符： \"<, >, \', \", {, }, [, ], %, \\, ^, #, |\"。');
            Acsurl_text.focus();
            return false;
        }
        
		if (!checkUrlPort(Acsurl_text.value))
        {
        	AlertEx('ITMS认证地址包含无效的端口。');
            Acsurl_text.focus();
            return false;
        }
        
        if ('' != isValidAscii(Acsurl_text.value))
        {
        	AlertEx('ITMS认证地址中包含非ASCII字符。');
            Acsurl_text.focus();
            return false;
		}
		
        if (getCheckVal("Tr69Inform_checkbox") == 1)
        {
            if ((Informinter_text.value == '') || (isPlusInteger(Informinter_text.value) == false))
            {
                AlertEx("无效的周期通知时间间隔。");
                Informinter_text.focus();
                return false;
            }
            
            var info = parseInt(Informinter_text.value,10);
            if (info < 1 || info > 2147483647)
            {
                AlertEx("无效的周期通知时间间隔。");
                Informinter_text.focus();
                return false;
            }

            
        }       
        
        if (AcsUserName_text.value == '')
        {
            AlertEx("请输入ITMS认证用户名。");
            AcsUserName_text.focus();
            return false;
        }
        if (isValidString(AcsUserName_text.value) == false )
        {
            AlertEx("无效的ITMS认证用户名。");
            AcsUserName_text.focus();
            return false;
        }
        
        if (AcsPassWord_password.value == '')
        {
            AlertEx("请输入ITMS认证密码。");
            AcsPassWord_password.focus();
            return false;
        }       
        if (isValidString(AcsPassWord_password.value) == false )
        {
            AlertEx("无效的ITMS认证密码。");
            AcsPassWord_password.focus();
            return false;
        }
        
        if (ConnReqName_text.value == '')
        {
            AlertEx("请输入反向认证用户名。");
            ConnReqName_text.focus();
            return false;
        }
        if (isValidString(ConnReqName_text.value) == false )
        {
            AlertEx("无效的反向认证用户名。");
            ConnReqName_text.focus();
            return false;
        }
        
        if ('' == ConnReqPassWord_password.value)
        {
            AlertEx("请输入反向认证密码。");
            ConnReqPassWord_password.focus();
            return false;
        }
        
        if (isValidString(ConnReqPassWord_password.value) == false )
        {
            AlertEx("无效的反向认证密码。");
            ConnReqPassWord_password.focus();
            return false;
        }
		//中间件参数校验
		if( 1 != getSelectVal('Middleware_select'))
		{
			if (MldAddr_text.value == '')
			{
				AlertEx("请输入中间件服务器地址。");
				MldAddr_text.focus();
				return false;
			}

			if (!isSafeStringSN(MldAddr_text.value))
			{
				AlertEx('中间件服务器地址不能包含空格和下列字符： \"<, >, \', \", {, }, [, ], %, \\, ^, #, |\"。');
				MldAddr_text.focus();
				return false;
			}

			if (!checkUrlPort(MldAddr_text.value))
			{
				AlertEx('中间件服务器地址包含无效的端口。');
				MldAddr_text.focus();
				return false;
			}

			if ('' != isValidAscii(MldAddr_text.value))
			{
				AlertEx('中间件服务器地址中包含非ASCII字符。');
				MldAddr_text.focus();
				return false;
			}
			
			if (!isValidMldPort(MldPort_text.value))
			{
				AlertEx('中间件服务器端口无效。');
				MldPort_text.focus();
				return false;
			}
		}

    }
    
    return true;
}

function ClickPeriodicInformEnable()
{
	var itemPeriodicInformEnable = document.getElementById("ConfigForm").Tr69Inform_checkbox;
	var itemPeriodicInformInterval = document.getElementById("ConfigForm").Informinter_text;
    
    if (true == itemPeriodicInformEnable.checked) {
       //这个广东特殊需求，沟选后也不让修改：DTS2013082108726 
    		if ( 'GDCT' == CfgMode.toUpperCase() || 'GDGCT' == CfgMode.toUpperCase())	
	    	{
	    		itemPeriodicInformInterval.disabled = true;
	    	}
	    	else
    		{
    			itemPeriodicInformInterval.disabled = false;
    		}
    		
        
    } else {
        itemPeriodicInformInterval.disabled = true;
       
    }
}

function AddSubmitParam(SubmitForm,type)
{
    SubmitForm.addParameter('x.PeriodicInformEnable',getCheckVal('Tr69Inform_checkbox'));
    if (getCheckVal('Tr69Inform_checkbox') == 1)
    {
        SubmitForm.addParameter('x.PeriodicInformInterval',parseInt(getValue('Informinter_text'),10));
        
    }
    SubmitForm.addParameter('x.URL',getValue('Acsurl_text'));
    SubmitForm.addParameter('x.Username',getValue('AcsUserName_text'));
    
	if (getValue('AcsPassWord_password') != cwmp.Password)
	{
		SubmitForm.addParameter('x.Password',getValue('AcsPassWord_password'));
	}
	
    SubmitForm.addParameter('x.ConnectionRequestUsername',getValue('ConnReqName_text'));
	
	if (getValue('ConnReqPassWord_password') != '********************************')
    {   
		SubmitForm.addParameter('x.ConnectionRequestPassword',getValue('ConnReqPassWord_password'));   	
    }
	SubmitForm.addParameter('y.Tr069Enable', getSelectVal('Middleware_select'));
	if( 1 != getSelectVal('Middleware_select'))
	{
		SubmitForm.addParameter('y.MiddlewareURL', getValue('MldAddr_text'));
		SubmitForm.addParameter('y.Port', getValue('MldPort_text'));
	}

    SubmitForm.setAction('set.cgi?x=InternetGatewayDevice.ManagementServer'
						 +'&y=InternetGatewayDevice.DeviceInfo.X_HW_MiddlewareMgt'
                         + '&RequestFile=html/ssmp/tr069/tr069e8c.asp');
    setDisable('Apply_button',1);
    
}

function MiddlewareChange()
{
    
}

function ClickHrefCertInputButton()
{
	window.location="hrefcerte8c.asp";
}

</script>

</head>
<body  class="mainbody" onLoad="LoadFrame();"> 
<form id="ConfigForm"> 
<div class="title_with_desc">TR069设置</div>
<div class="title_01"  style="padding-left:10px;" width="100%">管理协议（TR069）可以允许自动配置服务器（ACS）进行配置、管理、诊断到这个设备。</div>
<div class="func_spread"></div>
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_bg"> 
    <tr align="left"> 
      <td class="table_title" width="30%" align="left">启用周期上报:</td> 
      <td class="table_right" colspan="8" align="left"> <input id='Tr69Inform_checkbox' name='Tr69Inform_checkbox'  value='1' type='checkbox' onclick='ClickPeriodicInformEnable()'> </td> 
    </tr> 
	<tr align="left"> 
      <td class="table_title" width="30%" align="left">证书导入:</td> 
      <td class="table_right" colspan="8" align="left"> <input id='HrefCert_input_button' name='HrefCert_input_button'  value='证书导入' type='button' onclick='ClickHrefCertInputButton()'> </td> 
    </tr> 	
    <tr> 
      <td  class="table_title" align="left">通知间隔时间:</td> 
      <td class="table_right" colspan="8"> <input name='Informinter_text' type='text' id="Informinter_text" size="20"  maxlength="10"> 
        <strong style="color:#FF0033">*</strong> <span class="gray">[1 - 2147483647]（s）</span> </td> 
    </tr> 
    <tr> 
      <td  class="table_title" align="left">ITMS认证地址:</td> 
      <td class="table_right" colspan="8"> <input name='Acsurl_text' type='text' id="Acsurl_text" size="20" maxlength="256"> 
        <strong style="color:#FF0033">*</strong> </td> 
    </tr> 
    <tr> 
      <td  class="table_title" align="left">ITMS认证用户名:</td> 
      <td class="table_right" colspan="8"> <input name='AcsUserName_text' type='text' id="AcsUserName_text" size="20" maxlength="256"> 
        <strong style="color:#FF0033">*</strong> </td> 
    </tr> 
    <tr> 
      <td  class="table_title" align="left">ITMS认证密码:</td> 
      <td class="table_right" colspan="8" align="left"> <input name='AcsPassWord_password' type='password' id="AcsPassWord_password" size="20" maxlength="256"> 
        <strong style="color:#FF0033">*</strong><span class="gray">（密码的长度必须在1~256位字符之间）</span> </td> 
    </tr> 
    <tr> 
      <td  class="table_title" align="left">反向认证用户名:</td> 
      <td class="table_right" colspan="8"> <input name='ConnReqName_text' type='text' id="ConnReqName_text" size="20" maxlength="256"> 
        <strong style="color:#FF0033">*</strong> </td> 
    </tr> 
    <tr> 
      <td  class="table_title" align="left">反向认证密码:</td> 
      <td class="table_right" colspan="8"> <input name='ConnReqPassWord_password' type='password' id="ConnReqPassWord_password" size="20"  maxlength="256"> 
        <span class="gray"><strong style="color:#FF0033">*</strong>（密码的长度必须在1~256位字符之间）</span> </td> 
    </tr>
	<tr> 
      <td  class="table_title" align="left">中间件状态:</td> 
      <td class="table_right" colspan="8">
	  <select style="width:150px;" name='Middleware_select' id='Middleware_select' size="1" onChange='MiddlewareChange()'>
		<option value="0">启用中间件（含TR069）</option>
		<option value="1" selected="selected">不启用中间件</option>   
		<option value="2">启用中间件（不含TR069）</option>
      </select>
	  </td> 
    </tr>
	<tr> 
      <td class="table_title" align="left">中间件服务器地址：</td> 
      <td class="table_right" colspan="8"> <input name='MldAddr_text' type='text' id="MldAddr_text" size="20"  maxlength="256"> 
      </td> 
    </tr>
	<tr> 
      <td class="table_title" align="left">中间件服务器端口：</td> 
      <td class="table_right" colspan="8"> <input name='MldPort_text' type='text' id="MldPort_text" size="5"  maxlength="5"> 
      </td> 
    </tr> 
	
  </table> 
  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table_button">  
      <td  class="table_submit" width="30%"></td> 
      <td  class="table_submit" align="right">
	  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	  <input  class="submit" name="Apply_button" id= "Apply_button" type="button" value="保存/应用" onClick="Submit();"> 
      </td> 
    </tr> 
  </table> 

</form> 
 
</body>
</html>
