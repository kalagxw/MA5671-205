<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>layer3</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">

var landhcpenable ='<%HW_WEB_GetFeatureSupport(BBSP_FT_DHCPS_UNI_CTL);%>';
var UpportId = '<%HW_WEB_Upportid();%>';

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
		b.innerHTML = layer3_language[b.getAttribute("BindText")];
	}
}

function stLayer3Info(l1,l2,l3,l4,l5)
{
    this.LAN1 = l1;
    this.LAN2 = l2;
    this.LAN3 = l3;
    this.LAN4 = l4;   
	this.LAN5 = l5;
}

function stLayer3Enable(domain, lay3enable)
{
	this.domain = domain;
	this.lay3enable = lay3enable;
}

function stLanDhcpEnable(domain, lanDhcpenable)
{
	this.domain = domain;
	this.lanDhcpenable = lanDhcpenable;
}

function TopoInfo(Domain, EthNum, SSIDNum)
{   
    this.Domain = Domain;
    this.EthNum = EthNum;
    this.SSIDNum = SSIDNum;
}

function ConvertLanBindPort(_BindPhyPortInfo, _Port)
{
	var portEnable = "0";
	var portBindList = _BindPhyPortInfo.split(",");
	
	for(var i = 0; i < portBindList.length; i++)
	{
		if(portBindList[i].toUpperCase() == _Port)
		{
			portEnable = "1";
			break;
		}
	}
	
	return portEnable;
}

function stBindPhyPortInfo(_Domain, _BindPhyPortInfo)
{
	this.domain = _Domain;
	this.BindPhyPortInfo = _BindPhyPortInfo;
	this.lan1enable = ConvertLanBindPort(_BindPhyPortInfo, "LAN1");
	this.lan2enable = ConvertLanBindPort(_BindPhyPortInfo, "LAN2");
	this.lan3enable = ConvertLanBindPort(_BindPhyPortInfo, "LAN3");
	this.lan4enable = ConvertLanBindPort(_BindPhyPortInfo, "LAN4");
	this.lan5enable = ConvertLanBindPort(_BindPhyPortInfo, "LAN5");
	this.s1enable = ConvertLanBindPort(_BindPhyPortInfo, "SSID1");
	this.s2enable = ConvertLanBindPort(_BindPhyPortInfo, "SSID2");
	this.s3enable = ConvertLanBindPort(_BindPhyPortInfo, "SSID3");
	this.s4enable = ConvertLanBindPort(_BindPhyPortInfo, "SSID4");
}

var waniplanbind = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i}, X_HW_BindPhyPortInfo, stBindPhyPortInfo);%>;
var wanppplanbind = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i}, X_HW_BindPhyPortInfo, stBindPhyPortInfo);%>;

var Lay3Enables = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.{i}, X_HW_L3Enable,stLayer3Enable);%>; 
var LanDhcpEnables = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_SpecParaLanDhcpEnable,InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.{i}, X_HW_DHCPv4Enable, stLanDhcpEnable);%>; 
var TopoInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Topo,X_HW_EthNum|X_HW_SsidNum,TopoInfo);%>;
var TopoInfo = TopoInfoList[0];

var bindOption = new stLayer3Info();
for (var i = 1; i <= TopoInfo.EthNum; i++)
{
    if (Lay3Enables[i-1] != null)
    {
        bindOption["LAN"+i] = Lay3Enables[i-1].lay3enable;
    }
    else
    {
        bindOption["LAN"+i] = "0";
    }
}

var LanDhcpOption = new stLayer3Info();
for (var i = 1; i <= TopoInfo.EthNum; i++)
{
    if (LanDhcpEnables[i-1] != null)
    {
        LanDhcpOption["LAN"+i] = LanDhcpEnables[i-1].lanDhcpenable;
    }
    else
    {
        LanDhcpOption["LAN"+i] = "0";
    }
}

var isEnableSSID = false;

var usedBindData= new stLayer3Info();

