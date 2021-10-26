import streamlit as st
import numpy as np
import pandas as pd

st.title('This is my first app from Galileo Master!')

x=4
st.write(x, "square is", x**x)

st.write('This a dataframe example')
st.write(pd.DataFrame({
    'column A' : ['A','B','C','D','E'],
    'column B' : [1,2,3,4,5]
}))

"""
# Title: This is title tag
This is other example for dataframes
"""

df = pd.DataFrame({
    'column A' : ['A','B','C','D','E'],
    'column B' : [1,2,3,4,5]
})
df

"""
# Show me some graphs
"""

df_to_plot = pd.DataFrame(
    np.random.rand(20,3), columns=['A','B','C']
)

st.line_chart(df_to_plot)

"""
# Let's plot a map!
"""

df_lat_lon = pd.DataFrame(
    np.random.randn(1000, 2) / [50, 50] + [37.76, -122.4],
    columns=['lat', 'lon']
)

st.map(df_lat_lon)

if st.checkbox('Show dataframe'):
    df_lat_lon

"""
# Let's try some widgets!
"""

x = st.slider('Select a value for X', min_value=1, max_value=100, value=4)
y = st.slider('Select a power for X', min_value=0, max_value=5, value=2)
st.write(x, '^', y, '=', x**y)

"""
# What about options?
"""

def test():
    st.write('Función ejecutada :)')

option_list = range(1,11)
option  = st.selectbox('Which number do you like best?', option_list, on_change=test)

st.write('Your favorite option is:', option)

"""
## How about a progress bar?
"""

import time

label = st.empty()
progress_bar = st.progress(0)

for i in range(0,101):
    label.text(f'The value is: {i}%')
    progress_bar.progress(i)
    time.sleep(0.01)

'The wait is done!'

st.sidebar.write('This is a sidebar')
option_side = st.sidebar.selectbox('3) Which number do you like best?', option_list)
st.sidebar.write('The selection is: ', option_side)


st.sidebar.write('Another slider')
another_slider = st.sidebar.slider('Select range', 0.0,100.0,(25.0,75.0))
st.sidebar.write('Sidebar', another_slider)
