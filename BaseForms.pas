unit BaseForms;
(*
  BaseForms - базовая форма и базовая фрейма

****************************************************************
  Author    : Zverev Nikolay (delphinotes.ru)
  Created   : 30.08.2006
  Modified  : 19.01.2013
  Version   : 1.00
  History   :
****************************************************************

  Перед использованием необходимо установить пакет:
    packages\BaseFormsDesignXXX.dpk

  При изменении файла, пакет необходимо переустановить
*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms;

type
  TBaseForm = class;
  TBaseFormClass = class of TBaseForm;

  TBaseFrame = class;
  TBaseFrameClass = class of TBaseFrame;

  { TBaseForm }

  TBaseForm = class(TForm)
  end;

  { TBaseFrame }

  TBaseFrame = class(TFrame)
  end;

implementation

end.


