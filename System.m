classdef System <handle
    %SYSTEM 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        cost;
        minPrice;
        maxPrice;
        shopNum;
        userNum;
        shops;
        customers;
        shopsReports;
        priceYesterday;
        priceToday;
    end
    
    methods
        function obj = System(shopNum,userNum,cost,minp,maxp)
            obj.cost= cost;
            obj.minPrice=minp;
            obj.maxPrice = maxp;
            obj.shopNum = shopNum;
            obj.userNum = userNum;
            obj.shops = shop.empty();
            obj.customers = customer.empty();
            for i = 1:shopNum
                obj.shops(i,1) = shop(i,obj.cost);
            end
            for i = 1:userNum
                obj.customers(i,1) = customer(i,shopNum);
            end
            obj.shopsReports = report.empty();
            obj.priceYesterday = -1;
            obj.setNewestPrice();
            obj.informPrice_Shop();
        end
        function informPrice_Shop(obj)
            for i = 1:obj.shopNum
                obj.shops(i,1).acceptInfo(obj.priceToday);
            end
        end
        function informPrice_customer(obj)
            for i = 1 :obj.userNum
                obj.customers(i,1).acceptInfo(obj.priceYesterday);
            end
        end
        function setNewestPrice(obj)
            obj.priceToday = randi([obj.minPrice obj.maxPrice],1);
        end
        
        function  FetchAndDeliverReports(obj)
            prices = zeros(obj.shopNum,1);
            for i = 1 :obj.shopNum
                obj.shopsReports(i,1) = obj.shops(i,1).currentReport;
                prices(i,1) = obj.shopsReports.mprice;
            end
            for i = 1 : obj.userNum
                obj.customers(i,1).reportsFromShops = prices;
            end
        end
        
        function GameStart(obj,numOfDays)
            %Day 0
            obj.setNewestPrice();
            obj.informPrice_Shop();
            for i = 1 : obj.shopNum
                obj.shops(i,1).makeChoice;
            end
            obj.FetchAndDeliverReports();
            for i = 1 : obj.userNum
                shopId = obj.customers(i,1).chooseShop();
                obj.shops(shopId(1),1).CustomerIn();
            end
            
            % New Day
            for i = 1:numOfDays
                obj.priceYesterday = obj.priceToday;
                obj.setNewestPrice();
                obj.informPrice_customer();
                obj.informPrice_Shop();
                for j = 1 : obj.shopNum
                    obj.shops(j,1).makeChoice;
                end
                obj.FetchAndDeliverReports();
                for j = 1 : obj.userNum
                    shopId = obj.customers(j,1).chooseShop();
                    obj.shops(shopId(1),1).CustomerIn();
                end
                for j = 1 : obj.shopNum
                    obj.shops(j,1).analysisData();
                end
            end
        end
        function analysisData(obj)
            profits=zeros(1,obj.shopNum);
            for i = 1 :obj.shopNum
                profits(i) = obj.shops(i,1).profit;
                fprintf('shop %d  profit %d\n',i,profits(i));
            end
            index = find(profits == max(profits));
            fprintf('max profit shop : %d\n',index);
            obj.logShop(index);
        end
        function logShop(obj,index)
            shop  = obj.shops(index,1);
            fprintf('strategy that gains max profit : %s\n',strategy(find(shop.totalProfitVsStrategies==max(shop.totalProfitVsStrategies))));
            figure;
            bar(shop.customersVsStrategies);title('customersVsStrategies');xlabel('Strategies');ylabel('customers');
            figure;
            bar(shop.totalProfitVsStrategies);title('totalProfitVsStrategies');xlabel('Strategies');ylabel('totalProfit');
        end
    end
    
end

