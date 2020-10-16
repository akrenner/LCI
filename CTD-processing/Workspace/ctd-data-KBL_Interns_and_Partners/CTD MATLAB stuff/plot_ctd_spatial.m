%  Plots CTD temperature and salinity measurements along a transect at a 
%  given depth determined by user. 

%  Prompts user for inputs

%  Creates two figures, one for temperature and one for salinity

%  NOTE: CTD data must be in netCDF format, and file names must be of the 
%  format 'yyyymmdd_transect.nc' (for example, 20130721_T6.nc)

% You may want to change the graph axes depending on which transect(s) you're plotting. 
% [-154.5 -150.5 57.5 61] is good for capturing all of Cook Inlet

%---------------------------User defined info-----------------------------%

% Enter directory for CTD data
CTD_dir = '/Users/Jing/Documents/MATLAB/2013_ctd_netcdf2/';

% Insert Cook Inlet Coastline map full path
load /Users/Jing/Documents/MATLAB/Summer_2012_CTDobs_NOSCOOPS/cook_inlet_coastline.mat

%-------------------------------------------------------------------------%
% User Prompts

% Date (yyyymmdd) 
date = input('Enter date (yyyymmdd): ', 's');

title_date = [date(5:6) '/' date(7:8) '/' date(1:4)]; % date as appears in title

% Transect #
trans = input('Which Transect would you like to plot?: ', 's');

trans = ['T' trans];

% set temperature plotting range
tmin = input ('Temperature scale minimum (degrees Celsius): '); 
tmax = input('Temperature scale maximum (degrees Celsius): ');

% set salinity plotting range 
smin = input('Salinity scale minimum (PSU): '); 
smax = input('Salinity scale maximum (PSU): ');

%-------------------------------------------------------------------------%
filename = [CTD_dir date '_' trans '.nc'];

% Open file
f = netcdf.open(filename, 'NC_NOWRITE')

% Get depth variable, 'z'
var_name='z';var_id=netcdf.inqVarID(f,var_name);z=netcdf.getVar(f,var_id,'double');

% Display all available depths in file
 disp(' ')
  disp('Available depths (in meters) in this file:')
  disp('------------------------------------------------')
  disp(z)
  disp(' ')

% Choose a depth
depth = input('What depth (in meters) do you want to plot? ');

% Get variables for lat, long, temperature, and salinity
var_name='lon';var_id=netcdf.inqVarID(f,var_name);lon1=netcdf.getVar(f,var_id,'double');
var_name='lat';var_id=netcdf.inqVarID(f,var_name);lat1=netcdf.getVar(f,var_id,'double');
var_name='temp';var_id=netcdf.inqVarID(f,var_name);temp=netcdf.getVar(f,var_id,'double');
var_name='sal';var_id=netcdf.inqVarID(f,var_name);salt=netcdf.getVar(f,var_id,'double');

% Plot temperatures at the given depth at each station. 

figure(1) % Plot Cook Inlet Coastline
grid on
plot(lon,lat,'color',[0.5 0.5 0.5]) 
xlabel('Longitude','FontSize',14)
ylabel('Latitude','FontSize',14)
title([title_date ' CTD Survey, Depth: ' num2str(depth) 'm'],'FontSize',14)
axis([-154.5 -150.5 57.5 61])

figure(1) % Plot temperatures
hold on
for k=1:length(lat1) % iterate over each station
    for j=1:length(z) % iterate over all the possible depths at each station
        if depth==z(j) && temp(j,k)>-100 % find correct depth 
           scatter(lon1(k), lat1(k), 25, temp(j,k),'filled'); y=colorbar; caxis([tmin, tmax]); % plot temp
       
        end
    end
end

ylabel(y, 'Temperature (Degrees Celcius)', 'FontSize', 13)
    
% Plot Salinity at given depth

figure(2) % Plot Cook Inlet Coastline
grid on
plot(lon,lat,'color',[0.5 0.5 0.5]) 
xlabel('Longitude','FontSize',14)
ylabel('Latitude','FontSize',14)
title([title_date ' CTD Survey, Depth: ' num2str(depth) 'm'],'FontSize',14)
axis([-154.5 -150.5 57.5 61])

figure(2) % Plot salinity
hold on
for k=1:length(lat1)
    for j=1:length(z)
        if depth==z(j) && salt(j,k)>-100
           scatter(lon1(k), lat1(k), 25, salt(j,k),'filled'); y=colorbar;
           colormap('spring'); caxis([smin, smax]);
       
        end
    end
end

ylabel(y, 'Salinity (PSU)', 'FontSize', 13)

% Option to plot another transect on the same graphs
x = input('Would you like to plot another transect? (Y or N) ', 's');

if x == 'Y';
   plot_ctd_spatial
else
    % Option to rename title (for multi-day trips, otherwise the date in
    % title will automatically be the date of the latest file)
   y = input('Would you like to rename the title date? (Y or N) ', 's');
   if y =='Y';
       title_date=input('Enter date as you want it to appear in the titles: ', 's')
       figure(1); title([title_date ' CTD Survey, Depth: ' num2str(depth) 'm'],'FontSize',14)
       figure(2); title([title_date ' CTD Survey, Depth: ' num2str(depth) 'm'],'FontSize',14)
    disp('Yay you are done!') 
   else
       disp('Whoo! You are finished!') 
   end
end