# PubSub

This project is a playground to build a distributed messaging queue in Elixir. 
This is a project to learn more about distributed algorithms and the inner workings of current messaging brokers and message streaming services.


### Next Steps

- Create HTTP API endpoints and client library (In Progress)
- Add persistent topic storage. At first, this will be just a redis instance, but eventually build my own log-structured key-value store.
- Distribute topic caches to multiple nodes (This includes a lot of steps that I will update here when I get there)
- Distribute Server process (HTTP interfacing process) to multiple nodes and load balance between
- Document high-level architecture
