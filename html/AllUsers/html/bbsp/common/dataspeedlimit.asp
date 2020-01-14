var INVALID_LIMIT_MODE='0';
var PORT_LIMIT_MODE='1';
var VLAN_LIMIT_MODE='2';
var IP_LIMIT_MODE='3';
var VLAN_UNTAGGED='UNTAGGED';

var MODE_Type_DOWN="DOWN";
var MODE_Type_UP="UP";


var ERROR_UP_LIMIT_PORT_INVALID='1001';
var ERROR_DOWN_LIMIT_PORT_INVALID='1002';
var ERROR_UP_LIMIT_VLAN_INVALID='1003';
var ERROR_DOWN_LIMIT_VLAN_INVALID='1004';
var ERROR_UP_LIMIT_IP_INVALID='1005';
var ERROR_DOWN_LIMIT_IP_INVALID='1006';
var ERROR_DOWN_LIMIT_SPEED_VALUE_INVALID='1007';
var ERROR_UP_LIMIT_PORT_OTHER_INVALID='1998';
var ERROR_DOWN_LIMIT_PORT_OTHER_INVALID='1999';

function DataSpeedLimitClass(Domain,SpeedLimitMode_UP,SpeedLimitMode_DOWN,InterfaceLimit_UP,
                InterfaceLimit_DOWN,VlanTagLimit_UP,VlanTagLimit_DOWN,IPLimit_UP,IPLimit_DOWN)
{
    this.domain = Domain;
    this.SpeedLimitMode_UP = SpeedLimitMode_UP;
    this.SpeedLimitMode_DOWN = SpeedLimitMode_DOWN;
    this.InterfaceLimit_UP = InterfaceLimit_UP;
    this.InterfaceLimit_DOWN = InterfaceLimit_DOWN;
    this.VlanTagLimit_UP = VlanTagLimit_UP;
    this.VlanTagLimit_DOWN = VlanTagLimit_DOWN;
    this.IPLimit_UP = IPLimit_UP;
    this.IPLimit_DOWN = IPLimit_DOWN;
}

function DataSpeedLimit()
{
    this.Domain = "";
    this.SpeedLimitMode_UP = "0";
    this.SpeedLimitMode_DOWN = "0";
    this.InterfaceLimit_UP = "";
    this.InterfaceLimit_DOWN = "";
    this.VlanTagLimit_UP = "";
    this.VlanTagLimit_DOWN = "";
    this.IPLimit_UP = "";
    this.IPLimit_DOWN = "";
}

DataSpeedLimitClass.prototype.getUpLimitSpeed = function ()
{
    var upSpeedLimit="";
    
    switch(this.SpeedLimitMode_UP)
    {
        case PORT_LIMIT_MODE:
            upSpeedLimit=this.InterfaceLimit_UP;
            break;
        case VLAN_LIMIT_MODE:
            upSpeedLimit=this.VlanTagLimit_UP;
            break;
        case IP_LIMIT_MODE:
            upSpeedLimit=this.IPLimit_UP;
            break; 
        case INVALID_LIMIT_MODE:
            upSpeedLimit="";            
        default:
            break;
    }

    return upSpeedLimit;
}


DataSpeedLimitClass.prototype.getDownLimitSpeed = function ()
{
    var downSpeedLimit="";

    switch(this.SpeedLimitMode_DOWN)
    {
        case PORT_LIMIT_MODE:
            downSpeedLimit=this.InterfaceLimit_DOWN;
            break;
        case VLAN_LIMIT_MODE:
            downSpeedLimit=this.VlanTagLimit_DOWN;
            break;
        case IP_LIMIT_MODE:
            downSpeedLimit=this.IPLimit_DOWN;
            break; 
        case INVALID_LIMIT_MODE:
            downSpeedLimit="";   
        default:
            break;
    }

    return downSpeedLimit;
}

function CheckVlanTagLimit(modeType,vlanTagLimit)
{   
    var vlanTagLimitList = vlanTagLimit.split(",");
    var tempList;
    var vlan;
    var speed;

    for (var i = 0; i < vlanTagLimitList.length; i++)
    {
    	tempList = vlanTagLimitList[i].split("/");
    		

    	if (tempList.length != 2)
    	{    
    	    if( MODE_Type_UP == modeType)
    	    {
    		    return false;
    		}
    		else
    		{
    		    return false;
    		}
    	}
    	
    	vlan = 	tempList[0].toUpperCase();
    	speed = tempList[1];
    	

    	if (!isPlusInteger(speed))
    	{
    		if( MODE_Type_UP == modeType)
    	    {
    		    return false;
    		}
    		else
    		{
    		    return false;
    		}				
    	}
    		

    	if ((vlan != VLAN_UNTAGGED) && (vlan != "") && (!CheckNumber(vlan,1,4094)))
    	{
    		if( MODE_Type_UP == modeType)
    	    {
    		    return false;
    		}
    		else
    		{
    		    return false;
    		}	
    	}
  
    }
	
    return true;
	        
}

