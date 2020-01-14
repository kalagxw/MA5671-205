
var TabWidth = "75%";

function GetDescFormArrayById(Language,Name)
{
    return (Language[Name] == null || Language[Name] == "undefined") ? "" : Language[Name];
}

function ParseBindTextByTagName(LanguageArray, TagName, TagType)
{
	var all = document.getElementsByTagName(TagName);
	for (var i = 0; i < all.length; i++)
	{
		var b = all[i];
		var c = b.getAttribute("BindText");
		if(c == null)
		{
			continue;
		}
		
		if(1 == TagType)
		{
			b.innerHTML = GetDescFormArrayById(LanguageArray, c);
		}
		else if(2 == TagType)
		{
			b.value = GetDescFormArrayById(LanguageArray, c);
		}
	}
}

function isValidAscii(val)
{
 for ( var i = 0 ; i < val.length ; i++ )
 {
 var ch = val.charAt(i);
 if ( ch < ' ' || ch > '~' )
 {
 return false;
 }
 }
 return true;
}
function SetDivValue(Id, Value)
{
 try
 {
 var Div = document.getElementById(Id);
 Div.innerHTML = Value;
 }
 catch(ex)
 {
 }
}
function getElById(sId)
{
 return getElement(sId);
}
function getElementById(sId)
{
 if (document.getElementById)
 {
 return document.getElementById(sId); 
 }
 else if (document.all)
 {
 return document.all(sId);
 }
 else if (document.layers)
 {
 return document.layers[sId];
 }
 else
 {
 return null;
 }
}

