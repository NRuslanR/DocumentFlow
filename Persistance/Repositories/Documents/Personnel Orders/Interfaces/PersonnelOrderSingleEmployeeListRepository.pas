unit PersonnelOrderSingleEmployeeListRepository;

interface

uses

  PersonnelOrderEmployeeListRepository,
  PersonnelOrderEmployeeList,
  SysUtils;

type

  IPersonnelOrderSingleEmployeeListRepository = interface

    function GetPersonnelOrderSingleEmployeeList: TPersonnelOrderEmployeeList;

    procedure UpdatePersonnelOrderSingleEmployeeList(
      EmployeeList: TPersonnelOrderEmployeeList
    );

  end;

implementation

end.
