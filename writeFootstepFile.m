function writeFootstepFile(fname,stepdata)
% fname is the file name string, i.e., 'test.txt'
% stepdata is a struct with two fields:
%   stepdata.support is an array of support types at each step
%   (Support type: 0=Dsc, 1=SSL, 2=SSR)
%   stepdata.pos is an array of footsteps where each row specifies
%   t, x_left, y_left, yaw_left, x_right, y_right, yaw_right

% if exist([pwd,'/',fname],'file')
%     if strcmp(questdlg(['Overwrite ',fname,'?'],'Overwrite','Yes','No','No'), 'No')
%         return;
%     end
% end

fid = fopen(fname,'w');
for ii=1:numel(stepdata.support)
    fprintf(fid,'%d, %f, %f, %f, %f, %f, %f, %f\n',stepdata.support(ii),stepdata.pos(ii,:));
end
fclose(fid);
% msgbox(['Saved to ',fname]);
