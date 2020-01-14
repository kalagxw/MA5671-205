<html>
<head>
<script language="JavaScript" type="text/javascript">
	var CfgMode ='<%HW_WEB_GetCfgMode();%>';
	var TelNum;
	document.write('<title>中国移动</title>');
	TelNum='10086号';
 </script>	
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
</head>
<style>
.input_time {border:0px; }
</style>

<script language="javascript">
var br0Ip = '<%HW_WEB_GetBr0IPString();%>';
var httpport = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.Services.X_HW_WebServerConfig.ListenInnerPort);%>';

function stResultInfo(domain, Result, Status, Limits, Times, RegTimerState, InformStatus, ProvisioningCode, ServiceNum)
{
	this.domain = domain;
	this.Result = Result;
	this.Status = Status;
	this.Limits = Limits;
 	this.Times = Times;
 	this.RegTimerState = RegTimerState;
    this.InformStatus	= InformStatus;
 	this.ProvisioningCode = ProvisioningCode;
    this.ServiceNum = ServiceNum;
}  

function WANIP(domain,ConnectionStatus,ExternalIPAddress, X_HW_SERVICELIST,ConnectionType,X_HW_TR069FLAG)
{
  this.domain 	= domain;
  this.ConnectionStatus 	= ConnectionStatus;	
		
  if(ConnectionType == 'IP_Bridged')
  {
  	this.ExternalIPAddress	= '';
  }
  else
  {
    this.ExternalIPAddress	= ExternalIPAddress;
  }
  
  this.X_HW_SERVICELIST = X_HW_SERVICELIST;
  this.X_HW_TR069FLAG = X_HW_TR069FLAG;
	
}

function WANPPP(domain,ConnectionStatus,ExternalIPAddress, X_HW_SERVICELIST,ConnectionType,X_HW_TR069FLAG)
{
  this.domain	= domain;
  this.ConnectionStatus	= ConnectionStatus;	
	
  if (ConnectionType == 'PPPoE_Bridged')
  {  
  	this.ExternalIPAddress	= '';	  
  }
  else
  {
    this.ExternalIPAddress= ExternalIPAddress;
  }	 
  this.X_HW_SERVICELIST = X_HW_SERVICELIST;
  this.X_HW_TR069FLAG = X_HW_TR069FLAG;
}
 
function PingResultClass(domain, FailureCount, SuccessCount)
{
    this.domain = domain;
    this.FailureCount = FailureCount;
    this.SuccessCount = SuccessCount;
} 

var opticInfo = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.Optic.RxPower);%>';      
var stResultInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_UserInfo, Result|Status|Limit|Times|X_HW_TimeoutState|X_HW_InformStatus|ProvisioningCode, stResultInfo);%>;
var Infos = stResultInfos[0];

var WanIp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i},ConnectionStatus||ExternalIPAddress|X_HW_SERVICELIST|ConnectionType|X_HW_TR069FLAG,WANIP);%>;
var WanPpp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i},ConnectionStatus|ExternalIPAddress|X_HW_SERVICELIST|ConnectionType|X_HW_TR069FLAG,WANPPP);%>;
var Wan = new Array();

var PingResultList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.IPPingDiagnostics,FailureCount|SuccessCount, PingResultClass);%>;
var PingResult = PingResultList[0];

var stOnlineStatusInfo = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.OntOnlineStatus.ontonlinestatus);%>';
var IsOntOnline = stOnlineStatusInfo;
var ontPonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';

var loadedcolor='orange' ;     // PROGRESS BAR COLOR
var unloadedcolor='white';     // COLOR OF UNLOADED AREA
var bordercolor='orange';      // COLOR OF THE BORDER
var barheight=15;              // HEIGHT OF PROGRESS BAR IN PIXELS
var barwidth=300;              // WIDTH OF THE BAR IN PIXELS
var ns4=(document.layers)?true:false;
var ie4=(document.all)?true:false;
var PBouter;
var PBdone;
var PBbckgnd;
var txt='';
var RegPeriodFlag = '<%HW_WEB_GetRegPeriodFlag();%>';
var acsUrl = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.ManagementServer.URL);%>';
var GetCurrentRegPerCent = '<%HW_WEB_GetRegPerCent();%>';
var GetLoidAuthStatus = '<%HW_WEB_GetLoidAuthStatus();%>';
var opticMode = '<%HW_WEB_GetOpticMode();%>'
var opticType = '<%HW_WEB_GetOpticType();%>';

