" Vim syntax file
" Language: Cascading Style Sheets
" Previous Contributor List:
" Claudio Fleiner <claudio@fleiner.com> (Maintainer)
" Yeti (Add full CSS2, HTML4 support)
" Nikolai Weibull (Add CSS2 support)
" Maintainer: Jules Wang <w.jq0722@gmail.com>
" URL: https://github.com/JulesWang/css.vim
" Last Change: 2013 July 31

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'css'
elseif exists("b:current_syntax") && b:current_syntax == "css"
  finish
endif

" Required for cssHacks
setlocal iskeyword-=_

let s:cpo_save = &cpo
set cpo&vim

syn case ignore

" All HTML4 tags
syn keyword cssTagName abbr acronym address applet area a b base
syn keyword cssTagName basefont bdo big blockquote body br button
syn keyword cssTagName caption center cite code col colgroup dd del
syn keyword cssTagName dfn dir div dl dt em fieldset font form frame
syn keyword cssTagName frameset h1 h2 h3 h4 h5 h6 head hr html img i
syn keyword cssTagName iframe img input ins isindex kbd label legend li
syn keyword cssTagName link map menu meta noframes noscript ol optgroup
syn keyword cssTagName option p param pre q s samp script select small
syn keyword cssTagName span strike strong style sub sup table tbody td
syn keyword cssTagName textarea tfoot th thead title tr tt ul u var
syn keyword cssTagName object svg

" 34 HTML5 tags
syn keyword cssTagName article aside audio bdi canvas command data
syn keyword cssTagName datalist details dialog embed figcaption figure footer
syn keyword cssTagName header hgroup keygen main mark menuitem meter nav
syn keyword cssTagName output progress rt rp ruby section
syn keyword cssTagName source summary time track video wbr

" Tags not supported in HTML5
syn keyword cssDeprecated acronym applet basefont big center dir
syn keyword cssDeprecated font frame frameset noframes strike tt

syn match cssTagName "\*"

" selectors
syn match cssSelectorOp "[,>+]"
syn match cssSelectorOp2 "[~|^$*]\?=" contained
syn region cssAttributeSelector matchgroup=cssSelectorOp start="\[" end="]" contains=cssUnicodeEscape,cssSelectorOp2,cssStringQ,cssStringQQ

" .class and #id
syn match cssClassName "\.[A-Za-z][A-Za-z0-9_-]\+"

try
syn match cssIdentifier "#[A-Za-zÀ-ÿ_@][A-Za-zÀ-ÿ0-9_@-]*"
catch /^.*/
syn match cssIdentifier "#[A-Za-z_@][A-Za-z0-9_@-]*"
endtry

" digits
syn match cssValueInteger contained "[-+]\=\d\+" contains=cssUnitDecorators
syn match cssValueNumber contained "[-+]\=\d\+\(\.\d*\)\=" contains=cssUnitDecorators
syn match cssValueLength contained "[-+]\=\d\+\(\.\d*\)\=\(%\|mm\|cm\|in\|pt\|pc\|em\|ex\|px\|rem\|dpi\|dppx\|dpcm\)" contains=cssUnitDecorators
syn match cssValueAngle contained "[-+]\=\d\+\(\.\d*\)\=\(deg\|grad\|rad\)" contains=cssUnitDecorators
syn match cssValueTime contained "+\=\d\+\(\.\d*\)\=\(ms\|s\)" contains=cssUnitDecorators
syn match cssValueFrequency contained "+\=\d\+\(\.\d*\)\=\(Hz\|kHz\)" contains=cssUnitDecorators


" @media
syn match cssMedia "@media\>" nextgroup=cssMediaType,cssMediaFeature,cssMediaBlock,cssMediaComma,cssMediaKeyword2 skipwhite skipnl
syn keyword cssMediaType contained screen print aural braile embosed handheld projection ty tv all contained skipwhite skipnl nextgroup=cssMediaFeature,cssMediaBlock
syn match cssMediaFeature /\(and\)\=\s*(.\{-})/ contained skipwhite skipnl contains=cssMediaProp,cssValueLength,cssMediaKeyword,cssValueInteger,cssMediaAttr,cssVendor nextgroup=cssMediaFeature,cssMediaBlock,cssMediaComma
syn keyword cssMediaKeyword and contained
syn keyword cssMediaKeyword2 only not contained nextgroup=cssMediaType skipwhite skipnl

