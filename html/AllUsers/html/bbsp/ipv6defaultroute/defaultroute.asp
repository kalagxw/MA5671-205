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
<script language="javascript" src="../common/ipv6staticroute.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script>

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
			b.innerHTML = default_route_language[b.getAttribute("BindText")];
		}
	}
	
    function CheckParameter()
    {
        if (getSelectVal("WanNameList") == "")
        {
            AlertEx(default_route_language['bbsp_selectwan']);
            return false;
        }
        return true;
        
    }

    function IsDefaultRouteExist()
    {
        return (GetDefaultRouteInfo() == null) ? false : true;
    }
    function BindPaeData()
    {
        var RouteInfo = GetDefaultRouteInfo();
        setCheck("EnableRoute", ((IsDefaultRouteExist() == false) ? "0" : "1"))
        	
        if (null != RouteInfo)
        {	
           setSelect("WanNameList", RouteInfo.WanName);
        }
       
    }

    function OnApplyButtonClick()
    {   
        var Enable = getCheckVal("EnableRoute");
        var IsExist = IsDefaultRouteExist();
        var Url = "";
        var OperFlag = "";
        var cgi = "";
        var Form = new webSubmitForm();

        if (IsExist == false && Enable == "1")
        {
            cgi = "add.cgi";
            OperFlag = "Add";
        }

        if (IsExist == false && Enable == "0")
        {
            OperFlag = "No";
        }        


        if (IsExist == true && Enable == "1")
        {
            cgi = "set.cgi";
            OperFlag = "Set";
        }


        if (IsExist == true && Enable == "0")
        {
            cgi = "del.cgi";
            OperFlag = "Del";
        }


        if (OperFlag == "No")
        {
            return false;
        }


        if (OperFlag == "Del")
        {
            Form.addParameter(GetDefaultRouteInfo().domain,'');   
        } 
        else
        {
            if (CheckParameter() == false)
            {
                return false;
            }
            Form.addParameter('x.WanName', getSelectVal("WanNameList"));
            Form.addParameter('x.DestIPPrefix',"::/0");
            Form.addParameter('x.NextHop',"");
        }       

		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		
        Url = (OperFlag == "Add" || OperFlag == "Del") ? ('x=InternetGatewayDevice.X_HW_IPv6Layer3Forwarding.Forwarding') : ('x='+GetDefaultRouteInfo().domain);
         
        Form.setAction(cgi + "?" + Url+ '&RequestFile=html/bbsp/ipv6defaultroute/defaultroute.asp');
        Form.submit();
        DisableRepeatSubmit();
        setDisable('ButtonApply',1);
	 	setDisable('ButtonCancel',1);
        return false;
    }


    function OnCancelButtonClick()
    {
        BindPaeData();
        return false;
    }
	
	function LoadFrame()
	{
		BindPaeData();
		loadlanguage();
	}
</script>
<title>Default Route Configuration</title>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<form id="ConfigForm"> 
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("ipv6defaultroutetitle", GetDescFormArrayById(default_route_language, ""), GetDescFormArrayById(default_route_language, "bbsp_default_route_title"), false);
</script>
<div class="title_spread"></div>

  <table class="tabal_bg" border="0" cellpadding="0" cellspacing="1"  width="100%"> 
    <tr> 
      <td   class="table_title align_left width_per25"  BindText='bbsp_enableroutemh'> </td> 
      <td   class="table_right align_left width_per75"><input type=checkbox id="EnableRoute"/></td> 
    </tr> 
    <tr> 
      <td   class="table_title align_left width_per25" BindText='bbsp_wannamemh'></td> 
      <td   class="table_right align_left width_per75"><select id="WanNameList" class="width_260px"> </select></td> 
    </tr> 
  </table> 
  <table id="ConfigPanelButtons" width="100%" cellspacing="1" class="table_button"> 
    <tr> 
      <td class='width_per25'> </td> 
      <td class="table_submit pad_left5p" > 
	  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	  <button id="ButtonApply"  type="button" onclick="javascript:return OnApplyButtonClick();" class="ApplyButtoncss buttonwidth_100px" ><script>document.write(default_route_language['bbsp_app']);</script></button> 
        <button id="ButtonCancel" type="button" onclick="javascript:OnCancelButtonClick();" class="CancleButtonCss buttonwidth_100px" ><script>document.write(default_route_language['bbsp_cancel']);</script></button> </td> 
    </tr> 
  </table> 
</form> 
</body>
<script>
  function IsIPv6RouteWan(Wan)
  {
      if (Wan.IPv6Enable == "1" && Wan.Mode =="IP_Routed")
      {
        return true;
      } 
      return false;
  }
  InitWanNameListControl("WanNameList", IsIPv6RouteWan);
  </script>
</html>