/* 0表示光路正常 1表示光路异常*/
var GetGDCTOpticAbnormal = '<%HW_WEB_GDCT_GetOpticState();%>';

if(ns4)
{
	txt+='<table border=0 cellpadding=0 cellspacing=0><tr><td>';
	txt+='<ilayer name="PBouter" visibility="hide" height="'+barheight+'" width="'+barwidth+'">';
	txt+='<layer width="'+barwidth+'" height="'+barheight+'" bgcolor="'+bordercolor+'" top="0" left="0"></layer>';
	txt+='<layer width="'+(barwidth-2)+'" height="'+(barheight-2)+'" bgcolor="'+unloadedcolor+'" top="1" left="1"></layer>';
	txt+='<layer name="PBdone" width="'+(barwidth-2)+'" height="'+(barheight-2)+'" bgcolor="'+loadedcolor+'" top="1" left="1"></layer>';
	txt+='</ilayer>';
	txt+='</td></tr></table>';
}
else
{
	txt+='<div id="PBouter" style="position:relative; visibility:hidden; background-color:'+bordercolor+'; width:'+barwidth+'px; height:'+barheight+'px;">';
	txt+='<div style="position:absolute; top:1px; left:1px; width:'+(barwidth-2)+'px; height:'+(barheight-2)+'px; background-color:'+unloadedcolor+'; font-size:1px;"></div>';
	txt+='<div id="PBdone" style="position:absolute; top:1px; left:1px; width:0px; height:'+(barheight-2)+'px; background-color:'+loadedcolor+'; font-size:1px;"></div>';
	txt+='</div>';
}

/* 将IP类型的WAN添加到Wan中 */
for (i=0, j=0; WanIp.length > 1 && j < WanIp.length - 1; i++,j++)
{
  if("1" == WanIp[j].X_HW_TR069FLAG)
  {
    i--;
    continue;
  }
  Wan[i]= WanIp[j];
}

/* 将PPP类型的WAN添加到Wan中 */
for (j=0; WanPpp.length > 1 && j<WanPpp.length - 1; i++,j++)
{
  if("1" == WanPpp[j].X_HW_TR069FLAG)
  {
    i--;
    continue;
  }
  Wan[i]= WanPpp[j];
}

function resizeEl(id,t,r,b,l)
{
	if(ns4)
	{
		id.clip.left=l;
		id.clip.top=t;
		id.clip.right=r;
		id.clip.bottom=b;
	}
	else
	{
		id.style.width=r+'px';
	}
}

function myrefresh()   
{
	window.location.href="/loidresult.asp";
}  

//status stands wether visible, 
function setPrograss(status, width)
{
	PBouter=(ns4)?findlayer('PBouter',document):(ie4)?document.all['PBouter']:document.getElementById('PBouter');
  	PBdone=(ns4)?PBouter.document.layers['PBdone']:(ie4)?document.all['PBdone']:document.getElementById('PBdone');
	if(ns4)
	{
		if (1 == status)
		{
			PBouter.visibility="show";
		}
		else
		{
			PBouter.visibility="hide";
		}
	}
	else
	{
		if (1 == status)
		{
			PBouter.style.visibility="visible";
		}
		else
		{
			PBouter.style.visibility="hidden";
		}
	}
	
	resizeEl(PBdone, 0, width, barheight-2, 0);
}

