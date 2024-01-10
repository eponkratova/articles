#!/usr/bin/env python
# coding: utf-8

#importing libraries
import duckdb
import pygrametl
from pygrametl.tables import Dimension, FactTable, SlowlyChangingDimension
from pygrametl.datasources import PandasSource
import pandas as pd


#creating a test employee dataset
employee = {'EmpID':  ['19575', '19944'],
        'Name': ['Keven Norman', 'Kristin Werner'],
        'Gender': ['F', 'M'],
        'StoreId': ['1', '3']
        }

employee_df = pd.DataFrame(employee)
employee_df.rename(columns={'EmpID':'emp_id', 'Name':'emp_name', 'Gender':'emp_gender', 'StoreId':'store_id'}, inplace = True)

#creating a test sales orders dataset
sales_order = {'OrdID':  [1, 2, 3],
        'EmpID':  ['19575', '19944', '19575'],
        'Sold': [10, 2, 1],
        'Revenue': [74922, 44375, 40002],
        'Order_Date': ['2024-01-10', '2024-01-10', '2024-01-12']
        }

sales_order_df = pd.DataFrame(sales_order)
sales_order_df.rename(columns={'OrdID':'ord_id', 'EmpID':'emp_id', 'Sold':'unit_sold', 'Revenue':'tot_revenue', 'Order_Date':'ord_date'}, inplace = True)
sales_order_df['ord_date'] = pd.to_datetime(sales_order_df['ord_date'])


def fact_sales_order(dw_conn_wrapper):
    """The function creates the fact & dimension tables"""
    #dimensions table
    source = PandasSource(employee_df)
    employees_dim = SlowlyChangingDimension(
        name = 'dim_emp',  # name of the dimensions table in the data warehouse 
        key = 'emp_sk', # name of the primary key
        attributes = ['emp_id', 'emp_name', 'emp_gender', 'store_id', 'valid_from', 'valid_to', 'version'], #: a sequence of the attribute names in the dimension table. 
        # Should not include the name of the primary key which is given in the key argument.
        lookupatts = ['emp_id'], # a sequence with a subset of the attributes that uniquely identify a dimension members. 
        fromatt = 'valid_from', # the name of the attribute telling from when the version becomes valid. Default: None
        toatt = 'valid_to',
        versionatt = 'version') # the name of the attribute telling until when the version is valid. Default: None
    
    for row in source:
        employees_dim.scdensure(row)

    employees_dim.defaultidvalue = 0
    dw_conn_wrapper.commit()
  
    #fact table
    source = PandasSource(sales_order_df)
    fact_table = FactTable(
        name = 'fact_sales_order',  # name of the fact table in the data warehouse 
        keyrefs = ['ord_id', 'emp_sk'], #foreign and primary keys
        measures = ['unit_sold', 'tot_revenue', 'ord_date'])  
    # Specify an optional value to return when a lookup fails
    fact_table.defaultidvalue = 0  

    for row in source:
        row['emp_sk'] = employees_dim.lookupasof(row, row['ord_date'], (True, True), {'emp_id':'emp_id'})
        fact_table.ensure(row, False, {'ord_id': 'ord_id'})
        
    dw_conn_wrapper.commit()
    dw_conn_wrapper.close()

def main():
    fact_sales_order(dw_conn_wrapper)

if __name__ == '__main__':
    destDatabase = duckdb.connect(r'C:\Users\katep\OneDrive\Desktop\etl\salesorder7.duckdb')
    dw_conn_wrapper = pygrametl.ConnectionWrapper(connection = destDatabase)
    main()
