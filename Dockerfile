# Use official Python slim image as the base
FROM python:3.12-slim

# Set the working directory inside the container
WORKDIR /app

# Copy requirements first (for better layer caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Tell Docker the app listens on this port
EXPOSE 5000

# Run the app using gunicorn (production server)
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]