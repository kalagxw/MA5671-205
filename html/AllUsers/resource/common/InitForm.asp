
if(typeof(HTMLElement)!="undefined" && !window.opera && !( navigator.appName == 'Microsoft Internet Explorer')) 
{ 
    HTMLElement.prototype.__defineGetter__("outerHTML",function() { 
        var a=this.attributes, str="<"+this.tagName, i=0;for(;i<a.length;i++) 
        if(a[i].specified) 
            str+=" "+a[i].name+'="'+a[i].value+'"'; 
        if(!this.canHaveChildren) 
            return str+" />"; 
        return str+">"+this.innerHTML+"</"+this.tagName+">"; 
    }); 
    HTMLElement.prototype.__defineSetter__("outerHTML",function(s) { 
        var r = this.ownerDocument.createRange(); 
        r.setStartBefore(this); 
        var df = r.createContextualFragment(s); 
        this.parentNode.replaceChild(df, this); 
        return s; 
    }); 
    HTMLElement.prototype.__defineGetter__("canHaveChildren",function(){ 
        return !/^(area|base|basefont|col|frame|hr|img|br|input|isindex|link|meta|param)$/.test(this.tagName.toLowerCase()); 
    }); 
}

var g_curLanguage = '<%HW_WEB_GetCurrentLanguage();%>';
var NewCurValue;
var DelCurValue;
function LanguageInfo(Language, New, Delete)
{
	this.Language = Language;
	this.New = New;
	this.Delete = Delete;
}

var LanguageArrayInfos = new Array( new LanguageInfo("english","New","Delete"),
								    new LanguageInfo("chinese","新建","删除"),
								    new LanguageInfo("arabic","جديد","حذف"),
									new LanguageInfo("japanese","新規作成","削除"),
									new LanguageInfo("portuguese","Novo","Apagar"),
									new LanguageInfo("spanish","Nueva","Eliminar"),
									null );
									

function GetLanguageInfo(LanguageArrayInfos,curLanguage)
{
	var length = LanguageArrayInfos.length;
	for( var i = 0; i < length - 1; i++)
	{
		if(curLanguage == LanguageArrayInfos[i].Language)
		{
			NewCurValue = LanguageArrayInfos[i].New;
			DelCurValue = LanguageArrayInfos[i].Delete;
		}
	}
}									

									
if(!window.console){
	window.console = {};
	var funcs = ['clear', 'debug', 'error','info', 'log', 'trace', 'warn'];
	for(var i = 0; i < funcs.length; i++) {
		window.console[funcs[i]] = function(){};
	}
}

function writeFile(str)
{
	var fso, ctf;
	try
	{
		if(window.ActiveXObject) {
			fso = new ActiveXObject("Scripting.FileSystemObject");
			ctf = fso.CreateTextFile("c:\\test.txt", true);
			ctf.Write (str);
			ctf.Close();
		}
	}
	catch (e) {
	}
}


function selectLine(id)
{
	this.id = id;
	var TableId = this.id.split('_')[0];
	var objTR = getElement(id);
	if (objTR != null)
	{
		var IdStr = objTR.id;
		var SplitObj = IdStr.match(/\_/g);
		if(SplitObj.length >= 2)
		{
			var temp = objTR.id.split('_')[2];
		}
		else
		{
			var temp = objTR.id.split('_')[1];
		}

		if (temp == 'null')
		{
			setControl(-1, this.id);
			setLineHighLight(objTR);
			setDisable('btnApply',0);
			setDisable('btnCancel',0);
		}
		else if (temp == 'no')
		{
			setControl(-2, this.id);
			setDisable('btnApply',0);
			setDisable('btnCancel',0);
		}
		else
		{
			var index = parseInt(temp);
			setControl(index, this.id);
			setLineHighLight(objTR);
			setDisable('btnApply',1);
			setDisable('btnCancel',1);
		}
	}
}

function clickAdd(tabTitle)
{
	var tab = document.getElementById(tabTitle).getElementsByTagName('table');
	var row,col;
	var rowLen = tab[0].rows.length;
	var PrevTabID = "";
	var insertlength = 0;
	
	if(-1 != tabTitle.indexOf("_head"))
	{
		PrevTabID = tabTitle.split("_")[0];
		var Record_null = PrevTabID+"_record_null";
		var Record_no = PrevTabID+"_record_no";
	}
	else
	{
		PrevTabID = '';
		var Record_null = "record_null";
		var Record_no = "record_no";
	}

	var firstRow = tab[0].rows[0];
	var lastRow = tab[0].rows[rowLen - 1];

	if (lastRow.id == Record_null)
	{
		selectLine(Record_null);
		return;
	}
	else if (lastRow.id == Record_no)
	{
		tab[0].deleteRow(rowLen-1);
		rowLen = tab[0].rows.length;
	}

	row = tab[0].insertRow(rowLen);

	var appName = navigator.appName;
	if(appName == 'Microsoft Internet Explorer')
	{
		g_browserVersion = 1; /* IE */
		row.className = 'trTabContent';
		row.id = Record_null;
		row.attachEvent("onclick", function(){  selectLine(Record_null);  });
	}
	else
	{
		g_browserVersion = 2; /* firefox */
		row.setAttribute('class','trTabContent');
		row.setAttribute('id',Record_null);
		row.setAttribute('onclick','selectLine(this.id);');
	}
	
	/* get first or second cells length*/
	insertlength = firstRow.cells.length;
	if(1 == firstRow.cells.length)
	{	
		SecondRow = tab[0].rows[1];
		insertlength = SecondRow.cells.length
	}
	for (var i = 0; i < insertlength; i++)
	{
		col = row.insertCell(i);
		col.innerHTML = '----';
		col.style.textAlign = 'center';
	}

	selectLine(Record_null);
}


function addNullInst(tabTitle)
{
	var tab = document.getElementById(tabTitle).getElementsByTagName('table');
	var row,col;
	var rowLen = tab[0].rows.length;
	var firstRow = tab[0].rows[0];
	var lastRow = tab[0].rows[rowLen - 1];

	tab[0].deleteRow(rowLen-1);
	rowLen = tab[0].rows.length;
	row = tab[0].insertRow(rowLen);

	var appName = navigator.appName;
	if (appName == 'Microsoft Internet Explorer')
	{
		g_browserVersion = 1; /* IE */
		row.className = 'trTabContent';
		row.id = 'record_no';
		row.attachEvent("onclick", function(){selectLine("record_no");});
	}
	else
	{
		g_browserVersion = 2; /* firefox */
		row.setAttribute('class','trTabContent');
		row.setAttribute('id','record_no');
		row.setAttribute('onclick','selectLine(this.id);');
	}

	for (var i = 0; i < firstRow.cells.length; i++)
	{
		col = row.insertCell(i);
		col.innerHTML = '----';
		col.style.textAlign = 'center';
	}
	selectLine("record_no");
}

function removeInst(url)
{
	var rml = getElement('rml');
	if (rml == null)
		return;

	var SubmitForm = new webSubmitForm();
	var cnt = 0;
	with (document.forms[0])
	{
		if (rml.length > 0)
		{
			for (var i = 0; i < rml.length; i++)
			{
				if (rml[i].checked == true)
				{
					SubmitForm.addParameter(rml[i].value,'');
					cnt++;
				}
			}
		}
		else if (rml.checked == true)
		{
			SubmitForm.addParameter(rml.value,'');
			cnt++;
		}
	}

	SubmitForm.setAction('del.cgi?RequestFile=' + url);
	SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
	SubmitForm.submit();
}

function writeTabInfoHeader(tabTitle, tabWidth, btnWidth, tabId)
{
	writeTabHeader(tabTitle, tabWidth, btnWidth, 'info', tabId);
}

function writeTabCfgHeader(tabTitle, tabWidth, btnWidth, tabId)
{
	writeTabHeader(tabTitle, tabWidth, btnWidth, 'cfg', tabId);
}

function writeTabTail()
{
	document.write("<\/td><\/tr><\/table>");
}


var PreSelectTr = null;
var PreSelectTrcClassName = '';
var previousTR = null;
function setLineHighLight(objTR)
{
	if (previousTR != null)
	{
		previousTR.style.backgroundColor = PreSelectTrcClassName;
		for (var i = 0; i < previousTR.cells.length; i++)
		{
			previousTR.cells[i].style.color = '#000000';
		}
	}

	try{
		var id = objTR.id;
		PreSelectTrcClassName = $("#"+id).css("background-color");
	}catch(e)
	{
		PreSelectTrcClassName='';
	}
	objTR.style.backgroundColor = '#c7e7fe';
	for (var i = 0; i < objTR.cells.length; i++)
	{
		objTR.cells[i].style.color = '#000000';
	}
	previousTR = objTR;
}

