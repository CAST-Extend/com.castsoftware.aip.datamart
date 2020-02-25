@echo off
python utilities\curl.py application/json "%1" | python utilities\filter_domains.py