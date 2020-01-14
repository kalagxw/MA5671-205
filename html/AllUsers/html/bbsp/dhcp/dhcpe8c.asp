<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<title>Chinese -- DHCP Configure</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="javascript" src="../../bbsp/common/dhcpinfo.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">

function dhcpmainst(domain,enable,startip,endip,SubnetMask,leasetime,l2relayenable,HGWstartip,HGWendip,STBstartip,STBendip,Camerastartip,Cameraendip,Computerstartip,Computerendip,Phonestartip,Phoneendip,X_HW_Option60Enable,X_HW_Option125Enable)
{
	this.domain 	= domain;
	this.enable		= enable;
	this.startip	= startip;
	this.endip		= endip;
	this.SubnetMask = SubnetMask;
	this.leasetime  = leasetime;
	this.l2relayenable = l2relayenable;
	this.HGWstartip = HGWstartip;
	this.HGWendtip = HGWendip;
	this.STBstartip = STBstartip;
	this.STBendtip = STBendip;	
	this.Camerastartip = Camerastartip;
	this.Cameraendtip = Cameraendip;
	this.Computerstartip = Computerstartip;
	this.Computerendtip = Computerendip;		
	this.Phonestartip = Phonestartip;
	this.Phoneendtip = Phoneendip;	
	this.X_HW_Option60Enable = X_HW_Option60Enable;
	this.X_HW_Option125Enable = X_HW_Option125Enable;
}

function stipaddr(domain,enable,ipaddr,subnetmask)
{
	this.domain		= domain;
	this.enable		= enable;
	this.ipaddr		= ipaddr;
	this.subnetmask	= subnetmask;	
}

function stipaddrpool(startip,endip)
{
	this.startip	= startip;
	this.endip	= endip;
}

var MainDhcpRange = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement,DHCPServerEnable|MinAddress|MaxAddress|SubnetMask|DHCPLeaseTime|X_HW_DHCPL2RelayEnable|X_HW_HGWStart|X_HW_HGWEnd|X_HW_STBStart|X_HW_STBEnd|X_HW_CameraStart|X_HW_CameraEnd|X_HW_ComputerStart|X_HW_ComputerEnd|X_HW_PhoneStart|X_HW_PhoneEnd|X_HW_Option60Enable|X_HW_Option125Enable,dhcpmainst);%>;    

var LanIpInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},Enable|IPInterfaceIPAddress|IPInterfaceSubnetMask,stipaddr);%>;

var dhcpmain = MainDhcpRange[0];

var specialOption="";
var addOptionFlag = 0;
function setShowTime(dhcpLease,timeUnits)
{
	var strTime = "";
	var timeHead = dhcpLease/timeUnits;
    var infinite = ((dhcpLease == "-1") || (dhcpLease == "4294967295"));
	switch (timeUnits)
	{
		case 60:
			Units = "分";
			break;
		case 3600:
			Units = "小时";
			break;
		case 86400:
			Units = "天";
			break;
		case 604800:
			Units = "周";
			break;
		default:
			break;
	}
	if(1 == timeHead){
	    setSelect('LanLeaseTime_select', timeUnits);
    }else{
		if (0 == addOptionFlag)
		{
			strTime = timeHead + Units;
            if(infinite)
            {
                addOption('LanLeaseTime_select','infinite',dhcpLease, dhcp_language['bbsp_infinitetime']);
            }
            else
            {
                addOption('LanLeaseTime_select',strTime,dhcpLease,strTime);
            }
			setSelect('LanLeaseTime_select', dhcpLease);
			specialOption = dhcpLease;
			addOptionFlag = 1;
		}
    }
}


function setLease(dhcpLease, flag)
{
    var i = 0;
    var timeUnits = 604800;

    for(i = 0; i < 4; i++)
    {
        if (i == 0 )
        {
            timeUnits  = 604800;
        }
        else if (i == 1)
        {
            timeUnits  = 86400;
        }
        else if (i == 2)
        {
            timeUnits  = 3600;
        }
        else
        {
            timeUnits  = 60;                    
        }
          
        if ( true == isInteger(dhcpLease / timeUnits) )
        {
            break; 
        }          
    }  

    if ( flag == "main" )
    {
        setSelect('maindhcpLeasedTimeFrag', timeUnits);
        setShowTime(dhcpLease,timeUnits);
    }
    else
    {
        AlertEx(dhcp_language['bbsp_poolinvalid']);
    }
}

function Showdhcp1() 
{
    with ( document.forms[0] ) 
   	{
		setText('LanIP_Address_text',LanHostInfo.ipaddr);
		setText('LanSubmask_text',LanHostInfo.subnetmask);
	}
}

function LoadFrame() 
{
   with ( document.forms[0] ) 
   {    
   		setMainDhcp();
	} 
	Showdhcp1();
	setDisable('Apply_button', 0);

}

function setDiplayDataComputer(MainDhcpRange)
{
	setText('LanPC_StartAddress_text', MainDhcpRange.Computerstartip);
	setText('LanPC_EndAddress_text', MainDhcpRange.Computerendtip);
	if ((MainDhcpRange.Computerstartip != "") && (MainDhcpRange.Computerendtip != ""))
	{
		getElement('LanPC_checkbox').checked = true;
	}
	else
	{
		getElement('LanPC_checkbox').checked = false;
	}
}

