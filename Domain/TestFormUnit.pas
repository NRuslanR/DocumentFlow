unit TestFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ZAbstractRODataset, ZAbstractDataset, ZDataset;

type
  TForm6 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
  
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

uses

  AuxDebugFunctionsUnit;

type

  TA = class

  end;

  TB = class (TA)

  end;

  TC = class (TB)

  end;
  
{$R *.dfm}

procedure TForm6.FormCreate(Sender: TObject);
begin

  DebugOutput(TC.InheritsFrom(TA));
  DebugOutput(TC.ClassParent.ClassName);

end;

end.
