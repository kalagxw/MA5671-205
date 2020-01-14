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
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="Javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<title>ARP Ping</title>
</head>
<body class="mainbody"> 
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("arppingtitle", GetDescFormArrayById(arpping_language, ""), GetDescFormArrayById(arpping_language, "bbsp_arpping_title"), false);
</script> 
<div class="title_spread"></div>

<table border="0" cellpadding="0" cellspacing="0" id="Table1" width="100%"> </table> 
<script language="javascript">
var selIndex = -1;
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
		b.innerHTML = arpping_language[b.getAttribute("BindText")];
	}
}


function ArpPingItem(_Domain, _Enable, _Interface, _Interval, _Repeat)
{
    this.Domain = _Domain;
    this.Enable = _Enable;
    this.Interface = _Interface;
    this.Interval = _Interval;
    this.Repeat = _Repeat;
}



var ArpPingList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_ARPPingDiagnostics.{i},ARPPingEnable|WanName|ARPPingInterval|ARPPingNumberOfRepetitions,ArpPingItem);%>;  



function GetEnableString(Enable)
{
    if (Enable == 1 || Enable == "1")
    {
        return arpping_language['bbsp_enable'];
    }
    return arpping_language['bbsp_disable'];
}

function UpdateUI(ArpPingList)
{
    var HtmlCode = "";
    var DataGrid = getElById("DataGrid");
    var RecordCount = ArpPingList.length - 1;
    var i = 0;
     
    if (RecordCount == 0)
    {
        HtmlCode += '<TR id="record_no" class="tabal_center01" onclick="selectLine(this.id);">';
        HtmlCode += '<TD></TD>';
        HtmlCode += '<TD>--</TD>';
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
    	                 + ArpPingList[i].Domain  + '>' + '</TD>';
        HtmlCode += '<TD  id = \"RecordWanName'+i+'\">' + GetWanFullName(ArpPingList[i].Interface) + '</TD>';
        HtmlCode += '<TD  id = \"RecordInverval'+i+'\">' + ArpPingList[i].Interval + '</TD>';
        HtmlCode += '<TD  id = \"RecordRepeat'+i+'\">' + ArpPingList[i].Repeat + '</TD>';
    	HtmlCode += '</TR>';
    }
    return HtmlCode;

}

function CheckWanOkFunction(item)
{
	if (item.IPv4AddressMode != "DHCP")
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

window.onload = function()
{
    UpdateUI(ArpPingList);
	InitWanNameListControl("WanNameList", CheckWanOkFunction);
	loadlanguage();
}

</script> 
<script language="JavaScript" type="text/javascript">
var OperatorFlag = 0;
var OperatorIndex = 0;

function GetInputRouteInfo()
{
    return new ArpPingItem("",getCheckVal("EnableControl"), getSelectVal("WanNameList"), getValue("IntervalControl"), getValue("RepeateControl"));  
}

function SetInputRouteInfo(ArpPingItem)
{
    setCheck("EnableControl", ArpPingItem.Enable);
    setSelect("WanNameList", ArpPingItem.Interface);
    setText("IntervalControl", ArpPingItem.Interval);
    setText("RepeateControl", ArpPingItem.Repeat); 
}

function IsRepeateConfig(RouteInfo)
{
    var i = 0;
    for (i = 0; i < ArpPingList.length-1; i++)
    {
        if (RouteInfo.Interface == ArpPingList[i].Interface)
        {
            return true;
        } 
    }
    return false;
}

function OnNewInstance(index)
{
   OperatorFlag = 1;
   var pingitem = new ArpPingItem("", "0", "", "60", "3");
   document.getElementById("TableConfigInfo").style.display = "block";
   SetInputRouteInfo(pingitem);
}

function onSumbitCheck(RouteInfo)
{
     
    if (RouteInfo.Interface.length == 0)
    {
        AlertEx(arpping_language['bbsp_msg1']);
        return false; 
    }
	
	RouteInfo.Interval = removeSpaceTrim(RouteInfo.Interval);
	if(RouteInfo.Interval!="")
	{
       if ( false == CheckNumber(RouteInfo.Interval,1, 3600) )
       {
         AlertEx(arpping_language['bbsp_msg2']);
         return false;
       }
    }
    else
    {
		AlertEx(arpping_language['bbsp_msg2']);
		return false;
    }

	RouteInfo.Repeat = removeSpaceTrim(RouteInfo.Repeat);
	if(RouteInfo.Repeat!="")
	{
       if ( false == CheckNumber(RouteInfo.Repeat,1, 255) )
       {
         AlertEx(arpping_language['bbsp_msg3']);
         return false;
       }
    }
    else
    {
		AlertEx(arpping_language['bbsp_msg3']);
		return false;
    }
    return true;
}

function OnAddNewSubmit()
{
    var RouteInfo = GetInputRouteInfo();
    if(false == onSumbitCheck(RouteInfo))
    {
    	return false;
    }
    
    if (true == IsRepeateConfig(RouteInfo))
    {
        AlertEx(arpping_language['bbsp_wanexist']);
        return false;
    }
    
    var Form = new webSubmitForm();
    Form.addParameter('x.ARPPingEnable', RouteInfo.Enable);
    Form.addParameter('x.WanName',RouteInfo.Interface);
    Form.addParameter('x.ARPPingInterval',RouteInfo.Interval);	
    Form.addParameter('x.ARPPingNumberOfRepetitions',RouteInfo.Repeat);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));		
    Form.setAction('add.cgi?' +'x=InternetGatewayDevice.X_HW_ARPPingDiagnostics' + '&RequestFile=html/bbsp/arpping/arpping.asp');
    Form.submit();
	DisableRepeatSubmit();
}

