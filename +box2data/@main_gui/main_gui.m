classdef main_gui < handle
    %
    %   Class:
    %   box2data.main_gui

    %{
    
    %}

    properties
        image_path
        save_path
        n_draws = 1
        
        n_boxes
        box_labels

        h_axes
        h_boxes = []
        h_whiskers = []
        h_outliers = []
        h_calibrations = []
        h_medians = []

        %struct
        %.extracted_data
        %.calibrations 
        %%TODO: How do we get numbers for the calibrations???
        finished_draws
    end

    methods
        function obj = main_gui(image_path)

            %Steps
            %-----
            %1) specify how many boxes?
            %   - button for new box
            %   - button for whiskers
            %   - button for calibration
            %   - button for being done
            %   - button for
            %2) after done processing
            %   - compute numbers
            %   -

            obj.image_path = image_path;

            %TODO: Turn off targeting
            h_fig = figure(1);
            h_fig.Units = 'normalized';

            fh = @(p,s) uicontrol(h_fig,'Style','pushbutton','Units','normalized','Position',p,'String',s);

            %h1 = uicontrol(h_fig,'Style','pushbutton','Units','normalized','Position',[0.05 0.90 0.1 0.05],'String','Box');
            %h2 = uicontrol(h_fig,'Style','pushbutton','Units','normalized','Position',[0.20 0.90 0.1 0.05],'String','Whisker');
            %h3 = uicontrol(h_fig,'Style','pushbutton','Units','normalized','Position',[0.35 0.90 0.1 0.05],'String','Median');
            %h4 = uicontrol(h_fig,'Style','pushbutton','Units','normalized','Position',[0.50 0.90 0.1 0.05],'String','Outlier');

            h1 = fh([0.05 0.90 0.1 0.05],'Box');
            h1.Callback = @(~,~) obj.cb_button('box');
            h2 = fh([0.20 0.90 0.1 0.05],'Whisker');
            h2.Callback = @(~,~) obj.cb_button('whisker');
            h3 = fh([0.35 0.90 0.1 0.05],'median');
            h3.Callback = @(~,~) obj.cb_button('median');
            h4 = fh([0.50 0.90 0.1 0.05],'outlier');
            h4.Callback = @(~,~) obj.cb_button('outlier');
            %TODO: calibrations
            h6 = fh([0.65 0.90 0.1 0.05],'done');
            h6.Callback = @(~,~) obj.done();


            h_axes = axes('Parent',h_fig,'Units','normalized','Position',[0.025 0.025 0.95 0.85]);
            h_axes.XTick = [];
            h_axes.YTick = [];
            obj.h_axes = h_axes;


            %Try and load previous work from disk ...
            [file_root,file_name] = fileparts(image_path);

            obj.save_path = fullfile(file_root,[file_name '.mat']);


            %if no exist, 


            image_data = imread(image_path);
            imshow(image_data)
        end
        function cb_button(obj,type)
            switch type
                case 'box'
                    h = drawrectangle(obj.h_axes);
                    obj.h_boxes = [obj.h_boxes h];
                case 'whisker'
                    h = drawline(obj.h_axes);
                    obj.h_whiskers = [obj.h_whiskers h];
                case 'median'
                    h = drawline(obj.h_axes);
                    obj.h_medians = [obj.h_medians h];
                case 'outlier'
                    h = drawpoint(obj.h_axes);
                    obj.h_outliers = [obj.h_outliers h];
                case 'calibration'
                    h = drawline(obj.h_axes);
                    obj.h_calibrations = [obj.h_calibrations h];

            end
            obj.save();
        end

        function save(obj)
            %             h_boxes = []
            %             h_whiskers = []
            %             h_outliers = []
            %             h_calibrations = []
            %             h_medians = []

            s = struct;

            %Save color


            keyboard

            %Box 1 x 4 (left,bottom,width,height)
            %Line 2 x 2 (x,y; x,y)
            %Point 1 x 2
            if ~isempty(obj.h_boxes)
                h = obj.h_boxes;
                s.boxes = cat(1,h.Position);
            else
                s.boxes = [];
            end

            if ~isempty(obj.h_whiskers)
                h = obj.h_whiskers;
                s.whiskers = cat(3,h.Position);
            else
                s.whiskers = [];
            end

            if ~isempty(obj.h_outliers)
                h = obj.h_outliers;
                s.outliers = cat(1,h.Position);
            else
                s.outliers = [];
            end

            if ~isempty(obj.h_calibrations)
                h = obj.h_calibrations;
                s.calibrations = cat(3,h.Position);
            else
                s.calibrations = [];
            end

            if ~isempty(obj.h_medians)
                h = obj.h_medians;
                s.medians = cat(3,h.Position);
            else
                s.medians = [];
            end


            s.n_draws = obj.n_draws;



            keyboard
        end
        function drawingsToValues(obj)
            outliers = arrayfun(@(x) x.Position(1),obj.h_outliers);

            n_boxes = length(obj.h_boxes);
            xc_all = zeros(1,n_boxes);
            all_objs = cell(1,n_boxes);
            for i = 1:n_boxes
                h_box = obj.h_boxes(i);
                p = h_box.Position;
                xc = p(1) + 0.5*p(3);
                xc_all(i) = xc;
                q1 = p(2);
                q3 = p(2) + p(4);

                whiskers = h_getY(obj.h_whiskers,xc);

                median = h_getY(obj.h_medians,xc);

                %TODO: Outliers


                d = box2data.extracted_data(xc,q1,q3,median,whiskers);
                all_objs{i} = d;

            end

            n_outliers = length(outliers);
            outlier_id = zeros(1,n_outliers);
            for i = 1:n_outliers
                [~,I] = min(abs(outliers(i) - xc_all));
                outlier_id(i) = I;
            end

            %Extract calibrations
            %------------------
            calibrations = h_getY(obj.h_calibrations);
        end
        function done(obj)







            keyboard
        end
    end
end

function y = h_getY(h_all,pc)
y = [];
for i = 1:length(h_all)
    h = h_all(i);
    p = h.Position;
    p1 = p(1,1);
    p2 = p(2,1);
    if pc > p1 && pc < p2
        y = [y mean(p(:,2))];
    end
end
end

