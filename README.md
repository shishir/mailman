# Mailman

Scaled fault tolerant mail service

# Stack
Choosing ruby based frameworks due to my familiarity and time constraint. In a real application would have chosen IRIS instead of Rack. Chose Rack because its the most Performant. (SEE)[https://blog.altoros.com/performance-comparison-of-ruby-frameworks-app-servers-template-engines-and-orms-q4-2016.html]
- Web API - rack, puma, active-record, mysql
- Phobos - Kafka consumer (Light wrapper around ruby-kafka with abstracted configuration)
- Kafka - To build Event Sourcing solution.



