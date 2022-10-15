Param(
	[string] $ServerList,
	[string] $KeyList,
	[switch] $Check,
	[switch] $Help
)

if($Help.IsPresent -or (!$Check.IsPresent -and !$KeyList -and !$ServerList)){
	echo @"
Activate [-ServerList <список KMS-серверов>] [-KeyList <список ключей>] [-Check] [-Help]

Скрипт для активации Windows с помощью файлов со списками ключей или KMS-серверов.

	-ServerList <список KMS-серверов>       Использовать указанный файл со списком KMS-серверов.
	-KeyList <список ключей>                Использовать указанный файл со списком ключей.
	-Check                                  Проверить, активирована ли Windows. Возвращает код выхода 0, если система активирована, и 1, если нет.
	-Help                                   Вывести это сообщение.
"@
	exit 0
}

if($Check.IsPresent){
	if((cscript.exe //nologo $env:windir\system32\slmgr.vbs /dli).Contains("Состояние лицензии: имеет лицензию")){
		echo "Windows активирована."
		exit 0
	}else{
		echo "Windows не активирована."
		exit 1
	}
}

if($ServerList){
	if((cscript.exe //nologo $env:windir\system32\slmgr.vbs /dli).Contains("Состояние лицензии: имеет лицензию")){
		echo "Windows уже активирована!"
		exit 1
	}
	$servers = Get-Content $ServerList -Encoding Default
	foreach($server in $servers){
		$ping = Test-Connection $server -Count 1 -Quiet
		if($ping){
			echo "Сервер: $server"
			cscript.exe //nologo $env:windir\system32\slmgr.vbs /skms $server | Out-Null
			cscript.exe //nologo $env:windir\system32\slmgr.vbs /ato | Out-Null
			if($LASTEXITCODE -eq 0){
				echo "Windows активирована!"
				exit 0
			}
		}
	}
	echo "Сервера из списка не работают. Проверьте подключение к Интернету или попробуйте использовать другой список."
	exit 1
}

if($KeyList){
	if((cscript.exe //nologo $env:windir\system32\slmgr.vbs /dli).Contains("Состояние лицензии: имеет лицензию")){
		echo "Windows уже активирована!"
		exit 1
	}
	$keys = Get-Content $KeyList -Encoding Default
	foreach($key in $keys){
		echo "Ключ: $key"
		cscript.exe //nologo $env:windir\system32\slmgr.vbs /ipk $key | Out-Null
		cscript.exe //nologo $env:windir\system32\slmgr.vbs /ato | Out-Null
		if($LASTEXITCODE -eq 0){
			echo "Windows активирована!"
			exit 0
		}
	}
	echo "Ключи из списка не работают. Попробуйте использовать другой список."
	exit 1
}
