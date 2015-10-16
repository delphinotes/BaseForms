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
  private
    {$ifdef Allow_ScaleFix}
    FPixelsPerInch: Integer;
    FNCHeight: Integer;
    FNCWidth: Integer;
    {$endif}
    FCloseByEscape: Boolean;
    FFreeOnClose: Boolean;

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
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure WMSetIcon(var Message: TWMSetIcon); message WM_SETICON;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
  protected
    FAutoFreeOnHide: TObjectList;
    FAutoFreeOnDestroy: TObjectList;

    procedure InitializeNewForm; {$ifdef TCustomForm_InitializeNewForm}override;{$else}dynamic;{$endif}
    procedure DefineProperties(Filer: TFiler); override;
    procedure DoClose(var Action: TCloseAction); override;
    procedure DoHide; override;
    procedure DoDestroy; override;
    procedure Loaded; override;
  public
    {$ifndef TCustomForm_InitializeNewForm}
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

{.$region 'ScaleControl'}
// ScaleControl - scales control, its font, constraints, margins, scrollbars and its childs (if any) - recursively
procedure ScaleControl(Control: TControl; MX, DX, MY, DY, MF, DF: Integer); overload;
procedure ScaleControl(Control: TControl; M, D: Integer); overload;
{.$endregion}

type
  TFormHelper = class helper for TCustomForm
    procedure SafeSetPosition(APosition: TPosition);
  end;

implementation

uses
  Dialogs,
  {$ifdef bf_tb2k}
  TB2ToolWindow,
  {$endif}
  {$ifdef bf_Grids}
  Grids,
  {$endif}
  StdCtrls;

{$i BaseFormsFrndHackTypes.inc}

{ TFormHelper }

procedure TFormHelper.SafeSetPosition(APosition: TPosition);
begin
  //FPosition := APosition;
  THackCustomForm(Self).FPosition := APosition;
end;

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
    SetForegroundWindow(Application.Handle);
    for I := Count - 1 downto 0 do
      if FormsArray[I].HandleAllocated then
        BringWindowToTop(FormsArray[I].Handle);
  finally
    IsRestoringPositions := False;
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

