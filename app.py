from flask import Flask, render_template, request
from dotenv import load_dotenv
import requests
import os

# Load variables from .env into the environment
load_dotenv()

# Create the Flask app
app = Flask(__name__)

# Grab the API key we stored in .env
API_KEY = os.getenv("WEATHER_API_KEY")


@app.route("/", methods=["GET", "POST"])
def home():
    weather = None
    error = None

    if request.method == "POST":
        city = request.form.get("city")
        url = f"https://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric"
        response = requests.get(url)
        data = response.json()

        if response.status_code == 200:
            weather = {
                "city": data["name"],
                "country": data["sys"]["country"],
                "temp": round(data["main"]["temp"]),
                "feels_like": round(data["main"]["feels_like"]),
                "description": data["weather"][0]["description"].title(),
                "humidity": data["main"]["humidity"],
                "wind": data["wind"]["speed"],
                "icon": data["weather"][0]["icon"]
            }
        else:
            error = data.get("message", "City not found").title()

    return render_template("index.html", weather=weather, error=error)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)