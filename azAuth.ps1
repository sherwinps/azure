Import-Module 'C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1'
$ErrorActionPreference="Stop"

$subscriptionName = ""
$subscriptionID = ""
$location = ""
$storageAccount = ""

Write-Output "Retrieving Credentials" 
Add-AzureAccount 
    
$subscriptions = Get-AzureSubscription 

# No Subscription
if($subscriptions.Count -eq 0)
{
    Write-Output "No subscriptions found. Login with an organization account that has access to a Microsoft Azure Subscription"
    return
}

# Multiple subscriptions 
if($subscriptions.Count -gt 1)
{
    while($true)
    {
        for($i=1;$i -lt ($subscriptions.Count + 1); $i++)
        {
            Write-Host "[$i] - " $subscriptions[$i-1].SubscriptionName "- ID: " $subscriptions[$i-1].SubscriptionId
        }

        Write-Host 
        $selectedSubscription = Read-Host -Prompt "Select a Subscription to Use" 
        Write-Host 

        # validate they selected a number
        [int] $selectedNumber = $null
        if([int32]::TryParse($selectedSubscription, [ref]$selectedNumber) -eq $true)
        {
            # Validate it is within the range of subscriptions 
            if($selectedNumber -ge 1 -and $selectedNumber  -lt ($subscriptions.Count + 1))
            {
                Write-Host "Using subscription: " $subscriptions[$selectedNumber - 1].SubscriptionName " ID: " $subscriptions[$selectedNumber - 1].SubscriptionId
                $subscriptionName = $subscriptions[$selectedNumber - 1].SubscriptionName
                $subscriptionID = $subscriptions[$selectedNumber - 1].SubscriptionId
                Select-AzureSubscription -SubscriptionId $subscriptionID 
                break               
            }
        }
    }
}
# only 1 subscription
else 
{
    Write-Host "Using subscription: " $subscriptions[0].SubscriptionName " ID: " $subscriptions[0].SubscriptionId
    $subscriptionName = $subscriptions[0].SubscriptionName
    $subscriptionID = $subscriptions[$selectedNumber - 1].SubscriptionId
    Select-AzureSubscription -SubscriptionId $subscriptionID 
}