function sectioncsv2json(sectionjson, csvfile)
%SECTIONJSON2CSV Summary of this function goes here
%   Detailed explanation goes here

sections = external.jsonlab.loadjson(sectionjson);
sections.links = cell2mat(sections.links);

fid=fopen(csvfile,'r');
anno = textscan(fid,'%f%f%s','delimiter','\t');
[~] = fclose(fid);

for a = numel(anno{1}):-1:1
    sections.anno(a) = struct('name', anno{3}(a), 'weight', [], ...
        'relative_tempo', [], 'time', [anno{1}(a) anno{2}(a)], ...
        'time_unit','sec');
end

[~] = external.jsonlab.savejson('', sections, sectionjson);
end