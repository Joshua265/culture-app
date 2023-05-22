from typing import List
import requests
import random
import datetime
import json

BASE_URL = "http://localhost:5000"

event_types = [
    {
        "day_frequency": 0,
        "available_hours": [12, 21],
        "duration": 2,
        "title": "Avatar: The Way of Water",
        "city": "Heilbronn",
        "location": "CinemaxX Heilbronn",
        "prices": [
            {"category": "general", "value": 14},
            {"category": "reduced", "value": 8},
            {"category": "students", "value": 10},
        ],
        "mediaCategory": "cinema",
        "imagePath": "./images/avatar.png",
        "description": "Jake Sully lives with his newfound family formed on the extrasolar moon Pandora. Once a familiar threat returns to finish what was previously started, Jake must work with Neytiri and the army of the Na'vi race to protect their home.",
        "genres": ["action", "adventure", "fantasy"],
    },
    # Add more event types here
]


def upload_image(file_path):
    files = {"image": open(file_path, "rb")}

    try:
        response = requests.post(f"{BASE_URL}/images", files=files)
        if response.status_code == 200:
            return response.json().get("imageId")
        else:
            print(f"Failed to upload image: {response.text}")
            raise Exception("Error uploading image!")
    except requests.exceptions.RequestException as e:
        print(f"Error uploading image: {e}")
        raise Exception("Error uploading image!")


def create_event(event: dict):
    response = requests.post(
        f"{BASE_URL}/events/", json=event, headers={"Content-Type": "application/json"}
    )
    if response.status_code == 200:
        print(f"Successfully created event: {event}")
    else:
        print(f"Failed to create event: {event}")


def generate_random_start_times(event_type, num_events: int) -> List[str]:
    start_times = []
    today = datetime.datetime.today()
    today = today.replace(hour=0, minute=0, second=0, microsecond=0)
    for n in range(num_events):
        # if event_type["day_frequency"] > 0: the event is created once every x days
        if event_type["day_frequency"] > 0:
            start_time = today + datetime.timedelta(
                days=event_type["day_frequency"],
            )
            start_time = start_time.replace(hour=random.randint(12, 21))
            start_times.append(start_time)
        # if event_type["day_frequency"] == 0: the event is created multiple times every day
        else:
            # fill next 30 days
            assert (
                event_type["available_hours"][1] - event_type["available_hours"][0] > n
            ), "Not enough hours in the day"
            for d in range(30):
                start_time = today + datetime.timedelta(days=d)
                start_time = start_time.replace(
                    hour=random.choice(
                        list(
                            range(
                                event_type["available_hours"][0],
                                event_type["available_hours"][1],
                            )
                        )
                    )
                )
                start_times.append(start_time)
    return start_times


def create_booked_seats():
    booked_seats = []
    for _ in range(random.randint(0, 90)):
        booked_seats.append(
            {
                "seatNumber": random.randint(1, 14),
                "row": random.choice(list("ABCDEFG")),
            }
        )
    return booked_seats


def create_multiple_events(event_type, num_events):
    start_times = generate_random_start_times(event_type, num_events)
    image_id = upload_image(event_type["imagePath"])
    duration = event_type["duration"]
    event_type["imageId"] = image_id

    del event_type["day_frequency"]
    del event_type["available_hours"]
    del event_type["duration"]
    del event_type["imagePath"]

    for start_time in start_times:
        event_type["startTime"] = start_time
        event_type["endTime"] = start_time + datetime.timedelta(hours=duration)
        event_type["startTime"] = event_type["startTime"].isoformat()
        event_type["endTime"] = event_type["endTime"].isoformat()
        event_type["bookedSeats"] = create_booked_seats()
        create_event(event_type)


# Usage example:
event_type = event_types[0]  # Choose an event type from the list
num_events = 5  # Number of events to create
create_multiple_events(event_type, num_events)
