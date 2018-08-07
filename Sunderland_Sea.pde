import org.gicentre.utils.move.Ease;
import org.gicentre.handy.HandyRenderer;

/**************************************** SETTINGS ****************************************/
//set colours for the elements (R, G, B)
final color LAND = color(204, 235, 197);
final color SAND = color(255, 255, 204);
final color SEA = color(179, 205, 227);
final color POI = color(206, 76, 52);
final color ROAD = color(126);
final color OUTLINE = color(66);

//parameters for sketchy rendering
final float PENCIL_WIDTH = 0.5;
final float PENCIL_GAP = 1;

//set radius IN PIXELS for POI ellipse
final int POI_RAD = 30;

//name of the font to load (needs to be stored in data directory)
final String FONT_STRING = "MarkerFelt-Thin-48.vlw";

//the linear equivalent of the cubic interpolation at each step 
final float INCREMENT = 0.01;  //smaller = slower transition

//if true, the setch will output a tiff image each frame for making a movie
final boolean SHOOT_VIDEO = true;

/******************************************************************************************/

//custom renderer
HandyRenderer h;

//coordinate lists for target geometries
ArrayList<PVector> tideIn = new ArrayList<PVector>();
ArrayList<PVector> tideOut = new ArrayList<PVector>();

//coordinate list for the intermediate geometry as we lerp between the above
ArrayList<PVector> morph = new ArrayList<PVector>();

//coordinate list for the roads
ArrayList<ArrayList<PVector>> roads = new ArrayList<ArrayList<PVector>>();

//list of POIs
POI[] pois;

//the lerp controller and increment
float t, tInc;

//the geographical extent of the map (in OSGB Coordinates)
PVector tlCorner, brCorner; 

//initialise variable to hold the font 
PFont font;

/**
 * Setup sketch
 */
