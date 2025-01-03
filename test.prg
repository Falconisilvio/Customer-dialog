#include "FiveWin.ch"
#include "Constant.ch"
#include "ttitle.ch"

 #define DLG_nColorDlg     RGB(245,245,235)
 #define DLG_nColortitle1 CLR_WHITE //  RGB(219,230,244)
 #define DLG_nColortitle2 CLR_WHITE // RGB(207,221,239)
 #define DLG_nColorBar1    RGB(250,250,245)
 #define DLG_nColorBar2    RGB(245,245,235)
 #define DLG_nColorBtn1    RGB(245,245,235)
 #define DLG_nColorBtn2    RGB(250,250,245)
 #define DLG_nColorBtnB    RGB(195,195,185)


 #define ORANGE  nRGB( 255, 165, 0 )
 #define LIGHTORANGE  nRGB( 255, 160, 122 )

#define LIGHTBLUE    nRGB(  89, 135, 214 )
#define DARKBLUE     nRGB(   3,  56, 147 )
#define LIGHTORANGE1 nRGB( 250, 227, 143 )
#define DARKORANGE1  nRGB( 238, 152, 25 )
#define LIGHTCYAN    nRGB( 203, 225, 252 )
#define DARKCYAN     nRGB( 125, 165, 224 )
#define LIGHTORANGE2 nRGB( 255, 255, 220 )
#define DARKORANGE2  nRGB( 247, 192, 91 )


request dbfcdx
request dbffpt

request hb_lang_it
request hb_codepage_itwin



