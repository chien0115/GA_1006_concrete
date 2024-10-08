function repaired_chromosome = repair(chromosome, demand_trips)
    % 計算每個工地的次數
    site_counts = histcounts(chromosome, 1:max(max(chromosome), length(demand_trips))+1); % 確保 histogram 的長度至少等於 demand_trips 的長度
    
    % 如果 site_counts 的長度小於 demand_trips 的長度，則補充 0 值
    if length(site_counts) < length(demand_trips)
        site_counts(length(demand_trips)) = 0;
    end
    
    % 印出 site_counts 和 demand_trips 以檢查它們的內容
    disp('Site Counts:');
    disp(site_counts);
    disp('Demand Trips:');
    disp(demand_trips);
    
    % 檢查 site_counts 和 demand_trips 的大小是否一致
    if length(site_counts) ~= length(demand_trips)
        error('Site counts and demand trips size do not match. Please check chromosome or demand_trips input.');
    end

    % 逐個修復工地的需求次數
    for site = 1:length(demand_trips)
        % 計算工地分配的車次數與需求車次數的差值
        diff = site_counts(site) - demand_trips(site);
        
        % 如果超過需求次數
        while diff > 0
            % 隨機找到一個該工地的車次並替換為其他需求不足的工地
            idx = find(chromosome == site, 1);
            % 找到需求不足的工地
            under_demand_sites = find(site_counts < demand_trips);
            % 如果沒有需求不足的工地，則結束修復
            if isempty(under_demand_sites)
                break;
            end
            % 隨機選擇一個需求不足的工地
            new_site = under_demand_sites(randi(length(under_demand_sites)));
            chromosome(idx) = new_site;
            site_counts(new_site) = site_counts(new_site) + 1;
            site_counts(site) = site_counts(site) - 1;
            diff = diff - 1;
        end

        % 如果少於需求次數
        while diff < 0
            % 找到需求過多的工地並隨機替換掉其他工地
            over_demand_sites = find(site_counts > demand_trips);
            % 如果沒有需求過多的工地，則結束修復
            if isempty(over_demand_sites)
                break;
            end
            idx = randi(length(chromosome));
            new_site = over_demand_sites(randi(length(over_demand_sites)));
            chromosome(idx) = new_site;
            site_counts(new_site) = site_counts(new_site) + 1;
            site_counts(site) = site_counts(site) - 1;
            diff = diff + 1;
        end
    end

    % 確保在所有情況下返回修復後的染色體
    repaired_chromosome = chromosome;
end
