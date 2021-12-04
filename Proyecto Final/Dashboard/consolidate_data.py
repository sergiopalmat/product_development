import pandas as pd

def data_to_df(path):
    df = pd.read_csv(path, sep = ',')
    df = df.melt(id_vars = ('Province/State','Country/Region','Lat','Long'), var_name='Date', value_name='Cases')
    return df


def consolidate_data(c_path, d_path, r_path):
    'parameters: c_path = path to confirmed cases table, d_path = path to deaths cases table, r_path = path to recovered cases table'
    df1 = data_to_df(c_path)
    df2 = data_to_df(d_path)
    df3 = data_to_df(r_path)

    df1['Status'] = 'Confirmed'
    df2['Status'] = 'Deaths'
    df3['Status'] = 'Recovered'

    data = df1.append(df2)
    data = data.append(df3)
    data['Date'] = pd.to_datetime(data['Date']).dt.date
    data['Year-month'] = pd.to_datetime(data['Date']).dt.to_period('M')
    return data

# Define paths for reading data
confirmed_path = 'data_sources/time_series_covid19_confirmed_global.csv'
deaths_path = 'data_sources/time_series_covid19_deaths_global.csv'
recovered_path = 'data_sources/time_series_covid19_recovered_global.csv'

data = consolidate_data(confirmed_path, deaths_path, recovered_path)