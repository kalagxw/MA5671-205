<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>

<title>Optic information</title>
<script language="JavaScript" type="text/javascript">

function stOpticInfo(domain,transOpticPower,revOpticPower,voltage,temperature,bias,rfRxPower,rfOutputPower)
{
    this.domain = domain;
    this.transOpticPower = transOpticPower;
    this.revOpticPower = revOpticPower;
    this.voltage = voltage;
    this.temperature = temperature;
    this.bias = bias;
    this.rfRxPower = rfRxPower;
    this.rfOutputPower = rfOutputPower;
}

function stOLTOpticInfo(domain,BudgetClass,TxPower,PONIdentifier)
{
    this.domain = domain;
    this.BudgetClass = BudgetClass;
    this.TxPower = TxPower;
    this.PONIdentifier = PONIdentifier;
}


var OltOptics = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.OltOptic,BudgetClass|TxPower|PONIdentifier, stOLTOpticInfo);%>;
var OltOptic = OltOptics[0];
if(null == OltOptic)
{
	OltOptic = new stOLTOpticInfo('InternetGatewayDevice.X_HW_DEBUG.AMP.OltOptic', '--', '--', '');
}
 
var opticInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.Optic,TxPower|RxPower|Voltage|Temperature|Bias|RfRxPower|RfOutputPower, stOpticInfo);%>; 
var opticInfo = opticInfos[0];
var status = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.GetOptTxMode.TxMode);%>';
var ontPonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.AccessMode);%>';
var ontXGMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.XG_AccessMode);%>';
if ((ontPonMode == 'gpon') || (ontPonMode.indexOf("gpon")) > 0)
{
	ontPonMode = 'gpon';
}
else if ((ontPonMode == 'epon') || (ontPonMode.indexOf("epon")) > 0)
{
	ontPonMode = 'epon';
}
else
{
    ontPonMode = 'ge';
}

var ontPonRFNum = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.RF.RfPortNum);%>';
var opticPower = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.SMP.APM.ChipStatus.Optical);%>';
var opticStatus = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.GetOptStaus.status);%>';
var opticType = '<%HW_WEB_GetOpticType();%>';
var CfgMode = '<%HW_WEB_GetCfgMode();%>';
var curWebFrame='<%HW_WEB_GetWEBFramePath();%>';
var curUserType = '<%HW_WEB_GetUserType();%>';
var curLanguage='<%HW_WEB_GetCurrentLanguage();%>';
var telmexSpan = false;

if ('TELMEX' == CfgMode.toUpperCase() && 'SPANISH' == curLanguage.toUpperCase())
{
    telmexSpan = true;
}

function IsSonetSptUser()
{
	if(('<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_SONET);%>' == 1) && curUserType != '0')
	{
		return true;
	}
	else
	{
		return false;
	}
}
function GetLinkState()
{
    var State = <%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.OntOnlineStatus.ontonlinestatus);%>;

    if (State == 1 || State == "1")
    {
        return "已连接";
    }
    else
    {
        return "未连接";
    }
}

function GetLinkTime()
{
    var LinkTime = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.EPONLinkInfo.PONLinkTime);%>';
    var LinkDesc;

    LinkDesc = parseInt(LinkTime/3600) + "小时" + parseInt((LinkTime%3600)/60) + "分钟" + parseInt(((LinkTime%3600)%60)) + "秒";
    if (GetLinkState() == "未连接")
    {
        LinkDesc = "--";
    }

    return LinkDesc;
}

function GetPONTxPackets()
{                            
    var PONTxPackets = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.WANDevice.X_HW_PonInterface.Stats.PacketsSent);%>';
    var PONTxPacketsString = parseInt(PONTxPackets);
    return PONTxPacketsString;
}

function GetPONRxPackets()
{
    var PONTxPackets = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.WANDevice.X_HW_PonInterface.Stats.PacketsReceived);%>';
    var PONTxPacketsString = parseInt(PONTxPackets);
    return PONTxPacketsString;
}

