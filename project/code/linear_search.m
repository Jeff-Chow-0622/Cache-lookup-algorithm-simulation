
%clear all; close all;
% 
% linear search

function [cache_table, building_cache_time, ave_b_c_time, total_lookup_time, ave_time, MACs]=linear_search(n, data_set) % n is the number of lookup you want to test
    [dataset_r, datast_c] = size(data_set);
    cache_table = zeros([dataset_r, datast_c]);
    tic
    for d = 1:dataset_r
        cache_table(d, :) = data_set(d, :);
    end

    building_cache_time = toc;

    ave_b_c_time = building_cache_time / dataset_r;

    %[row, col] = size(cache_table);

    test_index = randi(dataset_r, 1, n); %range is within (1, number of row in table)  Can be repeated???
    %time_record = zeros(1, n);
    test_ips = cache_table(test_index, 1);
    MACs = zeros(n, 1);
    tic
    for i = 1:n
       test_ip = test_ips(i);
       for j = 1:dataset_r
           if cache_table(j, 1) == test_ip
               MACs(i) = cache_table(j, 2);
               break;
           end
       end
    end

    %for i = test_ip
        %for j = c_table(:, 1)
            %if j == i
                %break; 
    total_lookup_time = toc;
    ave_time = total_lookup_time / n;


    fprintf('Cache size: %d entries\n', dataset_r);
    fprintf('Number of lookups: %d\n', n);
    fprintf('Total time: %.6f seconds\n', total_lookup_time);
    fprintf('Average lookup time: %.6f seconds (%.2f us)\n', ave_time, ave_time * 1e6);
end


