<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../js/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<title>igmp</title>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
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
		b.innerHTML = igmp_language[b.getAttribute("BindText")];
	}
}


function stIGMPInfo(domain,IGMPEnable,ProxyEnable,SnoopingEnable,Robustness,GenQueryInterval,GenResponseTime,SpQueryNumber,SpQueryInterval,SpResponseTime,STBNumber)
{
    this.domain = domain;
    this.IGMPEnable = IGMPEnable;
}

var IGMPInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.X_HW_IPTV, IGMPEnable|ProxyEnable|SnoopingEnable|Robustness|GenQueryInterval|GenResponseTime|SpQueryNumber|SpQueryInterval|SpResponseTime|STBNumber,stIGMPInfo);%>; 
var IGMPInfo = IGMPInfos[0];

function LoadFrame()
{
 	if ( null != IGMPInfo )
	{
		  if('1' == IGMPInfo.IGMPEnable)
		 {
		       setSelect('IGMPEnable',"Enable");
		 }		
			
		  if ('0' == IGMPInfo.IGMPEnable)
		  {
		      setSelect('IGMPEnable',"Disable");
		}
	}
	
	loadlanguage();
}

function IGMPEnableChange()
{
    var igmpenable = getSelectVal('IGMPEnable');
		if (igmpenable == "Enable")
		{
    		setSelect('IGMPEnable',"Enable");
		}
		else
		{
	        setSelect('IGMPEnable',"Disable");
		}
	
}

function CheckForm(type)
{  
    return true;   
}


function AddSubmitParam(SubmitForm,type)
{
    var value = getSelectVal('IGMPEnable');
	if (value == "Enable")
	{
	     SubmitForm.addParameter('x.IGMPEnable',1);
	}
	else
	{
	    SubmitForm.addParameter('x.IGMPEnable',0);	
	}
    SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));	
    SubmitForm.setAction('set.cgi?x=InternetGatewayDevice.Services.X_HW_IPTV'
                         + '&RequestFile=html/bbsp/igmp/igmpenablee8c.asp');
    setDisable('btnApply',1);
    setDisable('cancelValue',1);
}


function CancelConfig()
{
    LoadFrame();
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody">
<form id="ConfigForm" action="../network/set.cgi">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" id="tabTest">
    <tr>
    	<td class="prompt">
        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="100%" style="padding-left:10px;" class="title_01" BindText='bbsp_igmp_title'> 
          </tr>
          </table>
        </td> 
    </tr>
	<tr><td height="5px"></td></tr>
</table>

    <table cellpadding="0" cellspacing="1" width="100%" class="tabal_bg">
	    <tr>
            <td width="25%" class="table_title" BindText='bbsp_enableigmpenablemh'></td>
            <td width="75%" class="table_right">
            	<select id="IGMPEnable" name="IGMPEnable" style="width: 135px" 
                    onChange="IGMPEnableChange()">
                              <option value="Disable"><script>document.write(igmp_language['bbsp_disable']);</script></option>
                              <option value="Enable"><script>document.write(igmp_language['bbsp_enable']);</script></option>
              </select> 
            </td>
        </tr>
       
    </table>
     <table cellpadding="0" cellspacing="1" width="100%" class="table_button">
     	<tr>
		    <td width="25%"></td>
            <td class="table_submit">
            	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
				<button id="btnApply" name="btnApply" type="button" class="submit" onClick="Submit();"><script>document.write(igmp_language['bbsp_app']);</script></button>
                <button name="cancelValue" id="cancelValue" class="submit"  type="button" onClick="CancelConfig();"><script>document.write(igmp_language['bbsp_cancel']);</script></button>
            </td>
            
        </tr>        
    </table>

</form>

</body>
</html>