function setDiplayDataSTB(MainDhcpRange)
{
	setText('LanSTB_StartAddress_text', MainDhcpRange.STBstartip);
	setText('LanSTB_EndAddress_text', MainDhcpRange.STBendtip);	
	if ((MainDhcpRange.STBstartip != "") && (MainDhcpRange.STBendtip != ""))
	{
		getElement('LanSTB_checkbox').checked = true;
	}
	else
	{
		getElement('LanSTB_checkbox').checked = false;
	}
}

function setDiplayDataPhone(MainDhcpRange)
{
	setText('LanPhone_StartAddress_text', MainDhcpRange.Phonestartip);
	setText('LanPhone_EndAddress_text', MainDhcpRange.Phoneendtip);
	if ((MainDhcpRange.Phonestartip != "") && (MainDhcpRange.Phoneendtip != ""))
	{
		getElement('LanPhone_checkbox').checked = true;
	}
	else
	{
		getElement('LanPhone_checkbox').checked = false;
	}
}

function setDiplayDataCamera(MainDhcpRange)
{
	setText('LanCamera_StartAddress_text', MainDhcpRange.Camerastartip);
	setText('LanCamera_EndAddress_text', MainDhcpRange.Cameraendtip);
	if ((MainDhcpRange.Camerastartip != "") && (MainDhcpRange.Cameraendtip != ""))
	{
		getElement('LanCamera_checkbox').checked = true;
	}
	else
	{
		getElement('LanCamera_checkbox').checked = false;
	}
}

function setMainDhcp()
{
	with(document.forms[0])
	{
		if (1 == MainDhcpRange[0].enable)
		{
			getElement('Lan_DHCP_checkbox').checked = true;
		}
		else
		{
			getElement('Lan_DHCP_checkbox').checked = false;
		}
		
		if (1 == MainDhcpRange[0].X_HW_Option60Enable)
		{
			getElement('LanAddressRange_checkbox').checked = true;
		}
		else
		{
			getElement('LanAddressRange_checkbox').checked = false;
		}

		setText('LanStartAddress_text', MainDhcpRange[0].startip);
		setText('LanEndAddress_text', MainDhcpRange[0].endip);
		setText('LanDHCP_Submask_text', MainDhcpRange[0].SubnetMask);
		
		setDiplayDataComputer(MainDhcpRange[0]);
		setDiplayDataSTB(MainDhcpRange[0]);
		setDiplayDataPhone(MainDhcpRange[0]);
		setDiplayDataCamera(MainDhcpRange[0]);
		
		setLease(dhcpmain.leasetime, "main");
		SetDHCPServerDisplay(MainDhcpRange[0].enable);
	}
}


