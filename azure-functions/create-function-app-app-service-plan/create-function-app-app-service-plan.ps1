#!/bin/pwsh

# <FullScript>
# Function app and storage account names must be unique.

# Variable block
$randomIdentifier = Get-Random
$location = "eastus"
$resourceGroup = "msdocs-azure-functions-rg-$randomIdentifier"
$tag = @{script = "create-function-app-app-service-plan"}
$storage = "msdocsaccount$randomIdentifier"
$appServicePlan = "msdocs-app-service-plan-$randomIdentifier"
$functionApp = "msdocs-serverless-function-$randomIdentifier"
$skuStorage = "Standard_LRS"
$skuPlan = "B1"
$functionsVersion = "4"

# Create a resource group
Write-Host "Creating $resourceGroup in $location..."
New-AzResourceGroup -Name $resourceGroup -Location $location -Tag $tag

# Create an Azure storage account in the resource group.
Write-Host "Creating $storage"
New-AzStorageAccount -Name $storage -Location $location -ResourceGroupName $resourceGroup -SkuName $skuStorage

# Create an App Service plan
Write-Host "Creating $appServicePlan"
New-AzFunctionAppPlan -Name $appServicePlan -ResourceGroupName $resourceGroup -Location $location -Sku $skuPlan -WorkerType Windows

# Create a Function App
Write-Host "Creating $functionApp"
New-AzFunctionApp -Name $functionApp -StorageAccountName $storage -PlanName $appServicePlan -ResourceGroupName $resourceGroup -Runtime DotNet -FunctionsVersion $functionsVersion
# </FullScript>

# echo "Deleting all resources"
# Remove-AzResourceGroup -Name $resourceGroup -Force