unit AbstractPersonnelOrderCreatingAccessEmployeeListFinder;

interface

uses

  PersonnelOrderCreatingAccessEmployeeList,
  AbstractPersonnelOrderSingleEmployeeListFinder,
  PersonnelOrderCreatingAccessEmployeeListFinder,
  SysUtils;

type

  TAbstractPersonnelOrderCreatingAccessEmployeeListFinder =
    class abstract (
      TAbstractPersonnelOrderSingleEmployeeListFinder,
      IPersonnelOrderCreatingAccessEmployeeListFinder
    )

      public

        function FindPersonnelOrderCreatingAccessEmployeeList: TPersonnelOrderCreatingAccessEmployeeList;
        
    end;
  
implementation

{ TAbstractPersonnelOrderCreatingAccessEmployeeListFinder }

function TAbstractPersonnelOrderCreatingAccessEmployeeListFinder.
  FindPersonnelOrderCreatingAccessEmployeeList: TPersonnelOrderCreatingAccessEmployeeList;
begin

  Result := TPersonnelOrderCreatingAccessEmployeeList(FindPersonnelOrderSingleEmployeeList);
  
end;

end.
