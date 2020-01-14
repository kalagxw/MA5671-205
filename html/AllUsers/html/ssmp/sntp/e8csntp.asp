<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>

<style>
form{padding:0;margin:0}
</style>

<script language="JavaScript" type="text/javascript">

var var_month;
var var_week;
var var_day;
var var_hour;
var var_min;
var var_sec;
var MngtShct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SHCT);%>';
var JsctSpecVlan='<%HW_WEB_GetSPEC(BBSP_SPEC_FILTERWAN_BYVLAN.STRING);%>';
function filterWanByVlan(WanItem)
{       
	if (WanItem.vlanid == parseInt(JsctSpecVlan))
	{    	
	    return false;	
	}
	return true;	
}

function stTimeInfo(domain,Enable,ntp1,ntp2,ntp3,ntp4,ntp5,ZoneName,SynInterval,WanName,ExportCfgMode, ExportType, DstUsed,StartDate,EndDate,StartDate_EX,EndDate_EX)
{
    this.domain = domain;
    this.Enable = Enable;
    this.ntp1 = ntp1;
    this.ntp2 = ntp2;
	this.ntp3 = ntp3;
	this.ntp4 = ntp4;
	this.ntp5 = ntp5;
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
var TimeInfos  = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.Time,Enable|NTPServer1|NTPServer2|NTPServer3|NTPServer4|NTPServer5|LocalTimeZoneName|X_HW_SynInterval|X_HW_WanName|X_HW_ExportCfgMode|X_HW_ExportType|DaylightSavingsUsed|DaylightSavingsStart|DaylightSavingsEnd|X_HW_DaylightSavingsStartDate|X_HW_DaylightSavingsEndDate,stTimeInfo);%>;
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

function IsNeedSpecDeal()
{
    return (CfgModeIsSHCT == "1")?true:false;
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

var sntpSysTime = '<%HW_WEB_GetSystemTime();%>';
var timeoutID;

var ntpServers = new Array();

ntpServers[0] = 'clock.fmt.he.net';
ntpServers[1] = 'clock.nyc.he.net';
ntpServers[2] = 'clock.sjc.he.net';
ntpServers[3] = 'clock.via.net';
ntpServers[4] = 'ntp1.tummy.com';
ntpServers[5] = 'time.cachenetworks.com';
ntpServers[6] = 'time.nist.gov';
ntpServers[7] = 'time.windows.com';

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
	var ntpEnabled = document.getElementById('NtpEnable_checkbox');
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
  if(!needed)
  {
    document.writeln("<option value=None>不配置</option>");
  }	
  for( var i = 0; i < ntpServers.length; i++ )
  {
    document.writeln("<option value=" + ntpServers[i] + ">" + ntpServers[i] + "</option>");
  }	
  document.writeln("<option value='Other'>其它</option>");
}

