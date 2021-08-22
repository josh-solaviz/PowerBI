<# READ ME: The following PowerShell script requires installating Power BI Cmdlets to work properly #>
	<# Power BI REST API documentation: https://docs.microsoft.com/en-us/rest/api/power-bi/ #>
	<# PowerShell Power BI Cmdlets documentation: https://docs.microsoft.com/en-us/powershell/power-bi/overview?view=powerbi-ps #>

	<# The following steps only need to be completed once #>
		<# Step 1: In a PowerShell window, type: 'Install-Module -Name AzureRM -Scope CurrentUser' #>
		<# Step 2: In a PowerShell window, type: 'Install-Module -Name MicrosoftPowerBIMgmt -Scope CurrentUser' #>
		<# Step 3: Restart PowerShell - to test that the modules were installed correctly, type: 'Connect-PowerBIServiceAccount' (a login window should appear) #>


<# Establish your credentials: These credentials are only valid from a Company ABC device #>
	$Username = "firstlast@ABCCompany.com" <# Enter your Company ABC email: The user needs admin priveliges in the workspace where the datasets is being refreshed #> 
	$Password = "password" | ConvertTo-SecureString -asPlainText -Force <# Enter your ABC Company password #> 
	$Credentials = New-Object System.Management.Automation.PSCredential($username, $password) <# This handles the login window programatically. Remove this line to force a login window to appear #> 

Connect-PowerBIServiceAccount -Credential $Credentials <# Connect-PowerBIServiceAccount: Logs the user into the Power BI service #>

<# The datasets that will be refeshed in Power BI, assigned with their ID -- you can find the ID with: Invoke-PowerBIRestMethod -Url "https://api.powerbi.com/v1.0/myorg/datasets#" -Method Get #>
	$DailyInventoryData = "f384673d-894e-4ce1-a13a-bae126cb7c09" <# Dataset Name:   #>
	$DailySalesData = "9b7c9e83-c236-43ad-9a6c-a784b9896619"  <# Connect-PowerBIServiceAccount: Logs the user into the Power BI service #>
	$WholesalerTrends = "e34395b6-2d19-4865-af55-9ba20642b93e" <# Connect-PowerBIServiceAccount: Logs the user into the Power BI service #>
	$DailyInventoryData_External = "ae279711-5967-4d8e-9f85-a48ab31b4050"

<# Call Power BI's Rest API to refresh the datasets with the datasets being entered in this format: datasets/$datasetID #>
Invoke-PowerBIRestMethod -Url "https://api.powerbi.com/v1.0/myorg/datasets/$DailyInventoryData/refreshes" -Method Post
Invoke-PowerBIRestMethod -Url "https://api.powerbi.com/v1.0/myorg/datasets/$DailyInventoryData_External/refreshes" -Method Post
Invoke-PowerBIRestMethod -Url "https://api.powerbi.com/v1.0/myorg/datasets/$DailySalesData/refreshes" -Method Post
Invoke-PowerBIRestMethod -Url "https://api.powerbi.com/v1.0/myorg/datasets/$WholesalerTrends/refreshes" -Method Post
