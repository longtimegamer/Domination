//Land_i_Shop_01_V1_F	-	Flower shop
isNil{params["_b"];
if(isNil{_b getVariable"PF_B"})then{_b setVariable["PF_B","h2a_2"]};_f=[];_dir=getDir _b;
_bed=createSimpleObject["a3\structures_f\civ\Camping\CampingTable_F.p3d",[0,0,0]];
_blanket=createSimpleObject[(selectRandom["A3\Structures_F\Civ\Camping\Sleeping_bag_F.p3d","A3\Structures_F\Civ\Camping\Sleeping_bag_blue_F.p3d","A3\Structures_F\Civ\Camping\Sleeping_bag_brown_F.p3d"]),[0,0,0]];
_boxes=createSimpleObject["A3\Structures_F\Civ\Market\CratesShabby_F.p3d",[0,0,0]];
_cash=createSimpleObject["A3\Structures_F\Furniture\CashDesk_F.p3d",[0,0,0]];
_chair1=createSimpleObject["a3\structures_f\furniture\ChairWood_F.p3d",[0,0,0]];
_chair2=createSimpleObject["a3\structures_f\furniture\ChairWood_F.p3d",[0,0,0]];
_desk=createSimpleObject["A3\Structures_F_Heli\Furniture\OfficeTable_01_F.p3d",[0,0,0]];
_fridge=createSimpleObject["Fridge_01_closed_F",[0,0,0]];
_luggage=createSimpleObject["A3\Structures_F_EPB\Items\Luggage\LuggageHeap_01_F.p3d",[0,0,0]];
_pChair=createSimpleObject["A3\Structures_F\Furniture\ChairPlastic_F.p3d",[0,0,0]];
_pot1=createSimpleObject["a3\Props_F_Orange\Items\Decorative\FlowerPot_01_F.p3d",[0,0,0]];
_pot2=createSimpleObject["a3\Props_F_Orange\Items\Decorative\FlowerPot_01_F.p3d",[0,0,0]];
_pot3=createSimpleObject["a3\Props_F_Orange\Items\Decorative\FlowerPot_01_F.p3d",[0,0,0]];
_pot4=createSimpleObject["a3\Props_F_Orange\Items\Decorative\FlowerPot_01_F.p3d",[0,0,0]];
_pot5=createSimpleObject["a3\Props_F_Orange\Items\Decorative\FlowerPot_01_F.p3d",[0,0,0]];
_plant1=createSimpleObject["a3\Props_F_Orange\Items\Decorative\FlowerPot_01_flower_F.p3d",[0,0,0]];
_plant2=createSimpleObject["a3\Props_F_Orange\Items\Decorative\FlowerPot_01_flower_F.p3d",[0,0,0]];
_plant3=createSimpleObject["a3\Props_F_Orange\Items\Decorative\FlowerPot_01_flower_F.p3d",[0,0,0]];
_plant4=createSimpleObject["a3\Props_F_Orange\Items\Decorative\FlowerPot_01_flower_F.p3d",[0,0,0]];
_plant5=createSimpleObject["a3\Props_F_Orange\Items\Decorative\FlowerPot_01_flower_F.p3d",[0,0,0]];
_rack=createSimpleObject["A3\Structures_F\Furniture\Metal_wooden_rack_F.p3d",[0,0,0]];
_sacks1=createSimpleObject["Land_FoodSacks_01_large_brown_F",[0,0,0]];
_sacks2=createSimpleObject["A3\Structures_F\Civ\Market\Sacks_goods_F.p3d",[0,0,0]];
_shelf1=createSimpleObject["A3\Structures_F_EPB\Furniture\ShelvesWooden_F.p3d",[0,0,0]];
_shelf2=createSimpleObject["A3\Structures_F_EPB\Furniture\ShelvesWooden_F.p3d",[0,0,0]];
_shelf3=createSimpleObject["A3\Structures_F_EPB\Furniture\ShelvesWooden_F.p3d",[0,0,0]];
_shelf4=createSimpleObject["A3\Structures_F_EPB\Furniture\ShelvesWooden_F.p3d",[0,0,0]];
_trash=createSimpleObject["A3\Structures_F_Heli\Civ\Garbage\WheelieBin_01_F.p3d",[0,0,0]];
{_f pushBack _x}forEach[_bed,_blanket,_boxes,_cash,_chair1,_chair2,_desk,_fridge,_luggage,_pChair,_pot1,_pot2,_pot3,_pot4,_pot5,_plant1,_plant2,_plant3,_plant4,_plant5,_rack,_sacks1,_sacks2,_shelf1,_shelf2,_shelf3,_shelf4,_trash];
_b setVariable["PF",_f];

_bed setPos(_b modelToWorld[-2.5,1,1.55]);
_blanket setPos(_b modelToWorld[-2.5,1,1.62]);_blanket setDir(_dir+270);
_boxes setPos(_b modelToWorld[-3.42,6.53,2.61]);_boxes setDir(_dir+182);
_cash setPos(_b modelToWorld[-2,0,-2.8]);_cash setDir(_dir+270);
_chair1 setPos(_b modelToWorld[-2.8,-.3,-2.8]);_chair1 setDir(_dir+250);
_chair2 setPos(_b modelToWorld[-3.4,4.25,1.08]);_chair2 setDir(_dir+180);
_desk setPos(_b modelToWorld[-3.14,4.45,1.93]);
_fridge setPos(_b modelToWorld[1.6,2.63,2.11]);
_luggage setPos(_b modelToWorld[-2.28,3.98,2.1]);_luggage setDir(_dir+8);
_pChair setPos(_b modelToWorld[-3.2,-3.15,2.04]);_pChair setDir(_dir+(random -80+90));
_plant1 setPos(_b modelToWorld[-0.5,-2,-.235]);
_plant2 setPos(_b modelToWorld[-0.9,-2,-.235]);
_plant3 setPos(_b modelToWorld[-2.7,-2,-.235]);
_plant4 setPos(_b modelToWorld[-3.1,-2,-.235]);
_plant5 setPos(_b modelToWorld[1.75,1,-.235]);
_pot1 setPos(_b modelToWorld[-.8,-2,-1.93]);
_pot2 setPos(_b modelToWorld[-2.6,-2,-1.93]);
_pot3 setPos(_b modelToWorld[-3,-2,-2.243]);
_pot4 setPos(_b modelToWorld[1.75,-0.7,-1.59]);
_pot5 setPos(_b modelToWorld[1.75,-0.3,-1.93]);
_rack setPos(_b modelToWorld[1.7,4.27,3.08]);
_sacks1 setPos(_b modelToWorld[-3,6.25,-1.85]);
_sacks2 setPos(_b modelToWorld[-3.2,3.5,-1.8]);
_shelf1 setPos(_b modelToWorld[-.8,-2,-1.8]);
_shelf2 setPos(_b modelToWorld[-2.8,-2,-1.8]);_shelf2 setDir(_dir+270);
_shelf3 setPos(_b modelToWorld[1.75,-.5,-1.8]);
_shelf4 setPos(_b modelToWorld[1.75,1,-1.8]);
_trash setPos(_b modelToWorld[3.4,4.38,-1.76]);_trash setDir(_dir-8);
{_x setDir _dir}forEach[_bed,_desk,_sacks1,_shelf3,_shelf4];
{_x setDir(random 359)}forEach[_plant1,_plant2,_plant3,_plant4,_plant5,_pot1,_pot2,_pot3,_pot4,_pot5];
{_x setDir(_dir+90)}forEach[_fridge,_rack,_sacks2,_shelf1]}