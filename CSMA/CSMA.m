clc; clear;

num_frames = 10;  
max_attempts = 5; 

slot_time = 0.01;         
IFS = 0.05;               
CTS_timeout = 0.1;        
ACK_timeout = 0.1;        


for frame = 1:num_frames

    fprintf('Frame %d:\n', frame);
    
    success = false;
    k = 0;
    
    while k < max_attempts && ~success
        channel_busy = rand < 0.5;
        if channel_busy
            disp('Channel is Busy, waiting IFS...');
            pause(IFS);
            continue;
        else
            disp('Channel is Free, waiting IFS...');
            pause(IFS);

            % Backoff
            CW = min(2^k - 1, 2^max_attempts - 1);
            backoff_slots = randi([0, max(CW,0)]);
            fprintf('Backoff = %d slots\n', backoff_slots);
            pause(backoff_slots * slot_time);

            % RTS/CTS exchange
            disp('Sending RTS...');
            pause(CTS_timeout);
            
            CTS_received = rand > 0.2;

            if ~CTS_received
                disp('CTS not received, retrying...');
                k = k + 1;
                continue;
            end
            disp('CTS received, sending data...');
            pause(IFS);

            % ACK check
            pause(ACK_timeout);
            ACK_received = rand > 0.1;
            
            if ACK_received
                disp('ACK received, frame successful!');
                success = true;
            else
                disp('ACK not received, retrying...');
                k = k + 1;
            end

        end
        fprintf('-----------------------------\n');
    end

    if ~success
        fprintf('Frame %d failed after %d attempts.\n', frame, max_attempts);
    end
end




