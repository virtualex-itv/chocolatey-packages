Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$baseURL = "https://downloads.dell.com/rvtools/"

function global:au_GetLatest {
    # Get version from PDF metadata (title contains version and date)
    $pdfUrl = "${baseURL}rvtools.pdf"
    $tempFile = [System.IO.Path]::GetTempFileName()

    try {
        Invoke-WebRequest -Uri $pdfUrl -OutFile $tempFile -UseBasicParsing
        $pdfContent = [System.IO.File]::ReadAllText($tempFile)

        # Extract version from PDF title metadata: /Title(RVTools 4.7.1 October 3, 2024)
        if ($pdfContent -match '/Title\(RVTools\s+(\d+\.\d+\.\d+)') {
            $version = $matches[1]
        } else {
            throw "Could not extract version from PDF metadata"
        }
    } finally {
        Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
    }

    $Url32 = "${baseURL}rvtools${version}.msi"

    # Checksum: hash the actual served MSI (~8MB). Dell's checksum.txt is NOT the
    # source of truth - in July 2026 Dell replaced the 4.8.1 MSI (validly signed) but
    # left checksum.txt stale for weeks, so trusting it broke every fresh install.
    # The txt is kept only as a cross-check that warns when Dell's files disagree.
    $checksum = (Get-RemoteChecksum $Url32 -Algorithm sha256).ToLower()

    try {
        $checksumContent = (Invoke-WebRequest -Uri "${baseURL}checksum.txt" -UseBasicParsing).Content
        if ($checksumContent -match 'SHA256:\s*([a-fA-F0-9]{64})') {
            $published = $matches[1].ToLower()
            if ($published -ne $checksum) {
                Write-Warning "Dell checksum.txt ($published) does not match the served MSI ($checksum) - packaging the real binary's hash. Verify the MSI's Authenticode signature if this persists."
            }
        }
    } catch {
        Write-Warning "Could not fetch/parse Dell checksum.txt for cross-check: $_"
    }

    # Self-force when Dell swaps the binary without bumping the version (same-version
    # re-release): if the stored checksum differs from the served MSI, force an update
    # so AU repackages with fix-version notation. Guarded so an empty placeholder in
    # chocolateyInstall.ps1 does not break the match chain.
    $match = Select-String -Path "$PSScriptRoot\tools\chocolateyInstall.ps1" -Pattern '\$checksum\s*=\s*''([a-fA-F0-9]{64})''' -ErrorAction SilentlyContinue
    if ($match -and $match.Matches.Count -gt 0) {
        $currentChecksum = $match.Matches[0].Groups[1].Value.ToLower()
        if ($currentChecksum -and $currentChecksum -ne $checksum) {
            Write-Host "Checksum changed without version bump - forcing update"
            $global:au_Force = $true
        }
    }

    @{
      Version           = $version
      Url32             = $Url32
      Checksum32        = $checksum
      ChecksumType32    = "sha256"
    }
}

function global:au_SearchReplace {
  @{
      'tools\chocolateyInstall.ps1' = @{
          "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.Url32)'"
          "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
          "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
      }
  }
}

Update-Package -ChecksumFor none
