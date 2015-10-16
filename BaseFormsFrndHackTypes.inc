{$HINTS OFF}
{$i jedi.inc}
type
  // Classes.pas
  TFriendlyReader = class(TReader);

  // Controls.pas
  TFriendlySizeConstraints = class(TSizeConstraints);

  THackSizeConstraints = class(TPersistent)
  // it tested with: Delphi 7, Delphi 2010, Delphi XE, Delphi XE2, Delphi XE7
  {$ifdef DELPHIXE8_UP}{$MESSAGE WARN 'sorry, not tested yet'}{$endif}
  private
    FControl: TControl;
    FMaxHeight: TConstraintSize;
    FMaxWidth: TConstraintSize;
    FMinHeight: TConstraintSize;
    FMinWidth: TConstraintSize;
  end;

  {$ifdef Controls_TMargins}
  TFriendlyMargins = class(TMargins);

  THackMargins = class(TPersistent)
  // it tested with: Delphi 7, Delphi 2010, Delphi XE, Delphi XE2, Delphi XE7
  {$ifdef DELPHIXE8_UP}{$MESSAGE WARN 'sorry, not tested yet'}{$endif}
  private
    FControl: TControl;
    FLeft, FTop, FRight, FBottom: TMarginSize;
  end;
  {$endif}

  {$ifdef Controls_TPadding}
  TFriendlyPadding = class(TPadding);

  THackPadding = THackMargins;
  {$endif}

  TFriendlyControl = class(TControl);

  THackControl = class(TComponent)
  private
  {$ifdef DELPHIXE2_UP}
  // it tested with: Delphi XE2, Delphi XE7
    {$ifdef DELPHIXE8_UP}{$MESSAGE WARN 'sorry, not tested yet'}{$endif}
    FParent: TWinControl;
    FWindowProc: TWndMethod;
    FLeft: Integer;
    FTop: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FControlStyle: TControlStyle;
    FControlState: TControlState;
    FDesktopFont: Boolean;
    FVisible: Boolean;
    FEnabled: Boolean;
    FParentFont: Boolean;
    FParentColor: Boolean;
    FAlign: TAlign;
    FAutoSize: Boolean;
    FDragMode: TDragMode;
    FIsControl: Boolean;
    FBiDiMode: TBiDiMode;
    FParentBiDiMode: Boolean;
    FAnchors: TAnchors;
    FFont: TFont;
    FActionLink: TControlActionLink;
    FColor: TColor;
    FConstraints: TSizeConstraints;
    FMargins: TMargins;
    FCursor: TCursor;
    FDragCursor: TCursor;
    FPopupMenu: TObject;//TPopupMenu;
    FHint: string;
    FFontHeight: Integer;
    FScalingFlags: TScalingFlags;
    FShowHint: Boolean;
    FParentShowHint: Boolean;
  {$endif}
  {$ifdef DELPHIXE}{$MESSAGE WARN 'sorry, not implemented'}{$endif}
  {$ifdef DELPHI2010}
  // it works with Delphi 2010
    FParent: TWinControl;
    FWindowProc: TWndMethod;
    FLeft: Integer;
    FTop: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FControlStyle: TControlStyle;
    FControlState: TControlState;
    FDesktopFont: Boolean;
    FVisible: Boolean;
    FEnabled: Boolean;
    FParentFont: Boolean;
    FParentColor: Boolean;
    FAlign: TAlign;
    FAutoSize: Boolean;
    FDragMode: TDragMode;
    FIsControl: Boolean;
    FBiDiMode: TBiDiMode;
    FParentBiDiMode: Boolean;
    FAnchors: TAnchors;
    FAnchorMove: Boolean;
    FText: PChar;
    FFont: TFont;
    FActionLink: TControlActionLink;
    FColor: TColor;
    FConstraints: TSizeConstraints;
    FMargins: TMargins;
    FCursor: TCursor;
    FDragCursor: TCursor;
    FPopupMenu: TObject;//TPopupMenu;
    FHint: string;
    FFontHeight: Integer;
    FScalingFlags: TScalingFlags;
    FShowHint: Boolean;
    FParentShowHint: Boolean;
  {$endif}
  {$ifdef DELPHI7}
  // it works with Delphi 7
    FParent: TWinControl;
    FWindowProc: TWndMethod;
    FLeft: Integer;
    FTop: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FControlStyle: TControlStyle;
    FControlState: TControlState;
    FDesktopFont: Boolean;
    FVisible: Boolean;
    FEnabled: Boolean;
    FParentFont: Boolean;
    FParentColor: Boolean;
    FAlign: TAlign;
    FAutoSize: Boolean;
    FDragMode: TDragMode;
    FIsControl: Boolean;
    FBiDiMode: TBiDiMode;
    FParentBiDiMode: Boolean;
    FAnchors: TAnchors;
    FAnchorMove: Boolean;
    FText: PChar;
    FFont: TFont;
    FActionLink: TControlActionLink;
    FColor: TColor;
    FConstraints: TSizeConstraints;
    FCursor: TCursor;
    FDragCursor: TCursor;
    FPopupMenu: TObject;//TPopupMenu;
    FHint: string;
    FFontHeight: Integer;
    FAnchorRules: TPoint;
    FOriginalParentSize: TPoint;
    FScalingFlags: TScalingFlags;
    FShowHint: Boolean;
    FParentShowHint: Boolean;
  {$endif}
  end;

  TFriendlyWinControl = class(TWinControl);

  // Forms.pas

