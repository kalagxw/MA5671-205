<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<title>DDNS</title>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="javascript" src="../../bbsp/common/managemode.asp"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../../bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list.asp"></script>
<style type="text/css">
.tabal_tr {
    height: 24px;
    line-height: 24px;
    padding-left: 5px;
}
.width_370px {
    width: 370px;
}
</style>
<script language="JavaScript" type="text/javascript">

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
		b.innerHTML = ddns_language[b.getAttribute("BindText")];
	}
}


var wans = GetWanList();

function stDdns(domain,Enable,Provider,Username,Port,DomainName,HostName,SaltAddress)
{
    this.domain = domain;
    this.Enable = Enable;
    this.Provider = Provider;
    this.Username = Username;
    this.Password = '********************************';
    this.Port = Port;
    this.DomainName = DomainName;
    this.HostName = HostName;
	this.SaltAddress = SaltAddress;
}

var WanIPDdns = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i}.X_HW_DDNSConfiguration.1,DDNSCfgEnabled|DDNSProvider|DDNSUsername|ServicePort|DDNSDomainName|DDNSHostName|SaltAddress,stDdns);%>;
var WanPPPDdns = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i}.X_HW_DDNSConfiguration.1,DDNSCfgEnabled|DDNSProvider|DDNSUsername|ServicePort|DDNSDomainName|DDNSHostName|SaltAddress,stDdns);%>;

function FindWanInfoByDdns(ddnsItem)
{
	var wandomain_len = 0;
	var temp_domain = null;
	
	for(var k = 0; k < wans.length; k++ )
	{
		wandomain_len = wans[k].domain.length;
		temp_domain = ddnsItem.domain.substr(0, wandomain_len);
		
		if (temp_domain == wans[k].domain)
		{
			return wans[k];
		}
	}	
}

var Ddns = new Array();
var Idx = 0;

for (i = 0; i < WanIPDdns.length-1; i++)
{
    var tmpWan = FindWanInfoByDdns(WanIPDdns[i]);   

    if (tmpWan.ServiceList != 'TR069'
		&& tmpWan.Mode == 'IP_Routed'
		&& tmpWan.AddressingType != 'Static')
	{
		Ddns[Idx] = WanIPDdns[i];
		Ddns[Idx].name = MakeDdnsName(WanIPDdns[i].domain);
		Ddns[Idx].wanins = MakeDdnsWanIns(WanIPDdns[i].domain);
		Idx ++;
	}
}
for (j = 0; j < WanPPPDdns.length-1; j++,i++)
{
      var tmpWan = FindWanInfoByDdns(WanPPPDdns[j]);   

	if (tmpWan.ServiceList != 'TR069'
		&& tmpWan.Mode == 'IP_Routed'
		&& tmpWan.AddressingType != 'Static')
	{
		Ddns[Idx] = WanPPPDdns[j];
		Ddns[Idx].name = MakeDdnsName(WanPPPDdns[j].domain);
		Ddns[Idx].wanins = MakeDdnsWanIns(WanPPPDdns[j].domain);   
		Idx ++;
	}  
}

function MakeDdnsName(DdnsDomain)
{
	var wandomain_len = 0;
	var temp_domain = null;
	
	for(var k = 0; k < wans.length; k++ )
	{
		wandomain_len = wans[k].domain.length;
		temp_domain = DdnsDomain.substr(0, wandomain_len);
		if (temp_domain == wans[k].domain)
		{
			return MakeWanName1(wans[k]);
		}
	}
}

function MakeDdnsWanIns(DdnsDomain)
{
	var wandomain_len = 0;
	var temp_domain = null;
	for(var k = 0; k < wans.length; k++ )
	{
		wandomain_len = wans[k].domain.length;
		temp_domain = DdnsDomain.substr(0, wandomain_len);
		if (temp_domain == wans[k].domain)
		{
			return temp_domain;
		}
	}
}


function isVaildDomainHost(val)
{
    return true;
}

function LoadFrame()
{
    var firstWanIf = getElement('DDNSWANInterface_select');
	loadlanguage();
	OnWanIfChange(firstWanIf);
}

function checkeMail(mail)
{
    return(new RegExp(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/).test(mail));
}

