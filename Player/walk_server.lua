module(... or '', package.seeall)

-- Get Platform for package path
cwd = '.';
local platform = os.getenv('PLATFORM') or '';
if (string.find(platform,'webots')) then cwd = cwd .. '/Player';
end

-- Get Computer for Lib suffix
local computer = os.getenv('COMPUTER') or '';
if (string.find(computer, 'Darwin')) then
  -- MacOS X uses .dylib:
  package.cpath = cwd .. '/Lib/?.dylib;' .. package.cpath;
else
  package.cpath = cwd .. '/Lib/?.so;' .. package.cpath;
end

package.path = cwd .. '/?.lua;' .. package.path;
package.path = cwd .. '/Util/?.lua;' .. package.path;
package.path = cwd .. '/Config/?.lua;' .. package.path;
package.path = cwd .. '/Lib/?.lua;' .. package.path;
package.path = cwd .. '/Dev/?.lua;' .. package.path;
package.path = cwd .. '/Motion/?.lua;' .. package.path;
package.path = cwd .. '/Motion/keyframes/?.lua;' .. package.path;
package.path = cwd .. '/Motion/Walk/?.lua;' .. package.path;
package.path = cwd .. '/Vision/?.lua;' .. package.path;
package.path = cwd .. '/World/?.lua;' .. package.path;

require('unix')
require('Config')
require('shm')
require('vector')
require('mcm')
require('Speak')
require('getch')
require('Body')
require('Motion')
require('dive')
require('grip')

-------------- UDP COMMUNICATION FOR BODY KINEMATIC ----------
local socket_body = require "socket"
local udp_body = socket_body.udp()
udp_body:settimeout(0)
udp_body:setsockname('*', 5000)
local data_body, msg_or_ip_body, port_or_nil_body
-------------------------------------------------------

--------------- UDP COMMUNICATION FOR HEAD MOVEMENT --------------
local socket_head = require "socket"
local udp_head = socket_head.udp()
udp_head:settimeout(0)
udp_head:setsockname('*', 5001)
local data_head, msg_or_ip_head, port_or_nil_head
---------------------------------------------------

--------------- UDP COMMUNICATION FOR SENSOR --------------
local socket_sensor = require "socket"
local udp_button = socket_sensor.udp()
udp_button:settimeout(0)
udp_button:setpeername("127.0.0.1", 5002)
---------------------------------------------------

Motion.entry();
darwin = false;
webots = false;

-- Enable OP specific 
if(Config.platform.name == 'OP') then
  darwin = true;
  --SJ: OP specific initialization posing (to prevent twisting)
--  Body.set_body_hardness(0.3);
--  Body.set_actuator_command(Config.stance.initangle)
end

--TODO: enable new nao specific
newnao = false; --Turn this on for new naos (run main code outside naoqi)
newnao = true;

getch.enableblock(1);
-- unix.usleep(1E6*1.0);
unix.usleep(0);
Body.set_body_hardness(0.8);

--This is robot specific 
webots = false;
init = false;
calibrating = false;
ready = false;
if( webots or darwin) then
  ready = true;
end

initToggle = true;
targetvel=vector.zeros(3);
button_pressed = {0,0};
--tambahan
lastYaw = 0;
lastSupportLeg = false;
walkActive = 0
supLeg = 0

function string:split(inSplitPattern, outResults)
   if not outResults then
      outResults = { }
   end
   local theStart = 1
   local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   while theSplitStart do
      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   end
   table.insert( outResults, string.sub( self, theStart ) )
   return outResults
end

function openGripper()
    Body.set_aux_hardness(0.5);
    angle = math.pi/180*vector.new({60, 60})
    Body.set_aux_command(angle);
end

function closeGripper()
  Body.set_aux_hardness(0.5);
  angle = math.pi/180*vector.new({0, 0})
  Body.set_aux_command(angle);
end



