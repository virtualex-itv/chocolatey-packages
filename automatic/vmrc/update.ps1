Import-Module AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases = 'https://softwareupdate.vmware.com/cds/vmw-desktop/vmrc/'

function global:au_GetLatest {
  #region Get Release Notes Url
  $allProductsUrl = 'https://my.vmware.com/channel/public/api/v1.0/products/getAllProducts?locale=en_US&isPrivate=true'
  $jsonProducts = Invoke-WebRequest -Uri $allProductsUrl | ConvertFrom-Json

  $re = 'vmware_vsphere'
  $productVersion = ($jsonProducts.productCategoryList.productList.actions | Where-Object target -match $re | Select-Object -First 1 -ExpandProperty target).Split("/")[-1]

  $productBinariesUrl = "https://my.vmware.com/channel/public/api/v1.0/products/getRelatedDLGList?locale=en_US&category=datacenter_cloud_infrastructure&product=vmware_vsphere&version=$($productVersion)&dlgType=DRIVERS_TOOLS"
  $jsonProduct = Invoke-WebRequest -Uri $productBinariesUrl | ConvertFrom-Json

  $re = 'VMRC*'
  $product = $jsonProduct.dlgEditionsLists.dlgList | Where-Object code -like $re | Select-Object -First 1

  $downloadFiles = "https://my.vmware.com/channel/public/api/v1.0/dlg/details?locale=en_US&downloadGroup=$($product.code)&productId=$($product.productId)"
  $jsonFile = Invoke-WebRequest -Uri $downloadFiles | ConvertFrom-Json

  $dlgHeaderUrl = "https://my.vmware.com/channel/public/api/v1.0/products/getDLGHeader?locale=en_US&downloadGroup=$($product.code)&productId=$($product.productId)"
  $jsonHeader = Invoke-WebRequest -Uri $dlgHeaderUrl | ConvertFrom-Json

  $ReleaseNotes = ($jsonHeader.dlg.documentation).Split(';|&') | Where-Object { $_ -match '.html' } | Select-Object -First 1
  #endregion

  #region Get VMware Remote Console Url
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $versionFolder = $download_page.Links | Where-Object { $_.href -Match '(\d+)' } | Select-Object -Last 1 -ExpandProperty href
  $versionFolderUrl = $releases + $versionFolder

  $build_page = Invoke-WebRequest -Uri $versionFolderUrl -UseBasicParsing
  $buildFolder = $build_page.Links | Where-Object { $_.href -Match '(\d+)' } | Select-Object -Last 1 -ExpandProperty href
  $buildFolderUrl = $versionFolderUrl + $buildFolder

  $staticFolder = 'windows/'
  $fileFolderUrl = $buildFolderUrl + $staticFolder

  $re = '\.tar$'
  $file_page = Invoke-WebRequest -Uri $fileFolderUrl -UseBasicParsing
  $fileName = $file_page.Links | Where-Object { $_.href -match $re } | Select-Object -ExpandProperty href
  #endregion

  $Url32 = $fileFolderUrl + $fileName
  $version = $jsonFile.downloadFiles.version[0] + '.' + $jsonFile.downloadFiles.build[0]
  $ChecksumType = 'sha256'

  @{
    Url32             = $Url32
    Version           = $version
    ChecksumType32    = $ChecksumType
    ReleaseNotes      = $ReleaseNotes
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

Update-Package -ChecksumFor 32
