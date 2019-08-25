int getColorHexFromStr(String colorStr) {
  colorStr = "FF" + colorStr;
  colorStr = colorStr.replaceAll("#", "");
  int val = 0;
  int len = colorStr.length;
  for (int i = 0; i < len; i++) {
    int hexDigit = colorStr.codeUnitAt(i);
    if (hexDigit >= 48 && hexDigit <= 57) {
      val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 65 && hexDigit <= 70) {
      // A..F
      val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 97 && hexDigit <= 102) {
      // a..f
      val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
    } else {
      throw new FormatException("An error occurred when converting a color");
    }
  }
  return val;
}

const PRIMARY_COLOR = "#606BA1";
const TEXT_COLOR_BLACK = "#515151";
const ICONS_COLOR = "#9f9f9f";

const TEXT_COLOR_ORANGE = "#FFC400";
const COLOR_BACKGROUND = "#FAFAFA";
const DISABLED_GREY = "#D3D3D3";
const REMOVE_ITEM_COLOR = "#ff0000";


const BLACK = "#000000";
const WHITE = "#FFFFFF";


//Theme colors
const THEME_COLOR_RED = "#6e2142";
const THEME_COLOR_BLUE = "#241663";
const THEME_COLOR_GREEN = "#207561";
const THEME_COLOR_YELLOW = "#560d0d";
const THEME_COLOR_DARK = "#252525";



const COLOR_NORMAL = "#3c763d";
const COLOR_DANGER = "#8B0000";
const COLOR_WARNING = "#FF8C00";

const COLOR_GOOD = "#008000";
const COLOR_BETTER = "#228B22";
const COLOR_BEST = "#006400";