--[[ os.execute("screen -d player");
function process_keyinput()  
  
  --hanjaya
  data_body, msg_or_ip_body, port_or_nil_body = udp_body:receivefrom(30)
  if data_body ~= nil then
    -- print(data_body)
    if data_body then
      -- print(data_body)
      local byte=string.byte(data_body);
       
      local parseData = data_body:split(",")
      if (parseData[1]=="walk") then
        walk.set_velocity(tonumber(parseData[2]),tonumber(parseData[3]),tonumber(parseData[4]));
        -- print("X:",parseData[2], "Y:",parseData[3], "A:",parseData[4]);
      elseif (parseData[1]=="motion") then
        -- print("Action:",parseData[2])
        if(tonumber(parseData[2]) == 1) then
          Motion.event("tendang");		   
          bfc_kick.set_tendang("LongLeft");      
        elseif(tonumber(parseData[2]) == 2) then 
          Motion.event("tendang");
          bfc_kick.set_tendang("LongRight");
        elseif(tonumber(parseData[2]) == 3) then
          Motion.event("kick");
          kick.set_kick("kickSideLeft");		        
        elseif(tonumber(parseData[2]) == 4) then
          Motion.event("kick");
          kick.set_kick("kickSideRight");
        elseif(tonumber(parseData[2]) == 5) then
          walk.doWalkKickLeft();		        
        elseif(tonumber(parseData[2]) == 6) then
          walk.doWalkKickRight();
        elseif (tonumber(parseData[2]) == 8) then	
          Motion.event("standup");
          closeGripper();
          if walk.active then walk.stop(); end
        elseif (tonumber(parseData[2]) == 9) then	
          Motion.event("start");
          walk.start();
        elseif (tonumber(parseData[2]) == 0) then	
          if walk.active then walk.stop(); end
        elseif (tonumber(parseData[2]) == 7) then	
          Motion.event("sit");
        end		
      elseif (parseData[1]=="grip") then
        --print(parseData[2])
        if(tonumber(parseData[2]) == 1) then
          --print("close");
          closeGripper();
        else 
          --print("open");
          openGripper();
        end
      end
      
      --walk.set_velocity(unpack(targetvel));
    end
  end
    data_head, msg_or_ip_head, port_or_nil_head = udp_head:receivefrom()
    if data_head then
      -- print(data_head)
      local head_angle = data_head:split(",")
      -- print(head_angle[1], head_angle[2])
      Body.set_head_hardness(0.5);
      Body.set_head_command({tonumber(head_angle[1]),tonumber(head_angle[2])});
   elseif msg_or_ip_head ~= 'timeout' then
   end
end ]]

local regres = true;
local errorWalkX = 0; -- sesuai dengan error Walk di configure.ini -- -0.0059990001666389
local errorWalkA = 0; -- sesuai dengan error Walk di configure.ini 
local parsing;
local inputStart = errorWalkX;
local inputEnd = walk.velLimitX[2];
local outputStart = 0.035;
local outputEnd = 0.08;
local Output;
local Error = 0;
local Perror;
local dataAkhir;
local walkKine = errorWalkX;
local actual_walk = walk.get_velocity();


local Count = 0;
local ErrorStep;
local PerrorStep;
local dataAkhirStep;
local walkKineStep;
local selisih = 0;
local selisihA = 0;


os.execute("screen -d player");
function process_keyinput()
	data_body, msg_or_ip_body, port_or_nil_body = udp_body:receivefrom() -- tampung data dari socket
	--start proses input motion and walk
	if data_body ~= nil then
		if data_body then
			print(data_body)
      local byte;
			parsing = data_body:split(",") -- pemisahan data dari header "motion" = motion , "walk" = velocity
			if parsing[1] == "motion" then 
				byte=string.byte(parsing[2]);
				if byte==string.byte("1") then	
					Motion.event("tendang");		   
          			bfc_kick.set_tendang("LongLeft"); 
					walk.initStep = 2;
				elseif byte==string.byte("2") then	
					Motion.event("tendang");
          			bfc_kick.set_tendang("LongRight");
					walk.initStep = 1;
				elseif byte==string.byte("3") then	
					bfc_kick.set_tendang("SideLeft")    
          			Motion.event("tendang");
					walk.initStep = 2;
				elseif byte==string.byte("4") then	
					bfc_kick.set_tendang("SideRight")    
          			Motion.event("tendang");
					walk.initStep = 1;
				elseif byte==string.byte("!") then	
					bfc_kick.set_tendang("MediumSideLeft")    
          			Motion.event("tendang");
					walk.initStep = 2;
				elseif byte==string.byte("@") then	
					bfc_kick.set_tendang("MediumSideRight")    
          			Motion.event("tendang");
					walk.initStep = 1;
				elseif byte==string.byte("5") then
					bfc_kick.set_tendang("MediumLeft")    
          			Motion.event("tendang");
					walk.initStep = 2;
				elseif byte==string.byte("6") then
          			bfc_kick.set_tendang("MediumRight")    
          			Motion.event("tendang");
					walk.initStep = 1;
				elseif byte==string.byte("7") then  
					Motion.event("sit");
				elseif byte==string.byte("8") then	
					Motion.event("standup");
					if walk.active then walk.stop(); end
				elseif byte==string.byte("9") then	
					Motion.event("walk");
					walk.start();
				elseif byte==string.byte("0") then	
					if walk.active then walk.stop(); end
					end
				else -- program input velocity
					local hasilParsing = data_body:split(",") --process pemisahan data velocity dengan header dan pemisahan sumbu X,Y,A
					if hasilParsing[1]=="walk" then
						walkX = actual_walk[1];
						walkY = actual_walk[2];
						walkA = actual_walk[3];
						selisih = walkX - 0.0;
						selisihA = tonumber(hasilParsing[2]) - walkX;
						--print("actual walk	: ",actual_walk[1]);
						--print("hasil parsing	: ",hasilParsing[2]);
						--print("walk kine	: ",walkKine);
						--print("stepHeight	: ",walk.stepHeight);
						-----------Start Program Decelerasi "P" controller-----------
						if tonumber(hasilParsing[2]) == errorWalkX and dataAkhir ~= 0 then
						        walk.tStep = 0.30;
						        walk.tZmp = 0.165;
							if selisih > 0 then
									Error =  actual_walk[1] + errorWalkX;
							elseif selisih < 0 then
									Error =  actual_walk[1] - errorWalkX;		
							end
							Perror = Error * 0.40;
              dataAkhir = actual_walk[1] - Perror;
              if dataAkhir > tonumber(hasilParsing[2]) then
                dataAkhir = tonumber(hasilParsing[2]);
              elseif dataAkhir < tonumber(hasilParsing[2]) then
                dataAkhir = tonumber(hasilParsing[2]); end
							print("Decel")
						-----------Start Program Accelerasi "P" controller-----------
						
						elseif walkX < 0.02 and tonumber(hasilParsing[2]) > 0.02 then
						        walk.tStep = 0.30;
						        walk.tZmp = 0.165;
							if walkKine < 0.02 then
							        walk.tStep = 0.30;
							        walk.tZmp = 0.165;
							else						
							        walk.tStep = 0.30;
							        walk.tZmp = 0.175;
							end