function SetCookie(name, value)
{
		var expdate = new Date();
		var argv = SetCookie.arguments;
		var argc = SetCookie.arguments.length;
		var expires = (argc > 2) ? argv[2] : null;
		
		//“/”将cookie路径设置为根文件目录；如果为空，表示当前文件路径
		var path = "/";
		var domain = (argc > 4) ? argv[4] : null;
		var secure = (argc > 5) ? argv[5] : false;
		if(expires!=null) expdate.setTime(expdate.getTime() + ( expires * 1000 ));
		document.cookie = name + "=" + escape (value) +((expires == null) ? "" : ("; expires="+ expdate.toGMTString()))
		+((path == null) ? "" : ("; path=" + path)) +((domain == null) ? "" : ("; domain=" + domain))
		+((secure == true) ? "; secure" : "");
}

function GetCookieVal(offset)
{
	var endstr = document.cookie.indexOf (";", offset);
	if (endstr == -1)
	endstr = document.cookie.length;
	return unescape(document.cookie.substring(offset, endstr));
}

function GetCookie(name)
{
	var arg = name + "=";
	var alen = arg.length;
	var clen = document.cookie.length;
	var i = 0;
	while (i < clen)
	{
	var j = i + alen;
	if (document.cookie.substring(i, j) == arg)
	return GetCookieVal(j);
	i = document.cookie.indexOf(" ", i) + 1;
	if (i == 0) break;
	}
	return null;
}

function GetDateTimeDiff()
{
	lStartTime = GetCookie('lStartTime');	
    if (lStartTime == null || lStartTime == "")
    {
        SetCookie("lStartTime", new Date());
        return '1';
    }	
	var CurrentTime = new Date();
	var PrevTime = new Date(GetCookie("lStartTime"));
 	return parseInt((CurrentTime.getTime()-PrevTime.getTime())/1000);
}

function GetStepStatus()
{
	StepStatus = GetCookie('StepStatus');
    if (StepStatus == null || StepStatus == "" || (StepStatus < '0' || StepStatus > '7'))
    {
        SetCookie("StepStatus", "0");
        return '0';
    }
    return StepStatus;
}

/**********************************
GPON接收光功率范围：
CLASS B+: (-27,-8)
CLASS C+: (-30,-8)
EPON接收光功率范围：
PX20:  (-24,-3)
PX20+: (-27,-3)
其它:  参考PX20+的值。
***********************************/
function IsOpticPowerLow()
{
	
	if (ontPonMode.toUpperCase() == 'GPON')
	{ 
		if (opticType == 1) /* GPON */
		{ 
			return opticInfo < -27;/* CLASS B+: (-27,-8) */
		}
		else if(opticType == 2)
		{ 
			return opticInfo < -30;/* CLASS C+: (-30,-8) */
		}
	}
	else if (ontPonMode.toUpperCase() == 'EPON') /* EPON */	
	{ 
		if(opticType == 0)
		{ 
			return opticInfo < -24;/*PX20:  (-24,-3)*/
		}
		else if(opticType == 1)
		{
			return opticInfo < -27;/*PX20+: (-27,-3)*/
		}
	}
    return opticInfo < -27;
}

function GetAcsUrlAddress()
{
	var aclUrlTmp1 = acsUrl.split('//');
	if(aclUrlTmp1.length > 1)
	{
		var aclUrlTmp2 = aclUrlTmp1[1].split(':');
		return(aclUrlTmp2[0]);
	}
	return aclUrlTmp1[0];
}

