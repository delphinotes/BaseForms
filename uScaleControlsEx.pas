unit uScaleControlsEx;

interface

implementation

{$define sf_colorpickerbutton}
{$define sf_dnSplitter}
// define, if using DBCtrlsEh
{.$define sf_EhLib}
// define, if using Vcl.Grids.pas
{.$define sf_Grids}
//{$define sf_StdCtrls}
// define, if using tb2k components
{$define sf_tb2k}
{$define sf_tbx}
{$define sf_VirtualTrees}

uses
  {$ifdef HAS_UNITSCOPE}
  System.Classes,
  Vcl.Controls,
  {$else}
  Classes,
  Controls,
  {$endif}
  {$ifdef sf_colorpickerbutton}ColorPickerButton,{$endif}
  {$ifdef sf_dnSplitter}dnSplitter,{$endif}
  {$ifdef sf_EhLib}DBCtrlsEh,{$endif}
  {$ifdef sf_Grids}{$ifdef HAS_UNITSCOPE}Vcl.Grids,{$else}Grids,{$endif}{$endif}
//  {$ifdef sf_StdCtrls}{$ifdef HAS_UNITSCOPE}Vcl.StdCtrls,{$else}StdCtrls,{$endif}{$endif}
  {$ifdef sf_tb2k}TB2Item, TB2Toolbar, TB2ToolWindow,{$endif}
  {$ifdef sf_tbx}TBXDkPanels, TBXStatusBars, TBXExtItems,{$endif}
  {$ifdef sf_VirtualTrees}VirtualTrees,{$endif}
  uScaleControls;

{$ifdef sf_colorpickerbutton}
procedure ScaleColorPickerButton(AControl: TControl; const AScaler: TIntScaler; var AHandled: Boolean);
begin
  if not (AControl is TColorPickerButton) then
    Exit;
  with TColorPickerButton(AControl) do
  begin
    DropDownWidth := AScaler.Scale(DropDownWidth);
    BoxSize := AScaler.Scale(BoxSize);
    //Margin := -1;
    PopupSpacing := AScaler.Scale(PopupSpacing);
    Spacing := AScaler.Scale(Spacing);
    Changed;
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

//{$ifdef sf_StdCtrls}
//procedure ScaleStdCtrls(AControl: TControl; const AScaler: TIntScaler; var AHandled: Boolean);
//begin
//  if AControl is TCustomComboBox then
//  begin
//    with TComboBox(AControl) do
//      ItemHeight := AScaler.Scale(ItemHeight);
//  end;
//end;
//{$endif}

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

{$ifdef sf_tbx}
procedure ScaleTBX(AControl: TControl; const AScaler: TIntScaler; var AHandled: Boolean);
var
  i: Integer;
  LSize: Integer;
  LPanel: TTBXStatusPanel;
  LToolBar: TTBCustomToolbar;
  LTBItem: TTBCustomItem;
begin
  if AControl is TTBXAlignmentPanel then
  begin
    with TTBXAlignmentPanel(AControl) do
    begin
      Margins.Left := AScaler.Scale(Margins.Left);
      Margins.Top := AScaler.Scale(Margins.Top);
      Margins.Right := AScaler.Scale(Margins.Right);
      Margins.Bottom := AScaler.Scale(Margins.Bottom);
    end
  end else if AControl is TTBXCustomStatusBar then
  begin
    with TTBXCustomStatusBar(AControl) do
      if Panels.Count > 0 then
      begin
        Panels.BeginUpdate;
        try
          for i := 0 to Panels.Count - 1 do
          begin
            LPanel := Panels[i];
            LSize := AScaler.Scale(LPanel.Size);
            LPanel.MaxSize := AScaler.Scale(LPanel.MaxSize);
            LPanel.Size := LSize;
          end;
        finally
          Panels.EndUpdate;
        end;
      end
  end else if AControl is TTBCustomToolbar then
  begin
    LToolBar := TTBCustomToolbar(AControl);
    for i := 0 to LToolBar.Items.Count - 1 do
    begin
      LTBItem := LToolBar.Items.Items[i];
      if LTBItem is TTBXComboBoxItem then
        with TTBXComboBoxItem(LTBItem) do
        begin
          EditWidth := AScaler.Scale(EditWidth);
          MinListWidth := AScaler.Scale(MinListWidth);
          MaxListWidth := AScaler.Scale(MaxListWidth);
        end;
    end;
  end;