--							walk.tStep = 0.26;
							Error =  tonumber(hasilParsing[2]) - actual_walk[1];
							Perror = Error * 0.1;
							dataAkhir = actual_walk[1] + Perror;
							if dataAkhir > tonumber(hasilParsing[2]) then
								dataAkhir = tonumber(hasilParsing[2]);
							elseif dataAkhir < tonumber(hasilParsing[2]) then
								dataAkhir = tonumber(hasilParsing[2]);  end
							print("Accel")
						
						else
							dataAkhir = tonumber(hasilParsing[2]);
						end
						walkKine = tonumber(dataAkhir);

						-- if tonumber(walkKine) < errorWalkX then
						-- 	walk.hardnessSwing = 0.51;
						-- else
						-- 	walk.hardnessSwing = 0.59;
						-- end

						walk.set_velocity(tonumber(walkKine),tonumber(hasilParsing[3]),tonumber(hasilParsing[4]));
						-- Output = outputStart + ((outputEnd - outputStart) / (inputEnd - inputStart)) * (tonumber(walkKine) - inputStart); -- proses regresi stepHeight
						Output = (0.0075*(tonumber(walkKine)*100)) + 0.0105
            if Output < 0.04 then
              Output = 0.04
            elseif Output > 0.05 then
              Output = 0.05
            end
            if walkKine > 0.02 then
						        walk.tStep = 0.30;
						        walk.tZmp = 0.175;
						else
						        walk.tStep = 0.30;
						        walk.tZmp = 0.165;
						end
						if walkY ~= 0 or walkA < 0 or walkA > errorWalkA then --jika erroWalkA bernilai positif
						--if walkY ~= 0 or walkA > 0 or walkA < errorWalkA then --jika errorWalkA bernilai negatif
							--walkKine = tonumber(walkKine) + 0.014;
							walk.stepHeight = 0.045;
              walk.tStep = 0.30;
						else
							if walkX < errorWalkX then
								walk.stepHeight = 0.045;
                walk.tStep = 0.30;
							else 
								if (regres == false) then -- mode stepHeight tanpa regresi
									if walkX > -0.005 and walkX < 0.005 then 
										walk.stepHeight = 0.03;
										print("0");
									elseif walkX > 0.005 and walkX < 0.015 then 
										walk.stepHeight = 0.036;
										print("1");
									elseif walkX > 0.015 and walkX < 0.025 then 
										walk.stepHeight = 0.042;
										print("2");
									elseif walkX > 0.025 and walkX < 0.035 then 
										walk.stepHeight = 0.048;
										print("3");
									elseif walkX > 0.035 and walkX < 0.045 then 
										walk.stepHeight = 0.054;
										print("4");
									elseif walkX > 0.045 and walkX < 0.055 then 
										walk.stepHeight = 0.060;
										print("5");
									elseif walkX > 0.055 and walkX < 0.065 then 
										walk.stepHeight = 0.067;
										print("6");
									elseif walkX > 0.065 and walkX < 0.075 then 
										walk.stepHeight = 0.073;
										print("7");
									elseif walkX > 0.075 and walkX < 0.085 then 
										walk.stepHeight = 0.080;
										print("8");
									end 
								else -- mode stepHeight regresi
									-- if walkKine > 0.2 then
									-- 	walk.stepHeight = 0.08;
