#!/bin/tcsh

# Do first cut object detection and processing. 

   make_fifile [0-9][0-9]*.sdf
   ./fifile
   rm *jnk*

   make_phfile [0-9][0-9]*.coo
   ./phfile


   setenv ROOT /Volumes/RAID3TB/daniela/WORKING/Instruments/GEMS/Astrometry/Distortion_No_Corrected/
   cd $ROOT

   set i = 'W1541'

   grep $i data_W1541/alldata_GEMS.dat > $i.lis
   awk '{print $1}' $i.lis > crap
   mv -f crap $i.lis

   set i1 = `echo $i | sed 's/+/p/'`
   set i1 = `echo $i1 | sed 's/-/m/'`
   mkdir $i1
   mv $i.lis $i1
   cd $i1
   cp ../../Example_W1541/*.opt .
   
   set i = `echo $cwd:t | sed -e 's/p/+/' | sed -e 's/m/-/' `
   foreach j ( `cat $i.lis ` )
     ln -s ../data_W1541/$j.sdf $j.sdf
     cp ../data_W1541/$j.coo $j.coo
     cp ../data_W1541/$j.ap $j.ap
   end

# Make sure you have a .coo and .ap file for each data file.
# If not go back to /data and make them

   echo "Files to be re-processed can be found in /tmp/again.lis"
   rm /tmp/again.lis
   foreach i ( ?????????.sdf*)
      if { ls $i:r.{coo}* >& /dev/null } then
         echo "Don't need to make  $i:r.coo"
      else
         echo $i >> /tmp/again.lis
         echo $i 
      endif
   end

   make_fifile `cat /tmp/again.lis`
   ./fifile
   rm *jnk*

   echo "Files to be re-processed can be found in /tmp/again.lis"
   rm /tmp/again.lis
   foreach i ( ?????????.sdf*)
      if { ls $i:r.{ap}* >& /dev/null } then
         echo "Don't need to make  $i:r.ap"
      else
         echo $i >> /tmp/again.lis
         echo $i 
      endif
      end

   make_phfile `cat /tmp/again.lis`
   ./phfile
   
# Either make a new fcol_trans.lis, or use the first entry from
# an old one, then edit out the duplicate.

   rm -f /tmp/tmp
   foreach j ( ??[a-z][a-z][a-z]????.coo )
      echo \'$j:r\' >> /tmp/tmp
   end

   rm -f fcol_trans.tmp
   if ( -e fcol_trans.lis ) then
      head -1 fcol_trans.lis > fcol_trans.tmp
      echo `wc /tmp/tmp | awk '{print $1-1}'` >> fcol_trans.tmp
      cat /tmp/tmp >> fcol_trans.tmp
   else
      head -1 /tmp/tmp > fcol_trans.tmp
      echo `wc /tmp/tmp | awk '{print $1-1}'` >> fcol_trans.tmp
      tail +2 /tmp/tmp >> fcol_trans.tmp
   endif
   wc fcol_trans.tmp
   nedit fcol_trans.tmp
   mv  fcol_trans.tmp fcol_trans.lis
   
# If you had a good set of PSF stars selected before, make sure you record them,
# before starting process0   

mv -f tmp_3 tmp_3.previous
process0
cp -f tmp_3.previous tmp_3
process0a
make_psffile psf_*.lst
./psffile

# Make sure the psf_*.pdf files have no NaNs in them

grep NaN psf_*.psf > NaN.txt

# Use the first pass PSFs to estimate seeing
cp ../../default.* .
make_seeing gems psf_[0-9][0-9][a-z][a-z][a-z][0-9][0-9][0-9][0-9].psf > seeing.out

# Start a findloop loop
# If you want to see what's going on (and which are likely to be the
# problem PSF stars) use the display options.

rm -r pass*
figaro
figdisp
findloop -trim 4 5 -dp -dn
findloop -fi

exit