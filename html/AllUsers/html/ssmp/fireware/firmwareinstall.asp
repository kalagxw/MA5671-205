<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" type="text/javascript">
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
var curWebFrame = '<%HW_WEB_GetWEBFramePath();%>';

function setAllDisable()
{
	setDisable('f_file',1);
	setDisable('browse',1);
	setDisable('btnBrowse',1);
	setDisable('btnSubmit',1);
}

function GetLanguageDesc(Name)
{
	return ssmpLanguage[Name];
}


function Check_SWM_Status()
{
	var xmlHttp = null;

	if(window.XMLHttpRequest) {
		xmlHttp = new XMLHttpRequest();
	} else if(window.ActiveXObject) {
		xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	}

	xmlHttp.open("GET", "../../get_swm_status.asp", false);
	xmlHttp.send(null);

	var swm_status = xmlHttp.responseText;
	if (swm_status.substr(1,1) == "0") {
		return true;
	} else {
		return false;
	}
}

function LoadFrame()
{
	top.UpgradeFlag = 0;

	if((curWebFrame == 'frame_argentina') &&(curUserType == sysUserType))
	{
		setAllDisable();
	}

}

function CheckForm(type)
{
	with(document.getElementById("ConfigForm"))
	{
	}
	return true;
}

function AddSubmitParam(SubmitForm,type)
{
}

function VerifyFile(FileName)
{
	var File = document.getElementsByName(FileName)[0].value;
	if (File.length == 0)
	{
		AlertEx('Seleccionar un archivo de firmware.');
		return false;
	}
	if (File.length > 128)
	{
		AlertEx('La longitud de la ruta del archivo de firmware no puede superar 128 caracteres.');
		return false;
	}

	return true;
}

function uploadImage()
{
	var uploadForm = document.getElementById("fr_uploadImage");

	if (Check_SWM_Status() == false)
	{
		AlertEx('El sistema está ocupado. Vuelva a intentarlo más tarde.');
		return;
	}

	if (VerifyFile('browse') == false)
	{
	   return;
	}
	top.previousPage = '/html/management/reset_install.asp';
	setDisable('btnSubmit',1);
	uploadForm.submit();
	top.UpgradeFlag = 1;
	setDisable('browse',1);
	setDisable('btnBrowse',1);
}

</script>
<script language="JavaScript" type="text/javascript">
function fchange()
{
	var ffile = document.getElementById("f_file");

	var tfile = document.getElementById("t_file");
	ffile.value = tfile.value;

	var buttonstart = document.getElementById('btnSubmit');
	buttonstart.focus();
	return ;
}

function StartFileOpt()
{
	XmlHttpSendAspFlieWithoutResponse("/asp/StartFileLoad.asp");
}
</script>
</head>

<body class="mainbody" onLoad="LoadFrame();">
	<script language="JavaScript" type="text/javascript">
		HWCreatePageHeadInfo("firmware", GetDescFormArrayById(FirmwareLgeDes, "s0900"), "Proceso de actualización firmware del dispositivo.", false);
	</script>
	<div class="title_spread"></div>
	<form action="Firmwareupload.cgi?RequestFile=html/management/reset_install.asp&FileType=image&RequestToken=<%HW_WEB_GetToken();%>" method="post" enctype="multipart/form-data" name="fr_uploadImage" id="fr_uploadImage">
		<table>
			<tr>
				<td class="filetitle">Archivo firmware:</td>
				<td>
					<div class="filewrap">
						<div class="fileupload">
							<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
							<input type="text" id="f_file" autocomplete="off" readonly="readonly" />
							<input type="file" name="browse" id="t_file" size="1"  onblur="StartFileOpt();" onchange="fchange();" />
							<input id="btnBrowse" type="button" class="CancleButtonCss"  value="Buscar... " />
						</div>
					</div>
				</td>
				<td>
					<input class="CancleButtonCss" name="btnSubmit" id="btnSubmit" type='button' onclick='uploadImage();'  value="Actualizar" />
				</td>
			</tr>
		</table>
	</form>

	<script>
		//ParseBindTextByTagName(FirmwareLgeDes, "td",     1);
		//ParseBindTextByTagName(FirmwareLgeDes, "input",  2);
	</script>

</body>
</html>
