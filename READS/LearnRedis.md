## LEARN REDIS

Redis is a Open source, BSD licensed advanced key-value store. Its a InMemory key-value store, with persistence.[That means it can be used a database or caching layer or a message broker]

REDIS is a key-value store and often referred as data structured server. keys can contain strings, hashes, List, sets and sorted sets.

#### Redis: Stands for REmote DIctionar Server

Written in C and it is NoSql database

##### Advantages:
Exceptionally Fast: Redis is very fast and can perform about 110000 SETS per second and about 81000 GETS per second

Supports rich data types: It uses most of datatypes which developers known such as lists, strings, sets, sorted sets and hashes.

Operations are atomic: If two clients access redis server concurrently, redis server receives the updated value

Example use case: Any Short lived data in your application, such as web application sessions, web page hit count etc.

##### REDIS DataTypes:
Redis supports 5 data types - Strings, Lists, Hashes, Sets, Sorted Sets
Strings: String is sequence of bytes. You can store anything up to 512 megabytes in one string. Redis strings commands are used for managing string values in Redis.

STRINGS:

```shell

SET used to load string values to Keys
GET Gets the value of the key.
DEL key_name
KEYs Find the all KEYs matching the specified pattern
EXPIRE: EXPIRE key seconds - Set expiry of the keys after specified time.
Hashes: Hashes is a collections of key value pairs.
PERSIST: Remove expiration of the keys
TTL: Gets the remaining time in keys expiry.
RENAME: Change the key_name
GETRANGE: Gets a substring of the string stored at a key.
GETSET: Sets the string value of a key and return its old value.
TYPE: Return datatype of value stored in the key.
EX:
127.0.0.1:6379> type <KEY_NAME>
list
--
127.0.0.1:6379> type myname
string

```

HASHES:
- Hashes are maps between string fields and string values. Its a collections of key value pairs.
- Every hash can store more than 4 billion field value pairs.


LISTS:

Redis lists are simply lists of strings, sorted by insertion order
```shell
LPUSH: Add a value to list
LPOP: Remove an element from the List
LLEN: Gets the length of the list
```

SET:
- Redis Sets are an unordered collection of unique strings. Sets does not allow repetition of data in a key.
```shell
SADD: Add one or more members to a set
SMEMBERS: Get the members in the key
SMOVE: Move members from one set to another [Ex: SMOVE source destination member]
SUNION: Adds multiple set.
```
SORTED SET: 
- Similar to sets and addon is it gives score to the value. Every member of sorted set is associated with a score.
```shell
ZADD test 1 redis
```

## Redis - Publish Subscribe
Redis Pub/Sub implements the messaging system where the senders (in redis terminology called publishers) sends the messages while the receivers (subscribers) receive them. The link by which the messages are transferred is called channel.

Subscribe open a channel and publisher sends messages using channels.

## Redis - Transactions:
It allows you to execute group of commands in a single step. Run MULTI and start passing commands, once you are done with passing all the commands. Run EXEC to end it. We can see it runs the all the commands in a sequence.

Use DISCARD to discard all commands.


## Some HelpFul commands
EVAL helps us to write Redis scripting[Lua interpreter, started from redis 2.6.0]

INFO commands for redis server statistics[INFO memory, INFO CPU, INFO connected_clients, etc.]

CLIENT LIST : Commands to list the connections

## Maximum Number of Clients
In Redis config (redis.conf), there is a property called maxclients, which describes the maximum number of clients that can connect to Redis.
```shell
127.0.0.1:6379> CONFIG GET maxclients
1) "maxclients"
2) "10000"
```
------------------------------------------------
Redis - BackUp
Redis SAVE/BGSAVE command is used to create a backup of the current Redis database.
To View the dump or back up run # CONFIG get dir -> to view the rdb files.

Source: https://www.tutorialspoint.com/redis/redis_useful_resources.htm
