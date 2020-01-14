<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>中国移动</title>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">

</head>
<style>
.input_time {border:0px; }
</style>
<script language="javascript">
var br0Ip = '<%HW_WEB_GetBr0IPString();%>';
var httpport = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.Services.X_HW_WebServerConfig.ListenInnerPort);%>';
var ontPonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';

var MngtGdct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_GDCT);%>';     
var loadedcolor='orange' ;       // PROGRESS BAR COLOR
var unloadedcolor='white';     // COLOR OF UNLOADED AREA
var bordercolor='orange';        // COLOR OF THE BORDER
var barheight=15;              // HEIGHT OF PROGRESS BAR IN PIXELS
var barwidth=300;              // WIDTH OF THE BAR IN PIXELS
var ns4=(document.layers)?true:false;
var ie4=(document.all)?true:false;
var PBouter;
var PBdone;
var PBbckgnd;
var txt='';

function stResultInfo(domain, Result, Status, Limits, Times, RegTimerState, InformStatus, ProvisioningCode, ServiceNum)
{
	this.domain = domain;
	this.Result = Result;
	this.Status = Status;
} 

var stResultInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_UserInfo, Result|Status, stResultInfo);%>;
var SuccInfos = stResultInfos[0];

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

function LoadFrame()
{	
	if ((parseInt(SuccInfos.Status) == 0) && (parseInt(SuccInfos.Result) == 1))
	{
		document.getElementById('regsuccshow').style.display="";
		document.getElementById("regResult").innerHTML = "已经注册成功，无需再注册。";	
	}
	else
	{
		window.location="/login.asp";
	}	
	
}

function JumpTo()
{
	window.location="/login.asp";
}

</script>

<body onload="LoadFrame();">
<form>
<div align="center" id="regsuccshow" style="display:none">
<TABLE cellSpacing="0" cellPadding="0" width="808" align="center" border="0">
<TBODY>
	<TR>
    	<TD>
        	<TABLE cellSpacing="0" cellPadding="0" align="middle" width="808" border="0">
        	<TBODY>
        	<TR>
         		<TD width="77" background="/images/bg.gif" rowSpan="3"></TD>
				<TD align="center" style="width:653px;height:250px;" background="/images/register_cmccinfo.jpg">
				<TABLE cellSpacing="0" cellPadding="0" width="96%" height="15%" border="0">
        			<TR>
						<TD align="right">
						<script language="javascript">
						document.write('<A href="http://' + br0Ip +':'+ httpport +'/login.asp"><font style="font-size: 14px;" color="#000000">返回登录页面</FONT></A>');
						</script>
						</TD>
					</TR>
        		</TABLE>
        		<TABLE cellSpacing="0" cellPadding="0" width="400" border="0" height="80">
        			<TD colSpan="2" height="32"></TD>
					<script language="javascript"> 
							if (ontPonMode == 'gpon' || ontPonMode == 'GPON')
							{
								document.write('<TR><TD align="middle" colSpan="2" height="25" style="font-size: 18px;"><strong style="color:#FF0033">GPON上行终端</strong></TD><TR>');         
							}
							else
							{
								document.write('<TR><TD align="middle" colSpan="2" height="25" style="font-size: 18px;"><strong style="color:#FF0033">EPON上行终端</strong></TD><TR>');                        
							}
							
							document.write('<TD colSpan="2" height="16"></TD>');  
						
						</script>
					<TR>
						<TD colspan="2" align="center">
							<div id="prograss"><span id="percent" style="font-size:12px;"></span></div>
						</TD>
					</TR>
					<TR>
        				<TD colspan="2" align="center">
						<script language="JavaScript" type="text/javascript">
						document.write(txt);
						</script>
						</TD>
        			</TR>
					<TR>
						<TD align="middle" colSpan="2" height="4"></TD>
					</TR>
        			<TR height="8">
        				<TD colspan="2" align="center"><span id="regResult" style="font-size:13px;"></span></TD>
        			</TR>
         			<TR>
        				<TD colspan="2" valign="top" align="right" width="130" height="25" align="center"></TD>
					</TR>
        			<TR>
        				<TD colspan="2" align="center">
                 <input type="button" class="submit" style="font-size: 14px;" value="返 回" onclick="JumpTo();"/>
        				</TD>
					</TR>
					<TR>
					<TR>
						<TD align="center" colSpan="2" width="100%" height="30"><font style="font-size: 14px;">中国移动客服热线10086号</TD>
        			</TR>
        			<TR>
						<TD align="left" colSpan="2" height="60"></TD>
					</TR>
        		</TABLE>
    			<TD width="78" background="/images/bg.gif" rowSpan="3"></TD>
   		 	</TR>
			</TBODY>
			</TABLE>
		</TD>
	</TR>
</TBODY>
</TABLE>
</div>
</form>
</body>
</html>
