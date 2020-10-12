## MongoDB

#### SQL     vs     NOSQL
    Tables        Collections





#### RoughNotes
```shell
switched to db mongo-mouli
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
> show collections
> db.createCollection("movies")
{ "ok" : 1 }
> show collections
movies
> show dbs
admin        0.000GB
config       0.000GB
local        0.000GB
mongo-mouli  0.000GB
> db.stats()
{
	"db" : "mongo-mouli",
	"collections" : 1,
	"views" : 0,
	"objects" : 0,
	"avgObjSize" : 0,
	"dataSize" : 0,
	"storageSize" : 4096,
	"indexes" : 1,
	"indexSize" : 4096,
	"totalSize" : 8192,
	"scaleFactor" : 1,
	"fsUsedSize" : 12324757504,
	"fsTotalSize" : 62725623808,
	"ok" : 1
}
> db.movies.delete
mongo-mouli.movies.delete
> db.stats()
{
	"db" : "mongo-mouli",
	"collections" : 1,
	"views" : 0,
	"objects" : 0,
	"avgObjSize" : 0,
	"dataSize" : 0,
	"storageSize" : 4096,
	"indexes" : 1,
	"indexSize" : 4096,
	"totalSize" : 8192,
	"scaleFactor" : 1,
	"fsUsedSize" : 12324794368,
	"fsTotalSize" : 62725623808,
	"ok" : 1
}
> show dbs
admin        0.000GB
config       0.000GB
local        0.000GB
mongo-mouli  0.000GB
> show collections
movies
> db.movies.delete
db.movies.deleteMany(  db.movies.deleteOne(
> db.movies.drop{}
uncaught exception: SyntaxError: unexpected token: '{' :
@(shell):1:14
> db.movies.drop()
true
> show collections
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
> cls
> exit
bye
root@centos:/# mongo
MongoDB shell version v4.4.0
connecting to: mongodb://127.0.0.1:27017/?compressors=disabled&gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("38d1eaea-3e64-4e7b-974a-8c6cef0f3a3d") }
MongoDB server version: 4.4.0
---
The server generated these startup warnings when booting:
        2020-08-22T14:38:34.158+00:00: Using the XFS filesystem is strongly recommended with the WiredTiger storage engine. See http://dochub.mongodb.org/core/prodnotes-filesystem
        2020-08-22T14:38:34.610+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted
---
---
        Enable MongoDB's free cloud-based monitoring service, which will then receive and display
        metrics about your deployment (disk utilization, CPU, operation statistics, etc).

        The monitoring data will be available on a MongoDB website with a unique URL accessible to you
        and anyone you share the URL with. MongoDB may use this information to make product
        improvements and to suggest MongoDB products and deployment options to you.

        To enable free monitoring, run the following command: db.enableFreeMonitoring()
        To permanently disable this reminder, run the following command: db.disableFreeMonitoring()
---
> db
test
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
> use testdb
switched to db testdb
> db
testdb
> db.movies.in
db.movies.initializeOrderedBulkOp(    db.movies.insertMany(
db.movies.initializeUnorderedBulkOp(  db.movies.insertOne(
db.movies.insert(
> db.movies.insert(
... {
...    "Name": "Mouli Veera"
...    "WorkPlace": "Hyderabad"
... }
... )
uncaught exception: SyntaxError: missing } after property list :
@(shell):4:3
> db.movies.insert( {    "Name": "Mouli Veera",    "WorkPlace": "Hyderabad" } )
WriteResult({ "nInserted" : 1 })
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
testdb  0.000GB
> show Collections
uncaught exception: Error: don't know how to show [Collections] :
shellHelper.show@src/mongo/shell/utils.js:1186:11
shellHelper@src/mongo/shell/utils.js:814:15
@(shellhelp2):1:1
> show collections
movies
> db.movies.find
function(query, fields, limit, skip, batchSize, options) {
    var cursor = new DBQuery(this._mongo,
                             this._db,
                             this,
                             this._fullName,
                             this._massageObject(query),
                             fields,
                             limit,
                             skip,
                             batchSize,
                             options || this.getQueryOptions());

    {
        const session = this.getDB().getSession();

        const readPreference = session._getSessionAwareClient().getReadPreference(session);
        if (readPreference !== null) {
            cursor.readPref(readPreference.mode, readPreference.tags);
        }

        const readConcern = session._getSessionAwareClient().getReadConcern(session);
        if (readConcern !== null) {
            cursor.readConcern(readConcern.level);
        }
    }

    return cursor;
}
> db.movies.find().pretty()
{
	"_id" : ObjectId("5f4135e3114d50344edcfa1e"),
	"Name" : "Mouli Veera",
	"WorkPlace" : "Hyderabad"
}
> show collections
movies
> db.movies.in
db.movies.initializeOrderedBulkOp(    db.movies.insertMany(
db.movies.initializeUnorderedBulkOp(  db.movies.insertOne(
db.movies.insert(
> db.movies.insert
db.movies.insert(      db.movies.insertMany(  db.movies.insertOne(
> db.movies.insert(
... {
...   "Name": "Deepu"
... ,
...   "WorkPlace": "Hyderabad"
... ,
...   "Phone": 123456
... }
... )
WriteResult({ "nInserted" : 1 })
> db.movies.find().pretty()
{
	"_id" : ObjectId("5f4135e3114d50344edcfa1e"),
	"Name" : "Mouli Veera",
	"WorkPlace" : "Hyderabad"
}
{
	"_id" : ObjectId("5f41425f114d50344edcfa1f"),
	"Name" : "Deepu",
	"WorkPlace" : "Hyderabad",
	"Phone" : 123456
}
> db.movies.find().pretty()^C
bye
root@centos:/# mongo
MongoDB shell version v4.4.0
connecting to: mongodb://127.0.0.1:27017/?compressors=disabled&gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("64f172a6-4c15-45d0-9830-6c8afb0419cc") }
MongoDB server version: 4.4.0
---
The server generated these startup warnings when booting:
        2020-08-22T14:38:34.158+00:00: Using the XFS filesystem is strongly recommended with the WiredTiger storage engine. See http://dochub.mongodb.org/core/prodnotes-filesystem
        2020-08-22T14:38:34.610+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted
---
---
        Enable MongoDB's free cloud-based monitoring service, which will then receive and display
        metrics about your deployment (disk utilization, CPU, operation statistics, etc).

        The monitoring data will be available on a MongoDB website with a unique URL accessible to you
        and anyone you share the URL with. MongoDB may use this information to make product
        improvements and to suggest MongoDB products and deployment options to you.

        To enable free monitoring, run the following command: db.enableFreeMonitoring()
        To permanently disable this reminder, run the following command: db.disableFreeMonitoring()
---
> db.movies.insert(
... {
...   "Name": "Manasa"
... ,
...   "WorkPlace": "Hyderabad",
...   "Phone": 900189324,
...   "Launguage": English,
...   "Likes": Toys
... }
... )
uncaught exception: ReferenceError: English is not defined :
@(shell):7:3
> db.movies.insert( {   "Name": "Manasa" ,   "WorkPlace": "Hyderabad",   "Phone": 900189324,   "Launguage": "English",   "Likes": "Toys" } )
WriteResult({ "nInserted" : 1 })
> db.movies.find().pretty()
{
	"_id" : ObjectId("5f41430caf3809a395b4b606"),
	"Name" : "Manasa",
	"WorkPlace" : "Hyderabad",
	"Phone" : 900189324,
	"Launguage" : "English",
	"Likes" : "Toys"
}
> db.movies.find().pretty()
{
	"_id" : ObjectId("5f41430caf3809a395b4b606"),
	"Name" : "Manasa",
	"WorkPlace" : "Hyderabad",
	"Phone" : 900189324,
	"Launguage" : "English",
	"Likes" : "Toys"
}
> show collections
movies
> db.movies.update(
... {}
... db.movies.find().pretty()
... db.movies.insertMany( [{   "Name": "Manasa" ,   "WorkPlace": "Hyderabad",   "Phone": 900189324,   "Launguage": "English",   "Likes": "Toys" }, {"Name": "Mouli" ,   "WorkPlace": "Hyderabad"}, {   "Name": "Manasa" ,   "WorkPlace": "Hyderabad",   "Phone": 123456789 }] )
... )
uncaught exception: SyntaxError: missing ) after argument list :
@(shell):3:0
> db.movies.insertMany( [{   "Name": "Manasa" ,   "WorkPlace": "Hyderabad",   "Phone": 900189324,   "Launguage": "English",   "Likes": "Toys" }, {"Name": "Mouli" ,   "WorkPlace": "Hyderabad"}, {   "Name": "Manasa" ,   "WorkPlace": "Hyderabad",   "Phone": 123456789 }] )
{
	"acknowledged" : true,
	"insertedIds" : [
		ObjectId("5f41445faf3809a395b4b607"),
		ObjectId("5f41445faf3809a395b4b608"),
		ObjectId("5f41445faf3809a395b4b609")
	]
}
> db.movies.find().pretty()
{
	"_id" : ObjectId("5f41430caf3809a395b4b606"),
	"Name" : "Manasa",
	"WorkPlace" : "Hyderabad",
	"Phone" : 900189324,
	"Launguage" : "English",
	"Likes" : "Toys"
}
{
	"_id" : ObjectId("5f41445faf3809a395b4b607"),
	"Name" : "Manasa",
	"WorkPlace" : "Hyderabad",
	"Phone" : 900189324,
	"Launguage" : "English",
	"Likes" : "Toys"
}
{
	"_id" : ObjectId("5f41445faf3809a395b4b608"),
	"Name" : "Mouli",
	"WorkPlace" : "Hyderabad"
}
{
	"_id" : ObjectId("5f41445faf3809a395b4b609"),
	"Name" : "Manasa",
	"WorkPlace" : "Hyderabad",
	"Phone" : 123456789
}
> db.movies.update(
... {
...   "Name": "Mouli"},
... {$set: {"Launguage" : "Telugu"}}
... )
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.movies.find().pretty()
{
	"_id" : ObjectId("5f41430caf3809a395b4b606"),
	"Name" : "Manasa",
	"WorkPlace" : "Hyderabad",
	"Phone" : 900189324,
	"Launguage" : "English",
	"Likes" : "Toys"
}
{
	"_id" : ObjectId("5f41445faf3809a395b4b607"),
	"Name" : "Manasa",
	"WorkPlace" : "Hyderabad",
	"Phone" : 900189324,
	"Launguage" : "English",
	"Likes" : "Toys"
}
{
	"_id" : ObjectId("5f41445faf3809a395b4b608"),
	"Name" : "Mouli",
	"WorkPlace" : "Hyderabad",
	"Launguage" : "Telugu"
}
{
	"_id" : ObjectId("5f41445faf3809a395b4b609"),
	"Name" : "Manasa",
	"WorkPlace" : "Hyderabad",
	"Phone" : 123456789
}
> db.movies.update( {   "Phone": 123456789}, {$set: {"Name" : "Deepu"}} )
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
> db.movies.find().pretty()
{
	"_id" : ObjectId("5f41430caf3809a395b4b606"),
	"Name" : "Manasa",
	"WorkPlace" : "Hyderabad",
	"Phone" : 900189324,
	"Launguage" : "English",
	"Likes" : "Toys"
}
{
	"_id" : ObjectId("5f41445faf3809a395b4b607"),
	"Name" : "Manasa",
	"WorkPlace" : "Hyderabad",
	"Phone" : 900189324,
	"Launguage" : "English",
	"Likes" : "Toys"
}
{
	"_id" : ObjectId("5f41445faf3809a395b4b608"),
	"Name" : "Mouli",
	"WorkPlace" : "Hyderabad",
	"Launguage" : "Telugu"
}
{
	"_id" : ObjectId("5f41445faf3809a395b4b609"),
	"Name" : "Deepu",
	"WorkPlace" : "Hyderabad",
	"Phone" : 123456789
}
> db.movies.delete
db.movies.deleteMany(  db.movies.deleteOne(
> db.movies.deleteOne(
... {
...   "_id" : ObjectId("5f41445faf3809a395b4b607"
... }
... )
...
... )
uncaught exception: SyntaxError: missing ) after argument list :
@(shell):4:0
> db.movies.deleteOne( {   "_id" : ObjectId("5f41445faf3809a395b4b607")}  )
{ "acknowledged" : true, "deletedCount" : 1 }
> db.movies.find().pretty()
{
	"_id" : ObjectId("5f41430caf3809a395b4b606"),
	"Name" : "Manasa",
	"WorkPlace" : "Hyderabad",
	"Phone" : 900189324,
	"Launguage" : "English",
	"Likes" : "Toys"
}
{
	"_id" : ObjectId("5f41445faf3809a395b4b608"),
	"Name" : "Mouli",
	"WorkPlace" : "Hyderabad",
	"Launguage" : "Telugu"
}
{
	"_id" : ObjectId("5f41445faf3809a395b4b609"),
	"Name" : "Deepu",
	"WorkPlace" : "Hyderabad",
	"Phone" : 123456789
}
> db.movies.find("Name" : "Manasa").pretty()
uncaught exception: SyntaxError: missing ) after argument list :
@(shell):1:22
> db.movies.find({"Name" : "Manasa"]).pretty()
uncaught exception: SyntaxError: missing } after property list :
@(shell):1:33
> db.movies.find({"Name" : "Manasa"])
uncaught exception: SyntaxError: missing } after property list :
@(shell):1:33
> db.movies.find()
{ "_id" : ObjectId("5f41430caf3809a395b4b606"), "Name" : "Manasa", "WorkPlace" : "Hyderabad", "Phone" : 900189324, "Launguage" : "English", "Likes" : "Toys" }
{ "_id" : ObjectId("5f41445faf3809a395b4b608"), "Name" : "Mouli", "WorkPlace" : "Hyderabad", "Launguage" : "Telugu" }
{ "_id" : ObjectId("5f41445faf3809a395b4b609"), "Name" : "Deepu", "WorkPlace" : "Hyderabad", "Phone" : 123456789 }
> db.movies.find({"Name" : "Manasa"})
{ "_id" : ObjectId("5f41430caf3809a395b4b606"), "Name" : "Manasa", "WorkPlace" : "Hyderabad", "Phone" : 900189324, "Launguage" : "English", "Likes" : "Toys" }
> db.movies.find({"Name" : "Manasa"}).pretty()
{
	"_id" : ObjectId("5f41430caf3809a395b4b606"),
	"Name" : "Manasa",
	"WorkPlace" : "Hyderabad",
	"Phone" : 900189324,
	"Launguage" : "English",
	"Likes" : "Toys"
}
> db.movies.find({"WorkPlace" : "Hyd*"}).pretty()
> db.movies.find({"WorkPlace" : "Hyderabad"}).pretty()
{
	"_id" : ObjectId("5f41430caf3809a395b4b606"),
	"Name" : "Manasa",
	"WorkPlace" : "Hyderabad",
	"Phone" : 900189324,
	"Launguage" : "English",
	"Likes" : "Toys"
}
{
	"_id" : ObjectId("5f41445faf3809a395b4b608"),
	"Name" : "Mouli",
	"WorkPlace" : "Hyderabad",
	"Launguage" : "Telugu"
}
{
	"_id" : ObjectId("5f41445faf3809a395b4b609"),
	"Name" : "Deepu",
	"WorkPlace" : "Hyderabad",
	"Phone" : 123456789
}
> db.movies.find({"WorkPlace" : {$re hyd}}).pretty()
uncaught exception: SyntaxError: missing : after property id :
@(shell):1:35
> db.movies.find({"WorkPlace" : {$re: hyd}}).pretty()
uncaught exception: ReferenceError: hyd is not defined :
@(shell):1:32
> db.movies.find({"WorkPlace" : {$re: Hyd}}).pretty()
uncaught exception: ReferenceError: Hyd is not defined :
@(shell):1:32
> db.movies.find({"WorkPlace" : {$regex: Hyd}}).pretty()
uncaught exception: ReferenceError: Hyd is not defined :
@(shell):1:32
> db.movies.find({"WorkPlace" : {$regex: Hyd}})
uncaught exception: ReferenceError: Hyd is not defined :
@(shell):1:32
> db.movies.find({"WorkPlace" : {$regex: /Hyd}})
uncaught exception: SyntaxError: unterminated regular expression literal :
@(shell):1:39
> db.movies.find({"WorkPlace" : { $regex: /Hyd }})
uncaught exception: SyntaxError: unterminated regular expression literal :
@(shell):1:40
> db.movies.find({"WorkPlace" : { $regexFind: "Hyd" }})
Error: error: {
	"ok" : 0,
	"errmsg" : "unknown operator: $regexFind",
	"code" : 2,
	"codeName" : "BadValue"
}
> db.movies.find({"WorkPlace" : { $regexFind: Hyd }})
uncaught exception: ReferenceError: Hyd is not defined :
@(shell):1:33
> db.movies.find({"WorkPlace" : { $regexFind: "Hyd" , strength: 1 }})
Error: error: {
	"ok" : 0,
	"errmsg" : "unknown operator: $regexFind",
	"code" : 2,
	"codeName" : "BadValue"
}
> db.movies.find({"WorkPlace" : { $regex: "Hyd" , strength: 1 }})
Error: error: {
	"ok" : 0,
	"errmsg" : "unknown operator: strength",
	"code" : 2,
	"codeName" : "BadValue"
}
> db.movies.find({"WorkPlace" : { $regex: "Hyd" }})
{ "_id" : ObjectId("5f41430caf3809a395b4b606"), "Name" : "Manasa", "WorkPlace" : "Hyderabad", "Phone" : 900189324, "Launguage" : "English", "Likes" : "Toys" }
{ "_id" : ObjectId("5f41445faf3809a395b4b608"), "Name" : "Mouli", "WorkPlace" : "Hyderabad", "Launguage" : "Telugu" }
{ "_id" : ObjectId("5f41445faf3809a395b4b609"), "Name" : "Deepu", "WorkPlace" : "Hyderabad", "Phone" : 123456789 }
> db.movies.find({"WorkPlace" : { $regex: "Hyd" }}).pretty
function() {
    this._prettyShell = true;
    return this;
}
> db.movies.find({"WorkPlace" : { $regex: "Hyd" }}).pretty()
{
	"_id" : ObjectId("5f41430caf3809a395b4b606"),
	"Name" : "Manasa",
	"WorkPlace" : "Hyderabad",
	"Phone" : 900189324,
	"Launguage" : "English",
	"Likes" : "Toys"
}
{
	"_id" : ObjectId("5f41445faf3809a395b4b608"),
	"Name" : "Mouli",
	"WorkPlace" : "Hyderabad",
	"Launguage" : "Telugu"
}
{
	"_id" : ObjectId("5f41445faf3809a395b4b609"),
	"Name" : "Deepu",
	"WorkPlace" : "Hyderabad",
	"Phone" : 123456789
}
> db.movies.find({"Likes" : { $regex: "toy" }}).pretty()
> db.movies.find({"Likes" : { $regex: "Toy" }}).pretty()
{
	"_id" : ObjectId("5f41430caf3809a395b4b606"),
	"Name" : "Manasa",
	"WorkPlace" : "Hyderabad",
	"Phone" : 900189324,
	"Launguage" : "English",
	"Likes" : "Toys"
}
```

