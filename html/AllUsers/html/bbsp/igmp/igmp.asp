<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>

<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<title>igmp</title>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>

<script language="JavaScript" type="text/javascript">

var featureflag = "<% HW_WEB_GetFeatureSupport(BBSP_FT_SMART_QOS_EXT);%>";
var curUserType = '<%HW_WEB_GetUserType();%>';
var productName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';

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
		b.innerHTML = igmp_language[b.getAttribute("BindText")];
	}
}

function stIGMPInfo(domain,IGMPEnable,ProxyEnable,SnoopingEnable,IGMPVersion,Robustness,GenQueryInterval,GenResponseTime,SpQueryNumber,SpQueryInterval,SpResponseTime,RemarkIPPrecedence,RemarkPri,STBNumber,BridgeWanProxyEnable,PPPoEWanSnoopingMode,PPPoEWanProxyMode)
{
    this.domain = domain;
    this.IGMPEnable = IGMPEnable;
    this.ProxyEnable = ProxyEnable;
    this.SnoopingEnable = SnoopingEnable;
    this.IGMPVersion = IGMPVersion;
    this.Robustness = Robustness;
    this.GenQueryInterval = GenQueryInterval;
    this.GenResponseTime = GenResponseTime;
    this.SpQueryNumber = SpQueryNumber;
    this.SpQueryInterval = SpQueryInterval;
    this.SpResponseTime = SpResponseTime;
    this.RemarkIPPrecedence = RemarkIPPrecedence;
    this.RemarkPri = RemarkPri;
    this.STBNumber = STBNumber;
	this.BridgeWanProxyEnable = BridgeWanProxyEnable;
    this.PPPoEWanSnoopingMode = PPPoEWanSnoopingMode;
    this.PPPoEWanProxyMode = PPPoEWanProxyMode;
}

var WanMulticastProxy = "<% HW_WEB_GetFeatureSupport(BBSP_FT_MULTICAST_WANPROXY);%>";

function disableIgmpWorkModeByFeature()
{	
	if ( "0" == WanMulticastProxy )
    {
        setDisable("IGMPWorkMode", 1);
	}	
}

var IGMPInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Services.X_HW_IPTV, IGMPEnable|ProxyEnable|SnoopingEnable|IGMPVersion|Robustness|GenQueryInterval|GenResponseTime|SpQueryNumber|SpQueryInterval|SpResponseTime|RemarkIPPrecedence|RemarkPri|STBNumber|BridgeWanProxyEnable|PPPoEWanSnoopingMode|PPPoEWanProxyMode,stIGMPInfo);%>; 
var IGMPInfo = IGMPInfos[0];

if("1" == featureflag)
{
	IGMPInfo.IGMPEnable = '1';
	setSelect('IGMPEnable',"Enable");
}

function setDisableAllContent()
{
    setDisable("IGMPEnable",1);
	setDisable("BridgeWanProxyEnable",1);
	setDisable("PPPoEWanProxyMode",1);
	setDisable("PPPoEWanSnoopingMode",1);
    setDisable("IGMPWorkMode",1);
    setDisable("IGMPProxyVersion",1);
    setDisable("Robustness",1);
    setDisable("GenQueryInterval",1);
    setDisable("GenResponseTime",1);
    setDisable("SpQueryNumber",1);
    setDisable("SpQueryInterval",1);
    setDisable("SpResponseTime",1);	
    setDisable("SpQueryInterval",1);
    setDisable("SpResponseTime",1);		
    setDisable("RemarkIPPrecedence",1);	
    setDisable("RemarkPri",1);	
    setDisable("btnApply",1);
    setDisable("cancelValue",1);
	if("1" == featureflag)
	{
		setDisable("IGMPSNOOPINGEnable",1);
		setDisable("IGMPPROXYEnable",1);	
	}
	
}

