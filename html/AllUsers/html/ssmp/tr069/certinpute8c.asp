<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title></title>
<script language="JavaScript" type="text/javascript">

function LoadFrame()
{
	if( ( window.location.href.indexOf("e8c_certification.cgi?") > 0) )
	{
		AlertEx("证书导入成功！");
	}
}

function ImportACBtnClick()
{	
	var Form = new webSubmitForm();
	var Certificate_text = document.getElementById("Certificate_text").value;
	if(Certificate_text == "")
	{
		AlertEx("请粘贴证书内容！");
		return;
	}
	Certificate_text = Certificate_text.replace(new RegExp(/(\n)/g),"<br>")
	Form.addParameter('x.certificationcontent',Certificate_text);  
	Form.setAction('e8c_certification.cgi?x=InternetGatewayDevice.ManagementServer'
                         + '&RequestFile=html/ssmp/tr069/certinpute8c.asp');
                         
   
    setDisable('CertificateApply_button',1);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.submit();
}

</script>

</head>
<body class="mainbody" onLoad="LoadFrame();">

<div class="title_with_desc"><label>导入CA证书</label></div>
<div class="title_01"  style="padding-left:10px;" width="100%"><label>请粘贴证书内容</label></div>
<div class="func_spread"></div>

<div id="DivSaveImportAC">
  <table width="100%" border="0" cellpadding="0" cellspacing="0"> 
	<tr> 
      <td align="left">证书名：</td> 
      <td  > <input style="width:80px;" name='CertImportName_text' type='text' id="CertImportName_text" size="20" value="tr069证书" disabled="disabled" maxlength="256"> 
      </td> 
    </tr>
	<tr > 
      <td align="left">证书：</td> 
      <td><textarea style="height:300px;width:550px;" type='text' name='Certificate_text' id="Certificate_text"></textarea>
      </td> 
    </tr> 	
  </table>
<div class="button_spread"></div> 
<table id="DivSaveAC" width="100%" border="0" cellspacing="0" cellpadding="0" class="table_button">
<tr>
<td width="25%"></td>
  <td class="table_submit" align="center">
  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
  <input name="CertificateApply_button" id="CertificateApply_button" type="button" class="submit" value="保存/应用" onClick="ImportACBtnClick();">
</tr>
</table>  
</div>


</body>
</html>