function LoadFrame()
{
  var i = 0;
  var ntp1 = TimeInfo.ntp1 ;
  var ntp2 = TimeInfo.ntp2;
  var ntp3 = TimeInfo.ntp3;
  var ntp4 = TimeInfo.ntp4;
  var ntp5 = TimeInfo.ntp5;
  var ntp_enabled = TimeInfo.Enable;
  var tz_name = TimeInfo.ZoneName;
  
  setText("NtpInterval_text", TimeInfo.SynInterval);
   setSelect("NtpType_select", TimeInfo.ExportType);
   
  with (document.forms[0])
  {
     setCheck('NtpEnable_checkbox',ntp_enabled);
	 setDisplay('ntpConfig',ntp_enabled);
		
    if( ntp1.length )
	{
      for( i = 0; i < ntpServers.length; i++ ) 
	  {
        if( ntp1 == ntpServers[i] ) 
		{
          FstServer_select.selectedIndex = i;
          break;
        }
      }
      if( i == ntpServers.length ) 
	  {
        FstServer_select.selectedIndex = i; 
        Server1Other_text.value = ntp1;
      }
    }
    ntpChange(FstServer_select,Server1Other_text);

    if( ntp2.length ) 
	{
      for( i = 0; i < ntpServers.length; i++ )
	  {
        if( ntp2 == ntpServers[i] )
		{
          SntpServer2_select.selectedIndex = i+1;
          break;
        }
      }
	  
      if( i == ntpServers.length ) 
	  {
        SntpServer2_select.selectedIndex = i+1; 
        Server2Other_text.value = ntp2;
      }
    }
	else
    {
        SntpServer2_select.selectedIndex = 0;
    }
	
	ntpChange(SntpServer2_select,Server2Other_text);
	
    if( ntp3.length ) 
	{
      for( i = 0; i < ntpServers.length; i++ )
	  {
        if( ntp3 == ntpServers[i] )
		{
          SntpServer3_select.selectedIndex = i+1;
          break;
        }
      }
	  
      if( i == ntpServers.length ) 
	  {
        SntpServer3_select.selectedIndex = i+1; 
        Server3Other_text.value = ntp3;
      }
    }
	else
    {
        SntpServer3_select.selectedIndex = 0;
    }
	
	ntpChange(SntpServer3_select,Server3Other_text);
	
	if( ntp4.length ) 
	{
      for( i = 0; i < ntpServers.length; i++ )
	  {
        if( ntp4 == ntpServers[i] )
		{
          SntpServer4_select.selectedIndex = i+1;
          break;
        }
      }
	  
      if( i == ntpServers.length ) 
	  {
        SntpServer4_select.selectedIndex = i+1; 
        Server4Other_text.value = ntp4;
      }
    }
	else
    {
        SntpServer4_select.selectedIndex = 0;
    }
	
	ntpChange(SntpServer4_select,Server4Other_text);
	
	
	if( ntp5.length ) 
	{
      for( i = 0; i < ntpServers.length; i++ )
	  {
        if( ntp5 == ntpServers[i] )
		{
          SntpServer5_select.selectedIndex = i+1;
		  
          break;
        }
      }
	  
      if( i == ntpServers.length ) 
	  {
        SntpServer5_select.selectedIndex = i+1; 
        Server5Other_text.value = ntp5;
      }
    }
	else
    {
        SntpServer5_select.selectedIndex = 0;
    }
	
   ntpChange(SntpServer5_select,Server5Other_text);
    
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
    var ntpEnabled = document.getElementById('NtpEnable_checkbox');
    var ntpServer1 = document.getElementById('FstServer_select');
    var ntpServerOther1 = document.getElementById('Server1Other_text');
    var ntpServer2 = document.getElementById('SntpServer2_select');
    var ntpServerOther2 = document.getElementById('Server2Other_text');
	var ntpServer3 = document.getElementById('SntpServer3_select');
    var ntpServerOther3 = document.getElementById('Server3Other_text');
	var ntpServer4 = document.getElementById('SntpServer4_select');
    var ntpServerOther4 = document.getElementById('Server4Other_text');
	var ntpServer5 = document.getElementById('SntpServer5_select');
    var ntpServerOther5 = document.getElementById('Server5Other_text');
    var XHWSynInterval = document.getElementById('NtpInterval_text');
  
   
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
      if( ntpServer1.selectedIndex == ntpServers.length )
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
         Form.addParameter('NTPServer1',ntpServer1[ntpServer1.selectedIndex].value);
      }
     
      if( ntpServer2.selectedIndex == ntpServers.length+1 ) 
	  {
        if( ntpServerOther2.value.length == 0 ) 
		{ // == Other
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
	  
	 if( ntpServer3.selectedIndex == ntpServers.length+1 ) 
	  {
        if( ntpServerOther3.value.length == 0 ) 
		{ 
          AlertEx('三级SNTP服务器后面的输入框不能空。');
          return;
        } 
        if (isIpFormat(ntpServerOther3.value))
        {
            if (isValidIpAddress(ntpServerOther3.value) == false)
            {
                AlertEx('三级SNTP服务器的IP地址格式不正确。');
                return;
            }
            if (isAbcIpAddress(ntpServerOther3.value) == false)
            {
                AlertEx('三级SNTP服务器的IP地址无效. \n它必须是一个单播地址。');
                return;
            }            
        }
        else 
        {
            if(isTValidName(ntpServerOther3.value) == false)
            {
                AlertEx('第三SNTP服务器的地址无效。');
                return;                
            }
        }
        Form.addParameter('NTPServer3',ntpServerOther3.value);      
        
      } 
	  else 
	  { 
        if( ntpServer3.selectedIndex > 0)
        {
		  Form.addParameter('NTPServer3',ntpServer3[ntpServer3.selectedIndex].value); 
		}
		else
		{
		  Form.addParameter('NTPServer3',''); 		
		}
      }
	  
	  if( ntpServer4.selectedIndex == ntpServers.length+1 ) 
	  {
        if( ntpServerOther4.value.length == 0 ) 
		{
          AlertEx('四级SNTP服务器后面的输入框不能空。');
          return;
        } 
        if (isIpFormat(ntpServerOther4.value))
        {
            if (isValidIpAddress(ntpServerOther4.value) == false)
            {
                AlertEx('四级SNTP服务器的IP地址格式不正确。');
                return;
            }
            if (isAbcIpAddress(ntpServerOther4.value) == false)
            {
                AlertEx('四级SNTP服务器的IP地址无效. \n它必须是一个单播地址。');
                return;
            }            
        }
        else 
        {
            if(isTValidName(ntpServerOther4.value) == false)
            {
                AlertEx('第四SNTP服务器的地址无效。');
                return;                
            }
        }
        Form.addParameter('NTPServer4',ntpServerOther4.value);      
      } 
	  else 
	  {
        if( ntpServer4.selectedIndex > 0)
        {
		  Form.addParameter('NTPServer4',ntpServer4[ntpServer4.selectedIndex].value); 
		}
		else
		{
		  Form.addParameter('NTPServer4',''); 		
		}
      }
	  
	 if( ntpServer5.selectedIndex == ntpServers.length+1 ) 
	  {
        if( ntpServerOther5.value.length == 0 ) 
		{ 
          AlertEx('五级SNTP服务器后面的输入框不能空。');
          return;
        } 
        if (isIpFormat(ntpServerOther5.value))
        {
            if (isValidIpAddress(ntpServerOther5.value) == false)
            {
                AlertEx('五级SNTP服务器的IP地址格式不正确。');
                return;
            }
            if (isAbcIpAddress(ntpServerOther5.value) == false)
            {
                AlertEx('五级SNTP服务器的IP地址无效. \n它必须是一个单播地址。');
                return;
            }            
        }
        else 
        {
            if(isTValidName(ntpServerOther5.value) == false)
            {
                AlertEx('第五SNTP服务器的地址无效。');
                return;                
            }
        }
        Form.addParameter('NTPServer5',ntpServerOther5.value);      
      } 
	  else 
	  {
        if( ntpServer5.selectedIndex > 0)
        {
		  Form.addParameter('NTPServer5',ntpServer5[ntpServer5.selectedIndex].value); 
		}
		else
		{
		  Form.addParameter('NTPServer5',''); 		
		}
      }
    } 
	else 
	{
      Form.addParameter('Enable',0);
    }
  }
   
	Form.addParameter('X_HW_SynInterval', XHWSynInterval.value);

	Form.addParameter('X_HW_ExportType', getSelectVal('NtpType_select'));
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('set.cgi?x=InternetGatewayDevice.Time&RequestFile=html/ssmp/sntp/e8csntp.asp');

  setDisable('btnApply',1);
  setDisable('cancelValue1',1);
  setDisable('ButApply_button',1);
  Form.submit();
}