syn region cssMediaBlock transparent matchgroup=cssBraces start='{' end='}' contains=css.*Attr,css.*Prop,cssComment,cssValue.*,cssColor,cssURL,cssImportant,cssError,cssStringQ,cssStringQQ,cssFunction,cssUnicodeEscape,cssVendor,cssDefinition,cssTagName,cssClassName,cssIdentifier,cssPseudoClass,cssSelectorOp,cssSelectorOp2,cssAttributeSelector
syn match cssMediaComma "," nextgroup=cssMediaType,cssMediaKeyword2 skipwhite skipnl contained

" Reference: http://www.w3.org/TR/css3-mediaqueries/
syn keyword cssMediaProp contained width height orientation monochrome scan grid
syn match cssMediaProp contained /\(\(device\)-\)\=aspect-ratio/
syn match cssMediaProp contained /\(\(max\|min\)-\)\=device-pixel-ratio/
syn match cssMediaProp contained /\(\(max\|min\)-\)\=device-\(height\|width\)/
syn match cssMediaProp contained /\(\(max\|min\)-\)\=\(height\|width\|resolution\|color\(-index\)\=\)/
syn keyword cssMediaAttr contained portrait landscape progressive interlace

" @page
syn match cssPage "@page\>" nextgroup=cssPagePseudo,cssDefinition skipwhite skipnl
syn match cssPagePseudo /:\(left\|right\|first\|\)/ nextgroup=cssDefinition contained skipwhite skipnl
syn match cssPageHeaderProp /@\(\(top\|left\|right\|bottom\)-\(left\|center\|right\|middle\|bottom\)\)\(-corner\)\=/ contained
syn keyword cssPageProp content size contained

" @keyframe
syn match cssKeyFrame "@\(-.*-\)\=keyframes\>\(\s*\<\S*\>\)\=" nextgroup=cssKeyFrameBlock contains=cssVendor skipwhite skipnl
syn region cssKeyFrameBlock contained transparent matchgroup=cssBraces start="{" end="}" contains=cssKeyFrameSelector,cssDefinition
syn match cssKeyFrameSelector /\(\d*%\|from\|to\)\=/ contained skipwhite skipnl

" @import
syn region cssInclude start=/@import\>/ end=/\ze;/ contains=cssComment,cssURL,cssUnicodeEscape,cssMediaType,cssStringQ,cssStringQQ
syn region cssInclude start=/@charset\>/ end=/\ze;/ contains=cssStringQ,cssStringQQ,cssUnicodeEscape,cssComment
syn region cssInclude start=/@namespace\>/ end=/\ze;/ contains=cssStringQ,cssStringQQ,cssUnicodeEscape,cssComment

" @font-face
" http://www.w3.org/TR/css3-fonts/#at-font-face-rule
syn match cssFontDescriptor "@font-face\>" nextgroup=cssFontDescriptorBlock skipwhite skipnl
syn region cssFontDescriptorBlock contained transparent matchgroup=cssBraces start="{" end="}" contains=cssComment,cssError,cssUnicodeEscape,cssFontProp,cssFontAttr,cssCommonAttr,cssStringQ,cssStringQQ,cssFontDescriptorProp,cssValue.*,cssFontDescriptorFunction,cssUnicodeRange,cssFontDescriptorAttr
"syn match cssFontDescriptorProp contained "\<\(unicode-range\|unit-per-em\|panose-1\|cap-height\|x-height\|definition-src\)\>"
"syn keyword cssFontDescriptorProp contained src stemv stemh slope ascent descent widths bbox baseline centerline mathline topline
syn keyword cssFontDescriptorProp contained src
syn match cssFontDescriptorProp contained "\<unicode-range\>"
syn keyword cssFontDescriptorAttr contained all
syn region cssFontDescriptorFunction contained matchgroup=cssFunctionName start="\<\(uri\|url\|local\|format\)\s*(" end=")" contains=cssStringQ,cssStringQQ oneline keepend
syn match cssUnicodeRange contained "U+[0-9A-Fa-f?]\+"
syn match cssUnicodeRange contained "U+\x\+-\x\+"

" The 16 basic color names
syn keyword cssColor contained aqua black blue fuchsia gray green lime maroon navy olive purple red silver teal yellow

