@echo off
python %~dp0\curl.py application/json "%1" | python %~dp0\filter_domains.py