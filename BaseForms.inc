{$i jedi.inc}

{$ifdef DELPHI2010_UP}
  {$define TCustomForm_InitializeNewForm}
  {$define Controls_TMargins}
  {$define Controls_TPadding}
{$endif}

{$define DataModule_AllowAutoFree}
{$define Form_AllowAutoFree}
{$define Frame_AllowAutoFree}


// Allow use .OnLocalize event and ResGet Method
{.$define Allow_Localization}

// ScaleFix - http://www.delphinotes.ru/2013/06/vcl-form-and-frame-scale-fix.html
{$define Allow_ScaleFix}

// define, if using tb2k components
{.$define bf_tb2k}

// define, if using Grids.pas
{.$define bf_Grids}
