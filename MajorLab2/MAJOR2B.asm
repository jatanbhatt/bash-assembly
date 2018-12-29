{\rtf1\ansi\ansicpg1252\cocoartf1671
{\fonttbl\f0\fmodern\fcharset0 Courier;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs26 \cf0 \expnd0\expndtw0\kerning0
#!/bin/bash\
\
if\'a0[\'a0$#\'a0!=\'a01\'a0]\'a0||\'a0[\'a0$#\'a0!=\'a02\'a0]\'a0||\'a0[\'a0$#\'a0!=3\'a0]\
\'a0\'a0\'a0\'a0\'a0then\
\'a0\'a0\'a0\'a0\'a0echo\'a0"wrong\'a0number\'a0of\'a0command\'a0line\'a0argunments"\
\'a0\'a0\'a0\'a0\'a0echo\'a0"Usage:\'a0Script2\'a0-Y\
\'a0\'a0\'a0\'a0\'a0or\
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0script2\'a0-Y\'a0<file1>\
\'a0\'a0\'a0\'a0\'a0or\
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0script2\'a0-Y\'a0<file1>\'a0<file2>"\
\'a0\'a0\'a0\'a0\'a0exit\
fi\
\
if\'a0[\'a0"$0"\'a0!=\'a0"-Y"\'a0]\'a0\
\'a0\'a0\'a0\'a0\'a0then\
\'a0\'a0\'a0\'a0\'a0echo\'a0"incorrect\'a0command\'a0line\'a0argument"\
\'a0\'a0\'a0\'a0\'a0echo\'a0"Usage:\'a0Script2\'a0-Y\
\'a0\'a0\'a0\'a0\'a0or\
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0script2\'a0-Y\'a0<file1>\
\'a0\'a0\'a0\'a0\'a0or\
\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0\'a0script2\'a0-Y\'a0<file1>\'a0<file2>"\
\'a0\'a0\'a0\'a0\'a0exit\
fi\
\
if\'a0[\'a0$#\'a0==\'a01\'a0]\
\'a0\'a0\'a0\'a0\'a0then\
\'a0\'a0\'a0\'a0\'a0echo\'a0"Appropriate"\
\'a0\'a0\'a0\'a0\'a0exit\
fi}