



% binary search
function [cache_table, building_cache_time, ave_b_c_time, total_lookup_time, ave_time, MACs] = binary_search(n, data_set)
    

    % build a cache table
    dataset_r = size(data_set, 1);
    tic
    [sorted_IPs, sorted_index] = sort(data_set(:, 1));
    sorted_MACs = data_set(sorted_index, 2);
    cache_table = [sorted_IPs(:), sorted_MACs(:)];
    building_cache_time = toc;
    ave_b_c_time = building_cache_time / dataset_r;
    
 
        
    test_ips_index = randi(dataset_r, 1, n); % can be searching for same ip multiple times
    test_ips = data_set(test_ips_index, 1);
    success = 0;
    MACs = zeros(n, 1);
    tic
    for i = 1:n
        target = test_ips(i);
        left = 1;
        right = dataset_r;
        while (left <= right)
            mid = floor((right + left) / 2);
            if sorted_IPs(mid) == target
                MACs(i) = cache_table(mid, 2);
                break
            elseif sorted_IPs(mid) < target
                left = mid + 1;
            else
                right = mid - 1;
            end
        end
        
        if sorted_IPs(mid) == target
            success = success + 1;
        end

    end
    total_lookup_time = toc;
    ave_time = total_lookup_time / n;


    fprintf('Cache size: %d entries\n', dataset_r);
    fprintf('Number of lookups: %d\n', n);
    fprintf('Total time: %.6f seconds\n', total_lookup_time);
    fprintf('Average lookup time: %.6f seconds (%.2f us)\n', ave_time, ave_time * 1e6);

end

















