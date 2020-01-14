<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<title>ARP Age Time</title>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="Javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<script language="javaScript" type="text/javascript">

var OperatorFlag = 0;
var OperatorIndex = -1;
var MaxRouteWan = GetRouteWanMax();

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
		b.innerHTML = arpagetime_language[b.getAttribute("BindText")];
	}
	
	var all = document.getElementsByTagName("span");
	for (var i = 0; i <all.length ; i++) 
	{
		var b = all[i];
		if(b.getAttribute("BindText") == null)
		{
			continue;
		}
		b.innerHTML = arpagetime_language[b.getAttribute("BindText")];
	}
}

function ArpAgeTimeItem(Domain, Interface, ArpAgingTime)
{
    this.Domain    = Domain;
    this.Interface = Interface;
    this.ArpAgingTime   = ArpAgingTime;
}

function TrimArryInfo(WanIPInfoList)
{
    var list = new Array();

    for (var i = 0; i < WanIPInfoList.length-1; i++)
    {
        list[i] = WanIPInfoList[i];
    }
	
    return list;
}

function CheckWanOkFunction(item)
{
	if (item.IPv4AddressMode.toUpperCase() == "PPPOE")
	{
		return false;
	}

	if (item.Tr069Flag == "1")
	{
		return false;
	}

	if (item.Mode != "IP_Routed")
	{
		return false;
	}

	if (item.IPv4Enable == 0)
	{
		return false;
	}
	
	return true;
}

var ArpAgeTimeList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_NeighborDiscovery.InterfaceSetting.{i}, Interface|ArpAgingTime, ArpAgeTimeItem);%>;
var itemList = TrimArryInfo(ArpAgeTimeList);

function UpdateUI(List)
{
    var HtmlCode = "";
    var RecordCount = List.length;
    var i = 0;
     
    if (RecordCount == 0)
    {
        HtmlCode += '<TR id="record_no" class="tabal_center01" onclick="selectLine(this.id);">';
        HtmlCode += '<TD></TD>';
        HtmlCode += '<TD>--</TD>';
        HtmlCode += '<TD>--</TD>';
    	HtmlCode += '</TR>';
    	return HtmlCode;
    }

    for (i = 0; i < RecordCount; i++)
    {
    	HtmlCode += '<TR id="record_' + i 
    	                + '" class="tabal_center01" onclick="selectLine(this.id);">';
        HtmlCode += '<TD>' + '<input type="checkbox" name="rml"'  + ' value=' 
    	                 + List[i].Domain  + '>' + '</TD>';
        HtmlCode += '<TD  id = \"RecordWanName'+i+'\">' + GetWanFullName(List[i].Interface) + '</TD>';
        HtmlCode += '<TD  id = \"RecordInverval'+i+'\">' + List[i].ArpAgingTime + '</TD>';
    	HtmlCode += '</TR>';
    }
	
	return HtmlCode;
}

function GetCurrentItemInfo()
{
    return new ArpAgeTimeItem("", getSelectVal("WanNameList"), getValue("ArpAgeTimeId"));  
}

function SetCurrentItemInfo(Item)
{
	setSelect("WanNameList", Item.Interface);
    setText("ArpAgeTimeId", Item.ArpAgingTime);
}

function IsRepeateConfig(checkItem, ignorItem)
{
	try
	{
		if(ignorItem && (checkItem.Interface == ignorItem.Interface))
		{
			return false;
		}
	}
	catch(e)
	{
		return false;
	}
	
	for ( var i = 0; i < itemList.length; i++)
    {
		if(checkItem.Interface == itemList[i].Interface)
		{	
			return true;
		}
    }
	
    return false;
}
	
function CheckParaValid(checkItem, ignorItem)
{
	try
	{
		if (checkItem.Interface.length == 0)
		{
		    AlertEx(arpagetime_language['bbsp_msg1']);
		    return false; 
		}

		checkItem.ArpAgingTime = removeSpaceTrim(checkItem.ArpAgingTime);
		if(checkItem.ArpAgingTime!="")
		{
		   if ( false == CheckNumber(checkItem.ArpAgingTime, 5, 1440) )
		   {
			 AlertEx(arpagetime_language['bbsp_msg2']);
			 return false;
		   }
		}
		else
		{
			AlertEx(arpagetime_language['bbsp_msg2']);
			return false;
		}

		if (true == IsRepeateConfig(checkItem, ignorItem))
		{
			AlertEx(arpagetime_language['bbsp_wanexist']);
			return false;
		} 
	}
	catch(e)
	{
		return false;
	}

	return true;
}

function OnNewInstance(index)
{
	if (itemList.length == MaxRouteWan)
	{
		var tableRow = getElementById("tbl_head");
		tableRow.deleteRow(tableRow.rows.length-1);
		AlertEx(arpagetime_language['bbsp_arppingfull']);	
		return false;
	}
	
	OperatorFlag = 1;
	OperatorIndex = index;	

	var item = new ArpAgeTimeItem("", "", "30");
	document.getElementById("TableConfigInfo").style.display = "block";
	SetCurrentItemInfo(item);
}

