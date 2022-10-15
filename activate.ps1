Param(
	[string] $ServerList,
	[string] $KeyList,
	[switch] $Check,
	[switch] $Help
)

if($Help.IsPresent -or (!$Check.IsPresent -and !$KeyList -and !$ServerList)){
	echo @"
Activate [-ServerList <������ KMS-��������>] [-KeyList <������ ������>] [-Check] [-Help]

������ ��� ��������� Windows � ������� ������ �� �������� ������ ��� KMS-��������.

	-ServerList <������ KMS-��������>       ������������ ��������� ���� �� ������� KMS-��������.
	-KeyList <������ ������>                ������������ ��������� ���� �� ������� ������.
	-Check                                  ���������, ������������ �� Windows. ���������� ��� ������ 0, ���� ������� ������������, � 1, ���� ���.
	-Help                                   ������� ��� ���������.
"@
	exit 0
}

if($Check.IsPresent){
	if((cscript.exe //nologo $env:windir\system32\slmgr.vbs /dli).Contains("��������� ��������: ����� ��������")){
		echo "Windows ������������."
		exit 0
	}else{
		echo "Windows �� ������������."
		exit 1
	}
}

if($ServerList){
	if((cscript.exe //nologo $env:windir\system32\slmgr.vbs /dli).Contains("��������� ��������: ����� ��������")){
		echo "Windows ��� ������������!"
		exit 1
	}
	$servers = Get-Content $ServerList -Encoding Default
	foreach($server in $servers){
		$ping = Test-Connection $server -Count 1 -Quiet
		if($ping){
			echo "������: $server"
			cscript.exe //nologo $env:windir\system32\slmgr.vbs /skms $server | Out-Null
			cscript.exe //nologo $env:windir\system32\slmgr.vbs /ato | Out-Null
			if($LASTEXITCODE -eq 0){
				echo "Windows ������������!"
				exit 0
			}
		}
	}
	echo "������� �� ������ �� ��������. ��������� ����������� � ��������� ��� ���������� ������������ ������ ������."
	exit 1
}

if($KeyList){
	if((cscript.exe //nologo $env:windir\system32\slmgr.vbs /dli).Contains("��������� ��������: ����� ��������")){
		echo "Windows ��� ������������!"
		exit 1
	}
	$keys = Get-Content $KeyList -Encoding Default
	foreach($key in $keys){
		echo "����: $key"
		cscript.exe //nologo $env:windir\system32\slmgr.vbs /ipk $key | Out-Null
		cscript.exe //nologo $env:windir\system32\slmgr.vbs /ato | Out-Null
		if($LASTEXITCODE -eq 0){
			echo "Windows ������������!"
			exit 0
		}
	}
	echo "����� �� ������ �� ��������. ���������� ������������ ������ ������."
	exit 1
}
