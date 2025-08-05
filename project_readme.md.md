# Log Analysis and Alert System

## Overview
Analyzes system logs for errors and failed logins, generates daily reports, and sends email alerts.

## Requirements
- Ubuntu 24.04 LTS
- `mailutils`

## Setup
1. Place `analyze_logs.sh` in `~/myproject/scripts/`.
2. Make executable: `chmod +x analyze_logs.sh`.
3. Schedule with cron: `0 6 * * * /path/to/analyze_logs.sh`.

## Usage
- Reports: `cat ~/myproject/docs/log_report_YYYY-MM-DD.txt`
- Logs: `tail ~/myproject/logs/analyze.log`

## Customization
- Change `EMAIL` in script for alerts.
- Add more log files to `LOG_SOURCES` array.

## Troubleshooting
- No reports? Check script permissions (`chmod +x`).
- Email fails? Verify `mailutils` setup.