void setup() {

  //setup sketch
  size(1000, 700);
  //frameRate(6);

  //set geographical extent
  tlCorner = new PVector(339685, 459485);
  brCorner = new PVector(346440, 454839);

  //initialise t
  t = 0;

  //set lerp increment
  tInc = INCREMENT;

  //initialise handy renderer
  h = new HandyRenderer(this);

  //load the font
  font = loadFont(FONT_STRING);

  //load the geometry for the sea (as this is what moves)
  String[] coordPairs = split("339629.386613684 459758.914990984,339755.849719804 459615.010098525,339891.034794194 459453.661064001,340013.137170985 459340.281126072,340148.32178851 459244.344062236,340279.145744051 459161.489684398,340362.000777737 459104.800068624,340440.495136758 458952.172421012,340492.825462365 458816.989148934,340588.762331011 458812.628646964,340789.358292858 458856.237141787,340955.069267906 458638.198694491,341016.120761808 458468.127992671,341031.122286083 458316.434091328,341043.936044319 458186.871463458,341059.77776207 458026.700348489,341081.480431125 457807.284856361,341094.617810863 457674.465557562,341153.624878943 457522.730484711,341216.720929057 457360.48954607,341251.607589509 457255.830854073,341312.658890741 457168.615395593,341391.153135412 457133.729412048,341539.420185275 457029.071139073,341635.357824645 456924.412672686,341757.460233734 456802.311166168,341805.429015332 456741.261006984,341862.118519137 456662.766987523,341974.784181662 456530.169616711,342045.273409726 456418.563219641,342093.242620628 456335.709149886,342140.906106641 456200.342036209,342172.760030268 456109.879545303,342202.263091667 456026.093221141,342263.314779675 455834.218941612,342315.644705877 455694.674040341,342333.088326163 455563.850578553,342298.20243923 455459.191628635,342280.759656907 455363.25431159,342341.81076477 455328.368263532,342402.861260284 455459.192015395,342524.962895889 455546.408150792,342612.178225576 455642.345725687,342629.620782273 455799.334021659,342664.506508035 455947.600813672,342690.670633135 456104.58914187,342612.176066105 456226.690809609,342551.124797075 456305.184699725,342533.681402379 456374.957182589,342612.175260304 456444.730020013,342586.010168254 456549.388744303,342568.566676854 456645.325932407,342586.009330198 456776.149523106,342542.401198 456854.643477673,342516.235977006 456994.188475611,342533.678662569 457116.290497886,342647.05876191 457194.785032676,342795.325134928 457273.279696418,342899.983730318 457334.331062154,342987.198995455 457447.711773918,343004.641809936 457534.927522545,342926.147242855 457657.029190225,342987.197899427 457744.245100035,342987.197512587 457848.903921014,343013.361798763 457962.284407119,343091.855850061 457979.727834094,343266.287476352 457909.955931536,343336.060765168 457709.360115879,343414.555654636 457500.042764029,343588.987474372 457377.941450938,343623.873973714 457316.890600966,343588.98808686 457212.23165101,343562.824251957 456976.749207023,343571.546174966 456880.811986664,343676.205221682 456819.761394568,343789.585578943 456828.483382055,343902.965355967 456994.193601081,344025.066927058 457098.852873424,344103.560946158 457125.017868819,344216.941303428 457133.739856328,344312.878781748 457072.689232003,344461.145638382 457020.360369524,344609.412527261 456959.309938624,344775.122553001 456898.259572194,344905.9461761 456872.095350498,345028.047972879 456915.703643942,345106.54176634 457002.919618305,345150.149189378 457116.300168986,345202.477922928 457299.453299282,345254.806688704 457473.884861157,345315.857151853 457613.430181587,345376.907614994 457752.975502018,345403.071965626 457848.912851381,345368.185208312 457979.736248731,345403.069998905 458380.928525064,345429.233382234 458738.512927032,345472.840257051 459000.160140855,345568.775929732 459427.51734812,345403.064872112 459767.657903782,345690.876694572 459750.215831091,345751.928447445 459540.89841475,345786.815495036 459331.580901654,345769.373099821 459130.984763494,345751.930704593 458930.388625327,345751.931284984 458773.400393751,345751.931833123 458625.133730594,345725.767772706 458450.702265435,345708.325345189 458258.827695673,345708.326151237 458040.788485128,345743.212811841 457936.12979303,345743.213521145 457744.255287737,345690.884723153 457578.545294257,345629.834356724 457412.835268539,345603.670296232 457238.403803361,345490.290229067 457151.187700012,345464.126136318 456985.477803258,345499.012958076 456837.211269021,345533.899554166 456749.99571374,345568.786440392 456584.286042643,345647.280943095 456479.627511697,345603.67355227 456357.525392565,345499.015214673 456226.701479355,345368.192075077 456122.04217471,345167.596194641 456069.712022729,344914.670710239 456069.711087883,344644.301831128 456139.482635958,344548.364062683 456279.027376117,344382.65416589 456305.191468902,344190.779434894 456366.241738665,343981.461953876 456322.633122919,343833.195741938 456200.530617049,343728.537372116 456078.428272363,343702.373118104 455956.326217788,343606.436284461 455842.945473765,343458.169846879 455781.893946868,343370.954420496 455712.121077189,343275.017457919 455633.626606864,343152.91579007 455555.132039847,343100.586830758 455433.029888595,343056.979568782 455276.041495899,343056.980181143 455110.331695933,343109.310107353 454970.786794602,343091.867518394 454822.520067008,339646.847992712 454822.507337442,339629.386613684 459758.914990984", ',');
  for (String c : coordPairs) { 
    String[] d = split(c, " ");
    PVector p = geoToScreen(new PVector(parseInt(d[0]), parseInt(d[1])));
    tideIn.add(p);
    morph.add(p);
  }
  coordPairs = split("339638.108697879 459619.369928777,339734.046433907 459488.546757343,339838.705673873 459375.166754944,339978.251155241 459270.508449889,340100.353596506 459139.685375137,340222.455908832 459043.748573998,340309.671721874 459008.862622743,340353.280079696 458869.317689434,340414.331574337 458729.772820591,340571.320031381 458668.722421995,340745.751270668 458703.609340352,340850.410542909 458581.507769485,340920.183541504 458459.406069662,340876.576311907 458293.696108729,340771.918006707 458154.150627374,340719.589208677 457988.440634209,340745.754751983 457761.679952289,340728.312388743 457552.362246009,340667.261957797 457404.095357426,340632.376489934 457186.056018266,340658.541710873 457046.511020409,340789.36568832 456924.409546148,340824.252413208 456802.307717331,340867.86083543 456645.319647097,340972.520365475 456453.445528821,341085.90114164 456348.787126881,341094.623000123 456270.293043403,340841.697806118 456191.797993027,340867.863155938 456017.366721484,340963.800537432 455982.480802358,341042.295072151 455869.100703062,341051.017059534 455755.720345928,341129.511304201 455720.834362334,341059.739240278 455590.010578313,341103.347533549 455467.908781669,340998.690001603 455119.045658403,341164.400091585 455040.55215499,341312.666722477 455049.274271266,341443.490023177 455110.325733581,341504.540744296 455180.098506494,341626.642218756 455310.922483914,341792.352050957 455302.201527843,341940.618617414 455328.366780981,341992.947576738 455450.46893218,342097.605849889 455598.735982003,342184.821534093 455598.736304305,342219.708420129 455433.026633316,342210.987625194 455223.708959088,342324.368111357 455197.544672817,342481.355666141 455380.698189712,342572.931314334 455489.718015615,342681.950621928 455616.181027767,342741.891228118 455776.017899665,342795.330268836 455934.519109664,342804.050796989 456165.640539813,342750.977599167 456295.373278268,342725.555972094 456357.514754882,342741.459618955 456424.306390747,342754.602846616 456479.507256898,342761.099460787 456506.792975741,342769.163137314 456540.667852793,342795.132538294 456557.192062205,342855.093739691 456595.348270432,342903.678516173 456626.2663272,342961.037191307 456662.770519771,342993.775039958 456686.577856308,343052.356744994 456729.181630654,343075.590691924 456746.07974951,343152.911180831 456802.316323603,343271.698332803 456860.423906005,343344.785395994 456880.811148533,343395.139581541 456852.0368488,343430.770433663 456831.676157898,343487.117502912 456799.478417609,343527.938719673 456776.153004466,343658.761962082 456741.267318325,343798.784334719 456751.262623075,343946.573939503 456793.597688632,344033.789172439 456915.69996886,344129.726102739 457002.916007661,344216.942044867 456933.143782679,344304.563088841 456927.987819507,344456.784893133 456915.701633272,344587.974082893 456879.021158854,344757.645423765 456831.587407561,344905.94661261 456802.322718431,345062.934536721 456837.209657095,345160.456805656 456965.757232297,345254.80810721 457090.135850591,345280.971774177 457308.174828776,345313.302637429 457464.436370669,345359.465256815 457604.708956267,345420.460724807 457743.332307091,345442.319060532 457857.634809417,345424.87514152 458010.261729823,345437.956548972 458376.568075416,345477.203247028 458734.15272305,345512.086739608 459000.159921704,345612.383655436 459418.795764152,345472.837419495 459767.658161753,345638.547187291 459776.380342864,345708.32063757 459532.176685099,345746.398518712 459342.326314339,345713.647404224 459147.727912634,345690.879930038 458926.027770626,345682.158960825 458764.678633128,345677.798573493 458629.494336857,345664.7172074 458446.341498862,345655.995870149 458276.270639059,345647.275172252 458040.78825943,345682.161865096 457927.407998913,345690.883884898 457805.306073242,345638.555054669 457648.317648189,345603.669319236 457460.803511429,345542.619551666 457295.093732935,345437.96068955 457186.073780264,345411.796919183 456933.148199287,345403.075866562 456793.603072279,345354.438479929 456740.910264412,345298.417464519 456680.22229592,345185.579297412 456656.712318412,345089.099983452 456636.613680096,344989.237728858 456600.29803625,344897.225735957 456566.840423497,344788.238099451 456546.76024798,344683.923720677 456527.543774954,344565.806361418 456505.788219545,344365.352742557 456474.464522383,344182.056969267 456431.653898205,343981.461728237 456383.684101855,343754.701497188 456235.416600617,343676.20783264 456113.31435264,343545.384757544 455991.211911261,343510.498838405 455895.274529717,343344.789296214 455825.50136994,343287.111657356 455767.821232231,343222.68778953 455703.39896082,343083.143145993 455581.29648725,343004.649513643 455450.472670888,342891.269800971 455267.3193151,342856.384581948 455075.444947026,342852.440642885 454964.985551897,342847.663570297 454831.240733007,339646.847992712 454822.507337442,339638.108697879 459619.369928777", ',');
  for (String c : coordPairs) { 
    String[] d = split(c, " ");
    tideOut.add(geoToScreen(new PVector(parseInt(d[0]), parseInt(d[1]))));
  }

  //load road data
  String[] roadStrings = new String[] {
    "344432.973765086 456066.9529707,344819.629088939 456066.9529707,345164.857056664 456066.9529707,345468.657668263 456053.143851991,345717.221805025 456011.716495864,346007.213297915 455970.289139737,346241.968315969 455887.434427483", 
    "347222.415744309 459823.033259555,346960.042488838 459436.377935703,346863.378657875 459063.531730559,346739.096589494 458635.449050579,346683.860114657 458304.030201562,346573.387164985 457972.611352546,346462.914215313 457447.864841603,346421.486859186 457102.636873877,346338.632146932 456757.408906151,346255.777434678 456398.371819717,346255.777434678 456094.571208118,346255.777434678 455790.770596519,346172.922722423 455500.77910363,345965.785941788 455031.269067523,345951.976823079 454810.323168178", 
    "342485.888027113 455942.670902319,342651.597451621 456412.180938426,342775.879520002 456646.935956479,342913.970707093 456950.736568078,343024.443656765 457157.873348713,343162.534843855 457295.964535803,343355.862505782 457641.192503529,343535.381048999 457862.138402874,343673.472236089 458069.275183509", 
    "343673.472236089 458069.275183509,343852.990779307 458497.357863489,344046.318441233 458870.204068633,344073.936678651 459298.286748612,344115.364034778 459684.942072465,344101.554916069 459850.651496974", 
    "343673.472236089 458069.275183509,343383.4807432 458193.55725189,343038.252775474 458400.694032526,342748.261282584 458538.785219616,342541.124501949 458607.830813161,342333.987721314 458759.73111896", 
    "342320.178602605 458759.73111896,342679.215689039 459146.386442813,342872.543350966 459243.050273776,343079.680131601 459505.423529248,343328.244268364 459795.415022137,343466.335455454 460016.360921482", 
  }; 

  //parse roads
  for (int i = 0; i < roadStrings.length; i++) {
    roads.add(new ArrayList<PVector>());
    coordPairs = split(roadStrings[i], ',');
    for (String c : coordPairs) { 
      String[] d = split(c, " ");
      roads.get(i).add(geoToScreen(new PVector(parseInt(d[0]), parseInt(d[1]))));
    }
  }

  //load points of interest
  pois = new POI[] {
    new POI(343689, 458053, "Overton"), 
    new POI(342331, 458749, "Middleton"), 
    new POI(344436, 456052, "Glasson"), 
    new POI(342507, 455941, "Sunderland")
  };
}


