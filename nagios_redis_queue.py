#!/usr/bin/python3
"""
nagios_redis_queue.py: Nagios plugin to check to see if the length
of a specified Redis queue exceeds a threshold

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
import socket

# script = os.path.basename(__file__)

# Exit statuses recognized by Nagios
UNKNOWN = -1
OK = 0
WARNING = 1
CRITICAL = 2


def main(argv):
    parser = argparse.ArgumentParser(description='Nagios plugin to get Redis queue length')
    parser.add_argument('-c', '--critical', dest='critical', type=int, action='store',
                        help='critical threshold (must be greater than warning threshold)', required=True)
    parser.add_argument('-w', '--warning', dest='warning', type=int, action='store',
                        help='warning threshold (must be less than critical threshold', required=True)
    parser.add_argument('-H', '--host', dest='host', action='store', help='host name', required=False, default='redis')
    parser.add_argument('-p', '--port', dest='port', type=int, action='store', help='Redis port', required=False,
                        default=9696)
    parser.add_argument('-a', '--password', dest='password', nargs='?', default='', action='store',
                        help='Redis password', required=False)
    parser.add_argument('-q', '--queue', dest='queue', action='store', help='Redis queue', required=True)

    # metavar gives the variable name for help,
    # otherwise it just upper cases dest
    # argparse handles its own exceptions

    args = parser.parse_args()

    host = args.host
    password = args.password
    queue = args.queue
    port = int(args.port)
    critical = int(args.critical)
    warning = int(args.warning)

    # Validate args
    if critical <= warning:
        print('UNKNOWN - Critical (' + critical + ') must be greater than Warning (' + warning + ')')
        raise SystemExit(UNKNOWN)

    if warning <= 0:
        print('UNKNOWN - Warning (' + warning + ') must be greater than 0')
        raise SystemExit(UNKNOWN)

    if critical <= 0:
        print('UNKNOWN - Critical (' + critical + ') must be greater than 0')
        raise SystemExit(UNKNOWN)

    # create an INET, STREAMing socket
    global s
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    except socket.error as e:
        print('UNKNOWN - Failed to create socket:' + str(e))
        raise SystemExit(UNKNOWN)

    # resolve DNS name
    try:
        remote_ip = socket.gethostbyname(host)
    except socket.gaierror:
        # could not resolve
        print('UNKNOWN - Host name could not be resolved')
        raise SystemExit(UNKNOWN)
        sys.exit()

    # set timeout to 10 seconds
    s.settimeout(10)

    # Connect to remote server
    try:
        s.connect((remote_ip, port))
    except socket.error as e:
        # connect failed
        print('UNKNOWN - socket error - connect failed: ' + str(e))
        raise SystemExit(UNKNOWN)
    except socket.timeout as e:
        # connect failed
        print('UNKNOWN - timeout error - connect failed: ' + str(e))
        raise SystemExit(UNKNOWN)

    # Authenticate if password was supplied
    if password:
        cmd = "AUTH " + password + "\r\n"
        reply = redis_cmd(cmd)
        if reply != 'OK':
            print('UNKNOWN - unable to authenticate')
            raise SystemExit(UNKNOWN)

    # Send command to redis
    cmd = "LLEN " + str(queue) + "\r\n"
    reply = redis_cmd(cmd)

    # we do not care if the close fails
    s.close

    try:
        queue_length = int(reply)
    except:
        print('UNKNOWN - invalid queue length=' + reply)
        raise SystemExit(UNKNOWN)

    if queue_length >= critical:
        print('CRITICAL - ' + str(queue) + '=' + str(queue_length))
        raise SystemExit(CRITICAL)
    if queue_length >= warning:
        print('WARNING - ' + str(queue) + '=' + str(queue_length))
        raise SystemExit(WARNING)
    # If we got this far, let's tell Nagios the Redis queue length is okay (below the warning threshold).
    print('OK - ' + str(queue) + '=' + str(queue_length))
    raise SystemExit(OK)


def redis_cmd(cmd):
    try:
        # Set the whole string
        s.sendall(bytes(cmd, "UTF-8"))
    except socket.error:
        # Send failed
        print('UNKNOWN - socket error - send failed')
        raise SystemExit(UNKNOWN)

    # Now receive data
    try:
        reply = s.recv(4096).decode("utf-8")[1:].rstrip()
    except socket.error:
        # Receive failed
        print('UNKNOWN - socket error - receive failed')
        raise SystemExit(UNKNOWN)
    return reply


if __name__ == "__main__":
    main(sys.argv[1:])
