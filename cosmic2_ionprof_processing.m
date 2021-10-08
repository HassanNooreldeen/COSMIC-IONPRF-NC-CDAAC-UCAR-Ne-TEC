%{
You should edit Section 1 only!!!!! 
on your desktop Go to "This Pc" and Open the C partition!!
Functions of this code are: 

Section-2:
Downloading  'ionPrf_prov1_year_doy.tar.gz' files from COSMIC Data Analysis
     and Archive Center CDAAC https://data.cosmic.ucar.edu/gnss-ro/cosmic2/
Section-3:
Untar the   'ionPrf_prov1_year_doy.tar.gz'  to   'ionPrf_prov1_year_doy.nc'
Section-4:
Reading of the nc files   and   export   the  follwing  variables  from  it
{GEO_lat         GEO_lon         MSL_alt         TEC_cal         ELEC_dens}
Extracting the time from  the nc files name and creat new variable for Time
called   'Generate_time' and save all variables in txt  files  named by the
date and time in new folder called "txtdata" (about 3500 file for each day) 
Section-5:
Merge  txt files in one txt file for each sat and name it by the sat number 
Section-6:
Merge the txt files of all satellites in one file in txt format and another 
one  in  xlsx  format  and   save  it  in  new   folder   called   results, 
the    file     named       " alldatafor-year-doy-month-day.txt and .xlsx "
Section-7:
plot  the  electron  density  with  altitude  for  all  atmospheris  layers
Section-8:
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
Not that data is filterd in section 7 and section 8 in part 2,3,and 4
in part 2 all Ne values below the min_Ne is removed
in part 3 all data beyond the selected latitude is removed
in part 4 all Ne data higher than the mean of maximum 20 points is removed
Comment part 4 in section 6 and 7 to stop the high fluctuation filter.
Data is downsampled by a factored 2, in section 6 part 2.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
credit: 
This code was developed by Eng: Hassan Noor Eldeen 
MSc  student  in  the  Space  Sciencs  departiment  at   Helwan  University 
a space  environment  specialist  at   the  Egyptian  Space  Agency  (EgSA)
for any technical or scientific advice from you to me or vice versa mail me
at HassanNoorElDeen@egsa.gov.eg or  HassanNour-Eldien@science.helwan.edu.eg
for acknowledgment:
Eng: Hassan Noor El-deen,   Space Environment Studies and Tests Department,
Egyptian Space Agency EGSA, 1564 Cairo, Egypt. 
May Allah accept this effort in our good deeds!
%}
%%
close all; clear; clc;
%% Section 1: Enter information for the study period
datafolder=('C:');            %All files will be downloaded on the C partition
                           %Preferred to select partition with SSD Hard Memory 
