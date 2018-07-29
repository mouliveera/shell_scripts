#!/usr/bin/python3
"""
nagios_r4e_health_check.py: Nagios plugin to check to check the health of a R4E service

Author:  Michael Goll / Reputation.com

Arguments:
-h | --help -- display help
-H | --host <hostname> -- redis server hostname (required)
-p | --port <port> -- redis port (optional, default 9696)
"""

import sys
import argparse
import socket
import json

# script = os.path.basename(__file__)

# Exit statuses recognized by Nagios
UNKNOWN = -1
OK = 0
WARNING = 1
CRITICAL = 2


def main(argv):
    parser = argparse.ArgumentParser(description='Nagios plugin to check R4E service health')
    parser.add_argument('-H', '--host', dest='host', action='store', help='host name', required=True)
    parser.add_argument('-p', '--port', dest='port', type=int, action='store',
                        help='Health_check port (=service port + 20000)', required=True)

    # metavar gives the variable name for help,
    # otherwise it just upper cases dest

    # argparse will handle its own exceptions and exit with a message

    args = parser.parse_args()

    host = args.host
    port = int(args.port)

    # create an INET, STREAMing socket
    global s
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    except socket.error as e:
        print('UNKNOWN - Failed to create socket: {0}'.format(e))
        raise SystemExit(UNKNOWN)

    # resolve DNS name
    try:
        remote_ip = socket.gethostbyname(host)
    except socket.gaierror as e:
        # could not resolve
        print('UNKNOWN - Host name could not be resolved: {0}'.format(e))
        raise SystemExit(UNKNOWN)
        sys.exit()

    # set timeout to 10 seconds
    s.settimeout(10)

    # Connect to remote server
    try:
        s.connect((remote_ip, port))
    except socket.error as e:
        # connect failed
        print('WARNING - socket error - connect failed to ' + remote_ip + ':' + str(port) + ':' + '{0}'.format(e))
        raise SystemExit(WARNING)

    message = "GET /health\r\n\r\n"
    reply = health_check(message)
    json_dict = json.loads(reply)

    # we do not care if the close fails
    s.close

    if json_dict["status"].upper() == 'UP':
        print('OK - r4e service status is UP ' + reply)
        raise SystemExit(OK)
    else:
        print('CRITICAL - r4e services status is not UP! ' + reply)
        raise SystemExit(CRITICAL)


def health_check(message):
    """send a message to a server and get reply

    returns reply
    """
    try:
        # Set the whole string
#        print(message)
        s.sendall(bytes(message, "UTF-8"))
    except socket.error as e:
        # Send failed
        print('UNKNOWN - socket error - send failed: {0}'.format(e))
        raise SystemExit(UNKNOWN)

    # Now receive data
    try:
        reply = s.recv(4096).decode("utf-8").rstrip()
    except socket.error as e:
        # Receive failed
        print('UNKNOWN - socket error - receive failed: {0}'.format(e))
        raise SystemExit(UNKNOWN)
    return reply


if __name__ == "__main__":
    main(sys.argv[1:])
