function OnDeleteButtonClick(tabTitle)
{
	var Selected = false;
	var RmlList = document.getElementsByName(tabTitle+"_rml");
    for (var i = 0; i < RmlList.length; i++)
	{
		if (RmlList[i].checked == true)
		{
			Selected = true;
		}
    }
	if (Selected == true)
	{
	    document.getElementById(tabTitle + '_DeleteButton').disabled = true;
	}

	clickRemove(tabTitle, "DeleteButton");
	

}
function writeTabHeader(tabTitle, tabDes, width, titleWidth, type)
{
	if (width == null)
	    width = "70%";
		
	if (titleWidth == null)
	   titleWidth = "120";
			
	var html = 
			"<table width=\"" + width + "\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">"
			+ "<tr>"
			+ "<td>"
			+ "<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">"
			+ "<tr class=\"tabal_head\">"
			+ "<td width=\"60%\" align=\"left\">" + tabDes + "<\/td>"
			+ "<td><\/td>"
			+ "<td align=\"right\">"
			+ "<table border=\"0\" cellpadding=\"1\" cellspacing=\"0\">"
			+ "<tr>";

	if ('info' == type)
	{
		 
	}
	else if ('cfg' == type)
	{
		html +=  '<td><input class="submit" id="' + tabTitle + '_Newbutton" type="button" value="新建" '
		         + 'onclick="clickAdd(\''
		         + tabTitle + '\');"></td>'
				 
				 + '<td><input id="' + tabTitle + '_DeleteButton" class="submit" type="button" value="删除" '
				 + 'onclick="OnDeleteButtonClick(\''
			     + tabTitle + '\');"></td>'
				 + '<td width="3"></td>';
	}
	else if ('qos' == type)
	{
		html +=  '<td><input class="submit" id="' + tabTitle + '_Newbutton" type="button" value="新建" '
		         + 'onclick="clickAddQos(\''
		         + tabTitle + '\');"></td>'
				 
				 + '<td><input id="' + tabTitle + '_DeleteButton" class="submit" type="button" value="删除" '
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
	var objTR = getElement(id);

	if (objTR != null)
	{
		var tableId = objTR.id.split('_')[0];
		var temp = objTR.id.split('_')[2];
		if (temp == 'null')
		{
		    setControlDispatch(tableId, -1);	
			setLineHighLight(tableId, objTR);
			setDisable(tableId  + '_btnApply',0);	
			setDisable(tableId  + '_btnCancel',0);		
		}
        else if (temp == 'no')
        {   
            setControlDispatch(tableId, -2);
			setDisable(tableId  + '_btnApply',0);	
			setDisable(tableId  + '_btnCancel',0);		
        }
		else
		{
			var index = parseInt(temp);
			setControlDispatch(tableId, index);
            setLineHighLight(tableId, objTR);
			setDisable(tableId  + '_btnApply',1);	
			setDisable(tableId  + '_btnCancel',1);		
		}	
	}	 
}

function selectMulLine(id,lineNum)
{
	var objTR = getElement(id);

	if (objTR != null)
	{
		var tableId = objTR.id.split('_')[0];
		var temp = objTR.id.split('_')[3];
		if (temp == 'null')
		{
		    setControlDispatch(tableId, -1);	
			setMulLineHighLight(tableId, id, lineNum);
			setDisable(tableId  + '_btnApply',0);	
			setDisable(tableId  + '_btnCancel',0);		
		}
        else if (temp == 'no')
        {   
            setControlDispatch(tableId, -2);
			setDisable(tableId  + '_btnApply',0);	
			setDisable(tableId  + '_btnCancel',0);		
        }
		else
		{
			var index = parseInt(temp);
			setControlDispatch(tableId, index);
            setMulLineHighLight(tableId, id, lineNum);
			setDisable(tableId  + '_btnApply',1);	
			setDisable(tableId  + '_btnCancel',1);		
		}	
	}	 
}

function clickAddQos(tabTitle)
{
	var ClassNum = 0;
	var tab = document.getElementById(tabTitle).getElementsByTagName('table');

	var row,col;
	var rowLen = tab[0].rows.length;
	var firstRow = tab[0].rows[0];
	var lastRow = tab[0].rows[rowLen - 1];
	tabTitle = tabTitle + '_N' + ClassNum;

	if (lastRow.id == (tabTitle + '_record_null'))
	{
		selectMulLine(tabTitle + '_record_null',ClassNum);
		return;
	}
    else if (lastRow.id == (tabTitle + '_record_no'))
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
		row.id = tabTitle + '_record_null';
		row.attachEvent("onclick", function(){selectMulLine(tabTitle + "_record_null",ClassNum);});
	}
	else
	{
		g_browserVersion = 2; /* firefox */
		row.setAttribute('class','trTabContent');
		row.setAttribute('id', tabTitle + '_record_null');
		row.setAttribute('onclick','selectLine(this.id);');
	}
	
	for (var i = 0; i < firstRow.cells.length; i++)
	{
        col = row.insertCell(i);
	 	col.innerHTML = '----';
	} 
	selectMulLine(tabTitle + "_record_null",ClassNum);
}

