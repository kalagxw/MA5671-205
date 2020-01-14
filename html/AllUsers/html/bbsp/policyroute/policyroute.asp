<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<title>Policy Route</title>
</head>
<body  class="mainbody"> 
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("policyroutetitle", GetDescFormArrayById(proute_language, ""), GetDescFormArrayById(proute_language, "bbsp_proute_title"), false);
</script> 
<div class="title_spread"></div>

<table border="0" cellpadding="0" cellspacing="0" id="Table1" width="100%"> </table> 
<script language="javascript">
var selIndex = -1;

function loadlanguage()
{
	var all = document.getElementsByTagName("td");
	for (var i = 0; i < all.length ; i++) 
	{
		var b = all[i];
		if(b.getAttribute("BindText") == null)
		{
			continue;
		}
		b.innerHTML = proute_language[b.getAttribute("BindText")];
	}
}

function PolicyRouteItem(_Domain, _Type, _VenderClassId, _WanName)
{
    this.Domain = _Domain;
    this.Type = _Type;
    this.VenderClassId = _VenderClassId;
    this.WanName = _WanName;
}

function filterWan(WanItem)
{
	if (!(IsWanHidden(domainTowanname(WanItem.domain)) == false))
	{
		return false;	
	}
	
	return true;
}

var stWanList = GetWanListByFilter(filterWan);

function IsValidWan(Wan)
{
    if (Wan.Mode != "IP_Routed" || Wan.IPv4Enable != '1')
    {
        return false;
    }

    if (Wan.Tr069Flag == "1")
    {
        return false;
    }

    return true;
}

function IsVenderClassIdValid(VenderClassId)
{
    var uiDotCount = 0;
    var i;
    var chDot = '*';
    var uiLength = VenderClassId.length;

    for (i = 0; i < VenderClassId.length; i++)
    {
        if(VenderClassId.charAt(i)==',')
        {
            return false;
        }
	if(VenderClassId.charAt(i)==chDot)
        {
            uiDotCount++; 
        }
    }   

    if (uiDotCount > 2)
    {
        return false;
    }

    if (0== uiDotCount)
    {
        return true;
    }

    if ((1 == uiDotCount) 
        && (VenderClassId.charAt(0) != chDot) 
        && (VenderClassId.charAt(uiLength-1) != chDot))
    {
        return false;
    }

    if ((2 == uiDotCount) 
        && ((VenderClassId.charAt(0) != chDot) 
        || (VenderClassId.charAt(uiLength-1) != chDot)))
    {
        return false
    }

    return true;
}


function dhcpmainst(domain,startip,endip)
{
	this.domain 	= domain;
	this.startip	= startip;
	this.endip		= endip;
}

var MainDhcpRange = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement,MinAddress|MaxAddress,dhcpmainst);%>;
var PolicyRouteListAll = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_FilterPolicyRoute, InternetGatewayDevice.Layer3Forwarding.X_HW_policy_route.{i},PolicyRouteType|VenderClassId|WanName,PolicyRouteItem);%>;  

var PolicyRouteList = new Array();
var i,j = 0;
var PolicyRouteNum = 0;
var PolicyRouteInfo = new Array();
for(var k = 0; k < 4; k++)
{
	PolicyRouteInfo[k] = new Array();
}

for(var m = 0; m < 4; m++)
{
	PolicyRouteInfo[m][0] = 0;
	PolicyRouteInfo[m][1] = 0;
}
var IndexList = new Array();
var l = 0;
for (i = 0; i < PolicyRouteListAll.length; i++)
{
	if (PolicyRouteListAll[i] && PolicyRouteListAll[i].Type.toUpperCase() == "SourceIP".toUpperCase())
	{
		var tempArrayVolume= PolicyRouteListAll[i].Domain.split(".");
		var Index = tempArrayVolume[tempArrayVolume.length-1];
	}
	IndexList[l++] = Index;
}


