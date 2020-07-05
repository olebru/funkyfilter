function Get-ExchangeRecipientFilterForElemets {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $includeElements,
        [Parameter()]
        [string[]]
        $allElements,
        [Parameter()]
        [string]
        $prefix,
        [Parameter()]
        [string]
        $adattribute,
        [Parameter()]
        [bool]
        $prettyformat = $false


    )
    $tab = [string]::Empty 
    $linefeed = [string]::Empty 
    $linefeedandtab = [string]::Empty
    $linefeedanddoubletab = [string]::Empty
    if($prettyformat){
        $linefeed = [System.Environment]::NewLine
        $tab = [char]9
        $linefeedandtab = $linefeed + $tab
        $linefeedanddoubletab = $linefeed + $tab + $tab
    }
    

    $filterstart = "($linefeedandtab(RecipientType -eq 'UserMailbox') $linefeedandtab -and $linefeedandtab($linefeedanddoubletab"
    $filterend = "$linefeedandtab)$linefeed)"
    $result = $filterstart

    $filterelementstart = "($adattribute -like '"
    $filterelementseperator = " -or $linefeedanddoubletab"
    $filterelementend = "')"

    $includeElements = $includeElements | Select-Object -Unique | Sort-Object

    $allOrderedPermutationsOfElements = Get-AllOrderedElementPermutations -elements $allElements

    foreach ($includedElement in $includeElements) {

        foreach ($permutation in $allOrderedPermutationsOfElements) {
            if ($permutation.Contains($includedElement)) {
                $result = $result + $filterelementstart + $prefix + $permutation + $filterelementend + $filterelementseperator
            }
        }
    }
    #strip last seperator...

    $result = $result.Substring(0, $result.Length - $filterelementseperator.Length)

    $result = $result + $filterend

    $result

}
