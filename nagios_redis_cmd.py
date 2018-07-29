#!/usr/bin/python3
"""
nagios_redis_cmd.py: Nagios plugin to check the results
of an arbitrary redis command

Author:  Michael Goll / Reputation.com

Arguments:
-h | --help -- display help
-c | --cmd <command string> -- command (required)
-r | --regex <regex> -- expected result (optional)
-H | --host <hostname> -- redis server hostname (optional, default redis)
-p | --port <port> -- redis port (optional, default 9696)
-a | --password <password> (optional)
"""

import sys
import argparse
import socket
import re

# script = os.path.basename(__file__)

# Exit statuses recognized by Nagios
UNKNOWN = -1
OK = 0
WARNING = 1
CRITICAL = 2


def main(argv):
    parser = argparse.ArgumentParser(description='Nagios plugin to issue Redis command')
    parser.add_argument('-c', '--cmd', dest='cmd', action='store',
                        help='redis command', required=True)
    parser.add_argument('-r', '--regex', dest='regex', action='store',
                        help='regex for expect result', default='.*')
    parser.add_argument('-H', '--host', dest='host', action='store', help='host name', required=False, default='redis')
    parser.add_argument('-p', '--port', dest='port', type=int, action='store', help='Redis port', required=False,
                        default=9696)
    parser.add_argument('-a', '--password', dest='password', nargs='?', default='', action='store',
                        help='Redis password', required=False)

    # metavar gives the variable name for help,
    # otherwise it just upper cases dest
    # argparse handles its own exceptions

    args = parser.parse_args()

    host = args.host
    password = args.password
    port = int(args.port)
    cmd = args.cmd
    regex = args.regex

    # Validate args
    try:
        result_regex = re.compile(regex)
    except:
        print("UNKNOWN - invalid regex '%s'" % regex)
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
        auth = "AUTH " + password
        reply = redis_cmd(auth)
        if reply != 'OK':
            print('UNKNOWN - unable to authenticate: %s' % reply)
            raise SystemExit(UNKNOWN)

    # Send command to redis
    reply = redis_cmd(cmd)

    # we do not care if the close fails
    s.close

    if result_regex.match(reply):
        print("OK - '%s'='%s' result regex='%s'" % (cmd,reply,regex))
        raise SystemExit(OK)
    else:
        print("CRITICAL - '%s'='%s' result regex='%s'" % (cmd,reply,regex))
        raise SystemExit(CRITICAL)

def redis_cmd(cmd):
    try:
        # Set the whole string
        s.sendall(bytes(cmd + '\r\n', "UTF-8"))
    except socket.error as e:
        # Send failed
        print('UNKNOWN - socket error - send failed: %s' % str(e))
        raise SystemExit(UNKNOWN)

    # Now receive data
    try:
        reply = s.recv(4096).decode("utf-8")[1:].rstrip()
    except socket.error as e:
        # Receive failed
        print('UNKNOWN - socket error - receive failed: %s' % str(e))
        raise SystemExit(UNKNOWN)
    return re.sub(r'^[^\n]*\n', '', reply)


if __name__ == "__main__":
    main(sys.argv[1:])