function GetXmlHttp_diff()
{
	var diff_xmlHttp;
	if(window.ActiveXObject){
		try {
			diff_xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
		}catch (e) {
		}
		if (diff_xmlHttp == null)
			try{
				diff_xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e) {
			}
	} else {
		diff_xmlHttp = new XMLHttpRequest();
	}
	return diff_xmlHttp;
}
function RedirectCurrentPage_diff()
{
	var curLoc = window.location.href;

	if ( curLoc.lastIndexOf("RequestFile=") > 0 ){
		curLoc = "/" + curLoc.split("RequestFile=")[1];
	}
	try {
		var diff_xmlHttp = GetXmlHttp_diff();
		diff_xmlHttp.open("GET",curLoc,false);
		diff_xmlHttp.send();
		if(4 == diff_xmlHttp.readyState){
			if(200 == diff_xmlHttp.status) {
				window.location = curLoc;
			}else{
				console.info(curLoc, diff_xmlHttp.status);
			}
		}
	} catch (e){
	}
}

function OnDeleteButtonClick(tabTitle)
{
	var Selected = false;
	var RmlList = document.getElementsByName("rml");
	for (var i = 0; i < RmlList.length; i++)
	{
		if (RmlList[i].checked == true)
		{
			Selected = true;
		}
	}
	if (Selected == true)
	{
		document.getElementById("DeleteButton").disabled = true;
	}

	clickRemove(tabTitle, "DeleteButton");
}


function writeTabHeader(tabTitle, tabwidth, btnWidth, type, tabId)
{
	if (tabwidth == null)
		tabwidth = "100%";

	var html = "<table";

	if (tabId != null)
	{
		html += " id=\"" + tabId + "\"";
	}

	html += " width=\"" + tabwidth + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">"
			+ "<tr class=\"alignment_rule\">"
			+ "<td>";
	
	if ('cfg' == type)
	{
		GetLanguageInfo(LanguageArrayInfos, g_curLanguage);
		
		html +=  '<input style="width:' + btnWidth + '"' +'class="NewDelbuttoncss" id="Newbutton" type="button" value="' + NewCurValue + '"'
				 + 'onclick="clickAdd(\''
				 + tabTitle + '\');">'
				 + '<input style="margin-left:9px;width:' + btnWidth + '"' +'id="DeleteButton" class="NewDelbuttoncss" type="button" value="' + DelCurValue + '"'
				 + 'onclick="OnDeleteButtonClick(\''
				 + tabTitle + '\');">'	 
				 + '<tr>'
				 + '<td class="button_spread">'
				 + "<\/td>"
				 + "<\/tr>";
	}

	html += "<\/td>"
			+ "<\/tr>"
			+ "<tr>"
			+ "<td id=\"" + tabTitle + "\">";

	writeFile(html);
	document.write(html);
}

function HWCreatePageHeadInfo(TitleId, Titlestring, SummaryInfo, IsneedImg)
{
	var HeadInfoHtml = HWAppendTitle(TitleId, Titlestring, SummaryInfo, IsneedImg);	
	document.write(HeadInfoHtml);
	return true;
}

function HWGetIdByBindField(FormLiIdList, BindField)
{
	var ElementLength = FormLiIdList.length;
	for (var i = 0; i < ElementLength; i++)
	{
		var ElementId = FormLiIdList[i];
		var ElementInfo = document.getElementById(ElementId);
		if(null == ElementInfo)
		{
			ElementInfo = document.getElementById(ElementId+"1");
			if(null == ElementInfo)
			{
				continue;
			}
		}
		var ParaName = ElementInfo.getAttribute("BindField");
		var SplitStr = "";
		try{SplitStr = ParaName.split(".")[1];}catch(e){}
		if(ParaName == BindField || SplitStr == BindField)
		{
			return ElementId;
		}
	}
	return null;
}

function GetCheckboxFuncString(TableId)
{
	var FuncStr = TableId + "selectRemoveCnt";
	if("undefined" != typeof(FuncStr))
	{
		return ' onclick="' + FuncStr + '(this);"';
	}
	return "";
}

function FillTableDataWithByForm(TableName, ColumnTitleDesArray, TableDataInfo)
{
	var LIneDate;
	for( var Data_j = 0; Data_j < TableDataInfo.length - 1; Data_j++)
	{
		var LIneDate = TableDataInfo[Data_j];
		if( Data_j%2 == 0 )
		{
			var LineHtml = '<TR id="' + TableName + '_record_' + Data_j + '" class="tabal_01" onclick="selectLine(this.id);">';
		}
		else
		{
			var LineHtml = '<TR id="' + TableName + '_record_' + Data_j + '" class="tabal_02" onclick="selectLine(this.id);">';
		}

		for(var Title_j = 0; Title_j < ColumnTitleDesArray.length - 1; Title_j++)
		{
			var TitleAttrName = ColumnTitleDesArray[Title_j].ShowAttrName;
			var ShowFlag = ColumnTitleDesArray[Title_j].IsNotShowFlag;
			var TdMaxNum = ColumnTitleDesArray[Title_j].MaxNum;
			var Td_i_Class = (null == ColumnTitleDesArray[Title_j].TableClass ? "" : ColumnTitleDesArray[Title_j].TableClass);

			if(true == ShowFlag || "summary" == ShowFlag)
			{
				continue;
			}

			if("DomainBox" == TitleAttrName)
			{
				var onclickstr = GetCheckboxFuncString(TableName);
				LineHtml += '<TD class="' + Td_i_Class + '" ><input id = "' + TableName + '_rml'+ Data_j + '" type="checkbox" name="' + TableName + 'rml"'  + onclickstr + ' value="' + TableDataInfo[Data_j].domain + '"></TD>';
				continue;
			}

			var TdId = ' id="' + TableName + "_" + Data_j + "_" + Title_j + '" ';
			if("NumIndexBox" == TitleAttrName)
			{
				LineHtml += '<td class="' + Td_i_Class + '" ' + TdId + '>' + (Data_j+1) + '</td>';
				continue;
			}

			var ShowAttrValue = LIneDate[TitleAttrName];
			if (ShowAttrValue != null)
			{
				var InnerHtml = (TdMaxNum == "undefined") ? ShowAttrValue : GetStringContent(ShowAttrValue, TdMaxNum);
				if (ShowAttrValue === InnerHtml)
				{
					LineHtml += '<TD class="' + Td_i_Class + '" ' + TdId +'>' + InnerHtml + '</TD>';
				}
				else
				{
					LineHtml += '<TD class="' + Td_i_Class + '" title="' + ShowAttrValue + '"' + TdId +'>' + InnerHtml + '</TD>';
				}
			}
		}
		LineHtml+='</tr>';
		document.write(LineHtml);
	}
}

function stTableTileInfo(DesRef, TableClass, ShowAttrName, IsNotShowFlag, MaxNum)
{
	this.DesRef = DesRef;
	this.TableClass = TableClass;
	this.ShowAttrName = ShowAttrName;
	this.IsNotShowFlag = IsNotShowFlag;
	this.MaxNum = MaxNum;
}

