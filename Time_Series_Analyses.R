# --- R SCRIPT FOR TIME SERIES FORECASTING ---
#Akshata_Noganihal


library(readr)     # For efficient data reading
library(dplyr)     # For data manipulation
library(lubridate) # For date functions
library(ggplot2)   # For plotting
library(forecast)  # For time series analysis and SARIMA
library(tseries)   # For statistical tests 

file_name <- "C:/Users/aksha/Downloads/vehicle_trips_dataset_without_missing_values/Vehicle_trips(H2C0ZP_Akshata_N).csv"
df <- read_csv(file_name)

# Identify the series to forecast
ts_id <- "T1"

# Filter the data frame for the selected series
ts_data <- df %>%
  filter(series_name == ts_id) %>%
  # Ensure the data is sorted by date
  arrange(start_timestamp) %>%
  select(start_timestamp, series_value)

print(paste("Data for series", ts_id, "loaded. Total observations:", nrow(ts_data)))
print(paste("Date range:", min(ts_data$start_timestamp), "to", max(ts_data$start_timestamp)))


start_date <- c(year(min(ts_data$start_timestamp)), yday(min(ts_data$start_timestamp)))

ts_object <- ts(ts_data$series_value, start = start_date, frequency = 7)


# Visualize the Time Series
autoplot(ts_object) +
  labs(title = paste("Time Series Plot for", ts_id, "Trips"),
       x = "Time (Weeks)",
       y = "Trips") +
  theme_minimal()

ts_decomp <- decompose(ts_object)
plot(ts_decomp)

Acf(ts_object, main = paste("ACF Plot for", ts_id))



test_size <- 30
train_ts <- head(ts_object, length(ts_object) - test_size)
test_ts  <- tail(ts_object, test_size)

print(paste("Training set length:", length(train_ts)))
print(paste("Testing set length:", length(test_ts)))


sarima_model <- auto.arima(train_ts,
                           stepwise = TRUE,
                           approximation = FALSE,
                           seasonal.test = "ch",
                           D = 1, # Seasonal differencing degree (recommended for strong seasonality)
                           allowdrift = TRUE,
                           trace = TRUE) # Show fit process

print("SARIMA Model Summary:")
print(summary(sarima_model))




forecast_period <- length(test_ts)
sarima_forecast <- forecast(sarima_model, h = forecast_period)



autoplot(sarima_forecast) +
  autolayer(test_ts, series = "Actual Test Data") +
  labs(title = paste("SARIMA Forecast vs. Actuals for", ts_id),
       x = "Time",
       y = "Trips") +
  theme_minimal()


accuracy_metrics <- accuracy(sarima_forecast, test_ts)
print("Forecast Accuracy Metrics (RMSE is key measure):")
print(accuracy_metrics)
print(paste("Final RMSE on Test Set:", round(accuracy_metrics["Test set", "RMSE"], 2)))


checkresiduals(sarima_model)