#### To Suppress a field in the document
Ex: We are trying to Suppress ID field here.
```bash
> db.movies.find({}, {"_id": 0}).pretty()
{
	"Name" : "Manasa",
	"WorkPlace" : "Hyderabad",
	"Phone" : 900189324,
	"Launguage" : "English",
	"Likes" : "Toys"
}
{ "Name" : "Mouli", "WorkPlace" : "Hyderabad", "Launguage" : "Telugu" }
{ "Name" : "Deepu", "WorkPlace" : "Hyderabad", "Phone" : 123456789 }
```

#### To get the document count in a collection
> db.movies.count()
2
>  db.movies.stats()
# To get specific record count.
> db.movies.count({"Name": "Deepu"})
1
# With regularExpression
> db.movies.count({"Name": {$regex: "Mouli"}})
1

#### Delete a document with one of fields
It deletes the all the documents your collection with WorkPlace: Hyderabab
```bash
> db.movies.deleteMany({"WorkPlace" : "Hyderabad"})
```

#### Delete the collection in the DB and database
```bash
> db.movies.drop()

> db
testdb
> db.dropDatabase()
{ "dropped" : "testdb", "ok" : 1 }
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
test    0.000GB
```


#### Enable Access Control
Source: https://docs.mongodb.com/manual/tutorial/enable-authentication/