function getElementByName(sId)
{ 
 if (document.getElementsByName)
 {
 var element = document.getElementsByName(sId);
 if (element.length == 0)
 {
 return null;
 }
 else if (element.length == 1)
 {
 return element[0];
 }
 return element; 
 }
}
function getElement(sId)
{
 var ele = getElementByName(sId); 
 if (ele == null)
 {
 return getElementById(sId);
 }
 return ele;
}
function setDisplay (sId, sh)
{
 var status;
 if (sh > 0) 
 {
        status = "";
 }
 else 
 {
        status = "none";
 }
 var item = getElement(sId);
 if (null != item)
 {
 getElement(sId).style.display = status;
 }
}
function getDivInnerId(divID)
{
 var nameStartPos = -1;
 var nameEndPos = -1;
 var ele;
 divHTML = getElement(divID).innerHTML;
    nameStartPos = divHTML.indexOf("name=");
 nameEndPos = divHTML.indexOf(' ', nameStartPos);
 if(nameEndPos <= 0)
 {
        nameEndPos = divHTML.indexOf(">", nameStartPos);
 }
 try
 {
 ele = eval(divHTML.substring(nameStartPos+3, nameEndPos));
 }
 catch (e)
 {
 ele = divHTML.substring(nameStartPos+3, nameEndPos);
 }
 return ele;
}
function setDisable(sId, flag)
{
 var item;
 if (null == (item = getElement(sId)))
 {
		debug(sId + " is not existed" );
 return false;
 }
 if ( typeof(item.disabled) == 'undefined' )
 {
        if ( item.tagName == "DIV" || item.tagName == "div" )
 {
 var ele = getDivInnerId(sId); 
 setDisable(ele, flag);
 }
 }
 else
 {
 if ( flag == 1 || flag == '1' ) 
 {
 item.disabled = true;
 }
 else
 {
 item.disabled = false;
 } 
 }
 return true;
}
function webSubmitForm(sFormName, DomainNamePrefix)
{
 
 this.setPrefix = function(Prefix)
 {
 if (Prefix == null)
 {
 this.DomainNamePrefix = '.';
 }
 else
 {
 this.DomainNamePrefix = Prefix + '.';
 }
 }
 this.getDomainName = function(sName){
 if (this.DomainNamePrefix == '.')
 {
 return sName;
 }
 else
 {
 return this.DomainNamePrefix + sName;
 }
 }
 this.getNewSubmitForm = function()
 {
		var submitForm = document.createElement("FORM");
 document.body.appendChild(submitForm);
		submitForm.method = "POST";
 return submitForm;
 }
 this.createNewFormElement = function (elementName, elementValue){
 var newElement = document.createElement('INPUT');
 newElement.setAttribute('name',elementName);
 newElement.setAttribute('value',elementValue);
 newElement.setAttribute('type','hidden');
 return newElement;
 }
 
 this.addForm = function(sFormName,DomainNamePrefix){
 this.setPrefix(DomainNamePrefix);
 var srcForm = getElement(sFormName);
 if (srcForm != null && srcForm.length > 0 && this.oForm != null 
 && srcForm.style.display != 'none')
 {
 MakeCheckBoxValue(srcForm);
 for(i=0; i < srcForm.elements.length; i++)
 { 
 var type = srcForm.elements[i].type;
 if (type != 'button' && srcForm.elements[i].disabled == false)
 { 
 if (this.DomainNamePrefix != '.')
 {
 var ele = this.createNewFormElement(this.DomainNamePrefix 
 + srcForm.elements[i].name,
 srcForm.elements[i].value); 
 this.oForm.appendChild(ele);
 } 
 else
 {
 var ele = this.createNewFormElement(srcForm.elements[i].name,
 srcForm.elements[i].value
 );
 this.oForm.appendChild(ele);
 } 
 }
 }
 }
 else
 {
 this.status = false;
 }
 this.DomainNamePrefix = '.';
 }
 this.addDiv = function(sDivName,Prefix)
 {
 if (Prefix == null)
 {
 Prefix = '';
 }
 else
 {
 Prefix += '.';
 }
 var srcDiv = getElement(sDivName); 
 if (srcDiv == null)
 {
 debug(sDivName + ' is not existed!')
 return;
 }
 if (srcDiv.style.display == 'none')
 {
 return;
 }
		var eleSelect = srcDiv.getElementsByTagName("select");
 if (eleSelect != null)
 {
 for (k = 0; k < eleSelect.length; k++)
 {
 if (eleSelect[k].disabled == false)
 {
 this.addParameter(Prefix+eleSelect[k].name,eleSelect[k].value)
 }
 }
 }
 MakeCheckBoxValue(srcDiv);
		var eleInput = srcDiv.getElementsByTagName("input");
 if (eleInput != null)
 {
 for (k = 0; k < eleInput.length; k++)
 {
 if (eleInput[k].type != 'button' && eleInput[k].disabled == false)
 {
 this.addParameter(Prefix+eleInput[k].name,eleInput[k].value)
 }
 } 
 }
 }
 this.addParameter = function(sName, sValue){
 var DomainName = this.getDomainName(sName);
 for(i=0; i < this.oForm.elements.length; i++) 
 {
 if(this.oForm.elements[i].name == DomainName)
 {
 this.oForm.elements[i].value = sValue;
 this.oForm.elements[i].disabled = false;
 return;
 }
 }
 if(i == this.oForm.elements.length) 
 { 
 var ele = this.createNewFormElement(DomainName,sValue); 
 this.oForm.appendChild(ele);
 }
 }
 this.disableElement = function(sName){ 
 var DomainName = this.getDomainName(sName); 
 for(i=0; i < this.oForm.elements.length; i++) 
 {
 if(this.oForm.elements[i].name == DomainName)
 {
 this.oForm.elements[i].disabled = true;
 return;
 }
 }
 }
 this.usingPrefix = function(Prefix){
 this.DomainNamePrefix = Prefix + '.';
 }
 this.endPrefix = function(){
 this.DomainNamePrefix = '.';
 }
 this.setMethod = function(sMethod) {
		if(sMethod.toUpperCase() == "GET")
			this.oForm.method = "GET";
 else
			this.oForm.method = "POST";
 };
 this.setAction = function(sUrl) {
 this.oForm.action = sUrl;
 }
 this.setTarget = function(sTarget) {
 this.oForm.target = sTarget;
 };
 this.submit = function(sURL, sMethod) {
		if( sURL != null && sURL != "" ) this.setAction(sURL);
		if( sMethod != null && sMethod!= "" ) this.setMethod(sMethod);
 if (this.status == true)
 this.oForm.submit();
 };
 this.status = true;
 
 this.setPrefix(DomainNamePrefix);
 this.oForm = this.getNewSubmitForm();
 if (sFormName != null && sFormName != '')
 {
 this.addForm(sFormName,this.DomainNamePrefix);
 }
}
function Submit(type)
{
 if (CheckForm(type) == true)
 {
 var Form = new webSubmitForm();
 AddSubmitParam(Form,type); 
 Form.addParameter('x.X_HW_Token', getValue('onttoken')); 
 Form.submit();
 }
}
function CreateXMLHttp()
{ 
 var xmlhttp = null;
     var aVersions = ["MSXML2.XMLHttp.5.0","MSXML2.XMLHttp.4.0","MSXML2.XMLHttp.3.0",      
                      "MSXML2.XMLHttp","Microsoft.XMLHttp"];
 if(window.XMLHttpRequest)
 { 
 try 
 {
 xmlhttp = new XMLHttpRequest();
 }
 catch (e)
 {
 }
 }
 else 
 {
 if(window.ActiveXObject)
 { 
 for (var i=0; i<5; i++) 
 {
 try
 { 
 xmlhttp = new ActiveXObject(aVersions[i]);
 return xmlhttp;
 }
 catch (e)
 {
 }
 }
 }
 } 
 return xmlhttp;
}
function XmlHttpSendAspFlieWithoutResponse(FileName)
{
 var xmlHttp = null;
 if(null == FileName
	   || FileName == "")
 {
 return false;
 }
 if(window.XMLHttpRequest) {
 xmlHttp = new XMLHttpRequest();
 } else if(window.ActiveXObject) {
		xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
 }
    xmlHttp.open("GET", FileName, false);
 xmlHttp.send(null);
}

