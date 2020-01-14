<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  id="Page" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
 	<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
	<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
	<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
    <script language="javascript" src="../common/userinfo.asp"></script>
    <script language="javascript" src="../common/topoinfo.asp"></script>
    <script language="javascript" src="../common/managemode.asp"></script>
	<script language="javascript" src="../common/wan_list_info.asp"></script>
	<script language="javascript" src="../common/wan_list.asp"></script>
    <script language="javascript" src="../common/lanmodelist.asp"></script>
    <script language="javascript" src="../common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>
    <script language="javascript" src="../common/wan_check.asp"></script>
    <script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
    <script language="javascript" src="../../amp/common/wlan_list.asp"></script>
    <script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
    <script>
    
	var UpportId = '<%HW_WEB_Upportid();%>';
	var MaxVlanPairsPerPort = 4;
	var MaxVlanPairs = 8;
	var SelectIndex = -1;
	
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
			b.innerHTML = vlan_ctc_language[b.getAttribute("BindText")];
		}
	}
	
	function IsLanPortType(BindInfo)
	{
		if(BindInfo.domain.indexOf("LANEthernetInterfaceConfig") >= 0)
			return true;
		else
			return false;
	}
		
	function BindInfoClass(domain, Mode, Vlan)
	{
		this.domain = domain;
		this.Mode = Mode;
		if(Mode == 1)
			this.Vlan = Vlan.replace(/;/g, ",");
		else
			this.Vlan = "";
		this.PortName = '';
	}
	
	var LanArray = new Array();
	var __LanArray = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.{i},X_HW_Mode|X_HW_VLAN,BindInfoClass);%>;
	var __SSIDArray = '<%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},X_HW_Mode|X_HW_VLAN,BindInfoClass);%>';
	if (__SSIDArray.length > 0) 
	{
		__SSIDArray = eval(__SSIDArray);
	}
	else
	{
		__SSIDArray = new Array(null);
	}
	
	var wlanstate = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.X_HW_WlanEnable);%>'; 

	for(var i = 0; i < __LanArray.length - 1; i++)
	{
		__LanArray[i].PortName = 'LAN' + __LanArray[i].domain.charAt(__LanArray[i].domain.length-1)
		LanArray.push(__LanArray[i]);
	}
	
	for(var j = 0, SL = GetSSIDList(); (TopoInfo.SSIDNum != 0) && (j < SL.length) ; j++)
	{		
		for(var i = 0; i < __SSIDArray.length - 1; i++)
		{
			if(__SSIDArray[i].domain == SL[j].domain)
			{
				__SSIDArray[i].PortName = "SSID" + getWlanInstFromDomain(SL[j].domain);
				LanArray.push(__SSIDArray[i]);
				
				break;
			}
		}
	}

    function OnPageLoad()
    {
		loadlanguage();
        return true; 
    }

    function IsBindBindVlanValid(BindVlan)
    {   
	var LanVlanWanVlanList = BindVlan.split(",");
	var LanVlan0;
	var WanVlan;
	var TempList;
	var vlanpairnum = 0;
		
	for (var i = 0; i < LanVlanWanVlanList.length; i++)
	{
		TempList = LanVlanWanVlanList[i].split("/");
			
		if (TempList.length != 2)
		{
			AlertEx(vlan_ctc_language['bbsp_vlanpairs']+vlan_ctc_language['bbsp_vlanpainvalid1']);
			return false;
		}
			
		if ((!isNum(TempList[0])) || (!isNum(TempList[1])))
		{
			AlertEx(vlan_ctc_language['bbsp_vlanpairs']+vlan_ctc_language['bbsp_vlanpainvalid1']);
			return false;				
		}
			
		if (!(parseInt(TempList[0],10) >= 1 && parseInt(TempList[0],10) <= 4094))
		{
			AlertEx(vlan_ctc_language['bbsp_vlanpairs']+vlan_ctc_language['bbsp_invlan']+vlan_ctc_language['bbsp_vlanpainvalid1']);
			return false;
		}
			
		if (!(parseInt(TempList[1],10) >= 1 && parseInt(TempList[1],10) <= 4094))
		{
			AlertEx(vlan_ctc_language['bbsp_vlanpairs']+vlan_ctc_language['bbsp_wan_vlan']+vlan_ctc_language['bbsp_vlanpainvalid1']);
			return false;
		}	
		
		vlanpairnum++;
		
		if (vlanpairnum > MaxVlanPairsPerPort)
		{
			AlertEx(vlan_ctc_language['bbsp_vp_per_port_overflow']);
			return false;
		}
	}

	for(var i in LanArray)
	{
		if((LanArray[i].Vlan.length != 0) && ((SelectIndex - 1) != i))
		{
			vlanpairnum += LanArray[i].Vlan.split(",").length;
		}
	}
	
	if (vlanpairnum > MaxVlanPairs)
	{
		AlertEx(vlan_ctc_language['bbsp_vlanpairs_overflow']);
		return false;
	}		
	
	return true;		        
		        
    }
    
    function CheckParameter(BindVlan, Mode)
    {
			var PortId = $("#PortId").text(); 
		
		    if ((Mode == "vlanbinding") && (0 == BindVlan.length) )
		    {
			    AlertEx(vlan_ctc_language['bbsp_vlanpairs']+vlan_ctc_language['bbsp_vlanisreq']);
			    return false;
		    }

		   if (Mode == "vlanbinding")
		   {
			   if (IsBindBindVlanValid(BindVlan) == false)
			  {
				  return false;
			  }
		   }

		   if((PortId.indexOf("SSID") >= 0) && (1 != wlanstate))
		   {
				AlertEx(vlan_ctc_language['bbsp_vlan_wifi_invalid']);
				return false;
		   }
		   
		   return true;

    
    }
    
    function FillBindInfo(Form)
    {
        var BindVlan = getElById("UrlAddressControl").value.replace(/;/g, ",");
        var PortMode = getElById("ChooseDeviceType").value;
		
        if (CheckParameter(BindVlan, PortMode) == false)
        {
             return false;
        }
		
        Form.addParameter('z.X_HW_Mode', "0");
        
        if(PortMode == "vlanbinding")
        {
             Form.addParameter('z.X_HW_Mode', "1");
        }
        else if (PortMode == "lanwanbinding")
        {
             Form.addParameter('z.X_HW_Mode', "0");
        }

        if (BindVlan == "")
        {
             Form.addParameter('z.X_HW_VLAN', BindVlan);
        }
            
        Form.addParameter('z.X_HW_VLAN', BindVlan);
        
        return true;
    }
    
    function OnApplyButtonClick()
    {
        var Path = "";
        var PortId = $("#PortId").text(); 
        var i;
        if(PortId.indexOf("LAN") >= 0)
        {
            Path = "z=InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig." + PortId.charAt(PortId.length - 1); 
        }
        else if(PortId.indexOf("SSID") >= 0)
        {
            Path = "z=InternetGatewayDevice.LANDevice.1.WLANConfiguration." + PortId.charAt(PortId.length - 1); 
        }

        var Form = new webSubmitForm();

		if(getElementById("ChooseDeviceType").value == "lanwanbinding")
		{
			getElById("UrlAddressControl").value = "";
		}

        if (FillBindInfo(Form) == false)
        {
            return false;
        }
		
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));

        Form.setAction('set.cgi?' +Path+ '&RequestFile=html/bbsp/vlanctc/vlanctc.asp');   
        Form.submit();
        
        return false;
    }


    function OnCancelButtonClick()
    {
        document.getElementById("TableUrlInfo").style.display = "none";
        return false;

    } 
 
    function OnChooseDeviceType(Select)
    {
       var Mode = getElementById("ChooseDeviceType").value;
    
       if (Mode == "lanwanbinding")
       {
           getElById("BindVlanRow").style.display = "none";        
       }
       else if (Mode == "vlanbinding")
       {
           getElById("BindVlanRow").style.display = "";
       }
        
    }

    function CreateRouteList()
    {       
          var HtmlCode = ""; 

          for (var i = 1; i <= LanArray.length; i++)
          {  

              if (i == UpportId) 
              {
                  continue;
              }

              var modestr = ""
              if (LanArray[i-1].Mode == 0)
              {
                  modestr = vlan_ctc_language['bbsp_portbind'];
              }
              else if (LanArray[i-1].Mode == 1)
              {
                  modestr = vlan_ctc_language['bbsp_vlanbind'];
              }
              HtmlCode += '<tr id= "record_' + i +'" align = "center" class="tabal_01" onclick="selectLine(this.id); " >';
              HtmlCode += '<td >' + LanArray[i-1].PortName + '</td>';
     
              HtmlCode += '<td>' +modestr + '</td>';          
              
              if( (LanArray[i-1].Vlan == "") || (LanArray[i-1].Mode == 0))
              {
                  HtmlCode += '<td>--</td>';   
              }
              else
              {
                  HtmlCode += '<td>' + LanArray[i-1].Vlan + '</td>'; 
              }
              
              HtmlCode += '</tr>'            
          }  
          
          return HtmlCode;    
    }
    </script>
    <title>LAN VLAN Bind Configuration</title>