function LoadFrame()
{
	if ( null != IGMPInfo )
	{
		setSelect('IGMPProxyVersion',IGMPInfo.IGMPVersion);
		setText('Robustness',IGMPInfo.Robustness);
		setText('GenQueryInterval',IGMPInfo.GenQueryInterval);
		setText('GenResponseTime',IGMPInfo.GenResponseTime);
		setText('SpQueryNumber',IGMPInfo.SpQueryNumber);
		setText('SpQueryInterval',IGMPInfo.SpQueryInterval);
		setText('SpResponseTime',IGMPInfo.SpResponseTime);
		setSelect('BridgeWanProxyEnable',(IGMPInfo.BridgeWanProxyEnable == 1)?"Enable":"Disable");
		setSelect('PPPoEWanProxyMode',IGMPInfo.PPPoEWanProxyMode);
		setSelect('PPPoEWanSnoopingMode',IGMPInfo.PPPoEWanSnoopingMode);

		if(parseInt(IGMPInfo.RemarkIPPrecedence,10)<0)
		{
			setText('RemarkIPPrecedence',"");
		}
		else
		{
			setText('RemarkIPPrecedence',IGMPInfo.RemarkIPPrecedence);
		}

		if(parseInt(IGMPInfo.RemarkPri,10)<0)
		{
			setText('RemarkPri',"");
		}
		else
		{
			setText('RemarkPri',IGMPInfo.RemarkPri);
		}
		
		if("1" == featureflag)
		{
				if(curUserType != 0 || '0' == IGMPInfo.IGMPEnable) 
				{
					setDisableAllContent();				
				}
				else
				{
					if('0' == IGMPInfo.SnoopingEnable)
					{
						setSelect('IGMPSNOOPINGEnable',"Disable");
					}
					else
					{
						setSelect('IGMPSNOOPINGEnable',"Enable");
					}
					if('0' == IGMPInfo.ProxyEnable)
					{
						setSelect('IGMPPROXYEnable',"Disable");
						setDisable("IGMPProxyVersion",1);
						setDisable("Robustness",1);
						setDisable("GenQueryInterval",1);
						setDisable("GenResponseTime",1);
						setDisable("SpQueryNumber",1);
						setDisable("SpQueryInterval",1);
						setDisable("SpResponseTime",1);	
						setDisable("BridgeWanProxyEnable",1);
						setDisable("PPPoEWanProxyMode",1);
					    setDisable("PPPoEWanSnoopingMode",0);		
					}
					else
					{
						setSelect('IGMPPROXYEnable',"Enable");
						setDisable("IGMPProxyVersion",0);
						setDisable("Robustness",0);
						setDisable("GenQueryInterval",0);
						setDisable("GenResponseTime",0);
						setDisable("SpQueryNumber",0);
						setDisable("SpQueryInterval",0);
						setDisable("SpResponseTime",0);	
						setDisable("BridgeWanProxyEnable",0);	
						setDisable("PPPoEWanProxyMode",0);
						setDisable("PPPoEWanSnoopingMode",1);	
					}
					if('0' == IGMPInfo.IGMPEnable)
					{
						setDisable("RemarkIPPrecedence",1);	
						setDisable("RemarkPri",1);
						setDisable("BridgeWanProxyOption",1);
						setDisable("PPPoEWanProxyMode",1);
						setDisable("PPPoEWanSnoopingMode",1);
					}
					else
					{
						setDisable("RemarkIPPrecedence",0);	
						setDisable("RemarkPri",0);
					}
				}
		}  
		else
		{
			if('0' == IGMPInfo.ProxyEnable)
			{
				setSelect('IGMPWorkMode',"Snooping");
			}
			else
			{
				setSelect('IGMPWorkMode',"Proxy");
			}
	
			if ('0' == IGMPInfo.IGMPEnable)
			{
				setSelect('IGMPEnable',"Disable");
				setDisplay('HomeGatewayInfo',1);
				setSelect('IGMPWorkMode',"Snooping");		
				setDisable("IGMPWorkMode",1);
				setDisable("IGMPProxyVersion",1);
				setDisable("Robustness",1);
				setDisable("GenQueryInterval",1);
				setDisable("GenResponseTime",1);
				setDisable("SpQueryNumber",1);
				setDisable("SpQueryInterval",1);
				setDisable("SpResponseTime",1);	
				setDisable("RemarkIPPrecedence",1);	
				setDisable("RemarkPri",1);
				setDisable("BridgeWanProxyEnable",1);
				setDisable("PPPoEWanProxyMode",1);
				setDisable("PPPoEWanSnoopingMode",1);
				if(curUserType != '0')
				{
					setDisableAllContent();				
				}	
			}
			else
			{
				setSelect('IGMPEnable',"Enable");
				setDisplay('HomeGatewayInfo',1);		
				setDisable("IGMPWorkMode",0);
	
				if(curUserType != '0')
				{
					setDisableAllContent();			
				}
				else
				{
					if ('0' == IGMPInfo.ProxyEnable)
					{
						setDisable("IGMPProxyVersion",1);
						setDisable("Robustness",1);
						setDisable("GenQueryInterval",1);
						setDisable("GenResponseTime",1);
						setDisable("SpQueryNumber",1);
						setDisable("SpQueryInterval",1);
						setDisable("SpResponseTime",1);		
						setDisable("BridgeWanProxyEnable",1);
						setDisable("PPPoEWanProxyMode",1);
						setDisable("PPPoEWanSnoopingMode",0);			
					}
					else
					{
						setDisable("IGMPProxyVersion",0);
						setDisable("Robustness",0);
						setDisable("GenQueryInterval",0);
						setDisable("GenResponseTime",0);
						setDisable("SpQueryNumber",0);
						setDisable("SpQueryInterval",0);
						setDisable("SpResponseTime",0);	
						setDisable("BridgeWanProxyEnable",0);
						setDisable("PPPoEWanProxyMode",0);
						setDisable("PPPoEWanSnoopingMode",1);
					}
				}
			}
		}
	}
	
	if("1" == featureflag)
	{
		setDisplay("IGMPOption",0);
		setDisplay("ModeOption",0);
		setDisplay("SnoopingOption",1);
		setDisplay("SpaceOption",1);
		setDisplay("ProxyOption",1);
	}
	else
	{
		setDisplay("SnoopingOption",0);
		setDisplay("SpaceOption",0);
		setDisplay("ProxyOption",0);
		setDisplay("IGMPOption",1);
		setDisplay("ModeOption",1);
	}
	
	disableIgmpWorkModeByFeature();
	if(productName == 'HG8240')
	{
		setDisable("IGMPWorkMode",1);
		if("1" == featureflag)
		{
			setDisable("IGMPPROXYEnable",1);
			setDisable("IGMPSNOOPINGEnable",1);
			setDisable("IGMPProxyVersion",1);
			setDisable("Robustness",1);
			setDisable("GenQueryInterval",1);
			setDisable("GenResponseTime",1);
			setDisable("SpQueryNumber",1);
			setDisable("SpQueryInterval",1);
			setDisable("SpResponseTime",1);	
		}
	}
	loadlanguage();
}