function LoadOpticRef()
{
    if (!IsSonetSptUser())
    {
        getElById("ref_head").style.display = "";
        getElById("ref_status").style.display = "";
        getElById("ref_rx").style.display = "";
        getElById("ref_tx").style.display = "";
        getElById("ref_vol").style.display = "";
        getElById("ref_cur").style.display = "";
        getElById("ref_temp").style.display = "";
        if ((ontPonMode == 'gpon' || ontPonMode == 'GPON') && (ontPonRFNum != '0'))
        {
            getElById("ref_catvrx").style.display = "";
            getElById("ref_catvtx").style.display = "";
        }
        
        if ( !(('TELMEX' == CfgMode.toUpperCase()) || ('GPON' != ontPonMode.toUpperCase())) ) 
        {
            getElById("ref_olt_head").style.display = "";
            getElById("ref_olt_optic_type").style.display = "";
            getElById("ref_olt_txpower").style.display = "";
            getElById("ref_olt_portid").style.display = "";		
        }
    }
}

function LoadFrame()
{ 
    var all = document.getElementsByTagName("td");
    for (var i = 0; i <all.length ; i++) 
    {
        var b = all[i];
        if(b.getAttribute("BindText") == null)
        {
            continue;
        }
        if (true == telmexSpan)
	    {
		if (b.getAttribute("BindText") == 'amp_optinfo_title')
		{
		   b.innerHTML = status_optinfo_language['amp_optinfo_title_telmex'];
		   continue;
		}
		if (b.getAttribute("BindText") == 'amp_optic_voltage')
		{
		   b.innerHTML = status_optinfo_language['amp_optic_voltage_telmex'];
		   continue;
		}
		if (b.getAttribute("BindText") == 'amp_optic_temp')
		{
		   b.innerHTML = status_optinfo_language['amp_optic_temp_telmex'];
		   continue;
		}
        if (b.getAttribute("BindText") == 'amp_optic_status')
		{
		   b.innerHTML = status_optinfo_language['amp_optic_status_telmex'];
		   continue;
		}
       }
        b.innerHTML = status_optinfo_language[b.getAttribute("BindText")];
    }    
    
    if ( ('TELMEX' == CfgMode.toUpperCase()) || ('GPON' != ontPonMode.toUpperCase()) )        
    {
        setDisplay("DivOltInfo",0);    
        setDisplay("ont_info_head",0);
    }
    else
    {
        setDisplay("DivOltInfo",1);    
        setDisplay("ont_info_head",1);
    }

    if (curWebFrame != 'frame_UNICOM')
    {
        setDisplay("table_ani_linkup_time_info", 0);
        setDisplay("table_ani_linkup_time_content", 0);
    }
    if (curWebFrame == 'frame_UNICOM')
    {
        setDisplay("DivOltInfo", 0);
    }

    if (IsSonetSptUser())
    {
        setDisplay("DivOltInfo", 0);
    }
	
	if (ontPonMode == 'ge' || ontPonMode == 'GE')
	{
	    setDisplay("optic_status_tr", 0);
        setDisplay("DivOltInfo", 0);
		setDisplay("table_ani_linkup_time_info", 0);
        setDisplay("table_ani_linkup_time_content", 0);
	}

    LoadOpticRef();
}

function CheckForm(type)
{    
    with (getElement ("ConfigForm"))
    {
       
    }
    return true;
}

function AddSubmitParam(SubmitForm,type)
{
}

function DeleteAllZero(hexpasswd)
{
    var str;
    var len = hexpasswd.length ;
    var i = len/2;
 
    for (  i ; i >= 0 ; i-- )
    {   
        if((hexpasswd.substring(i*2 - 1, i*2 ) != '0')||(hexpasswd.substring(i*2 - 2, i*2 - 1) != '0'))   
        {                      
            str = hexpasswd.substring(0, i*2); 
            break;
        }
    }        
    
    return str; 
                    
}
function ChangeHextoAscii(hexpasswd)
{
    var str;  
    var str2;
    var len = 0;
    
    len = hexpasswd.length;
    
    if (0 != len%2)
    {
        hexpasswd += "0";
    }
    
    str2 = DeleteAllZero(hexpasswd); 

    str = str2.replace(/[a-f\d]{2}/ig, function(m){
    return String.fromCharCode(parseInt(m, 16));});
    
    return str;
}

function isValidAscii(val)
{
    for ( var i = 0 ; i < val.length ; i++ )
    {
        var ch = val.charAt(i);
        if ( ch < ' ' || ch > '~' )
        {
            return false;
        }
    }
    return true;
}

