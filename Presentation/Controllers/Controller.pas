unit Controller;

interface

uses

  Forms,
  Classes,
  SysUtils;

type

  TController = class

    public

      function CreateForm(Owner: TComponent): TForm; virtual; abstract;

  end;
    
implementation

{ TFormController }


end.
