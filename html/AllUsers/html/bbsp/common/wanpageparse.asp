var LoginRequestLanguage = '<%HW_WEB_GetLoginRequestLangue();%>';
var IsPTVDFMode = '<%HW_WEB_GetFeatureSupport(BBSP_FT_PTVDF);%>';
var RadioWanFeature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_RADIO_WAN_LOAD);%>"; 
var MobileBackupWanSwitch = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Mobile_Backup.Enable);%>';
if (MobileBackupWanSwitch == '')
{
	MobileBackupWanSwitch = 0;
}

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
           this.ControlInfo.InitValueList = new Array(new TextValueItem("","", "")); 
        }
        else
        {
            this.ControlInfo.InitValueList = new Array();
            var InitValueDescList = eval(this.ControlInfo.InitValue);
            for (var i = 0; i < InitValueDescList.length; i++)
            {
               this.ControlInfo.InitValueList[i] = new TextValueItem(this.LanguageList[InitValueDescList[i].TextRef], InitValueDescList[i].Value, ((this.LanguageList[InitValueDescList[i].TitleRef] == undefined) ? this.LanguageList[InitValueDescList[i].TextRef]:this.LanguageList[InitValueDescList[i].TitleRef]));
            }
        }
    }
    

} 

function UserControlPaser(_Id, _RealType, _DescRef, _RemarkRef, _ErrorMsgRef, _Require, _BindField, _InitValue, _TitleRef, _MaxLength,userPara)
{
    this.Id          = _Id;
    this.RealType    = _RealType;
    this.DescRef     = _DescRef;
    this.RemarkRef   = _RemarkRef;
    this.ErrorMsgRef = _ErrorMsgRef;
	this.TitleRef    = _TitleRef;
    this.Require     = _Require;
    this.BindField   = _BindField;
    this.InitValue   = _InitValue;
	this.MaxLength   = _MaxLength;
    
    
    this.Description = "";
    this.ErrorMsg = "";
    this.Remark = "";
	this.Title = "";
    this.InitValueList= null;
    var withOutCss = false;
    if("undefined" != typeof(userPara)){
        withOutCss = userPara;
    }
    this.OuterHTML = function()
    {
        
        if (this.RealType == "HorizonBar")
            return this["Build"+this.RealType]();
        else
        {
            if(true == withOutCss){
                return "<tr border=1 id=\""+this.Id+"Row"+"\"><td width=\"25%\" class=\"table_left\">"+this.Description+"<\/td><td width=\"75%\" id=\""+this.Id+"Col"+"\" class=\"table_right\">"+this["Build"+this.RealType]()+"<\/td><\/tr>";
            }
            return "<tr border=1 id=\""+this.Id+"Row"+"\"><td width=\"25%\" class=\"table_title\">"+this.Description+"<\/td><td width=\"75%\" id=\""+this.Id+"Col"+"\" class=\"table_right\">"+this["Build"+this.RealType]()+"<\/td><\/tr>";
        }
    }
    

    this.BuildTextArea = function()
    {
        var RequireContent = this.Require.toUpperCase() == "TRUE" ? "*":"";
        var type = (this.Id.toUpperCase().indexOf("PASSWORD") >= 0) ? "password" : "text";
        return "<textarea id=\""+this.Id+"\" type=\""+type+"\"  maxlength=\""+this.MaxLength+"\" title=\""+((this.Title.length > 0) ? this.Title:this.Remark.replace("(","").replace(")",""))+"\" class=\"TextArea\" maxlength=\""+this.MaxLength+"\" RealType=\""+this.RealType+"\" BindField=\""+this.BindField+"\"></textarea>\
               <font color=\"red\">"+RequireContent+"</font>\
               <span class=\"gray\" id=\""+this.Id+"Remark\">"+this.Remark+"</span>";
    }
    

    this.BuildTextBox = function()
    {
        var RequireContent = this.Require.toUpperCase() == "TRUE" ? "*":"";
        var type = (this.Id.toUpperCase().indexOf("PASSWORD") >= 0) ? "password" : "text";
        if(this.Id.toUpperCase().indexOf("IP") >= 0 && this.Id.toUpperCase().indexOf("VLAN") < 0){
            return "<input id=\""+this.Id+"\" type=\""+type+"\" title=\""+((this.Title.length > 0) ? this.Title:this.Remark.replace("(","").replace(")",""))+"\" class=\"TextBox restrict_dir_ltr\" maxlength=\""+this.MaxLength+"\" RealType=\""+this.RealType+"\" BindField=\""+this.BindField+"\"/><font color=\"red\">"+RequireContent+"</font><span class=\"gray\" id=\""+this.Id+"Remark\">"+this.Remark+"</span>";
        }
        return "<input id=\""+this.Id+"\" type=\""+type+"\" title=\""+((this.Title.length > 0) ? this.Title:this.Remark.replace("(","").replace(")",""))+"\" class=\"TextBox\" maxlength=\""+this.MaxLength+"\" RealType=\""+this.RealType+"\" BindField=\""+this.BindField+"\"/><font color=\"red\">"+RequireContent+"</font><span class=\"gray\" id=\""+this.Id+"Remark\">"+this.Remark+"</span>";
    }
    

    this.BuildCheckBox = function()
    {
        var RequireContent = this.Require.toUpperCase() == "TRUE" ? "*":"";
        return "<input id=\""+this.Id+"\" type=\"checkbox\"  RealType=\""+this.RealType+"\" BindField=\""+this.BindField+"\" onclick=\"OnChangeUI(this);\"/><font color=\"red\">"+RequireContent+"</font><span class=\"gray\">"+this.Remark+"</span>";
    }
    

    this.BuildDropDownList = function()
    {
        var RequireContent = this.Require.toUpperCase() == "TRUE" ? "*":"";
        var html = "<select id=\""+this.Id+"\" class=\"Select\" RealType=\"DropDownList\" BindField=\""+this.BindField+"\" onchange=\"OnChangeUI(this);\">";
       
        for (var i = 0; i < this.InitValueList.length; i++)
        {
            var tid = parseInt(i+1).toString();
            html += "<option id=\""+tid+"\" value=\""+this.InitValueList[i].Value+"\">"+this.InitValueList[i].Text+"<\/option>";
        }
               
        html += "</select>";
        
        return html;
    }  
    

    this.BuildRadioButtonList = function()
    {
        var RequireContent = this.Require.toUpperCase() == "TRUE" ? "*":"";
        var html = "";
       
        for (var i = 0; i < this.InitValueList.length; i++)
        {
            var tid = parseInt(i+1).toString();
			
			if ( "ARABIC" == LoginRequestLanguage.toUpperCase() )
			{
				html += "<div style=\"display:inline\" dir=\"rtl\" id=\"Div"+this.Id+tid+"\" title=\""+this.InitValueList[i].Title+"\"  style=\"width:10pt\"><input name=\""+this.Id+"\" id=\""+this.Id+tid+"\" type=\"radio\" title=\""+this.InitValueList[i].Title+"\" value=\""+this.InitValueList[i].Value+"\"  RealType=\""+this.RealType+"\" BindField=\""+this.BindField+"\" onclick=\"OnChangeUI(this);\"/>"+this.InitValueList[i].Text+"<font color=\"red\">"+RequireContent+"</font><span class=\"gray\">"+this.Remark+"<\/span><\/div>";
			}
			else
			{
				html += "<span id=\"Div"+this.Id+tid+"\" title=\""+this.InitValueList[i].Title+"\"  style=\"width:10pt\"><input name=\""+this.Id+"\" id=\""+this.Id+tid+"\" type=\"radio\" title=\""+this.InitValueList[i].Title+"\" value=\""+this.InitValueList[i].Value+"\"  RealType=\""+this.RealType+"\" BindField=\""+this.BindField+"\" onclick=\"OnChangeUI(this);\"/>"+this.InitValueList[i].Text+"<font color=\"red\">"+RequireContent+"</font><span class=\"gray\">"+this.Remark+"<\/span><\/span>";
			}
        }
        
        return html;
    } 
    

    this.BuildCheckBoxList = function()
    {
        var RequireContent = this.Require.toUpperCase() == "TRUE" ? "*":"";
        var html = "";
       
        for (var i = 0; i < this.InitValueList.length; i++)
        {
            var tid = parseInt(i+1).toString();
			if ( "ARABIC" == LoginRequestLanguage.toUpperCase() )
			{
				html += "<div style=\"display:inline\" dir=\"rtl\" id=\"Div"+this.Id+tid+"\" style=\"width:10pt\"><input name=\""+this.Id+"\" id=\""+this.Id+tid+"\" type=\"checkbox\" value=\""+this.InitValueList[i].Value+"\"  RealType=\""+this.RealType+"\" BindField=\""+this.BindField+"\"/>"+"<span>"+this.InitValueList[i].Text+"</span>"+"<font color=\"red\">"+RequireContent+"</font><span class=\"gray\">"+this.Remark+"</span><\/div>";
				if(TopoInfo.SSIDNum == 8 && i == 3)
				{
					html +=  "<br>";  
				}
            }
			else
			{
				html += "<span  id=\"Div"+this.Id+tid+"\" style=\"width:10pt\"><input name=\""+this.Id+"\" id=\""+this.Id+tid+"\" type=\"checkbox\" value=\""+this.InitValueList[i].Value+"\"  RealType=\""+this.RealType+"\" BindField=\""+this.BindField+"\"/>"+this.InitValueList[i].Text+"<font color=\"red\">"+RequireContent+"</font><span class=\"gray\">"+this.Remark+"</span><\/span>";
				
				if(TopoInfo.SSIDNum == 8 && i == 3)
				{
				     html +=  "<br>";  
				}
			}
        }
        return html;
    } 
	
	 this.BuildInputButtonList = function()
    {
        var RequireContent = this.Require.toUpperCase() == "TRUE" ? "*":"";
        var html = "";
       
        for (var i = 0; i < this.InitValueList.length; i++)
        {
            var tid = parseInt(i+1).toString();
			
			html += "<span  id=\"Div"+this.Id+tid+"\" style=\"width:10pt\"><input name=\""+this.Id+"\" id=\""+this.Id+tid+"\" type=\"button\" value=\""+this.InitValueList[i].Value+"\"  class=\"submit\" RealType=\""+this.RealType+"\" BindField=\""+this.BindField+"\" onclick=\"OnConnectionButton(this);\"/>"+this.InitValueList[i].Text+"<font color=\"red\">"+RequireContent+"</font><span class=\"gray\">"+this.Remark+"</span><\/span>";
			
        }
        return html;
    }
    

    this.BuildHorizonBar = function()
    {
        var html = "";
        if(true == withOutCss){
            html += "<tr  id=\""+this.Id+"Row\">";
            html += "<td  class=\"table_left\" width=\"25%\"  id=\""+this.Id+"\" RealType=\""+this.RealType+"\" BindField=\""+this.BindField+"\">"+this.Description+"<\/td>";
			html += "<td  width=\"75%\"><\/td>";
        }else{
            html += "<tr class=\"head_title\" id=\""+this.Id+"Row\">";
            html += "<td class=\"align_left\" colspan=\"2\" id=\""+this.Id+"\" RealType=\""+this.RealType+"\" BindField=\""+this.BindField+"\">"+this.Description+"<\/td>";
        }
        html += "<\/tr>";
         
         return html;
    }     
              
    
} 


