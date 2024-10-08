function [Y, dispatch_times_new2] = mutation(P, t, dispatch_times)
    % P = Population
    % dispatch_times = Matrix of dispatch times corresponding to the chromosomes

    [x1, y1] = size(P); % Population size (x1) and chromosome length (y1)
    
    % 隨機選擇一個染色體
    r1 = randi(x1); % 隨機選擇族群內的索引
    A1 = P(r1, 1:y1); % 取出選中的染色體 (派遣順序)
    dispatch_times1 = dispatch_times(r1, :); % 取出對應的派遣時間

    % 定義派遣順序的突變位置（無奇數位置限制）
    pos = randperm(y1, 2); % 隨機選擇兩個不同的位置
    % 交換所選位置的值（調整派遣順序）
    A1([pos(1), pos(2)]) = A1([pos(2), pos(1)]);

    % 同時對派遣時間進行突變
    if t >= 2
        pos_dispatch = randperm(t, 2); % 隨機選擇兩個不同的位置
        dispatch_times1([pos_dispatch(1), pos_dispatch(2)]) = dispatch_times1([pos_dispatch(2), pos_dispatch(1)]); 
    end

    % 返回新的突變後的染色體和派遣時間
    Y = A1; % 返回突變後的染色體
    dispatch_times_new2 = dispatch_times1; % 返回突變後的派遣時間

end