function webSubmitForm(sFormName, DomainNamePrefix)
{
    /*-----------------------internal method------------------------*/
    this.setPrefix = function(Prefix)
    {
		if (Prefix == null)
		{
			this.DomainNamePrefix = '.';
		}
		else
		{
			this.DomainNamePrefix = Prefix + '.';
		}
	}
	
	this.getDomainName = function(sName)
	{
		if (this.DomainNamePrefix == '.')
		{
		    return sName;
		}
		else
		{
		    return this.DomainNamePrefix + sName;
		}
	}
	
    this.getNewSubmitForm = function()
	{
		var submitForm = document.createElement("FORM");
		document.body.appendChild(submitForm);
		submitForm.method = "POST";
		return submitForm;
	}
	
	this.createNewFormElement = function (elementName, elementValue)
	{
	    var newElement = document.createElement('INPUT');
		newElement.setAttribute('name',elementName);
		newElement.setAttribute('value',elementValue);
		newElement.setAttribute('type','hidden');
		return newElement;
	}
	
	/*---------------------------external method----------------------------*/
	this.addForm = function(sFormName,DomainNamePrefix)
	{
	    this.setPrefix(DomainNamePrefix);
	    var srcForm = getElement(sFormName);
		if (srcForm != null && srcForm.length > 0 && this.oForm != null 
			&& srcForm.style.display != 'none')
		{
			MakeCheckBoxValue(srcForm);
			
			for(i=0; i < srcForm.elements.length; i++)
			{  
			     var type = srcForm.elements[i].type;
			     if (type != 'button' && srcForm.elements[i].disabled == false)
				 {				
					 if (this.DomainNamePrefix != '.')
					 {
						 var ele = this.createNewFormElement(this.DomainNamePrefix 
												              + srcForm.elements[i].name,
												              srcForm.elements[i].value);	
						 this.oForm.appendChild(ele);
					 }	   
					 else
					 {
						var ele = this.createNewFormElement(srcForm.elements[i].name,
												             srcForm.elements[i].value
															  );
						this.oForm.appendChild(ele);
					 }	 
				 }
			 }
		}
		else
		{
			this.status = false;
		}
		
		this.DomainNamePrefix = '.';
	}
    
	this.addDiv = function(sDivName,Prefix)
	{
		if (Prefix == null)
		{
			Prefix = '';
		}
		else
		{
			Prefix += '.';
		}
		
		var srcDiv = getElement(sDivName);	
		if (srcDiv == null)
		{
			debug(sDivName + ' is not existed!')
			return;
		}
		if (srcDiv.style.display == 'none')
		{
			return;
		}

		var eleSelect = srcDiv.getElementsByTagName("select");
		if (eleSelect != null)
	    {
			for (k = 0; k < eleSelect.length; k++)
			{
				if (eleSelect[k].disabled == false)
				{
					this.addParameter(Prefix+eleSelect[k].name,eleSelect[k].value)
				}
			}
		}
		
		MakeCheckBoxValue(srcDiv);
		var eleInput = srcDiv.getElementsByTagName("input");
		if (eleInput != null)
	    {
			for (k = 0; k < eleInput.length; k++)
			{
				if (eleInput[k].type != 'button' && eleInput[k].disabled == false)
				{
				    this.addParameter(Prefix+eleInput[k].name,eleInput[k].value)
				}
			}	
		}
	}
	
	this.addParameter = function(sName, sValue)
	{
		//检查是否存在这个元素
		var DomainName = this.getDomainName(sName);
		
		for(i=0; i < this.oForm.elements.length; i++) 
		{
			if(this.oForm.elements[i].name == DomainName)
			{
				this.oForm.elements[i].value = sValue;
				this.oForm.elements[i].disabled = false;
				return;
			}
		}
	
		//没有发现这个元素
		if(i == this.oForm.elements.length) 
		{	
			var ele = this.createNewFormElement(DomainName,sValue);	
			this.oForm.appendChild(ele);
		}
	}
	
    this.disableElement = function(sName)
	{	
	    var DomainName = this.getDomainName(sName);		
		for(i=0; i < this.oForm.elements.length; i++) 
		{
			if(this.oForm.elements[i].name == DomainName)
			{
				this.oForm.elements[i].disabled = true;
				return;
			}
		}
	}
	
    this.usingPrefix = function(Prefix)
	{
	     this.DomainNamePrefix = Prefix + '.';
	}
	
    this.endPrefix = function()
	{
	     this.DomainNamePrefix = '.';
	}
	
	this.setMethod = function(sMethod)
	{
		if(sMethod.toUpperCase() == "GET")
			this.oForm.method = "GET";
		else
			this.oForm.method = "POST";
	};

	this.setAction = function(sUrl)
	{
		this.oForm.action = sUrl;
	}

	this.setTarget = function(sTarget)
	{
		this.oForm.target = sTarget;
	};

	this.submit = function(sURL, sMethod)
	{
		if( sURL != null && sURL != "" ) this.setAction(sURL);
		if( sMethod != null && sMethod!= "" ) this.setMethod(sMethod);
		
		if (this.status == true)
		    this.oForm.submit();
	};
	
	this.status = true;

	/*--------------------------------excute by internal-------------------------*/
	this.setPrefix(DomainNamePrefix);
	this.oForm = this.getNewSubmitForm();
	if (sFormName != null && sFormName != '')
	{
		this.addForm(sFormName,this.DomainNamePrefix);
	}
}

