
#
# Zeppelin Hash
#   by mveera
#
#   Prints a highly randomized, secure password hash to be inserted into linux /etc/shadow files. 
#   Remember to: sudo pip install passlib

import crypt, getpass, random, string
from passlib.hash import sha512_crypt

salt_length = 13
salt_string = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(salt_length))
password_string = getpass.getpass()
number_of_rounds = int(random.random() * 10000)

# return password hash
print sha512_crypt.encrypt(password_string, rounds=number_of_rounds, salt=salt_string)