function CheckForm(type)
{  
     var info = 0;
	 var str = "";
	with (getElement ("ConfigForm"))
	{   
		if("1" == featureflag)
		{
			if ('1' == IGMPInfo.IGMPEnable)
			{
				RemarkIPPrecedence.value = removeSpaceTrim(RemarkIPPrecedence.value);	
				if(RemarkIPPrecedence.value != "")
				{
					if (false == CheckNumber(RemarkIPPrecedence.value, 0, 7))
					{
						AlertEx(igmp_language['bbsp_iptosinvalid']);
						return false;
					} 
				}
	
				RemarkPri.value = removeSpaceTrim(RemarkPri.value);	
				if(RemarkPri.value != "")
				{
					if (false == CheckNumber(RemarkPri.value, 0, 7))
					{
						AlertEx(igmp_language['bbsp_802invalid']);
						return false;
					} 
				}                    	    	     	 	
			}
		}
		else
		{
			if (getSelectVal('IGMPEnable') == "Enable")
			{
				RemarkIPPrecedence.value = removeSpaceTrim(RemarkIPPrecedence.value);	
				if(RemarkIPPrecedence.value != "")
				{
					if (false == CheckNumber(RemarkIPPrecedence.value, 0, 7))
					{
						AlertEx(igmp_language['bbsp_iptosinvalid']);
						return false;
					} 
				}
	
				RemarkPri.value = removeSpaceTrim(RemarkPri.value);	
				if(RemarkPri.value != "")
				{
					if (false == CheckNumber(RemarkPri.value, 0, 7))
					{
						AlertEx(igmp_language['bbsp_802invalid']);
						return false;
					} 
				}                    	    	     	 	
			}
		}
		if("1" == featureflag)
		{
			if ('1' == IGMPInfo.IGMPEnable && getSelectVal('IGMPPROXYEnable') == "Enable")
			{
				Robustness.value = removeSpaceTrim(Robustness.value);
				if (false == CheckNumber(Robustness.value, 1, 10))
				{
					AlertEx(igmp_language['bbsp_robustnessinvalid']);
					return false;
				}  
	
				GenQueryInterval.value = removeSpaceTrim(GenQueryInterval.value);
				if (false == CheckNumber(GenQueryInterval.value, 1, 5000))
				{
					AlertEx(igmp_language['bbsp_intervalinvalid']);
					return false;
				}
	
				GenResponseTime.value = removeSpaceTrim(GenResponseTime.value);
				if (false == CheckNumber(GenResponseTime.value, 1, 255))
				{
					AlertEx(igmp_language['bbsp_timeinvalid']);
					return false;
				}
	
				SpQueryNumber.value = removeSpaceTrim(SpQueryNumber.value);
				if (false == CheckNumber(SpQueryNumber.value, 1, 10))
				{
					AlertEx(igmp_language['bbsp_snuminvalid']);
					return false;
				}
	
				SpQueryInterval.value = removeSpaceTrim(SpQueryInterval.value);
				if (false == CheckNumber(SpQueryInterval.value, 1, 5000))
				{
					AlertEx(igmp_language['bbsp_sintervalinvalid']);
					return false;
				}
	
				SpResponseTime.value = removeSpaceTrim(SpResponseTime.value);	
				if (false == CheckNumber(SpResponseTime.value, 1, 255))
				{
					AlertEx(igmp_language['bbsp_stimeinvalid']);
					return false;
				}			     
			}
			
		}
		else
		{
			if (getSelectVal('IGMPEnable') == "Enable" && getSelectVal('IGMPWorkMode') == "Proxy")
			{	
				Robustness.value = removeSpaceTrim(Robustness.value);
				if (false == CheckNumber(Robustness.value, 1, 10))
				{
					AlertEx(igmp_language['bbsp_robustnessinvalid']);
					return false;
				}  
	
				GenQueryInterval.value = removeSpaceTrim(GenQueryInterval.value);
				if (false == CheckNumber(GenQueryInterval.value, 1, 5000))
				{
					AlertEx(igmp_language['bbsp_intervalinvalid']);
					return false;
				}
	
				GenResponseTime.value = removeSpaceTrim(GenResponseTime.value);
				if (false == CheckNumber(GenResponseTime.value, 1, 255))
				{
					AlertEx(igmp_language['bbsp_timeinvalid']);
					return false;
				}
	
				SpQueryNumber.value = removeSpaceTrim(SpQueryNumber.value);
				if (false == CheckNumber(SpQueryNumber.value, 1, 10))
				{
					AlertEx(igmp_language['bbsp_snuminvalid']);
					return false;
				}
	
				SpQueryInterval.value = removeSpaceTrim(SpQueryInterval.value);
				if (false == CheckNumber(SpQueryInterval.value, 1, 5000))
				{
					AlertEx(igmp_language['bbsp_sintervalinvalid']);
					return false;
				}
	
				SpResponseTime.value = removeSpaceTrim(SpResponseTime.value);	
				if (false == CheckNumber(SpResponseTime.value, 1, 255))
				{
					AlertEx(igmp_language['bbsp_stimeinvalid']);
					return false;
				}			         
			}               
		}  
    }
    return true;   
}

