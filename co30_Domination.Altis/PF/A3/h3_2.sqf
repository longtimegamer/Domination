//Land_i_Shop_02_V1_F	-	RESTAURANT
isNil{params["_b"];_f=[];_dir=getDir _b;
_cashD=createSimpleObject["A3\Structures_F\Furniture\CashDesk_F.p3d",[0,0,0]];
_chair1=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair2=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair3=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair4=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair5=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair6=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair7=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair8=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair9=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair10=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair11=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair12=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair13=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair14=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair15=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair16=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair17=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair18=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair19=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair20=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_chair21=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanChair_01_F.p3d",[0,0,0]];
_dTable1=createSimpleObject["a3\Props_F_Orange\Furniture\TableBig_01_F.p3d",[0,0,0]];
_dTable2=createSimpleObject["a3\Props_F_Orange\Furniture\TableBig_01_F.p3d",[0,0,0]];
_dTable3=createSimpleObject["a3\Props_F_Orange\Furniture\TableBig_01_F.p3d",[0,0,0]];
_dTable4=createSimpleObject["a3\Props_F_Orange\Furniture\TableBig_01_F.p3d",[0,0,0]];
_plant=createSimpleObject["a3\Props_F_Orange\Items\Decorative\FlowerPot_01_flower_F.p3d",[0,0,0]];
_sTable=createSimpleObject["A3\Structures_F_Heli\Furniture\RattanTable_01_F.p3d",[0,0,0]];
_stool=createSimpleObject["a3\structures_f\furniture\Bench_F.p3d",[0,0,0]];
_sign=createSimpleObject["A3\Structures_F\Civ\InfoBoards\InfoStand_V1_F.p3d",[0,0,0]];
_sink=createSimpleObject["A3\Structures_F\Civ\Accessories\Sink_F.p3d",[0,0,0]];
{_f pushBack _x}forEach[_cashD,_chair1,_chair2,_chair3,_chair4,_chair5,_chair6,_chair7,_chair8,_chair9,_chair10,_chair11,_chair12,_chair13,_chair14,_chair15,_chair16,_chair17,_chair18,_chair19,_chair20,_chair21,_dTable1,_dTable2,_dTable3,_dTable4,_plant,_sTable,_stool,_sign,_sink];
_b setVariable["PF",_f];

_cashD setPos(_b modelToWorld[1.33,1.68,-2.68]);
_chair1 setPos(_b modelToWorld[3.26,-1.79,-1.56]);
_chair2 setPos(_b modelToWorld[2.41,-2.6,-1.56]);
_chair3 setPos(_b modelToWorld[2.33,-3.7,-1.56]);_chair3 setDir(_dir+random -40+230);
_chair4 setPos(_b modelToWorld[1.1,-4.11,-1.56]);
_chair5 setPos(_b modelToWorld[1.1,-3.35,-1.56]);
_chair6 setPos(_b modelToWorld[1.15,-2.65,-1.56]);_chair6 setDir(_dir+random 13+90);
_chair7 setPos(_b modelToWorld[0.3,-2,-1.56]);
_chair8 setPos(_b modelToWorld[-0.55,-4.05,-1.56]);_chair8 setDir(_dir+260);
_chair9 setPos(_b modelToWorld[-0.55,-3.37,-1.56]);_chair9 setDir(_dir+279);
_chair10 setPos(_b modelToWorld[-0.585,-2.7,-1.56]);_chair10 setDir(_dir+275);
_chair13 setPos(_b modelToWorld[-1.4,-1,2.31]);
_chair14 setPos(_b modelToWorld[-0.6,-0.2,2.31]);
_chair15 setPos(_b modelToWorld[0.3,-0.2,2.31]);
_chair16 setPos(_b modelToWorld[0.5,-1.85,2.31]);_chair16 setDir(_dir+180);
_chair17 setPos(_b modelToWorld[-0.5,-1.85,2.31]);_chair17 setDir(_dir+180);
_chair18 setPos(_b modelToWorld[1.4,-1,2.31]);
_chair11 setPos(_b modelToWorld[-0.6,2.26,2.31]);
_chair12 setPos(_b modelToWorld[0.6,2.26,2.31]);
_chair19 setPos(_b modelToWorld[-4.37,-4.05,2.31]);
_chair20 setPos(_b modelToWorld[-4.37,-3.1,2.31]);
_chair21 setPos(_b modelToWorld[-5.2,-2.1,2.31]);
_dTable1 setPos(_b modelToWorld[3.26,-3.185,-1.79]);
_dTable2 setPos(_b modelToWorld[0.3,-3.43,-1.79]);
_dTable3 setPos(_b modelToWorld[0,-1,2.07]);
_dTable4 setPos(_b modelToWorld[-5.17,-3.5,2.07]);
_plant setPos(_b modelToWorld[3.53,4.3,-1.08]);_plant setDir(_dir+40);
_sign setPos(_b modelToWorld[1.3,0.65,-1.53]);
_sink setPos(_b modelToWorld[-2.94,-3.5,-1.45]);
_sTable setPos(_b modelToWorld[0,2.26,2.07]);
_stool setPos(_b modelToWorld[3.495,2.1,-2.2]);
{_x setDir _dir}forEach[_chair1,_chair7,_chair14,_chair15,_chair21,_dTable3,_stool];
{_x setDir(_dir+90)}forEach[_chair4,_chair5,_chair18,_chair12,_chair19,_chair20,_dTable1,_dTable2,_dTable4,_sink];
{_x setDir(_dir+270)}forEach[_cashD,_chair2,_chair13,_chair11,_sign,_sTable]}