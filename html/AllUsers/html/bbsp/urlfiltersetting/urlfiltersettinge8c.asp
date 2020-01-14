<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="javascript" src="../../bbsp/common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>
<title>URL Filter</title>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var FltsecLevel = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Security.X_HW_FirewallLevel);%>'.toUpperCase();
var UrlFilterAllCnt = 0;
function loadlanguage()
{
	var all = document.getElementsByTagName("td");
	for (var i = 0; i <all.length ; i++) 
	{
		var b = all[i];
		if(b.getAttribute("BindText") == null)
		{
			continue;
		}
		b.innerHTML = urlfiltersetting_language[b.getAttribute("BindText")];
	}
}

function LoadFrame()
{
	setDisplay('Newbutton',0);
	setDisplay('DeleteButton',0);
	if(FltsecLevel != 'CUSTOM')
	{
		setDisable('URL_filter_enable_checkbox' , 1);
		setDisable('SmartEnable' , 1);
		setDisable('ExcludeMode_select' , true);
	}
	loadlanguage();
	showUrlFilterTips();
}
function showUrlFilterTips()
{
    var ExcludeMode_select = getElById("ExcludeMode_select");
    if (ExcludeMode_select[0].selected == true){
        getElement('ExcludeMode_tips_lable').innerHTML = "当配置在黑名单内的地址不允许被访问";
    }
    else{
        getElement('ExcludeMode_tips_lable').innerHTML = "只有当配置在白名单内的地址才允许被访问";
    }
}
function OnSaveUrlMode()
{
    var Form = new webSubmitForm();
    
    var control = getElById("ExcludeMode_select");
    if (control[0].selected == true){
        Form.addParameter('x.UrlFilterPolicy',0);
    }else{
        Form.addParameter('x.UrlFilterPolicy',1);
    }
    
    var Enable = getElById("URL_filter_enable_checkbox").checked;
    var CheckValue = (Enable == true)? "1":"0";
    Form.addParameter('x.UrlFilterRight',CheckValue);
	Form.addParameter('x.UrlFilterIpConcern',getCheckVal("SmartEnable"));
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		
    Form.setAction('set.cgi?' +'x=InternetGatewayDevice.X_HW_Security' + '&RequestFile=html/bbsp/urlfiltersetting/urlfiltersettinge8c.asp');
    Form.submit();
}	
</script>   
</head>
<body  onLoad="LoadFrame();" class="mainbody">
<table style="display:none" width="800px"> 
  <tr> 
    <td><input type="text" ID="UrlEnableData" value="1"/></td> 
    <td><input type="text" ID="NameListModeData" value="0"/></td> 
    <td><input type="text" ID="SmartEnableData" value="true"/></td> 
    <td><input type="text" ID="UrlData" value = "http://www.sina.com.cn|http://www.chinaren.com|http://www.sina.com"/></td> 
  </tr> 
</table> 
<div id="DivContent" style="display:block"> 
  <table  width="100%" id="TableSmartFilter" style="display:block" > 
    <tr  width="100%" > 
      <td class="prompt"><table width="100%" border="0" cellspacing="0" cellpadding="0"> 
          <tr> 
            <td class='title_common'><label id="Title_url_filter_set_lable">URL过滤——请先选择列表类型然后配置列表条目，最多128条可以被配置。</label>
			</td> 
          </tr> 
        </table></td> 
    </tr> 
  </table> 
  <table id="TableFilterContent"  width="100%" cellspacing="0"> 
    <tr > 
      <td class="table_title width_25p">启用</td> 
    <td class="table_right"><input type="checkbox" value="false" id="URL_filter_enable_checkbox" /></td>
     <td class="table_right width_5p" ></td>
	 <td class="table_right width_70p" >
	</tr > 
    <tr > 
      <td  class="table_title width_25p">URL列表类型</td> 
      <td  class="table_right"  id="Selectmode" >
	  <select id="ExcludeMode_select" onchange="setTimeout(function(){OnNameListModeChange();})"> 
          <option value="0"><script>document.write(urlfiltersetting_language['bbsp_blacklist']);</script></option> 
          <option value="1"><script>document.write(urlfiltersetting_language['bbsp_whitelist']);</script></option> 
      </select></td>
      <td class="table_right width_5p" ></td>
      <td class="table_right width_70p" ><label id="ExcludeMode_tips_lable" ></label></td> 
    </tr> 
    <tr > 
      <td  class="table_title width_25p" >使能智能URL过滤</td> 
      <td  class="table_right"><input  type='checkbox' id="SmartEnable" /></td> 
        <td class="table_right width_5p" ></td>
	 <td class="table_right width_70p" >
    </tr> 
  </table> 
      <table width="100%" class="table_button"> 
          <tr align="right"> 
          <td><button id="ModeSave_button" type="button" onclick="OnSaveUrlMode()">保存/应用</button></td>
          </tr>
     </table>
