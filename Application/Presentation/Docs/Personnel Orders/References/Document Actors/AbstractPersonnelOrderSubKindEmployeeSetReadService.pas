unit AbstractPersonnelOrderSubKindEmployeeSetReadService;

interface

uses

  AbstractApplicationService,
  PersonnelOrderSubKindEmployeeSetReadService,
  PersonnelOrderSubKindEmployeeGroupFinder,
  PersonnelOrderSubKindEmployeeListFinder,
  EmployeeSetReadService,
  EmployeeSetHolder,
  SysUtils;

type

  TAbstractPersonnelOrderSubKindEmployeeSetReadService =
    class (TAbstractApplicationService, IPersonnelOrderSubKindEmployeeSetReadService)

      private

        FPersonnelOrderSubKindEmployeeGroupFinder: IPersonnelOrderSubKindEmployeeGroupFinder;
        FPersonnelOrderSubKindEmployeeListFinder: IPersonnelOrderSubKindEmployeeListFinder;
        FEmployeeSetReadService: IEmployeeSetReadService;

      protected

        function GetEmployeeSetFromPersonnelOrderSubKindEmployeeGroup(
          const PersonnelOrderSubKindId: Variant
        ): TEmployeeSetHolder;

        function GetEmployeeSetFromPersonnelOrderSubKindEmployeeList(
          const PersonnelOrderSubKindId: Variant
        ): TEmployeeSetHolder;

      protected

        constructor Create(
          PersonnelOrderSubKindEmployeeGroupFinder: IPersonnelOrderSubKindEmployeeGroupFinder;
          EmployeeSetReadService: IEmployeeSetReadService
        ); overload;

        constructor Create(
          PersonnelOrderSubKindEmployeeListFinder: IPersonnelOrderSubKindEmployeeListFinder;
          EmployeeSetReadService: IEmployeeSetReadService
        ); overload;

      public
      
        function GetEmployeeSetForPersonnelOrderSubKind(
          const PersonnelOrderSubKindId: Variant
        ): TEmployeeSetHolder;
      
    end;

  
implementation

uses

  PersonnelOrderSubKindEmployeeList,
  PersonnelOrderSubKindEmployeeGroup,
  IDomainObjectBaseListUnit,
  IDomainObjectBaseUnit;

{ TAbstractPersonnelOrderSubKindEmployeeSetReadService }

constructor TAbstractPersonnelOrderSubKindEmployeeSetReadService.Create(
  PersonnelOrderSubKindEmployeeGroupFinder: IPersonnelOrderSubKindEmployeeGroupFinder;
  EmployeeSetReadService: IEmployeeSetReadService
);
begin

  inherited Create;

  FPersonnelOrderSubKindEmployeeGroupFinder := PersonnelOrderSubKindEmployeeGroupFinder;
  FEmployeeSetReadService := EmployeeSetReadService;
  
end;

constructor TAbstractPersonnelOrderSubKindEmployeeSetReadService.Create(
  PersonnelOrderSubKindEmployeeListFinder: IPersonnelOrderSubKindEmployeeListFinder;
  EmployeeSetReadService: IEmployeeSetReadService);
begin

  inherited Create;

  FPersonnelOrderSubKindEmployeeListFinder := PersonnelOrderSubKindEmployeeListFinder;
  FEmployeeSetReadService := EmployeeSetReadService;
  
end;

function TAbstractPersonnelOrderSubKindEmployeeSetReadService.GetEmployeeSetForPersonnelOrderSubKind(
  const PersonnelOrderSubKindId: Variant
): TEmployeeSetHolder;
begin

  if Assigned(FPersonnelOrderSubKindEmployeeGroupFinder) then begin

    Result :=
      GetEmployeeSetFromPersonnelOrderSubKindEmployeeGroup(
        PersonnelOrderSubKindId
      );

  end

  else begin

    Result :=
      GetEmployeeSetFromPersonnelOrderSubKindEmployeeList(
        PersonnelOrderSubKindId
      );

  end;

end;

function TAbstractPersonnelOrderSubKindEmployeeSetReadService.GetEmployeeSetFromPersonnelOrderSubKindEmployeeGroup(
  const PersonnelOrderSubKindId: Variant
): TEmployeeSetHolder;
var
    PersonnelOrderSubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup;
    Free: IDomainObjectBase;
begin

  PersonnelOrderSubKindEmployeeGroup :=
    FPersonnelOrderSubKindEmployeeGroupFinder
      .FindPersonnelOrderSubKindEmployeeGroupBySubKind(PersonnelOrderSubKindId);

  if not Assigned(PersonnelOrderSubKindEmployeeGroup) then begin

    Result := nil;

    Exit;

  end;

  Free := PersonnelOrderSubKindEmployeeGroup;

  Result :=
    FEmployeeSetReadService.GetEmployeeSetByIds(
      PersonnelOrderSubKindEmployeeGroup.EmployeeIds
    );
    
end;

function TAbstractPersonnelOrderSubKindEmployeeSetReadService.GetEmployeeSetFromPersonnelOrderSubKindEmployeeList(
  const PersonnelOrderSubKindId: Variant
): TEmployeeSetHolder;
var
    PersonnelOrderSubKindEmployeeList: TPersonnelOrderSubKindEmployeeList;
    Free: IDomainObjectBase;
begin

  PersonnelOrderSubKindEmployeeList :=
    FPersonnelOrderSubKindEmployeeListFinder
      .FindPersonnelOrderSubKindEmployeeList(PersonnelOrderSubKindId);

  if not Assigned(PersonnelOrderSubKindEmployeeList) then begin

    Result := nil;

    Exit;

  end;

  Free := PersonnelOrderSubKindEmployeeList;

  Result :=
    FEmployeeSetReadService.GetEmployeeSetByIds(
      PersonnelOrderSubKindEmployeeList.EmployeeIds
    );

end;

end.
