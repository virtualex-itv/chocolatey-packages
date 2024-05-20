Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$allProductsUrl = 'https://my.vmware.com/channel/public/api/v1.0/products/getAllProducts?locale=en_US&isPrivate=true'

function CreateStream {
  param ( $productVersion )

  #region Get VMware Tools Urls
  $productBinariesUrl = "https://my.vmware.com/channel/public/api/v1.0/products/getRelatedDLGList?locale=en_US&category=datacenter_cloud_infrastructure&product=vmware_tools&version=$($productVersion)&dlgType=PRODUCT_BINARY"

  $jsonProduct = Invoke-WebRequest -Uri $productBinariesUrl | ConvertFrom-Json

  $re = 'VMTOOLS*'
  $product = $jsonProduct.dlgEditionsLists.dlgList | Where-Object code -like $re | Select-Object -First 1

  $downloadFilesUrl = "https://my.vmware.com/channel/public/api/v1.0/dlg/details?locale=en_US&downloadGroup=$($product.code)&productId=$($product.productId)&rPId=$($product.releasePackageId)"

  $jsonFile = Invoke-WebRequest -Uri $downloadFilesUrl | ConvertFrom-Json

  $re32 = 'i386'
  $re64 = 'x86_64'
  $download32 = $jsonFile.downloadFiles | Where-Object fileName -match $re32
  $download64 = $jsonFile.downloadFiles | Where-Object fileName -match $re64

  $Result = $false

  if ($download32 -and $download64) {
    $fileName32 = ($download32.fileName).Replace('.zip', '')
    $fileName64 = ($download64.fileName).Replace('.zip', '')
    $release = $download32.version

    $Url32 = "https://packages.vmware.com/tools/releases/$($release)/windows/x86/$($fileName32)"
    $Url64 = "https://packages.vmware.com/tools/releases/$($release)/windows/x64/$($fileName64)"
    if ($download32.build -match '') {
      $build = ($fileName32).Split('-')[3]
      $version = "$release.$build"
    } else {
        $version = "$release.$($download32.build)"
    }
    $checksumType = 'sha256'
    $checksum32 = Get-RemoteChecksum -Algorithm $checksumType -Url $Url32
    $checksum64 = Get-RemoteChecksum -Algorithm $checksumType -Url $Url64
    #endregion

    #region Get Release Notes Url
    $dlgHeaderUrl = "https://my.vmware.com/channel/public/api/v1.0/products/getDLGHeader?locale=en_US&downloadGroup=$($product.code)&productId=$($product.productId)"

    $jsonHeader = Invoke-WebRequest -Uri $dlgHeaderUrl | ConvertFrom-Json

    $ReleaseNotes = ($jsonHeader.dlg.documentation).Split(';|&') | Where-Object { $_ -match '.html' }
    #endregion

    $Result = @{
      Url32             = $Url32
      Url64             = $Url64
      Version           = $version
      ChecksumType32    = $checksumType
      Checksum32        = $checksum32
      ChecksumType64    = $checksumType
      Checksum64        = $checksum64
      ReleaseNotes      = $ReleaseNotes
    }
  }

  return $Result
}

function global:au_GetLatest {
  $streams = @{}

  #region Get VMware Tools for Windows Versions
  $jsonProducts = Invoke-WebRequest -Uri $allProductsUrl | ConvertFrom-Json

  $re = 'vmware_tools'
  $productVersion = ($jsonProducts.productCategoryList.productList.actions | Where-Object target -match $re | Select-Object -First 1 -ExpandProperty target).Split("/")[-1]

  $productHeaderUrl = "https://my.vmware.com/channel/public/api/v1.0/products/getProductHeader?locale=en_US&category=datacenter_cloud_infrastructure&product=vmware_tools&version=$($productVersion)"

  $jsonProductHeader = Invoke-WebRequest -Uri $productHeaderUrl | ConvertFrom-Json

  foreach ( $id in $jsonProductHeader.versions.id ) {
    $streamData = CreateStream($id)
    if ($streamData) {
      $streams.Add($id, $streamData)
    }
  }

  return @{ Streams = $streams }
  #endregion
}

function global:au_SearchReplace {
  @{
      'tools\chocolateyInstall.ps1' = @{
          "(^[$]url\s*=\s*)('.*')"            = "`$1'$($Latest.Url32)'"
          "(^[$]checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
          "(^[$]checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
          "(^[$]url64\s*=\s*)('.*')"          = "`$1'$($Latest.Url64)'"
          "(^[$]checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
          "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
      }
  }
}

function global:au_AfterUpdate {
  Update-Metadata -key "releaseNotes" -value $Latest.ReleaseNotes
}

Update-Package -ChecksumFor none
