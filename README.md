Shards: Shards are individual MongoDB instances that store a portion of the sharded data. These are the primary storage nodes in a sharded cluster. Shards can be standalone MongoDB instances or replica sets.

Mongos (Router): Mongos acts as a query router, directing client requests to the appropriate shard(s) based on the shard key specified in the query. Mongos instances also handle routing updates and metadata operations.

Config Servers: Config servers store metadata and configuration settings for the sharded cluster. This includes information about the distribution of data across shards and the shard key ranges. Config servers typically run as a replica set to ensure high availability.

Replica Sets: Replica sets provide redundancy and high availability within each shard. Each shard in the cluster consists of one or more replica sets, ensuring that data is replicated across multiple nodes to prevent data loss and ensure continuous operation in case of node failures.

Reference: https://www.mongodb.com/basics/sharding