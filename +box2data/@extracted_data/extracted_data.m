classdef extracted_data < handle
    %
    %   Class:
    %   box2data.extracted_data

    properties
        xc
        q1
        q3
        median
        whisk_low
        whisk_high
        outliers
    end

    methods (Static)
        function obj = fromDisk(s)
            %
            %   obj = box2data.extracted_data.fromDisk(s)

            keyboard

        end
    end

    methods
        function obj = extracted_data(xc,q1,q3,median,whiskers)
            obj.xc = xc;
            obj.q1 = q1;
            obj.q3 = q3;
            obj.median = median;

            I = find(whiskers > median);
            if ~isempty(I)
                obj.whisk_high = whiskers(I);
            end

            I = find(whiskers < median);
            if ~isempty(I)
                obj.whisk_low = whiskers(I);
            end
        end
        function s = getStruct(obj)
            s = struct();
            s.xc = obj.xc;
            s.q1 = obj.q1;
            s.q3 = obj.q3;
            s.median = obj.median;
            s.whisk_high = obj.whisk_high;
            s.whisk_low = obj.whisk_low;
        end
    end
end