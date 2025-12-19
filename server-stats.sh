#!/bin/bash

# server-stats.sh — for macOS
# Usage: ./server-stats.sh

echo "=== macOS Server Performance Stats ==="
echo "Generated on: $(date)"
echo "Hostname: $(hostname)"
echo "macOS Version: $(sw_vers -productVersion)"
echo

# --- CPU Usage ---
echo "[1] Total CPU Usage"
# vm_stat gives memory; for CPU, use top in batch mode (limited on macOS)
# Alternative: use ps + awk to approximate user + sys CPU time over all processes
CPU_USAGE=$(ps -A -o %cpu | awk 'NR>1 {sum += $1} END {printf "%.1f", sum}')
# Note: This can exceed 100% (multi-core); cap at 100% for simplicity
CPU_USAGE_CAPPED=$(echo "$CPU_USAGE 100" | awk '{print ($1 > $2) ? $2 : $1}')
echo "Approx. CPU Usage: ${CPU_USAGE_CAPPED}% (aggregate across cores)"
echo

# --- Memory Usage ---
echo "[2] Memory Usage"
# Parse output of `vm_stat`
vm_stat | awk '
BEGIN {
    page_size = 4096  # default; modern macOS still uses 4KB pages for this stat
}
/ Mach Virtual Memory Statistics / { next }
/ page size / {
    gsub(/\./, "", $4); page_size = $4 + 0
}
/ Pages free / { free = $3 + 0 }
/ Pages active / { active = $3 + 0 }
/ Pages inactive / { inactive = $3 + 0 }
/ Pages speculative / { speculative = $3 + 0 }
/ Pages wired down / { wired = $4 + 0 }
/ Pages occupied by compressor / { compressed = $5 + 0 }
/ Pages in compressor / { compressed_pages = $4 + 0 }
END {
    used_pages = active + inactive + wired + compressed + speculative
    total_pages = used_pages + free
    used_mb = used_pages * page_size / 1024 / 1024
    free_mb = free * page_size / 1024 / 1024
    total_mb = total_pages * page_size / 1024 / 1024
    used_pct = (used_pages / total_pages) * 100
    printf "%.0f MB used / %.0f MB total (%.1f%% used)\n", used_mb, total_mb, used_pct
}'
echo

# --- Disk Usage (/) ---
echo "[3] Disk Usage (/)"
df -H / | awk 'NR==2 {
    gsub(/%/, "", $5)
    printf "%s used / %s total (%s%% used)\n", $3, $2, $5
}'
echo

# --- Top 5 CPU-consuming processes ---
echo "[4] Top 5 Processes by CPU Usage"
echo "  PID %CPU COMMAND"
ps -eo pid,pcpu,comm --no-headers | sort -k2 -nr | head -5 | awk '{printf "%5d %5.1f %s\n", $1, $2, $3}'
echo

# --- Top 5 Memory-consuming processes ---
echo "[5] Top 5 Processes by Memory Usage"
echo "  PID %MEM COMMAND"
ps -eo pid,pmem,comm --no-headers | sort -k2 -nr | head -5 | awk '{printf "%5d %5.1f %s\n", $1, $2, $3}'
echo

echo "=== End of Report ==="