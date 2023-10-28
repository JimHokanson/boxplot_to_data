function g = loadExample(example_name)
%
%   box2data.loadExample(example_name)
%
%   Example
%   -------
%   g = box2data.loadExample('Bramley_2021.png')

p = mfilename('fullpath');

root = fileparts(fileparts(p));
examples_root = fullfile(root,'examples');

file_path = fullfile(examples_root,example_name);

g = box2data.main_gui(file_path);

end