function LoadFrame()
{
    setCheck('cb_Lan1', bindOption.LAN1);
    setCheck('cb_Lan2', bindOption.LAN2);
    setCheck('cb_Lan3', bindOption.LAN3);
    setCheck('cb_Lan4', bindOption.LAN4);
	setCheck('cb_Lan5', bindOption.LAN5);

    setCheck('cb_DhcpLan1', LanDhcpOption.LAN1);
    setCheck('cb_DhcpLan2', LanDhcpOption.LAN2);
    setCheck('cb_DhcpLan3', LanDhcpOption.LAN3);
    setCheck('cb_DhcpLan4', LanDhcpOption.LAN4);
    
    setDisable('cb_Lan1', 0);
    setDisable('cb_Lan2', 0);
    setDisable('cb_Lan3', 0);
    setDisable('cb_Lan4', 0);
	setDisable('cb_Lan5', 0);

    for(i=0;waniplanbind.length > 0 && i < waniplanbind.length -1;i++)
    {
        if ("1" == waniplanbind[i].lan1enable)
        {
            setDisable('cb_Lan1', 1);
        }

        if ("1" == waniplanbind[i].lan2enable)
        {
            setDisable('cb_Lan2', 1);
        }

        if ("1" == waniplanbind[i].lan3enable)
        {
            setDisable('cb_Lan3', 1);
        }

        if ("1" == waniplanbind[i].lan4enable)
        {
            setDisable('cb_Lan4', 1);
        }
		
		if ("1" == waniplanbind[i].lan5enable)
        {
            setDisable('cb_Lan5', 1);
        }				
    }

    for(i=0;wanppplanbind.length > 0 && i < wanppplanbind.length -1;i++)
    {
        if ("1" == wanppplanbind[i].lan1enable)
        {
            setDisable('cb_Lan1', 1);
        }

        if ("1" == wanppplanbind[i].lan2enable)
        {
            setDisable('cb_Lan2', 1);
        }

        if ("1" == wanppplanbind[i].lan3enable)
        {
            setDisable('cb_Lan3', 1);
        }

        if ("1" == wanppplanbind[i].lan4enable)
        {
            setDisable('cb_Lan4', 1);
        }		
		
		if ("1" == wanppplanbind[i].lan5enable)
        {
            setDisable('cb_Lan5', 1);
        }
    }
	loadlanguage();
}

function parseUsedBindOptionData()
{
    for ( i=0; usedBindOptionOfIPCon.length > 0 && i < usedBindOptionOfIPCon.length-1; i++)
    {
        if ( usedBindOptionOfIPCon[i].LAN1 == 1)
        {
            usedBindData.LAN1 = 1;
        }
        if ( usedBindOptionOfIPCon[i].LAN2 == 1)
        {
            usedBindData.LAN2 = 1;
        }
        if ( usedBindOptionOfIPCon[i].LAN3 == 1)
        {
            usedBindData.LAN3 = 1;
        }
        if ( usedBindOptionOfIPCon[i].LAN4 == 1)
        {
            usedBindData.LAN4 = 1;
        }
		if ( usedBindOptionOfIPCon[i].LAN5 == 1)
        {
            usedBindData.LAN5 = 1;
        }
    }

    for ( j=0; usedBindOptionOfPPPCon.length > 1 && j < usedBindOptionOfPPPCon.length-1; j++)
    {
        if ( usedBindOptionOfPPPCon[j].LAN1 == 1)
        {
            usedBindData.LAN1 = 1;
        }
        if ( usedBindOptionOfPPPCon[j].LAN2 == 1)
        {
            usedBindData.LAN2 = 1;
        }
        if ( usedBindOptionOfPPPCon[j].LAN3 == 1)
        {
            usedBindData.LAN3 = 1;
        }
        if ( usedBindOptionOfPPPCon[j].LAN4 == 1)
        {
            usedBindData.LAN4 = 1;
        }
		if ( usedBindOptionOfPPPCon[j].LAN5 == 1)
        {
            usedBindData.LAN5 = 1;
        }
    }


     if ( isEnableSSID)
     {
        for ( i=0; usedBindOptionOfIPCon.length > 0 && i < usedBindOptionOfIPCon.length-1; i++)
        {
            if ( usedBindOptionOfIPCon[i].SSID1 == 1)
            {
                usedBindData.SSID1 = 1;
            }
            if ( usedBindOptionOfIPCon[i].SSID2 == 1)
            {
                usedBindData.SSID2 = 1;
            }
            if ( usedBindOptionOfIPCon[i].SSID3 == 1)
            {
                usedBindData.SSID4 = 1;
            }
            if ( usedBindOptionOfIPCon[i].SSID4 == 1)
            {
                usedBindData.SSID5 = 1;
            }
        }

        for ( j=0; usedBindOptionOfPPPCon.length > 1 && j < usedBindOptionOfPPPCon.length-1; j++)
        {
            if ( usedBindOptionOfPPPCon[j].SSID1 == 1)
            {
                usedBindData.SSID1 = 1;
            }
            if ( usedBindOptionOfPPPCon[j].SSID2 == 1)
            {
                usedBindData.SSID2 = 1;
            }
            if ( usedBindOptionOfPPPCon[j].SSID3 == 1)
            {
                usedBindData.SSID3 = 1;
            }
            if ( usedBindOptionOfPPPCon[j].SSID4 == 1)
            {
                usedBindData.SSID4 = 1;
            }
        }
    }
}

