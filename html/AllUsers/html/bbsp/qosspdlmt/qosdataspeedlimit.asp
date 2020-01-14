<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache"/>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<title>Chinese -- Data Speed Limit</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<script language="javascript" src="../common/topoinfo.asp"></script>
<script language="javascript" src="../common/dataspeedlimit.asp"></script>
<script language="JavaScript" type="text/javascript">
var g_dataSpeedLimitList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.X_HW_DataSpeedLimit,SpeedLimitMode_UP|SpeedLimitMode_DOWN|InterfaceLimit_UP|InterfaceLimit_DOWN|VlanTagLimit_UP|VlanTagLimit_DOWN|IPLimit_UP|IPLimit_DOWN,DataSpeedLimitClass);%>;
var g_dataSpeedLimitInfo = g_dataSpeedLimitList[0];

var g_mode2Pormt = new Array(data_speed_limit_language['mode_invalid'],data_speed_limit_language['speed_limit_port'],data_speed_limit_language['speed_limit_vlan'],data_speed_limit_language['speed_limit_ip_segment']);
var g_upMode2ValueId=new Array(null,"PortSpeedLimitUp","VlanTagSpeedLimitUp","IPSpeedLimitUp");                
var g_downMode2ValueId=new Array(null,"PortSpeedLimitDown","VlanTagSpeedLimitDown","IPSpeedLimitDown");                
             
function LoadLanguage()
{
    var all = document.getElementsByTagName("td");
	for (var i = 0; i <all.length ; i++) 
	{
		var b = all[i];
		if(b.getAttribute("BindText") == null)
		{
			continue;
		}
		b.innerHTML = data_speed_limit_language[b.getAttribute("BindText")];
	}

}

function LoadFrame() 
{
    LoadLanguage();
    DataBind();
}

function GetLimitModeUI(item)
{
    return item+"TD";
}

function InitUpMode()
{
    for(i=0;i<g_upMode2ValueId.length;i++)
	{
	    if(g_upMode2ValueId[i] != null)
	    {
	        setText(g_upMode2ValueId[i],"");
	        setDisplay(GetLimitModeUI(g_upMode2ValueId[i]),0);
	    }
	}
}


function UpdateUpMode(upSpeedLimitMode,upLimitSpeed)
{
	if(upSpeedLimitMode != INVALID_LIMIT_MODE)
	{
	    setDisplay("SpeedLimitUpTR",1);
	    
	    setText(g_upMode2ValueId[upSpeedLimitMode],upLimitSpeed);
        setDisplay(GetLimitModeUI(g_upMode2ValueId[upSpeedLimitMode]),1);
        UpdateTitle(GetLimitModeUI(g_upMode2ValueId[upSpeedLimitMode]),upSpeedLimitMode);
	}
	else
	{
	    setDisplay("SpeedLimitUpTR",0);
	}
}

function InitDownMode()
{
    for(i=0;i<g_downMode2ValueId.length;i++)
	{
	    if(g_downMode2ValueId[i]!=null)
	    {
	        setText(g_downMode2ValueId[i],"");
	        setDisplay(GetLimitModeUI(g_downMode2ValueId[i]),0);
	    }
	}
}

function UpdateDownMode(downSpeedLimitMode,downLimitSpeed)
{
	if(downSpeedLimitMode!=INVALID_LIMIT_MODE)
	{
	    setDisplay("SpeedLimitDownTR",1);
	    setText(g_downMode2ValueId[downSpeedLimitMode],downLimitSpeed);
        setDisplay(GetLimitModeUI(g_downMode2ValueId[downSpeedLimitMode]),1);
        UpdateTitle(GetLimitModeUI(g_downMode2ValueId[downSpeedLimitMode]),downSpeedLimitMode);
	}
	else
	{
	    setDisplay("SpeedLimitDownTR",0);
	}
}

function DataBind()
{
    InitUpMode();
    setSelect('UpModeSelect',g_dataSpeedLimitInfo.SpeedLimitMode_UP);
	UpdateUpMode(g_dataSpeedLimitInfo.SpeedLimitMode_UP,g_dataSpeedLimitInfo.getUpLimitSpeed());
	
	InitDownMode();
	setSelect('DownModeSelect',g_dataSpeedLimitInfo.SpeedLimitMode_DOWN);
	UpdateDownMode(g_dataSpeedLimitInfo.SpeedLimitMode_DOWN,g_dataSpeedLimitInfo.getDownLimitSpeed());
}

