#!/usr/bin/env python
# coding: utf-8

# In[1]:


from sqlalchemy import create_engine
source = create_engine('mysql+mysqlconnector://test:test123@172.19.0.3/test')


# In[3]:


pip install pandas


# In[4]:


import pandas as pd

pd.read_sql('select now()', con=source)

