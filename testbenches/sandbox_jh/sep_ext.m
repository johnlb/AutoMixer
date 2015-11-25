function [filename,fileext] = sep_ext (fullname)
filename = fullname;
fileext = fullname;
for n = 1:length(fullname)
  [~,filename{n},fileext{n}] = fileparts(fullname{n});
end;

