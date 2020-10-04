unit uScaleControls;

interface

{$i jedi.inc}
{$i BaseForms.inc}
{$ifndef SUPPORTS_ENHANCED_RECORDS}
  {$define TIntScalerIsClass}
{$endif}

{$ifdef HAS_UNITSCOPE}
uses
  System.Types,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Forms;
{$else}
uses
  Types,
  Classes,
  Graphics,
  Controls,
  StdCtrls,
  ComCtrls,
  Forms;
{$endif}

type
  TNCSize = record
    Width: Integer;
    Height: Integer;
  end;

  {$ifdef TIntScalerIsClass}
  TIntScaler = class
  {$else}
  TIntScaler = record
  {$endif}
  private
    FNewPPI: Integer;
    FOldPPI: Integer;
  public
    procedure Init(const ANewPPI, AOldPPI: Integer); {$ifdef SUPPORTS_INLINE}inline;{$endif}
    function Scale(const AValue: Integer): Integer; {$ifdef SUPPORTS_INLINE}inline;{$endif}
    function ScaleRect(const ARect: TRect): TRect; {$ifdef SUPPORTS_INLINE}inline;{$endif}
    function Upscaling: Boolean; {$ifdef SUPPORTS_INLINE}inline;{$endif}
    function Downscaling: Boolean; {$ifdef SUPPORTS_INLINE}inline;{$endif}
    property NewPPI: Integer read FNewPPI;
    property OldPPI: Integer read FOldPPI;
  end;

  TScaleCallbackProc = procedure (AControl: TControl; const AScaler: TIntScaler; var AHandled: Boolean);
  TScaleCallbackMethod = procedure (AControl: TControl; const AScaler: TIntScaler; var AHandled: Boolean) of object;
  PCLItem = ^TCLItem;
  TCLItem = record
    Method: TMethod;
    Next: PCLItem;
  end;

  TScaleControls = class
  private
    class function CastProcAsMethod(AProc: TScaleCallbackProc): TScaleCallbackMethod; {$ifdef SUPPORTS_INLINE}inline;{$endif}
    class procedure ProcessCallbacks(AControl: TControl; const AScaler: TIntScaler);
  private
    class procedure ScaleControlFont(AControl: TControl; const AScaler: TIntScaler);
    class procedure ScaleControlConstraints(AControl: TControl; const AScaler: TIntScaler);
    {$ifdef Controls_TMargins}
    class procedure ScaleControlMargins(AControl: TControl; const AScaler: TIntScaler);
    {$endif}
    {$ifdef Controls_OriginalParentSize}
    class procedure ScaleControlOriginalParentSize(AControl: TControl; const AScaler: TIntScaler);
    {$endif}
    class procedure ScaleControl(AControl: TControl; const AScaler: TIntScaler);
    class procedure ScaleWinControlDesignSize(AWinControl: TWinControl; const AScaler: TIntScaler);
    {$ifdef Controls_TPadding}
    class procedure ScaleWinControlPadding(AWinControl: TWinControl; const AScaler: TIntScaler);
    {$endif}
    class procedure ScaleWinControl(AWinControl: TWinControl; const AScaler: TIntScaler);
    class procedure ScaleScrollBars(AControl: TScrollingWinControl; const AScaler: TIntScaler);
    class procedure ScaleScrollingWinControl(AControl: TScrollingWinControl; const AScaler: TIntScaler);
    class procedure ScaleConstraintWithDelta(var AValue: TConstraintSize; const AScaler: TIntScaler;
      AOldCD, ANewCD: Integer);
    class procedure ScaleCustomFormConstraints(AConstraints: TSizeConstraints; const AScaler: TIntScaler;
      const AOldNCSize, ANewNCSize: TNCSize);
    class procedure ScaleCustomForm(ACustomForm: TCustomForm; const AScaler: TIntScaler);
    class procedure ScaleWinControlEx(AWinControl: TWinControl; const AScaler: TIntScaler);
  public
    class procedure RegisterScaleCallback(AProc: TScaleCallbackProc); overload;
    class procedure RegisterScaleCallback(AMethod: TScaleCallbackMethod); overload;
    class procedure UnregisterScaleCallback(AProc: TScaleCallbackProc); overload;
    class procedure UnregisterScaleCallback(AMethod: TScaleCallbackMethod); overload;
    class procedure Scale(AControl: TControl; const AScaler: TIntScaler); overload;
    class procedure Scale(AControl: TControl; ANewPPI, AOldPPI: Integer); overload;
  end;

implementation

uses
{$ifdef HAS_UNITSCOPE}
  System.SysUtils,
  Winapi.Windows,
{$else}
  SysUtils,
  Windows,
{$endif}
  BaseForms;

{$i BaseFormsFrndHackTypes.inc}

