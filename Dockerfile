# Use the official Python base image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the application files
COPY /app/app.py .
COPY /app/requirements.txt .

# Install Python dependencies
RUN pip install -r requirements.txt

# Expose the application port
EXPOSE 8080

# Start the application
CMD ["python", "app.py"]
