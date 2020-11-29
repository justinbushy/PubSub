# PubSub

This project is a playground to build a distributed messaging queue in Elixir. 
This is a project to learn more about distributed algorithms and the inner workings of current messaging brokers and message streaming services.


### Next Steps

- Create HTTP/WebSocket API endpoints and client library (In Progress)
- Add persistent topic storage. At first, this will be just a redis instance, but eventually build my own log-structured key-value store.
- Distribute topic caches to multiple nodes (This includes a lot of steps that I will update here when I get there)
- Distribute Server process (HTTP interfacing process) to multiple nodes and load balance between
- Document high-level architecture

### Purpose

The purpose of this repository is to learn more about building distributed systems and distributed algorithms. 
A lot of the driving force behind the ideas come from the following books:
- Distributed Systems by Maarten Van Steen, Andrew Tenenbaum
- Designing Data-Intensive Applications by Martin Kleppmann

I have recently been reading these books and have really wanted to play around with a lot of the topics that are discussed.

### Current ideas about design

#### HTTP/Websocket vs Distributed Elixir

As of right now, I plan to use API endpoints to interface with the system instead of direct processes in distributed Elixir.
Even though this project is purely in Elixir so far (I plan on building all related services in Elixir as well), this is a learning project and I am interested in designing the API with HTTP/Websocket endpoints. 
I'm mostly interested in how to build resiliency and fault-tolerance with these mechanics instead of allowing the BEAM to handle that.
This also makes this system able to be used by other languages and run times.  

Maybe in the future I will implement both options

#### Side Libraries/Project Ideas

To test this system, I plan to build a couple of systems and libraries around the project to help test and evaluate different approaches/algorithms used in building.

Client Library:
First, I of course need a client library to actually use the system in both usage and performance testing

Monitoring Application:
This is an application that I plan to build to both load test the system as well as monitor the performance on multiple levels.
A lot of the monitoring will probably be done through Telemetry and BEAM process monitoring. 
My hope is to use this as a way to evaluate changes in algorithms and designs as well as to compare with current solutions. 

#### Data and Persistence

At first, I will most likely use an already built system like Redis or Mnesia.
But eventually, I plan on building my own log based persistence structure. 

The system needs to be able to recover from crashes and not drop messages. The persistence will also act as a buffer in queueing in case BEAM message boxes get too overwhelming. 
For now, messages will only be sent to current live subscribers. There will be acknowledgement from the subscribers, but the system will not hold messages for subscribers that are offline. The system will only hold state of currently connected subscribers.
The persistence will also eventually need to be distributed and highly-available in case of full node failures. 

#### Process/Node Distribution

Since the goal is to build a highly-available and fault-tolerant system, I also plan on distributing processes to multiple nodes.
The connection between nodes will communicate with distributed Erlang.
Since this is a small system in the context of a whole system, there wouldn't be too many connections in a fully connected distributed Erlang cluster.