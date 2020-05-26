﻿$DefaultVMSize = "Standard_F2s"
$DefaultVMDisk = "Premium_LRS"
$DefaultOSImage = "2019-Datacenter"
$DefaultOSWSImage = "19h2-ent"

$AzureModule = Get-Module -ListAvailable Az.*
if ($AzureModule.Name -notlike "Az.*"){
Write-Host "Can't find Azure Module, installing module"
Install-Module Az -Force -Verbose -Scope CurrentUser
Import-Module Az -Verbose
}
else
{
Write-Host "Found Azure Module"
#Import-Module Az
}

############  LOGIN SECTION  #############
cls

if (Get-AzContext) {
    Write-Host "We have connection, start building!!" -ForegroundColor Green
    Get-Azcontext |fl
    $Title = "Task Menu"
$Caption = @"

1 - Continue with current login
2 - Reconnect to with different account Commerical Azure Account
3 - Reconnect to with different account Gov't Azure Account
Q - Quit
 
Select a choice:
"@
 
$coll = @()
#$coll = New-Object System.Collections.ObjectModel.Collection
 
$a = [System.Management.Automation.Host.ChoiceDescription]::new("&1 Current login")
$a | Add-Member -MemberType ScriptMethod -Name Invoke -Value {Write-Host "Good Luck with your lab!!" -ForegroundColor Green ; Return} -force
$a.HelpMessage = "Continue with IaaS GUI"
$coll+=$a
 
$b = [System.Management.Automation.Host.ChoiceDescription]::new("&2 Reconnect Commerical")
$b.HelpMessage = "Get top processes"
$b | Add-Member -MemberType ScriptMethod -Name Invoke -Value {Connect-AzAccount -Force -Verbose ; Return} -force
$coll+=$b
 
$c = [System.Management.Automation.Host.ChoiceDescription]::new("&3 Reconnect Gov't")
$c.HelpMessage = "Get disk information"
$c | Add-Member -MemberType ScriptMethod -Name Invoke -Value {Connect-AzAccount -Force -Environment AzureUSGovernment -Verbose ; Return} -force
$coll+=$c
 
$q = [System.Management.Automation.Host.ChoiceDescription]::new("&Quit")
$q | Add-Member -MemberType ScriptMethod -Name Invoke -Value {Write-Host "Have a nice day." -ForegroundColor Green | Exit-PSSession} -force
$q.HelpMessage = "Quit and exit"
$coll+=$q
 

$r = $host.ui.PromptForChoice($Title,$Caption,$coll,0)
$coll[$r].invoke() | Out-Host

  }
  else
  {
  Write-Host "No connection to Azure, Please login" -ForegroundColor Yellow
      $Title = "Task Menu"
$Caption = @"
1 - Connect to Commerical Azure Account
2 - Connect to Gov't Azure Accountt
Q - Quit
 
Select a choice:
"@
 
$coll = @()
#$coll = New-Object System.Collections.ObjectModel.Collection
 
$a = [System.Management.Automation.Host.ChoiceDescription]::new("&1 Login Azure")
$a | Add-Member -MemberType ScriptMethod -Name Invoke -Value {Connect-AzAccount -Verbose ; Return} -force
$a.HelpMessage = "Continue with IaaS GUI"
$coll+=$a
 
$b = [System.Management.Automation.Host.ChoiceDescription]::new("&2 Login US Gov't Azure")
$b.HelpMessage = "Get top processes"
$b | Add-Member -MemberType ScriptMethod -Name Invoke -Value {Connect-AzAccount -Environment AzureUSGovernment -Verbose ; Return} -force
$coll+=$b
 
$q = [System.Management.Automation.Host.ChoiceDescription]::new("&Quit")
$q | Add-Member -MemberType ScriptMethod -Name Invoke -Value {Write-Host "Have a nice day." -ForegroundColor Green | Exit-PSSession} -force
$q.HelpMessage = "Quit and exit"
$coll+=$q
 

$r = $host.ui.PromptForChoice($Title,$Caption,$coll,0)
$coll[$r].invoke() | Out-Host

  }

If ($coll[$r].Label -eq "&Quit"){
exit
}
############  END OF LOGIN ###############



# Add required assemblies
Add-Type -AssemblyName PresentationFramework, System.Drawing, System.Windows.Forms, WindowsFormsIntegration

#Push-Location (Split-Path $MyInvocation.MyCommand.Path)
split-path $SCRIPT:MyInvocation.MyCommand.Path -parent