function isReadModeForTR069Wan()
{
	return IsTr069WanOnlyRead();
}

function CheckNormalUserRadioWan()
{
	var count = 0;
	if(!((RadioWanFeature == "1") && (IsAdminUser() == false) && (MobileBackupWanSwitch == 1)))
	{
		return true;
	}
	
	for (i = 0;i < GetWanList().length; i++)
	{	
		if (Wan[i].RealName.indexOf("RADIO") < 0)
		{
			continue;
		}
		count++;
	}
	
	return (count > 0)?true:false;
}

function ShowWanListTable()
{
    var CheckBoxColumn1 = IsAdminUser() == true ? '<td>&nbsp;<\/td>': '';
    var CheckBoxColumn2 = IsAdminUser() == true ? '<TD align="center">--</TD>': ''; 
    var WriteHeaderFunc = IsAdminUser() == true ? writeTabCfgHeader : writeTabInfoHeader;

    WriteHeaderFunc('Wan Connection','100%');  
	if(IsSonetUser())
	{
		document.write('<table width="100%" class="tabal_bg" id="wanInstTable"  cellspacing="1"><tr class="head_title">'+CheckBoxColumn1+'<td>'+GetLanguage("WanConnectionName")+'</td><td>'+GetLanguage("WanProtocolType1")+'</td></tr>');
	}
	else
	{
		document.write('<table width="100%" class="tabal_bg" id="wanInstTable"  cellspacing="1"><tr class="head_title">'+CheckBoxColumn1+'<td>'+GetLanguage("WanConnectionName")+'</td><td>'+GetLanguage("WanVlanPriority")+'</td><td>'+GetLanguage("WanProtocolType1")+'</td></tr>');
	}
    if ((GetWanList().length == 0) || (CheckNormalUserRadioWan() == false))
    {
        document.write('<TR id="record_no"' + ' class="tabal_01">');
        if (IsAdminUser() == true)
        {
            document.write('<TD align="center">--</TD>');
        }
		if(false == IsSonetUser())
		{
			document.write('<TD align="center">--</TD>');
		}
        document.write('<TD align="center">--</TD>');
        document.write('<TD align="center">--</TD>');
        document.write('</TR>');
    }
    else
    {
        for (i = 0;i < GetWanList().length; i++)
        {
			if ((RadioWanFeature == "1") && (IsAdminUser() == false) && (MobileBackupWanSwitch == 1))
			{
				if (Wan[i].RealName.indexOf("RADIO") < 0)
				{
					continue;
				}
			}
			
            var Color = Wan[i].RealName.indexOf("OLT") >= 0 ? "gray" : "black";
            var Title = "RealName   :"+Wan[i].RealName+"\r\nStatus     :"+Wan[i].Status+"\r\nIPAddress  :"+Wan[i].IPv4IPAddress+"";
            document.write('<TR id="record_' + i + '" onclick="selectLine(this.id);" class="tabal_01">');
            if (IsAdminUser() == true)
            {		
							if( 'TELECOM' == CfgModeWord.toUpperCase() )
			                {
				               document.write('<TD align="center">' + '<input type="checkbox" name="rml"'  + ' value="' + Wan[i].domain + '" onClick="selectRemoveCnt(this);" disabled="true">' + '</TD>');
			                }
							else if(isReadModeForTR069Wan() && (Wan[i].ServiceList.indexOf("TR069") >= 0))
							{
								document.write('<TD align="center">' + '<input type="checkbox" disabled="disabled" name="rml"'  + ' value="' + Wan[i].domain + '" onClick="selectRemoveCnt(this);">' + '</TD>');			
							}
							else if ('JSCMCC' == CfgModeWord.toUpperCase() && Wan[i].VlanId == 4031 && Wan[i] && Wan[i].ServiceList == 'OTHER' && Wan[i].EncapMode == 'PPPoE' && IsWanHidden(domainTowanname(Wan[i].domain)) == true)
							{
							    document.write('<TD align="center">' + '<input type="checkbox" name="rml"'  + ' value="' + Wan[i].domain + '" onClick="selectRemoveCnt(this);" disabled="true">' + '</TD>');
							}
							else
							{
								document.write('<TD align="center">' + '<input type="checkbox" name="rml"'  + ' value="' + Wan[i].domain + '" onClick="selectRemoveCnt(this);">' + '</TD>');
							}

            }
            document.write('<TD align="center"><font color='+Color+'>' + Wan[i].Name + '</font></TD>');
            var vlan = "-", pri = "-";
            if ( 0 != parseInt(Wan[i].VlanId) )
            {	
                vlan = Wan[i].VlanId;
				pri = ('SPECIFIED' == Wan[i].PriorityPolicy.toUpperCase()) ? Wan[i].Priority : Wan[i].DefaultPriority ;
            }
			if(false == IsSonetUser())
			{
				document.write('<TD align="center"><font color='+Color+'>'+vlan+'/'+pri+'</font></TD>');
			}
            document.write('<TD align="center"><font color='+Color+'>' + Wan[i].ProtocolType + '</font></TD>');
            document.write('</TR>');
        }
    }

    document.write('</table>');
}