</head>
<body  class="mainbody" onload="OnPageLoad();">
<form id="ConfigForm">
<div id="PromptPanel">
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("vlanctctitle", GetDescFormArrayById(vlan_ctc_language, ""), GetDescFormArrayById(vlan_ctc_language, "bbsp_vlan_ctc_title"), false);
</script> 
<div class="title_spread"></div>
</div>


  <table class="tabal_bg" id="tabinfo" border="0" cellspacing="1"  width="100%">
    <tr  class="head_title">
        <td BindText='bbsp_port'></td>
       <td BindText='bbsp_portmode'></td>
        <td BindText='bbsp_vlanpairs'></td>
     </tr>    
    <script>
   document.write(CreateRouteList());              
   </script>  
  
 </table>

<script language="JavaScript" type="text/javascript">

function ModifyInstance(index)
{
    var lanmode = LanArray[index -1].Mode;
    var vlanpair = LanArray[index -1].Vlan;

    document.getElementById("TableUrlInfo").style.display = ""; 
    getElById("UrlAddressControl").value = vlanpair;

	if (IsLanPortType(LanArray[index -1]) && (IsL3Mode(index) == "0"))
	{
		setDisable("ChooseDeviceType", 1);
	}
	else
	{
		setDisable("ChooseDeviceType", 0);
	}

    if (lanmode == 0)
    {
        getElById("ChooseDeviceType").value = "lanwanbinding";
        getElById("BindVlanRow").style.display = "none";         
    }
    else if (lanmode == 1)
    {
        getElById("ChooseDeviceType").value = "vlanbinding"; 
        getElById("BindVlanRow").style.display = ""; 
    }
}

 
function setControl(index) 
{ 
	SelectIndex = index;
	if (index < -1)
	{
		return;
	}

	$("#PortId").text(LanArray[SelectIndex - 1].PortName)
	return ModifyInstance(SelectIndex);
}



