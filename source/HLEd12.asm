* HLEd12 - Werner Reinersmann 01.11.1993

	SECTION	Detach,CODE

StartUp
	movea.l	4,a6
	suba.l	a1,a1
	jsr	-294(a6)
	movea.l	d0,a5
	tst.l	172(a5)
	bne	CLI
	lea	92(a5),a0
	jsr	-384(a6)
	lea	92(a5),a0
	jsr	-372(a6)
	lea	WBMsg(pc),a0
	move.l	d0,(a0)
	lea	ProzTitel(pc),a0
	move.l	a0,10(a5)
	jsr	OpenLibs
	jsr	-132(a6)
	movea.l	WBMsg(pc),a1
	jsr	-378(a6)
	bra	Exit
CLI
	lea	DetDosName(pc),a1
	jsr	-408(a6)
	movea.l	d0,a4
	tst.l	d0
	beq	Exit
	jsr	-132(a6)
	moveq	#24,d0
	move.l	#$10001,d1
	jsr	-198(a6)
	movea.l	d0,a2
	tst.l	d0
	beq	CloseDosLib
	lea	ProzTitel(pc),a0
	move.l	a0,d1
	moveq	#0,d2
	lea	StartUp-4(pc),a0
	move.l	(a0),d3
	move.l	#4096,d4
	movea.l	a4,a6
	jsr	-138(a6)
	tst.l	d0
	beq	FreeMem
	movea.l	d0,a5
	lea	-92(a5),a5
	not.l	172(a5)
	movea.l	62(a5),a1
	move.l	a5,-16(a1)
	lsl.l	#2,d3
	subq.l	#4,d3
	movea.l	d3,a1
	move.w	#1,14(a2)
	move.l	a1,16(a2)
	move.l	(a1),20(a2)
	lea	74(a5),a0
	movea.l	a2,a1
	movea.l	4,a6
	jsr	-246(a6)
	lea	StartUp-4(pc),a0
	clr.l	(a0)
	bra	Exit
FreeMem
	movea.l	4,a6
	movea.l	a2,a1
	moveq	#24,d0
	jsr	-210(a6)
CloseDosLib
	movea.l	a4,a1
	jsr	-414(a6)
Exit
	jsr	-138(a6)
	moveq	#0,d0
	rts

* Var

WBMsg		ds.l	1

* Const

DetDosName	dc.b	'dos.library',0
ProzTitel	dc.b	'HLEd 1.2',0

	SECTION	Main,CODE

OpenLibs
	lea	Proz(pc),a0
	move.l	a5,(a0)
	movea.l	4,a6
	lea	LibNameTab(pc),a2
	lea	LibFehlerTab(pc),a3
	lea	DosBase(pc),a4
	moveq	#2,d2
OL_Loop
	movea.l	(a2)+,a1
	jsr	-408(a6)
	move.l	d0,(a4)+
	bne	OL_Zurueck
	movea.l	(a3),a5
	bra	CloseLibs
OL_Zurueck
	addq.l	#4,a3
	dbf	d2,OL_Loop

OpenScreen
	movea.l	IntBase(pc),a6
	lea	Schirm1(pc),a0
	move.w	20(a6),d0
	cmpi.w	#37,d0
	blt	OS_Marke1
	lea	Schirm1Tags(pc),a1
	jsr	-612(a6)
	bra	OS_Marke2
OS_Marke1
	jsr	-198(a6)
OS_Marke2
	lea	SZgr1(pc),a0
	move.l	d0,(a0)
	bne	OpenFenster
	lea	ScreenFehler(pc),a5
	bra	CloseLibs

OpenFenster
	movea.l	d0,a2
	lea	FenstTab(pc),a3
	lea	FZgr5(pc),a4
	lea	RP5(pc),a5
	moveq	#3,d2
OF_Loop
	movea.l	(a3)+,a0
	move.w	d2,d0
	lsl.b	#2,d0
	lea	TitelTab(pc),a1
	move.l	0(a1,d0.w),26(a0)
	move.l	a2,30(a0)
	jsr	-204(a6)
	move.l	d0,(a4)+
	bne	OF_Zurueck
	lea	FenstFehler(pc),a5
	bra	CloseFenster
OF_Zurueck
	movea.l	d0,a0
	move.l	50(a0),(a5)+
	dbf	d2,OF_Loop

SetMenuStrip
	lea	Menu4(pc),a1
	jsr	-264(a6)
	tst.l	d0
	bne	VorAb
	lea	MenuFehler(pc),a5
	bra	CloseFenster

VorAb
	movea.l	Proz(pc),a0
	move.l	FZgr1(pc),184(a0)
	moveq	#1,d0
	bsr	Palette

LadePfad
	lea	LPTxt(pc),a0
	movea.l	RP1(pc),a1
	moveq	#0,d0
	moveq	#34,d1
	bsr	Schreib
	lea	PfadName(pc),a0
	bsr	Untersuch
	tst.l	d0
	beq	LP_Marke1
	movea.l	d0,a0
	movea.l	RP1(pc),a1
	moveq	#0,d0
	moveq	#43,d1
	bsr	Schreib
	bra	LP_Marke3
LP_Marke1
	movea.l	DosBase(pc),a6
	move.l	a0,d1
	move.l	#$3ed,d2
	jsr	-30(a6)
	move.l	d0,d7
	bne	LP_Marke2
	lea	OpenFehler(pc),a0
	movea.l	RP1(pc),a1
	moveq	#0,d0
	moveq	#43,d1
	bsr	Schreib
	bra	LP_Marke3
LP_Marke2
	move.l	d0,d1
	lea	HLPfad(pc),a0
	move.l	a0,d2
	moveq	#32,d3
	jsr	-42(a6)
	move.l	d0,d6
	move.l	d7,d1
	jsr	-36(a6)
	tst.l	d6
	beq	LP_Marke3
	lea	Fertig(pc),a0
	movea.l	RP1(pc),a1
	moveq	#112,d0
	moveq	#34,d1
	bsr	Schreib
	bra	PfadReq
LP_Marke3
	lea	HL6(pc),a0
	lea	HLPfad(pc),a1
	bsr	StrCpy

PfadReq
	movea.l	FZgr1(pc),a3
PR_Marke1
	movea.l	IntBase(pc),a6
	lea	Req(pc),a0
	movea.l	a3,a1
	jsr	-240(a6)
	tst.l	d0
	bne	PR_WaitPort
	lea	ReqFehler(pc),a5
	bra	ClearMenuStrip
PR_WaitPort
	movea.l	4,a6
	movea.l	86(a3),a0
	jsr	-384(a6)
	movea.l	86(a3),a0
	jsr	-372(a6)
	movea.l	d0,a1
	move.l	20(a1),d2
	movea.l	28(a1),a2
	jsr	-378(a6)
	cmpi.b	#$40,d2
	bne	PR_Class_$80
	cmpi.w	#4,38(a2)
	bne	PR_Examine
	suba.l	a5,a5
	bra	ClearMenuStrip
PR_Examine
	lea	HLPfad(pc),a0
	bsr	Untersuch
	tst.l	d0
	bne	PR_Marke1
	bsr	StrLen
	cmpi.b	#':',-1(a0,d0.w)
	beq	BusyPointer
	move.b	#$2f,0(a0,d0.w)
	clr.b	1(a0,d0.w)
	bra	BusyPointer
PR_Class_$80
	cmpi.b	#$80,d2
	bne	PR_WaitPort
	movea.l	IntBase(pc),a6
	lea	Gad3(pc),a0
	movea.l	a3,a1
	lea	Req(pc),a2
	jsr	-462(a6)
	bra	PR_WaitPort

BusyPointer
	bsr	ClrScr
	movea.l	4,a6
	moveq	#72,d0
	move.l	#$10002,d1
	jsr	-198(a6)
	lea	UhrZgr(pc),a0
	move.l	d0,(a0)
	bne	BP_Marke1
	lea	AllocMemFehler(pc),a5
	bra	ClearMenuStrip
BP_Marke1
	lea	UhrDat(pc),a0
	movea.l	d0,a1
	moveq	#72,d0
	jsr	-630(a6)

VorAb2
	movea.l	GfxBase(pc),a6
	lea	ZSatz1(pc),a0
	jsr	-72(a6)
	lea	Topaz(pc),a0
	move.l	d0,(a0)
	movea.l	d0,a0
	movea.l	RP1(pc),a1
	jsr	-66(a6)
	movea.l	FZgr1(pc),a0
	bsr	SetPointer
	lea	PartsGroesse(pc),a2
	lea	PartsLib(pc),a3
	lea	PartsLibName(pc),a4
	lea	PartsLibPfad(pc),a5
	moveq	#7,d5
	bsr	Laden
	tst.l	d0
	beq	VorAb3
	suba.l	a5,a5
	bra	FreeUhrMem
VorAb3
	lea	UnitGroesse(pc),a2
	lea	UnitLib(pc),a3
	lea	UnitLibName(pc),a4
	lea	UnitLibPfad(pc),a5
	moveq	#16,d5
	bsr	Laden
	tst.l	d0
	beq	AllocListeMem
	suba.l	a5,a5
	bra	FreePartsLibMem

AllocListeMem
	movea.l	4,a6
	lea	MemListe(pc),a2
	move.w	(a2)+,d2
AllocLoop
	move.l	(a2)+,d1
	move.l	(a2)+,d0
	jsr	-198(a6)
	move.l	d0,-8(a2)
	beq	AllocListeFehler
	dbf	d2,AllocLoop
	bra	VorAb4
AllocListeFehler
	lea	AllocMemFehler(pc),a5
	bra	FreeListeMem

VorAb4
	bsr	InitParts
	bsr	InitUnits
	lea	ErstPartsI(pc),a0
	move.l	RP3(pc),-(sp)
	movea.l	Part(pc),a3
	moveq	#25,d2
	moveq	#107,d3
	moveq	#0,d7
	bsr	AllePUs
	lea	ErstPartsII(pc),a0
	move.l	RP4(pc),(sp)
	movea.l	Part(pc),a3
	moveq	#34,d2
	moveq	#66,d3
	moveq	#108,d7
	bsr	AllePUs
	lea	ErstUnits(pc),a0
	move.l	RP5(pc),(sp)
	movea.l	Unit(pc),a3
	moveq	#43,d2
	moveq	#102,d3
	moveq	#0,d7
	bsr	AllePUs
	addq.l	#4,sp
	lea	Schritt(pc),a0
	moveq	#2,d0
	move.l	d0,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	moveq	#16,d0
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	moveq	#1,d0
	move.l	d0,(a0)
	moveq	#1,d6
	bsr	Neu
	lea	SInfo1(pc),a0
	lea	Buffer1(pc),a1
	move.l	a1,(a0)
	moveq	#3,d0
	move.w	d0,10(a0)
	lea	Gad4(pc),a0
	lea	Gad6(pc),a1
	move.l	a1,(a0)
	movea.l	IntBase(pc),a6
	movea.l	FZgr1(pc),a0
	jsr	-60(a6)

WaitPort
	move.l	WUC(pc),d0
	btst.l	#0,d0
	beq	WP_Marke1
	bsr	WriteUCount
WP_Marke1
	movea.l	4,a6
	movea.l	FZgr1(pc),a4
	movea.l	86(a4),a0
	jsr	-384(a6)
	movea.l	86(a4),a0
	jsr	-372(a6)
	movea.l	d0,a1
	move.l	20(a1),d2
	move.w	24(a1),d3
	move.l	28(a1),a3
	move.w	32(a1),d4
	move.w	34(a1),d5
	jsr	-378(a6)
	lea	ClassSprung(pc),a0
	moveq	#2,d6
WP_Loop
	move.l	(a0)+,d7
	cmp.w	d2,d7
	beq	WP_Sprung
	addq.l	#4,a0
	dbf	d6,WP_Loop
	bra	WaitPort
WP_Sprung
	movea.l	(a0),a0
	jmp	(a0)

ExModus
	cmpi.b	#$68,d3
	bne	Code_$6a
	move.l	Modus(pc),d0
	beq	SetzePU
	cmpi.b	#1,d0
	beq	Fuell
	cmpi.b	#1,d0
	bgt	Zeichne
Code_$6a
	cmpi.b	#$6a,d3
	bne	WaitPort
	bra	AusXY

DateiReq
	lea	ReqTxt1(pc),a1
	move.l	a0,12(a1)
	tst.b	d0
	bne	DR_Marke1
	lea	Schreiben(pc),a0
	move.l	d0,(a0)
	lea	Lesen(pc),a0
	moveq	#1,d0
	move.l	d0,(a0)
	bra	DR_Marke2
DR_Marke1
	lea	Schreiben(pc),a0
	move.l	d0,(a0)
	lea	Lesen(pc),a0
	moveq	#0,d0
	move.l	d0,(a0)
DR_Marke2
	movea.l	IntBase(pc),a6
	lea	Req(pc),a0
	movea.l	FZgr1(pc),a1
	jsr	-240(a6)
	tst.l	d0
	bne	DR_WaitPort
	lea	ReqFehler(pc),a0
	movea.l	RP1(pc),a1
	moveq	#0,d0
	moveq	#7,d1
	bsr	Schreib
	bra	WaitPort
DR_WaitPort
	movea.l	4,a6
	movea.l	FZgr1(pc),a4
	movea.l	86(a4),a0
	jsr	-384(a6)
	movea.l	86(a4),a0
	jsr	-372(a6)
	movea.l	d0,a1
	move.l	20(a1),d2
	move.l	28(a1),a3
	jsr	-378(a6)
	cmpi.b	#$40,d2
	beq	DateiHandel
	cmpi.b	#$80,d2
	bne	DR_WaitPort
ActivateGad6
	movea.l	IntBase(pc),a6
	lea	Gad6(pc),a0
	movea.l	a4,a1
	lea	Req(pc),a2
	jsr	-462(a6)
	bra	DR_WaitPort
DateiHandel
	move.w	38(a3),d0
	cmpi.b	#4,d0
	beq	DateiAbbruch
	lea	SInfo1(pc),a0
	move.l	28(a0),d0
	bmi	DateiAbbruch
	cmpi.b	#71,d0
	bgt	DateiAbbruch
	move.l	d0,d7
	bsr	SetBusy
	move.l	Lesen(pc),d0
	beq	SicherLvl
	bra	LadeLvl
DateiAbbruch
	moveq	#0,d0
	lea	Lesen(pc),a0
	move.l	d0,(a0)
	lea	Schreiben(pc),a0
	move.l	d0,(a0)
	bra	WaitPort

MenuHandel
	move.l	d3,d4
	move.l	d4,d5
	andi.l	#31,d3
	lsr.l	#5,d4
	andi.l	#63,d4
	moveq	#11,d0
	lsr.l	d0,d5
	andi.l	#31,d5
	cmpi.b	#3,d3
	beq	Menu_3
	lea	MenuList(pc),a0
	moveq	#2,d0
MH_Loop
	cmp.l	(a0)+,d3
	beq	MH_Marke1
	adda.l	(a0),a0
	dbf	d0,MH_Loop
	bra	WaitPort
MH_Marke1
	lsl.b	#2,d4
	movea.l	4(a0,d4.w),a0
	jmp	(a0)

MItem_0_0
	bsr	Wirklich
	tst.b	d0
	beq	WaitPort
	moveq	#1,d6
	bsr	Neu
	bra	SetzBH
MItem_0_1
	lea	LvlLaden(pc),a0
	moveq	#0,d0
	bra	DateiReq
MItem_0_2
	lea	LvlSichern(pc),a0
	moveq	#1,d0
	bra	DateiReq
MItem_0_3
	bsr	Wirklich
	tst.b	d0
	beq	WaitPort
	suba.l	a5,a5
	bra	FreeListeMem
MItem_1_1
	move.l	d5,d0
	bsr	Palette
	bra	WaitPort
MItem_1_2
	moveq	#2,d0
	lsl.l	d5,d0
	lea	Schritt(pc),a0
	move.l	d0,(a0)
	bsr	NeuFTitel
	bra	WaitPort
MItem_1_3
	lea	MItem15(pc),a0
	move.w	12(a0),d0
	lsr.l	#8,d0
	andi.l	#1,d0
	lea	ZUnits(pc),a0
	move.l	d0,(a0)
	moveq	#1,d2
	bsr	Ausschnitt
	bra	WaitPort
MItem_2_0
	moveq	#2,d0
	add.l	d5,d0
	lsl.l	#3,d0
	cmpi.b	#48,d0
	ble	MH_Marke2
	move.l	y(pc),d1
	cmpi.b	#48,d1
	ble	MH_Marke2
	moveq	#48,d0
	moveq	#91,d1
	lea	SItem49(pc),a0
	move.w	d1,12(a0)
	lea	SItem50(pc),a0
	move.w	d1,12(a0)
	lea	SItem51(pc),a0
	move.w	#347,12(a0)
MH_Marke2
	lea	x(pc),a0
	move.l	d0,(a0)
	bra	CheckXY
MItem_2_1
	moveq	#2,d0
	add.l	d5,d0
	lsl.l	#3,d0
	cmpi.b	#48,d0
	ble	MH_Marke3
	move.l	x(pc),d1
	cmpi.b	#48,d1
	ble	MH_Marke3
	moveq	#48,d0
	moveq	#91,d1
	lea	SItem42(pc),a0
	move.w	d1,12(a0)
	lea	SItem43(pc),a0
	move.w	d1,12(a0)
	lea	SItem44(pc),a0
	move.w	#347,12(a0)
MH_Marke3
	lea	y(pc),a0
	move.l	d0,(a0)
	bra	CheckXY
MItem_2_4
	movea.l	FZgr3(pc),a2
	movea.l	FZgr4(pc),a3
	movea.w	#1,a5
	moveq	#0,d2
	moveq	#107,d3
	bsr	WaehlePU
	bra	WaitPort
MItem_2_5
	movea.l	FZgr4(pc),a2
	movea.l	FZgr3(pc),a3
	movea.w	#1,a5
	moveq	#0,d2
	moveq	#65,d3
	bsr	WaehlePU
	bra	WaitPort
MItem_2_6
	movea.l	FZgr5(pc),a2
	movea.l	FZgr4(pc),a3
	movea.w	#1,a5
	moveq	#1,d2
	moveq	#102,d3
	bsr	WaehlePU
	bra	WaitPort
Menu_3
	lea	Modus(pc),a0
	move.l	d4,(a0)+
	bne	MH_Marke4
	move.l	d4,(a0)
	lea	MItem12(pc),a0
	move.w	#146,12(a0)
	lea	MItem13(pc),a0
	move.w	#146,12(a0)
	lea	MItem20(pc),a0
	move.w	#86,12(a0)
	lea	MItem21(pc),a0
	move.w	#86,12(a0)
	bsr	NeuFTitel
	bra	WaitPort
MH_Marke4
	lea	MItem12(pc),a0
	move.w	#130,12(a0)
	lea	MItem13(pc),a0
	move.w	#130,12(a0)
	lea	MItem20(pc),a0
	move.w	#70,12(a0)
	lea	MItem21(pc),a0
	move.w	#70,12(a0)
	movea.l	IntBase(pc),a6
	movea.l	FZgr1(pc),a0
	lea	ModsTxtTab(pc),a1
	lsl.b	#2,d4
	movea.l	-4(a1,d4.w),a1
	lea	Titel1(pc),a2
	jsr	-276(a6)
	bra	WaitPort

TastaturHandel
	cmpi.b	#$16,d3
	bne	Code_$19
	moveq	#1,d2
	bra	Pick
Code_$19
	cmpi.b	#$19,d3
	bne	Code_$21
	moveq	#0,d2
	bra	Pick
Code_$21
	cmpi.b	#$21,d3
	bne	Code_$45
	bra	AusXY
Code_$45
	cmpi.b	#$45,d3
	bne	Code_$50
	bsr	Wirklich
	tst.b	d0
	beq	WaitPort
	suba.l	a5,a5
	bra	FreeListeMem
Code_$50
	cmpi.b	#$50,d3
	bne	Code_$59
	lea	WUC(pc),a0
	addq.l	#1,(a0)
	movea.l	GfxBase(pc),a6
	movea.l	RP1(pc),a1
	moveq	#0,d0
	jsr	-342(a6)
	movea.l	RP1(pc),a1
	moveq	#0,d0
	moveq	#0,d1
	moveq	#23,d2
	moveq	#7,d3
	jsr	-306(a6)
	bra	WaitPort
Code_$59
	cmpi.b	#$59,d3
	bne	Code_Scroll
	movea.l	FZgr3(pc),a2
	movea.l	FZgr4(pc),a3
	movea.w	#1,a5
	moveq	#0,d2
	moveq	#107,d3
	bsr	WaehlePU
	bra	WaitPort
Code_Scroll
	lea	ScrollListe(pc),a2
	moveq	#11,d0
Code_Loop
	move.l	(a2)+,d1
	cmp.b	d1,d3
	beq	ScrollKoords
	addq.l	#8,a2
	dbf	d0,Code_Loop
	bra	WaitPort

SetzePU
	bsr	CalcKxKy
SPU_Marke1
	movem.l	d4-d5,-(sp)
	moveq	#0,d0
	lea	Durch(pc),a0
	move.l	d0,(a0)
	move.l	PUNr(pc),d0
	addq.b	#1,d0
	move.l	PU(pc),d1
	bsr	FindTyp
	lea	Anzahl(pc),a0
	cmpi.b	#1,d0
	blt	SPU_Marke2
	cmpi.b	#84,0(a0,d0.w)
	beq	SPU_Ende
SPU_Marke2
	movea.l	Karte(pc),a3
	movea.l	Shop(pc),a4
	movea.l	IntBase(pc),a6
	move.l	Ay(pc),d3
	add.b	d5,d3
	lsl.w	#6,d3
	add.l	Ax(pc),d3
	add.w	d4,d3
	add.w	d3,d3
	move.l	PUNr(pc),d2
	bne	SPU_Marke15
	tst.b	d0
	bne	SPU_Marke3
	cmpi.b	#2,(a0)
	beq	SPU_Ende
	move.w	d1,d2
	subq.b	#1,d2
	move.b	d2,d6
	add.b	d2,d2
	add.b	d6,d2
	lsl.b	#2,d2
	add.b	d6,d2
	tst.b	12(a4,d2.w)
	bne	SPU_Ende
SPU_Marke3
	move.b	1(a3,d3.w),d0
	bmi	SPU_Marke8
	lsr.b	#1,d0
	cmpi.b	#27,d0
	blt	SPU_Marke4
	cmpi.b	#35,d0
	bgt	SPU_Marke4
	cmpi.w	#25,d1
	blt	SPU_Ende
	cmpi.w	#48,d1
	bgt	SPU_Ende
SPU_Marke4
	cmpi.b	#24,d0
	blt	SPU_Marke5
	cmpi.b	#26,d0
	bgt	SPU_Marke5
	cmpi.w	#85,d1
	blt	SPU_Ende
	cmpi.w	#104,d1
	bgt	SPU_Ende
SPU_Marke5
	cmpi.w	#25,d1
	blt	SPU_Marke8
	cmpi.w	#48,d1
	bgt	SPU_Marke8
	cmpi.b	#2,d0
	blt	SPU_Ende
	cmpi.b	#10,d0
	blt	SPU_Marke6
	cmpi.b	#23,d0
	blt	SPU_Ende
SPU_Marke6
	cmpi.b	#24,d0
	blt	SPU_Marke7
	cmpi.b	#27,d0
	blt	SPU_Ende
SPU_Marke7
	cmpi.b	#46,d0
	blt	SPU_Marke8
	cmpi.b	#51,d0
	blt	SPU_Ende
SPU_Marke8
	move.b	0(a3,d3.w),d1
	moveq	#1,d0
	bsr	FindTyp
	tst.b	d0
	bmi	SPU_Marke9
	bsr	Durch2
	moveq	#1,d0
	lea	Durch(pc),a0
	move.l	d0,(a0)
	bra	SPU_Marke28
SPU_Marke9
	move.l	PU(pc),d1
	moveq	#1,d0
	bsr	FindTyp
	tst.b	d0
	bmi	SPU_Marke28
	move.l	Ax(pc),d2
	add.b	d4,d2
	move.l	Ay(pc),d3
	add.b	d5,d3
	move.l	x(pc),d6
	move.l	y(pc),d7
	tst.b	d0
	bne	SPU_Marke10
	tst.b	d2
	beq	SPU_Ende
	subq.b	#2,d6
	cmp.b	d2,d6
	beq	SPU_Ende
	subq.b	#4,d7
	cmp.b	d3,d7
	blt	SPU_Ende
	lea	HQTeile2(pc),a2
	lea	HQFelder(pc),a5
	bra	SPU_Marke12
