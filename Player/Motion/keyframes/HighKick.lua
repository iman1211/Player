local mot={};

mot.servos={
1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,};
mot.keyframes={  

--0
--COM Slide
{
angles=vector.new({
0,-90,
90,16,-40,
0,-20,-43,42,-20,20,  -- penumpu
0,-20,-43,42,-20,20,  -- penendang
90,-16,-40
})*math.pi/180,
duration = 1;  -- -0.3
},

--Lifti
{
angles=vector.new({
0,-90,
90,16,-40,
0, -11, -35, 25, -10, 17, -- Penumpu
0, -25, -64, 100, -56, 18,  --Penendang
90,-16,-40
})*math.pi/180,
duration = 0.8;
},

--3
--Lifting
{
angles=vector.new({
0,-90,
90,16,-40,
2,-11,-45,25,-10,17,  -- Penumpu
-5,-18,-15,110,-37,11, -- Penendang
90,-16,-40
})*math.pi/180,
duration = 0.3;
},

--3.5
-- Kick Devil
{
angles=vector.new({
0,-90,
90,16,-40,
0,-11,-16,25,-10,17,  -- Penumpu
0,-24,-80,10,-20,10,  -- Penendang
90,-16,-40
})*math.pi/180,
duration = 0.15;
},

-- Landing 1
{
angles=vector.new({
0,-90,
90,16,-40,
2.1,-11,-35,33,-15,17,  --Penumpu
-2.5,-25,-80,113,-55,1.4,  --Penendang
90,-16,-40
})*math.pi/180,
duration = 1;
},


-- Landing Last
{
angles=vector.new({
0,-90,
90,16,-40,
2.1,-15,-35,33,-15,16,  -- Penumpu
2.5,-25,-43,42,-20,20,  -- Penendang
90,-16,-40
})*math.pi/180,
duration = 0.5;
},

--COM Last
{
angles=vector.new({
0,-90,
90,16,-40,
-2.5,3.2,-42.5,42,-20,3,  -- -95 -- Penendang
-2.5,3.2,-42.5,42,-20,3, -- -95  -- Penumpu
90,-16,-40
})*math.pi/180,
duration = 1;
},

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
--duration = 1;
--},
};

return mot;

