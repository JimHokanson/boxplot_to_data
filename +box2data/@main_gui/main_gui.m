classdef main_gui < handle
    %
    %   Class:
    %   box2data.main_gui
    
    %{
    
    %}
    
    properties
        
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
            
            h_fig = figure(1);
            h_fig.Units = 'normalized';
            h1 = uicontrol(h_fig,'Style','pushbutton','Units','normalized','Position',[0.05 0.90 0.1 0.05],'String','Box');
            h2 = uicontrol(h_fig,'Style','pushbutton','Units','normalized','Position',[0.20 0.90 0.1 0.05],'String','Whisker');
            h3 = uicontrol(h_fig,'Style','pushbutton','Units','normalized','Position',[0.35 0.90 0.1 0.05],'String','Outlier');
            
            h_axes = axes('Parent',h_fig,'Units','normalized','Position',[0.025 0.025 0.95 0.85]);
            
            keyboard
            
        end
    end
end

