#etcd v2
Register-ArgumentCompleter -CommandName Get-etcdKey -ParameterName Computername -ScriptBlock $etcdServerList
Register-ArgumentCompleter -CommandName Get-etcdKey -ParameterName Credential -ScriptBlock $etcdCredentialList
Register-ArgumentCompleter -CommandName Get-etcdKey -ParameterName Key -ScriptBlock { '"/v2/keys/"' }

Register-ArgumentCompleter -CommandName Search-vROScriptItem -ParameterName Computername -ScriptBlock $vraServerList
Register-ArgumentCompleter -CommandName Search-vROScriptItem -ParameterName Server -ScriptBlock $vraServerList
Register-ArgumentCompleter -CommandName Search-vROScriptItem -ParameterName Port -ScriptBlock { "443" }
Register-ArgumentCompleter -CommandName Search-vROScriptItem -ParameterName Credential -ScriptBlock $vraCredentialList

Register-ArgumentCompleter -CommandName New-vRABearerToken -ParameterName Computername -ScriptBlock $vraServerList
Register-ArgumentCompleter -CommandName New-vRABearerToken -ParameterName Credential -ScriptBlock $vraCredentialList
Register-ArgumentCompleter -CommandName New-vRABearerToken -ParameterName Domain -ScriptBlock $vraDomainList