SPU_Marke10
	cmpi.b	#1,d0
	bne	SPU_Marke11
	cmpi.b	#2,d2
	blt	SPU_Ende
	subq.b	#2,d7
	andi.b	#1,d2
	mulu	d2,d7
	cmp.b	d3,d7
	beq	SPU_Ende
	lea	FBTeile2(pc),a2
	lea	FBFelder(pc),a5
	bra	SPU_Marke12
SPU_Marke11
	cmpi.b	#2,d0
	bne	SPU_Marke28
	tst.b	d2
	beq	SPU_Ende
	subq.b	#2,d6
	cmp.b	d2,d6
	beq	SPU_Ende
	subq.b	#2,d7
	cmp.b	d3,d7
	beq	SPU_Ende
	lea	DPTeile2(pc),a2
	lea	DPFelder(pc),a5
SPU_Marke12
	move.l	d4,d2
	move.l	d5,d3
	bsr	Kontakt
	tst.b	d0
	bne	SPU_Ende
	movea.l	a5,a1
	move.l	Ax(pc),d6
	add.b	d4,d6
	andi.b	#1,d6
	moveq	#0,d7
	move.b	(a2),d7
SPU_Loop
	move.l	Durch(pc),d0
	bne	SPU_Marke13
	move.l	(a1)+,d3
	mulu	d6,d3
	add.w	d5,d3
	add.l	(a1)+,d3
	move.l	(a1)+,d2
	add.w	d4,d2
	bsr	Kontakt
	tst.b	d0
	bne	SPU_Ende
	dbf	d7,SPU_Loop
	move.l	Durch(pc),d0
	beq	SPU_Marke14
SPU_Marke13
	bsr	Durch2
	bra	SPU_Marke28
SPU_Marke14
	bsr	ZSF
	bra	SPU_Marke28
SPU_Marke15
	moveq	#3,d0
	bsr	FindTyp
	tst.b	d1
	bmi	SPU_Marke17
	move.l	UCount(pc),d2
	cmpi.w	#199,d2
	bgt	SPU_Beep
	tst.b	d0
	bmi	SPU_Marke17
	cmpi.w	#199,d2
	blt	SPU_Marke16
SPU_Beep
	movea.l	SZgr1(pc),a0
	jsr	-96(a6)
	bra	SPU_Ende
SPU_Marke16
	move.l	Ay(pc),d6
	add.b	d5,d6
	move.l	y(pc),d7
	subq.b	#2,d7
	cmp.b	d6,d7
	beq	SPU_Ende
SPU_Marke17
	move.b	d0,d7
	moveq	#0,d1
	move.b	0(a3,d3.w),d1
	moveq	#1,d0
	bsr	FindTyp
	tst.b	d0
	bpl	SPU_Ende
	move.l	PU(pc),d0
	tst.b	d0
	bmi	SPU_Marke21
	lsr.b	#1,d0
	cmpi.b	#24,d0
	blt	SPU_Marke18
	cmpi.b	#26,d0
	bgt	SPU_Marke18
	cmpi.w	#85,d1
	blt	SPU_Ende
	cmpi.w	#104,d1
	bgt	SPU_Ende
SPU_Marke18
	cmpi.b	#27,d0
	blt	SPU_Marke19
	cmpi.b	#35,d0
	bgt	SPU_Marke19
	cmpi.w	#25,d1
	blt	SPU_Ende
	cmpi.w	#48,d1
	bgt	SPU_Ende
SPU_Marke19
	cmpi.w	#25,d1
	blt	SPU_Marke21
	cmpi.w	#48,d1
	bgt	SPU_Marke21
	cmpi.b	#2,d0
	blt	SPU_Ende
	cmpi.b	#10,d0
	blt	SPU_Marke20
	cmpi.b	#23,d0
	blt	SPU_Ende
SPU_Marke20
	cmpi.b	#46,d0
	blt	SPU_Marke21
	cmpi.b	#51,d0
	blt	SPU_Ende
SPU_Marke21
	moveq	#127,d2
	add.w	d3,d2
	tst.b	d7
	bmi	SPU_Marke22
	moveq	#0,d0
	move.b	1(a3,d2.w),d0
	cmpi.w	#25,d0
	blt	SPU_Ende
	cmpi.w	#48,d0
	bgt	SPU_Ende
SPU_Marke22
	move.l	Durch(pc),d0
	bne	SPU_Marke28
	tst.b	d7
	bmi	SPU_Marke25
	move.b	2(a3,d2.w),d1
	bmi	SPU_Marke25
	lea	UCount(pc),a0
	moveq	#3,d0
	bsr	FindTyp
	tst.b	d0
	bmi	SPU_Marke23
	subq.l	#2,(a0)
	cmpi.b	#8,d0
	bne	SPU_Marke28
	move.l	Ay(pc),d2
	add.b	d5,d2
	addq.b	#2,d2
	lsl.w	#6,d2
	add.l	Ax(pc),d2
	add.w	d4,d2
	add.w	d2,d2
	move.b	#255,1(a3,d2.w)
	cmpi.b	#6,d5
	bgt	SPU_Marke27
	movea.l	RP1(pc),a0
	movea.l	Part(pc),a1
	moveq	#0,d1
	move.b	0(a3,d2.w),d1
	move.w	d1,d0
	lsl.w	#2,d1
	add.w	d0,d1
	lsl.w	#2,d1
	adda.l	d1,a1
	move.l	d4,d0
	add.b	d0,d0
	add.b	d4,d0
	lsl.b	#3,d0
	add.b	d4,d0
	addi.w	#19,d0
	move.l	Ax(pc),d6
	add.b	d4,d6
	andi.b	#1,d6
	move.b	d6,d1
	add.b	d6,d6
	add.b	d1,d6
	lsl.b	#2,d6
	move.l	d5,d1
	add.b	d1,d1
	add.b	d5,d1
	lsl.b	#3,d1
	add.b	d5,d1
	add.b	d6,d1
	addi.b	#64,d1
	jsr	-114(a6)
	bra	SPU_Marke25
SPU_Marke23
	moveq	#2,d0
	bsr	FindTyp
	tst.b	d0
	bpl	SPU_Marke24
	subq.l	#1,(a0)
	bra	SPU_Marke25
SPU_Marke24
	addq.b	#1,d5
	moveq	#1,d0
	lea	Durch(pc),a0
	move.l	d0,(a0)
	lea	Aldi(pc),a0
	move.l	PU(pc),(a0)
	lea	PU(pc),a0
	move.l	#255,(a0)
	bra	SPU_Marke28
SPU_Marke25
	move.b	1(a3,d3.w),d1
	bmi	SPU_Marke28
	moveq	#3,d0
	bsr	FindTyp
	cmpi.b	#8,d0
	blt	SPU_Marke28
	bgt	SPU_Marke26
	moveq	#1,d0
	bra	SPU_Marke27
SPU_Marke26
	moveq	#-1,d0
SPU_Marke27
	lea	UCount(pc),a0
	subq.l	#1,(a0)
	move.l	Ay(pc),d3
	add.b	d5,d3
	add.b	d0,d3
	lsl.w	#6,d3
	add.l	Ax(pc),d3
	add.w	d4,d3
	add.w	d3,d3
	move.b	#255,1(a3,d3.w)
	move.l	d5,d2
	add.b	d0,d2
	bmi	SPU_Marke28
	cmpi.b	#6,d2
	bgt	SPU_Marke28
	movea.l	RP1(pc),a0
	movea.l	Part(pc),a1
	moveq	#0,d0
	move.b	0(a3,d3.w),d0
	move.w	d0,d1
	lsl.w	#2,d0
	add.w	d1,d0
	lsl.w	#2,d0
	adda.l	d0,a1
	move.l	d4,d0
	add.b	d0,d0
	add.b	d4,d0
	lsl.b	#3,d0
	add.b	d4,d0
	addi.w	#19,d0
	move.l	Ax(pc),d6
	add.b	d4,d6
	andi.b	#1,d6
	move.b	d6,d1
	add.b	d6,d6
	add.b	d1,d6
	lsl.b	#2,d6
	move.l	d2,d1
	add.b	d1,d1
	add.b	d2,d1
	lsl.b	#3,d1
	add.b	d2,d1
	add.b	d6,d1
	addi.b	#14,d1
	jsr	-114(a6)
SPU_Marke28
	move.l	Ay(pc),d3
	add.b	d5,d3
	lsl.w	#6,d3
	add.l	Ax(pc),d3
	add.w	d4,d3
	add.w	d3,d3
	move.l	PUNr(pc),d0
	move.w	d3,d2
	add.w	d0,d2
	move.b	0(a3,d2.w),d1
	cmpi.b	#255,d1
	beq	SPU_Marke32
	addq.b	#1,d0
	bsr	FindTyp
	tst.b	d0
	bmi	SPU_Marke32
	bne	SPU_Marke29
	moveq	#0,d0
	move.b	d1,d0
	subq.b	#1,d0
	move.b	d0,d1
	add.b	d0,d0
	add.b	d1,d0
	lsl.b	#2,d0
	add.b	d1,d0
	clr.b	12(a4,d0.w)
	lea	Anzahl(pc),a0
	subq.b	#1,(a0)
	lea	UCount(pc),a0
	moveq	#6,d1
SPU_Loop2
	tst.b	5(a4,d0.w)
	bmi	SPU_Zurueck
	subq.l	#1,(a0)
SPU_Zurueck
	addq.w	#1,d0
	dbf	d1,SPU_Loop2
	bra	SPU_Marke32
SPU_Marke29
	move.w	d0,d6
	bsr	SetBusy
	movea.l	x(pc),a0
	subq.w	#1,a0
	movea.w	d6,a1
	suba.w	a6,a6
	move.l	Ay(pc),d0
	add.b	d5,d0
	move.l	Ax(pc),d1
	add.b	d4,d1
	bsr	ShopNr2
	lea	Anzahl(pc),a0
	moveq	#0,d1
	move.b	0(a0,d6.w),d1
	subq.b	#1,0(a0,d6.w)
	move.w	d6,d2
	lsl.b	#2,d2
	add.b	d6,d2
	lsl.b	#2,d2
	add.b	d6,d2
	lsl.b	#2,d2
	add.w	d0,d2
	move.w	d2,d6
	add.w	d2,d2
	add.w	d6,d2
	lsl.w	#2,d2
	add.w	d6,d2
	move.w	d2,d6
	lea	UCount(pc),a0
	moveq	#6,d7
SPU_Loop3
	tst.b	5(a4,d6.w)
	bmi	SPU_Zurueck2
	subq.l	#1,(a0)
SPU_Zurueck2
	addq.w	#1,d6
	dbf	d7,SPU_Loop3
	subq.b	#2,d1
	bmi	SPU_Marke30
SPU_Loop4
	subq.b	#1,15(a4,d2.w)
	moveq	#12,d7
SPU_Loop5
	move.b	13(a4,d2.w),0(a4,d2.w)
	addq.w	#1,d2
	dbf	d7,SPU_Loop5
SPU_Marke30
	clr.b	12(a4,d2.w)
	cmp.b	d1,d0
	bge	SPU_Marke31
	addq.b	#1,d0
	bra	SPU_Loop4
SPU_Marke31
	bsr	ClearIt
SPU_Marke32
	move.l	PUNr(pc),d0
	addq.b	#1,d0
	move.l	PU(pc),d1
	cmpi.b	#255,d1
	beq	SPU_Marke35
	bsr	FindTyp
	tst.b	d0
	bmi	SPU_Marke35
	bne	SPU_Marke33
	movea.l	d1,a0
	subq.b	#1,d1
	bsr	MachShop
	lea	Anzahl(pc),a0
	addq.b	#1,(a0)
	bra	SPU_Marke35
SPU_Marke33
	move.w	d0,d6
	bsr	SetBusy
	movea.l	x(pc),a0
	subq.w	#1,a0
	movea.w	d6,a1
	suba.w	a6,a6
	move.l	Ay(pc),d0
	add.b	d5,d0
	move.l	Ax(pc),d1
	add.b	d4,d1
	bsr	ShopNr2
	addq.w	#1,d0
	lea	Anzahl(pc),a0
	moveq	#0,d1
	move.b	0(a0,d6.w),d1
	addq.b	#1,0(a0,d6.w)
	cmp.b	d1,d0
	bge	SPU_Marke34
	subq.b	#1,d1
SPU_Loop6
	move.w	d6,d2
	lsl.b	#2,d2
	add.b	d6,d2
	lsl.b	#2,d2
	add.b	d6,d2
	lsl.b	#2,d2
	add.w	d1,d2
	move.w	d2,d7
	add.w	d2,d2
	add.w	d7,d2
	lsl.w	#2,d2
	add.w	d7,d2
	addq.b	#1,2(a4,d2.w)
	moveq	#12,d7
SPU_Loop7
	move.b	0(a4,d2.w),13(a4,d2.w)
	addq.w	#1,d2
	dbf	d7,SPU_Loop7
	cmp.b	d0,d1
	beq	SPU_Marke34
	subq.b	#1,d1
	bra	SPU_Loop6
SPU_Marke34
	movea.l	PU(pc),a0
	move.w	d0,d1
	move.w	d6,d0
	bsr	MachShop
	bsr	ClearIt
SPU_Marke35
	move.l	PU(pc),d0
	move.l	PUNr(pc),d1
	add.w	d3,d1
	btst.l	#0,d1
	beq	SPU_Marke37
	lea	UCount(pc),a0
	tst.b	0(a3,d1.w)
	bmi	SPU_Marke36
	subq.l	#1,(a0)
SPU_Marke36
	tst.b	d0
	bmi	SPU_Marke37
	addq.l	#1,(a0)
SPU_Marke37
	move.b	d0,0(a3,d1.w)
	movea.l	IntBase(pc),a6
	move.l	d4,d6
	add.b	d6,d6
	add.b	d4,d6
	lsl.b	#3,d6
	add.b	d4,d6
	addi.w	#19,d6
	move.l	Ax(pc),d2
	add.b	d4,d2
	andi.b	#1,d2
	move.b	d2,d7
	add.b	d2,d2
	add.b	d7,d2
	lsl.b	#2,d2
	move.l	d5,d7
	add.b	d7,d7
	add.b	d5,d7
	lsl.b	#3,d7
	add.b	d5,d7
	add.b	d2,d7
	addi.b	#14,d7
	move.l	PUNr(pc),d0
	beq	SPU_Marke38
	moveq	#3,d0
	move.l	PU(pc),d1
	bsr	FindTyp
	tst.b	d0
	bmi	SPU_Marke38
	lea	UCount(pc),a0
	addq.l	#1,(a0)
	move.b	d1,d0
	andi.b	#1,d0
	lsl.b	#2,d0
	add.b	d0,d1
	subq.b	#2,d1
	moveq	#127,d2
	add.w	d3,d2
	move.b	d1,2(a3,d2.w)
	cmpi.b	#6,d5
	bgt	SPU_Marke38
	movea.l	RP1(pc),a0
	movea.l	Part(pc),a1
	moveq	#0,d0
	move.b	1(a3,d2.w),d0
	move.w	d0,d1
	lsl.w	#2,d0
	add.w	d1,d0
	lsl.w	#2,d0
	adda.l	d0,a1
	move.l	d6,d0
	move.l	d7,d1
	addi.w	#25,d1
	jsr	-114(a6)
	move.l	ZUnits(pc),d0
	beq	SPU_Marke38
	movea.l	RP1(pc),a0
	movea.l	Unit(pc),a1
	moveq	#0,d0
	move.b	2(a3,d2.w),d0
	move.w	d0,d1
	lsl.w	#2,d0
	add.w	d1,d0
	lsl.w	#2,d0
	adda.l	d0,a1
	move.l	d6,d0
	move.l	d7,d1
	addi.w	#25,d1
	jsr	-114(a6)
SPU_Marke38
	movea.l	RP1(pc),a0
	movea.l	Part(pc),a1
	moveq	#0,d0
	move.b	0(a3,d3.w),d0
	move.w	d0,d1
	lsl.w	#2,d0
	add.w	d1,d0
	lsl.w	#2,d0
	adda.l	d0,a1
	move.l	d6,d0
	move.l	d7,d1
	jsr	-114(a6)
	move.l	ZUnits(pc),d0
	beq	SPU_Ende
	moveq	#0,d0
	move.b	1(a3,d3.w),d0
	bmi	SPU_Ende
	movea.l	RP1(pc),a0
	movea.l	Unit(pc),a1
	move.w	d0,d1
	lsl.w	#2,d0
	add.w	d1,d0
	lsl.w	#2,d0
	adda.l	d0,a1
	move.l	d6,d0
	move.l	d7,d1
	jsr	-114(a6)
SPU_Ende
	movem.l	(sp)+,d4-d5
	move.l	Durch(pc),d0
	beq	WaitPort
	lea	PU(pc),a0
	move.l	Aldi(pc),(a0)
	bra	SPU_Marke1

Fuell
	bsr	CalcKxKy
	add.l	Ax(pc),d4
	add.l	Ay(pc),d5
	move.l	Punkt(pc),d0
	bne	FU_Marke1
	moveq	#1,d0
	lea	Punkt(pc),a0
	move.l	d0,(a0)
	lea	Px(pc),a0
	move.l	d4,(a0)
	lea	Py(pc),a0
	move.l	d5,(a0)
	bra	WaitPort
FU_Marke1
	move.l	Px(pc),d2
	cmp.b	d2,d4
	bne	FU_Marke2
	move.l	Py(pc),d3
	cmp.b	d3,d5
	beq	WaitPort
FU_Marke2
	movea.l	FZgr1(pc),a0
	bsr	SetPointer
	cmp.b	d2,d4
	bge	FU_Marke3
	exg	d2,d4
	lea	Px(pc),a0
	move.l	d2,(a0)
FU_Marke3
	move.l	Py(pc),d3
	cmp.b	d3,d5
	bge	FU_Marke4
	exg	d3,d5
	lea	Py(pc),a0
	move.l	d3,(a0)
FU_Marke4
	move.l	PU(pc),d7
	move.l	PUNr(pc),d0
	bne	FU_Marke5
	move.b	d7,d1
	moveq	#1,d0
	bsr	FindTyp
	tst.b	d0
	bmi	FU_Marke6
FU_Marke5
	clr.b	d7
FU_Marke6
	movea.l	Karte(pc),a3
	movea.l	Shop(pc),a4
	movea.l	IntBase(pc),a6
	movea.l	-112(a6),a5
	move.l	d5,d2
	sub.b	d3,d2
FU_Loop
	move.l	d4,d3
	sub.l	Px(pc),d3
FU_Marke7
	move.l	Py(pc),d5
	add.b	d2,d5
	lsl.w	#6,d5
	add.l	Px(pc),d5
	add.w	d3,d5
	add.w	d5,d5
	move.b	0(a3,d5.w),d1
	moveq	#1,d0
	bsr	FindTyp
	tst.b	d0
	bpl	FU_Zurueck
	move.b	1(a3,d5.w),d1
	moveq	#2,d0
	bsr	FindTyp
	tst.b	d0
	bpl	FU_Zurueck
	lea	UCount(pc),a0
	tst.b	d1
	bmi	FU_Marke10
	subq.l	#1,(a0)
	moveq	#3,d0
	bsr	FindTyp
	cmpi.b	#8,d0
	blt	FU_Marke10
	bne	FU_Marke8
	moveq	#1,d0
	bra	FU_Marke9
FU_Marke8
	moveq	#-1,d0
FU_Marke9
	subq.l	#1,(a0)
	move.l	d0,d1
	lsl.w	#7,d0
	add.w	d5,d0
	move.b	#255,1(a3,d0.w)
	moveq	#0,d6
	move.b	0(a3,d0.w),d6
	move.l	Px(pc),d0
	add.b	d3,d0
	sub.l	Ax(pc),d0
	blt	FU_Marke10
	cmpi.b	#10,d0
	bgt	FU_Marke10
	add.l	Py(pc),d1
	add.b	d2,d1
	sub.l	Ay(pc),d1
	blt	FU_Marke10
	cmpi.b	#7,d1
	bgt	FU_Marke10
	movea.l	RP1(pc),a0
	movea.w	d6,a1
	lsl.w	#2,d6
	add.w	a1,d6
	lsl.w	#2,d6
	movea.l	Part(pc),a1
	adda.l	d6,a1
	move.l	d0,d6
	add.b	d0,d0
	add.b	d6,d0
	lsl.b	#3,d0
	add.b	d6,d0
	addi.w	#19,d0
	add.l	Ax(pc),d6
	andi.b	#1,d6
	movea.w	d6,a2
	add.b	d6,d6
	add.w	a2,d6
	lsl.b	#2,d6
	movea.w	d1,a2
	add.b	d1,d1
	add.w	a2,d1
	lsl.b	#3,d1
	add.w	a2,d1
	add.b	d6,d1
	addi.b	#14,d1
	jsr	(a5)
FU_Marke10
	move.b	d7,0(a3,d5.w)
	move.b	#255,1(a3,d5.w)
	move.l	Px(pc),d0
	add.b	d3,d0
	sub.l	Ax(pc),d0
	blt	FU_Zurueck
	cmpi.b	#10,d0
	bgt	FU_Zurueck
	move.l	Py(pc),d1
	add.b	d2,d1
	sub.l	Ay(pc),d1
	blt	FU_Zurueck
	cmpi.b	#7,d1
	bgt	FU_Zurueck
	movea.l	RP1(pc),a0
	movea.l	Part(pc),a1
	move.w	d7,d5
	lsl.w	#2,d5
	add.w	d7,d5
	lsl.w	#2,d5
	adda.l	d5,a1
	move.l	d0,d5
	add.b	d0,d0
	add.b	d5,d0
	lsl.b	#3,d0
	add.b	d5,d0
	addi.w	#19,d0
	add.l	Ax(pc),d5
	andi.b	#1,d5
	move.b	d5,d6
	add.b	d5,d5
	add.b	d6,d5
	lsl.b	#2,d5
	move.b	d1,d6
	add.b	d1,d1
	add.b	d6,d1
	lsl.b	#3,d1
	add.b	d6,d1
	add.b	d5,d1
	addi.b	#14,d1
	jsr	(a5)
FU_Zurueck
	dbf	d3,FU_Marke7
	dbf	d2,FU_Loop
	moveq	#0,d0
	lea	Punkt(pc),a0
	move.l	d0,(a0)
	movea.l	FZgr1(pc),a0
	jsr	-60(a6)
	bra	WaitPort

Zeichne
	bsr	CalcKxKy
	add.l	Ax(pc),d4
	add.l	Ay(pc),d5
	move.l	Punkt(pc),d0
	bne	ZE_Marke1
	moveq	#1,d0
	lea	Punkt(pc),a0
	move.l	d0,(a0)
	lea	Px(pc),a0
	move.l	d4,(a0)
	lea	Py(pc),a0
	move.l	d5,(a0)
	bra	WaitPort
ZE_Marke1
	move.l	Px(pc),d2
	cmp.b	d2,d4
	bne	ZE_Marke2
	move.l	Py(pc),d3
	cmp.b	d3,d5
	beq	WaitPort
ZE_Marke2
	movea.l	FZgr1(pc),a0
	bsr	SetPointer
	lea	ModTeil(pc),a2
	move.l	Modus(pc),d0
	subq.b	#2,d0
	move.b	d0,d1
	lsl.b	#3,d0
	add.b	d1,d0
	adda.l	d0,a2
	movea.l	Karte(pc),a3
	movea.l	IntBase(pc),a6
	movea.l	-112(a6),a5
	move.l	Py(pc),d3
	moveq	#2,d6
ZE_Richtung
	cmp.b	d2,d4
	ble	ZE_Marke3
	moveq	#1,d0
	bra	ZE_Marke5
ZE_Marke3
	beq	ZE_Marke4
	moveq	#-1,d0
	bra	ZE_Marke5
ZE_Marke4
	moveq	#0,d0
ZE_Marke5
	cmp.b	d3,d5
	ble	ZE_Marke6
	moveq	#1,d1
	bra	ZE_Marke8
ZE_Marke6
	beq	ZE_Marke7
	moveq	#-1,d1
	bra	ZE_Marke8
ZE_Marke7
	moveq	#0,d1
ZE_Marke8
	cmpi.b	#2,d6
	bne	ZE_Marke9
	move.b	d0,d6
	move.l	d1,d7