FUNCTION Main()
   LOCAL oDlg


   //datas
   local cCode := Space(10)
   local cCodFisc := Space(16)
   local cPartiva := space(11)
   local lCli:= .f.
   local lFor:=.f.
   local cName := Space(30)
   local cAddress := Space(50)
   local cZipCode := Space(10)
   local cCity := Space(30)
   local cProv := Space(2)
   local cCountry := Space(20)
   local aCountry
   local oMappa,oDestMerce,oAltriindirizzi,oAggIndirizzo
   local cReferente := Space(50)
   local cRecFatt    := Space(50)
   local cPhone := Space(15), cMobile := Space(15)
   local cEmail := Space(40), cVAT := Space(15)
   local oFattHelp,oAggContatto
   local cNote:= Space(250)


   //Dlg
   local aCooDlg := aParamDialog(1)
   local nWd  := aCooDlg[1]
   local nHt  := aCooDlg[2]
   local oFont,oBold
   local oFld
   local aPages:= { "Anagrafica "  ,;
                    "Rapporti Commerciali" ,;
                    "Varie" }
   local nRow:= 0,nCol:= 10
   local nInterlinea := 14
   local  oBtnAnnulla,oBtnAiuto,oBtnConferma
   local oSay[20]
   local aGet[20]
   local lReturn
   local nMode:= 2
   local oLines:= array(10)
   local aBtnSel:= array(10)
   local oBtnMenu := array(4)
   local bGrad2 :=  { |lInvert| If( !lInvert, nRGB(  89, 135, 214 ), nRGB( 255, 165, 0 ) ) }
   local oCrsHand  := TCursor():New(,'HAND')
   local oTitle,oBoldTitle,oFontTitle
   local oBtnConfirm,oBtnClose
   local aTitle:= { "Inserimento cliente "  ,;
                    "Modifica cliente" ,;
                    "Duplica cliente" }


   oFontTitle := TFont():New( "TAHOMA", 0, 14,, )
   oBoldTitle := TFont():New( "TAHOMA", 0, 16,,.t. )

   oFont := TFont():New( "TAHOMA", 0, 14,, )
   oBold := TFont():New( "TAHOMA", 0, 14,,.t. )

   aCountry:= Stati()


   DEFINE ICON oIcon RESOURCE "ICON1"
   DEFINE DIALOG oDlg SIZE nWd, nHt PIXEL TRUEPIXEL RESIZABLE;
       FONT oFont  TITLE aTitle[nMode] ICON oIcon


     //-----------------------------------title
    @ nRow, 0 TITLE oTitle OF oDlg SIZE 1025, 55 //NOBORDER //PIXEL
        oTitle:aGrdBack := { { 1, DLG_nColortitle1, DLG_nColortitle2 } }
        oTitle:nShadow  := 0
     nRow+=2
    @ nRow, nCol TITLEIMG OF oTitle RESNAME ".\bitmaps\icons8-client-48.png" SIZE 48, 48   TRANSPARENT
    nRow+=14
    @ nRow, 75 TITLETEXT OF oTitle TEXT "Scheda Cliente" FONT oBoldTitle COLOR LIGHTBLUE
    nRow+=20
    @ nRow, 75 TITLETEXT OF oTitle TEXT "Informazioni relative alla voce corrente" FONT oFontTitle  COLOR  DARKORANGE1
    //------------------------------------------------
     nRow+=nInterlinea
      nRow+=nInterlinea


   @ nRow,2  FOLDEREX oFld SIZE oDlg:nWidth-2, oDlg:nBottom-20 OF oDlg PIXEL  ;
   PROMPT aPages ;
      COLOR CLR_WHITE ;
      FONT oFont

      oFld:lTransparent := .T.
      oFld:nFolderHeight := 20
      oFld:nSeparator := 5

      oFld:aGradSel       := { { 0.5, CLR_WHITE, CLR_WHITE },;
                                 { 0.75,  CLR_WHITE, CLR_WHITE } }
      oFld:aGradUnSel     := { { 0.5, CLR_WHITE, CLR_WHITE },;
                                 { 0.75,  CLR_WHITE, CLR_WHITE } }
      oFld:aGradOverUnSel := { { 0.5, CLR_WHITE, CLR_WHITE },;
                                 { 0.75,  CLR_WHITE, CLR_WHITE } }
      oFld:aGradOver      := { { 0.5, CLR_WHITE, CLR_WHITE },;
                                 { 0.75,  CLR_WHITE, CLR_WHITE } }
      oFld:aGradDis       := { { 1, CLR_WHITE, CLR_WHITE } }

      oFld:bClrtext    := { |o,n|if( oFld:aEnable[n], CLR_BLACK, nRGB(  89, 135, 214 ) ) }

      /*
        oFld:aGradSel       := { { 0.5, rgb(245,244,234), rgb(245,245,235) },;
                                 { 0.75,  rgb(245,245,235), rgb(245,244,234) } }
      oFld:aGradUnSel     := { { 0.5, rgb(240,240,230), rgb(240,240,230) },;
                                 { 0.75,  rgb(240,240,230), rgb(240,240,230) } }
      oFld:aGradOverUnSel := { { 0.5, rgb(238,236,219), rgb(238,236,219) },;
                                 { 0.75,  rgb(238,236,219), rgb(238,236,219) } }
      oFld:aGradOver      := { { 0.5, rgb(238,236,219), rgb(238,236,219) },;
                                 { 0.75,  rgb(238,236,219), rgb(238,236,219) } }

      oFld:aGradDis       := { { 1, rgb(238,236,219), rgb(238,236,219) } }
      */





























   //Init dialog
   nRow:=5
   @ nRow, 2 SAY oSay[1] Prompt "Codice:" OF oFld:adialogs[1]  SIZE 55, 12 PIXEL FONT oFont  TRANSPARENT
   @  nRow-2, 140 CHECKBOX aGet[2] VAR  lCli  Prompt "&Cliente"  OF oFld:adialogs[1] PIXEL SIZE 30, 10
   @  nRow-2, 180 CHECKBOX aGet[3] VAR lfor  Prompt "&Fornitore"  OF oFld:adialogs[1] PIXEL SIZE 60, 10

   nRow-=2
   @ nRow, 55 GET aGet[1] VAR cCode OF oFld:adialogs[1] SIZE 100, 10 PIXEL FONT oFont

    @ nRow,155 BTNBMP aBtnSel[1] ;
     RESOURCE "MENU16" ;
     SIZE 12, 10 PIXEL FLAT NOROUND GDIP   OF oFld:adialogs[1] ;
      ACTION MsgInfo("NewCode")


     nRow+=nInterlinea
     @ nRow, 2 SAY oSay[2] Prompt "Cod. Fiscale:" OF oFld:adialogs[1]  SIZE 55, 12 PIXEL FONT oFont  TRANSPARENT
     @ nRow, 170 SAY oSay[3] Prompt "Par.Iva:" OF oFld:adialogs[1]  SIZE 55, 12 PIXEL FONT oFont  TRANSPARENT

     nRow-=2
   @ nRow, 55 GET aGet[4] VAR cCodFisc OF oFld:adialogs[1] SIZE 100, 10 PIXEL FONT oFont
   @ nRow, 200 GET aGet[5] VAR cPartiva OF oFld:adialogs[1] SIZE 60, 10 PIXEL FONT oFont

   @ nRow,155 BTNBMP aBtnSel[2] ;
     RESOURCE "MENU16" ;
     SIZE 12, 10 PIXEL FLAT NOROUND GDIP   OF oFld:adialogs[1] ;
      ACTION MsgInfo("Cod Fiscale")

   nRow+=nInterlinea
   nRow+=nInterlinea

   @ nRow-12, 2 SAY oSay[4] Prompt  "Sede operativa " OF oFld:adialogs[1]  SIZE 55, 12 PIXEL FONT oBold  TRANSPARENT
   @ nRow, 2 SAY  oSay[5] Prompt  "Denominaz." OF oFld:adialogs[1]  SIZE 55, 12 PIXEL FONT oFont  TRANSPARENT
   nRow-=2
   @ nRow, 55 GET aGet[6] VAR cName OF oFld:adialogs[1] SIZE 168, 10 PIXEL FONT oFont

   @ nRow,160 BTNBMP aBtnSel[3] ;
     FILENAME ".\bitmaps\icons8-sort-down-24.png" ;
     SIZE 12, 10 PIXEL FLAT NOROUND GDIP   OF oFld:adialogs[1] ;
      ACTION MsgInfo("Search")

   @ nRow,160 BTNBMP aBtnSel[4] ;
     FILENAME ".\bitmaps\icons8-info-24.png" ;
     SIZE 12, 10 PIXEL FLAT NOROUND GDIP   OF oFld:adialogs[1] ;
      ACTION MsgInfo("Search")

   nRow+=nInterlinea
   @ nRow, 2 SAY oSay[6] Prompt "Indirizzo" OF oFld:adialogs[1]  SIZE 55, 12 PIXEL FONT oFont  TRANSPARENT
   nRow-=2
   @ nRow, 55 GET aGet[7] VAR cAddress OF oFld:adialogs[1] SIZE 180, 10 PIXEL FONT oFont
    nRow+=nInterlinea
   @ nRow, 2 SAY oSay[7] Prompt "Cap" OF oFld:adialogs[1]  SIZE 55, 12 PIXEL FONT oFont  TRANSPARENT
   @ nRow,  98 SAY oSay[8] Prompt  "Località:" OF oFld:aDialogs[1]  SIZE  25,   7   PIXEL
   @ nRow,  185 SAY oSay[9] Prompt "Prov:"     OF oFld:aDialogs[1]  SIZE  25,   7   PIXEL
   nRow-=2
   @ nRow, 55 GET aGet[8] VAR cZipCode OF oFld:adialogs[1] SIZE 40, 10 PIXEL FONT oFont
   @ nRow, 123 GET aGet[9] VAR cCity OF oFld:adialogs[1] SIZE 55, 10 PIXEL FONT oFont
   @ nRow, 201 GET aGet[10] VAR cProv OF oFld:adialogs[1] SIZE 20, 10 PIXEL FONT oFont
   @ nRow,160 BTNBMP aBtnSel[5] ;
     RESOURCE "SEARCH" ;
     SIZE 10, 10 PIXEL FLAT NOROUND GDIP   OF oFld:adialogs[1] ;
      ACTION MsgInfo("Search")

  nRow+=nInterlinea
   @ nRow, 2 SAY oSay[10] Prompt "Nazione" OF oFld:adialogs[1]  SIZE 55, 12 PIXEL FONT oFont  TRANSPARENT
    nRow-=2
   @ nRow, 55 COMBOBOX aGet[11] VAR cCountry ITEMS ArrTranspose( aCountry )[ 1] OF oFld:adialogs[1] SIZE 100, 10 PIXEL FONT oFont

   @ nRow,160 BTNBMP aBtnSel[6] ;
     RESOURCE "SEARCH" ;
     SIZE 10, 10 PIXEL FLAT NOROUND GDIP   OF oFld:adialogs[1] ;
      ACTION Search_Stati()

   oMappa := TUrlLink():New( nRow+2, 159,oFld:adialogs[1] , .T., .F., oFont, "", "Mappa" )
   oMappa:SetColor(  oMappa:nClrText, oMappa:nClrPane )
   oMappa:ltransparent:=.t.
   oMappa:nClrOver = CLR_RED
   oMappa:bAction =  { || Msginfo("Mappa") }

    nRow+=nInterlinea

   oDestMerce := TUrlLink():New( nRow, 55,oFld:adialogs[1] , .T., .F., oFont, "", "Destinazione Merce" )
   oDestMerce:SetColor(  oDestMerce:nClrText, oDestMerce:nClrPane )
   oDestMerce:nClrOver = CLR_RED
   oDestMerce:bAction =  { || Msginfo("Destinazione Merce ") }
   oDestMerce:ltransparent:=.t.


   oAltriindirizzi := TUrlLink():New( nRow, 114,oFld:adialogs[1] , .T., .F., oFont, "", "Altri Indirizzi" )
   oAltriindirizzi:SetColor(  oAltriindirizzi:nClrText, oAltriindirizzi:nClrPane )
   oAltriindirizzi:nClrOver = CLR_RED
   oAltriindirizzi:bAction =  { || Msginfo("Altri Indirizzi ") }
   oAltriindirizzi:ltransparent:=.t.

   oAggIndirizzo := TUrlLink():New( nRow, 174,oFld:adialogs[1] , .T., .F., oFont, "", "Aggiungi Indirizzo" )
   oAggIndirizzo:SetColor(  oAggIndirizzo:nClrText, oAggIndirizzo:nClrPane )
   oAggIndirizzo:nClrOver = CLR_RED
   oAggIndirizzo:bAction =  { || Msginfo("Altri Indirizzi ") }
   oAggIndirizzo:ltransparent:=.t.

    nRow+=nInterlinea
    nRow+=14
    @ nRow-12, 2 SAY oSay[11] Prompt  "Fatturazione Elettronica" OF oFld:adialogs[1]  SIZE 100, 12 PIXEL FONT oBold  TRANSPARENT

   oFattHelp := TUrlLink():New( nRow-12, 79,oFld:adialogs[1] , .T., .F., oFont, "", "("+"?"+")" )
   oFattHelp:SetColor(  oFattHelp:nClrText, oFattHelp:nClrPane )
   oFattHelp:nClrOver = CLR_RED
   oFattHelp:bAction =  { || Msginfo("Help Fatt ") }
   oFattHelp:ltransparent:=.t.


    @ nRow, 2 SAY oSay[12] Prompt "Recapito" OF oFld:adialogs[1]  SIZE 55, 12 PIXEL FONT oFont  TRANSPARENT
    @ nRow, 200 SAY oSay[13] Prompt "Rif. Amm.vo" OF oFld:adialogs[1]  SIZE 55, 12 PIXEL FONT oFont  TRANSPARENT

    nRow-=2
   @ nRow, 55 GET aGet[12] VAR cRecFatt OF oFld:adialogs[1] SIZE 100, 10 PIXEL FONT oFont
   @ nRow, 255 GET aGet[13] VAR cReferente OF oFld:adialogs[1] SIZE 100, 10 PIXEL FONT oFont
    nRow+=nInterlinea
    nRow+=14
    @ nRow-12, 2 SAY oSay[14] Prompt  "Contatti " OF oFld:adialogs[1]  SIZE 125, 12 PIXEL FONT oBold  TRANSPARENT
    @ nRow, 2 SAY oSay[15] Prompt "Referente" OF oFld:adialogs[1]  SIZE 55, 12 PIXEL FONT oFont  TRANSPARENT
    @ nRow, 200 SAY oSay[16] Prompt "Fax" OF oFld:adialogs[1]  SIZE 55, 12 PIXEL FONT oFont  TRANSPARENT
     nRow-=2
   @ nRow, 55 GET aGet[14] VAR cRecFatt OF oFld:adialogs[1] SIZE 100, 10 PIXEL FONT oFont
   @ nRow, 255 GET aGet[15] VAR cReferente OF oFld:adialogs[1] SIZE 80, 10 PIXEL FONT oFont
    nRow+=nInterlinea
   @ nRow, 2 SAY oSay[17] Prompt "Telefono" OF oFld:adialogs[1]  SIZE 55, 12 PIXEL FONT oFont  TRANSPARENT
   @ nRow, 2 SAY oSay[17] Prompt "Cellulare" OF oFld:adialogs[1]  SIZE 55, 12 PIXEL FONT oFont  TRANSPARENT
   nRow-=2
   @ nRow, 55 GET aGet[16] VAR cPhone OF oFld:adialogs[1] SIZE 80, 10 PIXEL FONT oFont
    @ nRow, 255 GET aGet[17] VAR cMobile OF oFld:adialogs[1] SIZE 100, 10 PIXEL FONT oFont

    @ nRow,160 BTNBMP aBtnSel[7] ;
     FILENAME ".\bitmaps\icons8-phone-24.png" ;
     SIZE 10, 10 PIXEL FLAT NOROUND GDIP   OF oFld:adialogs[1] ;
      ACTION NIL
     @ nRow,160 BTNBMP aBtnSel[8] ;
     FILENAME ".\bitmaps\icons8-phone-24.png" ;
     SIZE 10, 10 PIXEL FLAT NOROUND GDIP   OF oFld:adialogs[1] ;
      ACTION NIL


       nRow+=nInterlinea
   @ nRow, 2 SAY oSay[18] Prompt "Email" OF oFld:adialogs[1]  SIZE 55, 12 PIXEL FONT oFont  TRANSPARENT
      nRow-=2
   @ nRow, 55 GET aGet[18] VAR cEmail OF oFld:adialogs[1] SIZE 100, 10 PIXEL FONT oFont

   @ nRow,160 BTNBMP aBtnSel[9] ;
     FILENAME ".\bitmaps\icons8-email-24.Png" ;
     SIZE 10, 10 PIXEL FLAT NOROUND GDIP   OF oFld:adialogs[1] ;
      ACTION NIL

    nRow+=nInterlinea
   @ nRow, 2 SAY oSay[19] Prompt "Pec" OF oFld:adialogs[1]  SIZE 55, 12 PIXEL FONT oFont  TRANSPARENT
      nRow-=2
   @ nRow, 55 GET aGet[19] VAR cEmail OF oFld:adialogs[1] SIZE 100, 10 PIXEL FONT oFont


      @ nRow,160 BTNBMP aBtnSel[10] ;
     FILENAME ".\bitmaps\icons8-email-24.Png" ;
     SIZE 10, 10 PIXEL FLAT NOROUND GDIP   OF oFld:adialogs[1] ;
      ACTION NIL

      nRow+=nInterlinea

   oAggContatto := TUrlLink():New( nRow, 55,oFld:adialogs[1] , .T., .F., oFont, "", "("+"Aggiungi contatto"+")" )
   oAggContatto:SetColor(  oAggContatto:nClrText, oAggContatto:nClrPane )
   oAggContatto:nClrOver = CLR_RED
   oAggContatto:bAction =  { || Msginfo("aggiungi contatto ") }
   oAggContatto:ltransparent:=.t.

    nRow+=nInterlinea
   @ nRow, 2 SAY oSay[20] Prompt "Note" OF oFld:adialogs[1]  SIZE 55, 12 PIXEL FONT oFont  TRANSPARENT
      nRow-=2
   @ nRow, 55 GET aGet[20] VAR cNote  MEMO OF oFld:adialogs[1] SIZE 200, 33 PIXEL FONT oFont

   nRow+=nInterlinea
   nRow+=nInterlinea
   nRow+=nInterlinea
   @ nRow-4, 55  BTNBMP oBtnMenu[1] PROMPT "Add Address" SIZE 45,12 FLAT NOROUND ACTION MsgInfo("Add Address clicked") OF oFld:adialogs[1]
   @ nRow-4, 105 BTNBMP oBtnMenu[2] PROMPT "Attach" SIZE 45,12 FLAT NOROUND ACTION MsgInfo("Attach clicked") OF oFld:adialogs[1]
   @ nRow-4, 165 BTNBMP oBtnMenu[3] PROMPT "Documents" SIZE 45,12 NOROUND FLAT ACTION MsgInfo("Documents clicked") OF oFld:adialogs[1]
   @ nRow-4, 215 BTNBMP oBtnMenu[4] PROMPT "Payments" SIZE 45,12  FLAT NOROUND ACTION MsgInfo("Payments clicked") OF oFld:adialogs[1]




        For n= 1 to Len(aBtnSel)
                aBtnSel[n]:bClrGrad:= bGrad2
                aBtnSel[n]:oCursor:= oCrsHand
                aBtnSel[n]:nClrBorder:=   LIGHTBLUE
                aBtnSel[n]:nClrFocusRect := LIGHTBLUE
                aBtnSel[n]:nDeepFocusRect := 0
                aBtnSel[n]:ltransparent:=.t.
         Next



     @ 100,10 BUTTON oBtnConfirm PROMPT "Conferma" of oDlg  SIZE 80,22 DEFAULT ACTION ( oDlg:end( IDOK  ) )
     @ 100,10 BUTTON oBtnClose PROMPT "Annulla" of oDlg  SIZE 80,22 CANCEL ACTION ( oDlg:end( IDCANCEL ) )



   oDlg:aMinMaxInfo := { nil, nil, ,, 600,675, , }
   oDlg:bResized  := <||
                   local oRect         := oDlg:GetCliRect()
                   oTitle:nWidth  :=  oRect:nWidth+10
                   oFld:nWidth  :=  oRect:nWidth-2
                   oFld:nHeight :=  oRect:nBottom-100

                   oSay[3]:nLeft :=oFld:nWidth -200
                   oSay[9]:nLeft :=oFld:nWidth -100   //prov
                   oSay[13]:nLeft :=oFld:nWidth -300
                   oSay[16]:nLeft :=oFld:nWidth -200
                   oSay[17]:nLeft :=oFld:nWidth -290

                   aGet[1]:nWidth := oFld:nWidth-420
                   aGet[2]:nLeft  := oFld:nWidth -150
                   aGet[3]:nLeft  := oFld:nWidth -80
                   aGet[4]:nWidth := oFld:nWidth-420
                   aGet[5]:nLeft :=oFld:nWidth -150
                   aGet[6]:nWidth := oFld:nWidth-170 //name
                   aGet[7]:nWidth := oFld:nWidth-120 //address
                   aGet[9]:nWidth := oFld:nWidth-420 //city
                   aGet[10]:nLeft :=oFld:nWidth -50
                   aGet[11]:nWidth := oFld:nWidth-270  //states
                   aGet[12]:nWidth := oFld:nWidth-420  //recfatt

                   aGet[13]:nLeft :=oFld:nWidth -210
                   aGet[14]:nWidth := oFld:nWidth-320  //recfatt
                   aGet[15]:nLeft :=oFld:nWidth -170
                   aGet[16]:nWidth := oFld:nWidth-420  //recfatt
                   aGet[17]:nLeft :=oFld:nWidth -240
                   aGet[18]:nWidth  :=oFld:nWidth-140
                   aGet[19]:nWidth  :=oFld:nWidth-140
                   aGet[20]:nWidth  :=oFld:nWidth-140
                   aBtnSel[1]:nLeft :=oFld:nWidth -310
                   aBtnSel[2]:nLeft :=oFld:nWidth -310
                   aBtnSel[3]:nLeft :=oFld:nWidth -55
                   aBtnSel[4]:nLeft :=oFld:nWidth -30
                   aBtnSel[5]:nLeft :=oFld:nWidth -170
                   aBtnSel[6]:nLeft :=oFld:nWidth -150
                   aBtnSel[7]:nLeft :=oFld:nWidth -310
                   aBtnSel[8]:nLeft :=oFld:nWidth -30
                   aBtnSel[9]:nLeft :=oFld:nWidth -30
                   aBtnSel[10]:nLeft :=oFld:nWidth -30


                   oMappa:nLeft :=oFld:nWidth -50

                 oBtnConfirm:nLeft    := oRect:nRight - 200
                 oBtnConfirm:nTop     := oRect:nBottom - 25
                 oBtnClose:nLeft    := oRect:nRight - 100
                 oBtnClose:nTop     := oRect:nBottom - 25
                 oFld:refresh(.f.)
                 oFld:SETCOLOR(,CLR_WHITE) 
                 RETURN nil
                   >


   ACTIVATE DIALOG oDlg CENTERED ;
                    ON INIT ( oDlg:resize())
   if oDlg:nresult == IDOK
      lReturn := .t.
   else
      lReturn := .f.
     Endif
   RELEASE FONT oFont, oBold
  return lReturn





