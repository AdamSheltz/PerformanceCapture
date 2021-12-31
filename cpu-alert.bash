#!/bin/bash
# ASSUMES the systat is installed and enabled. AND Perfinishgts

#sudo yum install sysstat -y
# edit /etc/default/sysstat
#ENABLED="true"
#sudo systemctl enable systat
#sudo systemctl start sysstat

#https://docs.microsoft.com/en-us/troubleshoot/azure/virtual-machines/how-to-use-perfinsights-linux
#Installing PerfInsights on a linux vm.
#wget https://download.microsoft.com/download/9/F/8/9F80419C-D60D-45F1-8A98-718855F25722/PerfInsights.tar.gz
#tar xzvf PerfInsights.tar.gz
#cd <the path of PerfInsights folder>


NOW=$(date "+%Y%m%d_%H%M%S")
cpuuse=$(cat /proc/loadavg | awk '{print $3}'|cut -f 1 -d ".")
perf_insights="/home/AzureAdam/perfinsights.py"


gather_data(){
echo "Gathring Data"
        iostat -myzcxtd 1 300 >> /tmp/$HOSTNAME.iostat.$NOW.log&
        sudo python3 $perf_insights -r vmslow -d 300s -a -o /tmp/$NOW.perfinsights&
}


echo "Checking if CPU usage is above a threshold."
if [ "$cpuuse" -ge 96 ]; then
        gather_data;
fi