function CheckForm()
{ 
	var selectObj = getElement('DDNSWANInterface_select');
    var index = 0;
    var idx = 0;
	var count = 0;
	var i = 0;
             
    if ( selectObj.selectedIndex < 0 )
    {
        AlertEx(ddns_language['bbsp_creatwan']);
        return false;
    } 

    with (getElement('ConfigForm'))
    {
        if (DDNSProvider_text.value == "")
        {
			AlertEx(ddns_language['bbsp_hostisreq']);
            return false;            
        }

		DDNSProvider_text.value = removeSpaceTrim(DDNSProvider_text.value);
		if(CheckDomainName(DDNSProvider_text.value) == false)
		{			
			AlertEx(ddns_language['bbsp_hostx'] + DDNSProvider_text.value +  ddns_language['bbsp_invalid']);
			return false;
		}

        if (ServicePort_text.value == "")
        {
			AlertEx(ddns_language['bbsp_portidreq']);
            return false;            
        }
        else if (ServicePort_text.value.charAt(0) == '0')
		{
		    AlertEx(ddns_language['bbsp_portinvalid']);
            return false; 
		}	

        if(isValidPort(ServicePort_text.value) == false)
		{			
            AlertEx(ddns_language['bbsp_portinvalid']);
			return false;
		}		
		if (DDNSDomainName_text.value == "")
        {
			AlertEx(ddns_language['bbsp_domainisreq']);
            return false;
        }
        if (DDNSHostName_text.value == "")
        {
			AlertEx("主机名为空。");
            return false;  
        }		
		DDNSDomainName_text.value = removeSpaceTrim(DDNSDomainName_text.value);
		if (DDNSProvider_text.value == 'no-ip')
		{
			if(CheckMultDomainName(DDNSDomainName_text.value) == false)
			{			
				AlertEx(ddns_language['bbsp_domainx'] + DDNSDomainName_text.value +  ddns_language['bbsp_invalid']);
				return false;
			}
		}
		else
		{
			if(CheckDomainName(DDNSDomainName_text.value) == false)
			{			
				AlertEx(ddns_language['bbsp_domainx'] + DDNSDomainName_text.value +  ddns_language['bbsp_invalid']);
				return false;
			}
		}

		if (DDNSUsername_text.value == "") 
		{
		   AlertEx(ddns_language['bbsp_userisreq']);
		   return false;
		}
		
		if (isValidAscii(DDNSUsername_text.value) != '')         
		{  
			AlertEx(Languages['IPv4UserName1'] + Languages['Hasvalidch'] + isValidAscii(DDNSUsername_text.value) + ddns_language['bbsp_sign']);          
			return false;       
		}

		if (isValidName(DDNSUsername_text.value) == false)
		{
			AlertEx(ddns_language['bbsp_userinvalid']);
			return false;
		}

        if (DDNSPassword_password.value == "")
        {
            AlertEx(ddns_language['bbsp_pswisreq']);
            return false;
        }  
		
		if (isValidAscii(DDNSPassword_password.value) != '')         
		{  
			AlertEx(Languages['IPv4Password1'] + Languages['Hasvalidch'] + isValidAscii(DDNSPassword.value) + ddns_language['bbsp_sign']);         
			return false;       
		}
	}

	setDisable('Btn_Submit_button', 1);
	return true;
}


function AddSubmitParam(SubmitForm)
{
    var DomainPrefix = getSelectVal('DDNSWANInterface_select')+'.X_HW_DDNSConfiguration';
	var url;

    with (getElement ("ConfigureDiv"))
    {
        SubmitForm.addParameter('x.DDNSCfgEnabled',getCheckVal('DDNSCfgEnabled_Value'));  
        SubmitForm.addParameter('x.DDNSProvider',getValue('DDNSProvider_text'));
        SubmitForm.addParameter('x.DDNSUsername',getValue('DDNSUsername_text'));
        if (getValue('DDNSPassword_password') != '********************************')
        {
            SubmitForm.addParameter('x.DDNSPassword',getValue('DDNSPassword_password'));
        } 
  
        SubmitForm.addParameter('x.ServicePort',getValue('ServicePort_text'));
        SubmitForm.addParameter('x.DDNSDomainName',getValue('DDNSDomainName_text'));
        SubmitForm.addParameter('x.DDNSHostName',getValue('DDNSHostName_text'));
		if (getValue('DDNSProvider_text') == "gnudip.http")
        {
            SubmitForm.addParameter('x.SaltAddress',getValue('bbsp_Salt_address'));
        }

    }
	
	SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
	if ( AddFlag == true )
	{
		url = 'add.cgi?x=';
	}
	else
	{
		url = 'set.cgi?x=';
		DomainPrefix += ".1";
	}
	url += DomainPrefix +'&RequestFile=html/bbsp/ddns/ddnse8c.asp';
    setDisable('Btn_Submit_button',1);
    setDisable('Btn_Cancel_button',1);	
    SubmitForm.setAction(url); 
}

