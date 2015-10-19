%%
clear
clc
close all

%addpath('/Users/sertansenturk/Documents/notaIcra/code/fragmentLinker')
addpath('./../../code/fragmentLinker')

addpath('./code/alignment/')

%% start experiment time
wrapperStart = tic;
set(0,'DefaultFigureWindowStyle','docked')

%% parameters
dataFolder = './data/';

% default options
sectionOptions = {'Verbose', true, 'PlotSteps', true};
alignerOptions = {'Verbose', true, 'PlotSteps', false};

%% get the file locations
fileLocations = fragmentLinker.FileOperation.getAudioScorePairs(...
    dataFolder, 'wav', 'txt');

for f = numel(fileLocations):-1:1
    fileLocations(f).folder = fileparts(fileLocations(f).audio);
    fileLocations(f).predominantMelody = fullfile(fileLocations(f).folder,...
        'predominantMelody.mat');
    fileLocations(f).tonic = fullfile(fileLocations(f).folder,...
        'tonic.json');
    fileLocations(f).tempo = fullfile(fileLocations(f).folder,...
        'tempo.json');
    fileLocations(f).tuning = fullfile(fileLocations(f).folder,...
        'tuning.json');
    
    scorefolder = fileparts(fileLocations(f).score);
    fileLocations(f).scoreMetadata = fullfile(scorefolder,...
        'scoreMetadata.json');
    fileLocations(f).structureModel = '';
    
    fileLocations(f).sectionTxt = fullfile(fileLocations(f).folder,...
        'sectionLinks.txt');
    fileLocations(f).sectionJson = fullfile(fileLocations(f).folder,...
        'sectionLinks.json');
end

%%
for f = 1:numel(fileLocations)
    %%
    disp(fileLocations(f).audio)
    [~] = alignAudioScore(fileLocations(f).score,...
        fileLocations(f).scoreMetadata, fileLocations(f).structureModel,...
        fileLocations(f).audio, fileLocations(f).predominantMelody, ...
        fileLocations(f).tonic, fileLocations(f).tempo, ...
        fileLocations(f).tuning, fileLocations(f).folder,sectionOptions,...
        alignerOptions);
end