function checkPoolPara() 
{
	with ( document.forms[0] ) 
	{
		var poolParaAll = new Array(new stipaddrpool(LanPC_StartAddress_text.value, LanPC_EndAddress_text.value),
							   new stipaddrpool(LanSTB_StartAddress_text.value, LanSTB_EndAddress_text.value),
							   new stipaddrpool(LanPhone_StartAddress_text.value, LanPhone_EndAddress_text.value),
							   new stipaddrpool(LanCamera_StartAddress_text.value, LanCamera_EndAddress_text.value));  
		var deviceTypeAll = new Array('Computer', 'STB', 'Phone', 'Camera'); 
		
		var poolPara = new Array();
		var deviceType = new Array();
		var index = 0;
		var indexTemp = 0;
		var num = 0;
		
		var enableLanDHCP = (true == getElement('Lan_DHCP_checkbox').checked) ? 1 : 0;
		var enableComputer = (true == getElement('LanPC_checkbox').checked) ? 1 : 0;
		var enableSTB = (true == getElement('LanSTB_checkbox').checked) ? 1 : 0;
		var enablePhone = (true == getElement('LanPhone_checkbox').checked) ? 1 : 0;
		var enableCamera = (true == getElement('LanCamera_checkbox').checked) ? 1 : 0;

		

			if (1 == enableComputer)
			{
				poolPara.push(poolParaAll[0]);
				deviceType.push(deviceTypeAll[0]); 
				num++;
			}
			
			if (1 == enableSTB)
			{
				poolPara.push(poolParaAll[1]);
				deviceType.push(deviceTypeAll[1]); 
				num++;
			}
			
			if (1 == enablePhone)
			{
				poolPara.push(poolParaAll[2]);
				deviceType.push(deviceTypeAll[2]); 
				num++;
			}
			
			if (1 == enableCamera)
			{
				poolPara.push(poolParaAll[3]);
				deviceType.push(deviceTypeAll[3]); 
				num++;
			}

	  
		
			for (index=0;index<num;index++)
			{
				if (("" == poolPara[index].startip) && ("" == poolPara[index].endip))
				{
				   continue;
				}
				
				if (isValidIpAddress(poolPara[index].startip) == false)
				{
				   AlertEx(dhcp_language['bbsp_startipaddr']+deviceType[index] +dhcp_language['bbsp_pridhcpserinvalid']);
				   return false;
				}

                if (isBroadcastIp(poolPara[index].startip, getValue('LanSubmask_text')) == true)
				{
					AlertEx(dhcp_language['bbsp_startipaddr']+deviceType[index] +dhcp_language['bbsp_pridhcpserinvalid']);
					return false;
				}
				
                if (false == isSameSubNet(poolPara[index].startip, getValue('LanSubmask_text'), getValue('LanEndAddress_text'), getValue('LanSubmask_text')))
				{
					AlertEx(dhcp_language['bbsp_startipaddr']+deviceType[index] +dhcp_language['bbsp_pridhcpsermustsamehost']);
					return false;
				}

				if (!(isEndGTEStart(poolPara[index].startip, LanStartAddress_text.value)))
				{
					AlertEx(dhcp_language['bbsp_startipaddr']+deviceType[index] +dhcp_language['bbsp_pridhcpmustinpriserpool']);
					return false;
				}

				if (isValidIpAddress(poolPara[index].endip) == false) 
				{
					AlertEx(dhcp_language['bbsp_startipaddr']+deviceType[index] +dhcp_language['bbsp_pridhcpinvalid']);
					return false;
				}
				
                if(isBroadcastIp(poolPara[index].endip, getValue('LanSubmask_text')) == true)
				{
					AlertEx(dhcp_language['bbsp_startipaddr']+deviceType[index] +dhcp_language['bbsp_pridhcpinvalid']);
					return false;
				}

                if (false == isSameSubNet(poolPara[index].endip,getValue('LanSubmask_text'),getValue('LanEndAddress_text'),getValue('LanSubmask_text')))
				{
					AlertEx(dhcp_language['bbsp_startipaddr']+deviceType[index] +dhcp_language['bbsp_pridhcpsermustsamesubhost']);
					return false;
				}
   
				if (!(isEndGTEStart(poolPara[index].endip, poolPara[index].startip))) 
				{
					AlertEx(dhcp_language['bbsp_startipaddr']+deviceType[index] +dhcp_language['bbsp_pridhcpsermustgtrstip']);
					return false;
				}

				if (!(isEndGTEStart(LanEndAddress_text.value, poolPara[index].endip)))
				{
					AlertEx(dhcp_language['bbsp_startipaddr']+deviceType[index] +dhcp_language['bbsp_pridhcpsermustinpripool']);
					return false;
				}
			}

			for (index=0;index<num;index++)
			{
				if (("" == poolPara[index].startip) && ("" == poolPara[index].endip))
				{
					continue;
				}  
			
				for (indexTemp=index+1;indexTemp<num;indexTemp++)
				{
					if (("" == poolPara[indexTemp].startip) && ("" == poolPara[indexTemp].endip))
					{
						continue;
					} 
			
					if ( (isEndGTEStart(poolPara[indexTemp].startip, poolPara[index].startip) && isEndGTEStart(poolPara[index].endip, poolPara[indexTemp].startip) ) 
					|| (isEndGTEStart(poolPara[index].startip, poolPara[indexTemp].startip) && isEndGTEStart(poolPara[indexTemp].endip, poolPara[index].startip) ))
					{
						AlertEx(dhcp_language['bbsp_startipaddr']+''+deviceType[index] +dhcp_language['bbsp_poolandtype']+deviceType[indexTemp] +dhcp_language['bbsp_secpoolconflict']);
						return false;		   
					}
				}	
			}		
	}   
    return true;
}

function CheckForm(type) 
{
	if (false == CheckParaDhcp1())
	{
		LoadFrame();
		return false;
	}
	
   with ( document.forms[0] ) 
   {  
	  var enableLanDHCP = (true == getElement('Lan_DHCP_checkbox').checked) ? 1 : 0;

     

        if (isValidIpAddress(LanStartAddress_text.value) == false)
        {       
            AlertEx(dhcp_language['bbsp_pridhcpstipinvalid']);
			LoadFrame();
            return false;
        }

        if (isBroadcastIp(LanStartAddress_text.value, getValue('LanSubmask_text')) == true)
        {
            AlertEx(dhcp_language['bbsp_pridhcpstipinvalid']);
			LoadFrame();
            return false;
        }
		
		if (isValidSubnetMask(LanDHCP_Submask_text.value) == false ) 
		{
			 AlertEx(dhcp_language['bbsp_subnetmaskp'] + LanDHCP_Submask_text.value + dhcp_language['bbsp_isinvalidp']);
			 LoadFrame();
			 return false;
		}
		
		if ( isMaskOf24BitOrMore(LanDHCP_Submask_text.value) == false ) 
		{
			AlertEx(dhcp_language['bbsp_subnetmaskp'] + LanDHCP_Submask_text.value + dhcp_language['bbsp_isinvalidp']);
			return false;
		}

		if (false == isSameSubNet(getValue('LanStartAddress_text'),getValue('LanSubmask_text'),getValue('LanIP_Address_text'),getValue('LanSubmask_text')))
        {
            AlertEx(dhcp_language['bbsp_pridhcpstipmustsamesubhost']);
			LoadFrame();
            return false;
        }

        if (isValidIpAddress(LanEndAddress_text.value) == false) 
        {
            AlertEx(dhcp_language['bbsp_dhcpendipinvalid']);
			LoadFrame();
            return false;
        }

        if(isBroadcastIp(LanEndAddress_text.value, getValue('LanSubmask_text')) == true)
        {
            AlertEx(dhcp_language['bbsp_dhcpendipinvalid']);
			LoadFrame();
            return false;
        }

		if (false == isSameSubNet(getValue('LanEndAddress_text'),getValue('LanSubmask_text'),getValue('LanIP_Address_text'),getValue('LanSubmask_text')))
        {
            AlertEx(dhcp_language['bbsp_pridhcpedipmustsamesubhost']);
			LoadFrame();
            return false;
        }

        if (!(isEndGTEStart(LanEndAddress_text.value, LanStartAddress_text.value))) 
        {
            AlertEx(dhcp_language['bbsp_priendipgeqstartip']);
			LoadFrame();
            return false;
        }

        if (false == checkLease(dhcp_language['bbsp_pripool'],MainLeasedTime.value,maindhcpLeasedTimeFrag.value,dhcp_language))
    	{
			LoadFrame();
			return false;
		}
    }   

    if (false == checkPoolPara())
    {
		LoadFrame();
        return false;
    }

  	setDisable('Apply_button', 1);

    return true;
}

