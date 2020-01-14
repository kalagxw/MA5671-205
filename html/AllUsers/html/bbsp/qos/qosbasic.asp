<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="javascript" src="../../bbsp/common/managemode.asp"></script>
<script language="javascript" src="../../bbsp/common/qosinfoe8c.asp"></script>
<title>qos</title>

<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" type="text/javascript">
var E8CQoSMode = "<% HW_WEB_GetFeatureSupport(BBSP_FT_UPLINKQOS);%>";
var QosBasicInfoList = GetQosBasicInfoList();

function CheckQosMode(QosMode)
{
    var QosModeArray ;
    if ("1" == GetCfgMode().SHCT)
    {
        QosModeArray = new Array("TR069","VOICE","IPTV","INTERNET","OTHER");
    }
    else
    {
        QosModeArray = new Array("TR069","VOIP","IPTV","INTERNET","OTHER");
    }
    
    var QosModeTemp = QosMode.split(",");   
    for (i = 0; i < QosModeTemp.length; i++ )
    {
        for (j = i+1; j < QosModeTemp.length; j++ )
        {
            if((QosModeTemp[i]==QosModeTemp[j]) )
            {   
                return false;
            }    
        }
    
        for (var k = 0; k < QosModeArray.length; k++)
        {   
            if( QosModeTemp[i] == QosModeArray[k] )
            {
                break;
            }      
        }
        if(k == QosModeArray.length )
        {
            return false;
        }
    
        if (QosModeTemp[i]== "OTHER" && QosModeTemp.length > 1 )
        {
            return false;
        }   
     
    }
    
    return true;
}
function OnQosApply()
{
    var QosMode;
    
    QosMode = getValue("QMQosModeText");
    QosMode = QosMode.toUpperCase();    
    if(!CheckQosMode(QosMode))
    {
        AlertEx(qos_language['bbsp_qosmodeinvalid']);
        return false;
    }
    
    if ("1" == GetCfgMode().SHCT)
    {
        QosMode = QosMode.replace(new RegExp(/(VOICE)/g),"VOIP")
    }
    
    var QoSEnable = (true == getElement('QoSEnable_checkbox').checked) ? 1 : 0;
    var Form = new webSubmitForm();
    Form.addParameter('x.Enable',QoSEnable);
    Form.addParameter('x.X_HW_Mode',QosMode);
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('set.cgi?' + 'x=InternetGatewayDevice.QueueManagement' + '&RequestFile=html/bbsp/qos/qosbasic.asp');
    setDisable('btnQosBasicApply',1);
    Form.submit();
}

function setQosMode()
{
    var QosMode = getSelectVal('QMQosMode');
    if(QosMode != qos_language['bbsp_selectdd'])
    {
        if ("1" == GetCfgMode().SHCT)
		{
			setText('QMQosModeText',QosMode.replace(new RegExp(/(VOIP)/g),"VOICE"));
		}
		else
		{
			setText('QMQosModeText',QosMode);
		}  
    }   
}

function GetQosBasicData()
{
    if (null == QosBasicInfoList[0])
    {
        getElement('QoSEnable_checkbox').checked = false;
        if (E8CQoSMode == 1)
        {
            setText('QMQosModeText','OTHER');
        }
        else
        {
            setText('QMQosMode','');
        }
    }
    else
    {
        if (1 == QosBasicInfoList[0].Enable)
        {
            getElement('QoSEnable_checkbox').checked = true;
        }
        else
        {
            getElement('QoSEnable_checkbox').checked = false;
        }
       
        if ("1" == GetCfgMode().SHCT)
        {
            setText('QMQosModeText',QosBasicInfoList[0].X_HW_Mode.replace(new RegExp(/(VOIP)/g),"VOICE"));
        }
        else
        {
            setText('QMQosModeText',QosBasicInfoList[0].X_HW_Mode);
        }   
        setSelect('QMQosMode',qos_language['bbsp_selectdd']);
    }
    
}

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
		b.innerHTML = qos_language[b.getAttribute("BindText")];
	}
}

function LoadFrame()
{
	GetQosBasicData();
	loadlanguage();
}
</script>
</head>

