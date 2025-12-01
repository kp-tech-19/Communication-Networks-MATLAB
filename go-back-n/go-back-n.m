clc;clear;

data='101010010000111001010010010100101';
framesize=input("Enter framesize:");
m=input("Enter sequence number bits(m):");
totalframe=floor(length(data)/framesize);
errorprb=0.2;
windowsize=2^m -1;

frame=1;timeout=0.1;

while frame<=totalframe
        frame_in_window=min(windowsize,totalframe-frame+1);
        failed=false;
        fprintf("Sending frames from %d to %d:\n",frame-1,frame+frame_in_window-2);
        
        for i=1:frame_in_window
            fno=frame+i-1;
            seqno=mod(fno-1,2^m);

            startidx=(fno-1)*framesize+1;
            endidx=startidx+framesize-1;
            val=data(startidx:endidx);
            
            r1=rand();r2=rand();r3=rand();r4=rand();

            if r1<0.1||r2<0.1||r3<0.1
                if r1<0.1
                     fprintf("Sender:Frame %d lost.Retransmitting frame %d.....\n",seqno,seqno);
                else
                    fprintf("Reciver:Frame %d recived.Ack delayed/lost.\n",seqno);
                    fprintf("Sender:Timeout.Retransmitting frame %d.....\n",seqno);
                    
                end
                failed=true;frame=fno;pause(timeout);break;
            else
                if r4<errorprb
                    index=randi([1,framesize]);
                    if val(index)=='0'
                        val(index)='1';
                    else
                        val(index)='0';
                    end
                    fprintf("Frame %d is corrupted.Recived frame data:%s\n",seqno,val);
                    if strcmp(val,data(startidx:endidx))
                        fprintf("Reciver:Frame %d recived.Ack send.\n",seqno);
                    else
                        fprintf("Reciver:Frame %d corrupted. No Ack.\n",seqno);
                        fprintf("Sender:Timeout.Retransmitting frame %d.....\n",seqno);
                        failed=true;frame=fno;pause(timeout);break;
                    end
                else
                    fprintf("Reciver:Frame %d recived.Ack send.\n",seqno);
                end
            end
        end
       if ~failed
            frame= frame+frame_in_window;
       end

end
fprintf("All frames are transmitted successfully.\n");
