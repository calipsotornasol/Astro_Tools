from astropy.io import fits
from astropy.io import ascii
import os
import glob
import pandas as pd
#Program to extract objects according to the array using Pandas. 
#This is slow. I have to improve it or come back to the old method.

folder_path = os.getcwd()

for file in os.listdir(folder_path):
     if glob.fnmatch.fnmatch(file,"rg*S00??.cat"):
          print ('Processing ' + file)
          names=[' ']*14
          N=14
          res =pd.DataFrame(columns=list(range(0,14,1)))
          with open(file) as myFile:
               for num, line in enumerate(myFile):
				
                    if num < 14:
                         label=line.strip()
					
                         names[num]=label[6:17].strip()
				
					
                    else:
                         new=line
                         new2=new.split()
                         #print len(new2)
                         res=res.append([new2])#Too slow
					
          #res.columns=names.str.slice(1)
          old_names=list(res.columns.values)
          new_names=list(names)
          res.rename(columns=dict(zip(old_names, new_names)), inplace=True)
          name2= os.path.splitext(file)[0]
          header = ["NUMBER", "X_IMAGE", "Y_IMAGE"]
          (res.loc[res['EXT_NUMBER'] == '1']).to_csv(name2 +'_1.cat', sep=" ", index=False, columns = header)
          (res.loc[res['EXT_NUMBER'] == '2']).to_csv(name2 +'_2.cat', sep=" ", index=False, columns = header)
          (res.loc[res['EXT_NUMBER'] == '3']).to_csv(name2 +'_3.cat', sep=" ", index=False, columns = header)
          (res.loc[res['EXT_NUMBER'] == '4']).to_csv(name2 +'_4.cat', sep=" ", index=False, columns = header)
          #print(list(res.columns.values))
          
        
