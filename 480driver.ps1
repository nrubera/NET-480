Import-Module '480-utils' -Force
#call banner
480Banner
#$conf = Get-480Config -config_path = "./480.json"
480Connect -server "10.0.17.3"
Select-VM -folder "BASEVM"
cloner  -vmtoclone "awx.base"