(*
  THackScreen = class(TComponent)
  // it works with: Delphi 7, Delphi 2010, Delphi XE, Delphi XE2
  {$ifdef DELPHIXE3_UP}{$MESSAGE WARN 'sorry, not tested yet'}{$endif}
  private
    FFonts: TStrings;
    FImes: TStrings;
    FDefaultIme: string;
    FDefaultKbLayout: HKL;
    FPixelsPerInch: Integer;
    FCursor: TCursor;
    FCursorCount: Integer;
    FForms: TList;
    FCustomForms: TList;
  end;
*)

  TFriendlyScrollingWinControl = class(TScrollingWinControl);

(*
  THackScrollingWinControl = class(TWinControl)
  private
  {$ifdef DELPHI2010_UP}
    {$ifdef DELPHIXE3_UP}{$MESSAGE WARN 'sorry, not tested yet'}{$endif}
    // it works with: Delphi 2010, Delphi XE, Delphi XE2
    FAutoRangeCount: Integer;
    FAutoScroll: Boolean;
    FHorzScrollBar: TControlScrollBar;
    FPanPoint: TPoint;
    FUpdatingScrollBars: Boolean;
    FVertScrollBar: TControlScrollBar;
  {$endif}
  {$ifdef DELPHI7}
    // it works with Delphi 7
    FHorzScrollBar: TControlScrollBar;
    FVertScrollBar: TControlScrollBar;
    FAutoScroll: Boolean;
  {$endif}
  end;
*)

  THackCustomForm = class(TScrollingWinControl)
  private
  {$ifdef DELPHI2010_UP}
    {$ifdef DELPHIXE8_UP}{$MESSAGE WARN 'sorry, not tested yet'}{$endif}
    // tested with: Delphi 2010, Delphi XE, Delphi XE2, Delphi XE7
    {$ifdef DELPHIXE6_UP}
    FTaskbarHandler: TComponent;//TTaskbarHandler;
    {$endif}
    FActiveControl: TWinControl;
    FFocusedControl: TWinControl;
    FBorderIcons: TBorderIcons;
    FBorderStyle: TFormBorderStyle;
    FWindowState: TWindowState;
    FShowAction: TShowAction;
    FKeyPreview: Boolean;
    FActive: Boolean;
    FFormStyle: TFormStyle;
    FPosition: TPosition;
    FDefaultMonitor: TDefaultMonitor;
    FTileMode: TTileMode;
    FDropTarget: Boolean;
    FPrintScale: TPrintScale;
    FCanvas: TControlCanvas;
    FHelpFile: string;
    FIcon: TIcon;
    FInCMParentBiDiModeChanged: Boolean;
    FMenu: TComponent;//TMainMenu;
    FModalResult: TModalResult;
    FDesigner: IDesignerHook;
    FWindowMenu: TComponent;//TMenuItem;
    FPixelsPerInch: Integer;
    FObjectMenuItem: TComponent;//TMenuItem;
    FOleForm: IOleForm;
    FClientWidth: Integer;
    FClientHeight: Integer;
    FTextHeight: Integer;
    FDefClientProc: TFarProc;
    FActiveOleControl: TWinControl;
    FSavedBorderStyle: TFormBorderStyle;
  {$endif}
  {$ifdef DELPHI7}
    // work with: Delphi 7
    FActiveControl: TWinControl;
    FFocusedControl: TWinControl;
    FBorderIcons: TBorderIcons;
    FBorderStyle: TFormBorderStyle;
    FSizeChanging: Boolean;
    FWindowState: TWindowState;
    FShowAction: TShowAction;
    FKeyPreview: Boolean;
    FActive: Boolean;
    FFormStyle: TFormStyle;
    FPosition: TPosition;
    FDefaultMonitor: TDefaultMonitor;
    FTileMode: TTileMode;
    FDropTarget: Boolean;
    FOldCreateOrder: Boolean;
    FPrintScale: TPrintScale;
    FCanvas: TControlCanvas;
    FHelpFile: string;
    FIcon: TIcon;
    FInCMParentBiDiModeChanged: Boolean;
    FMenu: TComponent;//TMainMenu;
    FModalResult: TModalResult;
    FDesigner: IDesignerHook;
    FClientHandle: HWND;
    FWindowMenu: TComponent;//TMenuItem;
    FPixelsPerInch: Integer;
    FObjectMenuItem: TComponent;//TMenuItem;
    FOleForm: IOleForm;
    FClientWidth: Integer;
    FClientHeight: Integer;
    FTextHeight: Integer;
    FDefClientProc: TFarProc;
    FClientInstance: TFarProc;
    FActiveOleControl: TWinControl;
    FSavedBorderStyle: TFormBorderStyle;
  {$endif}
  end;

  TFriendlyCustomLabel = class(TCustomLabel);

  {$ifdef bf_Grids}
  // Grids.pas
  TFriendlyCustomGrid = class(TCustomGrid);
  {$endif}
{$HINTS ON}