ZE_Marke9
	cmp.b	d0,d6
	bne	ZE_Marke10
	cmp.b	d1,d7
	beq	ZE_Marke11
ZE_Marke10
	tst.b	d0
	bne	ZE_Marke22
	tst.b	d1
	bne	ZE_Marke22
ZE_Marke11
	cmpi.b	#1,d6
	bne	ZE_Marke12
	cmp.b	d6,d7
	beq	ZE_Marke13
ZE_Marke12
	tst.b	d6
	bpl	ZE_Marke14
	cmp.b	d6,d7
	bne	ZE_Marke14
ZE_Marke13
	move.b	(a2),d6
	bra	ZE_Marke20
ZE_Marke14
	tst.b	d7
	bne	ZE_Marke16
	btst.l	#0,d6
	beq	ZE_Marke16
	btst.l	#0,d2
	beq	ZE_Marke15
	move.b	1(a2),d6
	bra	ZE_Marke20
ZE_Marke15
	move.b	4(a2),d6
	bra	ZE_Marke20
ZE_Marke16
	tst.b	d6
	bne	ZE_Marke17
	btst.l	#0,d7
	beq	ZE_Marke17
	move.b	2(a2),d6
	bra	ZE_Marke20
ZE_Marke17
	cmpi.b	#1,d6
	bne	ZE_Marke18
	tst.b	d7
	bmi	ZE_Marke19
ZE_Marke18
	tst.b	d6
	bpl	ZE_Marke20
	cmpi.b	#1,d7
	bne	ZE_Marke20
ZE_Marke19
	move.b	3(a2),d6
ZE_Marke20
	move.b	d1,d7
	btst.l	#0,d2
	bne	ZE_Marke21
	cmpi.b	#1,d1
	bne	ZE_Marke28
	btst.l	#0,d0
	beq	ZE_Marke28
	clr.b	d1
	bra	ZE_Marke28
ZE_Marke21
	tst.b	d1
	bpl	ZE_Marke28
	btst.l	#0,d0
	beq	ZE_Marke28
	clr.b	d1
	bra	ZE_Marke28
ZE_Marke22
	tst.b	d0
	bne	ZE_Marke26
	cmpi.b	#1,d6
	bne	ZE_Marke24
	cmp.b	d6,d7
	bne	ZE_Marke23
	cmp.b	d6,d1
	bne	ZE_Marke23
	move.b	5(a2),d6
	bra	ZE_Marke27
ZE_Marke23
	tst.b	d7
	bpl	ZE_Marke27
	cmp.b	d7,d1
	bne	ZE_Marke27
	move.b	8(a2),d6
	bra	ZE_Marke27
ZE_Marke24
	tst.b	d6
	bpl	ZE_Marke27
	cmp.b	d6,d7
	bne	ZE_Marke25
	cmp.b	d6,d1
	bne	ZE_Marke25
	move.b	6(a2),d6
	bra	ZE_Marke27
ZE_Marke25
	cmpi.b	#1,d7
	bne	ZE_Marke27
	cmp.b	d7,d1
	bne	ZE_Marke27
	move.b	7(a2),d6
	bra	ZE_Marke27
ZE_Marke26
	move.w	a4,d6
ZE_Marke27
	move.b	d1,d7
ZE_Marke28
	movem.l	d0-d1/d4-d5,-(sp)
	move.b	d3,d4
	lsl.w	#6,d4
	add.w	d2,d4
	add.w	d4,d4
	move.b	0(a3,d4.w),d1
	moveq	#1,d0
	bsr	FindTyp
	tst.b	d0
	bpl	ZE_Marke32
	move.b	1(a3,d4.w),d1
	moveq	#2,d0
	bsr	FindTyp
	tst.b	d0
	bpl	ZE_Marke32
	tst.b	d1
	bmi	ZE_Marke31
	lea	UCount(pc),a0
	subq.l	#1,(a0)
	moveq	#3,d0
	bsr	FindTyp
	cmpi.b	#8,d0
	blt	ZE_Marke31
	bne	ZE_Marke29
	moveq	#1,d1
	bra	ZE_Marke30
ZE_Marke29
	moveq	#-1,d1
ZE_Marke30
	subq.l	#1,(a0)
	move.l	d1,d0
	lsl.w	#7,d0
	add.w	d4,d0
	move.b	#255,1(a3,d0.w)
	move.b	0(a3,d0.w),d5
	move.l	d2,d0
	sub.l	Ax(pc),d0
	blt	ZE_Marke31
	cmpi.b	#10,d0
	bgt	ZE_Marke31
	add.l	d3,d1
	sub.l	Ay(pc),d1
	blt	ZE_Marke31
	cmpi.b	#7,d1
	bgt	ZE_Marke31
	movea.l	RP1(pc),a0
	movea.l	Part(pc),a1
	movea.w	d5,a4
	lsl.w	#2,d5
	add.w	a4,d5
	lsl.w	#2,d5
	adda.l	d5,a1
	move.l	d0,d5
	add.b	d0,d0
	add.b	d5,d0
	lsl.b	#3,d0
	add.b	d5,d0
	addi.w	#19,d0
	move.w	d2,d5
	andi.b	#1,d5
	movea.w	d5,a4
	add.b	d5,d5
	add.w	a4,d5
	lsl.b	#2,d5
	movea.w	d1,a4
	add.b	d1,d1
	add.w	a4,d1
	lsl.b	#3,d1
	add.w	a4,d1
	add.b	d5,d1
	addi.b	#14,d1
	jsr	(a5)
ZE_Marke31
	move.b	d6,0(a3,d4.w)
	move.b	#255,1(a3,d4.w)
	move.l	d2,d0
	sub.l	Ax(pc),d0
	blt	ZE_Marke32
	cmpi.b	#10,d0
	bgt	ZE_Marke32
	move.l	d3,d1
	sub.l	Ay(pc),d1
	blt	ZE_Marke32
	cmpi.b	#7,d1
	bgt	ZE_Marke32
	movea.l	RP1(pc),a0
	movea.l	Part(pc),a1
	andi.l	#255,d6
	movea.w	d6,a4
	move.b	d6,d5
	lsl.w	#2,d6
	add.w	d5,d6
	lsl.w	#2,d6
	adda.l	d6,a1
	move.l	d0,d5
	add.b	d0,d0
	add.b	d5,d0
	lsl.b	#3,d0
	add.b	d5,d0
	addi.w	#19,d0
	move.b	d2,d5
	andi.b	#1,d5
	move.b	d5,d6
	add.b	d5,d5
	add.b	d6,d5
	lsl.b	#2,d5
	move.b	d1,d6
	add.b	d1,d1
	add.b	d6,d1
	lsl.b	#3,d1
	add.b	d6,d1
	add.b	d5,d1
	addi.b	#14,d1
	jsr	(a5)
ZE_Marke32
	movem.l	(sp)+,d0-d1/d4-d5
	add.b	d0,d2
	add.b	d1,d3
	move.l	d0,d6
	tst.b	d0
	bne	ZE_Richtung
	tst.b	d1
	bne	ZE_Richtung
	moveq	#0,d0
	lea	Punkt(pc),a0
	move.l	d0,(a0)
	movea.l	FZgr1(pc),a0
	jsr	-60(a6)
	bra	WaitPort

LadeLvl
	moveq	#0,d6
	bsr	Neu
	lea	AltAx(pc),a0
	moveq	#-1,d0
	move.l	d0,(a0)
	lea	Zahl(pc),a2
	move.w	d7,d3
	add.b	d3,d3
	add.b	d7,d3
	lea	LadenText(pc),a0
	move.b	0(a2,d3.w),11(a0)
	move.b	1(a2,d3.w),12(a0)
	movea.l	RP1(pc),a1
	moveq	#0,d0
	moveq	#7,d1
	bsr	Schreib
	lea	LadeFin(pc),a4
	lea	FinName(pc),a5
	moveq	#16,d5
	bsr	GetFile
	tst.l	d0
	bne	SetzBH
	movea.l	Karte(pc),a0
	movea.l	PartsLib(pc),a1
	lea	UCount(pc),a6
	moveq	#0,d0
	move.b	1(a1),d0
	moveq	#0,d1
	move.b	3(a1),d1
	subq.b	#1,d1
LL_Loop
	move.l	d0,d2
	subq.b	#1,d2
	move.w	d1,d3
	mulu	d0,d3
LL_Marke1
	move.w	d3,d4
	add.w	d2,d4
	add.w	d4,d4
	move.w	d1,d5
	lsl.w	#6,d5
	add.w	d2,d5
	add.w	d5,d5
	move.b	4(a1,d4.w),0(a0,d5.w)
	move.b	5(a1,d4.w),1(a0,d5.w)
	bmi	LL_Marke2
	addq.l	#1,(a6)
LL_Marke2
	dbf	d2,LL_Marke1
	dbf	d1,LL_Loop
	lea	x(pc),a0
	move.l	d0,(a0)
	lea	y(pc),a0
	move.b	3(a1),3(a0)
	lea	Level(pc),a0
	move.l	d7,(a0)
	movea.l	4,a6
	move.l	PartsGroesse(pc),d0
	jsr	-210(a6)
	lea	Zahl(pc),a2
	move.w	d7,d3
	add.b	d3,d3
	add.b	d7,d3
	lea	LadeShp(pc),a4
	lea	ShpName(pc),a5
	moveq	#25,d5
	bsr	GetFile
	tst.l	d0
	bne	SetzBH
	lea	Produkt(pc),a0
	movea.l	PartsLib(pc),a1
	moveq	#50,d0
LL_Loop2
	cmpi.b	#13,d0
	beq	LL_Marke4
	cmpi.b	#35,d0
	bne	LL_Marke3
	moveq	#26,d0
LL_Marke3
	move.b	0(a1,d0.w),0(a0,d0.w)
LL_Marke4
	dbf	d0,LL_Loop2
	movea.l	Shop(pc),a0
	moveq	#0,d0
	move.b	51(a1),d0
	subq.b	#1,d0
LL_Marke5
	move.w	d0,d1
	add.w	d1,d1
	add.w	d0,d1
	lsl.w	#2,d1
	moveq	#0,d2
	move.b	53(a1,d1.w),d2
	moveq	#0,d3
	move.b	54(a1,d1.w),d3
	move.w	d2,d4
	lsl.b	#2,d4
	add.b	d2,d4
	lsl.b	#2,d4
	add.b	d2,d4
	lsl.b	#2,d4
	add.w	d3,d4
	move.w	d4,d5
	add.w	d4,d4
	add.w	d5,d4
	lsl.w	#2,d4
	add.w	d5,d4
	moveq	#11,d2
LL_Loop3
	move.b	52(a1,d1.w),0(a0,d4.w)
	addq.w	#1,d1
	addq.w	#1,d4
	dbf	d2,LL_Loop3
	move.b	#255,0(a0,d4.w)
	dbf	d0,LL_Marke5
	movea.l	4,a6
	move.l	PartsGroesse(pc),d0
	jsr	-210(a6)
	lea	PartsLib(pc),a0
	moveq	#0,d0
	move.l	d0,(a0)
	bsr	SetzProd
	lea	ZaehlShpText(pc),a0
	movea.l	RP1(pc),a1
	moveq	#0,d0
	moveq	#34,d1
	bsr	Schreib
	suba.w	a2,a2
	move.l	x(pc),d2
	bsr	ZaehlShops
	lea	Fertig(pc),a0
	movea.l	RP1(pc),a1
	move.l	#128,d0
	moveq	#34,d1
	bsr	Schreib
	lea	Anzahl(pc),a0
	movea.l	Shop(pc),a1
	lea	UCount(pc),a2
	moveq	#3,d0
	moveq	#0,d1
LL_Loop4
	moveq	#0,d2
	move.b	(a0)+,d2
	subq.b	#1,d2
	blt	LL_Zurueck2
LL_Marke6
	move.w	d1,d3
	lsl.b	#2,d3
	add.b	d1,d3
	lsl.b	#2,d3
	add.b	d1,d3
	lsl.b	#2,d3
	add.w	d2,d3
	move.w	d3,d4
	add.w	d3,d3
	add.w	d4,d3
	lsl.w	#2,d3
	add.w	d4,d3
	moveq	#6,d4
LL_Loop5
	tst.b	5(a1,d3.w)
	bmi	LL_Zurueck
	addq.l	#1,(a2)
LL_Zurueck
	addq.w	#1,d3
	dbf	d4,LL_Loop5
	dbf	d2,LL_Marke6
LL_Zurueck2
	addq.b	#1,d1
	dbf	d0,LL_Loop4
	bsr	ClearIt
	bra	SetzBH

SicherLvl
	bsr	ClrScr
	lea	Schreiben(pc),a0
	moveq	#0,d0
	move.l	d0,(a0)
	lea	AltAx(pc),a0
	moveq	#-1,d0
	move.l	d0,(a0)
	lea	Zahl(pc),a5
	lea	SichernText(pc),a0
	move.w	d7,d6
	add.b	d6,d6
	add.b	d7,d6
	move.b	0(a5,d6.w),15(a0)
	move.b	1(a5,d6.w),16(a0)
	movea.l	RP1(pc),a1
	moveq	#0,d0
	moveq	#7,d1
	bsr	Schreib
	lea	Anzahl(pc),a0
	cmpi.b	#2,(a0)
	beq	SL_Marke1
	lea	ZweiHQsTxt(pc),a0
	movea.l	RP1(pc),a1
	moveq	#0,d0
	moveq	#16,d1
	bsr	Schreib
	movea.l	DosBase(pc),a6
	move.l	#150,d1
	jsr	-198(a6)
	bra	SL_Ende2
SL_Marke1
	move.l	UCount(pc),d0
	cmpi.w	#201,d0
	blt	SL_Marke2
	lea	ZuVieleUs(pc),a0
	movea.l	RP1(pc),a1
	moveq	#0,d0
	moveq	#16,d1
	bsr	Schreib
	movea.l	DosBase(pc),a6
	move.l	#150,d1
	jsr	-198(a6)
	bra	SL_Ende2
SL_Marke2
	lea	SichFin(pc),a0
	move.b	0(a5,d6.w),9(a0)
	move.b	1(a5,d6.w),10(a0)
	movea.l	RP1(pc),a1
	moveq	#0,d0
	moveq	#16,d1
	bsr	Schreib
	move.l	x(pc),d5
	move.l	y(pc),d0
	mulu	d0,d5
	add.w	d5,d5
	addq.w	#4,d5
	move.l	d5,d0
	moveq	#25,d2
	bsr	ResSp
	tst.l	d0
	bne	SL_Ende2
	move.l	y(pc),d0
	move.l	d0,(a2)
	move.l	x(pc),d1
	move.w	d1,(a2)
	movea.l	Karte(pc),a0
	subq.b	#1,d0
SL_Marke3
	move.l	x(pc),d1
	mulu	d0,d1
	add.w	d1,d1
	addq.w	#4,d1
	move.l	x(pc),d2
	subq.b	#1,d2
SL_Marke4
	move.w	d2,d3
	add.b	d3,d3
	add.w	d1,d3
	move.w	d0,d4
	lsl.w	#6,d4
	add.w	d2,d4
	add.w	d4,d4
	move.b	0(a0,d4.w),0(a2,d3.w)
	move.b	1(a0,d4.w),1(a2,d3.w)
	dbf	d2,SL_Marke4
	dbf	d0,SL_Marke3
	move.l	d7,-(sp)
	lea	FinName(pc),a3
	moveq	#25,d4
	move.l	d5,d7
	bsr	Sicher
	move.l	(sp)+,d7
	tst.l	d0
	bne	SL_Ende2
	lea	Fertig(pc),a0
	movea.l	RP1(pc),a1
	move.l	#160,d0
	moveq	#16,d1
	bsr	Schreib
	lea	SichShp(pc),a0
	move.b	0(a5,d6.w),9(a0)
	move.b	1(a5,d6.w),10(a0)
	movea.l	RP1(pc),a1
	moveq	#0,d0
	moveq	#25,d1
	bsr	Schreib
	lea	Anzahl(pc),a0
	moveq	#0,d5
	move.b	(a0)+,d5
	add.b	(a0)+,d5
	add.b	(a0)+,d5
	add.b	(a0),d5
	move.w	d5,d0
	add.w	d5,d5
	add.w	d0,d5
	lsl.w	#2,d5
	addi.w	#52,d5
	move.l	d5,d0
	moveq	#34,d2
	bsr	ResSp
	tst.l	d0
	bne	SL_Ende
	lea	Produkt(pc),a0
	movea.l	a2,a1
	moveq	#50,d0
SL_Loop2
	move.b	(a0)+,(a1)+
	dbf	d0,SL_Loop2
	movem.l	d6-d7,-(sp)
	lea	Anzahl(pc),a0
	movea.l	Shop(pc),a1
	moveq	#0,d7
	moveq	#3,d0
	moveq	#0,d1
SL_Loop3
	moveq	#0,d2
	move.b	(a0)+,d2
	subq.b	#1,d2
	blt	SL_Zurueck2
SL_Marke5
	move.w	d1,d3
	lsl.b	#2,d3
	add.b	d1,d3
	lsl.b	#2,d3
	add.b	d1,d3
	lsl.b	#2,d3
	add.w	d2,d3
	move.w	d3,d4
	add.w	d3,d3
	add.w	d4,d3
	lsl.w	#2,d3
	add.w	d4,d3
	tst.b	12(a1,d3.w)
	bpl	SL_Zurueck
	moveq	#11,d4
	move.w	d7,d6
	add.w	d6,d6
	add.w	d7,d6
	lsl.w	#2,d6
SL_Loop4
	move.b	0(a1,d3.w),52(a2,d6.w)
	addq.w	#1,d3
	addq.w	#1,d6
	dbf	d4,SL_Loop4
	addq.b	#1,d7
SL_Zurueck
	dbf	d2,SL_Marke5
SL_Zurueck2
	addq.b	#1,d1
	dbf	d0,SL_Loop3
	move.b	d7,51(a2)
	move.w	d7,d0
	add.w	d7,d7
	add.w	d0,d7
	lsl.w	#2,d7
	addi.w	#52,d7
	move.l	(sp)+,d6
	lea	ShpName(pc),a3
	moveq	#34,d4
	bsr	Sicher
	move.l	(sp)+,d7
	tst.l	d0
	bne	SL_Ende
	lea	Fertig(pc),a0
	movea.l	RP1(pc),a1
	move.l	#160,d0
	moveq	#25,d1
	bsr	Schreib
SL_Ende
	lea	Level(pc),a0
	move.l	d7,(a0)
SL_Ende2
	bsr	ClearIt
	moveq	#0,d1
	moveq	#0,d2
	bra	SK_Marke1

ZeigeKarte
	movea.l	IntBase(pc),a6
	lea	Fenst2(pc),a0
	move.l	SZgr1(pc),30(a0)
	jsr	-204(a6)
	lea	FZgr2(pc),a0
	move.l	d0,(a0)
	bne	ZK_Marke1
	lea	FenstFehler(pc),a0
	movea.l	RP1(pc),a1
	moveq	#0,d0
	moveq	#7,d1
	bsr	Schreib
	bra	WaitPort
ZK_Marke1
	movea.l	d0,a0
	bsr	SetPointer
	movea.l	d0,a2
	movea.l	50(a2),a2
	movea.l	GfxBase(pc),a6
	movea.l	a2,a1
	moveq	#4,d0
	jsr	-342(a6)
	move.l	x(pc),d6
	move.l	y(pc),d7
	lea	Koordx(pc),a0
	moveq	#70,d0
	sub.b	d6,d0
	move.w	d0,(a0)
	move.w	d0,12(a0)
	move.w	d0,16(a0)
	moveq	#70,d1
	sub.b	d7,d1
	move.w	d1,2(a0)
	move.w	d1,6(a0)
	move.w	d1,18(a0)
	jsr	-240(a6)
	moveq	#71,d0
	add.b	d6,d0
	move.w	d0,4(a0)
	move.w	d0,8(a0)
	moveq	#72,d0
	add.b	d7,d0
	move.w	d0,10(a0)
	move.w	d0,14(a0)
	movea.l	a2,a1
	moveq	#5,d0
	jsr	-336(a6)
	movea.l	Karte(pc),a3
	movea.l	-340(a6),a4
	movea.l	-304(a6),a5
	move.l	d7,d4
	subq.b	#1,d4
ZK_Loop
	move.l	d6,d5
	subq.b	#1,d5
ZK_Marke2
	move.w	d4,d0
	lsl.w	#6,d0
	add.w	d5,d0
	add.w	d0,d0
	movea.l	a2,a1
	move.l	ZUnits(pc),d1
	beq	ZK_Marke3
	tst.b	1(a3,d0.w)
	bmi	ZK_Marke3
	move.b	1(a3,d0.w),d0
	andi.l	#1,d0
	lsl.b	#3,d0
	addq.b	#2,d0
	bra	ZK_Marke4
ZK_Marke3
	moveq	#0,d1
	move.b	0(a3,d0.w),d1
	lea	KFarbe(pc),a0
	moveq	#0,d0
	move.b	0(a0,d1.w),d0
ZK_Marke4
	jsr	(a4)
	moveq	#71,d0
	sub.b	d6,d0
	move.l	d5,d1
	add.b	d1,d1
	add.b	d1,d0
	moveq	#71,d1
	sub.b	d7,d1
	move.l	d5,d2
	andi.b	#1,d2
	add.b	d2,d1
	move.l	d4,d2
	add.b	d2,d2
	add.b	d2,d1
	move.l	d0,d2
	addq.b	#1,d2
	move.l	d1,d3
	addq.b	#1,d3
	jsr	(a5)
	dbf	d5,ZK_Marke2
	dbf	d4,ZK_Loop
	movea.l	IntBase(pc),a6
	movea.l	FZgr2(pc),a0
	jsr	-60(a6)
ZK_WaitPort
	movea.l	4,a6
	movea.l	FZgr2(pc),a4
	movea.l	86(a4),a0
	jsr	-384(a6)
	movea.l	86(a4),a0
	jsr	-372(a6)
	movea.l	d0,a1
	move.l	20(a1),d2
	move.w	24(a1),d5
	moveq	#0,d3
	move.w	32(a1),d3
	moveq	#0,d4
	move.w	34(a1),d4
	jsr	-378(a6)
	cmpi.w	#$200,d2
	bne	ZK_Class_$8
	movea.l	IntBase(pc),a6
	movea.l	FZgr2(pc),a0
	jsr	-72(a6)
	bra	WaitPort
ZK_Class_$8
	cmpi.b	#$8,d2
	bne	ZK_WaitPort
	cmpi.b	#$68,d5
	bne	ZK_WaitPort
	add.w	d6,d3
	subi.w	#75,d3
	blt	ZK_WaitPort
	add.w	d7,d4
	subi.w	#82,d4
	lsr.w	#1,d3
	move.w	d3,d0
	andi.b	#1,d0
	sub.w	d0,d4
	blt	ZK_WaitPort
	lsr.w	#1,d4
	subq.b	#1,d6
	cmp.b	d6,d3
	bgt	ZK_WaitPort
	subq.b	#1,d7
	cmp.b	d7,d4
	bgt	ZK_WaitPort
	subq.l	#5,d3
	subq.l	#3,d4
	movea.l	IntBase(pc),a6
	movea.l	FZgr2(pc),a0
	jsr	-72(a6)
	moveq	#0,d1
	moveq	#0,d2
	bra	SK_Marke2

Statistik
	movea.l	IntBase(pc),a6
	lea	Fenst4(pc),a0
	move.l	SZgr1(pc),30(a0)
	jsr	-204(a6)
	lea	FZgr2(pc),a0
	move.l	d0,(a0)
	bne	ST_Marke1
	lea	FenstFehler(pc),a0
	movea.l	RP1(pc),a1
	moveq	#0,d0
	moveq	#7,d1
	bsr	Schreib
	bra	WaitPort
ST_Marke1
	movea.l	d0,a0
	bsr	SetPointer
	movea.l	GfxBase(pc),a6
	movea.l	Topaz(pc),a0
	movea.l	d0,a1
	movea.l	50(a1),a1
	jsr	-66(a6)
	lea	Stats(pc),a2
	movea.l	a2,a0
	moveq	#0,d0
	moveq	#11,d1
ST_Loop
	move.l	d0,(a0)+
	dbf	d1,ST_Loop
	movea.l	Karte(pc),a3
	movea.l	Shop(pc),a5
	move.l	y(pc),d2
	subq.b	#1,d2
ST_Loop2
	move.l	x(pc),d3
	subq.b	#1,d3
