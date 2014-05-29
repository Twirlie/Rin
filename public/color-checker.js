var data = herp;
var vocaloids = [
  {'name': ['Hatsune Miku', '初音ミク'], color: 'DeepSkyBlue'},
  {'name': ['Gumi', 'GUMI', 'Megpoid'], color: 'LimeGreen'},
  {'name': ['Yuzuki Yukari', '結月ゆかり'], color: 'MediumPurple'},
  {'name': ['Kagamine Rin', '鏡音リン'], color: 'Khaki'},
  {'name': ['Kagamine Len', '鏡音レン'], color: 'Khaki'},
  {'name': ['Megurine Luka', '巡音ルカ'], color: 'pink'},
  {'name': ['IA'], color: 'Snow'},
  {'name': ['Kaito', 'KAITO'], color: 'MidnightBlue'},
  {'name': ['Meiko', 'MEIKO'], color: 'DarkRed'},
  {'name': ['Kasane Teto', '重音テト'], color: 'LightPink'}
];
for(var i = 0; i < vocaloids.length; i++) {
  if(getName(i)) {
    document.body.style.backgroundColor = vocaloids[i].color;
    console.log('changing color to: ' + vocaloids[i].color);
  }
}

function getName(i) {
  for(var x = 0; x < vocaloids[i].name.length; x++) {
    console.log(vocaloids[i].name[x]);
    if(S(data.title).include(vocaloids[i].name[x])) {
      return true;
    } else if(x===vocaloids[i].name.length) {
      console.log('nothing to change');
      return false;
    }
  }
}