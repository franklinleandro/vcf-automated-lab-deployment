# Adicionar registros DNS para Management Domain
Add-DnsServerResourceRecordA -Name "vcf-m01-cb01" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.2" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-sddcm01" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.3" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-vc01" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.4" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-nsx01" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.5" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-nsx01a" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.6" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-esx01" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.7" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-esx02" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.8" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-esx03" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.9" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-esx04" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.10" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-esx05" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.11" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-esx06" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.12" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-esx07" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.13" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-m01-esx08" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.14" -CreatePtr

# Adicionar registros DNS para Workload Domain
Add-DnsServerResourceRecordA -Name "vcf-w01-vc01" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.15" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-w01-nsx01" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.16" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-w01-nsx01a" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.17" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-w01-nsx01b" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.18" -CreatePtr
Add-DnsServerResourceRecordA -Name "vcf-w01-nsx01c" -ZoneName "vmbeer.local" -IPv4Address "192.168.68.19" -CreatePtr