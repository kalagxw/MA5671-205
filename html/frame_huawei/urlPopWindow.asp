<html>
<head>
<title></title>		
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
</head>
<style>
.input_time {border:0px; }
</style>

<script type="text/javascript" src="../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript">


var data = "<%GetUrlPushInfo();%>";
var Wid = "";
var Hei= "";
var Xxx= "";
var Yyy= "";
var Urla= "";
var OriUrla= "";

function getPageHeight(){
  var g = document, a = g.body, f = g.documentElement, d = g.compatMode == "BackCompat"
  ? a
  : g.documentElement;
  return Math.max(f.scrollHeight, a.scrollHeight, d.clientHeight);
}

function getPageWidth(){
  var g = document, a = g.body, f = g.documentElement, d = g.compatMode == "BackCompat"
  ? a
  : g.documentElement;
  return Math.max(f.scrollWidth, a.scrollWidth, d.clientWidth);
}

function WdPopWinTraceSet()
{
    $.ajax({
        type  : "POST",
        async : false,
        cache : false,
        url   : "WebWdPopCancel",
        success : function(data) {
            conflict = true;
		//alert("success ");
        },
        error : function(XMLHttpRequest, textStatus, errorThrown) {
            conflict = false;
	    //alert("error  ");
        },
        complete: function (XHR, TS) { 
            XHR = null;
	    //alert("complete ");
      }         
    }); 
}

function LoadFrame()
{ 
    var br0Ip = '<%HW_WEB_GetBr0IPString();%>';
    var httpport = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.Services.X_HW_WebServerConfig.ListenInnerPort);%>';
    if( window.location.href.indexOf(br0Ip) == -1 )
    {
    	window.location = 'http://' + br0Ip +':'+ httpport +'/urlPopWindow.asp';    
    }

    WdPopWinTraceSet();
	setTimeout(LoadFrame1,2000);
}

function LoadFrame1()
{ 
	 var parameterS = data.split("|");
	 var browserWidth = getPageWidth();
	 var browserheight = getPageHeight();
	 var  browserWidthInt = parseInt(browserWidth,10);
 	 var  browserheightInt = parseInt(browserheight,10);
	 Wid = parameterS[0];
	 Hei = parameterS[1];
	 Xxx = parameterS[2];
	 Yyy = parameterS[3];
	 Urla = parameterS[4];
	 OriUrla = parameterS[5];
	var WidInt = 	 parseInt(Wid,10); 
	var HeiInt = 	 parseInt(Hei,10); 
	var XxxInt = 	 parseInt(Xxx,10); 
	var YyyInt = 	 parseInt(Yyy,10);

	 if ( (Wid>browserWidth) || (Xxx>browserWidth) || (Hei>browserheight) || (Yyy>browserheight) )
	 {
	     Wid = browserWidth/2;
	     Hei = browserheight/2;
	     Xxx = browserWidth/4;	    
	     Yyy = browserheight/4;
	 }
	 
	  if ( ((WidInt+XxxInt)>browserWidthInt) || ((HeiInt+YyyInt)>browserheightInt))
	 {
	     Wid = browserWidth/2;
	     Hei = browserheight/2;
	     Xxx = browserWidth/4;	    
	     Yyy = browserheight/4;
	 }
	var para = "height="+Hei+",width="+Wid+",top="+Yyy+",left="+Xxx+",toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no";
	window.open(Urla, "newwindow",para);
	window.top.location=OriUrla;
}

</script>


<body onLoad="LoadFrame();"> 
</body>

</html>









