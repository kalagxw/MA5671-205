<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="javascript" src="../../bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list.asp"></script>
<script language="JavaScript" type="text/javascript">

var var_month;
var var_week;
var var_day;
var var_hour;
var var_min;
var var_sec;
var MngtShct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SHCT);%>';
var CUVoiceFeature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_UNICOM_DIS_VOICE);%>";
var CfgModeWord ='<%HW_WEB_GetCfgMode();%>';

function stTimeInfo(domain,Enable,ntp1,ntp2,ZoneName,SynInterval,WanName,ExportCfgMode, ExportType, DstUsed,StartDate,EndDate,StartDate_EX,EndDate_EX)
{
    this.domain = domain;
    this.Enable = Enable;
    this.ntp1 = ntp1;
    this.ntp2 = ntp2;
    this.ZoneName = ZoneName;    
    this.SynInterval = SynInterval;
    this.WanName = WanName;
    this.DstUsed = DstUsed;
    this.StartDate = StartDate;
    this.EndDate = EndDate;
    this.StartDate_EX = StartDate_EX;
    this.EndDate_EX = EndDate_EX;    
    this.ExportCfgMode = ExportCfgMode;
    this.ExportType = ExportType;
}

function stWanInfo(domain,Enable,CntType,ConnectionStatus,NATEnabled,DefaultGateway,ServiceList,ExServiceList, vlanid,tr069flag,macid,submask)
{
    this.domain = domain;
    this.Enable = Enable;
    this.CntType = CntType;    
    this.ConnectionStatus = ConnectionStatus;
    this.NATEnabled = NATEnabled;
    this.DefaultGateway = DefaultGateway;

    this.ServiceList = (ExServiceList.length == 0)?ServiceList.toUpperCase():ExServiceList.toUpperCase();
    this.vlanid = vlanid;
    this.submask = submask;
    this.Tr069Flag = tr069flag;
    this.MacId = macid;
}

var WanIPInfo  = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i},Enable|ConnectionType|ConnectionStatus|NATEnabled|DefaultGateway|X_HW_SERVICELIST|X_HW_ExServiceList|X_HW_VLAN|X_HW_TR069FLAG|X_HW_MacId|SubnetMask,stWanInfo);%>;  
var WanPPPInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i},Enable|ConnectionType|ConnectionStatus|NATEnabled|DefaultGateway|X_HW_SERVICELIST|X_HW_ExServiceList|X_HW_VLAN|X_HW_TR069FLAG|X_HW_MacId,stWanInfo);%>;  
var TimeInfos  = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Time,Enable|NTPServer1|NTPServer2|LocalTimeZoneName|X_HW_SynInterval|X_HW_WanName|X_HW_ExportCfgMode|X_HW_ExportType|DaylightSavingsUsed|DaylightSavingsStart|DaylightSavingsEnd|X_HW_DaylightSavingsStartDate|X_HW_DaylightSavingsEndDate,stTimeInfo);%>;
var CfgModeIsSHCT    = "<% HW_WEB_GetFeatureSupport(BBSP_FT_SHCT);%>";
var TimeInfo = TimeInfos[0];
var WanInfo = new Array();    
var waninfolen = 0;
for (i = 0; i < WanIPInfo.length-1; i++)
{
    if(filterWanByVlan(WanIPInfo[i]) == false )
    {            
	    continue;
    }
	
    if (WanIPInfo[i].Tr069Flag == '0')
    {
        WanInfo[waninfolen++] = WanIPInfo[i];                
    }
}

for (j = 0; j < WanPPPInfo.length-1; j++)
{
    if(filterWanByVlan(WanPPPInfo[j]) == false )
    {            
	    continue;
    }
	
    if (WanPPPInfo[j].Tr069Flag == '0')
    {
        WanInfo[waninfolen++] =  WanPPPInfo[j];
    }
}

