#Ahren Bader-Jarvis - idea from
#Brandon Lee - Virtualizationhowto.com - v1.2

#Set variables for the script to run
$WebPath = "C:\inetpub\wwwroot\lists\"
$ARecordFilepath = Join-path $WebPath "custom.txt"
$CNameFilepath   = Join-path $WebPath "cname.txt"

function Format-ARecord{
    param($Record)
    $IP = if($Record.RecordType -eq "A"){$Record.RecordData.IPv4Address}else{$Record.RecordData.IPv6Address}
    return $($IP.ToString() + " " + $_.Hostname + "." + $_.Domain)
}

function Format-CNameRecord{
    param($Record)
    return "cname=" + $_.Hostname + "." + $_.Domain + "," + $_.RecordData.HostNameAlias.TrimEnd(".")
}

#Run the DNS command to export entries to a file
$Domains = Get-DnsServerZone | Select -ExpandProperty ZoneName # | Where {-not $_.IsAutoCreated -and $_.ZoneName -notmatch "_msdcs"} |
$DNSRecords = foreach($Domain in $Domains) {Get-DnsServerResourceRecord -ZoneName $Domain | Select *,@{N="Domain";E={$Domain}}}
$DNSRecords | Where RecordType -in "A","AAAA" | ForEach-Object {Format-ARecord $_} | Out-File $ARecordFilepath -Encoding ascii -Force
$DNSRecords | Where RecordType -eq "CNAME" | ForEach-Object {Format-CNameRecord $_} | Out-File $CNameFilepath -Encoding ascii -Force