end;
{$endif}

{$ifdef sf_VirtualTrees}
type
  TfrBVT = class(TBaseVirtualTree);

procedure ScaleVirtualTree(AControl: TControl; const AScaler: TIntScaler; var AHandled: Boolean);
var
  LTree: TBaseVirtualTree;
  LHeader: TVTHeader;
  LColumn: TVirtualTreeColumn;
  i: Integer;
begin
  if not (AControl is TBaseVirtualTree) then
    Exit;
  LTree := TBaseVirtualTree(AControl);
  LTree.BeginUpdate;
  try
    TfrBVT(LTree).BackgroundOffsetX := AScaler.Scale(TfrBVT(LTree).BackgroundOffsetX);
    TfrBVT(LTree).BackgroundOffsetY := AScaler.Scale(TfrBVT(LTree).BackgroundOffsetY);
    TfrBVT(LTree).DefaultNodeHeight := AScaler.Scale(TfrBVT(LTree).DefaultNodeHeight);
    // DragHeight
    // DragWidth
    TfrBVT(LTree).Indent := AScaler.Scale(TfrBVT(LTree).Indent);
    TfrBVT(LTree).Margin := AScaler.Scale(TfrBVT(LTree).Margin);
    // TextMargin не учитывается при отрисовки хинта, баг в VTV?
    //TfrBVT(LTree).TextMargin := AScaler.Scale(TfrBVT(LTree).TextMargin);

    LHeader := LTree.Header;
    LHeader.DefaultHeight := AScaler.Scale(LHeader.DefaultHeight);
    //LHeader.FixedAreaConstraints.
    LHeader.Height := AScaler.Scale(LHeader.Height);
    LHeader.MaxHeight := AScaler.Scale(LHeader.MaxHeight);
    LHeader.MinHeight := AScaler.Scale(LHeader.MinHeight);
    LHeader.SplitterHitTolerance := AScaler.Scale(LHeader.SplitterHitTolerance);
    if LHeader.Columns.Count > 0 then
    begin
      LHeader.Columns.BeginUpdate;
      try
        for i := 0 to LHeader.Columns.Count - 1 do
        begin
          LColumn := LTree.Header.Columns.Items[i];
          LColumn.Margin := AScaler.Scale(LColumn.Margin);
          LColumn.MaxWidth := AScaler.Scale(LColumn.MaxWidth);
          LColumn.MinWidth := AScaler.Scale(LColumn.MinWidth);
          LColumn.Spacing := AScaler.Scale(LColumn.Spacing);
          LColumn.Width := AScaler.Scale(LColumn.Width);
        end;
      finally
        LTree.Header.Columns.EndUpdate;
      end;
    end;
  finally
    LTree.EndUpdate;
  end;
end;
{$endif}

initialization
  {$ifdef sf_colorpickerbutton}
  TScaleControls.RegisterScaleCallback(ScaleColorPickerButton);
  {$endif}
  {$ifdef sf_dnSplitter}
  TScaleControls.RegisterScaleCallback(ScalednSplitter);
  {$endif}
  {$ifdef sf_EhLib}
  TScaleControls.RegisterScaleCallback(ScaleDBEditEh);
  {$endif}
  {$ifdef sf_Grids}
  TScaleControls.RegisterScaleCallback(ScaleCustomGrid);
  {$endif}
//  {$ifdef sf_StdCtrls}
//  TScaleControls.RegisterScaleCallback(ScaleStdCtrls);
//  {$endif}
  {$ifdef sf_tb2k}
  TScaleControls.RegisterScaleCallback(ScaleTBToolWindow);
  {$endif}
  {$ifdef sf_tbx}
  TScaleControls.RegisterScaleCallback(ScaleTBX);
  {$endif}
  {$ifdef sf_VirtualTrees}
  TScaleControls.RegisterScaleCallback(ScaleVirtualTree);
  {$endif}

end.
