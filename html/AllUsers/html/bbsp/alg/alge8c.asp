<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>ALG</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var curUserType='<%HW_WEB_GetUserType();%>';

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
		b.innerHTML = alg_language[b.getAttribute("BindText")];
	}
}

function stAlg(domain,FTPEnable,TFTPEnable,H323Enable,PptpEnable,L2TPForward,IPSecForward,SipEnable,RTSPEnable,RTCPEnable,RTCPPort)
{
	this.domain = domain;	
	this.FTPEnable = FTPEnable;
	this.TFTPEnable = TFTPEnable;
	this.H323Enable = H323Enable;
	this.PptpEnable = PptpEnable;
	this.L2TPForward = L2TPForward;	
	this.IPSecForward = IPSecForward;
	this.SipEnable  = SipEnable;
	this.RTSPEnable = RTSPEnable;			
	this.RTCPEnable = RTCPEnable;
	this.RTCPPort = RTCPPort;
} 
var algArray = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_ALG,FtpEnable|TftpEnable|H323Enable|PptpEnable|L2TPForward|IPSecForward|SipEnable|RTSPEnable|RTCPEnable|RTCPPort,stAlg);%>;  
var alg = algArray[0];

function rtspEnableClick()
{
	var bEnable = getCheckVal('RTSPEnable_checkbox');
	setDisplay('rtcptable_div', bEnable);
}

function LoadFrame()
{
	with (getElement('ConfigForm'))
	{
	    if (alg != null)
		{
    		setCheck('FTPEnable_checkbox',alg.FTPEnable);
    		setCheck('TFTPEnable',alg.TFTPEnable);
    		setCheck('H323Enable_checkbox',alg.H323Enable);
			setCheck('PPTPEnable_checkbox',alg.PptpEnable);
			setCheck('L2TPEnable_checkbox',alg.L2TPForward);
			setCheck('IPSECEnable_checkbox',alg.IPSecForward);

			setCheck('SIPEnable_checkbox',alg.SipEnable);
			setCheck('RTSPEnable_checkbox',alg.RTSPEnable);						
			setCheck('RTCPEnable',alg.RTCPEnable);
			setText('RTCPPort', alg.RTCPPort)
			rtspEnableClick();
        }
	} 
	
	if(curUserType != '0')
    {
		setDisable("FTPEnable_checkbox",1);
    	setDisable("TFTPEnable",1);			
		setDisable("H323Enable_checkbox",1);
		setDisable("PPTPEnable_checkbox",1);
		setDisable("L2TPEnable_checkbox",1);
		setDisable("IPSECEnable_checkbox",1);
		setDisable("SIPEnable_checkbox",1);
		setDisable("RTSPEnable_checkbox",1);
		setDisable("RTCPEnable",1);
		setDisable("RTCPPort",1);
		setDisable("SaveApply_button",1);
	}
	loadlanguage(); 
}

function AddSubmitParam(SubmitForm,type)
{
	var RTCPPort = getValue("RTCPPort");
	RTCPPort = removeSpaceTrim(RTCPPort);
	
	SubmitForm.addParameter('x.FtpEnable', getCheckVal('FTPEnable_checkbox'));
	SubmitForm.addParameter('x.TftpEnable',getCheckVal('TFTPEnable'));
	SubmitForm.addParameter('x.H323Enable',getCheckVal('H323Enable_checkbox'));
	SubmitForm.addParameter('x.SipEnable',getCheckVal('SIPEnable_checkbox'));
	SubmitForm.addParameter('x.RTSPEnable',getCheckVal('RTSPEnable_checkbox'));
	SubmitForm.addParameter('x.PptpEnable',getCheckVal('PPTPEnable_checkbox'));
	SubmitForm.addParameter('x.L2TPForward',getCheckVal('L2TPEnable_checkbox'));
	SubmitForm.addParameter('x.IPSecForward',getCheckVal('IPSECEnable_checkbox'));
	SubmitForm.addParameter('x.RTCPEnable',getCheckVal('RTCPEnable'));
	SubmitForm.addParameter('x.RTCPPort',RTCPPort);
	SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));

	SubmitForm.setAction('set.cgi?x=InternetGatewayDevice.X_HW_ALG'
		                     + '&RequestFile=html/bbsp/alg/alge8c.asp');
    setDisable('SaveApply_button',1);
}

function CheckForm(type)
{
	var RTCPPort = getValue("RTCPPort");
	RTCPPort = removeSpaceTrim(RTCPPort);
	if(RTCPPort!="")
	{
       if ( false == CheckNumber(RTCPPort, 0, 65535) )
       {
         AlertEx(alg_language['bbsp_portranginvalid']);
         return false;
       }
    }
    else
    {
  	   RTCPPort = 0;
    }
    return true;
}

