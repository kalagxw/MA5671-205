<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<title>Arp config</title>
<style type="text/css">
.tabnoline td
{
   border:0px;
}

 .firstCol
{
   width:24%;
   text-align:right ;
}

.secondCol
{
   width:24%;
}

.thirdCol
{
   width:20%;
   text-align:right ;
}

.alignledge
{
   width:3%;
}
</style>
<script language="JavaScript" type="text/javascript">
var selctIndex = -1;
var AddFlag = true;
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
		b.innerHTML = arp_language[b.getAttribute("BindText")];
	}
}

function stArp(domain,ipAddress,macAddress)
{
    this.domain = domain;
    this.ipAddress = ipAddress;
	this.macAddress = macAddress;
}

var Arps = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Arp.{i},IPAddress|MACAddress,stArp);%>
var Arp = new Array();
for (var i = 0; i < Arps.length-1; i++)
{
    Arp[i] = Arps[i];
}

function filterWan(WanItem)
{
	if(WanItem.IPv4Enable != 1)
	{
		return false;
	}
	
	if(WanItem.Status != "Connected")
	{
		return false;
	}

	return true;
}

var WanInfo =GetWanListByFilter(filterWan);

function stHost(Domain, IPInterfaceIPAddress, IPInterfaceSubnetMask)
{
    this.Domain = Domain;
	this.IPInterfaceIPAddress = IPInterfaceIPAddress;
	this.IPInterfaceSubnetMask = IPInterfaceSubnetMask;
}

var host = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},IPInterfaceIPAddress|IPInterfaceSubnetMask,stHost);%>;

function LoadFrame()
{ 
   if (Arp.length > 0)
   {
	   selectLine('record_0');
       setDisplay('ConfigForm',1);
   }	
   else
   {   
	   selectLine('record_no');
       setDisplay('ConfigForm',0);
   }

   loadlanguage();
   
   if(('TELECOM' == CfgModeWord.toUpperCase()) &&(curUserType != sysUserType))
   {  		 
        setDisable('Newbutton', 1);
        setDisable('DeleteButton', 1);
		setDisable('btnApply_ex', 1);
        setDisable('cancel', 1);
		setDisable('ipAddr', 1);
        setDisable('macAddr', 1);
   }
}


function AddSubmitParam(SubmitForm,type)
{							
	SubmitForm.addParameter('x.IPAddress',getValue('ipAddr'));	
	SubmitForm.addParameter('x.MACAddress',getValue('macAddr'));
	SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
	
	if( selctIndex == -1 )
	{
		 SubmitForm.setAction('add.cgi?x=InternetGatewayDevice.X_HW_Arp'
							+ '&RequestFile=html/bbsp/arp/arp.asp');
	}
	else
	{
	     SubmitForm.setAction('set.cgi?x=' + Arp[selctIndex].domain
							+ '&RequestFile=html/bbsp/arp/arp.asp');
	}
    setDisable('btnApply_ex',1);
    setDisable('cancel',1);
}

function setCtlDisplay(record)
{
    if (record == null)
    {
    	setText('ipAddr','');
    	setText('macAddr','');
    }
    else
    {
        setText('ipAddr',record.ipAddress);
    	setText('macAddr',record.macAddress);
    }
}

var g_Index = -1;
function setControl(index)
{
	var record;
	selctIndex = index;
	
    if (index == -1)
	{
	    if(Arp.length >= 32)
	    {
	        setDisplay('ConfigForm', 0);
		    AlertEx(arp_language['bbsp_arpfull']);
		    return;
	    }
	    record = null;
        AddFlag = true;
        setDisplay('ConfigForm', 1);
        setCtlDisplay(record);
	}
    else if (index == -2)
    {
        setDisplay('ConfigForm', 0);
    }
	else
	{
	    record = Arp[index];
        AddFlag = false;
        setDisplay('ConfigForm', 1);
        setCtlDisplay(record);
	}

    g_Index = index;
    setDisable('btnApply_ex',0);
    setDisable('cancel',0);
   if(('TELECOM' == CfgModeWord.toUpperCase()) &&(curUserType != sysUserType))
   {  		 
        setDisable('Newbutton', 1);
        setDisable('DeleteButton', 1);
		setDisable('btnApply_ex', 1);
        setDisable('cancel', 1);
		setDisable('ipAddr', 1);
        setDisable('macAddr', 1);
   }
}

