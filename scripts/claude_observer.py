#!/usr/bin/env python3
"""
Claude Code Observer with Langfuse Integration
Advanced monitoring tool for Claude Code usage with anomaly detection
"""

import os
import sys
import json
import time
import subprocess
import threading
from datetime import datetime, timedelta
from pathlib import Path
from typing import Dict, List, Optional, Any
from dataclasses import dataclass, asdict
from collections import defaultdict, deque
import hashlib
import re

try:
    from watchdog.observers import Observer
    from watchdog.events import FileSystemEventHandler
    from langfuse import Langfuse
    import psutil
except ImportError as e:
    print(f"Missing dependencies: {e}")
    print("Install with: pip install watchdog langfuse psutil")
    sys.exit(1)

@dataclass
class CodeEdit:
    file_path: str
    timestamp: datetime
    lines_added: int
    lines_removed: int
    function_changed: Optional[str]
    git_hash: Optional[str]
    
@dataclass
class Anomaly:
    type: str
    severity: str
    description: str
    timestamp: datetime
    context: Dict[str, Any]

class ClaudeObserver:
    def __init__(self, langfuse_public_key: str = None, langfuse_secret_key: str = None):
        self.home_dir = Path.home()
        self.claude_dir = self.home_dir / ".claude"
        self.scripts_dir = self.home_dir / "scripts"
        
        # Initialize Langfuse if keys provided
        self.langfuse = None
        if langfuse_public_key and langfuse_secret_key:
            self.langfuse = Langfuse(
                public_key=langfuse_public_key,
                secret_key=langfuse_secret_key
            )
        
        # Tracking data
        self.recent_edits = deque(maxlen=100)
        self.git_changes = deque(maxlen=50)
        self.anomalies = deque(maxlen=20)
        self.session_stats = defaultdict(int)
        
        # Anomaly detection thresholds
        self.edit_rate_threshold = 10  # edits per minute
        self.large_file_threshold = 1000  # lines
        self.suspicious_patterns = [
            r'rm\s+-rf',
            r'sudo\s+rm',
            r'DELETE\s+FROM',
            r'DROP\s+TABLE',
            r'eval\s*\(',
            r'exec\s*\(',
        ]
        
        self.observer = None
        self.running = False
        
    def start_monitoring(self):
        """Start all monitoring components"""
        print("🔍 Starting Claude Code Observer...")
        
        # Start file system watcher
        self.start_file_watcher()
        
        # Start log monitoring
        self.start_log_monitoring()
        
        # Start periodic checks
        self.start_periodic_checks()
        
        print("✅ Claude Observer active")
        self.running = True
        
        try:
            while self.running:
                time.sleep(1)
        except KeyboardInterrupt:
            self.stop_monitoring()
    
    def start_file_watcher(self):
        """Monitor file system changes"""
        class ClaudeFileHandler(FileSystemEventHandler):
            def __init__(self, observer_instance):
                self.observer = observer_instance
                
            def on_modified(self, event):
                if not event.is_directory:
                    self.observer.handle_file_change(event.src_path)
        
        self.observer = Observer()
        handler = ClaudeFileHandler(self)
        
        # Watch common development directories
        watch_dirs = [
            str(self.home_dir),
            "/tmp",
        ]
        
        for watch_dir in watch_dirs:
            if os.path.exists(watch_dir):
                self.observer.schedule(handler, watch_dir, recursive=True)
        
        self.observer.start()
    
    def start_log_monitoring(self):
        """Monitor Claude logs for changes"""
        def monitor_logs():
            recently_edited_file = self.claude_dir / "recently_edited.txt"
            activity_log = self.claude_dir / "activity_summary.log"
            
            last_edited_size = 0
            last_activity_size = 0
            
            while self.running:
                try:
                    # Check recently edited file
                    if recently_edited_file.exists():
                        current_size = recently_edited_file.stat().st_size
                        if current_size > last_edited_size:
                            self.process_recent_edits()
                            last_edited_size = current_size
                    
                    # Check activity log
                    if activity_log.exists():
                        current_size = activity_log.stat().st_size
                        if current_size > last_activity_size:
                            self.process_activity_log()
                            last_activity_size = current_size
                    
                    time.sleep(2)
                except Exception as e:
                    print(f"⚠️  Log monitoring error: {e}")
                    time.sleep(5)
        
        threading.Thread(target=monitor_logs, daemon=True).start()
    
    def start_periodic_checks(self):
        """Run periodic anomaly detection"""
        def periodic_check():
            while self.running:
                try:
                    self.check_for_anomalies()
                    self.update_session_stats()
                    time.sleep(30)  # Check every 30 seconds
                except Exception as e:
                    print(f"⚠️  Periodic check error: {e}")
                    time.sleep(60)
        
        threading.Thread(target=periodic_check, daemon=True).start()
    
    def handle_file_change(self, file_path: str):
        """Process file change events"""
        file_path = Path(file_path)
        
        # Skip irrelevant files
        if any(skip in str(file_path) for skip in ['.git', '__pycache__', '.DS_Store', 'node_modules']):
            return
        
        # Only process code files
        if file_path.suffix in ['.py', '.js', '.ts', '.jsx', '.tsx', '.go', '.rs', '.java', '.cpp', '.c', '.h']:
            self.analyze_code_change(file_path)
    
    def analyze_code_change(self, file_path: Path):
        """Analyze code changes for anomalies"""
        try:
            if not file_path.exists():
                return
            
            # Get file stats
            stats = file_path.stat()
            content = file_path.read_text(encoding='utf-8', errors='ignore')
            
            # Count lines
            lines = content.split('\n')
            line_count = len(lines)
            
            # Check for suspicious patterns
            for pattern in self.suspicious_patterns:
                if re.search(pattern, content, re.IGNORECASE):
                    self.record_anomaly(
                        "suspicious_code",
                        "high",
                        f"Suspicious pattern '{pattern}' found in {file_path}",
                        {"file": str(file_path), "pattern": pattern}
                    )
            
            # Check for large files
            if line_count > self.large_file_threshold:
                self.record_anomaly(
                    "large_file_edit",
                    "medium",
                    f"Large file edited: {file_path} ({line_count} lines)",
                    {"file": str(file_path), "lines": line_count}
                )
            
            # Get git info if available
            git_hash = self.get_git_hash(file_path)
            
            # Record edit
            edit = CodeEdit(
                file_path=str(file_path),
                timestamp=datetime.now(),
                lines_added=0,  # Would need git diff for accurate count
                lines_removed=0,
                function_changed=self.extract_function_name(content),
                git_hash=git_hash
            )
            
            self.recent_edits.append(edit)
            
        except Exception as e:
            print(f"⚠️  Error analyzing {file_path}: {e}")
    
    def process_recent_edits(self):
        """Process recently edited files from Claude logs"""
        recently_edited_file = self.claude_dir / "recently_edited.txt"
        
        try:
            if recently_edited_file.exists():
                content = recently_edited_file.read_text()
                if content.strip():
                    file_path = Path(content.strip())
                    self.analyze_code_change(file_path)
        except Exception as e:
            print(f"⚠️  Error processing recent edits: {e}")
    
    def process_activity_log(self):
        """Process Claude activity logs"""
        activity_log = self.claude_dir / "activity_summary.log"
        
        try:
            if activity_log.exists():
                with open(activity_log, 'r') as f:
                    # Read last few lines
                    lines = f.readlines()[-5:]
                    
                for line in lines:
                    if line.strip():
                        # Parse activity entries
                        self.session_stats['total_activities'] += 1
                        
                        # Log to Langfuse if available
                        if self.langfuse:
                            self.langfuse.trace(
                                name="claude_activity",
                                input={"log_entry": line.strip()},
                                metadata={"timestamp": datetime.now().isoformat()}
                            )
        except Exception as e:
            print(f"⚠️  Error processing activity log: {e}")
    
    def check_for_anomalies(self):
        """Check for various anomalies"""
        now = datetime.now()
        
        # Check edit rate
        recent_edits = [edit for edit in self.recent_edits 
                       if now - edit.timestamp < timedelta(minutes=1)]
        
        if len(recent_edits) > self.edit_rate_threshold:
            self.record_anomaly(
                "high_edit_rate",
                "medium",
                f"High edit rate detected: {len(recent_edits)} edits in last minute",
                {"edit_count": len(recent_edits)}
            )
        
        # Check system resources
        cpu_percent = psutil.cpu_percent()
        memory_percent = psutil.virtual_memory().percent
        
        if cpu_percent > 80:
            self.record_anomaly(
                "high_cpu",
                "medium",
                f"High CPU usage: {cpu_percent}%",
                {"cpu_percent": cpu_percent}
            )
        
        if memory_percent > 85:
            self.record_anomaly(
                "high_memory",
                "medium",
                f"High memory usage: {memory_percent}%",
                {"memory_percent": memory_percent}
            )
    
    def record_anomaly(self, anomaly_type: str, severity: str, description: str, context: Dict[str, Any]):
        """Record and alert on anomalies"""
        anomaly = Anomaly(
            type=anomaly_type,
            severity=severity,
            description=description,
            timestamp=datetime.now(),
            context=context
        )
        
        self.anomalies.append(anomaly)
        
        # Print alert
        severity_emoji = {"low": "🔵", "medium": "🟡", "high": "🔴"}
        print(f"{severity_emoji.get(severity, '⚪')} ANOMALY [{severity.upper()}]: {description}")
        
        # Log to Langfuse
        if self.langfuse:
            self.langfuse.event(
                name="anomaly_detected",
                input=asdict(anomaly),
                metadata={"observer": "claude_code"}
            )
    
    def update_session_stats(self):
        """Update session statistics"""
        self.session_stats['uptime_minutes'] = int(time.time() - self.start_time) // 60
        self.session_stats['total_edits'] = len(self.recent_edits)
        self.session_stats['total_anomalies'] = len(self.anomalies)
    
    def get_git_hash(self, file_path: Path) -> Optional[str]:
        """Get git hash for file if in git repo"""
        try:
            result = subprocess.run(
                ['git', 'rev-parse', 'HEAD'],
                cwd=file_path.parent,
                capture_output=True,
                text=True
            )
            return result.stdout.strip() if result.returncode == 0 else None
        except:
            return None
    
    def extract_function_name(self, content: str) -> Optional[str]:
        """Extract function name from code content"""
        # Simple regex patterns for common languages
        patterns = [
            r'def\s+(\w+)\s*\(',  # Python
            r'function\s+(\w+)\s*\(',  # JavaScript
            r'func\s+(\w+)\s*\(',  # Go
            r'fn\s+(\w+)\s*\(',  # Rust
        ]
        
        for pattern in patterns:
            match = re.search(pattern, content)
            if match:
                return match.group(1)
        
        return None
    
    def stop_monitoring(self):
        """Stop all monitoring"""
        print("\n🛑 Stopping Claude Observer...")
        self.running = False
        
        if self.observer:
            self.observer.stop()
            self.observer.join()
        
        # Final summary
        print(f"📊 Session Summary:")
        print(f"   • Total edits: {len(self.recent_edits)}")
        print(f"   • Anomalies detected: {len(self.anomalies)}")
        print(f"   • Activities logged: {self.session_stats.get('total_activities', 0)}")
        
        if self.langfuse:
            self.langfuse.flush()

def main():
    """Main entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(description="Claude Code Observer")
    parser.add_argument("--langfuse-public-key", help="Langfuse public key")
    parser.add_argument("--langfuse-secret-key", help="Langfuse secret key")
    parser.add_argument("--config", help="Config file path")
    
    args = parser.parse_args()
    
    # Try to load config from file
    config = {}
    if args.config and os.path.exists(args.config):
        with open(args.config, 'r') as f:
            config = json.load(f)
    
    # Get keys from args or config
    public_key = args.langfuse_public_key or config.get("langfuse_public_key")
    secret_key = args.langfuse_secret_key or config.get("langfuse_secret_key")
    
    observer = ClaudeObserver(public_key, secret_key)
    observer.start_time = time.time()
    observer.start_monitoring()

if __name__ == "__main__":
    main()