//----------------------------------------------------------------------//
 Function aParamDialog(n)
     local  nBottom,nRight,nWd,nHt
     local aTmp :={0,0}

        Do Case
        Case n=1
           nBottom:= 39.4
           nRight := 55
        Case n=2
            nBottom:= 32.4
           nRight := 55
        Endcase

        nHt       := nBottom * DLG_CHARPIX_H
        nWd       := Max( nRight * DLG_CHARPIX_W, 180 )
        aTmp[1]:=nWd
        aTmp[2]:=nHt
        return aTmp
//----------------------------------------------------------------------//
 function DlgCenter( oDlg, oWnd )
   oDlg:Center( oWnd )
   return nil
//----------------------------------------------------------------------//
   function ChangeButtons( oBar )
       AEval( oBar:aControls, { | oCtrl | oCtrl:nTop += 4, oCtrl:nHeight -= 4 } )
       return .T.
 //----------------------------------------------------------------------//
 Function LinesBmp()
   local hBmp, oBrush
   DEFINE BRUSH oBrush STYLE BDIAGONAL COLOR  Rgb(195,195,185)
   hBmp  := FW_MakeYourBitmap( 88,88, <|hDC,w,h|
            FillRect( hDC, { 1,0,80,80 }, oBrush:hBrush )
            return nil
            > )
            RELEASE BRUSH oBrush
            return hBmp
 //----------------------------------------------------------------------//

   // Array con Stati del mondo e Codici
 Function Stati()
