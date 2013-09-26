#include "AppEvent.ch"
#include "Achoice.ch"
#include "Xbp.ch"
#include "SetCurs.ch"
#include "Common.ch"
#include "Inkey.ch"
#include "Gra.ch"
#include "color.ch"
#include "Font.ch"
#include "XbpDev.ch"
#include "Dmlb.ch"

#pragma Library( "XppUI2.lib","ASInet10.lib" )



#define CRLF  Chr(13)+Chr(10)

PROCEDURE AppSys

RETURN



PROCEDURE Main

        LOCAL nEvent, mp1, mp2, oXbp,oCrt,TIT

        PUBLIC odXbp1,odXbp2,odXbp3,odXbp4,procedura1



        SET PATH TO cApp_Path

        cTitolo:=SPACE(20)+"LISTE DI DISTRIBUZIONE - INDIRIZZI ED ETICHETTE "
        *?cTitolo
        *wait
        *clea scre
        *

        BIABLU="W+/B"
        BIAROS="W+/R"
        BIAVER="W+/G"
        NERNER="N/N"
        BIAMAG="W+/GR"
        NERCYA="N/BG"
        NERVER="N/G"
        giablu="gr+/b"

        set exclusive off
        SET SCOREBOARD OFF
        set wrap on
        SET SOFTSEEK ON
        set message TO 29 center
        SET DATE ITALIAN
        SET DELETED ON
        set century on
        SET EPOCH TO 2000


        compre=chr(27)+CHR(15)
        GRANDE=chr(27)+"W"+CHR(1)
        NORMALE=chr(27)+"W"+CHR(0)
        nocompre=chr(18)


    oCrt := XbpCrt():new( , ,{20,50},50,110,cTitolo )
    oCrt :create()
    SetAppWindow( oCrt )
        SetMouse(.T.)
        SetAppWindow():mouseMode := XBPCRT_MOUSEMODE_PM
        SET COLOR TO &GIABLU
        CLEAR SCREEN
        CreateMenuSystem( SetAppWindow() :menuBar() )
        DO WHILE nEvent <> xbeP_Close
                SET COLOR TO &GIABLU
                nEvent := AppEvent( @mp1, @mp2, @oXbp )
                oXbp:handleEvent( nEvent, mp1, mp2 )

        ENDDO
*QUESTO E' IL CICLO MAIN,SE ARRIVIAMO QUI IL PROGRAMMA E' IN USCITA E CHIUDIAMO TUTTO
CLOSE ALL
RETURN


PROCEDURE CreateMenuSystem( oMenubar )
        LOCAL oMenu, oSubMenu,oSSubMenu,mp1,aItem,mp2

        oMenu       := XbpMenu():new( oMenuBar )
        oMenu:title := "LISTE DI DISTRIBUZIONE"+SPACE(3)
        oMenu:create()
        oMenubar:addItem( { oMenu,NIL } )
        oMenu:addItem( { "STAMPA ETICHETTE",{|| stampaetichette()  }} )
        oMenu:addItem( {NIL,NIL,XBPMENUBAR_MIS_SEPARATOR,0} )
        oMenu:addItem( { "MODIFICA DATI-SOLO REGALI",{|| modificadati()  }} )
        oMenu:addItem( {NIL,NIL,XBPMENUBAR_MIS_SEPARATOR,0} )
        oMenu:addItem( { "MODIFICA DATI-ANAGRAFICI",{|| modificadatianagrafici()  }} )
        oMenu:addItem( {NIL,NIL,XBPMENUBAR_MIS_SEPARATOR,0} )
        oMenu:addItem( { "INSERIMENTO DATI",{|| inseriscidati()  }} )
        oMenu:addItem( {NIL,NIL,XBPMENUBAR_MIS_SEPARATOR,0} )
        oMenu:addItem( { "STAMPA LISTA NON OBSOLETI",{|| stampalista()  }} )
        oMenu:addItem( {NIL,NIL,XBPMENUBAR_MIS_SEPARATOR,0} )
        oMenu:addItem( { "STAMPA LISTA SOLO ATTIVI E CON AUGURI",{|| STAMPALISTANOTE()  }} )
        oMenu:addItem( {NIL,NIL,XBPMENUBAR_MIS_SEPARATOR,0} )
        oMenu:addItem( { "AGGIORNAMENTE DATABASE DA NEWFILE",{|| aggiorna_da_newfile()  }} )
        oMenu:addItem( {NIL,NIL,XBPMENUBAR_MIS_SEPARATOR,0} )
        oMenu:addItem( { "STAMPA LISTA SOLO ATTIVI SENZA AUGURI",{|| STAMPALISTA_NONOBSO_NONAUG()  }} )
        oMenu:addItem( {NIL,NIL,XBPMENUBAR_MIS_SEPARATOR,0} )





