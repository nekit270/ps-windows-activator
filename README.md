# ps-windows-activator
PowerShell Windows Activator - скрипт для активации Windows.

Для быстрой активации запустите quick-activation.bat.

Параметры командной строки:
<pre>
activate.exe [-ServerList <список KMS-серверов>] [-KeyList <список ключей>] [-Check] [-Help]

        -ServerList <список KMS-серверов>       Использовать указанный файл со списком KMS-серверов.
        -KeyList <список ключей>                Использовать указанный файл со списком ключей.
        -Check                                  Проверить, активирована ли Windows. Возвращает код выхода 0, если система активирована, и 1, если нет.
        -Help                                   Вывести это сообщение.
</pre>

В файле keys.txt содержатся ключи продукта для Windows 10, а в servers.txt - список KMS-серверов для активации.

###[Скачать](https://github.com/nekit270/ps-windows-activator/archive/refs/heads/main.zip)###