function ChangeLevel(level)
{		

}


</script>

</head>
<body onLoad="LoadFrame();" class="mainbody">
<form id="ConfigForm" action="">
	<table cellpadding="0" cellspacing="1" width="100%"> 
		<tr>
			<td  class="align_left title_common" width="100%" BindText='bbsp_alg_title1'></td> 
		</tr>
		<tr> 
			<td class="height10p"></td> 
		</tr> 
	</table>
  
    <table width="100%" cellpadding="0" cellspacing="0">
		<tr >
            <td class="table_title"> 
                <input type='checkbox'  id='H323Enable_checkbox' name='H323Enable_checkbox' value="True"/>
				<script>document.write(alg_language['bbsp_enableh323']);</script>
            </td>
        </tr>  
		
		<tr >
            <td class="table_title"> 
                <input type='checkbox' id='RTSPEnable_checkbox' name='RTSPEnable_checkbox'  value="True" onclick='rtspEnableClick();'/>
          		<script>document.write(alg_language['bbsp_enablertsp']);</script>
		    </td>
        </tr>  
		
		<tr >
            <td class="table_title"> 
                <input type='checkbox' id='L2TPEnable_checkbox' name='L2TPEnable_checkbox' value="True"/>
				<script>document.write(alg_language['bbsp_enablel2tp']);</script>
            </td>
        </tr> 
		
		<tr >
            <td class="table_title"> 
                <input type='checkbox' id='IPSECEnable_checkbox' name='IPSECEnable_checkbox' value="True" />
				<script>document.write(alg_language['bbsp_enableipsec']);</script>
            </td>
        </tr> 	
		
		 <tr >
            <td class="table_title"> 
                <input type='checkbox'  id='SIPEnable_checkbox' name='SIPEnable_checkbox' value="True"/>
				<script>document.write(alg_language['bbsp_enablesip']);</script>
            </td>
        </tr> 
	
        <tr>
            <td class="table_title"> 
                <input type='checkbox'  id='FTPEnable_checkbox' name='FTPEnable_checkbox' value="True"/>
				<script>document.write(alg_language['bbsp_enableftp']);</script>
            </td>
        </tr>
		
		<tr >
            <td class="table_title"> 
                <input type='checkbox' id='PPTPEnable_checkbox' name='PPTPEnable_checkbox' value="True"/>
				<script>document.write(alg_language['bbsp_enablepptp']);</script>
            </td>
        </tr> 

        <tr >
            <td class="table_title"> 
                <input type='checkbox'  id='TFTPEnable' name='TFTPEnable' value="True"/>
				<script>document.write(alg_language['bbsp_enabletftp']);</script>
            </td>
        </tr>
	</table>
	<div id="rtcptable_div">
		<table width="100%" cellpadding="0" cellspacing="0">
        <tr >
            <td class="table_title" > 
  				<input type='checkbox' id='RTCPEnable' name='RTCPEnable' value="True"/> 
				<script>document.write(alg_language['bbsp_enablertcp']);</script>
		    </td>
			<td class="table_title">
				<LABEL><script>document.write(alg_language['bbsp_nport']);</script></LABEL>
				<input type='text' id='RTCPPort' name='RTCPPort' maxlength='5' size='5'/>
			</td>
			<td  class="table_title" width="40%"></td>
        </tr>                     
      </table>
	</div>
        
	<script>
		getElById('FTPEnable_checkbox').title = alg_language['bbsp_ftptitle'];
		getElById('TFTPEnable').title = alg_language['bbsp_tftptitle'];
		getElById('H323Enable_checkbox').title = alg_language['bbsp_h323title'];
		getElById('SIPEnable_checkbox').title = alg_language['bbsp_siptitle'];
		getElById('RTSPEnable_checkbox').title = alg_language['bbsp_rtsptitle'];
		getElById('RTCPEnable').title = alg_language['bbsp_rtcptitle'];
		getElById('RTCPPort').title = alg_language['bbsp_rtctitle'];
		getElById('PPTPEnable_checkbox').title = alg_language['bbsp_pptptitle'];
		getElById('L2TPEnable_checkbox').title = alg_language['bbsp_l2tptitle'];
		getElById('IPSECEnable_checkbox').title = alg_language['bbsp_ipsectitle'];
	</script>

   <table  width="100%" class="table_button">
     <tr align="right">
		<td>
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
			<button id="SaveApply_button" name="SaveApply_button" type="button" class="submit" onClick="Submit(1);"><script>document.write(alg_language['bbsp_saveApp']);</script></button>
		</td>
	</tr>
   </table>
</form>
</body>
</html>