function HWShowTableListByType(ShowDefault, TableName, TableType, ColumnNum, TableDataInfo, ColumnTitleDesArray,LaguageList, Callbackfunc)
{
	if(0 == ShowDefault)
	{
		return;
	}

	var WriteHeaderFunc = TableType == true ? writeTabCfgHeader : writeTabInfoHeader;
	WriteHeaderFunc(TableName + "_head", '100%', null, TableName + "_tbl");
	var LineRowDataNum = TableDataInfo.length - 1;
	var tablehtml = '<table width="100%" class="tabal_bg" id="' + TableName + '" cellspacing="1">';
	for(var Column_i = 0; Column_i < ColumnNum;  Column_i++)
	{
		if(0 == Column_i)
		{
			if('summary' == ColumnTitleDesArray[Column_i].IsNotShowFlag)
			{	
				var summaryid = TableName + "summary";
				var DataColumNum = ColumnNum - 1;
				var summaryinfo_Des_Id = ColumnTitleDesArray[Column_i].DesRef;
				var summaryinfo = (null == LaguageList[summaryinfo_Des_Id] || undefined == LaguageList[summaryinfo_Des_Id]) ? "" : LaguageList[summaryinfo_Des_Id];
				tablehtml += '<tr class="head_summary"><td colspan=' + DataColumNum + ' id="' + summaryid + '">' + summaryinfo + '</td></tr>';
				tablehtml += '<tr class="head_title">';
				continue;
			}
			else
			{	
				var DataColumNum = ColumnNum;
				tablehtml += '<tr class="head_title">';
			}
		}
		
		if(true == ColumnTitleDesArray[Column_i].IsNotShowFlag)
		{
			continue;
		}
		
		var headid = ' id="head' + TableName +  "_0_" + Column_i + '" ';
		var Column_i_Des = ColumnTitleDesArray[Column_i].DesRef;
		var Column_i_Class = (null == ColumnTitleDesArray[Column_i].TableClass ? "" : ColumnTitleDesArray[Column_i].TableClass);
		var Des = (null == LaguageList[Column_i_Des] || undefined == LaguageList[Column_i_Des]) ? "" : LaguageList[Column_i_Des];
		tablehtml += '<td class="' + Column_i_Class + '"' + headid + '>' + Des + '<\/td>';
	}

	tablehtml += '</tr>';
	document.write(tablehtml);

	if (LineRowDataNum == 0)
	{
		var firstroe = '<tr id="' + TableName + '_record_no"' + 'class="tabal_01" >';
		for(var Column_i = 0; Column_i < DataColumNum;  Column_i++)
		{
			if(true == ColumnTitleDesArray[Column_i].IsNotShowFlag)
			{
				continue;
			}

			var TdClass = (null == ColumnTitleDesArray[Column_i].TableClass ? "" : ColumnTitleDesArray[Column_i].TableClass);
			var headid = ' id="' + TableName +  "_0_" + Column_i + '" ';
			firstroe += '<td align="center" class="' + TdClass + '" ' + headid +  '>--</td>';
		}
		firstroe += '</tr>';
		document.write(firstroe);
	}
	else
	{
		FillTableDataWithByForm(TableName, ColumnTitleDesArray, TableDataInfo);
		if(Callbackfunc != null)
		{
			Callbackfunc(TableName, ColumnNum, TableDataInfo);
		}
	}

	document.write('</table>');
	writeTabTail();
}

function TextValueItem(_Text, _Value, _Title)
{
	this.Text = _Text;
	this.Value = _Value;
	this.Title = _Title;
}

function UserControlPaserDecorate(_UserControl, _LanguageList)
{
	this.ControlInfo = _UserControl;
	this.LanguageList = _LanguageList;

	this.Decorate = function()
	{
		this.ControlInfo.Description = this.LanguageList[this.ControlInfo.DescRef];
		this.ControlInfo.Remark = this.LanguageList[this.ControlInfo.RemarkRef];
		this.ControlInfo.ErrorMsg = this.LanguageList[this.ControlInfo.ErrorMsgRef];
		if (this.ControlInfo.TitleRef != "" && this.ControlInfo.TitleRef != null)
		{
			this.ControlInfo.Title = this.LanguageList[this.ControlInfo.TitleRef];
		}

		if (this.ControlInfo.InitValue == "Empty" || this.ControlInfo.InitValue == "")
		{
			this.ControlInfo.InitValueList = null;
		}
		else
		{
			if(this.ControlInfo.RealType == "TextOtherBox")
			{
				return;
			}

			this.ControlInfo.InitValueList = new Array();
			var InitValueDescList = eval(this.ControlInfo.InitValue);
			for (var i = 0; null != InitValueDescList && i < InitValueDescList.length; i++)
			{
				this.ControlInfo.InitValueList[i] = new TextValueItem(this.LanguageList[InitValueDescList[i].TextRef], InitValueDescList[i].Value, ((this.LanguageList[InitValueDescList[i].TitleRef] == undefined) ? this.LanguageList[InitValueDescList[i].TextRef]:this.LanguageList[InitValueDescList[i].TitleRef]));
			}
		}
	}
}

//onclick=aaaaa;onchange=bbbb;onmouseout=cccc;
function GetClickFuncStr(ClickEventInfo)
{
	var FuncStrArray = "";
	var FuncArrayLen = 0;
	try{
		FuncStrArray = ClickEventInfo.split(";");
	}
	catch(e)
	{
		var onchangeStr = "";
	}

	try{
		var onchangeStr = "";
		FuncArrayLen = FuncStrArray.length;
		for(var index = 0; index < FuncArrayLen; index++)
		{
			var SigStr = FuncStrArray[index];
			var EventStr = SigStr.split("=")[0];
			var FuncStr = SigStr.split("=")[1];
			onchangeStr += EventStr + ' = "' + FuncStr + '(this);" '
		}
	}
	catch(e)
	{
		var onchangeStr = "";
	}

	return onchangeStr;
}

function GetDisabledStr(flag)
{
	if(false == flag || null == flag || undefined == flag)
	{
		return "";
	}

	return ' disabled="disabled" ';
}

function GetDirClassStr(DirStr)
{
	if(null == DirStr || undefined == DirStr)
	{
		return "";
	}

	return ' dir="' + DirStr + '" ';
}

function GetTitleStr(title, Remark)
{
	this.Title = title;
	this.Remark = Remark;

	var RemarkInfo = (this.Remark == null || this.Remark == undefined) ? "" : this.Remark;

	if(null == title || undefined == title)
	{
		return "";
	}

	var titlestr= ((this.Title.length > 0) ? this.Title:RemarkInfo.replace("(","").replace(")",""));

	if("/" == titlestr || "-" == titlestr || "--" == titlestr)
	{
		return "";
	}

	return ' title="' + titlestr + '" ';
}

function GetElementClassStr(classstr, ElementType)
{	
	if(undefined != classstr && null != classstr)
	{
		var ResultStr = ' class="' + classstr + '" ';
		return ResultStr;
	}
	
	if("TextArea" == ElementType)
	{
		var ResultStr = ' class="TextArea" ';
	}
	else if("TextBox" == ElementType)
	{
		var ResultStr = ' class="TextBox" ';
	}
	else if("CheckBox" == ElementType)
	{
		var ResultStr = ' class="CheckBox" ';
	}
	else if("select" == ElementType)
	{
		var ResultStr = ' class="selectdefcss" ';
	}
	else if("InputButtonList" == ElementType)
	{
		var ResultStr = ' class="configbuttonlist" ';
	}
	
	return ResultStr;
}

function HWGetContrlStartEndString(ContrlType, StartEndFlag)
{
	if(ContrlType == "select")
	{
		if("Start" == StartEndFlag)
		{
			return '<select ';
		}
		else
		{
			return '></select>';
		}
	}
	else if(ContrlType == "div")
	{
		if("Start" == StartEndFlag)
		{
			return '<div ';
		}
		else
		{
			return '</div>';
		}
	}
	else if(ContrlType == "span")
	{
		if("Start" == StartEndFlag)
		{
			return '<span ';
		}
		else
		{
			return '</span>';
		}
	}
	else if(ContrlType == "textarea")
	{
		if("Start" == StartEndFlag)
		{
			return '<textarea ';
		}
		else
		{
			return '></textarea>';
		}
	}
	else
	{
		if("Start" == StartEndFlag)
		{
			return '<input ';
		}
		else
		{
			return '/>';
		}
	}
}

function stTableClass(left,right,dir,select)
{
	this.left = left;
	this.right = right;
	this.dir = dir;
	this.select = select;
}