function IGMPSNOOPINGEnableChange()
{
    var igmpenable = getSelectVal('IGMPSNOOPINGEnable');
		if (igmpenable == "Enable")
		{
    		setSelect('IGMPEnable',"Enable");
			setSelect('IGMPWorkMode',"Snooping");
		}
		else
		{
	        setSelect('IGMPEnable',"Disable");
			setSelect('IGMPWorkMode',"Snooping");
		}
	
}

function IGMPPROXYEnableChange()
{
    var igmpenable = getSelectVal('IGMPPROXYEnable');
    if (igmpenable == "Enable")
    {
		setSelect('IGMPEnable',"Enable");
		setSelect('IGMPWorkMode',"Proxy");
		setDisable("IGMPProxyVersion",0);
		setDisable("Robustness",0);
		setDisable("GenQueryInterval",0);
		setDisable("GenResponseTime",0);
		setDisable("SpQueryNumber",0);
		setDisable("SpQueryInterval",0);
		setDisable("SpResponseTime",0);
		setDisable("BridgeWanProxyEnable",0);
		setDisable("PPPoEWanProxyMode",0);	
	}
	else
		{
	        	setSelect('IGMPEnable',"Enable");
			setSelect('IGMPWorkMode',"Proxy");
			setDisable("IGMPProxyVersion",1);
			setDisable("Robustness",1);
     		   	setDisable("GenQueryInterval",1);
		        setDisable("GenResponseTime",1);
		        setDisable("SpQueryNumber",1);
		        setDisable("SpQueryInterval",1);
		        setDisable("SpResponseTime",1);	
				setDisable("BridgeWanProxyEnable",1);
			    setDisable("PPPoEWanProxyMode",1);	
		}
	
		setDisable("IGMPPROXYEnable",(productName == 'HG8240') ? 1 : 0);	
}

