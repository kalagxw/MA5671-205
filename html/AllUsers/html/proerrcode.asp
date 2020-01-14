<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/util.js"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(errdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var DefaultLang = "<%HW_WEB_GetCurrentLanguage();%>";
var ErrCode = "<%HW_WEB_GetProRetCode();%>";
ErrInfo = getErrStrId(ErrCode);

/*该函数用于处理来自ONT发送的错误码
  ONT会向网页传错误字串的错误码：  
*/
function getErrStrId(ErrStr)
{
	var OutStr;
    var ErrData = GetLanguageDesc("s" + ErrStr);
    if ('string' != typeof(ErrData))
    {
	    //找不到错误码提示“内部错误”
		ErrData = GetLanguageDesc("s0xf7205001");
    }
	
	OutStr = errLanguage['errbasecode'] +":" + "&nbsp;" + ErrData;
	return OutStr;
}

function GetLanguageDesc(Name)
{
    return errLanguage[Name];
}

function LoadFrame() 
{
    top.SaveDataFlag = 0;
}

function Init()
{
    var ErrID = document.getElementById("err_info");    
    ErrID.innerHTML = ErrInfo;
}

function Return()
{
    window.history.go(-1);
}

</script>
</head>
<body class="mainbody">
<form action="" method="post" enctype="multipart/form-data" name="fr_uploadImage" id="fr_uploadImage">
 <div>
 <table width="100%" height="10%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td class="PageTitle_content">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="13%" align="center"><img src="../../../images/error.gif" width="48" height="48" /></td>
            <td width="87%">
			<script language="JavaScript" type="text/javascript">
				document.write(ErrInfo);
			</script>
			</td>
		  </tr>
        </table>
		</td>
      </tr>
 </table>
 </div>
</form>

</body>
</html>