" 130 more color names
syn keyword cssColor contained aliceblue antiquewhite aquamarine azure
syn keyword cssColor contained beige bisque blanchedalmond blueviolet brown burlywood
syn keyword cssColor contained cadetblue chartreuse chocolate coral cornflowerblue cornsilk crimson cyan
syn match cssColor contained /dark\(blue\|cyan\|goldenrod\|gray\|green\|grey\|khaki\)/
syn match cssColor contained /dark\(magenta\|olivegreen\|orange\|orchid\|red\|salmon\|seagreen\)/
syn match cssColor contained /darkslate\(blue\|gray\|grey\)/
syn match cssColor contained /dark\(turquoise\|violet\)/
syn keyword cssColor contained deeppink deepskyblue dimgray dimgrey dodgerblue firebrick
syn keyword cssColor contained floralwhite forestgreen gainsboro ghostwhite gold
syn keyword cssColor contained goldenrod greenyellow grey honeydew hotpink
syn keyword cssColor contained indianred indigo ivory khaki lavender lavenderblush lawngreen
syn keyword cssColor contained lemonchiffon limegreen linen magenta
syn match cssColor contained /light\(blue\|coral\|cyan\|goldenrodyellow\|gray\|green\)/
syn match cssColor contained /light\(grey\|pink\|salmon\|seagreen\|skyblue\|yellow\)/
syn match cssColor contained /light\(slategray\|slategrey\|steelblue\)/
syn match cssColor contained /medium\(aquamarine\|blue\|orchid\|purple\|seagreen\)/
syn match cssColor contained /medium\(slateblue\|springgreen\|turquoise\|violetred\)/
syn keyword cssColor contained midnightblue mintcream mistyrose moccasin navajowhite
syn keyword cssColor contained oldlace olivedrab orange orangered orchid
syn match cssColor contained /pale\(goldenrod\|green\|turquoise\|violetred\)/
syn keyword cssColor contained papayawhip peachpuff peru pink plum powderblue
syn keyword cssColor contained rosybrown royalblue saddlebrown salmon sandybrown
syn keyword cssColor contained seagreen seashell sienna skyblue slateblue
syn keyword cssColor contained slategray slategrey snow springgreen steelblue tan
syn keyword cssColor contained thistle tomato turquoise violet wheat
syn keyword cssColor contained whitesmoke yellowgreen

" FIXME: These are actually case-insentivie too, but (a) specs recommend using
" mixed-case (b) it's hard to highlight the word `Background' correctly in
" all situations
syn case match
syn keyword cssColor contained ActiveBorder ActiveCaption AppWorkspace ButtonFace ButtonHighlight ButtonShadow ButtonText CaptionText GrayText Highlight HighlightText InactiveBorder InactiveCaption InactiveCaptionText InfoBackground InfoText Menu MenuText Scrollbar ThreeDDarkShadow ThreeDFace ThreeDHighlight ThreeDLightShadow ThreeDShadow Window WindowFrame WindowText Background
syn case ignore

syn match cssImportant contained "!\s*important\>"

syn match cssColor contained "\<transparent\>"
syn match cssColor contained "\<white\>"
syn match cssColor contained "#[0-9A-Fa-f]\{3\}\>" contains=cssUnitDecorators
syn match cssColor contained "#[0-9A-Fa-f]\{6\}\>" contains=cssUnitDecorators

syn region cssURL contained matchgroup=cssFunctionName start="\<url\s*(" end=")" oneline extend
syn region cssFunction contained matchgroup=cssFunctionName start="\<\(rgb\|clip\|attr\|counter\|rect\|cubic-bezier\|steps\)\s*(" end=")" oneline contains=cssValueInteger,cssValueNumber,cssValueLength,cssFunctionComma
syn region cssFunction contained matchgroup=cssFunctionName start="\<\(rgba\|hsl\|hsla\|color-stop\|from\|to\)\s*(" end=")" oneline contains=cssColor,cssValueInteger,cssValueNumber,cssValueLength,cssFunctionComma,cssFunction
syn region cssFunction contained matchgroup=cssFunctionName start="\<\(linear-\|radial-\)\=\gradient\s*(" end=")" oneline contains=cssColor,cssValueInteger,cssValueNumber,cssValueLength,cssFunction,cssGradientAttr,cssFunctionComma
syn region cssFunction contained matchgroup=cssFunctionName start="\<\(matrix\(3d\)\=\|scale\(3d\|X\|Y\|Z\)\=\|translate\(3d\|X\|Y\|Z\)\=\|skew\(X\|Y\)\=\|rotate\(3d\|X\|Y\|Z\)\=\|perspective\)\s*(" end=")" oneline contains=cssValueInteger,cssValueNumber,cssValueLength,cssValueAngle,cssFunctionComma
syn keyword cssGradientAttr contained top bottom left right cover center middle ellipse at
syn match cssFunctionComma contained ","

" Common Prop and Attr
syn keyword cssCommonAttr contained auto none inherit all default normal
syn keyword cssCommonAttr contained top bottom center stretch hidden visible
"------------------------------------------------
" CSS Animations
" http://www.w3.org/TR/css3-animations/
syn match cssAnimationProp contained "\<animation\(-\(delay\|direction\|duration\|fill-mode\|name\|play-state\|timing-function\)\)\=\>"