for (i = 0; i < PolicyRouteListAll.length; i++)
{  	
	if (PolicyRouteListAll[i] && PolicyRouteListAll[i].Type.toUpperCase() == "SourceIP".toUpperCase())
	{
		var tempArrayVolume= PolicyRouteListAll[i].Domain.split(".");
		var Index = tempArrayVolume[tempArrayVolume.length-1];
		for(var n = 0; n < 4; n++)
		{
			if(PolicyRouteInfo[n][0] == 0)
			{
				PolicyRouteInfo[n][0] = 1;
				PolicyRouteInfo[n][1] = Index;
				break;
			}
		}
		
		for(var n = 0; n < 4; n++ )
		{	
			if(PolicyRouteInfo[n][0] == 1)
			{	
				var ExistFlag = false;
				for(l = 0; l < IndexList.length; l++)
				{
					if(PolicyRouteInfo[n][1] == IndexList[l])
					{
						ExistFlag = true;
						break;
					}
				}
				if(false == ExistFlag)
				{
					PolicyRouteInfo[n][0] = 0;
					PolicyRouteInfo[n][1] = 0;
				}
			}
		}
	}
    if (PolicyRouteListAll[i] == null)
    {
        PolicyRouteList[j++] = PolicyRouteListAll[i];
        continue;
    }
     
    if (PolicyRouteListAll[i].Type.toUpperCase() == "SourceIP".toUpperCase())
    {
        PolicyRouteList[j++] = PolicyRouteListAll[i];
        continue;
    }
 
}

function UpdateUI(PolicyRouteList)
{

    var HtmlCode = "";
    var DataGrid = getElById("DataGrid");
    var RecordCount = PolicyRouteList.length - 1;
    var i = 0;

    if (RecordCount == 0)
    {
        HtmlCode += '<TR id="record_no" class="tabal_center01" onclick="selectLine(this.id);">';
        HtmlCode += '<TD >--</TD>';
        HtmlCode += '<TD >--</TD>';
        HtmlCode += '<TD >--</TD>';
    	HtmlCode += '</TR>';
    	return HtmlCode;
    }

    for (i = 0; i < RecordCount; i++)
    {
    	HtmlCode += '<TR id="record_' + i 
    	                + '" class="tabal_center01 " onclick="selectLine(this.id);">';
        HtmlCode += '<TD>' + '<input type="checkbox" name="rml"'  + ' value=' 
    	                 + PolicyRouteList[i].Domain  + '>' + '</TD>';
		HtmlCode += '<TD id = \"RecordVenderClassId'+i+'\" title=\"' + ShowNewRow(PolicyRouteList[i].VenderClassId) + '\" class=\"restrict_dir_ltr\">' + GetStringContent(PolicyRouteList[i].VenderClassId, 16) + '</TD>';
        HtmlCode += '<TD id = \"RecordWanName'+i+'\">' + GetWanFullName(PolicyRouteList[i].WanName) + '</TD>';
    	HtmlCode += '</TR>';
    }

    return HtmlCode;

}

window.onload = function()
{
    UpdateUI(PolicyRouteList);
	InitWanNameListControlWanname("WanNameList", IsValidWan);
    loadlanguage();
}

</script> 
<script language="JavaScript" type="text/javascript">
var OperatorFlag = 0;
var OperatorIndex = 0;

function GetInputRouteInfo()
{
    return new PolicyRouteItem("","SourceIP", getValue("VenderClassId"), getSelectVal("WanNameList"));  
}

function SetInputRouteInfo(RouteInfo)
{
    setText("VenderClassId", RouteInfo.VenderClassId);
    setSelect("WanNameList", RouteInfo.WanName); 
}

function IsRepeateConfig(RouteInfo)
{
    var i = 0;
    for (i = 0; i < PolicyRouteList.length-1; i++)
    {
        if (RouteInfo.VenderClassId.toLowerCase() == TextTranslate(PolicyRouteList[i].VenderClassId.toLowerCase()))
        {
            return true;
        } 
    }

    return false;
}

function OnNewInstance(index)
{
   OperatorFlag = 1;
   document.getElementById("TableConfigInfo").style.display = "block";
}

