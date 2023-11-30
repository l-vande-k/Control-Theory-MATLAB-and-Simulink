clc; clear;
%% Go to Location
figure
i=1;
for kv_value = ["0.1", "0.5", "1"]
    for kh_value = ["0.1", "1", "4"]
        % the following line uses the for loop variables to write the file
        % name being loaded.
        file = "Lab07A_kv"+kv_value+"_kh"+kh_value+".mat";
        % this loads the file
        load(file);
        % assigns the data in the struct generated by simulink to a variable 
        % for easier accessibility
        coord = out.simout.Data(1:end,1:end);
        x = coord(:,1);
        y = coord(:,2);
        subplot(3,3,i)
        hold on
        plot(8, 5, '^','Color','#26CA15') % start point
        plot(x, y, 'b') % robot path
        plot(x(end), y(end), 's','Color','#DC3C09') % end point
        plot(5,5,'.k') % goal location
        % the following line writes the title name in a string
        PlotTitle = 'Kv = ' + kv_value + ' and Kh = ' + kh_value;
        ylabel("Y Position")
        xlabel("X Position")
        title(PlotTitle)
        i = i + 1;
    end
end

%% Follow a Line
load('KdKh.mat')
for Kd = [0.01, 0.1, 0.5]
    for Kh = [0.1, 0.5, 1]
        sim('Lab07B.slx')
        file_name = "Lab07B_kd"+num2str(Kd)+"_kh"+num2str(Kh)+".mat";
        save(file_name)
    end
end

figure
i = 1;
%plot(x,y, '.k', 'LineWidth', 1) % line to follow
for kd_value = ["0.01", "0.1", "0.5"]
    for kh_value = ["0.1", "0.5", "1"]
        file = "Lab07B_kd"+kd_value+"_kh"+kh_value+".mat";
        load(file);
        %coord = out.y.Data(1:end,1:end);
        coord = ans.y.Data(1:end,1:end); % to be used with automation for loop above
        x = coord(:,1);
        y = coord(:,2);
        %myPlots(i) = plot(x, y); % saves the plots in an array of plots
        subplot(3,3,i)
        hold on
        plot(coord(:,1), coord(:,2));
        plot(8, 5, '^','Color','#26CA15')
        plot(x(end), y(end), 's','Color','#DC3C09')
        x = -40:10;
        y = 0.5*x + 2;
        plot(x,y, ':r', 'LineWidth', 1) % line to follow
        myTitle = 'Kd = ' + kd_value + ' and Kh = ' + kh_value;
        title(myTitle)
        ylabel("Y Position")
        xlabel("X Position")
        % the following line writes the legend names as strings in a string
        % array indexed by our counter variable 'i'.
        %LegendName(i) = 'Kd = ' + kd_value + ' and Kh = ' + kh_value;
        i = i + 1;
    end
end
% the following line only creates legends according to the path plots
% created under the variable 'MyPlots'.
%legend(myPlots(1:9), LegendName, 'Location', 'northwest')
