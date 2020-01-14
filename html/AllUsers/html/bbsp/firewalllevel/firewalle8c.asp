<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>Firewall Level</title>
<script language="JavaScript" type="text/javascript">

var FltsecLevel = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Security.X_HW_FirewallGeneralLevel);%>';

function LoadFrame()
{
    if(1 == FltsecLevel){
        getElementById("FirewallEnable_checkbox").checked = false;
        getElementById("DosEnable_checkbox").checked = false;
        setDisable('DosEnable_checkbox',1);
    }else{
        getElementById("FirewallEnable_checkbox").checked = true;
        if(3 == FltsecLevel){
            getElementById("DosEnable_checkbox").checked = true;
        }
    }
}

function OnCfgChanged()
{
        var fireWallEn = document.getElementById("FirewallEnable_checkbox").checked;
        var dosEn = document.getElementById("DosEnable_checkbox").checked;
        var Form = new webSubmitForm();
        if(false == fireWallEn){
            Form.addParameter('x.X_HW_FirewallGeneralLevel',1);
        }else{
            if(false == dosEn){
                Form.addParameter('x.X_HW_FirewallGeneralLevel',2);
            }else{
                Form.addParameter('x.X_HW_FirewallGeneralLevel',3);
            }
        }
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
        Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_Security&RequestFile=html/bbsp/firewalllevel/firewalle8c.asp');
        Form.submit();	
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<form id="ConfigForm"> 
  <table  width="100%" id="TableSmartFilter"> 
    <tr  width="100%" > 
      <td class="prompt"><table width="100%" border="0" cellspacing="0" cellpadding="0"> 
          <tr> 
            <td width="100%"  class="title_01" style="padding-left:10px;">在本页面上，您可以配置防火墙开关和Dos开关。</td> 
          </tr> 
        </table></td> 
    </tr> 
  </table> 
  <table id="TableFilterContent"  width="100%" cellspacing="0"> 
    <tr> 
      <td class="table_title width_25p">启用</td> 
      <td class="table_right">
	  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	  <input type="checkbox" value="false" id="FirewallEnable_checkbox" onclick="OnCfgChanged()" /></td> 
    </tr>
    <tr> 
      <td class="table_title width_25p">DoS攻击保护</td> 
      <td class="table_right"><input type="checkbox" value="false" id="DosEnable_checkbox" onclick="OnCfgChanged()" /></td> 
    </tr>
  </table> 
</form> 
</body>
</html>