function clickAdd(tabTitle)
{
	var tab = document.getElementById(tabTitle).getElementsByTagName('table');

	var row,col;
	var rowLen = tab[0].rows.length;
	var firstRow = tab[0].rows[0];
	var lastRow = tab[0].rows[rowLen - 1];

	if (lastRow.id == (tabTitle + '_record_null'))
	{
		selectLine(tabTitle + '_record_null');
		return;
	}
    else if (lastRow.id == (tabTitle + '_record_no'))
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
		row.id = tabTitle + '_record_null';
		row.attachEvent("onclick", function(){selectLine(tabTitle + "_record_null");});
	}
	else
	{
		g_browserVersion = 2; /* firefox */
		row.setAttribute('class','trTabContent');
		row.setAttribute('id', tabTitle + '_record_null');
		row.setAttribute('onclick','selectLine(this.id);');
	}
	
	for (var i = 0; i < firstRow.cells.length; i++)
	{
        col = row.insertCell(i);
	 	col.innerHTML = '----';
	} 
	selectLine(tabTitle + "_record_null");
}

function addNullInstQos(tabTitle)
{
	var ClassNum = 0;
    var tab = document.getElementById(tabTitle).getElementsByTagName('table');
	var row,col;
	var rowLen = tab[0].rows.length;
	var firstRow = tab[0].rows[0];
	var lastRow = tab[0].rows[rowLen - 1];
	tabTitle = tabTitle + '_N' + ClassNum;
    
    tab[0].deleteRow(rowLen-1);
    rowLen = tab[0].rows.length;
    row = tab[0].insertRow(rowLen);

	var appName = navigator.appName;
	if (appName == 'Microsoft Internet Explorer')
	{
		g_browserVersion = 1; /* IE */
		row.className = 'trTabContent';
		row.id = tabTitle + '_record_no';
		row.attachEvent("onclick", function(){selectMulLine(tabTitle+ "_record_no",ClassNum);});
	}
	else
	{
		g_browserVersion = 2; /* firefox */
		row.setAttribute('class','trTabContent');
		row.setAttribute('id', tabTitle + '+record_no');
		row.setAttribute('onclick','selectMulLine(this.id,ClassNum);');
	}
	
	for (var i = 0; i < firstRow.cells.length; i++)
	{
        col = row.insertCell(i);
	 	col.innerHTML = '----';
	} 
	selectMulLine(tabTitle + "_record_no",ClassNum);
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
		row.id = tabTitle + '_record_no';
		row.attachEvent("onclick", function(){selectLine(tabTitle+ "_record_no");});
	}
	else
	{
		g_browserVersion = 2; /* firefox */
		row.setAttribute('class','trTabContent');
		row.setAttribute('id', tabTitle + '+record_no');
		row.setAttribute('onclick','selectLine(this.id);');
	}
	
	for (var i = 0; i < firstRow.cells.length; i++)
	{
        col = row.insertCell(i);
	 	col.innerHTML = '----';
	} 
	selectLine(tabTitle + "_record_no");
}

function removeInst(tabTitle, url)
{
   var rml = getElement(tabTitle + '_rml');
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
   SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
   SubmitForm.setAction('del.cgi?RequestFile=' + url);   
   SubmitForm.submit();	
}

function writeTabInfoHeader(tabTitle, tabDes, tabWidth, titleWidth)
{
	//writeTabHeader(tabTitle,tabWidth,titleWidth,'info');
}

function writeTabCfgHeader(tabTitle, tabDes, tabWidth, titleWidth)
{
	writeTabHeader(tabTitle, tabDes, tabWidth,titleWidth,'cfg');
}

function writeTabQosHeader(tabTitle, tabDes, tabWidth, titleWidth)
{
	writeTabHeader(tabTitle, tabDes, tabWidth,titleWidth,'qos');
}

function writeTabTail()
{
    document.write("<\/td><\/tr><\/table>");
}


var previousTRArray = new Array();
var previousLineNum = "";
function setLineHighLight(tableId, objTR)
{
	var previousTR = previousTRArray[tableId];

	if(previousTR == undefined)
	{
		previousTRArray[tableId] = null;
		previousTR = previousTRArray[tableId];
	}
	
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
	
	previousTRArray[tableId] = objTR;
}

function setMulLineHighLight(tableId, id, lineNum)
{
	var previousTR = previousTRArray[tableId];

	if(previousTR == undefined)
	{
		previousTRArray[tableId] = null;
		previousTR = previousTRArray[tableId];
	}
	
	if (previousTR != null)
	{
		if (previousLineNum == 0)
		{
			previousTR.style.backgroundColor = '#f4f4f4';
			for (var i = 0; i < previousTR.cells.length; i++)
			{
				previousTR.cells[i].style.color = '#000000';
			}
		}
		else
		{
			for (var k = 0; k < previousLineNum; k++)
			{
				var previousObjId = previousTR.id.substring(0,previousTR.id.length-1);
				previousObjId = previousObjId + k;
				previousTR = getElement(previousObjId);
				previousTR.style.backgroundColor = '#f4f4f4';
				for (var i = 0; i < previousTR.cells.length; i++)
				{
					previousTR.cells[i].style.color = '#000000';
				}
			}
		}
	}
	
	if (lineNum == 0)
	{
		var objTR = getElement(id);
		objTR.style.backgroundColor = '#c7e7fe';
		for (var j = 0; j < objTR.cells.length; j++)
		{
			objTR.cells[j].style.color = '#000000';		
		}
		previousTRArray[tableId] = objTR;
	}
	else
	{
		for (var i = 0; i < lineNum; i++)
		{
			var objId = objId = id.substring(0,id.length-1);
			objId = objId + i;
			var objTR = getElement(objId);
			objTR.style.backgroundColor = '#c7e7fe';
			for (var j = 0; j < objTR.cells.length; j++)
			{
				objTR.cells[j].style.color = '#000000';		
			}
			previousTRArray[tableId] = objTR;
		}
	}
	
	previousLineNum = lineNum;
	
}

