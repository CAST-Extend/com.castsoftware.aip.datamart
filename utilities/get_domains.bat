@echo off
%~dp0\curl-bat application/json "%1" | python %~dp0\filter_domains.py