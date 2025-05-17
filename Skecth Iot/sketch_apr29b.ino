#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseESP32.h>
#include <DHT.h>
#include <addons/TokenHelper.h>
#include <addons/RTDBHelper.h>

/* WiFi credentials */
#define WIFI_SSID "xrp"
#define WIFI_PASSWORD "mstahulhaq"

/* Firebase credentials */
#define API_KEY "AIzaSyC1qq_11HfZmqkuUaug971X8vT-6m5x5tw"
#define DATABASE_URL "https://iot20252a-3c04b-default-rtdb.firebaseio.com/"
#define USER_EMAIL "ulhaq@gmail.com"
#define USER_PASSWORD "ulhaq123"

/* DHT11 Sensor */
#define DHTPIN 4
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

/* LED */
#define LED_PIN 23

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

float temperature = 0;
float humidity = 0;
bool ledState = false;

unsigned long sendDataPrevMillis = 0;
unsigned long sensorReadPrevMillis = 0;
const long sensorInterval = 2000;
const long databaseInterval = 15000;

bool readSensorData() {
  humidity = dht.readHumidity();
  temperature = dht.readTemperature();

  if (isnan(humidity) || isnan(temperature)) {
    Serial.println("DHT reading failed");
    return false;
  }

  Serial.printf("Humidity: %.1f%%  Temp: %.1f°C\n", humidity, temperature);
  return true;
}

void sendDataToFirebase() {
  if (Firebase.setFloat(fbdo, "/iot/temperature", temperature)) {
    Serial.println("Temperature data sent to Firebase");
  } else {
    Serial.println("Error sending temperature data to Firebase");
  }

  if (Firebase.setFloat(fbdo, "/iot/humidity", humidity)) {
    Serial.println("Humidity data sent to Firebase");
  } else {
    Serial.println("Error sending humidity data to Firebase");
  }
}

void checkForLedCommand() {
  if (Firebase.getBool(fbdo, "/iot/led")) {
    bool newLedState = fbdo.to<bool>();
    if (newLedState != ledState) {
      ledState = newLedState;
      digitalWrite(LED_PIN, ledState ? HIGH : LOW);
      Serial.printf("LED is now %s\n", ledState ? "ON" : "OFF");
    }
  }
}

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);
  dht.begin();

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(300);
    Serial.print(".");
  }
  Serial.println();
  Serial.println("WiFi connected!");
  Serial.println(WiFi.localIP());

  config.api_key = API_KEY;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;
  config.database_url = DATABASE_URL;
  config.token_status_callback = tokenStatusCallback;

  Firebase.reconnectNetwork(true);
  Firebase.begin(&config, &auth);
}

void loop() {
  if (Firebase.ready()) {
    static bool sensorReady = false;

    if (millis() - sensorReadPrevMillis > sensorInterval) {
      sensorReadPrevMillis = millis();
      sensorReady = readSensorData();
    }

    if (millis() - sendDataPrevMillis > databaseInterval && sensorReady) {
      sendDataPrevMillis = millis();
      sendDataToFirebase();
    }

    checkForLedCommand();
  }
}
