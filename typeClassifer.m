function [type] = typeClassifer(timeStamp,phn)

i = 1;
type = ' ';
time = 1;

vPhn  = {'d';'g';'p';'dx';'q';'jh';'z'; 'zh';'v';'dh';'n';'ng';'em';'en';'eng';'nx';'l';'vr';'w';'y';'hh';'hv';'el';'iy';'ih '; 'eh '; 'ey '; 'ae'; 'aa'; 'aw'; 'ay';'ah';'ao'; 'oy'; 'ow';'uh';'uw';'ux';'er';'ax'; 'ix';'axr';'ax-h';'dcl';'ih'};
uvPhn = {'ch' ;'s' ; 'sh'; 'th'; 't'; 'k' ;'c';'p';'h#';'epi' ; 'pau'};
silence = {'epi' ; 'pau'; 'h#'};


while  i < size(phn,1)+1

        phnStart = phn{i,1}(1);
        phnEnd = phn{i,1}(2);
        
    if timeStamp> phnStart && timeStamp<phnEnd
        time = i;
        break
    else 
        time = i;
        i = i+1;
    end 
    
end

 phn_current = phn{time,2};

 if ismember(phn_current,uvPhn)
       type = 'uv';
 else 
       type = 'v';
 end 

     

 end 
     
         
         
         