function conversionblankAscii(val)
{
    var str='';
    for ( var i = 0 ; i < val.length ; i++ )
    {
        var ch = val.charAt(i);
        if ( ch == ' ')
        {
            str+="&nbsp;";
        }
        else
        {
            str+= ch;    
        }
    }
    
    return str;
}

</script>

</head>
<body class="mainbody" onLoad="LoadFrame();">

<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("amp_optinfo_title", 
		GetDescFormArrayById(status_optinfo_language, "amp_optinfo_title_head"), 
		GetDescFormArrayById(status_optinfo_language, "amp_optinfo_title"), false);
</script>

<div class="title_spread"></div>

<div id="ont_info_head" class="func_title"><SCRIPT>document.write(status_optinfo_language["amp_optinfo_ontinfo"]);</SCRIPT></div>

<table id="optic_status_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" style="table-layout:fixed; word-break:break-all">
  <tr > 
  
    <td class="tableTopTitle width_per35">&nbsp;</td>
    <td class="tableTopTitle" BindText='amp_optinfo_cur'></td>
    <td id="ref_head" class="tableTopTitle" BindText='amp_optinfo_ref' style="display:none"></td>
    
  </tr >
  <tr id="optic_status_tr"> 
    <td class="table_title width_per35" BindText='amp_optic_status'></td>
    <td class="table_right"> <script language="javascript" type="text/javascript"> 
            if(status == '')
            {
                  document.write(status_optinfo_language['amp_optic_unknown']);
            }
            else
            {
                if (opticStatus == 1)
 
                {
                    document.write(status_optinfo_language['amp_optic_none']);
                }
                else
                {
                    if ('OFF' == opticPower)
                    {
                        document.write(status_optinfo_language['amp_optic_disable']);
                    }
                    else
                    {
                        if ('enable' == status)
                        {
                            document.write(status_optinfo_language['amp_optic_fault']);
                        }
                        else
                        {
                            document.write(status_optinfo_language['amp_optic_auto']);
                        }
                    }
                }
            } 
             </script> </td>
    <td id="ref_status" class="table_right" BindText='amp_optic_ref' style="display:none"></td>
  </tr >
  <tr> 
    <td class="width_per35 table_title" BindText='amp_optic_txpower'></td>
    <td class="table_right"> <script language="javascript" type="text/javascript">
                  if(opticInfo == null)
                  {
                      document.write(status_optinfo_language['amp_optic_unknown']);
                  }
                  else
                  {
                    document.write(opticInfo.transOpticPower+' dBm');
                  }
                </script> </td>
    <td id="ref_tx" class="table_right"  style="display:none">
    <script language="javascript" type="text/javascript">
    if (ontXGMode == '10g-gpon')
    {
    	document.write(status_optinfo_language['amp_optic_txref_10g']);
    }
    else if (ontXGMode == 'Asymmetric 10g-epon')
    {
    	document.write(status_optinfo_language['amp_optic_txref_10eas']);
    }
    else if (ontXGMode == 'Symmetric 10g-epon')
    {
    	document.write(status_optinfo_language['amp_optic_txref_10es']);
    }
    else
    {
    	document.write(status_optinfo_language['amp_optic_txref']);
    }
    </script>
    </td>
  </tr>
  <tr > 
    <td class="width_per35 table_title" BindText='amp_optic_rxpower'></td>
    <td class="table_right"> <script language="javascript" type="text/javascript">
                  if(opticInfo == null)
                  {
                      document.write(status_optinfo_language['amp_optic_unknown']);
                  }
                  else
                  {
                    document.write(opticInfo.revOpticPower+' dBm');
                  }
                </script> </td>
    <td id="ref_rx" class="table_right" style="display:none"><script language="javascript" type="text/javascript">
                if ((ontPonMode == 'gpon' || ontPonMode == 'GPON'))
                {
                    if (ontXGMode == 'gpon')
                    {
                    
	                    if (opticType == 2)
	                    {
	                        document.write(status_optinfo_language['amp_optic_classc_plus_rxrefg']);
	                    }
	                    else
	                    {
	                        document.write(status_optinfo_language['amp_optic_rxrefg']);
	                    }
                    }
                    else
                    {
                    	document.write(status_optinfo_language['amp_optic_rxref_10g']);
                    }
                }
                else
                {
                    if (ontXGMode == 'epon')
                    {
                    	document.write(status_optinfo_language['amp_optic_rxrefe']);
                    }
                    else
                    {
                    	document.write(status_optinfo_language['amp_optic_rxref_10e']);
                    }
                }
    </script></td>
  </tr>
  <tr > 
    <td class="width_per35 table_title" BindText='amp_optic_voltage'></td>
    <td class="table_right"> <script language="javascript" type="text/javascript">
                  if(opticInfo == null)
                  {
                      document.write(status_optinfo_language['amp_optic_unknown']);
                  }
                  else
                  {
                      document.write(opticInfo.voltage+' mV');
                  }    
                </script> </td>
    <td id="ref_vol" class="table_right" BindText='amp_optic_volref' style="display:none"></td>
  </tr>
  <tr > 
    <td class="width_per35 table_title" BindText='amp_optic_current'></td>
    <td class="table_right"> <script language="javascript" type="text/javascript">
                  if(opticInfo == null)
                  {
                      document.write(status_optinfo_language['amp_optic_unknown']);
                  }
                  else
                  {
                      document.write(opticInfo.bias +' mA');
                  }    
                </script> </td>
    <td id="ref_cur" class="table_right" BindText='amp_optic_curref' style="display:none"></td>
  </tr>
  <tr > 
    <td class="width_per35 table_title" BindText='amp_optic_temp'></td>
    <td class="table_right"> <script language="javascript" type="text/javascript">
                   if(opticInfo == null)
                   {
                     document.write(status_optinfo_language['amp_optic_unknown']);
                   }
                   else
                   {            
                     document.write(opticInfo.temperature+'&nbsp;'+ status_optinfo_language['amp_optic_degree']);
                   }
                </script> </td>
    <td id="ref_temp" class="table_right" BindText='amp_optic_tempref' style="display:none"></td>
  </tr>
  <script type="text/javascript" language="javascript">
  if ((ontPonMode == 'gpon' || ontPonMode == 'GPON') && (ontPonRFNum != '0'))
  {
                     document.write('<tr id="tr1" name="tr1">');
                     document.write('<td  class="width_per35 table_title" id="tr1_1" name="tr1_1">' + status_optinfo_language['amp_optic_catvrx'] + '</td>');
                     document.write('<td  class="table_right" id="tr1_2" name="tr1_2">' + opticInfo.rfRxPower+' dBm' + '</td>');
                     document.write('<td  id="ref_catvrx" class="table_right" id="tr1_3" name="tr1_3" style="display:none">' + status_optinfo_language['amp_optic_catvrxref'] + '</td>');
                     document.write('</tr>');

                     document.write('<tr id="tr2" name="tr2">');
                     document.write('<td  class="width_per35 table_title" id="tr2_1" name="tr2_1">' + status_optinfo_language['amp_optic_catvtx'] + '</td>');
                     document.write('<td  class="table_right" id="tr2_2" name="tr2_2">' + opticInfo.rfOutputPower+' dBmV' + '</td>');
                     document.write('<td  id="ref_catvtx" class="table_right" id="tr2_3" name="tr2_3" style="display:none">' + status_optinfo_language['amp_optic_catvtxref'] + '</td>');
                     document.write('</tr>');                    
  }
  </script>
