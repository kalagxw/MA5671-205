<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<script language="javascript" src="../common/ProductCapInfo.asp"></script>
<title>设备信息帮助</title>
</head>
<body class="mainbody">
<blockquote>


<script language="javascript">
		   var stProductCapInfo = new stProductFlag("0", "0", "0", "0", "0", "0");
		   var MngtCQct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_CQCT);%>'; 
		   stProductCapInfo = GetProductCapInfo();
           if (stProductCapInfo.usb == 1)
		   {
		        document.write("<b>USB备份设置</b>");
				document.write("<p>将USB设备连接到终端，选择合适的USB分区，点击“备份配置”按钮，");
				document.write("将当前终端的配置备份到所选USB设备中。</p>");
				document.write("<br>");
				document.write("<b>恢复默认配置 </b>");
				document.write("<p>  点击 “恢复默认配置” 按钮，使终端设备的配置恢复为默认配置并保留关键参数（如语音、无线参数等）。</p>");
				document.write("<br>");
				document.write("<b>恢复出厂配置 </b>");
				document.write("<p>  点击 “恢复出厂配置” 按钮，使终端设备恢复出厂默认值。</p>");
		   }
		   else if(stProductCapInfo.usb == 0)
		   {
				document.write("<br>");
				document.write("<b>恢复默认配置 </b>");
				document.write("<p>  点击 “恢复默认配置” 按钮，使终端设备的配置恢复为默认配置并保留关键参数（如语音、无线参数等）。</p>");
				document.write("<br>");
				document.write("<b>恢复出厂配置 </b>");
				document.write("<p>  点击 “恢复出厂配置” 按钮，使终端设备恢复出厂默认值。</p>");
			}
			if(1 == MngtCQct)
			{
				document.write("<br>");
				document.write("<b>固件升级 </b>");
				document.write("<p> 通过固件升级功能，选择加载运营商提供的合法固件，可以更新设备的软件版本。</p>");
			}
		</script>
		
<br>
<b>设备重启</b>　　 
<p>  点击 “重启” 按钮使终端重新启动。</p>
</blockquote>
</body>
</html>

