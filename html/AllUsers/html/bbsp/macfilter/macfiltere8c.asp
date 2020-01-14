<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>Chinese -- MAC Filter</title>
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

var enableFilter = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Security.MacFilterRight);%>';

var Mode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Security.MacFilterPolicy);%>';

var StrHomeMacAddr = '<%HW_WEB_GetMacAddress();%>';
var HomeMacAddr = '';
if ('' != StrHomeMacAddr)
{
	HomeMacAddr = StrHomeMacAddr.substring(0,2) + ':' + StrHomeMacAddr.substring(2,4) + ':' + StrHomeMacAddr.substring(4,6) + ':' + StrHomeMacAddr.substring(6,8) + ':' + StrHomeMacAddr.substring(8,10) + ':' + StrHomeMacAddr.substring(10,12);
}

var HomeMacAddrIndex = -1;

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
		b.innerHTML = macfilter_language[b.getAttribute("BindText")];
	}
}

function stMacFilter(domain,MACAddress)
{
   this.domain = domain;
   this.MACAddress = MACAddress;
}

var MacFilter = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.MacFilter.{i},SourceMACAddress,stMacFilter);%>;
function ShowMacFilter(obj)
{
	if (obj.checked)
	{
		setDisplay('FilterInfo', 1);
	}
	else
	{
		setDisplay('FilterInfo', 0);
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
   Form.addParameter('x.X_HW_Token', getValue('onttoken'));	  
   Form.setAction('del.cgi?&RequestFile=html/bbsp/macfilter/macfiltere8c.asp');
   Form.submit();
}

function LoadFrame()
{
	setDisplay('Newbutton',0);
	setDisplay('DeleteButton',0);
   if (enableFilter != '' && Mode != '')
   {    
       setDisplay('ConfigForm1',1);
       setSelect('ExcludeMode_select',Mode);
       if (MacFilter.length - 1 == 0)
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
   }
   else
   {
       setDisplay('ConfigForm1',0);
   }
   
   if (enableFilter == "1")
   {
       getElById("MAC_filter_enable_checkbox").checked = true;
   }

	if(isValidMacAddress(numpara) == true)
	{
		clickAdd('MAC Filter');
		setText('MACAddress_text', numpara);
	}
	loadlanguage();
	showFilterTips();
}

function selFilter(filter)
{
   if (filter.checked)
   {   
       FilterInfo.style.display = "";
	   if (enableFilter == 0)
	   {
		   var mode = getElement('ExcludeMode_select');
		   mode[0].disabled = true;
		   mode[1].disabled = true;
	   }
   }
   else
   {
	   setDisplay('FilterInfo',0);
   }
   SubmitForm();

}
function showFilterTips()
{
    var ExcludeMode_select = getElById("ExcludeMode_select");
    if (ExcludeMode_select[0].selected == true){
        getElement('ExcludeMode_tips_lable').innerHTML = "当配置在黑名单内的MAC地址不允许被访问";
    }
    else{
        getElement('ExcludeMode_tips_lable').innerHTML = "当配置在白名单内的MAC地址才允许被访问";
    }
}
function ChangeMode()
{
    var ExcludeMode_select = getElById("ExcludeMode_select");
    if (ExcludeMode_select[0].selected == true)
	{ 
		if (false == ConfirmEx(macfilter_language['bbsp_macfilterconfirm1']))
		{
		    ExcludeMode_select[0].selected = false;
			ExcludeMode_select[1].selected = true;
			return;	
		}
	}
	else if (ExcludeMode_select[1].selected == true)
	{ 
		if (false == ConfirmEx(macfilter_language['bbsp_macfilterconfirm2']))
		{
		    ExcludeMode_select[0].selected = true;
		    ExcludeMode_select[1].selected = false;
			return;
		}
	}
	showFilterTips();
}

function setBtnDisable()
{
	setDisable('MAC_filter_enable_checkbox',1);
	setDisable('ExcludeMode_select',1);
	setDisable('ModeSave_button',1);
	setDisable('btnApply_ex',1);
	setDisable('MACDelete_button',1);
	setDisable('MACAdd_button',1);
	setDisable('MACEdit_button',1);
}


function OnSaveFilterMode()
{
   var Form = new webSubmitForm();
  
   var Enable = getElById("MAC_filter_enable_checkbox").checked;
   if (Enable == true)
   {
       Form.addParameter('x.MacFilterRight',1);
   }
   else
   {
       Form.addParameter('x.MacFilterRight',0);
   }
   var FilterMode = getElById("ExcludeMode_select");
   if (FilterMode[0].selected == true){
       Form.addParameter('x.MacFilterPolicy',0);  
   }else{
       Form.addParameter('x.MacFilterPolicy',1); 
   }
   setBtnDisable();
   Form.addParameter('x.X_HW_Token', getValue('onttoken'));
   Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_Security'
                        + '&RequestFile=html/bbsp/macfilter/macfiltere8c.asp');
   Form.submit();
}
function OnSelectMacRecord(recId)
{
    selectLine(recId);
}
function OnEditMacFilter()
{
    var recordId = 'record_' + selctIndex;
    setDisplay('mac_edit_tr',0);
    if((selctIndex < 0) && (MacFilter.length <= 1)){
        AlertEx("没有可以修改的配置记录");
        return;
    }
    selectLine(recordId);
    setDisplay('mac_edit_tr',1);
}

