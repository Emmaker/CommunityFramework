Param(
  [Parameter(Mandatory, HelpMessage = "Please provide a valid path")]
  $Path
)

$modPath = Join-Path -Path (Get-Location) -ChildPath "\*"
Write-Host "Current path is: $($modPath)"

Try {
  if (Test-Path -Path $Path) {
    Remove-Item -Path $Path -Recurse -Force
  }
} Catch {
  Write-Error "Something went wrong: $($_.exception.message)"
} Finally {
  Try {
    New-Item -Path $Path -ItemType Directory
  } Catch {
    Write-Error "Something went wrong: $($_.exception.message)"
  }
}

Try {
  Copy-Item -Path $modPath -Destination $Path -Recurse -Force

  Remove-Item -Path (Join-Path -Path $Path -ChildPath "\.git")
  Remove-Item -Path (Join-Path -Path $Path -ChildPath "\.gitattributes")
  Remove-Item -Path (Join-Path -Path $Path -ChildPath "\_export.ps1")
  Remove-Item -Path (Join-Path -Path $Path -ChildPath "\LICENSE")
  Remove-Item -Path (Join-Path -Path $Path -ChildPath "\README.md")
} Catch {
  Write-Error "Something went wrong: $($_.exception.message)"

  if (Test-Path -Path $Path) {
    Remove-Item -Path $Path -Recurse -Force
  }
}