RETURN

**********************************************************


PROCEDURE stampaetichette

local nPoseti:=1,nCodiceInizio:=0,nCodiceFine:=1,cRegali,nContastampe:=0,nMaxLabel:=1


Private nRiga, oPs, aSize, oImmagine, nRigIni, nRigEnd, oFont,;
           nRigIni1, nRigEnd1, oPrinter


*crea_finestra("Stampa etichette")
CLEAR
set cursor on
    @ 15,10 SAY "Per annullare il lavoro digitare ESC"
    @ 18,10 say "Posizione stampa prima etichetta :" get nposeti picture "99" valid (nposeti>0 .and. nposeti<25)
    @ 20,10 say "Stampare dal codice : " get nCodiceInizio picture "9999" valid nCodiceInizio>0
    @ 22,10 say "Stampare al codice  : " get nCodiceFine picture "9999" valid nCodiceInizio<=nCodiceFine
    @ 24,10 say "Stampare massimo numero di etichette : " get nMaxLabel valid nMaxLabel>0
    read
set cursor off
CLEA SCRE


    IF LASTKEY()=27
       close data
       return
    endif


oPrinter  := SmePrintDialog( AppDeskTop() )
      oPS   := XbpPresSpace():new()
      // Size of printable region on paper
      aSize := oPrinter:paperSize()
      aSize := { aSize[5] - aSize[3], ;
                 aSize[6] - aSize[4]  }
      oPS:create( oPrinter, aSize,GRA_PU_LOMETRIC )
      oPrinter:startDoc( "Stampa etichette" )
      nRiga := 0


      aSizeImg := Array(2)
      aSizeImg[1] :=  1220
      aSizeImg[2] :=  1010

        nRiga := 590
        aRect      := { 0, aSize[2]-nRiga-aSizeImg[2],;
                        aSizeImg[1], aSize[2]-nRiga }
 *       oImmagine:draw( oPS, aRect )  // Spool print job


      aAttr    := GraSetAttrString( oPS)


*PrintRiga(cString, nColSta, nRigSta, lGrasse, nPunti, lCompre, lSottol, ;
*                         lCorsiv, cCarattere, nWidth, cColore )

use listadib
inde on val(codice) to listadib
set inde to listadib
go top
nMargineAlto:=70
nRiga:=nMargineAlto
nMargineSinistro:=0
nCol:=nMarginesinistro
*wait "stiamo per entrare nel ciclo"
Do while .not. EOF() .and. (val(Codice)<=nCodicefine) .and. (nContastampe<nMaxLabel)


*entriamo nel ciclo solo per i soggetti non obsoleti ai quali mandiamo gli auguri
if (obso="1" .or. aug<>"S" .or. val(Codice)<nCodiceInizio)
      skip
      loop
endif
   nContastampe:=nContastampe+1
*? nContastampe
*wait
   if aug="S"
   cRegali:="|A01-"
   else
   cRegali:="|---"
   endif
   if .not. empty(cal)
   cRegali:=cRegali+"B"+alltrim(cal)+"-"
   endif
   if .not. empty(agbelle)
   cRegali:=cRegali+"C"+alltrim(agbelle)+"-"
   endif
   if .not. empty(agendine)
   cRegali:=cRegali+"D"+alltrim(agendine)+"-"
   endif
   if .not. empty(gadget)
   cRegali:=cRegali+"E"+alltrim(gadget)+"-|"
   endif

   nRisultato:=(nContastampe%24)
*? "contastampe"
*? nrisultato
*wait
   if nRisultato=0
   nRisultato:=24
   endif
   nNumeroRiga:=(nRisultato/3)
*? nnumeroriga
*wait
   nResto:=(nContastampe%3)
*? nresto
*wait
   if nResto=1
      nDifferenzaColonne:=0
   elseif nResto=2
      nDifferenzaColonne:=665
   elseif nResto=0
      nDifferenzaColonne:=1330
   else
      wait "allarme la procedura non funziona"
   endif
   nCounter:= roundup(nNumeroRiga)-1


*? "diffcolonne"
*? nDifferenzaColonne
*wait
   nDifferenzaRiga:=(nCounter*360)