function IGMPEnableChange()
{
    var igmpenable = getSelectVal('IGMPEnable');
    if (igmpenable == "Enable")
    {
        setDisplay('HomeGatewayInfo',1);		
        setDisable("IGMPWorkMode",0);
        disableIgmpWorkModeByFeature();
    
        var igmpworkmode = getSelectVal('IGMPWorkMode');
        if (igmpworkmode == "Proxy")
        {
               setDisable("IGMPProxyVersion",0);
               setDisable("Robustness",0);
               setDisable("GenQueryInterval",0);
               setDisable("GenResponseTime",0);
               setDisable("SpQueryNumber",0);
               setDisable("SpQueryInterval",0);
               setDisable("SpResponseTime",0);		
			   setDisable("BridgeWanProxyEnable",0);
			   setDisable("PPPoEWanProxyMode",0);
			   setDisable("PPPoEWanSnoopingMode",1);	
        }
        else
        {
               setDisable("IGMPProxyVersion",1);
               setDisable("Robustness",1);
               setDisable("GenQueryInterval",1);
               setDisable("GenResponseTime",1);
               setDisable("SpQueryNumber",1);
               setDisable("SpQueryInterval",1);
               setDisable("SpResponseTime",1);	
			   setDisable("BridgeWanProxyEnable",1);
			   setDisable("PPPoEWanProxyMode",1);
			   setDisable("PPPoEWanSnoopingMode",0);				
        }
        setDisable("RemarkIPPrecedence",0);	
        setDisable("RemarkPri",0);
    }
    else
    {
        setDisplay('HomeGatewayInfo',1);	
        setDisable("IGMPWorkMode",1);
        setDisable("IGMPProxyVersion",1);
        setDisable("Robustness",1);
        setDisable("GenQueryInterval",1);
        setDisable("GenResponseTime",1);
        setDisable("SpQueryNumber",1);
        setDisable("SpQueryInterval",1);
        setDisable("SpResponseTime",1);		
        setDisable("RemarkIPPrecedence",1);	
        setDisable("RemarkPri",1);	
		setDisable("BridgeWanProxyEnable",1);
		setDisable("PPPoEWanProxyMode",1);
		setDisable("PPPoEWanSnoopingMode",1);	
    }
    
    if(productName == 'HG8240')
    {
        setDisable("IGMPWorkMode",1);
    }
}

function ShowDetailPara(IgmpEnable, IgmpWorkMode)
{
    var igmpenable = IgmpEnable;
    var igmpworkmode = IgmpWorkMode;

    if (igmpworkmode == "Proxy")
    {
        if(igmpenable == "Enable")
	{
	    setDisable("IGMPProxyVersion",0);
    	    setDisable("Robustness",0);
	    setDisable("GenQueryInterval",0);
	    setDisable("GenResponseTime",0);
	    setDisable("SpQueryNumber",0);
	    setDisable("SpQueryInterval",0);
	    setDisable("SpResponseTime",0);		
		setDisable("BridgeWanProxyEnable",0);
		setDisable("PPPoEWanProxyMode",0);	
		setDisable("PPPoEWanSnoopingMode",1);
	}
	else
	{
	    setDisable("IGMPProxyVersion",1);
    	    setDisable("Robustness",1);
	    setDisable("GenQueryInterval",1);
	    setDisable("GenResponseTime",1);
	    setDisable("SpQueryNumber",1);
	    setDisable("SpQueryInterval",1);
	    setDisable("SpResponseTime",1);	
		setDisable("BridgeWanProxyEnable",1);
		setDisable("PPPoEWanProxyMode",1);
		setDisable("PPPoEWanSnoopingMode",1);
	}		
    }
    else
    {
    	    setDisable("IGMPProxyVersion",1);
	    setDisable("Robustness",1);
	    setDisable("GenQueryInterval",1);
	    setDisable("GenResponseTime",1);
	    setDisable("SpQueryNumber",1);
	    setDisable("SpQueryInterval",1);
	    setDisable("SpResponseTime",1);
		 setDisable("BridgeWanProxyEnable",1);
		setDisable("PPPoEWanProxyMode",1);
		if(igmpenable == "Enable")
		{
			setDisable("PPPoEWanSnoopingMode",0);
		}
		else
		{
			setDisable("PPPoEWanSnoopingMode",1);
		}	
    }  
      
    if(igmpenable == "Enable")
    {
    	 setDisable("RemarkIPPrecedence",0);	
         setDisable("RemarkPri",0);
    }
    else
    {
    	setDisable("RemarkIPPrecedence",1);	
        setDisable("RemarkPri",1);	
    } 
}

function IGMPWorkModeChange()
{    
	var igmpenable = getSelectVal('IGMPEnable');
	var igmpworkmode = getSelectVal('IGMPWorkMode');
	ShowDetailPara(igmpenable, igmpworkmode); 
}

