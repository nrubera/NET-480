function 480Banner ()
{
    Write-Host " 

_____/\\\\\\\\\\\____/\\\________/\\\_____/\\\\\\\\\\\____________________________/\\\________/\\\\\\\\\________/\\\\\\\____        
 ___/\\\/////////\\\_\///\\\____/\\\/____/\\\/////////\\\________________________/\\\\\______/\\\///////\\\____/\\\/////\\\__       
  __\//\\\______\///____\///\\\/\\\/_____\//\\\______\///_______________________/\\\/\\\_____\/\\\_____\/\\\___/\\\____\//\\\_      
   ___\////\\\_____________\///\\\/________\////\\\__________/\\\\\\\\\\\______/\\\/\/\\\_____\///\\\\\\\\\/___\/\\\_____\/\\\_     
    ______\////\\\____________\/\\\____________\////\\\______\///////////_____/\\\/__\/\\\______/\\\///////\\\__\/\\\_____\/\\\_    
     _________\////\\\_________\/\\\_______________\////\\\__________________/\\\\\\\\\\\\\\\\__/\\\______\//\\\_\/\\\_____\/\\\_   
      __/\\\______\//\\\________\/\\\________/\\\______\//\\\________________\///////////\\\//__\//\\\______/\\\__\//\\\____/\\\__  
       _\///\\\\\\\\\\\/_________\/\\\_______\///\\\\\\\\\\\/___________________________\/\\\_____\///\\\\\\\\\/____\///\\\\\\\/___ 
        ___\///////////___________\///__________\///////////_____________________________\///________\/////////________\///////_____
__/\\\________/\\\__/\\\\\\\\\\\\\\\__/\\\\\\\\\\\__/\\\_________________/\\\\\\\\\\\___                                            
 _\/\\\_______\/\\\_\///////\\\/////__\/////\\\///__\/\\\_______________/\\\/////////\\\_                                           
  _\/\\\_______\/\\\_______\/\\\___________\/\\\_____\/\\\______________\//\\\______\///__                                          
   _\/\\\_______\/\\\_______\/\\\___________\/\\\_____\/\\\_______________\////\\\_________                                         
    _\/\\\_______\/\\\_______\/\\\___________\/\\\_____\/\\\__________________\////\\\______                                        
     _\/\\\_______\/\\\_______\/\\\___________\/\\\_____\/\\\_____________________\////\\\___                                       
      _\//\\\______/\\\________\/\\\___________\/\\\_____\/\\\______________/\\\______\//\\\__                                      
       __\///\\\\\\\\\/_________\/\\\________/\\\\\\\\\\\_\/\\\\\\\\\\\\\\\_\///\\\\\\\\\\\/___                                     
        ____\/////////___________\///________\///////////__\///////////////____\///////////_____                                    

     "
}

Function 480Connect ([string] $server)
{
    $conn = $global:DefaultVIServer
    #are we already connected?
    if ($conn){
        $msg = "Already Connected to: {0}" -f $conn

        Write-Host -ForegroundColor Green $msg
    }else
    {
        $conn = Connect-VIServer -Server $server
    }

}

Function Get-480Config([string] $config_path)
{
    
    if(Test-Path $config_path)
    {
        $conf = (Get-Content -Raw -Path $config_path | ConvertFrom-Json)
        $msg = "Using Configuration at {0}" -f $config_path
        Write-Host -ForegroundColor "Green" $msg
    }else 
    {
        Write-Host -ForegroundColor "Yellow" "No Configuration"
    }
    return $conf
}

Function Select-VM ([string] $folder)
{
    $selected_vm=$null
    try {
        $vms = Get-VM -Location $folder
        $index = 1
        foreach($vm in $vms)
        {
            Write-Host [$index] $vm.Name
            $index+=1
        }
        $pick_index = Read-Host "Which index number [x] do you wish to pick"
        #480-TODO need to deal with an invalid index
        if ([int]$pick_index -gt $vms.Length - 1 || [int]$pick_index -lt 1){
            Write-Error "Invalid Option, try again"
        } else {
            $selected_vm = $vms[$pick_index -1]
        }
        Write-Host "You Picked " $selected_vm.Name
        #note this is a full on vm that we can interact with
        return $selected_vm
    }
    catch 
    {
        Write-Host "Invalid Folder: $folder" -ForegroundColor "Red"
    }
}

function cloner([string] $vmtoclone){

        $newname = Read-Host -Prompt 'Please enter the new name for the cloned VM'
        $snapname = Read-Host -Prompt 'Please state the name of the snapshot you wish to clone from'

    try {

    	$vm=get-vm -Name $vmtoclone
        $snapshot=get-snapshot -VM $vm -Name $snapname
        $vmhost=get-vmhost -Name "192.168.7.18"
        $ds=Get-Datastore -Name super8-datastore1

        $linkedName = "{0}.linked" -f $vm.Name
        $linkedVM = New-VM -LinkedClone -Name $linkedName -VM $vm -ReferenceSnapshot $snapshot -VMHost $vmhost -Datastore $ds

    	$newVM = New-VM -Name "$newname.base" -VM $linkedvm -VMHost $vmhost -Datastore $ds
    	$newVM | New-Snapshot -Name "Base"

        Remove-VM $linkedName

    } catch {
        Write-Host "An error occurred:"
        Write-Host $_
        exit
    }
}


