# PureGym Tracker
Param(
  [Parameter(Mandatory=$True)]
    [string]$email,
  [Parameter(Mandatory=$True)]
    [string]$pin
)

$ProgressPreference = "silentlyContinue"

$LOGIN_PAGE = "https://www.puregym.com/login/"
$LOGIN_API = "https://www.puregym.com/api/members/login/"
$MEMBERS_PAGE = "https://puregym.com/members/"

$LOGS = $PSScriptRoot + "\logs\"
$CSV_FILE = $LOGS + "data.csv"
$ERROR_LOG = $LOGS + "puregym-error.log"

$REQEUST_VERIFICATION_TOKEN = "__RequestVerificationToken"

$req1 = Invoke-WebRequest $LOGIN_PAGE -SessionVariable 'session' -Method Get
$requestVerificationToken = $Req1.InputFields.FindByName($REQEUST_VERIFICATION_TOKEN).value

$reqHeader = @{
  "$REQEUST_VERIFICATION_TOKEN"="$requestVerificationToken"
}

$reqPayload = @{
    "email"="$email"
    "pin"="$pin"
} | ConvertTo-Json
Invoke-WebRequest $LOGIN_API -Headers $reqHeader -ContentType "application/json" -Body $reqPayload  -WebSession $session -Method Post | Out-Null

$memberPage = Invoke-WebRequest $MEMBERS_PAGE -WebSession $session -Method Get
$html = $memberPage.ParsedHtml
$memberCount = ($html.getElementsByTagName('span') | Where-Object {$_.innerHTML -match '^\d+.+people$'})."innerHTML"
$memberCount = $memberCount -replace '\D+', ''

$timestamp = Get-Date -Format g
if ([string]::IsNullOrEmpty($memberCount)) {
  if (!(Test-Path $ERROR_LOG)) { New-Item -Path $ERROR_LOG -ItemType "file" }
  Add-Content -Path $ERROR_LOG -Value "[ERROR] $timestamp Unable to fetch data from PureGym. Check credentials and connection."
} else {
  if (!(Test-Path $CSV_FILE)) { New-Item -Path $CSV_FILE -ItemType "file" }
  [PsCustomObject]@{
    'Timestamp' = $timestamp
    'People' = $memberCount
  } | Export-Csv $CSV_FILE -Append -NoTypeInformation | Out-Null
}

exit
