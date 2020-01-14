<html>
<head>
<script language="JavaScript" type="text/javascript">
	document.write('<title>设备注册</title>');
 </script>	
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
</head>
<script language="JavaScript" src="/../resource/common/<%HW_WEB_CleanCache_Resource(md5.js);%>"></script>
<script language="JavaScript" src="/../resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
<script language="JavaScript" src="/../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>

<style type="text/css">
.register-input {
	
}

.guangdong {width:430px;font-size: 14px; }
.qita {width:400px;}

.register-input tr{width:100%;}

.guangdong .register-input-title {
	width:170px;
	
}


.guangdong .register-input-content {
	width: 260px;
}

.qita .register-input-title {
	width:130px;
}
.qita .register-input-content {
	width:270px;
}

.register-input-title { text-align:right;}
.register-input-content .input { width:150px; margin-left:2em;}

.input_time {border:0px; }
 
#ChooseAreaModule .header { font-weight:bold;line-height:18px;margin:0px;padding:0px;margin-bottom:5px;text-align:center;}
 
.submit_area{
	font: 12px Arial, ËÎÌå;
	color:#0000FF;
    height: 25px;
	width:60px;
	margin-left: 2px;
	margin-bottom:4px;
	
	background-color:#E1E1E1;
	display:inline-block;
}

.disabled { color: gray;}

.goback { 
	display:inline-block;
	padding-left:4px;
	margin:0px;
	height: 25px;
	color: red;
}
.gothrough { 
	display:inline-block;
	padding-left:4px;
	margin:0px;
	height: 25px;
	color: red;
}

.content { width:653px;height:323px;position:absolute;}
.content .prompt { position:absolute; top:0px;left:0px;width:96%;height:40px;;border:0px; }
.content .module { position:absolute; top: 55px;left: 110px;width:430px; }

#SelectedArea {color: Red;font-weight: bold; }

.progress { position:relative;left:10px; background-color:white; width:380px; height:20px;  }
.progress .progressbar { position:absolute; top:1px; left:1px; width:0%; height:18px; background-color:orange;  }
.progress .progress-text { position:absolute;top:1px;left:1px; width:378px;height:16px;color:Black;text-align:center;font-size:12px; }
</style>
<script type="text/javascript">

var ProductName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';

function stResultInfo(domain, Result, Status)
{
	this.domain = domain;
	this.Result = Result;
	this.Status = Status;
}            

function CTAreaRelationInfo(ShortDes, Des, Area)
{
	this.ShortDes = ShortDes;
	this.Des = Des;
	this.Area = Area;
}

var ctAreaInfos = new Array(new CTAreaRelationInfo("", "请选择", 'NOCHOOSE'),
                            new CTAreaRelationInfo("移动", "中国移动", 'CHOOSE_CMCC'),
                            new CTAreaRelationInfo("电信", "中国电信", 'CHOOSE_XINAN'),
                            new CTAreaRelationInfo("联通", "中国联通", 'CHOOSE_UNICOM'),
							null);

function GetTCAreaByName(ctAreaInfos, name)
{
	var length = ctAreaInfos.length;
	
	for( var i = 0; i <  length - 1; i++)
	{
	    if(name == ctAreaInfos[i].Area)
		{
			return ctAreaInfos[i].Des;
		}
	}
	
	return null;
}

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


function GetE8CAreaByName(userEthInfos,name)
{
	var length = userEthInfos.length;
	
	for( var i = 0; i <  length - 1; i++)
	{
	    if(name == userEthInfos[i].ChineseDes)
		{
			return userEthInfos[i].E8CArea;
		}
	}
	
	return null;
}

function GetE8CAreaByCfgFtWord(userEthInfos,name)
{
	var length = userEthInfos.length;
	var dec = "";
	var i = 0;

	for(i = 0; i <  length - 1; i++)
	{
	    if(name == userEthInfos[i].E8CArea)
		{
			dec = userEthInfos[i].ChineseDes;
			break;
		}
	}
	
	if (i ==  length - 1) return null;
	
	length = ctAreaInfos.length;
	for(i = 0; i <  length - 1; i++)
	{
		if(CfgCTArea == ctAreaInfos[i].Area)
		{
			return dec + ctAreaInfos[i].ShortDes;
		}
	}

	return null;
}

var stResultInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_UserInfo, Result|Status, stResultInfo);%>;
var Infos = stResultInfos[0];

var ontPonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';
//获取是否选择过省份
var CfgFtWordArea = '<%GetCfgAreaInfo_MxU();%>';
var CfgCTArea = '<%GetConfigCTAreaInfo_MxU();%>';
//高亮省份上报接口  
var ProvinceArray = '<%GetChoiceProvinceInfo();%>';

var br0Ip = '<%HW_WEB_GetBr0IPString();%>';
var httpport = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.Services.X_HW_WebServerConfig.ListenInnerPort);%>';
var CfgFtWord = '<%HW_WEB_GetCfgMode();%>';


if ((parseInt(Infos.Result) == 1) && (0 == parseInt(Infos.Status)))
{
	window.location="/login.asp";	
}

function isValidAscii(val)
{
    for ( var i = 0 ; i < val.length ; i++ )
    {
        var ch = val.charAt(i);
        if ( ch < ' ' || ch > '~' )
        {
            return ch;
        }
    }
    return '';
}

function getElementById(sId)
{
	if (document.getElementById)
	{
		return document.getElementById(sId);	
	}
	else if (document.all)
	{
		// old IE
		return document.all(sId);
	}
	else if (document.layers)
	{
		// Netscape 4
		return document.layers[sId];
	}
	else
	{
		return null;
	}
}

function getElementByName(sId)
{   
	if (document.getElementsByName)
	{
		var element = document.getElementsByName(sId);
		
		if (element.length == 0)
		{
			return null;
		}
		else if (element.length == 1)
		{
			return 	element[0];
		}
		
		return element;		
	}
}

function getElement(sId)
{
	 var ele = getElementByName(sId); 
	 if (ele == null)
	 {
		 return getElementById(sId);
	 }
	 return ele;
}

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

