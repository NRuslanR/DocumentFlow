unit PersonnelOrderCreatingAccessService;

interface

uses

  DomainException,
  Employee,
  SysUtils;

type

  IPersonnelOrderCreatingAccessService = interface

    function MayEmployeeCreatePersonnelOrders(const EmployeeId: Variant): Boolean; overload;
    function MayEmployeeCreatePersonnelOrders(const Employee: TEmployee): Boolean; overload;

    procedure EnsureEmployeeMayCreatePersonnelOrders(const EmployeeId: Variant); overload;
    procedure EnsureEmployeeMayCreatePersonnelOrders(const Employee: TEmployee); overload;

  end;
  
implementation

end.