<hr style="color:#C9C9C9"></hr>
  <table width="100%"> 
    <tr> 
      <td> <script language="JavaScript" type="text/javascript">
                 writeTabCfgHeader('TableUrlRecord',"100%","140");
            </script> </td> 
    </tr> 
    <tr> 
      <td> <table id="TableUrlRecord"  width="100%"> </table></td> 
    </tr> 
  </table> 
  <div id="ConfigUrlPanel" > 
    <table cellpadding="0" cellspacing="1"  width="100%"> 
      <tr>
        <td class="table_title width_10p">URL地址</td> 
        <td class="table_right"> <input type="text" id="URLAddress_text"  class='width_95p' maxlength="63"/> 
          <font color="red">*</font></td> 
      </tr> 
    </table> 
    <table width="100%" class="table_button"> 
      <tr align="right"> 
        <td class='width_20p'></td> 
        <td>
		<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
		<button id='URLAdd_button'type="button" onClick="OnBtAddUrlClick(this)">添加</button>
	   <button id='URLDelete_button' name="btnApply_ex"  type="button" onClick="OnDeleteBtClick();">删除</button></td>
      </tr> 
    </table> 
  </div> 
</div> 
<script language="javascript">

    function UrlValueClass(_Domain, _Url)
    {
        this.Domain = _Domain;
        this.Url = _Url;
    }
    
    function UrlFilterBaseValueClass(_Domain, _Policy, _Right, _IpConcern)
    {
        this.Domain = _Domain;
        this.Policy = _Policy;
        this.Right = _Right;
        this.IpConcern = _IpConcern;
    }

    var BaseUrlFilterValueArray = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security,UrlFilterPolicy|UrlFilterRight|UrlFilterIpConcern,UrlFilterBaseValueClass);%>;
    var BaseUrlFilterValue = BaseUrlFilterValueArray[0];
    var UrlValueArray = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.UrlFilter.{i},UrlAddress,UrlValueClass);%>;
	var selectindex = -1;

    if (null == BaseUrlFilterValue)
    {
        BaseUrlFilterValue = new UrlFilterBaseValueClass();
        BaseUrlFilterValue.Right = "0";
        BaseUrlFilterValue.Policy = "1";
        BaseUrlFilterValue.IpConcern = "0";
        UrlValueArray = new Array();
    }
    
    function DataPersistentClass()
    {   
        this.GetData = function()
        {
            var UrlFilterInfo = new UrlFilterInfoClass();
            var UrlEnable = BaseUrlFilterValue.Right;
            var NameListMode = BaseUrlFilterValue.Policy;
            var SmartEnable = BaseUrlFilterValue.IpConcern;
            var UrlAllStr = document.getElementById("UrlData").value;
            var ArrayOfUrl = UrlValueArray;
            var i = 0;
            var SplitResult = UrlAllStr.split("|");
  
            var UrlFilterInfo = new UrlFilterInfoClass(UrlEnable, NameListMode, SmartEnable, ArrayOfUrl);
            UrlFilterInfo.SetEnable(UrlEnable);

            return UrlFilterInfo;
        }

        this.SaveData = function(UrlFilterInfo)
        {   
        
            document.getElementById("UrlEnableData").value = UrlFilterInfo.GetEnable();
            document.getElementById("NameListModeData").value = UrlFilterInfo.GetNameListMode();
            document.getElementById("SmartEnableData").value = UrlFilterInfo.GetSmartEnable();
            document.getElementById("UrlData").value = UrlFilterInfo.GetUrlString(); 
        }
    }