function MakeWanName1(wan)
{
    var wanInst = 0;
    var wanServiceList = '';
    var wanMode = '';
    var vlanId = 0;
    var tmpVirtualDevice = '';
    var currentWanName = '';       
		var CfgModePCCWHK = "<%HW_WEB_GetFeatureSupport(BBSP_FT_PCCW);%>";

    DomainElement = wan.domain.split(".");
    wanInst = wan.MacId;

	wanServiceList  = wan.ServiceList.toUpperCase();
    if ('UNICOM' == CfgModeWord.toUpperCase() || "1" == CUVoiceFeature)
    {
	    switch(wanServiceList)
	    {
	    	case "VOIP":
	    	wanServiceList = "VOICE";
	    	break;
	    	case "TR069_VOIP":
	    	wanServiceList = "TR069_VOICE";
	    	break;
	    	case "VOIP_INTERNET":
	    	wanServiceList = "VOICE_INTERNET";
	    	break;
	    	case "TR069_VOIP_INTERNET":
	    	wanServiceList = "TR069_VOICE_INTERNET";
	    	break;
			case "VOIP_IPTV":
			wanServiceList = "VOICE_IPTV";
			break;
			case "TR069_VOIP_IPTV":
			wanServiceList = "TR069_VOICE_IPTV";
			break;
	    	default:
	    	break;
	    }
    }
	
    wanMode         = (wan.CntType == 'IP_Routed' ) ? "R" : "B";
    vlanId          = wan.vlanid;
  
    if (CfgModePCCWHK == "1")
    {
    	wanMode = (wan.Mode == 'IP_Routed' ) ? "Route" : "Bridge"
    	currentWanName = wanInst + "_" + wanMode + "_" +"WAN";
    }
    else
    {
	    if (0 != parseInt(vlanId))
	    {
	        currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_" + vlanId;
	    }
	    else
	    {
	        currentWanName = wanInst + "_" + wanServiceList + "_" + wanMode + "_VID_";
	    }
    }

    return currentWanName;
}

function domainTowanname(domain)
{
	if((null != domain) && (undefined != domain))
	{
		var domaina = domain.split('.');
		var type = (-1 == domain.indexOf("WANIPConnection")) ? '.ppp' : '.ip' ;
		return 'wan' + domaina[2]  + '.' + domaina[4] + type + domaina[6] ;
	}
}

function GetWanName(Domain)
{
  var ParentNodeName = "WANConnectionDevice";
  var Start = Domain.indexOf(ParentNodeName)+ ParentNodeName.length+1;
  return "wan"+Domain.substr(Start,1);
}

function IsNeedSpecDeal()
{
    return (CfgModeIsSHCT == "1")?true:false;
}

function WriteWanIfOptionByWanIndex()
{
    var html='';
    
    html += '<select name="WanName" id="WanName" maxlength="20" style="width:260px;">';
    html += '<option value=""></option>';
    
    for (i = 0; i < WanInfo.length; i++)
    {
        if (WanInfo[i].CntType == 'IP_Routed')
        {
            html += '<option id="wan_' + i + '" value="' + domainTowanname(WanInfo[i].domain) + '">' + MakeWanName1(WanInfo[i]) + '</option>';     
        }
    }

    html += '</select>';
    document.getElementById("divWanName").innerHTML = html;
} 

function WriteWanIfOptionByWanType()
{
    var html='';
    
    html += '<select name="WanName" id="WanName" maxlength="20" style="width:260px;">';
    html += '<option value="0">INTERNET WAN</option>';
    if ('UNICOM' == CfgModeWord.toUpperCase() || "1" == CUVoiceFeature)
    {
    	html += '<option value="1">VOICE WAN</option>';
    }
    else
   	{
    	html += '<option value="1">VOIP WAN</option>';	
    }
    html += '<option value="2">TR069 WAN</option>';
    html += '<option value="3">OTHER WAN</option>';
    html += '</select>';
    
    document.getElementById("divWanName").innerHTML = html;
} 

