unit PersonnelOrderCreatingAccessEmployeeList;

interface

uses

  PersonnelOrderEmployeeList,
  SysUtils;

type

  TPersonnelOrderCreatingAccessEmployeeList = class (TPersonnelOrderEmployeeList)

    protected

      procedure RaiseEmployeeAlreadyExistsException; override;
      
    public

      class function ListType: TPersonnelOrderEmployeeListsClass; override;

  end;

  TPersonnelOrderCreatingAccessEmployeeLists = class (TPersonnelOrderEmployeeLists)
  
  end;

implementation

{ TPersonnelOrderCreatingAccessEmployeeList }

class function TPersonnelOrderCreatingAccessEmployeeList.ListType: TPersonnelOrderEmployeeListsClass;
begin

  Result := TPersonnelOrderEmployeeLists;
  
end;

procedure TPersonnelOrderCreatingAccessEmployeeList.RaiseEmployeeAlreadyExistsException;
begin

  raise TPersonnelOrderEmployeeListException.Create(
    'Сотрудник уже включен в группу сотрудников, ' +
    'имеющих доступ к созданию кадровых приказов'
  );

end;

end.
