<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var FltsecLevel = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Security.X_HW_FirewallLevel);%>'.toUpperCase();
var firewallLevelShow = {
	DISABLE: '禁用',
	HIGH:    '高',
	MEDIUM:  '中',
	LOW:     '低',
	CUSTOM:  '自定义'
}

function SubmitForm()
{
    var Form = new webSubmitForm();   
    Form.addParameter('x.X_HW_FirewallLevel',getValue('SecurityLevel'));
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_Security'+ '&RequestFile=html/bbsp/firewalllevel/firewallDos.asp');	
	Form.submit();
	setDisable('btnApplyFire' , 1);	
}


function stDos(domain,synFloodEn,icmpEchoReplyEn,icmpRedirectEn,landEn,smurfEn,winnukeEn,pingsweepEn)
{
    this.domain = domain;
    this.synFloodEn = synFloodEn;
	this.icmpEchoReplyEn = icmpEchoReplyEn;
	this.icmpRedirectEn = icmpRedirectEn;
	this.landEn = landEn;	
	this.smurfEn = smurfEn;	
	this.winnukeEn = winnukeEn;	
	this.pingsweepEn = pingsweepEn;	
}

var DosFilters = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.Dosfilter,SynFloodEn|IcmpEchoReplyEn|IcmpRedirectEn|LandEn|SmurfEn|WinnukeEn|PingSweepEn,stDos);%>
var DosFilter = DosFilters[0];
function LoadFrame()
{
	setSelect("SecurityLevel", FltsecLevel);
    if (DosFilter != null)
	{
		setCheck('synFlooding',DosFilter.synFloodEn);
		setCheck('icmpEcho',DosFilter.icmpEchoReplyEn);
		setCheck('icmpRedirect',DosFilter.icmpRedirectEn);
		setCheck('land',DosFilter.landEn);
		setCheck('smurf',DosFilter.smurfEn);
		setCheck('winnuke',DosFilter.winnukeEn);			
		setCheck('pingsweep',DosFilter.pingsweepEn);   
    }
	if(FltsecLevel != 'CUSTOM')
	{
		setDisable('synFlooding' , 1);
		setDisable('icmpEcho' , 1);
		setDisable('icmpRedirect' , 1);
		setDisable('land' , 1);
		setDisable('smurf' , 1);
		setDisable('winnuke' , 1);		
		setDisable('pingsweep' , 1);
		setDisable('btnApply_Dos' , 1);
		setDisable('cancelDos' , 1)
	}
}
function AddSubmitParam()
{
    var Form = new webSubmitForm();
	Form.addParameter('x.SynFloodEn',(getElement('synFlooding').checked == true) ? 1 : 0);
	Form.addParameter('x.IcmpEchoReplyEn',(getElement('icmpEcho').checked == true) ? 1 : 0);
	Form.addParameter('x.IcmpRedirectEn',(getElement('icmpRedirect').checked == true) ? 1 : 0);
	Form.addParameter('x.LandEn',(getElement('land').checked == true) ? 1 : 0);
	Form.addParameter('x.SmurfEn',(getElement('smurf').checked == true) ? 1 : 0);
	Form.addParameter('x.WinnukeEn',(getElement('winnuke').checked == true) ? 1 : 0);	
	Form.addParameter('x.PingSweepEn',(getElement('pingsweep').checked == true) ? 1 : 0);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));

	Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_Security.Dosfilter'
	               + '&RequestFile=html/bbsp/firewalllevel/firewallDos.asp');	
    setDisable('btnApply_Dos',1);
    setDisable('cancelDos',1);
	Form.submit();			  
}
function CancelConfig()
{
    LoadFrame();
}

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody">
<form id="ConfigForm">
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("firewalldostitle", GetDescFormArrayById(firewalllevel_language, ""), GetDescFormArrayById(firewalllevel_language, ""), false);
document.getElementById("firewalldostitle_content").innerHTML = "在本页面上，您可以配置防火墙等级和DoS参数。";
</script>
<div class="title_spread"></div>

<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg"> 
	 <tr class="table_title">
		<td class='width_per40'>当前防火墙等级：</td> 
		<td class='width_per60' > 
		<script language="JavaScript">   
    		    document.write("&nbsp;&nbsp;"+firewallLevelShow[FltsecLevel]);
		</script>
		</td> 
	</tr>       
	 <tr class="table_title">
		<td class='width_per40'>防火墙等级：</td>
		<td class='width_per60'>
		<select name="SecurityLevel" id="SecurityLevel">
		<option value="DISABLE">禁用</option>
		<option value="HIGH">高</option>
		<option value="MEDIUM">中</option>
		<option value="LOW">低</option>
		<option value="CUSTOM">自定义</option>
		</select>
		</td>
	</tr>
</table>
			
<table id="OperatorPanel" class="table_button" style="width: 100%" cellpadding="0">
  <tr>
  <td class="width_per40"></td>
  <td class="table_submit">
  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
  <button id="btnApplyFire" type="button"  onClick="SubmitForm();" class="submit">应用</button>
  </td>
  </tr>
</table>
  <table width="100%" class="tabal_bg"  cellpadding="0" cellspacing="1"> 
    <tr class="table_title"> 
      <td class='width_per40'>使能防止SYN溢出攻击：</td> 
      <td class="table_right "><input type='checkbox' id='synFlooding' value="1" > </td> 
    </tr> 
    <tr class="table_title"> 
      <td>使能防止ICMP回显攻击：</td> 
      <td class="table_right" > <input type='checkbox'  id='icmpEcho'  value="1" /> </td> 
    </tr> 
    <tr class="table_title"> 
      <td>使能防止ICMP重定向攻击：</td> 
      <td class="table_right" > <input type='checkbox'  id='icmpRedirect' value="1" /> </td> 
    </tr> 
    <tr class="table_title"> 
      <td>使能防止Land攻击：</td> 
      <td class="table_right" > <input type='checkbox'  id='land'  value="1" /> </td> 
    </tr> 
    <tr class="table_title"> 
      <td>使能防止Smurf 攻击：</td> 
      <td class="table_right" > <input type='checkbox'  id='smurf'  value="1" /> </td> 
    </tr> 
    <tr class="table_title"> 
      <td>使能防止Winnuke攻击：</td> 
      <td class="table_right" > <input type='checkbox'  id='winnuke'  value="1" /> </td> 
    </tr> 
	<tr class="table_title">
		<td>使能防止Ping扫射攻击：</td>
		<td class="table_right" ><input type='checkbox'  id='pingsweep'  value="1" /></td>
	</tr>
  </table> 
  <table width="100%" border="0"  cellpadding="0" cellspacing="0" class="table_button"> 
    <tr> 
      <td class="width_per40"></td>
      <td class="table_submit"> <button id='btnApply_Dos' type="button" class="ApplyButtoncss buttonwidth_100px" onClick="AddSubmitParam();">应用</script></button> 
        <button id="cancelDos" type="button" class="CancleButtonCss buttonwidth_100px" onClick="CancelConfig();">取消</button> </td> 
    </tr> 
  </table> 
</form>
</body>
</html>
