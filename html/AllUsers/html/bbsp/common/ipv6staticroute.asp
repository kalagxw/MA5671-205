    function RouteItemClass(domain, DestIPPrefix, NextHop, WanName)
    {
        this.domain = domain;
        this.DestIPPrefix = DestIPPrefix;
        this.NextHop = NextHop;
        this.WanName = WanName;
    }
    

    var RouteListTemp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_IPv6Layer3Forwarding.Forwarding.{i},DestIPPrefix|NextHop|WanName,RouteItemClass);%>;  
    var StaticRouteList = new Array();
    var DefaultRouteInfo = null;
    var Count = 0;
    for (var i = 0; i < RouteListTemp.length-1; i++)
    {
        if (RouteListTemp[i].WanName == "")
        {
            continue;
        }
        
        if (IsIPv6ZeroAddress(RouteListTemp[i].DestIPPrefix.replace("/0","")) == true)
        {
            DefaultRouteInfo = RouteListTemp[i];
            continue;
        }
        StaticRouteList[Count++] = RouteListTemp[i];
    }
    
    function GetStaticRouteList()
    {
        return StaticRouteList;
    } 
    function GetDefaultRouteInfo()
    {
        return DefaultRouteInfo;
    }