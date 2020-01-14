
var ssidIdx = 0;
var changeWlanClick = 1;
var WlanBasicPage = '2G';
var WlanAdvancePage = '2G';
var lanDevIndex = 1;
var QoSCurInterface = '';
var DDNSProvider = '';
var ripIndex = "";
var previousPage = "";
var preAddDomain = "";
var editIndex = -1;
var editDomain = '';
var sptUserType = '1';
var sysUserType = '0';
var MenuName = "";
var StartIndex = 1;
var Menu2Path = "";
var authMode = 0;
var Passwordmode = 0;
var changeMethod = 999;
var UpgradeFlag = 0;
var SaveDataFlag = 0;
var collectType = "";
var PwdModifyFlag = 1;
var PwdAspNum = 0;
var SystemToolsNum = 0;
var EquipFlag = 0;
var productName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var curLanguage = '<%HW_WEB_GetCurrentLanguage();%>';
//var curWebFrame = '<%HW_WEB_GetWEBFramePath();%>';
//var curWebMenuPath = '<%HW_WEB_GetWEBMenuPath();%>';
//var pageName11 = '<%webGetReplacePage();%>';
var curUserType = '<%HW_WEB_GetUserType();%>';
var jumptomodifypwd = '<%HW_WEB_GetWebUserMdFlag();%>';
var menuArray = <%HW_WEB_GetWebMenuArray();%>;
document.title = productName;

