function GetRouteTableProcState(domain, state)
{
    this.domain = domain;
    this.state  = state;
}
<%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_FeatureList.BBSPCustomization.RouteTable,State, GetRouteTableProcState);%>;


