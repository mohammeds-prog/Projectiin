$path = "C:\Users\tsp-6\Downloads\Projected Monthly Office Production.xlsx"
$outFile = "C:\Users\tsp-6\Downloads\excel_structure.txt"
$lines = @()

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$wb = $excel.Workbooks.Open($path)
$ws = $wb.Sheets.Item(1)

$lines += "=== ALL NON-EMPTY ROWS IN COL A (rows 1-150) ==="
for ($r = 1; $r -le 150; $r++) {
    $val = $ws.Cells.Item($r, 1).Text
    if ($val -ne "") {
        $lines += ("Row" + $r + "=" + $val)
    }
}

$lines += "=== CHECK YEAR CELL TYPES (rows 1,23,47,72) ==="
foreach ($r in @(1, 23, 47, 72, 73, 96, 97)) {
    $cell = $ws.Cells.Item($r, 1)
    $lines += ("Row" + $r + " Text=" + $cell.Text + " Value=" + $cell.Value2 + " Type=" + $cell.Value2.GetType().Name)
}

$wb.Close($false)
$excel.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
$lines | Out-File -FilePath $outFile -Encoding UTF8