function WriteWanIfOption(str)
{
    if("1" == str.toString())
    {
				getElById('dsWanName').innerHTML = 'WAN类型:';
        WriteWanIfOptionByWanType();    
        setSelect("WanName", TimeInfo.ExportType);
    }
    else
    {
				getElById('dsWanName').innerHTML = 'WAN名称:';
        WriteWanIfOptionByWanIndex();
        setSelect("WanName", TimeInfo.WanName);
    }
}

function SetDstEnable()
{
	if('1' == TimeInfo.DstUsed)
	{
		setCheck('dstEnabled', '0');
		setDisplay('DSTConfig', 0);
	}
	else
	{
		setCheck('dstEnabled', '1');
		setDisplay('DSTConfig', 1);
	}
}

var sntpSysTime = '2009-9-12T200:11:22' ;
var timeoutID;

var ntpServers = new Array();

ntpServers[0] = 'None';
ntpServers[1] = 'clock.fmt.he.net';
ntpServers[2] = 'clock.nyc.he.net';
ntpServers[3] = 'clock.sjc.he.net';
ntpServers[4] = 'clock.via.net';
ntpServers[5] = 'ntp1.tummy.com';
ntpServers[6] = 'time.cachenetworks.com';
ntpServers[7] = 'time.nist.gov';
ntpServers[8] = 'time.windows.com';
ntpServers[9] = 'Other';

var timeZonesEng = new Array();

