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

function stOpticInfo(domain,transOpticPower,revOpticPower,voltage,temperature,bias)
{
    this.domain = domain;
	this.transOpticPower = transOpticPower;
	this.revOpticPower = revOpticPower;
	this.voltage = voltage;
	this.temperature = temperature;
	this.bias = bias;
}

function stDeviceInfo(domain,DevType)
{
	this.domain = domain;
	this.DevType = DevType;
}


var opticInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_DEBUG.AMP.Optic,TxPower|RxPower|Voltage|Temperature|Bias, stOpticInfo);%>; 
var opticInfo = opticInfos[0];
var status = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.GetOptTxMode.TxMode);%>';
var deviceInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo, X_HW_UpPortMode, stDeviceInfo);%>; 
var deviceInfo = deviceInfos[0];

function LoadFrame()
{ 
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
</script>
</head>

<body class="mainbody" onLoad="LoadFrame();">

<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("amp_optinfo_title", 
		GetDescFormArrayById(status_optinfo_language, "amp_optinfo_title_head"), 
		GetDescFormArrayById(status_optinfo_language, "amp_optinfo_title_pccw"), false);
</script>

<div class="title_spread"></div>

<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
  <tr > 
    <td width="33%" class="table_title"> <table border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="99%">Status</td>
          <td>:</td>
        </tr>
      </table></td>
    <td class="table_right"> <script language="javascript" type="text/javascript"> 
		    if((status == 'enable') || (status == 'Enable') || (status == 'ENABLE'))
		    {
		  	    document.write('Enable');
		    } 
			else if((status == 'disable') || (status == 'Disable') || (status == 'DISABLE'))
		    {
		  	    document.write('Disable');
		    } 
		    else if((status == 'auto') || (status == 'Auto') || (status == 'AUTO'))
		    {
		  	    document.write('Auto');
		    } 
			else
			{
		  	    document.write('unknown');
			}
             </script> </td>
  </tr >
  <tr> 
    <td width="33%" class="table_title"> <table border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="99%">Tx</td>
          <td>:</td>
        </tr>
      </table></td>
    <td class="table_right"> <script language="javascript" type="text/javascript">
                  if(opticInfo == null)
    			  {
    			  	document.write('unknown');
    			  }
    			  else
    			  {
    				document.write(opticInfo.transOpticPower);
    			  }
			    </script> </td>
  </tr>
  <tr > 
    <td width="33%" class="table_title"> <table border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="99%">Rx</td>
          <td>:</td>
        </tr>
      </table></td>
    <td class="table_right"> <script language="javascript" type="text/javascript">
				  if(opticInfo == null)
				  {
				  	document.write('unknown');
				  }
				  else
				  {
					document.write(opticInfo.revOpticPower);
				  }
				</script> </td>
  </tr>
  <tr > 
    <td width="33%" class="table_title"> <table border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="99%">Voltage</td>
          <td>:</td>
        </tr>
      </table></td>
    <td class="table_right"> <script language="javascript" type="text/javascript">
        		  if(opticInfo == null)
        		  {
        		  	document.write('unknown');
        		  }
        		  else
        		  {
        		  	document.write(opticInfo.voltage/1000.000);
        		  }	
				</script> </td>
  </tr>
  <tr > 
    <td width="33%" class="table_title"> <table border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="99%">Bias</td>
          <td>:</td>
        </tr>
      </table></td>
    <td class="table_right"> <script language="javascript" type="text/javascript">
        		  if(opticInfo == null)
        		  {
        		  	document.write('unknown');
        		  }
        		  else
        		  {
        		  	document.write(opticInfo.bias);
        		  }	
				</script> </td>
  </tr>
  <tr > 
    <td width="33%" class="table_title"> <table border="0" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="99%">Laser</td>
          <td>:</td>
        </tr>
      </table></td>
    <td class="table_right"> <script language="javascript" type="text/javascript">
				   if(opticInfo == null)
				   {
					 document.write('unknown');
				   }
				   else
                   {            
				     document.write(opticInfo.temperature);
				   }
				</script> </td>
  </tr>
</table>
</body>
</html>
