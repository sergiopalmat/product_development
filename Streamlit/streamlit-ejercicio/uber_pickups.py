import streamlit as st
import numpy as np
import pandas as pd


"""
# Uber Pickups Exercises
"""

DATA_URL = 'https://s3-us-west-2.amazonaws.com/streamlit-demo-data/uber-raw-data-sep14.csv.gz'


@st.cache
def download_data(allow_output_mutation=True):
    return pd.read_csv(DATA_URL)

nrow = st.sidebar.slider('No. rows to display:', min_value=0, max_value=10000, value=1000)
hour_range = st.sidebar.slider('Select the hour range:', 0,24,(8,10))

st.sidebar.write('Hours selected:', hour_range[0], hour_range[1])

#data = (download_data()
#        .rename(columns={'Date/Time':'date_time','Lat':'lat','Lon':'lon','Base':'base'})
#        .assign(date_time= lambda df:pd.to_datetime(df.date_time))
#        .loc[lambda df: (df.date_time.dt.hour >= hour_range[0]) & (df.date_time.dt.hour < hour_range[1])]
#        .loc[1:nrow]
#        .sort_values(by='date_time', axis=0, ascending=True, inplace=True)
#)

data = download_data()
data = data.rename(columns={'Date/Time':'date_time','Lat':'lat','Lon':'lon','Base':'base'})
data = data.assign(date_time= lambda df:pd.to_datetime(df.date_time))
data = data.loc[lambda df: (df.date_time.dt.hour >= hour_range[0]) & (df.date_time.dt.hour < hour_range[1])]
data = data.loc[1:nrow]
data.sort_values(by='date_time', axis=0, ascending=True, inplace=True)

data

st.subheader('Uber pickups location')
st.map(data)


# hacer un histograma de viajes por hora
st.subheader('Number of pickups by hour')
hist_values = np.histogram(
    data['date_time'].dt.hour, bins=24, range=(0,24))[0]
st.bar_chart(hist_values)

