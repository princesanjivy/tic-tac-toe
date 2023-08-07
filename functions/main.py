from firebase_functions import https_fn, scheduler_fn
from firebase_admin import initialize_app, db
from datetime import datetime

initialize_app()


@scheduler_fn.on_schedule(schedule="0 * * * *")
def on_every_hour(event: scheduler_fn.ScheduledEvent) -> None:
    date_format = "%Y-%m-%d %H:%M:%S.%f" # eg: 2023-07-26 21:43:50.019983
    path = db.reference("roomV1/")
    data = path.get()

    print(data)

    if data:
        for room in data:
            created_at_str = data[room]["createdAt"]
            created_at = datetime.strptime(created_at_str, date_format)
            current_time = datetime.now()

            # print(created_at)
            # print(current_time)

            time_diff = current_time - created_at

            if time_diff.total_seconds() > 3600:
                print("Time difference is greater than 1 hour")
                print(f"Deleting... room => {room}")

                path.child(room).delete()