function OnAddNewSubmit()
{
    var RouteInfo = GetInputRouteInfo();
	for(i = 0; i < 4; i++)
	{
		if(PolicyRouteInfo[i][0] == 0)
		{
			var IpMin = (64*i) ? 64*(i) : 2;
    		var IpMax = (255 == 64*(i + 1) -1) ? 254 : 64*(i + 1) -1;
			break;
		}
	}
	var IpStartOld = MainDhcpRange[0].startip.split('.');
	var IpEndOld = MainDhcpRange[0].endip.split('.');
	var IpMinOld = parseInt(IpStartOld[3]);
	var IpMaxOld = parseInt(IpEndOld[3]);
	if(IpMin < IpMinOld || IpMax > IpMaxOld)
	{
		AlertEx(proute_language['bbsp_ippoolpolicyrouteinvalid']);
		return false;
	}

    if (RouteInfo.VenderClassId.length == 0)
    {
        AlertEx(proute_language['bbsp_proutermsg1']);
        return false;
    } 

    if (RouteInfo.WanName.length == 0)
    {
        AlertEx(proute_language['bbsp_proutermsg2']);
        return false;
    } 

    if ( (isValidAscii(RouteInfo.VenderClassId) != '') || (IsVenderClassIdValid(RouteInfo.VenderClassId) == false) )
    {
        AlertEx(proute_language['bbsp_vendorinvalid']);
        return false;
    }
		 
	if(false == isSafeStringExc(RouteInfo.VenderClassId,'#='))
	{
		AlertEx(proute_language['bbsp_60'] + RouteInfo.VenderClassId + proute_language['bbsp_60invalid']);
		return false;
	}

    if (true == IsRepeateConfig(RouteInfo))
    {
        AlertEx(proute_language['bbsp_vendorrepeat']);
        return false;
    }    

    var Form = new webSubmitForm();
    Form.addParameter('x.PolicyRouteType', RouteInfo.Type);
    Form.addParameter('x.VenderClassId',RouteInfo.VenderClassId);
    Form.addParameter('x.WanName',RouteInfo.WanName);
	Form.addParameter('x.X_HW_Token', getValue('onttoken')); 	
    Form.setAction('add.cgi?' +'x=InternetGatewayDevice.Layer3Forwarding.X_HW_policy_route' + '&RequestFile=html/bbsp/policyroute/policyroute.asp');
    Form.submit();
    DisableRepeatSubmit();
}
 

function ModifyInstance(index)
{
    OperatorFlag = 2;
    OperatorIndex = index;
    
    document.getElementById("TableConfigInfo").style.display = "block";
    SetInputRouteInfo(PolicyRouteList[index]);

} 
function OnModifySubmit()
{
    var RouteInfo = GetInputRouteInfo();

    if (RouteInfo.VenderClassId.length == 0)
    {
        AlertEx(proute_language['bbsp_proutermsg1']);
        return false;
    }

    if (RouteInfo.WanName.length == 0)
    {
        AlertEx(proute_language['bbsp_proutermsg2']);
        return false;
    } 

	if ( isValidAscii(RouteInfo.VenderClassId) != '' )
	{
		AlertEx(proute_language['bbsp_vendorinvalid']);
		return false;
	}
	 
    if (IsVenderClassIdValid(RouteInfo.VenderClassId) == false)
    {
        AlertEx(proute_language['bbsp_vendorinvalid']);
        return false;
    } 

	if(false == isSafeStringExc(RouteInfo.VenderClassId,'#='))
	{
		AlertEx(proute_language['bbsp_60'] + RouteInfo.VenderClassId + proute_language['bbsp_60invalid']);
		return false;
	}
      
    if (RouteInfo.VenderClassId != PolicyRouteList[OperatorIndex].VenderClassId)
    if (true == IsRepeateConfig(RouteInfo))
    {
        AlertEx(proute_language['bbsp_vendorrepeat']);
        return false;
    } 
   
    var Form = new webSubmitForm();
    Form.addParameter('x.PolicyRouteType', RouteInfo.Type);
    Form.addParameter('x.VenderClassId',RouteInfo.VenderClassId);
    Form.addParameter('x.WanName',RouteInfo.WanName);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));	
    Form.setAction('set.cgi?' +'x='+ PolicyRouteList[OperatorIndex].Domain + '&RequestFile=html/bbsp/policyroute/policyroute.asp');
    Form.submit();
 
}
  