function printOntSysTime()
{
   var sysTime = document.getElementById('ontSysTime');
   sysTime.innerText = "The current system time : "+sntpSysTime;
}

function refreshSNTP()
{
    window.location.replace("e8c_sntp.asp");
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
    setCheck('NtpEnable_checkbox',ntp_enabled);
	
	var ntpServer1 = document.getElementById('FstServer_select');
	var ntpServerOther1 = document.getElementById('Server1Other_text');
	var ntpServer2 = document.getElementById('SntpServer2_select');
	var ntpServerOther2 = document.getElementById('Server2Other_text');

	
    with (document.forms[0])
    {
        if( ntp1.length )
    	{
          for( i = 0; i < ntpServers.length; i++ ) 
    	  {
            if( ntp1 == ntpServers[i] ) 
    		{
              ntpServer1.selectedIndex = i;
              break;
            }
          }
          if( i == ntpServers.length ) 
    	  {
            ntpServer1.selectedIndex = i; 
            ntpServerOther1.value = ntp1;
          }
        }
        ntpChange(ntpServer1,ntpServerOther1);

        if( ntp2.length ) 
    	{
          for( i = 0; i < ntpServers.length; i++ )
    	  {
            if( ntp2 == ntpServers[i] )
    		{
              ntpServer2.selectedIndex = i+1;
              break;
            }
          }
    	  
          if( i == ntpServers.length ) 
    	  {
            ntpServer2.selectedIndex = i+1; 
            ntpServerOther2.value = ntp2;
          }
        }
        ntpChange(ntpServer2,ntpServerOther2);



        ntpEnblChange();
		document.getElementById('NtpInterval_text').value=TimeInfo.SynInterval;
    }
}

</script>

</head>
<body onLoad="LoadFrame();" onUnload="stopTimeout();" class="mainbody">

<div class="title_with_desc">时间设置</div>
<div class="title_01"  style="padding-left:10px;" width="100%">设置路由器的时间，使之与网络时间服务器同步。</div>
<div class="title_spread"></div>
<table width="100%" border="0" cellspacing="0" cellpadding="0"> 

