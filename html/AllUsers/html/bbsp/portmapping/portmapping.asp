<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" type="text/javascript">

var numpara1 = "";

if(( window.location.href.indexOf("?") > 0) &&( window.location.href.split("?").length == 2))
{
	 numpara1 = "?" + window.location.href.split("?")[1];
}

var PORTMAPPING_ENHANCED='<%HW_WEB_GetFeatureSupport(BBSP_FT_PM_PORTLIST);%>';
if("1" == PORTMAPPING_ENHANCED){
    window.location.replace("portmappingnew.asp" + numpara1);
}else{
    window.location.replace("portmappingold.asp" + numpara1);
}
</script>   
</head>
<body  onLoad="LoadFrame();" class="mainbody">
</body>
</html>