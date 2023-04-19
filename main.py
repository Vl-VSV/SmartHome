from datetime import datetime
from enum import Enum
from typing import List, Optional
from fastapi import FastAPI
from pydantic import Field
from pydantic.main import BaseModel

app = FastAPI(
    title="Smart Home"
)

ledState = 0


@app.get('/getLedState', response_model=int)
def get_led_state():
    return ledState


@app.get('/setLedState')
def set_led_state(state: int = 0):
    global ledState
    ledState = state
    return {'status': 200, 'newLedState': ledState}