$inputxml = @"
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        mc:Ignorable="d"
        Title="Azure Builder v1.4" Height="530.654" Width="1244.946">
    <Grid Margin="0,0,5,0.5">
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="0*"/>
            <ColumnDefinition Width="1112*"/>
            <ColumnDefinition Width="119*"/>
            <ColumnDefinition/>
        </Grid.ColumnDefinitions>
        <ComboBox x:Name="Subscription1" HorizontalAlignment="Left" Margin="120,21,0,0" VerticalAlignment="Top" Width="221" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <Label Content="Subscription" HorizontalAlignment="Left" Height="24" Margin="12,19,0,0" VerticalAlignment="Top" Width="80" Grid.Column="1" FontWeight="Bold"/>
        <Label Content="Domain Name" HorizontalAlignment="Left" Height="24" Margin="351,58,0,0" VerticalAlignment="Top" Width="105" Grid.Column="1" FontWeight="Bold"/>
        <Label Content="Resource Group" HorizontalAlignment="Left" Height="24" Margin="11,82,0,0" VerticalAlignment="Top" Width="99" Grid.Column="1" FontWeight="Bold"/>
        <Label Content="Prefix" HorizontalAlignment="Left" Height="24" Margin="11,111,0,0" VerticalAlignment="Top" Width="99" Grid.Column="1" FontWeight="Bold"/>
        <TextBox x:Name="Dname1" HorizontalAlignment="Left" Height="23" Margin="468,62,0,0" TextWrapping="Wrap" Text="my.customer.com" VerticalAlignment="Top" Width="150" UndoLimit="30" Grid.Column="1"/>
        <TextBox x:Name="resourcegroup1" HorizontalAlignment="Left" Height="23" Margin="122,86,0,0" TextWrapping="Wrap" Text="rgtestlab" VerticalAlignment="Top" Width="132" UndoLimit="20" Grid.Column="1"/>
        <TextBox x:Name="prefix1" HorizontalAlignment="Left" Height="23" Margin="122,115,0,0" TextWrapping="Wrap" Text="ehu" VerticalAlignment="Top" Width="132" UndoLimit="3" Grid.Column="1"/>
        <Label Content="Locations" HorizontalAlignment="Left" Height="24" Margin="357,21,0,0" VerticalAlignment="Top" Width="80" Grid.Column="1" FontWeight="Bold"/>
        <ComboBox x:Name="Locations1" HorizontalAlignment="Left" Margin="443,23,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <Button x:Name="Exit1" Content="Exit" HorizontalAlignment="Left" Margin="27.333,418,0,0" VerticalAlignment="Top" Width="76" IsCancel="True" Grid.Column="2" Height="20"/>
        <Button x:Name="Build1" Content="Build" Grid.Column="2" HorizontalAlignment="Left" Margin="26.333,377,0,0" VerticalAlignment="Top" Width="76" Height="20"/>
        <Label Content="Storage Account" HorizontalAlignment="Left" Height="24" Margin="11,54,0,0" VerticalAlignment="Top" Width="99" Grid.Column="1" FontWeight="Bold"/>
        <TextBox x:Name="saname1" HorizontalAlignment="Left" Height="23" Margin="122,58,0,0" TextWrapping="Wrap" Text="saname" VerticalAlignment="Top" Width="132" UndoLimit="20" Grid.Column="1"/>
        <PasswordBox x:Name="adminpassword1" HorizontalAlignment="Left" Margin="468,127,0,0" VerticalAlignment="Top" Width="150" Height="18" Grid.Column="1"/>
        <Label Content="Admin Password" HorizontalAlignment="Left" Height="24" Margin="351,121,0,0" VerticalAlignment="Top" Width="105" Grid.Column="1" FontWeight="Bold"/>
        <TextBox x:Name="adminaccount1" HorizontalAlignment="Left" Height="23" Margin="468,96,0,0" TextWrapping="Wrap" Text="xadmin" VerticalAlignment="Top" Width="150" UndoLimit="30" Grid.Column="1"/>
        <Label Content="Admin Account" HorizontalAlignment="Left" Height="24" Margin="351,92,0,0" VerticalAlignment="Top" Width="105" Grid.Column="1" FontWeight="Bold"/>
        <Label Content="AddressPreFix" HorizontalAlignment="Left" Height="24" Margin="10,153,0,0" VerticalAlignment="Top" Width="99" Grid.Column="1" FontWeight="Bold"/>
        <TextBox x:Name="addressprefix1" HorizontalAlignment="Left" Height="23" Margin="122,153,0,0" TextWrapping="Wrap" Text="10.1.0.0/16" VerticalAlignment="Top" Width="132" UndoLimit="20" Grid.Column="1"/>
        <Label Content="AddressSubnet" HorizontalAlignment="Left" Height="24" Margin="10,188,0,0" VerticalAlignment="Top" Width="99" Grid.Column="1" FontWeight="Bold"/>
        <TextBox x:Name="addresssubnet1" HorizontalAlignment="Left" Height="23" Margin="122,192,0,0" TextWrapping="Wrap" Text="10.1.1.0/24" VerticalAlignment="Top" Width="132" UndoLimit="20" Grid.Column="1"/>
        <Label Content="SubnetName" HorizontalAlignment="Left" Height="24" Margin="351,148,0,0" VerticalAlignment="Top" Width="106" Grid.Column="1" FontWeight="Bold"/>
        <TextBox x:Name="subnetName1" HorizontalAlignment="Left" Height="23" Margin="468,152,0,0" TextWrapping="Wrap" Text="Servers" VerticalAlignment="Top" Width="150" UndoLimit="20" Grid.Column="1"/>
        <CheckBox x:Name="server1" Grid.ColumnSpan="2" Content="DC/CA" HorizontalAlignment="Left" Margin="12,259,0,0" VerticalAlignment="Top" IsChecked="True" IsEnabled="False" Height="16" Width="62" FontWeight="Bold"/>
        <Label Content="Server Name" HorizontalAlignment="Left" Margin="115,227,0,0" VerticalAlignment="Top" Height="27" Width="81" FontWeight="Bold" RenderTransformOrigin="-0.313,-2.291" Grid.Column="1"/>
        <Label Content="Server Private IP" HorizontalAlignment="Left" Margin="237,227,0,0" VerticalAlignment="Top" Height="27" Width="114" FontWeight="Bold" RenderTransformOrigin="-0.313,-2.291" Grid.Column="1"/>
        <Label Content="Server Role" HorizontalAlignment="Left" Margin="357,227,0,0" VerticalAlignment="Top" Height="27" Width="114" FontWeight="Bold" RenderTransformOrigin="-0.313,-2.291" Grid.Column="1"/>
        <Label Grid.ColumnSpan="2" Content="Build" HorizontalAlignment="Left" Margin="12,227,0,0" VerticalAlignment="Top" Height="27" Width="81" FontWeight="Bold" RenderTransformOrigin="-0.313,-2.291"/>
        <TextBox x:Name="Server1Name" HorizontalAlignment="Left" Height="23" Margin="115,256,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="105" Text="DC" Grid.Column="1"/>
        <TextBox x:Name="server1IP" HorizontalAlignment="Left" Height="23" Margin="237,254,0,0" TextWrapping="Wrap" Text="10.1.1.9" VerticalAlignment="Top" Width="105" Grid.Column="1"/>
        <ComboBox x:Name="Server1Role" HorizontalAlignment="Left" Margin="351,254,0,0" VerticalAlignment="Top" Width="120" IsReadOnly="True" SelectedIndex="0" IsEnabled="False" Height="22" Grid.Column="1">
            <Button Content="DC" IsDefault="True"/>
            <Button Content="ADFS"/>
            <Button Content="Domain Join"/>
        </ComboBox>
        <CheckBox x:Name="ADFS" Grid.ColumnSpan="2" Content="ADFS" HorizontalAlignment="Left" Margin="12,287,0,0" VerticalAlignment="Top" Height="16" Width="62" FontWeight="Bold"/>
        <TextBox x:Name="ADFSName" HorizontalAlignment="Left" Height="23" Margin="115,284,0,0" TextWrapping="Wrap" Text="ADFS" VerticalAlignment="Top" Width="105" Grid.Column="1"/>
        <TextBox x:Name="ADFSIP" HorizontalAlignment="Left" Height="23" Margin="237,282,0,0" TextWrapping="Wrap" Text="10.1.1.10" VerticalAlignment="Top" Width="105" Grid.Column="1"/>
        <ComboBox x:Name="ADFSRole" HorizontalAlignment="Left" Margin="351,282,0,0" VerticalAlignment="Top" Width="120" IsReadOnly="True" SelectedIndex="0" Height="22" IsEnabled="False" Grid.Column="1">
            <Button Content="ADFS"/>
        </ComboBox>
        <CheckBox x:Name="SCCM" Grid.ColumnSpan="2" Content="SCCM" HorizontalAlignment="Left" Margin="12,312,0,0" VerticalAlignment="Top" Height="16" Width="62" FontWeight="Bold"/>
        <TextBox x:Name="sccm_ps_name" HorizontalAlignment="Left" Height="23" Margin="115,309,0,0" TextWrapping="Wrap" Text="CMPS" VerticalAlignment="Top" Width="105" Grid.Column="1"/>
        <TextBox x:Name="sccm_ps_ip" HorizontalAlignment="Left" Height="23" Margin="237,307,0,0" TextWrapping="Wrap" Text="10.1.1.11" VerticalAlignment="Top" Width="105" Grid.Column="1"/>
        <ComboBox x:Name="sccmRole" HorizontalAlignment="Left" Margin="351,307,0,0" VerticalAlignment="Top" Width="120" IsReadOnly="True" SelectedIndex="0" Height="22" IsEnabled="False" Grid.Column="1">
            <Button Content="SCCM"/>
        </ComboBox>
        <CheckBox x:Name="sharepoint" Grid.ColumnSpan="2" Content="SharePoint" HorizontalAlignment="Left" Margin="12,365,0,0" VerticalAlignment="Top" Height="16" Width="81" FontWeight="Bold" IsEnabled="False"/>
        <TextBox x:Name="sharepointName" HorizontalAlignment="Left" Height="23" Margin="114,362,0,0" TextWrapping="Wrap" Text="SP" VerticalAlignment="Top" Width="105" Grid.Column="1"/>
        <TextBox x:Name="sharepointIP" HorizontalAlignment="Left" Height="23" Margin="236,360,0,0" TextWrapping="Wrap" Text="10.1.1.13" VerticalAlignment="Top" Width="105" Grid.Column="1"/>
        <ComboBox x:Name="sharepointRole" HorizontalAlignment="Left" Margin="350,360,0,0" VerticalAlignment="Top" Width="120" IsReadOnly="True" SelectedIndex="0" Height="22" IsEnabled="False" Grid.Column="1">
            <Button Content="SP"/>
        </ComboBox>
        <CheckBox x:Name="server5" Grid.ColumnSpan="2" Content="Server" HorizontalAlignment="Left" Margin="12,393,0,0" VerticalAlignment="Top" Height="16" Width="62" FontWeight="Bold"/>
        <TextBox x:Name="Server5Name" HorizontalAlignment="Left" Height="23" Margin="114,390,0,0" TextWrapping="Wrap" Text="ServerName" VerticalAlignment="Top" Width="105" Grid.Column="1"/>
        <TextBox x:Name="server5IP" HorizontalAlignment="Left" Height="23" Margin="236,388,0,0" TextWrapping="Wrap" Text="10.1.1.14" VerticalAlignment="Top" Width="105" Grid.Column="1"/>
        <ComboBox x:Name="Server5Role" HorizontalAlignment="Left" Margin="350,388,0,0" VerticalAlignment="Top" Width="120" IsReadOnly="True" SelectedIndex="0" Height="22" IsEnabled="False" Grid.Column="1">
            <Button Content="JoinDomain"/>
        </ComboBox>
        <CheckBox x:Name="workstation" Grid.ColumnSpan="2" Content="Workstation" HorizontalAlignment="Left" Margin="12,420,0,0" VerticalAlignment="Top" Height="16" Width="85" FontWeight="Bold"/>
        <TextBox x:Name="workstationName" HorizontalAlignment="Left" Height="23" Margin="114,417,0,0" TextWrapping="Wrap" Text="Win10" VerticalAlignment="Top" Width="105" Grid.Column="1"/>
        <TextBox x:Name="workstationIP" HorizontalAlignment="Left" Height="23" Margin="236,415,0,0" TextWrapping="Wrap" Text="10.1.1.15" VerticalAlignment="Top" Width="105" Grid.Column="1"/>
        <ComboBox x:Name="workstationRole" HorizontalAlignment="Left" Margin="350,415,0,0" VerticalAlignment="Top" Width="120" IsReadOnly="True" SelectedIndex="0" Height="22" IsEnabled="False" Grid.Column="1">
            <Button Content="JoinDomain"/>
        </ComboBox>
        <ComboBox x:Name="server1image" HorizontalAlignment="Left" Margin="481,254,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <ComboBox x:Name="ADFSimage" HorizontalAlignment="Left" Margin="481,280,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <ComboBox x:Name="sccmimageoffer" HorizontalAlignment="Left" Margin="481,307,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <ComboBox x:Name="sharepointimage" HorizontalAlignment="Left" Margin="480,362,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <ComboBox x:Name="server5image" HorizontalAlignment="Left" Margin="480,388,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <ComboBox x:Name="workstationimage" HorizontalAlignment="Left" Margin="480,415,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <Label Content="Image" HorizontalAlignment="Left" Margin="533,227,0,0" VerticalAlignment="Top" Height="27" Width="60" FontWeight="Bold" RenderTransformOrigin="-0.313,-2.291" Grid.Column="1"/>
        <TextBox x:Name="sccm_dp_name" HorizontalAlignment="Left" Height="23" Margin="114,335,0,0" TextWrapping="Wrap" Text="MPDP" VerticalAlignment="Top" Width="105" Grid.Column="1"/>
        <TextBox x:Name="sccm_dp_ip" HorizontalAlignment="Left" Height="23" Margin="236,333,0,0" TextWrapping="Wrap" Text="10.1.1.12" VerticalAlignment="Top" Width="105" Grid.Column="1"/>
        <ComboBox x:Name="sccmimagesku" HorizontalAlignment="Left" Margin="636,307,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <Label Content="SQL Edition" HorizontalAlignment="Left" Margin="678,227,0,0" VerticalAlignment="Top" Height="27" Width="74" FontWeight="Bold" RenderTransformOrigin="-0.313,-2.291" Grid.Column="1"/>
        <ComboBox x:Name="sccmdpimage" HorizontalAlignment="Left" Margin="481,334,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <ComboBox x:Name="sccmdp" HorizontalAlignment="Left" Margin="351,333,0,0" VerticalAlignment="Top" Width="120" IsReadOnly="True" SelectedIndex="0" Height="22" IsEnabled="False" Grid.Column="1">
            <Button Content="DPMP"/>
        </ComboBox>
        <CheckBox x:Name="STIGs" Content="" HorizontalAlignment="Left" Margin="735,27,0,0" VerticalAlignment="Top" IsChecked="True" Height="16" Width="34" Grid.Column="1" FontWeight="Bold"/>
        <Label Content="Import STIG GPOs" HorizontalAlignment="Left" Height="24" Margin="614,21,0,0" VerticalAlignment="Top" Width="115" Grid.Column="1" FontWeight="Bold"/>
        <Label Content="1" Grid.Column="1" HorizontalAlignment="Left" Margin="88,12,0,0" VerticalAlignment="Top" Width="23" FontSize="20" FontWeight="Bold" Background="#FFFCFCFC" Foreground="Red" Height="36"/>
        <Label Content="2" Grid.Column="1" HorizontalAlignment="Left" Margin="415,13,0,0" VerticalAlignment="Top" Width="23" FontSize="20" FontWeight="Bold" Background="#FFFCFCFC" Foreground="Red" Height="36"/>
        <Label Content="3" Grid.Column="1" HorizontalAlignment="Left" Margin="626,118,0,0" VerticalAlignment="Top" Width="23" FontSize="20" FontWeight="Bold" Background="#FFFCFCFC" Foreground="Red" Height="33" RenderTransformOrigin="-0.587,0.583"/>
        <Label Content="https://github.com/chlaplan/IaaS-Builder" Grid.Column="1" HorizontalAlignment="Left" Margin="10,468,0,0" VerticalAlignment="Top" FontStyle="Italic" FontFamily="Segoe UI Black" Height="26" Width="257"/>
        <Label Content="VMSize" HorizontalAlignment="Left" Margin="840,227,0,0" VerticalAlignment="Top" Height="27" Width="55" FontWeight="Bold" RenderTransformOrigin="-0.313,-2.291" Grid.Column="1"/>
        <Label Content="Disk Type" HorizontalAlignment="Left" Margin="987,227,0,0" VerticalAlignment="Top" Height="27" Width="69" FontWeight="Bold" RenderTransformOrigin="-0.313,-2.291" Grid.Column="1"/>
        <ComboBox x:Name="server1vmsize" HorizontalAlignment="Left" Margin="789,254,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <ComboBox x:Name="adfssize" HorizontalAlignment="Left" Margin="789,280,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <ComboBox x:Name="sscm_ps_size" HorizontalAlignment="Left" Margin="789,306,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <ComboBox x:Name="sccm_mpdp_size" HorizontalAlignment="Left" Margin="789,332,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <ComboBox x:Name="sharepoint_size" HorizontalAlignment="Left" Margin="789,359,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <ComboBox x:Name="server5size" HorizontalAlignment="Left" Margin="789,385,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <ComboBox x:Name="workstationsize" HorizontalAlignment="Left" Margin="789,412,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <ComboBox x:Name="server1disk" HorizontalAlignment="Left" Margin="948,254,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <ComboBox x:Name="adfsdisk" HorizontalAlignment="Left" Margin="948,280,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <ComboBox x:Name="sccm_ps_disk" HorizontalAlignment="Left" Margin="948,306,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <ComboBox x:Name="sccm_mpdp_disk" HorizontalAlignment="Left" Margin="948,332,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <ComboBox x:Name="sharepoint_disk" HorizontalAlignment="Left" Margin="948,359,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <ComboBox x:Name="server5disk" HorizontalAlignment="Left" Margin="948,385,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>
        <ComboBox x:Name="workstationdisk" HorizontalAlignment="Left" Margin="948,412,0,0" VerticalAlignment="Top" Width="150" IsReadOnly="True" RenderTransformOrigin="-0.025,-1.516" Height="22" Grid.Column="1">
            <MenuItem/>
        </ComboBox>

    </Grid>
