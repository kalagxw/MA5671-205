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
  
}

function ImportACBtnClick()
{	
	var Form = new webSubmitForm();
	Form.addParameter('x.X_HW_EnableCertificate',1);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));	
    Form.setAction('set.cgi?x=InternetGatewayDevice.ManagementServer'
                         + '&RequestFile=html/ssmp/tr069/certinpute8c.asp');
                         
    setDisable('ImportACBtn_button',1);
    Form.submit();
}

</script>
</head>

<body class="mainbody" onLoad="LoadFrame();">

<div class="title_with_desc">受信任的权威认证(CA)证书</div>
<div class="title_01"  style="padding-left:10px;" width="100%"><label>最多1个证书能被存储。</label></div>
<div class="func_spread"></div>
<div class="table_submit" align="center">
  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
  <input name="ImportACBtn_button" id="ImportACBtn_button" type="button" class="submit" value="导入证书" onClick="ImportACBtnClick();">
</div>

</body>
</html>

