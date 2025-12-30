import pandas as pd
import os


RAW_PRE_DIR = "./before"
RAW_POST_DIR = "./post"
CLEAN_DIR = "./cleaned"

os.makedirs(CLEAN_DIR, exist_ok=True)

pre = pd.read_csv(f"{RAW_PRE_DIR}/stop_times_pre.txt")
post = pd.read_csv(f"{RAW_POST_DIR}/stop_times_post.txt")

pre["RedesignPeriod"] = "Pre"
post["RedesignPeriod"] = "Post"


df = pd.concat([pre, post], ignore_index=True)


def get_hour(t):
    if pd.isna(t):
        return None

    t = str(t).strip()

    # AM / PM format
    if "AM" in t or "PM" in t:
        return pd.to_datetime(t, format="%I:%M:%S %p").hour


    h = int(t.split(":")[0])
    return h - 24 if h >= 24 else h

df["Hour"] = df["arrival_time"].apply(get_hour)
df = df[df["Hour"].between(0, 23)]


df["IsEvening"] = df["Hour"] >= 18

df["TimePeriod"] = df["Hour"].apply(
    lambda h: "Peak" if (7 <= h <= 9 or 15 <= h <= 18) else "Off-Peak"
)

PRE_DAYS = 77  # April 13 - June 28
POST_DAYS = 105  # August 31 - December 13

df["NormWeight"] = df["RedesignPeriod"].map({
    "Pre": 1.0 / PRE_DAYS,
    "Post": 1.0 / POST_DAYS
})


final = df[
    [
        "stop_id",
        "arrival_time",
        "Hour",
        "IsEvening",
        "TimePeriod",
        "RedesignPeriod",
        "NormWeight"
    ]
]

final.to_csv(f"{CLEAN_DIR}/events_cleaned_normalized.csv", index=False)

print("✅ Done. Saved events_cleaned_normalized.csv")