</Window>
"@


$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML

#$syncHash = [hashtable]::Synchronized(@{})
$reader=(New-Object System.Xml.XmlNodeReader $xaml)

try{
    $Form=[Windows.Markup.XamlReader]::Load( $reader )
    }
catch{
    Write-Warning "Unable to parse XML, with error: $($Error[0])`n Ensure that there are NO SelectionChanged or TextChanged properties (PowerShell cannot process them)"
    throw
    }

#===========================================================================
# Load XAML Objects In PowerShell
#===========================================================================
  
$xaml.SelectNodes("//*[@Name]") | %{"";
    try {Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop}
    catch{throw}
    }
 
Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
get-variable WPF*
}
 
$formvar = Get-FormVariables



#===========================================================================
# Use this space to add code to the various form elements in your GUI
#===========================================================================
                                                                    
     
#Reference 
 
#Adding items to a dropdown/combo box
#$vmpicklistView.items.Add([pscustomobject]@{'VMName'=($_).Name;Status=$_.Status;Other="Yes"})
     
#Setting the text of a text box to the current PC name    
#$WPFtextBox.Text = $env:COMPUTERNAME
     
#Adding code to a button, so that when clicked, it pings a system
# $WPFbutton.Add_Click({ Test-connection -count 1 -ComputerName $WPFtextBox.Text  @southcom.onmicrosoft.com
# })