function IGMPProxyVersionChange()
{    
	var igmpproxyversion = getSelectVal('IGMPProxyVersion');
}

function AddSubmitParam(SubmitForm,type)
{
	var value = getSelectVal('IGMPEnable');
	var snoopingvalue = getSelectVal('IGMPSNOOPINGEnable');
	var proxyvalue = getSelectVal('IGMPPROXYEnable');
	
	if("1" == featureflag)
	{	
		if('1' == IGMPInfo.IGMPEnable)
		{
			SubmitForm.addParameter('x.IGMPEnable',1);	
			if(snoopingvalue == "Enable")
			{
				SubmitForm.addParameter('x.SnoopingEnable',1);
			}
			else
			{
				SubmitForm.addParameter('x.SnoopingEnable',0);
			}
			if(proxyvalue == "Enable")
			{
				SubmitForm.addParameter('x.ProxyEnable',1);
				SubmitForm.addParameter('x.IGMPVersion',getSelectVal('IGMPProxyVersion'));
				SubmitForm.addParameter('x.Robustness',getValue('Robustness'));
				SubmitForm.addParameter('x.GenQueryInterval',getValue('GenQueryInterval'));
				SubmitForm.addParameter('x.GenResponseTime',getValue('GenResponseTime'));
				SubmitForm.addParameter('x.SpQueryNumber',getValue('SpQueryNumber'));
				SubmitForm.addParameter('x.SpQueryInterval',getValue('SpQueryInterval'));
				SubmitForm.addParameter('x.SpResponseTime',getValue('SpResponseTime'));
				SubmitForm.addParameter('x.BridgeWanProxyEnable',getSelectVal('BridgeWanProxyEnable'));
                SubmitForm.addParameter('x.PPPoEWanProxyMode',getSelectVal('PPPoEWanProxyMode'));	
			}
			else
			{
				SubmitForm.addParameter('x.ProxyEnable',0);
				SubmitForm.addParameter('x.PPPoEWanSnoopingMode',getSelectVal('PPPoEWanSnoopingMode'));	
			}
			SubmitForm.addParameter('x.RemarkIPPrecedence',(getValue('RemarkIPPrecedence')=="")?(-1):(parseInt(getValue('RemarkIPPrecedence'))));
			SubmitForm.addParameter('x.RemarkPri',(getValue('RemarkPri')=="")?(-1):(parseInt(getValue('RemarkPri'))));
		}
		else
		{
			SubmitForm.addParameter('x.IGMPEnable',0);
		}
	}
	else
	{
		if (value == "Enable")
		{
        	SubmitForm.addParameter('x.IGMPEnable',1);	
			value = getSelectVal('IGMPWorkMode');
        	if (value == "Proxy")
        	{
				SubmitForm.addParameter('x.ProxyEnable',1);
				SubmitForm.addParameter('x.SnoopingEnable',1);
				SubmitForm.addParameter('x.IGMPVersion',getSelectVal('IGMPProxyVersion'));
				SubmitForm.addParameter('x.Robustness',getValue('Robustness'));
				SubmitForm.addParameter('x.GenQueryInterval',getValue('GenQueryInterval'));
				SubmitForm.addParameter('x.GenResponseTime',getValue('GenResponseTime'));
				SubmitForm.addParameter('x.SpQueryNumber',getValue('SpQueryNumber'));
				SubmitForm.addParameter('x.SpQueryInterval',getValue('SpQueryInterval'));
				SubmitForm.addParameter('x.SpResponseTime',getValue('SpResponseTime'));
				var wanProxyEnable = ((getSelectVal('BridgeWanProxyEnable') == "Enable") ? 1 :0);
                SubmitForm.addParameter('x.BridgeWanProxyEnable',wanProxyEnable);
				SubmitForm.addParameter('x.PPPoEWanProxyMode',getSelectVal('PPPoEWanProxyMode'));	
        	}
			else 
			{
				SubmitForm.addParameter('x.ProxyEnable',0);
				SubmitForm.addParameter('x.SnoopingEnable',1);
				SubmitForm.addParameter('x.PPPoEWanSnoopingMode',getSelectVal('PPPoEWanSnoopingMode'));
			}	
        	SubmitForm.addParameter('x.RemarkIPPrecedence',(getValue('RemarkIPPrecedence')=="")?(-1):(parseInt(getValue('RemarkIPPrecedence'))));
       		SubmitForm.addParameter('x.RemarkPri',(getValue('RemarkPri')=="")?(-1):(parseInt(getValue('RemarkPri'))));
   		}
   		else
    	{
       		 SubmitForm.addParameter('x.IGMPEnable',0);	
    	}
	}
	
	SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
   
    SubmitForm.setAction('set.cgi?x=InternetGatewayDevice.Services.X_HW_IPTV'
                         + '&RequestFile=html/bbsp/igmp/igmp.asp');
    setDisable('btnApply',1);
    setDisable('cancelValue',1);
}

