<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>

<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<script language="Javascript" src="../common/portfwdprohibit.asp"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<script language="javascript" src="../common/lanuserinfo.asp"></script>
<script language="javascript" src="../common/ipmappinglist.asp"></script>

<script>
	var selctIndex = -1;
	var currentFile='ipmapping.asp';
	var CurrentMode;
	
	function SetEditMode()
	{
		CurrentMode = "EDIT";    
	}
	function SetAddMode()
	{
		CurrentMode = "ADD";    
	}

	function IsEditMode()
	{
		return CurrentMode=="EDIT" ? true : false;
	}
	function IsAddMode()
	{
		return CurrentMode=="ADD" ? true : false;
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
			b.innerHTML = ipmapping_language[b.getAttribute("BindText")];
		}
	}
	
    function GetIpMappingData()
    {
	    var CurrentDomain = (GetIpMappingList()[selctIndex] != null)?GetIpMappingList()[selctIndex].domain:"";
        return new IpMappingItemClass(CurrentDomain,"1", getValue("MappingPriority"),getSelectVal("MappingWan"), getValue("InnerIPstart"),getValue("InnerIPend"),getValue("PublicIP"));
    }

    function OnPageLoad()
    {
		loadlanguage();
        return true;
    }
    
    function CheckParameter(IpMappingItem)
    {   
		var IpMappingList = GetIpMappingList();
		
		if (IpMappingItem.Priority != '')
		{
		    if (false == CheckNumber(IpMappingItem.Priority, 1, 16))
			{
				AlertEx(ipmapping_language['bbsp_Priority_invalid']);
				return false;
			}
		}
		
		if (IpMappingItem.Interface == "")
        {
			AlertEx(ipmapping_language['bbsp_alert_wan']);
            return false;
        }
		
		if (IpMappingItem.StartIP == '')
		{
			AlertEx(ipmapping_language['bbsp_startip']);
            return false;
		}
		
		if (isValidIpAddress(IpMappingItem.StartIP) == false
		   || isAbcIpAddress(IpMappingItem.StartIP) == false 
           || isDeIpAddress(IpMappingItem.StartIP) == true 
           || isBroadcastIpAddress(IpMappingItem.StartIP) == true 
           || isLoopIpAddress(IpMappingItem.StartIP) == true ) 
           {              
                AlertEx(ipmapping_language['bbsp_startip_invalid']);
                return false;
           }
		
        if (IpMappingItem.EndIP != '')
        {
		    if (isValidIpAddress(IpMappingItem.EndIP) == false
			   || isAbcIpAddress(IpMappingItem.EndIP) == false 
			   || isDeIpAddress(IpMappingItem.EndIP) == true 
			   || isBroadcastIpAddress(IpMappingItem.EndIP) == true 
			   || isLoopIpAddress(IpMappingItem.EndIP) == true ) 
           {              
                AlertEx(ipmapping_language['bbsp_endip_invalid']);
                return false;
           }
		   if (IpAddress2DecNum(IpMappingItem.StartIP) > IpAddress2DecNum(IpMappingItem.EndIP))
		   {
				AlertEx(ipmapping_language['bbsp_startbigend']);
				return false;     	
		   }	
		}
		
		if (IpMappingItem.SnatSrcIP != '')
		{
		    if ((isValidIpAddress(IpMappingItem.SnatSrcIP) == false)
		   &&(isAbcIpAddress(IpMappingItem.SnatSrcIP) == false 
           || isDeIpAddress(IpMappingItem.SnatSrcIP) == true 
           || isBroadcastIpAddress(IpMappingItem.SnatSrcIP) == true 
           || isLoopIpAddress(IpMappingItem.SnatSrcIP) == true )) 
           {              
                AlertEx(ipmapping_language['bbsp_publicip_invalid']);
                return false;
           }
		}
		   
		for (i = 0; i < IpMappingList.length - 1; i++)
        {
			if((selctIndex != i)
				&&(IpMappingList[i].Interface == IpMappingItem.Interface)
				&& (IpMappingList[i].StartIP == IpMappingItem.StartIP)
				&& (IpMappingList[i].EndIP == IpMappingItem.EndIP)
				&& (IpMappingList[i].SnatSrcIP == IpMappingItem.SnatSrcIP))
			{
				AlertEx(ipmapping_language['bbsp_ruleexist']);
			    return false; 
			}
			if ((IpMappingList[i].Priority == IpMappingItem.Priority)
			    &&(IpMappingItem.Priority != '')
				&&(selctIndex != i))
			{
			    AlertEx(ipmapping_language['bbsp_ruleexist_priority']);
			    return false; 
			}
		}
		
	    return true;
    }
    

    function OnDeleteButtonClick(id) 
    {
        return OnRemoveButtonClick(id);
    }
	
    function setControl(Index)
    {
        selctIndex = Index;
		var WanList = GetWanList();
		var Flag = 1;
		if (Index < -1)
        {
            return;
        }
        if (Index == -1)
        {
            SetAddMode();
			setDisable("MappingWan", 0);
            return OnAddButtonClick();  
        }
        else
        {   
		    SetEditMode();
			for (var i = 0;i < WanList.length;i++)
			{
			    if (domainTowanname(WanList[i].domain) == GetIpMappingList()[Index].Interface)
				{
				    setDisable("MappingWan", 1);
					Flag = 0;
					break;
				}
			}
			if (1 == Flag)
			{
			    setDisable("MappingWan", 0);
			}
			setDisplay("TableConfigInfo", "1");
			var EditRecord = new IpMappingItemClass();
			EditRecord = GetIpMappingList()[Index];
			if (EditRecord.Priority == 0)
			{
			    EditRecord.Priority = '';
			}
			HWSetTableByLiIdList(IpmappingConfigFormList, EditRecord, null);
			return;
        }
		
    }
    
    function OnAddButtonClick()
    {
		setDisplay("TableConfigInfo", "1");
		var AddRecord = new IpMappingItemClass("","","","","","");
		HWSetTableByLiIdList(IpmappingConfigFormList, AddRecord, null);
		return; 		
    }
     
	function WanaclConfigListselectRemoveCnt(obj) 
	{
	
	} 
	
    function OnRemoveButtonClick(TableID)
    {        
        var CheckBoxList = document.getElementsByName("IpMappingConfigListrml");
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
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
        Form.setAction('del.cgi?' +'x=InternetGatewayDevice.X_HW_NAT.IPMapping' + '&RequestFile=html/bbsp/ipmapping/ipmapping.asp');
        Form.submit();
        setDisable('ButtonApply',1);
    	setDisable('ButtonCancel',1);
        return;        
    }

	
	function OnApplyButtonClick()
	{
		var IpMappingItem = GetIpMappingData();
		
		var Enable = IpMappingItem.Enable;
		var Priority = IpMappingItem.Priority;
		var Interface = IpMappingItem.Interface;
		var StartIP = IpMappingItem.StartIP;
		var EndIP = IpMappingItem.EndIP;
		var SnatSrcIP = IpMappingItem.SnatSrcIP;
		
        if (CheckParameter(IpMappingItem) == false)
        {
            return false;
        }
			

		var SpecIpMappingCfgParaList = new Array(new stSpecParaArray("x.Enable",Enable, 1),
												 new stSpecParaArray("x.Priority",Priority, 1),
												 new stSpecParaArray("x.Interface",Interface, 1),
												 new stSpecParaArray("x.StartIP",StartIP, 1),
												 new stSpecParaArray("x.EndIP",EndIP, 1),
												 new stSpecParaArray("x.SnatSrcIP",SnatSrcIP, 1));

		var Parameter = {};
		Parameter.asynflag = null;
		Parameter.FormLiList = IpmappingConfigFormList;
		Parameter.SpecParaPair = SpecIpMappingCfgParaList;
		var url = "";
		if (IsAddMode() == true)
        {
            url = 'add.cgi?x=InternetGatewayDevice.X_HW_NAT.IPMapping' + '&RequestFile=html/bbsp/ipmapping/ipmapping.asp';
        }
        else
        {
            url = 'set.cgi?x='+IpMappingItem.domain + '&RequestFile=html/bbsp/ipmapping/ipmapping.asp';
        }
		
		var tokenvalue = getValue('onttoken');
		HWSetAction(null, url, Parameter, tokenvalue);
		
		setDisable('ButtonApply',1);
    	setDisable('ButtonCancel',1);
        return;		
	}
	
	function OnCancelButtonClick()
    {
		var CancelRecord = new IpMappingItemClass("", "", "", "", "","","");
		HWSetTableByLiIdList(IpmappingConfigFormList, CancelRecord, OnCancelButtonClickSpec);
		return;
	}
    function OnCancelButtonClickSpec()
    {
        if (GetIpMappingList().length > 0 && IsAddMode())
        {
			var tableRow = getElementById("IpMappingConfigList");
            tableRow.deleteRow(tableRow.rows.length-1);
        }
        setDisplay("TableConfigInfo", "0");
        return;
    }
		
	var TableClass = new stTableClass("width_per20", "width_per80", "", "Select");
	