<body onLoad="LoadFrame();" class="mainbody"> 
<form id="ConfigForm" action="../application/set.cgi"> 
  <table width="100%" border="0" cellpadding="0" cellspacing="0" id="tabTest"> 
    <tr> 
      <td class="prompt"> <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
          <tr> 
		   <script language="JavaScript" type="text/javascript">
		   if (E8CQoSMode == 1)
		   {
				document.write("<td class='title_common'  BindText='bbsp_qos_e8c_title1'>  </td>");
		   }
		   else
		   {
				document.write("<td class='title_common'  BindText='bbsp_qos_title'>  </td>");
		   }
		   </script> 
          </tr> 
        </table></td> 
    </tr> 
    <tr> 
      <td class="height5p"></td> 
    </tr> 
  </table> 

    <table cellpadding="0" cellspacing="0" width="100%" border="0"> 
        <tr id="QosEnableRow"> 
            <td class="table_title" width="20%" BindText='bbsp_enableqosmh1'></td> 
            <td class="table_right" width="80%"> <input id='QoSEnable_checkbox' name='QoSEnable_checkbox' value='True' type='checkbox' > </td> 
        </tr> 
        <tr id="QosModeRow"> 
          <td class="table_title width_25p" BindText='bbsp_qosmodemh1'></td> 
          <td class="table_right width_75p"> 
              <script language="JavaScript" type="text/javascript">
                document.write('<input id="QMQosModeText" type="text" name="QMQosModeText" style="width: 194px"><font color="red">*</font>');
                document.write('<select id="QMQosMode" name="QMQosMode" size="1" onChange="setQosMode();">');
                document.write('<option value=' + qos_language['bbsp_selectdd'] + '>' + qos_language['bbsp_selectdd'] + '</option>');   
                document.write('<option value="INTERNET,TR069">INTERNET,TR069</option>');
                
                if ("1" == GetCfgMode().SHCT)
                {
                    document.write('<option value="INTERNET,TR069,VOIP">INTERNET,TR069,VOICE</option> ');
                }
                else
                {
                    document.write('<option value="INTERNET,TR069,VOIP">INTERNET,TR069,VOIP</option> ');
                }
			  </script> 
			  <option value="INTERNET,TR069,IPTV">INTERNET,TR069,IPTV</option> 
			  <script language="JavaScript" type="text/javascript">                  
						if ((GetCfgMode().JSCT == "1") || (GetCfgMode().SZCT == "1"))
						{
							if ("1" == GetCfgMode().SHCT)
							{
								document.write("<option value='INTERNET,TR069,IPTV,VOIP'>INTERNET,TR069,IPTV,VOICE</option>");
								document.write("<option value='INTERNET,TR069,VOIP,IPTV'>INTERNET,TR069,VOICE,IPTV</option>");
							}
							else
							{
								document.write("<option value='INTERNET,TR069,IPTV,VOIP'>INTERNET,TR069,IPTV,VOIP</option>");
								document.write("<option value='INTERNET,TR069,VOIP,IPTV'>INTERNET,TR069,VOIP,IPTV</option>");	
							}
						}
						else
						{
							if ("1" == GetCfgMode().SHCT)
							{
								document.write("<option value='INTERNET,TR069,VOIP,IPTV'>INTERNET,TR069,VOICE,IPTV</option>");
							}
							else
							{
								document.write("<option value='INTERNET,TR069,VOIP,IPTV'>INTERNET,TR069,VOIP,IPTV</option>");
							}
						}
						</script>
			  <script language="JavaScript" type="text/javascript">
						if ("1" == GetCfgMode().SHCT)
						{
							document.write('<option value="TR069,VOIP,IPTV,INTERNET">TR069,VOICE,IPTV,INTERNET</option> ');
						}
						else
						{
							document.write('<option value="TR069,VOIP,IPTV,INTERNET">TR069,VOIP,IPTV,INTERNET</option> ');
						}
			  </script> 
	
			  <option value="OTHER">OTHER</option> 
			</select> </td> 
		</tr> 
	</table>	
	 <table cellpadding="0" cellspacing="1" width="100%" class="table_button"> 
    <tr> 
      <td align="right"> 
	 	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	  	<button id="btnQosBasicApply" name="btnQosBasicApply" type="button" class="submit" onClick="OnQosApply();"><script>document.write(qos_language['bbsp_app']);</script></button> 
	</td> 
    </tr> 	
  </table> 
</form>
</body>
</html>