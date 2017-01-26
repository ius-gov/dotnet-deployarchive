$build = (Get-Content .\build.json | Out-String | ConvertFrom-Json)

function CreateZip {
  param( [string] $name ) 

  Add-Type -Assembly System.IO.Compression.FileSystem
  $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
  $sourcedir = $env:BUILD_ARTIFACTSTAGINGDIRECTORY + "\" + $name
  $zipfilename = $env:BUILD_ARTIFACTSTAGINGDIRECTORY + "\" + $name + ".zip"

  [System.IO.Compression.ZipFile]::CreateFromDirectory($sourcedir, $zipfilename, $compressionLevel, $false)
  if ($LASTEXITCODE -eq 1)
  {
    Write-Host "Error build project $name"
    exit 1
  }
}

if ($build.deploys)
{
    $build.deploys | ForEach {
        CreateZip $_.name
    }
}

if ($build.databases)
{
    $build.databases | ForEach {
        CreateZip $_.name
    }
}

