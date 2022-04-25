#!/bin/pwsh

# <FullScript>
# Function app and storage account names must be unique.

# Variable block
$randomIdentifier = Get-Random
$location = "eastus"
$resourceGroup = "msdocs-azure-functions-rg-$randomIdentifier"
$tag = @{script = "create-function-app-premium-plan"}
$storage = "msdocsaccount$randomIdentifier"
$premiumPlan = "msdocs-premium-plan-$randomIdentifier"
$functionApp = "msdocs-function-$randomIdentifier"
$skuStorage = "Standard_LRS" # Allowed values: Standard_LRS, Standard_GRS, Standard_RAGRS, Standard_ZRS, Premium_LRS, Premium_ZRS, Standard_GZRS, Standard_RAGZRS
$skuPlan = "EP1"
$functionsVersion = "4"

# Create a resource group
Write-Host "Creating $resourceGroup in $location..."
New-AzResourceGroup -Name $resourceGroup -Location $location -Tag $tag

# Create an Azure storage account in the resource group.
Write-Host "Creating $storage"
New-AzStorageAccount -Name $storage -Location $location -ResourceGroupName $resourceGroup -SkuName $skuStorage

# Create a Premium plan
Write-Host "Creating $premiumPlan"
New-AzFunctionAppPlan -Name $premiumPlan -ResourceGroupName $resourceGroup -Location $location -Sku $skuPlan -WorkerType Windows

# Create a Function App
Write-Host "Creating $functionApp"
New-AzFunctionApp -Name $functionApp -StorageAccountName $storage -PlanName $premiumPlan -ResourceGroupName $resourceGroup -Runtime DotNet -FunctionsVersion $functionsVersion
# </FullScript>

# echo "Deleting all resources"
# Remove-AzResourceGroup -Name $resourceGroup -Force