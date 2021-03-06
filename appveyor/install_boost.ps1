If (Test-Path C:\projects\cmappertools\boost){
    Write-Host "Boost is already installed."
}Else{
    Write-Host "Downloading Boost..."
    Write-Host "Donwload URL: https://ayera.dl.sourceforge.net/project/boost/boost-binaries/1.69.0/boost_1_69_0-msvc-$env:MSVC_VERSION.0-$env:PYTHON_ARCH.exe"
    (new-object net.webclient).DownloadFile("https://ayera.dl.sourceforge.net/project/boost/boost-binaries/1.69.0/boost_1_69_0-msvc-$env:MSVC_VERSION.0-$env:PYTHON_ARCH.exe", "C:\projects\cmappertools\boost.exe")
    Write-Host "Installing Boost..."
    Start-Process "C:\projects\cmappertools\boost.exe" -ArgumentList '/DIR="C:\projects\cmappertools\boost"','/SP-','/VERYSILENT','/SUPPRESSMSGBOXES','/NOCANCEL','/NORESTART' -Wait
}
