var g_redirectTimer_diff;
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

	for (var i = 0; i < firstRow.cells.length; i++)
	{
		col = row.insertCell(i);
		col.innerHTML = '----';
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

function writeTabInfoHeader(tabTitle, tabWidth, titleWidth, tabId)
{
	writeTabHeader(tabTitle, tabWidth, titleWidth, 'info', tabId);
}

function writeTabCfgHeader(tabTitle, tabWidth, titleWidth, tabId)
{
	writeTabHeader(tabTitle, tabWidth, titleWidth, 'cfg', tabId);
}

function writeTabTail()
{
	document.write("<\/td><\/tr><\/table>");
}


var previousTR = null;
function setLineHighLight(objTR)
{
	if (previousTR != null)
	{
		previousTR.style.backgroundColor = '#f4f4f4';
		for (var i = 0; i < previousTR.cells.length; i++)
		{
			previousTR.cells[i].style.color = '#000000';
		}
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

function writeTabHeader(tabTitle, width, titleWidth, type, tabId)
{
	if (width == null)
		width = "70%";

	if (titleWidth == null)
		titleWidth = "120";

	var spaceHeight = ('info' == type) ? "0" : "22";

	var html = "<table";

	if (tabId != null)
	{
		html += " id=\"" + tabId + "\"";
	}

	html += " width=\"" + width + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">"
			+ "<tr>"
			+ "<td>"
			+ "<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">"
			+ "<tr>"
			+ " <td width=\"7\" height=\"" + spaceHeight + "\"> <\/td>"
			+ "<td valign=\"bottom\" align=\"center\" width=\"" + titleWidth + "\" >"
			+ "<\/td>"
			+ "<td width=\"7\"><\/td>"
			+ "<td align=\"right\">"
			+ "<table border=\"0\" cellpadding=\"1\" cellspacing=\"0\">"
			+ "<tr>";

	if ('info' == type)
	{

	}
	else if ('cfg' == type)
	{
		html +=  '<td><input class="submit" id="Newbutton" type="button" value="New" '
			 + 'onclick="clickAdd(\''
			 + tabTitle + '\');"></td>'

			 + '<td><input id="DeleteButton" class="submit" type="button" value="Delete" '
			 + 'onclick="OnDeleteButtonClick(\''
			 + tabTitle + '\');"></td>'
			 + '<td width="3"></td>';
	}

	html += "<\/tr>"
			+ "<\/table>"
			+ "<\/td>"
			+ "<\/tr>"
			+ "<\/table>"
			+ "<\/td>"
			+ "<\/tr>"
			+ "<tr>"
			+ "<td id=\"" + tabTitle + "\">";

	writeFile(html);
	document.write(html);
}


