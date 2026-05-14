# =========================================================
# Nombre: E2026_PC_A6_Script.ps1
# Descripción: Escáner básico de puertos TCP
# =========================================================

# 1. Solicitar datos al usuario
$ip = Read-Host "Introduce la dirección IP a escanear"
$puertosInput = Read-Host "Introduce los puertos separados por comas (ej: 80,443,22)"

# 2. Convertir la entrada de puertos en una lista (array)
$puertos = $puertosInput.Split(',')

Write-Host "`nIniciando escaneo en $ip...`n" -ForegroundColor Cyan

# 3. Recorrer cada puerto y verificar estado
foreach ($puerto in $puertos) {
    try {
        # Se intenta una conexión con un tiempo de espera de 1000ms
        $connection = New-Object System.Net.Sockets.TcpClient
        $wait = $connection.BeginConnect($ip, $puerto.Trim(), $null, $null)
        $success = $wait.AsyncWaitHandle.WaitOne(1000, $false)

        if ($success) {
            Write-Host "Puerto $puerto: ABIERTO" -ForegroundColor Green
            $connection.Close()
        } else {
            Write-Host "Puerto $puerto: CERRADO (Timeout)" -ForegroundColor Red
        }
    } catch {
        Write-Host "Puerto $puerto: CERRADO (Error)" -ForegroundColor Red
    }
}
