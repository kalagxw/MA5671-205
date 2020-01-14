<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  id="Page" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache" />
<title>Wan Access Configuration</title>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/userinfo.asp"></script>
<script language="javascript" src="../common/topoinfo.asp"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<script language="javascript" src="../common/lanmodelist.asp"></script>
<script language="javascript" src="../common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<script language="javascript" src="../common/wanaccesslist.asp"></script>    


<script>
	
    var CurrentWanDomain = "";

    var FltsecLevel = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Security.X_HW_FirewallLevel);%>'.toUpperCase();
	
    var MaxSrcIpNum = '<%HW_WEB_GetSPEC(BBSP_SPEC_SEC_SIPWHITENUM.UINT32);%>';
    
    var CurSrcIpList;
    
    var appName = navigator.appName;

    function GetSrcIpList(srcip)
    {
        var iplist = srcip.split(",");
        var tmplist = new Array();
        var index = 0;
        
        for(var i = 0; i < iplist.length; i++)
        {
            if (iplist[i] != "")
                tmplist[index++] = iplist[i];
        }

        return tmplist;
    }
    function CreateWanAclList()
    {
     
	var WanAclList = GetWanAccessList();
	var HtmlCode = "";
        var DataGrid = getElById("DataGrid");
        var RecordCount = WanAclList.length;
        var i = 0;

      
	if (FltsecLevel != 'CUSTOM')
	{
	    RecordCount = 0;
	}

        if (RecordCount == 0)
        {
            HtmlCode += '<TR id="record_no" class="tabal_center01 " onclick="selectLine(this.id);">';
            HtmlCode += '<TD >--</TD>';
            HtmlCode += '<TD >--</TD>';
            HtmlCode += '<TD >--</TD>';
            HtmlCode += '<TD >--</TD>';
            HtmlCode += '<TD >--</TD>';
    	    HtmlCode += '</TR>';
    	    return HtmlCode;
        }
        
        for (i = 0; i < RecordCount; i++)
        {
            
    	    HtmlCode += '<TR id="record_' + i + '" class="tabal_center01 "  onclick="selectLine(this.id);">';
            HtmlCode += '<TD>' + '<input type="checkbox" name="rml"'  + ' value=' + WanAclList[i].domain  + '>' + '</TD>';
            HtmlCode += '<TD class=\"restrict_dir_ltr\" id = \"RecordWanName'+i+'\">' + GetWanFullName(WanAclList[i].WanName) + '</TD>';
            HtmlCode += '<TD id = \"RecordProtocol'+i+'\">' + WanAclList[i].Protocol.toUpperCase() + '</TD>';

            var list = GetSrcIpList(WanAclList[i].SrcIPPrefix);
            var listshow = "";
            for (var j = 0; j < list.length; j ++)
            {
                 listshow += list[j] + '<br>';
            }
            if (listshow == "")
            {
                HtmlCode += '<TD >--</TD>';
            }
            else
            {
                HtmlCode += '<TD id = \"SrcIpList'+i+'\">' + listshow  + '</TD>';
            }
            
            var enable = (WanAclList[i].Enable == 1) ? wan_acl_language['bbsp_td_enable']:wan_acl_language['bbsp_td_disable'];
            HtmlCode += '<TD id = \"AclEnable' + i+ '\">' + enable   + '</TD>';

            HtmlCode += '</TR>';
        }
        
        return HtmlCode;

    }
    
    function DeleteIpList(id) 
    { 
        var index = id.split('_')[1]; 
        CurSrcIpList.splice(index, 1);

        var Htmlcode     = CreateSrcIPListCode(CurSrcIpList);
        $("#srciplist").empty();
        $("#srciplist").append(Htmlcode);

    } 

    function AddIpList()
    {
       if (CurSrcIpList.length >= MaxSrcIpNum)
       {
           AlertEx(wan_acl_language['bbsp_alert_recfull']);
           return false;
       }
       
       CurSrcIpList.push("");

       var Htmlcode     = CreateSrcIPListCode(CurSrcIpList);
       $("#srciplist").empty();
       $("#srciplist").append(Htmlcode);
    }

    function radioClick(id)
    {
        
        var index = id.split('_')[1]; 

        CurSrcIpList[index] = getValue(id);
        
    }

    function CreateSrcIPListCode(iplist)
    {
        var HtmlCode = "";
        var i = 0;

        if (iplist.length > 0)
        {
            for (i = 0; i < iplist.length; i++)
            {
                HtmlCode += '<tr>';
                HtmlCode += '<td><input id=\"ip_' + i + '\" type=\"text\"  value=\"' + iplist[i] + '\" onblur = \"radioClick(this.id);\" name=\"ip_' + i + '\" class=\"width_254px\" maxlength=\"255\">';
                HtmlCode += '<span class=\"gray\">' + wan_acl_language['bbsp_td_srcip_note'] + '</span>';
                HtmlCode += '</td>';

                HtmlCode += '<td>';
                HtmlCode += '<button id=\"btnDeleteIp_' + i + '\" type=\"button\" onclick=\"DeleteIpList(this.id);\" class=\"submit\" >';
                HtmlCode += wan_acl_language['bbsp_delete'];
                HtmlCode += '</button>';
                HtmlCode += '</td>';
                HtmlCode += '</tr>';
            }
        }
         
        HtmlCode += '<tr>';
        HtmlCode += '<td>';
        HtmlCode += '<button id=\"btnAddIp\"  type=\"button\" onclick=\"AddIpList();\" class=\"submit\" >';
        HtmlCode +=  wan_acl_language['bbsp_add'];
        HtmlCode += '</button>';
        HtmlCode += '</td>';
        HtmlCode += '</tr>'; 

        return HtmlCode;
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
	    b.innerHTML = wan_acl_language[b.getAttribute("BindText")];
        }
    }

    function BindPageData(WanAclInfo)
    {    
        setSelect("WanNameList", WanAclInfo.WanName);
        setText("domain", WanAclInfo.domain);
   
        setCheck('WanAclEnable', WanAclInfo.Enable);
        setCheck('cb_TELNET', 0);
        setCheck('cb_FTP', 0);
        setCheck('cb_HTTP', 0);
        setCheck('cb_SSH', 0);
		  
        if(WanAclInfo.Protocol.toUpperCase().match('TELNET'))
        {
            setCheck('cb_TELNET', 1);
        }
        	
        if(WanAclInfo.Protocol.toUpperCase().match('FTP'))
        {
            setCheck('cb_FTP', 1);
        }
		
        if(WanAclInfo.Protocol.toUpperCase().match('HTTP'))
        {
            setCheck('cb_HTTP', 1);
	}
		
        if(WanAclInfo.Protocol.toUpperCase().match('SSH'))
        {
            setCheck('cb_SSH', 1);
        }

        $("#srciplist").empty();

        CurSrcIpList = GetSrcIpList(WanAclInfo.SrcIPPrefix);
        $("#srciplist").append(CreateSrcIPListCode(CurSrcIpList));
	
    }

    function GetWanAclData()
    {
        return new WanAccessItemClass(getValue("domain"),getValue("WanAclEnable"), "", getSelectVal("WanNameList"), "");
    }

    function OnPageLoad()
    {
        loadlanguage();
        return true;
    }
    

    function CheckParameter(WanAccessItem)
    {   
        if (WanAccessItem.WanName == "")
        {
            AlertEx(wan_acl_language['bbsp_alert_wan']);
            return false;
        }  
	
	return true;        
    }
    

    function clickRemove() 
    {
        return OnRemoveButtonClick();
    }
    
    
    function setControl(Index)
    {
        if (Index < -1)
        {
            return;
        }
        if (Index == -1)
        {
            CurrentWanDomain = "";
            SetAddMode();
            if (GetWanAccessList().length >= 8)
            {
                AlertEx(wan_acl_language['bbsp_alert_recfull']);
                OnCancelButtonClick();
                return false;
            }
            return OnAddButtonClick();  
        }
        else
        {   
            CurrentWanDomain = GetWanAccessList()[Index].domain;
            SetEditMode();
            return OnEditButtonClick(Index);
        }
    }
    

    function OnAddButtonClick()
    {
		
        BindPageData(new WanAccessItemClass("","","","",""));
        setDisplay("TableConfigInfo", "1");
        return false;   
    }
    

    function OnEditButtonClick(Index)
    {	    
        BindPageData(GetWanAccessList()[Index]);
        setDisplay("TableConfigInfo", "1");

    	return false;           
    }  

    function OnRemoveButtonClick()
    {        
       
        var CheckBoxList = document.getElementsByName("rml");
        var Form = new webSubmitForm();
        var Count = 0;
      
        for (var i = 0; i < CheckBoxList.length; i++)
        {
            if (CheckBoxList[i].checked != true)
            {
                continue;
            }
            
            Count++;
            Form.addParameter(CheckBoxList[i].value,'');
        }
        if (Count <= 0)
        {
            return false;
        }
		setDisable("DeleteButton","1");
        Form.addParameter('x.X_HW_Token', getValue('onttoken'));
        Form.setAction('del.cgi?' +'x=InternetGatewayDevice.X_HW_Security.AclServices.WanAccess' + '&RequestFile=html/bbsp/wanacl/wanacl.asp');
        Form.submit();
        setDisable('ButtonApply',1);
    	setDisable('ButtonCancel',1);
        return false;        
    }
    
    function num2binstr(num, outputstrlen)
    {
        var outputstr = num.toString(2);
        var len = outputstr.length;

        for (var i = 0; i < outputstrlen - len; i++)
        {
            outputstr = '0' + outputstr;
        }

        return outputstr;
    }

    function IPv4Address2binstr(address)
    {
        var addrmum = IpAddress2DecNum(address);
        var addrbinstr = num2binstr(addrmum, 32);

        return addrbinstr;
    }

    function isIPv4AddrMaskValid(address, masklen)
    {
        
        if((isAbcIpAddress(address) == false) 
            || (isDeIpAddress(address) == true) 
            || (isLoopIpAddress(address) == true) ) 
        {
            return false;
        }

        if (false == CheckNumber(masklen, 1, 32))
        {
            return false;
        }

        var addrbinstr = IPv4Address2binstr(address);

        var masklenum = parseInt(masklen, 10);
        for (var i = masklenum; i < addrbinstr.length; i++)
        {
            if ('0' != addrbinstr.charAt(i))
                return false;
        }

        return true;
    }
    
    function IPv6Address2binstr(address)
    {
        var ipv6addr_bin = "";
        var ipv6addr = standIpv6Address(address);
        for (var i = 0; i < ipv6addr.length; i++)
        {
             var tmp = parseInt(ipv6addr[i], 16);
             ipv6addr_bin += num2binstr(tmp, 16);
        }
        
        return ipv6addr_bin;
    }

    function isIPv6AddrMaskValid(address, masklen)
    {
        if (CheckIpv6Parameter(address) == false)
        {
            return false;
        }
        
        var ipv6addr_bin = IPv6Address2binstr(address);
 
        var masklenum = parseInt(masklen, 10);
        for (var j = masklenum; j < ipv6addr_bin.length; j++)
        {
            if ('0' != ipv6addr_bin.charAt(j))
                return false;
        }

        if (false == CheckNumber(masklen, 1, 128))
        {
            return false;
        }

        return true;
    }

    function isDuplicatedAddress(pos, address, masken)
    {
        for (var i = 0; i < pos; i++)
        {
            var addrtmp = CurSrcIpList[i].split("/")[0];
            var masklentmp = CurSrcIpList[i].split("/")[1];

             if (address.indexOf(".") > 0)
             {
                 if (addrtmp.indexOf(".") < 0)
                 {
                     continue;
                 }
                 var addrbinstr_tmp = IPv4Address2binstr(addrtmp);
                 var addrbinstr_cur = IPv4Address2binstr(address);

                 if ((addrbinstr_tmp == addrbinstr_cur) && (masklentmp == masken))
                 {
                     return true;
                 }
             }
             else
             {
                if (addrtmp.indexOf(":") < 0)
                {
                     continue;
                }

                var ipv6addr_bin_tmp = IPv6Address2binstr(addrtmp);
                var ipv6addr_bin_cur = IPv6Address2binstr(address);

                if ((ipv6addr_bin_tmp == ipv6addr_bin_cur) && (masklentmp == masken))
                {
                    return true;
                }
             }
            
        }
        return false;
    }
    
    function GetSelectedWan(wanname)
    {
        var WanList = GetWanList(); 
        var i = 0;

        for (i = 0; i < WanList.length; i++)
        { 
            if (wanname == domainTowanname(WanList[i].domain))
            {
                return WanList[i];
            }
        }
    }

    function OnApplyButtonClick()
    { 	
        var WanAclItem = GetWanAclData();
      
        if (CheckParameter(WanAclItem) == false)
        {
            return false;
        }
        
        var SrcIP = "";
        for (var i = 0; i < CurSrcIpList.length; i++)
        {
            CurSrcIpList[i] = getValue("ip_"+ i.toString());
            
            if (CurSrcIpList[i] == "")
            {
                continue;
            }
            
            if (CurSrcIpList[i].indexOf("/") < 0)
            {
                AlertEx(CurSrcIpList[i] + wan_acl_language['bbsp_td_srcip_invalid']);
                return false;
            }
            var addresses = CurSrcIpList[i].split("/");
            if (addresses.length != 2)
            {
                AlertEx(wan_acl_language['bbsp_td_srcip_invalid']);
                return false;
            }
    
            var address = CurSrcIpList[i].split("/")[0];
            var masklen = CurSrcIpList[i].split("/")[1];
            if ((address == "") || (masklen == ""))
            {
                AlertEx(wan_acl_language['bbsp_td_srcip_invalid']);
                return false;
            }
            
            var valid = false;
            var WanInfo = GetSelectedWan(WanAclItem.WanName);
            if (address.indexOf(".") > 0)
            {
                if (WanInfo.IPv4Enable != "1")
                {
                    AlertEx(wan_acl_language['bbsp_td_srciptype_invalid']);
                    return false;
                }
                valid =  isIPv4AddrMaskValid(address, masklen);
            }
            else if (address.indexOf(":") > 0)
            {
                if (WanInfo.IPv6Enable != "1")
                {
                    AlertEx(wan_acl_language['bbsp_td_srciptype_invalid']);
                    return false;
                }
                valid =  isIPv6AddrMaskValid(address, masklen);
            }

            if (false == valid)
            {
                AlertEx(wan_acl_language['bbsp_td_srcip_invalid']);
                return false;
            }

            if ( true == isDuplicatedAddress(i, address, masklen))
            {
                AlertEx(wan_acl_language['bbsp_iprepeat']);
                return false;
            }
            
            if (i < CurSrcIpList.length - 1)
            {
                SrcIP += CurSrcIpList[i] + ',';
            }
            else
            {
                SrcIP += CurSrcIpList[i];
            }
        }
        
		if(',' == SrcIP.charAt(SrcIP.length - 1))
		{
			SrcIP = SrcIP.substring(0, SrcIP.length - 1); 
		}
		
        var Form = new webSubmitForm();
        				
        var protoclStr = '';
		
		var selHttp = getCheckVal('cb_HTTP');
		var selFtp = getCheckVal('cb_FTP');
		var selTelnet = getCheckVal('cb_TELNET');
		var selSSH = getCheckVal('cb_SSH');
				 
		if((selHttp==1)&&(selFtp==0)&&(selTelnet==0)&&(selSSH==0))
		{protoclStr="HTTP";}
			
		if((selHttp==0)&&(selFtp==1)&&(selTelnet==0)&&(selSSH==0))
		{protoclStr="FTP";}
			
		if((selHttp==0)&&(selFtp==0)&&(selTelnet==1)&&(selSSH==0))
		{protoclStr="TELNET";}
			
		if((selHttp==0)&&(selFtp==0)&&(selTelnet==0)&&(selSSH==1))
		{protoclStr="SSH";}
			 
		if((selTelnet==1)&&(selHttp==1)&&(selFtp==1)&&(selSSH==1))
		{protoclStr="TELNET,HTTP,FTP,SSH";}
				
		if((selTelnet==1)&&(selHttp==1)&&(selFtp==1)&&(selSSH==0))
		{protoclStr="TELNET,HTTP,FTP";}
			
		if((selTelnet==1)&&(selHttp==1)&&(selFtp==0)&&(selSSH==1))
		{protoclStr="TELNET,HTTP,SSH";}
			
		if((selTelnet==1)&&(selHttp==1)&&(selFtp==0)&&(selSSH==0))
		{protoclStr="TELNET,HTTP";}
			
		if((selTelnet==1)&&(selHttp==0)&&(selFtp==1)&&(selSSH==1))
		{protoclStr="TELNET,FTP,SSH";}
			
		if((selTelnet==1)&&(selHttp==0)&&(selFtp==1)&&(selSSH==0))
		{protoclStr="TELNET,FTP";}
			
		if((selTelnet==1)&&(selHttp==0)&&(selFtp==0)&&(selSSH==1))
		{protoclStr="TELNET,SSH";}
			
		if((selTelnet==0)&&(selHttp==1)&&(selFtp==1)&&(selSSH==1))
		{protoclStr="HTTP,FTP,SSH";}
			
		if((selTelnet==0)&&(selHttp==1)&&(selFtp==1)&&(selSSH==0))
		{protoclStr="HTTP,FTP";}
			
		if((selTelnet==0)&&(selHttp==1)&&(selFtp==0)&&(selSSH==1))
		{protoclStr="HTTP,SSH";}
			
		if((selTelnet==0)&&(selHttp==0)&&(selFtp==1)&&(selSSH==1))
		{protoclStr="FTP,SSH";}
			
		WanAclItem.Enable = getCheckVal('WanAclEnable');
			
		WanAclItem.Protocol = protoclStr;
				
		if(protoclStr=='')
		{
			AlertEx(wan_acl_language['bbsp_alert_selproto']);
			return false;
		}
			
		Form.addParameter('x.WanName', WanAclItem.WanName);
		Form.addParameter('x.Enable',WanAclItem.Enable);
		Form.addParameter('x.Protocol',WanAclItem.Protocol);
		Form.addParameter('x.SrcIPPrefix',SrcIP);

			
		var WanAclList = GetWanAccessList();
		var RecordCount = WanAclList.length;
		var i = 0;
		for (i = 0; i < RecordCount; i++)
		{
			if(WanAclList[i].WanName == WanAclItem.WanName && CurrentWanDomain != WanAclList[i].domain)
			{			
				AlertEx(wan_acl_language['bbsp_alert_onerule']);
				OnCancelButtonClick();
				return false;
			}
		}
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		if (IsAddMode() == true)
		{
			Form.setAction('add.cgi?' +'x=InternetGatewayDevice.X_HW_Security.AclServices.WanAccess' + '&RequestFile=html/bbsp/wanacl/wanacl.asp');
		}
		else
		{
			Form.setAction('set.cgi?' +'x='+WanAclItem.domain + '&RequestFile=html/bbsp/wanacl/wanacl.asp');
		}
        Form.submit();
        DisableRepeatSubmit();
        setDisable('ButtonApply',1);
    	setDisable('ButtonCancel',1);
        return false;
    }

    function OnCancelButtonClick()
    {
        if (GetWanAccessList().length > 0 && IsAddMode())
        {
            var tableRow = getElementById("xxxInst");
            tableRow.deleteRow(tableRow.rows.length-1);
        }
        setDisplay("TableConfigInfo", "0");
        return false;

    }
