unit StandardPersonnelOrderSignerSetReadService;

interface

uses

  AbstractApplicationService,
  PersonnelOrderSignerSetReadService,
  EmployeeSetReadService,
  EmployeeSetHolder,
  PersonnelOrderSubKindEmployeeGroup,
  AbstractPersonnelOrderEmployeeSetReadService,
  PersonnelOrderSignerListFinder,
  SysUtils;

type

  TStandardPersonnelOrderSignerSetReadService =
    class (
      TAbstractPersonnelOrderEmployeeSetReadService,
      IPersonnelOrderSignerSetReadService
    )

      public

        constructor Create(                                
          PersonnelOrderSignerListFinder: IPersonnelOrderSignerListFinder;
          EmployeeSetReadService: IEmployeeSetReadService
        );

        function GetPersonnelOrderSignerSet: TEmployeeSetHolder;
        
    end;


implementation

{ TStandardPersonnelOrderSignerSetReadService }

constructor TStandardPersonnelOrderSignerSetReadService.Create(
  PersonnelOrderSignerListFinder: IPersonnelOrderSignerListFinder;
  EmployeeSetReadService: IEmployeeSetReadService
);
begin

  inherited Create(PersonnelOrderSignerListFinder, EmployeeSetReadService);
  
end;

function TStandardPersonnelOrderSignerSetReadService.GetPersonnelOrderSignerSet: TEmployeeSetHolder;
begin

  Result := GetPersonnelOrderEmployeeSet;
  
end;

end.
