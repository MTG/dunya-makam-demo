function [tonic, tempo, tuning, info] = extractTonicTempoTuning(...
    score, scoreMetadata, audio, audioMelody, outputFolder, varargin)
% jointTonicTempoTuningExtraction
%
% Demo for identifying the performed tonic in an audio recording by linking
% the repetitive section in the score of the performed composition. The
% methodology is explained in the [1]. The methodology is based on previous
% findings in [2] and [3]. The pitch features are extracted using Melodia
% [4] implementation in Essentia [5].
%
% In this experiment, the audio and the score are known to be of the same
% composition. We define tonic as 'the pitch class of the performed
% frequency of the karar (tonic) note.' Even though the octave information
% is important, we formalize the tonic around the pitch class due to some
% performance scenarios where the frequency of the karar is ambiguous (i.e.
% ensemble performances).
%
% The score file is in symbTr format [6], which is a machine-readable
% format. The symbTr-score also includes the musically relevant structures
% (sections) of the compositions (in the lyrics colums).
%
% Composition MusicBrainz* ID: 608def1b-d955-46e0-acde-1e3190d4f49b
% Audio Recording MusicBrainz ID: 06edff91-7617-4b6e-ba75-4537a56f86cb
%
% Author: Sertan Senturk (sertan.senturk@upf.edu)
% Music Technology Group - Universitat Pompeu Fabra
% 2013
%
% References:
% [1] S. Senturk, S. Gulati, and X. Serra. Score Informed Tonic
% Identification for Makam Music of Turkey. In Proceedings of ISMIR, 2013.
% [2] S. Senturk, A. Holzapfel, and X. Serra. Linking scores and audio
% recordings in makam music of Turkey. Journal of New Music Research,
% (submitted).
% [3] P. Chordia and S. Senturk. Joint recognition of raag and tonic in
% North Indian music. Computer Music Journal, 37(3), 2013.
% [4] J. Salamon and E. Gomez. Melody extraction from polyphonic music
% signals using pitch contour characteristics. IEEE Transactions on Audio,
% Speech, and Language Processing, 20(6):1759?1770, 2012.
% [5] D. Bogdanov, N. Wack, E. Gomez, S. Gulati, P. Herrera, O. Mayor, G.
% Roma, J. Salamon, J. Zapata, and X. Serra. Essentia: An audio analysis
% library for music information retrieval. In Proceedings of ISMIR, 2013.
% [6] K. Karaosmanoglu. A Turkish makam music symbolic database for music
% information retrieval: SymbTr. In Proceedings of ISMIR, pages 223-228,
% 2012.
% * www.musicbrainz.org

%% start experiment time
runStart = tic;

options = ['Write2File', false, 'FragmentLocation', ...
    'start_without_intro', 'FragmentDuration', ...
    {feature.DataPoint(15, 'seconds')}, varargin];

%% tonic identification
disp(' ');disp('------------ Joint Tonic, Tempo and Tuning Extraction -----------')

% instantiate the extractor
jointExtractor = makamLinker.TonicTempoTuningExtractor(options);

% identify
[tonic,tempo,tuning,info]=jointExtractor.estimate(score, audio, ...
    scoreMetadata, audioMelody);

%% convert to json
tonic = external.jsonlab.savejson('scoreInformed', tonic, ...
    fullfile(outputFolder, 'tonic.json'));
tempo = external.jsonlab.savejson('scoreInformed', tempo, ...
    fullfile(outputFolder, 'tempo.json'));
tuning = external.jsonlab.savejson('scoreInformed', tuning, ...
    fullfile(outputFolder, 'tuning.json'));

%% End of Demo
disp(['Tonic-Tempo-Tuning Identification took ' num2str(toc(runStart)) ' seconds'])
