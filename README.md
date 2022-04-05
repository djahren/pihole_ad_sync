# pihole_ad_sync
Synchronize Pihole local dns with Microsoft Active Directory DNS
My version of this idea from [Brandon Lee](https://github.com/brandonleegit/pihole_ad_sync)

## What does the script do?

- Dumps the DNS entries from the Active Directory database to a file
- Hosts the file via a basic webserver
- A cron job runs to download the files from each domain controller from the Pi. If the primary DC is unavailable or doesn't return data, the secondary DC file is used.
- the results are saved to the custom.list file in etc/pihole/ directory
- It restarts the DNS server in Pihole (a quick process)
- [GravitySync](https://github.com/vmstan/gravity-sync) (a separate community project) synchronizes the DNS entries between the primary Pihole server and the secondary Pihole server.

## Different parts of the script

pihole_ad_sync.ps1:
Variable is set to the path of the file. A .txt extension is reccomended so you don't have to add a custom file type to your IIS settings.
The PowerShell Get-DnsServerResourceRecord cmdlet dumps the DNS entries to the file specified.
The file is served by IIS to be available to the secondary script.

importdns.sh:
Downloads the file from the first script from each DC.
Checks if the first file is blank or non-existent.
Writes the best file to `/etc/pihole/custom.list`.
Restarts pihole DNS.

## What you need to do

- 1). Install the IIS role to each DC, and create a folder in C:\inetpub\wwwroot\ called `lists`.
- 2). Create a scheduled task to run `pihole_ad_sync.ps1` via powershell. Choose run whether user is logged on or not, select do not store password, and choose Run with highest priveldges.
- 3). Update the IPs of your domain controlers in `importdns.sh`.
- 4). Create a CRON job to run the `importdns.sh` script to copy over the DNS entries.