{.$region 'ScaleControl'}
procedure ScaleControl(Control: TControl; MX, DX, MY, DY, MF, DF: Integer);
  procedure ScaleControlConstraints(Control: TControl);
  begin
    with THackSizeConstraints(Control.Constraints) do
    begin
      FMaxHeight := MulDiv(FMaxHeight, MY, DY);
      FMaxWidth := MulDiv(FMaxWidth, MX, DX);
      FMinHeight := MulDiv(FMinHeight, MY, DY);
      FMinWidth := MulDiv(FMinWidth, MX, DX);
    end;
    //TFriendlySizeConstraints(Control.Constraints).Change;
  end;

  {$ifdef Controls_TMargins}
  procedure ScaleControlMargins(Control: TControl);
  begin
    with THackMargins(Control.Margins) do
    begin
      FLeft := MulDiv(FLeft, MX, DX);
      FTop := MulDiv(FTop, MY, DY);
      FRight := MulDiv(FRight, MX, DX);
      FBottom := MulDiv(FBottom, MY, DY);
    end;
    //TFriendlyMargins(Control.Margins).Change;
  end;
  {$endif}

  {$ifdef bf_Grids}
  procedure ScaleCustomGrid(CustomGrid: TCustomGrid);
  var
    i: Integer;
  begin
    with TFriendlyCustomGrid(CustomGrid) do
    begin
      for i := 0 to ColCount - 1 do
        ColWidths[i] := MulDiv(ColWidths[i], MX, DX);
      DefaultColWidth := MulDiv(DefaultColWidth, MX, DX);

      for i := 0 to RowCount - 1 do
        RowHeights[i] := MulDiv(RowHeights[i], MY, DY);
      DefaultRowHeight := MulDiv(DefaultRowHeight, MY, DY);
    end;
  end;
  {$endif}

  procedure ScaleControl(Control: TControl);
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
    end;

    ScaleControlConstraints(Control);

    {$ifdef Controls_TMargins}
    ScaleControlMargins(Control);
    {$endif}

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

    {$ifdef bf_Grids}
    if Control is TCustomGrid then
      ScaleCustomGrid(TCustomGrid(Control));
    {$endif}

    // apply new bounds (with check constraints and margins)
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

  procedure ScaleWinControlDesignSize(WinControl: TWinControl);
  begin
    with TFriendlyWinControl(WinControl) do
    begin
      FDesignSize.X := MulDiv(FDesignSize.X, MX, DX);
      FDesignSize.Y := MulDiv(FDesignSize.Y, MY, DY);
    end;
  end;

  {$ifdef Controls_TPadding}
  procedure ScaleWinControlPadding(WinControl: TWinControl);
  begin
    with THackPadding(WinControl.Padding) do
    begin
      FLeft := MulDiv(FLeft, MX, DX);
      FTop := MulDiv(FTop, MY, DY);
      FRight := MulDiv(FRight, MX, DX);
      FBottom := MulDiv(FBottom, MY, DY);
    end;
    TFriendlyPadding(WinControl.Padding).Change;
  end;
  {$endif}

  procedure ScaleWinControl(WinControl: TWinControl);
  begin
    ScaleControl(WinControl);

    ScaleWinControlDesignSize(WinControl);

    {$ifdef Controls_TPadding}
    ScaleWinControlPadding(WinControl);
    {$endif}
  end;

  procedure ScaleScrollBars(Control: TScrollingWinControl);
  begin
    with TFriendlyScrollingWinControl(Control) do
    begin
      if not AutoScroll then
      begin
        with HorzScrollBar do
        begin
          Position := 0;
          Range := MulDiv(Range, MX, DX);
        end;
        with VertScrollBar do
        begin
          Position := 0;
          Range := MulDiv(Range, MY, DY);
        end;
      end;
    end;
  end;

  procedure ScaleScrollingWinControl(ScrollingWinControl: TScrollingWinControl);
  begin
    ScaleScrollBars(ScrollingWinControl);
    ScaleWinControl(ScrollingWinControl);
  end;

  procedure ScaleCustomFormConstraints(CustomForm: TCustomForm; OldCdx, NewCdx, OldCdy, NewCdy: Integer);
    procedure ScaleValue(var Value: TConstraintSize; M, D, OldCD, NewCD: Integer);
    var
      tmp: Integer;
    begin
      if Value > 0 then
      begin
        tmp := MulDiv(Value - OldCD, M, D) + NewCD;
        if tmp < 0
          then Value := 0
          else Value := tmp;
      end;
    end;
  begin
    // при масштабировании констрейнтов формы, надо учитывать
    // разницу между внешними размерами и размерами клиентской области
    with THackSizeConstraints(CustomForm.Constraints) do
    begin
      ScaleValue(FMaxWidth, MX, DX, OldCdx, NewCdx);
      ScaleValue(FMinWidth, MX, DX, OldCdx, NewCdx);
      ScaleValue(FMaxHeight, MY, DY, OldCdy, NewCdy);
      ScaleValue(FMinHeight, MY, DY, OldCdy, NewCdy);
    end;
    //TFriendlySizeConstraints(Constraints).Change;
  end;

  procedure ScaleCustomForm(CustomForm: TCustomForm);
  var
    H, W: Integer;
    OldNCH, OldNCW: Integer;
    NewNCH, NewNCW: Integer;
  begin
    with CustomForm do
    begin
      OldNCH := 0;
      OldNCW := 0;
      NewNCH := Height - ClientHeight;
      NewNCW := Width - ClientWidth;
      if CustomForm is TBaseForm then
      begin
        OldNCH := TBaseForm(CustomForm).FNCHeight;
        OldNCW := TBaseForm(CustomForm).FNCWidth;
      end;
      if OldNCH = 0 then
        OldNCH := NewNCH;
      if OldNCW = 0 then
        OldNCW := NewNCW;

      if MF <> DF then
        Font.Height := MulDiv(Font.Height, MF, DF);

      H := MulDiv(ClientHeight, MY, DY) + NewNCH;
      W := MulDiv(ClientWidth, MX, DX) + NewNCW;
    end;

    ScaleWinControlDesignSize(CustomForm);

    ScaleScrollBars(CustomForm);

    ScaleCustomFormConstraints(CustomForm, OldNCW, NewNCW, OldNCH, NewNCH);

    // При уменьшении размера иногда (пока не разбирался почему) новые размеры не применяются
    // Наращивание ширины и высоты на 1 пиксель помогает обойти такую проблему
    if DX > MX then
      inc(W);
    if DY > MY then
      inc(H);

    // apply new bounds (with check constraints and margins)
    with CustomForm do
      SetBounds(Left, Top, W, H);
  end;

  procedure ScaleAndAlignWinControl(WinControl: TWinControl);
  var
    SavedAnchors: array of TAnchors;
    i: Integer;
  begin
    with WinControl do
    begin
      // disable anchors of child controls:
      SetLength(SavedAnchors, ControlCount);
      for i := 0 to ControlCount - 1 do
      begin
        SavedAnchors[i] := Controls[i].Anchors;
        Controls[i].Anchors := [akLeft, akTop];
      end;

      DisableAlign;
      try
        // scale itself:
        if WinControl is TCustomForm then
          ScaleCustomForm(TCustomForm(WinControl))
        else if WinControl is TScrollingWinControl then
          ScaleScrollingWinControl(TScrollingWinControl(WinControl))
        else
          ScaleWinControl(WinControl);

        // scale child controls:
        for i := 0 to ControlCount - 1 do
          BaseForms.ScaleControl(Controls[i], MX, DX, MY, DY, MF, DF);
      finally
        EnableAlign;

        // enable anchors of child controls:
        for i := 0 to ControlCount - 1 do
          Controls[i].Anchors := SavedAnchors[i];
      end;
    end;
  end;
