p = peripheral.wrap("top")
local function screen()
    player = coordinate.getPlayers(25000)
    if player ~= nil then
        for k, v in pairs(player) do
        guy = v.name
        if guy == user then
        return player
    end 
    end

    end

end

local function distance(a, b)
    return math.sqrt((b.x-a.x)^2 + (b.y-a.y)^2 + (b.z-a.z)^2)
end

function rayCast()
    local player = screen()
    if player ~= nil then
        for k, pos in pairs(player) do
        for i = 1, 256, 1 do
            local za = ship.getWorldspacePosition()
            
            pos.x = pos.x + pos.viewVector.x
            pos.y = pos.y + pos.viewVector.y
            pos.z = pos.z + pos.viewVector.z

            local la = distance(za,pos)

            block = coordinate.getBlock(pos.x,pos.y+1,pos.z)
        local manster = coordinate.getMonster(200)
        for key, v2 in pairs(manster) do
        if manster ~= nil then
            if pos.x < v2.x + 2 and pos.x > v2.x -2 and pos.y < v2.y + 2 and pos.y > v2.y -2 and pos.z < v2.z + 2 and pos.z > v2.z -2 then
                commands.execAsync("playsound tallyho:aim9_lock master @a ~ ~ ~ 0.5 1 1")
                return { x = v2.x ,y = v2.y ,z = v2.z }
            end 
        end
    end            
            local ship1 = coordinate.getShipsAll(256)
            for key, value in pairs(ship1) do
                if ship1 ~= nil then
                    mz = pos.x < value.max_x and pos.x > value.min_x and pos.y < value.max_y and pos.y > value.min_y and pos.z < value.max_z and pos.z > value.min_z  and la > 16
                else
                    mz = false
                end

            if block ~= "minecraft:air" and block ~= "minecraft:cave_air" and block ~= "minecraft:void_air" and block ~= "minecraft:dadelion" and block ~= "minecraft:cornflower" and block ~= "minecraft:snow" and block ~= "minecraft:grass" and block ~= "minecraft:tall_grass" and la > 16 or i == 256 or mz then
                return { x = pos.x ,y = pos.y+1 ,z = pos.z }
            end                         
            end
        end
        end
    end
end   
local function mb()
    playerst=coordinate.getPlayers(1000)
    for k, v in pairs(playerst) do
        user = v.name
    end
    print(user)
    while true do
        ta = rayCast()
        sleep(0)
    end
end
local function rotateVector(q, v)
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
local function quatToMatrix(q)
    local x2 = q.x + q.x; local y2 = q.y + q.y; local z2 = q.z + q.z
    local xx = q.x * x2; local xy = q.x * y2; local xz = q.x * z2
    local yy = q.y * y2; local yz = q.y * z2; local zz = q.z * z2
    local wx = q.w * x2; local wy = q.w * y2; local wz = q.w * z2
    
    return {
        {1 - (yy + zz), xy - wz, xz + wy},
        {xy + wz, 1 - (xx + zz), yz - wx},
        {xz - wy, yz + wx, 1 - (xx + yy)}
    }
end

-- 使用旋转矩阵旋转向量
local function rotateVectorWithMatrix(m, v)
    return {
        x = m[1][1]*v.x + m[1][2]*v.y + m[1][3]*v.z,
        y = m[2][1]*v.x + m[2][2]*v.y + m[2][3]*v.z,
        z = m[3][1]*v.x + m[3][2]*v.y + m[3][3]*v.z
    }
end

-- 角度规范化
local function normalizeAngle(angle)
    angle = angle % (2 * math.pi)
    if angle > math.pi then
        angle = angle - 2 * math.pi
    elseif angle < -math.pi then
        angle = angle + 2 * math.pi
    end
    return angle
end

-- 步进转动函数
local function stepTowards(current, target, stepSize)
    local diff = normalizeAngle(target - current)
    if math.abs(diff) <= stepSize then
        return target
    else
        return current + math.sign(diff) * math.min(math.abs(diff), stepSize)
    end
end

