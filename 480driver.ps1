Import-Module '480-utils' -Force
#call banner
480Banner

#$conf = Get-480Config -config_path = "./480.json"
480Connect -server "10.0.17.3"
# Select-VM -folder "BASEVM"
# cloner  -vmtoclone "480-fw"

# new-switch -newSwitch "test2"
# get-NetInfo -VMname "480-dc1"
# turnOn -Name "blue1-fw.base"
set-network -VMName "blue1-fw.base" -Network "480-WAN"