function clickRemove() 
{ 
    if (Arp.length == 0)
	{
	    AlertEx(arp_language['bbsp_noarp']);
	    return;
	}
	
	if (selctIndex == -1)
	{
	    AlertEx(arp_language['bbsp_savearp']);
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
        AlertEx(arp_language['bbsp_selectarp']);
        return ;
    }
        
	if (ConfirmEx(arp_language['bbsp_confirm1']) == false)
	{
		document.getElementById("DeleteButton").disabled = false;
	    return;
    }
    setDisable('btnApply_ex',1);
    setDisable('cancel',1);
    removeInst('html/bbsp/arp/arp.asp');
}  

function CheckForm()
{	
    var IpAddress;
	var MacAddress;
    var right = 0;

	IpAddress = getValue('ipAddr');
	MacAddress = getValue('macAddr'); 
	
	if (IpAddress == "") 
	{
	    AlertEx(arp_language['bbsp_ipisreq']);
		return false;
	}    

	if (MacAddress == "")
	{
	    AlertEx(arp_language['bbsp_macisreq']);
		return false;
	}

	if((isAbcIpAddress(IpAddress) == false) || (isDeIpAddress(IpAddress) == true) 
       || (isBroadcastIpAddress(IpAddress) == true) || (isLoopIpAddress(IpAddress) == true) )
	{
	    AlertEx(arp_language['bbsp_ipaddr']+ IpAddress + arp_language['bbsp_invalid']);
		return false;
	}	
    
    for (var i = 0; i < Arp.length; i++)
    {
        if (selctIndex != i)
        {
            if (Arp[i].ipAddress == IpAddress)
            {
                AlertEx(arp_language['bbsp_iprepeat']);
                return false;
            }
        }
        else
        {
            continue;
        }
    }

    for (var i = 0; i < host.length-1; i++)
    {
        if (IpAddress == host[i].IPInterfaceIPAddress)
        {
            AlertEx(arp_language['bbsp_ipdifhost']);
            return false;
        }
        
        if (false == isSameSubNet(host[i].IPInterfaceIPAddress,host[i].IPInterfaceSubnetMask,IpAddress,host[i].IPInterfaceSubnetMask))
        {
            right = 0;
            continue;
        }
        else
        {
            right = 1;
            break;
        }
    }

    if (right != 1)
    {
        for (var i = 0; i < WanInfo.length; i++)
        {
            if ( WanInfo[i].IPv4IPAddress != '0.0.0.0' && WanInfo[i].IPv4SubnetMask != '0.0.0.0'
                && WanInfo[i].IPv4IPAddress != '' && WanInfo[i].IPv4SubnetMask != '' )
            {
                if (IpAddress == WanInfo[i].IPv4IPAddress)
                {
                    AlertEx(arp_language['bbsp_ipdifwan']);
                    return false;
                }
                
                if (false == isSameSubNet(WanInfo[i].IPv4IPAddress,WanInfo[i].IPv4SubnetMask,IpAddress,WanInfo[i].IPv4SubnetMask))
                {
                    right = 0;
                    continue;
                }
                else
                {
                    right = 1;
                    break;
                }
            }
        }
    }
    
    if (right != 1)
    {
        AlertEx(arp_language['bbsp_samesubnet']);
        return false;
    }

	if(isValidMacAddress(MacAddress) == false)
	{
	    AlertEx(arp_language['bbsp_macaddr']+ MacAddress + arp_language['bbsp_invalid']);
		return false;
	}	
   
   	return true;
}

function Cancel()
{
    setDisplay("ConfigForm", 0);
	
	if (AddFlag == true)
    {
        var tableRow = getElement("arpInst");
        
        if (tableRow.rows.length == 1)
        {
            selectLine('record_no');
        }
        else if (tableRow.rows.length == 2)
        {
            addNullInst('Arp');
        } 
        else
        {
            tableRow.deleteRow(tableRow.rows.length-1);
            selectLine('record_0');
        }
    }
    else
    {
        setText('ipAddr',Arp[selctIndex].ipAddress);
    	setText('macAddr',Arp[selctIndex].macAddress);
    }
    setDisable('btnApply_ex',0);
    setDisable('cancel',0);
}

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody">
<form id="ConfigForm1" action="">
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("arptitle", GetDescFormArrayById(arp_language, ""), GetDescFormArrayById(arp_language, "bbsp_arp_title"), false);
</script> 
<div class="title_spread"></div>

