If (Test-Path C:\projects\cmappertools\boost){
    Write-Host "Boost is already installed."
}Else{
    Write-Host "Downloading Boost..."
    (new-object net.webclient).DownloadFile("http://heanet.dl.sourceforge.net/project/boost/boost-binaries/1.59.0/boost_1_59_0-msvc-$env:MSVC_VERSION.0-$env:PYTHON_ARCH.exe", "C:\projects\cmappertools\boost.exe")
    Write-Host "Installing Boost..."
    Start-Process "C:\projects\cmappertools\boost.exe" -ArgumentList '/DIR="C:\projects\cmappertools\boost"','/SP-','/VERYSILENT','/SUPPRESSMSGBOXES','/NOCANCEL','/NORESTART' -Wait
}
