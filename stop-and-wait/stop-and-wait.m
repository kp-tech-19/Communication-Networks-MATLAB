clc;clear;
framesize = input("enter the framesize:");
data = '1010101001010101001100100';
totalframes = floor(length(data)/framesize);
errorprob = 0.2;

ack = zeros([1, totalframe]);lost = 0;frame = 1;

while frame <= totalframes

    frameno = mod(frame-1, 2);
    ackno = mod(frame, 2);

    startidx = (frame-1)*framesize + 1;
    endidx = startidx + framesize - 1;
    val = data(startidx:endidx);

    fprintf("transmitting frame %d\n", frameno);
    fprintf("frame data %s\n", val);

    cases = ["no ack", "ack", "delayed"];
    case_str = cases(randi([1, 3]));

    if case_str == "no ack"
        fprintf("ack %d not received\n", ackno);
        pause(1);
        lost = lost + 1;
        if lost == 5
            fprintf("timeout. retransmitting frame...\n");
            pause(1);
            ack(frame) = ackno;frame = frame + 1; lost = 0;
            fprintf("ack %d received\n", ackno);
        end
        continue;

    elseif case_str == "ack"
        if rand < errorprob
            index = randi([1, framesize]);
            if val(index) == '0'
                val(index) = '1';
            else
                val(index) = '0';
            end
            fprintf("frame is corrupted\n");
            fprintf("received frame data %s\n", val);
            original_val = data(startidx:endidx);
            if strcmp(val, original_val)
                fprintf("ack %d received\n", ackno);
                ack(frame) = ackno;frame = frame + 1; lost = 0;
            else
                fprintf("frame %d is corrupted. retransmitting data...\n", frame);
                pause(1);
                continue;
            end
        else
            fprintf("ack %d received\n", ackno);
            ack(frame) = ackno;frame = frame + 1;lost = 0;
        end

    elseif case_str == "delayed"
        fprintf("ack %d received after delay\n", ackno);
        ack(frame) = ackno;frame = frame + 1;lost = 0;
    end
end

fprintf("all frames transmitted successfully\n");