timeZonesEng[0] = '(GMT-12:00) International Date Line West';
timeZonesEng[1] = '(GMT-11:00) Midway Island, Samoa';
timeZonesEng[2] = '(GMT-10:00) Hawaii';
timeZonesEng[3] = '(GMT-09:00) Alaska';
timeZonesEng[4] = '(GMT-08:00) Pacific Time, Tijuana';
timeZonesEng[5] = '(GMT-07:00) Arizona, Mazatlan';
timeZonesEng[6] = '(GMT-07:00) Chihuahua, La Paz';
timeZonesEng[7] = '(GMT-07:00) Mountain Time';
timeZonesEng[8] = '(GMT-06:00) Central America';
timeZonesEng[9] = '(GMT-06:00) Central Time';
timeZonesEng[10] = '(GMT-06:00) Guadalajara, Mexico City, Monterrey';
timeZonesEng[11] = '(GMT-06:00) Saskatchewan';
timeZonesEng[12] = '(GMT-05:00) Bogota, Lima, Quito';
timeZonesEng[13] = '(GMT-05:00) Eastern Time';
timeZonesEng[14] = '(GMT-05:00) Indiana';
timeZonesEng[15] = '(GMT-04:00) Atlantic Time';
timeZonesEng[16] = '(GMT-04:00) Caracas, La Paz';
timeZonesEng[17] = '(GMT-04:00) Santiago';
timeZonesEng[18] = '(GMT-03:30) Newfoundland';
timeZonesEng[19] = '(GMT-03:00) Brasilia';
timeZonesEng[20] = '(GMT-03:00) Buenos Aires, Georgetown';
timeZonesEng[21] = '(GMT-03:00) Greenland';
timeZonesEng[22] = '(GMT-02:00) Mid-Atlantic';
timeZonesEng[23] = '(GMT-01:00) Azores';
timeZonesEng[24] = '(GMT-01:00) Cape Verde Is.';
timeZonesEng[25] = '(GMT) Casablanca, Monrovia';
timeZonesEng[26] = '(GMT) Greenwich Mean Time: Dublin, Edinburgh, Lisbon, London';
timeZonesEng[27] = '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna';
timeZonesEng[28] = '(GMT+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague';
timeZonesEng[29] = '(GMT+01:00) Brussels, Copenhagen, Madrid, Paris';
timeZonesEng[30] = '(GMT+01:00) Sarajevo, Skopje, Warsaw, Zagreb';
timeZonesEng[31] = '(GMT+01:00) West Central Africa';
timeZonesEng[32] = '(GMT+02:00) Athens, Istanbul, Minsk';
timeZonesEng[33] = '(GMT+02:00) Bucharest';
timeZonesEng[34] = '(GMT+02:00) Cairo';
timeZonesEng[35] = '(GMT+02:00) Harare, Pretoria';
timeZonesEng[36] = '(GMT+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius';
timeZonesEng[37] = '(GMT+02:00) Jerusalem';
timeZonesEng[38] = '(GMT+03:00) Baghdad';
timeZonesEng[39] = '(GMT+03:00) Kaliningrad';
timeZonesEng[40] = '(GMT+03:00) Kuwait, Riyadh';
timeZonesEng[41] = '(GMT+03:00) Nairobi';
timeZonesEng[42] = '(GMT+03:30) Tehran';
timeZonesEng[43] = '(GMT+04:00) Abu Dhabi, Muscat';
timeZonesEng[44] = '(GMT+04:00) Baku, Tbilisi, Yerevan';
timeZonesEng[45] = '(GMT+04:00) Moscow, St. Petersburg, Volgograd';
timeZonesEng[46] = '(GMT+04:30) Kabul';
timeZonesEng[47] = '(GMT+05:00) Islamabad, Karachi, Tashkent';
timeZonesEng[48] = '(GMT+05:30) Chennai, Kolkata, Mumbai, New Delhi';
timeZonesEng[49] = '(GMT+05:45) Kathmandu';
timeZonesEng[50] = '(GMT+06:00) Almaty';
timeZonesEng[51] = '(GMT+06:00) Astana, Dhaka';
timeZonesEng[52] = '(GMT+06:00) Ekaterinburg';
timeZonesEng[53] = '(GMT+06:00) Sri Jayawardenepura';
timeZonesEng[54] = '(GMT+06:30) Rangoon';
timeZonesEng[55] = '(GMT+07:00) Bangkok, Hanoi, Jakarta';
timeZonesEng[56] = '(GMT+07:00) Novosibirsk';
timeZonesEng[57] = '(GMT+08:00) Beijing, Chongqing, Hong Kong, Urumqi';
timeZonesEng[58] = '(GMT+08:00) Krasnoyarsk';
timeZonesEng[59] = '(GMT+08:00) Kuala Lumpur, Singapore';
timeZonesEng[60] = '(GMT+08:00) Perth';
timeZonesEng[61] = '(GMT+08:00) Taipei';
timeZonesEng[62] = '(GMT+08:00) Ulaan Bataar';
timeZonesEng[63] = '(GMT+09:00) Irkutsk';
timeZonesEng[64] = '(GMT+09:00) Osaka, Sapporo, Tokyo';
timeZonesEng[65] = '(GMT+09:00) Seoul';
timeZonesEng[66] = '(GMT+09:30) Adelaide';
timeZonesEng[67] = '(GMT+09:30) Darwin';
timeZonesEng[68] = '(GMT+10:00) Brisbane';
timeZonesEng[69] = '(GMT+10:00) Canberra, Melbourne, Sydney';
timeZonesEng[70] = '(GMT+10:00) Guam, Port Moresby';
timeZonesEng[71] = '(GMT+10:00) Hobart';
timeZonesEng[72] = '(GMT+10:00) Yakutsk';
timeZonesEng[73] = '(GMT+11:00) Solomon Is., New Caledonia';
timeZonesEng[74] = '(GMT+11:00) Vladivostok';
timeZonesEng[75] = '(GMT+12:00) Auckland, Wellington';
timeZonesEng[76] = '(GMT+12:00) Fiji, Kamchatka, Marshall Is.';
timeZonesEng[77] = '(GMT+12:00) Magadan';
timeZonesEng[78] = '(GMT+13:00) Nuku\'alofa';