ST_Marke2
	move.w	d2,d4
	lsl.w	#6,d4
	add.w	d3,d4
	add.w	d4,d4
	move.b	0(a3,d4.w),d1
	moveq	#1,d0
	bsr	FindTyp
	tst.b	d0
	bmi	ST_Marke5
	cmpi.b	#2,d0
	bgt	ST_Marke5
	move.w	d0,d6
	movea.l	x(pc),a0
	subq.w	#1,a0
	movea.w	d0,a1
	suba.w	a6,a6
	move.w	d2,d0
	move.w	d3,d1
	bsr	ShopNr2
	move.w	d6,d1
	lsl.b	#2,d1
	add.b	d6,d1
	lsl.b	#2,d1
	add.b	d6,d1
	lsl.b	#2,d1
	add.w	d1,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	lsl.w	#2,d0
	add.w	d1,d0
	cmpi.b	#1,d6
	blt	ST_Marke3
	move.w	d6,d5
	add.b	d5,d5
	add.b	d6,d5
	lsl.b	#2,d5
	subi.b	#12,d5
	addq.l	#1,8(a2,d5.w)
	move.b	0(a5,d0.w),d1
	cmpi.b	#1,d1
	bgt	ST_Marke3
	lsl.b	#2,d1
	add.b	d1,d5
	addq.l	#1,0(a2,d5.w)
ST_Marke3
	moveq	#0,d1
	move.b	3(a5,d0.w),d1
	add.l	d1,32(a2)
	moveq	#0,d5
	move.b	0(a5,d0.w),d5
	cmpi.b	#1,d5
	bgt	ST_Marke4
	lsl.b	#2,d5
	add.l	d1,24(a2,d5.w)
ST_Marke4
	move.b	0(a5,d0.w),d1
	lsl.b	#2,d1
	moveq	#6,d5
ST_Loop3
	tst.b	5(a5,d0.w)
	bmi	ST_Zurueck
	addq.l	#1,44(a2)
	cmpi.b	#4,d1
	bgt	ST_Zurueck
	addq.l	#1,36(a2,d1.w)
ST_Zurueck
	addq.w	#1,d0
	dbf	d5,ST_Loop3
	bra	ST_Zurueck3
ST_Marke5
	move.b	1(a3,d4.w),d1
	bmi	ST_Zurueck3
	addq.l	#1,44(a2)
	move.b	d1,d4
	andi.w	#1,d4
	lsl.b	#2,d4
	addq.l	#1,36(a2,d4.w)
	moveq	#2,d0
	bsr	FindTyp
	cmpi.b	#3,d0
	bne	ST_Zurueck3
	move.w	d0,d6
	movea.l	x(pc),a0
	subq.w	#1,a0
	movea.w	d0,a1
	suba.w	a6,a6
	move.w	d2,d0
	move.w	d3,d1
	bsr	ShopNr2
	move.w	d6,d1
	lsl.b	#2,d1
	add.b	d6,d1
	lsl.b	#2,d1
	add.b	d6,d1
	lsl.b	#2,d1
	add.w	d1,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	lsl.w	#2,d0
	add.w	d1,d0
	moveq	#0,d1
	move.b	0(a5,d0.w),d1
	lsl.b	#2,d1
	moveq	#6,d5
ST_Loop4
	tst.b	5(a5,d0.w)
	bmi	ST_Zurueck2
	addq.l	#1,44(a2)
	addq.l	#1,36(a2,d1.w)
ST_Zurueck2
	addq.w	#1,d0
	dbf	d5,ST_Loop4
ST_Zurueck3
	dbf	d3,ST_Marke2
	dbf	d2,ST_Loop2
	movea.l	FZgr2(pc),a5
	movea.l	50(a5),a5
	lea	EZKTxt(pc),a0
	movea.l	a5,a1
	moveq	#96,d0
	moveq	#7,d1
	bsr	Schreib
	lea	StatsTxt(pc),a3
	moveq	#3,d2
	moveq	#15,d3
ST_Loop5
	movea.l	a3,a0
	movea.l	a5,a1
	moveq	#0,d0
	move.l	d3,d1
	bsr	Schreib
	adda.l	#12,a3
	addq.b	#8,d3
	dbf	d2,ST_Loop5
	moveq	#3,d2
ST_Loop6
	moveq	#2,d3
ST_Marke6
	move.l	d2,d0
	add.b	d0,d0
	add.b	d2,d0
	add.b	d3,d0
	lsl.b	#2,d0
	move.l	0(a2,d0.w),d0
	lea	GenBuffer(pc),a0
	bsr	IntToStr
	movea.l	a5,a1
	moveq	#96,d0
	move.l	d3,d1
	add.b	d1,d1
	add.b	d3,d1
	lsl.b	#4,d1
	add.b	d1,d0
	moveq	#15,d1
	move.l	d2,d4
	lsl.b	#3,d4
	add.b	d4,d1
	bsr	Schreib
	dbf	d3,ST_Marke6
	dbf	d2,ST_Loop6
	movea.l	IntBase(pc),a6
	movea.l	FZgr2(pc),a0
	jsr	-60(a6)
ST_WaitPort
	movea.l	4,a6
	movea.l	FZgr2(pc),a2
	movea.l	86(a2),a0
	jsr	-384(a6)
	movea.l	86(a2),a0
	jsr	-372(a6)
	movea.l	d0,a1
	jsr	-378(a6)
	movea.l	IntBase(pc),a6
	movea.l	FZgr2(pc),a0
	jsr	-72(a6)
	bra	WaitPort

CheckXY
	move.l	Altx(pc),d0
	move.l	x(pc),d2
	cmp.b	d0,d2
	bne	CXY_Marke1
	move.l	Alty(pc),d1
	move.l	y(pc),d3
	cmp.b	d1,d3
	beq	WaitPort
CXY_Marke1
	cmp.b	d0,d2
	bgt	CXY_Marke2
	move.l	y(pc),d3
	move.l	Alty(pc),d1
	cmp.b	d1,d3
	ble	CXY_Marke3
CXY_Marke2
	subq.b	#1,d0
	move.l	Alty(pc),d1
	subq.b	#1,d1
	moveq	#0,d2
	bsr	LoeschKuS
CXY_Marke3
	move.l	Altx(pc),d0
	move.l	x(pc),d2
	cmp.b	d0,d2
	blt	CXY_Marke4
	move.l	Alty(pc),d1
	move.l	y(pc),d3
	cmp.b	d1,d3
	bge	SetzBH
CXY_Marke4
	bsr	SetBusy
	movea.l	Karte(pc),a3
	movea.l	Shop(pc),a4
	move.l	y(pc),d6
	subq.b	#1,d6
CXY_Loop
	move.l	x(pc),d7
	subq.b	#1,d7
CXY_Marke5
	move.l	y(pc),d0
	subq.b	#1,d0
	cmp.b	d0,d6
	beq	CXY_Marke6
	move.l	x(pc),d0
	subq.b	#1,d0
	cmp.b	d0,d7
	bne	CXY_Zurueck
CXY_Marke6
	move.w	d6,d2
	lsl.w	#6,d2
	add.w	d7,d2
	add.w	d2,d2
	move.b	0(a3,d2.w),d1
	moveq	#1,d0
	bsr	FindTyp
	tst.b	d0
	bmi	CXY_Zurueck
	move.l	d7,d4
	move.l	d6,d5
	bsr	Aender
	move.w	d5,d2
	lsl.w	#6,d2
	add.w	d4,d2
	add.w	d2,d2
	move.b	0(a3,d2.w),d1
	moveq	#1,d0
	bsr	FindTyp
	movea.l	Altx(pc),a0
	subq.w	#1,a0
	movea.w	d0,a1
	suba.w	a6,a6
	move.w	d5,d0
	move.w	d4,d1
	bsr	ShopNr2
	move.w	a1,d1
	lsl.b	#2,d1
	add.w	a1,d1
	lsl.b	#2,d1
	add.w	a1,d1
	lsl.b	#2,d1
	add.w	d0,d1
	move.w	d1,d0
	add.w	d1,d1
	add.w	d0,d1
	lsl.w	#2,d1
	add.w	d0,d1
	move.b	#63,12(a4,d1.w)
CXY_Zurueck
	dbf	d7,CXY_Marke5
	dbf	d6,CXY_Loop
	lea	Aldi(pc),a0
	move.l	Anzahl(pc),(a0)
	movea.w	#1,a2
	move.l	Altx(pc),d2
	bsr	ZaehlShops
	movea.l	IntBase(pc),a6
	move.l	y(pc),d6
	subq.b	#1,d6
CXY_Loop2
	move.l	x(pc),d7
	subq.b	#1,d7
CXY_Marke8
	move.l	y(pc),d0
	subq.b	#1,d0
	cmp.b	d0,d6
	beq	CXY_Marke9
	move.l	x(pc),d0
	subq.b	#1,d0
	cmp.b	d0,d7
	bne	CXY_Zurueck2
CXY_Marke9
	move.w	d6,d2
	lsl.w	#6,d2
	add.w	d7,d2
	add.w	d2,d2
	move.b	0(a3,d2.w),d1
	moveq	#1,d0
	bsr	FindTyp
	tst.b	d0
	bmi	CXY_Marke10
	move.l	d7,d4
	move.l	d6,d5
	bsr	Aender
	move.w	d5,d2
	lsl.w	#6,d2
	add.w	d4,d2
	add.w	d2,d2
	move.b	0(a3,d2.w),d1
	moveq	#1,d0
	bsr	FindTyp
	tst.b	d0
	bmi	CXY_Zurueck2
	clr.b	0(a3,d2.w)
	sub.l	Ay(pc),d5
	sub.l	Ax(pc),d4
	lsl.b	#2,d0
	lea	ShopTeile1(pc),a2
	movea.l	0(a2,d0.w),a2
	lea	ShopFelder(pc),a5
	movea.l	0(a5,d0.w),a5
	bsr	ZSF
	tst.b	d5
	bmi	CXY_Zurueck2
	cmpi.b	#7,d5
	bgt	CXY_Zurueck2
	tst.b	d4
	bmi	CXY_Zurueck2
	cmpi.b	#10,d5
	bgt	CXY_Zurueck2
	movea.l	RP1(pc),a0
	movea.l	Part(pc),a1
	move.l	d4,d0
	add.b	d0,d0
	add.b	d4,d0
	lsl.b	#3,d0
	add.b	d4,d0
	addi.w	#19,d0
	add.l	Ax(pc),d4
	andi.b	#1,d4
	move.b	d4,d1
	add.b	d4,d4
	add.b	d1,d4
	lsl.b	#2,d4
	move.l	d5,d1
	add.b	d1,d1
	add.b	d5,d1
	lsl.b	#3,d1
	add.b	d5,d1
	add.b	d4,d1
	addi.b	#14,d1
	jsr	-114(a6)
	bra	CXY_Zurueck2
CXY_Marke10
	move.b	1(a3,d2.w),d1
	moveq	#3,d0
	bsr	FindTyp
	cmpi.b	#9,d0
	blt	CXY_Zurueck2
	move.l	d6,d4
	subq.b	#1,d4
	move.l	d7,d5
	move.w	d4,d2
	lsl.w	#6,d2
	add.w	d5,d2
	add.w	d2,d2
	move.b	#255,1(a3,d2.w)
	sub.l	Ay(pc),d4
	blt	CXY_Zurueck2
	cmpi.b	#7,d4
	bgt	CXY_Zurueck2
	sub.l	Ax(pc),d5
	blt	CXY_Zurueck2
	cmpi.b	#10,d5
	bgt	CXY_Zurueck2
	movea.l	RP1(pc),a0
	movea.l	Part(pc),a1
	move.l	d5,d0
	add.b	d0,d0
	add.b	d5,d0
	lsl.b	#3,d0
	add.b	d5,d0
	addi.w	#19,d0
	move.l	d5,d1
	add.l	Ax(pc),d1
	andi.b	#1,d1
	move.b	d1,d2
	add.b	d1,d1
	add.b	d2,d1
	lsl.b	#2,d1
	move.l	d4,d2
	add.b	d2,d2
	add.b	d4,d2
	lsl.b	#3,d2
	add.b	d4,d2
	add.b	d2,d1
	addi.b	#14,d1
	jsr	-114(a6)
CXY_Zurueck2
	dbf	d7,CXY_Marke8
	dbf	d6,CXY_Loop2
	move.l	Aldi(pc),d0
	rol.l	#8,d0
	move.l	Anzahl(pc),d1
	rol.l	#8,d1
	cmp.b	d0,d1
	beq	CXY_Marke13
	tst.b	d1
	bne	CXY_Marke11
	clr.b	12(a4)
	clr.b	25(a4)
	bra	CXY_Marke13
CXY_Marke11
	move.b	26(a4),d0
	bne	CXY_Marke12
	clr.b	12(a4)
CXY_Marke12
	move.b	27(a4),d1
	bne	CXY_Marke13
	clr.b	25(a4)
CXY_Marke13
	move.l	x(pc),d0
	move.l	y(pc),d1
	moveq	#0,d2
	bsr	LoeschKuS
	bsr	ClearIt
SetzBH
	lea	SItem55,a0
	lea	SItem48,a1
	move.l	x(pc),d0
	move.l	y(pc),d1
	moveq	#6,d2
	moveq	#2,d3
SBH_Loop
	move.b	d3,d4
	lsl.b	#3,d4
	cmp.b	d4,d0
	bne	SBH_Marke1
	move.w	#347,12(a0)
	bra	SBH_Marke2
SBH_Marke1
	move.w	#91,12(a0)
SBH_Marke2
	cmp.b	d4,d1
	bne	SBH_Marke3
	move.w	#347,12(a1)
	bra	SBH_Marke4
SBH_Marke3
	move.w	#91,12(a1)
SBH_Marke4
	movea.l	(a0),a0
	movea.l	(a1),a1
	addq.b	#1,d3
	dbf	d2,SBH_Loop
	lea	Altx(pc),a0
	move.l	d0,(a0)
	lea	Alty(pc),a0
	move.l	d1,(a0)
	bsr	NeuFTitel
	moveq	#0,d1
	moveq	#0,d2
	bra	SK_Marke1

CheckProd
	lea	SItem41(pc),a0
	lea	Produkt(pc),a1
	moveq	#50,d0
	moveq	#0,d1
CP_Loop
	cmpi.b	#13,d1
	beq	CP_Zurueck
	cmpi.b	#27,d1
	bne	CP_Marke1
	moveq	#14,d0
	moveq	#36,d1
CP_Marke1
	move.w	12(a0),d2
	andi.w	#$100,d2
	beq	CP_Marke2
	clr.b	0(a1,d1.w)
	bra	CP_Marke3
CP_Marke2
	move.b	#1,0(a1,d1.w)
CP_Marke3
	cmpi.b	#21,d1
	bne	CP_Marke4
	lea	SItem20(pc),a0
	bra	CP_Zurueck
CP_Marke4
	movea.l	(a0),a0
CP_Zurueck
	addq.b	#1,d1
	dbf	d0,CP_Loop
	bra	WaitPort

Pick
	bsr	CalcKxKy
	movea.l	Karte(pc),a3
	add.l	Ay(pc),d5
	lsl.w	#6,d5
	add.l	Ax(pc),d5
	add.w	d4,d5
	add.w	d5,d5
	add.w	d2,d5
	moveq	#0,d6
	move.b	0(a3,d5.w),d6
	cmpi.b	#255,d6
	beq	PK_Marke2
	cmpi.b	#174,d6
	beq	WaitPort
	move.l	d6,d4
	cmpi.w	#108,d6
	blt	PK_Marke1
	subi.w	#108,d4
PK_Marke1
	divu	#12,d4
	move.l	d4,d5
	swap	d4
	ext.l	d4
	ext.l	d5
	bra	PK_Marke3
PK_Marke2
	moveq	#6,d4
	moveq	#8,d5
PK_Marke3
	tst.b	d2
	bne	PK_Marke6
	cmpi.w	#107,d6
	bgt	PK_Marke4
	movea.l	FZgr3(pc),a2
	bra	PK_Marke5
PK_Marke4
	subi.w	#108,d6
	movea.l	FZgr4(pc),a2
PK_Marke5
	moveq	#0,d0
	moveq	#0,d2
	bsr	Wahl
	bra	WaitPort
PK_Marke6
	movea.l	FZgr5(pc),a2
	moveq	#0,d0
	moveq	#1,d2
	bsr	Wahl
	bra	WaitPort

AusXY
	bsr	CalcKxKy
	add.l	Ax(pc),d4
	add.l	Ay(pc),d5
	move.w	d5,d6
	lsl.w	#6,d6
	add.w	d4,d6
	add.w	d6,d6
	movea.l	Karte(pc),a3
	move.b	0(a3,d6.w),d1
	moveq	#1,d0
	bsr	FindTyp
	tst.b	d0
	bmi	AXY_Marke1
	cmpi.b	#5,d0
	blt	ShopInfo
	bsr	Aender
	move.w	d5,d0
	lsl.w	#6,d0
	add.w	d4,d0
	add.w	d0,d0
	move.b	0(a3,d0.w),d1
	moveq	#1,d0
	bsr	FindTyp
	bra	ShopInfo
AXY_Marke1
	move.b	1(a3,d6.w),d1
	bmi	WaitPort
	moveq	#2,d0
	bsr	FindTyp
	tst.b	d0
	bmi	WaitPort
ShopInfo
	movea.w	d0,a1
	movea.l	x(pc),a0
	subq.w	#1,a0
	movea.w	#1,a6
	move.w	d5,d0
	move.w	d4,d1
	bsr	ShopNr
	move.w	a1,d5
	move.l	d0,d2
	move.w	d5,d4
	lsl.b	#2,d4
	add.b	d5,d4
	lsl.b	#2,d4
	add.b	d5,d4
	lsl.b	#2,d4
	add.w	d2,d4
	move.w	d4,d0
	add.w	d4,d4
	add.w	d0,d4
	lsl.w	#2,d4
	add.w	d0,d4
	movea.l	Shop(pc),a2
	moveq	#0,d6
	move.b	3(a2,d4.w),d6
	move.w	d6,d0
	lsl.w	#8,d0
	add.w	d6,d0
	lea	PInfo1(pc),a0
	move.w	d0,2(a0)
	movea.l	IntBase(pc),a6
	lea	Fenst5(pc),a0
	move.l	SZgr1(pc),30(a0)
	jsr	-204(a6)
	lea	FZgr2(pc),a0
	move.l	d0,(a0)
	bne	SI_Marke1
	lea	FenstFehler(pc),a0
	movea.l	RP1(pc),a1
	moveq	#0,d0
	moveq	#7,d1
	bsr	Schreib
	bra	WaitPort
SI_Marke1
	movea.l	d0,a3
	movea.l	50(a3),a3
	movea.l	GfxBase(pc),a6
	movea.l	Topaz(pc),a0
	movea.l	a3,a1
	jsr	-66(a6)
	lea	SI_Typ(pc),a0
	movea.l	a3,a1
	moveq	#0,d0
	moveq	#7,d1
	bsr	Schreib
	lea	ShopTypTab(pc),a0
	move.w	d5,d0
	lsl.b	#2,d0
	movea.l	0(a0,d0.w),a0
	movea.l	a3,a1
	moveq	#96,d0
	moveq	#7,d1
	bsr	Schreib
	lea	SI_Besitzer(pc),a0
	movea.l	a3,a1
	moveq	#0,d0
	moveq	#15,d1
	bsr	Schreib
	lea	ShopBesTab(pc),a0
	move.b	0(a2,d4.w),d7
	moveq	#0,d0
	move.b	d7,d0
	lsl.b	#2,d0
	movea.l	0(a0,d0.w),a0
	movea.l	a3,a1
	moveq	#96,d0
	moveq	#15,d1
	bsr	Schreib
	lea	SI_Nr(pc),a0
	movea.l	a3,a1
	moveq	#0,d0
	moveq	#23,d1
	bsr	Schreib
	lea	GenBuffer(pc),a0
	move.l	d2,d0
	bsr	IntToStr
	movea.l	a3,a1
	moveq	#96,d0
	moveq	#23,d1
	bsr	Schreib
	lea	SI_Rohstoffe(pc),a0
	movea.l	a3,a1
	moveq	#0,d0
	moveq	#31,d1
	bsr	Schreib
	lea	GenBuffer(pc),a0
	move.l	d6,d0
	bsr	IntToStr
	movea.l	a3,a1
	moveq	#96,d0
	moveq	#31,d1
	bsr	Schreib
	movea.l	IntBase(pc),a6
	movea.l	-112(a6),a4
	movea.l	-106(a6),a5
	moveq	#6,d2
	move.w	d4,d3
	addi.w	#11,d3
	move.l	d5,-(sp)
	cmpi.b	#2,d7
	bne	SI_Loop
	moveq	#0,d7
SI_Loop
	move.l	d2,d0
	add.b	d0,d0
	add.b	d2,d0
	lsl.b	#3,d0
	add.b	d2,d0
	addq.b	#6,d0
	moveq	#0,d6
	move.b	0(a2,d3.w),d6
	bmi	SI_Marke2
	add.b	d6,d6
	add.b	d7,d6
	movea.l	a3,a0
	movea.l	Unit(pc),a1
	move.l	d6,d1
	lsl.w	#2,d1
	add.w	d6,d1
	lsl.w	#2,d1
	adda.l	d1,a1
	move.l	d0,d5
	addq.b	#1,d0
	moveq	#52,d1
	jsr	(a4)
	move.l	d5,d0
SI_Marke2
	movea.l	a3,a0
	lea	Grenze1(pc),a1
	moveq	#51,d1
	jsr	(a5)
	subq.w	#1,d3
	dbf	d2,SI_Loop
	move.l	(sp)+,d5
SI_WaitPort
	movea.l	4,a6
	movea.l	FZgr2(pc),a4
	movea.l	86(a4),a0
	jsr	-384(a6)
	movea.l	86(a4),a0
	jsr	-372(a6)
	movea.l	d0,a1
	move.l	20(a1),d2
	move.w	24(a1),d7
	movea.l	28(a1),a4
	move.w	32(a1),d3
	move.w	34(a1),d6
	jsr	-378(a6)
	cmpi.w	#$200,d2
	bne	SI_Class_$10
	movea.l	IntBase(pc),a6
	movea.l	FZgr2(pc),a0
	jsr	-72(a6)
	bra	WaitPort
SI_Class_$10
	cmpi.b	#$10,d2
	bne	SI_Class_$40
	bra	EditEnergie
SI_Class_$40
	cmpi.b	#$40,d2
	bne	SI_Class_$8
	tst.w	38(a4)
	beq	EditEnergie
	bra	GetUnit
SI_Class_$8
	cmpi.b	#$8,d2
	bne	SI_WaitPort
	cmpi.b	#$68,d7
	bne	SI_WaitPort
EditShop
	move.l	PUNr(pc),d0
	beq	SI_WaitPort
	move.l	UCount(pc),d0
	cmpi.w	#199,d0
	bgt	ES_Beep
	subi.w	#10,d3
	blt	SI_WaitPort
	subi.w	#62,d6
	blt	SI_WaitPort
	divu	#25,d3
	ext.l	d3
	divu	#25,d6
	ext.l	d6
	move.b	d6,d0
	lsl.b	#3,d0
	sub.b	d6,d0
	add.b	d3,d0
	cmpi.b	#6,d0
	bgt	SI_WaitPort
	moveq	#3,d0
	move.l	PU(pc),d1
	bsr	FindTyp
	cmpi.b	#7,d0
	bgt	SI_WaitPort
	move.l	d1,d7
	tst.b	d7
	bmi	ES_Marke1
	lsr.b	#1,d1
ES_Marke1
	move.w	d4,d0
	add.w	d3,d0
	move.b	d1,5(a2,d0.w)
	movea.l	GfxBase(pc),a6
	movea.l	a3,a1
	moveq	#0,d0
	jsr	-342(a6)
	movea.l	a3,a1
	move.l	d3,d6
	add.b	d6,d6
	add.b	d3,d6
	lsl.b	#3,d6
	add.b	d3,d6
	addq.b	#7,d6
	move.l	d6,d0
	moveq	#52,d1
	move.l	d6,d2
	addi.b	#23,d2
	moveq	#75,d3
	jsr	-306(a6)
	lea	UCount(pc),a0
	tst.b	d7
	bmi	ES_Marke2
	addq.l	#1,(a0)
	movea.l	IntBase(pc),a6
	movea.l	a3,a0
	movea.l	Unit(pc),a1
	move.w	d7,d0
	lsl.w	#2,d7
	add.w	d0,d7
	lsl.w	#2,d7
	adda.l	d7,a1
	move.l	d6,d0
	moveq	#52,d1
	jsr	-114(a6)
	bra	ES_Marke3