" animation-direction attributes
syn keyword cssAnimationAttr contained alternate reverse
syn match cssAnimationAttr contained "\<alternate-reverse\>"

" animation-fill-mode attributes
syn keyword cssAnimationAttr contained forwards backwards both

" animation-play-state attributes
syn keyword cssAnimationAttr contained running paused
"------------------------------------------------
" CSS Backgrounds and Borders Module Level 3
" http://www.w3.org/TR/css3-background/
syn match cssBackgroundProp contained "\<background\(-\(attachment\|clip\|color\|image\|origin\|position\|repeat\|size\)\)\=\>"
" background-attachment attributes
syn keyword cssBackgroundAttr contained scroll fixed local

" background-position attributes
syn keyword cssBackgroundAttr contained left center right top bottom

" background-repeat attributes
syn match cssBackgroundAttr contained "\<no-repeat\>"
syn match cssBackgroundAttr contained "\<repeat\(-[xy]\)\=\>"
syn keyword cssBackgroundAttr contained space round

" background-size attributes
syn keyword cssBackgroundAttr contained cover contain

syn match cssBorderProp contained "\<border\(-\(top\|right\|bottom\|left\)\)\=\(-\(width\|color\|style\)\)\=\>"
syn match cssBorderProp contained "\<border\(-\(top\|bottom\)-\(left\|right\)\)\=-radius\>"
syn match cssBorderProp contained "\<border-image\(-\(outset\|repeat\|slice\|source\|width\)\)\=\>"
syn match cssBorderProp contained "\<box-decoration-break\>"
syn match cssBorderProp contained "\<box-shadow\>"

" border-image attributes
syn keyword cssBorderAttr contained stretch repeat round space fill

" border-style attributes
syn keyword cssBorderAttr contained dotted dashed solid double groove ridge inset outset

" border-width attributes
syn keyword cssBorderAttr contained thin thick medium

" box-decoration-break attributes
syn keyword cssBorderAttr contained clone slice
"------------------------------------------------

syn match cssBoxProp contained "\<padding\(-\(top\|right\|bottom\|left\)\)\=\>"
syn match cssBoxProp contained "\<margin\(-\(top\|right\|bottom\|left\)\)\=\>"
syn match cssBoxProp contained "\<overflow\(-\(x\|y\|style\)\)\=\>"
syn match cssBoxProp contained "\<rotation\(-point\)=\>"
syn keyword cssBoxAttr contained visible hidden scroll auto
syn match cssBoxAttr contained "\<no-\(display\|content\)\>"

syn keyword cssColorProp contained opacity
syn match cssColorProp contained "\<color-profile\>"
syn match cssColorProp contained "\<rendering-intent\>"


syn match cssDimensionProp contained "\<\(min\|max\)-\(width\|height\)\>"
syn keyword cssDimensionProp contained height
syn keyword cssDimensionProp contained width

" shadow and sizing are in other property groups
syn match cssFlexibleBoxProp contained "\<box-\(align\|direction\|flex\|ordinal-group\|orient\|pack\|shadow\|sizing\)\>"
syn keyword cssFlexibleBoxAttr contained start end baseline
syn keyword cssFlexibleBoxAttr contained reverse
syn keyword cssFlexibleBoxAttr contained single mulitple
syn keyword cssFlexibleBoxAttr contained horizontal
" bugfix: escape vertial-align
syn match cssFlexibleBoxAttr contained "\<vertical\(-align\)\@!\>"
syn match cssFlexibleBoxAttr contained "\<\(inline\|block\)-axis\>"

" CSS Fonts Module Level 3
" http://www.w3.org/TR/css-fonts-3/
syn match cssFontProp contained "\<font\(-\(family\|\|feature-settings\|kerning\|language-override\|size\(-adjust\)\=\|stretch\|style\|synthesis\|variant\(-\(alternates\|caps\|east-asian\|ligatures\|numeric\|position\)\)\=\|weight\)\)\=\>"
" font attributes
syn keyword cssFontAttr contained icon menu caption
syn match cssFontAttr contained "\<small\(-\(caps\|caption\)\)\=\>"
syn match cssFontAttr contained "\<message-box\>"
syn match cssFontAttr contained "\<status-bar\>"
syn match cssFontAttr contained "\<x\{1,2\}-\(large\|small\)\>"

" font-family attributes
syn match cssFontAttr contained "\<sans\>"
syn match cssFontAttr contained "\<\(sans-\)\=\<serif\>"
syn keyword cssFontAttr contained Antiqua Arial Black Book Charcoal Comic Courier Dingbats Gadget Geneva Georgia Grande Helvetica Impact Linotype Lucida MS Monaco Neue New Palatino Roboto Roman Symbol Tahoma Times Trebuchet Unicode Verdana Webdings Wingdings York Zapf
syn keyword cssFontAttr contained cursive fantasy monospace