*? "diffriga"
*? nDifferenzaRiga
*wait
   nCol:=nMargineSinistro+NdifferenzaColonne
   nRiga:=nMargineAlto+nDifferenzaRiga

PrintRiga(ragosog,nCol,nRiga,.F.,32)
PrintRiga(indirizzo,nCol,nRiga+30,.F.,32)
PrintRiga(padL(alltrim(cap),5,"0")+" "+alltrim(comune),nCol,nRiga+60,.F.,32)
PrintRiga("("+alltrim(prov)+") "+" "+paese,nCol,nRiga+90,.F.,32)
PrintRiga(cRegali+" "+alltrim(codice),nCol,nRiga+150,.F.,25)

skip
*?  roundup(nNumeroRiga)
*?  nResto
*wait

IF roundup(nNumeroRiga)=8 .and. nResto=0
*? "siamo alla riga 8,terza colonna,e cambiamo pagina "+roundup(nNumeroriga)
*wait
      oPrinter:NewPage()
ENDIF


enddo
*WAIT

      oPrinter:endDoc()
      oPrinter:destroy()
      oPS:destroy()

DbCommitAll()
CLEAR SCREEN
CLOSE DATA
RETURN

PROCEDURE PrintRiga(cString, nColSta, nRigSta, lGrasse, nPunti, lCompre, lSottol,lCorsiv,cCarattere,nWidth,cColore )


   Local aAttr
   DEFAULT lCompre TO .f.
   DEFAULT lGrasse TO .f.
   DEFAULT lSottol TO .f.
   DEFAULT lCorsiv TO .f.

  //cCarattere := "Courier New"

   SettaFont(lCompre, lGrasse, nPunti, lSottol, lCorsiv, cCarattere, nWidth )

   If !IsNil( cColore )
      aAttr    := GraSetAttrString( oPS)
      Do Case
         Case cColore == "ROSSO"
              aAttr[GRA_AS_COLOR] := GRA_CLR_RED
         Case cColore == "VERDE"
              aAttr[GRA_AS_COLOR] := GRA_CLR_GREEN
         Case cColore == "BLU"
              aAttr[GRA_AS_COLOR] := GRA_CLR_BLUE
         Case cColore == "GRIGIO"
              aAttr[GRA_AS_COLOR] := GRA_CLR_PALEGRAY
         Case cColore == "GIALLO"
              aAttr[GRA_AS_COLOR] := GRA_CLR_YELLOW
         Otherwise
              aAttr[GRA_AS_COLOR] := GRA_CLR_NEUTRAL
      Endcase
      GraSetAttrString( oPS, aAttr )
   Endif
   GraStringAt( oPS, { nColSta, aSize[2]-nRigSta }, cString)
   If !IsNil( cColore )
      aAttr[GRA_AS_COLOR] := GRA_CLR_NEUTRAL
      GraSetAttrString( oPS, aAttr )
   Endif

   SettaFont(.f.,.f.,,.f.,.f.)
RETURN

FUNCTION CREA_FINESTRA
PARAMETERS TIT

    oCrt1 := XbpCrt():new( , ,{170,65},36,80,TIT )
    oCrt1 :create()
    oCrt1 :border :=XBPDLG_SIZEBORDER
    SetAppWindow( oCrt1 )
    apr_fin=1
    DbCommitAll()
return(.t.)

****************************************
PROCEDURE SettaFont(lCompre, lGrasse, nPunti, lSottol, lCorsiv, cCarattere, Width )
   LOCAL cTesto, oFont, nWidth := 0
   DEFAULT nPunti     TO 40
   DEFAULT cCarattere TO "Courier New"
   *DEFAULT cCarattere TO "Verdana"
   //DEFAULT Width      TO Nil
   //DEFAULT cCarattere TO "Arial"

   //nWidth := IIF( lCompre, nAgente7, Width )

   oFont := XbpFont():new( oPS )
   oFont:CompoundName := cCarattere
   oFont:FamilyName   := cCarattere
   oFont:Bold         := lGrasse
   oFont:height       := nPunti
   oFont:fixed        := .t.
   oFont:underscore   := lSottol
   //oFont:width        := nWidth
   Do Case
      Case lCompre
           oFont:width     := nAgente7
      Case !IsNil( Width )
           oFont:width     := Width
   EndCase
 //  oFont:Italic       := lCorsiv
   oFont:create()                              // Font settato di default
   GraSetFont( oPS, oFont )                    // install font
RETURN