function AddSubmitParam(Form,type)
{
	 with (document.forms[0])
	 {
		Form.addParameter('t.IPInterfaceIPAddress',getValue('LanIP_Address_text'));
		Form.addParameter('t.IPInterfaceSubnetMask',getValue('LanSubmask_text'));
		
		var enableLanDHCP = (true == getElement('Lan_DHCP_checkbox').checked) ? 1 : 0;
		Form.addParameter('z.DHCPServerEnable',enableLanDHCP);
		var enableDhcpMainOption60 = (true == getElement('LanAddressRange_checkbox').checked) ? 1 : 0;
		Form.addParameter('z.X_HW_Option60Enable',enableDhcpMainOption60);

		Form.addParameter('z.MinAddress',getValue('LanStartAddress_text'));
		Form.addParameter('z.MaxAddress',getValue('LanEndAddress_text'));
		Form.addParameter('z.SubnetMask',getValue('LanDHCP_Submask_text'));
		Form.addParameter('z.DHCPLeaseTime',getValue('LanLeaseTime_select'));

		var enableComputer = (true == getElement('LanPC_checkbox').checked) ? 1 : 0;
		var enableSTB = (true == getElement('LanSTB_checkbox').checked) ? 1 : 0;
		var enablePhone = (true == getElement('LanPhone_checkbox').checked) ? 1 : 0;
		var enableCamera = (true == getElement('LanCamera_checkbox').checked) ? 1 : 0;
		if (1 == enableComputer)
		{
			Form.addParameter('z.X_HW_ComputerStart',getValue('LanPC_StartAddress_text'));
			Form.addParameter('z.X_HW_ComputerEnd',getValue('LanPC_EndAddress_text'));
		}
		else
		{
			Form.addParameter('z.X_HW_ComputerStart','');
			Form.addParameter('z.X_HW_ComputerEnd','');
		}

		if (1 == enableSTB)
		{
			Form.addParameter('z.X_HW_STBStart',getValue('LanSTB_StartAddress_text'));
			Form.addParameter('z.X_HW_STBEnd',getValue('LanSTB_EndAddress_text'));
		}
		else
		{
			Form.addParameter('z.X_HW_STBStart','');
			Form.addParameter('z.X_HW_STBEnd','');
		}
		
		if (1 == enablePhone)
		{
			Form.addParameter('z.X_HW_PhoneStart',getValue('LanPhone_StartAddress_text'));
			Form.addParameter('z.X_HW_PhoneEnd',getValue('LanPhone_EndAddress_text'));
		}
		else
		{
			Form.addParameter('z.X_HW_PhoneStart','');
			Form.addParameter('z.X_HW_PhoneEnd','');
		}
		
		if (1 == enableCamera)
		{
			Form.addParameter('z.X_HW_CameraStart',getValue('LanCamera_StartAddress_text'));
			Form.addParameter('z.X_HW_CameraEnd',getValue('LanCamera_EndAddress_text'));
		}
		else
		{
			Form.addParameter('z.X_HW_CameraStart','');
			Form.addParameter('z.X_HW_CameraEnd','');
		}
	}	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	
	var RequestFile = 'html/bbsp/dhcp/dhcpe8c.asp';
	var urlpara;

        urlpara = 't=InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.1'
                  + '&x=InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.2'
                  + '&z=InternetGatewayDevice.LANDevice.1.LANHostConfigManagement'
                  + '&RequestFile=' + RequestFile;
    
    var url = 'set.cgi?' + urlpara;

    Form.setAction(url);	
	setDisable('Lan_DHCP_checkbox',1);
}

function SetMainDHCPServer()
{
	var enable = (true == getElement('Lan_DHCP_checkbox').checked) ? 1 : 0;

	SetDHCPServerDisplay(enable)
}