#  Azure API Testing
#$ResHeaders = @{'authorization' = $authenticationResult.CreateAuthorizationHeader()}
#$header = @{Authorization = 'Bearer' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($con.TokenCache.CacheData)")) }
#$header = @{Authorization = 'Bearer' + $con2.Context.TokenCache.CacheData}
#$Header = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($AzureDevOpsPAT)")) }

# Add current Azure connection
  if (Get-AzContext) {
    Write-Host "We have connection, start building!!" -ForegroundColor Green
    $Sub = Get-AzSubscription | select "Name"
    $Locations = Get-AzLocation

    foreach($Subs in $Sub){
        $WPFSubscription1.AddChild($Subs.Name)
        }

    foreach($Location in $Locations){
        $WPFLocations1.AddChild($Location.DisplayName)
        }
  }
  else
  {
  Write-Host "No connection to Azure, Please login" -ForegroundColor Yellow
  }


# Query VMSize and IMages After Location is Selected

$WPFLocations1.Add_SelectionChanged({

#$vmsize = Get-AzVMSize -Location $WPFLocations1.SelectedItem | Where Name -Like "*f2s*"
$vmsize = Get-AzComputeResourceSku | Where-Object {$_.Locations -eq ($WPFLocations1.SelectedItem) -and $_.Restrictions.ReasonCode -ne 'NotAvailableForSubscription' -and $_.ResourceType.Contains("virtualMachines")}

$SQLoffers = Get-AzVMImageOffer -Location $WPFLocations1.SelectedItem -PublisherName "MicrosoftSQLServer" | Select offer
$serverskus = Get-AzVMImageSku -Location $WPFLocations1.SelectedItem -Offer "WindowsServer" -PublisherName "MicrosoftWindowsServer" | Select Skus    
$clientskus = Get-AzVMImageSku -Location $WPFLocations1.SelectedItem -Offer "Windows-10" -PublisherName "MicrosoftWindowsDesktop" | Select Skus

$WPFserver1disk.AddChild($DefaultVMDisk)
$WPFadfsdisk.AddChild($DefaultVMDisk)
$WPFsccm_ps_disk.AddChild($DefaultVMDisk)
$WPFsccm_mpdp_disk.AddChild($DefaultVMDisk)
$WPFsharepoint_disk.AddChild($DefaultVMDisk)
$WPFserver5disk.AddChild($DefaultVMDisk)
$WPFworkstationdisk.AddChild($DefaultVMDisk)
   
    #############Load VMSize and Select Default#############
    Write-Host "Loading VMsizes and Disk information" -ForegroundColor Green

    $WPFserver1vmsize.items.Clear()
        Foreach ($Size in $vmsize){
    $WPFserver1vmsize.AddChild($size.Name)
    }
    $WPFserver1vmsize.SelectedItem = $DefaultVMSize
    $WPFserver1disk.SelectedItem = $DefaultVMDisk
    
    $WPFadfssize.items.Clear()    
        Foreach ($Size in $vmsize){
    $WPFadfssize.AddChild($size.Name)
    }
    $WPFadfssize.SelectedItem = $DefaultVMSize
    $WPFadfsdisk.SelectedItem = $DefaultVMDisk
    
    $WPFsscm_ps_size.items.Clear()
        Foreach ($Size in $vmsize){
    $WPFsscm_ps_size.AddChild($size.Name)
    }
    $WPFsscm_ps_size.SelectedItem = $DefaultVMSize
    $WPFsccm_ps_disk.SelectedItem = $DefaultVMDisk

    $WPFsccm_mpdp_size.items.Clear()
        Foreach ($Size in $vmsize){
    $WPFsccm_mpdp_size.AddChild($size.Name)
    }
    $WPFsccm_mpdp_size.SelectedItem = $DefaultVMSize
    $WPFsccm_mpdp_disk.SelectedItem = $DefaultVMDisk
    
    $WPFsharepoint_size.items.Clear()
        Foreach ($Size in $vmsize){
    $WPFsharepoint_size.AddChild($size.Name)
    }
    $WPFsharepoint_size.SelectedItem = $DefaultVMSize
    $WPFsharepoint_disk.SelectedItem = $DefaultVMDisk

    $WPFserver5size.items.Clear()
            Foreach ($Size in $vmsize){
    $WPFserver5size.AddChild($size.Name)
    }
    $WPFserver5size.SelectedItem = $DefaultVMSize
    $WPFserver5disk.SelectedItem = $DefaultVMDisk

    $WPFworkstationsize.items.Clear()
            Foreach ($Size in $vmsize){
    $WPFworkstationsize.AddChild($size.Name)
    }
    $WPFworkstationsize.SelectedItem = $DefaultVMSize
    $WPFworkstationdisk.SelectedItem = $DefaultVMDisk
    
    #############Load Images and Select Default#############
    Write-Host "Loading Images and SKUs" -ForegroundColor Green

    $WPFserver1image.Items.Clear()
    Foreach ($serversku in $serverskus){
    $WPFserver1image.AddChild($serversku.skus)
    }
    $WPFserver1image.SelectedItem = "$DefaultOSImage"

    $WPFADFSimage.Items.Clear()
        Foreach ($serversku in $serverskus){
    $WPFADFSimage.AddChild($serversku.skus)   
    }
    $WPFADFSimage.SelectedItem = "$DefaultOSImage"

    $WPFsccmimageoffer.Items.Clear()
        Foreach ($SQLoffer in $SQLoffers){
    $WPFsccmimageoffer.AddChild($SQLoffer.offer)
    }
    $WPFsccmimageoffer.SelectedItem = "sql2019-ws2019"
    
    $SQLSkus = Get-AzVMImageSku -Location $WPFLocations1.SelectedItem -Offer $WPFsccmimageoffer.SelectedItem -PublisherName "MicrosoftSQLServer" | Select Skus

    $WPFsccmimagesku.Items.Clear()
        Foreach ($SQLsku in $SQLskus){
    $WPFsccmimagesku.AddChild($SQLsku.skus)
    }
    $WPFsccmimagesku.SelectedItem = "standard"

    $WPFsccmdpimage.Items.Clear()
        Foreach ($serversku in $serverskus){
    $WPFsccmdpimage.AddChild($serversku.skus)
    }
    $WPFsccmdpimage.SelectedItem = "$DefaultOSImage"

    $WPFsharepointimage.Items.Clear()
        Foreach ($serversku in $serverskus){
    $WPFsharepointimage.AddChild($serversku.skus)
    }
    $WPFsharepointimage.SelectedItem = "$DefaultOSImage"

    $WPFserver5image.Items.Clear()
        Foreach ($serversku in $serverskus){
    $WPFserver5image.AddChild($serversku.skus)
    }
    $WPFserver5image.SelectedItem = "$DefaultOSImage"

    $WPFworkstationimage.Items.Clear()
    Foreach ($clientsku in $clientskus){
    $WPFworkstationimage.AddChild($clientsku.skus)
    }
    $WPFworkstationimage.SelectedItem = "$DefaultOSWSImage"
})

