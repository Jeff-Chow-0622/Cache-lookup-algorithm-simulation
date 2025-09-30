function simulate_linear_search(n_entries, n_queries)
    % generate cache：IP to MAC（IP: 32-bit，MAC: 48-bit）
    cache_ips = randi([0, 2^32 - 1], n_entries, 1);
    cache_macs = randi([0, 2^48 - 1], n_entries, 1);
    cache = [cache_ips, cache_macs];

    % 隨機挑選 query IPs（從 cache 中選，保證命中）
    query_ips = cache_ips(randperm(n_entries, n_queries));

    % 開始計時
    tic;
    successful = 0;

    for i = 1:n_queries
        ip = query_ips(i);
        found = false;

        for j = 1:n_entries
            if cache(j,1) == ip
                mac = cache(j,2); %#ok<NASGU>
                found = true;
                break;
            end
        end

        if found
            successful = successful + 1;
        end
    end

    % 結束計時
    total_time = toc;
    avg_time = total_time / n_queries;

    % 輸出結果
    fprintf('--- Linear Search Simulation ---\n');
    fprintf('Cache size: %d entries\n', n_entries);
    fprintf('Number of lookups: %d\n', n_queries);
    fprintf('Successful lookups: %d\n', successful);
    fprintf('Total time: %.6f seconds\n', total_time);
    fprintf('Average lookup time: %.6f seconds (%.2f microseconds)\n', ...
            avg_time, avg_time * 1e6);
end




clear all; close all;

% Since IP and MAC has to be unique, I used randperm instead of randi
IP = randperm(2^32, 1000) - 1; %total 2^32 combinations, I take 1000 of them 
MAC = randperm(2^48, 1000) - 1;%total 2^48 combinations, I take 1000 of them 

% build a cache table
cache_table = [IP(:), MAC(:)]; % since I'm using linear search, they don't need to be in order

% linear search
function linear_search(n, c_table) % n is the number of lookup you want to test
    [row, col] = size(c_table);
    test_index = randperm(row, n); %range is within (1, number of row in table)  Can be repeated???s
    %time_record = zeros(1, n);
    ips = c_table(test_index, 1);

    tic
    for i = 1:n
       test_ip = ips(i);
       for j = 1:row
           if c_table(j, 1) == test_ip
               break;
           end
       end
    end

    %for i = test_ip
        %for j = c_table(:, 1)
            %if j == i
                %break; 


    end_time = toc;
    
    ave_time = end_time / n;

    fprintf('Cache size: %d entries\n', row);
    fprintf('Number of lookups: %d\n', n);
    fprintf('Total time: %.6f seconds\n', end_time);
    fprintf('Average lookup time: %.6f seconds (%.2f microseconds)\n', ave_time, ave_time * 1e6);
end


linear_search(1000, cache_table)

simulate_linear_search(1000, 1000)