function StartPingDiagnose()
{
	var Form = new webSubmitForm();
	var IPAddress = GetAcsUrlAddress();		
	for (i = 0;i < Wan.length;i++)
    {
    	if((Wan[i].X_HW_SERVICELIST == "TR069") ||(Wan[i].X_HW_SERVICELIST == "TR069_VOIP")||(Wan[i].X_HW_SERVICELIST == "TR069_INTERNET")||(Wan[i].X_HW_SERVICELIST == "TR069_VOIP_INTERNET"))
    	{
    		//获取wan口名，用于ping诊断
    		WanName = Wan[i].domain;
    		break;
        }
    }
    var DSCP = 0;
    
	Form.addParameter('x.Host', IPAddress);
    Form.addParameter('x.DiagnosticsState', 'Requested');    
    Form.addParameter('x.NumberOfRepetitions', '3');
    Form.addParameter('x.DSCP', DSCP);
    if (WanName != "")
    {
       Form.addParameter('x.Interface', WanName); 
    }   
    Form.setAction('ping.cgi?x=InternetGatewayDevice.IPPingDiagnostics&RequestFile=loidresult.asp');
    Form.submit();
}

function StartRegStatus()
{
	setPrograss(1,90);
	document.getElementById('percent').innerHTML="30%"+"（历时"+GetDateTimeDiff()+"秒）";
	if(IsOpticPowerLow())
	{
	document.getElementById("regResult").innerHTML = "终端正在向OLT发起注册"+"（光功率过低）。";
	}
	else
	{
	document.getElementById("regResult").innerHTML = "终端正在向OLT发起注册。";
	}
}

//status stands wether visible, 
function setPrograss(status, width)
{
	PBouter=(ns4)?findlayer('PBouter',document):(ie4)?document.all['PBouter']:document.getElementById('PBouter');
  	PBdone=(ns4)?PBouter.document.layers['PBdone']:(ie4)?document.all['PBdone']:document.getElementById('PBdone');
	if(ns4)
	{
		if (1 == status)
		{
			PBouter.visibility="show";
		}
		else
		{
			PBouter.visibility="hide";
		}
	}
	else
	{
		if (1 == status)
		{
			PBouter.style.visibility="visible";
		}
		else
		{
			PBouter.style.visibility="hidden";
		}
	}
	
	resizeEl(PBdone, 0, width, barheight-2, 0);
}

/* 设置超时定时器，超时后刷新页面，相当于定时刷新*/
function setRefreshInterval()
{
	var timerTemp;
	if ((Infos != null) && (parseInt(Infos.Status) == 0) && (parseInt(Infos.Result) == 0))
	{
		timerTemp = setTimeout('myrefresh()', 2000); 
	}
	else
	{
		if ((GetCookie("CheckOnline") != "0") && (GetStepStatus() == "0"))
		{
			timerTemp = setTimeout('myrefresh()', 2000); 
		}
		else
		{	
			timerTemp = setTimeout('myrefresh()', 6000); 
		}	
	}
	return timerTemp;
}

/*光纤状态是否正常*/
function IsOpticalNomal()
{
	return opticInfo != "--";
}

