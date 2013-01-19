unit BaseForms;
(*
  BaseForms - ������� ����� � ������� ������

****************************************************************
  Author    : Zverev Nikolay (delphinotes.ru)
  Created   : 30.08.2006
  Modified  : 19.01.2013
  Version   : 1.00
  History   :
****************************************************************

  ����� �������������� ���������� ���������� �����:
    packages\BaseFormsDesignXXX.dpk

  ��� ��������� �����, ����� ���������� ��������������
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