function ModifyInstance(index)
{
    OperatorFlag = 2;
    OperatorIndex = index;
	    
    document.getElementById("TableConfigInfo").style.display = "block";
    SetCurrentItemInfo(itemList[index]);
}

function OnAddNewSubmit()
{
    var ItemInfo = GetCurrentItemInfo();

	if(false == CheckParaValid(ItemInfo, null))
	{
		return false;	
	}
		
    var Form = new webSubmitForm();
    Form.addParameter('x.Interface',ItemInfo.Interface);
    Form.addParameter('x.ArpAgingTime',ItemInfo.ArpAgingTime);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));	
    Form.setAction('add.cgi?x=InternetGatewayDevice.X_HW_NeighborDiscovery.InterfaceSetting&RequestFile=html/bbsp/arpagetime/arpagetime.asp');
    Form.submit();
    DisableRepeatSubmit();
	return true;
}
 
function OnModifySubmit()
{
    var ItemInfo = GetCurrentItemInfo();

    if(false == CheckParaValid(ItemInfo, itemList[OperatorIndex]))
		return false;	
	
    var Form = new webSubmitForm();
    Form.addParameter('x.Interface',ItemInfo.Interface);
    Form.addParameter('x.ArpAgingTime',ItemInfo.ArpAgingTime);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));	
    Form.setAction('set.cgi?x=' + itemList[OperatorIndex].Domain + '&RequestFile=html/bbsp/arpagetime/arpagetime.asp');
    Form.submit();
    DisableRepeatSubmit();
    return true;
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
    Form.setAction('del.cgi?x=InternetGatewayDevice.X_HW_NeighborDiscovery.InterfaceSetting&RequestFile=html/bbsp/arpagetime/arpagetime.asp');
    Form.submit();
}

function setControl(index)
{ 
	if (index < -1)
	{
		return;
	}

    if (-1 == index)
    {
        return OnNewInstance(index);
    }
    else
    {
        return ModifyInstance(index);
    }
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
    if (OperatorIndex == -1)
    {
         var tableRow = getElementById("tbl_head");
         if (tableRow.rows.length > 2)
			tableRow.deleteRow(tableRow.rows.length-1);
         return false;
     }
}

window.onload = function()
{   
	InitWanNameListControl("WanNameList", CheckWanOkFunction);
	loadlanguage();
}

</script>
</head>
<body class="mainbody">  
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("arpagetimetitle", GetDescFormArrayById(arpagetime_language, ""), GetDescFormArrayById(arpagetime_language, "bbsp_arpagetime_title"), false);
</script> 
<div class="title_spread"></div>

<script language="JavaScript" type="text/javascript">
    writeTabCfgHeader('aa','100%');
</script> 
  <table class="tabal_bg" id="tbl_head" width="100%" cellspacing="1"> 
    <tr  class="head_title"> 
      <td>&nbsp;</td> 
      <td BindText='bbsp_wanname'></td> 
      <td BindText='bbsp_agetime'></td> 
    </tr>
	<div id="table_ctx">
	</div>
    <script language="javaScript" type="text/javascript">
    document.write(UpdateUI(itemList));
    </script> 
  </table> 
  
  <div id="TableConfigInfo" class="displaynone">
  <div class="list_table_spread"></div> 
    <table class="tabal_bg tabCfgArea" border="0" cellpadding="0" cellspacing="1"  width="100%"> 
    <tr class="trTabConfigure"> 
      <td class="table_title align_left width_per15" BindText='bbsp_wannamemh'></td> 
      <td class="table_right">
		<select id="WanNameList"  class="width_260px" name="WanNameList"> </select> 
	  </td> 
    </tr> 
    <tr> 
      <td class="table_title align_left width_per15" BindText='bbsp_agetimemh'></td> 
      <td class="table_right" >
		<input type=text id="ArpAgeTimeId" value="30" class="width_254px"/><font color="red">*</font>
		<span class="gray" BindText='bbs_range'></span>
	  </td> 
    </tr> 
    </table> 
    <table width="100%"  cellspacing="1" class="table_button"> 
      <tr> 
        <td class="width_per15"></td> 
        <td class="table_submit pad_left5p">
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
			<button id='Apply' type='button' onclick = "javascript:return OnApply();" class="ApplyButtoncss buttonwidth_100px"><script>document.write(arpagetime_language['bbsp_app']);</script></button>
          	<button id='Cancel' type='button' onclick="javascript:OnCancel();" class="CancleButtonCss buttonwidth_100px"><script>document.write(arpagetime_language['bbsp_cancel']);</script></button> 
		</td> 
      </tr> 
    </table> 
  </div> 
<script language="JavaScript" type="text/javascript">
    writeTabTail();
</script>
</body>
</html>
