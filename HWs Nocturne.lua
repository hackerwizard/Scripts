--[HackerWizards Nocturne]--
if myHero.charName ~= "Nocturne" then return end

-- PREDICTION
if VIP_USER then
  QPredic = TargetPrediction(1200, 1600, .25, 100)
  PrintChat("<font color=\"#000000\"><b>Embrace the Darkness... Nocturne by HW Loaded V1.0</b></font>")
else
  QPredic = TargetPrediction(1200, 1423, 250, 100)
  PrintChat("<font color=\"#000000\"><b>Embrace the Darkness... Nocturne by HW Loaded V1.0</b></font>")
end

-- Misc
local version = "1.1"
local author = "HW"
local AUTOUPDATE = false
local iDmg = 0
local target = nil
local Ignite = { name = "summonerdot", range = 600, slot = nil }
local IgniteDmg = 50 + (20 * myHero.level)
local AARange = 125
local Range = {2000,2750,3500}
local ERange = 425
local QRange = 1200
 
function OnLoad()
Noctcfg = scriptConfig("Nocturne V1.1", "Nocturne by HW")
  Noctcfg:addSubMenu("Combo Settings", "combo")  
	Noctcfg:addSubMenu("Draw Settings", "draw")
	Noctcfg:addSubMenu("Auto Settings", "auto")
  Noctcfg.combo:addParam("combo", "Use Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
  Noctcfg.combo:addParam("useR", "Smart Ultimate", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
  Noctcfg.combo:addParam("useE", "Use E in Combo", SCRIPT_PARAM_ONOFF, true)
  Noctcfg.combo:addParam("useQ", "Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
  Noctcfg.draw:addParam("drawaa", "Draw AA Range", SCRIPT_PARAM_ONOFF, false)
  Noctcfg.draw:addParam("drawq", "Draw Q Range", SCRIPT_PARAM_ONOFF, false)
	Noctcfg.draw:addParam("drawe", "Draw E Range", SCRIPT_PARAM_ONOFF, false)	
	Noctcfg.draw:addParam("drawr", "Draw R Range", SCRIPT_PARAM_ONOFF, false)
	Noctcfg.auto:addParam("Autolevel", "Auto Level Spells", SCRIPT_PARAM_ONOFF, false)
  Noctcfg:permaShow("combo")
        ts = TargetSelector(TARGET_LESS_CAST, 3500, DAMAGE_PHYSICAL)
        ts.name = "Nocturne"
        Noctcfg:addTS(ts)
  enemyMinions = minionManager(MINION_ENEMY, 1200, player)
  lastAttack, lastWindUpTime, lastAttackCD = 0, 0, 0
SSCheck()
end

function OnTick()
        ts:update()
        enemyMinions:update()
if Noctcfg.combo.combo then
  Combo()
end
if Noctcfg.combo.useR and ts.target ~=nil then
    UseUlt()
 end
if Noctcfg.auto.Autolevel then
autoLevelSetSequence(levelSequence)
levelSequence = { 0,2,3,1,1,4,1,3,1,3,4,3,3,2,2,4,2,2 }
 end
end

function SSCheck()
if myHero:GetSpellData(SUMMONER_1).name:find("smite") then Smite = SUMMONER_1 and 
	Noctcfg.combo:addParam("usesmite1", "Use Smite in Combo", SCRIPT_PARAM_ONOFF, true)
elseif myHero:GetSpellData(SUMMONER_2).name:find("smite") then Smite = SUMMONER_2 and 
	Noctcfg.combo:addParam("usesmite2", "Use Smite in Combo", SCRIPT_PARAM_ONOFF, true)
 end
if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then Ignite = SUMMONER_1 and 
	Noctcfg.auto:addParam("ignite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then Ignite = SUMMONER_2 and 
	Noctcfg.auto:addParam("ignite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
 end
end

function Combo()
        if ts.target ~= nil then
                -- Q
                QPredict = QPredic:GetPrediction(ts.target)
                if Noctcfg.combo.useQ and myHero:CanUseSpell(_Q) == READY and QPredict ~= nil and GetDistance(QPredict) <= 1200 then
                        CastSpell(_Q, QPredict.x, QPredict.z)
                end
    -- E
    if Noctcfg.combo.useE and myHero:CanUseSpell(_E) == READY and GetDistance(ts.target) <= 425 then
      CastSpell(_E, ts.target)
    end
		end
		--Smite
if Noctcfg.combo.usesmite1
and 
myHero:CanUseSpell(SUMMONER_1) == READY and GetDistance(ts.target) <= 490 then
      CastSpell(SUMMONER_1, ts.target)
			end
if Noctcfg.combo.usesmite2
and 
myHero:CanUseSpell(SUMMONER_2) == READY and GetDistance(ts.target) <= 490 then
      CastSpell(SUMMONER_2, ts.target)
 end
end

function OnProcessSpell(object, spell)
  if object.isMe then
    if spell.name:lower():find("attack") then
      lastAttack = GetTickCount() - GetLatency()/2
      lastWindUpTime = spell.windUpTime*1000
      lastAttackCD = spell.animationTime*1000
  end
 end
end
 
function UseUlt()
  local RRange = GetRRange()
  if myHero:CanUseSpell(_R) == READY and GetDistance(ts.target) <= RRange then
    CastSpell(_R, ts.target)
    CastSpell(_R, ts.target)
 end
end
 
function GetRRange()
        if myHero:GetSpellData(_R).level == 1 then
                return 2000
        elseif myHero:GetSpellData(_R).level == 2 then
                return 2750
        elseif myHero:GetSpellData(_R).level == 3 then
                return 3500
        end
end
 
function OnDraw()
  local RRange = GetRRange()
        if Noctcfg.draw.drawq then
                if myHero:CanUseSpell(_Q) == READY then
                        DrawCircle(myHero.x, myHero.y, myHero.z, 1200, 0xFF0000)
                end
								end
								    if Noctcfg.draw.drawe then
                if myHero:CanUseSpell(_E) == READY then
      DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0xFF0000)
			end
    end
    if Noctcfg.draw.drawr then
                if myHero:CanUseSpell(_R) == READY then
      DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0xFF0000)
    end
		if Noctcfg.draw.drawaa then
 DrawCircle(myHero.x, myHero.y, myHero.z, AARange, 0xFF0000)
  end
 end
end
 
function minionCollision(predic, width, range)
        for _, minionObjectE in pairs(enemyMinions.objects) do
                if predic ~= nil and player:GetDistance(minionObjectE) < range then
                        ex = player.x
                        ez = player.z
                        tx = predic.x
                        tz = predic.z
                        dx = ex - tx
                        dz = ez - tz
                        if dx ~= 0 then
                                m = dz/dx
                                c = ez - m*ex
                        end
                        mx = minionObjectE.x
                        mz = minionObjectE.z
                        distanc = (math.abs(mz - m*mx - c))/(math.sqrt(m*m+1))
                        if distanc < width and math.sqrt((tx - ex)*(tx - ex) + (tz - ez)*(tz - ez)) > math.sqrt((tx - mx)*(tx - mx) + (tz - mz)*(tz - mz)) then
                                return true
                        end
                end
        end
        return false
end
