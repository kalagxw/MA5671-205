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
<title>Service Route</title>

</head>
<body class="mainbody">
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("serviceroutetitle", GetDescFormArrayById(serroute_language, ""), GetDescFormArrayById(serroute_language, "bbsp_serroute_title"), false);
</script> 
<div class="title_spread"></div>
      
<script language="javascript">
var selIndex = -1;

function PolicyRouteItem(_Domain, _Type, _VenderClassId, _WanName, _EtherType)
{
    this.Domain = _Domain;
    this.Type = _Type;
    this.VenderClassId = _VenderClassId;
    this.WanName = _WanName;
    this.EtherType = _EtherType;
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
    if (Wan.Mode.indexOf("Bridge") < 0)
    {
        return false;
    }

    return true;
}

function InitWanNameListControl(stWanList)
{
    var Control = getElById("WanNameList");
    var i = 0;
    
    for (i = 0; i < stWanList.length; i++)
    {   
        if (stWanList[i].Mode.indexOf("Bridge") < 0)
        {
            continue;
        }
          
        var Option = document.createElement("Option");
        Option.value = stWanList[i].Name;
        Option.innerText = MakeWanName1(stWanList[i]);
        Option.text = MakeWanName1(stWanList[i]);
        Control.appendChild(Option);
    }
}

var PolicyRouteListAll =<%HW_WEB_GetSpecParaArryByDomain(HW_WEB_FilterPolicyRoute, InternetGatewayDevice.Layer3Forwarding.X_HW_policy_route.{i},PolicyRouteType|VenderClassId|WanName|EtherType,PolicyRouteItem);%>;  

var PolicyRouteList = new Array();
var i,j = 0;
for (i = 0; i < PolicyRouteListAll.length; i++)
{  
    if (PolicyRouteListAll[i] == null)
    {
        PolicyRouteList[j++] = PolicyRouteListAll[i];
        continue;
    }
     
    if (PolicyRouteListAll[i].Type.toUpperCase() == "EthernetType".toUpperCase())
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
    	                + '" class="tabal_01" onclick="selectLine(this.id);">';
        HtmlCode += '<TD>' + '<input type="checkbox" name="rml"'  + ' value=' 
    	                 + PolicyRouteList[i].Domain  + '>' + '</TD>';
        HtmlCode += '<TD id = \"RecordVenderClassId'+i+'\" title=\"'+PolicyRouteList[i].EtherType+'\">' + GetStringContent(PolicyRouteList[i].EtherType, 16) + '</TD>';
        HtmlCode += '<TD  align="center" id = \"RecordWanName'+i+'\">' + GetWanFullName(PolicyRouteList[i].WanName) + '</TD>';
    HtmlCode += '</TR>';
    }
    
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
		b.innerHTML = serroute_language[b.getAttribute("BindText")];
	}
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
    return new PolicyRouteItem("","EthernetType", "", getSelectVal("WanNameList"), getSelectVal("ServiceType"));  
}

function SetInputRouteInfo(RouteInfo)
{
    setSelect("ServiceType", RouteInfo.EtherType);
    setSelect("WanNameList", RouteInfo.WanName); 
}

function IsRepeateConfig(RouteInfo)
{
    var i = 0;
    for (i = 0; i < PolicyRouteList.length-1; i++)
    {
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
     
    if (RouteInfo.WanName.length == 0)
    {
        AlertEx(serroute_language['bbsp_serroutemsg']);
        return false;
    }    


    var Form = new webSubmitForm();
    Form.addParameter('x.PolicyRouteType', RouteInfo.Type);
    Form.addParameter('x.VenderClassId',RouteInfo.VenderClassId);
    Form.addParameter('x.WanName',RouteInfo.WanName);
    Form.addParameter('x.EtherType',RouteInfo.EtherType);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));	
    Form.setAction('add.cgi?' +'x=InternetGatewayDevice.Layer3Forwarding.X_HW_policy_route' + '&RequestFile=html/bbsp/serviceroute/serviceroute.asp');
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
    
    if (RouteInfo.WanName.length == 0)
    {
        AlertEx(serroute_language['bbsp_serroutemsg']);
        return false;
    } 
 
 
    var Form = new webSubmitForm();
    Form.addParameter('x.PolicyRouteType', RouteInfo.Type);
    Form.addParameter('x.VenderClassId',RouteInfo.VenderClassId);
    Form.addParameter('x.WanName',RouteInfo.WanName);	
    Form.addParameter('x.EtherType',RouteInfo.EtherType);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('set.cgi?' +'x='+ PolicyRouteList[OperatorIndex].Domain + '&RequestFile=html/bbsp/serviceroute/serviceroute.asp');
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
        if (PolicyRouteList.length-1 == 1)
        {
	        AlertEx(serroute_language['bbsp_seralert1']);
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
    Form.setAction('del.cgi?' +'x=InternetGatewayDevice.Layer3Forwarding.X_HW_policy_route' + '&RequestFile=html/bbsp/serviceroute/serviceroute.asp');
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
    writeTabCfgHeader('SERVICEROUTE','100%');
</script>
  <table class="tabal_bg" id="xxxInst" width="100%" cellspacing="1">
    <tr  class="head_title">
   	    <td>&nbsp;</td>
        <td BindText='bbsp_sertype'></td>
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
	  <td class="table_title align_left width_per15" BindText='bbsp_sertypemh'></td><td  class="table_right">
			 <select id="ServiceType" class='width_200px'>
				  <option value="PPPoE"><script>document.write(serroute_language['bbsp_pppoe']);</script></option>
			 </select>
			<font class='color_red'>*</font><span class="gray"></span>
		</td>
	</tr>
  <tr class="trTabConfigure">
	  <td class="table_title align_left width_per15" BindText='bbsp_wannamemh'></td> <td class="table_right">
				<select id="WanNameList"  style="width: 200px" name="D1" >
				</select>
				<font class='color_red'>*</font>
		</td>
			<script>
				getElById('WanNameList').ErrorMsg = serroute_language['bbsp_serroutemsg'];
			</script> 
	</tr>

  </table>
	<table width="100%"  cellspacing="1" class="table_button">
	  <tr>
	   <td class='width_per15'></td>
		<td class="table_submit pad_left5p">
		   <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
		   <button type=button id='Apply' onclick = "javascript:return OnApply();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(serroute_language['bbsp_app']);</script> </button>
		   <button type=button id='Cancel' onclick="javascript:OnCancel();" class="CancleButtonCss buttonwidth_100px"><script>document.write(serroute_language['bbsp_cancel']);</script> </button>
		</td>
	</tr>
	</table>
  </div>
      <script language="JavaScript" type="text/javascript">
    	writeTabTail();
      </script>  
  </div>


</body>


</html>