function CheckForm(type)
{   
    var macAddress = getElement('MACAddress_text').value;
    if (macAddress == '') 
    {
		AlertEx(macfilter_language['bbsp_macfilterisreq']);
        return false;
    }
    if (macAddress != '' && isValidMacAddress1(macAddress) == false ) 
    {
        AlertEx(macfilter_language['bbsp_themac'] + macAddress + macfilter_language['bbsp_macisinvalid']);
        return false;
    }
	if ((0 == Mode) && (HomeMacAddr != '')&& (HomeMacAddr.toUpperCase() == macAddress.toUpperCase()))
	{
		AlertEx(macfilter_language['bbsp_macfilterBlackReq']);
		return false;
	}

    for (var i = 0; i < MacFilter.length-1; i++)
    {
        if (selctIndex != i)
        {
            if (macAddress.toUpperCase() == MacFilter[i].MACAddress.toUpperCase())
            {
                AlertEx(macfilter_language['bbsp_themac'] + macAddress + macfilter_language['bbsp_macrepeat']);
                return false;
            }
        }
        else
        {
            continue;
        }
    }
    return true;
}

function AddSubmitParam(SubmitForm,type)
{
	SubmitForm.addParameter('x.SourceMACAddress',getValue('MACAddress_text'));
	SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));

    if( selctIndex == -1 )
	{
		 SubmitForm.setAction('add.cgi?x=InternetGatewayDevice.X_HW_Security.MacFilter'
		                        + '&RequestFile=html/bbsp/macfilter/macfiltere8c.asp');
	}
	else
	{
	     SubmitForm.setAction('set.cgi?x=' + MacFilter[selctIndex].domain
							+ '&RequestFile=html/bbsp/macfilter/macfiltere8c.asp');
	}
    setBtnDisable();
}

function setCtlDisplay(record)
{
	setText('MACAddress_text',record.MACAddress);
}

