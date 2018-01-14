classdef report < handle
    %REPORT 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        mprice;
        shopId;
    end
    
    methods
        function obj = report(myprice,shopId)
            obj.mprice = myprice;
            obj.shopId = shopId;
        end
    end
    
end

