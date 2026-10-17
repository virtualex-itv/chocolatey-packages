Get-ChildItem | Where-Object PSIsContainer | Where-Object { !(Test-Path $_\README.md) } | ForEach-Object {
  [xml] $package = Get-Content $_\*.nuspec -ea 0 -Encoding UTF8
  if (!$package) { return }

  $meta = $package.package.metadata
  $description = if ($meta.description -is [string]) { $meta.description } else { $meta.description.InnerText }
  $description = $description.Trim()
  $icon = if ($meta.iconUrl) { '<img src="{0}" width="48" height="48"/> ' -f $meta.iconUrl } else { '' }
  $readme = ('# {1}[{0}](https://community.chocolatey.org/packages/{0})' -f $meta.id, $icon), ''
  $readme += $description -split "`n" | ForEach-Object { $_.Trim() }
  $readme -join "`r`n" | Out-File -Encoding UTF8 $_\README.md
  $meta.id
}
