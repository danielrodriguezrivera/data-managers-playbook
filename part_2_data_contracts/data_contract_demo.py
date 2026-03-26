# Part 2: The Data Manager's Playbook
# Enforcing a Data Contract using Python and Pydantic

from pydantic import BaseModel, ValidationError, constr

# 1. Define the strict Data Contract
class UserEventContract(BaseModel):
    event_id: str
    user_id: int               # Must be an integer
    event_type: str            # E.g., 'click', 'purchase'
    email: constr(pattern=r'^[\w\.-]+@[\w\.-]+\.\w+$') # Must be a valid email format

# 2. Simulate incoming data from the Software Engineering team
incoming_payload = {
    "event_id": "evt_9981",
    "customer_id": 450,        # ERROR: They changed 'user_id' to 'customer_id'!
    "event_type": "signup",
    "email": "invalid-email-format" # ERROR: Bad email
}

# 3. Enforce the Contract BEFORE letting it into the Data Warehouse
try:
    validated_event = UserEventContract(**incoming_payload)
    print("Contract passed. Writing to Data Warehouse.")
    
except ValidationError as e:
    print("CONTRACT VIOLATION DETECTED! Rejecting payload.")
    print(f"Alerting Software Engineering Team: \n{e.json()}")
    # Pipeline automatically routes this to a Dead Letter Queue (DLQ)