function SetDHCPServerDisplay(value)
{
	var cbComputer = (true == getElement('LanPC_checkbox').checked) ? 1 : 0;
	var cbSTB = (true == getElement('LanSTB_checkbox').checked) ? 1 : 0;
	var cbPhone = (true == getElement('LanPhone_checkbox').checked) ? 1 : 0;
	var cbCamera = (true == getElement('LanCamera_checkbox').checked) ? 1 : 0;

	if ( value == 1 || value == '1' )
	{
		setDisable("LanStartAddress_text",0);
		setDisable("LanEndAddress_text",0);
		setDisable("LanDHCP_Submask_text",0);
		setDisable("MainLeasedTime",0);
		setDisable("maindhcpLeasedTimeFrag",0);
		setDisable("LanLeaseTime_select",0);
		
		setDisable("LanPC_checkbox",0);
		if (1 == cbComputer)
		{
			setDisable("LanPC_StartAddress_text",0);
			setDisable("LanPC_EndAddress_text",0);	
		}
		else
		{
			setDisable("LanPC_StartAddress_text",1);
			setDisable("LanPC_EndAddress_text",1);	
		}
		setDisable("LanSTB_checkbox",0);
		if (1 == cbSTB)
		{
			setDisable("LanSTB_StartAddress_text",0);
			setDisable("LanSTB_EndAddress_text",0);	
		}
		else
		{
			setDisable("LanSTB_StartAddress_text",1);
			setDisable("LanSTB_EndAddress_text",1);	
		}
		setDisable("LanPhone_checkbox",0);
		if (1 == cbPhone)
		{
			setDisable("LanPhone_StartAddress_text",0);
			setDisable("LanPhone_EndAddress_text",0);
		}
		else
		{
			setDisable("LanPhone_StartAddress_text",1);
			setDisable("LanPhone_EndAddress_text",1);
		}	
		setDisable("LanCamera_checkbox",0);
		if (1 == cbCamera)
		{
			setDisable("LanCamera_StartAddress_text",0);
			setDisable("LanCamera_EndAddress_text",0);
		}
		else
		{
			setDisable("LanCamera_StartAddress_text",1);
			setDisable("LanCamera_EndAddress_text",1);
		}		
	}
	else
	{	    
		setDisable("LanStartAddress_text",1);
		setDisable("LanEndAddress_text",1);
		setDisable("LanDHCP_Submask_text",1);
		setDisable("MainLeasedTime",1);
		setDisable("maindhcpLeasedTimeFrag",1);
		setDisable("LanLeaseTime_select",1);
		
		setDisable("LanPC_checkbox",1);
		setDisable("LanPC_StartAddress_text",1);
		setDisable("LanPC_EndAddress_text",1);
		setDisable("LanSTB_checkbox",1);	
		setDisable("LanSTB_StartAddress_text",1);
		setDisable("LanSTB_EndAddress_text",1);
		setDisable("LanPhone_checkbox",1);
		setDisable("LanPhone_StartAddress_text",1);
		setDisable("LanPhone_EndAddress_text",1);
		setDisable("LanCamera_checkbox",1);
		setDisable("LanCamera_StartAddress_text",1);
		setDisable("LanCamera_EndAddress_text",1);		
	}
}

function SetDhcpMainOption60()
{
	var dhcpMainOption60 = (true == getElement('LanAddressRange_checkbox').checked) ? 1 : 0;
	var cbComputer = (true == getElement('LanPC_checkbox').checked) ? 1 : 0;
	var cbSTB = (true == getElement('LanSTB_checkbox').checked) ? 1 : 0;
	var cbPhone = (true == getElement('LanPhone_checkbox').checked) ? 1 : 0;
	var cbCamera = (true == getElement('LanCamera_checkbox').checked) ? 1 : 0;
	
	if (1 == dhcpMainOption60)
	{
		setDisable("LanPC_checkbox",0);
		setDisable("LanSTB_checkbox",0);
		setDisable("LanPhone_checkbox",0);
		setDisable("LanCamera_checkbox",0);
		
		if (1 == cbComputer)
		{
			setDisable("LanPC_StartAddress_text",0);
			setDisable("LanPC_EndAddress_text",0);
		}
		else
		{
			setDisable("LanPC_StartAddress_text",1);
			setDisable("LanPC_EndAddress_text",1);
		}
		
		if (1 == cbSTB)
		{
			setDisable("LanSTB_StartAddress_text",0);
			setDisable("LanSTB_EndAddress_text",0);	
		}
		else
		{
			setDisable("LanSTB_StartAddress_text",1);
			setDisable("LanSTB_EndAddress_text",1);	
		}
		
		if (1 == cbPhone)
		{
			setDisable("LanPhone_StartAddress_text",0);
			setDisable("LanPhone_EndAddress_text",0);
		}
		else
		{
			setDisable("LanPhone_StartAddress_text",1);
			setDisable("LanPhone_EndAddress_text",1);
		}
		
		if (1 == cbCamera)
		{
			setDisable("LanCamera_StartAddress_text",0);
			setDisable("LanCamera_EndAddress_text",0);
		}
		else
		{
			setDisable("LanCamera_StartAddress_text",1);
			setDisable("LanCamera_EndAddress_text",1);
		}
	}
	else
	{
		setDisable("LanPC_checkbox",1);
		setDisable("LanPC_StartAddress_text",1);
		setDisable("LanPC_EndAddress_text",1);
		setDisable("LanSTB_checkbox",1);
		setDisable("LanSTB_StartAddress_text",1);
		setDisable("LanSTB_EndAddress_text",1);	
		setDisable("LanPhone_checkbox",1);
		setDisable("LanPhone_StartAddress_text",1);
		setDisable("LanPhone_EndAddress_text",1);		
		setDisable("LanCamera_checkbox",1);
		setDisable("LanCamera_StartAddress_text",1);
		setDisable("LanCamera_EndAddress_text",1);
	}
}