/**
 * run a single frame for the animation
 */
void draw() {

  //clear image
  background(255);

  // oscillate t between 0 and 1.
  if (t<=0.1) { 
    tInc = abs(tInc);
  } else if (t >=1) { 
    tInc = -abs(tInc);
  }

  //loop through each vertex
  for (int i = 0; i < min (tideIn.size(), tideOut.size()); i++) {

    //calculate the lerp increment using cubic function (more attractive movement) and move vertex
    float inc = Ease.cubicBoth(t);
    morph.set(i, new PVector(lerp(tideOut.get(i).x, tideIn.get(i).x, inc), 
      lerp(tideOut.get(i).y, tideIn.get(i).y, inc)));
  }

  //set styles for and draw the land
  noStroke();
  fill(LAND);
  h.setFillGap(PENCIL_GAP);
  h.setFillWeight(PENCIL_WIDTH);
  h.setHachureAngle(45);
  h.rect(0, 0, width, height);

  //set styles for and draw the sand
  stroke(OUTLINE);
  strokeWeight(1);
  fill(SAND);
  h.beginShape();
  for (PVector v : tideIn) {
    h.vertex(v.x, v.y);
  }
  h.endShape(CLOSE);

  //set styles for the sea
  fill(SEA);
  h.setHachureAngle(-45);

  //draw the result of the cubic interpolation for the sea
  h.beginShape();
  for (PVector v : morph) {
    h.vertex(v.x, v.y);
  }
  h.endShape(CLOSE);
  
  //draw the roads
  stroke(ROAD);
  strokeWeight(0.6);
  for (int i=0; i < roads.size(); i++) {
    PVector[] r = roads.get(i).toArray(new PVector[roads.get(i).size()]);
    for (int j=0; j < r.length-1; j++) {
      h.line(r[j].x, r[j].y, r[j+1].x, r[j+1].y);
    }
  }

  //set styles for and draw the points of interest
  stroke(OUTLINE);
  strokeWeight(0.5);
  for (POI poi : pois) {

    //draw ellipse
    fill(POI);
    PVector loc = geoToScreen(poi.getVector()); 
    h.ellipse(loc.x, loc.y, POI_RAD, POI_RAD);

    //add label
    fill(0);
    textFont(font, 18);
    textAlign(LEFT, CENTER);
    text(poi.name, loc.x + POI_RAD * 0.8, loc.y);
  }

  //add title
  fill(0);
  textFont(font, 48);
  textAlign(CENTER, BASELINE);
  text("Tracing Tides", width/2, 50);

  //increment t for cubic interpolation
  t += tInc;
  
  //save frame for making a video if set to do so
  if (SHOOT_VIDEO){
    saveFrame("frame/######.tif");
  }
}

/**
 * Convert from OSGB coordinates to screen coordinates
 */
PVector geoToScreen(PVector geo) {

  //use built in map function to map between the stated geographical extents and screen coordinates 
  return new PVector(map(geo.x, tlCorner.x, brCorner.x, 0, width), 
    map(geo.y, tlCorner.y, brCorner.y, 0, height));
}
