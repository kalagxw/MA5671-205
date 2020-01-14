<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
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

        b.innerHTML = status_optinfo_language[b.getAttribute("BindText")];
    }
}
</script>

</head>
<body class="mainbody" onLoad="LoadFrame();">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="prompt">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="title_common" BindText='amp_optinfo_title'></td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr ><td class="height5p"></td></tr>
</table>
<table id="ont_info_head">
    <tr> 
        <td class="tabal_head" colspan="11" BindText='amp_optinfo_ontinfo'></td>
    </tr>
</table>
<table id="optic_status_table" width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" style="table-layout:fixed; word-break:break-all">
  <tr > 
    <td class="table_title width_per35">&nbsp;</td>
    <td class="table_right" BindText='amp_optinfo_cur'></td>
    <td id="ref_head" class="table_right" BindText='amp_optinfo_ref'></td>
  </tr >
  <tr > 
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
    <td id="ref_status" class="table_right" BindText='amp_optic_ref'></td>
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
    <td id="ref_tx" class="table_right">
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
    <td id="ref_rx" class="table_right" ><script language="javascript" type="text/javascript">
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
    <td id="ref_vol" class="table_right" BindText='amp_optic_volref' ></td>
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
    <td id="ref_cur" class="table_right" BindText='amp_optic_curref'></td>
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
                     document.write(opticInfo.temperature+'&nbsp;'+'℃');
                   }
                </script> </td>
    <td id="ref_temp" class="table_right" BindText='amp_optic_tempref' ></td>
  </tr>
  <script type="text/javascript" language="javascript">
  if ((ontPonMode == 'gpon' || ontPonMode == 'GPON') && (ontPonRFNum != '0'))
  {
                     document.write('<tr id="tr1" name="tr1">');
                     document.write('<td  class="width_per35 table_title" id="tr1_1" name="tr1_1">' + status_optinfo_language['amp_optic_catvrx'] + '</td>');
                     document.write('<td  class="table_right" id="tr1_2" name="tr1_2">' + opticInfo.rfRxPower+' dBm' + '</td>');
                     document.write('<td  id="ref_catvrx" class="table_right" id="tr1_3" name="tr1_3" >' + status_optinfo_language['amp_optic_catvrxref'] + '</td>');
                     document.write('</tr>');

                     document.write('<tr id="tr2" name="tr2">');
                     document.write('<td  class="width_per35 table_title" id="tr2_1" name="tr2_1">' + status_optinfo_language['amp_optic_catvtx'] + '</td>');
                     document.write('<td  class="table_right" id="tr2_2" name="tr2_2">' + opticInfo.rfOutputPower+' dBmV' + '</td>');
                     document.write('<td  id="ref_catvtx" class="table_right" id="tr2_3" name="tr2_3" >' + status_optinfo_language['amp_optic_catvtxref'] + '</td>');
                     document.write('</tr>');                    
  }
  </script>
</table>

</body>
</html>

