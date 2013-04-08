function mrdplot_to_mat(datafile)
% Saves a .mat file containing a struct with the elements of datafile
% parsed by column names
if nargin==0
    datafile = 'd00010';
end
[D,names,units,freq] = mrdplot_convert(datafile);
mrddata = cell2struct(num2cell(D,1),num2cell(char(names),2)',2);

mrd.pos = zeros(length(D),28);
mrd.vel = zeros(length(D),28);
mrd.eff = zeros(length(D),28);
for ii=1:28
    char(names(10+(ii-1)*3,:))
    mrd.pos(:,ii) = mrddata.(char(names(10+(ii-1)*3,:)));
    mrd.vel(:,ii) = mrddata.(char(names(11+(ii-1)*3,:)));
    mrd.eff(:,ii) = mrddata.(char(names(12+(ii-1)*3,:)));
end

save([datafile,'.mat'],'mrddata','mrd');