#######   Query Disk type Premium_LRS or Standard_LRS  ##########
$WPFserver1vmsize.Add_SelectionChanged({
$WPFserver1disk.Items.Clear()
$diskinfo = Get-AzComputeResourceSku | Where-Object {$_.Locations -eq ($WPFLocations1.SelectedItem) -and $_.Name.Contains($WPFserver1vmsize.SelectedItem) -and $_.ResourceType.Contains("virtualMachines")} | Select -ExpandProperty Capabilities

if($diskinfo[7].Value -eq $True){
$WPFserver1disk.AddChild("Premium_LRS")
$WPFserver1disk.SelectedItem = "Premium_LRS"
}
else
{
$WPFserver1disk.AddChild("Standard_LRS")
$WPFserver1disk.SelectedItem = "Standard_LRS"
}
})

$WPFadfssize.Add_SelectionChanged({
$WPFadfsdisk.Items.Clear()
$diskinfo = Get-AzComputeResourceSku | Where-Object {$_.Locations -eq ($WPFLocations1.SelectedItem) -and $_.Name.Contains($WPFserver1vmsize.SelectedItem) -and $_.ResourceType.Contains("virtualMachines")} | Select -ExpandProperty Capabilities

if($diskinfo[7].Value -eq $True){
$WPFadfsdisk.AddChild("Premium_LRS")
$WPFadfsdisk.SelectedItem = "Premium_LRS"
}
else
{
$WPFadfsdisk.AddChild("Standard_LRS")
$WPFadfsdisk.SelectedItem = "Standard_LRS"
}
})

$WPFsscm_ps_size.Add_SelectionChanged({
$WPFsccm_ps_disk.Items.Clear()
$diskinfo = Get-AzComputeResourceSku | Where-Object {$_.Locations -eq ($WPFLocations1.SelectedItem) -and $_.Name.Contains($WPFserver1vmsize.SelectedItem) -and $_.ResourceType.Contains("virtualMachines")} | Select -ExpandProperty Capabilities

if($diskinfo[7].Value -eq $True){
$WPFsccm_ps_disk.AddChild("Premium_LRS")
$WPFsccm_ps_disk.SelectedItem = "Premium_LRS"
}
else
{
$WPFsccm_ps_disk.AddChild("Standard_LRS")
$WPFsccm_ps_disk.SelectedItem = "Standard_LRS"
}
})

