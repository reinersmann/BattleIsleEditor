# BattleIsleEditor
Map editors for Battle Isle, History Line and data disks. Platform: Amiga (Motorola 68k assembly language)

The editors have been written about 30 years ago in assembly language on an Amiga 500 and later Amiga 4000.<br>
The source code is neither documented nor commented.<br>
It was my first (and last) program written in this languange so do not expect anything too fancy :-)<br>
On the bright side: the program still works for example in WinUAE!<br>
<br>
The GUI texts and manuals are written in German.

The contents of the repository are as follows:
<code>
.
├── Make                    Simple make file to assemble and link asm source files using A68K and BLINK (not included)
├── bin                     
│   ├── BIEd16              Battle Isle Editor v1.6
│   ├── BIEdDD112           Battle Isle Data Disk 1 Editor v1.2
│   ├── BIEdDD211           Battle Isle Data Disk 2 Editor v1.1
│   ├── BIEdDD211_512K      Battle Isle Data Disk 2 Editor v1.1 - runs on systems with only 512k chip mem
│   ├── HLEd12              History Line Editor v1.2
│   └── HLEd12_512K         History Line Editor v1.2 - runs on systems with only 512k chip mem
├── dstribution             
│   └── Editoren.7z         Package containing all necessary files to run the editors
├── manual                  
│   ├── Anleitung.ascii     German manual (ascii format)
│   ├── Anleitung.guide     German manual (Amiga guide format)
│   └── Zu BI & DD1         German additional information regarding data disk 1
└── source                  Source code in assembly language
    ├── BIEd16.asm          Battle Isle Editor v1.6
    ├── BIEdDD112.asm       Battle Isle Data Disk 1 Editor v1.2
    ├── BIEdDD211_512K.asm  Battle Isle Data Disk 2 Editor v1.1
    ├── BIEdDD211.asm       Battle Isle Data Disk 2 Editor v1.1 - runs on systems with only 512k chip mem
    ├── HLEd12_512K.asm     History Line Editor v1.2
    └── HLEd12.asm          History Line Editor v1.2 - runs on systems with only 512k chip mem
</code>
