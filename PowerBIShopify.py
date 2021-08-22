import pandas as pd
import numpy as np
import re
import requests


def get_all_orders():
    last=0
    orders=pd.DataFrame()
    while True:
        url = f"https://appkey:appsecret@yourstore.myshopify.com/admin/api/2021-07/orders.json/?limit=250&since_id={last}"
        response = requests.request("GET", url)
        
        df=pd.DataFrame(response.json()['orders'])
        orders=pd.concat([orders,df])
        last=df['id'].iloc[-1]
        if len(df)<250:
            break
    return(orders)



df=get_all_orders()
df.head()