function clickSubmit()
{
    var dataSpeedLimitClass = new DataSpeedLimitClass(g_dataSpeedLimitInfo.getDomain(),getValue('UpModeSelect'),getValue("DownModeSelect"),getValue("PortSpeedLimitUp"),getValue("PortSpeedLimitDown"),getValue("VlanTagSpeedLimitUp"),getValue("VlanTagSpeedLimitDown"),getValue("IPSpeedLimitUp"),getValue("IPSpeedLimitDown"));
    if (checkForm(dataSpeedLimitClass) == true)
    {
 	    submitData(dataSpeedLimitClass);
    }
}

function checkForm(dataSpeedLimitClass) 
{
    if(!dataSpeedLimitClass.checkUpSpeedLimit())
    {
        AlertEx(data_speed_limit_language['error_up_limit_invalid']);
        return false;
    }
    
    if(!dataSpeedLimitClass.checkDownSpeedLimit())
    {
        AlertEx(data_speed_limit_language['error_down_limit_invalid']);
        return false;
    }
    
    setDisable('btnApply', 1);
    setDisable('cancelValue', 1);

    return true;
}

function submitMock(dataSpeedLimitClass)
{
    g_dataSpeedLimitInfo = dataSpeedLimitClass;
    setDisable('btnApply', 0);
    setDisable('cancelValue', 0);
    DataBind();
}

function submitData(dataSpeedLimitClass)
{
    var form = new webSubmitForm();

	form.addParameter('x.SpeedLimitMode_UP',dataSpeedLimitClass.SpeedLimitMode_UP);
    if(dataSpeedLimitClass.SpeedLimitMode_UP != INVALID_LIMIT_MODE)
    {
	form.addParameter('x.InterfaceLimit_UP',dataSpeedLimitClass.InterfaceLimit_UP);
	form.addParameter('x.VlanTagLimit_UP',  dataSpeedLimitClass.VlanTagLimit_UP);
	form.addParameter('x.IPLimit_UP',       dataSpeedLimitClass.IPLimit_UP);
	}
	form.addParameter('x.SpeedLimitMode_DOWN',dataSpeedLimitClass.SpeedLimitMode_DOWN);
	if(dataSpeedLimitClass.SpeedLimitMode_DOWN != INVALID_LIMIT_MODE)
    {
	form.addParameter('x.InterfaceLimit_DOWN',dataSpeedLimitClass.InterfaceLimit_DOWN);
	form.addParameter('x.VlanTagLimit_DOWN',dataSpeedLimitClass.VlanTagLimit_DOWN);
	form.addParameter('x.IPLimit_DOWN',dataSpeedLimitClass.IPLimit_DOWN);
	}
	
	form.addParameter('x.X_HW_Token', getValue('onttoken'));
	var RequestFile = 'html/bbsp/qosspdlmt/qosdataspeedlimit.asp';
	var urlpara = 'x='+g_dataSpeedLimitInfo.getDomain()+ '&RequestFile=' + RequestFile;
	
	var url = 'set.cgi?' + urlpara;

	form.setAction(url);
	
	form.submit();

}	

function UpdateTitle(modeId,limitMode)
{
    getElById(modeId).title=g_mode2Pormt[limitMode];
}

function OnChangeUpMode(limitMode)
{
    if(limitMode < INVALID_LIMIT_MODE || limitMode > g_mode2Pormt.length || limitMode > g_upMode2ValueId.length)
    {
        return;
    }
    
    InitUpMode();
    UpdateUpMode(limitMode,"");
    
    if(limitMode != INVALID_LIMIT_MODE)
    {
    UpdateTitle(GetLimitModeUI(g_upMode2ValueId[limitMode]),limitMode);
    }
}

function OnChangeDownMode(limitMode)
{
    if(limitMode < INVALID_LIMIT_MODE || limitMode > g_mode2Pormt.length || limitMode > g_downMode2ValueId.length)
    {
        return;
    }
    
    InitDownMode();
    UpdateDownMode(limitMode,"");   
    
    if(limitMode != INVALID_LIMIT_MODE)
    {
    UpdateTitle(GetLimitModeUI(g_downMode2ValueId[limitMode]),limitMode);
    }
}

function CancelConfig()
{
    LoadFrame();
}

