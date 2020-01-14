<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title></title>
<script type="text/javascript">
var refreshData = 1;
function IsFF()
{          
	return navigator.userAgent.indexOf("Firefox")!=-1;      
}

function CheckHeartAllWithoutFF()
{
	   $.ajax({
            type : "GET",
            async : true,
            cache : false,
            url : "../html/ssmp/common/refreshTime.asp",
            success : function(data) {
            
            	refreshData = data;
			    if ( refreshData != 1)
				{
					clearInterval(TimerHandle);
					window.location.replace("login.asp");
				}
            }
        });
}

function CheckHeartStatus()
{
	var xmlHttp = false;
	try 
	{
		xmlHttp = new XMLHttpRequest();
	}
	catch (trymicrosoft) 
	{
	 	try 
		{
			xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
		} 
		catch (othermicrosoft) 
		{
			try 
			{
				xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
			} 
			catch (failed) 
			{ 
				xmlHttp = false;
			}
		}
	}
	
	if (!xmlHttp)
	{
		return true;
	}
	
	try
	{
	    xmlHttp.open("GET", "../html/ssmp/common/refreshTime.asp", false);
		xmlHttp.send(null);
	}
	catch(e)
	{
		return true;
	}

	
	var HeartStatus = xmlHttp.responseText;
	if (HeartStatus.substr(0,1) == "1") {
	    return true;
    } else {
        return false;
    }
}

function requestCgi()
{
	if (parent.UpgradeFlag == "0")
	{ 
		if (true == IsFF())
		{
			if (false == CheckHeartStatus())
			{
				clearInterval(TimerHandle);
				window.location.replace("login.asp");
			}
		}
		else
		{
			CheckHeartAllWithoutFF();
		}
	}
}

var TimerHandle = setInterval("requestCgi()", 5000);
</script>
</head>
<body onload=""> </body>
</html>