function UserControlPaser(_Id, _RealType, _DescRef, _RemarkRef, _ErrorMsgRef, _Require, _BindField, _InitValue, _TitleRef, _ElementClass, _MaxLength, _ClickFuncApp, _disabled, _Class, _LanguageList)
{
	this.Id           = _Id;
	this.RealType     = _RealType;
	this.DescRef      = _DescRef;
	this.RemarkRef    = _RemarkRef;
	this.ErrorMsgRef  = _ErrorMsgRef;
	this.TitleRef     = _TitleRef;
	this.Require      = _Require;
	this.BindField    = _BindField;
	this.InitValue    = _InitValue;
	this.MaxLength    = _MaxLength;
	this.ClickFuncApp = _ClickFuncApp;
	this.LanguageList = _LanguageList;
	this.Description  = "";
	this.ErrorMsg     = "";
	this.Remark       = "";
	this.Title        = "";
	this.InitValueList= null;
	this.disabled     = _disabled;
	this.ElementClass = _ElementClass;

	if(null != _Class)
	{
		this.Leftwidth   = _Class["left"];
		this.rightwidth   = _Class["right"];
		this.dir = _Class["dir"];
		this.select = _Class["select"];
	}
	else
	{
		this.Leftwidth   = "";
		this.rightwidth   = "";
		this.dir = "";
		this.select = "";
	}

	var DisabledStr = GetDisabledStr(this.disabled);
	this.OuterHTML = function()
	{
		var style =  (this.Id.toUpperCase().indexOf("DEFHIDE") >= 0) ? "display:none;" : " ";
		var StyleStr = style == " " ? ' ' : 'style="' + style + '"';
		if (this.RealType == "HorizonBar")
		{
			return this["Build"+this.RealType]();
		}
		else if(this.RealType == "HtmlText")
		{
			var html = '<tr border=1 id="' + this.Id + 'Row" ' + StyleStr + '>';
			html += '<td class="table_title ' + this.Leftwidth + '" id="' + this.Id  + 'Colleft">' + this.Description + '</td>';
			html += '<td id="' +  this.Id + '" BindField="' + this.BindField + '" RealType="' + this.RealType +  '" class="table_right ' + this.rightwidth + '">';
			html += this["Build"+this.RealType]();
			html += '</td></tr>';
			return html;
		}
		else if(this.RealType == "None")
		{
			return "";
		}
		else
		{
			var html = '<tr border=1 id="' + this.Id + 'Row" ' + StyleStr + '>';
			html += '<td class="table_title ' + this.Leftwidth + '" id="' + this.Id  +'Colleft">' + this.Description + '</td>';
			html += '<td id="' +  this.Id + 'Col" class="table_right ' + this.rightwidth + '">';
			html += this["Build"+this.RealType]();
			html += '</td></tr>';
			return html;
		}
	}

	this.BuildTextArea = function()
	{
		var RequireContent = this.Require.toUpperCase() == "TRUE" ? "*":"";
		var type = (this.Id.toUpperCase().indexOf("PASSWORD") >= 0) ? "password" : "text";
		var classstr = GetElementClassStr(this.ElementClass, "TextArea");
		var RemarkInfo = (this.Remark == null || this.Remark == undefined) ? "" : this.Remark;
		
		return '<textarea id="' + this.Id + '" type="' + type + '"  maxlength="' + this.MaxLength + '" title="' + ((this.Title.length > 0) ? this.Title:RemarkInfo.replace("(","").replace(")","")) + '"' + classstr +  'maxlength="' + this.MaxLength + '" RealType="' + this.RealType + '" BindField="' + this.BindField + '" ' + DisabledStr + '></textarea><font color="red">' + RequireContent + '</font><span class="gray" id="' + this.Id +'Remark">'+RemarkInfo+'</span>';
	}

	this.BuildTextBox = function()
	{
		var RequireContent = this.Require.toUpperCase() == "TRUE" ? "*":"";
		var type = (this.Id.toUpperCase().indexOf("PASSWORD") >= 0) ? "password" : "text";
		var onclickStr = GetClickFuncStr(this.ClickFuncApp);
		var RemarkInfo = (this.Remark == null || this.Remark == undefined) ? "" : this.Remark;
		var classstr = GetElementClassStr(this.ElementClass, "TextBox");
		
		return '<input id="'+this.Id+'" type="'+type+'" title="'+((this.Title.length > 0) ? this.Title:RemarkInfo.replace("(","").replace(")",""))+'"' + classstr + ' maxlength="'+this.MaxLength+'" RealType="'+this.RealType+'" BindField="'+this.BindField+'"' + DisabledStr + onclickStr + '/><font color="red">'+RequireContent+'</font><span class="gray" id="'+this.Id+'Remark">'+RemarkInfo+'</span>';
	}

	this.BuildCheckBox = function()
	{
		var RequireContent = this.Require.toUpperCase() == "TRUE" ? "*":"";
		var onclickStr = GetClickFuncStr(this.ClickFuncApp);
		var RemarkInfo = (this.Remark == null || this.Remark == undefined) ? "" : this.Remark;
		var classstr = GetElementClassStr(this.ElementClass, "CheckBox");
		var spanid = ' id="' + this.Id + 'span" ';

		return '<input id="' + this.Id +'" type=\"checkbox\"  RealType=\"' + this.RealType + '"' + classstr + ' BindField=\"' + this.BindField + '"' + DisabledStr + onclickStr + '/><font color=\"red\">' + RequireContent + '</font><span class="gray"' + spanid +  '>' + RemarkInfo+'</span>';
	}
	
	this.BuildCheckDivBox = function()
	{
		var otherInfo = eval(this.InitValue);
		HWConsoleLog(otherInfo);
		var RequireContent = this.Require.toUpperCase() == "TRUE" ? "*":"";
		var onclickStr = GetClickFuncStr(this.ClickFuncApp);
		var RemarkInfo = (this.Remark == null || this.Remark == undefined) ? "" : this.Remark;
		var classstr = GetElementClassStr(this.ElementClass, "CheckDivBox");
		
		var html = '<input id="' + this.Id +'" type=\"checkbox\"  RealType=\"' + this.RealType + '"' + classstr + ' BindField=\"' + this.BindField + '"' +  onclickStr + '/><font color=\"red\"' + DisabledStr + '>' +RequireContent+'</font><span class=\"gray\">'+RemarkInfo+'</span>';
		
		var otherhtml = "";
		for(var otherindex = 0; null != otherInfo && otherindex < otherInfo.length; otherindex++)
		{
			var ItemInfo = otherInfo[otherindex].Item;
			otherhtml += '<div ';
			for(var i = 0;  null != ItemInfo && i < ItemInfo.length; i++)
			{
				var ValueId = ItemInfo[i].AttrValue;
				var value = (this.LanguageList[ValueId] == null ||  this.LanguageList[ValueId] == undefined) ? ValueId : this.LanguageList[ValueId];
				otherhtml += ItemInfo[i].AttrName + '="' +  value + '" ';
			}
			otherhtml += '/>';
		}
		return html + otherhtml;
	}
	
	this.BuildDropDownList = function()
	{
		var RequireContent = this.Require.toUpperCase() == "TRUE" ? "*":"";
		var onchangeStr = GetClickFuncStr(this.ClickFuncApp);
		var classselect = (this.select == null || this.select == "undefined") ? this.ElementClass : this.select;
		var classstr = GetElementClassStr(classselect, "select");
		
		this.Remark = (this.Remark == null || this.Remark == undefined) ? "" : this.Remark;
		var spanid = ' id="' + this.Id + 'span" ';
		var selectspanremark = '<span class="gray"' + spanid + '>' + this.Remark+'</span>';
		
		var html = '<select id="' +this.Id + '" ' + classstr + ' RealType="DropDownList"  BindField="'  +this.BindField + '"' + onchangeStr + DisabledStr +'>';

		for (var i = 0; (this.InitValueList != null && i < this.InitValueList.length); i++)
		{
			var tid = parseInt(i+1).toString();
			html += "<option id=\""+tid+"\" value=\""+this.InitValueList[i].Value+"\">"+this.InitValueList[i].Text+"<\/option>";
		}

		html += "</select>" + selectspanremark;
		return html;
	}

	this.BuildRadioButtonList = function()
	{
		var RequireContent = this.Require.toUpperCase() == "TRUE" ? "*":"";
		var html = "";

		for (var i = 0; (this.InitValueList != null && i < this.InitValueList.length); i++)
		{
			var tid = parseInt(i+1).toString();
			var DirStr = GetDirClassStr(this.dir);
			var onclickStr = GetClickFuncStr(this.ClickFuncApp);
			this.Remark = (this.Remark == null || this.Remark == undefined) ? "" : this.Remark;

			html += '<span ' + DirStr + ' id=\"Div'+this.Id+tid+'\" title=\"'+this.InitValueList[i].Title+'\"  style=\"width:10pt\"><input name=\"'+this.Id+'\" id=\"'+this.Id+tid+'\" type=\"radio\" title=\"'+this.InitValueList[i].Title+'\" value=\"'+this.InitValueList[i].Value+'\"  RealType=\"'+this.RealType+'\" BindField=\"'+this.BindField+'\"' +  onclickStr + '/>'+this.InitValueList[i].Text+'<font color=\"red\">'+RequireContent+'</font><span class=\"gray\">'+this.Remark+'<\/span><\/span>  ';
		}

		return html;
	}

	this.BuildCheckBoxList = function()
	{
		var RequireContent = this.Require.toUpperCase() == "TRUE" ? "*":"";
		var html = "";
		var classstr = GetElementClassStr(this.ElementClass, "CheckBox");
		
		if(this.InitValueList != null)
		{
			var InitValueListLength = this.InitValueList.length;
		}
		var DirStr = GetDirClassStr(this.dir);
		for (var i = 0; i < InitValueListLength; i++)
		{
			this.Remark = (this.Remark == null || this.Remark == undefined) ? "" : this.Remark;
			var tid = parseInt(i+1).toString();
			html += "<span " + DirStr + "id=\"Div"+this.Id+tid+"\" style=\"width:10pt\"><input " + classstr +" name=\""+this.Id+"\" id=\""+this.Id+tid+"\" type=\"checkbox\" value=\""+this.InitValueList[i].Value+"\"  RealType=\""+this.RealType+"\" BindField=\""+this.BindField+"\"/>"+this.InitValueList[i].Text+"<font color=\"red\">"+RequireContent+"</font><span class=\"gray\">"+this.Remark+"</span><\/span>  ";

			if(InitValueListLength > 9 && i == 7)
			{
				 html +=  "<br>";
			}
		}
		return html;
	}

	this.BuildInputButtonList = function()
	{
		var RequireContent = this.Require.toUpperCase() == "TRUE" ? "*":"";
		var html = "";
		var classstr = GetElementClassStr(this.ElementClass, "InputButtonList");
		for (var i = 0; (this.InitValueList != null && i < this.InitValueList.length); i++)
		{
			this.Remark = (this.Remark == null || this.Remark == undefined) ? "" : this.Remark;
			var tid = parseInt(i+1).toString();

			html += "<span  id=\"Div"+this.Id+tid+"\" style=\"width:10pt\"><input name=\""+this.Id+"\" id=\""+this.Id+tid+"\" type=\"button\" value=\""+this.InitValueList[i].Value+"\""+ classstr +  " RealType=\""+this.RealType+"\" BindField=\""+this.BindField+"\" onclick=\"OnConnectionButton(this);\"/>"+this.InitValueList[i].Text+"<font color=\"red\">"+RequireContent+"</font><span class=\"gray\">"+this.Remark+"</span><\/span> ";
		}
		return html;
	}

	this.BuildHorizonBar = function()
	{
		var html = "";
		html += "<tr class=\"head_title\" id=\""+this.Id+"Row\">";
		html += "<td class=\"block_title\" colspan=\"2\" id=\""+this.Id+"\" RealType=\""+this.RealType+"\" BindField=\""+this.BindField+"\">"+this.Description+"<\/td>";
		html += "<\/tr>";

		return html;
	}

	this.BuildHtmlText = function()
	{
		return "";
	}

	this.BuildNone = function()
	{
		return "";
	}

	this.BuildTextOtherBox = function()
	{
		var RequireContent = this.Require.toUpperCase() == "TRUE" ? "*":"";
		var type = (this.Id.toUpperCase().indexOf("PASSWORD") >= 0) ? "password" : "text";
		var RemarkInfo = (this.Remark == null || this.Remark == undefined) ? "" : this.Remark;
		var onclickStr = GetClickFuncStr(this.ClickFuncApp);
		var Titlestr = GetTitleStr(this.Title, this.Remark);
		var classstr = GetElementClassStr(this.ElementClass, "TextBox");
		var html =  "<input id=\""+this.Id+"\" type=\""+type+"\"" + Titlestr + classstr + " maxlength=\""+this.MaxLength+"\" RealType=\""+this.RealType+"\" BindField=\""+this.BindField+"\"" + onclickStr + DisabledStr + "/><font color=\"red\">" +RequireContent+"</font><span class=\"gray\" id=\""+this.Id+"Remark\">"+RemarkInfo+"</span>";

		var otherhtml = "";
		if(this.InitValue != null && this.InitValue != "Empty")
		{
			var otherInfo = eval(this.InitValue);
			var EndStr="";
			for(var otherindex = 0; null != otherInfo && otherindex < otherInfo.length; otherindex++)
			{
				var ItemType = otherInfo[otherindex].Type;
				var ItemInfo = otherInfo[otherindex].Item;
				
				otherhtml += HWGetContrlStartEndString(ItemType, "Start");
				EndStr = HWGetContrlStartEndString(ItemType, "End");
				
				var innerhtml = "";
				for(var i = 0;  null != ItemInfo && i < ItemInfo.length; i++)
				{
					var ValueId = ItemInfo[i].AttrValue;
					var value = (this.LanguageList[ValueId] == null ||  this.LanguageList[ValueId] == undefined) ? ValueId : this.LanguageList[ValueId];
					otherhtml += ItemInfo[i].AttrName + '="' +  value + '" ';
					if("innerhtml" == ItemInfo[i].AttrName)
					{
						innerhtml = (this.LanguageList[ValueId] == null ||  this.LanguageList[ValueId] == undefined) ? ValueId : this.LanguageList[ValueId];
					}
					
				}
				if(ItemType == "div" || ItemType == "span")
				{
					otherhtml += '>' + innerhtml + EndStr;
				}
				else
				{
					otherhtml += EndStr;
				}
			}
		}
		return html + otherhtml;
	}

	this.BuildSmartBoxList = function()
	{
		var RequireContent = this.Require.toUpperCase() == "TRUE" ? "*":"";
		var type = (this.Id.toUpperCase().indexOf("PASSWORD") >= 0) ? "password" : "text";
		var RemarkInfo = (this.Remark == null || this.Remark == undefined) ? "" : this.Remark;
		var onclickStr = GetClickFuncStr(this.ClickFuncApp);
		var Titlestr = GetTitleStr(this.Title, this.Remark);
		var classstr = GetElementClassStr(this.ElementClass, "TextBox");
		
		var baseType = this.Id.split('_')[1];
		var baseTypeId = this.Id.split('_')[0];
		
		var BaseStart = HWGetContrlStartEndString(baseType, "Start");
		var BaseEndStr = HWGetContrlStartEndString(baseType, "End");
		
		var html =  BaseStart + "id=\""+baseTypeId+"\" type=\""+type+"\"" + Titlestr + classstr + " maxlength=\""+this.MaxLength+"\" RealType=\""+this.RealType+"\" BindField=\""+this.BindField+"\"" + onclickStr + DisabledStr + BaseEndStr + "<font color=\"red\">" +RequireContent+"</font><span class=\"gray\" id=\""+this.Id+"Remark\">"+RemarkInfo+"</span>";

		var otherhtml = "";
		if(this.InitValue != null && this.InitValue != "Empty")
		{
			var otherInfo = eval(this.InitValue);
			var EndStr="";
			for(var otherindex = 0; null != otherInfo && otherindex < otherInfo.length; otherindex++)
			{
				var ItemType = otherInfo[otherindex].Type;
				var ItemInfo = otherInfo[otherindex].Item;
				
				otherhtml += HWGetContrlStartEndString(ItemType, "Start");
				EndStr = HWGetContrlStartEndString(ItemType, "End");
				
				var innerhtml = "";
				for(var i = 0;  null != ItemInfo && i < ItemInfo.length; i++)
				{
					var ValueId = ItemInfo[i].AttrValue;
					var value = (this.LanguageList[ValueId] == null ||  this.LanguageList[ValueId] == undefined) ? ValueId : this.LanguageList[ValueId];
					otherhtml += ItemInfo[i].AttrName + '="' +  value + '" ';
					if("innerhtml" == ItemInfo[i].AttrName)
					{
						innerhtml = (this.LanguageList[ValueId] == null ||  this.LanguageList[ValueId] == undefined) ? ValueId : this.LanguageList[ValueId];
					}
					
				}
				if(ItemType == "div" || ItemType == "span")
				{
					otherhtml += '>' + innerhtml + EndStr;
				}
				else
				{
					otherhtml += EndStr;
				}
			}
		}
		return html + otherhtml;
	}


	this.BuildTextDivbox = function()
	{
		var otherInfo = eval(this.InitValue);
		HWConsoleLog(otherInfo);
		var RequireContent = this.Require.toUpperCase() == "TRUE" ? "*":"";
		var type = (this.Id.toUpperCase().indexOf("PASSWORD") >= 0) ? "password" : "text";
		var RemarkInfo = (this.Remark == null || this.Remark == undefined) ? "" : this.Remark;
		var html =  "<input id=\""+this.Id+"\" type=\""+type+"\" title=\""+((this.Title.length > 0) ? this.Title:RemarkInfo.replace("(","").replace(")",""))+"\" class=\"TextBox\" maxlength=\""+this.MaxLength+"\" RealType=\""+this.RealType+"\" BindField=\""+this.BindField+"\"" + DisabledStr + "/><font color=\"red\">"+RequireContent+"</font><span class=\"gray\" id=\""+this.Id+"Remark\">"+RemarkInfo+"</span>";

		var otherhtml = "";
		for(var otherindex = 0; null != otherInfo && otherindex < otherInfo.length; otherindex++)
		{
			var ItemInfo = otherInfo[otherindex].Item;
			otherhtml += '<div ';
			for(var i = 0;  null != ItemInfo && i < ItemInfo.length; i++)
			{
				var ValueId = ItemInfo[i].AttrValue;
				var value = (this.LanguageList[ValueId] == null ||  this.LanguageList[ValueId] == undefined) ? ValueId : this.LanguageList[ValueId];
				otherhtml += ItemInfo[i].AttrName + '="' +  value + '" ';
			}
			otherhtml += '/>';
		}
		return html + otherhtml;
	}
}

