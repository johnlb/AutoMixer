%% This script ensures the project is loaded in the matlab environment.
%% It should be run at the start of any script.

%% It assumes it is being run from somewhere inside the 'AutoMixer' directory.


thispath = pwd;

[~, endptr] = regexp(thispath,'AutoMixer');
if (isempty(endptr))
	error('This script should be run from inside "AutoMixer" directory');
end

thispath(endptr+1:end) = [];
thispath = [thispath '/'];
clear endptr

addpath([thispath 'tools']);
addpath([thispath 'proc_elts']);
% addpath([thispath 'testbenches']);


DATA_PATH = [thispath 'stems'];