ES_Marke2
	subq.l	#1,(a0)
ES_Marke3
	move.b	#255,12(a2,d4.w)
	bra	SI_WaitPort
ES_Beep
	movea.l	IntBase(pc),a6
	movea.l	SZgr1(pc),a0
	jsr	-96(a6)
	bra	SI_WaitPort
GetUnit
	movem.l	a2-a3/d4-d5,-(sp)
	movea.l	FZgr5(pc),a2
	movea.l	FZgr4(pc),a3
	suba.w	a5,a5
	moveq	#1,d2
	moveq	#102,d3
	bsr	WaehlePU
	movem.l	(sp)+,a2-a3/d4-d5
	movea.l	FZgr2(pc),a0
	jsr	-450(a6)
	bra	SI_WaitPort
EditEnergie
	cmpi.b	#3,d5
	beq	SI_WaitPort
	movea.l	GfxBase(pc),a6
	movea.l	a3,a1
	moveq	#0,d0
	jsr	-342(a6)
	movea.l	a3,a1
	moveq	#96,d0
	moveq	#24,d1
	moveq	#119,d2
	moveq	#32,d3
	jsr	-306(a6)
	lea	PInfo1(pc),a0
	move.w	2(a0),d0
	divu	#257,d0
	ext.l	d0
	move.b	d0,3(a2,d4.w)
	lea	GenBuffer(pc),a0
	bsr	IntToStr
	movea.l	a3,a1
	moveq	#96,d0
	moveq	#31,d1
	bsr	Schreib
	move.b	#255,12(a2,d4.w)
	bra	SI_WaitPort

ScrollKoords
	move.l	Schritt(pc),d0
	movem.l	(a2)+,d1-d2
	muls	d0,d1
	muls	d0,d2
SK_Marke1
	move.l	Ax(pc),d3
	move.l	Ay(pc),d4
SK_Marke2
	add.l	d1,d3
	bge	SK_Marke3
	moveq	#0,d3
SK_Marke3
	move.l	x(pc),d5
	subi.b	#11,d5
	cmp.b	d5,d3
	ble	SK_Marke4
	move.l	d5,d3
SK_Marke4
	add.l	d2,d4
	bge	SK_Marke5
	moveq	#0,d4
SK_Marke5
	move.l	y(pc),d5
	subq.b	#8,d5
	cmp.b	d5,d4
	ble	SK_Marke6
	move.l	d5,d4
SK_Marke6
	move.l	AltAx(pc),d0
	cmp.b	d0,d3
	bne	SK_Marke7
	move.l	AltAy(pc),d0
	cmp.b	d0,d4
	beq	WaitPort
SK_Marke7
	lea	Ax(pc),a0
	move.l	d3,(a0)
	lea	Ay(pc),a0
	move.l	d4,(a0)
	lea	AltAx(pc),a0
	move.l	d3,(a0)
	lea	AltAy(pc),a0
	move.l	d4,(a0)
	moveq	#0,d2
	bsr	Ausschnitt
	bra	WaitPort

* Ende

FreeListeMem
	movea.l	4,a6
	lea	MemListe(pc),a2
	move.w	(a2)+,d2
FLM_Loop
	move.l	(a2)+,d0
	beq	FreeUnitLibMem
	movea.l	d0,a1
	move.l	(a2)+,d0
	jsr	-210(a6)
	dbf	d2,FLM_Loop

FreeUnitLibMem
	movea.l	4,a6
	move.l	UnitLib(pc),d0
	beq	FreePartsLibMem
	movea.l	d0,a1
	move.l	UnitGroesse(pc),d0
	jsr	-210(a6)

FreePartsLibMem
	movea.l	4,a6
	move.l	PartsLib(pc),d0
	beq	FreeUhrMem
	movea.l	d0,a1
	move.l	PartsGroesse(pc),d0
	jsr	-210(a6)

FreeUhrMem
	movea.l	4,a6
	move.l	UhrZgr(pc),d0
	beq	ClearMenuStrip
	movea.l	d0,a1
	moveq	#72,d0
	jsr	-210(a6)

ClearMenuStrip
	movea.l	IntBase(pc),a6
	movea.l	FZgr1(pc),a0
	jsr	-54(a6)

CloseFenster
	lea	FZgr5(pc),a2
	moveq	#3,d2
CF_Loop
	move.l	(a2)+,d0
	beq	CF_Zurueck
	movea.l	d0,a0
	jsr	-72(a6)
CF_Zurueck
	dbf	d2,CF_Loop

CloseScreen
	movea.l	SZgr1(pc),a0
	jsr	-66(a6)

CloseLibs
	movea.l	4,a6
	lea	DosBase(pc),a2
	moveq	#2,d2
CL_Loop
	move.l	(a2)+,d0
	beq	CL_Zurueck
	movea.l	d0,a1
	jsr	-414(a6)
CL_Zurueck
	dbf	d2,CL_Loop

	move.l	a5,d0
	beq	Ende
	bsr	ConWrite
Ende
	rts

* Subs

GetFile
	move.b	0(a2,d3.w),5(a4)
	move.b	1(a2,d3.w),6(a4)
	move.b	0(a2,d3.w),4(a5)
	move.b	1(a2,d3.w),5(a5)
	lea	PartsGroesse(pc),a2
	lea	PartsLib(pc),a3
	bsr	Laden
	rts

CalcKxKy
	subi.w	#22,d4
	blt	CKK_Ende
	divu	#25,d4
	ext.l	d4
	move.l	Ax(pc),d0
	add.b	d4,d0
	andi.b	#1,d0
	move.b	d0,d1
	add.b	d0,d0
	add.b	d1,d0
	lsl.b	#2,d0
	addi.b	#24,d0
	sub.w	d0,d5
	blt	CKK_Ende
	divu	#25,d5
	ext.l	d5
	cmpi.b	#10,d4
	bgt	CKK_Ende
	cmpi.b	#7,d5
	bgt	CKK_Ende
	move.l	Ax(pc),d0
	add.b	d4,d0
	move.l	x(pc),d1
	subq.b	#1,d1
	cmp.b	d0,d1
	beq	CKK_Ende
	move.l	Ay(pc),d0
	add.b	d5,d0
	move.l	y(pc),d1
	subq.b	#1,d1
	cmp.b	d0,d1
	beq	CKK_Ende
	rts
CKK_Ende
	addq.l	#4,sp
	bra	WaitPort

WriteUCount
	movea.l	GfxBase(pc),a6
	movea.l	RP1(pc),a1
	moveq	#0,d0
	jsr	-342(a6)
	movea.l	RP1(pc),a1
	moveq	#0,d0
	moveq	#0,d1
	moveq	#23,d2
	moveq	#7,d3
	jsr	-306(a6)
	lea	GenBuffer(pc),a0
	move.l	UCount(pc),d0
	bsr	IntToStr
	movea.l	RP1(pc),a1
	moveq	#0,d0
	moveq	#7,d1
	bsr	Schreib
	rts

Kontakt
	move.l	Ay(pc),d0
	add.b	d3,d0
	lsl.w	#6,d0
	add.l	Ax(pc),d0
	add.w	d2,d0
	add.w	d0,d0
	tst.b	1(a3,d0.w)
	bmi	KT_Marke1
	moveq	#1,d0
	rts
KT_Marke1
	move.b	0(a3,d0.w),d1
	moveq	#1,d0
	bsr	FindTyp
	tst.b	d0
	bmi	KT_Marke2
	moveq	#1,d0
	lea	Durch(pc),a0
	move.l	d0,(a0)
	move.b	d2,d4
	move.b	d3,d5
KT_Marke2
	moveq	#0,d0
	rts

Durch2
	add.l	Ax(pc),d4
	bsr	Aender
	sub.l	Ax(pc),d4
	move.l	Ay(pc),d3
	add.b	d5,d3
	lsl.w	#6,d3
	add.l	Ax(pc),d3
	add.w	d4,d3
	add.w	d3,d3
	move.b	0(a3,d3.w),d1
	moveq	#1,d0
	bsr	FindTyp
	tst.b	d0
	bne	DZ_Marke1
	lea	HQTeile1(pc),a2
	lea	HQFelder(pc),a5
	bsr	ZSF
	bra	DZ_Marke3
DZ_Marke1
	cmpi.b	#1,d0
	bne	DZ_Marke2
	lea	FBTeile1(pc),a2
	lea	FBFelder(pc),a5
	bsr	ZSF
	bra	DZ_Marke3
DZ_Marke2
	cmpi.b	#2,d0
	bne	DZ_Marke3
	lea	DPTeile1(pc),a2
	lea	DPFelder(pc),a5
	bsr	ZSF
DZ_Marke3
	lea	Aldi(pc),a0
	move.l	PU(pc),(a0)
	moveq	#0,d0
	lea	PU(pc),a0
	move.l	d0,(a0)
	rts

Sicher
	movea.l	DosBase(pc),a6
	lea	HLPfad(pc),a0
	lea	GesamtName(pc),a1
	bsr	StrCpy
	movea.l	a3,a0
	move.b	0(a5,d6.w),4(a0)
	move.b	1(a5,d6.w),5(a0)
	bsr	StrCat
	move.l	a1,d1
	move.l	#$3ee,d2
	jsr	-30(a6)
	move.l	d0,d1
	bne	SD_Marke1
	lea	OpenFehler(pc),a0
	movea.l	RP1(pc),a1
	moveq	#0,d0
	move.l	d4,d1
	bsr	Schreib
	move.l	#150,d1
	jsr	-198(a6)
	moveq	#1,d2
	bra	SD_Ende
SD_Marke1
	move.l	d0,d4
	move.l	a2,d2
	move.l	d7,d3
	jsr	-48(a6)
	move.l	d4,d1
	jsr	-36(a6)
	moveq	#0,d2
SD_Ende
	movea.l	4,a6
	movea.l	a2,a1
	move.l	d5,d0
	jsr	-210(a6)
	move.l	d2,d0
	rts

ResSp
	move.l	a6,-(sp)
	movea.l	4,a6
	move.l	#$10000,d1
	jsr	-198(a6)
	move.l	d0,a2
	tst.l	d0
	bne	RS_Ende
	lea	AllocMemFehler(pc),a0
	movea.l	RP1(pc),a1
	moveq	#0,d0
	move.l	d2,d1
	bsr	Schreib
	movea.l	DosBase(pc),a6
	move.l	#150,d1
	jsr	-198(a6)
	movea.l	(sp)+,a6
	moveq	#1,d0
	rts
RS_Ende
	movea.l	(sp)+,a6
	moveq	#0,d0
	rts

SetBusy
	movea.l	FZgr1(pc),a0
	bsr	SetPointer
	movea.l	IntBase(pc),a6
	lea	BWarten(pc),a1
	lea	Titel1(pc),a2
	jsr	-276(a6)
	rts

ClearIt
	movea.l	IntBase(pc),a6
	movea.l	FZgr1(pc),a0
	jsr	-60(a6)
	bsr	NeuFTitel
	rts

ZSF
	movem.l	d2-d7/a4,-(sp)
	movea.l	-112(a6),a4
	add.l	Ax(pc),d4
	add.l	Ay(pc),d5
	move.l	d4,d2
	andi.b	#1,d2
	moveq	#0,d3
	move.b	(a2)+,d3
ZSF_Loop
	move.l	(a5)+,d0
	mulu	d2,d0
	add.l	d5,d0
	add.l	(a5)+,d0
	move.l	d0,d6
	lsl.w	#6,d0
	move.l	(a5)+,d1
	add.l	d4,d1
	move.l	d1,d7
	add.w	d1,d0
	add.w	d0,d0
	move.b	(a2),0(a3,d0.w)
	movea.l	RP1(pc),a0
	movea.l	Part(pc),a1
	moveq	#0,d0
	move.b	(a2)+,d0
	move.w	d0,d1
	lsl.w	#2,d0
	add.w	d1,d0
	lsl.w	#2,d0
	adda.l	d0,a1
	sub.l	Ay(pc),d6
	blt	ZSF_Zurueck
	cmpi.b	#7,d6
	bgt	ZSF_Zurueck
	move.l	d7,d0
	sub.l	Ax(pc),d0
	blt	ZSF_Zurueck
	cmpi.b	#10,d0
	bgt	ZSF_Zurueck
	move.l	d6,d1
	add.b	d1,d1
	add.b	d6,d1
	lsl.b	#3,d1
	add.b	d6,d1
	andi.b	#1,d7
	move.b	d7,d6
	add.b	d7,d7
	add.b	d6,d7
	lsl.b	#2,d7
	add.b	d7,d1
	addi.b	#14,d1
	move.b	d0,d6
	add.b	d0,d0
	add.b	d6,d0
	lsl.b	#3,d0
	add.b	d6,d0
	addi.w	#19,d0
	jsr	(a4)
ZSF_Zurueck
	dbf	d3,ZSF_Loop
	movem.l	(sp)+,d2-d7/a4
	rts

Palette
	lsl.b	#6,d0
	lea	Farbe(pc),a2
	adda.l	d0,a2
	movea.l	IntBase(pc),a6
	movea.l	FZgr1(pc),a0
	jsr	-300(a6)
	movea.l	d0,a0
	movea.l	GfxBase(pc),a6
	movea.l	a2,a1
	moveq	#32,d0
	jsr	-192(a6)
	rts

SetPointer
	movem.l	a0-a1/a6/d0-d3,-(sp)
	movea.l	IntBase(pc),a6
	movea.l	UhrZgr(pc),a1
	moveq	#16,d0
	moveq	#16,d1
	moveq	#-8,d2
	moveq	#0,d3
	jsr	-270(a6)
	movem.l	(sp)+,a0-a1/a6/d0-d3
	rts

Laden
	movea.l	a4,a0
	movea.l	RP1(pc),a1
	moveq	#0,d0
	move.l	d5,d1
	bsr	Schreib
	lea	HLPfad(pc),a0
	lea	GesamtName(pc),a1
	bsr	StrCpy
	movea.l	a5,a0
	bsr	StrCat
	move.l	a1,d6
	movea.l	a1,a0
	bsr	Untersuch
	movea.l	d0,a5
	tst.l	d0
	bne	La_Ende
	lea	FIB(pc),a0
	move.l	124(a0),(a2)
	movea.l	4,a6
	move.l	(a2),d0
	move.l	#$10000,d1
	jsr	-198(a6)
	move.l	d0,(a3)
	bne	La_OpenFile
	lea	AllocMemFehler(pc),a5
	bra	La_Ende
La_OpenFile
	movea.l	DosBase(pc),a6
	move.l	d6,d1
	move.l	#$3ed,d2
	jsr	-30(a6)
	move.l	d0,d4
	bne	La_Gepackt
	lea	OpenFehler(pc),a5
	bra	La_Ende
La_Gepackt
	move.l	d4,d1
	move.l	(a3),d2
	moveq	#4,d3
	jsr	-42(a6)
	tst.l	d0
	beq	La_ReadError
	movea.l	(a3),a0
	cmpi.l	#$5450574d,(a0)
	bne	La_ReadFile
	lea	GepacktFehler(pc),a5
	bra	La_CloseFile
La_ReadFile
	move.l	d4,d1
	moveq	#0,d2
	moveq	#-1,d3
	jsr	-66(a6)
	move.l	d4,d1
	move.l	(a3),d2
	move.l	(a2),d3
	jsr	-42(a6)
	tst.l	d0
	bne	La_OK
La_ReadError
	lea	ReadFehler(pc),a5
	bra	La_CloseFile
La_OK
	movea.l	a4,a0
	bsr	StrLen
	lea	Fertig(pc),a0
	movea.l	RP1(pc),a1
	addq.b	#1,d0
	lsl.b	#3,d0
	move.l	d5,d1
	bsr	Schreib
	suba.l	a5,a5
La_CloseFile
	move.l	d4,d1
	jsr	-36(a6)
La_Ende
	move.l	a5,d0
	beq	La_Ende2
	movea.l	a5,a0
	movea.l	RP1(pc),a1
	moveq	#0,d0
	addi.b	#9,d5
	move.l	d5,d1
	bsr	Schreib
	movea.l	DosBase(pc),a6
	move.l	#150,d1
	jsr	-198(a6)
La_Ende2
	rts

Untersuch
	movem.l	d1-d3/a0/a6,-(sp)
	movea.l	DosBase(pc),a6
	move.l	a0,d1
	moveq	#-2,d2
	jsr	-84(a6)
	move.l	d0,d3
	bne	Us_Examine
	lea	LockFehler(pc),a0
	move.l	a0,d0
	bra	Us_Ende
Us_Examine
	move.l	d3,d1
	lea	FIB(pc),a0
	move.l	a0,d2
	jsr	-102(a6)
	tst.l	d0
	bne	Us_OK
	lea	ExamineFehler(pc),a0
	move.l	a0,d0
	bra	Us_UnLock
Us_OK
	moveq	#0,d0
Us_UnLock
	move.l	d3,d1
	jsr	-90(a6)
Us_Ende
	movem.l	(sp)+,d1-d3/a0/a6
	rts

AllePUs
	movea.l	RP1(pc),a1
	moveq	#0,d0
	move.l	d2,d1
	bsr	Schreib
	lea	Grenze1(pc),a2
	movea.l	IntBase(pc),a6
	movea.l	-112(a6),a4
	movea.l	-106(a6),a5
	move.l	d3,d4
APU_Loop
	movea.l	4(sp),a0
	move.l	d4,d5
	add.w	d7,d5
	lsl.w	#2,d5
	add.w	d4,d5
	add.w	d7,d5
	lsl.w	#2,d5
	movea.l	a3,a1
	adda.l	d5,a1
	move.l	d4,d5
	divu	#12,d5
	move.l	d5,d6
	swap	d5
	ext.l	d5
	move.l	d5,d0
	add.b	d0,d0
	add.b	d5,d0
	lsl.w	#3,d0
	add.w	d0,d5
	addq.w	#7,d5
	move.l	d5,d0
	ext.l	d6
	move.l	d6,d1
	add.b	d1,d1
	add.b	d6,d1
	lsl.b	#3,d1
	add.b	d1,d6
	addq.b	#4,d6
	move.l	d6,d1
	cmpi.b	#102,d3
	bne	APU_Marke1
	cmpi.b	#102,d4
	beq	APU_DrawBorder
APU_Marke1
	jsr	(a4)
APU_DrawBorder
	movea.l	4(sp),a0
	movea.l	a2,a1
	move.l	d5,d0
	subq.w	#1,d0
	move.l	d6,d1
	subq.b	#1,d1
	jsr	(a5)
	dbf	d4,APU_Loop
	cmpi.b	#107,d3
	bne	APU_Ende
	movea.l	4(sp),a0
	movea.l	a2,a1
	move.b	#31,4(a1)
	moveq	#6,d0
	moveq	#3,d1
	jsr	(a5)
	movea.l	a2,a1
	move.b	#4,4(a1)
APU_Ende
	lea	Fertig(pc),a0
	movea.l	RP1(pc),a1
	move.l	#240,d0
	move.l	d2,d1
	bsr	Schreib
	rts

Neu
	bsr	ClrScr
	moveq	#1,d0
	lea	Level(pc),a0
	moveq	#-1,d0
	move.l	d0,(a0)+
	moveq	#16,d0
	move.l	d0,(a0)+
	move.l	d0,(a0)+
	moveq	#0,d0
	moveq	#0,d1
	moveq	#1,d2
	bsr	LoeschKuS
	lea	Lesen(pc),a0
	moveq	#0,d0
	moveq	#9,d1
NE_Loop
	move.l	d0,(a0)+
	dbf	d1,NE_Loop
	lea	MItem5(pc),a0
	moveq	#95,d0
	moveq	#4,d1
NE_Loop2
	move.w	d0,12(a0)
	movea.l	(a0),a0
	dbf	d1,NE_Loop2
	lea	MItem6(pc),a0
	move.w	#351,12(a0)
	move.w	#146,d0
	lea	MItem12(pc),a0
	move.w	d0,12(a0)
	lea	MItem13(pc),a0
	move.w	d0,12(a0)
	moveq	#86,d0
	lea	MItem20(pc),a0
	move.w	d0,12(a0)
	lea	MItem21(pc),a0
	move.w	d0,12(a0)
	tst.b	d6
	beq	NE_Ende
	lea	Produkt(pc),a0
	moveq	#50,d0
NE_Loop3
	move.b	#1,(a0)+
	dbf	d0,NE_Loop3
	bsr	SetzProd
	lea	Buffer1(pc),a0
	moveq	#0,d0
	move.l	d0,(a0)
	lea	SInfo1(pc),a0
	move.l	d0,28(a0)
	lea	UnBuffer1(pc),a0
	move.l	d0,(a0)
	moveq	#0,d2
	bsr	Ausschnitt
	bsr	NeuFTitel
NE_Ende
	rts

LoeschKuS
	movem.l	d0-d1/d6,-(sp)
	move.l	PU(pc),d6
	move.l	PUNr(pc),d0
	bne	LKS_Marke1
	move.b	d6,d1
	moveq	#1,d0
	bsr	FindTyp
	tst.b	d0
	bmi	LKS_Marke2
LKS_Marke1
	clr.b	d6
LKS_Marke2
	movem.l	(sp),d0-d1
	movea.l	Karte(pc),a0
	moveq	#63,d3
LKS_Loop
	moveq	#63,d4
LKS_Vergleich
	cmp.b	d1,d3
	bge	LKS_Karte
	cmp.b	d0,d4
	blt	LKS_Zurueck
LKS_Karte
	move.w	d3,d5
	lsl.w	#6,d5
	add.w	d4,d5
	add.w	d5,d5
	move.b	d6,0(a0,d5.w)
	move.b	#255,1(a0,d5.w)
LKS_Zurueck
	dbf	d4,LKS_Vergleich
	dbf	d3,LKS_Loop
	move.l	y(pc),d0
	subq.b	#1,d0
LKS_Loop2
	move.l	x(pc),d1
	subq.b	#1,d1
LKS_Marke3
	move.l	y(pc),d3
	subq.b	#1,d3
	cmp.b	d0,d3
	beq	LKS_Marke4
	move.l	x(pc),d3
	subq.b	#1,d3
	cmp.b	d1,d3
	bne	LKS_Zurueck2
LKS_Marke4
	move.w	d0,d3
	lsl.w	#6,d3
	add.w	d1,d3
	add.w	d3,d3
	move.b	#174,0(a0,d3.w)
	move.b	#255,1(a0,d3.w)
LKS_Zurueck2
	dbf	d1,LKS_Marke3
	dbf	d0,LKS_Loop2
	tst.b	d2
	beq	LKS_Ende
	lea	Anzahl(pc),a0
	movea.l	Shop(pc),a1
	moveq	#3,d0
	moveq	#0,d1
LKS_Loop3
	moveq	#0,d2
	move.b	(a0)+,d2
	subq.b	#1,d2
	blt	LKS_Zurueck3
LKS_Shop
	move.w	d1,d3
	lsl.b	#2,d3
	add.b	d1,d3
	lsl.b	#2,d3
	add.b	d1,d3
	lsl.b	#2,d3
	add.w	d2,d3
	move.w	d3,d4
	add.w	d3,d3
	add.w	d4,d3
	lsl.w	#2,d3
	add.w	d4,d3
	clr.b	12(a1,d3.w)
	dbf	d2,LKS_Shop
LKS_Zurueck3
	addq.b	#1,d1
	dbf	d0,LKS_Loop3
LKS_Ende
	movem.l	(sp)+,d0-d1/d6
	rts

SetzProd
	lea	SItem41(pc),a0
	lea	Produkt(pc),a1
	moveq	#50,d0
	moveq	#0,d1
SP_Loop
	cmpi.b	#13,d1
	beq	SP_Zurueck
	cmpi.b	#27,d1
	bne	SP_Marke1
	moveq	#14,d0
	moveq	#36,d1
SP_Marke1
	moveq	#0,d2
	move.b	0(a1,d1.w),d2
	lsl.w	#8,d2
	move.w	#347,d3
	sub.w	d2,d3
	move.w	d3,12(a0)
	cmpi.b	#21,d1
	bne	SP_Marke2
	lea	SItem20(pc),a0
	bra	SP_Zurueck
SP_Marke2
	movea.l	(a0),a0
SP_Zurueck
	addq.b	#1,d1
	dbf	d0,SP_Loop
	rts