function HWGetLiIdListByForm(FormId, ReloadArray)
{
	var ElementIdList = new Array();
	var FormObj = getElement(FormId);
	var ElementList = FormObj.getElementsByTagName("li");
	var ElementLength = ElementList.length;
	var j = 0;
	for (var i = 0; i < ElementLength; i++)
	{
		var TmpId = ElementList[i].id;
		var ReloadElement = HWGetReloadElementById(TmpId, ReloadArray);
		if(null != ReloadElement && 0 == ReloadElement.display)
		{
			continue;
		}

		ElementIdList[j] = TmpId;
		j++;
	}

	return ElementIdList;
}

function HWGetReloadElementById(id,ReloadInfo)
{
	this.id = id;

	if(null == ReloadInfo)
	{
		return null;
	}

	var length = ReloadInfo.length;
	for(var index = 0; (index < length && null != ReloadInfo[index]); index++)
	{
		var ReloadElement = ReloadInfo[index];
		if(this.id == ReloadElement.ReloadId)
		{
			return ReloadElement.ReloadValue[0];
		}
	}
	return null;
}

function HWGetAttribute(Obj,AttName)
{
	if(null == Obj || undefined == Obj)
	return null;

	try{
		return Obj.getAttribute(AttName);
	}catch(e){return null;}
}