</script>

</head>

<script language="JavaScript" type="text/javascript"> 
    if (appName == "Microsoft Internet Explorer")
    { 
        document.write('<body onLoad="OnPageLoad();" class="mainbody" scroll="auto">'); }
    else
    { 
        document.write('<body onLoad="OnPageLoad();" class="mainbody" >'); 
        document.write('<DIV style="overflow-x:auto; overflow-y:auto; WIDTH: 100%; HEIGHT: 460px">'); 
    }
</script>

<form id="ConfigForm">
<div id="PromptPanel">
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("wanacltitle", GetDescFormArrayById(wan_acl_language, ""), GetDescFormArrayById(wan_acl_language, "bbsp_title_prompt"), false);
</script> 
<div class="title_spread"></div>
  
</div>
  <script language="JavaScript" type="text/javascript">
    ((FltsecLevel == 'CUSTOM') ? writeTabCfgHeader : writeTabInfoHeader)('wacl','100%');
</script>
  <table class="tabal_bg" id="xxxInst" width="100%" cellspacing="1">
    <tr  class="head_title">
   	    <td class='width_per5'>&nbsp;</td>
   	    <td class='width_per30' BindText='bbsp_td_wanname'></td>
            <td class='width_per25' BindText='bbsp_td_proto'></td>
            <td class='width_per30' BindText='bbsp_td_srcip'></td>
            <td class='width_per10' BindText='bbsp_td_enable'></td>
    </tr>
    <script>
        document.write(CreateWanAclList());
    </script>
    
  </table>
 
  <div id="TableConfigInfo" style="display:none">
   <div class="list_table_spread"></div>
  <table class="tabal_bg" class="tabCfgArea" border="0" cellpadding="0" cellspacing="1"  width="100%">
  <tr class="trTabConfigure displaynone">
      <td  class="table_title align_left width_per15" BindText='bbsp_td_instance'></td>
      <td  class="table_right">
      <input type=text id="domain"  class='width_150px' maxlength=255  ErrorMsg="" datatype="int" minvalue="0" maxvalue="253" default="0"/>                   
      </td>
  </tr>   

  <tr class="trTabConfigure">
      <td class="table_title align_left width_per15" BindText='bbsp_td_enable1'></td>
      <td class="table_right"> <input type='checkbox' id='WanAclEnable' name='WanAclEnable'> </td> 
  </tr>

  <tr class="trTabConfigure">
      <td class="table_title align_left width_per15" BindText='bbsp_td_wanname2'></td>
      <td class="table_right"><select id="WanNameList"  class='width_260px' name="D1" ErrorMsg=""></select>
       </td>
  </tr>


  <tr class="trTabConfigure">
      <td class="table_title align_left width_per15" BindText='bbsp_td_proto2'></td>
      <td class="table_right">
        <div id="Div_TELNET">
          <table>
              <tr>
	      <td><input id="cb_TELNET" name="cb_TELNET" type="checkbox" value="TELNET">TELNET</td>
	      <td><input id="cb_HTTP" name="cb_HTTP" type="checkbox" value="HTTP">HTTP</td>
	      <td><input id="cb_FTP"  name="cb_FTP"  type="checkbox" value="FTP">FTP</td>
	      <td><input id="cb_SSH"  name="cb_SSH"  type="checkbox" value="SSH">SSH</td>
              </tr>
	  </table>
        </div>
      </td>
  </tr>
  <tr class="trTabConfigure"> 
       <td class="table_title align_left width_per15" BindText='bbsp_td_srcip1'></td> 
       <td class="table_right"> 
              <table id="srciplist">   
	      </table>
       </td>
  </tr> 

  </table>
 
<table id="ConfigPanelButtons" width="100%" cellspacing="1" class="table_button">
    <tr>
        <td class='width_per15'>
        </td>
        <td class="table_submit pad_left5p">
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
            <button id="ButtonApply"  type="button" onclick="javascript:return OnApplyButtonClick();" class="submit" ><script>document.write(wan_acl_language['bbsp_app']);</script></button>
            <button id="ButtonCancel" type="button" onclick="javascript:OnCancelButtonClick();" class="submit" ><script>document.write(wan_acl_language['bbsp_cancel']);</script></button>
        </td>
    </tr>
</table>
  </div>
  <script>
  function IsRouteWan(Wan)
  {
      if (Wan.Mode =="IP_Routed")
      {
        return true;
      } 
      
      return false;
  }
  InitWanNameListControl("WanNameList", IsRouteWan);
  </script>
</form>
<script language="JavaScript" type="text/javascript"> 
    if (appName != "Microsoft Internet Explorer")
    { 
        document.write('</DIV>'); 
    } 
</script>
</body>
</html>