type
  TFriendlyBaseForm = class(TBaseForm);

{ TIntScaler }

procedure TIntScaler.Init(const ANewPPI, AOldPPI: Integer);
begin
  FNewPPI := ANewPPI;
  FOldPPI := AOldPPI;
end;

function TIntScaler.Scale(const AValue: Integer): Integer;
begin
  //Result := MulDiv(AValue, NewPPI, OldPPI); // <-- так inline не работает
  Result := (AValue * NewPPI) div OldPPI;
end;

function TIntScaler.ScaleRect(const ARect: TRect): TRect;
begin
  Result.Left := Scale(ARect.Left);
  Result.Right := Scale(ARect.Right);
  Result.Top := Scale(ARect.Top);
  Result.Bottom := Scale(ARect.Bottom);
end;

function TIntScaler.Upscaling: Boolean;
begin
  Result := NewPPI > OldPPI;
end;

function TIntScaler.Downscaling: Boolean;
begin
  Result := NewPPI < OldPPI;
end;

{ TScaleControls }

var
  FCallbacksList: PCLItem;

procedure FreeCallbacksList;
var
  LCurItem, LNextItem: PCLItem;
begin
  LCurItem := FCallbacksList;
  FCallbacksList := nil;
  while Assigned(LCurItem) do
  begin
    LNextItem := LCurItem.Next;
    Dispose(LCurItem);
    LCurItem := LNextItem;
  end;
end;

class function TScaleControls.CastProcAsMethod(AProc: TScaleCallbackProc): TScaleCallbackMethod;
begin
  TMethod(Result).Code := nil;
  TMethod(Result).Data := @AProc;
end;

class procedure TScaleControls.RegisterScaleCallback(AProc: TScaleCallbackProc);
begin
  RegisterScaleCallback(CastProcAsMethod(AProc));
end;

class procedure TScaleControls.RegisterScaleCallback(AMethod: TScaleCallbackMethod);
var
  LItem: PCLItem;
begin
  New(LItem);
  LItem.Method := TMethod(AMethod);
  LItem.Next := FCallbacksList;
  FCallbacksList := LItem;
end;

class procedure TScaleControls.UnregisterScaleCallback(AProc: TScaleCallbackProc);
begin
  UnregisterScaleCallback(CastProcAsMethod(AProc));
end;

class procedure TScaleControls.UnregisterScaleCallback(AMethod: TScaleCallbackMethod);
var
  LPrevItem, LCurItem: PCLItem;
begin
  LPrevItem := nil;
  LCurItem := FCallbacksList;
  while Assigned(LCurItem) do
  begin
    //if LCurItem.Method = TMethod(AMethod) then
    if (LCurItem.Method.Code = TMethod(AMethod).Code) and (LCurItem.Method.Data = TMethod(AMethod).Data) then
    begin
      if not Assigned(LPrevItem) then
        // root item
        FCallbacksList := LCurItem.Next
      else
        // all others
        LPrevItem.Next := LCurItem.Next;
      Dispose(LCurItem);
      Exit;
    end;
    LPrevItem := LCurItem;
    LCurItem := LCurItem.Next;
  end;
end;

class procedure TScaleControls.ProcessCallbacks(AControl: TControl; const AScaler: TIntScaler);
var
  LHandled: Boolean;
  LItem: PCLItem;
begin
  LHandled := False;
  LItem := FCallbacksList;
  while Assigned(LItem) do
  begin
    if LItem.Method.Code = nil then
      TScaleCallbackProc(LItem.Method.Data)(AControl, AScaler, LHandled)
    else
      TScaleCallbackMethod(LItem.Method)(AControl, AScaler, LHandled);
    if LHandled then
      Exit;
    LItem := LItem.Next;
  end;
end;

class procedure TScaleControls.ScaleControlFont(AControl: TControl; const AScaler: TIntScaler);
begin
//EXIT;

  if TFriendlyControl(AControl).ParentFont then
    Exit;
  if (AControl is TCustomStatusBar) and TCustomStatusBar(AControl).UseSystemFont then
    Exit;

  with TFriendlyControl(AControl) do
    Font.Height := AScaler.Scale(Font.Height);
end;

class procedure TScaleControls.ScaleControlConstraints(AControl: TControl; const AScaler: TIntScaler);
begin
  with THackSizeConstraints(AControl.Constraints) do
  begin
    FMaxHeight := AScaler.Scale(FMaxHeight);
    FMaxWidth := AScaler.Scale(FMaxWidth);
    FMinHeight := AScaler.Scale(FMinHeight);
    FMinWidth := AScaler.Scale(FMinWidth);
  end;
  //TFriendlySizeConstraints(Control.Constraints).Change;
end;