function HWParsePageControlByID(FormId, TableClass, LanguageList,ReloadInfo)
{
	var ElementIdList = new Array();
	var FormObj = getElement(FormId);
	var ElementList = FormObj.getElementsByTagName("li");

	var ElementLength = ElementList.length;
	for (var i = 0; i < ElementLength; i++)
	{
		ElementIdList[i] = ElementList[i].id;
	}

	var table = "Table" + FormId;
	var tableStart = CreateTableStartString(table);
	document.write(tableStart);
	var HasStartHorizonBar = false;
	for (var i = 0; i < ElementLength; i++)
	{
		var Element = document.getElementById(ElementIdList[i]);
		var RealType = HWGetAttribute(Element, "RealType");
		var disabled = HWGetAttribute(Element, "disabled");
		var DescRef = HWGetAttribute(Element, "DescRef");
		var RemarkRef = HWGetAttribute(Element, "RemarkRef");
		var ErrorMsgRef = HWGetAttribute(Element, "ErrorMsgRef");
		var Require = HWGetAttribute(Element, "Require");
		var BindField = HWGetAttribute(Element, "BindField");
		var InitValue = HWGetAttribute(Element, "InitValue");
		var TitleRef = HWGetAttribute(Element, "TitleRef");
		var ElementClass = HWGetAttribute(Element, "Elementclass");
		var MaxLength = HWGetAttribute(Element, "MaxLength");
		var ClickFuncApp = HWGetAttribute(Element, "ClickFuncApp");

		var ReloadElement = HWGetReloadElementById(Element.id, ReloadInfo);
		if(null != ReloadElement)
		{
			if( null != ReloadElement.display && 0 == ReloadElement.display )
			{
				RealType = "None";
			}

			disabled = (undefined !== ReloadElement.disabled) ? ReloadElement.disabled : null;
			DescRef = (undefined !== ReloadElement.DescRef) ? ReloadElement.DescRef : DescRef;
			RemarkRef = (undefined !== ReloadElement.RemarkRef) ? ReloadElement.RemarkRef : RemarkRef;
			ErrorMsgRef = (undefined !== ReloadElement.ErrorMsgRef) ? ReloadElement.ErrorMsgRef : ErrorMsgRef;
			Require = (undefined !== ReloadElement.Require) ? ReloadElement.Require : Require;
			BindField = (undefined !== ReloadElement.BindField) ? ReloadElement.BindField : BindField;
			InitValue = (undefined !== ReloadElement.InitValue) ? ReloadElement.InitValue : InitValue;
			TitleRef = (undefined !== ReloadElement.TitleRef) ? ReloadElement.TitleRef : TitleRef;
			ElementClass = (undefined !== ReloadElement.ElementClass) ? ReloadElement.ElementClass : ElementClass;
			MaxLength = (undefined !== ReloadElement.MaxLength) ? ReloadElement.MaxLength : MaxLength;
			ClickFuncApp = (undefined !== ReloadElement.ClickFuncApp) ? ReloadElement.ClickFuncApp : ClickFuncApp;
		}

		var ControlInfo = new UserControlPaser(
			Element.id, RealType, DescRef, RemarkRef, ErrorMsgRef, Require, BindField,
			InitValue, TitleRef, ElementClass, MaxLength, ClickFuncApp, disabled, TableClass, LanguageList);

		HWConsoleLog(ControlInfo);
		var Decorate = new UserControlPaserDecorate(ControlInfo, LanguageList);
		Decorate.Decorate();

		var t = ControlInfo.OuterHTML();
		if (ControlInfo.RealType == "HorizonBar")
		{
			if (HasStartHorizonBar == true)
			{
				document.write("<\/tbody>");
			}
			HasStartHorizonBar = true;
			document.write("<tbody id=\""+ControlInfo.Id+"Panel\">");
		}

		Element.outerHTML = "";
		document.write(t);
		if (i == ElementLength-1)
		{
			document.write("<\/tbody>");
		}
	}
	document.write("</table></div>")
}

function HWcloneObject( SrcObj, CloneFlag )
{
	if ( SrcObj === null || SrcObj === undefined || typeof ( SrcObj ) !== 'object' )
	{
		return SrcObj;
	}

	var deep = !!CloneFlag;

	var cloned;

	if ( SrcObj.constructor === Array )
	{
		if ( deep === false )
		{
			return SrcObj;
		}

		cloned = [];

		for ( var i in SrcObj )
		{
			cloned.push( HWcloneObject( SrcObj[i], deep ) );
		}

		return cloned;
	}

	cloned = {};

	for ( var i in SrcObj )
	{
		cloned[i] = deep ? HWcloneObject( SrcObj[i], true ) : SrcObj[i];
	}

	return cloned;
}

function stFormParaNameValueArray(Name, Value)
{
	this.Name = Name;
	this.Value = Value;
}

function stSpecParaArray(Name, Value, ForceAddFlag)
{
	this.Name = Name;
	this.Value = Value;
	this.ForceAddFlag = ForceAddFlag;
}

function UserControlValueSetterByLiId(_ControlId,_DataSource)
{
	this.Id = _ControlId;
	this.DataSource = _DataSource;
	this.Control = document.getElementById(this.Id);
	if (null == this.Control)
	{
		this.Control = document.getElementById(this.Id+"1");
		if(null == this.Control)
		{
			return;
		}
	}
	this.RealType = this.Control.getAttribute("RealType");
	this.BindField = this.Control.getAttribute("BindField");
	var DataId = this.RealType == "HtmlText" ? this.BindField : this.BindField.split('.')[1];

	try{
		this.Value = this.DataSource[DataId];
	}catch(e){
		this.Value = "";
	}

	if(null == this.Value || "undefined" == this.Value)
	{
		this.Value = "";
	}


	this.SetValue = function()
	{
		this["set"+this.RealType]();
	}

	this.setTextArea = function()
	{
		setText(this.Id, this.Value);
	}
	this.setTextBox = function()
	{
		setText(this.Id, this.Value);
	}
	this.setCheckBox = function()
	{
		setCheck(this.Id, this.Value);
	}
	this.setDropDownList = function()
	{
		setSelect(this.Id, this.Value);
	}
	this.setRadioButtonList = function()
	{
		setRadio(this.Id, this.Value);
	}

	this.setCheckBoxList = function()
	{
		var li = document.getElementsByName(this.Id);
		for (var i = 0; i < li.length; i++)
		{
			li[i].checked = false;
			for (var j = 0; j < this.Value.length; j++)
			{
				if (li[i].value == this.Value[j])
				{
					li[i].checked = true;
					break;
				}
			}
		}
	}

	this.setHorizonBar = function()
	{

	}
	this.setInputButtonList = function()
	{

	}
	
	this.setSmartBoxList = function()
	{

	}

	this.setHtmlText = function()
	{
		document.getElementById(this.Id).innerHTML = this.Value;
	}

	this.setTextOtherBox = function()
	{
		var TextType = this.Id.split("_")[0];
		if(TextType == "select")
		{
			setSelect(this.Id, this.Value);
		}
		else if(TextType == "div" || TextType == "span")
		{
			document.getElementById(this.Id).innerHTML = this.Value;
		}
		else if(TextType == "checkbox")
		{
			 setCheck(this.Id, this.Value);
		}
		else if(TextType == "radio")
		{
			setRadio(this.Id, this.Value);
		}
		else
		{
			setText(this.Id, this.Value);
		}
	}

	this.setTextDivbox = function()
	{
		setText(this.Id, this.Value);
	}
}

