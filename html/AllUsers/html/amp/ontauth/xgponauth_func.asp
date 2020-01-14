

var xgponregisterid = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_XgponDeviceInfo.RegistrationID);%>';
var xgponmutualauthswitch = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_XgponDeviceInfo.MutualAuthSwitch);%>';
var xgponpsk = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_XgponDeviceInfo.PreSharedKey);%>';
var PonMode = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.AccessModeDisp.XG_AccessMode);%>';
var IsXGpon = false;

if (PonMode == '10g-gpon')
{
	IsXGpon = true;
}
else
{
	IsXGpon = false;
}


function xgpon_init()
{
	if (true != IsXGpon)
	{
		return;
	}

	setText("RegisterId", xgponregisterid);
	setText("tRegisterId", xgponregisterid);
	setText("Psk", xgponpsk);
	setText("tPsk", xgponpsk);
	setCheck("MutualAuth", xgponmutualauthswitch);
	setDisplay("TrPasswordGpon", 0);
	setDisplay("TrPasswordmode", 0);
    setDisplay("TrHexPassword",0);	
	
	if (1 == getRadioVal("rMethod"))
	{
		setDisplay("TrPSK", 0);
		setDisplay("TrRegisterId", 0);
		setDisplay("TrMutualAuth", 0);
		return;
	}
	
	setDisplay("TrMutualAuth", 1);
	if (1 == xgponmutualauthswitch)
	{
		setDisplay("TrPSK", 1);
		setDisplay("TrRegisterId", 0);
	}
	else
	{
		setDisplay("TrPSK", 0);
		setDisplay("TrRegisterId", 1);
	}
	
	if  ((isOntOnline == 1) && (curUserType != sysUserType))	
	{
		setDisable("RegisterId", 1);
		setDisable("tRegisterId", 1);
		setDisable("Psk", 1);
		setDisable("tPsk", 1);
	}

}

function onMutualAuthSwitch()
{
	if (1 == getCheckVal("MutualAuth"))
	{
		setDisplay("TrRegisterId", 0);
		setDisplay("TrPSK", 1);
	}
	else
	{
		setDisplay("TrRegisterId", 1);
		setDisplay("TrPSK", 0);
	}
	
	xgponmutualauthswitch = getCheckVal("MutualAuth");
}

function checkxgponinfo()
{
	var ret = CheckStr("RegisterId", xgponregisterid, 0, 36);
	
	if (false == ret)
	{
		return false;
	}
	
	ret = CheckStr("Psk", xgponpsk, 0, 16);
	
	return ret;
}

function AddXgponForm(Form, requestfile)
{
	if (true != IsXGpon)
	{
		return;
	}
	
	Form.addParameter("y.RegistrationID", xgponregisterid);
	Form.addParameter("y.MutualAuthSwitch", xgponmutualauthswitch);
	Form.addParameter("y.PreSharedKey", xgponpsk);

	Form.setAction('set.cgi?' +'x=InternetGatewayDevice.DeviceInfo&y=InternetGatewayDevice.X_HW_XgponDeviceInfo' 
						+ '&RequestFile=' + requestfile);
}
