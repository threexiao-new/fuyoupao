local function rotateVector(q, v)
    if q and v then
    local qx, qy, qz, qw = q.x, q.y, q.z, q.w
    local tx = 2 * (qy*v.z - qz*v.y)
    local ty = 2 * (qz*v.x - qx*v.z)
    local tz = 2 * (qx*v.y - qy*v.x)
    
    return {
        x = v.x + qw*tx + (qy*tz - qz*ty),
        y = v.y + qw*ty + (qz*tx - qx*tz),
        z = v.z + qw*tz + (qx*ty - qy*tx)
    }        
    end
end

worldScanner = peripheral.find("world_scanner")
local currentShipId = ship.getId()
-- 获取当前船体ID
local currentShipId = ship.getId()

-- 获取范围内的所有船体
local ships = coordinate.getShips(2500)

-- 创建一个表来存储船体信息
local shipMap = {}
for _, shipInfo in pairs(ships) do
    shipMap[shipInfo.id] = shipInfo
end

-- 判断两个船体是否直接相邻/连接
function areShipsConnected(shipA, shipB)
    -- 检查边界是否接触（相邻）
    -- 允许1格间距作为连接阈值
    local connectionThreshold = 3
    
    -- 在x轴上有重叠或接触
    local xOverlap = not (shipA.max_x < shipB.min_x - connectionThreshold or 
                         shipA.min_x > shipB.max_x + connectionThreshold)
    
    -- 在y轴上有重叠或接触
    local yOverlap = not (shipA.max_y < shipB.min_y - connectionThreshold or 
                         shipA.min_y > shipB.max_y + connectionThreshold)
    
    -- 在z轴上有重叠或接触
    local zOverlap = not (shipA.max_z < shipB.min_z - connectionThreshold or 
                         shipA.min_z > shipB.max_z + connectionThreshold)
    
    -- 如果船体在三个轴上都相邻或重叠，则认为它们连接
    return xOverlap and yOverlap and zOverlap
end

-- 构建连接图
local adjacencyList = {}
for idA, shipA in pairs(shipMap) do
    adjacencyList[idA] = {}
    for idB, shipB in pairs(shipMap) do
        if idA ~= idB and areShipsConnected(shipA, shipB) then
            adjacencyList[idA][idB] = true
        end
    end
end

-- 使用BFS查找所有直接和间接连接的船体
function findAllConnectedShips(startId)
    local visited = {}
    local queue = {startId}
    local connectedShips = {}
    
    visited[startId] = true
    
    while #queue > 0 do
        local currentId = table.remove(queue, 1)
        table.insert(connectedShips, currentId)
        
        -- 检查所有相邻的船体
        for neighborId, _ in pairs(adjacencyList[currentId] or {}) do
            if not visited[neighborId] then
                visited[neighborId] = true
                table.insert(queue, neighborId)
            end
        end
    end
    
    return connectedShips
end

-- 检查船体5是否与当前船体连接（直接或间接）
function isShip5ConnectedToCurrent(id)
    
    -- 获取当前船体所有直接和间接连接的船体
    
    
    -- 检查船体5是否在连接列表中
    for _, shipId in ipairs(connectedShips) do
        if shipId == id then
            return true
        end
    end
    
    return false
end

-- 主程序

connectedShips = findAllConnectedShips(currentShipId)


vector = {x = 1,y = 0,z = 0}
while true do
    if redstone.getAnalogInput("front") > 0 then
        q = ship.getQuaternion()
        pos = ship.getWorldspacePosition()
        xl = rotateVector(q,vector)--particle light_sword:orange ~ ~1 ~particle light_sword:orangeppppppppp ~ ~1 ~ 0 0 0 0 0 forceparticle light_sword:lightswordwhit ~ ~1 ~ 0 0 0 0 0 forceparticle light_sword:penshhewhite ~ ~1 ~ 0 0 0 0 0 force
        for i = 0, 15, 0.05 do
            commands.execAsync(string.format("particle light_sword:orangeppppppppp ~%.5f ~ ~ 0 0 0 0.06 10 force", 
            i
            ))       
            commands.execAsync(string.format("particle light_sword:orange ~%.5f ~ ~ 0 0 0 0.01 10 force", 
            i
            ))    
            zc = worldScanner.getBlockAt(2+i,0,0,false)
                if zc.ship_id ~= nil then
                    if not isShip5ConnectedToCurrent(zc.ship_id) then
            commands.execAsync(string.format("summon createbigcannons:ap_autocannon ~%.5f ~ ~ {Motion:[0.1,0.0,0.0],ProjectileMass:2000000.0f,Age:0,Damage:1500f}", 
                (1+i),math.random(-100,100)/100
            ))                        
                    end
                end
                

        end
    end
    sleep(0)
end