```bash
use admin
db.createUser(
  {
    user: "superuser",
    pwd: "abc123",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase" ]
  }
)
```

Test User:
```
use test
db.createUser(
  {
    user: "testuser",
    pwd:  "abc123",
    roles: [ { role: "readWrite", db: "test" },
             { role: "read", db: "reporting" } ]
  }
)
```

Access check:
root@ubuntu:/# mongo -u "testuser" -p "abc123" --authenticationDatabase admin
MongoDB shell version v4.4.0
connecting to: mongodb://127.0.0.1:27017/?authSource=admin&compressors=disabled&gssapiServiceName=mongodb
Error: Authentication failed. :
connect@src/mongo/shell/mongo.js:362:17
@(connect):2:6
exception: connect failed
exiting with code 1

root@ubuntu:/# mongo -u "testuser" -p "abc123" --authenticationDatabase test


#### Backup & Restore MongoDB database:
mongodump -> It helps to take the dump of all your databases and collections
Ex:
> mongodump
root@ubuntu:/# tree dump
dump
|-- admin
|   |-- system.users.bson
|   |-- system.users.metadata.json
|   |-- system.version.bson
|   `-- system.version.metadata.json
`-- mydb
    |-- extended_family.bson
    |-- extended_family.metadata.json
    |-- family.bson
    `-- family.metadata.json
--
> mongodump --out MyDBDump
root@ubuntu:/# tree MyDBDump/
MyDBDump/
|-- admin
|   |-- system.users.bson
|   |-- system.users.metadata.json
|   |-- system.version.bson
|   `-- system.version.metadata.json
`-- mydb
    |-- extended_family.bson
    |-- extended_family.metadata.json
    |-- family.bson
    `-- family.metadata.json