function clickCheckbox(index)
{
    var chkboxShow = 'URLAddress' + index +'_checkbox';
    var chkboxHide = 'URLAddress' + index +'_checkboxCopy';
    getElementById(chkboxHide).checked = getElementById(chkboxShow).checked;
}
function clickCheckboxAll()
{
    for (var i = 1; i < UrlFilterAllCnt; i++){
        var chkboxShow = 'URLAddress' + i +'_checkbox';
        getElementById(chkboxShow).checked = getElementById("URLAddress_checkbox").checked;
        clickCheckbox(i);
    }
}
    function DataUIObserverClass()
    {
        this.UpdateUI = function(UrlFilterInfo)
        {
            document.getElementById("URL_filter_enable_checkbox").checked = UrlFilterInfo.GetEnable() == "1" ? true:false;
             
            document.getElementById("DivContent").style.display = "block";
            if ("1" == UrlFilterInfo.GetEnable())
            {
               document.getElementById("DivContent").style.display = "block";
            }

            getElById("ExcludeMode_select")[0].selected = true;
            if (UrlFilterInfo.GetNameListMode() == "1")
            {
                getElById("ExcludeMode_select")[1].selected = true;
            }

            document.getElementById("SmartEnable").checked = UrlFilterInfo.GetSmartEnable().toString()=="1"?true:false;

            var Table = document.getElementById("TableUrlRecord");
            var Html = "<table id=\"TableUrlList\" width=\"100%\" cellspacing=\"1\" class=\"tabal_bg\"><tr class=\"head_title\"><td width=\"8%\" align=\"center\">" +
            "<input id=\"URLAddress_checkbox\" type=\"checkbox\" onclick=\"clickCheckboxAll();\"  value=\"false\" >"
            + "</td><td align=\"center\" id=\"URLAddress_table\" class=\"head_title\">"+urlfiltersetting_language['bbsp_urladdr']+"</td></tr>";
            var UrlArray = UrlFilterInfo.GetAllUrl();
            var i = 0;
            var Index = 1;
			if(FltsecLevel != 'CUSTOM')
			{
				UrlArray.length = 0;
			}
            if (UrlArray.length <= 1)
            {
               Html += "<tr class=\"tabal_01\"><td align=\"center\">--</td><td align=\"center\">--</td></tr>"; 
            }
            UrlFilterAllCnt = UrlArray.length;
            for (i = 0; i < UrlArray.length; i++)
            {
                if (UrlArray[i] == null)
                {
                    continue;
                }
                Html += "<tr class=\"tabal_01\"><td align=\"center\"><input type=\"checkbox\" value=\"false\" id=\"URLAddress"+Index+"_checkbox\" onclick=\"clickCheckbox("+Index+");\"/>";
                Html += "<input type=\"checkbox\" style=\"display:none\" name=\"rml\" value=\""+UrlArray[i].Domain+"\" id=\"URLAddress"+Index+"_checkboxCopy\"/></td>";
                Html += "<td align=\"center\" id=\"URLAddress"+Index+"_table\" title=\""+UrlArray[i].Url+"\" >"+GetStringContent(UrlArray[i].Url, 50)+"</td></tr>";
                Index++;
            }
            Html +="</table>";
            Table.innerHTML = Html;
        }
    }

    function UrlFilterPage()
    {
        this.UrlFileInfoObj = null;
        this.UIObserver = null;

        this.SetUIObserver = function(_UIObserver)
        {
            this.UIObserver = _UIObserver;
            this.UrlFileInfoObj.AddObserver(this.UIObserver);
        }
        this.GetUIObserver = function()
        {
            return this.UIObserver;
        }

        this.SetData = function(_UrlFilterInfo)
        {
            this.UrlFileInfoObj = _UrlFilterInfo;
            this.UrlFileInfoObj.NotifyObserver();
        }
        this.GetData = function()
        {
            return this.UrlFileInfoObj;
        }        

        this.LoadData = function()
        {
            var DataObj = new DataPersistentClass();
            var UIObserver = new DataUIObserverClass();
            var UrlFilterInfo = DataObj.GetData();
            UrlFilterInfo.AddObserver(UIObserver);
            this.SetData(UrlFilterInfo);
        }
        this.SaveData = function()
        {
            this.UrlFileInfoObj.SaveData(new DataPersistentClass());
        } 
    }

   var Page = new UrlFilterPage();

   Page.LoadData();

    function OnDeleteUrlClick(Url)
    {
        Page.GetData().DeleteUrl(Url);
    }


