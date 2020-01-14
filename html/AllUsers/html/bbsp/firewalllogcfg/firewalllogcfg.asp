<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>Firewall Log</title>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<style type="text/css">
.tabnoline td
{
   border:0px;
}
</style>
<script language="JavaScript" type="text/javascript"> 
var selctIndex = -1;
var numpara = "";
if( window.location.href.indexOf("?") > 0)
{
    numpara = window.location.href.split("?")[1]; 
}

var FirewallLogRight = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Security.FirewallLog.FirewallLogRight);%>';

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
		b.innerHTML = ipfirewalllogcfg_language[b.getAttribute("BindText")];
	}
}

function stFirewallLogRules(domain,Enable,Direction,Action)
{
   this.domain = domain;
   this.Enable = Enable;
   this.Direction = Direction;
   this.Action = Action;
}
var FirewallLogRules = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.FirewallLog.Rules.{i},Enable|Direction|Action,stFirewallLogRules);%>;

function ShowFirewallLogInfo(obj)
{
	if (obj.checked)
	{
		setDisplay('FirewallLogInfo', 1);
	}
	else
	{
		setDisplay('FirewallLogInfo', 0);
	}
}

function removeClick() 
{
   var rml = getElement('rml');
  
   if (rml == null)
   	   return;
 
   var Form = new webSubmitForm();

   var k;	   
   if (rml.length > 0)
   {
      for (k = 0; k < rml.length; k++) 
	  {
         if ( rml[k].checked == true )
         {
			 Form.addParameter(rml[k].value,'');
		 }	
      }
   }  
   else if ( rml.checked == true )
   {
	  Form.addParameter(rml.value,'');
   }	  
   Form.setAction('del.cgi?RequestFile=html/bbsp/firewalllogcfg/firewalllogcfg.asp');
   Form.submit();
}

function LoadFrame()
{
   if (FirewallLogRight == "1")
   {
       getElById("EnableFirewallLog").checked = true;
   }
   
   setDisplay('ConfigForm1',1);
	   
   if (FirewallLogRules.length - 1 == 0)
   {
       selectLine('record_no');
       setDisplay('ConfigForm',0);
   }
   else
   {
       selectLine('record_0');
       setDisplay('ConfigForm',1);
   }
	   
   setDisable('btnApply_ex',0);
   setDisable('cancel',0);

	loadlanguage();
}

function SubmitForm()
{
   var Form = new webSubmitForm();
      
   if (getElById("EnableFirewallLog").checked == true)
   {
       Form.addParameter('x.FirewallLogRight',1);
   }
   else
   {
       Form.addParameter('x.FirewallLogRight',0);
   }
   
   Form.addParameter('x.X_HW_Token', getValue('onttoken'));
   Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_Security.FirewallLog' + '&RequestFile=html/bbsp/firewalllogcfg/firewalllogcfg.asp');
   Form.submit();
}

