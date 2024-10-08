function [YY1, YY2, best_dispatch_times] = selection(P, E, s, dispatch_times)


    % P = Population, F = fitness value, p = population size

    [x, y] = size(P); % 目前經歷過 crossover、mutation 的 P


    YY1 = zeros(s, y); %儲存良好的染色體
    YY2 = zeros(s, 1); % 良好的適應值
    best_dispatch_times = zeros(s, size(dispatch_times, 2)); % Store dispatch times

    e = round(s / 4); % Number of elite chromosomes to select
    

    M = max(E); % 當前族群的最大暫時適存值
    F = M - E; % 計算真實適存值：暫時適存值越小，真實適存值越大

    for i = 1:e % Select the top e chromosomes with the highest fitness values
        c1 = find(F == max(F)); % Find index of the best fitness value 找到適應值最好的位置 因儲存適應度的陣列是一維
        if length(c1) > 1
            c1 = c1(1); % 如果有多個最小值，選擇第一個
        end

        % Store selected chromosome, fitness value, and dispatch times
        YY1(i, :) = P(c1, :);
        YY2(i) = F(c1);
        best_dispatch_times(i, :) = dispatch_times(c1, :);

        % Remove selected chromosome from population
        P(c1, :) = [];
        F(c1) = [];
        dispatch_times(c1, :) = [];

        % 更新維度
        [x, y] = size(P);

        % 確保在選擇過程中不超出染色體數量
        if x == 0
            break;
        end
    end

    % Selection based on fitness probabilities
    D = F / sum(F); % Fitness proportionate selection
    CP = cumsum(D); % Cumulative probabilities
    N = rand(1); % Random number for selection

    d1 = 1;
    d2 = e; % Start from where we left off

    while d2 < s
        if N < CP(d1)
            % Select chromosome based on cumulative probability
            YY1(d2 + 1, :) = P(d1, :);
            YY2(d2 + 1) = F(d1);
            best_dispatch_times(d2 + 1, :) = dispatch_times(d1, :);

            % Generate a new random number and update counters
            N = rand(1);
            d2 = d2 + 1;
            d1 = 1;

            % 防止選擇超出範圍
            if d2 >= x
                break;
            end
        else
            d1 = d1 + 1;
        end
    end
end