function LoadOption()
{
   
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<form id="ConfigForm" action="../network/set.cgi"> 
  <table width="100%" border="0" cellpadding="0" cellspacing="1"> 
    <tr> 
      <td class="prompt"> <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
          <tr> 
            <td width="100%" class="title_01" style="padding-left:10px;">
                <script>document.write(data_speed_limit_language['title']);</script></td> 
          </tr> 
        </table></td> 
    </tr> 
    <tr> 
      <td height="3px"></td> 
    </tr> 
  </table> 
  <div id="UpModeDiv"> 
    <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg"> 
      <tr class="head_title"> 
        <td align="left" colspan="2"><script>document.write(data_speed_limit_language['up_mode_prompt']);</script></td> 
      </tr> 
      <tr> 
        <td width="25%" class="table_title"><script>document.write(data_speed_limit_language['mode']);</script></td> 
        <td width="75%" class="table_right">
            <select name='UpModeSelect' size='1' style="width: 105px" onchange="OnChangeUpMode(this[this.selectedIndex].value)"> 
                <option value='0'><script>document.write(data_speed_limit_language['mode_invalid']);</script>
                <option value='1'><script>document.write(data_speed_limit_language['mode_user_port']);</script>
                <option value='2'><script>document.write(data_speed_limit_language['mode_vlan']);</script>
                <option value='3'><script>document.write(data_speed_limit_language['mode_ip_segment']);</script>
            </select>
        </td> 
      </tr>
      <tr id="SpeedLimitUpTR"> 
            <td  class="table_title width_per25"><script>document.write(data_speed_limit_language['speed_limit']);</script></td> 
            <td  class="table_title width_per75" id="PortSpeedLimitUpTD">
               <input type='text' id='PortSpeedLimitUp' maxlength='400' style='width: 98%'></input>
            </td>
            <td  class="table_title width_per75" id="VlanTagSpeedLimitUpTD">
                <input type='text' id='VlanTagSpeedLimitUp' maxlength='400' style='width: 98%'></input>
            </td>
            <td  class="table_title width_per75" id="IPSpeedLimitUpTD">
                <input type='text' id='IPSpeedLimitUp' maxlength='400' style='width: 98%'></input>
            </td>
        </tr>
    </table> 
  </div> 
  <div id="DownModePanel"> 
    <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg"> 
      <tr class="head_title"> 
        <td align="left" colspan="2"><script>document.write(data_speed_limit_language['down_mode_prompt']);</script></td> 
      </tr> 
      <tr> 
        <td width="25%" class="table_title"><script>document.write(data_speed_limit_language['mode']);</script></td> 
        <td width="75%" class="table_right">
            <select name='DownModeSelect' size='1' style='width: 105px' onchange="OnChangeDownMode(this[this.selectedIndex].value)"> 
                <option value='0'><script>document.write(data_speed_limit_language['mode_invalid']);</script>
                <option value='1'><script>document.write(data_speed_limit_language['mode_user_port']);</script>
                <option value='2'><script>document.write(data_speed_limit_language['mode_vlan']);</script>
                <option value='3'><script>document.write(data_speed_limit_language['mode_ip_segment']);</script>
            </select>
        </td> 
      </tr>
      <tr id="SpeedLimitDownTR"> 
            <td  class="table_title width_per25"><script>document.write(data_speed_limit_language['speed_limit']);</script></td> 
            <td  class="table_title width_per75" id="PortSpeedLimitDownTD">
                <input type='text' id='PortSpeedLimitDown' maxlength='400' style='width: 98%'></input>
            </td>
            <td  class="table_title width_per75" id="VlanTagSpeedLimitDownTD">
               <input type='text' id='VlanTagSpeedLimitDown' maxlength='400' style='width: 98%'></input>
            </td>
            <td  class="table_title width_per75" id="IPSpeedLimitDownTD">
                <input type='text' id='IPSpeedLimitDown' maxlength='400' style='width: 98%'></input>
            </td>
        </tr>
    </table> 
  </div> 
  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table_button"> 
    <tr> 
      <td width="25%"></td> 
      <td class="table_submit">
	    <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
        <button id="btnApply" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="clickSubmit();"><script>document.write(Languages['Apply']);</script></button>
        <button name="cancelValue" id="cancelValue" type="button" class="CancleButtonCss buttonwidth_100px" onClick="CancelConfig();"><script>document.write(Languages['Cancel']);</script></button>
      </td>
    </tr> 
  </table> 
</form> 
</body>
</html>
