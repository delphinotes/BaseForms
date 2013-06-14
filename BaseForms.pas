unit BaseForms;
(*
  The module contains classes of the Base DataModule, Base Form and Base Frame,
  which is intended to replace the standard classes.
  These Base classes will help get around some bugs VCL, and expand the standard
  functionality

****************************************************************
  Author    : Zverev Nikolay (delphinotes.ru)
  Created   : 30.08.2006
  Modified  : 19.01.2013
  Version   : 1.00
  History   :
****************************************************************

  Before using this module the package
    packages\BaseFormsDesignXXX.dpk
  must be installed. If the file changes, you need to reinstall the package.
*)

interface

{$i BaseForms.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Contnrs;

type
  TAutoFreeOnEvent = (afDefault, afHide, afDestroy);

  TBaseForm = class;
  TBaseFormClass = class of TBaseForm;

  TBaseFrame = class;
  TBaseFrameClass = class of TBaseFrame;

  { TBaseDataModule }

  TBaseDataModule = class(TDataModule)
  {$i BaseFormsLocalizeIntf.inc}
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
  {$i BaseFormsLocalizeIntf.inc}
  {$ifdef Allow.ScaleFix}
  private
    FPixelsPerInch: Integer;
    procedure WriteClientHeight(Writer: TWriter);
    procedure WriteClientWidth(Writer: TWriter);
    procedure WriteScaleFix(Writer: TWriter);
    procedure ReadScaleFix(Reader: TReader);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Loaded; override;
  {$endif}
  //published
    // наследуемые свойства:
    //property AutoScroll default False;
    //property Position default poScreenCenter;
    //property ShowHint default True;
  private
    FCloseByEscape: Boolean;
    FFreeOnClose: Boolean;

    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure WMSetIcon(var Message: TWMSetIcon); message WM_SETICON;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
  protected
    FAutoFreeOnHide: TObjectList;
    FAutoFreeOnDestroy: TObjectList;

    procedure InitializeNewForm; {$ifdef TCustomForm.InitializeNewForm}override;{$else}virtual;{$endif}
    procedure DoClose(var Action: TCloseAction); override;
    procedure DoHide; override;
    procedure DoDestroy; override;
  public
    {$ifndef TCustomForm.InitializeNewForm}
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
    {$endif}
    function AutoFree(AObject: TObject; OnEvent: TAutoFreeOnEvent = afDefault): Pointer;
  published
    property CloseByEscape: Boolean read FCloseByEscape write FCloseByEscape default True;
    property FreeOnClose: Boolean read FFreeOnClose write FFreeOnClose default False;
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
  {$i BaseFormsLocalizeIntf.inc}
//  protected
//    FAutoFreeObjects: TObjectList;
//    procedure DoDestroy; override;
  {$ifdef Allow.ScaleFix}
  private
    FPixelsPerInch: Integer;
    procedure WritePixelsPerInch(Writer: TWriter);
    procedure ReadPixelsPerInch(Reader: TReader);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure Loaded; override;
  {$endif}
  published
    // standart properties - add the 'default' to not saved in dfm
    property Left default 0;
    property Top default 0;
    property TabOrder default 0;
  end;

{.$region 'LocalizationStub'}
{$ifdef Allow.Localization}
procedure LocalizeDataModule(ADataModule: TDataModule);
procedure LocalizeForm(AForm: TCustomForm);
procedure LocalizeFrame(AFrame: TCustomFrame);
procedure LocalizeRootComponent(Instance: TComponent);

function ResGet(Section: TClass; const StringID: string; const DefaultValue: string = ''): string; overload;
function ResGet(const Section, StringID: string; const DefaultValue: string = ''): string; overload;
{$endif}
{.$endregion}

{.$region 'ScaleControl'}
// ScaleControl - масштабирует контрол, его шрифт, констрейнты и его дочерние (если есть) - рекурсивно
procedure ScaleControl(Control: TControl; MX, DX, MY, DY, MF, DF: Integer); overload;
procedure ScaleControl(Control: TControl; M, D: Integer); overload;
{.$endregion}


implementation

uses
  {$ifdef bf_tb2k}
  TB2ToolWindow,
  {$endif}
  StdCtrls;

{$i BaseFormsFrndHackTypes.inc}

{.$region 'RestoreFormsPositions'}
var
  IsRestoringPositions: Boolean;

procedure RestoreFormsPositions;
var
  Count, I: Integer;
  FormsArray: array of TCustomForm;
begin
  if IsRestoringPositions then
    Exit;