</table>

<div class="func_spread"></div>

<div id="DivOltInfo">

<div class="func_title"><SCRIPT>document.write(status_optinfo_language["amp_optinfo_oltinfo"]);</SCRIPT></div>

<table id="olt_status_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" style="table-layout:fixed; word-break:break-all">
  <tr > 
    <td class="tableTopTitle width_per35">&nbsp;</td>
    <td class="tableTopTitle" BindText='amp_optinfo_cur'></td>
    <td id="ref_olt_head" class="tableTopTitle" BindText='amp_optinfo_ref' style="display:none"></td>
  </tr >
  <tr > 
    <td class="table_title width_per35" BindText='amp_optic_oltpower'></td>
    <td class="table_right"> <script language="javascript" type="text/javascript">     
    document.write(OltOptic.BudgetClass);
         </script> </td>
    <td id="ref_olt_optic_type" class="table_right" style="display:none">--</td>
  </tr >
    <tr> 
    <td class="width_per35 table_title" BindText='amp_optic_olttxpower'></td>
    <td class="table_right"> <script language="javascript" type="text/javascript">
    
		if(OltOptic.TxPower != '--')
		{
			document.write(OltOptic.TxPower+' dBm');
		}
		else
		{
			document.write(OltOptic.TxPower);
		}
    </script> </td>
    <td id="ref_olt_txpower" class="table_right" style="display:none">
    <script language="javascript" type="text/javascript">
    if(opticInfo != null && opticInfo.revOpticPower == '--')
    {
        document.write('--');
    }
    else if(OltOptic.BudgetClass.toUpperCase() == 'CLASS A')
    {
        document.write(status_optinfo_language['amp_optic_oltclass_a']);
    }
    else if(OltOptic.BudgetClass.toUpperCase() == 'CLASS B')
    {
        document.write(status_optinfo_language['amp_optic_oltclass_b']);
    }
    else if(OltOptic.BudgetClass.toUpperCase() == 'CLASS C')
    {
        document.write(status_optinfo_language['amp_optic_oltclass_c']);
    }
    else if(OltOptic.BudgetClass.toUpperCase() == 'CLASS B+')
    {
        document.write(status_optinfo_language['amp_optic_oltclass_bj']);
    }
    else if(OltOptic.BudgetClass.toUpperCase() == 'CLASS C+')
    {
        document.write(status_optinfo_language['amp_optic_oltclass_cj']);
    }
    else if(OltOptic.BudgetClass == 'N1')
    {
        document.write(status_optinfo_language['amp_optic_xgpon']);
    }
    else if(OltOptic.BudgetClass == 'N2a')
    {
        document.write(status_optinfo_language['amp_optic_xgpon']);
    }
    else if(OltOptic.BudgetClass == 'N2b')
    {
        document.write(status_optinfo_language['amp_optic_xgpon']);
    }
    else if(OltOptic.BudgetClass == 'E1')
    {
        document.write(status_optinfo_language['amp_optic_xgpon']);
    }
    else if(OltOptic.BudgetClass == 'E2a')
    {
        document.write(status_optinfo_language['amp_optic_xgpon']);
    }
    else if(OltOptic.BudgetClass == 'E2b')
    {
        document.write(status_optinfo_language['amp_optic_xgpon']);
    }
    else
    {
        document.write('--');
    }
    
    </script> 
    </td>
    </tr>
    
    <tr id="TrPasswordPon"> 
    <td class="width_per35 table_title" BindText='amp_optic_oltponid'></td>
    <td class="table_right"> 
    <script>    
    if(OltOptic.PONIdentifier =='')
    {
        document.write('--');
    }
    else
    {
        if(isValidAscii(ChangeHextoAscii(OltOptic.PONIdentifier)) == true)
        {
            document.write(conversionblankAscii(ChangeHextoAscii(OltOptic.PONIdentifier))+"&nbsp;"+'('+'0x'+OltOptic.PONIdentifier+')');
        }
        else
        {
            document.write('('+'0x'+OltOptic.PONIdentifier+')');
        }
        
    }
    
    </script>
    </td>
    <td id="ref_olt_portid" class="table_right" style="display:none">--</td>    
    </tr>
</table>

<div class="func_spread"></div>

</div>

<table id="table_ani_linkup_time_info">
    <tr> 
        <td class="tabal_head" colspan="11" BindText='amp_optic_ANIinfo'></td>
    </tr>
</table>
<table id="table_ani_linkup_time_content" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" style="table-layout:fixed; word-break:break-all">
    <tr> 
        <td class="table_title width_per35" BindText='amp_optic_ponlinktime'></td>
        <td class="table_right"><script type="text/javascript" language="javascript">document.write(GetLinkTime());</script></td>
      </tr>
    <tr> 
        <td class="width_per35 table_title" BindText='amp_optic_ponTXpackets'></td>
        <td class="table_right"> <script language="javascript" type="text/javascript">document.write(GetPONTxPackets());</script></td>
    </tr>
    <tr> 
        <td class="width_per35 table_title" BindText='amp_optic_ponRXpackets'></td>
        <td class="table_right"> <script language="javascript" type="text/javascript">document.write(GetPONRxPackets());</script></td>
    </tr>
</table>

</body>
</html>

