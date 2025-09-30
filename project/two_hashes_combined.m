clear all; close all;

% Since IP and MAC has to be unique, I used randperm instead of randi
IP = randperm(2^32, 500) - 1; %total 2^32 combinations, I take 10000 of them 
MAC = randperm(2^48, 500) - 1;%total 2^48 combinations, I take 10000 of them 

IP_MAC = [IP(:), MAC(:)];
[ip_r, ip_c] = size(IP);
% in this hash table simulation, I ignore the time it takes for populating
% the table






%building the table for linear search

cache_table_ls = IP_MAC;


% building the cache table for binary search
[sorted_IPs, sorted_index] = sort(IP_MAC(:, 1));
sorted_MACs = IP_MAC(sorted_index, 2);
cache_table_bs = [sorted_IPs(:), sorted_MACs(:)];



% building the cache table for hash with linear prob
A = 0.6; % parameter of multiplication hash function
m = 500; % size of table

cache_table_h = zeros(m, 2);



for i = 1:ip_c
    index = floor((mod(A*IP(i), 1)) * m ) + 1; % I +1 here to avoid "Index in position 1 is invalid. Array indices must be
    if index > m
        index = index - m;
    end                                                %positive integers or logical values."
    %increment = 0;
    % using linear probing method
    while cache_table_h(index, 1) ~= 0
        index = index + 1;
        if (index) > m
            index = 1;
            
        end
    end
    
    cache_table_h(index, 1) = IP_MAC(i, 1);
    cache_table_h(index, 2) = IP_MAC(i, 2);
end




% building cache table for double hashing 

m_dh = 509;
prime_num = max(primes(m_dh)); 
%hash_func1 = floor((mod(A*IP, 1)) * m ) + 1;
hash_f1 = @(A, ip, m)floor((mod(A * ip, 1)) * m );
    %hash_func2 = mod(IP, m) + 1;
hash_f2 = @(ip, prime)prime - mod(ip, prime);

ind_func = @(ip, itr, A, m, prime)mod(hash_f1(A, ip, m) + itr * hash_f2(ip, prime), m) + 1;


cache_table = zeros(m_dh, 2);

for i = 1:ip_c
    itr = 0;
    index = ind_func(IP(i), itr, A, m_dh, prime_num);                                       
    % using double hashing
    while cache_table(index, 1) ~= 0
        itr = itr + 1;
        index = ind_func(IP(i), itr, A, m_dh, prime_num);
        if itr > m_dh
            fprintf("Collision overflow at i=%d (IP=%d)\n", i, IP(i));
            break;
        end


    end

    cache_table(index, 1) = IP_MAC(i, 1);
    cache_table(index, 2) = IP_MAC(i, 2);
end


















% generate test ips
n = 500;
test_ips_index = randi(ip_c, 1, n); % can be searching for same ip multiple times
test_ips = IP(test_ips_index);
hit = zeros(1, n);
miss = zeros(1, n);

%0.6180339887;

iteration = 50;
ave_t_arry_ls = zeros(iteration, 1);
ave_t_arry_bs = zeros(iteration, 1);
ave_t_arry_hlp = zeros(iteration, 1);
ave_t_arry_dh = zeros(iteration, 1);