$WPFsccm_mpdp_size.Add_SelectionChanged({
$WPFsccm_mpdp_disk.Items.Clear()
$diskinfo = Get-AzComputeResourceSku | Where-Object {$_.Locations -eq ($WPFLocations1.SelectedItem) -and $_.Name.Contains($WPFserver1vmsize.SelectedItem) -and $_.ResourceType.Contains("virtualMachines")} | Select -ExpandProperty Capabilities

if($diskinfo[7].Value -eq $True){
$WPFsccm_mpdp_disk.AddChild("Premium_LRS")
$WPFsccm_mpdp_disk.SelectedItem = "Premium_LRS"
}
else
{
$WPFsccm_mpdp_disk.AddChild("Standard_LRS")
$WPFsccm_mpdp_disk.SelectedItem = "Standard_LRS"
}
})

$WPFsharepoint_size.Add_SelectionChanged({
$WPFsharepoint_disk.Items.Clear()
$diskinfo = Get-AzComputeResourceSku | Where-Object {$_.Locations -eq ($WPFLocations1.SelectedItem) -and $_.Name.Contains($WPFserver1vmsize.SelectedItem) -and $_.ResourceType.Contains("virtualMachines")} | Select -ExpandProperty Capabilities

if($diskinfo[7].Value -eq $True){
$WPFsharepoint_disk.AddChild("Premium_LRS")
$WPFsharepoint_disk.SelectedItem = "Premium_LRS"
}
else
{
$WPFsharepoint_disk.AddChild("Standard_LRS")
$WPFsharepoint_disk.SelectedItem = "Standard_LRS"
}
})

$WPFserver5size.Add_SelectionChanged({
$WPFserver5disk.Items.Clear()
$diskinfo = Get-AzComputeResourceSku | Where-Object {$_.Locations -eq ($WPFLocations1.SelectedItem) -and $_.Name.Contains($WPFserver1vmsize.SelectedItem) -and $_.ResourceType.Contains("virtualMachines")} | Select -ExpandProperty Capabilities

if($diskinfo[7].Value -eq $True){
$WPFserver5disk.AddChild("Premium_LRS")
$WPFserver5disk.SelectedItem = "Premium_LRS"
}
else
{
$WPFserver5disk.AddChild("Standard_LRS")
$WPFserver5disk.SelectedItem = "Standard_LRS"
}
})

$WPFworkstationsize.Add_SelectionChanged({
$WPFworkstationdisk.Items.Clear()
$diskinfo = Get-AzComputeResourceSku | Where-Object {$_.Locations -eq ($WPFLocations1.SelectedItem) -and $_.Name.Contains($WPFserver1vmsize.SelectedItem) -and $_.ResourceType.Contains("virtualMachines")} | Select -ExpandProperty Capabilities

if($diskinfo[7].Value -eq $True){
$WPFworkstationdisk.AddChild("Premium_LRS")
$WPFworkstationdisk.SelectedItem = "Premium_LRS"
}
else
{
$WPFworkstationdisk.AddChild("Standard_LRS")
$WPFworkstationdisk.SelectedItem = "Standard_LRS"
}
})

#####  SCCM Image offer query   #####
$WPFsccmimageoffer.Add_SelectionChanged({
$WPFsccmimagesku.Items.Clear()

$SQLSkus = Get-AzVMImageSku -Location $WPFLocations1.SelectedItem -Offer $WPFsccmimageoffer.SelectedItem -PublisherName "MicrosoftSQLServer" | Select Skus


    Foreach ($SQLsku in $SQLskus){
    $WPFsccmimagesku.AddChild($SQLsku.skus)
    $WPFsccmimagesku.SelectedItem = "standard"
    }

})

# Build Location List
$WPFSubscription1.Add_DropDownClosed({
$Locations = Get-AzLocation
$WPFLocations1.Items.Clear()
foreach($Location in $Locations){
    $WPFLocations1.AddChild($Location.Location)
    }
})



