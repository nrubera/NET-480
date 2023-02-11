$vmtoclone = Read-Host -Prompt 'Please enter the name of the VM you want to clone'
$newname = Read-Host -Prompt 'Please enter the new name for the cloned VM'

function cloner($vmtoclone, $newname){
    try {
    	$vm=get-vm -name $vmtoclone
        $snapshot=get-snapshot -VM $vm -name "Base"
        $vmhost=get-vmhost -name "192.168.7.18"
        $ds=Get-Datastore -name super8-datastore1

        $linkedName = "{0}.linked" -f $vm.name
        $linkedVM = New-VM -LinkedClone -Name $linkedName -VM $vm -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $ds

    	$newVM = New-VM -name "$newname.base" -VM $linkedvm -VMHost $vmhost -Datastore $ds
    	$newVM | New-Snapshot -Name "Base"

	Remove-VM $linkedName
    } catch {
        Write-Host "An error occurred:"
        Write-Host $_
        exit
    }
}

try {
    Connect-VIServer -Server 10.0.17.3
    cloner $vmtoclone $newname
} catch {
    Write-Host "An error occurred:"
    Write-Host $_
    exit
}
