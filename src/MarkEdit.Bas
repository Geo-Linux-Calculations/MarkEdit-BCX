$INCLUDE "meids.basi"

GLOBAL  Brl As Double
GLOBAL  LenFrac As Integer
GLOBAL  LenFracA As Integer

'program variables

GLOBAL  AppName$
GLOBAL  AppMeCaption$
GLOBAL  Caption$

GLOBAL  szFile$
GLOBAL  szFileTitle$

GLOBAL  Form1          AS  HWND
GLOBAL  Edit1          AS  HWND
GLOBAL  Wc             AS  WNDCLASS
GLOBAL  OpenFileName   AS  OPENFILENAME

DIM wRect       AS RECT   'rect structure for window pos
DIM ww          AS DWORD   'window width
DIM wh          AS DWORD   'window height
DIM bNeedSave   AS BOOL
DIM bSave       AS BOOL
DIM iReturn     AS DWORD


FUNCTION WINMAIN
  Brl = 0.76
  LenFrac = 4
  LenFracA = 2
  LOCAL Msg AS  MSG
  AppName$  = "Mark_Editor"
  AppMeCaption$ = "Mark Editor by AKON (rus)"
  Caption$  = AppMeCaption$
  bSave = TRUE
  bNeedSave = FALSE

  If FINDFIRSTINSTANCE(AppName$) Then Exit Function

  Wc.style           = CS_HREDRAW OR CS_VREDRAW
  Wc.lpfnWndProc     = WndProc
  Wc.cbClsExtra      = 0
  Wc.cbWndExtra      = 0
  Wc.hInstance       = hInst
  Wc.hIcon           = LoadIcon     ( hInst, MAKEINTRESOURCE(IDI_MEICON))
  Wc.hCursor         = LoadCursor       ( NULL,IDC_ARROW )
  Wc.hbrBackground   = GetStockObject     ( WHITE_BRUSH )
  Wc.lpszMenuName    = MAKEINTRESOURCE(IDMAINMENU)
  Wc.lpszClassName   = AppName$
  RegisterClass(&Wc)


' create the main window
  Form1 = CreateWindow(AppName$, Caption$, WS_CAPTION OR WS_MAXIMIZEBOX OR WS_MINIMIZEBOX OR _
  WS_SYSMENU OR WS_VISIBLE,0,0, 600, 500, NULL, NULL, hInst, NULL)

' create the edit window
  Edit1 = CreateWindow("edit",NULL, WS_CHILD OR WS_VISIBLE OR WS_BORDER OR _
  ES_LEFT OR WS_HSCROLL OR WS_VSCROLL OR ES_MULTILINE OR  _
  ES_AUTOVSCROLL OR ES_AUTOHSCROLL,0, 0, 550, 450, _
  Form1, EDIT_1, hInst,NULL )

  PosMainWindow  (Form1)              'set main window pos
  ShowWindow    (Form1,CmdShow)       'show that baby!
  UpdateWindow  (Form1)               'update it

  While GetMessage (&Msg,NULL,0,0)    'message loop
    TranslateMessage  (&Msg)
    DispatchMessage   (&Msg)
  Wend

  Function = Msg.wParam               'return this
End Function

SUB PosMainWindow (hWnd AS HWND)
  GetWindowRect (hWnd, &wRect)
  ww = GetSystemMetrics (SM_CXSCREEN)
  wh = GetSystemMetrics (SM_CYSCREEN)-GetSystemMetrics(SM_CYCAPTION)-5
  SetWindowPos (hWnd, NULL,0,0,ww,wh,SWP_SHOWWINDOW)
End Sub


$INCLUDE "megsedit.basi"
$INCLUDE "medlgos.basi"

$INCLUDE "medlgopt.basi"
$INCLUDE "medlgabout.basi"

$INCLUDE "memath.basi"
$INCLUDE "memark.basi"

$INCLUDE "medlgtl.basi"
$INCLUDE "medlgtcc.basi"
$INCLUDE "medlgtsc.basi"

$INCLUDE "medlgrl.basi"
$INCLUDE "medlgrcc.basi"
$INCLUDE "medlgrsc.basi"

$INCLUDE "medlgevl.basi"
$INCLUDE "medlgevc.basi"

$INCLUDE "medlgchc.basi"
$INCLUDE "medlgchs.basi"

$INCLUDE "medlgint.basi"

