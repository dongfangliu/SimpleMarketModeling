classdef report < handle
    %REPORT �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
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