$WPFBuild1.Add_Click({

#-------------------------------------------------------------------------------------------------------------------
#Set variables

$rg = $WPFresourcegroup1.Text
$Sub = $WPFSubscription1.SelectedItem
$saname = $WPFsaname1.Text
$adminAccount = $WPFadminaccount1.Text
$AdminPassword = $WPFadminpassword1.SecurePassword
$AzureLocation = $WPFLocations1.SelectedItem
$storagetype = 'Standard_GRS' # Other Options: 'Standard_GRS' , 'Standard_RAGRS' , 'Standard_ZRS' and 'Premium_LRS'
$DomainName = $WPFDname1.Text
$Prefix = $WPFprefix1.Text  # All computers will start with prefix
#$DNSServers = @()
$DCName = $WPFprefix1.Text+'dc01'
$VMSize = $WPFVMSize.SelectedItem
$addressubnet = $WPFaddresssubnet1.text
$addressprefix = $WPFaddressprefix1.text
$subnetname = $WPFsubnetName1.text

#-------------------------------------------------------------------------------------------------------------------
# Grab Custom Image ResourceID for Windows 10 images and feed it into JSON
#$ImageID = Find-AzureRmResource | Where 'ResourceType' -eq 'Microsoft.Compute/images'

#
Select-AzSubscription -Subscription $WPFSubscription1.SelectedItem
#-------------------------------------------------------------------------------------------------------------------
# Creating new Resource Group
$Getrg = Get-AzResourceGroup -Verbose

  if ($Getrg.ResourceGroupName -eq $rg) {
    $newrg = Get-AzResourceGroup -Name $rg -Verbose
    write-host "Resource group already exist" -ForegroundColor Green
  }
  else
  {
    $newrg = New-AzResourceGroup -Name $rg -Location $AzureLocation -Force -Verbose
    write-host "Created new resource group" -ForegroundColor Green
  }


#-------------------------------------------------------------------------------------------------------------------
# Creating new storage Account to upload files
$GetSA = Get-AzStorageAccount -Verbose
  
  if ($GetSA.StorageAccountName -eq $saname) {
  write-host "Storage Account already exist" -ForegroundColor Green
    $storageaccount = Get-AzStorageAccount -ResourceGroupName $rg -Name $saname -Verbose
  }
  else
  {
  $storageaccount = New-AzStorageAccount -ResourceGroupName $rg -Name $saname -Location $AzureLocation -SkuName $storagetype -Verbose
  write-host "Creating new storage account for DSC files" -ForegroundColor Green
  }

#-------------------------------------------------------------------------------------------------------------------
# Creating new File Share to upload files and scripts
  $GetFS = Get-AzStorageShare -Context $storageaccount.Context -Verbose
  
  if ($GetFS.Name -eq "dscstatus") {
  $fs = Get-AzStorageShare -Name "dscstatus" -Context $storageaccount.Context -Verbose
  }
  else
  {
  $fs = New-AzStorageShare -Name "dscstatus" -Context $storageaccount.Context -Verbose
  }


#-------------------------------------------------------------------------------------------------------------------

# Creating storage containers
$GetSC = Get-AzStorageContainer -Context $storageaccount.Context -Verbose
  
  if ($GetSC.Name -eq "dsc") {
  write-host "Storage container already exist" -ForegroundColor Green
  $dsccontainer = Get-AzStorageContainer -Name dsc -Context $storageaccount.Context -Verbose
  }
  else
  {
  write-host "Creating new storage container for DSC files" -ForegroundColor Green
  $dsccontainer = New-AzStorageContainer -Name dsc -Permission Blob -Context $storageaccount.Context -Verbose
  }


        ## Copying DSC to Azure Storage
        write-host "Uploading DSC to Azure Storage Container" -ForegroundColor Green
        Set-AzStorageBlobContent -Container $dsccontainer.Name -File .\DSC\Configuration.zip -Blob 'Configuration.zip' -Context $dsccontainer.Context -Force -Verbose -AsJob
        Set-AzStorageBlobContent -Container $dsccontainer.Name -File .\DSC\ServerDomainJoin.zip -Blob 'ServerDomainJoin.ps1.zip' -Context $dsccontainer.Context -Force -Verbose -AsJob
        Get-AzStorageContainer -Name $dsccontainer.Name -Context $dsccontainer.Context -Verbose
        
        write-host "Sleeping for 30secs so the DSC files can upload" -ForegroundColor Green
        Start-Sleep -Seconds 30
        $DSCs = Get-AzStorageBlob -Container dsc -Context $dsccontainer.Context -Verbose
        
        # Get uri DSC for Deployment
        $assetLocation = (Get-AzStorageBlob -blob 'Configuration.zip' -Container 'dsc' -Context $dsccontainer.Context).context.BlobEndPoint #+ 'dsc/'
        
        # Setting up File Share Connections for each server
        #$Fileshare = $storageaccount.Context.FileEndPoint
        #$Fileshare = $Fileshare -replace 'https://','\\' -replace '/',''
        #$Fileshare = $fileshare + "\dscstatus"
        #$storageKey = Get-AzStorageAccountKey -ResourceGroupName $rg -Name $storageaccount.storageAccountName
        #$accountKey = ConvertTo-SecureString -String "$storageKey" -AsPlainText -Force
        #$sacreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "Azure\$storageaccount.storageAccountName", $accountKey


#####################################################################################################
# DC/CA Build
If ($WPFserver1.IsChecked -eq $true){
Write-Host "Building DC/CA" -ForegroundColor Green

New-AzResourceGroupDeployment -Name $WPFServer1Name.Text `
                                   -ResourceGroupName $rg `
                                   -TemplateFile ".\AzureTemplate.json" `
                                   -prefix $Prefix `
                                   -DomainName $DomainName `
                                   -adminUsername $adminAccount `
                                   -adminPassword $AdminPassword `
                                   -_artifactsLocation $assetLocation `
                                   -vmsize $WPFserver1vmsize.SelectedItem `
                                   -vmdisk $WPFserver1disk.SelectedItem `
                                   -addressprefix $addressprefix `
                                   -addresssubnet $addressubnet `
                                   -subnetname $subnetname `
                                   -publisher "MicrosoftWindowsServer" `
                                   -offer "WindowsServer" `
                                   -DCName $WPFServer1Name.Text `
                                   -sku $WPFserver1image.SelectedItem `
                                   -servername $WPFServer1Name.Text `
                                   -ip $WPFserver1IP.Text `
                                   -role $WPFServer1Role.Text `
                                   -DCip $WPFserver1IP.Text `
                                   -DPMPName $WPFsccm_dp_name.Text `
                                   -PSName $WPFsccm_ps_name.Text `
                                   -STIG $WPFSTIGs.IsChecked `
                                   -Verbose `
}
else
{
Write-Host "Not checked, not true, server 1 will always be check"
}
#####################################################################################################
# ADFS Build
If ($WPFADFS.IsChecked -eq $true){
Write-Host "Building ADFS" -ForegroundColor Green

New-AzResourceGroupDeployment -Name $WPFADFSName.Text `
                                   -ResourceGroupName $rg `
                                   -TemplateFile ".\AzureTemplate.json" `
                                   -prefix $Prefix `
                                   -DomainName $DomainName `
                                   -adminUsername $adminAccount `
                                   -adminPassword $AdminPassword `
                                   -_artifactsLocation $assetLocation `
                                   -vmsize $WPFadfssize.SelectedItem `
                                   -vmdisk $WPFadfsdisk.SelectedItem `
                                   -addressprefix $addressprefix `
                                   -addresssubnet $addressubnet `
                                   -subnetname $subnetname `
                                   -publisher "MicrosoftWindowsServer" `
                                   -offer "WindowsServer" `
                                   -DCName $WPFServer1Name.Text `
                                   -sku $WPFADFSimage.SelectedItem `
                                   -servername $WPFADFSName.Text `
                                   -ip $WPFADFSIP.Text `
                                   -role $WPFADFSRole.Text `
                                   -DCip $WPFserver1IP.Text `
                                   -DPMPName $WPFsccm_dp_name.Text `
                                   -PSName $WPFsccm_ps_name.Text `
                                   -STIG $WPFSTIGs.IsChecked `
                                   -AsJob `
                                   -Verbose `
}
else
{
Write-Host "Will not build server two because someone forgot to check the box...."
}
#####################################################################################################                                   
# SCCM Build
If ($WPFSCCM.IsChecked -eq $true){
Write-Host "Building SCCM Primary Server, SCCM Primary will take up to 45mins to install once the DSC starts" -ForegroundColor Green

New-AzResourceGroupDeployment -Name $WPFsccm_ps_name.Text `
                                   -ResourceGroupName $rg `
                                   -TemplateFile ".\AzureTemplate.json" `
                                   -prefix $Prefix `
                                   -DomainName $DomainName `
                                   -adminUsername $adminAccount `
                                   -adminPassword $AdminPassword `
                                   -_artifactsLocation $assetLocation `
                                   -vmsize $WPFsscm_ps_size.SelectedItem `
                                   -vmdisk $WPFsccm_ps_disk.SelectedItem `
                                   -addressprefix $addressprefix `
                                   -addresssubnet $addressubnet `
                                   -subnetname $subnetname `
                                   -publisher "MicrosoftSQLServer" `
                                   -offer $WPFsccmimageoffer.SelectedItem `
                                   -DCName $WPFServer1Name.Text `
                                   -sku $WPFsccmimagesku.SelectedItem `
                                   -servername $WPFsccm_ps_name.Text `
                                   -ip $WPFsccm_ps_ip.Text `
                                   -role "PS" `
                                   -DCip $WPFserver1IP.Text `
                                   -DPMPName $WPFsccm_dp_name.Text `
                                   -PSName $WPFsccm_ps_name.Text `
                                   -STIG $WPFSTIGs.IsChecked `
                                   -Verbose `

Write-Host "Building SCCM DP/MP Server" -ForegroundColor Green
New-AzResourceGroupDeployment -Name $WPFsccm_dp_name.Text `
                                   -ResourceGroupName $rg `
                                   -TemplateFile ".\AzureTemplate.json" `
                                   -prefix $Prefix `
                                   -DomainName $DomainName `
                                   -adminUsername $adminAccount `
                                   -adminPassword $AdminPassword `
                                   -_artifactsLocation $assetLocation `
                                   -vmsize $WPFsccm_mpdp_size.SelectedItem `
                                   -vmdisk $WPFsccm_mpdp_disk.SelectedItem `
                                   -addressprefix $addressprefix `
                                   -addresssubnet $addressubnet `
                                   -subnetname $subnetname `
                                   -publisher "MicrosoftWindowsServer" `
                                   -offer "WindowsServer" `
                                   -DCName $WPFServer1Name.Text `
                                   -sku $WPFsccmdpimage.SelectedItem `
                                   -servername $WPFsccm_dp_name.Text `
                                   -ip $WPFsccm_dp_ip.Text `
                                   -role "DPMP" `
                                   -DCip $WPFserver1IP.Text `
                                   -DPMPName $WPFsccm_dp_name.Text `
                                   -PSName $WPFsccm_ps_name.Text `
                                   -STIG $WPFSTIGs.IsChecked `
                                   -AsJob `
                                   -Verbose `
}
else
{
Write-Host "Will not build server two because someone forgot to check the box...."                                                                                                            
}
       

#####################################################################################################
# Workstation Build
If ($WPFworkstation.IsChecked -eq $true){
Write-Host "Building Windows Workstation" -ForegroundColor Green

New-AzResourceGroupDeployment -Name $WPFworkstationName.Text `
                                   -ResourceGroupName $rg `
                                   -TemplateFile ".\AzureTemplate.json" `
                                   -prefix $Prefix `
                                   -DomainName $DomainName `
                                   -adminUsername $adminAccount `
                                   -adminPassword $AdminPassword `
                                   -_artifactsLocation $assetLocation `
                                   -vmsize $WPFworkstationsize.SelectedItem `
                                   -vmdisk $WPFworkstationdisk.SelectedItem `
                                   -addressprefix $addressprefix `
                                   -addresssubnet $addressubnet `
                                   -subnetname $subnetname `
                                   -publisher "MicrosoftWindowsDesktop" `
                                   -offer "windows-10" `
                                   -DCName $WPFServer1Name.Text `
                                   -sku $WPFworkstationimage.SelectedItem `
                                   -servername $WPFworkstationName.Text `
                                   -ip $WPFworkstationIP.Text `
                                   -role $WPFworkstationRole.Text `
                                   -DCip $WPFserver1IP.Text `
                                   -DPMPName $WPFsccm_dp_name.Text `
                                   -PSName $WPFsccm_ps_name.Text `
                                   -STIG $WPFSTIGs.IsChecked `
                                   -AsJob `
                                   -Verbose `
}
else
{
Write-Host "Will not build server two because someone forgot to check the box...."                                                                                                            
}
        
#####################################################################################################
# SharePoint Build
If ($WPFsharepoint.IsChecked -eq $true){
Write-Host "Here we go!!  Building ADFS" -ForegroundColor Green

New-AzResourceGroupDeployment -Name $rg `
                                   -ResourceGroupName $rg `
                                   -TemplateFile ".\AzureTemplate.json" `
                                   -prefix $Prefix `
                                   -DomainName $DomainName `
                                   -adminUsername $adminAccount `
                                   -adminPassword $AdminPassword `
                                   -_artifactsLocation $assetLocation `
                                   -vmsize $WPFsharepoint_size.SelectedItem `
                                   -vmdisk $WPFsharepoint_disk.SelectedItem `
                                   -addressprefix $addressprefix `
                                   -addresssubnet $addressubnet `
                                   -subnetname $subnetname `
                                   -publisher "MicrosoftWindowsServer" `
                                   -offer "WindowsServer" `
                                   -DCName $WPFServer1Name.Text `
                                   -sku $WPFsharepointimage.SelectedItem `
                                   -servername $WPFsharepointName.Text `
                                   -ip $WPFsharepointIP.Text `
                                   -role $WPFsharepointRole.Text `
                                   -DCip $WPFserver1IP.Text `
                                   -DPMPName $WPFsccm_dp_name.Text `
                                   -PSName $WPFsccm_ps_name.Text `
                                   -STIG $WPFSTIGs.IsChecked `
                                   -Verbose `

}
else
{
Write-Host "Will not build server two because someone forgot to check the box...."
}

#####################################################################################################
# Server Build
If ($WPFserver5.IsChecked -eq $true){
Write-Host "Here we go!!  Building Server5" -ForegroundColor Green

New-AzResourceGroupDeployment -Name $rg `
                                   -ResourceGroupName $rg `
                                   -TemplateFile ".\AzureTemplate.json" `
                                   -prefix $Prefix `
                                   -DomainName $DomainName `
                                   -adminUsername $adminAccount `
                                   -adminPassword $AdminPassword `
                                   -_artifactsLocation $assetLocation `
                                   -vmsize $WPFserver5size.SelectedItem `
                                   -vmdisk $WPFserver5disk.SelectedItem `
                                   -addressprefix $addressprefix `
                                   -addresssubnet $addressubnet `
                                   -subnetname $subnetname `
                                   -publisher "MicrosoftWindowsServer" `
                                   -offer "WindowsServer" `
                                   -DCName $WPFServer1Name.Text `
                                   -sku $WPFserver5image.SelectedItem `
                                   -servername $WPFServer5Name.Text `
                                   -ip $WPFserver5IP.Text `
                                   -role $WPFServer5Role.Text `
                                   -DCip $WPFserver1IP.Text `
                                   -DPMPName $WPFsccm_dp_name.Text `
                                   -PSName $WPFsccm_ps_name.Text `
                                   -STIG $WPFSTIGs.IsChecked `
                                   -Verbose `
                                                                                                       
}
else
{
Write-Host "Will not build server two because someone forgot to check the box...."
}















})
#===========================================================================
# Shows the form
#===========================================================================
write-host "To show the form, run the following" -ForegroundColor Cyan


$async = $Form.Dispatcher.InvokeAsync({
    $Form.ShowDialog() | out-null
})
$async.Wait() | Out-Null



Pop-Location