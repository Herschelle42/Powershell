<#
.SYNOPSIS
  Used in conjunction with Argument Completers. These will be oragnisation specific.
#>
$vraServerList = { "vra.corp.local", "vra-dev.corp.local" }
$vraCredentialList = {"`$cred_userid_corp"}
$vraDomainList = { "corp.local" }

$etcdServerList = {"etcd.corp.local"}
$etcdCredentialList = { "`$cred_etcd_readonly" }
