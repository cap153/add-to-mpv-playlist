# --- 配置区 ---
$scriptPath = $MyInvocation.MyCommand.Path
$currentDir = Split-Path $scriptPath
# 假设 mpv.exe 和脚本在同一目录，或者你可以手动指定绝对路径
$mpvPath = Join-Path $currentDir "mpv.exe" 

$pipeShortName = "mpvsocket"
$pipeFullPath = "\\.\pipe\$pipeShortName"
$logFile = "$env:TEMP\mpv-debug.log"
# --- 配置结束 ---

function Write-Log {
    param($Message)
    $line = "[$(Get-Date -Format 'HH:mm:ss')] $Message"
    # 使用 UTF8 防止日志乱码
    Add-Content -Path $logFile -Value $line -Encoding UTF8
}

try {
    # 获取传入的文件路径
    $filePath = $args[0]
    
    # 简单的非空检查
    if (-not $filePath) { return }

    Write-Log "脚本启动。处理文件: $filePath"

    # 1. 检查 MPV 管道是否存在
    if (Test-Path $pipeFullPath) {
        Write-Log "检测到管道存在，准备追加播放..."

        # 2. 生成 JSON
        # loadfile 支持追加模式，能够处理播放列表
        $payloadObj = @{ 
            command = @("loadfile", $filePath, "append-play") 
        }
        # Compress 压缩成单行，Depth 防止对象层级过深出问题
        $jsonPayload = $payloadObj | ConvertTo-Json -Compress -Depth 2

        Write-Log "指令内容: $jsonPayload"

        # 3. 连接管道
        $pipeClient = New-Object System.IO.Pipes.NamedPipeClientStream(".", $pipeShortName, [System.IO.Pipes.PipeDirection]::Out)
        try {
            $pipeClient.Connect(500) # 500ms 连接超时即可，无需太久
        } catch {
            Write-Log "连接管道失败，尝试直接启动新进程..."
            # 如果连接失败（僵尸管道），则回落到启动新进程
            Start-Process -FilePath $mpvPath -ArgumentList "--input-ipc-server=$pipeShortName", """$filePath"""
            return
        }

        # 4. 发送 UTF-8 字节流
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($jsonPayload + "`n")
        $pipeClient.Write($bytes, 0, $bytes.Length)
        $pipeClient.Flush()
        
        $pipeClient.Dispose()
        Write-Log "指令已发送。"

    } else {
        Write-Log "MPV 未运行，启动新实例..."
        # 强制指定 ipc-server，确保这次启动的实例能被下一次右键菜单利用
        # 使用 LiteralPath 思想传递参数比较困难，这里用三引号包裹路径处理空格
        Start-Process -FilePath $mpvPath -ArgumentList "--input-ipc-server=$pipeFullPath", """$filePath"""
    }

} catch {
    $errMsg = $_.Exception.Message
    Write-Log "[ERROR] $errMsg"
    # 如果必须弹窗报错，使用更轻量的 COM 对象
    # $wshell = New-Object -ComObject Wscript.Shell
    # $wshell.Popup("MPV Add Error: $errMsg", 0, "Error", 16)
}
