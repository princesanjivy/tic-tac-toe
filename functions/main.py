# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn, scheduler_fn
from firebase_admin import initialize_app, db
import time

initialize_app()


@https_fn.on_request()
def on_request_example(req: https_fn.Request) -> https_fn.Response:
    return https_fn.Response("<h1>Hello, princesanjivy from locals!</h1>")


@scheduler_fn.on_schedule(schedule="0 * * * *")
def on_every_hour(event: scheduler_fn.ScheduledEvent) -> None:
    print(db)
    path = db.reference("roomV1/")
    data = path.get()
    print(len(data))
    for room in data:
        print("room_code:", room)
        if int(room) % 2 == 0:
            path.child(room).delete()
