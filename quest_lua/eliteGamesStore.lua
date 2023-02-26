module(..., package.seeall);
print("eliteGamesStore 2.3"); -- royal heroes host

function new()
	local _store = display.newGroup();
	local _items = {};
	local _items_list = {};
	local _items_array = {};
	local shop_debug = false;
	
	--show_msg('store_ini_begin.');
	local store = nil;
	if(options_shop_enabled)then
		if(optionsBuild == "amazon")then
			store = require("plugin.amazon.iap");
		elseif(optionsBuild == "android")then
			store = require("plugin.google.iap.billing.v2");
		elseif(optionsBuild ~= "ouya")then
			store = require("store");
		end
	end
	--show_msg('store_ini_ended.');
	
	local environment = system.getInfo("environment");
	
	_store.CONST_SHOP_APPLE = 'apple';
	_store.CONST_SHOP_GOOGLE = 'google';
	_store.CONST_SHOP_AMAZON = 'amazon';
	_store.CONST_SHOP_OUYA = 'ouya';
	_store.CONST_SHOP_XIAOMI = "xiaomi";
	
	local _store_items = {}
	--_store_items[_store.CONST_SHOP_APPLE] = {};
	--_store_items[_store.CONST_SHOP_GOOGLE] = {};
	--_store_items[_store.CONST_SHOP_AMAZON] = {};
	--_store_items[_store.CONST_SHOP_OUYA] = {};
	--_store_items[_store.CONST_SHOP_XIAOMI] = {};
	
	local currentStore = nil;
	local buyHandler = nil;
	local afterBuyHandler = nil;
	
	function _store:setDebug()
		shop_debug = true;
		environment = "simulator";
		_store:setShop(_store.CONST_SHOP_GOOGLE);
	end
	
	function _store:restore()
		if(store.restore)then
			store.restore();
		end
	end
	
	function _store:getItem(item_id)
		return _items[item_id]
	end
	
	function _store:addItem(item_id, item_obj)
		table.insert(_items_array , item_id);
		table.insert(_items_list, item_obj);
		--print("_store:addItem:",item_id,item_obj);
		item_obj['item_id'] = item_id;
		if(item_obj.cost == nil)then
			item_obj.cost = "$0.99";
		end
		_items[item_id] = item_obj;
	end
	
	function _store:addItemShopId(item_id, shop_id, shop_item_id)
		--print("_store:addItemShopId:",item_id,shop_id,shop_item_id);
		local item_obj = _items[item_id];
		item_obj[shop_id] = shop_item_id;
		if(_store_items[shop_id]==nil)then _store_items[shop_id]={}; end
		_store_items[shop_id][shop_item_id] = item_id;
	end
	
	function _store:getItemShopObj(item_id)
		local item_obj = _items[item_id];
		if(item_obj and currentStore)then
			return item_obj[currentStore];
		end
	end
	
	function ouyaOnSuccess(json_str)
		--show_msg("OUYA Store Success.");
		--show_msg("OUYA Store Success:"..json_str);

		--globals.txtStatus.text = "onSuccessRequestPurchase";
		if json_str == nil then
			--print("onSuccessRequestPurchase: (nil)");
			show_msg("onSuccessRequestPurchase: (nil)");
		elseif json_str == "" then
			--print("onSuccessRequestPurchase: (empty)");
			show_msg("onSuccessRequestPurchase: (empty)");
		else
			--print("onSuccessRequestPurchase: jsonData=" .. json_str);
			--show_msg("onSuccessRequestPurchase: jsonData=" .. json_str);
			local purchase_obj = Json.Decode(json_str);
			_store:buyHandlerCall(purchase_obj.identifier);
			_store:backToGame(purchase_obj.identifier);
		end
	end

	function ouyaOnFailure(errorCode, errorMessage)
		show_msg("OUYA Failure: "..tostring(errorCode)..", "..tostring(errorMessage));
		--globals.txtStatus.text = "onFailureRequestPurchase";
		if errorCode == nil then
			show_msg("onFailureRequestPurchase: errorCode=(nil)");
		else
			show_msg("onFailureRequestPurchase: errorCode=" .. errorCode);
		end
			
		if errorMessage == nil then
			show_msg("onFailureRequestPurchase: errorMessage=(nil)");
		else
			show_msg("onFailureRequestPurchase: errorMessage=" .. errorMessage);
		end
		
		if(afterBuyHandler)then
			afterBuyHandler();
		end
		if(loaderClose)then
			loaderClose();
		end
	end

	function ouyaOnCancel()
		if(afterBuyHandler)then
			afterBuyHandler();
		end
		if(loaderClose)then
			loaderClose();
		end
	end

	_store.started_buy_id = nil;
	function _store:buyItem(item_id,callback)
		print("_store:buyItem:", item_id, callback);

		if(currentStore == nil)then
			show_msg('NO STORE SELECTED!')
			_store:setAutoShop();
			--return
		end
		if(store)then
			if(store.canMakePurchases)then
				if(store.canMakePurchases == false)then
					show_msg('canMakePurchases:'..tostring(store.canMakePurchases));
					options_shop_enabled = false;
					return
				end
			end
		end
		afterBuyHandler = callback;
		local item_obj = _items[item_id];
		local buy_id = item_obj[currentStore];
		_store.started_buy_id = buy_id;
		-- show_msg('attempt:'..tostring(buy_id)..','..tostring(currentStore)..','..tostring(item_id));
		--print('attempt:'..tostring(buy_id)..','..tostring(currentStore)..','..tostring(item_id));
		if(show_loading)then
			show_loading(30000);
		end
		if(environment == "device" )then
			--show_msg("_currentStore:"..currentStore..", id:"..buy_id);
			if((currentStore==_store.CONST_SHOP_XIAOMI or currentStore==_store.CONST_SHOP_OUYA) and plugin_ouya)then
				plugin_ouya.asyncLuaOuyaRequestPurchase(ouyaOnSuccess, ouyaOnFailure, ouyaOnCancel, buy_id);
			elseif(currentStore==_store.CONST_SHOP_AMAZON or currentStore == _store.CONST_SHOP_GOOGLE)then
				store.purchase(buy_id);
			else
				store.purchase({buy_id});
			end
		else
			if(shop_debug)then
				timer.performWithDelay(1500, function(e)
					_store:buyHandlerCall(buy_id);
					_store:backToGame(buy_id);
					--local testJson = {identifier=buy_id};
					--local testStr = Json.Encode(testJson);
					--ouyaOnSuccess(testStr);
					--ouyaOnFailure('404', 'testError');
					--ouyaOnCancel();
				end)
				
			end
		end
	end
	
	function _store:buyHandlerSet(val)
		buyHandler = val;
	end
	function _store:backToGame(shop_item_id)
		if(afterBuyHandler and shop_item_id)then
			local item_id = _store_items[currentStore][shop_item_id];
			local item_obj = _items[item_id];
			afterBuyHandler(item_id);
		end
		if(loaderClose)then
			loaderClose();
		end
	end
	function _store:buyHandlerCall(shop_item_id)
		--show_msg("__store:buyHandlerCall:"..shop_item_id);
		local item_id = _store_items[currentStore][shop_item_id];
		-- local item_obj = _items[item_id];
		buyHandler(item_id);
	end
	
	function _store:getAllItems()
		return _items_list;
	end
	
	
	function storeInitHandler(event)
		local transaction = event.transaction;
		-- show_msg('callback:'..tostring(transaction.state));
		local buy_id;
        if (transaction.state == "purchased" or transaction.state == "restored") then
            -- print("Transaction succuessful!")
            -- print("productIdentifier", transaction.productIdentifier)
            -- print("receipt", transaction.receipt)
            -- print("transactionIdentifier", transaction.identifier)
            -- print("date", transaction.date)
				
			buy_id = transaction.productIdentifier;
			_store:buyHandlerCall(buy_id);
			
			--show_msg('purchased:'..tostring(buy_id));
			local item_id = _store_items[currentStore][buy_id];
			local item_obj = _items[item_id];
			if(item_obj.consumable==true or item_obj.consumable==nil)then
				if(store.consumePurchase and currentStore == _store.CONST_SHOP_GOOGLE)then 
					store.consumePurchase({transaction.productIdentifier}, function(e)
						show_msg('consumed:'..tostring(buy_id));
					end);
				end;
			end
		elseif  transaction.state == "refunded" then
			print("Transaction refunded (from previous session)");
			show_msg("Transaction refunded (from previous session)");
		elseif ( transaction.state == "consumed" ) then
			print( "Transaction consumed!" )
			print( "product identifier", transaction.productIdentifier )
			print( "receipt", transaction.receipt )
			print( "transaction identifier", transaction.identifier )
			print( "date", transaction.date )
			print( "original receipt", transaction.originalReceipt )
			print( "original transaction identifier", transaction.originalIdentifier )
			print( "original date", transaction.originalDate )
			return
        elseif transaction.state == "cancelled" then
			print("User cancelled transaction")
			show_msg("User cancelled transaction");
        elseif transaction.state == "failed" then
			print("Transaction failed, type:", transaction.errorType, transaction.errorString);
			show_msg("error:"..tostring(transaction.errorType).."|"..tostring(transaction.errorString));
			-- error:7 unable to buy item (response:7 item already owned). 
			if(tostring(transaction.errorType) == '7')then
				buy_id = transaction.productIdentifier or _store.started_buy_id;
				show_msg('handling:'..tostring(transaction.errorType).."|"..tostring(buy_id));
				_store:buyHandlerCall(buy_id);
			end
		elseif transaction.state == "initialized" then
			
        else
			print("unknown event", transaction.state);
			-- show_msg("unknown store state:"..tostring(transaction.state))
        end
		
		if(store.finishTransaction)then store.finishTransaction( transaction ); end;
		_store:backToGame(buy_id);
	end
	if(store)then
		store.init(storeInitHandler);
	end
	
	function storeLoadHandler(event)
		print("showing valid products", #event.products)
		for i=1, #event.products do
			print(event.products[i].title)    -- This is a string.
			print(event.products[i].description)    -- This is a string.
			print(event.products[i].price)    -- This is a number.
			print(event.products[i].localizedPrice)    -- This is a string.
			print(event.products[i].productIdentifier)    -- This is a string.
			local shop_item_id = event.products[i].productIdentifier;
			local item_id = _store_items[currentStore][shop_item_id];
			local item_obj = _items[item_id];
		end
	 
		print("showing invalidProducts", #event.invalidProducts)
		for i=1, #event.invalidProducts do
			print(event.invalidProducts[i]);
		end
	end
	
	function getListOfProducts(store_id)
		local list = {};
		for i=1,#_items_array do
			local item_id = _items_array[i];
			local item_obj = _items[item_id];
			table.insert(list,item_obj[store_id]);
		end
		return list;
	end
	
	function _store:getCurrentStoreId()
		return currentStore;
	end
	
	function _store:setShop(shop_id)
		currentStore = shop_id;
		local listOfProducts = getListOfProducts(currentStore);
		if(currentStore == _store.CONST_SHOP_APPLE)then
			store.loadProducts( listOfProducts, storeLoadHandler );
		--elseif(currentStore == _store.CONST_SHOP_AMAZON)then
		--	if store.canLoadProducts == true then 
		--		store.loadProducts(listOfProducts, storeLoadHandler) 
		--	end 
		end
		if((currentStore==_store.CONST_SHOP_OUYA or currentStore==_store.CONST_SHOP_XIAOMI) and _G.plugin_ouya)then
            local jsonData = Json.Encode(listOfProducts);
			--show_msg('OUYA setShop:'..jsonData);
			if(_G.plugin_ouya.asyncLuaOuyaRequestProducts)then
			_G.plugin_ouya.asyncLuaOuyaRequestProducts(function(JsonStr)
				
				
					if JsonStr == nil then
						--show_msg("onSuccessRequestProducts: (nil)");
					elseif JsonStr == "" then
						--show_msg("onSuccessRequestProducts: (empty)");
					else
						--show_msg("onSuccessRequestProducts: jsonData=" .. JsonStr);
						local json_obj = Json.Decode(JsonStr);
						for i=1, #json_obj do
							local j_obj = json_obj[i];
							--show_msg(tostring(i)..','..tostring(j_obj['name'])..','..tostring(j_obj['identifier'])..','..tostring(j_obj['currencyCode'])..','..tostring(j_obj['localPrice']));
							local item_id = _store_items[currentStore][j_obj['identifier']];
							if(item_id and tostring(j_obj['localPrice'])~="1")then
								local item_obj = _items[item_id];
								item_obj['cost'] = tostring(j_obj['localPrice']).." "..tostring(j_obj['currencyCode']);
							end
						end
					end
				end, ouyaOnFailure, ouyaOnCancel, jsonData);
			end
		end
	end
	function _store:setAutoShop()
		print("_environment:", environment);
		if(environment == "simulator" )then
			shop_debug = true;
			_store:setShop(_store.CONST_SHOP_GOOGLE);
			return true
		end
		if(optionsBuild == "amazon" and options_shop_enabled)then
			_store:setShop(_store.CONST_SHOP_AMAZON);
			return true
		elseif (optionsBuild==_store.CONST_SHOP_XIAOMI and options_shop_enabled) then
			_store:setShop(_store.CONST_SHOP_XIAOMI);
			return true
		elseif (optionsBuild==_store.CONST_SHOP_OUYA and options_shop_enabled) then
			_store:setShop(_store.CONST_SHOP_OUYA);
			return true
		elseif (optionsBuild=="android") then
			_store:setShop(_store.CONST_SHOP_GOOGLE);
			return true
		elseif(store)then
			if(store.availableStores)then
				if store.availableStores.apple then
					_store:setShop(_store.CONST_SHOP_APPLE);
				end
				return true
			end
		end
		_G.options_shop_enabled = false;
	end
	
	return _store
end