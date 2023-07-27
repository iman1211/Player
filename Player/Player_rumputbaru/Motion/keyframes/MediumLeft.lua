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
0,20,-43,42,-20,-20,  -- -95
0,20,-43,42,-20,-20,  -- -95
90,-16,-40
})*math.pi/180,
duration = 2;  -- -0.3
},

--Lifti
{
angles=vector.new({
0,-90,
90,16,-40,
0,25,-64,90,-56,-20,  --Penendang
0,13,-35,25,-10,-18,  --Penumpu
90,-16,-40
})*math.pi/180,
duration = 1.5;
},

--3
--Lifting
{
angles=vector.new({
0,-90,
90,16,-40,
0,28,-15,55,-38,-11, -- Penendang 
0,13,-40,25,-10,-18,  -- Penumpu
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
0,28,-60,40,-20,-10,  -- Penendang
0,13,-35,25,-10,-18,  -- Penumpu
90,-16,-40
})*math.pi/180,
duration = 0.2;
},

-- Landing 1
{
angles=vector.new({
0,-90,
90,16,-40,
-2.5,20,-80,113,-55,1.4,  --Penendang
2,13,-35,33,-15,-18,  --Penumpu
90,-16,-40
})*math.pi/180,
duration = 0.5;
},


-- Landing Last
{
angles=vector.new({
0,-90,
90,16,-40,
2.5,25,-43,42,-20,-20,  -- Penendang
2.1,15,-35,33,-15,-18,  -- Penumpu
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

