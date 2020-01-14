<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<title>User Device Information</title>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../../amp/common/wlan_list.asp"></script>
<script language="javascript" src="../common/lanuserinfo.asp"></script>
<script language="JavaScript" type="text/javascript">
var list = 5;
var MAX_DEV_TYPE=16;
var MAX_HOST_TYPE=16;


var firstpage = 1;
var page = firstpage;
var lastpage = 0;
var DHCPLeaseTimes = new Array();
var UserDevices = new Array();

function IsValidPage(pagevalue)
{
	if (true != isInteger(pagevalue))
	{
		return false;
	}
	return true;
}

function initFirstPage(UserDevicesnum)
{
	if(UserDevicesnum == 0)
	{
		firstpage = 0;
	}

	page = firstpage;

	if( window.location.href.indexOf("?") > 0)
	{
	  page = parseInt(window.location.href.split("?")[1],10); 
		if (false == IsValidPage(page))
		{
		    if( window.location.href.indexOf("x=InternetGatewayDevice.LANDevice.1.X_HW_UserDev") <= 0)
		    {		    
			    AlertEx(userdevinfo_language['bbsp_faulturl']);		
			    page = (0 == UserDevicesnum) ? 0:1;
			}
		}
	}

	lastpage = UserDevicesnum/list;
	if(lastpage != parseInt(lastpage,10))
	{
		lastpage = parseInt(lastpage,10) + 1;	
	}

	if( window.location.href.indexOf("?") > 0)
	{
		var href = window.location.href.split("?")[1];
	
		if( window.location.href.indexOf("x=InternetGatewayDevice.LANDevice.1.X_HW_UserDev") > 0)
		{	
			page = window.location.href.split("?")[2].split('&')[0]; 
		}
		else
		{	
		    page = href;
		}
	}

	if( page > lastpage )
	{
		page = lastpage;
	}
}

function submit1(index)
{
	if (false == IsValidPage(page))
	{
		AlertEx(userdevinfo_language['bbsp_faulturl']);
		return;
	}
	window.location="userdetdevinfo.asp?" + index +  "?" + parseInt(page,10);
}

function submit2(index)
{
	var shell = null;
	var index_s=index.split("_")[1];
	var address = "\\\\"+UserDevices[index_s].IpAddr;
	try
	{
        shell = new ActiveXObject("wscript.shell");
    }
	catch(exception)
	{
		AlertEx(userdevinfo_language['bbsp_explorertooh']+"\r\n\r\n" +userdevinfo_language['bbsp_youcaninput']+"\""+address+"\""+userdevinfo_language['bbsp_accesscom']);
		return false;
	}
	shell.run("explorer "+address);
}

function submit3(index)
{
	var index_a=index.split("_")[1];

	if (false == IsValidPage(page))
	{
		AlertEx(userdevinfo_language['bbsp_faulturl']);
		return;
	}
	
	window.location="netapp.asp?" + UserDevices[index_a].IpAddr + "?"+ UserDevices[index_a].MacAddr + "?" + UserDevices[index_a].PortType + "?" + UserDevices[index_a].Port + "?" + parseInt(page,10); 
}


function submit4(index)
{
	var index_a=index.split("_")[1];
		
	if (ConfirmEx(userdevinfo_language['bbsp_devinfodelconfirm'])) 
	{
		var Form = new webSubmitForm();
		Form.addParameter(UserDevices[index_a].Domain,'');
		if (false == IsValidPage(page))
		{
			AlertEx(userdevinfo_language['bbsp_faulturl']);
			return;
		}
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.setAction('del.cgi?' +'x=InternetGatewayDevice.LANDevice.1.X_HW_UserDev' + '?' + parseInt(page,10) + '&RequestFile=html/bbsp/userdevinfo/userdevinfo.asp');
		Form.submit();
		DisableRepeatSubmit();
	}
}

