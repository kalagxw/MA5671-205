﻿<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" type="text/javascript">
function OnEndClick() 
{
 
	setDisable('MaintainEnd_button', 1);
	var Form = new webSubmitForm();
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('maintenancend.cgi?FileType=log&RequestFile=html/ssmp/maintain/cudiagnose.asp');
	Form.submit();
 
}
</script>
</head>
<body  class="mainbody"">
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td class="prompt">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td width="100%" class="title_01" style="padding-left: 10px;">
                            点击[维护结束]按钮，系统将修改管理员密码为随机值，并自动把新修改的数据上报到服务器。
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
	
  <table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td> </td> 
    </tr> 
  </table> 
  
  <table  id="MaintenanceButton" width="100%">
  <tr>
  <td >
  	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
  	<input id="MaintainEnd_button" type="button" value="维护结束" onclick="javascript:OnEndClick();" class="submit" /></td>
  </tr>
  </table>

</body>
</html>
