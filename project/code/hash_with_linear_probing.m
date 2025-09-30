










function [cache_table, building_cache_time, ave_b_c_time, total_time, ave_time, MACs] = hash_with_linear_probing(n, data_set, m, A)  %m is the size of cache table

    dataset_r = size(data_set, 1);

    % building the cache table



    cache_table = zeros(m, 2);

    tic
    for i = 1:dataset_r
        index = floor((mod(A*data_set(i, 1), 1)) * m ) + 1; % I +1 here to avoid "Index in position 1 is invalid. Array indices must be
        if index > m
            index = index - m;
        end                                                %positive integers or logical values."
        %increment = 0;

        % using linear probing method
        while cache_table(index, 1) ~= 0
            index = index + 1;
            if (index) > m
                index = 1;

            end
        end

        cache_table(index, 1) = data_set(i, 1);
        cache_table(index, 2) = data_set(i, 2);
    end
    building_cache_time = toc;
    ave_b_c_time = building_cache_time / dataset_r;



    % generate test ips
    test_ips_index = randi(dataset_r, 1, n); % can be searching for same ip multiple times
    test_ips = data_set(test_ips_index);
    hit = zeros(1, n);
    miss = zeros(1, n);

    MACs = zeros(n, 1);

    tic
    for i = 1:n
        test_ip = test_ips(i);
        search_index = floor((mod(A*test_ip, 1)) * m ) + 1;
        if search_index > m
            search_index = search_index - m;
        end
        while cache_table(search_index, 1) ~= test_ip
            search_index = search_index + 1;
            miss(1, i) = miss(1, i) + 1;
            if search_index > m
                search_index = 1;
            end

        end
        if cache_table(search_index, 1) == test_ip
            %fprintf("ip index: %d found ", ind)
            MACs(i) = cache_table(search_index, 2);
            if miss(1, i) == 0
                hit(1, i) = hit(1, i) + 1;
            end
        % else
        %     printf("sth else wrong\n")
        end


    % if cache_table(search_index) == IP(ind)  % then w found the correct one
    end
    total_time = toc;
    ave_time = total_time / n;

    fprintf('Cache size: %d entries\n', m);
    fprintf('Number of lookups: %d\n', n);
    fprintf('Total time: %.6f seconds\n', total_time);
    fprintf('Average lookup time: %.6f seconds (%.2f us)\n', ave_time, ave_time * 1e6);


end