var base64EncodeChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
var base64DecodeChars = new Array(-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
 -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1, -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1,
 -1, -1, -1, -1);
function base64encode(str) {
 var out, i, len;
 var c1, c2, c3;
 len = str.length;
 i = 0;
    out = "";
 while (i < len) {
 c1 = str.charCodeAt(i++) & 0xff;
 if (i == len) {
 out += base64EncodeChars.charAt(c1 >> 2);
 out += base64EncodeChars.charAt((c1 & 0x3) << 4);
            out += "==";
 break;
 }
 c2 = str.charCodeAt(i++);
 if (i == len) {
 out += base64EncodeChars.charAt(c1 >> 2);
 out += base64EncodeChars.charAt(((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4));
 out += base64EncodeChars.charAt((c2 & 0xF) << 2);
            out += "=";
 break;
 }
 c3 = str.charCodeAt(i++);
 out += base64EncodeChars.charAt(c1 >> 2);
 out += base64EncodeChars.charAt(((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4));
 out += base64EncodeChars.charAt(((c2 & 0xF) << 2) | ((c3 & 0xC0) >> 6));
 out += base64EncodeChars.charAt(c3 & 0x3F);
 }
 return out;
}
function base64decode(str) {
 var c1, c2, c3, c4;
 var i, len, out;
 len = str.length;
 i = 0;
    out = "";
 while (i < len) {
 
 do {
 c1 = base64DecodeChars[str.charCodeAt(i++) & 0xff];
 } while (i < len && c1 == -1);
 if (c1 == -1)
 break;
 
 do {
 c2 = base64DecodeChars[str.charCodeAt(i++) & 0xff];
 } while (i < len && c2 == -1);
 if (c2 == -1)
 break;
 out += String.fromCharCode((c1 << 2) | ((c2 & 0x30) >> 4));
 
 do {
 c3 = str.charCodeAt(i++) & 0xff;
 if (c3 == 61)
 return out;
 c3 = base64DecodeChars[c3];
 } while (i < len && c3 == -1);
 if (c3 == -1)
 break;
 out += String.fromCharCode(((c2 & 0XF) << 4) | ((c3 & 0x3C) >> 2));
 
 do {
 c4 = str.charCodeAt(i++) & 0xff;
 if (c4 == 61)
 return out;
 c4 = base64DecodeChars[c4];
 } while (i < len && c4 == -1);
 if (c4 == -1)
 break;
 out += String.fromCharCode(((c3 & 0x03) << 6) | c4);
 }
 return out;
}
