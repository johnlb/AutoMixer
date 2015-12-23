function [filename,fileext] = sep_ext (fullname)
filename = fullname;    % init to same size as fullname
fileext = fullname;     % init to same size as fullname
for n = 1:length(fullname)
  [filepath,filename{n},fileext{n}] = fileparts(fullname{n});
end;