" font-feature-settings attributes
syn keyword cssFontAttr contained on off

" font-stretch attributes
syn match cssFontAttr contained "\<\(\(ultra\|extra\|semi\)-\)\=\(condensed\|expanded\)\>"

" font-style attributes
syn keyword cssFontAttr contained italic oblique

" font-variant-caps attributes
syn match cssFontAttr contained "\<\(all-\)\=\(small-\|petite-\|titling-\)caps\>"
syn keyword cssFontAttr contained unicase

" font-weight attributes
syn keyword cssFontAttr contained bold bolder lighter
"------------------------------------------------

" Webkit specific property/attributes
syn match cssFontProp contained "\<font-smooth\>"
syn match cssFontAttr contained "\<\(subpixel-\)\=\antialiased\>"

syn keyword cssGeneratedContentProp contained quotes crop
syn match cssGeneratedContentProp contained "\<counter-\(reset\|increment\)\>"
syn match cssGeneratedContentProp contained "\<move-to\>"
syn match cssGeneratedContentProp contained "\<page-policy\>"
syn match cssGeneratedContentAttr contained "\<\(no-\)\=\(open\|close\)-quote\>"


syn match cssGridProp contained "\<grid-\(columns\|rows\)\>"

syn match cssHyerlinkProp contained "\<target\(-\(name\|new\|position\)\)\=\>"

syn match cssListProp contained "\<list-style\(-\(type\|position\|image\)\)\=\>"
syn match cssListAttr contained "\<\(lower\|upper\)-\(roman\|alpha\|greek\|latin\)\>"
syn match cssListAttr contained "\<\(hiragana\|katakana\)\(-iroha\)\=\>"
syn match cssListAttr contained "\<\(decimal\(-leading-zero\)\=\|cjk-ideographic\)\>"
syn keyword cssListAttr contained disc circle square hebrew armenian georgian
syn keyword cssListAttr contained inside outside

syn match cssMultiColumnProp contained "\<column\(-\(\break-\(after\|before\)\|count\|gap\|rule\(-\(color\|style\|width\)\)\=\)\|span\|width\)\=\>"

syn keyword cssPositioningProp contained bottom clear clip display float left
syn keyword cssPositioningProp contained position right top visibility
syn match cssPositioningProp contained "\<z-index\>"
syn keyword cssPositioningAttr contained block compact
syn match cssPositioningAttr contained "\<table\(-\(row-group\|\(header\|footer\)-group\|row\|column\(-group\)\=\|cell\|caption\)\)\=\>"
syn keyword cssPositioningAttr contained left right both
syn match cssPositioningAttr contained "\<list-item\>"
syn match cssPositioningAttr contained "\<inline\(\-block\|-box\)\=\>"
syn keyword cssPositioningAttr contained static relative absolute fixed

syn match cssPrintProp contained "\<page\(-break-\(before\|after\|inside\)\)\=\>"
syn keyword cssPrintProp contained orphans widows
syn keyword cssPrintAttr contained landscape portrait crop cross always avoid

syn match cssTableProp contained "\<\(caption-side\|table-layout\|border-collapse\|border-spacing\|empty-cells\)\>"
syn keyword cssTableAttr contained fixed collapse separate show hide once always


syn keyword cssTextProp contained color direction
syn match cssTextProp "\<\(\(word\|letter\)-spacing\|text\(-\(decoration\|transform\|align\|index\|shadow\)\)\=\|vertical-align\|unicode-bidi\|line-height\)\>"
syn match cssTextProp contained "\<text-\(justify\|outline\|warp\|align-last\|size-adjust\|rendering\|stroke\|indent\)\>"
syn match cssTextProp contained "\<word-\(break\|\wrap\)\>"
syn match cssTextProp contained "\<white-space\>"
syn match cssTextProp contained "\<hanging-punctuation\>"
syn match cssTextProp contained "\<punctuation-trim\>"
syn match cssTextAttr contained "\<line-through\>"
syn match cssTextAttr contained "\<\(text-\)\=\(top\|bottom\)\>"
syn keyword cssTextAttr contained ltr rtl embed nowrap
syn keyword cssTextAttr contained underline overline blink sub super middle
syn keyword cssTextAttr contained capitalize uppercase lowercase
syn keyword cssTextAttr contained justify baseline sub super
syn keyword cssTextAttr contained optimizeLegibility optimizeSpeed
syn match cssTextAttr contained "\<pre\(-\(line\|wrap\)\)\=\>"
syn match cssTextAttr contained "\<\(allow\|force\)-end\>"
syn keyword cssTextAttr contained start end adjacent
syn match cssTextAttr contained "\<inter-\(word\|ideographic\|cluster\)\>"
syn keyword cssTextAttr contained distribute kashida first last
syn keyword cssTextAttr contained clip ellipsis unrestricted suppress
syn match cssTextAttr contained "\<break-all\>"
syn match cssTextAttr contained "\<break-word\>"
syn keyword cssTextAttr contained hyphenate