return  aStati := { ;
   { "AFGHANISTAN", "AF" }, ;
   { "ALBANIA", "AL" }, ;
   { "ALGERIA", "DZ" }, ;
   { "ANDORRA", "AD" }, ;
   { "ANGOLA", "AO" }, ;
   { "ANTIGUA AND BARBUDA", "AG" }, ;
   { "ARGENTINA", "AR" }, ;
   { "ARMENIA", "AM" }, ;
   { "AUSTRALIA", "AU" }, ;
   { "AUSTRIA", "AT" }, ;
   { "AZERBAIJAN", "AZ" }, ;
   { "BAHAMAS", "BS" }, ;
   { "BAHRAIN", "BH" }, ;
   { "BANGLADESH", "BD" }, ;
   { "BARBADOS", "BB" }, ;
   { "BELARUS", "BY" }, ;
   { "BELGIUM", "BE" }, ;
   { "BELIZE", "BZ" }, ;
   { "BENIN", "BJ" }, ;
   { "BHUTAN", "BT" }, ;
   { "BOLIVIA", "BO" }, ;
   { "BOSNIA AND HERZEGOVINA", "BA" }, ;
   { "BOTSWANA", "BW" }, ;
   { "BRAZIL", "BR" }, ;
   { "BRUNEI", "BN" }, ;
   { "BULGARIA", "BG" }, ;
   { "BURKINA FASO", "BF" }, ;
   { "BURUNDI", "BI" }, ;
   { "CABO VERDE", "CV" }, ;
   { "CAMBODIA", "KH" }, ;
   { "CAMEROON", "CM" }, ;
   { "CANADA", "CA" }, ;
   { "CENTRAL AFRICAN REPUBLIC", "CF" }, ;
   { "CHAD", "TD" }, ;
   { "CHILE", "CL" }, ;
   { "CHINA", "CN" }, ;
   { "COLOMBIA", "CO" }, ;
   { "COMOROS", "KM" }, ;
   { "CONGO (Congo-Brazzaville)", "CG" }, ;
   { "CONGO (Democratic Republic)", "CD" }, ;
   { "COSTA RICA", "CR" }, ;
   { "CROATIA", "HR" }, ;
   { "CUBA", "CU" }, ;
   { "CYPRUS", "CY" }, ;
   { "CZECHIA", "CZ" }, ;
   { "DENMARK", "DK" }, ;
   { "DJIBOUTI", "DJ" }, ;
   { "DOMINICA", "DM" }, ;
   { "DOMINICAN REPUBLIC", "DO" }, ;
   { "ECUADOR", "EC" }, ;
   { "EGYPT", "EG" }, ;
   { "EL SALVADOR", "SV" }, ;
   { "EQUATORIAL GUINEA", "GQ" }, ;
   { "ERITREA", "ER" }, ;
   { "ESTONIA", "EE" }, ;
   { "ESWATINI", "SZ" }, ;
   { "ETHIOPIA", "ET" }, ;
   { "FIJI", "FJ" }, ;
   { "FINLAND", "FI" }, ;
   { "FRANCE", "FR" }, ;
   { "GABON", "GA" }, ;
   { "GAMBIA", "GM" }, ;
   { "GEORGIA", "GE" }, ;
   { "GERMANY", "DE" }, ;
   { "GHANA", "GH" }, ;
   { "GREECE", "GR" }, ;
   { "GRENADA", "GD" }, ;
   { "GUATEMALA", "GT" }, ;
   { "GUINEA", "GN" }, ;
   { "GUINEA-BISSAU", "GW" }, ;
   { "GUYANA", "GY" }, ;
   { "HAITI", "HT" }, ;
   { "HOLY SEE", "VA" }, ;
   { "HONDURAS", "HN" }, ;
   { "HUNGARY", "HU" }, ;
   { "ICELAND", "IS" }, ;
   { "INDIA", "IN" }, ;
   { "INDONESIA", "ID" }, ;
   { "IRAN", "IR" }, ;
   { "IRAQ", "IQ" }, ;
   { "IRELAND", "IE" }, ;
   { "ISRAEL", "IL" }, ;
   { "ITALY", "IT" }, ;
   { "JAMAICA", "JM" }, ;
   { "JAPAN", "JP" }, ;
   { "JORDAN", "JO" }, ;
   { "KAZAKHSTAN", "KZ" }, ;
   { "KENYA", "KE" }, ;
   { "KIRIBATI", "KI" }, ;
   { "KOREA (North)", "KP" }, ;
   { "KOREA (South)", "KR" }, ;
   { "KUWAIT", "KW" }, ;
   { "KYRGYZSTAN", "KG" }, ;
   { "LAOS", "LA" }, ;
   { "LATVIA", "LV" }, ;
   { "LEBANON", "LB" }, ;
   { "LESOTHO", "LS" }, ;
   { "LIBERIA", "LR" }, ;
   { "LIBYA", "LY" }, ;
   { "LIECHTENSTEIN", "LI" }, ;
   { "LITHUANIA", "LT" }, ;
   { "LUXEMBOURG", "LU" }, ;
   { "MADAGASCAR", "MG" }, ;
   { "MALAWI", "MW" }, ;
   { "MALAYSIA", "MY" }, ;
   { "MALDIVES", "MV" }, ;
   { "MALI", "ML" }, ;
   { "MALTA", "MT" }, ;
   { "MARSHALL ISLANDS", "MH" }, ;
   { "MAURITANIA", "MR" }, ;
   { "MAURITIUS", "MU" }, ;
   { "MEXICO", "MX" }, ;
   { "MICRONESIA", "FM" }, ;
   { "MOLDOVA", "MD" }, ;
   { "MONACO", "MC" }, ;
   { "MONGOLIA", "MN" }, ;
   { "MONTENEGRO", "ME" }, ;
   { "MOROCCO", "MA" }, ;
   { "MOZAMBIQUE", "MZ" }, ;
   { "MYANMAR (Burma)", "MM" }, ;
   { "NAMIBIA", "NA" }, ;
   { "NAURU", "NR" }, ;
   { "NEPAL", "NP" }, ;
   { "NETHERLANDS", "NL" }, ;
   { "NEW ZEALAND", "NZ" }, ;
   { "NICARAGUA", "NI" }, ;
   { "NIGER", "NE" }, ;
   { "NIGERIA", "NG" }, ;
   { "NORTH MACEDONIA", "MK" }, ;
   { "NORWAY", "NO" }, ;
   { "OMAN", "OM" }, ;
   { "PAKISTAN", "PK" }, ;
   { "PALAU", "PW" }, ;
   { "PALESTINE", "PS" }, ;
   { "PANAMA", "PA" }, ;
   { "PAPUA NEW GUINEA", "PG" }, ;
   { "PARAGUAY", "PY" }, ;
   { "PERU", "PE" }, ;
   { "PHILIPPINES", "PH" }, ;
   { "POLAND", "PL" }, ;
   { "PORTUGAL", "PT" }, ;
   { "QATAR", "QA" }, ;
   { "ROMANIA", "RO" }, ;
   { "RUSSIA", "RU" }, ;
   { "RWANDA", "RW" }, ;
   { "SAINT KITTS AND NEVIS", "KN" }, ;
   { "SAINT LUCIA", "LC" }, ;
   { "SAINT VINCENT AND THE GRENADINES", "VC" }, ;
   { "SAMOA", "WS" }, ;
   { "SAN MARINO", "SM" }, ;
   { "SAO TOME AND PRINCIPE", "ST" }, ;
   { "SAUDI ARABIA", "SA" }, ;
   { "SENEGAL", "SN" }, ;
   { "SERBIA", "RS" }, ;
   { "SEYCHELLES", "SC" }, ;
   { "SIERRA LEONE", "SL" }, ;
   { "SINGAPORE", "SG" }, ;
   { "SLOVAKIA", "SK" }, ;
   { "SLOVENIA", "SI" }, ;
   { "SOLOMON ISLANDS", "SB" }, ;
   { "SOMALIA", "SO" }, ;
   { "SOUTH AFRICA", "ZA" }, ;
   { "SOUTH SUDAN", "SS" }, ;
   { "SPAIN", "ES" }, ;
   { "SRI LANKA", "LK" }, ;
   { "SUDAN", "SD" }, ;
   { "SURINAME", "SR" }, ;
   { "SWEDEN", "SE" }, ;
   { "SWITZERLAND", "CH" }, ;
   { "SYRIA", "SY" }, ;
   { "TAIWAN", "TW" }, ;
   { "TAJIKISTAN", "TJ" }, ;
   { "TANZANIA", "TZ" }, ;
   { "THAILAND", "TH" }, ;
   { "TIMOR-LESTE", "TL" }, ;
   { "TOGO", "TG" }, ;
   { "TONGA", "TO" }, ;
   { "TRINIDAD AND TOBAGO", "TT" }, ;
   { "TUNISIA", "TN" }, ;
   { "TURKEY", "TR" }, ;
   { "TURKMENISTAN", "TM" }, ;
   { "TUVALU", "TV" }, ;
   { "UGANDA", "UG" }, ;
   { "UKRAINE", "UA" }, ;
   { "UNITED ARAB EMIRATES", "AE" }, ;
   { "UNITED KINGDOM", "GB" }, ;
   { "UNITED STATES", "US" }, ;
   { "URUGUAY", "UY" }, ;
   { "UZBEKISTAN", "UZ" }, ;
   { "VANUATU", "VU" }, ;
   { "VATICAN CITY", "VA" }, ;
   { "VENEZUELA", "VE" }, ;
   { "VIETNAM", "VN" }, ;
   { "YEMEN", "YE" }, ;
   { "ZAMBIA", "ZM" }, ;
   { "ZIMBABWE", "ZW" } ;
}

