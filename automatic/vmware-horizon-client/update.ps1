Import-Module AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$allProducts = 'https://my.vmware.com/channel/public/api/v1.0/products/getAllProducts?locale=en_US&isPrivate=true'

function global:au_GetLatest {
  #region Get VMware Horizon Clients for Windows Url
  $jsonProducts = Invoke-WebRequest -Uri $allProducts | ConvertFrom-Json

  $re = 'vmware_horizon_clients'
  $productName = ($jsonProducts.productCategoryList.productList.actions | Where-Object target -match $re | Select-Object -First 1 -ExpandProperty target).Split("/")[-1]

  $productBinaries = "https://my.vmware.com/channel/public/api/v1.0/products/getRelatedDLGList?locale=en_US&category=desktop_end_user_computing&product=vmware_horizon_clients&version=$($productName)&dlgType=PRODUCT_BINARY"

  $jsonProduct = Invoke-WebRequest -Uri $productBinaries | ConvertFrom-Json

  $re = '*_WIN_*'
  $product = $jsonProduct.dlgEditionsLists.dlgList | Where-Object code -like $re | Select-Object -First 1

  $downloadFiles = "https://my.vmware.com/channel/public/api/v1.0/dlg/details?locale=en_US&downloadGroup=$($product.code)&productId=$($product.productId)&rPId=$($product.releasePackageId)"

  $jsonFile = Invoke-WebRequest -Uri $downloadFiles | ConvertFrom-Json

  $Url32 = $jsonFile.downloadFiles.thirdPartyDownloadUrl
  $version = ($Url32).Split("-")[-2] + "." + ($Url32).Split("-")[-1] -replace (".exe", "")
  $ChecksumType = 'sha256'
  $checksum = $jsonFile.downloadFiles.sha256checksum
  #endregion

  #region Get Release Notes Url
  $feed = 'https://docs.vmware.com/en/VMware-Horizon-Client-for-Windows/rn_rss.xml'
  $xml_fileName = Split-Path -Leaf $feed
  $dest = "$env:TEMP\$xml_fileName"

  Get-WebFile $feed $dest | Out-Null
  [xml]$content = Get-Content $dest

  $ReleaseNotes = $content.feed.entry | Where-Object { $_.id -match $jsonFile.downloadFiles.version } | Select-Object -ExpandProperty id

  Remove-Item $dest -Force -ErrorAction SilentlyContinue
  #endregion

  @{
    Url32          = $Url32
    Version        = $version
    ChecksumType32 = $ChecksumType
    Checksum32     = $checksum
    ReleaseNotes   = $ReleaseNotes
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

function global:au_AfterUpdate {
  Update-Metadata -key "releaseNotes" -value $Latest.ReleaseNotes
}

Update-Package -ChecksumFor none
