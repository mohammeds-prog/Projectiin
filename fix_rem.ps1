$f = 'C:\Users\tsp-6\Downloads\Projectiin-main\Projectiin-main\Main.xaml'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# Replace all 3 occurrences of rem (reserved keyword) with remainder inside the Invoke Code
$c = $c.Replace('Dim rem As Integer = (n - 1) Mod 26', 'Dim remainder As Integer = (n - 1) Mod 26')
$c = $c.Replace('res = Chr(65 + rem) &amp; res', 'res = Chr(65 + remainder) &amp; res')
$c = $c.Replace('n = (n - rem - 1) \ 26', 'n = (n - remainder - 1) \ 26')

[System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
Write-Output 'Done'