function SetComputer()
{
	var cbComputer = (true == getElement('LanPC_checkbox').checked) ? 1 : 0;
	var enable = (1 == cbComputer) ? 0 : 1;
	setDisable("LanPC_StartAddress_text",enable);
	setDisable("LanPC_EndAddress_text",enable);
}

function SetSTB()
{	
	var cbSTB = (true == getElement('LanSTB_checkbox').checked) ? 1 : 0;
	var enable = (1 == cbSTB) ? 0 : 1;
	setDisable("LanSTB_StartAddress_text",enable);
	setDisable("LanSTB_EndAddress_text",enable);
}

function SetPhone()
{	
	var cbPhone = (true == getElement('LanPhone_checkbox').checked) ? 1 : 0;
	var enable = (1 == cbPhone) ? 0 : 1;
	setDisable("LanPhone_StartAddress_text",enable);
	setDisable("LanPhone_EndAddress_text",enable);
}

function SetCamera()
{	
	var cbCamera = (true == getElement('LanCamera_checkbox').checked) ? 1 : 0;
	var enable = (1 == cbCamera) ? 0 : 1;
	setDisable("LanCamera_StartAddress_text",enable);
	setDisable("LanCamera_EndAddress_text",enable);
}
function OnLeaseChange()
{
    removeOption('LanLeaseTime_select',specialOption);
}
function CancelConfig()
{
    LoadFrame();
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<form id="ConfigForm" action="../network/set.cgi"> 
  <table width="100%" border="0" cellpadding="0" cellspacing="1"> 
	  <tr> 
		<td width="100%" style="font-weight: bold;"><script>document.write(dhcp_language['bbsp_e8c_dhcptitle1']);</script></td> 
	  </tr> 
	  <tr> 
		  <td class="height10p"></td> 
	  </tr> 
	  <tr> 
		<td class="title_common" width="100%"><script>document.write(dhcp_language['bbsp_e8c_dhcptitle2']);</script></td> 
	  </tr> 
	  <tr> 
		  <td class="height10p"></td> 
	  </tr> 
  </table> 
  
  <table width="100%" border="0" cellpadding="0" cellspacing="0"  border="0"> 
  <tr> 
    <td width="25%" class="table_title"><script>document.write(dhcp_language['bbsp_ip']);</script></td> 
    <td width="75%" class="table_right"> <input type='text' name='LanIP_Address_text' id='LanIP_Address_text' maxlength='15' size='15'> 
      <font color="red">*</font> </td> 
  </tr> 
  </table> 
  <table width="100%" border="0" cellpadding="0" cellspacing="0"  border="0"> 
	  <tr> 
		<td width="25%" class="table_title"><script>document.write(dhcp_language['bbsp_ethIpMask']);</script></td> 
		<td width="75%" class="table_right"> <input type='text' name='LanSubmask_text' id='LanSubmask_text' maxlength='15' size='15'> 
		  <font color="red">*</font> </td> 
	  </tr> 
  </table> 
  <table>
   <tr> 
	 <td class="height10p"></td> 
  </tr> 
  </table>
  
  <div id="DhcpServerPanel"> 
  	<table width="100%" border="0" cellpadding="0" cellspacing="0"> 
		<tr> 
			<td class="table_title"> <input type='checkbox' value='True' id='Lan_DHCP_checkbox' name='Lan_DHCP_checkbox' onClick='SetMainDHCPServer();'> <script>document.write(dhcp_language['bbsp_dhcpServer']);</script></td> 
		</tr>
	</table>
    <table width="100%" border="0" cellpadding="0" cellspacing="0"> 
      <tr> 
        <td width="25%" class="table_title"><script>document.write(dhcp_language['bbsp_startaddr']);</script></td> 
        <td width="75%" class="table_right"> <input type='text' name='LanStartAddress_text' id='LanStartAddress_text' maxlength='15' size='15'> 
          <font color="red">*</font> <span class="gray"><script>document.write(dhcp_language['bbsp_mustbesamesubnet']);</script></span> </td> 
      </tr> 
      <tr > 
        <td width="25%" class="table_title"><script>document.write(dhcp_language['bbsp_endaddr']);</script></td> 
        <td width="75%" class="table_right"> <input type='text' name='LanEndAddress_text' id='LanEndAddress_text' maxlength='15' size='15'> 
          <font color="red">*</font> </td> 
      </tr> 
	  <tr> 
        <td width="25%" class="table_title"><script>document.write(dhcp_language['bbsp_ethIpMask']);</script></td> 
        <td width="75%" class="table_right"> <input type='text' name='LanDHCP_Submask_text' id='LanDHCP_Submask_text' maxlength='15' size='15'> 
		  <font color="red">*</font> </td> 
      </tr> 
      <tr id="MainLeasedTimeTr" style="display:none;"> 
        <td width="25%" class="table_title"><script>document.write(dhcp_language['bbsp_e8c_main_leaseTime']);</script></td> 
        <td width="75%" class="table_right"> <input type="text" name="MainLeasedTime" id="MainLeasedTime" value="1" size="6"> 
          <select name='maindhcpLeasedTimeFrag' id='maindhcpLeasedTimeFrag' size='1'> 
            <option value='60'><script>document.write(dhcp_language['bbsp_minute']);</script>
            <option value='3600'><script>document.write(dhcp_language['bbsp_hour']);</script>
            <option value='86400'><script>document.write(dhcp_language['bbsp_day']);</script>
            <option value='604800'><script>document.write(dhcp_language['bbsp_week']);</script>
          </select> </td> 
      </tr> 
	  
	  <tr>
		  <td width="25%" class="table_title"><script>document.write(dhcp_language['bbsp_e8c_main_leaseTime1']);</script></td> 
		  <td width="75%" class="table_right"> <span id="MainLeasedShowTime"></span>
			<select id='LanLeaseTime_select' name='LanLeaseTime_select' size='1' style="width: 65px" onMousedown="OnLeaseChange();""> 
				<option value='60'><script>document.write(dhcp_language['bbsp_1minute']);</script>
				<option value='3600'><script>document.write(dhcp_language['bbsp_1hour']);</script>
				<option value='86400'><script>document.write(dhcp_language['bbsp_1day']);</script>
				<option value='604800'><script>document.write(dhcp_language['bbsp_1week']);</script>
		    </select> </td> 
	  </tr>
    </table> 
	<table>
   	<tr> 
	 <td class="height10p"></td> 
  </tr> 
  </table>
  </div> 
  
  <div id="PoolSectionPanel"> 
  	<table width="100%" border="0" cellpadding="0" cellspacing="0"> 
		<tr> 
			<td class="table_title"> <input type='checkbox' value='True' id='LanAddressRange_checkbox' name='LanAddressRange_checkbox' onClick=''> <script>document.write(dhcp_language['bbsp_main_option601']);</script></td> 

		</tr>
	</table>
    <table width="100%" border="0" cellpadding="0" cellspacing="0"> 
	  <tr class="table_right"> 
        <td class="table_title"><input type='checkbox' value='True' id='LanPC_checkbox' name='LanPC_checkbox' onClick='SetComputer();'><script>document.write(dhcp_language['bbsp_computere8c']);</script></td> 
        <td><script>document.write(dhcp_language['bbsp_ComputerStartIp']);</script></td> 
        <td><input type='text' name='LanPC_StartAddress_text' id='LanPC_StartAddress_text' maxlength='15' size='15'></td>
        <td><script>document.write(dhcp_language['bbsp_ComputerEndIp']);</script></td> 
        <td><input type='text' name='LanPC_EndAddress_text' id='LanPC_EndAddress_text' maxlength='15' size='15'></td>
      </tr> 
      <tr class="table_right"> 
        <td class="table_title"><input type='checkbox' value='True' id='LanSTB_checkbox' name='LanSTB_checkbox' onClick='SetSTB();'><script>document.write(dhcp_language['bbsp_stbe8c']);</script></td> 
	    <td><script>document.write(dhcp_language['bbsp_STBStartIp']);</script></td> 
	    <td><input type='text' name='LanSTB_StartAddress_text' id='LanSTB_StartAddress_text' maxlength='15' size='15'></td>
        <td><script>document.write(dhcp_language['bbsp_STBEndIp']);</script></td> 
        <td><input type='text' name='LanSTB_EndAddress_text' id='LanSTB_EndAddress_text' maxlength='15' size='15'></td> 
      </tr> 
      <tr class="table_right"> 
        <td class="table_title"><input type='checkbox' value='True' id='LanPhone_checkbox' name='LanPhone_checkbox' onClick='SetPhone();'><script>document.write(dhcp_language['bbsp_phonee8c']);</script></td> 
        <td><script>document.write(dhcp_language['bbsp_PhoneStartIp']);</script></td> 
        <td><input type='text' name='LanPhone_StartAddress_text' id='LanPhone_StartAddress_text' maxlength='15' size='15'></td>
        <td><script>document.write(dhcp_language['bbsp_PhoneEndIp']);</script></td> 
        <td><input type='text' name='LanPhone_EndAddress_text' id='LanPhone_EndAddress_text' maxlength='15' size='15'></td>
      </tr> 
	  <tr class="table_right">  
        <td class="table_title"><input type='checkbox' value='True' id='LanCamera_checkbox' name='LanCamera_checkbox' onClick='SetCamera();'><script>document.write(dhcp_language['bbsp_camerae8c']);</script></td> 
        <td><script>document.write(dhcp_language['bbsp_CameraStartIp']);</script></td> 
        <td><input type='text' name='LanCamera_StartAddress_text' id='LanCamera_StartAddress_text' maxlength='15' size='15'></td>
        <td><script>document.write(dhcp_language['bbsp_CameraEndIp']);</script></td> 
        <td><input type='text' name='LanCamera_EndAddress_text' id='LanCamera_EndAddress_text' maxlength='15' size='15'></td>
      </tr> 
    </table> 
  </div> 
  <table width="100%" border="0"  class="table_button"> 
    <tr align="right">
      <td width="25%"></td> 
      <td >
	  	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
        <button id="Apply_button" type="button" class="submit" onClick="Submit(0);"><script>document.write(dhcp_language['bbsp_saveapp']);</script></button>
      </td>
    </tr> 
  </table> 
</form> 
<script language="JavaScript" type="text/javascript">
function stLanHostInfo(domain,ipaddr,subnetmask)
{
	this.domain = domain;
	this.ipaddr = ipaddr;
	this.subnetmask = subnetmask;
}

function PolicyRouteItem(_Domain, _Type, _VenderClassId, _WanName)
{
    this.Domain = _Domain;
    this.Type = _Type;
    this.VenderClassId = _VenderClassId;
    this.WanName = _WanName;
}

function GetPolicyRouteListLength(PolicyRouteList, Type)
{
	var Count = 0;

	if (PolicyRouteList == null)
	{
		return 0;
	}

	for (var i = 0; i < PolicyRouteList.length; i++)
	{
		if (PolicyRouteList[i] == null)
		{
			continue;
		}

		if (PolicyRouteList[i].Type == Type)
		{
			Count++;
		}
	}

	return Count;
}
	
var LanHostInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.{i},IPInterfaceIPAddress|IPInterfaceSubnetMask,stLanHostInfo);%>;
var PolicyRouteListAll = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_FilterPolicyRoute, InternetGatewayDevice.Layer3Forwarding.X_HW_policy_route.{i},PolicyRouteType|VenderClassId|WanName,PolicyRouteItem);%>;  

