function [alignedLinks, alignedNotes, info] = alignAudioScore(...
    score, scoreMetadata, structureModel, audio, audioMelody, ...
    audioTonic, audioTempo, audioTuning, outputFolder, varargin)
% audioScoreAlignment
%
% Wrapper for linking the sections of the scores of different compositions
% to audio recording of the same composition. The methodology is explained
% in [1] using optimal parameters. During the process the tonic of the
% audio recording is also estimated by linking the repetitive section. See
% [2] for the methodology.
%
% In this experiment, the audio and the score are known to be of the same
% composition*. The score includes the musically relevant sections and their
% sequence in the composition. For candidate estimation, we use the class
% "@SectionCandidateLinkEstimator." The class links the given sections
% independent of each other. To follow the steps of how a single section
% is linked to the audio, please refer to "linkSingleScoreSectionDemo.m".
%
% After the candidate estimation a Variable-length Markov Model is trained
% to be used in the sequential linking step. The VLMM is trained on the
% annotated section sequences other audio recordings whose scores follow
% the same sequence with the current score. In the sequential linking step
% the most probable links from the section candidate links are selected
% according to the VLMM. We use the class "SequentialLinkEstimator" for
% sequential linking. To follow the steps of how the links are selected
% sequentially, please refer to "sequentialLinkingDemo.m".
%
% The score file is in symbTr format [3], which is a machine-readable
% format. The symbTr-score also includes the musically relevant structures
% (sections) of the compositions (in the lyrics colums). The audio features
% are extracted using Melodia [4] implementation in Essentia [5].
%
% Author: Sertan Senturk (sertan.senturk@upf.edu)
% Music Technology Group - Universitat Pompeu Fabra
% 2013
%
% References:
% [1] S. Senturk, A. Holzapfel, and X. Serra. Linking scores and audio
% recordings in makam music of Turkey. Journal of New Music Research,
% (submitted).
% [1] S. Senturk, S. Gulati, and X. Serra. Score Informed Tonic
% Identification for Makam Music of Turkey. In Proceedings of ISMIR, 2013.
% [3] K. Karaosmanoglu. A Turkish makam music symbolic database for music
% information retrieval: SymbTr. In Proceedings of ISMIR, pages 223-228,
% 2012.
% [4] J. Salamon and E. Gomez. Melody extraction from polyphonic music
% signals using pitch contour characteristics. IEEE Transactions on Audio,
% Speech, and Language Processing, 20(6):1759?1770, 2012.
% [5] D. Bogdanov, N. Wack, E. Gomez, S. Gulati, P. Herrera, O. Mayor, G.
% Roma, J. Salamon, J. Zapata, and X. Serra. Essentia: An audio analysis
% library for music information retrieval. In Proceedings of ISMIR, 2013.
%
% * The metadata is store as MBIDs. For further information refer to the
% relevant documentation in MusicBrainz.
% http://musicbrainz.org/doc/MusicBrainz_Identifier

%% start experiment time
runStart = tic;

% parse options
switch numel(varargin)
    case 0
        secExtraOpts = {};
        dtwExtraOpts = {};
    case 1
        secExtraOpts = varargin{1};
        dtwExtraOpts = {};
    case 2
        secExtraOpts = varargin{1};
        dtwExtraOpts = varargin{2};
    otherwise
            error('alignAudioScore:extraOptions', ['Extra options can '...
                'at most 2 cells; one for sectionLinking and '...
                'another or noteAlignment'])
end

sectionOptions = ['TempoEstimationMethod', 'scoreInformed', ...
    'SectionCandidateEstimationMethod', 'houghDtw', ...
    'FilterKmeans', true, 'RemoveInconsequent', false, ...
    'GuessNonlinked', false, ...
    'Write2File', false, 'OverwriteFile', false, secExtraOpts];

dtwOptions = {'DtwPixelsPitchDistanceBinarizationThreshold', feature...
    .PitchDataPoint(50, 'cent'), 'Write2File', false,...
    'OverwriteFile', false, dtwExtraOpts{:}};

%% start repetitive section linking
disp(' ');disp('------------ Sequential Linking -----------')

% instantiate the estimator objects
sectionLinker = makamLinker.SectionLinker(sectionOptions);
aligner = fragmentLinker.NoteAligner(dtwOptions);

%% section linking
[~, sectionLinks, info, audio, sections] = sectionLinker.link(...
    score, audio, scoreMetadata, structureModel, audioMelody, audioTonic, ...
    audioTempo, audioTuning);

%% note alignment
[alignedNotes, alignedLinks] = aligner.align(sectionLinks, sections, audio);

%% convert to json
alignedLinks.saveLinks(alignedLinks, ...
    fullfile(outputFolder, 'sectionLinks.json'), 'links', false, false);
alignedNotes = external.jsonlab.savejson('notes', alignedNotes, ...
    fullfile(outputFolder, 'alignedNotes.json'));

%% End of Demo
disp(['Audio-score alignment took ' num2str(toc(runStart)) ' seconds'])
