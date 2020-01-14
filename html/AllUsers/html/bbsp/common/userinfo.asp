var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';

function IsAdminUser()
{
    return (curUserType == sysUserType);
}