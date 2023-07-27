local mot={};

mot.servos={
1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,};
mot.keyframes={  

--0
--COM Slide
{
angles=vector.new({
0,-90,
90,16,-100,
0,20,-35,42,-20,-20,  -- penumpu
0,20,-35,42,-20,-20,  -- penendang
90,-16,-100
})*math.pi/180,
duration = 1.2;  -- -0.3
},

--Lifti
{
angles=vector.new({
0,-90,
90,16,-100,
0, 25, -60, 80, -50, -18,  --Penendang
0, 11, -35, 30, -10, -19, -- Penumpu
90,-16,-100
})*math.pi/180,
duration = 1;
},

--3
--Lifting 1
{
angles=vector.new({
0,-90,
90,16,-100,
35,25,-40,60,-20,-18, -- Penendang
-2,11,-35,30,-10,-19,  -- Penumpu
90,-16,-100
})*math.pi/180,
duration = 0.3;
},

--3.5
-- Lifting 2
{
angles=vector.new({
0,-90,
90,16,-100,
40,25,-60,10,30,-20,  -- Penendang
0,13,-35,30,-10,-18,  -- Penumpu
90,-16,-100
})*math.pi/180,
duration = 0.25;
},

-- Kick Side
{
    angles=vector.new({
    0,-90,
    90,16,-100,
    -23,18,-67,10,30,-15,  -- Penendang
    0,13,-30,30,-10,-18,  -- Penumpu
    90,-16,-100
    })*math.pi/180,
    duration = 0.2;
    },

-- Landing 1
{
    angles=vector.new({
    0,-90,
    90,16,-40,
    2,20,-85,113,-55,-1.4,  --Penendang
    -2,11,-30,33,-15,-18,  --Penumpu
    90,-16,-40
    })*math.pi/180,
    duration = 1.2;
    },
-- Landing 2
{
    angles=vector.new({
    0,-90,
    90,16,-40,
    2,20,-43,42,-25,-20,  -- Penendang
    2,15,-35,33,-15,-18,  -- Penumpu
    90,-16,-40
    })*math.pi/180,
    duration = 1.2;
    },

--COM Last
{
    angles=vector.new({
    0,-90,
    90,16,-40,
    2,3,-40,42,-15,3,  -- -95 -- Penendang
    2,3,-40,42,-15,3, -- -95  -- Penumpu
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

