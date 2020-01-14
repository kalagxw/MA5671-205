var gMonths=new Array(time_language['bbsp_January'],time_language['bbsp_February'],time_language['bbsp_March'],time_language['bbsp_April'],time_language['bbsp_May'],time_language['bbsp_June'],time_language['bbsp_July'],time_language['bbsp_August'],time_language['bbsp_September'],time_language['bbsp_October'],time_language['bbsp_November'],time_language['bbsp_December']);
var WeekDay=new Array(time_language['bbsp_Sunday'],time_language['bbsp_Monday'],time_language['bbsp_Tuesday'],time_language['bbsp_Wednesday'],time_language['bbsp_Thursday'],time_language['bbsp_Friday'],time_language['bbsp_Saturday']);
var strToday=time_language['bbsp_Today'];
var strYear=time_language['bbsp_Year'];
var strMonth=time_language['bbsp_Month'];
var strDay=time_language['bbsp_Day'];
var splitChar="-";
var startYear=2000;
var endYear=2050;
var dayTdHeight=12;
var dayTdTextSize=12;
var gcNotCurMonth="#E0E0E0";
var gcRestDay="#FF0000";
var gcWorkDay="#444444";
var gcMouseOver="#79D0FF";
var gcMouseOut="#F4F4F4";
var gcToday="#444444";
var gcTodayMouseOver="#6699FF";
var gcTodayMouseOut="#79D0FF";
var gdCtrl=new Object();
var goSelectTag=new Array();
var gdCurDate=new Date();
var giYear=gdCurDate.getFullYear();
var giMonth=gdCurDate.getMonth()+1;
var giDay=gdCurDate.getDate();
    function $(){
        var elements=new Array();
        for(var i=0;i<arguments.length;i++) {
            var element=arguments[i];
            if(typeof(arguments[i])=='string')
            {
                element=document.getElementById(arguments[i]);
            }
            if(arguments.length==1)
            {
                return element;
            }
            elements.Push(element);
        }
        return elements;
    }
    Array.prototype.Push=function(){
        var startLength=this.length;
        for(var i=0;i<arguments.length;i++){
            this[startLength+i]=arguments[i];
        }
        return this.length;
    }
    String.prototype.HexToDec=function(){
        return parseInt(this,16);
    }
    String.prototype.cleanBlank=function(){
        return this.isEmpty()?"":this.replace(/\s/g,"");
    }
    function checkColor(){
        var color_tmp=(arguments[0]+"").replace(/\s/g,"").toUpperCase();
        var model_tmp1=arguments[1].toUpperCase();
        var model_tmp2="rgb("+arguments[1].substring(1,3).HexToDec()+","+arguments[1].substring(1,3).HexToDec()+","+arguments[1].substring(5).HexToDec()+")";
        model_tmp2=model_tmp2.toUpperCase();
        if(color_tmp==model_tmp1 ||color_tmp==model_tmp2){
            return true;
        }
        return false;
    }
    function $V(){
        return document.getElementById(arguments[0]).value;
    }
    function fPopCalendar(evt,popCtrl,dateCtrl,offsetX){
        evt.cancelBubble=true;
        gdCtrl=dateCtrl;
        fSetYearMon(giYear,giMonth);
        var point=fGetXY(popCtrl);
        with(document.getElementById("calendardiv").style){
            if(document.all){			
                left=(point.x - offsetX+1)+"px";
                top=(point.y+popCtrl.offsetHeight+1)+"px";
            }else{
                left=(point.x - offsetX+1)+"px";
                top=(point.y+popCtrl.offsetHeight+1)+"px";
            }
            visibility='visible';zindex='99';position='absolute';}
            document.getElementById("calendardiv").focus();
    }
    function fSetDate(iYear,iMonth,iDay){
        var iMonthNew=new String(iMonth);
        var iDayNew=new String(iDay);
        if(iMonthNew.length<2){
            iMonthNew="0"+iMonthNew;
        }
        if(iDayNew.length<2){
            iDayNew="0"+iDayNew;
        }
        gdCtrl.value=iYear+splitChar+iMonthNew+splitChar+iDayNew;
        fHideCalendar();
    }
    function fHideCalendar(){
		document.getElementById("calendardiv").style.visibility="hidden";
        for(var i=0;i<goSelectTag.length;i++){
            goSelectTag[i].style.visibility="visible";
        }
        goSelectTag.length=0;
    }
    function fSetSelected(){
        var iOffset=0;var iYear=parseInt(document.getElementById("tbSelYear").value);
        var iMonth=parseInt(document.getElementById("tbSelMonth").value);
        var aCell=document.getElementById("cellText"+arguments[0]);
        aCell.bgColor=gcMouseOut;
        with(aCell){
            var iDay=parseInt(innerHTML);
            if(checkColor(style.color,gcNotCurMonth)){
                iOffset=(innerHTML>10)?-1:1;
            }
            iMonth+=iOffset;
            if(iMonth<1){
                iYear--;iMonth=12;
            }else if(iMonth>12){
                iYear++;iMonth=1;
            }
        }
        fSetDate(iYear,iMonth,iDay);
    }
    function Point(iX,iY){
        this.x=iX;this.y=iY;
    }
    function fBuildCal(iYear,iMonth){
        var aMonth=new Array();
        for(var i=1;i<7;i++){
            aMonth[i]=new Array(i);
        }
        var dCalDate=new Date(iYear,iMonth-1,1);
        var iDayOfFirst=dCalDate.getDay();
        var iDaysInMonth=new Date(iYear,iMonth,0).getDate();
        var iOffsetLast=new Date(iYear,iMonth-1,0).getDate()-iDayOfFirst+1;
        var iDate=1;var iNext=1;
        for(var d=0;d<7;d++){
            aMonth[1][d]=(d<iDayOfFirst)?(iOffsetLast+d)*(-1):iDate++;
        }
        for(var w=2;w<7;w++){
            for(var d=0;d<7;d++){
                aMonth[w][d]=(iDate<=iDaysInMonth)?iDate++:(iNext++)*(-1);
            }
        }
        return aMonth;
    }
    function fDrawCal(iYear,iMonth,iCellHeight,iDateTextSize){
        var colorTD=" bgcolor='"+gcMouseOut+"' bordercolor='"+gcMouseOut+"'";
        var styleTD=" valign='middle' align='center' style='height:"+iCellHeight+"px;font-weight:bolder;font-size:"+iDateTextSize+"px;";
        var dateCal="";dateCal+="<tr>";
        for(var i=0;i<7;i++){
            dateCal+="<td"+colorTD+styleTD+"color:#990099'>"+WeekDay[i]+"</td>";
        }
        dateCal+="</tr>";for(var w=1;w<7;w++){
            dateCal+="<tr>";
            for(var d=0;d<7;d++){
                var tmpid=w+""+d;dateCal+="<td"+styleTD+"cursor:pointer;' onclick='fSetSelected("+tmpid+")'>";
                dateCal+="<span id='cellText"+tmpid+"'></span>";dateCal+="</td>";
                }
                dateCal+="</tr>";}return dateCal;
     }
    function fUpdateCal(iYear,iMonth){
        var myMonth=fBuildCal(iYear,iMonth);
        var i=0;for(var w=1;w<7;w++){
            for(var d=0;d<7;d++){
                with(document.getElementById("cellText"+w+""+d)){
                    parentNode.bgColor=gcMouseOut;
                    parentNode.borderColor=gcMouseOut;
                    parentNode.onmouseover=function(){
                        this.bgColor=gcMouseOver;};
                        parentNode.onmouseout=function(){
                            this.bgColor=gcMouseOut;
                        };
                        if(myMonth[w][d]<0){
                            style.color=gcNotCurMonth;
                            innerHTML=Math.abs(myMonth[w][d]);
                        }else{
                            style.color=((d==0)||(d==6))?gcRestDay:gcWorkDay;
                            innerHTML=myMonth[w][d];
                            if(iYear==giYear && iMonth==giMonth && myMonth[w][d]==giDay){
                                style.color=gcToday;
                                parentNode.bgColor=gcTodayMouseOut;
                                parentNode.onmouseover=function(){
                                    this.bgColor=gcTodayMouseOver;
                                };
                                parentNode.onmouseout=function(){
                                    this.bgColor=gcTodayMouseOut;
                                };
                            }
                        }
                    }
                }
            }
        }
    
    
    function fSetYearMon(iYear,iMon){
		document.getElementById("tbSelMonth").options[iMon-1].selected=true;
        for(var i=0;i<document.getElementById("tbSelYear").length;i++){
            if(document.getElementById("tbSelYear").options[i].value==iYear){
                document.getElementById("tbSelYear").options[i].selected=true;
            }
        }
        fUpdateCal(iYear,iMon);
    }
    function fPrevMonth(){
        var iMon=document.getElementById("tbSelMonth").value;
        var iYear=document.getElementById("tbSelYear").value;
        if(--iMon<1){iMon=12;iYear--;}
        fSetYearMon(iYear,iMon);
    }
    function fNextMonth(){
        var iMon=document.getElementById("tbSelMonth").value;
        var iYear=document.getElementById("tbSelYear").value;
        if(++iMon>12){iMon=1;iYear++;}
        fSetYearMon(iYear,iMon);
    }
    function fGetXY(aTag){
        var oTmp=aTag;var pt=new Point(0,0);
        do{
            pt.x+=oTmp.offsetLeft;
            pt.y+=oTmp.offsetTop;
            oTmp=oTmp.offsetParent;
        }while(oTmp.tagName.toUpperCase()!="BODY");
        return pt;
    }
    function getDateDiv(){
        var noSelectForIE="";
        var noSelectForFireFox="";
        if(document.all){
            noSelectForIE="onselectstart='return false;'";
        }else{
            noSelectForFireFox="-moz-user-select:none;";
        }
        var dateDiv="";
        dateDiv+="<div id='calendardiv' onclick='event.cancelBubble=true' "+noSelectForIE+" style='"+noSelectForFireFox+"position:absolute;z-index:99;visibility:hidden;border:1px solid #999999;'>";
        dateDiv+="<table border='0' bgcolor='#E0E0E0' cellpadding='1' cellspacing='1' >";
        dateDiv+="<tr>";
        dateDiv+="<td><input type='button' id='PrevMonth' value='<' style='height:22px;width:20px;font-weight:bolder;padding-left: 2px;padding-top: 0px;' onclick='fPrevMonth()'>";
        dateDiv+="</td><td><select id='tbSelYear' style='border:1px solid;' onchange='fUpdateCal($V(\"tbSelYear\"),$V(\"tbSelMonth\"))'>";
        for(var i=startYear;i<endYear;i++){
            dateDiv+="<option value='"+i+"'>"+i+"</option>";}dateDiv+="</select></td><td>";
            dateDiv+="<select id='tbSelMonth' style='border:1px solid;' onchange='fUpdateCal($V(\"tbSelYear\"),$V(\"tbSelMonth\"))'>";
            for(var i=0;i<12;i++){
                dateDiv+="<option value='"+(i+1)+"'>"+gMonths[i]+"</option>";
            }
            dateDiv+="</select></td><td>";
            dateDiv+="<input type='button' id='NextMonth' value='>' style='height:22px;width:20px;font-weight:bolder;padding-left: 2px;padding-top: 0px;' onclick='fNextMonth()'>";
            dateDiv+="</td>";dateDiv+="</tr><tr>";
            dateDiv+="<td align='center' colspan='4'>";
            dateDiv+="<div style='background-color:#cccccc'><table width='100%' border='0' cellpadding='3' cellspacing='1'>";
            dateDiv+=fDrawCal(giYear,giMonth,dayTdHeight,dayTdTextSize);
            dateDiv+="</table></div>";dateDiv+="</td>";
            dateDiv+="</tr><tr><td align='center' colspan='4' nowrap>";
			if (top.curLanguage == "chinese")
			{
				dateDiv+="<span style='cursor:pointer;font-weight:bolder;' onclick='fSetDate(giYear,giMonth,giDay)' onmouseover='this.style.color=\""+gcMouseOver+"\"' onmouseout='this.style.color=\"#000000\"'>"+strToday+":"+giYear+strYear+giMonth+strMonth+giDay+strDay+"</span>";
			}
			else
			{
				dateDiv+="<span style='cursor:pointer;font-weight:bolder;' onclick='fSetDate(giYear,giMonth,giDay)' onmouseover='this.style.color=\""+gcMouseOver+"\"' onmouseout='this.style.color=\"#000000\"'>"+strToday+":"+giMonth+','+giDay+','+giYear+"</span>";
			}
            dateDiv+="</tr></tr>";
            dateDiv+="</table></div>";
            return dateDiv;
       }

   with(document){
    onclick=fHideCalendar;
    
    write(getDateDiv());
    bgColor = "#FFFFFF";
     
   }

