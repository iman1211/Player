local mot={};

mot.servos={
1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,};
mot.keyframes={  

--0
--For Set Early and com
{
angles=vector.new({
0,-90,
90,20,-0,
0,-0,-70,130,-65,-5,  -- penumpu
0,-0,-70,130,-65,-5,  -- penendang
90,-20,-0
})*math.pi/180,
duration = 0.5;  -- -0.3
},

--Lifti
{
angles=vector.new({
0,-90,
90,20,-0,
0,-0,-70,130,-65,-5,  -- penumpu
0,-0,-70,130,-65,-5,  -- penendang
90,-20,-0
})*math.pi/180,
duration = 5;
},

{
angles=vector.new({
0,-90,
90,20,-0,
0,-0,-50,50,-20,0,  -- penumpu
0,-0,-50,50,-20,0,  -- penendang
90,-20,-0
})*math.pi/180,
duration = 1;  -- -0.3
},
--3
--Lifting
--{
--angles=vector.new({
--0,-90,
--90,16,-40,
--0,-65,-60,120,-40,-15,  -- penumpu
---0,-65,-60,120,-40,-15,  -- penendang
--90,-16,-40
--})*math.pi/180,
--duration = 2;
--},

--3.5
-- Kick Devil
--{
--angles=vector.new({
---0,-90,
--90,16,-40,
--0,-5,-43,42,-5,18,  -- penumpu
--0,-5,-43,42,-5,20,  -- penendang
--90,-16,-40
--})*math.pi/180,
--duration = 0.2;
--},

-- Landing 1
--{
--angles=vector.new({
--0,-90,
--90,16,-40,
--2.1,-11,-35,33,-15,18,  --Penumpu
---2.5,-25,-80,113,-55,1.4,  --Penendang
--90,-16,-40
--})*math.pi/180,
--duration = 1;
--},


-- Landing Last
--{
--angles=vector.new({
--0,-90,
--90,16,-40,
--2.1,-15,-35,33,-15,18,  -- Penumpu
--2.5,-25,-43,42,-20,20,  -- Penendang
--90,-16,-40
--})*math.pi/180,
--duration = 0.5;
--},

--COM Last
--{
--angles=vector.new({
--0,-90,
--90,16,-40,
---2.5,3.2,-42.5,42,-20,3,  -- -95 -- Penendang
---2.5,3.2,-42.5,42,-20,3, -- -95  -- Penumpu
--90,-16,-40
--})*math.pi/180,
--duration = 0.5;
--},

--Penstabilan
--{
--angles=vector.new({
--0,-90,
--90,10,-90,
--0,0,-60,110,-60,0,
--0,0,-60,110,-60,0,
--90,-10,-90
--})*math.pi/180,
--duration = 0.4;
--},

--5
--Final Step
--{
--angles=vector.new({
--0,-90,
--90,10,-20,
--0,0,-46,70,-35,0,
--0,0,-46,70,-35,0,
--90,-10,-30
--})*math.pi/180,
--duration = 3;
--},
};

return mot;

