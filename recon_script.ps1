# recon_script.ps1 - النسخة النهائية والمضمونة
param(
    [Parameter(Mandatory=$true)]
    [string]$Target
)

Write-Host "=========================================="
Write-Host "[*] Starting reconnaissance for: $Target"
Write-Host "[*] Start time: $(Get-Date)"
Write-Host "=========================================="

# Create output directory
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$OutputDir = "recon_results_${Target}_${Timestamp}"
New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null

Write-Host "[*] Results directory: $OutputDir"
Write-Host "------------------------------------------"

# Check if target is IP
$isIP = $Target -match '^\d+\.\d+\.\d+\.\d+$'

# PHASE 1: DNS / IP Info
if ($isIP) {
    Write-Host "[PHASE 1] Target is IP: $Target"
    $ipFile = "$OutputDir\ip_info.txt"
    
    "IP Address: $Target" | Out-File $ipFile
    "Date: $(Get-Date)" | Out-File $ipFile -Append
    "===================" | Out-File $ipFile -Append
    
    Write-Host "[*] Reverse DNS lookup..."
    "Reverse DNS:" | Out-File $ipFile -Append
    nslookup $Target 2>$null | Select-String "name =" | ForEach-Object {
        $_.Line | Out-File $ipFile -Append
    }
    Write-Host "[✓] IP info saved"
} else {
    Write-Host "[PHASE 1] Target is Domain: $Target"
    $dnsFile = "$OutputDir\dns.txt"
    
    "DNS for $Target" | Out-File $dnsFile
    "Date: $(Get-Date)" | Out-File $dnsFile -Append
    "===================" | Out-File $dnsFile -Append
    
    Write-Host "[*] Getting A records..."
    "A Records:" | Out-File $dnsFile -Append
    nslookup $Target 2>$null | Select-String "Address:" | Where-Object {$_ -notmatch "#53"} | ForEach-Object {
        $_.Line | Out-File $dnsFile -Append
    }
    
    Write-Host "[*] Getting MX records..."
    "`nMX Records:" | Out-File $dnsFile -Append
    nslookup -type=MX $Target 2>$null | Select-String "mail exchanger" | ForEach-Object {
        $_.Line | Out-File $dnsFile -Append
    }
    
    Write-Host "[*] Getting NS records..."
    "`nNS Records:" | Out-File $dnsFile -Append
    nslookup -type=NS $Target 2>$null | Select-String "nameserver" | ForEach-Object {
        $_.Line | Out-File $dnsFile -Append
    }
    Write-Host "[✓] DNS info saved"
}

# PHASE 2: Ping Test
Write-Host "[PHASE 2] Testing connectivity..."
$pingFile = "$OutputDir\ping.txt"
ping -n 4 $Target | Out-File $pingFile
Write-Host "[✓] Ping test saved"

# PHASE 3: Nmap Scan
$HasNmap = Get-Command "nmap" -ErrorAction SilentlyContinue
if ($HasNmap) {
    Write-Host "[PHASE 3] Running Nmap scan..."
    $nmapFile = "$OutputDir\nmap_scan.txt"
    nmap -F --open $Target -oN $nmapFile
    
    if ($isIP) {
        Write-Host "[*] Running service detection..."
        $nmapVersionFile = "$OutputDir\nmap_versions.txt"
        nmap -sV -F --open $Target -oN $nmapVersionFile
    }
    Write-Host "[✓] Nmap scan saved"
} else {
    Write-Host "[!] Nmap not installed"
    Write-Host "    Download from: https://nmap.org/download.html"
}

# PHASE 4: Traceroute
Write-Host "[PHASE 4] Running traceroute..."
$traceFile = "$OutputDir\traceroute.txt"
tracert $Target | Out-File $traceFile
Write-Host "[✓] Traceroute saved"

# Create summary
$summaryFile = "$OutputDir\summary.txt"
"RECONNAISSANCE SUMMARY" | Out-File $summaryFile
"======================" | Out-File $summaryFile -Append
"Target: $Target" | Out-File $summaryFile -Append
"Date: $(Get-Date)" | Out-File $summaryFile -Append
"Directory: $OutputDir" | Out-File $summaryFile -Append
"" | Out-File $summaryFile -Append
"Files Created:" | Out-File $summaryFile -Append
Get-ChildItem $OutputDir | ForEach-Object {
    "  - $($_.Name)" | Out-File $summaryFile -Append
}

Write-Host "=========================================="
Write-Host "[✓] RECONNAISSANCE COMPLETE"
Write-Host "[*] End time: $(Get-Date)"
Write-Host "[*] Results saved in: $OutputDir"
Write-Host "[*] Summary file: $summaryFile"
Write-Host "=========================================="

# Show quick results
Write-Host "`n=== Quick Results ==="
if (!$isIP) {
    Write-Host "DNS Records:"
    Get-Content $dnsFile | Select-String "Address:" | Select-Object -First 3
}

Write-Host "`nPing Results:"
Get-Content $pingFile | Select-String "time" | Select-Object -First 2

if ($HasNmap -and (Test-Path $nmapFile)) {
    Write-Host "`nOpen Ports:"
    Get-Content $nmapFile | Select-String "^[0-9].*open" | Select-Object -First 5
}