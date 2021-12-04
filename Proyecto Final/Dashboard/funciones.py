import streamlit as st
import numpy as np
import pandas as pd
import datetime
from datetime import date
from consolidate_data import *
import plotly.express as px

def set_inicio():
    st.title("Introducción")

def set_mapa():
    st.title("Distribución geográfica")

def set_estadisticas():
    st.title("Estadísticas de incrementos")
    
    # Funcion para agrupar y graficar datos
    def plot_by_date(data, status, color, titulo):
        df = data[data.Status == status]
        df_daily = df.groupby(['Date','Country/Region'], as_index=False).sum()
        df_daily = df_daily[['Date','Country/Region','Cases']]
        df_country = df.groupby(['Country/Region'], as_index=False).sum()

        fig = px.line(df_daily, x="Date", y="Cases", color='Country/Region',
            title=titulo)
        fig.update_traces(patch={"line": {"width": 2}})
        
        barras = px.bar(df_country, x='Country/Region',y='Cases', color='Cases')
        barras.update_layout( xaxis={'categoryorder':'total descending'})
        return (df_daily, fig, barras)

    # Filtro de estado:
    select_status = st.radio(
        label='Seleccionar un estado:',
        options= ['Confirmados','Muertes','Recuperados'],
        index=0
    )

    # Radio Selection estado
    if select_status == 'Confirmados':
        estado = 'Confirmed'
    elif select_status == 'Muertes':
        estado = 'Deaths'
    else:
        estado = 'Recovered'
    
    df, fig, barras = plot_by_date(data,estado,["#FFA500"], f"{select_status} por fecha")

        
    #columnas
    col1, col2 = st.columns([2,1])

    with col1:
        st.plotly_chart(fig, use_container_width = True)

    with col2:
        st.plotly_chart(barras,use_container_width = True)




def set_otras_estadisticas():
    st.title("Otras estadísticas")

    data_summary = data[['Year-month', 'Country/Region', 'Status','Cases']]
    data_summary = data_summary.groupby(['Year-month','Country/Region','Status'], as_index=False).sum()
    st.write(data_summary[data_summary['Country/Region']=='Guatemala'])
