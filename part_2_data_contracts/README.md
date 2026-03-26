## 🚀 Part 2: Enforcing Data Contracts

This module demonstrates how to prevent upstream schema changes (Schema Drift) from breaking downstream data pipelines. 

* **File:** `data_contract_demo.py`
* **Concept:** Using Python's `pydantic` library to create a strict schema contract. If the upstream software application sends a JSON payload with missing fields, renamed columns, or incorrect data types, the contract throws a validation error. 
* **Architecture:** In a real-world scenario, this validation step sits at the ingestion layer (e.g., an AWS Lambda function, a Kafka stream processor, or within an Airbyte/dbt test). Valid records move to the Data Warehouse; invalid records are routed to a Dead Letter Queue (DLQ) for the software engineers to fix.