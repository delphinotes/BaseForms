{$ifndef BaseForms_inc}
{$define BaseForms_inc}

  {$i jedi.inc}

  {$ifdef DELPHI2010_UP}
    {$define TCustomForm_InitializeNewForm}
    {$define Controls_TMargins}
    {$define Controls_TPadding}
    {$define Controls_OriginalParentSize}
  {$endif}

  {$define DataModule_AllowAutoFree}
  {$define Form_AllowAutoFree}
  {$define Frame_AllowAutoFree}

  // Allow use .OnLocalize event and ResGet Method
  {.$define Allow_Localization}

  // ScaleFix - http://www.delphinotes.ru/2013/06/vcl-form-and-frame-scale-fix.html
  {$define Allow_ScaleFix}

  {$define DoubleBufferedAlwaysOn}

{$endif ~BaseForms_inc}