function CheckForm()
{
    setDisable('button', 1);
    setDisable('cancelValue', 1);
	return true;
}

function ChangeLanState()
{
    var Form = new webSubmitForm();
    var domain = "";
  
    for (var i = 1; i <= TopoInfo.EthNum && Lay3Enables[i-1] != null; i++)
    {
        domain +=  '&LAN'+i+'='+ Lay3Enables[i-1].domain;
        Form.addParameter('LAN'+i+'.X_HW_L3Enable',getCheckVal('cb_Lan'+i+''));
    }
	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    domain = domain.substr(1,domain.length-1);

    Form.setAction('set.cgi?' + domain
						 + '&RequestFile=html/bbsp/layer3/layer3.asp');
    setDisable('button', 1);
    setDisable('cancelValue', 1);
    Form.submit();
}

function ChangeDhcpBasedLanState()
{
    var Form = new webSubmitForm();
    var domain = "";
  
    for (var i = 1; i <= TopoInfo.EthNum; i++)
    {  
        domain +=  '&LAN'+i+'='+ LanDhcpEnables[i-1].domain
        Form.addParameter('LAN'+i+'.X_HW_DHCPv4Enable',getCheckVal('cb_DhcpLan'+i+''));
    }
    
    domain = domain.substr(1,domain.length-1);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('set.cgi?' + domain
						 + '&RequestFile=html/bbsp/layer3/layer3.asp');
    setDisable('button', 1);
    setDisable('cancelValue', 1);
    Form.submit();
}

