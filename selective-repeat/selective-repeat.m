clc;clear;

framesize=input("Enter framesize:");
m=input("Enter m value:");
data='1010101000001110000010101010';
totalframe=floor(length(data)/framesize);
errorprb=0.2;
windowsize=2^(m-1);

ack=zeros(1,totalframe);
frame=1;

while frame<=totalframe
     windowend=min(windowsize+frame-1,totalframe);
     fprintf("Sending frame from %d to %d:\n",frame-1,windowend-1);
     failed=[];

      
     
     for f=frame:windowend
         event=rand();
         if ack(f)==1
             continue;
         end
         startidx = (f - 1) * framesize + 1; %9
         endidx=startidx + framesize - 1;
         val = data(startidx : endidx);
         if event<0.2
             fprintf("Reciver:Frame %d lost.Retransmitting frame %d.....\n",f-1,f-1);
             failed(end+1)=f;
         elseif event<0.4
             fprintf("Reciver:Frame %d recived.Ack lost.\n",f-1);
             failed(end+1)=f;
         elseif event<0.6
             fprintf("Reciver:Frame %d recived.Ack delayed.\n",f-1);
             failed(end+1)=f;
         else
            if rand<errorprb
               index = randi([1, framesize]);
                if val(index) == '0'
                    val(index) = '1';
                else
                    val(index) = '0';
                end
                 fprintf('Frame %d corrupted during transmission!\n', f-1);
                 fprintf('Frame %d received: %s\n', f-1, val);
                 if strcmp(val, data(startidx:endidx))
                     ack(f)=1;
                    fprintf('Receiver: Frame %d received correctly. ACK %d sent.\n', f-1, f-1);
                else
                    fprintf('Receiver: Frame %d corrupted! No ACK.\n', f-1);
                    fprintf('Sender: Timeout! Restarting from Frame %d\n', f-1);
                    failed(end+1)=f;
                end
            else
                fprintf("Receiver: Frame %d received correctly. ACK sent.\n", f-1);
                ack(f) = 1;
            end
    
         end
     end
     for f=failed
            fprintf("Retransmitting the frame %d.....\n",f-1);
            while true
                if rand<errorprb
                    fprintf("Retransmitting the frame %d failed.....\n",f-1);
                    failed(end+1)=f;
                else
                    fprintf("Retransmitting the frame %d successfully....\n",f-1);
                    ack(f)=1;break;
                end
            end
            
    end
    while frame<=totalframe && ack(frame)==1
                 frame=frame+1;
    end
end
fprintf("All frames are transmitted successfully.\n");
