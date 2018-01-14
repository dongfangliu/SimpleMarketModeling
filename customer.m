classdef customer<handle
    properties
        id;
        distrust_constant; % ����ƭ�����ζȽ��͵ĳ̶�
        trustnessOfShops;
        truePriceYesterday;
        reportsFromShops;
        shopLastChosen;
        self_priority; % 1��2x1��Ȩ�أ������˶��ڼ۸����ζȵ�ƫ�򣬸����Ǽ۸��Ǹ��������ζ�
    end
    
    methods
        function obj = customer(id,shopNum)
            obj.id = id;
            obj.distrust_constant = randi([40 50]);
            obj.truePriceYesterday = -1;
            obj.shopLastChosen = -1;
            obj.reportsFromShops = report.empty(shopNum,0);
            obj.trustnessOfShops = randi([55 80],shopNum,1);
            obj.self_priority = zeros(2,1);
            obj.self_priority(1) =rand();obj.self_priority(2) = 1 - obj.self_priority(1);
        end
        function shopId= chooseShop(obj)
            mini = min(obj.reportsFromShops);
            priceConcern = (1-(obj.reportsFromShops-mini)./mini).*100;
            selection = obj.self_priority(1).*obj.trustnessOfShops+obj.self_priority(2).*priceConcern;
            shopId = find(selection == max(selection));
            obj.shopLastChosen = shopId;
        end
        function adjustTrustness(obj,priceYesterDay)
            priceLastBuy = obj.reportsFromShops(obj.shopLastChosen,1);
            obj.trustnessOfShops(obj.shopLastChosen,1)=obj.trustnessOfShops(obj.shopLastChosen,1)-(priceLastBuy-priceYesterDay)*obj.distrust_constant/priceYesterDay;
        end
        function acceptInfo(obj,priceYesterDay)
            obj.adjustTrustness(priceYesterDay);
        end
    end
    
end