function getTimeZoneIndex(timeZoneName) 
{
  var i = 0, ret = 4; 

  for ( var i = 0; i < timeZonesEng.length; i++ ) 
  {
    if ( timeZonesEng[i].search(timeZoneName) != -1 )
      break;
  }

  if ( i < timeZonesEng.length )
    ret = i;

  return ret;
}

function getTimeZoneName(idx) 
{
  var str = timeZonesEng[idx];
  var ret = '';

  if ( idx != 25 && idx != 26 )
    ret = str.substr(12);
  else
    ret = str.substr(6);

  return ret;
}

function getTimeZoneOffset(idx) 
{
  var str = timeZonesEng[idx];
  var ret = '';

  if ( idx != 25 && idx != 26 )
    ret = str.substr(4, 6);


  return ret;
}

function writeTimeZoneList() 
{
  for( var i = 0; i < timeZonesEng.length; i++ )
    document.writeln("<option value=" + getTimeZoneOffset(i) + ">" + timeZonesEng[i] + "</option>");
}

function ntpChange(optionlist,textbox)
{
  if( optionlist[optionlist.selectedIndex].value == "Other" )
  {
    textbox.disabled = false;
  }	
  else 
  {
    textbox.value = "";
    textbox.disabled = true;
  }
}

function hideNtpConfig(hide) 
{
  var status = 'block';

  if(hide)
    status = 'none';
 	
  if( document.getElementById('ntpConfig') )
  {
    document.getElementById('ntpConfig').style.display = status;
  }
  else if(!document.layers)
  {
      document.all.ntpConfig.style.display = status;
  }
}

function ntpEnblChange() 
{
	var ntpEnabled = document.getElementById('ntpEnabled');
   try
   {
  if( ntpEnabled.checked )
    hideNtpConfig(0);
  else
    hideNtpConfig(1);
    }
    catch(ex)
    {}
}

function writeNtpList(needed)
{
  for( var i = 0; i < ntpServers.length; i++ )
  {
    document.writeln("<option value=" + ntpServers[i] + ">" + ntpServers[i] + "</option>");
  }	
}

function LoadFrame()
{
  var i = 0;
  var ntp1 = TimeInfo.ntp1 ;
  var ntp2 = TimeInfo.ntp2;
  var ntp_enabled = TimeInfo.Enable;
  var tz_name = TimeInfo.ZoneName;
  
  WriteWanIfOption(TimeInfo.ExportCfgMode); 
  setSelect("SelectWanType", TimeInfo.ExportCfgMode);
  setText("XHWSynInterval", TimeInfo.SynInterval);

  if(IsNeedSpecDeal())
    setDisable("SelectWanType", 1);

  with (document.forms[0])
  {
     setCheck('ntpEnabled',ntp_enabled);
	 setDisplay('ntpConfig',ntp_enabled);
	
    if( ntp1.length )
	{
      for( i = 0; i < ntpServers.length - 1; i++ ) 
	  {
        if( ntp1 == ntpServers[i] ) 
		{
          ntpServer1.selectedIndex = i;
          break;
        }
      }
      if( i == ntpServers.length - 1) 
	  {
        ntpServer1.selectedIndex = i; 
        ntpServerOther1.value = ntp1;
      }
    }
    ntpChange(ntpServer1,ntpServerOther1);

    if( ntp2.length ) 
	{
      for( i = 0; i < ntpServers.length - 1; i++ )
	  {
        if( ntp2 == ntpServers[i] )
		{
          ntpServer2.selectedIndex = i;
          break;
        }
      }
	  
      if( i == ntpServers.length - 1 ) 
	  {
        ntpServer2.selectedIndex = i; 
        ntpServerOther2.value = ntp2;
      }
    }
    else
    {
        ntpServer2.selectedIndex = 0;
    }
    
    ntpChange(ntpServer2,ntpServerOther2);

    cboTimeZone.selectedIndex = getTimeZoneIndex(tz_name);
	
    ntpEnblChange();
  }

}

