unit AbstractPersonnelOrderSignerListFinder;

interface

uses

  PersonnelOrderSignerList,
  AbstractPersonnelOrderSingleEmployeeListFinder,
  PersonnelOrderSignerListFinder,
  Employee,
  SysUtils;

type

  TAbstractPersonnelOrderSignerListFinder =
    class abstract (
      TAbstractPersonnelOrderSingleEmployeeListFinder,
      IPersonnelOrderSignerListFinder
    )

      public

        function FindPersonnelOrderSignerList: TPersonnelOrderSignerList;
        function FindDefaultPersonnelOrderSigner: TEmployee;

    end;

  
implementation

{ TAbstractPersonnelOrderSignerListFinder }

function TAbstractPersonnelOrderSignerListFinder.FindDefaultPersonnelOrderSigner: TEmployee;
var
    SignerList: TPersonnelOrderSignerList;
begin

  SignerList := FindPersonnelOrderSignerList;


end;

function TAbstractPersonnelOrderSignerListFinder.FindPersonnelOrderSignerList: TPersonnelOrderSignerList;
begin

  Result := TPersonnelOrderSignerList(FindPersonnelOrderSingleEmployeeList);
  
end;

end.