syn match cssTransformProp contained "\<transform\(-\(origin\|style\)\)\=\>"
syn match cssTransformProp contained "\<perspective\(-origin\)\=\>"
syn match cssTransformProp contained "\<backface-visibility\>"

" CSS Transitions
" http://www.w3.org/TR/css3-transitions/
syn match cssTransitionProp contained "\<transition\(-\(delay\|duration\|property\|timing-function\)\)\=\>"

" transition-time-function attributes
syn match cssTransitionAttr contained "\<linear\(-gradient\)\@!\>"
syn match cssTransitionAttr contained "\<ease\(-\(in-out\|out\|in\)\)\=\>"
syn match cssTransitionAttr contained "\<step\(-start\|-end\)\=\>"
"------------------------------------------------
" CSS Basic User Interface Module Level 3 (CSS3 UI)
" http://www.w3.org/TR/css3-ui/
syn match cssUIProp contained "\<box-sizing\>"
syn match cssUIAttr contained "\<\(content\|padding\|border\)-box\>"

syn keyword cssUIProp contained cursor
syn match cssUIAttr contained "\<\(\([ns]\=[ew]\=\)\|col\|row\|nesw\|nwse\)-resize\>"
syn keyword cssUIAttr contained crosshair help move pointer alias copy
syn keyword cssUIAttr contained progress wait text cell move
syn match cssUIAttr contained "\<context-menu\>"
syn match cssUIAttr contained "\<no-drop\>"
syn match cssUIAttr contained "\<not-allowed\>"
syn match cssUIAttr contained "\<all-scroll\>"
syn match cssUIAttr contained "\<\(vertical-\)\=text\>"
syn match cssUIAttr contained "\<zoom\(-in\|-out\)\=\>"

syn match cssUIProp contained "\<ime-mode\>"
syn keyword cssUIAttr contained active inactive disabled

syn match cssUIProp contained "\<nav-\(down\|index\|left\|right\|up\)\=\>"
syn match cssUIProp contained "\<outline\(-\(width\|style\|color\|offset\)\)\=\>"

syn keyword cssUIProp contained icon resiz
syn keyword cssUIAttr contained both horizontal vertical

syn match cssUIProp contained "\<text-overflow\>"
syn keyword cssUIAttr contained clip ellipsis

" Already highlighted Props: font content
"------------------------------------------------
" Webkit/iOS specific attributes
syn match cssUIAttr contained '\(preserve-3d\)'
" IE specific attributes
syn match cssIEUIAttr contained '\(bicubic\)'

" Webkit/iOS specific properties
syn match cssUIProp contained '\(tap-highlight-color\|user-select\|touch-callout\)'
" IE specific properties
syn match cssIEUIProp contained '\(interpolation-mode\|zoom\|filter\)'

" Webkit/Firebox specific properties/attributes
syn keyword cssUIProp contained appearance
syn keyword cssUIAttr contained window button field icon document menu


syn match cssAuralProp contained "\<\(pause\|cue\)\(-\(before\|after\)\)\=\>"
syn match cssAuralProp contained "\<\(play-during\|speech-rate\|voice-family\|pitch\(-range\)\=\|speak\(-\(punctuation\|numerals\)\)\=\)\>"
syn keyword cssAuralProp contained volume during azimuth elevation stress richness
syn match cssAuralAttr contained "\<\(x-\)\=\(soft\|loud\)\>"
syn keyword cssAuralAttr contained silent
syn match cssAuralAttr contained "\<spell-out\>"
syn keyword cssAuralAttr contained non mix
syn match cssAuralAttr contained "\<\(left\|right\)-side\>"
syn match cssAuralAttr contained "\<\(far\|center\)-\(left\|center\|right\)\>"
syn keyword cssAuralAttr contained leftwards rightwards behind
syn keyword cssAuralAttr contained below level above higher
syn match cssAuralAttr contained "\<\(x-\)\=\(slow\|fast\)\>"
syn keyword cssAuralAttr contained faster slower
syn keyword cssAuralAttr contained male female child code digits continuous
syn match cssAuralAttr contained "\<lower\>"

