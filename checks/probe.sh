#!/bin/sh
# /list gives a new visitor the cookie that carries the (serialized) bookmark list.
curl -fsS --max-time 10 -D - -o /dev/null http://deserialization-pickle-bookmarks/list | grep -qi '^Set-Cookie: bookmarks='
