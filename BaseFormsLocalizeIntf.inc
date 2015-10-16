  private
    FOnLocalize: TNotifyEvent;
  protected
    procedure DoLocalize; dynamic;
  public
    procedure Localize;
    class function ResGet(const StringID: string; const DefaultValue: string = ''): string;
  published
    property OnLocalize: TNotifyEvent read FOnLocalize write FOnLocalize;
