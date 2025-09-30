clear all; close all;
IP = randperm(2^32, 1000) - 1; %total 2^32 combinations, I take 10000 of them 
MAC = randperm(2^48, 1000) - 1;%total 2^48 combinations, I take 10000 of them 



data_set = [IP(:), MAC(:)];
A = 0.61;
n = 2000;

iteration = 50;
m = 2000;
m_dh = 2009;
ave_t_arry_ls = zeros(iteration, 1);
ave_t_arry_bs = zeros(iteration, 1);
ave_t_arry_hlp = zeros(iteration, 1);
ave_t_arry_dh = zeros(iteration, 1);





% use a for loop here because each run the variation of time is different,
% so take average
for i = 1:iteration
    
    [cache_table, building_cache_time, ave_b_c_time, total_lookup_time, ave_time1, MACs]=linear_search(n, data_set);
    ave_t_arry_ls(i) = ave_time1 * 1000000; 
    [cache_table, building_cache_time, ave_b_c_time, total_lookup_time, ave_time2, MACs] = binary_search(n, data_set);
    ave_t_arry_bs(i) = ave_time2 * 1000000;
    [cache_table, building_cache_time, ave_b_c_time, total_time, ave_time3, MACs] = hash_with_linear_probing(n, data_set, m, A);
    ave_t_arry_hlp(i) = ave_time3 * 1000000;
    [cache_table, building_cache_time, ave_b_c_time, total_time, ave_time4, MACs] = double_hashing(n, data_set, m_dh, A);
    ave_t_arry_dh(i) = ave_time4 * 1000000;
 
end

mean_arr_ls = mean(ave_t_arry_ls);
mean_arr_bs = mean(ave_t_arry_bs);
mean_arr_hlp = mean(ave_t_arry_hlp);
mean_arr_dh = mean(ave_t_arry_dh);




figure;
histogram(ave_t_arry_ls,'Normalization','pdf')
hold on;
histogram(ave_t_arry_bs, 'Normalization', 'pdf');
histogram(ave_t_arry_hlp, 'Normalization', 'pdf');
histogram(ave_t_arry_dh, 'Normalization', 'pdf');
legend(sprintf("Linear; mean: %.3fus", mean_arr_ls), sprintf("Binary; mean: %.3fus", mean_arr_bs), sprintf("Hash Linear; mean: %.3fus", mean_arr_hlp), sprintf("double hash; mean: %.3fus", mean_arr_dh));
xlabel('Average Lookup Time (us)');
ylabel('Probability Density');
title('Distribution of Lookup Times(2000) and cache size=2000');
grid on;