function setControl(index)
{ 
    selIndex = index;
	if (index < -1)
	{
		return;
	}

    OperatorIndex = index;   

    if (-1 == index)
    {
        if (PolicyRouteList.length-1 == 4)
        {
	        AlertEx(proute_language['bbsp_vendorfull']);
	        var tableRow = getElementById("xxxInst");
             tableRow.deleteRow(tableRow.rows.length-1);
	        return false;
        }
        return OnNewInstance(index);
    }
    else
    {
        return ModifyInstance(index);
    }
}

function clickRemove() 
{
    var CheckBoxList = document.getElementsByName("rml");
    var Count = 0;
    var i;
    for (i = 0; i < CheckBoxList.length; i++)
    {
        if (CheckBoxList[i].checked == true)
        {
            Count++;
        }
    }

    if (Count == 0)
    {
        return false;
    }

    var Form = new webSubmitForm();
    for (i = 0; i < CheckBoxList.length; i++)
    {
        if (CheckBoxList[i].checked != true)
        {
            continue;
        }
 
        Form.addParameter(CheckBoxList[i].value,'');
    }
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));

    Form.setAction('del.cgi?' +'x=InternetGatewayDevice.Layer3Forwarding.X_HW_policy_route' + '&RequestFile=html/bbsp/policyroute/policyroute.asp');
    Form.submit();
}
  
function OnApply()
{
    if (OperatorFlag == 1)
    {
        return OnAddNewSubmit();
    }
    else
    {
        return OnModifySubmit();
    }
}

function OnCancel()
{
    getElById('TableConfigInfo').style.display = 'none';
    getElById('TableConfigInfo').style.display = 'none';
    
    if (selIndex == -1)
    {
         var tableRow = getElementById("xxxInst");
         if (tableRow.rows.length > 2)
         tableRow.deleteRow(tableRow.rows.length-1);
         return false;
     }
}

   </script> 
<div id="TypeLimitPanel"> 
  <script language="JavaScript" type="text/javascript">
    writeTabCfgHeader('aaa','100%');
</script> 
  <table class="tabal_bg" id="xxxInst" width="100%" cellspacing="1"> 
    <tr  class="head_title"> 
      <td>&nbsp;</td> 
      <td BindText='bbsp_vendor'></td> 
      <td BindText='bbsp_wanname'></td> 
    </tr> 
    <script>
    document.write(UpdateUI(PolicyRouteList));
    </script> 
  </table> 
  
  <div id="TableConfigInfo" style="display:none"> 
  <div class="list_table_spread"></div>
    <table class="tabal_bg" class="tabCfgArea" border="0" cellpadding="0" cellspacing="1"  width="100%"> 
    <tr class="trTabConfigure"> 
      <td class="table_title align_left width_per15" BindText='bbsp_vendormh'></td> 
      <td  class="table_right"> <input type=text id="VenderClassId"  class='width_150px restrict_dir_ltr' maxlength=256  datatype="int" minvalue="0" maxvalue="253" default="0"/> 
        <font class='color_red'>*</font><span class="gray"><script>document.write(proute_language['bbsp_prnote']);</script></span></td> 
    </tr> 
    <tr class="trTabConfigure"> 
      <td class="table_title align_left width_per15" BindText='bbsp_wannamemh'></td> 
      <td class="table_right" id="WanNameListtitle"><select id="WanNameList"  class='width_260px' name="D1" > </select> </td> 
    </tr> 
	<script>
		getElById('VenderClassId').ErrorMsg = proute_language['bbsp_proutermsg1'];
		getElById('WanNameListtitle').ErrorMsg = proute_language['bbsp_proutermsg2'];
	</script>
    </table> 
    <table width="100%"  cellspacing="1" class="table_button"> 
      <tr> 
        <td class='width_per15'></td> 
        <td class="table_submit pad_left5p"> 
		  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
		  <button type=button id='Apply' onclick = "javascript:return OnApply();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(proute_language['bbsp_app']);</script></button> 
          <button type=button id='Cancel' onclick="javascript:OnCancel();" class="CancleButtonCss buttonwidth_100px"><script>document.write(proute_language['bbsp_cancal']);</script></button> </td> 
      </tr> 
    </table> 
  </div> 
</div> 
</body>
</html>