</script>

</head>
<body  class="mainbody" onload="OnPageLoad();">
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("ipmappingtitle", GetDescFormArrayById(ipmapping_language, ""), GetDescFormArrayById(ipmapping_language, "bbsp_title_prompt"), false);
</script>
<div class="title_spread"></div>
 
<script type="text/javascript">
var IpMappingConfiglistInfo = new Array(new stTableTileInfo("Empty","","DomainBox"),
                                    new stTableTileInfo("bbsp_priority"," align_center","Priority"),
									new stTableTileInfo("bbsp_wanname2"," align_center","Interface"),
									new stTableTileInfo("bbsp_innerip"," align_center","StartIPEndIP"),
									new stTableTileInfo("bbsp_publicip"," align_center","SnatSrcIP"),null);

var ColumnNum = 5;
var ShowButtonFlag = true;
var IpmappingConfigFormList = new Array();
var UserInfo = GetIpMappingList();
var IpMappingList = GetIpMappingList();
var TableDataInfo =  HWcloneObject(UserInfo, 1);
//TableDataInfo.push(null);

if (TableDataInfo.length > 17)
{
    TableDataInfo.length = 17;
}
for (var i = 0; i < TableDataInfo.length - 1; i++)
{
    TableDataInfo[i].Interface = GetWanFullName(IpMappingList[i].Interface);
    if (IpMappingList[i].StartIP != '')
	{
	    if (IpMappingList[i].EndIP != '')
		{
		    TableDataInfo[i].StartIPEndIP = IpMappingList[i].StartIP +'--' +IpMappingList[i].EndIP;
		}
		else
		{
		    TableDataInfo[i].StartIPEndIP = IpMappingList[i].StartIP;
		}
	}
	if (IpMappingList[i].Priority == 0)
	{
	    TableDataInfo[i].Priority = '';
	}
}

