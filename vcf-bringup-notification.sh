#!/bin/bash
WEBHOOK_URL="https://hooks.slack.com/services/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"
grep 'End of Orchestration' /var/log/vmware/vcf/bringup/*.log > /dev/null 2>&1
if [ $? -eq 0 ]; then
        BRINGUP_LOGENTRY=$(grep 'End of Orchestration' /var/log/vmware/vcf/bringup/*.log | head -1 | awk '{print $1}')
        BRINGUP_COMPLETE_TIME=$(echo ${BRINGUP_LOGENTRY#*.log:})
        MESSAGE="{\"text\":\"VCF Bringup Completed at ${BRINGUP_COMPLETE_TIME}\"}"
        echo ${MESSAGE} > /tmp/file
        curl -X POST -H 'Content-Type: application/json' ${WEBHOOK_URL} -d @/tmp/file
        rm -f /var/spool/cron/root
fi