function isIpFormat(str)
{
    var i;
    var addrParts = str.split('.');
    if (addrParts.length != 4 ) 
	    return false;

    for (i=0; i<4; i++)
    {
        if (isNaN(addrParts[i]) || addrParts[i] == ""
            || addrParts[i].charAt(0) == '+' ||  addrParts[i].charAt(0) == '-' )
    	    return false;
        if (isPlusInteger(addrParts[i]) == false) 
    	    return false;        
    }
    return true;
}

function isTValidName(name) {
   var i = 0;	
   var unsafeString = "\"<>%\\^[]`\+\$\,='#&:;*/{} \t";
   for ( i = 0; i < name.length; i++ ) {
   	  for( j = 0; j < unsafeString.length; j++)
      	if ( (name.charAt(i)) == unsafeString.charAt(j) )
         return false;
   }

  return true;
}

function SubmitForm()
{
    var Form = new webSubmitForm();    
    Form.usingPrefix('x');
    var ntpEnabled = document.getElementById('ntpEnabled');
    var ntpServer1 = document.getElementById('ntpServer1');
    var ntpServerOther1 = document.getElementById('ntpServerOther1');
    var ntpServer2 = document.getElementById('ntpServer2');
    var ntpServerOther2 = document.getElementById('ntpServerOther2');
    var cboTimeZone = document.getElementById('cboTimeZone');
    var XHWSynInterval = document.getElementById('XHWSynInterval');
    var WanType = document.getElementById('SelectWanType');


    if (XHWSynInterval.value.length > 1 && XHWSynInterval.value.charAt(0) == '0')
    {
        AlertEx("时间同步周期不合法。");
        return false;
    }
    

   if (isPlusInteger(XHWSynInterval.value)==false)
    {
        AlertEx("时间同步周期不合法。");
        return false;
    }

    with( document.forms[0] ) 
   {
    if( ntpEnabled.checked )
	{
	  Form.addParameter('Enable',1);
      if( ntpServer1.selectedIndex == ntpServers.length -1 )
	  {
        if( ntpServerOther1.value.length == 0 ) 
		{
          AlertEx('一级SNTP服务器后面的输入框不能为空。');
          return;
        }
        if (isIpFormat(ntpServerOther1.value))
        {
            if (isValidIpAddress(ntpServerOther1.value) == false)
            {
                AlertEx('一级SNTP服务器的IP地址格式不正确。');
                return;
            }
            if (isAbcIpAddress(ntpServerOther1.value) == false)
            {
                AlertEx('一级SNTP服务器的IP地址无效，\n它必须是一个单播地址。');
                return;
            }            
        }
        else 
        {
            if(isTValidName(ntpServerOther1.value) == false)
            {
                AlertEx('第一级SNTP服务器的地址无效。');
                return;                
            }
        }
		 Form.addParameter('NTPServer1',ntpServerOther1.value)
      }
	  else 
	  {
		 if(ntpServer1.selectedIndex > 0)
		 {
			Form.addParameter('NTPServer1',ntpServer1[ntpServer1.selectedIndex].value);
		 }
		 else
		 {
		 	Form.addParameter('NTPServer1',"");
		 }
      }

      if( ntpServer2.selectedIndex == ntpServers.length - 1 ) 
	  {
        if( ntpServerOther2.value.length == 0 ) 
		{ 
          AlertEx('二级SNTP服务器后面的输入框不能空。');
          return;
        } 
        if (isIpFormat(ntpServerOther2.value))
        {
            if (isValidIpAddress(ntpServerOther2.value) == false)
            {
                AlertEx('二级SNTP服务器的IP地址格式不正确。');
                return;
            }
            if (isAbcIpAddress(ntpServerOther2.value) == false)
            {
                AlertEx('二级SNTP服务器的IP地址无效. \n它必须是一个单播地址。');
                return;
            }            
        }
        else 
        {
            if(isTValidName(ntpServerOther2.value) == false)
            {
                AlertEx('第二SNTP服务器的地址无效。');
                return;                
            }
        }
        Form.addParameter('NTPServer2',ntpServerOther2.value);      
      } 
	  else 
	  {
        if( ntpServer2.selectedIndex > 0)
        {
		  Form.addParameter('NTPServer2',ntpServer2[ntpServer2.selectedIndex].value); 
		}
		else
		{
		  Form.addParameter('NTPServer2',''); 		
		}
      }
      Form.addParameter('LocalTimeZoneName',getTimeZoneName(cboTimeZone.selectedIndex)); 

    } 
	else 
	{
      Form.addParameter('Enable',0);
    }
  }

    Form.addParameter('X_HW_SynInterval', XHWSynInterval.value);

    if(WanType[WanType.selectedIndex].value == 1)
    {
        Form.addParameter('X_HW_ExportType', getSelectVal('WanName'));
    }
    else
    {
        Form.addParameter('X_HW_WanName', getSelectVal('WanName'));
    }
    Form.addParameter('X_HW_ExportCfgMode', WanType[WanType.selectedIndex].value);    
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
  Form.setAction('set.cgi?x=InternetGatewayDevice.Time&RequestFile=html/ssmp/sntp/cusntp.asp');
  setDisable('btnApply',1);
  setDisable('cancelValue1',1);
  setDisable('btnApply2',1);
  setDisable('cancelValue2',1); 
  Form.submit();
}