//---------------------------------------------------------//
Function Search_Stati()
   local oDlg,oBrw
   local aStates:=Stati()
   local aCooDlg := aParamDialog(2)
   local nWd  := aCooDlg[1]
   local nHt  := aCooDlg[2]
   local oFont,oBold
    local oSay:=array(2)
   local cSeek:=Space(100)
   local oGet
   local nColorHeader  := DLG_nColorDlg
   local nColorFooter  := DLG_nColorDlg
   local nColorPigiama := RGB(235,243,245)// RGB(243,243,238)
   local oTitle,oBoldTitle,oFontTitle
   local nRow:= 0,nCol:= 10
   local nInterlinea := 14

   oFontTitle := TFont():New( "TAHOMA", 0, 14,, )
   oBoldTitle := TFont():New( "TAHOMA", 0, 16,,.t. )





   DEFINE DIALOG oDlg SIZE nWd, nHt PIXEL TRUEPIXEL;
       FONT oFont   COLOR CLR_BLACK, DLG_nColorDlg  ;
       STYLE nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, ;
                  WS_MINIMIZEBOX)   ICON oIcon


 //-----------------------------------title
    @ nRow, 0 TITLE oTitle OF oDlg SIZE 1025, 55 //NOBORDER //PIXEL
        oTitle:aGrdBack := { { 1, DLG_nColortitle1, DLG_nColortitle2 } }
        oTitle:nShadow  := 0
     nRow+=2
    @ nRow, nCol TITLEIMG OF oTitle RESNAME ".\bitmaps\search_.bmp" SIZE 48, 48   TRANSPARENT
    nRow+=14
    @ nRow, 75 TITLETEXT OF oTitle TEXT "Ricerca Nazione" FONT oBoldTitle COLOR LIGHTBLUE
    nRow+=20
    @ nRow, 75 TITLETEXT OF oTitle TEXT "Compilare  i dati di ricerca" FONT oFontTitle  COLOR  DARKORANGE1
    //------------------------------------------------
     nRow+=nInterlinea
      nRow+=nInterlinea











 @ 12,15 say oSay[1] Prompt "Cerca" SIZE 46,24 PIXEL OF oDlg FONT oBold TRANSPARENT
 @ 12,450 say oSay[2] Prompt "in" SIZE 20,24 PIXEL OF oDlg FONT oBold    TRANSPARENT

 @ 10, 165 GET oGet VAR cSeek SIZE 200,19 PIXEL OF oDlg PICTURE "@!"