function setControl(index)
{   
    var record;
    selctIndex = index;
    if (index == -1)
	{
	    if (MacFilter.length >= 8+1)
        {
            setDisplay('ConfigForm', 0);
			setDisable('btnApply_ex',1);
            AlertEx(macfilter_language['bbsp_macfilterfull']);
            return;
        }
        else
        {
	        record = new stMacFilter('','');
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
	    record = MacFilter[index];
		if ((1 == Mode) && (HomeMacAddr != '') && (HomeMacAddr.toUpperCase() == record.MACAddress.toUpperCase()))
		{
			setDisable('MACEdit_button',1);
		}
		else
		{
			setDisable('MACEdit_button',0);
		}

        setDisplay('ConfigForm', 1);
        setCtlDisplay(record);
	}
    setDisable('btnApply_ex',0);

}

function OnDeleteBtClick() 
{ 
	var noChooseFlag = true;
	var SubmitForm = new webSubmitForm();	
    if ((MacFilter.length-1) == 0)
	{
	    AlertEx(macfilter_language['bbsp_nomacfilter']);
	    return;
	}

	for (var i = 0; i < MacFilter.length - 1; i++)
	{
		var j = i + 1;
		var rmId = 'MACAddress' + j +'_checkbox';
		var rm = getElement(rmId);
		if (rm.checked == true)
		{
			noChooseFlag = false;
			SubmitForm.addParameter(MacFilter[i].domain,'');
		}
	}
    if ( noChooseFlag )
    {
        AlertEx(macfilter_language['bbsp_selectmacfilter']);
        return ;
    }
	
	SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
    if (enableFilter == 1 && Mode == 1)
    {   
        if(ConfirmEx(macfilter_language['bbsp_macfilterconfirm3']))
        {
            setBtnDisable();
			SubmitForm.setAction('del.cgi?RequestFile=html/bbsp/macfilter/macfiltere8c.asp');
			SubmitForm.submit();
        }
        else
        {
            return;
        }
    }
    else
    {
        if (ConfirmEx(macfilter_language['bbsp_macfilterconfirm4']) == false)
    	{
    	    return;
        }
        setBtnDisable();
		SubmitForm.setAction('del.cgi?RequestFile=html/bbsp/macfilter/macfiltere8c.asp');
		SubmitForm.submit();
    }  
}

function CancelValue()
{   
    if (selctIndex == -1)
    {
        var tableRow = getElement("MacInfo");

        if (tableRow.rows.length == 1)
        {
        }
        else if (tableRow.rows.length == 2)
        {
            addNullInst('MAC Filter');
        }   
        else
        {
            tableRow.deleteRow(tableRow.rows.length-1);
            selectLine('record_0');
        }
    }
    else
    {
        setText('MACAddress_text',MacFilter[selctIndex].MACAddress);
    }
}

function clickCheckboxAll()
{
    for (var i = 0; i < MacFilter.length - 1; i++){
        var index = i + 1;
        var chkboxShow = 'MACAddress' + index +'_checkbox';
        var enableVal = getCheckVal("MACAddress_checkbox");
		if (!((1 == Mode) && (HomeMacAddr != '') && (HomeMacAddrIndex == index)))
		{
			setCheck(chkboxShow,enableVal);
			clickCheckbox(index);
		}
    }
}
function clickCheckbox(index)
{
    var chkboxShow = 'MACAddress' + index +'_checkbox';
    var chkboxHide = 'MACAddress' + index +'_checkboxCopy';
    var enableVal = getCheckVal(chkboxShow);
	if (!((1 == Mode) && (HomeMacAddr != '') && (HomeMacAddrIndex == index)))
	{
		setCheck(chkboxHide,enableVal);
	}
}
function clickAdd()
{
    if (MacFilter.length >= 8+1)
    {
        AlertEx(macfilter_language['bbsp_macfilterfull']);
        return;
    }
	
    if (Mode == 1)
    {   
        setDisplay("MacAlert",1);
        AlertEx(macfilter_language['bbsp_linkmacfilter']);
    }
    else 
    {
        setDisplay("MacAlert",0);
    }
    
    setDisplay('mac_edit_tr',1);

	var tab = document.getElementById('MAC Filter').getElementsByTagName('table');
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
		g_browserVersion = 1; /* IE */
		row.className = 'trTabContent';
		row.id = 'record_null';
		row.attachEvent("onclick", function(){selectLine("record_null");});
	}
	else
	{
		g_browserVersion = 2; /* firefox */
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
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<table width="100%" border="0" cellpadding="0" cellspacing="0" id="tabTest"> 
  <tr> 
    <td class="prompt"><table width="100%" border="0" cellspacing="0" cellpadding="0"> 
        <tr> 
          <td class='title_common'><label id="Title_mac_filter_tips_lable">MAC过滤——请先选择过滤模式然后配置列表条目，最多8条可以被配置。 </label></td> 
        </tr> 
      </table></td> 
  </tr> 
  <tr> 
    <td class='height5p'></td> 
  </tr> 
</table> 
<table border="0" cellpadding="0" cellspacing="0" width="100%" class="tabal_bg" > 
  <form id="ConfigForm1" action=""> 
    <div id='FilterInfo'> 
      <table cellspacing="0" cellpadding="0" width="100%"  > 
        <tr> 
          <td class="table_title width_20p">启用</td> 
          <td class="table_right"><input type=checkbox value="true" id="MAC_filter_enable_checkbox" /></td> 
		   <td class="table_right width_5p" ></td>
		    <td class="table_right width_75p" > 
        </tr> 
        <tr > 
          <td class="table_title width_20p" >过滤模式</td> 
          <td class="table_right" id="Selectlist" ><select id="ExcludeMode_select" onchange="setTimeout(function(){ChangeMode();})"> 
              <option value="0"><script>document.write(macfilter_language['bbsp_blacklist']);</script></option> 
              <option value="1"><script>document.write(macfilter_language['bbsp_whitelist']);</script></option> 
            </select></td> 
          <td class="table_right width_5p" ></td> 
          <td class="table_right width_75p" ><label id="ExcludeMode_tips_lable" ></label></td> 
        </tr> 
      </table>
      <br/> 
      <table width="100%" class="table_button"> 
          <tr align="right"> 
          <td><button id="ModeSave_button" type="button" onclick="OnSaveFilterMode()">保存/应用</button></td>
          </tr>
     </table>
<hr style="color:#C9C9C9"></hr>
      <script language="JavaScript" type="text/javascript">
        writeTabCfgHeader('MAC Filter',"100%");
        </script> 

      <table id="MacInfo" width="100%" cellspacing="1" class="tabal_bg"> 
        <tr> 
          <td class="head_title"><input id="MACAddress_checkbox" type="checkbox" onclick="clickCheckboxAll();"  value="false" ></td> 
          <td id="MACAddress_table" class="head_title">MAC地址</td> 
        </tr> 
        <script language="JavaScript" type="text/javascript">
            if (MacFilter.length - 1 == 0)
            {
               document.write('<tr id="record_no" class="tabal_01" onclick="OnSelectMacRecord(this.id);">');
               document.write('<td id=\"MACAddress1_checkbox\" onclick="selectLine(this.id);" align="center">--</td>');
				 document.write('<td id=\"MACAddress1_table\" align="center">--</td>');    
				 document.write('</tr>');
            }
            else
            {
            	for (i = 0; i < MacFilter.length - 1; i++)
            	{
            	   var j = i+1;
            	   if (MacFilter[i].MACAddress != '')
            	   {
            			document.write('<tr id="record_' + i + '" class="tabal_01"  onclick="OnSelectMacRecord(this.id)">');
						if ((1 == Mode) && (HomeMacAddr != '') && (HomeMacAddr.toUpperCase() == MacFilter[i].MACAddress.toUpperCase()))
						{
							HomeMacAddrIndex = j;
							document.write('<td align="center"><input disabled="disabled" id=\"MACAddress' + j +'_checkbox\"'  + 'type=\'checkbox\''+ 'value=\'false\'' + 'onclick=\"clickCheckbox('+j+');\" \'>' );
							document.write('<input id=\"MACAddress' + j +'_checkboxCopy\"'  + 'type=\'checkbox\' name=\'rml\''
											+ ' value=\'' + MacFilter[i].domain + '\' style=\"display:none\" >'+ '</td>' );
							document.write('<td align="center" id=\"MACAddress'+ j + '_table\">' + MacFilter[i].MACAddress + '</br>' + '<span class="color_red">' + macfilter_language['bbsp_WriteListInfo'] + '</span>' +'&nbsp;</td>'); 
						}
						else
						{
							document.write('<td align="center"><input id=\"MACAddress' + j +'_checkbox\"'  + 'type=\'checkbox\''+ 'value=\'false\'' + 'onclick=\"clickCheckbox('+j+');\" \'>' );
							document.write('<input id=\"MACAddress' + j +'_checkboxCopy\"'  + 'type=\'checkbox\' name=\'rml\''
											+ ' value=\'' + MacFilter[i].domain + '\' style=\"display:none\" >'+ '</td>' );
							document.write('<td align="center" id=\"MACAddress'+ j + '_table\">' + MacFilter[i].MACAddress + '&nbsp;</td>'); 
						}
            			document.write('</tr>');
                   }
            	}
            }
            </script> 
      </table> 
      
<td>

</td>
      <div id="ConfigForm"> 
        <table  cellpadding="0" cellspacing="0" width="100%" > 
          <tr> 
            <td id="mac_edit_tr" style="display:none"> <table cellpadding="0" cellspacing="1" width="100%"> 
                <tr> 
                  <td class="table_title">MAC地址</td> 
                  <td  class="table_right "> <input type='text'id="MACAddress_text" maxlength='17'> 
                    <strong class="color_red">*</strong><span class="gray"><script>document.write(macfilter_language['bbsp_macfilternote3']);</script></span> </td> 
                </tr> 
                <tr style="display:none"> 
                  <td class="table_title" BindText='bbsp_enablemh'></td> 
                  <td class="table_right"> <input type='checkbox' id="Enable" name="Enable" checked> </td> 
                </tr> 
              </table> 
              <div id="MacAlert" style="display:none"> 
                <table cellpadding="2" cellspacing="0" class="tabal_bg" width="100%"> 
                  <tr> 
                    <td class='color_red' BindText='bbsp_rednote'></td> 
                  </tr> 
                </table> 
              </div></td> 
          </tr> 
        </table> 
        <table width="100%" class="table_button"> 
          <tr align="right"> 
            <td> 
			 <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
			 <button id='MACAdd_button'  type="button" onClick="clickAdd('MAC Filter');">添加</button>
             <button id='MACEdit_button' type="button" onclick="OnEditMacFilter();" >编辑</button>
             <button id='btnApply_ex' name="btnApply_ex"  type="button" onClick="Submit();">应用</button>
             <button id='MACDelete_button' name="MACDelete_button"  type="button" onClick="OnDeleteBtClick();">删除</button> </td>
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