function CheckForm(type)
{
	var Direction = getElement('Direction').value;
	var Action;
	
	if ( getElement('Action').value == 0)
	{
		Action = "Deny";
	}
	else
	{
		Action = "Permit";
	}
	
	for (i = 0; i < FirewallLogRules.length - 1; i++)
    {
		if (selctIndex == i)
		{
			continue;
		}
		
		if ((FirewallLogRules[i].Direction == Direction) && (FirewallLogRules[i].Action == Action))
		{
			AlertEx(ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_rule_exist']);
			return false;
		}
    }
	
    return true;
}

function AddSubmitParam(SubmitForm,type)
{
	if (getElById("Enable").checked == true)
	{
		SubmitForm.addParameter('x.Enable', 1);
	}
	else
	{
		SubmitForm.addParameter('x.Enable', 0);
	}
	
	SubmitForm.addParameter('x.Direction',getValue('Direction'));
	
	if (getValue('Action') == 0)
	{
		SubmitForm.addParameter('x.Action', "Deny");
	}
	else
	{
		SubmitForm.addParameter('x.Action', "Permit");
	}
	
    if (selctIndex == -1)
	{
		SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
		AlertEx(ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_add_note']);
		SubmitForm.setAction('add.cgi?x=InternetGatewayDevice.X_HW_Security.FirewallLog.Rules' + '&RequestFile=html/bbsp/firewalllogcfg/firewalllogcfg.asp');
	}
	else
	{
		SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
		SubmitForm.setAction('set.cgi?x=' + FirewallLogRules[selctIndex].domain + '&RequestFile=html/bbsp/firewalllogcfg/firewalllogcfg.asp');
	}

    setDisable('btnApply_ex',1);
    setDisable('cancel',1);
}

function setCtlDisplay(record)
{
	if (record.Enable == 1)
	{
		getElById("Enable").checked = true;
	}
	else
	{
		getElById("Enable").checked = false;
	}
	
	setSelect('Direction',record.Direction);
	
	if (record.Action == "Deny")
	{
		setSelect('Action',0);
	}
	else
	{
		setSelect('Action',1);
	}
}

function setControl(index)
{   
    var record;
    selctIndex = index;
	
    if (index == -1)
	{
	    if (FirewallLogRules.length >= 8+1)
        {
            setDisplay('ConfigForm', 0);
            AlertEx(ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_full']);
			CancelValue();
            return;
        }
        else
        {
	        record = new stFirewallLogRules('','','','');
            setDisplay('ConfigForm', 1);
            setCtlDisplay(record);
        }
	}
    else if (index == -2)
    {
        setDisplay('ConfigForm', 0);
    }
	else
	{
	    record = FirewallLogRules[index];
        setDisplay('ConfigForm', 1);
        setCtlDisplay(record);
	}
	
    setDisable('btnApply_ex',0);
    setDisable('cancel',0);
}

function clickRemove() 
{ 
    if ((FirewallLogRules.length-1) == 0)
	{
	    AlertEx(ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_no_rule']);
	    return;
	}

	if (selctIndex == -1)
	{
	    AlertEx(ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_save_rule']);
	    return;
	}

    var rml = getElement('rml');
    var noChooseFlag = true;
    if ( rml.length > 0)
    {
         for (var i = 0; i < rml.length; i++)
         {
             if (rml[i].checked == true)
             {   
                 noChooseFlag = false;
             }
         }
    }
    else if (rml.checked == true)
    {
        noChooseFlag = false;
    }
    if ( noChooseFlag )
    {
        AlertEx(ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_select_rule']);
        return ;
    }

    if (ConfirmEx(ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_del_confirm']) == false)
    {
        document.getElementById("DeleteButton").disabled = false;
        return;
    }
	
    setDisable('btnApply_ex',1);
    setDisable('cancel',1);
    removeInst('html/bbsp/firewalllogcfg/firewalllogcfg.asp');
}

function CancelValue()
{ 
    if (selctIndex == -1)
    {
        var tableRow = getElement("LogInfo");

        if (tableRow.rows.length == 1)
        {
        }
        else if (tableRow.rows.length == 2)
        {
            addNullInst('Firewall Log');
        }   
        else
        {
            tableRow.deleteRow(tableRow.rows.length-1);
            selectLine('record_0');
        }
    }
    else
    {
        setCtlDisplay(FirewallLogRules[selctIndex]);
    }
}

function clickAdd()
{
	var tab = document.getElementById('Firewall Log').getElementsByTagName('table');
	var row,col;
	var rowLen = tab[0].rows.length;
	var firstRow = tab[0].rows[0];
	var lastRow = tab[0].rows[rowLen - 1];

	if (lastRow.id == 'record_null')
	{
		selectLine("record_null");
		return;
	}
    else if (lastRow.id == 'record_no')
    {
        tab[0].deleteRow(rowLen-1);
        rowLen = tab[0].rows.length;
    }

	row = tab[0].insertRow(rowLen);	

	var appName = navigator.appName;
	if(appName == 'Microsoft Internet Explorer')
	{
		g_browserVersion = 1; 
		row.className = 'trTabContent';
		row.id = 'record_null';
		row.attachEvent("onclick", function(){selectLine("record_null");});
	}
	else
	{
		g_browserVersion = 2; 
		row.setAttribute('class','trTabContent');
		row.setAttribute('id','record_null');
		row.setAttribute('onclick','selectLine(this.id);');
	}

	for (var i = 0; i < firstRow.cells.length; i++)
	{
        col = row.insertCell(i);
	 	col.innerHTML = '----';
	} 
	selectLine("record_null");
}

function ShowFirewallLogRuleEnableStatus(RuleEnable)
{
	var RuleEnableStatus = '' ;
	
	if (RuleEnable == "1" || RuleEnable == 1)
	{
		RuleEnableStatus += '<TD >' + ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_en_str'] + '&nbsp;</TD>';
	}
	else
	{
		RuleEnableStatus += '<TD >' + ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_dis_str'] + '&nbsp;</TD>';
	}
	document.write(RuleEnableStatus);
}

function ShowFirewallLogRuleDirectionInfo(RuleDirection)
{
	var RuleDirectionInfo = '' ;
	
	if (RuleDirection == "0" || RuleDirection == 0)
	{
		RuleDirectionInfo += '<TD >' + ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_dir_0'] + '&nbsp;</TD>';
	}
	else if (RuleDirection == "1" || RuleDirection == 1)
	{
		RuleDirectionInfo += '<TD >' + ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_dir_1'] + '&nbsp;</TD>';
	}
	else if (RuleDirection == "2" || RuleDirection == 2)
	{
		RuleDirectionInfo += '<TD >' + ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_dir_2'] + '&nbsp;</TD>';
	}
	else
	{
		RuleDirectionInfo += '<TD >' + ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_dir_3'] + '&nbsp;</TD>';
	}
	document.write(RuleDirectionInfo);
}

function ShowFirewallLogRuleActionInfo(RuleAction)
{
	var RuleActionInfo = '' ;
	
	if (RuleAction == "Deny")
	{
		RuleActionInfo += '<TD >' + ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_act_0'] + '&nbsp;</TD>';
	}
	else
	{
		RuleActionInfo += '<TD >' + ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_act_1'] + '&nbsp;</TD>';
	}
	document.write(RuleActionInfo);
}

function ShowFirewallLogDir()
{
}

function ShowFirewallLogAct()
{
}

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("firewalllogcfgtitle", GetDescFormArrayById(ipfirewalllogcfg_language, ""), GetDescFormArrayById(ipfirewalllogcfg_language, "bbsp_ipfirewalllogcfg_title"), false);
</script>
<div class="title_spread"></div>

<table cellspacing="0" cellpadding="0" width="100%" class="tabal_bg" > 
  <form id="ConfigForm1" action=""> 
    <div id='FirewallLogInfo'> 
      <table cellspacing="1" cellpadding="0" width="100%" class="tabal_bg"  > 
        <tr class='align_left'> 
          <td class="table_title width_per20" BindText='bbsp_ipfirewalllogcfg_enable_mh'></td> 
          <td class="table_right"><input type=checkbox value="0" id="EnableFirewallLog" onclick = "SubmitForm();">
		  <span class="gray"><script>document.write(ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_enable_note']);</script></span></td> 
        </tr>
      </table> 
	  
      <div class="func_spread"></div>	  
      <script language="JavaScript" type="text/javascript">
        writeTabCfgHeader('Firewall Log',"100%");
        </script> 
      <table id="LogInfo" width="100%" cellspacing="1" class="tabal_bg"> 
        <tr> 
          <td class="head_title">&nbsp;</td> 
		  <td class="head_title" BindText='bbsp_ipfirewalllogcfg_tt_en'></td>
          <td class="head_title" BindText='bbsp_ipfirewalllogcfg_tt_dir'></td>
		  <td class="head_title" BindText='bbsp_ipfirewalllogcfg_tt_act'></td> 
        </tr> 
        <script language="JavaScript" type="text/javascript">
            if (FirewallLogRules.length - 1 == 0)
            {
               document.write('<tr id="record_no"' + ' class="tabal_01" onclick="selectLine(this.id);">');
               document.write('<td align="center">--</td>');
   	           document.write('<td align="center">--</td>');
			   document.write('<td align="center">--</td>');  
			   document.write('<td align="center">--</td>');    
    		   document.write('</tr>');
            }
            else
            {
            	for (i = 0; i < FirewallLogRules.length - 1; i++)
            	{
            		document.write('<tr id="record_' + i + '" class="tabal_01" onclick="selectLine(this.id);">');
                    document.write('<td>' + '<input type=\'checkbox\' name=\'rml\'' + ' value=\'' + FirewallLogRules[i].domain + '\'>' + '</td>'); 
					ShowFirewallLogRuleEnableStatus(FirewallLogRules[i].Enable);
					ShowFirewallLogRuleDirectionInfo(FirewallLogRules[i].Direction);
					ShowFirewallLogRuleActionInfo(FirewallLogRules[i].Action);
            		document.write('</tr>');
            	}
            }
            </script> 
      </table> 
	  
      <div id="ConfigForm"> 
	  <div class="list_table_spread"></div>
        <table  cellpadding="0" cellspacing="0" width="100%"> 
          <tr> 
            <td> <table cellpadding="0" cellspacing="1" class="tabal_bg" width="100%"> 
			    <tr> 
                  <td class="table_title width_per20" BindText='bbsp_ipfirewalllogcfg_en_add'></td> 
                  <td class="table_right width_per80"> <input type='checkbox' id="Enable" name="Enable">
				  <strong class="color_red">*</strong> </td>
                </tr> 
                <tr> 
                  <td class="table_title width_per20" BindText='bbsp_ipfirewalllogcfg_dir_add'> </td> 
                  <td class="table_right width_per80"> <select id="Direction" name="Direction" onChange="ShowFirewallLogDir()" maxlength='50' class="width_100px" > 
				  <option value="0"><script>document.write(ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_dir_0']);</script></option> 
                  <option value="1"><script>document.write(ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_dir_1']);</script></option> 
				  <option value="2"><script>document.write(ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_dir_2']);</script></option> 
                  <option value="3"><script>document.write(ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_dir_3']);</script></option> 
		          </select> 
				  <strong class="color_red">*</strong> </td>
                </tr> 
                <tr> 
                  <td class="table_title width_per20" BindText='bbsp_ipfirewalllogcfg_act_add'></td> 
                  <td class="table_right width_per80"> <select id="Action" name="Action" onChange="ShowFirewallLogAct()" maxlength='50' class="width_100px" > 
				  <option value="0"><script>document.write(ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_act_0']);</script></option> 
                  <option value="1"><script>document.write(ipfirewalllogcfg_language['bbsp_ipfirewalllogcfg_act_1']);</script></option> 
		          </select> 
                  <strong class="color_red">*</strong> </td>
                </tr>
              </table> 
          </tr> 
        </table> 
        <table cellpadding="0" cellspacing="0" width="100%" class="table_button"> 
          <tr > 
            <td class='width_per20'></td> 
            <td class="table_submit"> <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
			  <button id='btnApply_ex' name="btnApply_ex" class="ApplyButtoncss buttonwidth_100px" type="button" onClick="Submit();"><script>document.write(ipfirewalllogcfg_language['bbsp_app']);</script></button> 
              <button id='Cancel' name="cancel" class="CancleButtonCss buttonwidth_100px" type="button" onClick="CancelValue();"><script>document.write(ipfirewalllogcfg_language['bbsp_cancel']);</script></button>
		   </td> 
          </tr> 
		  <tr> 
			  <td  style="display:none"> <input type='text'> </td> 
		  </tr>          
        </table> 
      </div> 
      <script language="JavaScript" type="text/javascript">
		writeTabTail();
		</script> 
    </div> 
  </form> 
</table> 
</body>
</html>
