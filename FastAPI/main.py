from fastapi import FastAPI
from enum import Enum

app = FastAPI()

class Operacion(str, Enum):
    suma = 'suma'
    resta = 'resta'
    multiplicacion = 'multiplicacion'
    division = 'division'


@app.get("/suma")
def suma(array: str):
    arr = array.split(",")
    for i in range(0, len(arr)):
        arr[i] = int(arr[i])
    return sum(arr)

@app.get("/resta")
def resta(array: str):
    arr = array.split(",")
    for i in range(0, len(arr)):
        arr[i] = int(arr[i])
    result = arr[0]
    arr = arr[1:]
    for x in arr:
      result = result - x
    return result

@app.get("/producto")
def multiplicacion(array: str):
    arr = array.split(",")
    for i in range(0, len(arr)):
        arr[i] = int(arr[i])
    result = 1
    for x in arr:
      result = result * x
    return result

@app.get("/division")
def division(array: str):
    arr = array.split(",")
    for i in range(0, len(arr)):
        arr[i] = int(arr[i])
    result = 1
    for x in arr:
      result = result/x
    return result

@app.get("/operaciones")
def operacion(operacion: Operacion, array:str):
    if operacion == 'suma':
        return suma(array)
    if operacion == 'resta':
        return resta(array)
    if operacion == 'division':
        return division(array)
    if operacion == 'multiplicacion':
        return multiplicacion(array)