function isValidInterface(interface)
{
    var lanId = 0;
    var ssidId = 0;
    var index=-1;
    var LAN_KEY="LAN";
    var SSID_KEY="SSID";
    

    index=interface.indexOf(LAN_KEY);
    if(-1 != index)
    {
        lanId=interface.substring(index+LAN_KEY.length,index+LAN_KEY.length+1);
        if(!isPlusInteger(lanId) || lanId > TopoInfo.EthNum)
        {
            return false;
        }
        else
        {
            return true;
        }
    }
    else
    {
        index=interface.indexOf(SSID_KEY);
        if(-1 != index)
        {
            ssidId=interface.substring(index+SSID_KEY.length,index+SSID_KEY.length+1);
        }
        else
        {
            return false;
        }
        
        if(!isPlusInteger(ssidId) || ssidId > TopoInfo.SSIDNum)
        {
            return false;
        }
        else
        {
            return true;
        }
    }
 
}

function checkInterfaceLimit(mode,interfaceLimit)
{   
    var interfaceLimitList = interfaceLimit.split(",");
    var tempList;
    var interface;
    var speed;
    	
    for (var i = 0; i < interfaceLimitList.length; i++)
    {
    	tempList = interfaceLimitList[i].split("/");
    		

    	if (tempList.length != 2)
    	{
    		return false;
    	}
    	
    	interface = tempList[0];
    	speed = tempList[1];
    	

    	if (!isPlusInteger(speed))  
    	{
    		return false;				
    	}
    		

    	if (!isValidInterface(interface.toUpperCase()))
    	{
    		return false;
    	}
    		
    }
	
    return true;
	        
}


function CheckIPSegmentLimit(modeType,ipSegmentLimit)
{   

    var ipSegmentLimit = ipSegmentLimit.split(",");
    var tempList;
    var ipSegment;
    var ipList;
    var beginIp;
    var endIp;
    var speed;
    	
    for (var i = 0; i < ipSegmentLimit.length; i++)
    {
    	tempList = ipSegmentLimit[i].split("/");
    		

    	if (tempList.length != 2)
    	{   
    		return false;
    	}
    	
    	ipSegment = tempList[0];
    	speed = tempList[1];
    	

    	if (!isPlusInteger(speed))
    	{
    		return false;				
    	}
        
        ipList=ipSegment.split("-");
        if (ipList.length != 2)
    	{
    		return false;
    	}
        
        beginIp=ipList[0];
        endIp=ipList[1];
        

        if (beginIp == "" && endIp != "" ) 
    	{
    		return false;
    	}
    	

    	if(!CheckIpAddressValid(beginIp)||!CheckIpAddressValid(endIp))
    	{
    	    return false;
    	}
    	
    }
	
    return true;
	        
}


DataSpeedLimitClass.prototype.checkDownSpeedLimit = function ()
{
    var mode = this.SpeedLimitMode_DOWN;
    var check=false;

    if(INVALID_LIMIT_MODE == mode)
    {
       return true;
    }
    
    switch(mode)
    {
        case PORT_LIMIT_MODE:
            check=checkInterfaceLimit(MODE_Type_DOWN,this.InterfaceLimit_DOWN);
            break;
        case VLAN_LIMIT_MODE:
            check=CheckVlanTagLimit(MODE_Type_DOWN,this.VlanTagLimit_DOWN);
            break;
        case IP_LIMIT_MODE:
            check=CheckIPSegmentLimit(MODE_Type_DOWN,this.IPLimit_DOWN);
            break; 
        default:
            break;
    }
    
    return check;
}


DataSpeedLimitClass.prototype.checkUpSpeedLimit = function ()
{
    var mode = this.SpeedLimitMode_UP;
    var check=false;
    var modeType="UP";
    
    if(INVALID_LIMIT_MODE == mode)
    {
       return true;
    }
    
    switch(mode)
    {
        case PORT_LIMIT_MODE:
            check=checkInterfaceLimit(MODE_Type_UP,this.InterfaceLimit_UP);
            break;
        case VLAN_LIMIT_MODE:
            check=CheckVlanTagLimit(MODE_Type_UP,this.VlanTagLimit_UP);
            break;
        case IP_LIMIT_MODE:
            check=CheckIPSegmentLimit(MODE_Type_UP,this.IPLimit_UP);
            break; 
        default:
            break;
    }
    
    return check;
}

DataSpeedLimitClass.prototype.getDomain = function ()
{
    return this.domain;
}
