#Ahren Bader-Jarvis - idea from
#Brandon Lee - Virtualizationhowto.com - v1.1
#Set variables for the script to run
$Filepath = "C:\inetpub\wwwroot\lists\custom.txt"

#Run the DNS command to export entries to a file
$Domains = Get-DnsServerZone | Where {-not $_.IsAutoCreated -and $_.ZoneName -notmatch "_msdcs"} | Select -ExpandProperty ZoneName
$DNSEntries = ""
foreach($Domain in $Domains){
    Foreach($DNSEntry in Get-DnsServerResourceRecord -ZoneName $Domain){
        $IP = $DNSEntry.recordData.IPV4Address
        if($IP){
            $DNSEntries += $IP.ToString() + " " + $DNSEntry.Hostname + ".$Domain`n"
        }
    }
}
$DNSEntries | Out-File $Filepath -Encoding utf8