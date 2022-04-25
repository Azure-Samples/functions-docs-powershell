#!/bin/pwsh

# <FullScript>
# Function app and storage account names must be unique.

# Variable block
$randomIdentifier = Get-Random
$location = "eastus"
$resourceGroup = "msdocs-azure-functions-rg-$randomIdentifier"
$tag = @{script = "create-function-app-connect-to-storage-account"}
$storage = "msdocsaccount$randomIdentifier"
$functionApp = "msdocs-serverless-function-$randomIdentifier"
$skuStorage = "Standard_LRS"
$functionsVersion = "4"

# Create a resource group
Write-Host "Creating $resourceGroup in $location..."
New-AzResourceGroup -Name $resourceGroup -Location $location -Tag $tag

# Create an Azure storage account in the resource group.
Write-Host "Creating $storage"
New-AzStorageAccount -Name $storage -Location $location -ResourceGroupName $resourceGroup -SkuName $skuStorage

# Create a serverless function app in the resource group.
Write-Host "Creating $functionApp"
New-AzFunctionApp -Name $functionApp -StorageAccountName $storage -Location $location -ResourceGroupName $resourceGroup -Runtime DotNet -FunctionsVersion $functionsVersion

# Get the storage account connection string.
$connstr = (Get-AzStorageAccount -StorageAccountName $storage -ResourceGroupName $resourceGroup).Context.ConnectionString

# Update function app settings to connect to the storage account.
Update-AzFunctionAppSetting -Name $functionApp -ResourceGroupName $resourceGroup -AppSetting @{StorageConStr = $connstr}
# </FullScript>

# echo "Deleting all resources"
# Remove-AzResourceGroup -Name $resourceGroup -Force
