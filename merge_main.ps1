
# Read both files
$src = [System.IO.File]::ReadAllText('C:\Users\tsp-6\Downloads\Main (2).xaml', [System.Text.Encoding]::UTF8)
$dst = [System.IO.File]::ReadAllText('C:\Users\tsp-6\Downloads\Projectiin-main\Projectiin-main\Main.xaml', [System.Text.Encoding]::UTF8)

# === STEP 1: Add uix, sd1, sd2 namespaces to current file ===
$dst = $dst.Replace(
    'xmlns:sd="clr-namespace:System.Data;assembly=System.Data.Common" xmlns:this=',
    'xmlns:sd="clr-namespace:System.Data;assembly=System.Data.Common" xmlns:sd1="clr-namespace:System.Drawing;assembly=System.Drawing.Common" xmlns:sd2="clr-namespace:System.Drawing;assembly=System.Drawing.Primitives" xmlns:this='
)
$dst = $dst.Replace(
    'xmlns:ui="http://schemas.uipath.com/workflow/activities" xmlns:usau=',
    'xmlns:ui="http://schemas.uipath.com/workflow/activities" xmlns:uix="http://schemas.uipath.com/workflow/activities/uix" xmlns:usau='
)

# === STEP 2: Extract the full CommentOut block from Main (2).xaml ===
# It starts at <ui:CommentOut DisplayName="Comment Out" ... CommentOut_6
$startTag = '<ui:CommentOut DisplayName="Comment Out" sap:VirtualizedContainerService.HintSize="556,12189" sap2010:WorkflowViewState.IdRef="CommentOut_6">'
$startIdx = $src.IndexOf($startTag)

if ($startIdx -lt 0) {
    Write-Host "ERROR: Could not find CommentOut_6 start tag in source file"
    exit 1
}

# Find the matching closing </ui:CommentOut> by counting nesting
$searchFrom = $startIdx + $startTag.Length
$depth = 1
$pos = $searchFrom

while ($depth -gt 0 -and $pos -lt $src.Length) {
    $openIdx  = $src.IndexOf('<ui:CommentOut', $pos)
    $closeIdx = $src.IndexOf('</ui:CommentOut>', $pos)
    
    if ($closeIdx -lt 0) {
        Write-Host "ERROR: Could not find closing CommentOut tag"
        exit 1
    }
    
    if ($openIdx -ge 0 -and $openIdx -lt $closeIdx) {
        $depth++
        $pos = $openIdx + 14  # len('<ui:CommentOut')
    } else {
        $depth--
        if ($depth -eq 0) {
            $endIdx = $closeIdx + 16  # len('</ui:CommentOut>')
        } else {
            $pos = $closeIdx + 16
        }
    }
}

$commentOutBlock = $src.Substring($startIdx, $endIdx - $startIdx)
Write-Host "Extracted CommentOut block: $($commentOutBlock.Length) chars"

# === STEP 3: Replace the empty CommentOut_3 in current file with the full CommentOut_6 ===
$emptyCommentOut = '<ui:CommentOut DisplayName="Comment Out" sap:VirtualizedContainerService.HintSize="486,201" sap2010:WorkflowViewState.IdRef="CommentOut_3">
      <ui:CommentOut.Body>
        <Sequence DisplayName="Ignored Activities" sap:VirtualizedContainerService.HintSize="450,90" sap2010:WorkflowViewState.IdRef="Sequence_116">
          <sap:WorkflowViewStateService.ViewState>
            <scg:Dictionary x:TypeArguments="x:String, x:Object">
              <x:Boolean x:Key="IsExpanded">True</x:Boolean>
            </scg:Dictionary>
          </sap:WorkflowViewStateService.ViewState>
        </Sequence>
      </ui:CommentOut.Body>
    </ui:CommentOut>'

if (-not $dst.Contains($emptyCommentOut)) {
    Write-Host "ERROR: Could not find the empty CommentOut_3 block in destination file"
    exit 1
}

$dst = $dst.Replace($emptyCommentOut, $commentOutBlock)

# === STEP 4: Also remove the ManualTrigger since Dentrix block has its own ===
# Keep ManualTrigger_26 as-is - it won't hurt anything

# === STEP 5: Write the merged file ===
[System.IO.File]::WriteAllText('C:\Users\tsp-6\Downloads\Projectiin-main\Projectiin-main\Main.xaml', $dst, [System.Text.Encoding]::UTF8)

Write-Host "SUCCESS: Merged file written."
Write-Host "Has uix namespace: $($dst.Contains('xmlns:uix'))"
Write-Host "Has sd1 namespace: $($dst.Contains('xmlns:sd1'))"
Write-Host "Has sd2 namespace: $($dst.Contains('xmlns:sd2'))"
Write-Host "Has NApplicationCard: $($dst.Contains('NApplicationCard_19'))"
Write-Host "Has Math.Round InvokeCode: $($dst.Contains('Math.Round'))"
Write-Host "Has full Sheets URL: $($dst.Contains('docs.google.com/spreadsheets'))"