function getDdnsEncryptAlgorithm(servProvider)
{
	var ret = 'BASE64';
	
	if ((servProvider == 'gnudip') || (servProvider == 'gnudip.http'))
	{
		ret = 'MD5';
	}
	else if (servProvider == 'dtdns')
	{
		ret = ddns_language['bbsp_noencryptmh'];
	}
	else if (servProvider == '')
	{
		ret = '';
	}
	
	return ret;
}

function ISPChange()
{
	with (document.forms[0])
	{
	    setDisplay('saltaddress', 0);
		bbsp_Salt_address.value = '';
		
		if (DDNSProvider_text.value == 'dyndns')
		{			
			DDNSUsername_text.value = '';
			DDNSPassword_password.value = '';					    
		    setDisplay('isDDNSServer', 1);	
		    setDisplay('isDDNSServerPort', 1);		
			DDNSHostName_text.value = 'members.dyndns.org';
			ServicePort_text.value = '80';
		}
		else if (DDNSProvider_text.value == 'dyndns-static')
		{			
			DDNSUsername_text.value = '';
			DDNSPassword_password.value = '';					    
		    setDisplay('isDDNSServer', 1);			
		    setDisplay('isDDNSServerPort', 1);
			DDNSHostName_text.value = 'members.dyndns.org';
			ServicePort_text.value = '80';
		}
		else if (DDNSProvider_text.value == 'dyndns-custom')
		{			
			DDNSUsername_text.value = '';
			DDNSPassword_password.value = '';					    
		    setDisplay('isDDNSServer', 1);			
		    setDisplay('isDDNSServerPort', 1);
			DDNSHostName_text.value = 'members.dyndns.org';
			ServicePort_text.value = '80';
		}		
		else if (DDNSProvider_text.value == 'qdns')
		{			
			DDNSUsername_text.value = '';
			DDNSPassword_password.value = '';					    
		    setDisplay('isDDNSServer', 1);			
		    setDisplay('isDDNSServerPort', 1);
			DDNSHostName_text.value = 'members.3322.org';
			ServicePort_text.value = '80';
		}
		else if (DDNSProvider_text.value == 'qdns-static')
		{			
			DDNSUsername_text.value = '';
			DDNSPassword_password.value = '';					    
		    setDisplay('isDDNSServer', 1);			
		    setDisplay('isDDNSServerPort', 1);
			DDNSHostName_text.value = 'members.3322.org';
			ServicePort_text.value = '80';
		}
		else if (DDNSProvider_text.value == 'gnudip')
		{			
			DDNSUsername_text.value = '';
			DDNSPassword_password.value = '';					    
		    setDisplay('isDDNSServer', 1);			
		    setDisplay('isDDNSServerPort', 1);
			DDNSHostName_text.value = '';
			ServicePort_text.value = '3459';
		}
		else if (DDNSProvider_text.value == 'gnudip.http')
		{			
			DDNSUsername_text.value = '';
			DDNSPassword_password.value = '';					    
			setDisplay('isDDNSServer', 1);			
			setDisplay('isDDNSServerPort', 1);
			DDNSHostName_text.value = '';
			ServicePort_text.value = '80';
			bbsp_Salt_address.value = '/cgi-bin/gdipupdt.cgi';
			setDisplay('saltaddress', 1);
		}

		else if (DDNSProvider_text.value == 'no-ip')
		{			
			DDNSUsername_text.value = '';
			DDNSPassword_password.value = '';					    
		    setDisplay('isDDNSServer', 1);			
		    setDisplay('isDDNSServerPort', 1);
			DDNSHostName_text.value = 'dynupdate.no-ip.com';
			ServicePort_text.value = '80';
		}
		else if (DDNSProvider_text.value == 'dtdns')
		{			
			DDNSUsername_text.value = '';
			DDNSPassword_password.value = '';					    
		    setDisplay('isDDNSServer', 1);			
		    setDisplay('isDDNSServerPort', 1);
			DDNSHostName_text.value = 'www.dtdns.com';
			ServicePort_text.value = '80';
		}
		else if (DDNSProvider_text.value == '')
		{
			DDNSUsername_text.value = '';
			DDNSPassword_password.value = '';					    
		    setDisplay('isDDNSServer', 1);			
		    setDisplay('isDDNSServerPort', 1);
			DDNSHostName_text.value = '';
			ServicePort_text.value = '';		
		}
		DDNSEncrypt_text.value = getDdnsEncryptAlgorithm(DDNSProvider_text.value);
		setDisable('DDNSEncrypt_text',1);
	}
}