  IsRestoringPositions := True;
  try
    // save the window list in the order in which they are displayed
    Count := Screen.CustomFormCount;
    SetLength(FormsArray, Count);
    for I := 0 to Count - 1 do
      FormsArray[I] := Screen.CustomForms[I];

    // now restore this order
    for I := Count - 1 downto 0 do
      if FormsArray[I].HandleAllocated then
        BringWindowToTop(FormsArray[I].Handle);
  finally
    IsRestoringPositions := False;
  end;
end;
{.$endregion}

{.$region 'LocalizationStub'}
{$ifdef Allow.Localization}
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
  {$MESSAGE HINT 'sorry, not implemented yet'}
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
  {$MESSAGE HINT 'sorry, not implemented yet'}
  // TODO: do this
  Result := DefaultValue;
end;
{$endif}
{.$endregion}

{.$region 'ScaleControl'}
procedure ScaleControl(Control: TControl; MX, DX, MY, DY, MF, DF: Integer);
  procedure ScaleScrollBars(Control: TScrollingWinControl);
  begin
    with THackScrollingWinControl(Control) do
    begin
      // ScaleScrollBars
      if not FAutoScroll then
      begin
        //with FHorzScrollBar do if FScaled then Range := MulDiv(Range, MX, DX);
        //with FVertScrollBar do if FScaled then Range := MulDiv(Range, MY, DY);
        with FHorzScrollBar do
        begin
          Position := 0;
          Range := MulDiv(Range, MX, DX);
        end;
        with FVertScrollBar do
        begin
          Position := 0;
          Range := MulDiv(Range, MY, DY);
        end;
      end;
    end;
  end;

  procedure ScaleConstraints(Control: TControl);
  begin
    with THackSizeConstraints(Control.Constraints) do
    begin
      FMaxHeight := MulDiv(FMaxHeight, MY, DY);
      FMaxWidth := MulDiv(FMaxWidth, MX, DX);
      FMinHeight := MulDiv(FMinHeight, MY, DY);
      FMinWidth := MulDiv(FMinWidth, MX, DX);
    end;
    //TFriendlySizeConstraints(Constraints).Change;
  end;

  procedure ScaleFormConstraints(Control: TControl; cdx, cdy: Integer);
    procedure ScaleValue(var Value: TConstraintSize; M, D, s, c: Integer);
    var
      tmp: Integer;
    begin
      if Value > 0 then
      begin
        tmp := MulDiv(Value - s, M, D) + c;
        if tmp < 0
          then Value := 0
          else Value := tmp;
      end;
    end;
  begin
    with THackSizeConstraints(Control.Constraints) do
    begin
      ScaleValue(FMaxWidth, MX, DX, cdx, cdx);
      ScaleValue(FMinWidth, MX, DX, cdx, cdx);
      ScaleValue(FMaxHeight, MY, DY, cdy, cdy);
      ScaleValue(FMinHeight, MY, DY, cdy, cdy);
    end;
    //TFriendlySizeConstraints(Constraints).Change;
  end;

  {$ifdef Controls.TMargins}
  procedure ScaleMargins(Control: TControl);
  begin
    with THackMargins(Control.Margins) do
    begin
      FLeft := MulDiv(FLeft, MX, DX);
      FTop := MulDiv(FTop, MY, DY);
      FRight := MulDiv(FRight, MX, DX);
      FBottom := MulDiv(FBottom, MY, DY);
    end;
    //TFriendlyMargins(Margins).Change;
  end;
  {$endif}

  procedure ScaleControls(Control: TWinControl);
  var
    i: Integer;
  begin
    with Control do
      for i := 0 to ControlCount - 1 do
        ScaleControl(Controls[i], MX, DX, MY, DY, MF, DF);
  end;

  procedure ChangeControlScale(Control: TControl);
  var
    L, T, W, H: Integer;
  begin
    with Control do
    begin
      // scale Left
      L := MulDiv(Left, MX, DX);
      // scale Top
      T := MulDiv(Top, MY, DY);
      // scale Width
      if not (csFixedWidth in ControlStyle) then
        W := MulDiv(Left + Width, MX, DX) - L
      else
        W := Width;
      // scale Hight
      if not (csFixedHeight in ControlStyle) then
        H := MulDiv(Top + Height, MY, DY) - T
      else
        H := Height;

      // scale Constraints
      ScaleConstraints(Control);

