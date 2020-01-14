function stSummaryInfo(contenttype, contentinfo, icontext)
{
	this.contenttype = contenttype;
	this.contentinfo = contentinfo;
	this.icontext = icontext;
}

function HWAppendTitle(TitleId, Titlestring, SummaryInfo, IsneedImg)
{
	var titlehtml = "";
	titlehtml +='<div id="' + TitleId + '" class="PageTitle">';

	var SummaryInfoStr = "";
	var ImgIndex = 0;
	if(true != IsneedImg)
	{
		SummaryInfoStr = SummaryInfo;
		titlehtml +='<div id="' + TitleId + '_content" class="PageTitle_content">' + SummaryInfoStr + '</div>';
	}
	else
	{	
		var SummaryLen = SummaryInfo.length - 1;
		var SummaryInfoPrevStr = "";
		var SummaryInfoEndStr = "";
		var SummaryImgStr="";
		for(var index = 0; index < SummaryLen; index++)
		{
			var type = SummaryInfo[index].contenttype;
			var content = SummaryInfo[index].contentinfo;
			if("img" != type)
			{
				SummaryInfoPrevStr += content;
			}
			else
			{
				ImgIndex = index;
				var icontextstring = '';
				SummaryImgStr +='<br><div class="divsummaryicon"><img class="summaryicon" src="' + content + '" /></div>';
				if(null != SummaryInfo[index].icontext || undefined != SummaryInfo[index].icontext)
				{
					var icontextstring = '<div class="divpageicontext"><span class="pageicontext">' + SummaryInfo[index].icontext + '</span></div>';
				}

				SummaryImgStr += icontextstring;
				break;
			}
		}
		
		for(var index = ImgIndex; index < SummaryLen; index++)
		{
			var type = SummaryInfo[index].contenttype;
			var content = SummaryInfo[index].contentinfo;
			if("img" != type)
			{
				SummaryInfoEndStr += content;
			}
		}
		
		titlehtml +='<div id="' + TitleId + '_content" class="PageTitle_content">';
		titlehtml +='<span class="pagetitlecontent_span">' + SummaryInfoPrevStr + '</span>';
		titlehtml += SummaryImgStr;
		titlehtml += '<span class="pagetitlecontent_span">' + SummaryInfoEndStr + '</span>';
		titlehtml += '</div>';	
	}
	
	titlehtml +='</div>';
	return titlehtml;
}

function CreateTableStartString(tableinfo)
{
	var StartDiv = '<div id="div' + tableinfo + '" class="configborder">';
	var StartTable ='<table id="' + tableinfo + '" width="100%" cellpadding="0" cellspacing="1" class="tabal_noborder_bg">';
	return StartDiv + StartTable;
}
