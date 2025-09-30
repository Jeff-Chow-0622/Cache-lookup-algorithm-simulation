clear all; close all;

% Since IP and MAC has to be unique, I used randperm instead of randi
IP = randperm(2^32, 499) - 1; %total 2^32 combinations, I take 1000 of them 
MAC = randperm(2^48, 499) - 1;%total 2^48 combinations, I take 1000 of them 


IP_MAC = [IP(:), MAC(:)];
[ip_r, ip_c] = size(IP) ;
% in this hash table simulation, I ignore the time it takes for populating
% the table

% building the cache table
A = 0.6; % parameter of multiplication hash function
m = 10009; % size of table

cache_table = zeros(m, 2);



% test the impact of different size of cache table
table_sizes = [499, 997, 1201, 1499, 1999];
lookup_t = zeros(size(table_sizes));
collisions = zeros(size(table_sizes));






% double hash formula
%hash_func1 = floor((mod(A*IP, 1)) * m ) + 1;
%hash_func2 = mod(IP, m) + 1;

% function index = ind_func(ip, itr, A, m)
%     index = mod((floor(((mod(A*ip, 1)) * m ) + 1) + itr * (mod(ip, 997) + 1)) , m) + 1;
% 
% end
%hash_func1 = floor((mod(A*IP, 1)) * m ) + 1;
hash_f1 = @(A, ip, m)floor((mod(A * ip, 1)) * m );
    %hash_func2 = mod(IP, m) + 1;
hash_f2 = @(ip, prime)prime - mod(ip, prime);

ind_func = @(ip, itr, A, m)mod(hash_f1(A, ip, m) + itr * hash_f2(ip, 997), m) + 1;

for sizes = 1:length(table_sizes)
    

    m = table_sizes(sizes); 
    cache_table = zeros(m, 2);

    hash_f1 = @(A, ip, m)floor((mod(A * ip, 1)) * m );
    %hash_func2 = mod(IP, m) + 1;
    hash_f2 = @(ip, prime)prime - mod(ip, prime);

    ind_func = @(ip, itr, A, m)mod(hash_f1(A, ip, m) + itr * hash_f2(ip, 997), m) + 1;
    collisions_c = 0; % to count the collisions

    for i = 1:ip_c
        itr = 0;
        index = ind_func(IP(i), itr, A, m);                                       
        % using double hashing
        while cache_table(index, 1) ~= 0
            itr = itr + 1;
            index = ind_func(IP(i), itr, A, m);
            collisions_c = collisions_c + 1;
            if itr > m
                fprintf("Collision overflow at i=%d (IP=%d)\n", i, IP(i));
                break;
            end
    
    
        end
    
        cache_table(index, 1) = IP_MAC(i, 1);
        cache_table(index, 2) = IP_MAC(i, 2);
    end
    
    
    
    % number of lookups
    n = 10000;
    test_ips_index = randi(ip_c, 1, n); % can be searching for same ip multiple times
    test_ips = IP(test_ips_index);
    hit = zeros(1, n);
    miss = zeros(1, n);
    
    
    
    tic
    for i = 1:n
        itr = 0;
        test_ip = test_ips(i);
        %search_index = floor((mod(A*test_ip, 1)) * m ) + 1;
        search_index = ind_func(test_ip, itr, A, m);
    
        while cache_table(search_index, 1) ~= test_ip
            itr = itr + 1;
            search_index = ind_func(test_ip, itr, A, m);
            miss(1, i) = miss(1, i) + 1;
    
        end
        if cache_table(search_index, 1) == test_ip
            if miss(1, i) == 0
                hit(1, i) = hit(1, i) + 1;
            end
        else
            fprintf("sth else wrong\n")
        end
    
    
       % if cache_table(search_index) == IP(ind)  % then w found the correct one
    end
    total_time = toc;
    ave_time = total_time / n;
    
    collisions(sizes) = collisions_c;           %% <-- 這是新增的部分
    lookup_times(sizes) = ave_time;


    fprintf('Cache size: %d entries\n', m);
    fprintf('Number of lookups: %d\n', n);
    fprintf('Total time: %.6f seconds\n', total_time);
    fprintf('Average lookup time: %.6f seconds (%.2f microseconds)\n', ave_time, ave_time * 1e6);



end



figure;
subplot(2,1,1);
plot(table_sizes, collisions, '-o');
xlabel('Cache table Size');
ylabel('total collisions');
title('Collision vs Cache table size');


subplot(2,1,2);
plot(table_sizes, lookup_times * 1e6, '-o');
xlabel('cache table Size');
ylabel('average lookup time(us)');
title('lookup time vs cache table size');





