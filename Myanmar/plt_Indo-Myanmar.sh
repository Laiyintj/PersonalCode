#!/bin/bash

gmt set MAP_FRAME_TYPE plain
gmt set GMT_AUTO_DOWNLOAD on

R=90/98/13/27
topodata=ETOPO1_Bed_g_gmt4.grd
map=../Plots/Indo-Myanmar
faultfl=gem_active_faults.gmt
#catalog=/home/postdoc/Documents/Projects/Myanmar/Data/EVENTS-INFO/catalog_table.txt
catalog=/Users/laiyin/OneDrive/Paper/Myanmar/Data/catalog_13_28_90_98.txt


gmt begin $map pdf,png
    gmt grdcut $topodata -R$R -GcutTopo.grd
    gmt grdgradient cutTopo.grd -Ne0.7 -A50 -GcutTopo_i.grd
    gmt grd2cpt cutTopo.grd -Cglobe -T-9000/9000/50 -Z -D
    #绘制底图
    gmt basemap -R$R -JM7i -Ba2f1 -BWeSn
    gmt grdimage $topodata -IcutTopo_i.grd -Q

    gmt plot PB2002_boundaries.dig.txt -W1.5p,red
    gmt plot $faultfl -W1.5p,black
    # cat $catalog | head -n 9092 | tail -n +25 | awk -F, '{print $6,$5,$11}' | gmt plot -Sc 
    cat $catalog | head -n 9092 | tail -n +25 | awk -F, '$11!=""{print $6,$5,exp($11)*0.0006}' | gmt plot -Sc -W2p,white
    cat $catalog | head -n 9092 | tail -n +25 | awk -F, '$11!=""{print $6,$5,exp($11)*0.0006}' | gmt plot -Sc -W0.6p,black
    cat $catalog | head -n 9092 | tail -n +25 | awk -F, '$11>7{print $6+0.5,$5,$10 $11}' | gmt text
    echo 93.5 19 | gmt plot -Sc0.2c -Gred
    # | gmt plot -Sc
    #绘制colorbar
    gmt colorbar -DjCB+w3i/0.15i+o0/-1i+h+m -Bxa3000f1000+l"Elevation (m)" -G-8000/9000 # o0/-1i+h to set bar location
    # 绘制主要城市
    # 96.1735 16.8409 仰光（Yangon）原首都和现最大城市，地处伊洛瓦底江三角洲，是缅甸的政治、经济、文化中心和缅甸内外海陆交通的总枢纽。
    # 16.7754° N, 94.7381° E 勃生(Pathein)是缅甸重要港市，伊洛瓦底省省会
    # 19.7633° N, 96.0785° E Naypyitaw is the modern capital of Myanmar (Burma), north of former capital, Yangon
    # 21.9588° N, 96.0891° E 曼德勒（Mandalay）全国第二大城市，中部地区经济、文化中心和交通枢纽，也是中部地区的军事重镇。
    # 21.9160° N, 95.9621° E 缅甸中部城市，实皆省首府。
    # 25.3946° N, 97.3841° E 密支那(Myitkyina) 是缅甸北部克钦邦首府，位于大约北纬28度30分。 第二次世界大战时为战略据点，是缅甸北部最重要河港、史迪威公路上的贸易中心。
    # 19°26'0"N，93°34'0"E 皎漂港 
    # gmt plot -Skcity/0.2i -W0.6p << EOF
    # 96.1735 16.8409 
    # 94.7381 16.7754 
    # 96.0785 19.7633
    # 96.0891 21.9588
    # 95.9621 21.9160
    # 97.3841 25.3946 
    # EOF
    echo 96.1735 16.8409 | gmt plot -Skcity/0.2i -W0.6p
    echo 96.1735 16.8409 Yangon | gmt text -F+f20p,37 

    echo 94.7381 16.7754 | gmt plot -Skcity/0.2i -W0.6p
    echo 94.7381 16.7754 Pathein | gmt text -F+f20p,37 

    echo 96.0785 19.7633 | gmt plot -Skcity/0.2i -W0.6p
    echo 96.0785 19.7633 Naypyitaw | gmt text -F+f20p,37

    echo 96.0891 21.9588 | gmt plot -Skcity/0.2i -W0.6p
    echo 96.0891 21.9588 Mandalay | gmt text -F+f20p,37 

    echo 95.9621 21.9160 | gmt plot -Skcity/0.2i -W0.6p
    echo 95.9621 21.9160 Sagaing | gmt text -F+f20p,37 

    echo 97.3841 25.3946 | gmt plot -Skcity/0.2i -W0.6p
    echo 97.3841 25.3946 Myitkyina | gmt text -F+f20p,37 

    echo 93.56 19.43 | gmt plot -Skcity/0.2i -W0.6p 
    echo 93.56 19.43 Kyaukpyu | gmt text -F+f20p,37
    
    # gmt text -F+f10p,37 << EOF
    # 96.17 16.84 仰光 
    # 94.73 16.77 勃生
    # 96.07 19.76 内比都
    # 96.08 21.95 曼德勒
    # 95.96 21.91 实皆
    # 97.38 25.39 密支那 
    # EOF
gmt end show
rm cutTopo*.grd
rm gmt.conf
