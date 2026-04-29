
$src = [System.IO.File]::ReadAllText('C:\Users\tsp-6\Downloads\Main (2).xaml', [System.Text.Encoding]::UTF8)
$dst = [System.IO.File]::ReadAllText('C:\Users\tsp-6\Downloads\Projectiin-main\Projectiin-main\Main.xaml', [System.Text.Encoding]::UTF8)

# Step 1: Add missing namespaces to current file
$dst = $dst.Replace('xmlns:ui="http://schemas.uipath.com/workflow/activities" xmlns:usau=', 'xmlns:ui="http://schemas.uipath.com/workflow/activities" xmlns:uix="http://schemas.uipath.com/workflow/activities/uix" xmlns:usau=')
$dst = $dst.Replace('xmlns:sd="clr-namespace:System.Data;assembly=System.Data.Common" xmlns:this=', 'xmlns:sd="clr-namespace:System.Data;assembly=System.Data.Common" xmlns:sd1="clr-namespace:System.Drawing;assembly=System.Drawing.Common" xmlns:sd2="clr-namespace:System.Drawing;assembly=System.Drawing.Primitives" xmlns:this=')

# Step 2: Extract CommentOut_6 block from source (simple approach - find tag boundaries)
$co6Marker = 'WorkflowViewState.IdRef="CommentOut_6">'
$co6Start = $src.IndexOf($co6Marker)
$tagOpenStart = $src.LastIndexOf('<ui:CommentOut', $co6Start)
$closeTag = '</ui:CommentOut>'
$closeIdx = $src.IndexOf($closeTag, $co6Start)
$co6Block = $src.Substring($tagOpenStart, $closeIdx + $closeTag.Length - $tagOpenStart)

# Step 3: Find CommentOut_3 in destination and replace it
$co3Marker = 'WorkflowViewState.IdRef="CommentOut_3">'
$co3Start = $dst.IndexOf($co3Marker)
$co3TagOpen = $dst.LastIndexOf('<ui:CommentOut', $co3Start)
$co3CloseIdx = $dst.IndexOf($closeTag, $co3Start)
$dst = $dst.Substring(0, $co3TagOpen) + $co6Block + $dst.Substring($co3CloseIdx + $closeTag.Length)

# Step 4: Write merged result
[System.IO.File]::WriteAllText('C:\Users\tsp-6\Downloads\Projectiin-main\Projectiin-main\Main.xaml', $dst, [System.Text.Encoding]::UTF8)

"DONE. Has uix: " + $dst.Contains('xmlns:uix') + " | Has NApplicationCard: " + $dst.Contains('NApplicationCard_19') + " | Has Math.Round: " + $dst.Contains('Math.Round') + " | Has Sheet1: " + $dst.Contains('Sheet1')
