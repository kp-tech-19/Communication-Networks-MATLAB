clc;clear;

num_frames=10;
max_attempts=5;

slot_time=0.01;
IFS=0.05;
CTS_timeout=0.1;
ACK_timeout=0.1;

for frame=1:num_frames
      fprintf("Frame: %d \n",frame);
      k=0;
      success=false;

      while k< max_attempts && ~success
           channel_busy=rand<0.5;
           if channel_busy 
              disp("Channel is busy.Wait for IFS");
              pause(IFS);
              continue;
           else
               disp("Channel is free.Wait for IFS");
               pause(IFS);

               %backoff
               CW=min(2^k-1,2^max_attempts-1);
               backoff_slot=randi([0,max(CW,0)]);
               fprintf("Backoff= %d \n",backoff_slot);
               pause(backoff_slot*slot_time);
               %RTS/CTS exchange
               disp("RTS sending");
               pause(CTS_timeout);

               CTS_recived= rand>0.2;
               if ~CTS_recived
                   disp("CTS not recived.Retrying...");
                   k=k+1;
                   continue;
               else
                   disp("CTS recived.Recived successfully.")
                   success=true;
               end

               %ACK 
               ACK_received=rand>0.1;
               pause(ACK_timeout);
               if ~ACK_received
                   disp("ACK not recived. Retrying...");
                   k=k+1;
               else
                   disp("ACK recived.Recived successfully.");
                   success=true;
               end
           end
         fprintf("----------------------------------\n");
      end
      
     if ~success
         fprintf("Frames %d not recived in %d attempts\n",frame,max_attempts);
     end
end
