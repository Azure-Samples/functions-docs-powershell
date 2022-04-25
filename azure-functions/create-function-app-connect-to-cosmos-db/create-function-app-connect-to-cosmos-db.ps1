#!/bin/pwsh

# <FullScript>
# Function app and storage account names must be unique.

# Variable block
$randomIdentifier = Get-Random
$location = "eastus"
$resourceGroup = "msdocs-azure-functions-rg-$randomIdentifier"
$tag = @{script = "create-function-app-connect-to-cosmos-db"}
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

# Create an Azure Cosmos DB database account using the same function app name.
Write-Host "Creating $functionApp"
New-AzCosmosDBAccount -Name $functionApp -ResourceGroupName $resourceGroup -Location $location

# Get the Azure Cosmos DB connection string.
$endpoint = (Get-AzCosmosDBAccount -Name $functionApp -ResourceGroupName $resourceGroup).DocumentEndpoint
Write-Host $endpoint

$key = (Get-AzCosmosDBAccountKey -Name $functionApp -ResourceGroupName $resourceGroup).PrimaryMasterKey
Write-Host $key

# Configure function app settings to use the Azure Cosmos DB connection string.
Update-AzFunctionAppSetting -Name $functionApp -ResourceGroupName $resourceGroup -AppSetting @{CosmosDB_Endpoint = $endpoint; CosmosDB_Key = $key}
# </FullScript>

# echo "Deleting all resources"
# Remove-AzResourceGroup -Name $resourceGroup -Force
