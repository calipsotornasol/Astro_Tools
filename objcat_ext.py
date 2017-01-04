from astropy.io import fits
from astropy.io import ascii
import os
import glob
import pandas as pd

folder_path = os.getcwd()

#Reading catalogue from mosaiced fits image and moving the catalogue to a text file


for file in os.listdir(folder_path):
     if glob.fnmatch.fnmatch(file,"rg*_proj.fits"):
          print ('Processing ' + file)
          name1= os.path.splitext(file)[0]
          f=fits.open(file)
          tdhdata =f[4].data
          ascii.write(tdhdata, name1 +".cat")

#Splitting the catalogue according to the extension (array) of the image
          
 
for file in os.listdir(folder_path):
     if glob.fnmatch.fnmatch(file,"rg*_proj.cat"):
          print ('Processing ' + file)              
          df = pd.read_csv(file, sep=" ")
          name2= os.path.splitext(file)[0]
          header = ["NUMBER", "X_IMAGE", "Y_IMAGE"]
          (df.loc[df['ARRAY'] == 1]).to_csv(name2[:-5]+'_1.cat', sep=" ", index=False, columns = header)
          (df.loc[df['ARRAY'] == 2]).to_csv(name2[:-5]+'_2.cat', sep=" ", index=False, columns = header)
          (df.loc[df['ARRAY'] == 3]).to_csv(name2[:-5]+'_3.cat', sep=" ", index=False, columns = header)
          (df.loc[df['ARRAY'] == 4]).to_csv(name2[:-5]+'_4.cat', sep=" ", index=False, columns = header)
