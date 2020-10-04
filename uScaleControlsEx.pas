unit uScaleControlsEx;

interface

implementation

// define, if using tb2k components
{.$define sf_tb2k}

// define, if using Vcl.Grids.pas
{.$define sf_Grids}

// define, if using DBCtrlsEh
{.$define sf_EhLib}

{$define sf_dnSplitter}

{$i jedi.inc}


uses
  {$ifdef HAS_UNITSCOPE}
  Vcl.Controls,
  {$else}
  Controls,
  {$endif}
  {$ifdef sf_Grids}
    {$ifdef HAS_UNITSCOPE}
    Vcl.Grids,
    {$else}
    Grids,
    {$endif}
  {$endif}
  {$ifdef sf_EhLib}DBCtrlsEh,{$endif}
  {$ifdef sf_tb2k}TB2ToolWindow,{$endif}
  {$ifdef sf_dnSplitter}dnSplitter,{$endif}
  uScaleControls;

{$ifdef sf_Grids}
type
  TFriendlyCustomGrid = class(TCustomGrid);

procedure ScaleCustomGrid(AControl: TControl; const AScaler: TIntScaler; var AHandled: Boolean);
var
  i: Integer;
begin
  if not (AControl is TCustomGrid) then
    Exit;
  with TFriendlyCustomGrid(AControl) do
  begin
    for i := 0 to ColCount - 1 do
      ColWidths[i] := AScaler.Scale(ColWidths[i]);
    DefaultColWidth := AScaler.Scale(DefaultColWidth);

    for i := 0 to RowCount - 1 do
      RowHeights[i] := AScaler.Scale(RowHeights[i]);
    DefaultRowHeight := AScaler.Scale(DefaultRowHeight);
  end;
end;
{$endif}

{$ifdef sf_tb2k}
procedure ScaleTBToolWindow(AControl: TControl; const AScaler: TIntScaler; var AHandled: Boolean);
begin
  if not (AControl is TTBToolWindow) then
    Exit;
  with TTBToolWindow(AControl) do
  begin
    MaxClientWidth := AScaler.Scale(MaxClientWidth);
    MinClientWidth := AScaler.Scale(MinClientWidth);
    MaxClientHeight := AScaler.Scale(MaxClientHeight);
    MinClientHeight := AScaler.Scale(MinClientHeight);
  end;
end;
{$endif}

{$ifdef sf_EhLib}
procedure ScaleDBEditEh(AControl: TControl; const AScaler: TIntScaler; var AHandled: Boolean);
begin
  if not (AControl is TCustomDBEditEh) then
    Exit;
  with TCustomDBEditEh(AControl).ControlLabelLocation do
  begin
    Offset := AScaler.Scale(Offset);
    Spacing := AScaler.Scale(Spacing);
  end;
end;
{$endif}

{$ifdef sf_dnSplitter}
procedure ScalednSplitter(AControl: TControl; const AScaler: TIntScaler; var AHandled: Boolean);
begin
  if not (AControl is TdnSplitter) then
    Exit;
  with TdnSplitter(AControl) do
  begin
    if ButtonWidthType = btwPixels then
      ButtonWidth := AScaler.Scale(ButtonWidth);
    MinSize := AScaler.Scale(MinSize);
    Size := AScaler.Scale(Size);
  end;
end;
{$endif}

initialization
  {$ifdef sf_Grids}
  TScaleControls.RegisterScaleCallback(ScaleCustomGrid);
  {$endif}
  {$ifdef sf_tb2k}
  TScaleControls.RegisterScaleCallback(ScaleTBToolWindow);
  {$endif}
  {$ifdef sf_EhLib}
  TScaleControls.RegisterScaleCallback(ScaleDBEditEh);
  {$endif}
  {$ifdef sf_dnSplitter}
  TScaleControls.RegisterScaleCallback(ScalednSplitter);
  {$endif}

end.
