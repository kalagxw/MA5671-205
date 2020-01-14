function stProhibitPortArray(PortStart, PortEnd)
{
    this.PortStart = PortStart;
    this.PortEnd   = PortEnd;  
} 

var ProhibitInternetPortArray = new Array();
var ProhibitVoIPPortArray = new Array();
var ProhibitIPTVPortArray = new Array();

function GenerateProhibitPortArrayByWanType(WanType, ProhibitPortList)
{
	var ProhibitPort = ProhibitPortList.split(",");	
	var MinusPos, ProhibitPortStart, ProhibitPortEnd;
	
	for (var ArrayIdx = 0; ArrayIdx < ProhibitPort.length; ArrayIdx++)
	{
		MinusPos = ProhibitPort[ArrayIdx].indexOf("-");
		
		if (MinusPos < 0)
		{
			 ProhibitPortStart = ProhibitPortEnd = parseInt(ProhibitPort[ArrayIdx], 10);		 			 
		}
		else
		{
	    	var StartAndEnd   = ProhibitPort[ArrayIdx].split("-");	
		 	ProhibitPortStart = parseInt(StartAndEnd[0], 10);
		 	ProhibitPortEnd   = parseInt(StartAndEnd[1], 10);
		}
	
		switch (WanType.toUpperCase())
		{
			case "INTERNET":
				ProhibitInternetPortArray[ArrayIdx] = new stProhibitPortArray(ProhibitPortStart, ProhibitPortEnd);
				break;
			case "VOIP":
				ProhibitVoIPPortArray[ArrayIdx] = new stProhibitPortArray(ProhibitPortStart, ProhibitPortEnd);
				break;
			case "IPTV":
				ProhibitIPTVPortArray[ArrayIdx] = new stProhibitPortArray(ProhibitPortStart, ProhibitPortEnd);
				break;
			default:
				break;
		}
	}
	
	return;
}

function GenerateProhibitPortArray(ProhibitPortList)
{
	var ProhibitPortByWanType = ProhibitPortList.split(";");	
	
	for (var ArrayIdx = 0; ArrayIdx < ProhibitPortByWanType.length; ArrayIdx++)
	{
		var ProhibitWanTypePorts = ProhibitPortByWanType[ArrayIdx].split("[");
		var WanType = "";
		
		if (ProhibitWanTypePorts[0].toUpperCase().indexOf("INTERNET") >= 0)
		{
			 WanType = "INTERNET";		 			 
		}
		else if (ProhibitWanTypePorts[0].toUpperCase().indexOf("IPTV") >= 0)
		{
	    	WanType = "IPTV";	
		}
		else if (ProhibitWanTypePorts[0].toUpperCase().indexOf("VOIP") >= 0)
		{
	    	WanType = "VOIP";
		}
		
		var ProhibitPorts = ProhibitWanTypePorts[1].split("]");
	
		GenerateProhibitPortArrayByWanType(WanType, ProhibitPorts[0]);
	}
	
	return;
}

function PortFwdProhibitCheck(ServiceList, ChkPortStart, ChkPortEnd)
{
	var ProhibitPortArray = new Array();
	var ArrayIdx = 0;
	
	if (ServiceList.toUpperCase().indexOf("INTERNET") >= 0)
	{
		for (var ii = 0; ii < ProhibitInternetPortArray.length; ii++)
		{
			ProhibitPortArray[ArrayIdx] = new stProhibitPortArray(ProhibitInternetPortArray[ii].PortStart, ProhibitInternetPortArray[ii].PortEnd);
			ArrayIdx++;
		}
	}
	if (ServiceList.toUpperCase().indexOf("VOIP") >= 0)
	{
		for (var vi = 0; vi < ProhibitVoIPPortArray.length; vi++)
		{
			ProhibitPortArray[ArrayIdx] = new stProhibitPortArray(ProhibitVoIPPortArray[vi].PortStart, ProhibitVoIPPortArray[vi].PortEnd);
			ArrayIdx++;
		}
	}
	if (ServiceList.toUpperCase().indexOf("IPTV") >= 0)
	{
		for (var ti = 0; ti < ProhibitIPTVPortArray.length; ti++)
		{
			ProhibitPortArray[ArrayIdx] = new stProhibitPortArray(ProhibitIPTVPortArray[ti].PortStart, ProhibitIPTVPortArray[ti].PortEnd);
			ArrayIdx++;
		}
	}
		
    for (ArrayIdx = 0; ArrayIdx < ProhibitPortArray.length; ArrayIdx++)
    {
    	if ((ProhibitPortArray[ArrayIdx].PortStart >= ChkPortStart) && (ProhibitPortArray[ArrayIdx].PortStart <= ChkPortEnd))
    	{
    	    return true;
    	}

    	if ((ChkPortStart >= ProhibitPortArray[ArrayIdx].PortStart) && (ChkPortStart <= ProhibitPortArray[ArrayIdx].PortEnd))
    	{
    	    return true;
    	}

    	if ((ProhibitPortArray[ArrayIdx].PortStart >= ChkPortStart) && (ProhibitPortArray[ArrayIdx].PortEnd <= ChkPortEnd))
    	{
			return true;
    	}
            
		if ((ProhibitPortArray[ArrayIdx].PortStart <= ChkPortStart) && (ProhibitPortArray[ArrayIdx].PortEnd >= ChkPortEnd))
    	{
			return true;
    	}
	}
	
	return false;
}
