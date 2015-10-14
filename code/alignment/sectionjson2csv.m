function sectionjson2csv(sectionjson, csvfile)
%SECTIONJSON2CSV Summary of this function goes here
%   Detailed explanation goes here

sections = external.jsonlab.loadjson(sectionjson);
links = cell2mat(sections.links);

fid=fopen(csvfile,'wt');

for i=1:numel(links)
      [~] = fprintf(fid,'%f\t',links(i).time(1));
      [~] = fprintf(fid,'%f\t',links(i).time(2));
      [~] = fprintf(fid,'%s\n',links(i).name);
end
[~] = fclose(fid);

end