# Automated VMware Cloud Foundation Lab Deployment

## Table of Contents

* [Description](#description)
* [Changelog](#changelog)
* [Requirements](#requirements)
* [Configuration](#configuration)
* [Logging](#logging)
* [Sample Execution](#sample-execution)
    * [Lab Deployment Script](#lab-deployment-script)
    * [Deploy VCF Management Domain](#deploy-vcf-management-domain)
    * [Deploy VCF Workload Domain](#deploy-vcf-workload-domain)

## Descrição

Semelhante aos scripts anteriores de "Implantação Automática de Laboratórios" (como [aqui](https://www.williamlam.com/2016/11/vghetto-automated-vsphere-lab-deployment-for-vsphere-6-0u2-vsphere-6-5.html), [aqui](https://www.williamlam.com/2017/10/vghetto-automated-nsx-t-2-0-lab-deployment.html), [aqui](https://www.williamlam.com/2018/06/vghetto-automated-pivotal-container-service-pks-lab-deployment.html), [aqui](https://www.williamlam.com/2020/04/automated-vsphere-7-and-vsphere-with-kubernetes-lab-deployment-script.html), [aqui](https://www.williamlam.com/2020/10/automated-vsphere-with-tanzu-lab-deployment-script.html) e [aqui](https://williamlam.com/2021/04/automated-lab-deployment-script-for-vsphere-with-tanzu-using-nsx-advanced-load-balancer-nsx-alb.html)), este script torna muito fácil para qualquer pessoa implantar um VMware Cloud Foundation (VCF) "básico" em um ambiente de laboratório nested para fins de aprendizado e educação. Todos os componentes VMware necessários (VMs ESXi e Cloud Builder) são automaticamente implantados e configurados para permitir que o VCF seja implantado e configurado usando o VMware Cloud Builder. Para mais informações, você pode consultar a documentação oficial do [VMware Cloud Foundation](https://docs.vmware.com/en/VMware-Cloud-Foundation/4.0/com.vmware.vcf.ovdeploy.doc_40/GUID-F2DCF1B2-4EF6-444E-80BA-8F529A6D0725.html).

Abaixo está um diagrama do que é implantado como parte da solução, e você só precisa ter um ambiente vSphere existente rodando, gerenciado pelo vCenter Server e com recursos suficientes (CPU, Memória e Armazenamento) para implantar este laboratório "nested". Para habilitação do VCF (operação pós-implantação), consulte a seção [Execução de Exemplo](#sample-execution) abaixo.

Agora você está pronto para usar o VCF! 😁

![](screenshots/screenshot-0.png)

## Changelog
* **07/10/2024**
  * Domínio de Gerenciamento:
    * Adiciona suporte para VCF 5.2 (senha para o Cloud Builder 5.2 deve ter no mínimo 15 caracteres)
  * Domínio de Workload:
    * Adiciona suporte para VCF 5.2
    * Adiciona variável `$SeparateNSXSwitch` para especificar um VDS separado para o NSX (similar à opção do Domínio de Gerenciamento)
* **28/05/2024**
  * Domínio de Gerenciamento:
    * Refatora a geração do JSON do Domínio de Gerenciamento do VCF para ser mais dinâmica
    * Refatora o código de licenciamento para suportar tanto chaves licenciadas quanto a funcionalidade de licenciamento posterior
    * Adiciona `clusterImageEnabled` ao JSON por padrão usando a variável `$EnableVCLM`
  * Domínio de Workload:
    * Adiciona variável `$EnableVCLM` para controlar a imagem baseada em vLCM para o Cluster do vSphere
    * Adiciona variável `$VLCMImageName` para especificar a imagem baseada em vLCM desejada (por padrão usa o Domínio de Gerenciamento)
    * Adiciona variável `$EnableVSANESA` para especificar se o vSAN ESA está habilitado
    * Adiciona variável `$NestedESXiWLDVSANESA` para especificar se a VM ESXi Nested para WLD será usada para vSAN ESA, requerendo um controlador NVME ao invés de um controlador PVSCSI (padrão)
    * Refatora o código de licenciamento para suportar tanto chaves licenciadas quanto a funcionalidade de licenciamento posterior
* **27/03/2024**
  * Adiciona suporte para licenciamento posterior (também conhecido como modo de avaliação de 60 dias)
* **08/02/2024**
  * Adiciona script suplementar `vcf-automated-workload-domain-deployment.ps1` para automatizar a implantação do Domínio de Workload
* **05/02/2024**
  * Melhora o código de substituição para redes CIDR de ESXi vMotion, vSAN & NSX
  * Renomeia variáveis (`$CloudbuilderVMName`,`$CloudbuilderHostname`,`$SddcManagerName`,`$NSXManagerVIPName`,`$NSXManagerNode1Name`) para (`$CloudbuilderVMHostname`,`$CloudbuilderFQDN`,`$SddcManagerHostname`,`$NSXManagerVIPHostname`,`$NSXManagerNode1Hostname`) para representar melhor o valor esperado (Hostname e FQDN)
* **03/02/2024**
  * Adiciona suporte para definir recursos (CPU, memória e armazenamento) de forma independente para VMs ESXi Nested para uso com Domínios de Gerenciamento e/ou Workload
  * Gera automaticamente o arquivo JSON de comissão de hosts do Domínio de Workload do VCF (vcf-commission-host-api.json) para uso com a API do SDDC Manager (a interface agora incluirá `-ui` no nome do arquivo)
* **29/01/2024**
  * Adiciona suporte para [VCF 5.1]([texto](https://blogs.vmware.com/cloud-foundation/2023/11/07/announcing-availability-of-vmware-cloud-foundation-5-1/))
  * Inicia automaticamente a criação do Domínio de Gerenciamento do VCF no SDDC Manager usando o arquivo JSON de implantação gerado (vcf-mgmt.json)
  * Adiciona suporte para implantar hosts ESXi Nested para Domínio de Workload
  * Gera automaticamente o arquivo JSON de comissão de hosts do Domínio de Workload do VCF (vcf-commission-host.json) para o SDDC Manager
  * Adiciona argumento `-CoresPerSocket` para otimizar a implantação de ESXi Nested para licenciamento
  * Adiciona variáveis (`$NestedESXivMotionNetworkCidr`, `$NestedESXivSANNetworkCidr` e `$NestedESXiNSXTepNetworkCidr`) para personalizar os CIDRs das redes vMotion, vSAN e NSX TEP do ESXi

* **27/03/2023**
  * Habilita múltiplas implantações no mesmo Cluster

* **28/02/2023**
  * Adiciona nota sobre Cluster habilitado com DRS para criação de vApp e pré-checagem no código

* **21/02/2023**
  * Adiciona nota à Configuração para implantar o Domínio de Gerenciamento do VCF usando apenas um único host ESXi

* **09/02/2023**
  * Atualiza a memória do ESXi para corrigir falhas nas tarefas "Configurar o Transport Node do NSX-T Data Center" e "Reconfigurar a Alta Disponibilidade do vSphere" aumentando a memória do ESXi para 46GB [explicado aqui](http://strivevirtually.net)

* **21/01/2023**
  * Adiciona suporte para [VCF 4.5](https://imthiyaz.cloud/automated-vcf-deployment-script-with-nested-esxi)
  * Corrige o tamanho do disco de boot do vSAN
  * Siga [KB 89990](https://kb.vmware.com/s/article/89990) se você receber "O endereço IP do gateway para o gerenciamento não é contatável"
  * Se falhar a criação do Diskgroup do VSAN, siga [FakeSCSIReservations](https://williamlam.com/2013/11/how-to-run-nested-esxi-on-top-of-vsan.html)

* **25/05/2021**
  * Lançamento Inicial

## Requisitos

* Versões suportadas do VCF e os materiais necessários (BOM)

| Versão VCF | Download do Cloud Builder                                                                                                                                                                                                                     | Download do ESXi Nested                                                       |
|-------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------|
| 5.2         | [VMware Cloud Builder 5.2 (23480823) OVA](https://support.broadcom.com/group/ecx/productfiles?subFamily=VMware%20Cloud%20Foundation&displayGroup=VMware%20Cloud%20Foundation%205.2&release=5.2&os=&servicePk=520823&language=EN)     | [Nested ESXi 8.0 Update 3 OVA](https://community.broadcom.com/flings)  |
| 5.1.1       | [VMware Cloud Builder 5.1.1 (23480823) OVA](https://support.broadcom.com/group/ecx/productfiles?subFamily=VMware%20Cloud%20Foundation&displayGroup=VMware%20Cloud%20Foundation%205.1&release=5.1.1&os=&servicePk=208634&language=EN) | [Nested ESXi 8.0 Update 2b OVA](https://community.broadcom.com/flings) |
| 5.1         | [VMware Cloud Builder 5.1 (22688368) OVA](https://support.broadcom.com/group/ecx/productfiles?subFamily=VMware%20Cloud%20Foundation&displayGroup=VMware%20Cloud%20Foundation%205.1&release=5.1&os=&servicePk=203383&language=EN)         | [Nested ESXi 8.0 Update 2 OVA](https://community.broadcom.com/flings)  |

* Servidor vCenter rodando pelo menos vSphere 7.0 ou posterior
    * Se o seu armazenamento físico for vSAN, certifique-se de que você aplicou a seguinte configuração mencionada [aqui](https://www.williamlam.com/2013/11/how-to-run-nested-esxi-on-top-of-vsan.html)
* Rede do ESXi
  * Habilite [MAC Learning](https://williamlam.com/2018/04/native-mac-learning-in-vsphere-6-7-removes-the-need-for-promiscuous-mode-for-nested-esxi.html) ou [Modo Promíscuo](https://kb.vmware.com/kb/1004099) na rede do seu host ESXi físico para garantir a conectividade de rede adequada para cargas de trabalho ESXi Nested
* Requisitos de Recursos
    * Computação
        * Capacidade de provisionar VMs com até 8 vCPUs (12 vCPUs necessárias para implantação do Domínio de Workload)
        * Capacidade de provisionar até 384 GB de memória
        * Cluster habilitado com DRS (não obrigatório, mas a criação de vApps não será possível)
    * Rede
        * 1 x Portgroup Padrão ou Distribuído (roteável) para implantar todas as VMs (VCSA, NSX-T Manager & NSX-T Edge)
           * 13 x Endereços IP para Cloud Builder, SDDC Manager, VCSA, ESXi e VMs NSX-T
           * 9 x Endereços IP para implantação do Domínio de Workload (se aplicável) para ESXi, NSX e VCSA
    * Armazenamento
        * Capacidade de provisionar até 1,25 TB de armazenamento

        **Nota:** Para requisitos detalhados, consulte a planilha de planejamento e preparação [aqui](https://docs.vmware.com/en/VMware-Cloud-Foundation/5.1/vcf-planning-and-preparation-workbook.zip)
* Licenças do VMware Cloud Foundation 5.x para vCenter, ESXi, vSAN e NSX-T (VCF 5.1.1 ou posterior suporta a funcionalidade [Licenciar Depois](https://williamlam.com/2024/03/enabling-license-later-evaluation-mode-for-vmware-cloud-foundation-vcf-5-1-1.html), portanto, as chaves de licença agora são opcionais)
* Desktop (Windows, Mac ou Linux) com o PowerShell Core mais recente e PowerCLI 12.1 Core instalado. Veja [instruções aqui](https://blogs.vmware.com/PowerCLI/2018/03/installing-powercli-10-0-0-macos.html) para mais detalhes

## Configuração

Antes de executar o script, você precisará editá-lo e atualizar várias variáveis para corresponder ao seu ambiente de implantação. Os detalhes de cada seção são descritos abaixo, incluindo os valores reais usados no meu ambiente de home lab.

Esta seção descreve as credenciais do seu vCenter Server físico onde o ambiente do laboratório VCF será implantado:
```console
$VIServer = "FILL-ME-IN"
$VIUsername = "FILL-ME-IN"
$VIPassword = "FILL-ME-IN"
```

Esta seção descreve a localização dos arquivos necessários para a implantação.
```console
$NestedESXiApplianceOVA = "C:\Users\william\Desktop\VCF\Nested_ESXi8.0u2b_Appliance_Template_v1.ova"
$CloudBuilderOVA = "C:\Users\william\Desktop\VCF\VMware-Cloud-Builder-5.1.1.0-23480823_OVF10.ova"
```

Esta seção define as licenças para cada componente dentro do VCF. Se você deseja usar o modo de avaliação de 60 dias, pode deixar esses campos em branco, mas precisa usar o VCF 5.1.1 ou posterior.
```console
$VCSALicense = ""
$ESXILicense = ""
$VSANLicense = ""
$NSXLicense = ""
```

Esta seção define as configurações do VCF, incluindo o nome dos arquivos de saída para implantar o Domínio de Gerenciamento do VCF, juntamente com hosts ESXi adicionais para comissionar para uso com a interface do SDDC Manager ou API para implantação do Domínio de Workload do VCF. Os valores padrão são suficientes.
```console
$VCFManagementDomainPoolName = "vcf-m01-rp01"
$VCFManagementDomainJSONFile = "vcf-mgmt.json"
$VCFWorkloadDomainUIJSONFile = "vcf-commission-host-ui.json"
$VCFWorkloadDomainAPIJSONFile = "vcf-commission-host-api.json"
```

Esta seção descreve a configuração para o appliance virtual VMware Cloud Builder:
```console
$CloudbuilderVMHostname = "vcf-m01-cb01"
$CloudbuilderFQDN = "vcf-m01-cb01.tshirts.inc"
$CloudbuilderIP = "172.17.31.180"
$CloudbuilderAdminUsername = "admin"
$CloudbuilderAdminPassword = "VMw@re123!"
$CloudbuilderRootPassword = "VMw@re123!"
```

Esta seção descreve a configuração que será usada para implantar o SDDC Manager dentro do ambiente ESXi Nested:
```console
$SddcManagerHostname = "vcf-m01-sddcm01"
$SddcManagerIP = "172.17.31.181"
$SddcManagerVcfPassword = "VMware1!VMware1!"
$SddcManagerRootPassword = "VMware1!VMware1!"
$SddcManagerRestPassword = "VMware1!VMware1!"
$SddcManagerLocalPassword = "VMware1!VMware1!"
```

Esta seção define o número de VMs ESXi Nested a serem implantadas, juntamente com seus endereços IP associados. Os nomes são os nomes de exibição das VMs quando implantadas, e você deve garantir que esses nomes sejam adicionados à sua infraestrutura DNS. Um mínimo de quatro hosts é necessário para a implantação adequada do VCF.
```console
$NestedESXiHostnameToIPsForManagementDomain = @{
    "vcf-m01-esx01"   = "172.17.31.185"
    "vcf-m01-esx02"   = "172.17.31.186"
    "vcf-m01-esx03"   = "172.17.31.187"
    "vcf-m01-esx04"   = "172.17.31.188"
}
```

Esta seção define o número de VMs ESXi Nested a serem implantadas, juntamente com seus endereços IP associados para uso em uma implantação de Domínio de Workload. Os nomes são os nomes de exibição das VMs quando implantadas, e você deve garantir que esses nomes sejam adicionados à sua infraestrutura DNS. Um mínimo de quatro hosts deve ser usado para a implantação do Domínio de Workload.
```console
$NestedESXiHostnameToIPsForWorkloadDomain = @{
    "vcf-m01-esx05"   = "172.17.31.189"
    "vcf-m01-esx06"   = "172.17.31.190"
    "vcf-m01-esx07"   = "172.17.31.191"
    "vcf-m01-esx08"   = "172.17.31.192"
}
```

**Nota:** Um Domínio de Gerenciamento do VCF pode ser implantado com apenas uma única VM ESXi Nested. Para mais detalhes, consulte este [post no blog](https://williamlam.com/2023/02/vmware-cloud-foundation-with-a-single-esxi-host-for-management-domain.html) para os ajustes necessários.

Esta seção descreve a quantidade de recursos a serem alocados para as VMs ESXi Nested, tanto para o Domínio de Gerenciamento quanto para o Domínio de Workload (caso você opte por implantá-lo). Dependendo do seu uso, você pode querer aumentar os recursos, mas para a funcionalidade adequada, este é o mínimo necessário para começar. Para a configuração de Memória e Disco, a unidade é em GB.
```console
# Nested ESXi VM Resources for Management Domain
$NestedESXiMGMTvCPU = "12"
$NestedESXiMGMTvMEM = "78" #GB
$NestedESXiMGMTCachingvDisk = "4" #GB
$NestedESXiMGMTCapacityvDisk = "200" #GB
$NestedESXiMGMTBootDisk = "32" #GB

# Nested ESXi VM Resources for Workload Domain
$NestedESXiWLDVSANESA = $false
$NestedESXiWLDvCPU = "8"
$NestedESXiWLDvMEM = "36" #GB
$NestedESXiWLDCachingvDisk = "4" #GB
$NestedESXiWLDCapacityvDisk = "250" #GB
$NestedESXiWLDBootDisk = "32" #GB
```

Esta seção descreve as Redes ESXi Nested que serão usadas para a configuração do VCF. Para a rede de gerenciamento do ESXi, a definição CIDR deve corresponder à rede especificada na variável `$VMNetwork`.
```console
$NestedESXiManagementNetworkCidr = "172.17.31.0/24"
$NestedESXivMotionNetworkCidr = "172.17.32.0/24"
$NestedESXivSANNetworkCidr = "172.17.33.0/24"
$NestedESXiNSXTepNetworkCidr = "172.17.34.0/24"
```

Esta seção descreve as configurações que serão usadas para implantar o VCSA dentro do ambiente ESXi Nested:
```console
$VCSAName = "vcf-m01-vc01"
$VCSAIP = "172.17.31.182"
$VCSARootPassword = "VMware1!"
$VCSASSOPassword = "VMware1!"
$EnableVCLM = $true
```

Esta seção descreve as configurações que serão usadas para implantar a infraestrutura NSX-T dentro do ambiente ESXi Nested:
```console
$NSXManagerVIPHostname = "vcf-m01-nsx01"
$NSXManagerVIPIP = "172.17.31.183"
$NSXManagerNode1Hostname = "vcf-m01-nsx01a"
$NSXManagerNode1IP = "172.17.31.184"
$NSXRootPassword = "VMware1!VMware1!"
$NSXAdminPassword = "VMware1!VMware1!"
$NSXAuditPassword = "VMware1!VMware1!"
```

Esta seção descreve a localização, bem como as configurações de rede genéricas aplicadas às VMs ESXi Nested e Cloud Builder:

```console
$VMDatacenter = "San Jose"
$VMCluster = "Compute Cluster"
$VMNetwork = "sjc-comp-mgmt (1731)"
$VMDatastore = "comp-vsanDatastore"
$VMNetmask = "255.255.255.0"
$VMGateway = "172.17.31.1"
$VMDNS = "172.17.31.2"
$VMNTP = "172.17.31.2"
$VMPassword = "VMware1!"
$VMDomain = "tshirts.inc"
$VMSyslog = "172.17.31.182"
$VMFolder = "VCF"
```

> **Nota:** É recomendável que você use um servidor NTP que tenha resolução direta e reversa de DNS configurada. Caso isso não seja feito, durante a fase de validação de pré-requisitos do JSON do VCF, pode levar mais tempo do que o esperado para que o tempo limite do DNS seja concluído antes de permitir que o usuário continue com a implantação do VCF.

Depois de salvar suas alterações, você pode agora executar o script PowerCLI como faria normalmente.

## Log

Há um log adicional detalhado que é gerado como um arquivo de log no seu diretório de trabalho atual **vcf-lab-deployment.log**

## Execução de Exemplo

No exemplo abaixo, estarei utilizando uma VLAN /24 (172.17.31/0/24). A primeira rede será usada para provisionar todas as VMs e colocá-las sob a configuração típica da rede de Gerenciamento do vSphere, e 5 IPs serão alocados desta faixa para o Supervisor Control Plane e 8 IPs para o NSX ALB Service Engine. A segunda rede combinará ambas as faixas de IP para a função NSX ALB VIP/Frontend, bem como as faixas de IP para Workloads. Veja a tabela abaixo para os mapeamentos de rede explícitos, e espera-se que você tenha uma configuração semelhante ao que foi descrito.

|           Hostname          | IP Address    | Function       |
|:---------------------------:|---------------|----------------|
| vcf-m01-cb01.tshirts.inc    | 172.17.31.180 | Cloud Builder  |
| vcf-m01-sddcm01.tshirts.inc | 172.17.31.181 | SDDC Manager   |
| vcf-m01-vc01.tshirts.inc    | 172.17.31.182 | vCenter Server |
| vcf-m01-nsx01.tshirts.inc   | 172.17.31.183 | NSX-T VIP      |
| vcf-m01-nsx01a.tshirts.inc  | 172.17.31.184 | NSX-T Node 1   |
| vcf-m01-esx01.tshirts.inc   | 172.17.31.185 | ESXi Host 1    |
| vcf-m01-esx02.tshirts.inc   | 172.17.31.186 | ESXi Host 2    |
| vcf-m01-esx03.tshirts.inc   | 172.17.31.187 | ESXi Host 3    |
| vcf-m01-esx04.tshirts.inc   | 172.17.31.188 | ESXi Host 4    |
| vcf-m01-esx05.tshirts.inc   | 172.17.31.189 | ESXi Host 5    |
| vcf-m01-esx06.tshirts.inc   | 172.17.31.190 | ESXi Host 6    |
| vcf-m01-esx07.tshirts.inc   | 172.17.31.191 | ESXi Host 7    |
| vcf-m01-esx08.tshirts.inc   | 172.17.31.192 | ESXi Host 8    |

### Lab Deployment Script

Here is a screenshot of running the script if all basic pre-reqs have been met and the confirmation message before starting the deployment:

![](screenshots/screenshot-1.png)

Here is an example output of a complete deployment:

![](screenshots/screenshot-2.png)

**Note:** Deployment time will vary based on underlying physical infrastructure resources. In my lab, this took ~19min to complete.

Once completed, you will end up with eight Nested ESXi VM and VMware Cloud Builder VMs which is placed into a vApp.

![](screenshots/screenshot-3.png)

### Deploy VCF Management Domain

By default, the script will auto generate the required VCF Management Domain deployment file `vcf-mgmt.json` based off of your specific deployment and save that into the current working directory. Additionally, the VCF deployment file will automatically be submitted to SDDC Manager and begin the VCF Bringup process, which in previous versions of this script was performed manually by the end user.

Now you can just open a web browser to your SDDC Manager deployment and monitor the VCF Bringup progress.

![](screenshots/screenshot-4.png)

**Note:** If you wish to disable the VCF Bringup process, simply search for the variable named `$startVCFBringup` in the script and change the value to 0.

The deployment and configuration can take up to several hours to complete depending on the resources of your underlying hardware. In this example, the deployment took about ~1.5 to complete and you should see a success message as shown below.

![](screenshots/screenshot-6.png)

Click on the Finish button which should prompt you to login to SDDC Manager. You will need to use `administrator@vsphere.local` credentials that you had configured within the deployment script for the deployed vCenter Server.

![](screenshots/screenshot-7.png)

### Deploy VCF Workload Domain

## Manual Method

By default, the script will auto generate the VCF Workload Domain host commission file `vcf-commission-host-ui.json` based off of your specific deployment and save that into the current working directory.

Once the VCF Management Domain has been deployed, you can login to SDDC Manager UI and under `Inventory->Hosts`, click on the `COMMISSION HOSTS` button and upload the generated JSON configuration file.

**Note:** There is currently a different JSON schema between the SDDC Manager UI and API for host commission and the generated JSON file can only be used by SDDC Manager UI. For the API, you need to make some changes to the file including replacing the networkPoolName with the correct networkPoolId. For more details, please refer to the JSON format in the [VCF Host Commission API]([text](https://developer.vmware.com/apis/vcf/latest/v1/hosts/post/))

![](screenshots/screenshot-8.png)

Once the ESXi hosts have been added to SDDC Manager, then you can perform a manual VCF Workload Domain deployment using either the SDDC Manager UI or API.

![](screenshots/screenshot-9.png)

## Automated Method

A supplemental auotomation script `vcf-automated-workload-domain-deployment.ps1` will be used to automatically standup the workfload domain. It will assume that the VCF Workload Domain host commission file `vcf-commission-host-api.json` was generated from running the initial deployent script and this file will contain a "TBD" field because the SDDC Manager API expects the Management Domain Network Pool ID, which will be retrieved automatically as part of using the additional automation.

Here is an example of what will be deployed as part of Workload Domain creation:

|           Hostname          | IP Address    | Function       |
|:---------------------------:|---------------|----------------|
| vcf-w01-vc01.tshirts.inc    | 172.17.31.120 | vCenter Server |
| vcf-w01-nsx01.tshirts.inc   | 172.17.31.121 | NSX-T VIP      |
| vcf-w01-nsx01a.tshirts.inc  | 172.17.31.122 | NSX-T Node 1   |
| vcf-w01-nsx01b.tshirts.inc  | 172.17.31.122 | NSX-T Node 2   |
| vcf-w01-nsx01c.tshirts.inc  | 172.17.31.122 | NSX-T Node 3   |


### Configuration

This section describes the credentials to your deployed SDDC Manager from setting up the Management Domain:
```console
$sddcManagerFQDN = "FILL_ME_IN"
$sddcManagerUsername = "FILL_ME_IN"
$sddcManagerPassword = "FILL_ME_IN"
```

This section defines the licenses for each component within VCF
```console
$ESXILicense = "FILL_ME_IN"
$VSANLicense = "FILL_ME_IN"
$NSXLicense = "FILL_ME_IN"
```

This section defines the Management and Workload Domain configurations, which the default values should be sufficient unless you have modified anything from the original deployment script
```console
$VCFManagementDomainPoolName = "vcf-m01-rp01"
$VCFWorkloadDomainAPIJSONFile = "vcf-commission-host-api.json"
$VCFWorkloadDomainName = "wld-w01"
$VCFWorkloadDomainOrgName = "vcf-w01"
$EnableVCLM = $true
$VLCMImageName = "Management-Domain-ESXi-Personality"
$EnableVSANESA = $false
```

> **Note:** If you're going to deploy VCF Workload Domain with vLCM enabled, make sure the `$VLCMImageName` name matches what you see in SDDC Manager under Lifecycle Management->Image Management. In VCF 5.2, the default name should be "Management-Domain-ESXi-Personality" and in VCF 5.1.x the default name should be "Management-Domain-Personality" but best to confirm before proceeding with deployment.

This section defines the vCenter Server configuration that will be used in the Workload Domain
```console
$VCSAHostname = "vcf-w01-vc01"
$VCSAIP = "172.17.31.120"
$VCSARootPassword = "VMware1!"
```

This section defines the NSX Manager configurations that will be used in the Workload Domain
```console
$NSXManagerVIPHostname = "vcf-w01-nsx01"
$NSXManagerVIPIP = "172.17.31.121"
$NSXManagerNode1Hostname = "vcf-m01-nsx01a"
$NSXManagerNode1IP = "172.17.31.122"
$NSXManagerNode2Hostname = "vcf-m01-nsx01b"
$NSXManagerNode2IP = "172.17.31.123"
$NSXManagerNode3Hostname = "vcf-m01-nsx01c"
$NSXManagerNode3IP = "172.17.31.124"
$NSXAdminPassword = "VMware1!VMware1!"
$SeparateNSXSwitch = $false
```

This section defines basic networking information that will be needed to deploy vCenter and NSX components
```console
$VMNetmask = "255.255.255.0"
$VMGateway = "172.17.31.1"
$VMDomain = "tshirts.inc"
```

### Example Deployment

Here is a screenshot of running the script if all basic pre-reqs have been met and the confirmation message before starting the deployment:

![](screenshots/screenshot-10.png)

Here is an example output of a completed deployment:

![](screenshots/screenshot-11.png)

**Note:** While the script should finish ~3-4 minutes, the actual creation of the Workload Domain will take a bit longer and will depend on your resources.

To monitor the progress of your Workload Domain deployment, login to the SDDC Manager UI

![](screenshots/screenshot-12.png)

![](screenshots/screenshot-13.png)

If you now login to your vSphere UI for your Management Domain, you should see the following inventory 

![](screenshots/screenshot-14.png)