Function SmePrintDialog( pDlg, pOrientamento)
   Local oDlg, oPrinter
   oDlg := XbpPrintDialog():new()
   oDlg:create()
   oPrinter := oDlg:display()
   IIF( pOrientamento == "O" .And. oPrinter != Nil, oPrinter:SetOrientation( XBPPRN_ORIENT_LANDSCAPE ), Nil )
   oDlg:destroy()
Return oPrinter

PROCEDURE modificadati
local cCodice:="    "

clear screen
set cursor on
@ 10,10 say "inserire codice da modificare" get cCodice picture "9999"
read
set cursor off
use listadib inde listadib
seek val(cCodice)
if .not. found()
   @ 15,10 say "non trovato"
   wait
   close data
   CLEAR SCREEN

   return
endif
rlock()
CLEAR SCREEN
set cursor on
@ 10,5 SAY CODICE
@ 10,12 SAY RAGOSOG

@ 12,10 SAY "AUGURI N/S      " get aug
@ 13,10 say "CALENDARI N.    " get cal picture "99"
@ 14,10 say "AGENDE BELLE N. " get agbelle picture "99"
@ 15,10 say "AGENDINE N.     " get agendine picture "99"
@ 16,10 say "GADGET   N.     " get gadget picture "99"
@ 17,10 say "NOTE            " get note
@ 18,10 say "INDIRIZZO 2     " get indir2
read
REPLA AUG WITH UPPER(AUG)
set cursor off
wait "inserimento concluso"
close data
clear screen
return

PROCEDURE STAMPALISTA
local nContaStampe:=0
oPrinter  := SmePrintDialog( AppDeskTop() )
      oPS   := XbpPresSpace():new()
      // Size of printable region on paper
      aSize := oPrinter:paperSize()
      aSize := { aSize[5] - aSize[3], ;
                 aSize[6] - aSize[4]  }
      oPS:create( oPrinter, aSize,GRA_PU_LOMETRIC )
      oPrinter:startDoc( "Stampa lista" )
      nRiga := 0


      aSizeImg := Array(2)
      aSizeImg[1] :=  1220
      aSizeImg[2] :=  1010

        nRiga := 590
        aRect      := { 0, aSize[2]-nRiga-aSizeImg[2],;
                        aSizeImg[1], aSize[2]-nRiga }
 *       oImmagine:draw( oPS, aRect )  // Spool print job


      aAttr    := GraSetAttrString( oPS)




USE LISTADIB INDE LISTADIB
GO TOP

nMargineAlto:=60
nRiga:=nMargineAlto
nMargineSinistro:=0
nCol:=nMarginesinistro

DO WHILE .NOT. EOF()
   IF OBSO<>"1"
      nContastampe:=nContastampe+1
      if aug="S"
         cRegali:="|A01-"
      else
         cRegali:="|---"
      endif
      if .not. empty(cal)
         cRegali:=cRegali+"B"+alltrim(cal)+"-"
      endif
      if .not. empty(agbelle)
         cRegali:=cRegali+"C"+alltrim(agbelle)+"-"
      endif
      if .not. empty(agendine)
         cRegali:=cRegali+"D"+alltrim(agendine)+"-"
      endif
      if .not. empty(gadget)
         cRegali:=cRegali+"E"+alltrim(gadget)+"-|"
      endif
   PrintRiga(PADR(ALLTRIM(CODICE),6," ")+PADR(ALLTRIM(ragosog),40," ")+" "+PADR(ALLTRIM(iif(empty(indir2),indirizzo,indir2)),40," ")+" "+padL(alltrim(cap),5,"0")+" "+comune+" ("+prov+") "+" "+paese+" "+;
   +cRegali+" "+alltrim(note)+str(nRiga),nCol,nRiga,.F.,20)
   ELSE
      SKIP
      LOOP
   ENDIF
   SKIP
   nRiga:=nRiga+20
   IF nRiga>2900
      oPrinter:NewPage()
      nRiga:=nMargineAlto
   ENDIF
   loop
ENDDO
nRiga:=Nriga+100
PrintRiga("stampati codici n. "+str(nContastampe),nCol,nRiga,.F.,20)
   oPrinter:endDoc()
   oPrinter:destroy()
   oPS:destroy()
CLOSE DATA
CLEAR SCREEN
RETURN

PROCEDURE inseriscidati
local cCodice:="    "

clear screen

use listadib inde listadib
go botto
cCodice:=Codice
if val(cCodice) < 9000
   cCodice:="9000"
else
   cCodice:=str(val(cCodice)+1)
   ? cCodice
   wait