function ModifyInstance(index)
{
    OperatorFlag = 2;
    OperatorIndex = index;
    
    document.getElementById("TableConfigInfo").style.display = "block";
    SetInputRouteInfo(ArpPingList[index]);
}
 
function OnModifySubmit()
{
    var RouteInfo = GetInputRouteInfo();

    if(false == onSumbitCheck(RouteInfo))
    {
    	return false;
    }
  
    if (RouteInfo.Interface != ArpPingList[OperatorIndex].Interface)
    {
	    if (true == IsRepeateConfig(RouteInfo))
	    {
	        AlertEx(arpping_language['bbsp_wanexist']);
	        return false;
	    }
    }  
  
    var Form = new webSubmitForm();
    Form.addParameter('x.ARPPingEnable', RouteInfo.Enable);
    Form.addParameter('x.WanName',RouteInfo.Interface);
    Form.addParameter('x.ARPPingInterval',RouteInfo.Interval);	
    Form.addParameter('x.ARPPingNumberOfRepetitions',RouteInfo.Repeat);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));	
    Form.setAction('set.cgi?' +'x='+ ArpPingList[OperatorIndex].Domain + '&RequestFile=html/bbsp/arpping/arpping.asp');
    Form.submit();
    DisableRepeatSubmit();
}
  
function setControl(index)
{ 
    if (-1 == index)
    {
        if (ArpPingList.length-1 == MaxRouteWan)
        {
            var tableRow = getElementById("xxxInst");
            tableRow.deleteRow(tableRow.rows.length-1);
            AlertEx(arpping_language['bbsp_arppingfull']);
            return false;
        }
    }
    
    selIndex = index;
	if (index < -1)
	{
		return;
	}

    OperatorIndex = index;   

    if (-1 == index)
    {        
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
    Form.setAction('del.cgi?' +'x=InternetGatewayDevice.X_HW_ARPPingDiagnostics' + '&RequestFile=html/bbsp/arpping/arpping.asp');
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
      <td BindText='bbsp_wanname'></td> 
      <td BindText='bbsp_interval'></td> 
      <td BindText='bbsp_num'></td> 
    </tr> 
    <script>
    document.write(UpdateUI(ArpPingList));
    </script> 
  </table> 
  
  <div id="TableConfigInfo" class="displaynone"> 
  <div class="list_table_spread"></div>
    <table class="tabal_bg tabCfgArea" border="0" cellpadding="0" cellspacing="1"  width="100%"> 
    <tr class="trTabConfigure"> 
      <td  class="table_title align_left width_per15" BindText='bbsp_enablemh'></td> 
      <td  class="table_right"> <input type='checkbox' id="EnableControl" /> </td> 
    </tr> 
    <tr class="trTabConfigure"> 
      <td class="table_title align_left width_per15" BindText='bbsp_wannamemh'></td> 
      <td class="table_right"><select id="WanNameList"  class="width_260px" name="D1"> </select> </td> 
    </tr> 
    <tr> 
      <td class="table_title align_left width_per15" BindText='bbsp_intervalmh'></td> 
      <td class="table_right" ><input name="IntervalControl" type="text" value="60" id="IntervalControl" class="width_254px"/>
        <font color="red">*</font><span class="gray">(1~3600s)</span></td> 
    </tr> 
    <tr> 
      <td class="table_title align_left width_per15" BindText='bbsp_nummh'></td> 
      <td class="table_right"><input name="RepeateControl" type="text" value="3" id="RepeateControl" class="width_254px"/>
        <font color="red">*</font><span class="gray">(1~255)</span></td> 
    </tr>
    </table> 
    <table width="100%"  cellspacing="1" class="table_button"> 
      <tr> 
        <td class="width_per15"></td> 
        <td class="table_submit pad_left5p">
		    <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
			<button id='Apply' type=button onclick = "javascript:return OnApply();" class="submit"><script>document.write(arpping_language['bbsp_app']);</script></button>
          	<button id='Cancel' type=button onclick="javascript:OnCancel();" class="submit"><script>document.write(arpping_language['bbsp_cancel']);</script></button> 
		</td> 
      </tr> 
    </table> 
  </div> 
</div> 
<script>
InitControlDataType();
</script> 
</body>
</html>
