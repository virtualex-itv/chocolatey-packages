Import-Module AU

$allProducts = 'https://my.vmware.com/channel/public/api/v1.0/products/getAllProducts?locale=en_US&isPrivate=true'

function CreateStream {
  param ( $productName )

  $productBinaries = "https://my.vmware.com/channel/public/api/v1.0/products/getRelatedDLGList?locale=en_US&category=desktop_end_user_computing&product=vmware_horizon_clients&version=$($productName)&dlgType=PRODUCT_BINARY"

  $jsonProduct = Invoke-WebRequest -Uri $productBinaries | ConvertFrom-Json

  $re = '*_WIN_*'
  $product = $jsonProduct.dlgEditionsLists.dlgList | Where-Object code -like $re | Select-Object -First 1

  $downloadFiles = "https://my.vmware.com/channel/public/api/v1.0/dlg/details?locale=en_US&downloadGroup=$($product.code)&productId=$($product.productId)&rPId=$($product.releasePackageId)"

  $jsonFile = Invoke-WebRequest -Uri $downloadFiles | ConvertFrom-Json

  $Url32 = $jsonFile.downloadFiles.thirdPartyDownloadUrl
  $version = ($Url32).Split("-")[-2] + '.' + ($Url32).Split("-")[-1] -replace (".exe", "")
  $ChecksumType = 'sha256'
  $checksum = $jsonFile.downloadFiles.sha256checksum
  #endregion

  #region Get Release Notes Url
  $dlgHeader = "https://my.vmware.com/channel/public/api/v1.0/products/getDLGHeader?locale=en_US&downloadGroup=$($product.code)&productId=$($product.productId)"

  $jsonHeader = Invoke-WebRequest -Uri $dlgHeader | ConvertFrom-Json

  $ReleaseNotes = ($jsonHeader.dlg.documentation).Split(';|&') | Where-Object { $_ -match '.html' }
  #endregion

  $Result = @{
    Url32          = $Url32
    Version        = $version
    ChecksumType32 = $ChecksumType
    Checksum32     = $checksum
    ReleaseNotes   = $ReleaseNotes
  }
  return $Result
}

function global:au_GetLatest {
  $streams = @{}

  #region Get VMware Horizon Client for Windows Url
  $jsonProducts = Invoke-WebRequest -Uri $allProducts | ConvertFrom-Json

  $re = 'vmware_horizon_clients'
  $productName = ($jsonProducts.productCategoryList.productList.actions | Where-Object target -match $re | Select-Object -First 1 -ExpandProperty target).Split("/")[-1]

  $productHeaderUrl = "https://my.vmware.com/channel/public/api/v1.0/products/getProductHeader?locale=en_US&category=desktop_end_user_computing&product=vmware_horizon_clients&version=$($productName)"

  $jsonProductHeader = Invoke-WebRequest -Uri $productHeaderUrl | ConvertFrom-Json

  foreach ( $id in $jsonProductHeader.versions.id ) {
    $streams.Add( $id, ( CreateStream $id ) )
  }

  return @{ Streams = $streams }

  #fetch all product ids
  #loop over those product ids and invoke new function
  #with results, add to streams HashTable
  #return HashTable to AU
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