endif
appe blank
rlock()
replace codice with cCodice
CLEAR SCREEN
set cursor on
? codice
wait
@ 10,5 SAY "CODICE          " get codice
@ 12,10 SAY "RAGIONE SOCIALE " get RAGOSOG valid .not. empty (ragosog)
@ 13,10 say "INDIRIZZO       " get INDIRIZZO VALID .NOT. EMPTY(INDIRIZZO)
@ 14,10 SAY "COMUNE          " get comune valid .not. empty(comune)
@ 15,10 say "CAP             " get cap valid .not. empty(cap)
@ 16,10 say "PROVINCIA       " get prov valid .not. empty(prov)
@ 17,10 say "AUGURI  (S/N)   " get aug valid (aug="S" .or. aug="N")
@ 18,10 say "CALENDARI N.    " get cal picture "99"
@ 19,10 say "AGENDE BELLE N. " get agbelle picture "99"
@ 20,10 say "AGENDINE N.     " get agendine picture "99"
@ 21,10 say "GADGET   N.     " get gadget picture "99"
@ 22,10 say "NOTE            " get note
@ 23,10 say "INDIRIZZO 2     " get indir2
read
REPLA AUG WITH UPPER(AUG)
set cursor off
wait "inserimento concluso"
close data
clear screen
return

PROCEDURE STAMPALISTANOTE
local nContaStampe:=0,nContaCalendari:=0,nContaAgendeBelle:=0,nContaAgendine:=0,nContaGadget:=0


oPrinter  := SmePrintDialog( AppDeskTop() )
      oPS   := XbpPresSpace():new()
      // Size of printable region on paper
      aSize := oPrinter:paperSize()
      aSize := { aSize[5] - aSize[3], ;
                 aSize[6] - aSize[4]  }
      oPS:create( oPrinter, aSize,GRA_PU_LOMETRIC )
      oPrinter:startDoc( "Stampa lista CON NOTE" )
      nRiga := 0


      aSizeImg := Array(2)
      aSizeImg[1] :=  1220
      aSizeImg[2] :=  1010

        nRiga := 590
        aRect      := { 0, aSize[2]-nRiga-aSizeImg[2],;
                        aSizeImg[1], aSize[2]-nRiga }
 *       oImmagine:draw( oPS, aRect )  // Spool print job


      aAttr    := GraSetAttrString( oPS)




USE LISTADIB INDE LISTADIB
GO TOP

nMargineAlto:=60
nRiga:=nMargineAlto
nMargineSinistro:=0
nCol:=nMarginesinistro

DO WHILE .NOT. EOF()
   IF OBSO<>"1" .AND. aug="S"
      nContastampe:=nContastampe+1
      nContaCalendari:=nContaCalendari+val(cal)
      nContaAgendeBelle:=nContaAgendeBelle+val(agbelle)
      nContaAgendine:=nContaAgendine+val(agendine)
      nContaGadget:=nContaGadget+val(gadget)
      if aug="S"
         cRegali:="|A01-"
      else
         cRegali:="|---"
      endif
      if .not. empty(cal)
         cRegali:=cRegali+"B"+alltrim(cal)+"-"
      endif
      if .not. empty(agbelle)
         cRegali:=cRegali+"C"+alltrim(agbelle)+"-"
      endif
      if .not. empty(agendine)
         cRegali:=cRegali+"D"+alltrim(agendine)+"-"
      endif
      if .not. empty(gadget)
         cRegali:=cRegali+"E"+alltrim(gadget)+"-|"
      endif
   PrintRiga(PADR(ALLTRIM(CODICE),6," ")+PADR(ALLTRIM(ragosog),40," ")+cRegali+" "+alltrim(note),nCol,nRiga,.F.,30)
   ELSE
      SKIP
      LOOP
   ENDIF
   SKIP
   nRiga:=nRiga+30
   IF nRiga>2900
      oPrinter:NewPage()
      nRiga:=nMargineAlto
   ENDIF
   loop
ENDDO
nRiga:=Nriga+100
PrintRiga("stampati codici n. "+str(nContastampe),nCol,nRiga,.F.,20)
PrintRiga("totale calendari n. "+str(nContaCalendari),nCol,nRiga+20,.F.,20)
PrintRiga("totale agende belle n. "+str(nContaagendebelle),nCol,nRiga+40,.F.,20)
PrintRiga("totale agendine n. "+str(nContaAgendine),nCol,nRiga+60,.F.,20)
PrintRiga("totale gadget n. "+str(nContaGadget),nCol,nRiga+80,.F.,20)


   oPrinter:endDoc()
   oPrinter:destroy()
   oPS:destroy()