function setText(sId, sValue)
{
	var item;
	if (null == (item = getElement(sId)))
	{
		debug(sId + " is not existed" );
		return false;
	}
    
	if(null != sValue)
	{
		sValue = sValue.toString().replace(/&nbsp;/g," ");
		sValue = sValue.toString().replace(/&quot;/g,"\"");
		sValue = sValue.toString().replace(/&gt;/g,">");
		sValue = sValue.toString().replace(/&lt;/g,"<");
		sValue = sValue.toString().replace(/&#39;/g, "\'");
		sValue = sValue.toString().replace(/&#40;/g, "\(");
		sValue = sValue.toString().replace(/&#41;/g, "\)");
		sValue = sValue.toString().replace(/&amp;/g,"&");
	}
	item.value = sValue;
	return true;
}

function getDivInnerId(divID)
{
    var nameStartPos = -1;
    var nameEndPos = -1;
    var ele;

    divHTML = getElement(divID).innerHTML;
    nameStartPos = divHTML.indexOf("name=");
    nameEndPos   = divHTML.indexOf(' ', nameStartPos);
    if(nameEndPos <= 0)
    {
        nameEndPos = divHTML.indexOf(">", nameStartPos);
    }
    
    try
    {
        ele = eval(divHTML.substring(nameStartPos+3, nameEndPos));
    }
    catch (e)
    {
        ele = divHTML.substring(nameStartPos+3, nameEndPos);
    }
    return ele;
}

function setDisable(sId, flag)
{
	var item;
	if (null == (item = getElement(sId)))
	{
		debug(sId + " is not existed" );
		return false;
	}

    if ( typeof(item.disabled) == 'undefined' )
    {
        if ( item.tagName == "DIV" || item.tagName == "div" )
        {
            var ele = getDivInnerId(sId);            
            setDisable(ele, flag);
        }
    }
    else
    {
        if ( flag == 1 || flag == '1' ) 
        {
             item.disabled = true;
        }
        else
        {
             item.disabled = false;
        }     
    }
    
    return true;
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
	
	this.getDomainName = function(sName){
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
	
	this.createNewFormElement = function (elementName, elementValue){
	    var newElement = document.createElement('INPUT');
		newElement.setAttribute('name',elementName);
		newElement.setAttribute('value',elementValue);
		newElement.setAttribute('type','hidden');
		return newElement;
	}
	
	/*---------------------------external method----------------------------*/
	this.addForm = function(sFormName,DomainNamePrefix){
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
	
	this.addParameter = function(sName, sValue){
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
	
    this.disableElement = function(sName){	
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
	
    this.usingPrefix = function(Prefix){
	     this.DomainNamePrefix = Prefix + '.';
	}
	
    this.endPrefix = function(){
	     this.DomainNamePrefix = '.';
	}
	
	this.setMethod = function(sMethod) {
		if(sMethod.toUpperCase() == "GET")
			this.oForm.method = "GET";
		else
			this.oForm.method = "POST";
	};

	this.setAction = function(sUrl) {
		this.oForm.action = sUrl;
	}

	this.setTarget = function(sTarget) {
		this.oForm.target = sTarget;
	};

	this.submit = function(sURL, sMethod) {
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

function MakeCheckBoxValue(srcForm)
{
	var Inputs = srcForm.getElementsByTagName("input");
	for (var i = 0; i < Inputs.length; i++) 
	{
		if (Inputs[i].type == "checkbox")
		{
			var CheckBox = getElement(Inputs[i].name);

			if (CheckBox.checked == true)
			{
				CheckBox.value = 1;
			}
			else
			{
				CheckBox.value = 0;
			}
		}
		else if (Inputs[i].type == "radio")
		{
			var radio = getElement(Inputs[i].name);
	        for (k = 0; k < radio.length; k++)
			{
				if (radio[k].checked == false)
				{
				    radio[k].disabled = true;
				}				
			}
		}
	}
}

function Submit(type)
{
    if (CheckForm(type) == true)
	{
	    var Form = new webSubmitForm();
	    AddSubmitParam(Form,type);		
		Form.submit();
	}
}

function debug(info)
{
}

function stDevInfo(domain,loid, eponpwd)
{
	this.domain = domain;
	this.loid       = loid;
    this.eponpwd = eponpwd;
}

function stOperateInfo(domain,Result,Status)
{
	this.domain = domain;
    this.Result = Result;
    this.Status = Status;
}

var stDevInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo, X_HW_Loid|X_HW_EponPwd, stDevInfo);%>;

var stOperateInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_UserInfo, Result|Status, stOperateInfo);%>;

var stDevinfo = stDevInfos[0];

var stOperateInfo = stOperateInfos[0];

function CheckForm()
{
    var loid = getValue('LOIDValue');
    var eponpwd = getValue('PwdValue');
	
	if ((null == loid) || ('' == loid))
	{
		alert("LOID不能为空，请输入正确的LOID。");
		return false;
	}
	
	if (isValidAscii(loid) != '')
	{
		alert("LOID包含非ASCII字符，请输入正确的LOID。");
		return false;
	}
	
	if (ontPonMode == 'gpon' || ontPonMode == 'GPON')
	{
		if (loid.length > 24)
		{
			alert("LOID不能超过24个字符。");
			return false;
		}
	}
	else
	{
	    if (loid.length > 32)
		{
			alert("LOID不能超过32个字符。");
			return false;
		}
	}
	
	if ((null != eponpwd) && ('' != eponpwd))
	{
		if (isValidAscii(eponpwd) != '')
		{
			alert("PASSWORD包含非ASCII字符，请输入正确的PASSWORD。");
			return false;
		}
		
		if (eponpwd.length > 12)
		{
			alert("PASSWORD不能超过12个字符。");
			return false;
		}
	}
	
	return true;
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

function LoadFrame()
{ 
	if ('GDCU' == CfgFtWord.toUpperCase())
	{
		setDisable('PwdValue',1);
	}
}

function AddSubmitParam1()
{
    if ((parseInt(Infos.Status) == 0) && (parseInt(Infos.Result) == 1))
	{
		//注册成功，不许再注册
		window.location="/loidgregsuccess.asp";
		return;	
	}
	
	if (CheckForm() == true)
	{
		var PrevTime = new Date();
		SetCookie("lStartTime",PrevTime);
		SetCookie("StepStatus","0");
		SetCookie("CheckOnline","0");
		SetCookie("lastPercent","0");
		SetCookie("GdTR069WanStatus","0");
		SetCookie("GdDispStatus","0");
		SetCookie("GdTR096WanIp","0");
		
		var SubmitForm = new webSubmitForm();
		
		SubmitForm.addParameter('x.UserName', getValue('LOIDValue'));
		SubmitForm.addParameter('x.UserId', getValue('PwdValue'));
		
		SubmitForm.setAction('loid.cgi?' +'x=InternetGatewayDevice.X_HW_UserInfo&RequestFile=loidresult.asp');
		setDisable('btnApply',1);
		setDisable('resetValue',1);
		SubmitForm.submit();
	}
}

function AddSubmitParam2()
{
	setText('LOIDValue','');
	setText('PwdValue','');
}

function CheckPwdCancel()
{
  window.location.reload(true);
}

</script>
<body onLoad="LoadFrame();"> 
<form> 
<div align="center"> 
<table cellSpacing="0" cellPadding="0" width="653" align="center" border="0"> 
<TBODY > 

<TR> 
<TD><table width="653" height="323" border="0" align="center" cellpadding="0" cellspacing="0"> 
<TBODY> 
<TR> 

<script language="javascript">		
		 document.write('<TD  align="center" width="653" height="323" background="/images/register_commoninfo.jpg">');
		
</script>
<div id="ChooseCTAreaModule" class="module" align="center" style="display:none;">
请选择运营商:
<select id="ChooseCTArea" style="width: 156px">
</select>
</div>
<div  id="ChooseAreaModule" class="module" align="left" style="display:none; width:400px; height:220px;padding-top:75px">
    <!-- 区域选择模块 -->
<p class="header">请选择所在地区:</p>
<input type="button"  class="submit_area" name="010" id="010" value="北京" />
<input type="button"  class="submit_area" name="021" id="021" value="上海" />
<input type="button"  class="submit_area" name="022" id="022" value="天津" />
<input type="button"  class="submit_area" name="023" id="023" value="重庆" />
<input type="button"  class="submit_area" name="0551" id="0551" value="安徽" />
<input type="button"  class="submit_area" name="0591" id="0591" value="福建" />
<input type="button"  class="submit_area" name="0971" id="0971" value="甘肃" />
<input type="button"  class="submit_area" name="020" id="020" value="广东" />
<input type="button"  class="submit_area" name="0771" id="0771" value="广西" />
<input type="button"  class="submit_area" name="0851" id="0851" value="贵州" />
<input type="button"  class="submit_area" name="0898" id="0898" value="海南" />
<input type="button"  class="submit_area" name="0311" id="0311" value="河北" />
<input type="button"  class="submit_area" name="0371" id="0371" value="河南" />
<input type="button"  class="submit_area" name="027" id="027" value="湖北" />
<input type="button"  class="submit_area" name="0731" id="0731" value="湖南" />
<input type="button"  class="submit_area" name="0431" id="0431" value="吉林" />
<input type="button"  class="submit_area" name="025" id="025" value="江苏" />
<input type="button"  class="submit_area" name="0791" id="0791" value="江西" />
<input type="button"  class="submit_area" name="024" id="024" value="辽宁" />
<input type="button"  class="submit_area" name="0951" id="0951" value="宁夏" />
<input type="button"  class="submit_area" name="0971" id="0971" value="青海" />
<input type="button"  class="submit_area" name="0531" id="0531" value="山东" />
<input type="button"  class="submit_area" name="0351" id="0351" value="山西" />
<input type="button"  class="submit_area" name="029" id="029" value="陕西" />
<input type="button"  class="submit_area" name="028" id="028" value="四川" />
<input type="button"  class="submit_area" name="0891" id="0891" value="西藏" />
<input type="button"  class="submit_area" name="0991" id="0991" value="新疆" />
<input type="button"  class="submit_area" name="0871" id="0871" value="云南" />
<input type="button"  class="submit_area" name="0571" id="0571" value="浙江" />
<input type="button"  class="submit_area" name="0451" id="0451" value="黑龙江" />
<input type="button"  class="submit_area" name="0471" id="0471" value="内蒙古" />
</div>

<div id="ApplyAreaModule" class="module" style="display:none;padding-top:70px">
<!-- 这里是应用配置文件时的进度条模块 -->

<div class="progress">
<div class="progressbar">
<div class="progress-text">0%</div>
</div>
</div>
<p id="RedirectText" style="text-align:center; height:200px"></p>

<script type="text/javascript">
$('#ApplyAreaModule').children('table')
.addClass('register-input')
</script>
</div>

<div id="CheckPwdModule" class="module" style="display:none;">
<!-- 密码校验模块 --> 
<br />
<br />
<br />
<br />
<p  align="center">验证密码：<input type="password" class="input" name="CheckPwdValue" id="CheckPwdValue" size="15" maxlength="127"/><strong style="color:#FF0033">*</strong></p>
<font id="CheckPwdPrompt" style="margin-left:20px;display:none;" size="2">提示：输入的验证密码不正确，请找支撑经理从CMS平台获取。</font>                      
<p style="text-align:center;">
<br>
<input name="btnCheckPwdApply" class="submitApply" id="btnCheckPwdApply"  type="button" value="&nbsp;确&nbsp;认&nbsp;">
<input style="margin-left:20px;"　name="btnCheckPwdCancel" class="submitCancel" id="btnCheckPwdCancel" onClick="CheckPwdCancel();" type="button" value="&nbsp;取&nbsp;消&nbsp;">
</p>
 
 <script language="javascript">
document.write('<p style="text-align:center;"> <font size="2">中国移动客服热线10086号</font></p>');
</script> 
</div>  

<div id="RegisterModule" class="module" style="display:none;padding-top:50px">
                    <!-- 注册模块 -->                                    
<TABLE cellSpacing="0" cellPadding="0" width="400" border="0" height="80%">
 <tr id="showChooseArea">
    <br />
	<br />
    <td colspan="2" style="text-align:center;">
        当前配置地区为<span id="SelectedArea"></span>，更改请<a href="#" class="showChooseAreaModule" >点击&gt;&gt;</a>
    </td>
</tr>
<script language="javascript">
    /* 如果为MA5676-G1F1或者MA5676-G1F1，不显示设备注册模块 */
	if(ProductName.indexOf("MA5676") < 0)
	{
		document.write('<tr id="tr_pon_type" style="display:none;">');
		document.write('<td colspan="2" height="18" align="left" id="pon_type"></td>');
		document.write('</tr>');

		document.write('<tr>');
		document.write('<td colspan="2" align="center" id="ont_sn_des" style="padding-left:30px;"></td>');
		document.write('</tr>');
		document.write('<tr >');
		document.write('<td colspan="2" align="center" id="otherinfo_des" style="padding-left:30px;"></td>');
		document.write('</tr>');
		
		document.write('<tr style="height:25px;">');
		document.write('<td class="register-input-title" id="ont_loid_value"></td>');
		document.write('<td class="register-input-content" ><input name="LOIDValue" class="input" id="LOIDValue" type="text" size="15" maxlength="63"><strong style="color:#FF0033">*</strong></td>');
		document.write('</tr>');

		document.write('<tr style="height:25px;">');
		document.write('<td class="register-input-title" id="passpwd_value"></td>');
		document.write('<td class="register-input-content"><input type="text" class="input" name="PwdValue" id="PwdValue" size="15" maxlength="63"/></td>');
		document.write('</tr>');
		
		document.getElementById('tr_pon_type').style.display="";
		document.write('<TR>');
		if (ontPonMode == 'gpon' || ontPonMode == 'GPON')
		{
			document.getElementById('pon_type').innerHTML = "<p size='2' style='text-align:center;color:#FF0033;font-size: 18px;'><strong>GPON上行终端</strong></p>";        
		}
		else
		{
			document.getElementById('pon_type').innerHTML = "<p size='2' style='text-align:center;color:#FF0033;font-size: 18px;'><strong>EPON上行终端</strong></p>";   
		}
		document.write('</TR>');

		if ('GDCU' == CfgFtWord.toUpperCase())
		{
			document.getElementById('otherinfo_des').innerHTML = "<font size='2'>提示：终端该密码为空，不能填写。</font>";
		}
			document.getElementById('ont_sn_des').innerHTML = "<font size='3'>请您输入申请业务时所提供的LOID和Password：</font>";
		document.getElementById('ont_loid_value').innerHTML = "LOID：";
		document.getElementById('passpwd_value').innerHTML = "Password：";
		
		document.write('<TR>');
		document.write('<TD align="middle" colSpan="2" height="35"> <input name="btnApply" class="submit" id="setReg" onClick="AddSubmitParam1()" type="button" value="&nbsp;提&nbsp;交&nbsp;">');
		document.write('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
		document.write('<input name="resetValue" id="resetValue" type="button" class="submit"  onClick="AddSubmitParam2();" value="&nbsp;重&nbsp;置&nbsp;"> </TD>');	
		document.write('</TR>');
	}
	else
	{
	}					
</script> 
 
<script language="javascript">	
document.write('<TD align="center" colSpan="2" width="100%" height="20"><font size="2">中国移动客服热线10086号</TD>');	
</script>
</TR> 
<TR> 
<TD align="left" colSpan="2" height="40"></TD> 
</TR> 
</TABLE> 
</div>
</TR> 
</TBODY> 
</TABLE> 
</TD> 
</TR> 
</TBODY> 
</TABLE> 
</div> 

<div align="center" style="margin-top:-320px">
<table class="prompt">
<TR>
<TD width="12%"></TD>
<TD align="right" width="15%">
<br />
<script language="javascript">
document.write('<A href="http://' + br0Ip +':'+ httpport +'/login.asp"><FONT size="2" color="#000000">返回登录页面</FONT></A>');
</script>
</TD> 

</TR> 
</TABLE> 
</div>

</form> 
<script type="text/javascript">
    $(document).ready(function () {
        var viewModel = {
            selectedArea: null,
			$ChooseCTAreaModule: $('#ChooseCTAreaModule'),
            $ChooseAreaModule: $('#ChooseAreaModule'),
            $ApplyAreaModule: $('#ApplyAreaModule'),
            $CheckPwdModule: $('#CheckPwdModule'),
            $RegisterModule: $('#RegisterModule')
        };
		
		 viewModel.$ChooseCTAreaModule.change(function() {
            //获取点击的区域
            var ctArea = $("#ChooseCTArea").val();

			if ('NOCHOOSE' != ctArea){
				if (confirm("您当前选择的运营商为：" + GetTCAreaByName(ctAreaInfos, ctArea) + "，是否确认?")){
				$.post('ConfigCTArea_MxU.cgi?&RequestFile=loidreg.asp', { "CTAreaInfo": ctArea });
				window.location="./loidreg.asp";
				}
			}
        }).bind({
            start: function (event, gothrough) {
                viewModel.$ApplyAreaModule.hide();
                viewModel.$RegisterModule.hide();
				viewModel.$ChooseAreaModule.hide();
                viewModel.$ChooseCTAreaModule.show();
				//LoadCTArea();
				if ("NOCHOOSE" == CfgCTArea || "" == CfgCTArea)
				{
					$("#ChooseCTArea").append("<option value='" + ctAreaInfos[0].Area + "'>"+ ctAreaInfos[0].Des + "</option>"); 
				}
				for (var i =1; i < ctAreaInfos.length-1;i++)
				{
					$("#ChooseCTArea").append("<option value='" + ctAreaInfos[i].Area + "'>"+ ctAreaInfos[i].Des + "</option>"); 
				}
				
				$("#ChooseCTArea ").val(CfgCTArea); 
				
				//制定跳过按钮
                var gothroughBtn = viewModel.$ChooseCTAreaModule.find('.gothrough');
				
				if (gothroughBtn)
				{
					gothroughBtn.remove();
				}
                //是否禁止添加返回按钮
                if (gothrough === "gothrough") {
					viewModel.$ChooseCTAreaModule.append('<a class="gothrough" href="#">跳过&gt;&gt;</a>');

                } else {
                    //移除跳过按钮
                    gothroughBtn.remove();
                }
            }	
        }).delegate('a.gothrough', 'click', function (event) {
            viewModel.$ChooseAreaModule.trigger('start');
        });

        //1.检测是否已配置运营商.是:直接显示账户输入面板;否:显示区域显示面板

        //设置区域选择模块的点击委托事件
        viewModel.$ChooseAreaModule.delegate(':button', 'click', function () {

            //获取点击的区域
            var area = this.value;
			
			//修复IE浏览器在将按钮设置为disabled后还能触发点击事件的bug
			if(this.disabled) return false;

            //确认用户是否选择配置此区域，是则配置，调用进度条模块

            //显示应用区域模块,并触发区域的配置事件
            viewModel.$ApplyAreaModule.trigger('start', area);

        }).bind({
            start: function (event, backable) {


                viewModel.$ApplyAreaModule.hide();
                viewModel.$RegisterModule.hide();
				viewModel.$ChooseCTAreaModule.hide();
                viewModel.$ChooseAreaModule.show();

                //制定返回按钮
                var gobackBtn = viewModel.$ChooseAreaModule.find('.goback');

                //是否禁止添加返回按钮
                if (backable === "noback") {

                    //移除返回按钮
                    gobackBtn.remove();

                } else {
                    if (!gobackBtn.length) {
                        viewModel.$ChooseAreaModule.append('<a class="goback" href="#">返回&gt;&gt;</a>');
                    }
                }
					
				//将非指定的按钮禁用并灰掉
				var enabledBtns = ProvinceArray;

				$('.submit_area').filter('[type="button"]').each(function(index) {
					var element = this;
					var name = element.name;
					if(enabledBtns.indexOf) {
						if(enabledBtns.indexOf(name) == -1) {
							$(this).attr('disabled', 'disabled').addClass('disabled');						
						}
					} else {
						var included = false;
						$.each(enabledBtns,function(index, item){
							if(item == name)
							{	
								included = true;
								return false;
							}
						});
						
						if(!included) {
							$(element).attr('disabled', 'disabled').addClass('disabled');
						}
					}
					
				});
				
            }	
        }).delegate('a.goback', 'click', function (event) {
            event.preventDefault();
            event.stopPropagation();

            viewModel.$RegisterModule.trigger('start');
        });

        //添加应用区域配置相关事件
        viewModel.$ApplyAreaModule.bind({
            start: function (event, area) {
                var e8cArea;

                if (!area) {
                    alert("您未选择任何区域!");
                    return;
                }
                

                e8cArea = GetE8CAreaByName(userEthInfos, area);

                //让用户确认是否选择此区域
                if (confirm("您当前选择的地区为" + area + "，是否确认?")) {
					alert("定制大约需要1分钟，请勿在定制过程中掉电，定制完成后请使用对应IP地址和用户名、密码登陆设备");
                    viewModel.$ChooseAreaModule.hide();
                    viewModel.$RegisterModule.hide();

                    viewModel.$ApplyAreaModule.show();

                    //向后台传输数据
                    $.post('ConfigE8cArea.cgi?&RequestFile=loidreg.asp', { "AreaInfo": e8cArea });
                   
                    //设置当前页面的e8c
                    window.CfgFtWordArea = e8cArea;

                    //调用进度条模块，跑进度条
                    viewModel.$ApplyAreaModule.trigger('beginProgress');
				
                }
            },
            beginProgress: function () {
                var completeSeconds = 10;
                var startSeconds = 0;
                var startTime = new Date();
                var endTime = new Date();
				
				viewModel.$ApplyAreaModule.find('#RedirectText').text("正在配置，请稍候...");
				viewModel.$ApplyAreaModule.trigger('setProgress', parseInt((startSeconds / completeSeconds) * 100));
                //循环刷新进度条
                var interval = setInterval(function () {

                    if (startSeconds != completeSeconds) {
                        var configstatus = '';
                        
                        $.ajax({
													type : "POST",
													async : true,
													cache : false,
													url : "/asp/GetConfigStatusInfo.asp",
													success : function(data) {
													configstatus = data;
													},
													error: function() {
         										configstatus = '';
         								},
         								
         								complete: function()
         								{
         									  if(configstatus == '')
		                        {   		
		                        		if(parseInt((endTime.getTime()-startTime.getTime())/1000) > 40)
			                    			{
			                    				viewModel.$ApplyAreaModule.find('#RedirectText').text("设备网络连接可能已断开，请检查你的网络连接状态。");
			                    			}
		                        }
		                        else if(configstatus == "DONE")
		                    		{
		                    			  viewModel.$ApplyAreaModule.find('#RedirectText').text("正在配置，请稍候...");
		                    				startSeconds = completeSeconds;
		                    		}
		                      	else if(parseInt((startSeconds / completeSeconds) * 100) >90)
		                    		{
		                    			viewModel.$ApplyAreaModule.find('#RedirectText').text("正在配置，请稍候...");  			
		                    			viewModel.$ApplyAreaModule.trigger('setProgress', 100);//装维人员需要速度。
		                    			startSeconds = completeSeconds;  			
		                    		}
		                    		else if(configstatus == "DOING")
		                  			{
		                  					viewModel.$ApplyAreaModule.trigger('setProgress', parseInt((startSeconds / completeSeconds) * 100));
		                    		    startSeconds += 1;
		                  			}
		                  			
		                  			endTime = new Date();
         								}
         								
         								
													});
													
                       
                  			
                    } else {

                        viewModel.$ApplyAreaModule.trigger('setProgress', 100);

                        //用结束进度条方法
                        viewModel.$ApplyAreaModule.trigger('endProgress');

                        //停止刷新进度条
                        clearInterval(interval);
                    };

                }, 1000);
            },
            setProgress: function (event, percent) {
                viewModel.$ApplyAreaModule.find('.progressbar').css('width', percent + '%');
                viewModel.$ApplyAreaModule.find('.progress-text').text(percent + '%');
            },
            endProgress: function () {

                redirectSeconds = 1;

                var tempInterval = setInterval(function () {

                    if (redirectSeconds !== 0) {
                        redirectSeconds -= 1;
                    } else {
						clearInterval(tempInterval);
                        window.location.reload(true);
                    }
                }, 1000);

            }
        });
       //初始化注册模块开始事件及显示选择区域模块的点击事件
        viewModel.$CheckPwdModule.bind({
            start: function () {
            	
            viewModel.$ChooseAreaModule.hide();
						viewModel.$ApplyAreaModule.hide();
						viewModel.$RegisterModule.hide();
						viewModel.$CheckPwdModule.show();
            }
          
        }).delegate('.submitApply', 'click', function (event) {
            //点击选择区域面板的按钮委托事件
            var CheckPassword = document.getElementById("CheckPwdValue").value;
            if(CheckPassword == '')
            {
            	 alert("输入的密码不能为空！");
            	return false;
            }
           
			var CheckInfo = FormatUrlEncode(CheckPassword);
            var CheckResult =0;
     
            
            //校验密码接口,返回CheckResult结果值:0,1。
            $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : '/asp/CheckModifyInfo.asp?&1=1',
            data :'CheckInfo='+CheckInfo,
            success : function(data) {
                CheckResult = data;
            }
        });
						        
            
            if(1 == CheckResult) //校验成功跳到选择省份，不成功则继续密码校验。
            {
            	viewModel.$CheckPwdModule.hide();
				viewModel.$ChooseCTAreaModule.trigger('start', "gothrough");
                //viewModel.$ChooseAreaModule.trigger('start');
            }
            else
          	{
          		
          		document.getElementById('CheckPwdPrompt').style.display="";
          		viewModel.$CheckPwdModule.show();
          	}
            
           
        });  

        //初始化注册模块开始事件及显示选择区域模块的点击事件
        viewModel.$RegisterModule.bind({
            start: function () {
				viewModel.$ChooseCTAreaModule.hide();
                viewModel.$ChooseAreaModule.hide();
                viewModel.$ApplyAreaModule.hide();

                viewModel.$RegisterModule.show();
                viewModel.$RegisterModule.find('#SelectedArea').text(GetE8CAreaByCfgFtWord(userEthInfos, CfgFtWordArea));
            }
        }).delegate('.showChooseAreaModule', 'click', function (event) {
            //点击选择区域面板的按钮委托事件

            event.preventDefault();
            event.stopPropagation();
			/* 如果为MA5676-G1F1或者MA5676-G1F1，不需要验证密码即可修改 */
			if(ProductName.indexOf("MA5676") < 0)
			{
				//不为区号027之类的需要校验密码
				if(CfgFtWordArea.toUpperCase() != 'NOCHOOSE' && CfgFtWordArea.toUpperCase() != 'CHOOSE' )
				{
					setText('CheckPwdValue','');
					viewModel.$CheckPwdModule.trigger('start');
				}
				else
				{
					viewModel.$ChooseAreaModule.trigger('start');
				}
			}
			else
			{
				viewModel.$CheckPwdModule.hide();
				viewModel.$ChooseCTAreaModule.trigger('start', "gothrough");
			}
        });

        //初始化事件.如果未选择区域,则提示用户选择区域
		if (CfgCTArea == '' || CfgCTArea.toUpperCase() == 'NOCHOOSE'){
			viewModel.$ChooseCTAreaModule.trigger('start');
		}
		else if (CfgFtWordArea == "")
		{
			viewModel.$ChooseAreaModule.trigger('start');
		}
        else if(CfgFtWordArea.toUpperCase() != 'NOCHOOSE' && CfgFtWordArea.toUpperCase() != 'CHOOSE') {
            viewModel.$RegisterModule.trigger('start');
            
            
        }
        else if(CfgFtWordArea.toUpperCase() == 'NOCHOOSE')
      	{
		viewModel.$ChooseAreaModule.trigger('start', 'noback');

      		  //viewModel.$RegisterModule.trigger('start');
      		  //document.getElementById('showChooseArea').style.display="none";
			  //document.getElementById('ChooseCTAreaModule').style.display="none";
      	}
        else {
            viewModel.$ChooseAreaModule.trigger('start', 'noback');
            
        }
        		
		
    });
</script> 
</body>
</html>
