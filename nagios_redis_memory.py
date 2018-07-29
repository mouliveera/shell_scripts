#!/usr/bin/python3
"""
nagios_redis_memory.py: Nagios plugin to check to check memory usage against
a threshold

Author:  Michael Goll / Reputation.com

Arguments:
-h | --help -- display help
-c | --critical <n> -- critical threshold (required)
-w | --warning <n> -- warning threshold (required)
-H | --host <hostname> -- redis server hostname (required)
-p | --port <port> -- redis port (optional, default 9696)
-a | --password <password> (optional)
"""

import sys
import argparse
import redis


# script = os.path.basename(__file__)

# Exit statuses recognized by Nagios
UNKNOWN = -1
OK = 0
WARNING = 1
CRITICAL = 2


def main(argv):
    parser = argparse.ArgumentParser(description='Nagios plugin to get Redis current memory footprint')
    parser.add_argument('-c', '--critical', dest='critical', type=int,
                        action='store', required=True,
                        help='critical threshold (must be greater than warning threshold)')
    parser.add_argument('-w', '--warning', dest='warning', type=int, action='store', help='warning threshold',
                        required=True)
    parser.add_argument('-H', '--host', dest='host', action='store', help='host name', required=False, default='redis')
    parser.add_argument('-p', '--port', dest='port', type=int, action='store', help='Redis port', required=False,
                        default=9696)
    parser.add_argument('-a', '--password', dest='password', nargs='?', default='', action='store',
                        help='Redis password', required=False)

    # metavar gives the variable name for help,
    # otherwise it just upper cases dest

    # argparse will handle its own exceptions and exit with a message

    args = parser.parse_args()

    host = args.host
    password = args.password
    port = int(args.port)
    critical = int(args.critical)
    warning = int(args.warning)

    # Validate args

    if warning <= 0:
        print('UNKNOWN - Warning ({0}) must be greater than 0'.format(warning))
        raise SystemExit(UNKNOWN)

    if critical <= 0:
        print('UNKNOWN - Critical ({0}) must be greater than 0'.format(critical))
        raise SystemExit(UNKNOWN)
    if critical <= warning:
        print('UNKNOWN - Critical ({0}) must be greater than Warning ({1})'.format(critical, warning))
        raise SystemExit(UNKNOWN)

    try:
        i = redis.StrictRedis(host=host, port=port, password=password)
    except:
        print('UNKNOWN - unable to access redis server {0}:{1} using password "{2}"'.format(host, port, password))
        raise SystemExit(UNKNOWN)

    r = i.info('memory')

    used_memory = int(r['used_memory'])

    if used_memory >= critical:
        print('CRITICAL - used_memory={0}'.format(r['used_memory_human']))
        raise SystemExit(CRITICAL)
    if used_memory >= warning:
        print('WARNING - used_memory={0}'.format(r['used_memory_human']))
        raise SystemExit(WARNING)
    # If we got this far, let's tell Nagios the Redis queue length is okay (below the warning threshold).
    print('OK - used_memory={0}'.format(r['used_memory_human']))
    raise SystemExit(OK)


if __name__ == '__main__':
    main(sys.argv[1:])