function appendstr(str)
{
	return str;
}
function shoulist(startlist , endlist, UserDevicesInfo)
{
	var outputlist = "";
	if( 0 == UserDevicesInfo.length - 1 )
	{
		outputlist = outputlist + appendstr("<tr class=\"tabal_center01\">");
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr('<td >'+'--'+'</td>');
		outputlist = outputlist + appendstr("</tr>");

		$("#devlist").append(outputlist);
		return;
	}

	for(i=startlist;i <= endlist - 1;i++)   
	{
		if (UserDevicesInfo[i].Port.toUpperCase().indexOf("SSID") >=0)
		{	
			var ssidindex = UserDevicesInfo[i].Port;	
			ssidindex = ssidindex.charAt(ssidindex.length-1);
			if (1 == isSsidForIsp(ssidindex) || 1 == IsRDSGatewayUserSsid(ssidindex))
			{
				continue;
			}
		}
		
		outputlist = outputlist + appendstr("<tr class=\"tabal_center01 trTabContent\" >");
		if(('--' == UserDevicesInfo[i].HostName) && ("1" == GetCfgMode().TELMEX))
		{
		    outputlist = outputlist + appendstr('<td >'+ UserDevicesInfo[i].MacAddr +'</td>');
		}
		else
		{
		    outputlist = outputlist + appendstr('<td style="width:15%">'+GetStringContent(UserDevicesInfo[i].HostName, MAX_HOST_TYPE) +'</td>');
		}

		
		outputlist = outputlist + appendstr('<td style="width:20%">'+GetStringContent(UserDevicesInfo[i].DevType, MAX_DEV_TYPE) +'</td>');
		outputlist = outputlist + appendstr('<td style="width:15%">'+UserDevicesInfo[i].IpAddr	  +'</td>');
		outputlist = outputlist + appendstr('<td style="width:15%">'+UserDevicesInfo[i].MacAddr	  +'</td>');
		outputlist = outputlist + appendstr('<td style="width:10%">'+userdevinfo_language[UserDevicesInfo[i].DevStatus]  +'</td>');		
		outputlist = outputlist + appendstr('<td style="width:25%">');
		outputlist = outputlist + appendstr('<button name="btnApply" id='+ i +'  type="button" class="pix_70_130 submit_bbspuser1"  onClick="submit1(this.id);">'+ '&nbsp;');
		outputlist = outputlist + appendstr(userdevinfo_language['bbsp_detinfo']);
		outputlist = outputlist + appendstr('</button>');
		outputlist = outputlist + appendstr('<br />');	
		if ('ONLINE' != UserDevicesInfo[i].DevStatus.toUpperCase())
		{
		    outputlist = outputlist + appendstr('<button name="btnApply" id=share_'+ i +'  type="button"  class="pix_70_130 submit_bbspuser1"  onClick="submit4(this.id);">'+ '&nbsp;');
		    outputlist = outputlist + appendstr(userdevinfo_language['bbsp_delete']);
		    outputlist = outputlist + appendstr('</button>');
		    outputlist = outputlist + appendstr('<br />');
		}
		else
		{	
			if("1" != GetCfgMode().PTVDF)
			{
				outputlist = outputlist + appendstr('<button name="btnApply" id=share_'+ i +'  type="button"  class="pix_70_130 submit_bbspuser1"  onClick="submit2(this.id);">'+ '&nbsp;');
				outputlist = outputlist + appendstr(userdevinfo_language['bbsp_comaccess']);
				outputlist = outputlist + appendstr('</button>');
				outputlist = outputlist + appendstr('<br />');
			}
		}
		outputlist = outputlist + appendstr('<button name="btnApply" id=netapp_'+ i +'  type="button" class="pix_70_130 submit_bbspuser1"  onClick="submit3(this.id);">'+ '&nbsp;');
		outputlist = outputlist + appendstr(userdevinfo_language['bbsp_netapp']);
		outputlist = outputlist + appendstr('</button>');
		outputlist = outputlist + appendstr('</td>');
		outputlist = outputlist + appendstr("</tr>");
	}

	$("#devlist").append(outputlist);
}

function showlistcontrol(UserDevicesInfo)
{
	if(UserDevicesInfo.length - 1 == 0)
	{
		shoulist(0 , 0, UserDevicesInfo);
	}
	else if( UserDevicesInfo.length - 1 >= list*parseInt(page,10) )
	{
		shoulist((parseInt(page,10)-1)*list , parseInt(page,10)*list, UserDevicesInfo);
	}
	else
	{
		shoulist((parseInt(page,10)-1)*list , UserDevicesInfo.length - 1, UserDevicesInfo);
	}
}