/*判断终端是否在线，如果在线转入“向cms平台发起注册”的状态*/
function mystep()   
{
	if (1 != IsOntOnline)
	{
		SetCookie("CheckOnline","0");
	    SetCookie("StepStatus","3");
		return;
	}	
	
	var CheckOnlineTmp = GetCookie("CheckOnline");
	if(CheckOnlineTmp < "3")
	{
		CheckOnlineTmp++;
		SetCookie("CheckOnline",CheckOnlineTmp);
		return;
	}
	
	SetCookie("CheckOnline","0");
	
    //OLT上注册成功
	setPrograss(1,90);
	document.getElementById('percent').innerHTML="30%"+" （历时"+GetDateTimeDiff()+"秒）" ;
	document.getElementById("regResult").innerHTML = "终端在OLT已注册成功，下一步是终端向CMS平台发起注册。";

    SetCookie("StepStatus","2");	
}

/* 在CMS返回结果前的处理，需要处理：
	1 初始状体，即向OLT发起注册
	2 光纤异常
	3 OLT注册超时
	4 OLT注册成功，向CMS发起注册
 */
function setTipsBeforeITMSResult()
{
	//向OLT发起注册提示,初始状态
    if(GetStepStatus() == '0')
    {
    	//注册OLT超时的情况
	    if (GetDateTimeDiff() > 300)
		{
			setPrograss(0,0);
			document.getElementById('percent').innerHTML="";
			document.getElementById("regResult").innerHTML = "终端在OLT上注册失败，请检查光纤是否插接正常、或收光功率是否正常、或LOID是否输入正确"+" （历时"+GetDateTimeDiff()+"秒）。" ;						
		}
		else
		{
	        StartRegStatus(); 	
	        mystep();
	    }		  		  
    }
    //光纤异常
    else if(!IsOpticalNomal())
    {
        setPrograss(0,0);
        document.getElementById('percent').innerHTML="";
	    document.getElementById("regResult").innerHTML = "终端在OLT上注册失败，请检查光纤是否插接正常、或收光功率是否正常、或LOID是否输入正确"+" （历时"+GetDateTimeDiff()+"秒）。" ;
		SetCookie("StepStatus","4"); 
	}
    //向CMS平台注册超时
    else if(GetStepStatus() == '2')
	{	
		if( GetDateTimeDiff() > 120 )
		{
			setPrograss(0,0);
			document.getElementById('percent').innerHTML="";
			document.getElementById("regResult").innerHTML = "终端到CMS的通道不通，请找支撑经理处理"+" （历时"+GetDateTimeDiff()+"秒）。" ;
		}
		else
		{
			setPrograss(1,90);
			document.getElementById('percent').innerHTML="30%"+" （历时"+GetDateTimeDiff()+"秒）" ;
			document.getElementById("regResult").innerHTML = "终端在OLT已注册成功，下一步是终端向CMS平台发起注册。";
		}
	}
	//注册5分钟超时提示
    else if(GetStepStatus() == '3')
	{	
		if (GetDateTimeDiff() > 300)
		{
			setPrograss(0,0);
			document.getElementById('percent').innerHTML="";
			document.getElementById("regResult").innerHTML = "终端在OLT上注册失败，请检查光纤是否插接正常、或收光功率是否正常、或LOID是否输入正确"+" （历时"+GetDateTimeDiff()+"秒）。" ;	
		}
		else
		{
			StartRegStatus();	
			SetCookie("CheckOnline","0");	
			SetCookie("StepStatus","0");	
		}
	}
	else
	{
		//拔掉光纤把时间清一下
		if(GetStepStatus() == '4')
		{
			SetCookie("lStartTime",new Date());
		}
		StartRegStatus();
		SetCookie("StepStatus","0");
	}		   			  
}

/* 条件：第一次注册或上次注册未成功
   四川电信：注册成功，下发业务成功。
   福建电信：
   	1 ProvisioningCode节点为空：CMS平台数据下发成功，共下发了宽带、语音、ITV三个业务。
	2 ProvisioningCode节点非空：CMS平台数据下发成功，共下发了" + Infos.ProvisioningCode +"&nbsp;&nbsp;"+ strProvisioning.length + " 个业务。
 */
