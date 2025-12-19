# `server-stats.sh` — macOS Server Performance Monitor

A lightweight, portable Bash script to collect and display essential system performance metrics on **macOS**, designed for sysadmins, developers, and educators needing quick insight into system health—without external dependencies.

>  **No third-party tools required** — uses only built-in macOS utilities (`ps`, `vm_stat`, `df`, `awk`, `sort`).

---

## Features

The script reports:

| Metric | Details |
|-------|---------|
| **CPU Usage** | Aggregate % CPU usage (capped at 100% for readability) |
| **Memory Usage** | Used vs. total RAM (including compressed memory), with percentage |
| **Disk Usage** | Root (`/`) volume usage in human-readable format |
| **Top 5 CPU Processes** | PID, %CPU, and command name |
| **Top 5 Memory Processes** | PID, %MEM, and command name |

All output is clean, timestamped, and CLI-friendly.

---

## Requirements

- **macOS 10.15 (Catalina) or later**  
  (Tested on macOS Monterey, Ventura, and Sonoma — Intel & Apple Silicon)

- Built-in tools only:
  - `bash` (≥ v3.2)
  - `ps`, `vm_stat`, `df`, `awk`, `sort`, `hostname`, `sw_vers`

> No `brew`, `python`, or `bc` required.

---

## Installation

1. Download or create the script:
   ```bash
   curl -LO https://example.com/server-stats.sh  # ← replace with actual URL if hosted
   # OR
   nano server-stats.sh  # paste script contents from server-stats.sh