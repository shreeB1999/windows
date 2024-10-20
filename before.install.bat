@echo off
setlocal

REM Define variables
set CODEDEPLOY_AGENT_URL=https://aws-codedeploy-<region>.s3.amazonaws.com/latest/Windows/CodeDeploySetup.exe
set CODEDEPLOY_AGENT_INSTALLER=CodeDeploySetup.exe

REM Check if the CodeDeploy agent is already installed
if exist "C:\Program Files\Amazon\CodeDeploy\agent\bin\codedeploy-agent.exe" (
    echo CodeDeploy agent is already installed.
) else (
    echo Downloading CodeDeploy agent...
    powershell -Command "Invoke-WebRequest -Uri %CODEDEPLOY_AGENT_URL% -OutFile %CODEDEPLOY_AGENT_INSTALLER%"

    echo Installing CodeDeploy agent...
    start /wait %CODEDEPLOY_AGENT_INSTALLER% install

    REM Clean up the installer
    del %CODEDEPLOY_AGENT_INSTALLER%

    echo Starting CodeDeploy agent service...
    powershell -Command "Start-Service codedeployagent"

    echo CodeDeploy agent installed and started successfully.
)

REM Check if the agent is running
powershell -Command "Get-Service codedeployagent"

endlocal

::powershell -Command iisreset /stop

powershell -Command "Remove-Item 'C:\inetpub\wwwroot\*' -Recurse -Force"

powershell -Command iisreset /restart
