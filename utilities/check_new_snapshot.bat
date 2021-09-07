@echo off
echo Check new snapshots against %1
type "%1" | python utilities\check_new_snapshot.py
