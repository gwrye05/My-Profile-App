
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field

app = FastAPI(
    title="Vehicle Manufacturer API",
    description="CRUD API for manufacturers and their vehicles",
    version="1.0.0"
)

# --------------------------------------------------
# In-memory database
# --------------------------------------------------

manufacturers_db = {}
vehicles_db = {}

next_manufacturer_id = 1
next_vehicle_id = 1


# --------------------------------------------------
# Pydantic models
# --------------------------------------------------

class ManufacturerCreate(BaseModel):
    name: str = Field(min_length=1)
    country: str = Field(min_length=1)


class ManufacturerUpdate(BaseModel):
    name: str = Field(min_length=1)
    country: str = Field(min_length=1)


class ManufacturerResponse(BaseModel):
    id: int
    name: str
    country: str


class VehicleCreate(BaseModel):
    name: str = Field(min_length=1)
    model_year: int = Field(ge=1886, le=2100)
    vehicle_type: str = Field(min_length=1)


class VehicleUpdate(BaseModel):
    name: str = Field(min_length=1)
    model_year: int = Field(ge=1886, le=2100)
    vehicle_type: str = Field(min_length=1)


class VehicleResponse(BaseModel):
    id: int
    name: str
    model_year: int
    vehicle_type: str
    manufacturer_id: int


# --------------------------------------------------
# Manufacturer CRUD endpoints
# --------------------------------------------------

# CREATE a manufacturer
@app.post(
    "/manufacturers/",
    response_model=ManufacturerResponse,
    status_code=201
)
def create_manufacturer(manufacturer: ManufacturerCreate):
    global next_manufacturer_id

    manufacturer_id = next_manufacturer_id

    new_manufacturer = {
        "id": manufacturer_id,
        "name": manufacturer.name,
        "country": manufacturer.country
    }

    manufacturers_db[manufacturer_id] = new_manufacturer
    next_manufacturer_id += 1

    return new_manufacturer


# READ all manufacturers
@app.get(
    "/manufacturers/",
    response_model=list[ManufacturerResponse]
)
def get_manufacturers():
    return list(manufacturers_db.values())


# READ one manufacturer
@app.get(
    "/manufacturers/{manufacturer_id}",
    response_model=ManufacturerResponse
)
def get_manufacturer(manufacturer_id: int):
    manufacturer = manufacturers_db.get(manufacturer_id)

    if manufacturer is None:
        raise HTTPException(
            status_code=404,
            detail="Manufacturer not found"
        )

    return manufacturer


# UPDATE a manufacturer
@app.put(
    "/manufacturers/{manufacturer_id}",
    response_model=ManufacturerResponse
)
def update_manufacturer(
    manufacturer_id: int,
    manufacturer: ManufacturerUpdate
):
    if manufacturer_id not in manufacturers_db:
        raise HTTPException(
            status_code=404,
            detail="Manufacturer not found"
        )

    updated_manufacturer = {
        "id": manufacturer_id,
        "name": manufacturer.name,
        "country": manufacturer.country
    }

    manufacturers_db[manufacturer_id] = updated_manufacturer

    return updated_manufacturer


# DELETE a manufacturer and its vehicles
@app.delete("/manufacturers/{manufacturer_id}")
def delete_manufacturer(manufacturer_id: int):
    if manufacturer_id not in manufacturers_db:
        raise HTTPException(
            status_code=404,
            detail="Manufacturer not found"
        )

    del manufacturers_db[manufacturer_id]

    # Delete every vehicle belonging to this manufacturer
    vehicle_ids = [
        vehicle_id
        for vehicle_id, vehicle in vehicles_db.items()
        if vehicle["manufacturer_id"] == manufacturer_id
    ]

    for vehicle_id in vehicle_ids:
        del vehicles_db[vehicle_id]

    return {
        "message": "Manufacturer and associated vehicles deleted",
        "manufacturer_id": manufacturer_id,
        "deleted_vehicle_count": len(vehicle_ids)
    }


# --------------------------------------------------
# Vehicle CRUD endpoints
# --------------------------------------------------

# CREATE a vehicle for a specific manufacturer
@app.post(
    "/manufacturers/{manufacturer_id}/vehicles/",
    response_model=VehicleResponse,
    status_code=201
)
def create_vehicle(
    manufacturer_id: int,
    vehicle: VehicleCreate
):
    global next_vehicle_id

    if manufacturer_id not in manufacturers_db:
        raise HTTPException(
            status_code=404,
            detail="Manufacturer not found"
        )

    vehicle_id = next_vehicle_id

    new_vehicle = {
        "id": vehicle_id,
        "name": vehicle.name,
        "model_year": vehicle.model_year,
        "vehicle_type": vehicle.vehicle_type,
        "manufacturer_id": manufacturer_id
    }

    vehicles_db[vehicle_id] = new_vehicle
    next_vehicle_id += 1

    return new_vehicle


# READ all vehicles
@app.get("/vehicles/", response_model=list[VehicleResponse])
def get_vehicles():
    return list(vehicles_db.values())


# READ all vehicles for one manufacturer
@app.get(
    "/manufacturers/{manufacturer_id}/vehicles/",
    response_model=list[VehicleResponse]
)
def get_manufacturer_vehicles(manufacturer_id: int):
    if manufacturer_id not in manufacturers_db:
        raise HTTPException(
            status_code=404,
            detail="Manufacturer not found"
        )

    return [
        vehicle
        for vehicle in vehicles_db.values()
        if vehicle["manufacturer_id"] == manufacturer_id
    ]


# READ one vehicle
@app.get("/vehicles/{vehicle_id}", response_model=VehicleResponse)
def get_vehicle(vehicle_id: int):
    vehicle = vehicles_db.get(vehicle_id)

    if vehicle is None:
        raise HTTPException(
            status_code=404,
            detail="Vehicle not found"
        )

    return vehicle


# UPDATE a vehicle
@app.put("/vehicles/{vehicle_id}", response_model=VehicleResponse)
def update_vehicle(
    vehicle_id: int,
    vehicle: VehicleUpdate
):
    if vehicle_id not in vehicles_db:
        raise HTTPException(
            status_code=404,
            detail="Vehicle not found"
        )

    existing_vehicle = vehicles_db[vehicle_id]

    updated_vehicle = {
        "id": vehicle_id,
        "name": vehicle.name,
        "model_year": vehicle.model_year,
        "vehicle_type": vehicle.vehicle_type,
        "manufacturer_id": existing_vehicle["manufacturer_id"]
    }

    vehicles_db[vehicle_id] = updated_vehicle

    return updated_vehicle


# DELETE a vehicle
@app.delete("/vehicles/{vehicle_id}")
def delete_vehicle(vehicle_id: int):
    if vehicle_id not in vehicles_db:
        raise HTTPException(
            status_code=404,
            detail="Vehicle not found"
        )

    del vehicles_db[vehicle_id]

    return {
        "message": "Vehicle deleted successfully",
        "vehicle_id": vehicle_id
    }
