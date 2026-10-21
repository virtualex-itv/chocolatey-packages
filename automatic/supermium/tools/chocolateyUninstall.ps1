$ErrorActionPreference = 'Stop'

[array]$key = Get-UninstallRegistryKey -SoftwareName 'Supermium*'

if ($key.Count -eq 0) {
  Write-Warning "$env:ChocolateyPackageName has already been uninstalled by other means."
  return
}
if ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | ForEach-Object { Write-Warning "- $($_.DisplayName)" }
  return
}

$uninstaller = $key[0].UninstallString -replace '"', ''
$installDir = Split-Path -Parent $uninstaller

# Close only the copy that was installed here, never another Chromium browser: ask nicely (tabs restore), then force.
$running = @(Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.Path -and $_.Path.StartsWith("$installDir\", [StringComparison]::OrdinalIgnoreCase) })
$running | Where-Object { $_.MainWindowHandle -ne 0 } | ForEach-Object { [void]$_.CloseMainWindow() }
$running | Wait-Process -Timeout 15 -ErrorAction SilentlyContinue
$running | Where-Object { -not $_.HasExited } | Stop-Process -Force -ErrorAction SilentlyContinue

# Supermium's uninstaller has no silent mode: it asks "uninstall?" and "keep your user data?" and ends with an OK box.
# Answer Yes (keep the profile) and OK, so bookmarks and settings survive a reinstall.
if (-not ('SupermiumUninstallDialog' -as [type])) {
  Add-Type @'
using System; using System.Text; using System.Runtime.InteropServices; using System.Collections.Generic;
public class SupermiumUninstallDialog {
  public delegate bool EnumProc(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] static extern bool EnumWindows(EnumProc p, IntPtr l);
  [DllImport("user32.dll")] static extern bool EnumChildWindows(IntPtr h, EnumProc p, IntPtr l);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] static extern int GetWindowText(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] static extern int GetClassName(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] static extern IntPtr SendMessage(IntPtr h, uint m, IntPtr w, IntPtr l);
  static string Text(IntPtr h) { var s = new StringBuilder(512); GetWindowText(h, s, 512); return s.ToString(); }
  static string Cls(IntPtr h) { var s = new StringBuilder(128); GetClassName(h, s, 128); return s.ToString(); }
  // Presses Yes/OK on the open 'Supermium Setup' dialog; returns true if a dialog was found.
  public static bool AnswerOne() {
    var dialogs = new List<IntPtr>();
    EnumWindows(delegate(IntPtr h, IntPtr l) { if (IsWindowVisible(h) && Cls(h) == "#32770" && Text(h) == "Supermium Setup") dialogs.Add(h); return true; }, IntPtr.Zero);
    foreach (var d in dialogs) {
      IntPtr button = IntPtr.Zero;
      EnumChildWindows(d, delegate(IntPtr c, IntPtr l) { string t = Text(c).Replace("&", ""); if (Cls(c) == "Button" && (t == "Yes" || t == "OK")) { button = c; return false; } return true; }, IntPtr.Zero);
      if (button != IntPtr.Zero) { SendMessage(button, 0x00F5, IntPtr.Zero, IntPtr.Zero); return true; }
    }
    return false;
  }
}
'@
}

Write-Host "Running $uninstaller and answering its prompts..."
$started = Start-Process -FilePath $uninstaller -PassThru
$deadline = (Get-Date).AddSeconds(120)
$answered = 0
$quietSince = $null
while ((Get-Date) -lt $deadline) {
  if ([SupermiumUninstallDialog]::AnswerOne()) { $answered++; $quietSince = $null; Start-Sleep -Milliseconds 500; continue }
  $running = Get-Process -Name 'uninstall' -ErrorAction SilentlyContinue
  if (-not $running -and $answered -gt 0) {
    if (-not $quietSince) { $quietSince = Get-Date } elseif (((Get-Date) - $quietSince).TotalSeconds -ge 3) { break }
  } else { $quietSince = $null }
  Start-Sleep -Milliseconds 300
}

if (Test-Path -LiteralPath $installDir) {
  throw "Supermium's uninstaller did not finish (answered $answered prompts); $installDir is still present."
}
