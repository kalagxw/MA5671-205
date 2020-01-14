<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
 	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="Pragma" content="no-cache" />
  <title></title>
  <style type="text/css">
  </style>
 </head>
 <body>
 <br>
<p align="center">
<script language="JavaScript" type="text/javascript">
var Var_DefaultLang = '<%HW_WEB_GetCurrentLanguage();%>';
var Var_LastLoginLang = '<%HW_WEB_GetLoginRequestLangue();%>';
var Language = '';
if(Var_LastLoginLang == '')
{
	Language = Var_DefaultLang;
}
else
{
	Language = Var_LastLoginLang;
}
if(Language == 'english')
{
	document.write("Network connection interrupted. Check the upstream connection or contact your ISP to resolve the problem!");
}
else if(Language == 'japanese')
{
	document.write("ネットワーク接続が中断されました。この問題を解決するためにアップストリーム接続が正しいことを確認するか、インターネットサービスプロバイダに連絡してください!");
}
else if(Language == 'portuguese')
{
	document.write("Ligação à rede interrompida. Verifique a ligação ascendente ou contacte o seu fornecedor de serviços para resolver o problema!");
}
</script>	
</p>
 </body>
</html>