function getRegSuccessTips()
{
    var strProvisioning=Infos.ProvisioningCode.split(',');
	var strNewProvisioning='';
    if (""== Infos.ProvisioningCode)
    {
        return "CMS平台数据下发成功，共下发了宽带、语音、iTV三个业务。";
    }
    else
    {
        //拼接所有下发业务，用于页面提示
        for (i = 0; i < strProvisioning.length-1; i++)
        {
		    strNewProvisioning = strNewProvisioning+strProvisioning[i]+'、';
		}
        strNewProvisioning = strNewProvisioning+strProvisioning[strProvisioning.length-1];   	
        return "CMS平台数据下发成功，共下发了" + strNewProvisioning + strProvisioning.length + "个业务。";
    }
}

/*注册次数是否已经达到上限*/
function IsRegTimesToLimits()
{
    return parseInt(Infos.Times) >= parseInt(Infos.Limits);
}

function LoadFrame()
{
	/* 启动超时定时器 */
	var timer = setRefreshInterval();

	/* 对于广东，各个注册阶段都会进行光路检测，若存在光路异常，提示失败，无需重注册 */
    if ((1 != IsOntOnline) || (0 != parseInt(Infos.InformStatus)))
    {
        Infos.Status=99;
    } 
      
	   
	if (Infos != null)
	{
		if (parseInt(Infos.Status) == 0)
		{   
			if (parseInt(Infos.Result) == 99)
			{   
				setPrograss(1,150);
				document.getElementById('percent').innerHTML="50%";
				document.getElementById("regResult").innerHTML = "注册成功。";
			}
            else if (parseInt(Infos.Result) == 0)
            {
				setPrograss(1,180);
				document.getElementById('percent').innerHTML="60%";
				document.getElementById("regResult").innerHTML = "注册成功，正在下发业务，请等待。";		
			}
			else if (parseInt(Infos.Result) == 1)
			{	
				setPrograss(1,298);
				document.getElementById('percent').innerHTML="100%";
				document.getElementById("regResult").innerHTML = "注册成功，下发业务成功。";						
			}
			else if (parseInt(Infos.Result) == 2)
			{   
				setPrograss(0,0);		
				document.getElementById('percent').innerHTML="";

		
					document.getElementById("regResult").innerHTML = "注册成功，下发业务失败，请联系10086号。";
			}
		}
		else if(parseInt(Infos.Status) == 1)
		{
			setPrograss(0,0);
			document.getElementById('percent').innerHTML="";
			if (IsRegTimesToLimits())
			{
				document.getElementById("regResult").innerHTML = "身份证不存在，用户绑定不成功并且超过最大重试次数！请联系10086号。";
			}
			else
			{
				document.getElementById("regResult").innerHTML = "身份证不存在，用户绑定不成功！请重试（剩余尝试次数：" + (parseInt(Infos.Limits)-parseInt(Infos.Times)) + ")。";
			}
		}
		else if(parseInt(Infos.Status) == 2)
		{ 
			setPrograss(0,0);
			document.getElementById('percent').innerHTML="";
			if (IsRegTimesToLimits())
			{
				document.getElementById("regResult").innerHTML = "宽带账号不存在！注册失败，请联系10086号。";
			}
			else
			{
				document.getElementById("regResult").innerHTML = "宽带账号不存在！请重试（剩余尝试次数：" + (parseInt(Infos.Limits)-parseInt(Infos.Times)) + ")。";
			}
		}
		else if(parseInt(Infos.Status) == 3)
		{
			setPrograss(0,0);
			document.getElementById('percent').innerHTML="";
			if (IsRegTimesToLimits())
			{
				document.getElementById("regResult").innerHTML = "身份证与宽带帐号不匹配！注册失败，请联系10086号。";
			}
			else
			{
				document.getElementById("regResult").innerHTML = "身份证与宽带帐号不匹配！请重试（剩余尝试次数：" + (parseInt(Infos.Limits)-parseInt(Infos.Times)) + ")。";
			}
		}
		else if (parseInt(Infos.Status) == 4)
		{
			setPrograss(0,0);
			document.getElementById('percent').innerHTML="";
			document.getElementById("regResult").innerHTML = "注册超时！请检查线路后重试。";
		}
		else if (parseInt(Infos.Status) == 5)
		{
			setPrograss(0,0);
			document.getElementById('percent').innerHTML="";
			document.getElementById("regResult").innerHTML = "已经注册成功，无需再注册。";
		}
		else
		{
		    setTipsBeforeITMSResult();
			return;
		}
		
	}
	else
	{
		setTipsBeforeITMSResult();
		return;
	}
}