function CancelConfig()
{
    LoadFrame();
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody">
<form id="ConfigForm" action="../network/set.cgi">
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("igmptitle", GetDescFormArrayById(igmp_language, ""), GetDescFormArrayById(igmp_language, "bbsp_igmp_title"), false);
</script>
<div class="title_spread"></div>
   
    <table cellpadding="0" cellspacing="1" width="100%" class="tabal_bg">
        <tr id="IGMPOption">
            <td class="table_title width_per25" BindText='bbsp_enableigmpmh'></td>
            <td class="table_right width_per75">
            	<select id="IGMPEnable" name="IGMPEnable" class="width_135px"
                    onChange="IGMPEnableChange()">
                              <option value="Disable"><script>document.write(igmp_language['bbsp_disable']);</script></option>
                              <option value="Enable"><script>document.write(igmp_language['bbsp_enable']);</script></option>
              </select> 
            </td>
        </tr>

		<tr id="SnoopingOption">
            <td class="table_title width_per25" BindText='bbsp_enableigmpsnoopingmh'></td>
            <td class="table_right width_per75">
            	<select id="IGMPSNOOPINGEnable" name="IGMPSNOOPINGEnable" style="width: 135px" 
                    onChange="IGMPSNOOPINGEnableChange()">
                              <option value="Disable"><script>document.write(igmp_language['bbsp_disable']);</script></option>
                              <option value="Enable"><script>document.write(igmp_language['bbsp_enable']);</script></option>
              </select> 
            </td>
        </tr>
		<tr id="SpaceOption"><td class="height5p" ></td></tr>
		<tr id="ProxyOption">
            <td class="table_title width_per25" BindText='bbsp_enableigmpproxymh'></td>
            <td class="table_right width_per75">
            	<select id="IGMPPROXYEnable" name="IGMPPROXYEnable" style="width: 135px" 
                    onChange="IGMPPROXYEnableChange()">
                              <option value="Disable"><script>document.write(igmp_language['bbsp_disable']);</script></option>
                              <option value="Enable"><script>document.write(igmp_language['bbsp_enable']);</script></option>
              </select> 
            </td>
        </tr>
		
		<tbody id='HomeGatewayInfo'>       
         <tr id="ModeOption">
            <td class="table_title width_per25" BindText='bbsp_igmpmodemh'></td>
            <td class="table_right width_per75">
            	<select id="IGMPWorkMode" name="IGMPWorkMode" class="width_135px"
                    onChange="IGMPWorkModeChange()" >
                              <option value="Snooping"><script>document.write(igmp_language['bbsp_Snooping']);</script></option>
                              <option value="Proxy"><script>document.write(igmp_language['bbsp_Proxy']);</script></option>
                </select> 
            </td>
        </tr>
		
		<tr id="BridgeWanProxyOption">
            <td class="table_title width_per25" BindText='bbsp_enableBridgeWanProxymh'></td>
            <td class="table_right width_per75">
            	<select id="BridgeWanProxyEnable" name="BridgeWanProxyEnable" class="width_135px">
                    <option value="Disable"><script>document.write(igmp_language['bbsp_disable']);</script></option>
                    <option value="Enable"><script>document.write(igmp_language['bbsp_enable']);</script></option>
                </select> 
            </td>
        </tr>

         <tr id="PPPoEWanProxyModeOption">
            <td class="table_title width_per25" BindText='bbsp_PPPoEWanProxyModemh'></td>
            <td class="table_right width_per75">
            	<select id="PPPoEWanProxyMode" name="PPPoEWanProxyMode" class="width_135px">
                              <option value="IPoEAndPPPoE"><script>document.write(igmp_language['bbsp_IPoEAndPPPoERos']);</script></option>
                              <option value="IPoE"><script>document.write(igmp_language['bbsp_IPoERos']);</script></option>
                              <option value="PPPoE"><script>document.write(igmp_language['bbsp_PPPoERos']);</script></option>
                </select> 
            </td>
         </tr>

        <tr id="PPPoEWanSnoopingModeOption">
            <td class="table_title width_per25" BindText='bbsp_PPPoEWanSnoopingModemh'></td>
            <td class="table_right width_per75">
            	<select id="PPPoEWanSnoopingMode" name="PPPoEWanSnoopingMode" class="width_135px">
                              <option value="IPoEAndPPPoE"><script>document.write(igmp_language['bbsp_IPoEAndPPPoERos']);</script></option>
                              <option value="IPoE"><script>document.write(igmp_language['bbsp_IPoERos']);</script></option>
                              <option value="PPPoE"><script>document.write(igmp_language['bbsp_PPPoERos']);</script></option>
                </select> 
            </td>
         </tr>
        
		
        <tr id="ProxyVersion">
            <td class="table_title width_per25" BindText='bbsp_proxyversionmh'></td>
            <td class="table_right width_per75">
            	<select id="IGMPProxyVersion" name="IGMPProxyVersion" class="width_135px"
                    onChange="IGMPProxyVersionChange()" >
                              <option value="2"><script>document.write("V2");</script></option>
                              <option value="3"><script>document.write("V3");</script></option>
                </select> 
            </td>
        </tr>
	 <tr>
          <td class="table_title width_per25" BindText='bbsp_iptosmh'></td>
          <td class="table_right width_per75">
            <input name='RemarkIPPrecedence' type='text' id="RemarkIPPrecedence" size="20"  maxlength="19">
            <span class="gray">(0~7)</span>
          </td>
        </tr>
		
		 <tr>
          <td  class="table_title width_per25" BindText='bbsp_802mh'></td>
          <td  class="table_right width_per75">
            <input name='RemarkPri' type='text' id="RemarkPri" size="20"  maxlength="19">
            <span class="gray">(0~7)</span></td>
        </tr>
        <tr>       
          <td class="table_title width_per25" BindText='bbsp_robustnessmh'></td>
          <td class="table_right width_per75">
            <input name='Robustness' type='text' id="Robustness" size="20"  maxlength="19"><font color="red">*</font>
            <span class="gray"><script>document.write(igmp_language['bbsp_span1']);</script></span></td>
        </tr>
        <tr>
            <td class="table_title width_per25" BindText='bbsp_intervalmh'></td>
          <td class="table_right width_per75">
            <input name='GenQueryInterval' type='text' id="GenQueryInterval" size="20"  maxlength="19"><font color="red">*</font>            
            <span class="gray"><script>document.write(igmp_language['bbsp_span2']);</script></span></td>
            </td>
        </tr>
        <tr>
            <td class="table_title width_per25" BindText='bbsp_timemh'></td>
          <td class="table_right width_per75">
            <input name='GenResponseTime' type='text' id="GenResponseTime" size="20"  maxlength="19"><font color="red">*</font> 
              <span class="gray"><script>document.write(igmp_language['bbsp_span3']);</script></span></td>
            </td>
        </tr>
        <tr>
          <td class="table_title width_per25" BindText='bbsp_snummh'>      
		  <td class="table_right width_per75">
            <input name='SpQueryNumber' type='text' id="SpQueryNumber" size="20"  maxlength="19"><font color="red">*</font>            
            <span class="gray"><script>document.write(igmp_language['bbsp_span4']);</script></span></td>
        </tr>
        <tr >
          <td class="table_title width_per25" BindText='bbsp_sintervalmh'></td>
          <td class="table_right width_per75">
            <input name='SpQueryInterval' type='text' id="SpQueryInterval" size="20"  maxlength="19"><font color="red">*</font>
         
            <span class="gray"><script>document.write(igmp_language['bbsp_span5']);</script></span></td>
        </tr>
        <tr>
          <td class="table_title width_per25" BindText='bbsp_stimemh'> </td>     
		  <td class="table_right width_per25">
            <input name='SpResponseTime' type='text' id="SpResponseTime" size="20"  maxlength="19"><font color="red">*</font> 
            <span class="gray"><script>document.write(igmp_language['bbsp_span6']);</script></span></td>
        </tr>
		</tbody>
       
  </table>
     <table cellpadding="0" cellspacing="1" width="100%" class="table_button">
     	<tr>
		    <td class="width_per25"></td>
            <td class="table_submit">
				<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
                <button id="btnApply" name="btnApply" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="Submit();"><script>document.write(igmp_language['bbsp_app']);</script></button>
                <button name="cancelValue" id="cancelValue" class="CancleButtonCss buttonwidth_100px"  type="button" onClick="CancelConfig();"><script>document.write(igmp_language['bbsp_cancel']);</script></button>
            </td>
            
        </tr>        
    </table>

</form>
<div style="height:10px;"></div>

</body>
</html>
