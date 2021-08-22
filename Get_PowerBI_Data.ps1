<# READ ME: The following PowerShell script requires installating Power BI Cmdlets to work properly #>
	<# Power BI REST API documentation: https://docs.microsoft.com/en-us/rest/api/power-bi/ #>
	<# PowerShell Power BI Cmdlets documentation: https://docs.microsoft.com/en-us/powershell/power-bi/overview?view=powerbi-ps #>

	<# The following steps only need to be completed once #>
		<# Step 1: In a PowerShell window, type: 'Install-Module -Name AzureRM -Scope CurrentUser' #>
		<# Step 2: In a PowerShell window, type: 'Install-Module -Name MicrosoftPowerBIMgmt -Scope CurrentUser' #>
		<# Step 3: Restart PowerShell - to test that the modules were installed correctly, type: 'Connect-PowerBIServiceAccount' (a login window should appear) #>


<# Establish your credentials: These credentials are only valid from an ABC Company device #>
	$Username = "username@ABCCOMPANY.com" <# Enter your Santen email: The user needs admin priveliges in the workspace where the datasets being refreshed exist #> 
	$Password = "password" | ConvertTo-SecureString -asPlainText -Force <# Enter your password #> 
	$Credentials = New-Object System.Management.Automation.PSCredential($username, $password) <# This handles the login window programatically. Remove this line to force a login window to appear #> 

Connect-PowerBIServiceAccount -Credential $Credentials <# Connect-PowerBIServiceAccount: Logs the user into the Power BI service #>

<# Place your DAX Query in the body of the request as seen below #>

$body = @"
{
	"queries":
	[
	{"query": "EVALUATE SUMMARIZECOLUMNS('Territory List'[Employee], FILTER('Market Definition', 'Market Definition'[CompetitorProduct]=1),
\"Week 1\", ROUND([Week 1],0), \"Week 2\", [week 2], \"Week 3\", [week 3], \"Week 4\", [week 4] , \"Week 5\", [week 5], \"Week 6\", [week 6], \"Week 7\", [week 7] , \"Week 8\", [week 8], \"Week 9\", [week 9], \"Week 10\", [week 10], \"Week 11\", [week 11] , \"Week 12\", [week 12] , \"W/W Δ\", [W/W Δ])"
	}
	]
}
"@

$request = "datasets/$EnterDatasetIDHere/executeQueries"
	
$result = Invoke-PowerBIRestMethod -Url $request -Method Post -Body $body

<# Convert the JSON returned from the result to a csv #>

$parsed = $result | ConvertFrom-Json
$parsedFile = $parsed.results[0].tables[0].rows | ConvertTo-Csv
$parsedList = $parsed.results[0].tables[0].rows | Format-List
$parsedResult | Out-File -Force ".\productrankings.csv" -Encoding UTF8


<# Send an email #>

$Outlook = New-Object -ComObject Outlook.Application
$date = Get-Date -Format g
$attachment = ".\productrankings.csv"
$Mail = $Outlook.CreateItem(0)
$Mail.To = "MailToSomone@ABCCompany.com"
$Mail.Cc = "MailToSomoneElse@ABCCompany.com"
$Mail.Subject = "Sample Report $date CST"
$Mail.Body = "Hi All'n'nPFA here are the product rankings. 

'n'

$parsedList

"
Try
{
    $Mail.Attachments.Add($attachment)
    $Mail.Send()
    Write-Host "Mail Sent Successfully"
    Read-Host -Prompt “Press Enter to exit”
}
Catch
{
    Write-Host "File Not Attached Successfully, Please Try Again"
    Read-Host -Prompt “Press Enter to exit”
    Exit
}