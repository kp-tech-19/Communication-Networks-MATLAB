clc; clear;

errorprobability = 0.2;
framesize = input("Enter number of bits per frame: ");
m = input("Enter number of sequence-number bits (m): ");
window_size = 2^m - 1;

data = '0101101110100000100101011011001011001001';
total_frames = floor(length(data)/framesize);

frame = 1; timeout = 0.3;

while frame <= total_frames
    frames_in_window = min(window_size, total_frames - frame + 1);
    fprintf('\nSending frames %d to %d...\n', frame, frame + frames_in_window - 1);
    failed = false;
    
    for i = 1:frames_in_window
        fno = frame + i - 1;

        startidx = (fno - 1) * framesize + 1;
        endidx = startidx + framesize - 1;
        val = data(startidx:endidx);

        r1 = rand(); r2 = rand(); r3 = rand(); r4 = rand();

        if r1 < 0.1
            fprintf('Sender: Frame %d lost! Restarting from Frame %d\n', fno, fno);
            frame = fno; failed = true; pause(timeout); break;
        elseif r2 < 0.1 || r3 < 0.1
            fprintf('Receiver: Frame %d received but ACK lost/delayed!\n', fno);
            fprintf('Sender: Timeout! Restarting from Frame %d\n', fno);
            frame = fno; failed = true; pause(timeout); break;
        else
            if r4 < errorprobability
                index = randi([1, framesize]);
                if val(index) == '0'
                    val(index) = '1';
                else
                    val(index) = '0';
                end
                fprintf('Frame %d corrupted during transmission!\n', fno);
            end

            fprintf('Frame %d received: %s\n', fno, val);

            if strcmp(val, data(startidx:endidx))
                fprintf('Receiver: Frame %d received correctly. ACK sent.\n', fno);
            else
                fprintf('Receiver: Frame %d corrupted! No ACK.\n', fno);
                fprintf('Sender: Timeout! Restarting from Frame %d\n', fno);
                frame = fno; failed = true; pause(timeout); break;
            end
        end
    end
    
    if ~failed
        frame = frame + frames_in_window;
    end
end

fprintf('\nAll frames sent and acknowledged successfully!\n');