CALLBACK FUNCTION WndProc
  DIM T$
  DIM hDC AS HDC
  DIM ps  AS PAINTSTRUCT
  Dim i

  SELECT CASE CBMSG

    CASE WM_COMMAND
    IF LOWORD (wParam) = EDIT_1 THEN
      IF HIWORD (wParam) = EN_CHANGE THEN
        bNeedSave = TRUE
        IF HIWORD (wParam) = EN_ERRSPACE OR HIWORD (wParam) = EN_MAXTEXT THEN
          MsgBox  "Edit control out of space.","Error!", 16
          EXIT FUNCTION
        END IF
      END IF
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_NEW THEN
      bNeedSave = Not (FileNewMeEdit (Form1, Edit1))
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_OPEN THEN
      bNeedSave = Not (FileOpenMeEdit (Form1, Edit1))
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_SAVE THEN
      bNeedSave = Not (FileSaveMeEdit (Form1, Edit1))
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_SAVEAS THEN
      bNeedSave = Not (FileSaveAsMeEdit (Form1, Edit1))
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_PRINT THEN
      notice("Sorry - Not implemented yet!")
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_EXIT  THEN   ' Was the EXIT menu clicked?
      bNeedSave = Not (FileExitMeEdit (Form1, Edit1))
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_DELETE THEN
      SendMessage(Edit1, WM_CLEAR, 0, 0)
      Caption$ = Caption$ & " - " & szFile$
      SetWindowText (Form1, Caption$)
      bNeedSave = TRUE
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_UNDO THEN
      IF SendMessage(Edit1, EM_CANUNDO,0,0) THEN
        SendMessage(Edit1, WM_UNDO, 0, 0)
      ELSE
        MsgBox  "Nothing to undo!","Undo Notification", 0
      END IF
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_CUT THEN
      SendMessage (Edit1, WM_CUT, 0, 0)
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_COPY THEN
      SendMessage (Edit1, WM_COPY, 0, 0)
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_PASTE THEN
      SendMessage (Edit1, WM_PASTE, 0, 0)
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_SELECTALL THEN
      SendMessage (Edit1, EM_SETSEL, 0, MAKELONG(-1,0))
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_OPTION THEN
      MessageBeep(MB_OK)
      DialogBox(GetModuleHandle(0),MAKEINTRESOURCE(IDD_OPTD),Form1,DlgOPT)
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_ABOUT THEN
      MessageBeep(MB_OK)
      DialogBox(GetModuleHandle(0),MAKEINTRESOURCE(IDD_ABOUT),Form1,AboutDlg)
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_TLD THEN
      MessageBeep(MB_OK)
      DialogBox(GetModuleHandle(0),MAKEINTRESOURCE(IDD_TLD),Form1,DlgTLD)
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_TCD THEN
      MessageBeep(MB_OK)
      DialogBox(GetModuleHandle(0),MAKEINTRESOURCE(IDD_TCD),Form1,DlgTCD)
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_TSD THEN
      MessageBeep(MB_OK)
      DialogBox(GetModuleHandle(0),MAKEINTRESOURCE(IDD_TSD),Form1,DlgTSD)
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_RLD THEN
      MessageBeep(MB_OK)
      DialogBox(GetModuleHandle(0),MAKEINTRESOURCE(IDD_RLD),Form1,DlgRLD)
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_RCD THEN
      MessageBeep(MB_OK)
      DialogBox(GetModuleHandle(0),MAKEINTRESOURCE(IDD_RCD),Form1,DlgRCD)
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_RSD THEN
      MessageBeep(MB_OK)
      DialogBox(GetModuleHandle(0),MAKEINTRESOURCE(IDD_RSD),Form1,DlgRSD)
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_EVLD THEN
      MessageBeep(MB_OK)
      DialogBox(GetModuleHandle(0),MAKEINTRESOURCE(IDD_EVLD),Form1,DlgEvLD)
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_EVCD THEN
      MessageBeep(MB_OK)
      DialogBox(GetModuleHandle(0),MAKEINTRESOURCE(IDD_EVCD),Form1,DlgEvCD)
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_CHCD THEN
      MessageBeep(MB_OK)
      DialogBox(GetModuleHandle(0),MAKEINTRESOURCE(IDD_CHCD),Form1,DlgCHCD)
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_CHSD THEN
      MessageBeep(MB_OK)
      DialogBox(GetModuleHandle(0),MAKEINTRESOURCE(IDD_CHSD),Form1,DlgCHSD)
      EXIT FUNCTION
    END IF

    IF LOWORD(wParam) = IDM_INTER THEN
      MessageBeep(MB_OK)
      DialogBox(GetModuleHandle(0),MAKEINTRESOURCE(IDD_INTER),Form1,DlgINTER)
      EXIT FUNCTION
    END IF
    EXIT FUNCTION

    CASE WM_SETFOCUS
    SetFocus(Edit1)
    EXIT FUNCTION

    CASE WM_PAINT
    hDC = BeginPaint(hWnd,&ps)
    T$ = "Editbox is using" & Str$(GetWindowTextLength(Edit1)) & " bytes"
    TextOut(hDC,75,128,T$,len(T$))
    EndPaint(hWnd,&ps)
    EXIT FUNCTION

    CASE WM_SIZE 'set editor size
    MoveWindow(Edit1,0, 0, LOWORD(lParam), HIWORD(lParam), TRUE)
    EXIT FUNCTION

    CASE WM_KEYDOWN
    IF wParam = VK_DELETE THEN
      SendMessage(Edit1, WM_CLEAR, 0, 0)
      Caption$ = Caption$ & " - " & szFile$
      SetWindowText (Form1, Caption$)
      bNeedSave = TRUE
    END IF
    EXIT FUNCTION

    CASE WM_DESTROY
    PostQuitMessage(0)
    EXIT FUNCTION

    CASE WM_LBUTTONDOWN
    notice ("Made it!")
    EXIT FUNCTION

  END SELECT
END FUNCTION