var Frame = {

	menuItems : [],
	mainMenuCounter : 0,
	subMenuCounter : 0,
	$mainMenu : null,
	$subMenu : null,
	$content : null,

	init : function() {
		this.initData();
		this.initElement();
	},

	initData : function() {
		var frame = this;

		this.mainMenuCounter = 0;
		this.subMenuCounter = 0;

		this.$mainMenu = $("#headerTab ul");
		this.$subMenu = $("#nav ul");
		this.$content = $("#frameContent");

		this.$content.load(function() {
			frame.$content.show();
			frame.setContentHeight();
		});

		this.menuItems = eval(menuArray);
	},

	initElement : function() {
		$("#headerTitle").text(productName);

		this.setLogoutElement(curLanguage);
		this.setCopyRightInfo(curLanguage);
		this.setAppDesInfo(curLanguage);

		if (this.menuItems.length > 0) {
			this.addMenuItems(this.$mainMenu, this.menuItems, "main");

			if(("Quick Setup" == this.menuItems[0].name))
			{
				jumptomodifypwd = 1;
			}

			if ((jumptomodifypwd == 0) && (curUserType != sysUserType) && (PwdModifyFlag == 1))
			{
				this.addMenuItems(this.$subMenu, this.menuItems[this.menuItems.length - 1].subMenus, "sub");
				var pwdurl = "html/ssmp/accoutcfg/account.asp";
				if(curLanguage.toUpperCase() == "ENGLISH")
				{
					MenuName = "System Tools";
					Menu2Path = "Modify Login Password";
				}
				if(curLanguage.toUpperCase() == "CHINESE")
				{
					MenuName = "系统工具";
					Menu2Path = "修改登录密码";
				}
				else if(curLanguage.toUpperCase() == "PORTUGUESE")
				{
					MenuName = "Ferram. de Sis.";
					Menu2Path = "Alterar palavra-passe";
				}
				else if(curLanguage.toUpperCase() == "JAPANESE")
				{
					MenuName = "システムツール";
					Menu2Path = "ログインパスワードの変更";
				}
				else if(curLanguage.toUpperCase() == "SPANISH")
				{
					MenuName = "Herramientas del sistema";
					Menu2Path = "Modificar contraseña";
				}
				else
				{
					MenuName = "System Tools";
					Menu2Path = "Modify Login Password";
				}

				this.setContentPath(pwdurl);
			}
			else
			{
				MenuName = this.menuItems[0].name;
				Menu2Path = this.menuItems[0].subMenus[0].name;
				this.addMenuItems(this.$mainMenu, this.menuItems, "main");
				this.addMenuItems(this.$subMenu, this.menuItems[0].subMenus, "sub");
			}
		}
	},

	addMenuItems : function(element, menus, type) {
		var frame = this;
		var posDeviceInfo = 0;
		element.empty();
		if(type == "main") {
			this.mainMenuCounter = 0;
			for (var i = 0, len = menus.length; i < len; i++) {

				if( menus[i].name == "System Tools" || menus[i].name == "系统工具" || menus[i].name == "Ferram. de Sis." || menus[i].name == "システムツール" || menus[i].name == "Herramientas del sistema")
				{
					SystemToolsNum = i;
				}

				element.append('<li value="' + i + '">' +
					'<div class="tabBtnLeft"></div>' +
					'<div class="tabBtnCenter">' + menus[i].name + '</div>' +
					'<div class="tabBtnRight"></div>' +
				'</li>');
			}

			if ((jumptomodifypwd == 0)&& (curUserType != sysUserType) && (PwdModifyFlag == 1))
			{
				element.children("li").eq(SystemToolsNum).addClass("hover");
			}
			else
			{
				 element.children("li").eq(0).addClass("hover");
			}

			element.children("li").click(function() {
				if (!element.children("li").eq(this.value).is(".hover")) {
					if(frame.mainMenuCounter != SystemToolsNum)
					{
						element.children("li").eq(SystemToolsNum).removeClass("hover");
					}

					element.children("li").eq(frame.mainMenuCounter).removeClass("hover");
					element.children("li").eq(this.value).addClass("hover");
					frame.mainMenuCounter = this.value;
					MenuName = menus[this.value].name;
					frame.addMenuItems($("#nav ul"), menus[this.value].subMenus, "sub");
				}
			});
		} else if (type == "sub") {
			this.subMenuCounter = 0;
			for (var i = 0, len = menus.length; i < len; i++) {
				element.append('<li value="' + i + '"><div>' + menus[i].name + '</div></li>');
				if("Device Information" == menus[i].name || "设备信息" == menus[i].name || "Infor. do dispositivo" == menus[i].name || "デバイス情報" == menus[i].name || "Información del dispositivo" == menus[i].name)
				{
					posDeviceInfo = i;
				}

				if(menus[i].name == "Modify Login Password" || menus[i].name == "修改登录密码"  || menus[i].name == "Alterar palavra-passe" || menus[i].name == "ログインパスワードの変更" || menus[i].name == "Modificar contraseña" )
				{
					PwdAspNum = i;
				}
			}
			if ((jumptomodifypwd == 0) && (curUserType != sysUserType) && (PwdModifyFlag == 1))
			{
				element.children("li").eq(PwdAspNum).addClass("hover");
				PwdModifyFlag = 0;
			}
			else
			{
				element.children("li").eq(frame.subMenuCounter).removeClass("hover");
				element.children("li").eq(posDeviceInfo).addClass("hover");
				frame.subMenuCounter = posDeviceInfo;
				Menu2Path = menus[posDeviceInfo].name;
				frame.setContentPath(menus[posDeviceInfo].url);
			}
			element.children("li").click(function() {
				 if(PwdAspNum != frame.subMenuCounter)
				 {
					 element.children("li").eq(PwdAspNum).removeClass("hover");
				 }

				element.children("li").eq(frame.subMenuCounter).removeClass("hover");
				element.children("li").eq(this.value).addClass("hover");
				frame.subMenuCounter = this.value;

				Menu2Path = menus[this.value].name;
				frame.setContentPath(menus[this.value].url);
			});
		}
	},

	setContentPath : function(url) {
		var msg;
		if (UpgradeFlag == 1)
		{
			if(curLanguage == 'english') {
				msg = 'Note: Upgrade will be interrupted and the device might not boot successfully next time if you switch to another page. It is strongly recommended to press cancel and remain on this page until the upgrade is complete.';
			}else if(curLanguage == 'portuguese') {
				msg = 'Nota: Actualização será interrompida e o dispositivo pode não iniciar com sucesso a próxima vez que mudar para outra página. É altamente recomendável pressionar cancelar e permanecer nesta página até a actualização estar concluída.';
			}else if(curLanguage == 'japanese') {
				msg = '備考: 別のページに切り替えると、アップグレードが中断され、次回デバイスがうまく起動できない可能性があります。 キャンセルを選択し、アップグレードが完了するまでこのページを切り替えないことをお薦めします。';
			}else if(curLanguage == 'spanish') {
				msg = 'Nota: Si decide cambiar de página, la actualización \nse interrumpirá y es posible que el dispositivo no arranque \nla próxima vez. Se recomienda presionar cancelar y permanecer en esta página hasta que se complete la actualización.';
			}else if(curLanguage == 'chinese') {
				msg = '提醒:系统正在升级，离开本页面会导致升级失败。强烈建议您点击\"取消\"，停留在本页面，直到升级成功。';
			}
			if(confirm(msg))
			{
				UpgradeFlag = 0;
				this.setMenuPath();
				this.$content.attr("src", url);
			}
		}
		else
		{
			this.setMenuPath();
			this.$content.attr("src", url);
		}
	},

	setContentHeight : function() {
		setInterval(function() {
			try {
				var height = 0;
				if (window.ActiveXObject) {
					height = document.getElementById("frameContent").contentWindow.document.body.scrollHeight;
				}

				else if (window.XMLHttpRequest) {
					height = document.getElementById("frameContent").contentWindow.document.body.offsetHeight;
				}
				height = Math.max(height, 570);
				$("#center").height(height + 25);
				$("#nav").height(height + 25);
				$("#content").height(height + 25);
				$("#frameWarpContent").height(height);
				$("#frameContent").height(height);
			} catch (e) {

			}
		}, 200);
	},

	setMenuPath : function() {
		$("#topNav #topNavMainMenu").text(MenuName);
		$("#topNav #topNavSubMenu").text(Menu2Path);
	},

	setLogoutElement : function(curLanguage) {
		if(curLanguage == "english")
		{
			$("#headerLogout span").html("Logout");
		}
		else if(curLanguage == "chinese") {
			$("#headerLogout span").html("退出");
		}
		else if(curLanguage == "portuguese")
		{
			$("#headerLogout span").html("Terminar sessão");
		}
		else if(curLanguage == "japanese")
		{
			$("#headerLogout span").html("ログアウト");
		}
		else if(curLanguage == "spanish")
		{
			$("#headerLogout span").html("Cerrar sesión");
		}
		var frame = this;

		$("#headerLogout span").mouseover(function() {
			$("#headerLogout span").css({
				"color" : "#990000",
				"text-decoration" : "underline"
			});
		});
		$("#headerLogout span").mouseout(function() {
			$("#headerLogout span").css({
				"color" : "#000000",
				"text-decoration" : "none"
			});
		});
		$("#headerLogout span").click(function() {
			frame.clickLogout();
		});
	},

	setCopyRightInfo : function(language) {
		if (language == "english") {
			$("#footerText").html("Copyright © Huawei Technologies Co., Ltd. 2009-2017. All rights reserved. ");
		}else if (language == "portuguese") {
			$("#footerText").html("Copyright © Huawei Technologies Co., Ltd 2009-2017. Todos os direitos reservados. ");
		}else if (language == "japanese") {
			$("#footerText").html("Copyright © Huawei Technologies Co., Ltd. 2009-2017. All rights reserved. ");
		}else if (language == "spanish") {
			$("#footerText").html("Copyright © Huawei Technologies Co., Ltd. 2009-2017. Todos los derechos reservados. ");
		}else if (language == "chinese") {
			$("#footerText").html("版权所有 © 华为技术有限公司 2009-2017。保留一切权利。");
		}
	},
	setAppDesInfo : function(language) {
		if (language == "english") {
			$("#appdes").html("Click or scan to download the APP");
		}else if (language == "portuguese") {
			$("#appdes").html("Clique ou digitalize para transferir a aplicação.");
		}else if (language == "japanese") {
			$("#appdes").html("クリックまたはスキャンしてAPPをダウンロードしてください");
		}else if (language == "spanish") {
			$("#appdes").html("Hacer clic en la imagen o escanearla para descargar la APP.");
		}
	},
	clickLogout : function() {
		var sUserAgent = navigator.userAgent
		var isIELarge11 = (sUserAgent.indexOf("Trident") > -1 && sUserAgent.indexOf("rv") > -1);
		if (isIELarge11) {
			$.post('logout.cgi?&RequestFile=html/logout.html');
		}
		else
		{
			var Form = new webSubmitForm();
			Form.setAction('logout.cgi?RequestFile=html/logout.html');
			Form.submit();
		}
	},
	show : function() {
		var frame = this;
		$(document).ready(function() {
			frame.init();
		});
	},
	showjump : function(hpa,zpa)
	{
		if((productName == 'HG8045') && (curUserType == sysUserType))
		{
			hpa--;
		}
		this.$mainMenu.children("li").eq(this.mainMenuCounter).removeClass("hover");
		this.$mainMenu.children("li").eq(this.menuItems.length-hpa).addClass("hover");
		this.mainMenuCounter=this.menuItems.length-hpa;
		this.addMenuItems($("#nav ul"), this.menuItems[this.menuItems.length-hpa].subMenus, "sub");
		this.$subMenu.children("li").eq(this.subMenuCounter).removeClass("hover");
		this.$subMenu.children("li").eq(zpa).addClass("hover");
		MenuName = this.menuItems[this.menuItems.length-hpa].name;
		Menu2Path = this.menuItems[this.menuItems.length-hpa].subMenus[zpa].name;
		this.setContentPath(this.menuItems[this.menuItems.length-hpa].subMenus[zpa].url);
		this.subMenuCounter=zpa;
	}
};

Frame.show();