function printOntSysTime()
{
   var sysTime = document.getElementById('ontSysTime');
   sysTime.innerText = "The current system time : "+sntpSysTime;
}

function refreshSNTP()
{
    window.location.replace("cu_sntp.asp");
}

function startTimeout()
{        	
    timeoutID = setTimeout("refreshSNTP()", 1000*60);
}

function stopTimeout()
{
   clearTimeout(timeoutID);
}

function ShowNtpConfig(obj)
{
	if (obj.checked)
	{
		setDisplay('ntpConfig', 1);
	}
	else
	{
		setDisplay('ntpConfig', 0);
	}
}

function CancelConfigServer()
{
    var i = 0;
    var ntp1 = TimeInfo.ntp1 ;
    var ntp2 = TimeInfo.ntp2;
    var ntp_enabled = TimeInfo.Enable;
    var tz_name = TimeInfo.ZoneName;
    setCheck('ntpEnabled',ntp_enabled);
	
	var ntpServer1 = document.getElementById('ntpServer1');
	var ntpServerOther1 = document.getElementById('ntpServerOther1');
	var ntpServer2 = document.getElementById('ntpServer2');
	var ntpServerOther2 = document.getElementById('ntpServerOther2');
	var cboTimeZone = document.getElementById('cboTimeZone');
	
    with (document.forms[0])
    {
        if( ntp1.length )
    	{
          for( i = 0; i < ntpServers.length -1; i++ ) 
    	  {
            if( ntp1 == ntpServers[i] ) 
    		{
              ntpServer1.selectedIndex = i;
              break;
            }
          }
          if( i == ntpServers.length -1 ) 
    	  {
            ntpServer1.selectedIndex = i; 
            ntpServerOther1.value = ntp1;
          }
        }
        ntpChange(ntpServer1,ntpServerOther1);

        if( ntp2.length ) 
    	{
          for( i = 0; i < ntpServers.length - 1; i++ )
    	  {
            if( ntp2 == ntpServers[i] )
    		{
              ntpServer2.selectedIndex = i;
              break;
            }
          }
    	  
          if( i == ntpServers.length -1 ) 
    	  {
            ntpServer2.selectedIndex = i; 
            ntpServerOther2.value = ntp2;
          }
        }
        ntpChange(ntpServer2,ntpServerOther2);

        cboTimeZone.selectedIndex = getTimeZoneIndex(tz_name);

        ntpEnblChange();
		document.getElementById('XHWSynInterval').value=TimeInfo.SynInterval;
    }
}

