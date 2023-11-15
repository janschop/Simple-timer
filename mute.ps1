Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class MediaKey {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern IntPtr SendMessage(IntPtr hWnd, int Msg, IntPtr wParam, IntPtr lParam);

    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern IntPtr PostMessage(IntPtr hWnd, int Msg, IntPtr wParam, IntPtr lParam);
}
"@

$WM_APPCOMMAND = 0x319
$APPCOMMAND_VOLUME_MUTE = 8

# Send the mute command
[MediaKey]::SendMessage([MediaKey]::GetForegroundWindow(), $WM_APPCOMMAND, 0, [IntPtr]::op_Explicit($APPCOMMAND_VOLUME_MUTE * 65536))

# Introduce a delay (adjust the duration as needed)
Start-Sleep -Milliseconds 500

# Check audio status
$audioStatus = [MediaKey]::SendMessage([MediaKey]::GetForegroundWindow(), $WM_APPCOMMAND, 0, [IntPtr]::op_Explicit(0)).Mute

# Check if the audio is still not muted and then send the mute command again
if ($audioStatus -eq $false) {
    [MediaKey]::SendMessage([MediaKey]::GetForegroundWindow(), $WM_APPCOMMAND, 0, [IntPtr]::op_Explicit($APPCOMMAND_VOLUME_MUTE * 65536))
}