Ausschnitt
	movea.l	IntBase(pc),a6
	move.l	Modus(pc),d0
	bne	AS_Marke1
	movea.l	FZgr1(pc),a0
	lea	BWarten(pc),a1
	lea	Titel1(pc),a2
	jsr	-276(a6)
AS_Marke1
	movea.l	FZgr1(pc),a0
	bsr	SetPointer
	tst.b	d2
	bne	AS_Marke2
	bsr	ClrScr
AS_Marke2
	movea.l	RP1(pc),a2
	lea	Zahl(pc),a3
	movea.l	Karte(pc),a4
	movea.l	-112(a6),a5
	moveq	#7,d3
AS_Loop
	moveq	#10,d4
	move.l	Ay(pc),d5
	add.w	d3,d5
AS_Marke3
	move.l	Ax(pc),d6
	add.w	d4,d6
	move.w	d5,d7
	lsl.w	#6,d7
	add.w	d6,d7
	add.w	d7,d7
	tst.b	d2
	beq	AS_Marke4
	tst.b	1(a4,d7.w)
	bmi	AS_Zurueck2
AS_Marke4
	movea.l	a2,a0
	movea.l	Part(pc),a1
	moveq	#0,d0
	move.b	0(a4,d7.w),d0
	move.l	d0,d1
	lsl.w	#2,d0
	add.w	d1,d0
	lsl.w	#2,d0
	adda.l	d0,a1
	move.b	d6,d1
	andi.b	#1,d1
	move.b	d1,d0
	add.b	d1,d1
	add.b	d0,d1
	lsl.b	#2,d1
	addi.b	#14,d1
	move.b	d3,d0
	add.b	d0,d0
	add.b	d3,d0
	lsl.b	#3,d0
	add.b	d3,d0
	add.b	d0,d1
	move.w	d4,d0
	add.b	d0,d0
	add.b	d4,d0
	lsl.b	#3,d0
	add.b	d4,d0
	addi.w	#19,d0
	movem.l	d0-d1,-(sp)
	jsr	(a5)
	move.l	ZUnits(pc),d0
	beq	AS_Marke5
	move.b	1(a4,d7.w),d0
	bmi	AS_Marke5
	movea.l	a2,a0
	movea.l	Unit(pc),a1
	move.w	d0,d1
	lsl.w	#2,d0
	add.w	d1,d0
	lsl.w	#2,d0
	adda.l	d0,a1
	movem.l	(sp),d0-d1
	jsr	(a5)
AS_Marke5
	tst.b	d2
	bne	AS_Zurueck
	movea.l	a2,a0
	lea	Grenze1(pc),a1
	movem.l	(sp),d0-d1
	subq.w	#1,d0
	subq.b	#1,d1
	jsr	-108(a6)
	cmpi.b	#7,d3
	bne	AS_Marke6
	movea.l	a3,a0
	move.l	d6,d0
	add.b	d0,d0
	add.b	d6,d0
	addq.b	#3,d0
	adda.l	d0,a0
	movea.l	a2,a1
	move.l	(sp),d0
	addq.w	#4,d0
	moveq	#8,d1
	bsr	Schreib
AS_Marke6
	cmpi.b	#10,d4
	bne	AS_Zurueck
	movea.l	a3,a0
	move.l	d5,d0
	add.b	d0,d0
	add.b	d5,d0
	addq.b	#3,d0
	adda.l	d0,a0
	movea.l	a2,a1
	moveq	#0,d0
	move.l	4(sp),d1
	addi.b	#13,d1
	bsr	Schreib
AS_Zurueck
	addq.l	#8,sp
AS_Zurueck2
	dbf	d4,AS_Marke3
	dbf	d3,AS_Loop
	movea.l	FZgr1(pc),a0
	jsr	-60(a6)
	move.l	Modus(pc),d0
	bne	AS_Ende
	bsr	NeuFTitel
AS_Ende
	rts

InitParts
	lea	PartPos(pc),a2
	movea.l	PartsLib(pc),a3
	movea.l	Part(pc),a4
	move.l	PartIDataZgr(pc),d2
	movea.l	4,a6
	movea.l	-628(a6),a5
	move.l	#174,d3
IP_Loop
	move.l	d3,d4
	lsl.w	#2,d4
	move.l	0(a2,d4.w),d5
	addi.l	#24,d5
	movea.l	a3,a0
	adda.l	d5,a0
	move.b	-15(a0),d6
	move.l	d4,d0
	add.w	d4,d4
	add.w	d0,d4
	add.w	d4,d4
	add.w	d0,d4
	add.w	d4,d4
	add.w	d0,d4
	lsl.l	#3,d4
	movea.l	d2,a1
	adda.l	d4,a1
	move.l	#480,d0
	jsr	(a5)
	move.l	d3,d5
	lsl.w	#2,d5
	add.w	d3,d5
	lsl.w	#2,d5
	movea.l	a4,a0
	adda.l	d5,a0
	moveq	#24,d0
	move.w	d0,4(a0)
	move.w	d0,6(a0)
	moveq	#5,d0
	move.w	d0,8(a0)
	movea.l	d2,a1
	adda.l	d4,a1
	move.l	a1,10(a0)
	move.b	d6,14(a0)
	dbf	d3,IP_Loop
	movea.l	a3,a1
	move.l	PartsGroesse(pc),d0
	jsr	-210(a6)
	lea	PartsLib(pc),a0
	moveq	#0,d0
	move.l	d0,(a0)
	rts

InitUnits
	lea	UnitPos(pc),a2
	movea.l	UnitLib(pc),a3
	movea.l	Unit(pc),a4
	move.l	UnitIDataZgr(pc),d2
	movea.l	4,a6
	moveq	#101,d3
	moveq	#0,d7
IU_Loop
	move.l	d3,d4
	lsl.w	#2,d4			;d4 = UnitPos-Offset
	move.l	0(a2,d4.w),d5
	addi.l	#24,d5
	movea.l	a3,a5
	adda.l	d5,a5			;a5 = Wert2
	move.b	-1(a5),d7		;d7 = Height
	moveq	#0,d6
	move.b	-5(a5),d6
	mulu	d7,d6
	add.w	d6,d6			;d6 = Gr��e
	move.l	d6,d5			;d5 = Gr��e
	add.w	d6,d6
	add.w	d5,d6			;d6 = 3*Gr��e
	movea.l	a5,a0
	adda.l	d5,a0			;a0 = Wert2+Gr��e
	move.l	d4,d0
	add.w	d4,d4
	add.w	d0,d4
	add.w	d4,d4
	add.w	d0,d4
	add.w	d4,d4
	add.w	d0,d4
	lsl.w	#3,d4			;d4 = ImageData-Offset
	movea.l	d2,a1
	adda.l	d4,a1			;a1 = ImageData
	move.l	d6,d0			;d0 = 3*Gr��e
	jsr	-630(a6)
	movea.l	a5,a0			;a0 = Wert2
	movea.l	d2,a1
	adda.l	d4,a1
	adda.l	d6,a1			;a1 = ImageData+3*Gr��e
	move.l	d5,d0			;d0 = Gr��e
	jsr	-630(a6)
	move.l	d3,d5
	lsl.w	#2,d5
	add.w	d3,d5
	lsl.w	#2,d5			;d5 = Image-Offset
	movea.l	a4,a0
	adda.l	d5,a0			;a0 = Image
	move.b	-3(a5),5(a0)		;Width
	move.w	d7,6(a0)		;Height
	moveq	#5,d0
	move.w	d0,8(a0)		;Depth
	movea.l	d2,a1
	adda.l	d4,a1
	move.l	a1,10(a0)		;ImageData
	move.b	d3,d0
	andi.b	#1,d0
	lsl.b	#3,d0
	addq.b	#7,d0
	move.b	d0,14(a0)		;PlanePick
	moveq	#24,d0
	sub.b	d7,d0
	cmpi.b	#59,d3
	beq	IU_Marke2
	cmpi.b	#60,d3
	beq	IU_Marke2
	cmpi.b	#65,d3
	beq	IU_Marke2
	cmpi.b	#66,d3
	beq	IU_Marke2
	cmpi.b	#69,d3
	beq	IU_Marke2
	cmpi.b	#70,d3
	beq	IU_Marke2
	cmpi.b	#58,d3
	blt	IU_Marke1
	cmpi.b	#71,d3
	bgt	IU_Marke1
	cmpi.b	#62,d3
	beq	IU_Marke1
	cmpi.b	#63,d3
	bne	IU_Zurueck
IU_Marke1
	lsr.b	#1,d0
IU_Marke2
	move.b	d0,3(a0)		;TopEdge
IU_Zurueck
	dbf	d3,IU_Loop
	movea.l	a3,a1
	move.l	UnitGroesse(pc),d0
	jsr	-210(a6)
	lea	UnitLib(pc),a0
	moveq	#0,d0
	move.l	d0,(a0)
	rts

NeuFTitel
	lea	Zahl(pc),a0
	lea	Titel5(pc),a1
	move.l	Level(pc),d0
	bpl	NFT_Marke1
	move.b	#$5f,8(a1)
	move.b	#$5f,9(a1)
	bra	NFT_Marke2
NFT_Marke1
	move.b	d0,d1
	add.b	d0,d0
	add.b	d1,d0
	move.b	0(a0,d0.w),8(a1)
	move.b	1(a0,d0.w),9(a1)
NFT_Marke2
	move.l	x(pc),d0
	move.b	d0,d1
	add.b	d0,d0
	add.b	d1,d0
	move.b	0(a0,d0.w),19(a1)
	move.b	1(a0,d0.w),20(a1)
	move.l	y(pc),d0
	move.b	d0,d1
	add.b	d0,d0
	add.b	d1,d0
	move.b	0(a0,d0.w),24(a1)
	move.b	1(a0,d0.w),25(a1)
	move.l	Schritt(pc),d0
	move.b	d0,d1
	add.b	d0,d0
	add.b	d1,d0
	move.b	0(a0,d0.w),35(a1)
	move.b	1(a0,d0.w),36(a1)
	movea.l	IntBase(pc),a6
	movea.l	FZgr1(pc),a0
	lea	Titel1(pc),a2
	jsr	-276(a6)
	rts

Wirklich
	lea	ReqTxt1(pc),a0
	moveq	#16,d0
	move.w	d0,6(a0)
	lea	SiSiSiTxt(pc),a1
	move.l	a1,12(a0)
	lea	Gad4(pc),a0
	moveq	#0,d0
	move.l	d0,(a0)
	movea.l	IntBase(pc),a6
	lea	Req(pc),a0
	movea.l	FZgr1(pc),a1
	jsr	-240(a6)
	tst.l	d0
	bne	WK_WaitPort
	lea	ReqFehler(pc),a0
	movea.l	RP1(pc),a1
	moveq	#0,d0
	moveq	#7,d1
	bsr	Schreib
	movea.l	DosBase(pc),a6
	moveq	#75,d1
	jsr	-198(a6)
	movea.l	IntBase(pc),a6
	jsr	-342(a6)
	movea.l	DosBase(pc),a6
	lea	ConTitel2(pc),a0
	move.l	a0,d1
	move.l	#$3ed,d2
	jsr	-30(a6)
	move.l	d0,d4
	beq	WK_Apokalypse
WK_Loop
	move.l	d4,d1
	lea	SiSiSiTxt(pc),a0
	move.l	a0,d2
	bsr	StrLen
	move.l	d0,d3
	jsr	-48(a6)
	move.l	d4,d1
	lea	GenBuffer(pc),a2
	move.l	a2,d2
	moveq	#1,d3
	jsr	-42(a6)
	cmpi.b	#'j',(a2)
	beq	WK_Ende
	cmpi.b	#'n',(a2)
	bne	WK_Loop
WK_Apokalypse
	moveq	#0,d7
	bra	WK_Close
WK_Ende
	moveq	#1,d7
WK_Close
	move.l	d4,d1
	jsr	-36(a6)
	movea.l	IntBase(pc),a6
	jsr	-336(a6)
	bra	WK_Ende2
WK_WaitPort
	movea.l	4,a6
	movea.l	FZgr1(pc),a2
	movea.l	86(a2),a0
	jsr	-384(a6)
	movea.l	86(a2),a0
	jsr	-372(a6)
	movea.l	d0,a1
	move.l	20(a1),d2
	movea.l	28(a1),a2
	jsr	-378(a6)
	cmpi.b	#$40,d2
	bne	WK_WaitPort
	cmpi.w	#3,38(a2)
	bne	WK_Marke1
	moveq	#1,d7
	bra	WK_Ende2
WK_Marke1
	moveq	#0,d7
WK_Ende2
	lea	ReqTxt1(pc),a0
	moveq	#7,d0
	move.w	d0,6(a0)
	lea	Gad4(pc),a0
	lea	Gad6(pc),a1
	move.l	a1,(a0)
	move.l	d7,d0
	rts

WaehlePU
	movea.l	IntBase(pc),a6
	movea.l	a2,a0
	jsr	-312(a6)
	movea.l	a2,a0
	jsr	-450(a6)
	movea.l	a3,a0
	jsr	-306(a6)
WPU_WaitPort
	movea.l	4,a6
	movea.l	86(a2),a0
	jsr	-384(a6)
	movea.l	86(a2),a0
	jsr	-372(a6)
	movea.l	d0,a1
	move.l	20(a1),d6
	move.w	24(a1),d7
	move.w	32(a1),d4
	move.w	34(a1),d5
	jsr	-378(a6)
	cmpi.w	#$200,d6
	beq	WPU_Ende
	cmpi.b	#$8,d6
	bne	WPU_Class_$400
	cmpi.b	#$68,d7
	bne	WPU_WaitPort
	moveq	#1,d0
	bsr	Wahl
	tst.b	d0
	beq	WPU_WaitPort
	bra	WPU_Ende
WPU_Class_$400
	cmpi.w	#$400,d6
	bne	WPU_WaitPort
	cmpi.b	#$45,d7
	beq	WPU_Ende
	cmpi.b	#$59,d7
	bne	WPU_WaitPort
	move.w	a5,d0
	beq	WPU_WaitPort
	move.l	FZgr5(pc),d0
	cmp.l	a2,d0
	beq	WPU_Ende
	move.l	FZgr3(pc),d0
	cmp.l	a2,d0
	bne	WPU_Marke1
	movea.l	a2,a3
	movea.l	FZgr4,a2
	moveq	#0,d2
	moveq	#65,d3
	bra	WaehlePU
WPU_Marke1
	movea.l	a2,a3
	movea.l	FZgr5,a2
	moveq	#1,d2
	moveq	#102,d3
	bra	WaehlePU
WPU_Ende
	movea.l	IntBase(pc),a6
	movea.l	a2,a0
	jsr	-306(a6)
	movea.l	FZgr1(pc),a0
	jsr	-450(a6)
	rts

Wahl
	move.l	d3,-(sp)
	movea.l	IntBase(pc),a6
	tst.b	d0
	beq	WA_Marke2
	subi.w	#10,d4
	blt	WA_Marke1
	subi.w	#14,d5
	blt	WA_Marke1
	divu	#25,d4
	ext.l	d4
	cmpi.b	#11,d4
	bgt	WA_Marke1
	divu	#25,d5
	ext.l	d5
	move.l	d5,d6
	add.b	d6,d6
	add.b	d5,d6
	lsl.b	#2,d6
	add.b	d4,d6
	cmp.b	d3,d6
	ble	WA_Marke2
WA_Marke1
	moveq	#0,d0
	bra	WA_Ende
WA_Marke2
	move.l	PU(pc),d3
	move.l	PUNr(pc),d0
	bne	WA_Marke4
	cmpi.w	#108,d3
	blt	WA_Marke3
	movea.l	FZgr4(pc),a3
	bra	WA_Marke5
WA_Marke3
	movea.l	FZgr3(pc),a3
	bra	WA_Marke5
WA_Marke4
	movea.l	FZgr5(pc),a3
	tst.b	d3
	bpl	WA_Marke5
	moveq	#102,d3
WA_Marke5
	movea.l	50(a3),a3
	movea.l	a3,a0
	lea	Grenze1(pc),a1
	move.l	d3,d0
	cmpi.w	#108,d0
	blt	WA_Marke6
	subi.w	#108,d0
WA_Marke6
	divu	#12,d0
	move.w	d0,d1
	swap	d0
	ext.l	d0
	move.w	d0,d7
	add.b	d0,d0
	add.b	d7,d0
	lsl.w	#3,d0
	add.w	d7,d0
	addq.w	#6,d0
	ext.l	d1
	move.b	d1,d7
	add.b	d1,d1
	add.b	d7,d1
	lsl.b	#3,d1
	add.b	d7,d1
	addq.b	#3,d1
	jsr	-108(a6)
	move.l	PUNr(pc),d0
	bne	WA_LoeschUnit
	moveq	#1,d0
	move.b	d3,d1
	bsr	FindTyp
	tst.b	d0
	bmi	WA_Marke7
	lea	ShopTeile2(pc),a4
	lsl.b	#2,d0
	movea.l	0(a4,d0.w),a4
	moveq	#0,d3
	move.b	(a4)+,d3
WA_Loop
	movea.l	a3,a0
	lea	Grenze1(pc),a1
	moveq	#0,d7
	move.b	(a4)+,d7
	divu	#12,d7
	move.w	d7,d1
	swap	d7
	move.w	d7,d0
	ext.l	d0
	add.b	d0,d0
	add.b	d7,d0
	lsl.w	#3,d0
	add.w	d7,d0
	addq.w	#6,d0
	ext.l	d1
	move.b	d1,d7
	add.b	d1,d1
	add.b	d7,d1
	lsl.b	#3,d1
	add.b	d7,d1
	addq.b	#3,d1
	jsr	-108(a6)
	dbf	d3,WA_Loop
	bra	WA_Marke7
WA_LoeschUnit
	moveq	#3,d0
	move.b	d3,d1
	bsr	FindTyp
	cmpi.b	#8,d0
	blt	WA_Marke7
	move.l	d3,d7
	andi.b	#1,d7
	lsl.b	#2,d7
	add.b	d3,d7
	subq.b	#2,d7
	movea.l	a3,a0
	lea	Grenze1(pc),a1
	divu	#12,d7
	move.w	d7,d1
	swap	d7
	move.w	d7,d0
	ext.l	d0
	add.b	d0,d0
	add.b	d7,d0
	lsl.w	#3,d0
	add.w	d7,d0
	addq.w	#6,d0
	ext.l	d1
	move.b	d1,d7
	add.b	d1,d1
	add.b	d7,d1
	lsl.b	#3,d1
	add.b	d7,d1
	addq.b	#3,d1
	jsr	-108(a6)
WA_Marke7
	lea	PUNr(pc),a0
	move.l	d2,(a0)
	bne	WA_Marke8
	move.l	FZgr4(pc),d0
	cmp.l	a2,d0
	bne	WA_Marke9
	addi.w	#108,d6
	bra	WA_Marke9
WA_Marke8
	cmpi.b	#102,d6
	bne	WA_Marke9
	move.b	#255,d6
WA_Marke9
	lea	PU(pc),a1
	move.l	d6,(a1)
	movea.l	50(a2),a3
	lea	Grenze1(pc),a1
	move.b	#31,4(a1)
	tst.b	d2
	bne	WA_MarkUnit
	moveq	#1,d0
	move.b	d6,d1
	bsr	FindTyp
	move.w	d0,d2
	bmi	WA_MarkPU
	cmpi.b	#5,d2
	blt	WA_Marke10
	lea	NeutraleTeile(pc),a0
	subq.b	#5,d2
	move.b	0(a0,d2.w),d6
	bra	WA_Marke11
WA_Marke10
	lea	NeutraleTeile(pc),a0
	cmp.b	0(a0,d2.w),d6
	bne	WA_Marke12
WA_Marke11
	movea.l	a3,a0
	lea	Grenze1(pc),a1
	move.l	d6,d0
	divu	#12,d0
	move.w	d0,d1
	swap	d0
	ext.l	d0
	move.w	d0,d3
	add.b	d0,d0
	add.b	d3,d0
	lsl.w	#3,d0
	add.w	d3,d0
	addq.w	#6,d0
	ext.l	d1
	move.b	d1,d3
	add.b	d1,d1
	add.b	d3,d1
	lsl.b	#3,d1
	add.b	d3,d1
	addq.b	#3,d1
	jsr	-108(a6)
WA_Marke12
	lea	ShopTeile2(pc),a4
	lsl.b	#2,d2
	movea.l	0(a4,d2.w),a4
	moveq	#0,d2
	move.b	(a4)+,d2
WA_Loop2
	movea.l	a3,a0
	lea	Grenze1(pc),a1
	moveq	#0,d3
	move.b	(a4)+,d3
	divu	#12,d3
	move.w	d3,d1
	swap	d3
	move.w	d3,d0
	ext.l	d0
	add.b	d0,d0
	add.b	d3,d0
	lsl.w	#3,d0
	add.w	d3,d0
	addq.w	#6,d0
	ext.l	d1
	move.b	d1,d3
	add.b	d1,d1
	add.b	d3,d1
	lsl.b	#3,d1
	add.b	d3,d1
	addq.b	#3,d1
	jsr	-108(a6)
	dbf	d2,WA_Loop2
	bra	WA_MarkPU
WA_MarkUnit
	moveq	#3,d0
	move.b	d6,d1
	bsr	FindTyp
	cmpi.b	#8,d0
	blt	WA_MarkPU
	moveq	#0,d2
	cmpi.b	#61,d6
	bgt	WA_Marke16
	btst.l	#0,d6
	bne	WA_Marke14
	cmpi.b	#8,d0
	beq	WA_Marke13
	addq.b	#2,d6
	bra	WA_Marke20
WA_Marke13
	moveq	#-2,d2
	bra	WA_Marke20
WA_Marke14
	cmpi.b	#8,d0
	beq	WA_Marke15
	subq.b	#2,d6
	bra	WA_Marke20
WA_Marke15
	moveq	#2,d2
	bra	WA_Marke20
WA_Marke16
	cmpi.b	#64,d6
	blt	WA_Marke20
	btst.l	#0,d6
	bne	WA_Marke18
	cmpi.b	#8,d0
	beq	WA_Marke17
	addq.b	#2,d6
	bra	WA_Marke20
WA_Marke17
	moveq	#-2,d2
	bra	WA_Marke20
WA_Marke18
	cmpi.b	#8,d0
	beq	WA_Marke19
	subq.b	#2,d6
	bra	WA_Marke20
WA_Marke19
	moveq	#2,d2
WA_Marke20
	movea.l	a3,a0
	lea	Grenze1(pc),a1
	add.l	d6,d2
	divu	#12,d2
	move.w	d2,d1
	swap	d2
	move.w	d2,d0
	ext.l	d0
	add.b	d0,d0
	add.b	d2,d0
	lsl.w	#3,d0
	add.w	d2,d0
	addq.w	#6,d0
	ext.l	d1
	move.b	d1,d2
	add.b	d1,d1
	add.b	d2,d1
	lsl.b	#3,d1
	add.b	d2,d1
	addq.b	#3,d1
	jsr	-108(a6)
WA_MarkPU
	movea.l	a3,a0
	lea	Grenze1(pc),a1
	move.l	d4,d0
	add.b	d0,d0
	add.b	d4,d0
	lsl.w	#3,d0
	add.w	d4,d0
	addq.w	#6,d0
	move.l	d5,d1
	add.b	d1,d1
	add.b	d5,d1
	lsl.b	#3,d1
	add.b	d5,d1
	addq.b	#3,d1
	jsr	-108(a6)
	lea	Grenze1(pc),a1
	move.b	#4,4(a1)
	lea	PU(pc),a0
	move.l	d6,(a0)
	moveq	#1,d0
WA_Ende
	move.l	(sp)+,d3
	rts

ConWrite
	movea.l	DosBase(pc),a6
	lea	ConTitel1(pc),a0
	move.l	a0,d1
	move.l	#$3ed,d2
	jsr	-30(a6)
	move.l	d0,d4
	beq	CW_Ende
	move.l	d4,d1
	move.l	a5,d2
	movea.l	d2,a0
	bsr	StrLen
	move.l	d0,d3
	jsr	-48(a6)
	tst.l	d0
	beq	CW_CloseCon
	move.l	#150,d1
	jsr	-198(a6)
CW_CloseCon
	move.l	d4,d1
	jsr	-36(a6)
CW_Ende
	rts

Schreib
	movem.l	a0-a1/a6,-(sp)
	movea.l	GfxBase(pc),a6
	jsr	-240(a6)
	movea.l	4(sp),a1
	moveq	#4,d0
	jsr	-342(a6)
	movem.l	(sp)+,a0-a1
	bsr	StrLen
	jsr	-60(a6)
	movea.l	(sp)+,a6
	rts