function setCtlDisplay(record)
{	
    var endIndex = record.domain.lastIndexOf('X_HW_DDNSConfiguration') - 1;
	var Interface = record.domain.substring(0,endIndex);

    setSelect('DDNSWANInterface_select',Interface);
	setText('DDNSDomainName_text',record.DomainName);
	setText('DDNSHostName_text',record.HostName);
	setText('DDNSProvider_text',record.Provider); 
	setText('DDNSUsername_text',record.Username);
	setText('DDNSPassword_password',record.Password);
	setText('ServicePort_text',record.Port);	    
    setCheck('DDNSCfgEnabled_Value', record.Enable);
	setText('DDNSEncrypt_text', getDdnsEncryptAlgorithm(record.Provider));
	setDisable('DDNSEncrypt_text',1);
	setText('bbsp_Salt_address',record.SaltAddress);
	setDisplay('saltaddress', ("gnudip.http" == record.Provider)?1:0);

}
      
function CancelConfig()
{
    var firstWanIf = getElement('DDNSWANInterface_select');
	OnWanIfChange(firstWanIf);
}
function showCurRecordByWanIf(wanIf)
{
    var recCfged = false;
    for(var i = 0; i < Ddns.length; i++){
        if(Ddns[i].wanins == wanIf){
            recCfged = true;
            break;
        }
    }
    
    if(true == recCfged){
        setCtlDisplay(Ddns[i]);
        AddFlag = false;
    }else{
        AddFlag = true;
        recordNull = new stDdns('','0','dyndns','','80','','members.dyndns.org');
        setCtlDisplay(recordNull);
    }
    setDisplay('isDDNSServer', 1);
    setDisplay('isDDNSServerPort', 1);
}
function OnWanIfChange(recSlected)
{
    showCurRecordByWanIf(getSelectVal(recSlected.id));
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<table width="100%"  border="0" cellpadding="0" cellspacing="0" id="tabTest"> 
  <tr> 
    <td class="prompt"> <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
        <tr> 
          <td class="title_common" BindText='bbsp_ddns_title'> </td> 
        </tr> 
      </table></td> 
  </tr> 
  <tr> 
    <td class="height5p"></td> 
  </tr> 
  <tr> 
    <td class="height5p"></td> 
  </tr> 
</table> 
<table> 
  <form id="ConfigForm"> 
    <div id="ConfigureDiv"> 
      <table cellpadding="0" cellspacing="0"  width="100%" > 
        <tr class="tabal_tr"> 
          <td id="DDNSCfgEnabled_text" class="table_title width_per25" >启动DDNS功能</td> 
          <td class="table_right"> <input id="DDNSCfgEnabled_Value" type="checkbox" name="DDNSCfgEnabled" checked> </td> 
        </tr> 
        <tr class="tabal_tr"> 
          <td class="table_title">服务器</td>
          <td class="table_right width_per75"><select id="DDNSProvider_text" name='DDNSProvider_text' size="1" 
                                    onChange="ISPChange()" class="width_260px"> 
              <option value="dyndns">dyndns</option> 
              <option value="dyndns-static">dyndns-static</option> 
              <option value="dyndns-custom">dyndns-custom</option> 
              <option value="qdns">qdns</option> 
              <option value="qdns-static">qdns-static</option> 
              <option value="gnudip">gnudip</option>
			  <option value="gnudip.http">gnudip.http</option> 
			  <option value="no-ip">no-ip</option> 
			  <option value="dtdns">dtdns</option> 
            </select></td>
	  </tr> 
        <tr id="saltaddress" style="display:none"> 
          <td class="table_title">Salt地址</td> 
          <td class="table_right width_per75"> <input id="bbsp_Salt_address" type='text' name='bbsp_Salt_address' size='20' maxlength='256' class="width_260px" /> 
            <span class="gray"><script>document.write(ddns_language['bbsp_Salt_address_eg']);</script></span></td> 

        </tr> 
        <tr id = 'isDDNSServerPort' class="tabal_tr"> 
          <td class="table_title">端口号</td> 
          <td class="table_right"> <input id="ServicePort_text" name="ServicePort_text" type="text" size="20" maxlength="6" class="width_370px"/> 
            <font color="red">*</font> <span class="gray"><script>document.write(ddns_language['bbsp_note2']);</script></span></td> 
        </tr>
        <tr class="tabal_tr"> 
          <td id="tdUserType" class="table_title">用户名</td> 
          <td class="table_right"> <input id="DDNSUsername_text_text" type="text" name="DDNSUsername_text" maxlength='255' class="width_370px"/> 
            <font color="red">*</font><span class="gray"><script>document.write(ddns_language['bbsp_note3']);</script></span></td> 
        </tr> 
        <tr class="tabal_tr"> 
          <td  class="table_title">密码</td> 
          <td class="table_right"> <input id="DDNSPassword_password" type="password" name="DDNSPassword_password"  maxlength='255' class="width_370px"/> 
            <font color="red">*</font><span class="gray"><script>document.write(ddns_language['bbsp_note3']);</script></span></td> 
        </tr> 
		<tr class="tabal_tr"> 
          <td  class="table_title">加密方式</td> 
          <td class="table_right"> <input id="DDNSEncrypt_text" type="text" name="DDNSEncrypt_text"  maxlength='255' class="width_370px"/></td> 
        </tr> 
        <tr> 
          <td  class="table_title">网络连接</td> 
          <td class="table_right"> <select id="DDNSWANInterface_select" name='DDNSWANInterface_select' size="1" class="width_260px" onChange="OnWanIfChange(this);" >
              <script language="JavaScript" type="text/javascript">
			  	InitWanNameListControl2("DDNSWANInterface_select", function(item){
					if (item.ServiceList != 'TR069' 
						&& item.Mode == 'IP_Routed'
						&& item.IPv4AddressMode != 'Static'
						&& item.IPv4Enable == '1')
					{return true;}else{return false;}
				});
			  </script>
            </select> </td> 
        </tr> 
        <tr class="tabal_tr"> 
          <td class="table_title">域</td> 
          <td class="table_right"> <input id="DDNSDomainName_text" type='text' name='DDNSDomainName_text' size='20' maxlength='255' class="width_370px"/> 
            <font color="red">*</font><span class="gray"><script>document.write(ddns_language['bbsp_note3']);</script></span></td> 
        </tr> 
        <tr class="tabal_tr" id = 'isDDNSServer'> 
          <td  class="table_title">主机名</td> 
          <td class="table_right"><input id="DDNSHostName_text" name='DDNSHostName_text' type='text' size="20" maxlength='255' class="width_370px"> 
            <font color="red">*</font><span class="gray"><script>document.write(ddns_language['bbsp_note3']);</script></span></td>
        </tr> 
      </table> 
      <table width="100%" class="table_button"> 
        <br/>
        <tr align="right"> 
          <td >
		  	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
		  	<button id="Btn_Submit_button" name="Btn_Submit_button" type="button"  onClick="Submit();">确定</button> 
            <button id="Btn_Cancel_button" name="Btn_Cancel_button"  type="button" onClick="CancelConfig();">取消</script></button>
		</td> 
        </tr> 
      </table> 
    </div> 
    <script language="JavaScript" type="text/javascript">
	writeTabTail();
	</script> 
  </form> 
</table> 
</body>
</html>
