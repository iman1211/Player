module(..., package.seeall);

require('Body')
require('keyframe')
require('unix')
require('Config');
require('walk');
require('wcm')

local cwd = unix.getcwd();
if string.find(cwd, "WebotsController") then
  cwd = cwd.."/Player";
end
cwd = cwd.."/Motion/keyframes"

keyframe.load_motion_file(cwd.."/"..Config.km.maut_kiri,
                          "LongLeft");
keyframe.load_motion_file(cwd.."/"..Config.km.maut_kanan,
                          "LongRight");
keyframe.load_motion_file(cwd.."/"..Config.km.side_kanan,
                          "SideRight");
keyframe.load_motion_file(cwd.."/"..Config.km.side_kiri,
                          "SideLeft");
keyframe.load_motion_file(cwd.."/"..Config.km.save_tengah,
                          "SaveCenter");
keyframe.load_motion_file(cwd.."/"..Config.km.medium_kiri,
                          "MediumLeft");
keyframe.load_motion_file(cwd.."/"..Config.km.medium_kanan,
                          "MediumRight");
keyframe.load_motion_file(cwd.."/"..Config.km.serong_kanan,
                          "SerongRight");


use_rollback_getup = Config.use_rollback_getup or 0;
batt_max = Config.batt_max or 10;

kickType = "LongRight"

function entry()
  print(_NAME.." entry");
  keyframe.entry();
  Body.set_body_hardness(0.865);
  if kickType == "LongRight" then
    keyframe.do_motion("LongRight");
  elseif kickType == "LongLeft" then
    keyframe.do_motion("LongLeft");
  elseif kickType == "SideRight" then
    keyframe.do_motion("SideRight");
  elseif kickType == "SideLeft" then
    keyframe.do_motion("SideLeft");
  elseif kickType == "SaveCenter" then
    keyframe.do_motion("SaveCenter");
  elseif kickType == "MediumLeft" then
    keyframe.do_motion("MediumLeft");
  elseif kickType == "MediumRight" then
    keyframe.do_motion("MediumRight");
  elseif kickType == "SerongRight" then
    keyframe.do_motion("SerongRight");
  end
  print("Tendangan Maut");
end

function update()
  keyframe.update();
  if (keyframe.get_queue_len() == 0) then
    local imuAngle = Body.get_sensor_imuAngle();
    local maxImuAngle = math.max(math.abs(imuAngle[1]),
                        math.abs(imuAngle[2]));
    print(maxImuAngle);
    if (maxImuAngle > 50) then
      -- print("AAAA");
      return "fail";
    else
    	--Set velocity to 0 to prevent falling--
    	walk.still=true;
    	walk.set_velocity(0, 0, 0);
      return "done";
    end
  end
end

function set_tendang(tipe)
  kickType = tipe;
end

function exit()
  keyframe.exit();
end