</script>
<div class="list_table_spread"></div>
  <div id="TableUrlInfo" style="display:none">
  <table cellspacing="1" cellpadding="0" class="tabal_bg"   width="100%">
  	<tr class="trTabConfigure"> 
    	<td class="table_title width_per25 align_left" BindText='bbsp_portmh'></td> <td class="table_right"> <div id="PortId"></div></td> 
    </tr>
    <tr class="trTabConfigure">
    	<td  class="table_title width_per25 align_left" BindText='bbsp_portmodemh'></td><td  class="table_right"><select id="ChooseDeviceType" onchange="OnChooseDeviceType(this);"><option value="vlanbinding"><script>document.write(vlan_ctc_language['bbsp_vlanbind']);</script></option><option value="lanwanbinding"><script>document.write(vlan_ctc_language['bbsp_portbind']);</script></option></select>
    	</td>
    </tr>
    <tr class="trTabConfigure" id="BindVlanRow"><td class="table_title width_per25 align_left" BindText='bbsp_vlanpairsmh'></td><td class="table_right"><input type=text id="UrlAddressControl"  style="width:300px" maxlength=255 /><font color="red">*&nbsp</font><script>document.write(vlan_ctc_language['bbsp_note']);</script></td></tr>
	<tr> <td  style="display:none"> <input type='text'> </td> </tr>
  </table>
  <table id="ConfigPanelButtons" width="100%" cellspacing="1" class="table_button">
    <tr>
        <td class='width_per25'>
        </td>
        <td class="table_submit pad_left5p">
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
            <button id="ButtonApply"  type="button" onclick="javascript:return OnApplyButtonClick();" class="ApplyButtoncss buttonwidth_100px" ><script>document.write(vlan_ctc_language['bbsp_app']);</script></button>
            <button id="ButtonCancel" type="button" onclick="javascript:OnCancelButtonClick();" class="CancleButtonCss buttonwidth_100px" ><script>document.write(vlan_ctc_language['bbsp_cancel']);</script></button>
        </td>
    </tr>
  </table>
</div>
</form>
<script>
</script>

</body>
</html>


