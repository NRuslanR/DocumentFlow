unit StandardPersonnelOrderControlService;

interface

uses

  PersonnelOrderControlService,
  PersonnelOrderControlGroupFinder,
  DomainException,
  Employee,
  SysUtils;

type

  TStandardPersonnelOrderControlService =
    class (TInterfacedObject, IPersonnelOrderControlService)

      private

        FPersonnelOrderControlGroupFinder: IPersonnelOrderControlGroupFinder;

      public

        constructor Create(PersonnelOrderControlGroupFinder: IPersonnelOrderControlGroupFinder);

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

uses

  PersonnelOrderControlGroup,
  IDomainObjectBaseUnit;

{ TStandardPersonnelOrderControlService }

constructor TStandardPersonnelOrderControlService.Create(
  PersonnelOrderControlGroupFinder: IPersonnelOrderControlGroupFinder);
begin

  inherited Create;

  FPersonnelOrderControlGroupFinder := PersonnelOrderControlGroupFinder;

end;

function TStandardPersonnelOrderControlService.MayEmployeeControlPersonnelOrders(
  const PersonnelOrderSubKindId: Variant; const Employee: TEmployee
): Boolean;
begin

  Result := MayEmployeeControlPersonnelOrders(PersonnelOrderSubKindId, Employee.Identity);

end;

function TStandardPersonnelOrderControlService.MayEmployeeControlPersonnelOrders(
  const PersonnelOrderSubKindId, EmployeeId: Variant): Boolean;
begin

  try

    EnsureEmployeeMayControlPersonnelOrders(PersonnelOrderSubKindId, EmployeeId);

    Result := True;
    
  except

    on E: TDomainException do Result := False;

  end;

end;

procedure TStandardPersonnelOrderControlService.EnsureEmployeeMayControlPersonnelOrders(
  const PersonnelOrderSubKindId: Variant; const Employee: TEmployee);
begin

  EnsureEmployeeMayControlPersonnelOrders(PersonnelOrderSubKindId, Employee.Identity);
  
end;

procedure TStandardPersonnelOrderControlService.EnsureEmployeeMayControlPersonnelOrders(
  const PersonnelOrderSubKindId, EmployeeId: Variant);
begin

  if
    not
    FPersonnelOrderControlGroupFinder
      .IsPersonnelOrderEmployeeGroupIncludesEmployeeBySubKind(
        PersonnelOrderSubKindId, EmployeeId
      )
  then begin

    Raise TDomainException.Create(
      'Сотрудник не может выполнять контроль ' +
      'работ по кадровым приказам, поскольку ' +
      'не входит в соответствующую группу сотрудников'
    );
    
  end;

end;

end.
