clear all;

%open directory where DR five is stored 
cd '/Applications/MATLAB_R2018b.app/MATLAB/Isla-Hoe-4C4'
fFiles = dir('**/F*');

fPathDir = {};
fDir = {};
marker = 1;
results = 'full';

%set up all the paths to files 
for i = 1:size(fFiles)
    folder = char(string(fFiles(i).folder)+'/'+string(fFiles(i).name));
    fDir{i,1} = folder;
    %open speciefed folder 
    cd(folder);
    %get all wav files for that folder
    wavFilesDir = dir('**/*.WAV');
   
    for j = 1:size(wavFilesDir)-2
        
        wavPath = string(string(fFiles(i).folder)+'/'+string(fFiles(i).name)+'/'+(wavFilesDir(j).name));
        fPathDir{marker,1} = folder;
        fPathDir{marker,2} = wavPath;
        marker = marker+1;
    end
    
end

%call function to train GMM's 
cd '/Applications/MATLAB_R2018b.app/MATLAB//Isla-Hoe-4C4'
[voicedGMM,unVoicedGMM] = trainGMM(fPathDir);

%open directory for challange files 
cd '/Applications/MATLAB_R2018b.app/MATLAB//Isla-Hoe-4C4/CHALLANGE'
%get all WAV files 
challangeFiles = dir('**/*.WAV');
newMarker = 1;
fullCount = 1;
printPrediction = {};
nc = 1;
fc = 1;



    for i = 1:size(challangeFiles)

        name = char(challangeFiles(i).name);
        nc = nc+1;
        fileName = string(name)+'.vuv';
        folder = char(challangeFiles(i).folder);
        fc = fc+1;
        fileID = fopen((fileName),'w');
        fprintf(fileID, 'Voiced and Unvoiced Transcription \n\n');

        [prediction,fs, accuracy] = makePrediction(name, folder,voicedGMM,unVoicedGMM);
        fprintf(fileID,' Timestamp   V/UV \n');

        for j = 1:size(prediction)
            ts = (prediction{j,1});
            pr = prediction{j,2};

            printPrediction{newMarker,1} = ts/fs;
            printPrediction{newMarker,2} = pr;

            fprintf(fileID,'[%0.3f %0.3f]  %s\n', printPrediction{newMarker,1}(1),printPrediction{newMarker,1}(2), printPrediction{newMarker,2});

            newMarker = newMarker + 1;
        end 
        fprintf(fileID,' Accuracy \n %f ', accuracy);

        fullCount = fullCount+1;

    end





    