function submitfirst()
{
	page = firstpage;
	
	if (false == IsValidPage(page))
	{
		AlertEx(userdevinfo_language['bbsp_faulturl']);
		return;
	}
	window.location="userdevinfo.asp?" + parseInt(page,10);
}

function submitprv()
{
	if (false == IsValidPage(page))
	{
		AlertEx(userdevinfo_language['bbsp_faulturl']);
		return;
	}
	page--;
	window.location="userdevinfo.asp?" + parseInt(page,10);
}

function submitnext()
{
	if (false == IsValidPage(page))
	{
		AlertEx(userdevinfo_language['bbsp_faulturl']);
		return;
	}
	page++;
	window.location="userdevinfo.asp?" + parseInt(page,10);
}

function submitlast()
{
	page = lastpage;
	if (false == IsValidPage(page))
	{
		AlertEx(userdevinfo_language['bbsp_faulturl']);
		return;
	}
	
	window.location="userdevinfo.asp?" + parseInt(page,10);
}

function submitjump()
{
	var jumppage = getValue('pagejump');
	if(isInteger(jumppage) != true)
	{
		setText('pagejump', '');
		return;
	}
	if(jumppage < firstpage)
	{
		jumppage = firstpage;
	}
	if(jumppage > lastpage)
	{
		jumppage = lastpage;
	}
	window.location="userdevinfo.asp?" + jumppage;
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
		b.innerHTML = userdevinfo_language[b.getAttribute("BindText")];
	}
}

function LoadFrame()
{
	loadlanguage();
}

</script>
</head>
<body  class="mainbody" onLoad="LoadFrame();"> 
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("userdevinfotitle", GetDescFormArrayById(userdevinfo_language, ""), GetDescFormArrayById(userdevinfo_language, "bbsp_userdevinfo_title"), false);
</script> 
<div class="title_spread"></div>

  <table class='width_per100' border="0" align="center" cellpadding="0" cellspacing="1" id='devlist'>
    <tr class="head_title">
    <td class='width_per15' BindText='bbsp_hostname'></td> 
    <td class='per_13_15' BindText='bbsp_devtype'></td> 
    <td class="per_18_21" BindText='bbsp_ip'></td> 
    <td class="per_18_21" BindText='bbsp_mac'></td> 
    <td class="per_13_16" BindText='bbsp_devstate'></td> 
    <td class="per_15_20" BindText='bbsp_app'></td> 
    </tr> 
</table> 
  <table class='width_per100' border="0" cellspacing="0" cellpadding="0" > 
	<tr > 
		<td class='width_per55'></td> 
		<td class='title_bright1' > 
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
			<input name="first" id="first" class="submit" type="button" value="<<" onClick="submitfirst();"/> 
			<input name="prv" id="prv"  class="submit" type="button" value="<" onClick="submitprv();"/> 
			<input name="next"  id="next" class="submit" type="button" value=">" onClick="submitnext();"/> 
			<input name="last"  id="last" class="submit" type="button" value=">>" onClick="submitlast();"/> 
		</td>
		<td class='width_per5'></td>
		<td  class='title_bright1'>
			<script> document.write(userdevinfo_language['bbsp_goto']); </script> 
				<input  type="text" name="pagejump" id="pagejump" size="3" maxlength="3" style="width:20px;border:0px;" />
			<script> document.write(userdevinfo_language['bbsp_page']); </script>
		</td>
		<td class='title_bright1'>
			<button name="jumpt"  id="jump" class="submit" type="button" onClick="submitjump();"> <script> document.write(userdevinfo_language['bbsp_jump']); </script></button> 
		</td>
	</tr> 
</table> 
<script> 
    GetLanUserInfo(function(para1, para2)
	{
		UserDevices = para2;
		DHCPLeaseTimes = para1;
		
		initFirstPage(para2.length - 1);
		if (false == IsValidPage(page))
		{
			page = (0 == UserDevicesnum) ? 0:1;
		}
		$("#prv").after(parseInt(page,10) + "/" + lastpage);
	   
		showlistcontrol(para2);

		if(page == firstpage)
		{
			setDisable('first',1);
			setDisable('prv',1);
		}
		if(page == lastpage)
		{
			setDisable('next',1);
			setDisable('last',1);
		}
	});
</script> 
</body>
</html>
