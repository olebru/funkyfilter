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
        $linefeedinfilter = $false


    )

    $linefeed = [string]::Empty 
    if($linefeedinfilter){
        $linefeed = [System.Environment]::NewLine
    }
    $filterstart = "($linefeed(RecipientType -eq 'UserMailbox') -and $linefeed ($linefeed "
    $filterend = ")$linefeed )"
    $result = $filterstart

    $filterelementstart = "($adattribute -like '"
    $filterelementseperator = "$linefeed -or "
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


Get-ExchangeRecipientFilterForElemets -includeElements @("ADM","EDU") -allElements  @("ADM","EDU","KRAFT") -prefix "KVAM" -adattribute "CustomAttribute15" -linefeedinfilter $true