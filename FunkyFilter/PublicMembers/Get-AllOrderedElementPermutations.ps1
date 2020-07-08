function Get-AllOrderedElementPermutations {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $elements
    )
    $result = [System.Collections.Generic.list[string]]::new()

    $elements = $elements | Select-Object -Unique | Sort-Object
    $maxbinaryval = [System.Math]::Pow(2, ($elements | Measure-Object).Count) 

    foreach ($binVal in 0..($maxbinaryval)) {
        $tempResult = ""
        $bitPos = [System.Collections.Generic.list[string]]::New()
        $binaryString = [Convert]::ToString($binVal, 2)
        $reversedBinaryStringArray = $binaryString.ToCharArray()
        [array]::Reverse($reversedBinaryStringArray)
        foreach ($bit in $reversedBinaryStringArray) {
            $bitPos.add($bit)
        }
        for ($i = 0; $i -lt $bitPos.Count; $i++) {
            if ($bitPos[$i] -eq "1") {
                $tempResult += $elements[$i]
            }
        }
        if($tempResult.Length -gt 0){
            $result.Add($tempResult) 
        }
          
    
    }
    $result | Sort-Object
}