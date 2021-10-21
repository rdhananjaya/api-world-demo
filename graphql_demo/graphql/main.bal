import ballerina/graphql;
import ballerina/http;

final http:Client httpClient = check new("http://api.weatherapi.com/v1");
configurable string API_KEY = ?;

service /weather on new graphql:Listener(8080) {
    resource function get weather(string city) returns WeatherResponse|error {
        json weather = check getCurrentWeather(city);
        return weather.cloneWithType();
    }
}

function getCurrentWeather(string city) returns json|error {
    string query = string `?key=${API_KEY}&q=${city}`;
    return httpClient->get("/current.json" + query);
}

type Weather record {
    decimal temp_c;
    decimal temp_f;
    string last_updated;
};

type Location record {
    string localtime;
    string country;
};

type WeatherResponse record {|
    Weather current;
    Location location;
|};