2 directories, 8 files

#### Specific DB dump
```bash
root@ubuntu:/# mongodump --db mydb --out mydb-dump
2020-08-22T20:16:15.690+0000	writing mydb.family to mydb-dump/mydb/family.bson
2020-08-22T20:16:15.691+0000	writing mydb.extended_family to mydb-dump/mydb/extended_family.bson
2020-08-22T20:16:15.692+0000	done dumping mydb.family (3 documents)
2020-08-22T20:16:15.692+0000	done dumping mydb.extended_family (2 documents)
root@ubuntu:/# tree mydb-dump
mydb-dump
`-- mydb
    |-- extended_family.bson
    |-- extended_family.metadata.json
    |-- family.bson
    `-- family.metadata.json

1 directory, 4 files
```

#### Specific collections
```
root@ubuntu:/# mongodump --db mydb --collection family --out mydb-family-dump
2020-08-22T20:18:18.423+0000	writing mydb.family to mydb-family-dump/mydb/family.bson
2020-08-22T20:18:18.424+0000	done dumping mydb.family (3 documents)
root@ubuntu:/# tree mydb-family-dump
mydb-family-dump
`-- mydb
    |-- family.bson
    `-- family.metadata.json

1 directory, 2 files

----
root@ubuntu:/# mongodump --db mydb --excludeCollection=family --out mydb-ex-family-dump
2020-08-22T20:20:31.138+0000	writing mydb.extended_family to mydb-ex-family-dump/mydb/extended_family.bson
2020-08-22T20:20:31.139+0000	done dumping mydb.extended_family (2 documents)
root@ubuntu:/# ls -l mydb-ex-family-dump
total 4
drwxr-xr-x 2 root root 4096 Aug 22 20:20 mydb
root@ubuntu:/# tree mydb-ex-family-dump
mydb-ex-family-dump
`-- mydb
    |-- extended_family.bson
    `-- extended_family.metadata.json
```

