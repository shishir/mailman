# Mailman

RESTFul service that provides an abstraction between Sendgrid and Mailman service providers. If Sendgrid service goes down, this service will failover to mailman.

## Table of Contents

1. [Usage](#usage)
1. [Architecture](#arch)
1. [Notes](#todos)
1. [Test](#test)
1. [Deployment](#test)


## <a name="usage"></a>Usage
### <a name="local-setup"></a>Local Setup

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

### <a name="send-email"></a>1. Sending email.
#### Request
```
> ./bin/example_request
```
OR

```
 curl -isb -H "Accept: application/json"  -H "Content-Type: application/json" -X POST -d '{"to":["mailman@gmail.com"], "from":"friend@gmail.com", "content":"Hi! There"}' http
://localhost:9292/mail/send
```

#### Sample Response
```
HTTP/1.1 201 Created
Content-Type: application/json
location: /mail/54
Content-Length: 75

{"mail":{"id":54,"links":[{"status":"/mail/54/status","self":"/mail/54"}]}}
```

### 2. Querying Status of a sent email
####  Request
```
  curl http://localhost:9292/mail/53/status
```
#### Sample Response
```
{"mail":{"id":53,"status":"sent","links":[{"self":"/mail/53/status","show":"/mail/53"}]}}
```



# <a name="arch"></a>Architecture (:
![Mailman](https://raw.githubusercontent.com/shishir/mailman/master/doc/arch.jpg)

## Components

1. *Backend Web service:* Rack. Modular, fast and lightweight Web-server interface.
2. *Datastore:* Mysql. Persistent backend for Restful service provides application state.
  Kafka is also a message store and provides ability to query.
3. *Kafka Consumer/Producers:* Phobos, Ruby framework for kafka. Wraps kafka-ruby gem, gives simple abstraction to write consumers/producers. Runs in standalone mode. Battle tested.
4. *Message Broker:* Apache Kafka: event sourcing framework for durability, speed and scalability.

#### Backend Web service
  - Rack/puma based RESTful Web service.
  - Valid End-Consumer endpoints
      1. POST /mail/send
   This will save the message in Mysql. Drop a message to mailer queue. And return links for consumer to use to query status of the mail as response with appropriate status code.
      2. GET /mail/:id/status
   Return the current status(sending|sent|failed) of the mail.
  - Valid end-points used by bookkeeper.
      1. POST /mail/:id/sent. Indicates success.
      2. POST /mail/:id/failed. Indicates failure.
  - config.ru in the entry point.

#### Consumers
  - Phobos standalone app. Each instance of phobos have sengrid/mailgun/bookkeeper handlers running.
    - Sengrid: Listens to mailer queue and makes call to Sengrid API.
    - Mailgun: Listens to backup-mailer queuue and makes call to Mailgun API.
    - Bookkeeper: Listens to status queue and makes call to RESTful service to update status of the email
  - In memory Circuit breaker trips on first timeout and then retries after 5 minutes to deal with network timeouts.

#### Producer
  - Phobos included in Web service as library.
    - mail_dispatcher.rb: publish message to mailer queue.

#### Message broker
  - Kafka is vendorized. binary under /vendor
  - Basic configuration in config/zookeeper.properties and server.properties
  - Bin stubs to start zookeeper and kafka are located in bin directory.
  - Development with only broker. Production setup would have multiple brokers distributed across AZ.

# <a name="todos"></a>Notes/TODOs
## Restful service
- Http caching for /mail/:id/status endpoint.
- Add Rack router for more idiomatic route matching
- Add appropriate Http response headers.
- Extend links in response to include all resource operations.
- Add consumer driven contracts in tests.
- Fail when request type other than json.
- Re-visit MySQL datastore. Kafka is a message store and querying it is possible.
- Security. Easy to DOS right now.
- Log aggregation.
- Extend Validations.
- Extend status api to return more information to the user in case of failure. /mail/:id/sent, /mail/:id/failed would also need to be extended.


## Consumer
-  Circuit breaker trips on first timeout and then retries after 5 minutes. Improvements:
    - Move circuit breaker state outside the consumers. So that multiple consumer can check state instead discovering the failure at individual level.
    - Exponential backoff.
- More detailed error handling of errors sent by downstream system.
- Back pressure, inform upstream that when load is high.
- Add Contracts between web-api mail format and sengrid/mailgun to avoid integration failures.
- Centralized logging
- Log aggregation.

# <a name="test"></a>Test
  - tests can be found under test directory.
  - test_request is an end-to-end test.
  - Contracts needs to be added. #pending

# <a name="deployment"></a>Deployment
  - Base ami using packer #pending.
  - AWS setup using terraform #pending.