--										walk.tStep = 26;
									-- else
										walk.stepHeight = Output;
--										walk.tStep = 28;
									-- end
								end
							end
						end
					end
				end
			end
	elseif data_body == nil then 
		data_body = "walk,0.00,0.00,0.00";
	--   print(data_body)
	else
		data_body = "walk,0.00,0.00,0.00";
	--   print("null");
	end	

	data_head, msg_or_ip_head, port_or_nil_head = udp_head:receivefrom() -- tampung data gerak kepala dari socket
	--start proses input head movement
	if data_head then
		--print(data_head)
		local head_angle = data_head:split(",") --pemisahan data antara tilt dan pan (angguk dan geleng)
			Body.set_head_command({tonumber(head_angle[1]),tonumber(head_angle[2])});
			Body.set_head_hardness(0.5);
	elseif msg_or_ip_head ~= 'timeout' then
	end	
end

-- main loop
count = 0;
lcount = 0;
tUpdate = unix.time();

function update()
  count = count + 1;
  if (not init)  then
    if (calibrating) then
      if (Body.calibrate(count)) then
        Speak.talk('Calibration done');
        calibrating = false;
        ready = true;
      end
    elseif (ready) then
      init = true;
    else
      if (count % 20 == 0) then
-- start calibrating w/o waiting
--        if (Body.get_change_state() == 1) then
          Speak.talk('Calibrating');
          calibrating = true;
--        end
      end
      -- toggle state indicator
      if (count % 100 == 0) then
        initToggle = not initToggle;
        if (initToggle) then
          Body.set_indicator_state({1,1,1}); 
        else
          Body.set_indicator_state({0,0,0});
        end
      end
    end
  else
    -- update state machines 
    process_keyinput();
    Motion.update();
    Body.update();
  end
  local dcount = 50;
  if (count % 50 == 0) then
--    print('fps: '..(50 / (unix.time() - tUpdate)));
    tUpdate = unix.time();
    -- update battery indicator
    Body.set_indicator_batteryLevel(Body.get_battery_level());
  end
  
  -- check if the last update completed without errors
  lcount = lcount + 1;
  if (count ~= lcount) then
    print('count: '..count)
    print('lcount: '..lcount)
    Speak.talk('missed cycle');
    lcount = count;
  end

  if (Body.get_change_state() == 1) then button_pressed[1]=1;
  else                                   button_pressed[1]=0;
  end

  if (Body.get_change_role() == 1) then button_pressed[2]=1;
  else                                  button_pressed[2]=0;
  end

  -- print(vector.new(button_pressed))
  SensorCM=shm.open('dcmSensor');
  local imuAllIn = SensorCM:get('imuAngle');
  local kneeAllIn = SensorCM:get('kneeCurrent');
  local imuYaw = imuAllIn[3]
  local velInMx, velInMy, velInMa = unpack(walk.get_velocity());
  local velInMmX = velInMx * 1000;
  local velInMmY = velInMy * 1000;
  local velInMmA = velInMa * 1000;
  if walk.active then walkActive = 1;
  else walkActive = 0; end
  if walk.supportLeg == 1 then supLeg = 1;
  else supLeg = 0; end
  if imuYaw ~= lastYaw or supLeg ~= lastSupportLeg then
    -- print(walkActive, supLeg)
    datagram = string.format("%d;%d;%d;",unpack(SensorCM:get('imuAngle')))..string.format("%d;",SensorCM:get('voltage')).. string.format("%d;%d;%d;",velInMmX, velInMmY, velInMmA).. string.format("%d;%d;", walkActive, supLeg).. string.format("%d;%d",unpack(SensorCM:get('kneeCurrent')));
    udp_button:send(datagram);
    lastYaw = imuYaw;
    lastSupportLeg = supLeg;
  end

  -- --Stop walking if button is pressed and the released
  -- if (Body.get_change_state() == 1) then
  --   button_pressed[1]=1;
  -- else
  --   if button_pressed[1]==1 then
  --     Motion.event("sit");
  --   end
  --   button_pressed[1]=0;
  -- end

  -- --stand up if button is pressed and the released
  -- if (Body.get_change_role() == 1) then
  --   button_pressed[2]=1;
  -- else
  --   if button_pressed[2]==1 then
  --     Motion.event("standup");
  --   end
  --   button_pressed[2]=0;
  -- end
  
end

-- if using Webots simulator just run update
if (webots) then
  while (true) do
    -- update motion process
    update();
    io.stdout:flush();
  end
end

--Now both nao and darwin runs this separately
if (darwin) or (newnao) then
  local tDelay = 0.005 * 1E6; -- Loop every 5ms
  while 1 do
    update();
    unix.usleep(tDelay);
  end
end