#### Restore
```
> use mydb
switched to db mydb
> db.drop()
uncaught exception: TypeError: db.drop is not a function :
@(shell):1:1
> db.dropDatabase()
{ "dropped" : "mydb", "ok" : 1 }
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
> exit
bye

root@ubuntu:/# mongorestore MyDBDump
2020-08-22T20:28:00.045+0000	preparing collections to restore from
2020-08-22T20:28:00.047+0000	reading metadata for mydb.family from MyDBDump/mydb/family.metadata.json
2020-08-22T20:28:00.048+0000	reading metadata for mydb.extended_family from MyDBDump/mydb/extended_family.metadata.json
2020-08-22T20:28:00.057+0000	restoring mydb.extended_family from MyDBDump/mydb/extended_family.bson
2020-08-22T20:28:00.059+0000	no indexes to restore
2020-08-22T20:28:00.059+0000	finished restoring mydb.extended_family (2 documents, 0 failures)
2020-08-22T20:28:00.059+0000	restoring mydb.family from MyDBDump/mydb/family.bson
2020-08-22T20:28:00.066+0000	no indexes to restore
2020-08-22T20:28:00.066+0000	finished restoring mydb.family (3 documents, 0 failures)
2020-08-22T20:28:00.067+0000	restoring users from MyDBDump/admin/system.users.bson
2020-08-22T20:28:00.091+0000	5 document(s) restored successfully. 0 document(s) failed to restore.
root@ubuntu:/# mongo
MongoDB shell version v4.4.0
connecting to: mongodb://127.0.0.1:27017/?compressors=disabled&gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("3426f1f6-283a-47c9-b745-4e156b578112") }
MongoDB server version: 4.4.0
---
The server generated these startup warnings when booting:
        2020-08-22T19:19:12.125+00:00: Using the XFS filesystem is strongly recommended with the WiredTiger storage engine. See http://dochub.mongodb.org/core/prodnotes-filesystem
        2020-08-22T19:19:12.762+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted
---
---
        Enable MongoDB's free cloud-based monitoring service, which will then receive and display
        metrics about your deployment (disk utilization, CPU, operation statistics, etc).

        The monitoring data will be available on a MongoDB website with a unique URL accessible to you
        and anyone you share the URL with. MongoDB may use this information to make product
        improvements and to suggest MongoDB products and deployment options to you.

        To enable free monitoring, run the following command: db.enableFreeMonitoring()
        To permanently disable this reminder, run the following command: db.disableFreeMonitoring()
---
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
mydb    0.000GB
> use mydb
switched to db mydb
> show collections
extended_family
family
> db.extended_family.find().pretty()
{
	"_id" : ObjectId("5f417b2390b25a99b627ee6c"),
	"Name" : "RK",
	"Status" : "Father"
}
{
	"_id" : ObjectId("5f417b2390b25a99b627ee6d"),
	"Name" : "Vijaya",
	"Status" : "Mother"
}
> db.family.find().pretty()
{
	"_id" : ObjectId("5f417a8c90b25a99b627ee69"),
	"Name" : "Mouli",
	"Status" : "1"
}
{
	"_id" : ObjectId("5f417a8c90b25a99b627ee6a"),
	"Name" : "Deepu",
	"Status" : "2"
}
{
	"_id" : ObjectId("5f417a8c90b25a99b627ee6b"),
	"Name" : "Manasa",
	"Status" : "3"
}
```

centos  172.18.0.3
mongodb0  172.18.0.5
ubuntu  172.18.0.4

rs.initiate( {
   _id : "rs0",
   members: [
      { _id: 0, host: "mongo-0:27017" },
      { _id: 1, host: "mongo-1:27017" },
      { _id: 2, host: "mongo-2:27017" }
   ]
})
