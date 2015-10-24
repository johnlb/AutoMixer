function [ chunks_id ] = find_chunk(raw, sample_time, time_window, threhold)
    abs_raw = abs(raw);
    [Xm, Im] = findpeaks(abs_raw);
    index = find(Xm <= threhold);
    
    %consecutive peaks below threhold
    d  = find(diff(index) > 1);
    interval_id = horzcat(index(d(1:end-1) + 1), index(d(2:end)));
    interval_id = vertcat([1, index(d(1))], interval_id);

    %time length between 
    interval_tid = horzcat(Im(interval_id(:,1)), Im(interval_id(:,2)));
    window_length = (interval_tid(:,2) - interval_tid(:,1)) * sample_time;
    valid_id = find(window_length >= time_window);
    valid_interval = interval_tid(valid_id,:);

    chunks_id = horzcat(valid_interval(1:end-1,2), valid_interval(2:end,1));
    chunks_id = vertcat([1, valid_interval(1,1)],chunks_id);
    if(valid_interval(end,2) < length(raw))
        chunks_id = vertcat(chunks_id,[valid_interval(end,2),length(raw)]);
    end


end

