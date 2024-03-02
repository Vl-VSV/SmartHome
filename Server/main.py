from typing import List
from fastapi import FastAPI, Query
from pydantic import Field
from pydantic.main import BaseModel

app = FastAPI(title="Smart Home")


class Data(BaseModel):
    led: int = Field(ge=0, le=1, default=0)
    ledR: int = Field(ge=0, le=255, default=0)
    ledG: int = Field(ge=0, le=255, default=0)
    ledB: int = Field(ge=0, le=255, default=0)
    temperature: int = 0
    mtrx: List[str] = ["0b11111111",
                       "0b11111111",
                       "0b11111111",
                       "0b11111111",
                       "0b11111111",
                       "0b11111111",
                       "0b11111111",
                       "0b11111111"
                       ]


data = Data()


@app.get('/setLed', response_model=Data)
def set_led_state(state: int = Query(ge=0, le=1, default=0)) -> Data:
    global data
    data.led = state

    return data


@app.get('/setRGB', response_model=Data)
def set_rgb_led_color(r: int = Query(ge=0, le=255, default=0),
                      g: int = Query(ge=0, le=255, default=0),
                      b: int = Query(ge=0, le=255, default=0)) -> Data:
    global data
    data.ledR = r
    data.ledB = b
    data.ledG = g

    return data


@app.get('/getData', response_model=Data)
def get_data():
    return data


@app.post('/setMatrix', response_model=Data)
def set_matrix(mtrx_states: List[str]):
    global data
    data.mtrx = mtrx_states
    return data


@app.post('/setTemperature', response_model=Data)
def set_temperature(temperature: int):
    global data
    data.temperature = temperature
    return data