      {$ifdef Controls.TMargins}
      // scale Margins
      with THackMargins(Margins) do
      begin
        FLeft := MulDiv(FLeft, MX, DX);
        FTop := MulDiv(FTop, MY, DY);
        FRight := MulDiv(FRight, MX, DX);
        FBottom := MulDiv(FBottom, MY, DY);
      end;
      //TFriendlyMargins(Margins).Change;
      {$endif}
    end;

    {$ifdef bf_tb2k}
    // scale TTBToolWindow
    if Control is TTBToolWindow then
      with TTBToolWindow(Control) do
      begin
        MaxClientHeight := MulDiv(MaxClientHeight, MY, DY);
        MaxClientWidth := MulDiv(MaxClientWidth, MX, DX);
        MinClientHeight := MulDiv(MinClientHeight, MY, DY);
        MinClientWidth := MulDiv(MinClientWidth, MX, DX);
      end;
    {$endif}

    // Применение новых размеров с учётом констрейнтов
    Control.SetBounds(L, T, W, H);

    with THackControl(Control), TFriendlyControl(Control) do
    begin
      // scale OriginalParentSize
      FOriginalParentSize.X := MulDiv(FOriginalParentSize.X, MX, DX);
      FOriginalParentSize.Y := MulDiv(FOriginalParentSize.Y, MY, DY);

      // scale Font.Size
      if not ParentFont and (MF <> DF) then
        Font.Size := MulDiv(Font.Size, MF, DF);
    end;
  end;

  procedure ChangeWinControlScale(WinControl: TWinControl);
  begin
    ChangeControlScale(WinControl);

    // scale DesignSize
    with TFiendlyWinControl(WinControl) do
    begin
      FDesignSize.X := MulDiv(FDesignSize.X, MX, DX);
      FDesignSize.Y := MulDiv(FDesignSize.Y, MY, DY);
    end;

    {$ifdef Controls.TPadding}
    // scale Padding
    with THackPadding(WinControl.Padding) do
    begin
      FLeft := MulDiv(FLeft, MX, DX);
      FTop := MulDiv(FTop, MY, DY);
      FRight := MulDiv(FRight, MX, DX);
      FBottom := MulDiv(FBottom, MY, DY);
    end;
    TFriendlyPadding(WinControl.Padding).Change;
    {$endif}
  end;

  procedure ChangeScrollingWinControl(Control: TScrollingWinControl);
  begin
    ScaleScrollBars(Control);
    ChangeWinControlScale(Control);
  end;

  procedure ChangeFormScale(Form: TCustomForm);
  var
    W, H: Integer;
    cdx, cdy: Integer;
  begin
    cdx := Form.Width - Form.ClientWidth;
    cdy := Form.Height - Form.ClientHeight;

    with THackCustomForm(Form), THackControl(Form), TFriendlyControl(Form) do
    begin
      if (MF <> DF) then
        Form.Font.Height := MulDiv(Form.Font.Height, MF, DF);

      W := MulDiv(ClientWidth, MX, DX) + cdx;
      H := MulDiv(ClientHeight, MY, DY) + cdy;

      FDesignSize.X := MulDiv(FDesignSize.X, MX, DX);
      FDesignSize.Y := MulDiv(FDesignSize.Y, MY, DY);

      ScaleScrollBars(Form);

      // при масштабировании констрейнтов формы, надо учитывать
      // разницу между внешними размерами и размерами клиентской области
      ScaleFormConstraints(Form, cdx, cdy);

      if DX > MX then
        inc(W);
      if DY > MY then
        inc(H);
      SetBounds(FLeft, FTop, W, H);
    end;
  end;

var
  SavedAnchors: array of TAnchors;
  i: Integer;
begin
  if Control is TWinControl then
  with TWinControl(Control) do
  begin
    // DisableAnchors:
    SetLength(SavedAnchors, ControlCount);
    for i := 0 to ControlCount - 1 do
    begin
      SavedAnchors[i] := Controls[i].Anchors;
      Controls[i].Anchors := [akLeft, akTop];
    end;

    DisableAlign;
    try
      if Control is TCustomForm then
        ChangeFormScale(TCustomForm(Control))
      else if Control is TScrollingWinControl then
        ChangeScrollingWinControl(TScrollingWinControl(Control))
      else
        ChangeWinControlScale(TWinControl(Control));

      // ScaleControls
      ScaleControls(TWinControl(Control))
    finally
      EnableAlign;

