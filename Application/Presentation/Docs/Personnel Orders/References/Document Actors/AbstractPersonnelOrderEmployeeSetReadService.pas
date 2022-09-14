unit AbstractPersonnelOrderEmployeeSetReadService;

interface

uses

  AbstractApplicationService,
  EmployeeSetHolder,
  PersonnelOrderEmployeeSetReadService,
  EmployeeSetReadService,
  PersonnelOrderSingleEmployeeListFinder;

type

  TAbstractPersonnelOrderEmployeeSetReadService =
    class (TAbstractApplicationService, IPersonnelOrderEmployeeSetReadService)

      protected

        FPersonnelOrderSingleEmployeeListFinder: IPersonnelOrderSingleEmployeeListFinder;
        FEmployeeSetReadService: IEmployeeSetReadService;
        
      protected

        constructor Create(
          PersonnelOrderSingleEmployeeListFinder: IPersonnelOrderSingleEmployeeListFinder;
          EmployeeSetReadService: IEmployeeSetReadService
        );

      public

        function GetPersonnelOrderEmployeeSet: TEmployeeSetHolder;
      
    end;
  
implementation

uses

  PersonnelOrderEmployeeList,
  IDomainObjectBaseUnit;
  
{ TAbstractPersonnelOrderEmployeeSetReadService }

constructor TAbstractPersonnelOrderEmployeeSetReadService.Create(
  PersonnelOrderSingleEmployeeListFinder: IPersonnelOrderSingleEmployeeListFinder;
  EmployeeSetReadService: IEmployeeSetReadService
);
begin

  inherited Create;

  FPersonnelOrderSingleEmployeeListFinder := PersonnelOrderSingleEmployeeListFinder;
  FEmployeeSetReadService := EmployeeSetReadService;
  
end;

function TAbstractPersonnelOrderEmployeeSetReadService.GetPersonnelOrderEmployeeSet: TEmployeeSetHolder;
var
    EmployeeList: TPersonnelOrderEmployeeList;
    Free: IDomainObjectBase;
begin

  EmployeeList :=
    FPersonnelOrderSingleEmployeeListFinder.FindPersonnelOrderSingleEmployeeList;

  if not Assigned(EmployeeList) then begin
  
    Result := nil;
    Exit;
    
  end;

  Free := EmployeeList;

  Result := 
    FEmployeeSetReadService.GetEmployeeSetByIds(EmployeeList.EmployeeIds);
  
end;

end.