{$ifdef Controls_TMargins}
class procedure TScaleControls.ScaleControlMargins(AControl: TControl; const AScaler: TIntScaler);
begin
  with THackMargins(AControl.Margins) do
  begin
    FLeft := AScaler.Scale(FLeft);
    FTop := AScaler.Scale(FTop);
    FRight := AScaler.Scale(FRight);
    FBottom := AScaler.Scale(FBottom);
  end;
  //TFriendlyMargins(Control.Margins).Change;
end;
{$endif}

{$ifdef Controls_OriginalParentSize}
class procedure TScaleControls.ScaleControlOriginalParentSize(AControl: TControl; const AScaler: TIntScaler);
begin
  with TFriendlyControl(AControl) do
  begin
    // scale OriginalParentSize - parent control size with it's padding bounds
    FOriginalParentSize.X := AScaler.Scale(FOriginalParentSize.X);
    FOriginalParentSize.Y := AScaler.Scale(FOriginalParentSize.Y);
  end;
end;
{$endif}

class procedure TScaleControls.ScaleControl(AControl: TControl; const AScaler: TIntScaler);
var
  LNewLeft, LNewTop, LNewWidth, LNewHeight: Integer;
begin
  LNewLeft := AScaler.Scale(AControl.Left);
  LNewTop := AScaler.Scale(AControl.Top);
  if not (csFixedWidth in AControl.ControlStyle) then
    LNewWidth := AScaler.Scale(AControl.Left + AControl.Width) - LNewLeft
  else
    LNewWidth := AControl.Width;
  if not (csFixedHeight in AControl.ControlStyle) then
    LNewHeight := AScaler.Scale(AControl.Top + AControl.Height) - LNewTop
  else
    LNewHeight := AControl.Height;

  ScaleControlConstraints(AControl, AScaler);

  {$ifdef Controls_TMargins}
  ScaleControlMargins(AControl, AScaler);
  {$endif}

  ProcessCallbacks(AControl, AScaler);

  // apply new bounds (with check constraints and margins)
  AControl.SetBounds(LNewLeft, LNewTop, LNewWidth, LNewHeight);

  {$ifdef Controls_OriginalParentSize}
  ScaleControlOriginalParentSize(AControl, AScaler);
  {$endif}

  ScaleControlFont(AControl, AScaler);
end;

class procedure TScaleControls.ScaleWinControlDesignSize(AWinControl: TWinControl; const AScaler: TIntScaler);
begin
  with TFriendlyWinControl(AWinControl) do
  begin
    FDesignSize.X := AScaler.Scale(FDesignSize.X);
    FDesignSize.Y := AScaler.Scale(FDesignSize.Y);
  end;
end;

{$ifdef Controls_TPadding}
class procedure TScaleControls.ScaleWinControlPadding(AWinControl: TWinControl; const AScaler: TIntScaler);
begin
  with THackPadding(AWinControl.Padding) do
  begin
    FLeft := AScaler.Scale(FLeft);
    FTop := AScaler.Scale(FTop);
    FRight := AScaler.Scale(FRight);
    FBottom := AScaler.Scale(FBottom);
  end;
  TFriendlyPadding(AWinControl.Padding).Change;
end;
{$endif}

class procedure TScaleControls.ScaleWinControl(AWinControl: TWinControl; const AScaler: TIntScaler);
begin
  ScaleControl(AWinControl, AScaler);
  ScaleWinControlDesignSize(AWinControl, AScaler);
  {$ifdef Controls_TPadding}
  ScaleWinControlPadding(AWinControl, AScaler);
  {$endif}
end;

class procedure TScaleControls.ScaleScrollBars(AControl: TScrollingWinControl; const AScaler: TIntScaler);
begin
  with TFriendlyScrollingWinControl(AControl) do
    if not AutoScroll then
    begin
      with HorzScrollBar do
      begin
        Position := 0;
        Range := AScaler.Scale(Range);
      end;
      with VertScrollBar do
      begin
        Position := 0;
        Range := AScaler.Scale(Range);
      end;
    end;
end;

class procedure TScaleControls.ScaleScrollingWinControl(AControl: TScrollingWinControl; const AScaler: TIntScaler);
begin
  ScaleScrollBars(AControl, AScaler);
  ScaleWinControl(AControl, AScaler);
end;

class procedure TScaleControls.ScaleConstraintWithDelta(var AValue: TConstraintSize; const AScaler: TIntScaler;
  AOldCD, ANewCD: Integer);
var
  LResult: Integer;
begin
  if AValue > 0 then
  begin
    LResult := AScaler.Scale(AValue - AOldCD) + ANewCD;
    if LResult < 0 then
      AValue := 0
    else
      AValue := LResult;
  end;
end;

class procedure TScaleControls.ScaleCustomFormConstraints(AConstraints: TSizeConstraints; const AScaler: TIntScaler;
  const AOldNCSize, ANewNCSize: TNCSize);