begin
  if Control is TWinControl then
    ScaleAndAlignWinControl(TWinControl(Control))
  else
    ScaleControl(Control);
end;

//const
//  DesignerDefaultFontName = 'Tahoma';

procedure ScaleControl(Control: TControl; M, D: Integer);
//var
//  s: Integer;
begin
//  s := Application.DefaultFont.Size;
//  if Application.DefaultFont.Name = 'Segoe UI' then
//    ScaleControl(Control, M * 182 * s, D * 180 * 8, M * s, D * 8, M * s, D * 8)
//  else
//    ScaleControl(Control, M * s, D * 8, M * s, D * 8, M * s, D * 8);
  ScaleControl(Control, M, D, M, D, M, D);
end;
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
  ParentFont := True;
end;

{$ifndef TCustomForm_InitializeNewForm}
constructor TBaseForm.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin
  inherited CreateNew(AOwner, Dummy);
  InitializeNewForm;
end;
{$endif}

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
  function NeedScale: Boolean;
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
  begin
    Result := (FPixelsPerInch > 0) and (DPIChanged {or FontChanged} or NeedConstraintsResize);
  end;
  {$endif}
begin
  {$ifdef Allow_ScaleFix}
  //if (FPixelsPerInch > 0) and ((FPixelsPerInch <> Screen.PixelsPerInch) or (Application.DefaultFont.Name <> 'Tahoma')) then
  //if (FPixelsPerInch > 0) and (FPixelsPerInch <> Screen.PixelsPerInch) then
  if NeedScale then
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
    //ScaleControl(Self, Screen.PixelsPerInch * MulDiv(Canvas.TextWidth('M'), FPixelsPerInch, Screen.PixelsPerInch), FPixelsPerInch * 8,
    //  Screen.PixelsPerInch, FPixelsPerInch, Screen.PixelsPerInch, FPixelsPerInch);
  end;
  {$endif}

  inherited Loaded;
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
  function NeedScale: Boolean;
  begin
    Result := (FPixelsPerInch <> Screen.PixelsPerInch){ or (Application.DefaultFont.Name <> DesignerDefaultFontName)
      or (Application.DefaultFont.Size <> 8)};
  end;
  {$endif}
begin
  {$ifdef Allow_ScaleFix}
  // масштабируем только в том случае, если фрейма создаётся в Run-Time вручную (т.е. Parent = nil),
  // либо в дизайнере
  if (FPixelsPerInch > 0) and NeedScale and (not Assigned(Parent) or (csDesigning in ComponentState))
  then
    ScaleControl(Self, Screen.PixelsPerInch, FPixelsPerInch);
    //ScaleControl(Self, Trunc(Screen.PixelsPerInch * 1.064), Trunc(FPixelsPerInch),
    //  Screen.PixelsPerInch, FPixelsPerInch, Screen.PixelsPerInch, FPixelsPerInch);
  {$endif}

  inherited Loaded;
end;

//procedure TBaseFrame.DoDestroy;
//begin
//  inherited DoDestroy;
//end;

end.