CLOSE DATA
CLEAR SCREEN
RETURN

FUNCTION ROUNDUP (nNumero)
*arrotonda sempre all'intero superiore
if int(nNumero)==nNumero
   return nNumero
else
   return (int(nNumero)+1)
endif
return  .T.

PROCEDURE modificadatianagrafici
local cCodice:="    "

clear screen
set cursor on
@ 10,10 say "inserire codice da modificare" get cCodice picture "9999"
read
set cursor off
use listadib inde listadib
seek val(cCodice)
if .not. found()
   @ 15,10 say "non trovato"
   wait
   close data
   CLEAR SCREEN

   return
endif
rlock()
CLEAR SCREEN
set cursor on
@ 10,5 SAY "CODICE          " get codice
@ 12,10 SAY "RAGIONE SOCIALE " get RAGOSOG valid .not. empty (ragosog)
@ 13,10 say "INDIRIZZO       " get INDIRIZZO VALID .NOT. EMPTY(INDIRIZZO)
@ 14,10 SAY "COMUNE          " get comune valid .not. empty(comune)
@ 15,10 say "CAP             " get cap valid .not. empty(cap)
@ 16,10 say "PROVINCIA       " get prov valid .not. empty(prov)
@ 17,10 say "AUGURI          " get aug
@ 18,10 say "CALENDARI N.    " get cal picture "99"
@ 19,10 say "AGENDE BELLE N. " get agbelle picture "99"
@ 20,10 say "AGENDINE N.     " get agendine picture "99"
@ 21,10 say "GADGET   N.     " get gadget picture "99"
@ 22,10 say "NOTE            " get note
@ 23,10 say "INDIRIZZO 2     " get indir2
read
REPLA AUG WITH UPPER(AUG)
set cursor off
wait "inserimento concluso"
close data
clear screen
return

PROCEDURE aggiorna_da_newfile

local nCancellati:=0

clear screen
sele 1
use listadib inde listadib
flock()
append from newfile
*browse()
go top
cOldCode:=codice
lInizio:=.T.
DO WHILE .NOT. EOF()
if lInizio
   lInizio:=.F.
   skip
   loop
endif
if alltrim(codice)==alltrim(cOldCode)
   nCancellati=nCancellati+1
   cOldCode:=codice
   delete
   skip
   loop
else
   cOldCode:=codice
   skip
   loop
endif
enddo
browse()
? nCancellati
wait "inserimento concluso"
close data
clear screen
return

PROCEDURE STAMPALISTA_NONOBSO_NONAUG


oPrinter  := SmePrintDialog( AppDeskTop() )
      oPS   := XbpPresSpace():new()
      // Size of printable region on paper
      aSize := oPrinter:paperSize()
      aSize := { aSize[5] - aSize[3], ;
                 aSize[6] - aSize[4]  }
      oPS:create( oPrinter, aSize,GRA_PU_LOMETRIC )
      oPrinter:startDoc( "Stampa lista NON obsoleti,senza auguri" )
      nRiga := 0


      aSizeImg := Array(2)
      aSizeImg[1] :=  1220
      aSizeImg[2] :=  1010

        nRiga := 590
        aRect      := { 0, aSize[2]-nRiga-aSizeImg[2],;
                        aSizeImg[1], aSize[2]-nRiga }
 *       oImmagine:draw( oPS, aRect )  // Spool print job


      aAttr    := GraSetAttrString( oPS)




USE LISTADIB INDE LISTADIB
GO TOP

nMargineAlto:=60
nRiga:=nMargineAlto
nMargineSinistro:=0
nCol:=nMarginesinistro

DO WHILE .NOT. EOF()
   IF OBSO<>"1" .AND. aug<>"S"
       PrintRiga(PADR(ALLTRIM(CODICE),6," ")+PADR(ALLTRIM(ragosog),40," ")+" "+alltrim(note),nCol,nRiga,.F.,30)
   ELSE
      SKIP
      LOOP
   ENDIF
   SKIP
   nRiga:=nRiga+30
   IF nRiga>2900
      oPrinter:NewPage()
      nRiga:=nMargineAlto
   ENDIF
   loop
ENDDO
nRiga:=Nriga+100



   oPrinter:endDoc()
   oPrinter:destroy()
   oPS:destroy()
CLOSE DATA
CLEAR SCREEN
RETURN