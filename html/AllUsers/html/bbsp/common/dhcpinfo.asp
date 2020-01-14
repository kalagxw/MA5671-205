
function checkLease(fieldPrompt,LeaseTime,Frag,resourceLangDes)
{
       var errmsg="";
       var field="";
       
       field=resourceLangDes[fieldPrompt];
       errmsg=new Array("bbsp_lease_invalid","bbsp_lease_num","bbsp_lease_outrange");
       
       if (LeaseTime == '')
       {
           AlertEx(field+resourceLangDes[errmsg[0]]);
           return false;
       }
   
      	if(!isInteger(LeaseTime) )
  		{
    	   AlertEx(field+resourceLangDes[errmsg[1]]);
           return false;
        }
   
        var lease=LeaseTime*Frag;
        if(lease<=0)
      	{
            AlertEx(field+resourceLangDes[errmsg[1]]);
            return false;
        }
   
        if((lease>604800*10))
      	{
      	    AlertEx(field+resourceLangDes[errmsg[2]]);
            return false;
      	}
      
        return true;
}