function OnNameListModeChange()
{
    var control = getElById("ExcludeMode_select");
    
    if (control[0].selected == true)
	{ 	
		if (false == ConfirmEx(urlfiltersetting_language['bbsp_ischange']))
		{
		    control[0].selected = false;
			control[1].selected = true;
			return;
		}
	}
	else if (control[1].selected == true)
	{ 
		if (false == ConfirmEx(urlfiltersetting_language['bbsp_ischange']))
		{
		     control[0].selected = true;
		     control[1].selected = false;
			 return;
		}
	}
	showUrlFilterTips();
}


    function OnDeleteBtClick()
    {
        var i = 0;
        var count = Page.GetData().GetUrlList().length;
        var control = null;
        var DeleteInstanceArray = new Array();

		if(0 == (count-1))
		{
		    AlertEx(urlfiltersetting_language['bbsp_nourl']);
			return;
		}

        for (i = 0; i < count; i++)
        {
            var recordId = i + 1;
            control = document.getElementById("URLAddress"+recordId+"_checkboxCopy");
            if (null == control)
            {
                continue;
            }
            if (control.checked == false)
            {
                continue;
            }
            DeleteInstanceArray.push(control.value);
        }

        if (DeleteInstanceArray.length == 0)
        {
            AlertEx(urlfiltersetting_language['bbsp_selecturl']);
            return;
        }

        var Form = new webSubmitForm();
        for (i = 0; i < DeleteInstanceArray.length; i++)
        {
            Form.addParameter(DeleteInstanceArray[i], '');
        }
		
	    Form.addParameter('x.X_HW_Token', getValue('onttoken'));	
	    Form.setAction('del.cgi?&RequestFile=html/bbsp/urlfiltersetting/urlfiltersettinge8c.asp');
	    Form.submit();
    }

    function IsUrlRepeat(UrlList, NewUrl)
    {
        var i;
        for (i = 0; i < UrlList.length; i++)
        {   
            if (UrlList[i] == null)
            {
                break;
            }
        
			if (TextTranslate(UrlList[i].Url.toLowerCase()) == NewUrl.toLowerCase())
            {
                return true;
            }
        }
        return false;
    }

    function OnBtAddUrlClick(BtAddUrlControl)
    {
		if(Page.GetData().GetUrlList().length >= 129)
		{
			AlertEx(urlfiltersetting_language['bbsp_urlfull']);
			return ;
		} 
		
		var UrlValueControl = document.getElementById("URLAddress_text");
        var UrlString = UrlValueControl.value;
        var ArrayOfUrl = Page.GetData().GetUrlList();

		if (isValidAscii(UrlString) != '')         
		{  
			AlertEx(urlfiltersetting_language['bbsp_urladdr'] + Languages['Hasvalidch'] + isValidAscii(UrlString) + '".');          
			return false;       
		}

		if((CheckUrlParameter(UrlString) == false) || (IsUrlValid(UrlString) == false))
		{
			AlertEx(urlfiltersetting_language['bbsp_urlinvalid']);
            return false;
		}

        if (IsUrlRepeat(ArrayOfUrl, UrlString) == true)
        {
            AlertEx(urlfiltersetting_language['bbsp_urlrepeat']);

            return false;
        }

        Page.GetData().AddUrl(new UrlValueClass("domain",UrlString));

        var Form = new webSubmitForm();
	    Form.addParameter('x.UrlAddress',UrlString);
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));	
	    Form.setAction('add.cgi?' +'x=InternetGatewayDevice.X_HW_Security.UrlFilter' + '&RequestFile=html/bbsp/urlfiltersetting/urlfiltersettinge8c.asp');
	    Form.submit();
		DisableRepeatSubmit();
	    
    	setDisable('URLAdd_button', 1);
        setDisable('URLDelete_button', 1);
    }
	
	function DeleteLineRow()
	{
	   var tableRow = getElementById("TableUrlList");
	   if (tableRow.rows.length > 2)
	   tableRow.deleteRow(tableRow.rows.length-1);
	   return false;
	}
	
    function setControl(Index)
    {
		selectindex = Index;
		if (-1 == Index)
		{
			if(Page.GetData().GetUrlList().length >= 129)
			{
				DeleteLineRow();
				AlertEx(urlfiltersetting_language['bbsp_urlfull']);
				return ;
			} 
		}
		else
		{
			return ;
		}
        getElById("ConfigUrlPanel").style.display = "block";
    }
    function clickRemove() 
    {
        return OnDeleteBtClick();
    }

    </script> 
<br> 
<br> 
</body>
</html>