HWShowTableListByType(1, "IpMappingConfigList", ShowButtonFlag, ColumnNum, TableDataInfo, IpMappingConfiglistInfo, ipmapping_language, null);

</script>

<form id="TableConfigInfo" style="display:none">
<div class="list_table_spread"></div>
<table class="tabal_bg" class="tabCfgArea" border="0" cellpadding="0" cellspacing="1"  width="100%">
<li   id="MappingPriority"           RealType="TextBox"            DescRef="bbsp_td_priority"                 RemarkRef="bbsp_bt_Priority"                   ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.Priority"   InitValue="Empty" MaxLength="2"/>
<li   id="MappingWan"                RealType="DropDownList"       DescRef="bbsp_td_wanname2"                 RemarkRef="Empty"                   ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.Interface"  InitValue="Empty"/>
<li   id="InnerIPstart"              RealType="TextBox"            DescRef="bbsp_td_starip"                  RemarkRef="Empty"                   ErrorMsgRef="Empty"    Require="TRUE"     BindField="x.StartIP"    InitValue="Empty" MaxLength="15"/>
<li   id="InnerIPend"                RealType="TextBox"            DescRef="bbsp_td_endip"                    RemarkRef="Empty"                   ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.EndIP"      InitValue="Empty" MaxLength="15"/>
<li   id="PublicIP"                  RealType="TextBox"            DescRef="bbsp_td_publicip"                 RemarkRef="Empty"                   ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.SnatSrcIP"  InitValue="Empty" MaxLength="15"/>
</table>
<script>
IpmappingConfigFormList = HWGetLiIdListByForm("TableConfigInfo");
HWParsePageControlByID("TableConfigInfo", TableClass, ipmapping_language, null);
getElById("MappingPriority").title = ipmapping_language['bbsp_Priority_note'];
</script>

<table id="ConfigPanelButtons" width="100%" cellspacing="1" class="table_button">
    <tr>
        <td class='width_per20'>
        </td>
        <td class="table_submit pad_left20p">
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
            <button id="ButtonApply"  type="button" onclick="javascript:return OnApplyButtonClick();" class="ApplyButtoncss buttonwidth_100px" ><script>document.write(ipmapping_language['bbsp_app']);</script></button>
            <button id="ButtonCancel" type="button" onclick="javascript:OnCancelButtonClick();" class="CancleButtonCss buttonwidth_100px" ><script>document.write(ipmapping_language['bbsp_cancel']);</script></button>
        </td>
    </tr>
</table>

</form>

<script>
  function IsRouteWan(Wan)
  {
      if ((Wan.Mode =="IP_Routed")
	      &&((Wan.ProtocolType =="IPv4") || (Wan.ProtocolType =="IPv4/IPv6"))
		  &&((Wan.ServiceList !="TR069") && (Wan.ServiceList !="VOIP") && (Wan.ServiceList !="TR069_VOIP")))
      {
          return true;
      } 
      return false;
  }
  InitWanNameListControl("MappingWan", IsRouteWan);
</script>

</body>
</html>