var WLANFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>';
function TopoInfoClass(Domain, EthNum, SSIDNum)
{   
    this.Domain = Domain;
    this.EthNum = EthNum;
    this.SSIDNum = SSIDNum;
    if(WLANFlag != 1)
	  {   
        this.SSIDNum = 0;
	  } 
}

var TopoInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Topo,X_HW_EthNum|X_HW_SsidNum,TopoInfoClass);%>
var TopoInfo = TopoInfoList[0];

function GetTopoInfo()
{
    return TopoInfo;
}
function GetTopoItemValue(Name)
{
    return TopoInfo[Name];
}