ClrScr
	move.l	a6,-(sp)
	movea.l	GfxBase(pc),a6
	movea.l	RP1(pc),a1
	moveq	#0,d0
	moveq	#0,d1
	jsr	-240(a6)
	jsr	-48(a6)
	movea.l	(sp)+,a6
	rts

ZaehlShops
	move.l	x(pc),d0
	subq.b	#2,d0
	move.l	y(pc),d1
	subq.b	#2,d1
	subq.b	#2,d2
	move.l	d0,d3
	move.l	d1,d4
	lea	Anzahl(pc),a5
	moveq	#0,d0
	move.l	d0,(a5)
	movea.l	Karte(pc),a3
	movea.l	Shop(pc),a4
	clr.b	26(a4)
	clr.b	27(a4)
ZS_Loop
	move.w	d3,d5
ZS_Loop2
	moveq	#1,d6
ZS_Marke1
	move.w	d4,d0
	lsl.w	#6,d0
	add.w	d5,d0
	add.w	d0,d0
	add.w	d6,d0
	moveq	#0,d1
	move.b	0(a3,d0.w),d1
	cmpi.b	#255,d1
	beq	ZS_Zurueck2
	move.w	d1,d7
	move.b	d6,d0
	addq.b	#1,d0
	bsr	FindTyp
	tst.b	d0
	bmi	ZS_Zurueck2
	cmpi.b	#3,d0
	bgt	ZS_Zurueck2
	movea.w	d2,a0
	movea.w	d0,a1
	suba.w	a6,a6
	move.w	d4,d0
	move.w	d5,d1
	bsr	ShopNr2
	move.l	d0,-(sp)
	move.w	a1,d1
	lsl.b	#2,d1
	add.w	a1,d1
	lsl.b	#2,d1
	add.w	a1,d1
	lsl.b	#2,d1
	move.l	d1,-(sp)
	add.w	d0,d1
	move.w	d1,d0
	add.w	d0,d0
	add.w	d1,d0
	lsl.w	#2,d0
	add.w	d1,d0
	move.l	d0,-(sp)
	move.b	12(a4,d0.w),d1
	cmpi.b	#63,d1
	beq	ZS_Zurueck
	move.w	a1,d0
	bne	ZS_Marke2
	move.l	8(sp),d0
	move.b	#1,26(a4,d0.w)
ZS_Marke2
	move.w	a1,d0
	addq.b	#1,0(a5,d0.w)
	tst.b	d1
	bne	ZS_Marke3
	movea.w	d7,a0
	move.l	8(sp),d1
	bsr	MachShop
ZS_Marke3
	move.w	a2,d0
	beq	ZS_Zurueck
	movea.w	d3,a0
	suba.w	a6,a6
	move.w	d4,d0
	move.w	d5,d1
	bsr	ShopNr2
	move.l	4(sp),d1
	add.w	d0,d1
	move.w	d1,d0
	add.w	d0,d0
	add.w	d1,d0
	lsl.w	#2,d0
	add.w	d1,d0
	move.l	(sp),d1
	moveq	#11,d3
ZS_Loop3
	move.b	0(a4,d1.w),0(a4,d0.w)
	addq.w	#1,d1
	addq.w	#1,d0
	dbf	d3,ZS_Loop3
	move.l	a0,d3
ZS_Zurueck
	lea	12(sp),sp
ZS_Zurueck2
	dbf	d6,ZS_Marke1
	dbf	d5,ZS_Loop2
	dbf	d4,ZS_Loop
	rts

ShopNr
	move.l	a0,-(sp)
	movea.l	FZgr1(pc),a0
	bsr	SetPointer
	movea.l	(sp)+,a0
ShopNr2
	movem.l	d1-d4,-(sp)
	move.w	a1,d2
	bne	SN_Marke1
	lsl.w	#6,d0
	add.w	d0,d1
	add.w	d1,d1
	moveq	#0,d0
	move.b	0(a3,d1.w),d0
	subq.b	#1,d0
	bra	SN_Ende
SN_Marke1
	move.w	d0,d2
	move.w	d1,d3
	moveq	#-1,d4
SN_Marke2
	move.w	d2,d0
	lsl.w	#6,d0
	add.w	d3,d0
	add.w	d0,d0
	moveq	#0,d1
	cmpa.w	#2,a1
	bgt	SN_Marke3
	move.b	0(a3,d0.w),d1
	moveq	#1,d0
	bsr	FindTyp
	cmp.w	a1,d0
	bne	SN_Zurueck
	addq.l	#1,d4
	bra	SN_Zurueck
SN_Marke3
	move.b	1(a3,d0.w),d1
	bmi	SN_Zurueck
	moveq	#2,d0
	bsr	FindTyp
	cmpi.b	#3,d0
	bne	SN_Zurueck
	addq.l	#1,d4
SN_Zurueck
	dbf	d3,SN_Marke2
	move.w	a0,d3
	dbf	d2,SN_Marke2
	move.l	d4,d0
SN_Ende
	move.w	a6,d1
	beq	SN_Ende2
	movem.l	a0-a1/d0,-(sp)
	movea.l	IntBase(pc),a6
	movea.l	FZgr1(pc),a0
	jsr	-60(a6)
	movem.l	(sp)+,a0-a1/d0
SN_Ende2
	movem.l	(sp)+,d1-d4
	rts

FindTyp
	movem.l	d2-d3/a0,-(sp)
	lea	TeilTypListe(pc),a0
	moveq	#2,d2
FT_Loop
	move.b	(a0)+,d3
	cmp.b	d0,d3
	beq	FT_Marke1
	moveq	#0,d3
	move.b	(a0)+,d3
	add.b	d3,d3
	adda.l	d3,a0
	dbf	d2,FT_Loop
	moveq	#-1,d0
	bra	FT_Ende2
FT_Marke1
	moveq	#0,d2
	move.b	(a0)+,d2
	subq.b	#1,d2
FT_Loop2
	move.b	(a0)+,d3
	cmp.b	d1,d3
	beq	FT_Ende
	addq.l	#1,a0
	dbf	d2,FT_Loop2
	moveq	#-1,d0
	bra	FT_Ende2
FT_Ende
	moveq	#0,d0
	move.b	(a0),d0
FT_Ende2
	movem.l	(sp)+,d2-d3/a0
	rts

MachShop
	movem.l	d2-d4/a1,-(sp)
	move.w	a0,d2
	cmpi.b	#3,d0
	bne	MS_Marke1
	andi.b	#1,d2
	bra	MS_Marke4
MS_Marke1
	lea	TypTeilListe(pc),a1
	moveq	#7,d3
MS_Loop
	move.b	(a1)+,d4
	cmp.b	d0,d4
	bne	MS_Marke2
	move.b	(a1)+,d4
	cmp.b	d2,d4
	bne	MS_Marke3
	move.b	(a1),d2
	bra	MS_Marke4
MS_Marke2
	addq.l	#1,a1
MS_Marke3
	addq.l	#1,a1
	dbf	d3,MS_Loop
MS_Marke4
	move.w	d0,d3
	lsl.b	#2,d3
	add.b	d0,d3
	lsl.b	#2,d3
	add.b	d0,d3
	lsl.b	#2,d3
	add.w	d1,d3
	move.w	d3,d4
	add.w	d3,d3
	add.w	d4,d3
	lsl.w	#2,d3
	add.w	d4,d3
	move.b	d2,0(a4,d3.w)
	move.b	d0,1(a4,d3.w)
	move.b	d1,2(a4,d3.w)
	clr.b	3(a4,d3.w)
	clr.b	4(a4,d3.w)
	move.b	#127,12(a4,d3.w)
	moveq	#6,d4
MS_Loop2
	move.b	#255,5(a4,d3.w)
	addq.w	#1,d3
	dbf	d4,MS_Loop2
MS_Ende
	movem.l	(sp)+,d2-d4/a1
	rts

Aender
	lea	AenderListe(pc),a0
	moveq	#11,d0
AE_Loop
	move.l	(a0)+,d3
	cmp.b	d1,d3
	beq	AE_Marke1
	adda.l	#12,a0
	dbf	d0,AE_Loop
	rts
AE_Marke1
	move.l	d4,d0
	movem.l	(a0)+,d1-d3
	add.l	d1,d4
	cmpi.b	#1,d2
	beq	AE_Marke2
	add.l	d2,d5
	rts
AE_Marke2
	andi.w	#1,d0
	subq.l	#1,d0
	add.l	d3,d0
	add.l	d0,d5
	rts

IntToStr
	movem.l	d0-d4/a0-a2,-(sp)
	btst	#31,d0
	beq	ITS_Marke1
	move.b	#'-',(a0)+
	neg.l	d0
ITS_Marke1
	lea	Teiler(pc),a1
	movea.l	a0,a2
	moveq	#8,d1
ITS_Loop
	move.l	(a1)+,d2
	move.l	d0,d3
	moveq	#0,d4
ITS_Marke2
	sub.l	d2,d3
	blt	ITS_Marke3
	sub.l	d2,d0
	addq.b	#1,d4
	bra	ITS_Marke2
ITS_Marke3
	tst.b	d4
	bne	ITS_Marke4
	cmpa.l	a0,a2
	beq	ITS_Marke5
ITS_Marke4
	move.b	d4,(a2)
	addi.b	#48,(a2)+
ITS_Marke5
	dbf	d1,ITS_Loop
	move.b	d0,(a2)
	addi.b	#48,(a2)+
	clr.b	(a2)
	movem.l	(sp)+,d0-d4/a0-a2
	rts

StrCpy
	movem.l	a0-a1,-(sp)
StrCpy_Loop
	move.b	(a0)+,(a1)+
	bne	StrCpy_Loop
	movem.l	(sp)+,a0-a1
	rts

StrCat
	movem.l	a0-a1,-(sp)
StrCat_SearchZero
	tst.b	(a1)+
	bne	StrCat_SearchZero
	subq.l	#1,a1
StrCat_Loop
	move.b	(a0)+,(a1)+
	bne	StrCat_Loop
	movem.l	(sp)+,a0-a1
	rts

StrLen
	movem.l	a0-a1,-(sp)
	movea.l	a0,a1
StrLen_Laenge
	tst.b	(a0)+
	bne	StrLen_Laenge
	subq.l	#1,a0
	suba.l	a1,a0
	move.l	a0,d0
	movem.l	(sp)+,a0-a1
	rts

* Var

		cnop	0,4
Proz		ds.l	1
DosBase		ds.l	1
IntBase		ds.l	1
GfxBase		ds.l	1
SZgr1		ds.l	1
FZgr2		ds.l	1
FZgr5		ds.l	1
FZgr4		ds.l	1
FZgr3		ds.l	1
FZgr1		ds.l	1
RP5		ds.l	1
RP4		ds.l	1
RP3		ds.l	1
RP1		ds.l	1
UhrZgr		ds.l	1
PartsLib	ds.l	1
PartsGroesse	ds.l	1
UnitLib		ds.l	1
UnitGroesse	ds.l	1
FIB		ds.l	65
HLPfad		ds.l	9
Buffer1		ds.l	1
UnBuffer1	ds.l	9
GesamtName	ds.l	12
PBild1		ds.l	5
Schritt		ds.l	1
Durch		ds.l	1
PUNr		ds.l	1
PU		ds.l	1
Altx		ds.l	1
Alty		ds.l	1
ZUnits		ds.l	1
Level		ds.l	1
x		ds.l	1
y		ds.l	1
Lesen		ds.l	1
Schreiben	ds.l	1
Ax		ds.l	1
Ay		ds.l	1
AltAx		ds.l	1
AltAy		ds.l	1
Anzahl		ds.l	1
Modus		ds.l	1
Punkt		ds.l	1
UCount		ds.l	1
Produkt		ds.l	13
GenBuffer	ds.l	4
Topaz		ds.l	1
Stats		ds.l	12
Aldi		ds.l	1
Px		ds.l	1
Py		ds.l	1
Koordx		ds.l	5
WUC		ds.l	1

* Const

MemListe	dc.w	(MemListeEnde-MemListe-6)/8
Part		dc.l	$10000,3500
PartIDataZgr	dc.l	$10002,84000
Unit		dc.l	$10000,2040
UnitIDataZgr	dc.l	$10002,48960
Karte		dc.l	$10000,8192
Shop		dc.l	$10000,4368
MemListeEnde

FontName	dc.b	'topaz.font',0
Titel1		dc.b	'HL Editor 1.2 - � 1993 Werner Reinersmann',0
BWarten		dc.b	'Bitte warten ...',0
Titel2		dc.b	'Karte',0
Units		dc.b	'Units',0
PartsI		dc.b	'Parts I',0
PartsII		dc.b	'Parts II',0
Titel3		dc.b	'Statistik',0
Koord1		dc.w	0,0,25,0,25,25,0,25,0,0
Koord2		dc.w	0,0,47,0,47,11,0,11,0,0
Koord3		dc.w	-4,-2,132,-2,132,9,-4,9,-4,-2
Koord4		dc.w	0,0,63,0,63,11,0,11,0,0
Koord5		dc.w	0,0,154,0,154,59,0,59,0,0
Koord6		dc.w	-4,-2,28,-2,28,9,-4,9,-4,-2
SText1		dc.b	'  MARK IV.',0
SText2		dc.b	'  ST. CHAMMOND',0
SText3		dc.b	'  MARK I.',0
SText4		dc.b	'  RENAULT',0
SText5		dc.b	'  CHARRON',0
SText6		dc.b	'  SOPWITH CAMEL',0
SText7		dc.b	'  SPAD XIII',0
SText8		dc.b	'  SE5A',0
SText9		dc.b	'  SPAD VII',0
SText10		dc.b	'  NIEUPORT',0
SText11		dc.b	'  DH2',0
SText12		dc.b	'  MORANE',0
SText13		dc.b	'  DH4',0
SText14		dc.b	'  HANDLEY',0
SText15		dc.b	'  VOISIN',0
SText16		dc.b	'  TRUPPENTRANSPORT',0
SText17		dc.b	'  PANZERZUG',0
SText18		dc.b	'  SCHIENENGESCH�TZ',0
SText19		dc.b	'  BALLON',0
SText20		dc.b	'  TRANSPORTWAGEN',0
SText21		dc.b	'  KAVALLERIE',0
SText22		dc.b	'  PIONIERE',0
SText23		dc.b	'  PANZERABWEHR',0
SText24		dc.b	'  INFANTERIE',0
SText25		dc.b	'  ELITE INFANTERIE',0
SText26		dc.b	'  DEPOTEINHEIT',0
SText27		dc.b	'  STATION�RE FLAK',0
SText28		dc.b	'  MOBILE FLAK',0
SText29		dc.b	'  SCHWERE ARI',0
SText30		dc.b	'  MITTLERE ARI',0
SText31		dc.b	'  LEICHTE ARI',0
SText32		dc.b	'  FOKKER D VII',0
SText33		dc.b	'  FOKKER DR I.',0
SText34		dc.b	'  ALBATROS',0
SText35		dc.b	'  FOKKER E III.',0
SText36		dc.b	'  FOKKER E I.',0
SText37		dc.b	'  JUNKERS J4-10',0
SText38		dc.b	'  ZEPPELIN STAAKEN',0
SText39		dc.b	'  GOTHA',0
SText40		dc.b	'  A7V',0
SText41		dc.b	'  SP�HPANZER',0
SText42		dc.b	'  64',0
SText43		dc.b	'  56',0
SText44		dc.b	'  48',0
SText45		dc.b	'  40',0
SText46		dc.b	'  32',0
SText47		dc.b	'  24',0
SText48		dc.b	'  16',0
SText49		dc.b	'   8',0
SText50		dc.b	'   4',0
SText51		dc.b	'   2',0
SText52		dc.b	'  C',0
SText53		dc.b	'  B',0
SText54		dc.b	'  A',0
NText1		dc.b	'  Weg         ',0
NText2		dc.b	'  Stra�e      ',0
NText3		dc.b	'  Schiene     ',0
NText4		dc.b	'  Flu�        ',0
NText5		dc.b	'  F�llen      ',0
NText6		dc.b	'  Normal      ',0
NText7		dc.b	'Units          ',0
NText8		dc.b	'Parts II       ',0
NText9		dc.b	'Parts I        ',0
NText10		dc.b	'Produktion II �',0
NText11		dc.b	'Produktion I  �',0
NText12		dc.b	'H�he          �',0
NText13		dc.b	'Breite        �',0
NText14		dc.b	'  Statistik     ',0
NText15		dc.b	'  Units         ',0
NText16		dc.b	'  Schritte     �',0
NText17		dc.b	'  Palette      �',0
NText18		dc.b	'  Karte         ',0
NText19		dc.b	'Ende        ',0
NText20		dc.b	'Sichern     ',0
NText21		dc.b	'Laden       ',0
NText22		dc.b	'Neu         ',0
GText1		dc.b	'OK',0
GText2		dc.b	'Abbruch',0
GText3		dc.b	'Level :',0
RText1		dc.b	'HL MAP & LIB Pfad',0
MText1		dc.b	'Modus',0
MText2		dc.b	'Edit',0
MText3		dc.b	'Karte',0
MText4		dc.b	'Projekt',0
Titel4		dc.b	'Shop Info',0
Pens		dc.w	0,4,0,4,0,22,0,5,4,1,-1

		cnop	0,4
ZSatz1		dc.l	FontName
		dc.w	8
		dc.b	0,1
Schirm1		dc.w	0,0,320,256,5
		dc.b	0,1
		dc.w	0,$F
		dc.l	ZSatz1,Titel1,0,0
Schirm1Tags	dc.l	$8000003a,Pens		;SA_Pens
		dc.l	0,0
Fenst1		dc.w	0,12,320,244
		dc.b	0,4
		dc.l	$5c8,$1400,0,0,BWarten,0,0
		dc.w	0,0,0,0,$F
Fenst2		dc.w	85,49,149,158
		dc.b	0,4
		dc.l	$208,$1408,0,0,Titel2,0,0
		dc.w	0,0,0,0,$F
Fenst3		dc.w	0,12,320,244
		dc.b	0,4
		dc.l	$608,$408,0,0,Units,0,0
		dc.w	0,0,0,0,$F
Fenst4		dc.w	33,99,252,55
		dc.b	0,4
		dc.l	$200,$1408,0,0,Titel3,0,0
		dc.w	0,0,0,0,$F
Grenze1		dc.w	0,0
		dc.b	4,0,0,5
		dc.l	Koord1,0
Grenze2		dc.w	0,0
		dc.b	4,0,0,5
		dc.l	Koord2,0
Grenze3		dc.w	0,0
		dc.b	4,0,0,5
		dc.l	Koord3,0
Grenze4		dc.w	0,0
		dc.b	4,0,0,5
		dc.l	Koord4,0
Grenze5		dc.w	0,0
		dc.b	4,0,0,5
		dc.l	Koord5,0
Grenze6		dc.w	0,0
		dc.b	4,0,0,5
		dc.l	Koord6,0
SITxt1		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText1,0
SITxt2		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText2,0
SITxt3		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText3,0
SITxt4		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText4,0
SITxt5		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText5,0
SITxt6		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText6,0
SITxt7		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText7,0
SITxt8		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText8,0
SITxt9		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText9,0
SITxt10		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText10,0
SITxt11		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText11,0
SITxt12		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText12,0
SITxt13		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText13,0
SITxt14		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText14,0
SITxt15		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText15,0
SITxt16		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText16,0
SITxt17		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText17,0
SITxt18		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText18,0
SITxt19		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText19,0
SITxt20		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText20,0
SITxt21		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText21,0
SITxt22		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText22,0
SITxt23		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText23,0
SITxt24		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText24,0
SITxt25		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText25,0
SITxt26		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText26,0
SITxt27		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText27,0
SITxt28		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText28,0
SITxt29		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText29,0
SITxt30		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText30,0
SITxt31		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText31,0
SITxt32		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText32,0
SITxt33		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText33,0
SITxt34		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText34,0
SITxt35		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText35,0
SITxt36		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText36,0
SITxt37		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText37,0
SITxt38		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText38,0
SITxt39		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText39,0
SITxt40		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText40,0
SITxt41		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText41,0
SITxt42		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText42,0
SITxt43		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText43,0
SITxt44		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText44,0
SITxt45		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText45,0
SITxt46		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText46,0
SITxt47		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText47,0
SITxt48		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText48,0
SITxt49		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText49,0
SITxt50		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText50,0
SITxt51		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText51,0
SITxt52		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText52,0
SITxt53		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText53,0
SITxt54		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,SText54,0
MITxt1		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText1,0
MITxt2		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText2,0
MITxt3		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText3,0
MITxt4		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText4,0
MITxt5		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText5,0
MITxt6		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText6,0
MITxt7		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText7,0
MITxt8		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText8,0
MITxt9		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText9,0
MITxt10		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText10,0
MITxt11		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText11,0
MITxt12		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText12,0
MITxt13		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText13,0
MITxt14		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText14,0
MITxt15		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText15,0
MITxt16		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText16,0
MITxt17		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText17,0
MITxt18		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText18,0
MITxt19		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText19,0
MITxt20		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText20,0
MITxt21		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText21,0
MITxt22		dc.b	0,4,1,0
		dc.w	0,0
		dc.l	0,NText22,0
GadTxt1		dc.b	4,0,0,0
		dc.w	4,2
		dc.l	0,Units,0
GadTxt2		dc.b	4,0,0,0
		dc.w	22,2
		dc.l	0,GText1,0
GadTxt3		dc.b	4,0,0,0
		dc.w	4,2
		dc.l	0,GText2,0
GadTxt4		dc.b	4,0,0,0
		dc.w	-63,0
		dc.l	0,GText3,0
ReqTxt1		dc.b	4,0,0,0
		dc.w	9,7
		dc.l	0,RText1,0
