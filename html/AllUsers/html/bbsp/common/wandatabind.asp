function UserControlValueSetter(_ControlId,_DataSource)
{
    this.Id = _ControlId;
    this.DataSource = _DataSource;
    this.Control = document.getElementById(this.Id);
    if (this.Control == null)
    {
        this.Control = document.getElementById(this.Id+"1");
    }
    this.RealType = this.Control.getAttribute("RealType");
    this.BindField = this.Control.getAttribute("BindField");
    this.Value = this.DataSource[this.BindField];
    
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
}
function UserControlValueGetter(ControlId)
{
    this.Id = ControlId;
    
    this.GetValue = function()
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

function GetPageData()
{
    var Wan = new WanInfoInst();
    for (var i = 0; i < ElementIdList.length; i++)
    {
        var Picker = new UserControlValueGetter(ElementIdList[i]);
        var CurrentControl = document.getElementById(ElementIdList[i]);
        if (CurrentControl == null)
        {
            CurrentControl = document.getElementById(ElementIdList[i]+"1");
        }
        var BindField = CurrentControl.getAttribute("BindField");
        if (BindField == "Empty")
        {
            continue;
        }
        Wan[BindField] = Picker.GetValue();        
    }

    if (Wan.EncapMode == "PPPoE" && Wan.Mode == "IP_Bridged")
    {
        Wan.Mode = "PPPoE_Bridged";
    }
    
    Wan.IPv4Enable = "0";
    Wan.IPv6Enable = "0";

    if (Wan.ProtocolType == "IPv4/IPv6")
    {
        Wan.IPv4Enable = "1";
        Wan.IPv6Enable = "1";
    }
    if (Wan.ProtocolType == "IPv4")
    {
        Wan.IPv4Enable = "1";
    }
    if (Wan.ProtocolType == "IPv6")
    {
        Wan.IPv6Enable = "1";
    }
	if(IsE8cFrame())
	{
		Wan.IPv4BindLanList = Wan.IPv4BindLanList.concat(Wan.IPv4BindSsidList);
	}
    return Wan;
      
}


function BindPageData(Wan)
{
    var LanWanBindInfo = GetLanWanBindInfo(domainTowanname(Wan.domain));
    var SsidWanBindInfo = "";
    if (LanWanBindInfo != null && LanWanBindInfo != undefined)
    {
        Wan.IPv4BindLanList = LanWanBindInfo.PhyPortName.split(",");
		if(IsE8cFrame())
		{
			for(var j = 0; j< Wan.IPv4BindLanList.length; j++)
			{
				if(Wan.IPv4BindLanList[j].indexOf("SSID") >= 0)
				{
					SsidWanBindInfo += Wan.IPv4BindLanList[j] + ",";
				}
			}
			SsidWanBindInfo = SsidWanBindInfo.substring(0, SsidWanBindInfo.length - 1);
			Wan.IPv4BindSsidList = SsidWanBindInfo.split(",");
		}
    }
    
    for (var i = 0; i < ElementIdList.length; i++)
    {
        var Id = ElementIdList[i];
        var Control = document.getElementById(Id);
        var Setter = new UserControlValueSetter(Id, Wan);
        Setter.SetValue();
  
    }
    
}


