clc;clear;

framesize=input ("Enter framesize:");
data='10101010110011010101001001001010';
totalframes=floor(length(data)/framesize);
errorprb=0.2;

ack=zeros([1,totalframes]);lost=0;frame=1;

while frame<=totalframes
    frameno=mod(frame-1,2);
    ackno=mod(frame,2);

    startidx=(frame-1)*framesize+1;
    endidx=startidx+framesize-1;
    val=data(startidx:endidx);

    fprintf("Transmitting frame %d with data %s\n",frameno,val);
    cases=["no ack","ack","delayed ack"];
    cases_str=cases(randi([1,3]));

    if cases_str=="no ack"
        fprintf("Ack %d not recived\n",ackno);
        pause(1);
        lost=lost+1;
        if lost==5
           fprintf("Timeout,retransmitting frame....\n");
           pause(1);
           ack(frame)=ackno;lost=0;frame=frame+1;
           fprintf("Ack %d recived \n",ackno);
        end
        continue;
    elseif cases_str=="ack"
        if rand< errorprb
            index=randi([1,framesize]);
            if val(index)=='0'
                val(index)='1';
            else 
                val(index)='0';
            end
            fprintf("Frame %d corruputed. Frame recived :%s\n",frameno,val);
            original_val=data(startidx:endidx);
            if strcmp(val,original_val)
                fprintf("Ack %d recived ",ackno); 
                ack(frame)=ackno;lost=0;frame=frame+1;
            else
               fprintf("Frame %d corruputed. Retransmitting frame....\n",frameno);
               pause(1);
               continue;
            end
        else
          fprintf("Ack %d recived\n ",ackno); 
          ack(frame)=ackno;lost=0;frame=frame+1;
        end
        
    elseif cases_str=="delayed ack"
        fprintf("Ack %d recived after delay\n",ackno);
        ack(frame)=ackno;lost=0;frame=frame+1;
    end
end
fprintf("All frames transmitted successfully\n");
