clear; clc;

errorprobability = 0.2;
framesize = input("Enter frame size (data bits): ");
m = input("Enter number of bits for sequence numbers: ");
windowsize = 2^m - 1;
data = '0101101110100000100101011011001011001001';
totalframes = floor(length(data)/framesize);
ack = zeros(1, totalframes);
frame = 1;

while frame <= totalframes
    windowend = min(frame + windowsize - 1, totalframes);
    fprintf('Sending frames %d to %d...\n', frame - 1, windowend - 1);
    failed = [];
    
    for f = frame:windowend
        if ack(f) == 1
            continue;
        end
        
        startidx = (f - 1)*framesize + 1;
        endidx = startidx + framesize - 1;
        val = data(startidx:endidx);
        event = rand();
        
        if event < 0.2
            fprintf('Frame %d corrupted.\n', f-1);
            failed(end+1) = f;
        elseif event < 0.4
            fprintf('Receiver: Frame %d received but ACK lost!\n', f-1);
            failed(end+1) = f;
        elseif event < 0.6
            fprintf('Receiver: Frame %d received but ACK delayed!\n', f-1);
            failed(end+1) = f;
        else
            if rand < errorprobability
                idx = randi([1, framesize]);
                val(idx) = char('0' + '1' - val(idx));
                fprintf('Frame %d corrupted during transmission!\n', f-1);
            end
            fprintf('Frame %d received: %s\n', f-1, val);
            original_val = data(startidx:endidx);
            if strcmp(val, original_val)
                ack(f) = 1;
                fprintf('Receiver: Frame %d received. ACK sent.\n', f-1);
            else
                fprintf('Frame %d corrupted.\n', f-1);
                failed(end+1) = f;
            end
        end
        
        pause(0.3);
    end
    
    for f = failed
        if ack(f) == 1
            continue;
        end
        fprintf('Retransmitting Frame %d...\n', f-1);
        while ack(f) == 0
            if rand < errorprobability
                fprintf('Retransmission of Frame %d failed.\n', f-1);
            else
                ack(f) = 1;
                fprintf('Retransmission of Frame %d successful.\n', f-1);
            end
        end
    end
    
    while frame <= totalframes && ack(frame) == 1
        frame = frame + 1;
    end
end

fprintf('\nAll frames successfully transmitted and acknowledged.\n');
