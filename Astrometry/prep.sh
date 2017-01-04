#!/bin/tcsh

#PREPARING DATA#

#  Start up STARLINK.

figaro

starlogin

rm rcg*.sdf
rm rg*.sdf
rm 18*.sdf
rm 21*.sdf
rm 12*.sdf

#Convert FITS TO SDF. Number depending on the chip

convert

foreach i ( rcgS20130420S????.fits )
   fits2ndf $i'[2]' ${i:r}_2
   end

foreach i ( *gS201?052?S????.fits )
   fits2ndf $i'[2]' ${i:r}_2
   end
   
foreach i ( *gS201?0412S????.fits )
   fits2ndf $i'[2]' ${i:r}_2
   end

foreach i ( *gS20140618S????.fits )
   fits2ndf $i'[2]' ${i:r}_2
   end
 
   
# Get the filenames into a format I want

foreach i ( *gS*_2.sdf )
      set l = `echo $i | sed -e 's/_2//' `
      set n = `./alldata_GEMS $l:r.fits | awk '{print $1}'`
      echo $i $l $n
      if ( -e $i:r.sdf ) then
         echo "$i:r.sdf exists - not creating"
      else
         echo "$i:r.sdf being created"
         ndf2fits $i $i:r
      endif
      if ( -e $n:r.sdf ) then
         echo "$n:r.sdf exists - not creating new link"
      else 
         echo "Creating new link $n:r.sdf <-> $i:r.sdf"
         ln -s $i:r.sdf $n:r.sdf
      endif
   end
   
# Making a lash up bad pixel mask, because the crap data in chip 2 really is screwing
# things up. 


foreach i ( 24???????.sdf )
   let $i:r.data_array.bad_pixel = GEMS_CHIP2_MASK.data_array.bad_pixel
   iadd $i:r GEMS_CHIP2_MASK $i:r
   end
   
foreach i ( 20???????.sdf )
   let $i:r.data_array.bad_pixel = GEMS_CHIP2_MASK.data_array.bad_pixel
   iadd $i:r GEMS_CHIP2_MASK $i:r
   end

foreach i ( 28???????.sdf )
   let $i:r.data_array.bad_pixel = GEMS_CHIP2_MASK.data_array.bad_pixel
   iadd $i:r GEMS_CHIP2_MASK $i:r
   end

foreach i ( 12???????.sdf )
   let $i:r.data_array.bad_pixel = GEMS_CHIP2_MASK.data_array.bad_pixel
   iadd $i:r GEMS_CHIP2_MASK $i:r
   end
   
foreach i ( 18???????.sdf )
   let $i:r.data_array.bad_pixel = GEMS_CHIP2_MASK.data_array.bad_pixel
   iadd $i:r GEMS_CHIP2_MASK $i:r
   end
   
# Get alldata information
./alldata_GEMS *gS????????S????.fits > alldata_GEMS.dat

exit