function CancelConfig()
{
    LoadFrame();
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("layer3", GetDescFormArrayById(layer3_language, "bbsp_mune"), GetDescFormArrayById(layer3_language, "bbsp_layer3_title"), false);
</script> 
<div class="title_spread"></div>
<table> 
  <form action="" id="ConfigForm"> 
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="1"> 
      <tr id="secUsername" class='align_left'> 
        <td style="background-color: #f8f8f8;height: 24px;"> <div id="Div_LAN1"> 
            <input id="cb_Lan1" name="cb_Lan1" type="checkbox" value="LAN1"> 
            LAN1</div></td> 
        <td style="background-color: #f8f8f8;height: 24px;" nowrap> <div id="Div_LAN2"> 
            <input id="cb_Lan2" name="cb_Lan2" type="checkbox" value="LAN2"> 
            LAN2</div></td> 
        <td style="background-color: #f8f8f8;height: 24px;"> <div id="Div_LAN3"> 
            <input type="checkbox" id="cb_Lan3" name="cb_Lan3" value="LAN3"> 
            LAN3</div></td> 
        <td style="background-color: #f8f8f8;height: 24px;"> <div id="Div_LAN4"> 
            <input type="checkbox" id="cb_Lan4" name="cb_Lan4" value="LAN4"> 
            LAN4</div></td>
		<td style="background-color: #f8f8f8;height: 24px;"> <div id="Div_LAN5"> 
            <input type="checkbox" id="cb_Lan5" name="cb_Lan5" value="LAN5"> 
            LAN5</div></td> 
      </tr> 
      <tr id='secSSID' class='displaynone align_left'> 
        <td width="100%" align="left"> <div id="Div_SSID1"> 
            <input type="checkbox" id="cb_SSID1" name="cb_SSID1" value="SSID1"> 
            SSID1&nbsp;</div> 
          <div id="Div_SSID2"> 
            <input type="checkbox" id="cb_SSID2" name="cb_SSID2" value="SSID2"> 
            SSID2&nbsp;</div> 
          <div id="Div_SSID3"> 
            <input type="checkbox" id="cb_SSID3" name="cb_SSID3" value="SSID3"> 
            SSID3&nbsp;</div> 
          <div id="Div_SSID4"> 
            <input type="checkbox" id="cb_SSID4" name="cb_SSID4" value="SSID4"> 
            SSID4&nbsp;</div></td> 
      </tr> 
      <script>
  var EthNum = TopoInfo.EthNum;
  var SSIDNum = TopoInfo.SSIDNum;
  var i;
  for (i = 1; i <= 5; i++)
  {
      if (i > EthNum || i == UpportId)
      {
        setDisplay("Div_LAN"+i, 0);
      }
      if (i > SSIDNum)
      {
       setDisplay("Div_SSID"+i, 0);
      }
  }

  </script> 
    </table> 
    <table width="100%" border="0"  cellpadding="0" cellspacing="0"> 
      <tr > 
        <td class='title_bright1'> <button id='Apply' name="button" class="ApplyButtoncss buttonwidth_100px" type="button" onClick="ChangeLanState();" ><script>document.write(layer3_language['bbsp_app']);</script></button> 
          <button id='Cancel' name="cancelValue" class="CancleButtonCss buttonwidth_100px" type="button" onClick="CancelConfig();"><script>document.write(layer3_language['bbsp_cancel']);</script></button> </td> 
      </tr> 
    </table> 
  </form> 
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0" id="tabTestDhcpLan" style="display:none"> 
  <tr> 
    <td class="prompt"> <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
        <tr> 
          <td class='title_common' BindText='bbsp_dhcpbasedlan_title' ></td> 
        </tr> 
      </table> 
  </tr> 
  <tr> 
    <td class='height5p'></td> 
  </tr> 
  <script>
		if (landhcpenable == 1)
		{
  	    setDisplay("tabTestDhcpLan", 1);
  	}
  </script>
</table> 

<form action="" id="ConfigFormDhcpLan" style="display:none"> 
<table id="tabTestDhcpLanCheck">   
    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="1" > 
      <tr id="secUsername" class='align_left'> 
        <td style="background-color: #f8f8f8;height: 24px;"> <div id="Div_DHCPLAN1"> 
            <input id="cb_DhcpLan1" name="cb_DhcpLan1" type="checkbox" value="LAN1"> 
            LAN1</div></td> 
        <td style="background-color: #f8f8f8;height: 24px;"> <div id="Div_DHCPLAN2"> 
            <input id="cb_DhcpLan2" name="cb_DhcpLan2" type="checkbox" value="LAN2"> 
            LAN2</div></td> 
        <td style="background-color: #f8f8f8;height: 24px;"> <div id="Div_DHCPLAN3"> 
            <input type="checkbox" id="cb_DhcpLan3" name="cb_DhcpLan3" value="LAN3"> 
            LAN3</div></td> 
        <td style="background-color: #f8f8f8;height: 24px;"> <div id="Div_DHCPLAN4"> 
            <input type="checkbox" id="cb_DhcpLan4" name="cb_DhcpLan4" value="LAN4"> 
            LAN4</div></td>
		<td style="background-color: #f8f8f8;height: 24px;"> <div id="Div_DHCPLAN5"> 
            <input type="checkbox" id="cb_DhcpLan5" name="cb_DhcpLan5" value="LAN5"> 
            LAN5</div></td>  
      </tr> 
      <script>
      var EthNum = TopoInfo.EthNum;
      var i;
      for (i = 1; i <= 5; i++)
      {
          if (i > EthNum || i == UpportId)
          {
            setDisplay("Div_DHCPLAN"+i, 0);
          }
      }
      </script>
    </table> 
    <table width="100%" border="0"  cellpadding="0" cellspacing="0"> 
      <tr > 
        <td class='title_bright1'>
		  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
		  <button id='Apply' name="button" class="ApplyButtoncss buttonwidth_100px" type="button" onClick="ChangeDhcpBasedLanState();" ><script>document.write(layer3_language['bbsp_app']);</script></button> 
          <button id='Cancel' name="cancelValue" class="CancleButtonCss buttonwidth_100px" type="button" onClick="CancelConfig();"><script>document.write(layer3_language['bbsp_cancel']);</script></button> </td> 
      </tr> 
    </table> 
</table> 
<script>
if (landhcpenable == 1)
{
    setDisplay("ConfigFormDhcpLan", 1);
}
</script>
</form> 
</body>
</html>
