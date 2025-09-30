
clear all; close all;

% Since IP and MAC has to be unique, I used randperm instead of randi
IP = randperm(2^32, 1000) - 1; %total 2^32 combinations, I take 1000 of them 
MAC = randperm(2^48, 1000) - 1;%total 2^48 combinations, I take 1000 of them 

IP_MAC = [IP(:), MAC(:)]; % This is the original list of IPs and their corresponding MAC addresses, not sorted


% build a cache table
[sorted_IPs, sorted_index] = sort(IP);
sorted_MAC = MAC(sorted_index);
IP_MAC_sorted = [sorted_IPs(:), sorted_MAC(:)];



% binary search
function index = binary_search(ips, target)
    left = 1;
    right = size(ips, 2);
    while (left <= right)
        mid = floor((right + left) / 2);
        if ips(mid) == target
            index = mid;
            break
        elseif ips(mid) < target
            left = mid + 1;
        else
            right = mid - 1;
        end
    end
end

%583863179

% number of lookups
n = 1000;
test_ips_index = randi(size(IP_MAC_sorted, 1), 1, n); % can be searching for same ip multiple times
test_ips = IP(test_ips_index);
success = 0;
index = 0;
tic
for i = 1:n
    test_ip = test_ips(i);
    index = binary_search(sorted_IPs, test_ip);
    if sorted_IPs(index) == test_ip
        success = success + 1;
    end

end
total_time = toc