" mobile text
syn match cssMobileTextProp contained "\<text-size-adjust\>"



syn match cssBraces contained "[{}]"
syn match cssError contained "{@<>"
syn region cssDefinition transparent matchgroup=cssBraces start='{' end='}' contains=cssAttrRegion,css.*Prop,cssComment,cssValue.*,cssColor,cssURL,cssImportant,cssError,cssStringQ,cssStringQQ,cssFunction,cssUnicodeEscape,cssVendor,cssDefinition,cssHacks keepend
syn match cssBraceError "}"
syn match cssAttrComma ","

" Pseudo class
syn match cssPseudoClass ":[A-Za-z0-9_-]*" contains=cssPseudoClassId,cssUnicodeEscape,cssVendor
syn keyword cssPseudoClassId link visited active hover before after left right lang
syn match cssPseudoClassId contained "\<first\(-\(line\|letter\|child\)\)\=\>"
" FIXME: handle functions.
"syn region cssPseudoClassLang matchgroup=cssPseudoClassId start="lang(" end=")"
syn match cssPseudoClassId contained "\<\(last\|only\|nth\|nth-last\)-child\>"
syn match cssPseudoClassId contained "\<\(first\|last\|only\|nth\|nth-last\)-of-type\>"
syn keyword cssPseudoClassId root empty target enable disabled checked not invalid
syn match cssPseudoClassId contained "\<selection\>"
syn match cssPseudoClassId contained "\<focus\(-inner\)\=\>"
syn match cssPseudoClassId contained "\<\(input-\)\=placeholder\>"

" Comment
syn region cssComment start="/\*" end="\*/" contains=@Spell
syn region cssComment start="//" skip="\\$" end="$" keepend contains=@Spell

syn match cssUnicodeEscape "\\\x\{1,6}\s\?"
syn match cssSpecialCharQQ +\\"+ contained
syn match cssSpecialCharQ +\\'+ contained
syn region cssStringQQ start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=cssUnicodeEscape,cssSpecialCharQQ
syn region cssStringQ start=+'+ skip=+\\\\\|\\'+ end=+'+ contains=cssUnicodeEscape,cssSpecialCharQ

" Vendor Prefix
syn match cssVendor contained "\(-\(webkit\|moz\|o\|ms\)-\)"

" Various CSS Hack characters
" In earlier versions of IE (6 and 7), one can prefix property names
" with a _ or * to isolate those definitions to particular versions of IE
" This is purely decorative and therefore we assign to the same highlight
" group to cssVendor, for more information:
" http://www.paulirish.com/2009/browser-specific-css-hacks/
syn match cssHacks contained /\(_\|*\)/