% total comparement    
for I = 1:iteration



    %linear search
    tic
    for i = 1:n
       test_ip = test_ips(i);
       for j = 1:ip_c
           if cache_table_ls(j, 1) == test_ip
               break;
           end
       end
    end

    %for i = test_ip
        %for j = c_table(:, 1)
            %if j == i
                %break; 
    total_lookup_time_ls = toc;
    ave_time_ls = total_lookup_time_ls / n;


    fprintf('Cache size: %d entries\n', ip_c);
    fprintf('Number of lookups: %d\n', n);
    fprintf('Total time: %.6f seconds\n', total_lookup_time_ls);
    fprintf('Average lookup time: %.6f seconds (%.2f microseconds)\n', ave_time_ls, ave_time_ls * 1e6);
    ave_t_arry_ls(I) = ave_time_ls * 1000000;




    % binary search
    success = 0;
    tic
    for i = 1:n
        target = test_ips(i);
        left = 1;
        right = length(sorted_IPs);
        while (left <= right)
            mid = floor((right + left) / 2);
            if sorted_IPs(mid) == target
                
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
    total_lookup_time_bs = toc;
    ave_time_bs = total_lookup_time_bs / n;


    fprintf('Cache size: %d entries\n', m);
    fprintf('Number of lookups: %d\n', n);
    fprintf('Total time: %.6f seconds\n', total_lookup_time_bs);
    fprintf('Average lookup time: %.6f seconds (%.2f microseconds)\n', ave_time_bs, ave_time_bs * 1e6);
    ave_t_arry_bs(I) = ave_time_bs * 1000000;






    %hash with linear probing
    tic
    for i = 1:n
        test_ip = test_ips(i);
        search_index = floor((mod(A*test_ip, 1)) * m ) + 1;
        if search_index > m
            search_index = search_index - m;
        end
        while cache_table_h(search_index, 1) ~= test_ip
            search_index = search_index + 1;
            miss(1, i) = miss(1, i) + 1;
            if search_index > m
                search_index = 1;
            end
            
        end
        if cache_table_h(search_index, 1) == test_ip
            %fprintf("ip index: %d found ", ind)
            if miss(1, i) == 0
                hit(1, i) = hit(1, i) + 1;
            end
        else
            printf("sth else wrong\n")
        end
        
    
       % if cache_table(search_index) == IP(ind)  % then w found the correct one
    end
    total_time_h = toc;
    ave_time_h = total_time_h / n;
    
    fprintf('Cache size: %d entries\n', m);
    fprintf('Number of lookups: %d\n', n);
    fprintf('Total time: %.6f seconds\n', total_time_h);
    fprintf('Average lookup time: %.6f seconds (%.2f microseconds)\n', ave_time_h, ave_time_h * 1e6);
    ave_t_arry_hlp(I) = ave_time_h * 1000000;
    
    
    
    
    
    % double hashing
    
    tic
    for i = 1:n
        itr = 0;
        test_ip = test_ips(i);
        %search_index = floor((mod(A*test_ip, 1)) * m ) + 1;
        search_index_dh = ind_func(test_ip, itr, A, m_dh, prime_num);
    
        while cache_table(search_index_dh, 1) ~= test_ip
            itr = itr + 1;
            search_index_dh = ind_func(test_ip, itr, A, m_dh, prime_num);
            miss(1, i) = miss(1, i) + 1;
    
        end
        if cache_table(search_index_dh, 1) == test_ip
            if miss(1, i) == 0
                hit(1, i) = hit(1, i) + 1;
            end
        % else
        %     fprintf("sth else wrong\n")
        end
    
    
       % if cache_table(search_index) == IP(ind)  % then w found the correct one
    end
    total_time = toc;
    ave_time = total_time / n;
    
    fprintf('Cache size: %d entries\n',m_dh );
    fprintf('Number of lookups: %d\n', n);
    fprintf('Total time: %.6f seconds\n', total_time);
    fprintf('Average lookup time: %.6f seconds (%.2f microseconds)\n', ave_time, ave_time * 1e6);
    ave_t_arry_dh(I) = ave_time * 1000000;
end







% histogram & after processing

mean_arr_hlp = mean(ave_t_arry_hlp);
mean_arr_dh = mean(ave_t_arry_dh);
mean_arr_ls = mean(ave_t_arry_ls);
mean_arr_bs = mean(ave_t_arry_bs);


figure;
histogram(ave_t_arry_ls,'Normalization','pdf')
hold on;
histogram(ave_t_arry_bs, 'Normalization', 'pdf');
histogram(ave_t_arry_hlp, 'Normalization', 'pdf');
histogram(ave_t_arry_dh, 'Normalization', 'pdf');
legend(sprintf("Linear search; mean: %.3fms", mean_arr_ls), sprintf("Binary search; mean: %.3fms", mean_arr_bs), sprintf("Hash Linear prob; mean: %.3fms", mean_arr_hlp), sprintf("double hash; mean: %.3fms", mean_arr_dh));
xlabel('Average Lookup Time (ms)');
ylabel('Probability Density');
title('Distribution of Lookup Times(500) and cache size=500');
grid on;