SItem1		dc.l	0
		dc.w	36,171,144,9,91
		dc.l	0,SITxt1,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem2		dc.l	SItem1
		dc.w	36,162,144,9,91
		dc.l	0,SITxt2,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem3		dc.l	SItem2
		dc.w	36,153,144,9,91
		dc.l	0,SITxt3,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem4		dc.l	SItem3
		dc.w	36,144,144,9,91
		dc.l	0,SITxt4,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem5		dc.l	SItem4
		dc.w	36,135,144,9,91
		dc.l	0,SITxt5,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem6		dc.l	SItem5
		dc.w	36,126,144,9,91
		dc.l	0,SITxt6,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem7		dc.l	SItem6
		dc.w	36,117,144,9,91
		dc.l	0,SITxt7,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem8		dc.l	SItem7
		dc.w	36,108,144,9,91
		dc.l	0,SITxt8,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem9		dc.l	SItem8
		dc.w	36,99,144,9,91
		dc.l	0,SITxt9,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem10		dc.l	SItem9
		dc.w	36,90,144,9,91
		dc.l	0,SITxt10,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem11		dc.l	SItem10
		dc.w	36,81,144,9,91
		dc.l	0,SITxt11,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem12		dc.l	SItem11
		dc.w	36,72,144,9,91
		dc.l	0,SITxt12,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem13		dc.l	SItem12
		dc.w	36,63,144,9,91
		dc.l	0,SITxt13,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem14		dc.l	SItem13
		dc.w	36,54,144,9,91
		dc.l	0,SITxt14,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem15		dc.l	SItem14
		dc.w	36,45,144,9,91
		dc.l	0,SITxt15,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem16		dc.l	SItem15
		dc.w	36,36,144,9,91
		dc.l	0,SITxt16,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem17		dc.l	SItem16
		dc.w	36,27,144,9,91
		dc.l	0,SITxt17,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem18		dc.l	SItem17
		dc.w	36,18,144,9,91
		dc.l	0,SITxt18,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem19		dc.l	SItem18
		dc.w	36,9,144,9,91
		dc.l	0,SITxt19,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem20		dc.l	SItem19
		dc.w	36,0,144,9,91
		dc.l	0,SITxt20,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem21		dc.l	0
		dc.w	36,180,144,9,91
		dc.l	0,SITxt21,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem22		dc.l	SItem21
		dc.w	36,171,144,9,91
		dc.l	0,SITxt22,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem23		dc.l	SItem22
		dc.w	36,162,144,9,91
		dc.l	0,SITxt23,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem24		dc.l	SItem23
		dc.w	36,153,144,9,91
		dc.l	0,SITxt24,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem25		dc.l	SItem24
		dc.w	36,144,144,9,91
		dc.l	0,SITxt25,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem26		dc.l	SItem25
		dc.w	36,135,144,9,91
		dc.l	0,SITxt26,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem27		dc.l	SItem26
		dc.w	36,126,144,9,91
		dc.l	0,SITxt27,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem28		dc.l	SItem27
		dc.w	36,117,144,9,91
		dc.l	0,SITxt28,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem29		dc.l	SItem28
		dc.w	36,108,144,9,91
		dc.l	0,SITxt29,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem30		dc.l	SItem29
		dc.w	36,99,144,9,91
		dc.l	0,SITxt30,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem31		dc.l	SItem30
		dc.w	36,90,144,9,91
		dc.l	0,SITxt31,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem32		dc.l	SItem31
		dc.w	36,81,144,9,91
		dc.l	0,SITxt32,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem33		dc.l	SItem32
		dc.w	36,72,144,9,91
		dc.l	0,SITxt33,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem34		dc.l	SItem33
		dc.w	36,63,144,9,91
		dc.l	0,SITxt34,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem35		dc.l	SItem34
		dc.w	36,54,144,9,91
		dc.l	0,SITxt35,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem36		dc.l	SItem35
		dc.w	36,45,144,9,91
		dc.l	0,SITxt36,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem37		dc.l	SItem36
		dc.w	36,36,144,9,91
		dc.l	0,SITxt37,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem38		dc.l	SItem37
		dc.w	36,27,144,9,91
		dc.l	0,SITxt38,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem39		dc.l	SItem38
		dc.w	36,18,144,9,91
		dc.l	0,SITxt39,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem40		dc.l	SItem39
		dc.w	36,9,144,9,91
		dc.l	0,SITxt40,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem41		dc.l	SItem40
		dc.w	36,0,144,9,91
		dc.l	0,SITxt41,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem42		dc.l	0
		dc.w	90,54,32,9,91
		dc.l	63,SITxt42,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem43		dc.l	SItem42
		dc.w	90,45,32,9,91
		dc.l	95,SITxt43,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem44		dc.l	SItem43
		dc.w	90,36,32,9,91
		dc.l	111,SITxt44,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem45		dc.l	SItem44
		dc.w	90,27,32,9,91
		dc.l	119,SITxt45,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem46		dc.l	SItem45
		dc.w	90,18,32,9,91
		dc.l	123,SITxt46,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem47		dc.l	SItem46
		dc.w	90,9,32,9,91
		dc.l	125,SITxt47,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem48		dc.l	SItem47
		dc.w	90,0,32,9,347
		dc.l	126,SITxt48,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem49		dc.l	0
		dc.w	90,54,32,9,91
		dc.l	63,SITxt42,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem50		dc.l	SItem49
		dc.w	90,45,32,9,91
		dc.l	95,SITxt43,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem51		dc.l	SItem50
		dc.w	90,36,32,9,91
		dc.l	111,SITxt44,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem52		dc.l	SItem51
		dc.w	90,27,32,9,91
		dc.l	119,SITxt45,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem53		dc.l	SItem52
		dc.w	90,18,32,9,91
		dc.l	123,SITxt46,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem54		dc.l	SItem53
		dc.w	90,9,32,9,91
		dc.l	125,SITxt47,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem55		dc.l	SItem54
		dc.w	90,0,32,9,347
		dc.l	126,SITxt48,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem56		dc.l	0
		dc.w	90,27,32,9,91
		dc.l	7,SITxt48,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem57		dc.l	SItem56
		dc.w	90,18,32,9,91
		dc.l	11,SITxt49,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem58		dc.l	SItem57
		dc.w	90,9,32,9,91
		dc.l	13,SITxt50,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem59		dc.l	SItem58
		dc.w	90,0,32,9,347
		dc.l	14,SITxt51,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem60		dc.l	0
		dc.w	90,18,24,9,91
		dc.l	3,SITxt52,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem61		dc.l	SItem60
		dc.w	90,9,24,9,347
		dc.l	5,SITxt53,0
		dc.b	0,0
		dc.l	0
		dc.w	0
SItem62		dc.l	SItem61
		dc.w	90,0,24,9,91
		dc.l	6,SITxt54,0
		dc.b	0,0
		dc.l	0
		dc.w	0
MItem1		dc.l	0
		dc.w	0,45,112,9,95
		dc.l	31,MITxt1,0
		dc.b	'B',0
		dc.l	0
		dc.w	0
MItem2		dc.l	MItem1
		dc.w	0,36,112,9,95
		dc.l	47,MITxt2,0
		dc.b	'V',0
		dc.l	0
		dc.w	0
MItem3		dc.l	MItem2
		dc.w	0,27,112,9,95
		dc.l	55,MITxt3,0
		dc.b	'C',0
		dc.l	0
		dc.w	0
MItem4		dc.l	MItem3
		dc.w	0,18,112,9,95
		dc.l	59,MITxt4,0
		dc.b	'X',0
		dc.l	0
		dc.w	0
MItem5		dc.l	MItem4
		dc.w	0,9,112,9,95
		dc.l	61,MITxt5,0
		dc.b	'F',0
		dc.l	0
		dc.w	0
MItem6		dc.l	MItem5
		dc.w	0,0,112,9,351
		dc.l	62,MITxt6,0
		dc.b	'Y',0
		dc.l	0
		dc.w	0
MItem7		dc.l	0
		dc.w	0,54,120,9,86
		dc.l	0,MITxt7,0
		dc.b	'U',0
		dc.l	0
		dc.w	0
MItem8		dc.l	MItem7
		dc.w	0,45,120,9,86
		dc.l	0,MITxt8,0
		dc.b	'2',0
		dc.l	0
		dc.w	0
MItem9		dc.l	MItem8
		dc.w	0,36,120,9,86
		dc.l	0,MITxt9,0
		dc.b	'1',0
		dc.l	0
		dc.w	0
MItem10		dc.l	MItem9
		dc.w	0,27,120,9,146
		dc.l	0,MITxt10,0
		dc.b	0,0
		dc.l	SItem20
		dc.w	0
MItem11		dc.l	MItem10
		dc.w	0,18,120,9,146
		dc.l	0,MITxt11,0
		dc.b	0,0
		dc.l	SItem41
		dc.w	0
MItem12		dc.l	MItem11
		dc.w	0,9,120,9,146
		dc.l	0,MITxt12,0
		dc.b	0,0
		dc.l	SItem48
		dc.w	0
MItem13		dc.l	MItem12
		dc.w	0,0,120,9,146
		dc.l	0,MITxt13,0
		dc.b	0,0
		dc.l	SItem55
		dc.w	0
MItem14		dc.l	0
		dc.w	0,36,128,9,86
		dc.l	0,MITxt14,0
		dc.b	'T',0
		dc.l	0
		dc.w	0
MItem15		dc.l	MItem14
		dc.w	0,27,128,9,351
		dc.l	0,MITxt15,0
		dc.b	'A',0
		dc.l	0
		dc.w	0
MItem16		dc.l	MItem15
		dc.w	0,18,128,9,146
		dc.l	0,MITxt16,0
		dc.b	0,0
		dc.l	SItem59
		dc.w	0
MItem17		dc.l	MItem16
		dc.w	0,9,128,9,146
		dc.l	0,MITxt17,0
		dc.b	0,0
		dc.l	SItem62
		dc.w	0
MItem18		dc.l	MItem17
		dc.w	0,0,128,9,86
		dc.l	0,MITxt18,0
		dc.b	'K',0
		dc.l	0
		dc.w	0
MItem19		dc.l	0
		dc.w	0,27,96,9,86
		dc.l	0,MITxt19,0
		dc.b	'E',0
		dc.l	0
		dc.w	0
MItem20		dc.l	MItem19
		dc.w	0,18,96,9,86
		dc.l	0,MITxt20,0
		dc.b	'S',0
		dc.l	0
		dc.w	0
MItem21		dc.l	MItem20
		dc.w	0,9,96,9,86
		dc.l	0,MITxt21,0
		dc.b	'L',0
		dc.l	0
		dc.w	0
MItem22		dc.l	MItem21
		dc.w	0,0,96,9,86
		dc.l	0,MITxt22,0
		dc.b	'N',0
		dc.l	0
		dc.w	0
Menu1		dc.l	0
		dc.w	176,0,48,9,1
		dc.l	MText1,MItem6
		dc.w	0,0,0,0
Menu2		dc.l	Menu1
		dc.w	128,0,40,9,1
		dc.l	MText2,MItem13
		dc.w	0,0,0,0
Menu3		dc.l	Menu2
		dc.w	72,0,48,9,1
		dc.l	MText3,MItem18
		dc.w	0,0,0,0
Menu4		dc.l	Menu3
		dc.w	0,0,64,9,1
		dc.l	MText4,MItem22
		dc.w	0,0,0,0
PInfo1		dc.w	3,0,0,$FF,0,0,0,0,0,0,0
SInfo1		dc.l	HLPfad,UnBuffer1
		dc.w	0,32,0,0,0,0,0,0
		dc.l	0,0,0
Gad1		dc.l	0
		dc.w	6,38,176,8,0,11,3
		dc.l	PBild1,0,0,0,PInfo1
		dc.w	0
		dc.l	0
Gad2		dc.l	Gad1
		dc.w	74,83,48,12,0,3,1
		dc.l	Grenze2,0,GadTxt1,0,0
		dc.w	1
		dc.l	0
Gad3		dc.l	0
		dc.w	13,24,128,8,0,7,4100
		dc.l	Grenze3,0,0,0,SInfo1
		dc.w	2
		dc.l	0
Gad4		dc.l	Gad3
		dc.w	9,41,64,12,0,7,4097
		dc.l	Grenze4,0,GadTxt2,0,0
		dc.w	3
		dc.l	0
Gad5		dc.l	Gad4
		dc.w	82,41,64,12,0,7,4097
		dc.l	Grenze4,0,GadTxt3,0,0
		dc.w	4
		dc.l	0
Gad6		dc.l	0
		dc.w	80,24,24,8,0,$807,4100
		dc.l	Grenze6,0,GadTxt4,0,SInfo1
		dc.w	5
		dc.l	0
Fenst5		dc.w	62,71,196,114
		dc.b	0,4
		dc.l	$258,$1408,Gad2,0,Titel4,0,0
		dc.w	0,0,0,0,$F
Req		dc.l	0
		dc.w	78,87,155,60,0,0
		dc.l	Gad5,Grenze5,ReqTxt1
		dc.w	0
		dc.b	18,0
		dc.l	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
Unitx		dc.w	0,0,24,24,5
		dc.l	0
		dc.b	7,0
		dc.l	0

Farbe		dc.w	$000,$9AC,$658,$314,$FFF,$BBB,$888,$444
		dc.w	$000,$CB8,$864,$421,$EDD,$AAA,$666,$222
		dc.w	$8A0,$780,$570,$450,$340,$130,$5BB,$489
		dc.w	$356,$DB8,$B86,$864,$642,$421,$433,$900
		dc.w	$000,$E40,$910,$500,$FFF,$BBB,$888,$444
		dc.w	$000,$6D2,$481,$240,$EDD,$AAA,$666,$222
		dc.w	$8A0,$780,$570,$450,$340,$130,$5BB,$489
		dc.w	$356,$DB8,$B86,$864,$642,$421,$433,$900
		dc.w	$000,$4DF,$28A,$146,$FFF,$BBB,$888,$444
		dc.w	$000,$FF4,$A91,$640,$EDD,$AAA,$666,$222
		dc.w	$8A0,$780,$570,$450,$340,$130,$5BB,$489
		dc.w	$356,$DB8,$B86,$864,$642,$421,$433,$900
KFarbe		dc.b	16,01,09,14,14,14,14,14,14,14,14,14,14,01,09,14,01
		dc.b	09,14,14,14,14,14,14,14,22,22,22,22,22,22,22,22,22
		dc.b	22,23,22,22,22,22,22,22,22,22,22,22,22,23,24,16,16
		dc.b	16,05,05,18,19,20,21,25,25,06,06,06,26,27,17,17,17
		dc.b	17,17,17,27,27,27,27,28,28,28,16,16,16,26,26,26,26
		dc.b	15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
		dc.b	15,15,15,25,25,05,05,05,05,05,05,05,05,05,05,05,05
		dc.b	16,16,05,05,16,16,16,16,05,05,05,05,05,05,05,05,05
		dc.b	05,05,05,05,05,05,05,05,05,05,25,25,25,25,25,25,25
		dc.b	25,25,25,25,25,25,25,25,25,25,25,25,26,26,26,26,26
		dc.b	26,26,26,26,31
PartPos		dc.l	31156,15028,15532,16036,16540,17044,17548,18052
		dc.l	18556,07564,07060,06556,06052,05548,05044,00508
		dc.l	01012,01516,00004,02020,02524,03028,03532,04036
		dc.l	04540,63964,64972,65476,65980,66484,66988,67492
		dc.l	67996,68500,69004,69508,70012,70516,71020,71524
		dc.l	72028,72532,73036,73540,74044,74548,75052,64468
		dc.l	86644,19060,19564,20068,75556,76060,38020,10084
		dc.l	38428,38836,76564,77068,08068,08572,09076,34996
		dc.l	39244,39748,40156,40564,41068,41476,41980,42388
		dc.l	42892,43396,43900,10492,10996,11500,31468,31972
		dc.l	32476,32980,33484,33988,34492,21580,22084,22588
		dc.l	23092,23596,24100,24604,25108,25612,26116,26620
		dc.l	09580,27124,27628,28132,28636,29140,29644,30148
		dc.l	30652,20572,21076,80596,81100,81604,82108,82612
		dc.l	83116,83620,84124,84628,85132,85636,86140,78580
		dc.l	79084,79588,80092,12004,12508,77572,78076,44404
		dc.l	44908,45412,45916,46420,46924,47428,47932,48436
		dc.l	48940,49444,49948,50452,50956,51460,51964,52468
		dc.l	52972,53476,53980,54484,54988,55492,55996,56500
		dc.l	57004,57508,58012,58516,59020,59524,60028,60532
		dc.l	60940,61444,61948,62452,62956,35500,36004,36508
		dc.l	37012,37516,14524,14020,13012,13516,63460
UnitPos		dc.l	02844,01908,00956,00004,04780,03780,09116,07812
		dc.l	06796,05780,17548,16516,19580,18580,11420,10420
		dc.l	13452,12420,15500,14484,21404,20580,23100,22228
		dc.l	24956,23972,26924,25940,28908,27908,30556,29908
		dc.l	32204,31204,33964,33204,35532,34724,38476,37540
		dc.l	36940,36340,40092,39412,41772,40772,43612,42772
		dc.l	45516,44452,47500,46580,49156,48420,50500,49892
		dc.l	54964,54244,58036,57252,56468,55684,59540,58820
		dc.l	62476,61732,60996,60260,53460,52676,51892,51108
		dc.l	68156,67188,66220,65252,64236,63220,72252,71220
		dc.l	70172,69124,74284,73284,80492,79508,78476,77444
		dc.l	82476,81476,76364,75284,86332,85316,91948,91156
		dc.l	88300,87348,84396,83476,90204,89252
Zahl		dc.b	'00',0,'01',0,'02',0,'03',0,'04',0,'05',0,'06',0
		dc.b	'07',0,'08',0,'09',0,'10',0,'11',0,'12',0,'13',0
		dc.b	'14',0,'15',0,'16',0,'17',0,'18',0,'19',0,'20',0
		dc.b	'21',0,'22',0,'23',0,'24',0,'25',0,'26',0,'27',0
		dc.b	'28',0,'29',0,'30',0,'31',0,'32',0,'33',0,'34',0
		dc.b	'35',0,'36',0,'37',0,'38',0,'39',0,'40',0,'41',0
		dc.b	'42',0,'43',0,'44',0,'45',0,'46',0,'47',0,'48',0
		dc.b	'49',0,'50',0,'51',0,'52',0,'53',0,'54',0,'55',0
		dc.b	'56',0,'57',0,'58',0,'59',0,'60',0,'61',0,'62',0
		dc.b	'63',0,'64',0,'65',0,'66',0,'67',0,'68',0,'69',0
		dc.b	'70',0,'71',0
UhrDat		dc.w	$0000,$0000,$0400,$07c0,$0000,$07c0,$0100,$0380,$0000
		dc.w	$07e0,$07c0,$1ff8,$1ff0,$3fec,$3ff8,$7fde,$3ff8,$7fbe
		dc.w	$7ffc,$ff7f,$7efc,$ffff,$7ffc,$ffff,$3ff8,$7ffe,$3ff8
		dc.w	$7ffe,$1ff0,$3ffc,$07c0,$1ff8,$0000,$07e0,$0000,$0000

DosName		dc.b	'dos.library',0
IntName		dc.b	'intuition.library',0
GfxName		dc.b	'graphics.library',0
LibNameTab	dc.l	DosName,IntName,GfxName
DosFehler	dc.b	'Dos Library konnte nicht ge�ffnet werden !',0
IntFehler	dc.b	'Intuition Library konnte nicht ge�ffnet werden !',0
GfxFehler	dc.b	'Graphics Library konnte nicht ge�ffnet werden !',0
LibFehlerTab	dc.l	DosFehler,IntFehler,GfxFehler
ScreenFehler	dc.b	'Schirm konnte nicht ge�ffnet werden !',0
FenstFehler	dc.b	'Fenster konnte nicht ge�ffnet werden !',0
MenuFehler	dc.b	'Menus konnten nicht erstellt werden !',0
ReqFehler	dc.b	'Requester konnte nicht ge�ffnet werden !',0
LockFehler	dc.b	'Datei existiert nicht !',0
ExamineFehler	dc.b	'Datei konnte nicht untersucht werden !',0
AllocMemFehler	dc.b	'Speicher konnte nicht reserviert werden !',0
OpenFehler	dc.b	'Datei konnte nicht ge�ffnet werden !',0
GepacktFehler	dc.b	'Datei gepackt !',0
ReadFehler	dc.b	'Fehler beim Lesen der Datei !',0
ConTitel1	dc.b	'CON:0/118/640/21/Fehler !',0
ConTitel2	dc.b	'CON:0/118/640/21/Requesterersatz ...',0
Fertig		dc.b	'Fertig !',0
PartsLibName	dc.b	'Lade PARTS.LIB ...',0
PartsLibPfad	dc.b	'LIB/PARTS.LIB',0
UnitLibName	dc.b	'Lade UNIT.LIB  ...',0
UnitLibPfad	dc.b	'LIB/UNIT.LIB',0
HL6		dc.b	'HL6:',0
ErstPartsI	dc.b	'Erstelle Fenster Parts I  ...',0
ErstPartsII	dc.b	'Erstelle Fenster Parts II ...',0
ErstUnits	dc.b	'Erstelle Fenster Units    ...',0
Titel5		dc.b	'Level : __ Gr��e : xx * yy Schr. : ss',0
ScrollListe	dc.l	$1d,-1,01,$1e,00,01,$1f,01,01,$2d,-1,00,$2f,01,00
		dc.l	$3d,-1,-1,$3e,00,-1,$3f,01,-1,$4c,00,-1,$4d,00,01
		dc.l	$4e,01,00,$4f,-1,00
LvlLaden	dc.b	'Level laden ...',0
LvlSichern	dc.b	'Level sichern ...',0
LadenText	dc.b	'Lade Level xx ...',0
SichernText	dc.b	'Schreibe Level xx ...',0
FinName		dc.b	'MAP/xx.FIN',0
LadeFin		dc.b	'Lade xx.FIN ...',0
SichFin		dc.b	'Schreibe xx.FIN ...',0
ShpName		dc.b	'MAP/xx.SHP',0
LadeShp		dc.b	'Lade xx.SHP ...',0
SichShp		dc.b	'Schreibe xx.SHP ...',0
ZaehlShpText	dc.b	'Z�hle Shops ...',0
TypTeilListe	dc.b	00,01,00,00,02,01
		dc.b	01,12,02,01,13,00,01,14,01
		dc.b	02,15,02,02,16,00,02,17,01
TeilTypListe	dc.b	01,20
		dc.b	01,00,02,00,03,05,04,05,05,05,06,05,07,05,08,05,09,06
		dc.b	10,06,11,06,12,01,13,01,14,01,15,02,16,02,17,02,18,07
		dc.b	19,07,20,07
		dc.b	02,06
		dc.b	44,03,45,03,52,03,53,03,62,03,63,03
		dc.b	03,12
		dc.b	58,09,59,08,60,08,61,09,64,09,65,08,66,08,67,09,68,09
		dc.b	69,08,70,08,71,09
AenderListe	dc.l	03,00,-1,00,04,00,-2,00,05,01,01,00,06,01,01,-1
		dc.l	07,-1,01,00,08,-1,01,-1,09,01,01,01,10,01,01,00
		dc.l	11,02,00,00,18,00,-1,00,19,01,01,00,20,-1,01,00
ShopTyp		dc.b	'HQ',0,'Fabrik',0,'Depot',0,'Transporter',0
ShopBes		dc.b	'Spieler 1',0,'Spieler 2',0,'Neutral',0
ShopTypTab	dc.l	ShopTyp,ShopTyp+3,ShopTyp+10,ShopTyp+16
ShopBesTab	dc.l	ShopBes,ShopBes+10,ShopBes+20
SI_Typ		dc.b	'      Typ :',0
SI_Besitzer	dc.b	' Besitzer :',0
SI_Nr		dc.b	'      Nr. :',0
SI_Rohstoffe	dc.b	'Rohstoffe :',0
ClassSprung	dc.l	$8,ExModus,$100,MenuHandel,$400,TastaturHandel
Teiler		dc.l	1000000000,100000000,10000000,1000000,100000,10000,
		dc.l	1000,100,10
LPTxt		dc.b	'Lade Pfad ...',0
PfadName	dc.b	'S:HLPfad',0
FenstTab	dc.l	Fenst3,Fenst3,Fenst3,Fenst1
TitelTab	dc.l	BWarten,PartsI,PartsII,Units
SiSiSiTxt	dc.b	'Sind Sie sicher ? (j/n) ',0
EZKTxt		dc.b	'Eins  Zwei  Karte',0
StatsTxt	dc.b	' Fabriken :',0,'   Depots :',0,'Rohstoffe :',0
		dc.b	'    Units :',0
ModsTxt		dc.b	'Modus : F�llen ',0,'Modus : Flu�   ',0
		dc.b	'Modus : Schiene',0,'Modus : Stra�e ',0
		dc.b	'Modus : Weg    ',0
ModsTxtTab	dc.l	ModsTxt,ModsTxt+16,ModsTxt+32,ModsTxt+48,ModsTxt+64
ZweiHQsTxt	dc.b	'Es mu� zwei HQs geben !',0
HQFelder	dc.l	1,1,-1,1,0,-1,0,2,0,1,1,1,1,0,1,0,1,0
HQTeile1	dc.b	5,00,00,00,00,00,00
HQTeile2	dc.b	5,06,05,04,08,07,03
FBFelder	dc.l	0,0,-2,1,0,-1,1,-1,-1
FBTeile1	dc.b	2,00,00,00
FBTeile2	dc.b	2,11,10,09
DPFelder	dc.l	1,0,-1,1,0,1,0,1,0
DPTeile1	dc.b	2,00,00,00
DPTeile2	dc.b	2,19,20,18
ModTeil		dc.b	036,044,038,037,043,040,042,041,039
		dc.b	086,092,085,087,093,089,091,090,088
		dc.b	129,134,127,128,135,132,131,130,133
		dc.b	148,153,146,147,154,151,150,149,152
ZuVieleUs	dc.b	'Zu viele Einheiten !',0
MenuList	dc.l	00,20
		dc.l	MItem_0_0,MItem_0_1,MItem_0_2,MItem_0_3
		dc.l	01,24
		dc.l	ZeigeKarte,MItem_1_1,MItem_1_2,MItem_1_3,Statistik
		dc.l	02,32
		dc.l	MItem_2_0,MItem_2_1,CheckProd,CheckProd,MItem_2_4
		dc.l	MItem_2_5,MItem_2_6
ShopTeile2	dc.l	HQTeile2,FBTeile2,DPTeile2
NeutraleTeile	dc.b	01,12,15
ShopTeile1	dc.l	HQTeile1,FBTeile1,DPTeile1
ShopFelder	dc.l	HQFelder,FBFelder,DPFelder

	END