      // EnableAnchors:
      for i := 0 to ControlCount - 1 do
        Controls[i].Anchors := SavedAnchors[i];
    end;
  end else
    ChangeControlScale(Control);
end;

procedure ScaleControl(Control: TControl; M, D: Integer);
begin
  ScaleControl(Control, M, D, M, D, M, D);
end;
{.$endregion}

{ TBaseDataModule }

{$ifdef Allow.Localization}
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
  {$ifdef Allow.Localization}
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

{$ifdef Allow.Localization}
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


{$ifdef Allow.ScaleFix}
// Проблема масштабирования VCL: если в dfm не сохраняются
// параметры ClientWidth и ClientHeight (а не сохраниться они могут при различных
// сочетаниях свойств AutoScroll, BorderStyle),
// то в методе TCustomForm.ReadState не происходит коррекция клиентской области
// окна, что приводит к следующему: все контролы масштабируются, а окно - нет.
// В обычных случаях это не страшно, но если на форме есть контролы с якорями
// по правому и/или нижнему краям, то они выезжают за край формы.
// Кроме того, VCL (в старых версиях) не масштабирует Constraints.

// Пока придумал такое решение: в dfm ВСЕГДА сохраняем ClientWidth и ClientHeight.

// В будущем можно будет также сохранять дополнительное свойство,
// которое не будет в себе нести никакой смысловой нагрузки, но зато
// позволит управлять шрифтом формы сразу после считывания его из ресурсов.
// Для этого надо раскомментить ReadScaleFix и связанные.


// TODO: ещё одна проблема: VCL не масштабирует фреймы, созданные в рантайме
//
//  можно попытаться сделать так: запретить VCL масштабировать, т.е. в dfm всегда
//  сохранять Scalled = False;
//  а на уровне BaseFrame и BaseForm уже масштабировать как надо.


//TODO: такая задумка: можно масштабировать, если в ini указан нестандаартный размер шрифта.
//          Только тут возникают проблемы: не масштабируются размеры строк в таблицах,
//          не масштабируются рисунки, и некоторые другие вещи.

{procedure TBaseForm.ReadScaleFix(Reader: TReader);
begin
  Reader.ReadInteger;

  if not (csDesigning in ComponentState) then
  begin
    if (Reader.Root <> nil) and (Reader.Root.ClassType = Self.ClassType) then
    begin
      // save readed PixelsPerInch from DFM
      FPPI := THackCustomForm(Self).FPixelsPerInch;

      // and reset it, for disable scale on VCL level
      THackCustomForm(Self).FPixelsPerInch := 0;
    end;
  end;
end;}

//function TBaseForm.GetTextHeight: Integer;
//begin
//  Result := Canvas.TextHeight('0');
//end;

procedure TBaseForm.WriteClientHeight(Writer: TWriter);
begin
  Writer.WriteInteger(ClientHeight);
end;

procedure TBaseForm.WriteClientWidth(Writer: TWriter);
begin
  Writer.WriteInteger(ClientWidth);
end;

procedure TBaseForm.WriteScaleFix(Writer: TWriter);
begin
  // just save flag to DFM for disable VCL scale on ReadState
  Writer.WriteBoolean(True);
end;

procedure TBaseForm.ReadScaleFix(Reader: TReader);
begin
  if not Reader.ReadBoolean then
    Exit;

  // save readed PixelsPerInch from DFM
  FPixelsPerInch := THackCustomForm(Self).FPixelsPerInch;
  // and set current value
  THackCustomForm(Self).FPixelsPerInch := Screen.PixelsPerInch;

  // and reset TextHeight, for disable scale on VCL level
  THackCustomForm(Self).FTextHeight := 0;
end;

procedure TBaseForm.DefineProperties(Filer: TFiler);
  function NeedWriteClientSize: Boolean;
  begin
    //Result := Scaled and not IsClientSizeStored
    // IsClientSizeStored = not IsFormSizeStored
    // IsFormSizeStored = AutoScroll or (HorzScrollBar.Range <> 0) or (VertScrollBar.Range <> 0)
    Result := Scaled and (AutoScroll or (HorzScrollBar.Range <> 0) or (VertScrollBar.Range <> 0));
  end;
begin
  inherited DefineProperties(Filer);

