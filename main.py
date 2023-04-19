from datetime import datetime
from enum import Enum
from typing import List, Optional
from fastapi import FastAPI
from pydantic import Field
from pydantic.main import BaseModel

app = FastAPI(
    title="Smart Home"
)

ledState = 1


@app.get('/getLedState', response_model=int)
def get_led_state():
    return ledState


@app.post('/setLedState/{state}')
def set_led_state(state: int):
    ledState = state
    return {'status': 200, 'newLedState': ledState}
