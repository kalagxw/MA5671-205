var UserDhcpInfo;
var UserDevInfo;


function sprint(data)
{
    var i=1;
    var args=arguments;
    return data.replace(/%s/g, function(){return (i<args.length) ? args[i++]:"";});
}

function GetOldLanUserDhcpInfo(func)
{

	$.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "/html/bbsp/common/GetLanUserDhcpInfo.asp",
            success : function(data) {
            UserDhcpInfo = eval(data);
            if (func)
		{
			func(UserDhcpInfo);
		}
            }
        });
	
}

function GetOldLanUserDevInfo(func)
{
	$.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "/html/bbsp/common/GetLanUserDevInfo.asp",
            success : function(data) {
            UserDevInfo = eval(data);  
      	    if (func)
	    {
		func(UserDevInfo);
	    } 
            }
        });
	
}

'<%HW_WEB_UserDevSendArp();%>';

function GetLanUserDhcpInfo(func)
{	
    setTimeout(function() {GetOldLanUserDhcpInfo(func);}, 1000);
}

function GetLanUserDevInfo(func)
{	
    setTimeout(function() {GetOldLanUserDevInfo(func);}, 1000);
}

function GetLanUserDevInfoNoDelay(func)
{	
    GetOldLanUserDevInfo(func);
}

function GetLanUserInfo(func)
{
	var devinfo =  new Array(null);
	var dhcpinfo =  new Array(null);

        setTimeout( function() {
		GetOldLanUserDevInfo(
		  function(para1)
		  {
		     for(var i = 0; i < para1.length - 1;i++)
		     {
		         devinfo[i] = para1[i];		         
		     } 
		     devinfo[i] = null;
		  }
		);

		GetOldLanUserDhcpInfo(
		function(para2)
		{
		     for(var i = 0; i < para2.length - 1;i++)
		     {
		         dhcpinfo[i] = para2[i];
		     } 
		     dhcpinfo[i] = null;
		}
		);
		func(dhcpinfo, devinfo);
		}, 1000);
}
