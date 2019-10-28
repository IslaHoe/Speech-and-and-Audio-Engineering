function [voicedGMM,unVoicedGMM] = trainGMM(fPathDir)

%set up for all voiced features and all unvoiced features
totalVoiced = [];
totalUnvoiced = [];
countv = 0;
countuv = 0;
fullCount = 1;

%load and store data points for each inputed wav file
for j = 1:length(fPathDir)
    
    folder = fPathDir{j,1};
    cd(folder);
   
    fn = char(fPathDir{j,2});
    [x,fs,wrd,phn]=readsph(fn,'wt');
    
    ms2=floor(fs*0.002);
    ms10=floor(fs*0.01);
    ms20=floor(fs*0.02);
    ms30=floor(fs*0.03); 
    ms60=floor(fs*0.00);
    
    %innitalise positions and empty arrays to store features 
    pos=1; i = 1; j = 1; k = 1;  %markers
    uv_count=1; v_count =1; 
    uv ={}; v = {}; %inital feature arrays

    groundTruth = {}; %ground truth data 
   
    %extract features and classify features for individual frames;
    while (pos+ms30) <= length(x)
        
       
        y = x(pos:pos+ms30-1);
        timeStamp = (pos + ms30-1)/fs;
        [type] = typeClassifer(timeStamp,phn); 
        features = melcepst(y,fs,"E0dD",12,floor(3*log(fs)),ms30,ms30,0,0.5);


        groundTruth{j,2} = type;
        groundTruth{j,1} = timeStamp;

        uvCheck = strcmp(type,'uv');
        vCheck = strcmp(type,'v');
        f = length(features);
        count = 1;




          if vCheck == 1
                fullCount = fullCount+1;

                v{v_count,1} = double(features(1));
                v{v_count,2} = double(features(2));
                v{v_count,3} = double(features(3));
                v{v_count,4} = double(features(4));
                v{v_count,5} = double(features(5));
                v{v_count,6} = double(features(6));
                v{v_count,7} = double(features(7));
                v{v_count,8} = double(features(8));
                v{v_count,9} = double(features(9));
                v{v_count,10} = double(features(10));
                v{v_count,11} = double(features(11));
                v{v_count,12} = double(features(12));
                v_count = v_count+1;

            else
                 fullCount = fullCount+1;
                uv{uv_count,1} = double(features(1));
                uv{uv_count,2} = double(features(2));
                uv{uv_count,3} = double(features(3));
                uv{uv_count,4} = double(features(4));
                uv{uv_count,5} = double(features(5));
                uv{uv_count,6} = double(features(6));
                uv{uv_count,7} = double(features(7));
                uv{uv_count,8} = double(features(8));
                uv{uv_count,9} = double(features(9));
                uv{uv_count,10} = double(features(10));
                uv{uv_count,11} = double(features(11));
                uv{uv_count,12} = double(features(12));
                uv_count = uv_count+1;
          end 
          
        pos = pos + ms10;

        uvF = double(cell2mat(uv));
        vF = double(cell2mat(v));
        
    end
         totalUnvoiced = [totalUnvoiced;uvF];
         totalVoiced = [totalVoiced;vF];
    %Use this for multiple input files 
   
    
end

options = statset('MaxIter',1000);

voicedGMM = fitgmdist(totalVoiced,2,'RegularizationValue',0.1,'Options',options); 
unVoicedGMM = fitgmdist(totalUnvoiced,2,'RegularizationValue',0.1,'Options',options);

end 

