# Mailman

 - RESTFul service that provides an abstraction between Sendgrid and Mailman service providers. If Sendgrid service goes down, this service will failover to mailman.

# Usage


```
  > git clone https://github.com/shishir/mailman. #clone the repository
  > cd mailman
  > bundle                                        #install gem dependencies
```
Note: .ruby-version is 2.4.0. Change for other version. tested only in 2.4.0

```
  > cd mailman
  > ./bin/zookeeper-start-server.sh               # Start zookeeper. binds to port 2182. SEE config/zookeeper.properties for configuration
  > ./bin/kafka-start-server.sh                   # Start kafka. SEE config/server.properties for configuration
  > phobos start                                  # Start phobos. SEE config/phobos.yml for configurations
  > ./bin/web                                     # Start Web server. app.rb is the entry point
```

### Sending email.
#### Request
```
> ./bin/example_request
```
OR

```
> curl -isb -H "Accept: application/json"  -H "Content-Type: application/json" -X POST -d '{"to":["mailman@gmail.com"], "from":"friend@gmail.com", "content":"Hi! There"}' http
://localhost:9292/send
```

#### Sample Response
```
HTTP/1.1 201 Created
Content-Type: application/json
location: /mail/54
Content-Length: 75

{"mail":{"id":54,"links":[{"status":"/mail/54/status","self":"/mail/54"}]}}
```

### Querying Status of a sent email
####  Request
```
  > curl http://localhost:9292/mail/53/status
```
#### Sample Response
```
{"mail":{"id":53,"status":"sent","links":[{"self":"/mail/53/status","show":"/mail/53"}]}}
```



# Stack

- *Restful Service:* Rack, Modular, fast and lightweight Web-server interface.
- *Datastore:* Mysql. Persistent backend for Restful service provides application state.
  Kafka is also a message store and provides ability to query.
- *Kafka Consumer/Producers:* Phobos, Ruby framework for kafka. Wraps kafka-ruby gem, gives simple abstraction to write consumers/producers. Runs in standalone mode. Being used in production.
- *Message Broker:* Apache Kafka: event sourcing framework for durability, speed and scalability.


# Architecture
- insert image here
![Mailman](https://raw.githubusercontent.com/shishir/mailman/master/doc/arch.jpg)
# Installation



# Notes
- Web and Kafka Consumer Tests can be separated.
- Should sendgrid know about the format in which email is store in the database or should it request the api to give data in a specified format. In a production system, this will be enforced using contracts where consumer would be aware of the contract and any breakage will result in test failure.





