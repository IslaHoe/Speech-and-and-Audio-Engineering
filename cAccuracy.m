function  [accuracy] = cAccuracy(prediction,x,phn,fn,fs)

    [fx,tt]= fxrapt(x,fs,'u');
    %gt = groundTruth

    pos = 1;
    ms30=floor(fs*0.03); 
    ms10=floor(fs*0.01); 
    count = 1;
    groundTruth = {};
    rp = 0;
    gp = 0;
    while (pos+ms30) <= length(x)

            y = x(pos:pos+ms30-1);
            timeStamp = (pos + ms30-1)/fs;
            [type] = typeClassifer(timeStamp,phn); 
            uvCheck = strcmp(type,'uv');
            vCheck = strcmp(type,'v');

              if vCheck == 1
                  groundTruth{count,1} = timeStamp;
                  groundTruth{count,2} = 'v';
                  count = count+1;


                else
                    groundTruth{count,1} = timeStamp;
                    groundTruth{count,2} = 'uv';
                    count = count + 1;
              end 

            pos = pos + ms10;


    end 
    
    acc_prediction = prediction;
    acc_rapt = fx;
    acc_gT = groundTruth;
    
    for i = 1:size(acc_prediction)
        gt_pre(i,1) = string(groundTruth{i,2});
        gt_pre(i,2) = string(prediction{i,2});
    end
    
    for i = 1:size(fx)
        rapt_pr(i,1) = string(groundTruth{i,2});
        rapt_pr(i,2) = string(fx(i));
        
        if rapt_pr(i,2) == 'NAN'
            rapt_pr(i,2) = 'uv';
        else
            rapt_pr(i,2) = 'v';
        end
    end
    
    for i = 1:size(rapt_pr)
        s1 = rapt_pr(i,1);
        s2 = rapt_pr(i,2);
        
        tf1 = strcmp(s1,s2);
        if tf1 == true
            rp = rp+1;
        end
        
        s3 = gt_pre(i,1);
        s4 = gt_pre(i,2);
        
        tf2 = strcmp(s3,s4);
           
        if tf2 == true
            gp = gp+1;
        end
        
    end 
    c = size(prediction,1);
    r_acc = rp/(c);
    gt_acc = gp/(c);
    
 

    accuracy = [r_acc,gt_acc];

end