@ 103,10 XBROWSE oBrw SIZE -10,-10 PIXEL OF oDlg ;
      DATASOURCE aStates ;
      AUTOCOLS ;
      HEADERS "Stato","Codice" ;
      AUTOSORT ;
      NOBORDER LINES

   WITH OBJECT oBrw
            :nRowHeight          := 25
            :l2007               := .F.
            :l2015               := .T.
            :lRecordSelector     := .F.
            :nColDividerStyle    := LINESTYLE_LIGHTGRAY
            :nRowDividerStyle    := LINESTYLE_LIGHTGRAY
            :nStretchCol         := STRETCHCOL_WIDEST
            :nMarqueeStyle        := MARQSTYLE_HIGHLROW
            :lDisplayZeros        := .f.
            :lAllowRowSizing     := .F.
            :lAllowColSwapping   := .F.
            :lAllowColHiding     := .F.
            :lAllowSizings       := .F.
             :lDrawBorder := .t.
             :nClrBorder := Rgb(195,195,185)
             :lDrawBorderIn   := .F.
             :bRecSelHeader    := ""
       *     :bClrSelFocus := { || {,rgb(255,255,224)}}
            :bClrRowFocus := { || {, rgb(255,255,224)}}
           * :nRecSelColor     :=   nRgb( 245,244,234)
            :bClrHeader       := {|| { ,nColorHeader } }
            :bClrFooter       := {|| { ,nColorFooter } }
            :bClrStd := { || { CLR_BLACK, If( oBrw:KeyNo % 2 == 0, CLR_WHITE,nColorPigiama ) } }
            :lHScroll  := .f.
      :lIncrFilter      := .t.
            :bOnSort          := { |b,oCol| oBrw:Seek( "" ), ;
                                   oBrw:cFilterFld := oCol:cExpr, ;
                                   oBrw:SetFocus() }
            :oSeek := oGet
      :CreateFromCode()
   END

    @ 10,20 COMBOBOX oBrw:oSortCbx VAR oBrw:cSortOrder SIZE 100,400 PIXEL OF oDlg


               oDlg:bResized  := <||
                  local oRect         := oDlg:GetCliRect()

                  oSay[1]:setsize(90,   24.2)
                  oSay[1]:nTop        := oRect:ntop+78
                  oSay[1]:nLeft       := oRect:nLeft+10
                  oSay[2]:nTop        := oRect:ntop+78
                  oSay[2]:nLeft       := oRect:nLeft+270
                  oGet:nTop           := oRect:ntop+74
                  oGet:nLeft          := oRect:nLeft+60
                  oGet:setsize(200,   24.2)

                  oBrw:oSortCbx:nTop  := oRect:ntop+74.9
                  oBrw:oSortCbx:nLeft := oRect:nLeft+290

                    oBrw:refresh()
                   RETURN nil
                   >







                   ACTIVATE DIALOG oDlg  CENTER ;
                   ON INIT ( oDlg:resize() )
   return nil
 //---------------------------------------------------------//
