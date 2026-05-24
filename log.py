from flask import Flask, request
from datetime import datetime
import os

app = Flask(__name__)

session_folder = None  # folder for current session, e.g. logs/GameName_2026-05-22_14-30-00/
session_id = None

def get_channel_path(channel):
    safe = channel.replace(":", "_").replace("/", "_").replace(" ", "_")
    return os.path.join(session_folder, f"{safe}.txt")

@app.route('/start', methods=['POST'])
def start():
    global session_id, session_folder
    data = request.json
    session_id = data.get("session")
    project_name = data.get("project", "Unknown").replace(":", "_").replace("/", "_").replace(" ", "_")
    timestamp = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
    folder_name = f"{project_name}_{timestamp}"
    session_folder = os.path.join("logs", folder_name)
    os.makedirs(session_folder, exist_ok=True)
    print(f"[START] session={session_id}, folder={session_folder}")
    return "session started"

@app.route('/log', methods=['POST'])
def log():
    if session_folder is None:
        return "No session started", 400
    data = request.json
    channel = data.get("channel", "general")
    path = get_channel_path(channel)
    with open(path, "a", encoding="utf-8") as f:
        f.write(f"[{data['time']}] {data['message']}\n")
    return "ok"

@app.route('/log_raw', methods=['POST'])
def log_raw():
    if session_folder is None:
        return "No session started", 400
    data = request.json
    channel = data.get("channel", "general")
    msg = data.get("message", str(data))
    path = get_channel_path(channel)
    with open(path, "a", encoding="utf-8") as f:
        f.write(f"{msg}\n")
    return "ok"

if __name__ == "__main__":
    app.run(port=5000)