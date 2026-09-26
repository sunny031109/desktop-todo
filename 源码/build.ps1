param([string]$OutputPath)
$ErrorActionPreference = 'Stop'
$framework = Join-Path $env:WINDIR 'Microsoft.NET\Framework64\v4.0.30319'
$compiler = Join-Path $framework 'csc.exe'
$output = if ($OutputPath) { $OutputPath } else { Join-Path (Split-Path $PSScriptRoot -Parent) '桌面待办.exe' }
$refs = @('System.dll','System.Core.dll','System.Runtime.Serialization.dll','System.Xml.dll','System.Windows.Forms.dll','System.Drawing.dll','WPF\WindowsBase.dll','WPF\PresentationCore.dll','WPF\PresentationFramework.dll','System.Xaml.dll')
$arguments = @('/nologo','/target:winexe','/platform:anycpu','/optimize+','/codepage:65001',('/out:' + $output),('/resource:' + (Join-Path $PSScriptRoot 'MainWindow.xaml') + ',MainWindow.xaml'))
foreach ($ref in $refs) { $arguments += '/reference:' + (Join-Path $framework $ref) }
$iconPath = Join-Path (Split-Path $PSScriptRoot -Parent) '素材\待办.ico'
$arguments += '/resource:' + $iconPath + ',Todo.ico'
$arguments += '/win32icon:' + $iconPath
$arguments += Join-Path $PSScriptRoot 'DesktopTodo.cs'
& $compiler $arguments
if ($LASTEXITCODE -ne 0) { throw 'Build failed' }
Write-Output $output
