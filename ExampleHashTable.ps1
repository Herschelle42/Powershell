
$hash = [ordered]@{}
$hash.name = "server01"
$hash.id = "123456"
$hash.tags = @(
    @{
        key = "projectId"
        value = "211890"
    }
    @{
        key = "Backups"
        value = "FULL-FRI"
    }
)
$hash.customProperties = @{}
$hash.customProperties["onboardedMachine"] = "true"

$hash | ConvertTo-Json
