# TransactionalAnalytics-Tracker

## Description

TransactionalAnalytics-Tracker is a MySQL-based solution designed to efficiently track and analyze customer transactions in real-time. This project is a showcase of handling transaction data, event-driven analytics, and log management using advanced SQL techniques, making it an ideal demonstration for technical proficiency in database systems.

## Key Technical Aspects

- **Real-Time Analytics Counters:** Implements counters to track the number and value of transactions on different time scales (hourly, daily, monthly), providing key metrics for customer behavior.

- **Event-Driven Data Management:** Utilizes MySQL triggers to update counters dynamically whenever a transaction is created, updated, or deleted. This demonstrates the practical application of triggers in real-time data processing.

- **Transactional Log System:** Maintains a comprehensive log of all transactional activities, offering insights into the historical data changes and enabling traceability of every transactional event.

- **Automated Data Purging:** Features an automated cleanup process to remove outdated transaction logs, efficiently managing database size and performance.

- **Complex SQL Procedures:** Showcases the use of stored procedures for both incremental and decremental updates to counters based on transactional events, reflecting the real-world application of procedural SQL for complex data manipulation.

- **Docker Deployment:** Includes Docker integration for straightforward deployment, emphasizing the project's readiness for modern, containerized environments.