local function preciseAimTurret(gc1,gc2,ya,pi,xx1,sx1,cf,oay,oap,spee,rightside,zf)
    local turretOffsetY = 0 
    local gunOffsetX = rightside
    zmzt = 0
    tk = 0

    local currentYaw = oay
    local currentPitch = oap
    
    -- 最大转动步长（0.05弧度）
    local maxStep = spee
    
    -- 获取船体旋转矩阵（缓存）
    local lastShipMatrix = nil
    local lastShipQuat = nil
    time = 0
    time2 = 0
    zmzt = 0
    while true do
        -- 获取船体姿态和位置
        
        f=redstone.getAnalogInput("front")


        kv = ta

        local vorVector = {x = 0, y = 0 , z = -1}
        local shipQuat = p.callRemote(gc1,"getQuaternion")
        local shipPos = p.callRemote(gc2,"getPosition")
        local xvt = rotateVector(shipQuat,vorVector)
        hp = p.callRemote("a6","getTargetValue")
        if f > 0 and kv ~= nil then
        targetPos = kv
            else
                targetPos = {x = shipPos.x + xvt.x*100 , y = shipPos.y + 10 + xvt.y*100 , z = shipPos.z + xvt.z*100 }
        end
        
        -- 计算船体旋转矩阵（如果四元数变化则重新计算）
        if not lastShipQuat or not quatEqual(lastShipQuat, shipQuat) then
            lastShipMatrix = quatToMatrix(shipQuat)
            lastShipQuat = {w = shipQuat.w, x = shipQuat.x, y = shipQuat.y, z = shipQuat.z}
        end
        
        -- 1. 计算炮塔基座位置（世界坐标系）
        local turretOffsetShip = {x = 0, y = turretOffsetY, z = 0}
        local turretOffsetWorld = rotateVectorWithMatrix(lastShipMatrix, turretOffsetShip)
        local turretPosWorld = {
            x = shipPos.x + turretOffsetWorld.x,
            y = shipPos.y + turretOffsetWorld.y,
            z = shipPos.z + turretOffsetWorld.z
        }
        
        -- 2. 计算炮管根部位置（世界坐标系）
        -- 炮管在炮塔坐标系中的偏移
        local gunOffsetTurret = {x = gunOffsetX, y = 0, z = 0}
        
        -- 计算炮塔坐标系到船体坐标系的旋转矩阵（绕Y轴）
        local turretToShipMatrix = {
            {math.cos(currentYaw), 0, -math.sin(currentYaw)},
            {0, 1, 0},
            {math.sin(currentYaw), 0, math.cos(currentYaw)}
        }
        
        -- 转换到船体坐标系
        local gunOffsetShip = rotateVectorWithMatrix(turretToShipMatrix, gunOffsetTurret)
        
        -- 转换到世界坐标系
        local gunOffsetWorld = rotateVectorWithMatrix(lastShipMatrix, gunOffsetShip)
        local gunPosWorld = {
            x = turretPosWorld.x + gunOffsetWorld.x,
            y = turretPosWorld.y + gunOffsetWorld.y,
            z = turretPosWorld.z + gunOffsetWorld.z
        }
        
        -- 3. 计算目标向量（世界坐标系）
        local targetVecWorld = {
            x = targetPos.x - gunPosWorld.x,
            y = targetPos.y - gunPosWorld.y,
            z = targetPos.z - gunPosWorld.z
        }
        
        -- 4. 将目标向量转换到船体坐标系
        local shipMatrixInv = matrixTranspose(lastShipMatrix)  -- 正交矩阵的逆等于转置
        local targetVecShip = rotateVectorWithMatrix(shipMatrixInv, targetVecWorld)
        
        -- 5. 计算目标偏航角（绕船体Y轴）
        local targetYaw = math.atan2(targetVecShip.x, targetVecShip.z)
        
        -- 6. 将目标向量转换到炮塔坐标系
        local turretMatrixInv = matrixTranspose(turretToShipMatrix)
        local targetVecTurret = rotateVectorWithMatrix(turretMatrixInv, targetVecShip)
        
        -- 7. 计算目标俯仰角（绕炮塔X轴）
        local horizontalDist = math.sqrt(targetVecTurret.x^2 + targetVecTurret.z^2)
        local targetPitch
        if horizontalDist < 1e-6 then
            targetPitch = targetVecTurret.y > 0 and math.pi/2 or -math.pi/2
        else
            targetPitch = math.atan2(targetVecTurret.y, horizontalDist)
        end
        
        -- 8. 应用步进限制
        currentYaw = stepTowards(currentYaw, targetYaw, maxStep)
        currentPitch = stepTowards(currentPitch, targetPitch, maxStep)
        
        -- 9. 输出转动指令

            setTurretYaw(currentYaw,ya,oay)
            setTurretPitch(currentPitch,pi,xx1,sx1,oap,zf) 
        zmzt = 0

    os.sleep(0.05)
    end

end

-- 辅助函数
function math.sign(x)
    return x > 0 and 1 or x < 0 and -1 or 0
end

function matrixTranspose(m)
    return {
        {m[1][1], m[2][1], m[3][1]},
        {m[1][2], m[2][2], m[3][2]},
        {m[1][3], m[2][3], m[3][3]}
    }
end

function quatEqual(q1, q2)
    local tolerance = 1e-6
    return math.abs(q1.w - q2.w) < tolerance and
           math.abs(q1.x - q2.x) < tolerance and
           math.abs(q1.y - q2.y) < tolerance and
           math.abs(q1.z - q2.z) < tolerance
end

-- 硬件接口函数（需要根据实际实现）
function getShipOrientation()
    -- 实现从船舶导航系统获取四元数
    return {w = 1, x = 0, y = 0, z = 0}
end

function getShipPosition()
    -- 实现获取船体位置
    return {x = 0, y = 0, z = 0}
end

function getTargetPosition()
    -- 实现获取目标位置
    return {x = 10, y = 5, z = 20}
end
function setTurretYaw(angle,ya,oay)
    if tk == 0 then
        opi = p.callRemote(ya,"getAngle")
    end
    if tk < 36 then
        p.callRemote(ya,"setTargetValue",opi+(angle+oay-opi-opi)/35*tk)
        else
        p.callRemote(ya,"setTargetValue",angle+oay)           
        p.callRemote("gm1","setTargetValue",angle+oay)
    end
    tk = tk + 1
end
tk = 0
function setTurretPitch(angle,pi,xx1,sx1,oa,zf)

        p.callRemote(pi,"setTargetValue",zf*angle+oa)            
        p.callRemote("gm2","setTargetValue",zf*angle+oa)

end
parallel.waitForAll(
function () mb() end,
function () preciseAimTurret("zm0","zm0","zm1","zm2",-5,5,redstone.getAnalogInput("right"),math.pi/2+math.pi,math.pi,1.3,0,-1)end,
function () preciseAimTurret("zm3","zm3","zm4","zm5",-5,5,redstone.getAnalogInput("right"),math.pi/2+math.pi,-math.pi/2,1.3,0,-1)end)