var ElementIdList = new Array();
function ParsePageControl(userPara)
{
    var ElementList = document.getElementsByTagName("li");
    var ElementLength = ElementList.length;
    
    for (var i = 0; i < ElementLength; i++)
    {
        ElementIdList[i] = ElementList[i].id;
    }
    
    var HasStartHorizonBar = false;
    for (var i = 0; i < ElementLength; i++)
    {
        var Element = document.getElementById(ElementIdList[i]);
        
        var ControlInfo = new UserControlPaser(
            Element.id, Element.getAttribute("RealType"), 
            Element.getAttribute("DescRef"), Element.getAttribute("RemarkRef"), 
            Element.getAttribute("ErrorMsgRef"), Element.getAttribute("Require"), 
            Element.getAttribute("BindField"), Element.getAttribute("InitValue"),
			Element.getAttribute("TitleRef"),Element.getAttribute("MaxLength"),userPara);
        
        var Decorate = new UserControlPaserDecorate(ControlInfo, Languages);
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
	
   if( 'TELECOM' == CfgModeWord.toUpperCase() )
   {  		 
        setDisable('Newbutton', 1);
        setDisable('DeleteButton', 1);
   }
}

function ParsePageSpec()
{
	if (("1" == GetCfgMode().GDCT) || ("1" == GetCfgMode().FJCT) || ("1" == GetCfgMode().JSCT)
     || ("1" == GetCfgMode().CQCT) || ("1" == GetCfgMode().JXCT))
	{
		document.getElementById("DivIPv4BindLanList2").childNodes[1].nodeValue = "LAN2(iTV)"
	}
	
	if("1" != GetCfgMode().TELMEX)
	{
		$("#UserNameRemark").text("");
		$("#PasswordRemark").text("");
	}
}