var LanHostInfo = LanHostInfos[0];

function CheckParaDhcp1() 
{
     var result = false;
     var IpAddress = getValue('LanIP_Address_text');
     var IpMask = getValue('LanSubmask_text');


      if (( isValidIpAddress(IpAddress) == false ))
	  {
         AlertEx(dhcp_language['bbsp_dhcpipaddr'] + IpAddress + dhcp_language['bbsp_60invalid']);
         return false;
      }

    if ( isValidSubnetMask(IpMask) == false ) 
    {
         AlertEx(dhcp_language['bbsp_subnetmaskp'] + IpMask + dhcp_language['bbsp_isinvalidp']);
         return false;
    }
    if ( isMaskOf24BitOrMore(IpMask) == false ) 
    {
        AlertEx(dhcp_language['bbsp_subnetmaskp'] + IpMask + dhcp_language['bbsp_isinvalidp']);
        return false;
    }
    if(isHostIpWithSubnetMask(IpAddress, IpMask) == false)
    {
        AlertEx(dhcp_language['bbsp_dhcpipaddr']+ IpAddress +dhcp_language['bbsp_e8c_not_main_pool']);
        return false;
    }
    if ( isBroadcastIp(IpAddress, IpMask) == true ) 
    {
       AlertEx(dhcp_language['bbsp_dhcpipaddr'] + IpAddress +dhcp_language['bbsp_60invalid']);
       return false;
    }

    var Reboot = (GetPolicyRouteListLength(PolicyRouteListAll, "SourceIP") > 0 && getValue('ethIpAddress') != LanHostInfos[0].ipaddr) ? dhcp_language['bbsp_resetont']:"";

	result = true;
	if (getValue('LanIP_Address_text') != LanHostInfos[0].ipaddr)
	{
		result = ConfirmEx(dhcp_language['bbsp_dhcpconfirmnote']+Reboot);
	}
	
	if ( result == true )
	{
		setDisable('Apply_button', 1);
	}

	return result;
}

function SetDHCP1()
{
	var CheckResult;
	var RequestFile = 'html/bbsp/dhcp/dhcpe8c.asp';
	CheckResult = CheckParaDhcp1();
	if (CheckResult == true)
	{
	    var Form = new webSubmitForm();

		Form.addParameter('x.IPInterfaceIPAddress',getValue('LanIP_Address_text'));
                Form.addParameter('x.IPInterfaceSubnetMask',getValue('LanSubmask_text'));
				Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		var url = 'set.cgi?'
				  + 'x=InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.IPInterface.1'
				  + '&RequestFile=' + RequestFile;
	   Form.setAction(url);	
	   setDisable('Lan_DHCP_checkbox',1);
	   Form.submit();
	}
	else
	{
	    setText('LanIP_Address_text',LanHostInfo.ipaddr);
		setText('LanSubmask_text',LanHostInfo.subnetmask);
	}
	return true;
}	

var DhcpsFeature = "<% HW_WEB_GetFeatureSupport(BBSP_FT_DHCP_MAIN);%>";

</script> 
</div> 
</body>
</html>