<tr> 
<label id="SystemTime_lable" ><td class="title_01" width="20%">当前系统时间:</td>
	<td class="table_right" align="left" colspan="6" width='75%'>
	<script language="javascript">
	sntpSysTime= sntpSysTime.split("#");
	document.write(sntpSysTime[0]); 
	</script>
    </td>
</label>
</tr>
		  
</table>
<div class="func_spread"></div>
<table width="100%"  border="0" cellpadding="0" cellspacing="0" id="tabTest">
	 <tr align="left">
            <td>
                <input type='checkbox' name='NtpEnable_checkbox' id='NtpEnable_checkbox' onClick='ShowNtpConfig(this);' checked = false>
                自动同步网络时间 </td>
        </tr>
 </table>

<div class="func_spread"></div> 
<form id="ConfigForm" action="">
<div id="ntpConfig" name="ntpConfig" class="" style="z-index:2" >
    <table class="tabal_bg"  cellpadding="0" cellspacing="0" width="100%">
	<tr class="trTabConfigure" align="left">
          <td width="25%" id="dsWanName" class="table_title">时间同步通道:</td>
          <td class="table_right">
		  <select name="NtpType_select" id="NtpType_select" maxlength="20" style="width:165px;">
			<option value="0">上网通道</option>
			<option value="1">语音通道</option>   
			<option value="2">管理通道</option>
			<option value="3">其它通道</option>
		 </select>
          </td>
      </tr>
	  <tr class="trTabConfigure" align="left">
          <td width="25%" class="table_title">同步间隔（单位：秒）:</td>
          <td width="75%" class="table_right">
             <input type='text' style="width:158px;" name='NtpInterval_text' id='NtpInterval_text' size=20 maxLength=9>
          </td>
      </tr>
      <tr class="trTabConfigure" align="left">
          <td width="25%" class="table_title">一级SNTP服务器:</td>
          <td width="75%" class="table_right">
              <select name='FstServer_select' id='FstServer_select'  size="1" onChange='ntpChange(this.form.FstServer_select,this.form.Server1Other_text)'>
                  <script language="javascript">
                writeNtpList(true);
              </script>
              </select>
              <input type='text' name='Server1Other_text' id='Server1Other_text'  size=20 maxLength=63>
          </td>
      </tr>
      <tr>
          <td width="25%" class="table_title">二级SNTP服务器:</td>
          <td width="75%" class="table_right">
              <select name='SntpServer2_select' id='SntpServer2_select' size="1" onChange='ntpChange(this.form.SntpServer2_select,this.form.Server2Other_text)'>
                  <script language="javascript">
                writeNtpList(false);
              </script>
              </select>
              <input type='text' name='Server2Other_text' id='Server2Other_text' size=20 maxLength=63>
          </td>
      </tr>
	  <tr>
          <td width="25%" class="table_title">三级SNTP服务器:</td>
          <td width="75%" class="table_right">
              <select name='SntpServer3_select' id='SntpServer3_select' size="1" onChange='ntpChange(this.form.SntpServer3_select,this.form.Server3Other_text)'>
                  <script language="javascript">
                writeNtpList(false);
              </script>
              </select>
              <input type='text' name='Server3Other_text' id='Server3Other_text' size=20 maxLength=63>
          </td>
      </tr>
	  <tr>
          <td width="25%" class="table_title">四级SNTP服务器:</td>
          <td width="75%" class="table_right">
              <select name='SntpServer4_select' id='SntpServer4_select' size="1" onChange='ntpChange(this.form.SntpServer4_select,this.form.Server4Other_text)'>
                  <script language="javascript">
                writeNtpList(false);
              </script>
              </select>
              <input type='text' name='Server4Other_text' id='Server4Other_text' size=20 maxLength=63>
          </td>
      </tr>
	  <tr>
          <td width="25%" class="table_title">五级SNTP服务器:</td>
          <td width="75%" class="table_right">
              <select name='SntpServer5_select' id='SntpServer5_select' size="1" onChange='ntpChange(this.form.SntpServer5_select,this.form.Server5Other_text)'>
                  <script language="javascript">
                writeNtpList(false);
              </script>
              </select>
              <input type='text' name='Server5Other_text' id='Server5Other_text' size=20 maxLength=63>
          </td>
      </tr>
    </table>
  
  </div>
<div class="button_spread"></div>
<div class="table_submit" align="right">
		  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
		  <input name="ButApply_button" id="ButApply_button" type="button" class="submit" value="保存/应用" onClick="SubmitForm();"
</div>
</form>
</body>
</html>

