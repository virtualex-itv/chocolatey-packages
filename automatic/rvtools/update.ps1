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

    # Get checksum from checksum.txt
    $checksumUrl = "${baseURL}checksum.txt"
    $checksumContent = (Invoke-WebRequest -Uri $checksumUrl -UseBasicParsing).Content

    # Extract SHA256 hash from content (format: "SHA256: <hash>")
    if ($checksumContent -match 'SHA256:\s*([a-fA-F0-9]{64})') {
        $checksum = $matches[1].ToLower()
    } else {
        throw "Could not extract checksum from checksum.txt"
    }

    $Url32 = "${baseURL}rvtools${version}.msi"

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
