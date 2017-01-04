#!/bin/tcsh

cd ../W1541

# Now extract the finalised daophotometry
set lastpass = `ls -1d pass??? | tail -1`
cp $lastpass/[0-9][0-9][a-z][a-z][a-z][0-9][0-9][0-9][0-9].nst .
cp $lastpass/npsf_[0-9][0-9][a-z][a-z][a-z][0-9][0-9][0-9][0-9].psf .
foreach i ([0-9][0-9][a-z][a-z][a-z][0-9][0-9][0-9][0-9].nst)
cp npsf_$i:r.psf $i:r.psf
end
rm *s.sdf *.sub
rm t????.sdf pass???/t????.sdf
   
make_seeing gems ?????????.psf > seeing2.out

# Create a control_file.lis
   
   if ( -e control_file.lis ) then
      mv -f control_file.lis control_file.previous
      head -5 control_file.previous > control_file.lis
      tail +2 fcol_trans.lis >> control_file.lis
   else
      set i = `echo $cwd:t | sed -e 's/p/+/' | sed -e 's/m/-/' `
      echo $i > control_file.lis
      head -1 fcol_trans.lis >> control_file.lis
      echo 0.000 >> control_file.lis
      echo 0.0 30.0 >> control_file.lis
      echo -1.0 1.0 >> control_file.lis
      tail +2 fcol_trans.lis >> control_file.lis
   endif

# Edit it to put in any special parameters. In particular these are the 
# rotation angle of the field of view to the traditional NS-EW orientation, and parameters to use
# In trimming the data based on their daophot parameters (in practise the latter is not used any more).
# However, we DO need to get a rotation angle to put into the control_file.lis
# Use JHKplot ...
# For W1639 this tells me my master frame is rotated by -0.025 degrees, and this
# is the number I put into the control_file.lis file.
# Note that for GSAOI I may well have to do this in 2 steps
   # (1) Get the rotation angle for a reference Magellan image
   # (2) Then use to thisgrep Magellan image to get a rotation angle for GSAOI


#ln -s ~/Dropbox/2MASS 2MASS 
#JHKplot -J3 -a -s 10 -t 5 -O 20 -z 0.1 -m 35000 -S 0.159 `head -1 fcol_trans.lis | sed -e "s/'//g"` 16 39 41.04 -68 47 45.0 S1639 /xs

# Now start doing astrometry   
   
#set object = `echo $cwd:t | sed -e 's/p/+/g' | sed -e 's/m/-/g'`
#process11 gems

#If you have not selected reference stars before, then you'll probably
   # want to start with the brightest 100 or so.
   #if ( ! -e reference_stars.lis ) then
      #echo 80 > reference_stars.lis
      #head -80 reference_stars.tmp >> reference_stars.lis
   #endif

#echo $object

#fcol_atrans ${object}_5 ${object}_6 control_file.lis
#fcol_pave ${object}_6 control_file.lis
#sort -nk 5 W0713_6 > parallax.txt

exit