#!/usr/bin/env python
# coding: utf-8

# In[12]:

import lzma
import pandas as pd
import numpy as np
import sys
from datetime import date
from datetime import timedelta


# In[4]:
argvs = sys.argv

full_data = lzma.open(argvs[1]) 

# In[14]:


end_date = date.fromisoformat(argvs[2]) # date of data upload as string with hyphens, e.g. '2023-04-22'
timespan = timedelta(days=400) # number of days since upload date to include
start_date =  end_date - timespan


# In[18]:


# Choose to keep lines following a name with collection date that is after the start_date. Kept lines are printed.
keep = 'no'
for line in full_data:
    try: # Check to see if line works as utf-8 or not
        line = line.decode()
    except ValueError:
        continue
    if '>' in line[0]: # i.e. lines that are sample names 
        # remove string before first pipe and after second pipe to leave just the collected date 
        try:
            seq_date = date.fromisoformat(line.split('|')[1].split('|')[0])
        except ValueError:
            seq_date = date.fromisoformat('2020-01-01')
        if seq_date >= start_date:
            keep = 'yes'
            print(line.split('|')[0], end="\n") # Prints just the seq name without dates for compatibility. 
        else: keep = 'no'
    else:
        if keep == 'yes':
            print(line, end="")
        
            
        
                

