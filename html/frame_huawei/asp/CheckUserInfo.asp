(function(){

function WanPPP(domain,ConnectionType,X_HW_SERVICELIST,X_HW_ExServiceList,Username,Password)
{
	this.domain 	       = domain;
	this.ConnectionType 	       = ConnectionType;
	this.X_HW_SERVICELIST 	       = X_HW_SERVICELIST;
	this.X_HW_ExServiceList 	       = X_HW_ExServiceList;
	this.Username 	       = Username;
	this.Password 	       = Password;
}

function WanPPPResult(PwdCheckResult,PPPoEdomain,PPPoEUsername,PPPoEPassword)
{
	this.PwdCheckResult 	   = PwdCheckResult;
	this.PPPoEdomain 	       = PPPoEdomain;
	this.PPPoEUsername 	       = PPPoEUsername;
	this.PPPoEPassword 	       = PPPoEPassword;
}

var CheckPPPoEWANStatus = new WanPPPResult("0","0","0","0");

var PwdCheckResult = <%CheckUsrPwdForHtml();%>;

var WanList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i},ConnectionType|X_HW_SERVICELIST|X_HW_ExServiceList|Username|Password,WanPPP);%>;

function GetTr069InternetPppoeRoutedWan()
{
	var pppWanList=null;
	var loop = 0;

	if (WanList.length > 1)
	{
		for (loop = 0; loop < WanList.length - 1; loop++)
		{
			if ((WanList[loop].X_HW_SERVICELIST.toUpperCase().indexOf("INTERNET")>=0) && ('IP_ROUTED' == WanList[loop].ConnectionType.toUpperCase()))
			{
				pppWanList = WanList[loop];
				return pppWanList;
			}
		}
	}
	
	return pppWanList;
}

function Get3bbCheckInfo()
{
	var PPPoEWan = GetTr069InternetPppoeRoutedWan();
	  
   if(PPPoEWan == null)
   {	
        CheckPPPoEWANStatus.PwdCheckResult = PwdCheckResult;
		CheckPPPoEWANStatus.PPPoEdomain = null;
		CheckPPPoEWANStatus.PPPoEUsername ="";
		CheckPPPoEWANStatus.PPPoEPassword = "";

   }
   else
   {
		CheckPPPoEWANStatus.PwdCheckResult = PwdCheckResult;
		CheckPPPoEWANStatus.PPPoEdomain = PPPoEWan.domain;
		CheckPPPoEWANStatus.PPPoEUsername = PPPoEWan.Username;
		CheckPPPoEWANStatus.PPPoEPassword = PPPoEWan.Password;

   }
   return CheckPPPoEWANStatus;
}

return Get3bbCheckInfo();

})();

