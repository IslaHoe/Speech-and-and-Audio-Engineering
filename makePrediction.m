function [prediction,fs, accuracy] = makePrediction(name,folder,voicedGMM,unVoicedGMM)


    cd(folder);
    fn = name;
    [x,fs,wrd,phn]=readsph(fn,'wt');
    
    
    ms2=floor(fs*0.002);
    ms10=floor(fs*0.01);
    ms20=floor(fs*0.02);
    ms30=floor(fs*0.03);
    pos = 1;
    pred = {};
    itteration = 1;
    featureToTest = [];
    predictions = {};
    timeStamp = [];
 
    
    while (pos+ms30) <= length(x)
        
        timeStamp = [pos,pos+ms30-1];
        
        y = x(pos:pos+ms30-1);
        features = melcepst(y,fs,"E0dD",12,floor(3*log(fs)),ms30,ms30,0,0.5);
        
        for i = 1:size(features,2)
            featureToTest(1,i) = features(i);
        end
    
        
        prVoice = pdf( voicedGMM, featureToTest );
        prUnVoice = pdf( unVoicedGMM, featureToTest );
   
        prediction=log(prVoice) - log(prUnVoice);
   
        
        if prediction > 0
            prediction = 'v';
        else 
            prediction = 'uv';
        end 
        
        predictions{itteration,1} = timeStamp;
        predictions{itteration,2} = prediction;
        itteration = itteration + 1;
        pos = pos + ms10;
    end
    
    prediction = predictions;
    [accuracy] = cAccuracy(prediction,x,phn,fn,fs);
    
    %get accuracy here
    
end

