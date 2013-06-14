{$HINTS OFF}
type
  TFriendlyReader = class(TReader);

  THackScreen = class(TComponent)
  // work with: Delphi 7, Delphi 2010
  {$ifdef DELPHIXE_UP}{$MESSAGE WARN 'sorry, not tested yet'}{$endif}
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

  TFriendlySizeConstraints = class(TSizeConstraints);

  THackSizeConstraints = class(TPersistent)
  // work with: Delphi 7, Delphi 2010
  {$ifdef DELPHIXE_UP}{$MESSAGE WARN 'sorry, not tested yet'}{$endif}
  private
    FControl: TControl;
    FMaxHeight: TConstraintSize;
    FMaxWidth: TConstraintSize;
    FMinHeight: TConstraintSize;
    FMinWidth: TConstraintSize;
  end;

  {$ifdef Controls.TMargins}
  TFriendlyMargins = class(TMargins);

  THackMargins = class(TPersistent)
  private
    FControl: TControl;
    FLeft, FTop, FRight, FBottom: TMarginSize;
  end;
  {$endif}

  {$ifdef Controls.TPadding}
  TFriendlyPadding = class(TPadding);

  THackPadding = THackMargins;
  {$endif}

  TFriendlyControl = class(TControl);

  THackControl = class(TComponent)
  private
  {$ifdef DELPHI2010_UP}
  // work with: Delphi 2010
    {$ifdef DELPHIXE_UP}{$MESSAGE WARN 'sorry, not tested yet'}{$endif}
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
  // work with: Delphi 7
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

  TFiendlyWinControl = class(TWinControl);

  THackScrollingWinControl = class(TWinControl)
  private
  {$ifdef DELPHI2010_UP}
    {$ifdef DELPHIXE_UP}{$MESSAGE WARN 'sorry, not tested yet'}{$endif}
    // work with: Delphi 2010
    FAutoRangeCount: Integer;
    FAutoScroll: Boolean;
    FHorzScrollBar: TControlScrollBar;
    FPanPoint: TPoint;
    FUpdatingScrollBars: Boolean;
    FVertScrollBar: TControlScrollBar;
  {$endif}
  {$ifdef DELPHI7}
    // work with: Delphi 7
    FHorzScrollBar: TControlScrollBar;
    FVertScrollBar: TControlScrollBar;
    FAutoScroll: Boolean;
  {$endif}
  end;

  THackCustomForm = class(TScrollingWinControl)
  private
  {$ifdef DELPHI2010_UP}
    {$ifdef DELPHIXE_UP}{$MESSAGE WARN 'sorry, not tested yet'}{$endif}
    // work with: Delphi 2010
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
    FMenu: TObject;//TMainMenu;
    FModalResult: TModalResult;
    FDesigner: IDesignerHook;
    FWindowMenu: TObject;//TMenuItem;
    FPixelsPerInch: Integer;
    FObjectMenuItem: TObject;//TMenuItem;
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
    FMenu: TObject;//TMainMenu;
    FModalResult: TModalResult;
    FDesigner: IDesignerHook;
    FClientHandle: HWND;
    FWindowMenu: TObject;//TMenuItem;
    FPixelsPerInch: Integer;
    FObjectMenuItem: TObject;//TMenuItem;
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
{$HINTS ON}