year = num2str(2020);                 %Cosmic2 for period (Oct-2019 until now)
start_doy = 1;                      %You can start from any doy from 1 to 365) 
end_doy = 366;                          %You can end at any doy from 1 to 365)
mission = 'cosmic2' ;               %This code only work with cosmic 2 mission
lower_altitude= 200;               %you can select any range from 10 to 800 Km
upper_altitude= 350;
min_Ne= 100000;       %keep it 100000, if you don't have a solar eclipse model
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section 2:  Download data from COSMIC UCAR data center    
cd ([datafolder '\']);                    mkdir([ 'cosmic' year]);
yearfolder =([datafolder '\cosmic' year]);cd (yearfolder);
mkdir(['rawdata' year]);   
rawfolder=([datafolder '\cosmic' year '\rawdata' year '\']);  
for i1=start_doy:end_doy   %From 1 to 365 or 366 for the whole year
    cd (rawfolder);
    doy1=num2str(i1,'%03g');      %to creat a string of format 000 for the doy
    if contains(mission,'cosmic2') %check that the selected mission is cosmic2 
    fullURL=(['https://data.cosmic.ucar.edu/gnss-ro/' mission '/provisiona'...
              'l/spaceWeather/level2/' year '/' doy1 '/ionPrf_prov1_' year ...
              '_' doy1 '.tar.gz']);
    filename1  =  ([  'ionPrf_prov1_'    year    '_'    doy1    '.tar.gz'  ]);
    if isfile(filename1)
       sprintf(['The file ' filename1 ' is aleardy exist in the directory!!'])
    else
       websave(filename1,fullURL);
    sprintf(['Job successfully finished for DOWNLOADING ' filename1 'file!!'])
    end
    else
    sprintf(['No such data for: ' num2str(i1) '-' year  ' or '  mission '!!'])    
    end
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section 3: UNTAR the .TAR.Z files to .nc files
  doy1 =char(extractBetween(filename1,19,21));
  year1=char(extractBetween(filename1,14,17));    
 filename2=(['UNTARionP_' year1 '_' doy1 '.nc']);
 cd ([datafolder '\cosmic' year]);                         mkdir 'Extracted';
 extractfolder=([datafolder '\cosmic' year '\Extracted\']);cd (extractfolder);
 mkdir (filename2);cd (rawfolder);extractedfile=([ extractfolder  filename2]);
  selpath = (extractedfile);
  if isfile(filename1)
     untar(filename1,extractedfile);
  else
     fprintf([filename1 'not exist'])
  end
  sprintf([ 'Job successfully finished for UNTAR '    filename1    ' file!!'])
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section 4: read and convert nc.files to txt and EXCEL.xlsx files       
% part 1
cd (extractedfile); mkdir ('txtandexcel');cd (yearfolder);  mkdir ('results');
cd (extractedfile); filePattern1 = fullfile(extractedfile, 'ion*_nc'); 
ncfiles1 = dir(filePattern1); ncfilesc1 = length(ncfiles1); k=1;
for C = 1:6
  for ii3= 1:ncfilesc1
      satnum = (['C2E',num2str(C)]);
      filename3 = fullfile(ncfiles1(ii3).name);
      if contains(filename3,satnum)
        % ncdisp(filename3);
         MSL_alt = ncread(filename3,'MSL_alt');
         GEO_lat = ncread(filename3,'GEO_lat'); 
         GEO_lon = ncread(filename3,'GEO_lon'); 
         OCC_azi = ncread(filename3,'OCC_azi'); 
         TEC_cal = ncread(filename3,'TEC_cal');
         ELEC_dens = ncread(filename3,'ELEC_dens');
      % part 2
         Time = char(extractBetween(filename3,22,26));
         [numRows,numCols] = size(GEO_lat);
         Generate_time = str2num(Time)*ones(numRows,1);
         savePath = ([ datafolder '\cosmic' year1 '\Extracted\'  filename2 ...
         '\txtandexcel\']); textfile_name=([savePath  'ionPrf_' satnum '.' ...
         year1 '.' doy1 '_' Time '.txt']);  fileID=fopen(textfile_name, 'w+');
         fprintf(fileID,   '%f     %f     %f     %f     %f     %f     \n', ...
         [Generate_time  GEO_lat   GEO_lon   MSL_alt   TEC_cal   ELEC_dens]');
         fclose(fileID);
      end
  end
 end
 sprintf(['Job successfully finished for converting '   filename2 ' from ' ...
          'nc to .txt with time!!'])
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section 5: Merge text files for each satellite
txtfolder = ([extractedfile '\txtandexcel\']);  cd (txtfolder);
folderData4=(txtfolder); filePattern4 = fullfile(folderData4, 'ion*.txt'); 
txtfiles4 = dir(filePattern4);                 txtfilesc4 = length(txtfiles4);
for C = 1:6 
    fid_p4 = fopen(['sat',num2str(C),'.txt'],'w');
    for i4 =1:txtfilesc4
        sat=(['C2E',num2str(C)]);name_of_file4=fullfile(txtfiles4(i4).name);
        if contains(name_of_file4,sat)               
           filename4=([txtfiles4(i4).name]);
           char(extractAfter(name_of_file4,17));
           fid_t4=fopen(filename4,'r'); data4 = fscanf(fid_t4,'%c');
           fprintf(fid_p4,'%c',data4); fclose(fid_t4);
        end
    end         
    fclose(fid_p4);
      sprintf(['Job successfully finished for merging files of ' filename2 ...
               ' for each satellite!!'])        
end   
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section 6: Merge text files for all satellites 
 % part 1
 cd (txtfolder)
 filePattern5=fullfile(folderData4, 'sat*.txt');satfiles5=dir(filePattern5);
 satfilesc5 = length(satfiles5); savePathfina5 = ([yearfolder '\results\']); 
 yearsatd = str2num(year1);   doysatd = str2num(doy1);
 [yy, mm ,dd] = datevec(datenum(yearsatd,1,doysatd));     yys = num2str(yy); 
 mm = num2str(mm,'%02g'); dd = num2str(dd,'%02g'); 
 fid_p5 = fopen([ savePathfina5, 'satdatafor-' year1 '-'  doy1  '-month-' ...
                    mm '-day-' dd  '.txt'] ,'w');                
for i =1:satfilesc5
    sat = (['sat',num2str(i)]);
    name_of_file5 = fullfile(satfiles5(i).name); 
    if contains(name_of_file5,sat)
       filename5=[sat '.txt']; fid_t5=fopen(filename5,'r'); 
       data5= fscanf(fid_t5,'%c'); fprintf(fid_p5,'%c',data5); fclose(fid_t5);
    end
end
 fclose(fid_p5);
 sprintf(['Job successfully finished for merging files of ' satfiles5.name ...
          ' in one file!!'])
  %% 
  % part 2
  cd  ([yearfolder '\results']);
  filename6=(['satdatafor-' year1 '-' doy1 '-month-' mm '-day-' dd  '.txt ']);
  datah = load(filename6); 
  data=downsample(datah,2);
  time= data(:,1); lat= data(:,2); long= data(:,3);
  alt=  data(:,4); tec= data(:,5); ne=   data(:,6);
  xlswrite(['alldatafor-' year1 '-' doy1 '-month-' mm '-day-' dd  '.xlsx'], ...
      [time lat long alt tec ne]);
 sprintf(['Job successfully finished for converting ' filename6 ' to xlsx!!'])
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section 7: plot Ne with altitude for the whole atmosphere
   % part 1:
   cd ([yearfolder '\results\']);
   datamatrix=xlsread(['alldatafor-' year1 '-' doy1 '-month-' mm '-day-' dd]);
   % part 2: Filter for the negative and illogical values of electron density
   datamatrix5 = datamatrix(datamatrix(:,6)>=min_Ne,:);
   % part 3: for all atmosphere altitude range (10 to 800 km)
   datamatrix4  = datamatrix5(datamatrix5(:,4)>=10,:);
   datamatrix3  = datamatrix4(datamatrix4(:,4)<800,:);
   xtime=datamatrix3(:,1);   xlat=datamatrix3(:,2);
   xlong=datamatrix3(:,3);   xalt=datamatrix3(:,4);
   xtec=datamatrix3(:,5);    xne=datamatrix3(:,6);
   % part 4: Filter for the high fluctuated values of electron density
   xnemaxs=maxk(xne,20); xnemeans=mean(xnemaxs);
   xnef=xne(xne<=xnemeans); xaltf=xalt(xne<=xnemeans);
   xlatf=xlat(xne<=xnemeans); xlongf=xlong(xne<=xnemeans);
   xtecf=xtec(xne<=xnemeans); xtimef=xtime(xne<=xnemeans);
   % part 5: calculate the mean value of electron density profile
   xaltf=round(xaltf,1);[xnall,~,ixall]=unique(xaltf); xnall=smooth(xnall);   
   meall= accumarray(ixall,xnef,[],@mean);   meall=smooth(meall,0.2,'rloess');
%%  
% part 6:
figure(1);
scatter(xnef,xaltf,'Marker','.'); xlim([0 4000000]); grid on ;box on
  xlabel('Electron density (N/cm^{3}'); ylabel('Altitude (km)'); 
  title(['Electron density profile from Cosmic in '  dd  '-'  mm  '-'  yys ...
  ' at altitude from 10 to 800 Km']); set(gcf,'position',get(0,'screensize'));
  saveas(figure(1), ['Ne profile all layers ' year1 '-' doy1 '-' dd '-' mm ...
                     '-' yys '.fig']);
  saveas(figure(1), ['Ne profile all layers ' year1 '-' doy1 '-' dd '-' mm ...
                     '-' yys '.png']);    close(figure(1))    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2)
   plot(meall,xnall,'Marker','.');  xlim([0 1000000]);
   xlabel('Electron density (N/cm^{3}'); ylabel('Altitude (km)')
  title(['Average Electron density profile from Cosmic in ' doy1 '-' year1 ...
         '-' dd '-' mm '-' yys ' at altitude from 10 to 800 Km'])
set(gcf,'position',get(0,'screensize')); grid on ; box on;
saveas(figure(2),['average Ne profile all layers ' year1 '-' doy1 '-' dd ...
                  '-' mm '-' yys '.fig']);
saveas(figure(2),['average Ne profile all layers ' year1 '-' doy1 '-' dd ...
                  '-' mm '-' yys '.png']); close(figure(2))
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section 8: plot Ne with altitude ana Ne map for the F2-region
% part 1:
l_alt=num2str(lower_altitude); 
u_alt=num2str(upper_altitude);
% part 2:
datamatrix1 = datamatrix(datamatrix(:,6)>=min_Ne,:);
% part 3:
datamatrix2  = datamatrix1(datamatrix1(:,4)>=lower_altitude,:);
datamatrix3  = datamatrix2(datamatrix2(:,4)<=upper_altitude,:);
xtimef2=datamatrix3(:,1);   xlatf2=datamatrix3(:,2);
xlongf2=datamatrix3(:,3);   xaltf2=datamatrix3(:,4);
xtecf2=datamatrix3(:,5);    xnef2=datamatrix3(:,6);
% part 4: Filter for the high fluctuated values of electron density  
xnemaxf2=maxk(xnef2,20); xnemeanf2=mean(xnemaxf2);
xnef2=xnef2(xnef2<=xnemeanf2); xaltf2=xaltf2(xnef2<=xnemeanf2);
xlatf2=xlatf2(xnef2<=xnemeanf2); xlongf2=xlongf2(xnef2<=xnemeans);
xtecf2=xtecf2(xnef2<=xnemeanf2); xtimef2=xtimef2(xnef2<=xnemeanf2);
% part 5:
xaltf2=round(xaltf2,1);[xnf2,~,ixallf2]=unique(xaltf2); xnf2=smooth(xnf2);  
nef2 = accumarray(ixallf2,xnef2,[],@mean);  nef2=smooth(nef2,0.2,'rloess'); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% part 6:
xlswrite(['F2-region data for' year1 '-' doy1 '-month-' mm '-day-' ...
        dd '.xlsx'],[xtimef2 xlatf2 xlongf2 xaltf2 xtecf2 xnef2]);    
%%
% part 7:
figure(3);
scatter(xnef2,xaltf2,'Marker','.'); xlim([0 4000000]); grid on ;box on
  xlabel('Electron density (N/cm^{3}'); ylabel('Altitude (km)'); 
  title(['Electron density profile from Cosmic in '  dd  '-'  mm  '-'  yys ...
         ' at altitude from ' l_alt ' to ' u_alt ' Km']); 
    set(gcf,'position',get(0,'screensize'));
    saveas(figure(3), ['Ne profile-' l_alt ' to ' u_alt '-' year1 '-' doy1 ...
      '-' dd '-' mm '-' yys '.fig']);
   saveas(figure(3), ['Ne profile-' l_alt ' to ' u_alt  '-' year1 '-' doy1 ...
      '-' dd '-' mm '-' yys '.png']);    close(figure(3))    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4)
   plot(nef2,xnf2,'Marker','.');  xlim([0 1000000]);
   xlabel('Electron density (N/cm^{3}'); ylabel('Altitude (km)')
  title(['Average Electron density profile from Cosmic in ' doy1 '-' year1 ...
         '-' dd '-' mm '-' yys ' at altitude from 200 to 350 Km']);
set(gcf,'position',get(0,'screensize')); grid on ; box on;
 saveas(figure(4),['Ne profile-' l_alt ' to ' u_alt '_' year1 '-' doy1 '-' ...
    dd '-' mm '-' yys '.fig']);
 saveas(figure(4),['Ne profile-' l_alt ' to ' u_alt '-' year1 '-' doy1 '-' ...
    dd '-' mm '-' yys '.png']); close(figure(4))
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% part 8:
%{
  the map for the Ne at altitude range 10-800 is meaningless,the map should be
  for a narrow range of altitudes for example F1-rgion or f2-region only    
%}

latVdr = linspace(min(xlatf2), max(xlatf2), 50);
lonVdr = linspace(min(xlongf2), max(xlongf2), 50);
[lonGdr, latGdr] = meshgrid(lonVdr, latVdr);
valGdr = griddata(xlongf2, xlatf2,xnef2, lonGdr, latGdr);
valGdr(isnan(valGdr))=100000;

figure(5)
load coastlines
worldmap world
contourfm(latVdr,lonVdr,valGdr,'LineStyle','none')
geoshow(coastlat,coastlon,'Color','k')
contourcbar
colormap(jet())
     c = colorbar;
     c.Label
     c.Label.String = 'Ne (N/cm^3)';
     grid on ,
     box on ,
      caxis([10000 900000])
      c.Limits = [10000 900000];
xlabel('longitude')
ylabel('latitude')
 title(['Equatorial Ionization anomaly in electron density in ' ...
     doy1 '-' dd '-' mm '-' yys 'at altitude from ' l_alt ' to ' u_alt ]);    
set(gcf,'position',get(0,'screensize'));  
saveas(figure(5),['electron density map for Ne at altitude from ' l_alt ...
    ' to ' u_alt '-' year1 '-' doy1 '-' dd '-' mm '-' yys '.fig']);
saveas(figure(5),['electron density map for Ne at altitude from ' l_alt ...
    ' to ' u_alt '-'  year1 '-' doy1 '-' dd '-' mm '-' yys '.png']);
     close(figure(5))
%%
 sprintf(['Job successfully finished for processing ' filename1 'file!!'])
 sprintf('Credit to Hassan Noor Eldeen')
end   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