function HWSetTableByLiIdList(LiIdList,DataArray, SpecFunction)
{
	this.LiIdList = LiIdList;
	this.DataArray = DataArray;
	for (var i = 0; i < LiIdList.length; i++)
	{
		var Id = LiIdList[i];
		try{
			this.Control = document.getElementById(Id);
			if(null == this.Control)
			{
				this.Control = document.getElementById(Id+"1");
			}
			this.BindField = this.Control.getAttribute("BindField");
			if(this.BindField == "" || this.BindField == "Empty")
			{
				continue;
			}

			HWConsoleLog(this.DataArray);
			var Setter = new UserControlValueSetterByLiId(Id, this.DataArray);

			Setter.SetValue();
		}
		catch(e)
		{ continue;}
	}

	if(null != SpecFunction)
	{
		SpecFunction(this.DataArray);
	}
}

function UserControlValueGetParaByBindField(FormLiIdList, BindField)
{
	var ElementLength = FormLiIdList.length;
	this.Id = 'Empty';
	for (var i = 0; i < ElementLength; i++)
	{
		var ElementId = FormLiIdList[i];
		var ElementInfo = document.getElementById(ElementId);
		if(null == ElementInfo)
		{
			ElementInfo = document.getElementById(ElementId+"1");
			if(null == ElementInfo)
			{
				continue;
			}
		}

		var ParaName = ElementInfo.getAttribute("BindField");

		if(ParaName == BindField)
		{
			this.Id = ElementId;
			break;
		}
	}

	if("Empty" == this.Id)
	{
		return null;
	}

	this.GetBindFieldValue = function()
	{
		var CurrentControl = document.getElementById(this.Id);
		if (CurrentControl == null)
		{
			CurrentControl = document.getElementsByName(this.Id)[0];
		}
		var RealType = CurrentControl.getAttribute("RealType");
		if (RealType == "HorizonBar")
		{
			return "";
		}

		return this["get"+RealType]();
	}

	this.getTextBox = function()
	{
		return getValue(this.Id);
	}
	this.getSmartBoxList = function()
	{
		return "";	
	}
	this.getTextOtherBox = function()
	{
		var TextType = this.Id.split("_")[0];
		if(TextType == "select")
		{
			return getSelectVal(this.Id);
		}
		else if(TextType == "div" || TextType == "span")
		{
			;
		}
		else if(TextType == "checkbox")
		{
			 return getCheckVal(this.Id);
		}
		else if(TextType == "radio")
		{
			return getRadioVal(this.Id);
		}
		else
		{
			return getValue(this.Id);
		}
	}
	this.getTextDivbox = function()
	{
		return getValue(this.Id);
	}
	this.getTextArea = function()
	{
		return getValue(this.Id);
	}
	this.getCheckBox = function()
	{
		return getCheckVal(this.Id);
	}
	this.getDropDownList = function()
	{
		return getSelectVal(this.Id);
	}
	this.getRadioButtonList = function()
	{
		return getRadioVal(this.Id);
	}
	this.getCheckBoxList = function()
	{
		var li = document.getElementsByName(this.Id);
		var rev = new Array();
		for (var i = 0; i < li.length; i++)
		{
			if (li[i].checked)
			{
				rev[i] = li[i].value;
			}
		}
		return rev;
	}
}


function GetParaValueArrayByFormId(FormLiIdList)
{
	var ElementLength = FormLiIdList.length;
	var ParaListArray = [];
	for (var i = 0; i < ElementLength; i++)
	{
		var ElementId = FormLiIdList[i];
		var ElementInfo = document.getElementById(ElementId);
		if(null == ElementInfo)
		{
			ElementInfo = document.getElementById(ElementId+"1");
			if(null == ElementInfo)
			{
				continue;
			}
		}
		var ParaName = ElementInfo.getAttribute("BindField");
		var RealType = ElementInfo.getAttribute("RealType");
		if(-1 == ParaName.indexOf(".") || RealType == "HtmlText")
		{
			continue;
		}

		var Picker = new UserControlValueGetParaByBindField(FormLiIdList, ParaName);
		if(null == Picker)
		{
			continue;
		}

		var BaseIndex = ParaName.split(".")[1];
		var ParaValue = Picker.GetBindFieldValue();
		ParaListArray[BaseIndex] = ParaValue;
	}

	return ParaListArray;
}

function GetTrDisplayInfo(TdId)
{
	var TrId = TdId + "Row";
	try{
		var Obj = document.getElementById(TrId);
		var ParentObj = document.getElementById(TrId).parentNode;
		if("none" == Obj.style.display || "none" == ParentObj.style.display)
		{
			return "none";
		}
	}catch(e){return null}
	return null;
}

function GetParaNameValueArrayByFormId(FormLiIdList, BaseData)
{
    	var ElementLength = FormLiIdList.length;
	var ParaListArray = new Array();
    	for (var i = 0; i < ElementLength; i++)
    	{
	   	var ElementId = FormLiIdList[i];
		var ElementInfo = document.getElementById(ElementId);
		if(null == ElementInfo)
		{
			ElementInfo = document.getElementById(ElementId+"1");
			if(null == ElementInfo)
			{
				continue;
			}
		}

		var ParaName = ElementInfo.getAttribute("BindField");
		var RealType = ElementInfo.getAttribute("RealType");
		var DisplayInfo = GetTrDisplayInfo(ElementId);

		if(ParaName == "" || ParaName == "Empty" || ParaName == "DomainBox" || DisplayInfo == "none")
		{
			continue;
		}

		if(RealType == "HtmlText")
		{
			continue;
		}

		var Picker = new UserControlValueGetParaByBindField(FormLiIdList, ParaName);
		if(null == Picker)
		{
			continue;
		}

		var ParaValue = Picker.GetBindFieldValue();
		if(null != BaseData)
		{
			try{
				var BaseIndex = ParaName.split(".")[1];
				var BaseValue = BaseData[BaseIndex];
				if(undefined != BaseValue && BaseValue == ParaValue)
				{
					continue;
				}
			}catch(e){}
		}

		var ParaPair = new stFormParaNameValueArray(ParaName, ParaValue);
		ParaListArray.push(ParaPair);

    	}

	return ParaListArray;
}

function DeleteUnchangeData(NewArray, BaseArray)
{
	var ResultArray = {};
	if(null == BaseArray)
	{
		return  NewArray;
	}

	return  NewArray;
}

function FormatUrlEncode(val)
{
	if(null != val)
	{
		var formatstr = escape(val);
		formatstr=formatstr.replace(new RegExp(/(\+)/g),"%2B");
		formatstr = formatstr.replace(new RegExp(/(\/)/g), "%2F");
		return formatstr
	}
	return null;
}

