var LoginRequestLanguage = '<%HW_WEB_GetLoginRequestLangue();%>';
var IsPTVDFMode = '<%HW_WEB_GetFeatureSupport(BBSP_FT_PTVDF);%>';
var RadioWanFeature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_RADIO_WAN_LOAD);%>"; 
var MobileBackupWanSwitch = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Mobile_Backup.Enable);%>';
if (MobileBackupWanSwitch == '')
{
	MobileBackupWanSwitch = 0;
}

if(typeof(HTMLElement)!="undefined" && !window.opera && !( navigator.appName == 'Microsoft Internet Explorer')) 
{ 
    HTMLElement.prototype.__defineGetter__("outerHTML",function() { 
        var a=this.attributes, str="<"+this.tagName, i=0;for(;i<a.length;i++) 
        if(a[i].specified) 
            str+=" "+a[i].name+'="'+a[i].value+'"'; 
        if(!this.canHaveChildren) 
            return str+" />"; 
        return str+">"+this.innerHTML+"</"+this.tagName+">"; 
    }); 
    HTMLElement.prototype.__defineSetter__("outerHTML",function(s) { 
        var r = this.ownerDocument.createRange(); 
        r.setStartBefore(this); 
        var df = r.createContextualFragment(s); 
        this.parentNode.replaceChild(df, this); 
        return s; 
    }); 
    HTMLElement.prototype.__defineGetter__("canHaveChildren",function(){ 
        return !/^(area|base|basefont|col|frame|hr|img|br|input|isindex|link|meta|param)$/.test(this.tagName.toLowerCase()); 
    }); 
}



function isReadModeForTR069Wan()
{
	return IsTr069WanOnlyRead();
}

	
function ShowWanListTable()
{
	var ShowTableFlag = 0;
	if ((RadioWanFeature != "1") || (IsAdminUser() == true) || (MobileBackupWanSwitch == 1))
	{
		ShowTableFlag = 1;
	}
	var BoxHideFlag = (IsAdminUser() != true) ? true : false;
	var VlanHideFlag = (IsSonetUser()) ? true : false;
	var ShowButtonFlag = (IsAdminUser() != true) ? false : true;
	var WanConfiglistInfo = new Array(new stTableTileInfo("Empty","","DomainBox",BoxHideFlag),
									new stTableTileInfo("WanConnectionName","align_center","Name",false),
									new stTableTileInfo("WanVlanPriority","align_center","VlanPriority",VlanHideFlag),
									new stTableTileInfo("WanProtocolType1","align_center","ProtocolType",false),null);
	
	var ColumnNum = 4;
	var UserInfo = new Array();
	
	for (i = 0;i < GetWanList().length; i++)
	{
		if ((IsPTVDFMode == '1') && (RadioWanFeature == "1") && (IsAdminUser() == false) && (MobileBackupWanSwitch == 1))
		{
			if (GetWanList()[i].RealName.indexOf("RADIO") < 0)
			{
				continue;
			}
		}
		UserInfo.push(GetWanList()[i]);
	}
	
	var TableDataInfo =  HWcloneObject(UserInfo, 1);
	TableDataInfo.push(null);
	
	for(var j = 0; j < TableDataInfo.length-1; j++)
	{
		var vlan = "-", pri = "-";
		if ( 0 != parseInt(TableDataInfo[j].VlanId) )
		{	
			vlan = TableDataInfo[j].VlanId;
			pri = ('SPECIFIED' == TableDataInfo[j].PriorityPolicy.toUpperCase()) ? TableDataInfo[j].Priority : TableDataInfo[j].DefaultPriority ;
		}
		TableDataInfo[j].VlanPriority = vlan+'/'+pri;
	}
	
	HWShowTableListByType(ShowTableFlag, "wanInstTable", ShowButtonFlag, ColumnNum, TableDataInfo, WanConfiglistInfo, Languages, WanConfigCallBack);
	
}


function ParsePageSpec()
{
	if (("1" == GetCfgMode().GDCT) || ("1" == GetCfgMode().FJCT) || ("1" == GetCfgMode().JSCT)
     || ("1" == GetCfgMode().CQCT) || ("1" == GetCfgMode().JXCT))
	{
		document.getElementById("DivIPv4BindLanList2").childNodes[1].nodeValue = "LAN2(iTV)";
	}
	
	if("1" != GetCfgMode().TELMEX)
	{
		$("#UserNameRemark").text("");
		$("#PasswordRemark").text("");
	}
}

function GetPageData()
{   
    var Wan = new WanInfoInst();
	Wan = GetParaValueArrayByFormId(WanConfigFormList);

    if (Wan.EncapMode == "PPPoE" && Wan.Mode == "IP_Bridged")
    {
        Wan.Mode = "PPPoE_Bridged";
    }
    
    Wan.IPv4Enable = "0";
    Wan.IPv6Enable = "0";

    if (Wan.ProtocolType == "IPv4/IPv6")
    {
        Wan.IPv4Enable = "1";
        Wan.IPv6Enable = "1";
    }
    if (Wan.ProtocolType == "IPv4")
    {
        Wan.IPv4Enable = "1";
    }
    if (Wan.ProtocolType == "IPv6")
    {
        Wan.IPv6Enable = "1";
    }
	if(IsE8cFrame())
	{
		Wan.IPv4BindLanList = Wan.IPv4BindLanList.concat(Wan.IPv4BindSsidList);
	}
    return Wan;
      
}


function BindPageData(Wan)
{
    var LanWanBindInfo = GetLanWanBindInfo(domainTowanname(Wan.domain));
    var SsidWanBindInfo = "";
    if (LanWanBindInfo != null && LanWanBindInfo != undefined)
    {
        Wan.IPv4BindLanList = LanWanBindInfo.PhyPortName.split(",");
		if(IsE8cFrame())
		{
			for(var j = 0; j< Wan.IPv4BindLanList.length; j++)
			{
				if(Wan.IPv4BindLanList[j].indexOf("SSID") >= 0)
				{
					SsidWanBindInfo += Wan.IPv4BindLanList[j] + ",";
				}
			}
			SsidWanBindInfo = SsidWanBindInfo.substring(0, SsidWanBindInfo.length - 1);
			Wan.IPv4BindSsidList = SsidWanBindInfo.split(",");
		}
    }
	
	HWSetTableByLiIdList(WanConfigFormList,Wan, null);
    
}

