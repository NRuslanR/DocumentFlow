unit AbstractPersonnelOrderSignerListFinder;

interface

uses

  PersonnelOrderSignerList,
  AbstractPersonnelOrderSingleEmployeeListFinder,
  PersonnelOrderSignerListFinder,
  SysUtils;

type

  TAbstractPersonnelOrderSignerListFinder =
    class abstract (
      TAbstractPersonnelOrderSingleEmployeeListFinder,
      IPersonnelOrderSignerListFinder
    )

      public

        function FindPersonnelOrderSignerList: TPersonnelOrderSignerList;
        
    end;

  
implementation

{ TAbstractPersonnelOrderSignerListFinder }

function TAbstractPersonnelOrderSignerListFinder.FindPersonnelOrderSignerList: TPersonnelOrderSignerList;
begin

  Result := TPersonnelOrderSignerList(FindPersonnelOrderSingleEmployeeList);
  
end;

end.