function JumpTo()
{
	if ((parseInt(Infos.Result) == 1) && (parseInt(Infos.Status) == 0))
	{
		window.location="/login.asp";
	}	
	else
	{
		window.location="/loidreg.asp";
	}
}

</script>
<body onLoad="LoadFrame();"> 
<form> 
<div align="center"> 
<TABLE cellSpacing="0" cellPadding="0" align="center" border="0" style="font-size:16px;"> <TBODY> 
<TR> 
</TR> 
<TR> 
<TD> <TABLE cellSpacing="0" cellPadding="0" align="middle" border="0" style="font-size:16px;"> 
<TBODY> <TR><TD align="center" style="width:653px;height:250px;" background="/images/register_cmccinfo.jpg">
<TABLE cellSpacing="0" cellPadding="0" width="96%" height="15%" border="0" style="font-size:16px;"> 
<TR> 
<TD align="right">
<script language="javascript">
document.write('<A href="http://' + br0Ip +':'+ httpport +'/login.asp"><font style="font-size: 14px;" color="#000000">返回登录页面</FONT></A>');
</script>
</TD> 
</TR> 
</TABLE> 
<br>
<br>
<TABLE cellSpacing="0" cellPadding="0" width="400" border="0" height="80%">    							
<script language="javascript"> 			      		       			
document.write('<TD colSpan="2" height="8"></TD>');
document.write('<TR>');
if (ontPonMode == 'gpon' || ontPonMode == 'GPON')
{
	document.write('<TD align="middle" colSpan="2" height="25" style="font-size: 18px;"><strong style="color:#FF0033">GPON上行终端</strong></TD>');         
}
else
{
	document.write('<TD align="middle" colSpan="2" height="25" style="font-size: 18px;"><strong style="color:#FF0033">EPON上行终端</strong></TD>');                        
}
document.write('</TR>');
document.write('<TD colSpan="2" height="16"></TD>');				
</script>
<TR> 
<TD colspan="2" align="center"> <div id="prograss"><span id="percent" style="font-size:12px;"></span></div></TD> 
</TR> 
<TR> 
<TD colspan="2" align="center">
<script language="JavaScript" type="text/javascript">
	document.write(txt);
</script> </TD> 
</TR> 
<TR> 
<TD align="middle" colSpan="2" height="4"></TD> 
</TR> 
<TR height="8"> 
<TD colspan="2" align="center"><span id="regResult" style="font-size:14px;"></span></TD> 
</TR> 
<TR> <TD colspan="2" valign="top" align="right" width="130" height="25" align="center"/> 
</TR>
<TR>
<TD colspan="2" align="center"　height="30">
	<input type="button" class="submit" style="font-size:13px;" value="返 回" onclick="JumpTo();"/></TD>		         
</TR>
<TR> 
<script language="javascript">
document.write('<TD align="center" colSpan="2" width="100%" height="20"><font style="font-size: 13px;">中国移动客服热线10086号</font></TD> ');
</script>
</TR> 
<TR> 
<TD align="left" colSpan="2" height="60"></TD> 
</TR> 
</TABLE> 

</TR> </TBODY> 
</TABLE></TD> 
</TR> 
</TBODY> 
</TABLE> 
</div> 
</form> 
</body>
</html>
