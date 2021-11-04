unit BaseForms;
(*
  The module contains classes of the Base DataModule, Base Form and Base Frame,
  which is intended to replace the standard classes.
  These Base classes will help get around some bugs VCL, and expand the standard
  functionality

****************************************************************
  Author    : Zverev Nikolay (delphinotes.ru)
  Created   : 30.08.2006
  Modified  : 04.11.2021
  Version   : 1.04
  History   :
****************************************************************

  Before using this module the package
    packages\BaseFormsDesignXXX.dpk
  must be installed. If the file changes, you need to reinstall the package.
*)

interface

{$i jedi.inc}
{$i BaseForms.inc}

{$ifdef HAS_UNITSCOPE}
uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Contnrs,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms;
{$else}
uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Contnrs,
  Graphics,
  Controls,
  Forms;
{$endif}

//const
//  WM_DPICHANGED = 736; // 0x02E0

type
  TAutoFreeOnEvent = (afDefault, afHide, afDestroy);

  TBaseForm = class;
  TBaseFormClass = class of TBaseForm;

  TBaseFrame = class;
  TBaseFrameClass = class of TBaseFrame;

  { TBaseDataModule }

  TBaseDataModule = class(TDataModule)
  {$ifdef Allow_Localization}
    {$i BaseFormsLocalizeIntf.inc}
  {$endif}
  protected
    FAutoFreeObjects: TObjectList;
    procedure DoCreate; override;
    procedure DoDestroy; override;
    procedure ReadState(Reader: TReader); override;
  public
    function AutoFree(AObject: TObject): Pointer;
  published
    // standart properties - add the 'default' to not saved in dfm
    property OldCreateOrder default False;
  end;

  { TBaseForm }

  TBaseForm = class(TForm)
  {$ifdef Allow_Localization}
    {$i BaseFormsLocalizeIntf.inc}
  {$endif}
  //published
    // наследуемые свойства:
    //property AutoScroll default False;
    //property Position default poScreenCenter;
    //property ShowHint default True;
  protected
    {$ifdef Allow_ScaleFix}
    FPixelsPerInch: Integer;
    FNCHeight: Integer;
    FNCWidth: Integer;
    {$endif}
  private
    FCloseByEscape: Boolean;
    FFreeOnClose: Boolean;
    FInMouseWheelHandler: Boolean;
    FUseAdvancedWheelHandler: Boolean;

    procedure WriteClientHeight(Writer: TWriter);
    procedure WriteClientWidth(Writer: TWriter);
    {$ifdef Allow_ScaleFix}
    procedure WriteScaleFix(Writer: TWriter);
    procedure WriteNCHeight(Writer: TWriter);
    procedure WriteNCWidth(Writer: TWriter);
    procedure ReadNCHeight(Reader: TReader);
    procedure ReadNCWidth(Reader: TReader);
    {$endif}
    procedure ReadScaleFix(Reader: TReader);
    procedure CMChildKey(var Message: TCMChildKey); message CM_CHILDKEY;
    procedure WMSetIcon(var Message: TWMSetIcon); message WM_SETICON;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
    procedure WMQueryOpen(var Message: TWMQueryOpen); message WM_QUERYOPEN;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure WMWindowPosChanged(var Msg: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    //procedure WMDpiChanged(var Message: TMessage); message WM_DPICHANGED;
    //procedure CMParentFontChanged(var Message: TCMParentFontChanged); message CM_PARENTFONTCHANGED;
  protected
    FAutoFreeOnHide: TObjectList;
    FAutoFreeOnDestroy: TObjectList;

    procedure InitializeNewForm; {$ifdef TCustomForm_InitializeNewForm}override;{$else}dynamic;{$endif}
    procedure DefineProperties(Filer: TFiler); override;
    function HandleCreateException: Boolean; override;
    procedure DoClose(var Action: TCloseAction); override;
    procedure DoHide; override;
    procedure DoDestroy; override;
    procedure Loaded; override;
    function PostCloseMessage: LRESULT;
  public
    {$ifndef TCustomForm_InitializeNewForm}
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
    {$endif}
    procedure MouseWheelHandler(var Message: TMessage); override;
    function AutoFree(AObject: TObject; OnEvent: TAutoFreeOnEvent = afDefault): Pointer;
  published
    property CloseByEscape: Boolean read FCloseByEscape write FCloseByEscape default True;
    property FreeOnClose: Boolean read FFreeOnClose write FFreeOnClose default False;
    property UseAdvancedWheelHandler: Boolean read FUseAdvancedWheelHandler write FUseAdvancedWheelHandler default True;
  published
    // standart properties - add the 'default' to not saved in dfm
    property OldCreateOrder default False;
    property Left default 0;
    property Top default 0;
    property ParentFont default True;
    property Color default clBtnFace;
  end;

  { TBaseFrame }

  TBaseFrame = class(TFrame)
  private
  {$ifdef Allow_Localization}
    {$i BaseFormsLocalizeIntf.inc}
  {$endif}
//  protected
//    FAutoFreeObjects: TObjectList;
//    procedure DoDestroy; override;
  private
    {$ifdef Allow_ScaleFix}
    FPixelsPerInch: Integer;
    procedure WritePixelsPerInch(Writer: TWriter);
    {$endif}
    procedure ReadPixelsPerInch(Reader: TReader);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Loaded; override;
  published
    // standart properties - add the 'default' to not saved in dfm
    property Left default 0;
    property Top default 0;
    property TabOrder default 0;
  end;

procedure ClearUserInput;

{.$region 'LocalizationStub'}
{$ifdef Allow_Localization}
procedure LocalizeDataModule(ADataModule: TDataModule);
procedure LocalizeForm(AForm: TCustomForm);
procedure LocalizeFrame(AFrame: TCustomFrame);
procedure LocalizeRootComponent(Instance: TComponent);

function ResGet(Section: TClass; const StringID: string; const DefaultValue: string = ''): string; overload;
function ResGet(const Section, StringID: string; const DefaultValue: string = ''): string; overload;
{$endif}
{.$endregion}

{$ifdef SUPPORTS_CLASS_HELPERS}
type
  TFormHelper = class helper for TCustomForm
    // сhanging properties through Property causes windowhandle to be recreated (if any)
    // and Visible to be set True
    // the hack is needed to bypass this behavior
    procedure SafeSetBorderIcons(ABorderIcons: TBorderIcons);
    procedure SafeSetBorderStyle(ABorderStyle: TFormBorderStyle);
    procedure SafeSetFormStyle(AFormStyle: TFormStyle);
    procedure SafeSetPosition(APosition: TPosition);
    procedure SafeSetWidowState(AWindowState: TWindowState);
  end;
{$endif}

implementation

uses
{$ifdef Allow_ScaleFix}
  uScaleControls,
{$endif}
{$ifdef HAS_UNITSCOPE}
  System.Types,
  Vcl.StdCtrls;
{$else}
  Types,
  StdCtrls;
{$endif}

//{$ifdef Allow_ScaleFix}
//const
//  DesignerDefaultFontName = 'Tahoma';

//{$endif}

procedure ClearUserInput;
var
  Msg: TMsg;
  NeedTerminate: Boolean;
begin
  NeedTerminate := False;
  while PeekMessage(Msg, 0, WM_MOUSEFIRST, WM_MOUSELAST, PM_REMOVE or PM_NOYIELD) do
    NeedTerminate := NeedTerminate or (Msg.message = WM_QUIT);
  while PeekMessage(Msg, 0, WM_KEYFIRST, WM_KEYLAST, PM_REMOVE or PM_NOYIELD) do
    NeedTerminate := NeedTerminate or (Msg.message = WM_QUIT);
  if NeedTerminate then
    Application.Terminate;
end;

{$i BaseFormsFrndHackTypes.inc}

{$ifdef SUPPORTS_CLASS_HELPERS}
{ TFormHelper }

procedure TFormHelper.SafeSetBorderIcons(ABorderIcons: TBorderIcons);
begin
  THackCustomForm(Self).FBorderIcons := ABorderIcons;
end;

procedure TFormHelper.SafeSetBorderStyle(ABorderStyle: TFormBorderStyle);
begin
  THackCustomForm(Self).FBorderStyle := ABorderStyle;
end;

procedure TFormHelper.SafeSetFormStyle(AFormStyle: TFormStyle);
begin
  THackCustomForm(Self).FFormStyle := AFormStyle;
end;

procedure TFormHelper.SafeSetPosition(APosition: TPosition);
begin
  THackCustomForm(Self).FPosition := APosition;
end;

procedure TFormHelper.SafeSetWidowState(AWindowState: TWindowState);
begin
  THackCustomForm(Self).FWindowState := AWindowState;
end;

{$endif}

{.$region 'RestoreFormsPositions'}
type
  TWndList = array of HWND;

var
  GIsMinimizing: Boolean;
  GIsRestoring: Boolean;
  GIsActivating: Boolean;
  GLastModalMinimized: TWndList;
  GLastDisabled: TWndList;

procedure GetVisibleNotMinimized(var AWndList: TWndList);
var
  LCount, i: Integer;
  F: TForm;
begin
  // gets a list of visible and non-minimized windows in the order in which they are displayed
  SetLength(AWndList, Screen.FormCount);
  LCount := 0;
  for i := 0 to Screen.FormCount - 1 do
  begin
    F := Screen.Forms[i];
    if (F.FormStyle <> fsMDIChild) and F.HandleAllocated and IsWindowVisible(F.Handle) and not IsIconic(F.Handle) then
    begin
      AWndList[LCount] := F.Handle;
      Inc(LCount);
    end;
  end;
  SetLength(AWndList, LCount);
end;

procedure GetDisabled(var AWndList: TWndList);
var
  LCount, i: Integer;
  F: TForm;
begin
<<<<<<< HEAD
  // gets a list of visible and disabled windows
=======
  // gets a list of visible and non-minimized windows in the order in which they are displayed
>>>>>>> 051ba9b04cd684e2d8ea62bcee86ad1fe25922db
  SetLength(AWndList, Screen.FormCount);
  LCount := 0;
  for i := 0 to Screen.FormCount - 1 do
  begin
    F := Screen.Forms[i];
    if (F.FormStyle <> fsMDIChild) and F.HandleAllocated and IsWindowVisible(F.Handle) and not IsWindowEnabled(F.Handle) then
    begin
      AWndList[LCount] := F.Handle;
      Inc(LCount);
    end;
  end;
  SetLength(AWndList, LCount);
end;

procedure EnableDisabled;
var
  i: Integer;
begin
  // https://www.sql.ru/forum/actualutils.aspx?action=gotomsg&tid=1339878&msg=22391822
  GetDisabled(GLastDisabled);
  for i := Low(GLastDisabled) to High(GLastDisabled) do
    EnableWindow(GLastDisabled[i], True);
end;

procedure DisableEnabled;
var
  i: Integer;
begin
  // https://www.sql.ru/forum/actualutils.aspx?action=gotomsg&tid=1339878&msg=22391822
  for i := Low(GLastDisabled) to High(GLastDisabled) do
    EnableWindow(GLastDisabled[i], False);
  SetLength(GLastDisabled, 0);
end;

function IsWindowInList(AWnd: HWND; const AWndList: TWndList): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := Low(AWndList) to High(AWndList) do
    if AWndList[i] = AWnd then
      Exit;
  Result := False;
end;

function HandleMinimizeAllByModal: Boolean;
var
  i: Integer;
begin
  Result := False;
  if GIsMinimizing then
    Exit;
  GIsMinimizing := True;
  try
    // save the list of non-minimized windows
    GetVisibleNotMinimized(GLastModalMinimized);
    // now minimize them all
    for i := Low(GLastModalMinimized) to High(GLastModalMinimized) do
      ShowWindow(GLastModalMinimized[i], SW_SHOWMINNOACTIVE);
    Application.Minimize;
    // save the list of disabled windows and enable them
    EnableDisabled;

    Result := True;
  finally
    GIsMinimizing := False;
  end;
end;

function HandleRestoreMinimized(AWnd: HWND): Boolean;
var
  i: Integer;
begin
  Result := False;
  if GIsRestoring then
    Exit;
  if Length(GLastModalMinimized) = 0 then
    Exit;
  GIsRestoring := True;
  try
    // disable previously enabled windows
    DisableEnabled;

    Application.Restore;
    if not IsWindowInList(AWnd, GLastModalMinimized) then
      ShowWindow(AWnd, SW_SHOWNOACTIVATE);
    for i := High(GLastModalMinimized) downto Low(GLastModalMinimized) do
      ShowWindow(GLastModalMinimized[i], SW_SHOWNOACTIVATE);
    SetForegroundWindow(GLastModalMinimized[0]);

    SetLength(GLastModalMinimized, 0);
    Result := True;
  finally
    GIsRestoring := False;
  end;
end;

function HandleActivateDisabled(AWnd: HWND): Boolean;
var
  LWndList: TWndList;
  i: Integer;
begin
  Result := True;
  if GIsActivating then
    Exit;
  // when activated by Alt+Tab, the WM_QUERYOPEN message is not sent, so we need to restore the minimized windows
  if HandleRestoreMinimized(AWnd) then
    Exit;
  GetVisibleNotMinimized(LWndList);
  if Length(LWndList) = 0 then
    Exit;
  GIsActivating := True;
  try
    for i := High(LWndList) downto Low(LWndList) do
      BringWindowToTop(LWndList[i]);
    SetForegroundWindow(LWndList[0]);
  finally
    GIsActivating := False;
  end;
end;
{.$endregion}

{.$region 'LocalizationStub'}
{$ifdef Allow_Localization}
procedure LocalizeDataModule(ADataModule: TDataModule);
begin
  LocalizeRootComponent(ADataModule);
end;

procedure LocalizeForm(AForm: TCustomForm);
begin
  LocalizeRootComponent(AForm);
end;

procedure LocalizeFrame(AFrame: TCustomFrame);
begin
  LocalizeRootComponent(AFrame);
end;

procedure LocalizeRootComponent(Instance: TComponent);
begin
  // Call Localizer to Localize (Translate) Instance
  {.$MESSAGE HINT 'sorry, not implemented yet'}
  // TODO: do this


  // Call user OnLocalize event handler:
  if Instance is TBaseDataModule then
    TBaseDataModule(Instance).Localize else
  if Instance is TBaseForm then
    TBaseForm(Instance).Localize else
  if Instance is TBaseFrame then
    TBaseFrame(Instance).Localize;
  // else - send msg (WM_LOCALIZE) ?
end;

function ResGet(Section: TClass; const StringID: string; const DefaultValue: string = ''): string;
begin
  Result := ResGet(Section.ClassName, StringID, DefaultValue);
end;

function ResGet(const Section, StringID: string; const DefaultValue: string = ''): string;
begin
  {.$MESSAGE HINT 'sorry, not implemented yet'}
  // TODO: do this
  Result := DefaultValue;
end;
{$endif}
{.$endregion}

{ TBaseDataModule }

{$ifdef Allow_Localization}
procedure TBaseDataModule.DoLocalize;
begin
  if Assigned(FOnLocalize) then
    FOnLocalize(Self);
end;

procedure TBaseDataModule.Localize;
begin
  DoLocalize;
end;

class function TBaseDataModule.ResGet(const StringID: string; const DefaultValue: string = ''): string;
begin
  Result := BaseForms.ResGet(Self, StringID, DefaultValue);
end;
{$endif}

procedure TBaseDataModule.DoCreate;
begin
  {$ifdef Allow_Localization}
  LocalizeDataModule(Self);
  {$endif}
  inherited DoCreate;
end;

procedure TBaseDataModule.DoDestroy;
begin
  inherited DoDestroy;
  // destory auto free objects
  FreeAndNil(FAutoFreeObjects);
end;

procedure TBaseDataModule.ReadState(Reader: TReader);
begin
  // skip inherited, because there is seting OldCreateOrder to False
  TFriendlyReader(Reader).ReadData(Self);
end;

function TBaseDataModule.AutoFree(AObject: TObject): Pointer;
begin
  if not Assigned(FAutoFreeObjects) then
    FAutoFreeObjects := TObjectList.Create;
  FAutoFreeObjects.Add(AObject);
  Result := AObject;
end;

{ TBaseForm }

{$ifdef Allow_Localization}
procedure TBaseForm.DoLocalize;
begin
  if Assigned(FOnLocalize) then
    FOnLocalize(Self);
end;

procedure TBaseForm.Localize;
begin
  DoLocalize;
end;

class function TBaseForm.ResGet(const StringID: string; const DefaultValue: string = ''): string;
begin
  Result := BaseForms.ResGet(Self, StringID, DefaultValue);
end;
{$endif}

procedure TBaseForm.WriteClientHeight(Writer: TWriter);
begin
  Writer.WriteInteger(ClientHeight);
end;

procedure TBaseForm.WriteClientWidth(Writer: TWriter);
begin
  Writer.WriteInteger(ClientWidth);
end;

{$ifdef Allow_ScaleFix}
procedure TBaseForm.WriteScaleFix(Writer: TWriter);
begin
  // just save flag to DFM for disable VCL scale on ReadState
  Writer.WriteBoolean(True);
end;

procedure TBaseForm.WriteNCHeight(Writer: TWriter);
begin
  Writer.WriteInteger(Height - ClientHeight);
end;

procedure TBaseForm.WriteNCWidth(Writer: TWriter);
begin
  Writer.WriteInteger(Width - ClientWidth);
end;

procedure TBaseForm.ReadNCHeight(Reader: TReader);
begin
  FNCHeight := Reader.ReadInteger;
end;

procedure TBaseForm.ReadNCWidth(Reader: TReader);
begin
  FNCWidth := Reader.ReadInteger;
end;
{$endif}

procedure TBaseForm.ReadScaleFix(Reader: TReader);
begin
  if not Reader.ReadBoolean then
    Exit;

  {$ifdef Allow_ScaleFix}
  // save readed PixelsPerInch from DFM
  FPixelsPerInch := THackCustomForm(Self).FPixelsPerInch;
  // and set current value
  THackCustomForm(Self).FPixelsPerInch := Screen.PixelsPerInch;

  // reset TextHeight, for disable scale on VCL level
  THackCustomForm(Self).FTextHeight := 0;
  {$endif}
end;

procedure TBaseForm.InitializeNewForm;
begin
  {$ifdef TCustomForm_InitializeNewForm}
  inherited InitializeNewForm;
  {$endif}
  FCloseByEscape := True;
  FUseAdvancedWheelHandler := True;

  {$ifdef DoubleBufferedAlwaysOn}
  DoubleBuffered := True;
  {$endif}
  ParentFont := True;
end;

{$ifndef TCustomForm_InitializeNewForm}
constructor TBaseForm.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin
  inherited CreateNew(AOwner, Dummy);
  InitializeNewForm;
end;
{$endif}

procedure TBaseForm.MouseWheelHandler(var Message: TMessage);
  procedure WheelMsgToScrollMsg(const AWheelMsg: TMessage; var AScrollMsg: TMessage; var AScrollCount: DWORD);
  var
    LWheelMsg: TWMMouseWheel absolute AWheelMsg;
    LScrollMsg: TWMScroll absolute AScrollMsg;
    //LShiftState: TShiftState;
  begin
    ZeroMemory(@LScrollMsg, SizeOf(LScrollMsg));

    //LShiftState := KeysToShiftState(LWheelMsg.Keys);

    // Если зажата Shift - горизонтальная прокрутка, иначе - вертикальная
    //if ssShift in LShiftState then
    if GetKeyState(VK_SHIFT) < 0 then
      LScrollMsg.Msg := WM_HSCROLL
    else
      LScrollMsg.Msg := WM_VSCROLL;

    // Если зажата Ctrl - прокручиваем страницами, иначе - построчно
    //if ssCtrl in LShiftState then
    if GetKeyState(VK_CONTROL) < 0 then
    begin
      if LWheelMsg.WheelDelta > 0 then
        LScrollMsg.ScrollCode := SB_PAGEUP
      else
        LScrollMsg.ScrollCode := SB_PAGEDOWN;
      // прокрутку выполняем один раз:
      AScrollCount := 1;
    end else
    begin
      if LWheelMsg.WheelDelta > 0 then
        LScrollMsg.ScrollCode := SB_LINEUP
      else
        LScrollMsg.ScrollCode := SB_LINEDOWN;
      // прокрутку делаем N-раз
      //SystemParametersInfo(SPI_GETWHEELSCROLLLINES, 0, @AScrollCount, 0);
      AScrollCount := Mouse.WheelScrollLines;
      if AScrollCount <= 0 then
        AScrollCount := 1;
    end;
  end;

  function IsScrollable(Control: TControl; IsVert: Boolean): Boolean;
  begin
    if Control is TScrollingWinControl then
    begin
      if IsVert then
        Result := TScrollingWinControl(Control).VertScrollBar.IsScrollBarVisible
      else
        Result := TScrollingWinControl(Control).HorzScrollBar.IsScrollBarVisible;
    end else
      Result := False;
  end;

  function GetScrollPos(Control: TControl; IsVert: Boolean): Integer;
  begin
    if Control is TScrollingWinControl then
    begin
      if IsVert then
        Result := TScrollingWinControl(Control).VertScrollBar.Position
      else
        Result := TScrollingWinControl(Control).HorzScrollBar.Position;
    end else
      Result := 0;
  end;

  procedure ScrollControl(Control: TControl; var AMessage: TMessage; ScrollCount: DWORD);
  var
    i: Integer;
  begin
    for i := 1 to ScrollCount do
      Control.WindowProc(AMessage);
  end;

var
  LMsg: TWMMouseWheel absolute Message;
  LMouseControl: TControl;
  LControl: TControl;
  LComponent: TComponent;

  i: Integer;

  LWMScroll: TMessage;
  LScrollCount: DWORD;
  LScrollPos: Integer;
begin
  if not UseAdvancedWheelHandler then
  begin
    inherited MouseWheelHandler(Message);
    Exit;
  end;

  // Переопределяем логику обработки колеса мыши следующим образом:
  //  а) ищем контрол под курсором
  //  б) далее ищем родительский, который имеет полосы прокрутки
  //  в) выполняем прокрутку
  //  г) но не забываем о том, что контрол в фокусе может иметь свою обработку, которую стоит запускать:
  //     - либо когда он под курсором
  //     - либо когда он имеет дочерние контролы с прокруткой
  if FInMouseWheelHandler then
    Exit;
  FInMouseWheelHandler := True;
  try
    // Если мышь захвачена (например выпавшим списком в Combobox'е) - используем только дефолтовый обработчик
    if GetCapture <> 0 then
    begin
      inherited MouseWheelHandler(Message);
      Exit;
    end;

    // Ищем контрол под курсором
    LMouseControl := FindControl(WindowFromPoint(SmallPointToPoint(TWMMouseWheel(Message).Pos)));

    // Если он при этом в фокусе, отдаём обработку сначала ему
    if (LMouseControl is TWinControl) and TWinControl(LMouseControl).Focused then
    begin
      // HINT: MouseWheelHandler генерирует CM_MOUSEWHEEL сообщение, которое может и не обработаться
      // поэтому проверяем результат и посылаем сообщение (WM_MOUSEWHEEL) напрямую
      inherited MouseWheelHandler(Message);
      if Message.Result = 0 then
        LMouseControl.WindowProc(Message);
      if Message.Result <> 0 then
        Exit;
    end;

    // Далее обрабатываем такую ситуацию: у контрола, который в фокусе, могут быть дочерние компоненты,
    // умеющие обрабатывать прокрутку - проверяем это
    // (например, выпадающие списки в EhLib)
    if Assigned(ActiveControl) then
    begin
      for i := 0 to ActiveControl.ComponentCount - 1 do
      begin
        LComponent := ActiveControl.Components[i];
        if (LComponent is TControl) and TControl(LComponent).Visible then
        begin
          TControl(LComponent).WindowProc(Message);
          if Message.Result <> 0 then
            Exit;
        end;
      end;
    end;

    // Теперь от контрола под курсором смотрим родительские и пытаемся выполнить прокрутку
    // посредством передачи сообщения WM_HSCROLL/WM_VSCROLL
    WheelMsgToScrollMsg(Message, LWMScroll, LScrollCount);
    LControl := LMouseControl;
    while Assigned(LControl) do
    begin
      if IsScrollable(LControl, LWMScroll.Msg = WM_VSCROLL) then
      begin
        // Здесь: нашли контрол с возможностью отреагировать на прокрутку
        // Теперь обработчик по умолчанию вызываться не должен
        Message.Result := 1;

        // Пытаемся прокрутить, если при этом реальной прокрутки не было, то смотрим дальше
        LScrollPos := GetScrollPos(LControl, LWMScroll.Msg = WM_VSCROLL);
        ScrollControl(LControl, LWMScroll, LScrollCount);
        if LWMScroll.Result = 0 then
          if LScrollPos <> GetScrollPos(LControl, LWMScroll.Msg = WM_VSCROLL) then
            LWMScroll.Result := 1;
        if LWMScroll.Result <> 0 then
          Break;
      end;
      LControl := LControl.Parent;
    end;

    {
    if Message.Result <> 0 then
       Exit;

    // Так и не обработали, попробуем обработать прокрутку контролом напрямую
    if Assigned(LMouseControl) then
      // HINT: здесь используем CM_MOUSEWHEEL, т.к. WM_MOUSEWHEEL вызовет MouseWheelHandler, который придёт сюда
      Message.Result := LMouseControl.Perform(CM_MOUSEWHEEL, Message.WParam, Message.LParam);
      это плохо: CM_MOUSEWHEEL обрабатывается TDBComboboxEh, а хочется, чтобы только гридом
    }
    if Message.Result = 0 then
      inherited MouseWheelHandler(Message);
  finally
    FInMouseWheelHandler := False;
  end;
end;

procedure TBaseForm.DefineProperties(Filer: TFiler);
  function NeedWriteClientSize: Boolean;
  begin
    //Result := Scaled and not IsClientSizeStored
    // IsClientSizeStored = not IsFormSizeStored
    // IsFormSizeStored = AutoScroll or (HorzScrollBar.Range <> 0) or (VertScrollBar.Range <> 0)
    Result := Scaled and (AutoScroll or (HorzScrollBar.Range <> 0) or (VertScrollBar.Range <> 0));
  end;

  function NeedWriteNCHeight: Boolean;
  begin
    Result := Scaled and (Height <> ClientHeight) and ((Constraints.MinHeight <> 0) or (Constraints.MaxHeight <> 0));
  end;

  function NeedWriteNCWidth: Boolean;
  begin
    Result := Scaled and (Width <> ClientWidth) and ((Constraints.MinWidth <> 0) or (Constraints.MaxWidth <> 0));
  end;

begin
  inherited DefineProperties(Filer);

  // ClientHeight и ClientWidth сохраняются не всегда, а вместо этого сохраняются внешние размеры формы.
  // Это не совсем правильно, т.к. масштабировать необходимо именно клиентскую область. Функция NeedWriteClientSize
  // определяет, нужно ли принудительно сохранять размер клиентской области.
  Filer.DefineProperty('ClientHeight', nil, WriteClientHeight, NeedWriteClientSize);
  Filer.DefineProperty('ClientWidth', nil, WriteClientWidth, NeedWriteClientSize);

  {$ifdef Allow_ScaleFix}
  // так же сохраняем разницу между внешними размерами и клиентской областью,
  // это необходимо при использовании констрейнтов для корректного их масштабирования
  Filer.DefineProperty('NCHeight', ReadNCHeight, WriteNCHeight, NeedWriteNCHeight);
  Filer.DefineProperty('NCWidth', ReadNCWidth, WriteNCWidth, NeedWriteNCWidth);
  Filer.DefineProperty('ScaleFix', ReadScaleFix, WriteScaleFix, Scaled);
  {$else}
  Filer.DefineProperty('ScaleFix', ReadScaleFix, nil, False);
  {$endif}
end;

function TBaseForm.HandleCreateException: Boolean;
begin
  Result := inherited HandleCreateException;
  // HandleCreateException вызывает Application.HandleException(Self);
  // при этом само исключение поглащается, тем самым ошибки в OnCreate формы не отменяют создание формы
  // в итоге форма может создаться не до конца проинициализированной
  // Меня это не устраивает, вызываем Abort для отмены операции создания формы при ошибках в OnCreate
  if Result then
    Abort; // TODO: AbortOnCreateError default True
end;

procedure TBaseForm.DoClose(var Action: TCloseAction);
begin
  if FreeOnClose then
    Action := caFree;
  inherited DoClose(Action);  // <- Form.OnClose
end;

procedure TBaseForm.DoHide;
begin
  inherited DoHide;           // <- Form.OnHide
  // destory auto free objects
  FreeAndNil(FAutoFreeOnHide);
end;

procedure TBaseForm.DoDestroy;
begin
  inherited DoDestroy;        // <- Form.OnDestroy
  // destory auto free objects
  FreeAndNil(FAutoFreeOnHide);
  FreeAndNil(FAutoFreeOnDestroy);
end;

procedure TBaseForm.Loaded;
  {$ifdef Allow_ScaleFix}
  function DPIChanged: Boolean;
  begin
    Result := FPixelsPerInch <> Screen.PixelsPerInch;
  end;

  //function FontChanged: Boolean;
  //begin
  //  Result := ParentFont and ((Application.DefaultFont.Name <> DesignerDefaultFontName) or (Application.DefaultFont.Size <> 8));
  //end;

  function NeedConstraintsResize: Boolean;
  begin
    //Result := (Constraints.MaxHeight <> 0) or (Constraints.MaxWidth <> 0)
    // (Constraints.MinHeight <> 0) or (Constraints.MinWidth <> 0);
    //if Result then
    //  Result
    Result := (FNCHeight <> 0) or (FNCWidth <> 0);
  end;

  function NeedScale: Boolean;
  begin
//Result := True;
//Exit;
    Result := (FPixelsPerInch > 0) and (DPIChanged {or FontChanged} or NeedConstraintsResize);
  end;
  {$endif}
begin
  {$ifdef Allow_ScaleFix}
  //HINT: VCL использует ScalingFlags, анализируя их в ReadState
  //      ReadState вызывается для каждого класса в иерархии, у которых есть DFM ресурс,
  //      поэтому ScalingFlags используются, чтобы не промасштабировать
  //      что-то несколько раз.
  //
  //      Сейчас масштабирование вынесено в Loaded, а FPixelsPerInch считывается только для Root-компонента,
  //      поэтому наше масштабирование вызываться будет один раз.
  if NeedScale then
  begin
    uScaleControls.TScaleControls.Scale(Self, Screen.PixelsPerInch, FPixelsPerInch);
    FPixelsPerInch := Screen.PixelsPerInch;
  end;
  {$endif}

  inherited Loaded;
end;

function TBaseForm.PostCloseMessage: LRESULT;
begin
  // for Modal state - talk Cancel
  if fsModal in FormState then
  begin
    ModalResult := mrCancel;
    Result := 1;
  end else
    // for normal - send command to close
    Result := LRESULT(PostMessage(Handle, WM_CLOSE, 0, 0));
end;

function TBaseForm.AutoFree(AObject: TObject; OnEvent: TAutoFreeOnEvent = afDefault): Pointer;
begin
  if OnEvent = afDefault then
    if fsShowing in FormState
      then OnEvent := afHide
      else OnEvent := afDestroy;

  case OnEvent of
    afHide:
      begin
        if not Assigned(FAutoFreeOnHide) then
          FAutoFreeOnHide := TObjectList.Create;
        FAutoFreeOnHide.Add(AObject);
      end;
    afDestroy:
      begin
        if not Assigned(FAutoFreeOnDestroy) then
          FAutoFreeOnDestroy := TObjectList.Create;
        FAutoFreeOnDestroy.Add(AObject);
      end;
  else
    Assert(False);
  end;
  Result := AObject;
end;

procedure TBaseForm.CMChildKey(var Message: TCMChildKey);
  function WantSpecKey(AControl: TWinControl; ACharCode: Word): Boolean;
  begin
    repeat
      Result := AControl.Perform(CM_WANTSPECIALKEY, WPARAM(ACharCode), LPARAM(0)) <> LRESULT(0);
      if Result then
        Exit;
      AControl := AControl.Parent;
      //AControl := AControl.Owner
    until not Assigned(AControl) or (AControl = Self);
  end;
begin
  // handling CloseByEscape
  if CloseByEscape then
    with Message do
      if (CharCode = VK_ESCAPE) and not WantSpecKey(Sender, CharCode) then
      begin
        Result := PostCloseMessage;
        if Result <> 0 then
          Exit;
      end;

  inherited;
end;

procedure TBaseForm.WMSetIcon(var Message: TWMSetIcon);
begin
  // At the time of the destruction of the window ignore the installation icon
  // (otherwise it is noticeable in animations in Windows Aero)
  if (csDesigning in ComponentState) or not (csDestroying in ComponentState) then
    inherited;
end;

procedure TBaseForm.WMSysCommand(var Message: TWMSysCommand);
begin
  if (Message.CmdType = SC_MINIMIZE) and (fsModal in FormState) then
  begin
    // Here: window is in a Modal state, so wee need to minimize all non-minimized windows
    if HandleMinimizeAllByModal then
    begin
      Message.Result := 1;
      Exit;
    end;
  end;
  inherited;
end;

procedure TBaseForm.WMQueryOpen(var Message: TWMQueryOpen);
begin
  // Here: user clicked on minimized window icon in taskbar
  if HandleRestoreMinimized(Handle) then
  begin
    Message.Result := 0;
    Exit;
  end;
  inherited;
end;

procedure TBaseForm.WMActivate(var Message: TWMActivate);
begin
  if not (csDesigning in ComponentState) and (Message.Active > 0) and not IsWindowEnabled(Handle) then
  begin
    // Here: our window is disabled, but somehow is activated,
    // Most likely there is modal window, if any - then we must show them
    if HandleActivateDisabled(Handle) then
    begin
      Message.Result := 0;
      Exit;
    end;
  end;
  inherited;
end;

procedure TBaseForm.WMWindowPosChanged(var Msg: TWMWindowPosChanged);
begin
  if IsIconic(Handle) then
    // VCL bug: calling UpdateBounds from the Restore event causes additional window flickering
    Exit;
  inherited;
end;

//procedure TBaseForm.CMParentFontChanged(var Message: TCMParentFontChanged);
//begin
//  inherited;
//end;

//procedure TBaseForm.WMDpiChanged(var Message: TMessage);
//var
//  LNewPPI: Integer;
//begin
//  LNewPPI := LOWORD(Message.wParam);
//  Self.ParentFont := False;
//  uScaleControls.TScaleControls.Scale(Self, LNewPPI, FPixelsPerInch);
//  FPixelsPerInch := LNewPPI;
//  Message.Result := 0;
//end;

{ TBaseFrame }

{$ifdef Allow_Localization}
procedure TBaseFrame.DoLocalize;
begin
  if Assigned(FOnLocalize) then
    FOnLocalize(Self);
end;

procedure TBaseFrame.Localize;
begin
  DoLocalize;
end;

class function TBaseFrame.ResGet(const StringID: string; const DefaultValue: string = ''): string;
begin
  Result := BaseForms.ResGet(Self, StringID, DefaultValue);
end;
{$endif}

{$ifdef Allow_ScaleFix}
procedure TBaseFrame.WritePixelsPerInch(Writer: TWriter);
begin
  Writer.WriteInteger(Screen.PixelsPerInch);
end;
{$endif}

procedure TBaseFrame.ReadPixelsPerInch(Reader: TReader);
begin
  {$ifdef Allow_ScaleFix}FPixelsPerInch := {$endif}Reader.ReadInteger;
end;

procedure TBaseFrame.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);

  {$ifdef Allow_ScaleFix}
  // сохранять свойство PixelsPerInch нужно только при дизайне самой фреймы. Если фрейма встроена во что-то, то
  // тогда свойство сохранять не нужно
  Filer.DefineProperty('PixelsPerInch', ReadPixelsPerInch, WritePixelsPerInch, not Assigned(Filer.Ancestor));
  {$else}
  Filer.DefineProperty('PixelsPerInch', ReadPixelsPerInch, nil, False);
  {$endif}
end;

procedure TBaseFrame.Loaded;
  {$ifdef Allow_ScaleFix}
  function DPIChanged: Boolean;
  begin
    Result := FPixelsPerInch <> Screen.PixelsPerInch;
  end;

  //function FontChanged: Boolean;
  //begin
  //  Result := (Application.DefaultFont.Name <> DesignerDefaultFontName) or (Application.DefaultFont.Size <> 8);
  //end;

  function NeedScale: Boolean;
  begin
    Result := (FPixelsPerInch > 0) and (DPIChanged {or FontChanged});
  end;
  {$endif}
begin
  {$ifdef Allow_ScaleFix}
  // масштабируем только в том случае, если фрейм создаётся в Run-Time вручную (т.е. Parent = nil),
  // либо в дизайнере
  if NeedScale and (not Assigned(Parent) or (csDesigning in ComponentState)) then
    uScaleControls.TScaleControls.Scale(Self, Screen.PixelsPerInch, FPixelsPerInch);
  {$endif}

  inherited Loaded;
end;

//procedure TBaseFrame.DoDestroy;
//begin
//  inherited DoDestroy;
//end;

end.
