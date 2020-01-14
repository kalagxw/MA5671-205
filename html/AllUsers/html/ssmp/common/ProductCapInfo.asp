function stProductFlag(lan, wlan, usb, voice, catv, remote)
{
	this.lan = lan;
	this.wlan = wlan;
	this.usb = usb;
	this.voice = voice;
	this.catv = catv;
	this.remote = remote;
}

var ProductCapInfo = new stProductFlag("0", "0", "0", "0", "0", "0");
ProductCapInfo.usb = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_USB);%>';
ProductCapInfo.remote = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_TR069);%>';
ProductCapInfo.lan = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_APMLAN);%>';
ProductCapInfo.voice = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_APMVOICE);%>';
ProductCapInfo.catv = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_APMRF);%>';
ProductCapInfo.wlan = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_APMWLAN);%>';

function GetProductCapInfo()
{
    return ProductCapInfo;
}