<script language="JavaScript" type="text/javascript">
	writeTabCfgHeader('Arp',"100%");
</script>
    <table class="tabal_bg" id="arpInst" cellpadding="0" cellspacing="1" width="100%">
        <tr class="head_title">
        	<td>&nbsp;  </td>
            <td  BindText='bbsp_ip'>  </td>
            <td  BindText='bbsp_mac'>  </td>
        </tr>
        <script language="JavaScript" type="text/javascript">
        if (Arp.length == 0)
        {
		    if(('TELECOM' == CfgModeWord.toUpperCase()) &&(curUserType != sysUserType))
	        {
                document.write('<TR id="record_no"'
       						    + '  class="tabal_01 align_center" onclick="selectLine(this.id);">');
                document.write('<TD >--</TD>');
                document.write('<TD >--</TD>');
                document.write('<TD >--</TD>');	
       		    document.write('</TR>');
	        }
			else
			{
			    document.write('<TR id="record_no"'
       						+ '  class="tabal_01 align_center" onclick="selectLine(this.id);">');
                document.write('<TD >--</TD>');
                document.write('<TD >--</TD>');
                document.write('<TD >--</TD>');	
       		    document.write('</TR>');
			}
        }
        else
        {
       	    for (i = 0;i < Arp.length; i++)
       	    {     
    		   		
				if(('TELECOM' == CfgModeWord.toUpperCase()) &&(curUserType != sysUserType))
	            {
                    document.write('<TR id="record_' + i 
       						    + '" class="tabal_01" onclick="selectLine(this.id);">');
                    document.write('<TD>' + '<input type="checkbox" name="rml" disabled="true"'  + ' value="' 
            	               + Arp[i].domain  + '">' + '</TD>');
       		        document.write('<TD>' + Arp[i].ipAddress + '</TD>');
       		        document.write('<TD>' + Arp[i].macAddress +'</TD>');	
       		        document.write('</TR>');
	            }
				else
				{
				    document.write('<TR id="record_' + i 
       						    + '" class="tabal_01" onclick="selectLine(this.id);">');
                    document.write('<TD>' + '<input type="checkbox" name="rml"'  + ' value="' 
            	               + Arp[i].domain  + '">' + '</TD>');
       		        document.write('<TD>' + Arp[i].ipAddress + '</TD>');
       		        document.write('<TD>' + Arp[i].macAddress + '</TD>');	
       		        document.write('</TR>');
				}
       		  
       	    }
        }
        </script>
    </table>
	
    <div id='ConfigForm' style="display:none">
	<div class="list_table_spread"></div>
    <table  class="tabal_bg"  cellpadding="0" cellspacing="1" width="100%"> 
        <tr>
            <td class="table_title width_per25" BindText='bbsp_ipmh'></td>
            <td class="table_right"> 
                <input type='text' id='ipAddr' name='ipAddr' size='10' style="width:123px"><font color="red">*</font></td>
        </tr>
        
        <tr>
            <td class="table_title" BindText='bbsp_macmh'></td>
            <td class="table_right"> 
                <input type='text' id='macAddr' name='macAddr' size='10' style="width:123px">
				<strong class="color_red">*</strong><span class="gray"><script>document.write(arp_language['bbsp_macaddrform']);</script></span></td>

        </tr>
    
        
    </table>
     <table   cellpadding="0" cellspacing="0" width="100%" class="table_button"> 
       <tr>
	      <td class="width_per25"></td>
            <td class="table_submit">
				<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
                <button id="btnApply_ex" name="btnApply_ex" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="Submit();"><script>document.write(arp_language['bbsp_app']);</script></button>
                <button id="cancel" name="cancel" type="button" class="CancleButtonCss buttonwidth_100px" onClick="Cancel();"><script>document.write(arp_language['bbsp_cancel']);</script></button>
            </td>
          
        </tr>
    </table>
    </div> 
<script language="JavaScript" type="text/javascript">
    writeTabTail();
</script>
</form>
</body>
</html>

