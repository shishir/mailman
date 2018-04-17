# Mailman

Scaled fault tolerant mail service

# Stack
Choosing ruby based frameworks due to my familiarity and time constraint. In a real application would have chosen IRIS instead of Rack. Chose Rack because its the most Performant. (SEE)[https://blog.altoros.com/performance-comparison-of-ruby-frameworks-app-servers-template-engines-and-orms-q4-2016.html]
- Web API - rack, puma, active-record, mysql
- Phobos - Kafka wrapper. Being used in production. Not sure if racecar is production ready.
- Kafka - To build Event Sourcing solution.


# Notes
- Web and Kafka Consumer Tests can be separated.
- Should sendgrid know about the format in which email is store in the database or should it request the api to give data in a specified format. In a production system, this will be enforced using contracts where consumer would be aware of the contract and any breakage will result in test failure.



