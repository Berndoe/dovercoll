#include <HCSR04.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

const int trigPin = 5;
const int echoPin = 12;

const int emptyThreshold = 16;
const int fullThreshold = 5;

const char* ssid = "";  
const char* password = "";  
const char* serverName = "{server_name}/retrieve_bin_status";  
LiquidCrystal_I2C lcd(0x27, 16, 2);

void setup() {
  Serial.begin(115200);
  HCSR04.begin(trigPin, echoPin);
  lcd.init();
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("Smart Dustbin");

  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  lcd.setCursor(0, 1);
  lcd.print("Connecting...");
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");
  lcd.setCursor(0, 1);
  lcd.print("Connected    ");
}

// Function to measure distance
double measureDistance() {
  double* distances = HCSR04.measureDistanceCm();
  return distances[0];
}

// Function to calculate fill percentage
int calculateFillPercentage(double distance) {
  if (distance > emptyThreshold) distance = emptyThreshold;
  if (distance < fullThreshold) distance = fullThreshold;

  int fill_percentage = (1.0 - (float)(distance - fullThreshold) / (emptyThreshold - fullThreshold)) * 100;
  return fill_percentage;
}

// Function to display fill percentage on LCD
void displayFillPercentage(int fill_percentage) {
  lcd.setCursor(0, 1);
  lcd.print("Fullness: ");
  lcd.print(fill_percentage);
  lcd.print("%    ");
}

// Function to send data to API server
void sendData(double distance, int fill_percentage) {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(serverName);

    http.addHeader("Content-Type", "application/json");

    StaticJsonDocument<200> doc;
    doc["distance"] = distance;
    doc["fill_percentage"] = fill_percentage;

    String json;
    serializeJson(doc, json);

    int httpResponseCode = http.POST(json);

    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.println(httpResponseCode);
      Serial.println(response);
    } else {
      Serial.print("Error on sending POST: ");
      Serial.println(httpResponseCode);
    }

    http.end();
  } else {
    Serial.println("WiFi Disconnected");
  }
}

void loop() {
  double distance = measureDistance();
  int fill_percentage = calculateFillPercentage(distance);

  Serial.print("Distance: ");
  Serial.print(distance);
  Serial.print(" cm, Fullness: ");
  Serial.print(fill_percentage);
  Serial.println("%");

  displayFillPercentage(fill_percentage);

  sendData(distance, fill_percentage);

  delay(10000); // Sending data every 10 seconds
}
