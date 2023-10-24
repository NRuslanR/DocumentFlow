unit PersonnelOrderControlService;

interface

uses

  Employee,
  DomainException,
  SysUtils;

type

  TPersonnelOrderControlServiceException = class (TDomainException)

  end;
  
  IPersonnelOrderControlService = interface

    function MayEmployeeControlPersonnelOrders(
      const PersonnelOrderSubKindId, EmployeeId: Variant
    ): Boolean; overload;
    
    function MayEmployeeControlPersonnelOrders(
      const PersonnelOrderSubKindId: Variant;
      const Employee: TEmployee
    ): Boolean; overload;

    procedure EnsureEmployeeMayControlPersonnelOrders(
      const PersonnelOrderSubKindId, EmployeeId: Variant
    ); overload;

    procedure EnsureEmployeeMayControlPersonnelOrders(
      const PersonnelOrderSubKindId: Variant;
      const Employee: TEmployee
    ); overload;

  end;
  
implementation

end.
