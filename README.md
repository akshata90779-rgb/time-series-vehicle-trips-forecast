# Vehicle Trips Time Series Forecasting

This project focuses on forecasting vehicle trip volumes using
seasonal time series models (SARIMA).

## Objective
To model weekly seasonality in vehicle trips and generate short-term
forecasts with reliable residual diagnostics.

## Dataset
- Time-stamped vehicle trip counts
- Weekly seasonality (frequency = 7)
- Missing values removed during preprocessing

## Methodology
- Exploratory time series analysis
- Train-test split
- SARIMA model using auto.arima
- Forecast evaluation on test set
- Residual diagnostics (ACF, Ljung-Box test)

## Tools & Technologies
- R
- forecast
- ggplot2
- tseries

## Key Results
- Model captures weekly seasonality effectively
- Residuals behave like white noise
- Forecast aligns well with test data

## Data Availability
The dataset is not included due to size and privacy considerations.