  // ClientHeight и ClientWidth сохраняются не всегда, а вместо этого сохраняются внешние размеры формы.
  // Это не совсем правильно, т.к. масштабировать необходимо именно клиентскую область. Функция NeedWriteClientSize
  // определяет, нужно ли принудительно сохранять размер клиентской области.
  Filer.DefineProperty('ClientHeight', nil, WriteClientHeight, NeedWriteClientSize);
  Filer.DefineProperty('ClientWidth', nil, WriteClientWidth, NeedWriteClientSize);
  Filer.DefineProperty('ScaleFix', ReadScaleFix, WriteScaleFix, Scaled);
end;

procedure TBaseForm.Loaded;
begin
  if (FPixelsPerInch > 0) and (FPixelsPerInch <> Screen.PixelsPerInch) then
  begin
    //HINT: VCL использует ScalingFlags, анализируя их в ReadState
    //      ReadState вызывается для каждого класса в иерархии, у которых есть DFM ресурс,
    //      поэтому ScalingFlags используются, чтобы не промасштабировать
    //      что-то несколько раз.
    //
    //      Сейчас масштабирование вынесено в Loaded, а FPixelsPerInch считывается только для Root-компонента,
    //      поэтому наше масштабирование вызываться будет один раз.

    //TODO: VCL масштабирует только в том случае, если меняется размер шрифта.
    //      Windows, похоже, масштабирует по такому же принципу, но не пропорционально,
    //      а используя золотое сечение: коэффициент масштабирования
    //      по X в 1.064 раза больше коэффициента масштабирования по Y
    // пока не стал заморачиваться на всё это, масштабируем тупо:
    ScaleControl(Self, Screen.PixelsPerInch, FPixelsPerInch);
  end;

  inherited Loaded;
end;
{ /fix_vcl_scale_bug }
{$endif}

procedure TBaseForm.InitializeNewForm;
begin
  {$ifdef TCustomForm.InitializeNewForm}
  inherited InitializeNewForm;
  {$endif}
  FCloseByEscape := True;
  ParentFont := True;
end;

{$ifndef TCustomForm.InitializeNewForm}
constructor TBaseForm.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin
  inherited CreateNew(AOwner, Dummy);
  InitializeNewForm;
end;
{$endif}

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

procedure TBaseForm.CMDialogKey(var Message: TCMDialogKey);
begin
  // handling CloseByEscape
  if CloseByEscape then
    with Message do
      if (CharCode = VK_ESCAPE) and (KeyDataToShiftState(KeyData) = []) then
      begin
        // for Modal state - talk Cancel
        if fsModal in FormState then
        begin
          ModalResult := mrCancel;
          Result := 1;
        end else
          // for normal - send command to close
          Result := Integer(PostMessage(Handle, WM_CLOSE, 0, 0));

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
  // If a window in a Modal state, minimize the application, instead of the window
  if (Message.CmdType = SC_MINIMIZE) and (fsModal in FormState) then
    Application.Minimize
  else
    inherited;
end;

procedure TBaseForm.WMActivate(var Message: TWMActivate);
begin
  if not (csDesigning in ComponentState) and (Message.Active > 0) and not IsWindowEnabled(Handle) then
    // Here: our window is disabled, but somehow is activated,
    // Most likely there is modal window, if any - then we must show them
    RestoreFormsPositions;
  inherited;
end;

{ TBaseFrame }

{$ifdef Allow.Localization}
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

{$ifdef Allow.ScaleFix}
procedure TBaseFrame.WritePixelsPerInch(Writer: TWriter);
begin
  Writer.WriteInteger(Screen.PixelsPerInch);
end;

procedure TBaseFrame.ReadPixelsPerInch(Reader: TReader);
begin
  FPixelsPerInch := Reader.ReadInteger;
end;

procedure TBaseFrame.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);

  // сохранять свойство PixelsPerInch нужно только при дизайне самой фреймы. Если фрейма встроена во что-то, то
  // тогда свойство сохранять не нужно
  Filer.DefineProperty('PixelsPerInch', ReadPixelsPerInch, WritePixelsPerInch, not Assigned(Filer.Ancestor));
end;

procedure TBaseFrame.Loaded;
begin
  // масштабируем только в том случае, если фрейма создаётся в Run-Time вручную (т.е. Parent = nil),
  // либо в дизайнере
  if (FPixelsPerInch > 0) and (FPixelsPerInch <> Screen.PixelsPerInch) and
    (not Assigned(Parent) or (csDesigning in ComponentState))
  then
    ScaleControl(Self, Screen.PixelsPerInch, FPixelsPerInch);

  inherited Loaded;
end;
{$endif}

//procedure TBaseFrame.DoDestroy;
//begin
//  inherited DoDestroy;
//end;

end.