begin
  // при масштабировании констрейнтов формы, надо учитывать разницу
  // между внешними размерами и размерами клиентской области
  with THackSizeConstraints(AConstraints) do
  begin
    ScaleConstraintWithDelta(FMaxWidth, AScaler, AOldNCSize.Width, ANewNCSize.Width);
    ScaleConstraintWithDelta(FMinWidth, AScaler, AOldNCSize.Width, ANewNCSize.Width);
    ScaleConstraintWithDelta(FMaxHeight, AScaler, AOldNCSize.Height, ANewNCSize.Height);
    ScaleConstraintWithDelta(FMinHeight, AScaler, AOldNCSize.Height, ANewNCSize.Height);
  end;
  //TFriendlySizeConstraints(Constraints).Change;
end;

class procedure TScaleControls.ScaleCustomForm(ACustomForm: TCustomForm; const AScaler: TIntScaler);
var
  LOldNCSize, LNewNCSize: TNCSize;
  LNewWidth, LNewHeight: Integer;
begin
  LOldNCSize.Width := 0;
  LOldNCSize.Height := 0;
  LNewNCSize.Width := ACustomForm.Width - ACustomForm.ClientWidth;
  LNewNCSize.Height := ACustomForm.Height - ACustomForm.ClientHeight;
  if ACustomForm is TBaseForm then
  begin
    LOldNCSize.Width := TFriendlyBaseForm(ACustomForm).FNCWidth;
    LOldNCSize.Height := TFriendlyBaseForm(ACustomForm).FNCHeight;
  end;
  if LOldNCSize.Width = 0 then
    LOldNCSize.Width := LNewNCSize.Width;
  if LOldNCSize.Height = 0 then
    LOldNCSize.Height := LNewNCSize.Height;

  ScaleControlFont(ACustomForm, AScaler);

  LNewWidth := AScaler.Scale(ACustomForm.ClientWidth) + LNewNCSize.Width;
  LNewHeight := AScaler.Scale(ACustomForm.ClientHeight) + LNewNCSize.Height;


  ScaleWinControlDesignSize(ACustomForm, AScaler);

  ScaleScrollBars(ACustomForm, AScaler);

  ScaleCustomFormConstraints(ACustomForm.Constraints, AScaler, LOldNCSize, LNewNCSize);

  // При уменьшении размера иногда (пока не разбирался почему) новые размеры не применяются
  // Наращивание ширины и высоты на 1 пиксель помогает обойти такую проблему
  if AScaler.Downscaling then
  begin
    inc(LNewWidth);
    inc(LNewHeight);
  end;

  // apply new bounds (with check constraints and margins)
  with ACustomForm do
    SetBounds(Left, Top, LNewWidth, LNewHeight);
end;

class procedure TScaleControls.ScaleWinControlEx(AWinControl: TWinControl; const AScaler: TIntScaler);
var
  LSavedAnchors: array of TAnchors;
  i: Integer;
begin
  with AWinControl do
  begin
    // disable anchors of child controls:
    SetLength(LSavedAnchors, ControlCount);
    for i := 0 to ControlCount - 1 do
    begin
      LSavedAnchors[i] := Controls[i].Anchors;
      Controls[i].Anchors := [akLeft, akTop];
    end;

    DisableAlign;
    try
      // scale itself:
      if AWinControl is TCustomForm then
        ScaleCustomForm(TCustomForm(AWinControl), AScaler)
      else if AWinControl is TScrollingWinControl then
        ScaleScrollingWinControl(TScrollingWinControl(AWinControl), AScaler)
      else
        ScaleWinControl(AWinControl, AScaler);

      // scale child controls:
      for i := 0 to ControlCount - 1 do
        Scale(Controls[i], AScaler);
    finally
      EnableAlign;

      // enable anchors of child controls:
      for i := 0 to ControlCount - 1 do
        Controls[i].Anchors := LSavedAnchors[i];
    end;
  end;
end;

class procedure TScaleControls.Scale(AControl: TControl; const AScaler: TIntScaler);
begin
  if AControl is TWinControl then
    ScaleWinControlEx(TWinControl(AControl), AScaler)
  else
    ScaleControl(AControl, AScaler);
end;

class procedure TScaleControls.Scale(AControl: TControl; ANewPPI, AOldPPI: Integer);
var
  LScaler: TIntScaler;
begin
  {$ifdef TIntScalerIsClass}
  LScaler := TIntScaler.Create;
  try
  {$endif}
    LScaler.Init(ANewPPI, AOldPPI);
    Scale(AControl, LScaler);
  {$ifdef TIntScalerIsClass}
  finally
    LScaler.Free;
  end;
  {$endif}
end;

initialization

finalization
  FreeCallbacksList;

end.
