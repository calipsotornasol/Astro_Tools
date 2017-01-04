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


exit