#!/usr/bin/env python

# File: /usr/lib/nagios/plugins/check_r4e-gm-decryptor.py
# Author: Matt Madrid <matt.madrid@reputation.com>

import argparse
import json
import httplib2
#from pprint import pprint


parser = argparse.ArgumentParser(description='Nagios plugin to check r4e-gm-decryptor service')
parser.add_argument('-u', '--url', help='health check URL', required=True)
parser.add_argument('-o', '--ok-string', default="You look fine!")
parser.add_argument('-t', '--timeout', default=5)

args = parser.parse_args()

# Exit statuses recognized by Nagios
UNKNOWN = -1
OK = 0
WARNING = 1
CRITICAL = 2

h = httplib2.Http(cache=None, timeout=args.timeout)
h.force_exception_to_status_code = True
(r, c) = h.request(args.url, method="GET", headers={'cache-control': 'no-cache'})

if r.status >= 300:
    print "WARNING - got status code: %i - %s" \
        % (r.status, str(c))
    raise SystemExit(WARNING)
try:
    j = json.loads(c)
except ValueError as e:
    print "UNKNOWN - unable to read response JSON: %s" % str(c)
    raise SystemExit(UNKNOWN)

if j['Status'].upper() == args.ok_string.upper():
    print "OK - r4e-gm-decryptor service is UP"
    raise SystemExit(OK)
else:
    print "CRITICAL - r4e-gm-decryptor service is DOWN"
    raise SystemExit(CRITICAL)

