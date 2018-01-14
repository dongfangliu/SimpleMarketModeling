classdef shop < handle
    %SHOP 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        cost;
        profit;
        newestPrice;
        currentReport;
        currentStrategy;
        customersVsStrategies;
        maxProfitVsStrategies;
        minProfitVsStrategies;
        totalProfitVsStrategies;
        shopId;
        profitToday;
        customerToday;
    end
    
    methods
        function obj = shop(id,c)
            obj.shopId = id;
            obj.cost = c;
            obj.customersVsStrategies = randi([10 20],1,12);
            obj.totalProfitVsStrategies = zeros(1,12);
            obj.maxProfitVsStrategies = zeros(1,12);
            obj.minProfitVsStrategies = zeros(1,12)*Inf;
            obj.newestPrice = 0;
            obj.currentReport = report.empty();
            obj.profit = 0; obj.profitToday = 0;obj.customerToday = 0;
            obj.currentStrategy= strategy.truth;
        end
        function makeChoice(obj)
            p=(obj.newestPrice - obj.cost)/12;
            profit_vec = zeros(1,12);
            for i = 1:12
                profit_vec(1,i) = (i-1)*p;
            end
            buy_rate = obj.customersVsStrategies./sum(obj.customersVsStrategies);
            decision = buy_rate.*profit_vec;  a = find(decision==max(decision));
            if isempty(a)
                obj.currentStrategy = strategy.truth;
            else
                obj.currentStrategy = a(1);
            end
            p = profit_vec(obj.currentStrategy);
            obj.currentReport = report(obj.cost+p(1),obj.shopId);
        end
        function acceptInfo(obj,price)
            obj.newestPrice = price;
        end
        function CustomerIn(obj)
            p=obj.currentReport.mprice-obj.cost;
            obj.profit = obj.profit+ p;
            obj.customerToday = obj.customerToday+1;
            obj.totalProfitVsStrategies(1,obj.currentStrategy) = obj.totalProfitVsStrategies(1,obj.currentStrategy)+p;
            obj.profitToday = obj.profitToday+p;
        end
        function analysisData(obj)
            obj.customersVsStrategies(1,obj.currentStrategy) = obj.customerToday;
            obj.maxProfitVsStrategies(1,obj.currentStrategy) = max(obj.maxProfitVsStrategies(1,obj.currentStrategy),obj.profitToday);
            obj.minProfitVsStrategies(1,obj.currentStrategy) = min(obj.minProfitVsStrategies(1,obj.currentStrategy),obj.profitToday);
            obj.profitToday = 0 ;obj.customerToday =  0 ;
        end
    end
    
end

