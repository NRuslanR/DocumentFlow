unit StandardPersonnelOrderCreatingAccessService;

interface

uses

  DomainException,
  PersonnelOrderCreatingAccessService,
  PersonnelOrderCreatingAccessEmployeeListFinder,
  Employee,
  VariantListUnit,
  SysUtils;

type

  TStandardPersonnelOrderCreatingAccessService =
    class (TInterfacedObject, IPersonnelOrderCreatingAccessService)

      private

        FCreatingAccessEmployeeFinder: IPersonnelOrderCreatingAccessEmployeeListFinder;

      public

        constructor Create(
          CreatingAccessEmployeeFinder: IPersonnelOrderCreatingAccessEmployeeListFinder
        );

        function MayEmployeeCreatePersonnelOrders(const EmployeeId: Variant): Boolean; overload; 
        function MayEmployeeCreatePersonnelOrders(const Employee: TEmployee): Boolean; overload;

        procedure EnsureEmployeeMayCreatePersonnelOrders(const EmployeeId: Variant); overload;
        procedure EnsureEmployeeMayCreatePersonnelOrders(const Employee: TEmployee); overload;

    end;

implementation

{ TStandardPersonnelOrderCreatingAccessService }

constructor TStandardPersonnelOrderCreatingAccessService.Create(
  CreatingAccessEmployeeFinder: IPersonnelOrderCreatingAccessEmployeeListFinder
);
begin

  inherited Create;

  FCreatingAccessEmployeeFinder := CreatingAccessEmployeeFinder;

end;

function TStandardPersonnelOrderCreatingAccessService.MayEmployeeCreatePersonnelOrders(
  const Employee: TEmployee): Boolean;
begin

  Result := MayEmployeeCreatePersonnelOrders(Employee.Identity);
  
end;

function TStandardPersonnelOrderCreatingAccessService.
  MayEmployeeCreatePersonnelOrders(const EmployeeId: Variant): Boolean;
begin

  try

    EnsureEmployeeMayCreatePersonnelOrders(EmployeeId);

    Result := True;

  except

    on E: TDomainException do Result := False;

  end;

end;

procedure TStandardPersonnelOrderCreatingAccessService.
  EnsureEmployeeMayCreatePersonnelOrders(const Employee: TEmployee);
begin

  EnsureEmployeeMayCreatePersonnelOrders(Employee.Identity);

end;

procedure TStandardPersonnelOrderCreatingAccessService.EnsureEmployeeMayCreatePersonnelOrders(
  const EmployeeId: Variant);

begin

  if
    not
    FCreatingAccessEmployeeFinder
      .IsPersonnelOrderEmployeeListIncludesEmployee(EmployeeId)
  then begin

    Raise TDomainException.Create(
      'У сотрудника отсутствуют права на ' +
      'создание кадровых приказов'
    );

  end;

end;

end.
