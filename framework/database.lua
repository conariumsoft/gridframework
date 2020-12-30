local http = game:GetService("HttpService");
local dataservice = game:GetService("DataStoreService")

local queue = require(game.ReplicatedFirst.framework.stdlibx.queue);

local database = {}

local cached_stores = {}


function database.get_store(store: string) : GlobalDataStore
    if cached_stores[store] then return cached_stores[store] end

    local result = dataservice:GetDataStore(store);
    cached_stores[store] = result;
    return result;
end
function database.get_store_ordered(store: string) : GlobalDataStore
    if cached_stores[store] then return cached_stores[store] end

    local result = dataservice:GetOrderedDataStore(store);
    cached_stores[store] = result;
    return result;
end


local function eval_type_any(data, ...)
    local types = {...}
    for _, v in pairs(types) do
        if typeof(data) == v then return true, v end
    end
    return false;
end

local schema = {
    {
        Key = "...",
        ValidTypes = {}, 
        Default = 0,

    },

}

type write_request = {
    datastore : string,
    key : string,
    data : {},
}

local storage_queue: queue.q<write_request> = queue.new();



function database.enqueue_save_async(storage, key, data)


end
function database.is_finished_saving() return storage_queue:count() == 0 end


return database;