" Misc highlight groups
syntax match cssUnitDecorators /\(#\|-\|%\|mm\|cm\|in\|pt\|pc\|em\|ex\|px\|rem\|dpi\|dppx\|dpcm\|Hz\|kHz\|s\|ms\|deg\|grad\|rad\)/ contained
syntax match cssNoise contained /\(:\|;\|\/\)/

" Attr Enhance
" Some kewords are both Prop and Attr, so we have to handle them
syn region cssAttrRegion start=/:/ end=/;/ contained keepend contains=css.*Attr,cssColor,cssImportant,cssValue.*,cssFunction,cssString.*,cssURL,cssComment,cssUnicodeEscape,cssVendor,cssError,cssTransitionHackProp,cssAttrComma,cssNoise

" Hack for transition
" The 'transition' Prop has Props after ':'.
syn region cssAttrRegion start=/transition\s*:/ end=/;/ contained keepend contains=css.*Prop,css.*Attr,cssColor,cssImportant,cssValue.*,cssFunction,cssString.*,cssURL,cssComment,cssUnicodeEscape,cssVendor,cssError,cssTransitionHackProp,cssAttrComma,cssNoise


if main_syntax == "css"
  syn sync minlines=10
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_css_syn_inits")
  if version < 508
    let did_css_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink cssComment Comment
  HiLink cssVendor Comment
  HiLink cssHacks Comment
  HiLink cssTagName Statement
  HiLink cssDeprecated Error
  HiLink cssSelectorOp Special
  HiLink cssSelectorOp2 Special
  HiLink cssAttrComma Special

  HiLink cssAnimationProp cssProp
  HiLink cssBackgroundProp cssProp
  HiLink cssBorderProp cssProp
  HiLink cssBoxProp cssProp
  HiLink cssColorProp cssProp
  HiLink cssContentForPagedMediaProp cssProp
  HiLink cssDimensionProp cssProp
  HiLink cssFlexibleBoxProp cssProp
  HiLink cssFontProp cssProp
  HiLink cssGeneratedContentProp cssProp
  HiLink cssGridProp cssProp
  HiLink cssHyerlinkProp cssProp
  HiLink cssLineboxProp cssProp
  HiLink cssListProp cssProp
  HiLink cssMarqueeProp cssProp
  HiLink cssMultiColumnProp cssProp
  HiLink cssPagedMediaProp cssProp
  HiLink cssPositioningProp cssProp
  HiLink cssPrintProp cssProp
  HiLink cssRubyProp cssProp
  HiLink cssSpeechProp cssProp
  HiLink cssTableProp cssProp
  HiLink cssTextProp cssProp
  HiLink cssTransformProp cssProp
  HiLink cssTransitionProp cssProp
  HiLink cssUIProp cssProp
  HiLink cssIEUIProp cssProp
  HiLink cssAuralProp cssProp
  HiLink cssRenderProp cssProp
  HiLink cssMobileTextProp cssProp

  HiLink cssAnimationAttr cssAttr
  HiLink cssBackgroundAttr cssAttr
  HiLink cssBorderAttr cssAttr
  HiLink cssBoxAttr cssAttr
  HiLink cssContentForPagedMediaAttr cssAttr
  HiLink cssDimensionAttr cssAttr
  HiLink cssFlexibleBoxAttr cssAttr
  HiLink cssFontAttr cssAttr
  HiLink cssGeneratedContentAttr cssAttr
  HiLink cssGridAttr cssAttr
  HiLink cssHyerlinkAttr cssAttr
  HiLink cssLineboxAttr cssAttr
  HiLink cssListAttr cssAttr
  HiLink cssMarginAttr cssAttr
  HiLink cssMarqueeAttr cssAttr
  HiLink cssMultiColumnAttr cssAttr
  HiLink cssPaddingAttr cssAttr
  HiLink cssPagedMediaAttr cssAttr
  HiLink cssPositioningAttr cssAttr
  HiLink cssGradientAttr cssAttr
  HiLink cssPrintAttr cssAttr
  HiLink cssRubyAttr cssAttr
  HiLink cssSpeechAttr cssAttr
  HiLink cssTableAttr cssAttr
  HiLink cssTextAttr cssAttr
  HiLink cssTransformAttr cssAttr
  HiLink cssTransitionAttr cssAttr
  HiLink cssUIAttr cssAttr
  HiLink cssIEUIAttr cssAttr
  HiLink cssAuralAttr cssAttr
  HiLink cssRenderAttr cssAttr
  HiLink cssCommonAttr cssAttr

  HiLink cssPseudoClassId PreProc
  HiLink cssPseudoClassLang Constant
  HiLink cssValueLength Number
  HiLink cssValueInteger Number
  HiLink cssValueNumber Number
  HiLink cssValueAngle Number
  HiLink cssValueTime Number
  HiLink cssValueFrequency Number
  HiLink cssFunction Constant
  HiLink cssURL String
  HiLink cssFunctionName Function
  HiLink cssFunctionComma Function
  HiLink cssColor Constant
  HiLink cssIdentifier Function
  HiLink cssInclude Include
  HiLink cssImportant Special
  HiLink cssBraces Function
  HiLink cssBraceError Error
  HiLink cssError Error
  HiLink cssInclude Include
  HiLink cssUnicodeEscape Special
  HiLink cssStringQQ String
  HiLink cssStringQ String
  HiLink cssAttributeSelector String
  HiLink cssMedia Special
  HiLink cssMediaType Special
  HiLink cssMediaComma Normal
  HiLink cssMediaFeature Normal
  HiLink cssMediaKeyword Statement
  HiLink cssMediaKeyword2 Statement
  HiLink cssMediaProp cssProp
  HiLink cssMediaAttr cssAttr
  HiLink cssPage Special
  HiLink cssPagePseudo PreProc
  HiLink cssPageHeaderProp PreProc
  HiLink cssPageProp cssProp
  HiLink cssKeyFrame Special
  HiLink cssKeyFrameSelector Constant
  HiLink cssFontDescriptor Special
  HiLink cssFontDescriptorFunction Constant
  HiLink cssFontDescriptorProp cssProp
  HiLink cssFontDescriptorAttr cssAttr
  HiLink cssUnicodeRange Constant
  HiLink cssClassName Function
  HiLink cssProp StorageClass
  HiLink cssAttr Constant
  HiLink cssUnitDecorators Number
  HiLink cssNoise Noise
  delcommand HiLink
endif

let b:current_syntax = "css"

if main_syntax == 'css'
  unlet main_syntax
endif

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: ts=8


