#!/bin/sh

# Total CPU usage
mpstat_info=$(mpstat)
cpu_usage=$(echo "$mpstat_info" | awk 'NR==4 { print (100-$13) }')
cpu_usage_at=$(echo "$mpstat_info" |  awk 'NR==4 { print $1  $2}')
echo "- Total CPU usage at $cpu_usage_at is: $cpu_usage%"

# Total memory usage (Free vs Used including percentage)
free_info=$(free -m)
memory_total=$(echo "$free_info" | awk 'NR==2 {print $2}')
memory_usage=$(echo "$free_info" | awk 'NR==2 {print $3*100/$2}')
memory_free=$(echo "$free_info" | awk 'NR==2 {print $4*100/$2}') 
echo "- Total memory: $memory_total MB"
echo "  + Memory used: $memory_usage%"
echo "  + Memory free: $memory_free%"

#Total disk usage (Free vs Used including percentage)
disk_used=$(df --total | awk 'END {gsub("%","",$5); print $5}')
disk_free=$((100-disk_used))
echo "- Total memory usage: "
echo "  + Disk used: $disk_used%"
echo "  + Disk free: $disk_free%"

# Top 5 processes by CPU usage
echo "- Top 5 processes by CPU usage"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

# Top 5 processes by memory usage
echo "- Top 5 processes by memory usage"
ps -eo pid,cmd,%mem --sort=-%mem | head -n 6
