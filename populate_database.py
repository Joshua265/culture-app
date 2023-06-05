from typing import List
import requests
import random
import datetime
import json
from glob import glob

BASE_URL = "http://localhost:5000"


DAYS_OF_WEEK = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday",
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


def generate_start_times(event_type, weeks: int):
    start_times = []
    now = datetime.datetime.now()
    days_since_monday = (now.weekday() - 0) % 7
    last_monday = now - datetime.timedelta(days=days_since_monday)
    last_monday = last_monday.replace(hour=0, minute=0, second=0, microsecond=0)
    for week in range(weeks):
        for n_day, day in enumerate(DAYS_OF_WEEK):
            day_event_times = event_type[day]
            for day_event_time in day_event_times:
                hour_minute_list = [int(t) for t in day_event_time.split(":")]
                start_times.append(
                    last_monday
                    + datetime.timedelta(
                        days=n_day + (7 * week),
                        hours=hour_minute_list[0] + 2,  # +2 for timezone
                        minutes=hour_minute_list[1],
                    )
                )
    return start_times


def create_multiple_events(event_type, weeks):
    start_times = generate_start_times(event_type, weeks)
    image_id = upload_image(event_type["imagePath"])
    duration = event_type["duration"]
    event_type["imageId"] = image_id
    event_type["city"] = "Heilbronn"

    del event_type["duration"]
    del event_type["imagePath"]

    if not "prices" in event_type.keys():
        event_type["prices"] = [
            {"category": "general", "value": 13.49},
            {"category": "children", "value": 10.49},
            {"category": "students", "value": 12.49},
        ]

    for start_time in start_times:
        event_type["startTime"] = start_time
        event_type["endTime"] = start_time + datetime.timedelta(minutes=duration)
        event_type["startTime"] = event_type["startTime"].isoformat()
        event_type["endTime"] = event_type["endTime"].isoformat()
        event_type["bookedSeats"] = create_booked_seats()
        create_event(event_type)


# Usage example:
event_type_json_list = glob("data/*.json")
event_types = [
    json.load(open(event_type_json, encoding="utf-8"))
    for event_type_json in event_type_json_list
]
weeks = 5  # Number of events to create
for event_type in event_types:
    create_multiple_events(event_type, weeks)