/*
SpecList.ForceAddFlag,
0:取spec.value 覆盖lilist，添加到body;（不改变属性名，更新属性值）
1.取spec.Name，添加到参数列表，若spec.value为空则取lilist中与spec.name后缀相同的属性填充,但是删除原有list中同名的属性；（强制添加参数对，并删除原有同名参数对）
2:强制从lilist中删除属性名称为spec.Name的参数，使其不添加到body;（强制删除同名参数对）
3:覆盖变更存在的参数对，不存在则忽略;
4:取spec.Name，添加到参数列表，若spec.value为空则取lilist中与spec.name后缀相同的属性填充；（强制添加）
*/
function HWAddParameterByFormId(SubmitForm, FormLiIdList, ParaList, OldValueList,UnUseForm)
{
	var SubmitType = SubmitForm == null ? 0 : 1 ;
	var SpecParaList = ParaList;

	if(true != UnUseForm)
	{
		var ParaListArray = GetParaNameValueArrayByFormId(FormLiIdList, OldValueList);
		var ArrayLengthTmp = ParaListArray.length;
		if(0 == ArrayLengthTmp)
		{
			ParaListArray = ParaList;
			SpecParaList = null;
		}
	}
	else
	{
		ParaListArray = ParaList;
		SpecParaList = null;
	}

	var ArrayLengthTmp = ParaListArray.length;
	if(0 == ArrayLengthTmp)
	{
		return null;
	}

	for(var index = 0; index < ArrayLengthTmp; index++)
	{
		var testtmp = ParaListArray[index];
		if(undefined == testtmp.ForceAddFlag)
		{
			continue;
		}

		var ForceFlag = parseInt(testtmp.ForceAddFlag,10);
		if(2 == ForceFlag || 3 == ForceFlag)
		{
			testtmp.Name="";
			testtmp.Value="";
		}
	}

	var ParaType = SpecParaList == null ? 1 : 0 ;

	if(0 == ParaType)
	{
		var ParaListLength = SpecParaList.length;
		for(var i = 0; i < ParaListLength; i++)
		{
			var SpecList = SpecParaList[i];
			if(SpecList.Name == "" || SpecList.Name == "null")
			{
				continue;
			}

			var SpecName = SpecList.Name.split(".")[1];
			var ForceFlag = parseInt(SpecList.ForceAddFlag,10);
			if(1 == ForceFlag)
			{
				var Flag = 0;
				var Addvalue = "";
				for(var j = 0; j < ArrayLengthTmp; j++)
				{
					var ParaArray = ParaListArray[j];
					if(ParaArray.Name == "")
					{
						continue;
					}

					var BaseName = ParaArray.Name.split(".")[1];
					if(SpecName == BaseName)
					{
						Addvalue = SpecList.Value == null ? ParaArray.Value : SpecList.Value;
						Flag = 1;
						ParaArray.Name="";
						ParaArray.Value="";
						break;
					}
				}

				if(0 == Flag)
				{
					Addvalue = SpecList.Value;
				}

				var ParaPair = new stFormParaNameValueArray(SpecList.Name, Addvalue);
				ParaListArray.push(ParaPair);
			}
			else if(2 == ForceFlag)
			{
				for(var j = 0; j < ArrayLengthTmp; j++)
				{
					var ParaArray = ParaListArray[j];
					if(ParaArray.Name == "")
					{
						continue;
					}

					/* 删除时全匹配 */
					if(SpecList.Name == ParaArray.Name)
					{
						/* set null to delete */
						ParaArray.Name="";
						break;
					}
				}
			}
			else if(3 == ForceFlag)
			{
				for(var j = 0; j < ArrayLengthTmp; j++)
				{
					var ParaArray = ParaListArray[j];
					if(ParaArray.Name == "")
					{
						continue;
					}

					var BaseName = ParaArray.Name.split(".")[1];
					if(SpecName == BaseName)
					{
						ParaArray.Name="";
						ParaArray.Value="";
						var Addvalue = SpecList.Value == null ? ParaArray.Value : SpecList.Value;
						var ParaPair = new stFormParaNameValueArray(SpecList.Name, Addvalue);
						ParaListArray.push(ParaPair);
						break;
					}
				}
			}
			else if(4 == ForceFlag)
			{
				var Flag = 0;
				for(var j = 0; j < ArrayLengthTmp; j++)
				{
					var ParaArray = ParaListArray[j];
					if(ParaArray.Name == "")
					{
						continue;
					}

					var BaseName = ParaArray.Name.split(".")[1];
					if(SpecName == BaseName)
					{
						var Addvalue = SpecList.Value == null ? ParaArray.Value : SpecList.Value;
						Flag = 1;
						break;
					}
				}

				if(0 == Flag)
				{
					var Addvalue = SpecList.Value;
				}

				var ParaPair = new stFormParaNameValueArray(SpecList.Name, Addvalue);
				ParaListArray.push(ParaPair);
			}
			else
			{
				for(var j = 0; j < ArrayLengthTmp; j++)
				{
					var ParaArray = ParaListArray[j];
					if(ParaArray.Name == "")
					{
						continue;
					}

					if(ParaArray.Name == SpecList.Name)
					{
						ParaArray.Value = SpecList.Value;
						break;
					}
				}
			}
		}
	}

	if(SubmitType == 0)
	{
		var ArrayLength = ParaListArray.length;
		var AjaxData = "";
		for(var Para_j = 0; Para_j < ArrayLength; Para_j++)
		{
			var ParameterName = ParaListArray[Para_j].Name;
			var ParameterValue = FormatUrlEncode(ParaListArray[Para_j].Value);
			if(ParameterName != "")
			{
				if(Para_j != ArrayLength - 1)
				{
					AjaxData += ParameterName + "=" + ParameterValue + "&";
				}
				else
				{
					AjaxData += ParameterName + "=" + ParameterValue;
					break;
				}
			}
		}

		return AjaxData;
	}

	var ArrayLength = ParaListArray.length;
	for(var Para_j = 0; Para_j < ArrayLength; Para_j++)
	{
		var ParameterName = ParaListArray[Para_j].Name;
		var ParameterValue = ParaListArray[Para_j].Value;
		if(ParameterName == "")
		{
			continue;
		}

		SubmitForm.addParameter(ParameterName,ParameterValue);
	}

	return "success";
}

function stSetParaInfo(asynflag, FormLiList, SpecParaPair,OldValueList,UnUseForm)
{
	this.asynflag = asynflag;
	this.FormLiList = FormLiList;
	this.SpecParaPair = SpecParaPair;
	this.OldValueList = OldValueList;
	this.UnUseForm = UnUseForm;
}

function HWSetAction(type,url,Parameter,tokenvalue)
{
	var UnUseForm = (Parameter.UnUseForm == true) ? true : false;
	var ajaxResult;
	if("ajax" == type)
	{
		var AjaxBody = HWAddParameterByFormId(null, Parameter.FormLiList, Parameter.SpecParaPair, Parameter.OldValueList, UnUseForm);
		if(null == AjaxBody)
		{
			return;
		}
		
		$.ajax({
			type : "POST",
			async : Parameter.asynflag,
			cache : false,
			url: url,
			data :AjaxBody + "&x.X_HW_Token=" + tokenvalue,
			success : function(data) {
				ajaxResult=data;
				}
			});

			try{
				var ReturnJson = $.parseJSON(ajaxResult);
			}catch(e){
				var ReturnJson = null;
			}
		return ReturnJson;
	}
	else
	{
		var Form = new webSubmitForm();
		var FormBody = HWAddParameterByFormId(Form, Parameter.FormLiList, Parameter.SpecParaPair, Parameter.OldValueList, UnUseForm);
		HWConsoleLog(FormBody);
		if(null == FormBody)
		{
			return false;
		}
		Form.addParameter('x.X_HW_Token', tokenvalue);
		Form.setAction(url);
		Form.submit();
		return true;
	}
}

function HWGetAction(Url, ParameterList, tokenvalue)
{
	var tokenstring = (null == tokenvalue) ? "" : ("x.X_HW_Token=" + tokenvalue);
	var ResultTmp = null;
	  $.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : Url,
		data: ParameterList + tokenstring,
		success : function(data) {
			 ResultTmp  = data;
		}
	});

	try{
		var ReturnJson = $.parseJSON(ResultTmp);
	}catch(e){
		var ReturnJson = null;
	}

	return ReturnJson;
}

function HWGetDesByIndexId(DesArray,Id)
{
	try{
		return DesArray[Id];
	}catch(e){

		return "undefined";
	}
}

function HWParseResult(ReturnStr, ConfigIdList)
{
	if(null == ReturnStr)
	{
		return;
	}

	var result = ReturnStr.result;
	var ErrCode = "s" + ReturnStr.error;
	var ErrorId = HWGetIdByBindField(ConfigIdList, ReturnStr.pro);
	if(1 == result)
	{
		var ErrorDes = HWGetDesByIndexId(errLanguage, ErrCode);
		ErrorDes = "undefined" == ErrorDes ? errLanguage["s0xf7205001"]: ErrorDes;
		document.getElementById(ErrorId).style.backgroundColor="#FF0000";
	}
	else
	{
		var ErrorDes = HWGetDesByIndexId(errLanguage, "success");
	}
}

function HWConsoleLog(msg)
{
	try {
		//console.log(msg);
	}catch(e){};
}
