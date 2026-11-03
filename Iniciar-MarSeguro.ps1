$ErrorActionPreference = "Stop"
Set-Location -LiteralPath $PSScriptRoot

if (-not (Get-Command node.exe -ErrorAction SilentlyContinue)) {
  throw "Node.js nao foi encontrado. Instale o Node.js 18 ou superior e tente novamente."
}

$hostName = if ($env:HOST) { $env:HOST } else { "127.0.0.1" }
$port = if ($env:PORT) { $env:PORT } else { "3000" }
$baseUrl = "http://127.0.0.1:$port"
$healthUrl = "$baseUrl/api/health"
$publicUrl = "$baseUrl/"
$panelUrl = "$baseUrl/painel"

try {
  $health = Invoke-RestMethod -Uri $healthUrl -TimeoutSec 2
  if ($health.ok -and $health.service -eq "MarSeguro") {
    Write-Host "MarSeguro ja esta em execucao. Abrindo as interfaces..."
    Start-Process $publicUrl
    Start-Process $panelUrl
    exit 0
  }
}
catch {
}

$securePassword = Read-Host "Defina a senha do painel (minimo de 10 caracteres)" -AsSecureString
$password = [System.Net.NetworkCredential]::new("", $securePassword).Password
if ($password.Length -lt 10) {
  throw "A senha precisa ter pelo menos 10 caracteres."
}

$env:PAINEL_SENHA = $password
$env:HOST = $hostName
$env:PORT = $port
$serverProcess = $null

try {
  $serverProcess = Start-Process -FilePath "node.exe" -ArgumentList "server.js" -WorkingDirectory $PSScriptRoot -PassThru -NoNewWindow
  $ready = $false
  for ($attempt = 0; $attempt -lt 30; $attempt++) {
    $serverProcess.Refresh()
    if ($serverProcess.HasExited) {
      throw "O servidor encerrou antes de ficar pronto. Confira a mensagem exibida acima."
    }
    try {
      $health = Invoke-RestMethod -Uri $healthUrl -TimeoutSec 1
      if ($health.ok -and $health.service -eq "MarSeguro") {
        $ready = $true
        break
      }
    }
    catch {
    }
    Start-Sleep -Seconds 1
  }
  if (-not $ready) {
    throw "O servidor nao respondeu. Confira se a porta $port esta disponivel."
  }

  Write-Host "Interfaces prontas. Abrindo a pagina publica e o painel..."
  Start-Process $publicUrl
  Start-Process $panelUrl
  Write-Host "Mantenha esta janela aberta. Pressione Ctrl+C para encerrar o MarSeguro."
  while ($true) {
    Start-Sleep -Seconds 1
    $serverProcess.Refresh()
    if ($serverProcess.HasExited) { break }
  }
}
catch {
  Write-Host $_.Exception.Message -ForegroundColor Red
  exit 1
}
finally {
  Remove-Item Env:PAINEL_SENHA -ErrorAction SilentlyContinue
  if ($serverProcess) {
    $serverProcess.Refresh()
    if (-not $serverProcess.HasExited) {
      Stop-Process -Id $serverProcess.Id
    }
  }
}
