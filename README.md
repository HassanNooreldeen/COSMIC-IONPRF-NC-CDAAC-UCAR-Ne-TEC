# COSMIC-IONPRF-PROCESSING
Download and analyze ionosphere data from the COSMIC CDAAC, Filter and analyze Electron density for several years of data by MATLAB.
%{
You should edit Section 1 only!!!!! 
on your desktop Go to "This Pc" and Open the C partition!!
Functions of this code are: 

Section-1:
Downloading  'ionPrf_prov1_year_doy.tar.gz' files from COSMIC Data Analysis
     and Archive Center CDAAC https://data.cosmic.ucar.edu/gnss-ro/cosmic2/
Section-2:
Untar the   'ionPrf_prov1_year_doy.tar.gz'  to   'ionPrf_prov1_year_doy.nc'
Section-3:
Reading of the nc files   and   export   the  follwing  variables  from  it
{GEO_lat         GEO_lon         MSL_alt         TEC_cal         ELEC_dens}
Extracting the time from  the nc files name and creat new variable for Time
called   'Generate_time' and save all variables in txt  files  named by the
date and time in new folder called "txtdata" (about 3500 file for each day) 
Section-4:
Merge  txt files in one txt file for each sat and name it by the sat number 
Section-5:
Merge the txt files of all satellites in one file in txt format and another 
one  in  xlsx  format  and   save  it  in  new   folder   called   results, 
the    file     named       " alldatafor-year-doy-month-day.txt and .xlsx "
Section-6:
plot  the  electron  density  with  altitude  for  all  atmospheris  layers
Section-7:
plot  the  electron  density  with  altitude  for  the             F2 layer
plot the electron density map with latitude and longitude for the  F2 layer
save  the data  for  the F2  layer in new Excel.xlsx file in results folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I sincerely acknowledge the COSMIC Data Analysis and Archive Center (CDAAC) 
for   providing     FORMOSAT-7/COSMIC-2     and   other   GNSS-RO  datasets 
 (https://cdaac-www.cosmic.ucar.edu/cdaac/index.html)
my Acknowledgement to  Mr: Samerr Hisham  from the Space Weather Monitoring 
Center (SWMC) For his valuable help in coding.       Samerrhisham@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Not that data is filterd in section 6 and section 7 in part 2,3,and 4
in part 2 all Ne values below the min_Ne is removed
in part 3 all data beyond the selected latitude is removed
in part 4 all Ne data higher than the mean of maximum 20 points is removed
Comment part 4 in section 6 and 7 to stop the high fluctuation filter
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
credit: 
This code was developed by Eng: Hassan Noor Eldeen 
MSc  student  in  the  Space  Sciencs  departiment  at   Helwan  University 
a space  environment  specialist  at   the  Egyptian  Space  Agency  (EgSA)
for any technical or scientific advice from you to me or vice versa mail me
at HassanNoorElDeen@egsa.gov.eg or  HassanNour-Eldien@science.helwan.edu.eg
May Allah accept this effort in our good deeds
%}
