VMBEER
Add-DnsServerResourceRecordA -Name "vmb-vce01" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.240" -CreatePtr
Add-DnsServerResourceRecordA -Name "esxi01" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.241" -CreatePtr
Add-DnsServerResourceRecordA -Name "esxi02" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.242" -CreatePtr
Add-DnsServerResourceRecordA -Name "esxi03" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.243" -CreatePtr
Add-DnsServerResourceRecordA -Name "esxi04" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.244" -CreatePtr


VCF
Add-DnsServerResourceRecordA -Name "vcf-m01-cb01" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.10" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-sddcm01" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.11" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-vc01" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.12" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-nsx01" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.13" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-nsx01a" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.14" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-esx01" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.15" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-esx02" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.16" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-esx03" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.17" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-esx04" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.18" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-esx05" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.19" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-esx06" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.20" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-esx07" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.21" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-esx08" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.22" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-w01-vc01" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.23" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-w01-nsx01" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.24" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-w01-nsx01a" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.25" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-w01-nsx01b" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.26" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-w01-nsx01c" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.27" -CreatePtr
Add-DnsServerResourceRecordA -Name "vmb-dep01" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.28" -CreatePtr
