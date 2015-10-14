%%
clear
clc
close all

addpath('./../../code/fragmentLinker')

%% start experiment time
wrapperStart = tic;

%% parameters
dataFolder = './data/';

% default options
options = {'Verbose', true, 'PlotSteps', false};

%% get the file locations
fileLocations = fragmentLinker.FileOperation.getAudioScorePairs(...
    dataFolder, 'wav', 'txt');

for f = numel(fileLocations):-1:1
    fileLocations(f).folder = fileparts(fileLocations(f).audio);
    fileLocations(f).predominantMelody = fullfile(fileLocations(f).folder,...
        'predominantMelody.mat');
    scorefolder = fileparts(fileLocations(f).score);
    fileLocations(f).scoreMetadata = fullfile(scorefolder,...
        'scoreMetadata.json');
end

%%
for f = 1:numel(fileLocations)
    [~] = extractTonicTempoTuning(fileLocations(f).score, ...
        fileLocations(f).scoreMetadata,  fileLocations(f).audio, ...
        fileLocations(f).predominantMelody, fileLocations(f).folder, ...
        options{:});
end
