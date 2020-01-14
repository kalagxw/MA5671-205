<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  id="Page" xmlns="http://www.w3.org/1999/xhtml">
<head>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
 
    <title>DNS configuration</title>

<script>
function adjustParentHeight(containerID, newHeight)
{
	var height = (newHeight > 600) ? newHeight : 600;
	$("#" + containerID).css("height", height+ "px");
}
</script>
</head>

<body>
<div id="DivContent">
<div id="DnsHostsFrameContent">
<iframe id="dns_hosts" src="dnshosts.asp?Title=1" style="width:100%;height:100%;" frameborder="0" framespacing="0" marginwidth="0"></iframe>
</div>
</div>
</body>
</html>
