#!/bin/bash
# Log Analysis and Alert System
set -e

# Config
LOG_SOURCES=("/var/log/syslog" "/var/log/auth.log")
REPORT_DIR="/home/$USER/myproject/docs"
LOG_DIR="/home/$USER/myproject/logs"
REPORT_FILE="$REPORT_DIR/log_report_$(date +%F).txt"
ANALYSIS_LOG="$LOG_DIR/analyze.log"
EMAIL="princessdianaappiah5@gmail.com"

# Ensure directories exist
mkdir -p "$REPORT_DIR" "$LOG_DIR"

# Functions
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$ANALYSIS_LOG"
}

analyze_logs() {
  echo "=== SYSTEM LOG ANALYSIS REPORT ($(date +%F)) ===" > "$REPORT_FILE"
  
  for log in "${LOG_SOURCES[@]}"; do
    echo -e "\n---- Analyzing $log ----" >> "$REPORT_FILE"
    
    # 1. Count total errors
    error_count=$(grep -i "error\|fail\|denied" "$log" | wc -l)
    echo "Total errors: $error_count" >> "$REPORT_FILE"
    
    # 2. Extract last 5 critical errors
    echo -e "\nLast 5 critical errors:" >> "$REPORT_FILE"
    grep -i "error\|fail\|denied" "$log" | tail -n 5 >> "$REPORT_FILE"
    
    # 3. Failed SSH logins (security)
    if [[ "$log" == *"auth.log" ]]; then
      failed_logins=$(grep "Failed password" "$log" | wc -l)
      echo -e "\nFailed SSH attempts: $failed_logins" >> "$REPORT_FILE"
      echo "Last 3 failed IPs:" >> "$REPORT_FILE"
      grep "Failed password" "$log" | awk '{print $11}' | sort | uniq -c | tail -n 3 >> "$REPORT_FILE"
    fi
  done
  
  log "Generated report at $REPORT_FILE"
}

send_alert() {
  if grep -q "Failed password" "$REPORT_FILE" || [ "$error_count" -gt 0 ]; then
    echo "Sending alert email..." >> "$ANALYSIS_LOG"
    mail -s "ALERT: Issues found on $(hostname)" "$EMAIL" < "$REPORT_FILE" || \
      log "Failed to send email"
  fi
}

# Main
log "Starting log analysis..."
analyze_logs
send_alert
log "Analysis complete"