</script>

</head>
<body onLoad="LoadFrame();" class="mainbody">
<br>
<table width="100%"  border="0" cellpadding="0" cellspacing="0" id="tabTest">
    <tr>
       
       <td class="prompt">
        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="100%" class="title_01" style="padding-left:10px;">在本页面，您可以配置SNTP协议和时区以获取准确的时间。</td>
          </tr>
        </table>
       </td>
    </tr>
	<tr><td height="5px"></td></tr>
	 <tr align="left">
            <td>
                <input type='checkbox' name='ntpEnabled' id='ntpEnabled' onClick='ShowNtpConfig(this);' checked = false>
                自动同步网络时间服务器 </td>
        </tr>
 </table>
 <table width="100%" height="15" border="0" cellpadding="0" cellspacing="0"> 
  <tr> 
    <td></td> 
  </tr> 
</table> 
<form id="ConfigForm" action="">
<div id="ntpConfig" name="ntpConfig" class="" style="z-index:2" >

    <table class="tabal_bg"  cellpadding="0" cellspacing="1" width="100%">
      <tr class="trTabConfigure" align="left">
          <td width="25%" class="table_title">一级SNTP服务器:</td>
          <td width="75%" class="table_right">
              <select name='ntpServer1' id='ntpServer1'  size="1" onChange='ntpChange(this.form.ntpServer1,this.form.ntpServerOther1)'>
                  <script language="javascript">
                writeNtpList();
              </script>
              </select>
              <input type='text' name='ntpServerOther1' id='ntpServerOther1'  size=20 maxLength=63>
          </td>
      </tr>
      <tr>
          <td width="25%" class="table_title">二级SNTP服务器:</td>
          <td width="75%" class="table_right">
              <select name='ntpServer2' id='ntpServer2' size="1" onChange='ntpChange(this.form.ntpServer2,this.form.ntpServerOther2)'>
                  <script language="javascript">
                writeNtpList();
              </script>
              </select>
              <input type='text' name='ntpServerOther2' id='ntpServerOther2' size=20 maxLength=63>
          </td>
      </tr>
      <tr>
          <td width="25%" class="table_title">时间区域:</td>
          <td  width="75%" class="table_right">
              <select name='cboTimeZone' id='cboTimeZone'  size="1">
                  <script language="javascript">
                writeTimeZoneList();
              </script>
              </select>
          </td>
      </tr>
      <tr>
          <td width="25%" class="table_title">时间同步周期:</td>
          <td width="75%" class="table_right">
              <input type='text' name='XHWSynInterval' id='XHWSynInterval' size=20 maxLength=9>(秒)
          </td>
      </tr>
      <tr>
          <td width="25%" class="table_title">NTP服务选择出口方式:</td>
          <td class="table_right">
              <select name="SelectWanType" id="SelectWanType" maxlength="20" style="width:260px;"    
                      onChange='WriteWanIfOption(this.form.SelectWanType[this.form.SelectWanType.selectedIndex].value)'>
                  <option value="0">指定WAN索引</option>
                  <option value="1">指定WAN类型</option>
              </select>
          </td>
      </tr>
      <tr>
          <td width="25%" class="table_title" id="dsWanName">WAN名称:</td>
          <td class="table_right">
             <div name="divWanName" id="divWanName"></div>
          </td>
      </tr>
    </table>
  
  </div>
  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table_button">
        <tr>
		<td width="25%"></td>
          <td class="table_submit">
          <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
		  <input name="btnApply2" id="btnApply2" type="button" class="submit" value="应用" onClick="SubmitForm();">
          <input name="cancelValue2" id="cancelValue2" type="button" class="submit" value="取消" onClick="CancelConfigServer();"> </td>
        </tr>
    </table>
</form>
</body>
</html>

