% 专门用于绘制有残缺的数据的图示的函数
%  输入：
%      x:数据
%      t:每个数据对应的时间
%      dt:时间坐标轴分辨率（即连续不残缺的两个数据之间的时间间隔大小）
function myplot(x, t, dt)
    lenc = length(x);
    
    figure();
    hold on;

    plot_s = 1;
    plot_e = plot_s;
    t_pre = t(1);
    for k = 2 : lenc
        diff = t(k) - t_pre - dt;
        if (diff > -1e-6) && (diff < 1e-6) % 数据没有残缺
            plot_e = plot_e + 1;
            t_pre = t(k);
        else % 数据有残缺，将完整的部分先plot
            plot(t(plot_s:plot_e), x(plot_s:plot_e), 'b');
            plot_s = k;
            plot_e = plot_s;
            t_pre = t(k);
        end
    end
    hold off;
end